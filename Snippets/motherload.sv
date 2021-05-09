
//#1 LOGIC DATATYPES

//RTL
module jk_flop(j,k,clk,reset,q,qb);

input logic j,k,clk,reset;
output logic q,qb;
  
  parameter HOLD = 0,
  			SET = 2,
  			RESET = 1,
  			TOGGLE = 3;

always@(posedge clk) begin
    if(reset)
    q<=0;

    else
    begin
        case({j,k})

        HOLD: begin
            q<= q;
        end

        SET: begin
            q<= 1'b1;
        end

        RESET: begin
            q<= 1'b0;
        end

        TOGGLE: begin
            q<= ~q;
        end
        endcase
    end
end

assign qb = ~q;

endmodule

//TESTBENCH

module jk_flop_tb;
 logic clk,reset,j,k;
 logic q, qb;

 jk_flop DUT(j,k,clk,reset,q,qb);
  
  always begin
    #3 clk = 1'b1;
    #3 clk = ~clk;
  end
  

 initial begin
   
   @(negedge clk)
   reset = 1'b1;
   
      @(negedge clk)
   reset = 1'b0;
     
     for(int i=0;i<4;i++) begin
         {j,k} = i;
         #3;
 end
 #100 $finish;
 end

 initial begin
     $dumpfile("file.vcd");
     $dumpvars();
     #1;
     end

 initial 
 $monitor("For J=%b and K=%b, the output is q = %b and qb=%b",j,k,q,qb);

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//STRUCTURES
/*
module test;

  struct{bit[7:0]a,b,c;}value;

initial begin
    value.a = 10;
    value.b = 2;
    #3;
    value.c = struc.a + struc.b;

    $display(value.c);
end
endmodule
*/
//___________________________________________________________________________________________________________________________________________________________________\\
//STRUCTURES and TYPEDEF
module test;
  
  struct{int temp, fps, clk_freq;} GPU;
  
  typedef struct{int temp1, freq;} CPU;
  CPU intel, amd;
  
  initial begin
    GPU.temp = 50;
    GPU.fps = 89;
    GPU.clk_freq = 1710;
    
    
    $display("For NVIDIA RTX 2060 Super, GPU temperature = %0d, FPS count = %0d, GPU clock frequency = %0d MHz",GPU.temp, GPU.fps, GPU.clk_freq);
    
    intel.temp1 = 100;
    intel.freq = 4;
    amd.temp1 = 92;
    amd.freq = 5;
    
    $display("Between AMD and INTEL, CPU temperature for AMD and INTEL are %0d %0d\nCPU clock frequencies for AMD and INTEL are %0d %0d MHz",amd.temp1,intel.temp1,amd.freq,intel.freq);
  
  end 
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//ENUM DATATYPE
module test;

  enum{RED, GREEN =10, BLUE, YELLOW =1, WHITE, BLACK =7}colours;
 initial begin
     colours = colours.first;
   $display("_____________________________________________________________________________");

   $display("FIRST COLOUR is %s and the LAST COLOUR IS %s",colours.first.name,colours.last.name);
   
   $display("_____________________________________________________________________________");

   for(int i=0;i<6;i++) begin
    $display("For colour %s, the value assigned is %0d",colours.name, colours);
    if(colours == colours.last())
     break;
    colours = colours.next(3);
    colours = colours.prev(2);//NULLIFYING EFFECT

 end

 end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//STATIC CASTING AND DYNAMIC CASTING
module test;

 typedef enum{RED, GREEN =10, BLUE, YELLOW =1, WHITE, BLACK =7}colours;
colours shade;
  
int value;
  
  initial begin
    
    shade = colours'(10);
    value = shade;
    $display("Static casting done for %0d",shade);
    
    shade = BLUE;
    value = shade;
    $display(value);
    
    if(!$cast(shade,7))
      $display("Casting failed miserably");
    else begin
      $display("Casting is done!");
      $display("Dynamic casting done for %0d",shade);
    end
    
  end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//STRING OPERATIONS
module practice;

string str;
  
initial
begin

str = "EDAPLAYGROUND";
str = str.tolower(); 
$display("character in 5th position is %s", str.getc(5));

  $display("%s", str.substr(3, str.len-1)); 

str = {str, ".com"}; 
str = {{3{"w"}},".", str}; 
$display($sformatf("https://%s", str));

end
  
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\
//DYNAMIC ARRAYS

module test;

int a[],b[];
  int sum;
  

