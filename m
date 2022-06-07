Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CCA5414AC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358285AbiFGUVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359042AbiFGUTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29B31D0BEC;
        Tue,  7 Jun 2022 11:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9ACA611B9;
        Tue,  7 Jun 2022 18:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A25C385A2;
        Tue,  7 Jun 2022 18:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626607;
        bh=yUWi9eLXk1J9vjjkZvhBAvrAmSPuFeslmO2wWxRBOq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIDlYzcwKYSepHkBl1gjzyn9ahJSPoEsn7Bi+n+rNxbkz2w87BUxIiy5ToHUMXXdV
         iVRO9TMNFSfsonmgWr1z/5mzpZWlz1dNiTBlZzcf28e9UkjD5O2kO2ziEoXMYuNcyi
         GufT8rNTUaKlx7+FRhxW75rmP7kyP9TLV+ARAhyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 440/772] rxrpc: Fix overlapping ACK accounting
Date:   Tue,  7 Jun 2022 19:00:32 +0200
Message-Id: <20220607165001.965306957@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 8940ba3cfe4841928777fd45eaa92051522c7f0c ]

Fix accidental overlapping of Rx-phase ACK accounting with Tx-phase ACK
accounting through variables shared between the two.  call->acks_* members
refer to ACKs received in the Tx phase and call->ackr_* members to ACKs
sent/to be sent during the Rx phase.

Fixes: 1a2391c30c0b ("rxrpc: Fix detection of out of order acks")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h |  7 ++++---
 net/rxrpc/input.c       | 16 ++++++++--------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 422558d50571..cc1fe6d00eca 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -676,10 +676,9 @@ struct rxrpc_call {
 
 	spinlock_t		input_lock;	/* Lock for packet input to this call */
 
-	/* receive-phase ACK management */
+	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
-	rxrpc_serial_t		ackr_first_seq;	/* first sequence number received */
 	rxrpc_seq_t		ackr_prev_seq;	/* previous sequence number received */
 	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
 	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
@@ -692,8 +691,10 @@ struct rxrpc_call {
 #define RXRPC_CALL_RTT_AVAIL_MASK	0xf
 #define RXRPC_CALL_RTT_PEND_SHIFT	8
 
-	/* transmission-phase ACK management */
+	/* Transmission-phase ACK management (ACKs we've received). */
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
+	rxrpc_seq_t		acks_first_seq;	/* first sequence number received */
+	rxrpc_seq_t		acks_prev_seq;	/* previous sequence number received */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 67d3eba60dc7..3da33b5c13b2 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -812,7 +812,7 @@ static void rxrpc_input_soft_acks(struct rxrpc_call *call, u8 *acks,
 static bool rxrpc_is_ack_valid(struct rxrpc_call *call,
 			       rxrpc_seq_t first_pkt, rxrpc_seq_t prev_pkt)
 {
-	rxrpc_seq_t base = READ_ONCE(call->ackr_first_seq);
+	rxrpc_seq_t base = READ_ONCE(call->acks_first_seq);
 
 	if (after(first_pkt, base))
 		return true; /* The window advanced */
@@ -820,7 +820,7 @@ static bool rxrpc_is_ack_valid(struct rxrpc_call *call,
 	if (before(first_pkt, base))
 		return false; /* firstPacket regressed */
 
-	if (after_eq(prev_pkt, call->ackr_prev_seq))
+	if (after_eq(prev_pkt, call->acks_prev_seq))
 		return true; /* previousPacket hasn't regressed. */
 
 	/* Some rx implementations put a serial number in previousPacket. */
@@ -933,8 +933,8 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
-					   first_soft_ack, call->ackr_first_seq,
-					   prev_pkt, call->ackr_prev_seq);
+					   first_soft_ack, call->acks_first_seq,
+					   prev_pkt, call->acks_prev_seq);
 		return;
 	}
 
@@ -949,14 +949,14 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
-					   first_soft_ack, call->ackr_first_seq,
-					   prev_pkt, call->ackr_prev_seq);
+					   first_soft_ack, call->acks_first_seq,
+					   prev_pkt, call->acks_prev_seq);
 		goto out;
 	}
 	call->acks_latest_ts = skb->tstamp;
 
-	call->ackr_first_seq = first_soft_ack;
-	call->ackr_prev_seq = prev_pkt;
+	call->acks_first_seq = first_soft_ack;
+	call->acks_prev_seq = prev_pkt;
 
 	/* Parse rwind and mtu sizes if provided. */
 	if (buf.info.rxMTU)
-- 
2.35.1



