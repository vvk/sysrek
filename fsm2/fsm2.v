`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:36:43 03/19/2015 
// Design Name: 
// Module Name:    fsm2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fsm2(
	input clk,
	input rst,
	input rxd,
	
	output [7:0] data,
	output received
    );

localparam STATE1 = 2'b00;
localparam STATE2 = 2'b01;
localparam STATE3 = 2'b10;
//localparam STATE4 = 2'b11;

reg state = STATE1;
reg [7:0] tmp_data = 8'b00000000;
reg tmp_received = 1'b0;
reg [2:0] index;
reg [1:0] rxd_hist = 2'b11;

always @(posedge clk)
begin
	if(rst)
	begin
		tmp_data = 0;
		tmp_received = 0;
		state = STATE1;
	end
	
	case(state)
	STATE1:
	begin
		if(rxd_hist == 2'b00 && rxd == 1) //bit startu
		begin
			rxd_hist = 2'b11;
			tmp_data = 8'b00000000;
			index = 3'b000;
			state = STATE2;
		end
	end
	STATE2:
	begin
		tmp_data[index] = rxd;
		index = index + 1;
		
		if(index == 3'b000) //odebrano 8 bitow danych
		begin
			tmp_received = 1'b1;
			state = STATE3;
		end
	end
	STATE3:
	begin
		//obsluga flagi received
		tmp_received = 1'b0;
		tmp_data = 8'b00000000;
		state = STATE1;
	end
	endcase
	
	if(state == STATE1) rxd_hist = { rxd_hist[0], rxd };	
end

assign data = tmp_data;
assign received = tmp_received;

endmodule
