Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCA610BBCA
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfK0VQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387567AbfK0VOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:14:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9CF216F4;
        Wed, 27 Nov 2019 21:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889282;
        bh=DsL44gBVIgR0pNwuHYU5KliZ1cqc3aLioBlTCDOpyzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHJmk5EI9nlJ3bLFW50abLo3WgcB6PnHViHUB6n3aRKhKJi/Y9wO1HT0BbHsUryhq
         JoU7oXJuXX29QWfeLP1UlU41U3/0FOnKHTvfn4uowTP58FE6z3j7Pi3wDt4ZZmW8z7
         vBXxsxX3YfZMtLB3DrVqPtGs6LSEDeSWlO7tJgbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, A Sun <as1033x@comcast.net>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.4 51/66] media: mceusb: fix out of bounds read in MCE receiver buffer
Date:   Wed, 27 Nov 2019 21:32:46 +0100
Message-Id: <20191127202731.944285952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: A Sun <as1033x@comcast.net>

commit e43148645d18efc3072b1ba45afaa3f385299e55 upstream.

Fix multiple cases of out of bounds (OOB) read associated with
MCE device receive/input data handling.

In reference for the OOB cases below, the incoming/read (byte) data
format when the MCE device responds to a command is:
    { cmd_prefix, subcmd, data0, data1, ... }
where cmd_prefix are:
    MCE_CMD_PORT_SYS
    MCE_CMD_PORT_IR
and subcmd examples are:
    MCE_RSP_GETPORTSTATUS
    MCE_RSP_EQIRNUMPORTS
    ...
Response size dynamically depends on cmd_prefix and subcmd.
So data0, data1, ... may or may not be present on input.
Multiple responses may return in a single receiver buffer.

The trigger condition for OOB read is typically random or
corrupt input data that fills the mceusb receiver buffer.

Case 1:

mceusb_handle_command() reads data0 (var hi) and data1 (var lo)
regardless of whether the response includes such data.
If { cmd_prefix, subcmd } is at the end of the receiver buffer,
read past end of buffer occurs.

This case was reported by
KASAN: slab-out-of-bounds Read in mceusb_dev_recv
https://syzkaller.appspot.com/bug?extid=c7fdb6cb36e65f2fe8c9

Fix: In mceusb_handle_command(), change variable hi and lo to
pointers, and dereference only when required.

Case 2:

If response with data is truncated at end of buffer after
{ cmd_prefix, subcmd }, mceusb_handle_command() reads past
end of buffer for data0, data1, ...

Fix: In mceusb_process_ir_data(), check response size with
remaining buffer size before invoking mceusb_handle_command().
+    if (i + ir->rem < buf_len)
            mceusb_handle_command(ir, &ir->buf_in[i - 1]);

Case 3:

mceusb_handle_command() handles invalid/bad response such as
{ 0x??, MCE_RSP_GETPORTSTATUS } of length 2 as a response
{ MCE_CMD_PORT_SYS, MCE_RSP_GETPORTSTATUS, data0, ... }
of length 7. Read OOB occurs for non-existent data0, data1, ...
Cause is mceusb_handle_command() does not check cmd_prefix value.

Fix: mceusb_handle_command() must test both cmd_prefix and subcmd.

Case 4:

mceusb_process_ir_data() receiver parser state SUBCMD is
possible at start (i=0) of receiver buffer resulting in buffer
offset=-1 passed to mceusb_dev_printdata().
Bad offset results in OOB read before start of buffer.

[1214218.580308] mceusb 1-1.3:1.0: rx data[0]: 00 80 (length=2)
[1214218.580323] mceusb 1-1.3:1.0: Unknown command 0x00 0x80
...
[1214218.580406] mceusb 1-1.3:1.0: rx data[14]: 7f 7f (length=2)
[1214218.679311] mceusb 1-1.3:1.0: rx data[-1]: 80 90 (length=2)
[1214218.679325] mceusb 1-1.3:1.0: End of raw IR data
[1214218.679340] mceusb 1-1.3:1.0: rx data[1]: 7f 7f (length=2)

Fix: If parser_state is SUBCMD after processing receiver buffer,
reset parser_state to CMD_HEADER.
In effect, discard cmd_prefix at end of receiver buffer.
In mceusb_dev_printdata(), abort if buffer offset is out of bounds.

Case 5:

If response with data is truncated at end of buffer after
{ cmd_prefix, subcmd }, mceusb_dev_printdata() reads past
end of buffer for data0, data1, ...
while decoding the response to print out.

Fix: In mceusb_dev_printdata(), remove unneeded buffer offset
adjustments (var start and var skip) associated with MCE gen1 header.
Test for truncated MCE cmd response (compare offset+len with buf_len)
and skip decoding of incomplete response.
Move IR data tracing to execute before the truncation test.

Signed-off-by: A Sun <as1033x@comcast.net>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/mceusb.c |  141 +++++++++++++++++++++++++++++++---------------
 1 file changed, 98 insertions(+), 43 deletions(-)