initial begin
  
  a = new[10];
  
  foreach(a[i])
  begin
  a[i]=i;
  $display(a[i]);
  end
  
  b = a;
  $display(b.min(),b.max());
  b.reverse();
  a = new[20](a);
  a.shuffle();
  $display(a);
  
  sum = a.sum with((item>4)*item);
  $display(sum);
  
  
  b.delete();
  $display(b);

end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//QUEUES

module test;

int q1[$] = {1,3,7,2,56,2,4,5,55,0};
int q2[$] = {1,3,5,7,9};
int q3[$];
  int q[];
  
int a,b;

initial begin
  q=new[5];
  q={2,8,2,55,67};
  

    $display(q1);
    $display(q2);

    a = q1.pop_front();
    b = q2.pop_back();
  	
  	$display("Values of a and b are %0d and %0d", a,b);
  	$display(q1);
  	
  q2.insert(0,a);
  q1.insert(0,b);
  $display(q1);
  
  q2.push_front(5);
  $display(q2);
  
  q3 = q.unique();
  $display(q3);
end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//FUNCTIONS

//SIMPLE FUNCTION

module test;
  
  int a =9,b=0;
  int result;
  
  function int mult(int a, b);
    if((a==0)||(b==0))begin
      $display("zero multiplication is not allowed");
    return 'hx;
    end
    else
      mult = a*b;
  endfunction
  
  
  initial begin
    
    result = mult(a,b);
    $display("Result is %0d",result);
    
  end endmodule

  //_________________________________________________________________________STATIC Vs. AUTOMATIC METHODS__________________________________________________________________________________________\\

//STATIC TASK (LOCAL MEMORY IS SHARED WITH EACH METHOD CALL)

module fun();
 int d,result;
int a=2, b=3;

  task mult(int a,input int b, output int c);
#5;
c= (a*b) +2;
a=a+1;
b=a;
  $display($time,"  %0d  >> %0d >>%0d",a,b,c);

endtask

initial

fork

begin
#1;
mult(a,b,d);
$display($time,"  %0d  >> %0d >>%0d",a,b,d);

end

begin
#2;
mult(a,b,d);
$display($time,"  %0d  >> %0d >>%0d",a,b,d);

end
join

endmodule

  //___________________________________________________________________________________________________________________________________________________________________\\

//AUTOMATIC TASK (LOCAL MEMORY IS CREATED FOR EACH METHOD CALL)

module fun();
 int d,result;
int a=2, b=3;

  task automatic mult(int a,input int b, output int c);
#5;
c= (a*b) +2;
a=a+1;
b=a;
  $display($time,"  %0d  >> %0d >>%0d",a,b,c);

endtask

initial

fork

begin
#1;
mult(a,b,d);
$display($time,"  %0d  >> %0d >>%0d",a,b,d);

end

begin
#2;
mult(a,b,d);
$display($time,"  %0d  >> %0d >>%0d",a,b,d);

end
join

endmodule

  //___________________________________________________________________________________________________________________________________________________________________\\

//FUNCTION AUTOMATIC

module fun();
 int d,result;
int a=2, b=3;

  function automatic mult(int a, int b, output int c);
c= (a*b) +2;
a=a+1;
  $display($time,"  %0d  >> %0d >>%0d",a,b,c);

endfunction

initial

fork

begin
#1;
mult(a,b,d);
$display($time,"  %0d  >> %0d >>%0d",a,b,d);

end

begin
#2;
mult(a,b,d);
$display($time,"  %0d  >> %0d >>%0d",a,b,d);

end
join

endmodule

  //___________________________________________________________________________________________________________________________________________________________________\\
