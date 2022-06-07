Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C0A540630
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347251AbiFGReU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348200AbiFGRbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E1611E4BC;
        Tue,  7 Jun 2022 10:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED6DE614B2;
        Tue,  7 Jun 2022 17:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FE6C385A5;
        Tue,  7 Jun 2022 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622983;
        bh=RN7uMU1X7VJtKbIve5Q6YwJAtS92XW+tVUGxyj3POVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRMpcIY3ymkOjhCJUUMs89InnR0Use9gFcW7ArX6VqJbZU8eGo+hxSMhzT32mEMM1
         Sknrd65oanc8tAu9kpEwlxeQhkE6oX85dVF1G+xRGoZYnUAtaUTFW8U59sEXHaEm7U
         vVVUQHBN4XATShuDcJ/x66RT5os/kBrM9E4N+5UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/452] rxrpc: Fix decision on when to generate an IDLE ACK
Date:   Tue,  7 Jun 2022 19:01:51 +0200
Message-Id: <20220607164916.126850724@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 4a3ab0ed6e06..1c714336b863 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1509,7 +1509,7 @@ TRACE_EVENT(rxrpc_call_reset,
 		    __entry->call_serial = call->rx_serial;
 		    __entry->conn_serial = call->conn->hi_serial;
 		    __entry->tx_seq = call->tx_hard_ack;
-		    __entry->rx_seq = call->ackr_seen;
+		    __entry->rx_seq = call->rx_hard_ack;
 			   ),
 
 	    TP_printk("c=%08x %08x:%08x r=%08x/%08x tx=%08x rx=%08x",
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ed88552c237c..ccb65412b670 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -663,8 +663,8 @@ struct rxrpc_call {
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
 	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
-	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
-	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
+	atomic_t		ackr_nr_unacked; /* Number of unacked packets */
+	atomic_t		ackr_nr_consumed; /* Number of packets needing hard ACK */
 
 	/* RTT management */
 	rxrpc_serial_t		rtt_serial[4];	/* Serial number of DATA or PING sent */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 2e61545ad8ca..1145cb14d86f 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -412,8 +412,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
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
@@ -569,6 +569,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			sp = NULL;
 		}
 
+		nr_unacked++;
+
 		if (last) {
 			set_bit(RXRPC_CALL_RX_LAST, &call->flags);
 			if (!ack) {
@@ -588,9 +590,14 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
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
index 46aae9b7006f..9683617db704 100644
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
@@ -223,6 +230,10 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	n = rxrpc_fill_out_ack(conn, call, pkt, &hard_ack, &top, reason);
 
 	spin_unlock_bh(&call->lock);
+	if (n == 0) {
+		kfree(pkt);
+		return 0;
+	}
 
 	iov[0].iov_base	= pkt;
 	iov[0].iov_len	= sizeof(pkt->whdr) + sizeof(pkt->ack) + n;
@@ -259,13 +270,6 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
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
index 2c842851d72e..787826773937 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -260,11 +260,9 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
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