--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -564,7 +564,7 @@ static int mceusb_cmd_datasize(u8 cmd, u
 			datasize = 4;
 			break;
 		case MCE_CMD_G_REVISION:
-			datasize = 2;
+			datasize = 4;
 			break;
 		case MCE_RSP_EQWAKESUPPORT:
 		case MCE_RSP_GETWAKESOURCE:
@@ -600,14 +600,9 @@ static void mceusb_dev_printdata(struct
 	char *inout;
 	u8 cmd, subcmd, *data;
 	struct device *dev = ir->dev;
-	int start, skip = 0;
 	u32 carrier, period;
 
-	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
-	if (ir->flags.microsoft_gen1 && !out && !offset)
-		skip = 2;
-
-	if (len <= skip)
+	if (offset < 0 || offset >= buf_len)
 		return;
 
 	dev_dbg(dev, "%cx data[%d]: %*ph (len=%d sz=%d)",
@@ -616,11 +611,32 @@ static void mceusb_dev_printdata(struct
 
 	inout = out ? "Request" : "Got";
 
-	start  = offset + skip;
-	cmd    = buf[start] & 0xff;
-	subcmd = buf[start + 1] & 0xff;
-	data = buf + start + 2;
+	cmd    = buf[offset];
+	subcmd = (offset + 1 < buf_len) ? buf[offset + 1] : 0;
+	data   = &buf[offset] + 2;
+
+	/* Trace meaningless 0xb1 0x60 header bytes on original receiver */
+	if (ir->flags.microsoft_gen1 && !out && !offset) {
+		dev_dbg(dev, "MCE gen 1 header");
+		return;
+	}
 
+	/* Trace IR data header or trailer */
+	if (cmd != MCE_CMD_PORT_IR &&
+	    (cmd & MCE_PORT_MASK) == MCE_COMMAND_IRDATA) {
+		if (cmd == MCE_IRDATA_TRAILER)
+			dev_dbg(dev, "End of raw IR data");
+		else
+			dev_dbg(dev, "Raw IR data, %d pulse/space samples",
+				cmd & MCE_PACKET_LENGTH_MASK);
+		return;
+	}
+
+	/* Unexpected end of buffer? */
+	if (offset + len > buf_len)
+		return;
+
+	/* Decode MCE command/response */
 	switch (cmd) {
 	case MCE_CMD_NULL:
 		if (subcmd == MCE_CMD_NULL)
@@ -644,7 +660,7 @@ static void mceusb_dev_printdata(struct
 				dev_dbg(dev, "Get hw/sw rev?");
 			else
 				dev_dbg(dev, "hw/sw rev %*ph",
-					4, &buf[start + 2]);
+					4, &buf[offset + 2]);
 			break;
 		case MCE_CMD_RESUME:
 			dev_dbg(dev, "Device resume requested");
@@ -746,13 +762,6 @@ static void mceusb_dev_printdata(struct
 	default:
 		break;
 	}
-
-	if (cmd == MCE_IRDATA_TRAILER)
-		dev_dbg(dev, "End of raw IR data");
-	else if ((cmd != MCE_CMD_PORT_IR) &&
-		 ((cmd & MCE_PORT_MASK) == MCE_COMMAND_IRDATA))
-		dev_dbg(dev, "Raw IR data, %d pulse/space samples",
-			cmd & MCE_PACKET_LENGTH_MASK);
 #endif
 }
 
@@ -1136,32 +1145,62 @@ static int mceusb_set_rx_carrier_report(
 }
 
 /*
+ * Handle PORT_SYS/IR command response received from the MCE device.
+ *
+ * Assumes single response with all its data (not truncated)
+ * in buf_in[]. The response itself determines its total length
+ * (mceusb_cmd_datasize() + 2) and hence the minimum size of buf_in[].
+ *
  * We don't do anything but print debug spew for many of the command bits
  * we receive from the hardware, but some of them are useful information
  * we want to store so that we can use them.
  */
-static void mceusb_handle_command(struct mceusb_dev *ir, int index)
+static void mceusb_handle_command(struct mceusb_dev *ir, u8 *buf_in)
 {
+	u8 cmd = buf_in[0];
+	u8 subcmd = buf_in[1];
+	u8 *hi = &buf_in[2];		/* read only when required */
+	u8 *lo = &buf_in[3];		/* read only when required */
 	struct ir_raw_event rawir = {};
-	u8 hi = ir->buf_in[index + 1] & 0xff;
-	u8 lo = ir->buf_in[index + 2] & 0xff;
 	u32 carrier_cycles;
 	u32 cycles_fix;
 
-	switch (ir->buf_in[index]) {
-	/* the one and only 5-byte return value command */
-	case MCE_RSP_GETPORTSTATUS:
-		if ((ir->buf_in[index + 4] & 0xff) == 0x00)
-			ir->txports_cabled |= 1 << hi;
-		break;
+	if (cmd == MCE_CMD_PORT_SYS) {
+		switch (subcmd) {
+		/* the one and only 5-byte return value command */
+		case MCE_RSP_GETPORTSTATUS:
+			if (buf_in[5] == 0)
+				ir->txports_cabled |= 1 << *hi;
+			break;
 
+		/* 1-byte return value commands */
+		case MCE_RSP_EQEMVER:
+			ir->emver = *hi;
+			break;
+
+		/* No return value commands */
+		case MCE_RSP_CMD_ILLEGAL:
+			ir->need_reset = true;
+			break;
+
+		default:
+			break;
+		}
+
+		return;
+	}
+
+	if (cmd != MCE_CMD_PORT_IR)
+		return;
+
+	switch (subcmd) {
 	/* 2-byte return value commands */
 	case MCE_RSP_EQIRTIMEOUT:
-		ir->rc->timeout = US_TO_NS((hi << 8 | lo) * MCE_TIME_UNIT);
+		ir->rc->timeout = US_TO_NS((*hi << 8 | *lo) * MCE_TIME_UNIT);
 		break;
 	case MCE_RSP_EQIRNUMPORTS:
-		ir->num_txports = hi;
-		ir->num_rxports = lo;
+		ir->num_txports = *hi;
+		ir->num_rxports = *lo;
 		break;
 	case MCE_RSP_EQIRRXCFCNT:
 		/*
@@ -1174,7 +1213,7 @@ static void mceusb_handle_command(struct
 		 */
 		if (ir->carrier_report_enabled && ir->learning_active &&
 		    ir->pulse_tunit > 0) {
-			carrier_cycles = (hi << 8 | lo);
+			carrier_cycles = (*hi << 8 | *lo);
 			/*
 			 * Adjust carrier cycle count by adding
 			 * 1 missed count per pulse "on"
@@ -1192,24 +1231,24 @@ static void mceusb_handle_command(struct
 		break;
 
 	/* 1-byte return value commands */
-	case MCE_RSP_EQEMVER:
-		ir->emver = hi;
-		break;
 	case MCE_RSP_EQIRTXPORTS:
-		ir->tx_mask = hi;
+		ir->tx_mask = *hi;
 		break;
 	case MCE_RSP_EQIRRXPORTEN:
-		ir->learning_active = ((hi & 0x02) == 0x02);
-		if (ir->rxports_active != hi) {
+		ir->learning_active = ((*hi & 0x02) == 0x02);
+		if (ir->rxports_active != *hi) {
 			dev_info(ir->dev, "%s-range (0x%x) receiver active",
-				 ir->learning_active ? "short" : "long", hi);
-			ir->rxports_active = hi;
+				 ir->learning_active ? "short" : "long", *hi);
+			ir->rxports_active = *hi;
 		}
 		break;
+
+	/* No return value commands */
 	case MCE_RSP_CMD_ILLEGAL:
 	case MCE_RSP_TX_TIMEOUT:
 		ir->need_reset = true;
 		break;
+
 	default:
 		break;
 	}
@@ -1235,7 +1274,8 @@ static void mceusb_process_ir_data(struc
 			ir->rem = mceusb_cmd_datasize(ir->cmd, ir->buf_in[i]);
 			mceusb_dev_printdata(ir, ir->buf_in, buf_len, i - 1,
 					     ir->rem + 2, false);
-			mceusb_handle_command(ir, i);
+			if (i + ir->rem < buf_len)
+				mceusb_handle_command(ir, &ir->buf_in[i - 1]);
 			ir->parser_state = CMD_DATA;
 			break;
 		case PARSE_IRDATA:
@@ -1264,15 +1304,22 @@ static void mceusb_process_ir_data(struc
 			ir->rem--;
 			break;
 		case CMD_HEADER:
-			/* decode mce packets of the form (84),AA,BB,CC,DD */
-			/* IR data packets can span USB messages - rem */
 			ir->cmd = ir->buf_in[i];
 			if ((ir->cmd == MCE_CMD_PORT_IR) ||
 			    ((ir->cmd & MCE_PORT_MASK) !=
 			     MCE_COMMAND_IRDATA)) {
+				/*
+				 * got PORT_SYS, PORT_IR, or unknown
+				 * command response prefix
+				 */
 				ir->parser_state = SUBCMD;
 				continue;
 			}
+			/*
+			 * got IR data prefix (0x80 + num_bytes)
+			 * decode MCE packets of the form {0x83, AA, BB, CC}
+			 * IR data packets can span USB messages
+			 */
 			ir->rem = (ir->cmd & MCE_PACKET_LENGTH_MASK);
 			mceusb_dev_printdata(ir, ir->buf_in, buf_len,
 					     i, ir->rem + 1, false);
@@ -1296,6 +1343,14 @@ static void mceusb_process_ir_data(struc
 		if (ir->parser_state != CMD_HEADER && !ir->rem)
 			ir->parser_state = CMD_HEADER;
 	}
+
+	/*
+	 * Accept IR data spanning multiple rx buffers.
+	 * Reject MCE command response spanning multiple rx buffers.
+	 */
+	if (ir->parser_state != PARSE_IRDATA || !ir->rem)
+		ir->parser_state = CMD_HEADER;
+
 	if (event) {
 		dev_dbg(ir->dev, "processed IR data");
 		ir_raw_event_handle(ir->rc);