//FIFO INTERFACE
`define DATA_WIDTH 8

interface router_fifo(input bit clock)

logic restn;
logic soft_reset;
logic write_enb;
logic read_enb;
logic lfd_state;
logic [(DATA_WIDTH-1):0]data_in;
logic [(DATA_WIDTH-1):0]data_out;
logic full;
logic empty;


//clocking blocks

clocking write_driver_cb@(posedge clock);
default input #1 output #1;
output write_enb;
output data_in;
output resetn;
output soft_reset;
input full;
input empty;

endclocking

clocking read_driver_cb@(posedge clock);
default input #1 output #1;
output read_enb;

endclocking

clocking write_monitor_cb@(posedge clock);
default input #1 output #1;

input write_enb;
input data_in;
input resetn;
input soft_reset;

input full;
input empty;

endclocking

clocking read_monitor_cb@(posedge clock);
default input #1 output #1;

input read_enb;
input data_out;

endclocking


modport WDR_MP(clocking write_driver_cb);
modport RDR_MP(clocking read_driver_cb);
modport WMON_MP(clocking write_monitor_cb);
modport RMON_MP(clocking read_monitor_cb);

endinterface

  //___________________________________________________________________________________________________________________________________________________________________\\

//SYNCHRONIZER INTERFACE

interface router_sync(input bit clock);

logic resetn;
logic detect_add;
logic full_0,full_1,full_2;
logic empty_0, empty_1, empty_2;
logic writ_enb_reg;

logic read_enb_0, read_enb_1, read_enb_2;
logic [1:0]data_in;

logic [2:0]write_enb;
logic fifo_full;
logic vld_out_0, vld_out_1, vld_out_2;
logic soft_reset_0, soft_reset_1, soft_reset_2;


clocking driver_cb@(posedge clock);
output detect_add;
output resetn;
output empty_0;
output empty_1;
output empty_2;
output full_0;
output full_1;
output full_2;
output read_enb_0;
output read_enb_1;
output read_enb_2;

input vld_out_0;
input vld_out_1;
input vld_out_2;

endclocking

clocking monitor_cb@(posedge clock);

input detect_add;
input resetn;
input empty_0;
input empty_1;
input empty_2;
input full_0;
input full_1;
input full_2;
input read_enb_0;
input read_enb_1;
input read_enb_2;

input vld_out_0;
input vld_out_1;
input vld_out_2;

input soft_reset_0;
input soft_reset_1;
input soft_reset_2;
input fifo_full;

endclocking

modport DRV_MP(clocking driver_cb);
modport MON_MP(clocking monitor_cb);

endinterface


  //___________________________________________________________________________________________________________________________________________________________________\\

interface router_fsm(input bit clock)

logic resetn;
logic pkt_valid;
logic [1:0]data_in;
logic fifo_full;
logic fifo_empty_0;
logic fifo_empty_1;
logic fifo_empty_2;

logic soft_reset_0;
logic soft_reset_1;
logic soft_reset_2;
logic parity_done;
logic low_pkt_valid;

logic write_enb_reg;
logic detect_add;
logic ld_state;
logic laf_state;
logic lfd_state;
logic full_state;
logic rst_int_reg;
logic busy;

clocking driver_cb@(posedge clock);
default input #1 output #1;

output resetn;
output pkt_valid;
output [1:0]data_in;
output fifo_full;
output fifo_empty_0;
output fifo_empty_1;
output fifo_empty_2;

output soft_reset_0;
output soft_reset_1;
output soft_reset_2;
output parity_done;
output low_pkt_valid;
input busy;

endclocking

clocking monitor_cb@(posedge clock);
default input #1 output #1;

input resetn;
input pkt_valid;
input [1:0]data_in;
input fifo_full;
input fifo_empty_0;
input fifo_empty_1;
input fifo_empty_2;

input soft_reset_0;
input soft_reset_1;
input soft_reset_2;
input parity_done;
input low_pkt_valid;

input write_enb_reg;
input detect_add;
input ld_state;
input laf_state;
input lfd_state;
input full_state;
input  rst_int_reg;

endclocking

modport DRV_MP(clocking driver_cb);
modport MON_MP(clocking monitor_cb);

endinterface

  //___________________________________________________________________________________________________________________________________________________________________\\
`define DATA_WIDTH 8

interface router_register(input bit clock);
default input #1 output #1;

logic resetn;
logic pkt_valid;
logic [(DATA_WIDTH-1):0]data_in;
logic fifo_full;
logic detect_add;
logic ld_state;
logic laf_state;
logic full_state;
logic lfd_state;
logic rst_int_reg;

logic err;
logic parity_done;
logic low_pkt_valid;
logic [(DATA_WIDTH-1):0]dout;


clocking driver_cb@(posedge clock);

output resetn;
output pkt_valid;
output [(DATA_WIDTH-1):0]data_in;
output fifo_full;
output detect_add;
output ld_state;
output laf_state;
output full_state;
output lfd_state;
output rst_int_reg;

endclocking

clocking monitor_cb@(posedge clock);

input resetn;
input pkt_valid;
input [(DATA_WIDTH-1):0]data_in;
input fifo_full;
input detect_add;
input ld_state;
input laf_state;
input full_state;
input lfd_state;
input rst_int_reg;

