Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788CD54863C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352487AbiFMLSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353705AbiFMLQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8484C9587;
        Mon, 13 Jun 2022 03:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA86B80EA3;
        Mon, 13 Jun 2022 10:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C907C34114;
        Mon, 13 Jun 2022 10:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116760;
        bh=1ZgQ2f7FYNuE+pQPqGhs57U0rrKbcVpOieiJwxxhte0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6cf82bwKUD+qP29DJ92U/uMjI2q4r2wqfA6/0aDZRrgvg6L1CcUAGFxjne+5pAJ0
         9nzeByBGojRZbBoXI+aR/rHrG655BRAQC6ADHMKTp5YHdiYpGbpHTZpFHp94dGm7xL
         XnNVP12gnHI/6RSdgqxhGdok9q4RnRHNr/CxAw3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/411] rxrpc: Fix decision on when to generate an IDLE ACK
Date:   Mon, 13 Jun 2022 12:07:07 +0200
Message-Id: <20220613094933.281377813@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 9a3dedcf18096e8f7f22b8777d78c4acfdea1651 ]

Fix the decision on when to generate an IDLE ACK by keeping a count of the
number of packets we've received, but not yet soft-ACK'd, and the number of
packets we've processed, but not yet hard-ACK'd, rather than trying to keep
track of which DATA sequence numbers correspond to those points.

We then generate an ACK when either counter exceeds 2.  The counters are
both cleared when we transcribe the information into any sort of ACK packet
for transmission.  IDLE and DELAY ACKs are skipped if both counters are 0
(ie. no change).

Fixes: 805b21b929e2 ("rxrpc: Send an ACK after every few DATA packets we receive")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  2 +-
 net/rxrpc/ar-internal.h      |  4 ++--
 net/rxrpc/input.c            | 11 +++++++++--
 net/rxrpc/output.c           | 18 +++++++++++-------
 net/rxrpc/recvmsg.c          |  8 +++-----
 5 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 059b6e45a028..839bb07b93a7 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1511,7 +1511,7 @@ TRACE_EVENT(rxrpc_call_reset,
 		    __entry->call_serial = call->rx_serial;
 		    __entry->conn_serial = call->conn->hi_serial;
 		    __entry->tx_seq = call->tx_hard_ack;
-		    __entry->rx_seq = call->ackr_seen;
+		    __entry->rx_seq = call->rx_hard_ack;
 			   ),
 
 	    TP_printk("c=%08x %08x:%08x r=%08x/%08x tx=%08x rx=%08x",
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 8ca7afe0ac26..cb174f699665 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -669,8 +669,8 @@ struct rxrpc_call {
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
 	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
-	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
-	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
+	atomic_t		ackr_nr_unacked; /* Number of unacked packets */
+	atomic_t		ackr_nr_consumed; /* Number of packets needing hard ACK */
 
 	/* ping management */
 	rxrpc_serial_t		ping_serial;	/* Last ping sent */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 8eafa3463b88..5cf64cf8debf 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -413,8 +413,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	enum rxrpc_call_state state;
-	unsigned int j, nr_subpackets;
-	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = 0;
+	unsigned int j, nr_subpackets, nr_unacked = 0;
+	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = serial;
 	rxrpc_seq_t seq0 = sp->hdr.seq, hard_ack;
 	bool immediate_ack = false, jumbo_bad = false;
 	u8 ack = 0;
@@ -570,6 +570,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			sp = NULL;
 		}
 
+		nr_unacked++;
+
 		if (last) {
 			set_bit(RXRPC_CALL_RX_LAST, &call->flags);
 			if (!ack) {
@@ -589,9 +591,14 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			}
 			call->rx_expect_next = seq + 1;
 		}
+		if (!ack)
+			ack_serial = serial;
 	}
 
 ack:
+	if (atomic_add_return(nr_unacked, &call->ackr_nr_unacked) > 2 && !ack)
+		ack = RXRPC_ACK_IDLE;
+
 	if (ack)
 		rxrpc_propose_ACK(call, ack, ack_serial,
 				  immediate_ack, true,
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 7f1c8116e030..6202d2e32914 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -74,11 +74,18 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 				 u8 reason)
 {
 	rxrpc_serial_t serial;
+	unsigned int tmp;
 	rxrpc_seq_t hard_ack, top, seq;
 	int ix;
 	u32 mtu, jmax;
 	u8 *ackp = pkt->acks;
 
+	tmp = atomic_xchg(&call->ackr_nr_unacked, 0);
+	tmp |= atomic_xchg(&call->ackr_nr_consumed, 0);
+	if (!tmp && (reason == RXRPC_ACK_DELAY ||
+		     reason == RXRPC_ACK_IDLE))
+		return 0;
+
 	/* Barrier against rxrpc_input_data(). */
 	serial = call->ackr_serial;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
@@ -180,6 +187,10 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	n = rxrpc_fill_out_ack(conn, call, pkt, &hard_ack, &top, reason);
 
 	spin_unlock_bh(&call->lock);
+	if (n == 0) {
+		kfree(pkt);
+		return 0;
+	}
 
 	iov[0].iov_base	= pkt;
 	iov[0].iov_len	= sizeof(pkt->whdr) + sizeof(pkt->ack) + n;
@@ -227,13 +238,6 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 					  ntohl(pkt->ack.serial),
 					  false, true,
 					  rxrpc_propose_ack_retry_tx);
-		} else {
-			spin_lock_bh(&call->lock);
-			if (after(hard_ack, call->ackr_consumed))
-				call->ackr_consumed = hard_ack;
-			if (after(top, call->ackr_seen))
-				call->ackr_seen = top;
-			spin_unlock_bh(&call->lock);
 		}
 
 		rxrpc_set_keepalive(call);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 4f48e3bdd4b4..c75789ebc514 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -212,11 +212,9 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 		rxrpc_end_rx_phase(call, serial);
 	} else {
 		/* Check to see if there's an ACK that needs sending. */
-		if (after_eq(hard_ack, call->ackr_consumed + 2) ||
-		    after_eq(top, call->ackr_seen + 2) ||
-		    (hard_ack == top && after(hard_ack, call->ackr_consumed)))
-			rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial,
-					  true, true,
+		if (atomic_inc_return(&call->ackr_nr_consumed) > 2)
+			rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, serial,
+					  true, false,
 					  rxrpc_propose_ack_rotate_rx);
 		if (call->ackr_reason && call->ackr_reason != RXRPC_ACK_DELAY)
 			rxrpc_send_ack_packet(call, false, NULL);
-- 
2.35.1



