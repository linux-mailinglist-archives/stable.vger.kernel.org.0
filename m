Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951671E10A5
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgEYOhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:37:39 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50151 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgEYOhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:37:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0986E19421BD;
        Mon, 25 May 2020 10:37:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3xoxNH
        topWUKyRHvHXanqy/uandxdAjzTzI12Zv2e2Y=; b=B0NRiUYATfEOK9dCLUHwnD
        hoaONsmdw1vF88bNP0q8UI+HsJQ7X8v0AefmHI6Bs7R71jB6mr0qYdGbPfVDiAvS
        u2R+8o+8HFxZT3CFKn5PjLndALAqO8bjcxNj6k3oNG95VDWa8Bsfni/tjXqAvAH4
        pEKNz3HDXKhVAm3JJIUxBZePiTtUPLfygMONmfWsFjyZu8W7tdSh+yKMxOtEDlkA
        q8N6iuX9KW40qQX7vZfrqkwyl0P8ZvO+6k6JWwZ0QQn2wRxUUZ/fS/NyNsN0+Ndb
        1wbx4l7ek06H1+38vCJYkB/jGCfVZtahbLH6KOkAVQOwc7aryw16rXzmXi607ElA
        ==
X-ME-Sender: <xms:MdjLXpwqV0J_xiP4wAcWTUrgKqa5g2kJP-FGiIHKPb-9zvIj05Q_RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:MdjLXpRoK2e8LD81jd3Hh_3P_z-ztiu9B_yJ6gPXh7hL0WWoRuTi3A>
    <xmx:MdjLXjXXQKVn7q6K4d9au1kEzJSi9x5BPNnv_Z7bz100GJcQifqVCA>
    <xmx:MdjLXrirtD3ySiS05eGYfmxNABXCFEq5ArhGzpdk7U60AfY8Hnd71w>
    <xmx:MtjLXu-ZtLtkLMTYmuZYFl6B58UsUuMcsc7r7bVvX6XoJqpNpg_UWg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 566C33280059;
        Mon, 25 May 2020 10:37:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rxrpc: Fix ack discard" failed to apply to 5.6-stable tree
To:     dhowells@redhat.com, botsch@cnf.cornell.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:37:33 +0200
Message-ID: <15904174535561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 441fdee1eaf050ef0040bde0d7af075c1c6a6d8b Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Wed, 29 Apr 2020 23:48:43 +0100
Subject: [PATCH] rxrpc: Fix ack discard

The Rx protocol has a "previousPacket" field in it that is not handled in
the same way by all protocol implementations.  Sometimes it contains the
serial number of the last DATA packet received, sometimes the sequence
number of the last DATA packet received and sometimes the highest sequence
number so far received.

AF_RXRPC is using this to weed out ACKs that are out of date (it's possible
for ACK packets to get reordered on the wire), but this does not work with
OpenAFS which will just stick the sequence number of the last packet seen
into previousPacket.

The issue being seen is that big AFS FS.StoreData RPC (eg. of ~256MiB) are
timing out when partly sent.  A trace was captured, with an additional
tracepoint to show ACKs being discarded in rxrpc_input_ack().  Here's an
excerpt showing the problem.

 52873.203230: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 0002449c q=00024499 fl=09

A DATA packet with sequence number 00024499 has been transmitted (the "q="
field).

 ...
 52873.243296: rxrpc_rx_ack: c=000004ae 00012a2b DLY r=00024499 f=00024497 p=00024496 n=0
 52873.243376: rxrpc_rx_ack: c=000004ae 00012a2c IDL r=0002449b f=00024499 p=00024498 n=0
 52873.243383: rxrpc_rx_ack: c=000004ae 00012a2d OOS r=0002449d f=00024499 p=0002449a n=2

The Out-Of-Sequence ACK indicates that the server didn't see DATA sequence
number 00024499, but did see seq 0002449a (previousPacket, shown as "p=",
skipped the number, but firstPacket, "f=", which shows the bottom of the
window is set at that point).

 52873.252663: rxrpc_retransmit: c=000004ae q=24499 a=02 xp=14581537
 52873.252664: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244bc q=00024499 fl=0b *RETRANS*