input err;
input parity_done;
input low_pkt_valid;
input [(DATA_WIDTH-1):0]dout;

endclocking

modport DRV_MP(clocking driver_cb);
modport MON_MP(clocking monitor_cb);

endinterface

  //___________________________________________________________________________________________________________________________________________________________________\\

//BASIC OOP

module test;

class account_c;
int balance;

function int summary;

return balance;
endfunction

task update(input int pay);
balance = balance + pay;

endtask

endclass

account_c ac;

initial begin
  ac = new();

  ac.update(20000);
  
  $display("BALANCE IS %0d",ac.summary);
  #3;
  $display("UPDATED BALANCE IS %0d",ac.balance);
end

endmodule

  //___________________________________________________________________________________________________________________________________________________________________\\

//SHALLOW COPY

module test;

class bank_account;

int acc_balance;

function int summary;

return acc_balance;
endfunction

task update(input int pay);
acc_balance = acc_balance + pay;

endtask

endclass

bank_account suyash;
bank_account varsha;
bank_account sudhir;

initial begin
//  suyash = new();
  varsha = new();
  sudhir = new();

  varsha.update(2000);
  sudhir.update(1500);
  
  suyash = new varsha; //SHALLOW COPY
  suyash.update(100);
  
  $display("SUYASH'S BALANCE IS %0d",suyash.acc_balance);
  $display("SUDHIR'S BALANCE IS %0d",sudhir.acc_balance);
  $display("VARSHA'S BALANCE IS %0d",varsha.acc_balance);
  
end

endmodule

/*OUTPUT:
# KERNEL: ASDB file was created in location /home/runner/dataset.asdb
# KERNEL: SUYASH'S BALANCE IS 2100
# KERNEL: SUDHIR'S BALANCE IS 1500
# KERNEL: VARSHA'S BALANCE IS 2000
# KERNEL: Simulation has finished. There are no more test vectors to simulate.
# VSIM: Simulation has finished
*/

//___________________________________________________________________________________________________________________________________________________________________\\

//DEEP COPY


  
  
class play_area;
int no_games;
bit availability;

function play_area copy();

copy = new();
copy.no_games = this.no_games;
copy.availability = this.availability;

endfunction
endclass

class building;

int building_no;
play_area p_h = new();

function building copy();
copy = new();
copy.building_no = this. building_no;
copy.p_h = this.p_h.copy;
endfunction
endclass

module test;


building b_a, b_b;

initial begin
  
  b_a = new();
  b_a.building_no = 2;

  b_a.p_h.no_games = 10;
  b_a.p_h.availability = 1;
$display("BUILDING A %p", b_a);
$display("BUILDING B %p", b_b);
 $display("_____________________________________________");

  b_b = b_a.copy; //DEEP COPY
$display("BUILDING A %p", b_a);
$display("BUILDING B %p", b_b);
$display("_____________________________________________");

b_b.building_no = 3;
b_b.p_h.availability = 0;
$display("BUILDING A %p", b_a);
  $display("BUILDING B %p", b_b);
end

endmodule


/*OUTPUT:
# KERNEL: ASDB file was created in location /home/runner/dataset.asdb
# KERNEL: BUILDING A '{building_no:2, p_h:'{no_games:10, availability:1}}
# KERNEL: BUILDING B null
# KERNEL: _____________________________________________
# KERNEL: BUILDING A '{building_no:2, p_h:'{no_games:10, availability:1}}
# KERNEL: BUILDING B '{building_no:2, p_h:'{no_games:10, availability:1}}
# KERNEL: _____________________________________________
# KERNEL: BUILDING B '{building_no:3, p_h:'{no_games:10, availability:0}}
# KERNEL: Simulation has finished. There are no more test vectors to simulate.
# VSIM: Simulation has finished.

*/

  //___________________________________________________________________________________________________________________________________________________________________\\
//ADVANCED OOP
//PARAMETERIZED CLASSES

module test;
  
  class packet#(parameter int ADDR_WIDTH=10, DATA_WIDTH=10);
    bit[(ADDR_WIDTH-1):0]address =10;
    bit[(DATA_WIDTH-1):0]data=20;
  
endclass
  
  packet pkt;
  packet#(4,5)pkt1 = new();
  
initial begin
pkt = new();
  
  $display("ADDRESS WIDTH %b",pkt.address);
  $display("DATA WIDTH %b",pkt.data);
  
  $display("_____________________________________________");
  $display("ADDRESS WIDTH %b",pkt1.address);
  $display("DATA WIDTH %b",pkt1.data);
  
