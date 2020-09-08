Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8F626167C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgIHRMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731796AbgIHQTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCBA2247F;
        Tue,  8 Sep 2020 15:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579434;
        bh=kSTDMEbbv8+doQ7jyZH6u4aslf3swuwbo7focQT/NNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxIJyRCtlY4MNnRst8OYY2dYTwGpZ7LoSc4V55tFm2bwoBfQ9m53vUgJLF+9AK+wE
         mSxBwjOx6clVcLKOhrhTzszp54jRNkAnaHbginG8GstvG7C+I/8FoTk2Sd08DgEkb9
         dVehOFYlk+INAe2zSn+xr8L8jx8KLJO93NOWXWX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 046/186] rxrpc: Keep the ACK serial in a var in rxrpc_input_ack()
Date:   Tue,  8 Sep 2020 17:23:08 +0200
Message-Id: <20200908152243.892478027@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 68528d937dcd675e79973061c1a314db598162d1 ]

Keep the ACK serial number in a variable in rxrpc_input_ack() as it's used
frequently.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/input.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 767579328a069..a7699e56eac88 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -843,7 +843,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		struct rxrpc_ackinfo info;
 		u8 acks[RXRPC_MAXACKS];
 	} buf;
-	rxrpc_serial_t acked_serial;
+	rxrpc_serial_t ack_serial, acked_serial;
 	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
 	int nr_acks, offset, ioffset;
 
@@ -856,6 +856,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 	offset += sizeof(buf.ack);
 
+	ack_serial = sp->hdr.serial;
 	acked_serial = ntohl(buf.ack.serial);
 	first_soft_ack = ntohl(buf.ack.firstPacket);
 	prev_pkt = ntohl(buf.ack.previousPacket);
@@ -864,31 +865,31 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	summary.ack_reason = (buf.ack.reason < RXRPC_ACK__INVALID ?
 			      buf.ack.reason : RXRPC_ACK__INVALID);
 
-	trace_rxrpc_rx_ack(call, sp->hdr.serial, acked_serial,
+	trace_rxrpc_rx_ack(call, ack_serial, acked_serial,
 			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
 
 	if (buf.ack.reason == RXRPC_ACK_PING_RESPONSE)
 		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
-					  sp->hdr.serial);
+					  ack_serial);
 	if (buf.ack.reason == RXRPC_ACK_REQUESTED)
 		rxrpc_input_requested_ack(call, skb->tstamp, acked_serial,
-					  sp->hdr.serial);
+					  ack_serial);
 
 	if (buf.ack.reason == RXRPC_ACK_PING) {
-		_proto("Rx ACK %%%u PING Request", sp->hdr.serial);
+		_proto("Rx ACK %%%u PING Request", ack_serial);
 		rxrpc_propose_ACK(call, RXRPC_ACK_PING_RESPONSE,
-				  sp->hdr.serial, true, true,
+				  ack_serial, true, true,
 				  rxrpc_propose_ack_respond_to_ping);
 	} else if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
 		rxrpc_propose_ACK(call, RXRPC_ACK_REQUESTED,
-				  sp->hdr.serial, true, true,
+				  ack_serial, true, true,
 				  rxrpc_propose_ack_respond_to_ack);
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
-		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
 		return;
@@ -904,7 +905,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
-		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
 		goto out;
@@ -964,7 +965,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    RXRPC_TX_ANNO_LAST &&
 	    summary.nr_acks == call->tx_top - hard_ack &&
 	    rxrpc_is_client_call(call))
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, ack_serial,
 				  false, true,
 				  rxrpc_propose_ack_ping_for_lost_reply);
 
-- 
2.25.1