The packet has been retransmitted.  Retransmission recurs until the peer
says it got the packet.

 52873.271013: rxrpc_rx_ack: c=000004ae 00012a31 OOS r=000244a1 f=00024499 p=0002449e n=6

More OOS ACKs indicate that the other packets that are already in the
transmission pipeline are being received.  The specific-ACK list is up to 6
ACKs and NAKs.

 ...
 52873.284792: rxrpc_rx_ack: c=000004ae 00012a49 OOS r=000244b9 f=00024499 p=000244b6 n=30
 52873.284802: rxrpc_retransmit: c=000004ae q=24499 a=0a xp=63505500
 52873.284804: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244c2 q=00024499 fl=0b *RETRANS*
 52873.287468: rxrpc_rx_ack: c=000004ae 00012a4a OOS r=000244ba f=00024499 p=000244b7 n=31
 52873.287478: rxrpc_rx_ack: c=000004ae 00012a4b OOS r=000244bb f=00024499 p=000244b8 n=32

At this point, the server's receive window is full (n=32) with presumably 1
NAK'd packet and 31 ACK'd packets.  We can't transmit any more packets.

 52873.287488: rxrpc_retransmit: c=000004ae q=24499 a=0a xp=61327980
 52873.287489: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244c3 q=00024499 fl=0b *RETRANS*
 52873.293850: rxrpc_rx_ack: c=000004ae 00012a4c DLY r=000244bc f=000244a0 p=00024499 n=25

And now we've received an ACK indicating that a DATA retransmission was
received.  7 packets have been processed (the occupied part of the window
moved, as indicated by f= and n=).

 52873.293853: rxrpc_rx_discard_ack: c=000004ae r=00012a4c 000244a0<00024499 00024499<000244b8

However, the DLY ACK gets discarded because its previousPacket has gone
backwards (from p=000244b8, in the ACK at 52873.287478 to p=00024499 in the
ACK at 52873.293850).

We then end up in a continuous cycle of retransmit/discard.  kafs fails to
update its window because it's discarding the ACKs and can't transmit an
extra packet that would clear the issue because the window is full.
OpenAFS doesn't change the previousPacket value in the ACKs because no new
DATA packets are received with a different previousPacket number.

Fix this by altering the discard check to only discard an ACK based on
previousPacket if there was no advance in the firstPacket.  This allows us
to transmit a new packet which will cause previousPacket to advance in the
next ACK.

The check, however, needs to allow for the possibility that previousPacket
may actually have had the serial number placed in it instead - in which
case it will go outside the window and we should ignore it.

Fixes: 1a2391c30c0b ("rxrpc: Fix detection of out of order acks")
Reported-by: Dave Botsch <botsch@cnf.cornell.edu>
Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 2f22f082a66c..3be4177baf70 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -802,6 +802,30 @@ static void rxrpc_input_soft_acks(struct rxrpc_call *call, u8 *acks,
 	}
 }
 
+/*
+ * Return true if the ACK is valid - ie. it doesn't appear to have regressed
+ * with respect to the ack state conveyed by preceding ACKs.
+ */
+static bool rxrpc_is_ack_valid(struct rxrpc_call *call,
+			       rxrpc_seq_t first_pkt, rxrpc_seq_t prev_pkt)
+{
+	rxrpc_seq_t base = READ_ONCE(call->ackr_first_seq);
+
+	if (after(first_pkt, base))
+		return true; /* The window advanced */
+
+	if (before(first_pkt, base))
+		return false; /* firstPacket regressed */
+
+	if (after_eq(prev_pkt, call->ackr_prev_seq))
+		return true; /* previousPacket hasn't regressed. */
+
+	/* Some rx implementations put a serial number in previousPacket. */
+	if (after_eq(prev_pkt, base + call->tx_winsize))
+		return false;
+	return true;
+}
+
 /*
  * Process an ACK packet.
  *
@@ -865,8 +889,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
-	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq)) {
+	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
@@ -882,8 +905,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	spin_lock(&call->input_lock);
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
-	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq)) {
+	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);