end
endmodule

  //___________________________________________________________________________________________________________________________________________________________________\\
//INHERITANCE

module test;
  
  class transaction;
    int crc;
    int good_pkt;
  endclass
  
  class bad_trans extends transaction;
    int bad_crc;
  endclass
  
  transaction t_h;
  bad_trans b_h;
  
  initial begin
    t_h = new();
    b_h = new();
   
    $display("TRANSACTION CLASS %p",t_h);
    $display("BA_TRANS %p",b_h);
    
    $display("_____________________________________________");

    b_h.bad_crc = 10;
    
    $display("BA_TRANS %p",b_h);
    $display("_____________________________________________");

    b_h.crc = 10;
	$display("TRANSACTION CLASS %p",t_h);
    $display("BA_TRANS %p",b_h);

    $display("_____________________________________________");

    t_h.good_pkt = 20;
	$display("TRANSACTION CLASS %p",t_h);
    $display("BA_TRANS %p",b_h);
    
  end
  
  endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//STATIC PROPERTIES (can be accessed without creating an object for the class)

module test;
  
  class main;
    static int number=0;
    
  endclass
  
  initial begin
    main m_h;
    
    m_h.number = 10;
    $display(m_h.number);
  end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//SV_PDF____OOP concept problem statements

//1

module fun();

class base;
int i;   //DYNAMIC PROPERTY

function static get(); //ALL THE PROPERTIES DECLARED IN FUNCTION STATIC ARE STATIC IN NATURE 
int a;  //  PROPERTY
a++;
 $display(a);
endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();


end

endmodule
//___________________________________________________________________________________________________________________________________________________________________\\


//2

module fun();

class base;
static int i;   //DYNAMIC PROPERTY

function static get(); //ALL THE PROPERTIES DECLARED IN FUNCTION STATIC ARE STATIC IN NATURE 
int a;  //  PROPERTY
a++;
i++;
 $display(a);
 $display(i);
endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();


end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//3

module fun();

class base;
 int i;   //DYNAMIC PROPERTY

function static get(); //ALL THE PROPERTIES DECLARED IN FUNCTION STATIC ARE STATIC IN NATURE 
int a;  //  PROPERTY
a++;
i++;
 $display(a);
 $display(i);
endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();


end

endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//4

module fun();

class base;
 static int i;   

static function get(); 
int a;  
a++;
i++;
 $display(a);
 $display(i);
endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();


end

endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//5

module fun();

class base;
 int i;   

static function get(); 
int a;  
a++;
i++;
 $display(a);
 $display(i);
endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();


end

endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//6

module fun();
class base;
 int i;   
static function get(); 
int a;  
a++;
 $display(a);
endfunction
endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();
end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//7

module fun();
class base;
 int i;   
static function get(); 
static int a;  
a++;
 $display(a);
endfunction
endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();
end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//8

module fun();

class base;
 int i;   

static function static get(); 
int a;  
a++;
$display(a);

endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();
end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//9
module fun();

class base;
 static int i;   

static function static get(); 
int a;  
a++;
i++;
$display(a);
$display(i);
endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();
end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//10

module fun();

class base;
int i;   

static function static get(); 
int a;  
a++;
i++;
$display(a);
$display(i);
endfunction

endclass

initial begin
  base b1,b2;
  b1 = new();
  b2 = new();

  b1.get();
  b1.get();
  b2.get();
end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//INHERITANCE

module test;

class A;

int i;


function new();
i =13;
endfunction 
endclass



class B extends A;

int i;
function new(int i);
super.new();

this.i=i;
$display("%0d",i);
endfunction

endclass

initial
begin

B b_h;

b_h=new(10);

$display("%p", b_h);

end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//INHERITANCE


module test;

class A;

int i;


function new(int i =10);
this.i =i;
endfunction 
endclass



class B extends A;

int i;
function new();

i=20;
endfunction

endclass

initial
begin

B b_h;

b_h=new();

$display("%p", b_h);

end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//INHERITANCE

module test;

class A;

int i;


function new();
i =10;
endfunction 
endclass



class B extends A;

int i;
function new();

i=20;
endfunction

endclass

initial
begin

B b_h;

b_h=new();

$display("%p", b_h);

end
endmodule
//___________________________________________________________________________________________________________________________________________________________________\\

//POLYMORPHISM

// base class
class base_class;
  virtual function void display();
    $display("Inside base class");
  endfunction
endclass
 
// extended class 1
class ext_class_1 extends base_class;
  function void display();
    $display("Inside extended class 1");
  endfunction
endclass
 
// extended class 2
class ext_class_2 extends base_class;
  function void display();
    $display("Inside extended class 2");
  endfunction
endclass
 
// extended class 3
class ext_class_3 extends base_class;
  function void display();
    $display("Inside extended class 3");
  endfunction
endclass
 
// module
module class_polymorphism;
 
  initial begin
     
    //declare and create extended class
    ext_class_1 ec_1 = new();
    ext_class_2 ec_2 = new();
    ext_class_3 ec_3 = new();
     
    //base class handle
    base_class b_c[4];
     
    //assigning extended class to base class
    b_c[0] = ec_1;
    b_c[1] = ec_2;
    b_c[2] = ec_3;
    b_c[3] = new();
    //accessing extended class methods using base class handle
    b_c[0].display();
    b_c[1].display();
    b_c[2].display();
    b_c[3].display();

  end
 
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//-------------------INHERITANCE-------------------//
module test;
  
class base;
  int num1;
  int num2;
  static int num3;
  
  function new(int value);
    num1 = value;
    num2 = num1*10;
  endfunction
endclass

class child extends base;
  function new(int number);
    super.new(number);
  endfunction
endclass

base b1;
  child c1[5];

initial begin  
//  b1 = new(5);
  foreach(c1[i]) begin
    c1[i] = new(i+10);
    c1[i].num3++;
    
    $display("%p",c1);
    $display("%0d",c1.num3);
  end
end

endmodule
    
//___________________________________________________________________________________________________________________________________________________________________\\

//-------------------POLYMORPHISM-------------------//
module test;
  class parent;
    virtual task body();
      $display("IM PARENT");
    endtask
  endclass
  
  class child extends parent;
    virtual task body();
      $display("IM CHILD");
    endtask
  endclass
  
  parent p1;
  child c1,c2;
  
  initial begin
    p1 = new();
    c1 = new();
    c2 = new();
    
    p1.body();
    c1.body();
    
    p1 = c1;
   // $cast(c2,p1);

    p1.body();
    //c1.body();
  //  c2.body();
    
    
  end
endmodule
         
//___________________________________________________________________________________________________________________________________________________________________\\
//OVERRIDING PARENT CLASS METHODS

class parent_class;
  bit [31:0] addr;
 
  function display();
    $display("Addr = %0d",addr);
  endfunction
endclass
 
class child_class extends parent_class;
  bit [31:0] data;
  function display();
    $display("Data = %0d",data);
  endfunction
endclass
 
module inheritence;
  initial begin
    child_class c=new();
    c.addr = 10;
    c.data = 20;
    c.display();
  end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//SUPER KEYWORD

class parent_class;
  bit [31:0] addr;
 
  function p_display();
    $display("Addr = %0d",addr);
  endfunction
endclass
 
class child_class extends parent_class;
  bit [31:0] data;
 
  function c_display();
    super.p_display();
    $display("Data = %0d",data);
  endfunction
 
endclass
 
module inheritence;
  initial begin
    child_class c=new();
    c.addr = 10;
    c.data = 20;
    c.c_display();
  end
endmodule

class parent_class;
  bit [31:0] addr;
  function display();
    $display("Addr = %0d",addr);
  endfunction
endclass
 
class child_class extends parent_class;
  bit [31:0] data;
  function display();
    super.display();
    $display("Data = %0d",data);
  endfunction
endclass
 
module inheritence;
  initial begin
    parent_class p;
    child_class  c=new();
    child_class  c1;
    c.addr = 10;
    c.data = 20;
 
    p = c;         //p is pointing to child class handle c.
    $cast(c1,p);   //with the use of $cast, type chek will occur during runtime
 
    c1.display();
  end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//RANDOMISATION  (RAND RANDC KEYWORDS)

module practice;
  
class practice;

  rand bit[1:0]addr; //randomizes any random value within the datatype range. (can be repeated)
  randc bit[1:0] data;  //cycles through all the values possible within the range of the datatype (does not repeat in one complete cycle of going through all possible values)

endclass


initial begin
  practice p1;

  p1 = new();

  repeat(8) begin
    p1.randomize();
    $display("Value of address is %0d and the value of data is %0d", p1.addr, p1.data);
  end

end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//RAND_MODE DISABLE CLASS VARIABLES

module practice;

class test;

rand bit[3:0]addr;
rand bit[3:0]data;

endclass

packet pkt;

initial begin
  pkt = new();

  pkt.data.rand_mode(0);
  pkt.randomize();

  $display("Values of address and data are %0d and %0d", pkt.addr, pkt.data);
  #5;

  pkt.data.rand_mode(1);
  pkt.randomize();

  $display("Values of address and data are %0d and %0d", pkt.addr, pkt.data);

end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//RAND_MODE DISABLE ALL CLASS VARIABLES

module test;

class packet;

rand bit[3:0]addr;
rand bit[3:0]data;
endclass

packet pkt;

initial begin
  pkt = new();

  pkt.rand_mode(0);
  pkt.randomize();

  $display("Values of address and data are %0d and %0d", pkt.addr, pkt.data);
  
  pkt.rand_mode(1);
  pkt.randomize();

  $display("Values of address and data are %0d and %0d", pkt.addr, pkt.data);
  
end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//CONSTRAINTS

module test;

class packet;

  rand bit[6:0] pkt_length;

constraint pkt_len{pkt_length<=64; }

endclass

packet p1;

initial begin
  p1 = new();

  p1.randomize();
  $display(p1);

end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//CONSTRAINT INHERITANCE

module test;

class packet;
  rand bit[8:0]pkt_length;

constraint undersized{pkt_length<64;}
endclass

class extended_packet extends packet;
constraint oversized{pkt_length>60;}
endclass

extended_packet ep1;
initial begin
  ep1 = new();

  ep1.randomize();

  $display(ep1);

end

endmodule


//___________________________________________________________________________________________________________________________________________________________________\\

//CONSTRAINT OVERRIDING


module test;

class packet;
rand bit[8:0]pkt_length;

constraint undersized{pkt_length<64;}
endclass

class extended_packet extends packet;
constraint undersized{pkt_length>60;}
endclass

extended_packet ep1;
initial begin
  ep1 = new();

  ep1.randomize();

  $display(ep1);

end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//SET MEMBERSHIP (INSIDE KEYWORD)

module test;

class packet;
rand bit[8:0]pkt_length;

constraint undersized{pkt_length<64;}
endclass

class extended_packet extends packet;
  constraint undersized{pkt_length inside {10,11,45,[67:78]};}
endclass

extended_packet ep1;
initial begin
  ep1 = new();

  ep1.randomize();

  $display(ep1);

end

endmodule


//___________________________________________________________________________________________________________________________________________________________________\\

//CONSTRAINT INHERITANCE (inside KEYWORD)

module test;

class packet;
rand bit[8:0]pkt_length;
  rand bit[5:0]start_ad, end_ad;
  constraint undersized{pkt_length inside{[start_ad:end_ad]};}
  
endclass

class extended_packet extends packet;
constraint oversized{pkt_length>60;}
endclass

extended_packet ep1;
initial begin
  ep1 = new();

  ep1.randomize();

  $display(ep1);

end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//INLIINE CONSTRAINTS(with KEYWORD)

module test;

class packet;
rand bit[8:0]pkt_length;
  rand bit[5:0]start_ad, end_ad;
constraint oversized{pkt_length>60;}
endclass

packet ep1;
  
initial begin
  ep1 = new();
  repeat(4) begin
  assert(ep1.randomize with{pkt_length%100==0;});

  $display(ep1);
  end
end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//SV ASSIGNMENTS CONSTRAINTS

module test;

class parent;
rand bit[2:0]a;
constraint a_size{a==3;}
endclass

class child extends parent;
rand bit[2:0]a;
constraint a_size{a==2;}
constraint c_size{super.a==a;}
endclass

parent p1;
child c1;

initial begin
  c1 = new();

  repeat(4) begin
    assert(c1.randomize());
    $display(c1);

end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\


module test;

class parent;
rand bit[2:0]a;
constraint a_size{a==3;}
endclass

class child extends parent;
rand bit[2:0]a;
constraint b_size{a==2;}
constraint c_size{super.a==a;}
endclass

parent p1;
child c1;

initial begin
  c1 = new();

  repeat(4) begin
    assert(c1.randomize());
    $display(c1);

end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

module test;

class parent;
rand bit[2:0]a;
  constraint a_size{a<3;}
endclass

class child extends parent;
rand bit[2:0]a;
  constraint a_size{a>3;}
endclass

parent p1;
child c1;

initial begin
  c1 = new();

  repeat(4) begin
    assert(c1.randomize());
    $display(c1);

end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

module test;

class parent;
rand bit[2:0]a;
  constraint a_size{a<3;}
endclass

class child extends parent;
rand bit[2:0]a;
  constraint a_size{a<5;}
endclass

parent p1;
child c1;

initial begin
  c1 = new();

  repeat(4) begin
    assert(c1.randomize());
    $display(c1);

end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

module test;

class parent;
rand bit[2:0]a;
  constraint a_size{a<3;}
endclass

class child extends parent;
rand bit[2:0]a;
  constraint b_size{a<5;}
endclass

parent p1;
child c1;

initial begin
  c1 = new();

  repeat(7) begin
    assert(c1.randomize());
    $display(c1);

end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//Write a constraint to randomly generate 10 unique numbers between 99 to 100

module test;

class practice;
rand int number;
real number_r; //for displaying decimal numbers between 99 and 1000

constraint c1{number inside {[990:1000]};} //10 numbers between 990 and 1000 

function void post_randomize();
number_r = number/10;
endfunction

endclass

practice p1;

initial begin
  
  p1 = new();

  repeat(10) begin
    assert(p1.randomize());
  $display(p1.number_r);
end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//Write a constraint to generate 10 random numbers in an array. The range of each element should be between 10 to 30.  Write a code to generate 10 elements in a queue with the following conditions,
//   Example:   queue[0] = array[0]  - 0 and 
//                     queue[1] = array[1] - array[0] and so on.

module test;

class practice;

rand int array1[];
rand int queue1[$];

constraint array1_size{array1.size==10;}
constraint queue1_size{queue1.size==10;}

constraint array1_members{foreach(array1[i]) array1[i] inside{[10:30]};}
  constraint queue1_members{foreach(queue1[i]) if(i==0) queue1[i] == array1[i]-0;
                           						else queue1[i]== (array1[i] - array1[i-1]);}

endclass

practice p1;

initial begin
  p1 = new();

  assert(p1.randomize());
  $display(p1);
end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//Write a constraint to generate 10 even and odd numbers in two separate arrays.

module test();

class practice;
 
  rand bit[5:0]array1[];
  rand bit[5:0]array2[];
	
  constraint array_size1{array1.size==10;}
  constraint array_size2{array2.size== array1.size;}
  constraint array1_members{foreach(array1[i]) array1[i]%2==0;}
  constraint array2_members{foreach(array2[i]) array2[i]%2!=0;}

endclass
	
	practice p1;
	
	initial 
	begin
      p1 = new();
     
      assert(p1.randomize());
      $display(p1);
  
	end

endmodule

//___________________________________________________________________________________________________________________________________________________________________\\
//Write a constraint to randomly generate 10 unique numbers between 1.35 to 2.57

module test;

class practice;
rand int number;
real number_r; //for displaying decimal numbers between 1.35 and 2.57

constraint c1{number inside {[135:257]};} //10 numbers between 990 and 1000 

function void post_randomize();
number_r = number/100.0;
endfunction

endclass

practice p1;

initial begin
  
  p1 = new();

  repeat(10) begin
    assert(p1.randomize());
  $display(p1.number_r);
end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

//Write constraint to generate random values 25,27,30,36,40,45 for the integer "a" without using "set membership".

module test;

class practice;
rand int a;

constraint range{a inside{[25:45]};}
constraint c1{a!=35;}
  constraint c2{(a%5==0)||(a%9==0);}

endclass
              
practice p1;

initial begin
  p1 = new();

  repeat(16) begin
  assert(p1.randomize());
  $display(p1);
  end
end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

/*Assume that you have two properties
 rand bit [7:0]a;
 rand bit [2:0]b;

The range of values for b are 3,4,7

If b==3, the number of ones in the binary number 'a' must be 4. 
If b==4, the number of ones in the binary number 'a' must be 5. 
If b==7, the number of ones in the binary number 'a' must be 8. 

Write constraints for above scenario.*/

module test;

class practice;
 rand bit [7:0]a;
 rand bit [2:0]b;

  constraint b_range {b dist {3:=2,4:=2,7:=2};}
 constraint no_of_ones {$countones(a)==(b+1); }
endclass

practice p1;
initial
 begin
  
  p1=new();
   repeat(10)begin
   assert(p1.randomize);
     $display("For b=%0d, a in binary is %b",p1.b,p1.a);
   end

 end
endmodule

//___________________________________________________________________________________________________________________________________________________________________\\

