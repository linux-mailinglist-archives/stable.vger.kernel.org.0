Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493301991DF
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgCaJIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730982AbgCaJIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:08:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D612137B;
        Tue, 31 Mar 2020 09:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645681;
        bh=0wveDMe7uyg5AfVuGN/w8XtmkVLcDHD92wtygOJaXvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO5ZQ+RiHzo/N39oDgzlGi15iIA1fNYIUJLpiF8n2vTtBbDj0xGOLRKwWUEddqUXk
         uNayHi8VorXxy/BIqA3bBWLNZfmY4PjenKKW3TVrhkn8XLsIV2RIvj2jpiLCHtaYPG
         nKR8S70y4MjC2Doj20txVnuFEcwroYzKmn29d5tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.5 130/170] afs: Fix client call Rx-phase signal handling
Date:   Tue, 31 Mar 2020 10:59:04 +0200
Message-Id: <20200331085437.532150385@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 7d7587db0d7fd1138f2afcffdc46a8e15630b944 upstream.

Fix the handling of signals in client rxrpc calls made by the afs
filesystem.  Ignore signals completely, leaving call abandonment or
connection loss to be detected by timeouts inside AF_RXRPC.

Allowing a filesystem call to be interrupted after the entire request has
been transmitted and an abort sent means that the server may or may not
have done the action - and we don't know.  It may even be worse than that
for older servers.

Fixes: bc5e3a546d55 ("rxrpc: Use MSG_WAITALL to tell sendmsg() to temporarily ignore signals")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/rxrpc.c          |   34 ++--------------------------------
 include/net/af_rxrpc.h  |    4 +---
 net/rxrpc/af_rxrpc.c    |   33 +++------------------------------
 net/rxrpc/ar-internal.h |    1 -
 net/rxrpc/input.c       |    1 -
 5 files changed, 6 insertions(+), 67 deletions(-)

--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -603,11 +603,7 @@ call_complete:
 long afs_wait_for_call_to_complete(struct afs_call *call,
 				   struct afs_addr_cursor *ac)
 {
-	signed long rtt2, timeout;
 	long ret;
-	bool stalled = false;
-	u64 rtt;
-	u32 life, last_life;
 	bool rxrpc_complete = false;
 
 	DECLARE_WAITQUEUE(myself, current);
@@ -618,14 +614,6 @@ long afs_wait_for_call_to_complete(struc
 	if (ret < 0)
 		goto out;
 
-	rtt = rxrpc_kernel_get_rtt(call->net->socket, call->rxcall);
-	rtt2 = nsecs_to_jiffies64(rtt) * 2;
-	if (rtt2 < 2)
-		rtt2 = 2;
-
-	timeout = rtt2;
-	rxrpc_kernel_check_life(call->net->socket, call->rxcall, &last_life);
-
 	add_wait_queue(&call->waitq, &myself);
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -636,37 +624,19 @@ long afs_wait_for_call_to_complete(struc
 			call->need_attention = false;
 			__set_current_state(TASK_RUNNING);
 			afs_deliver_to_call(call);
-			timeout = rtt2;
 			continue;
 		}
 
 		if (afs_check_call_state(call, AFS_CALL_COMPLETE))
 			break;
 
-		if (!rxrpc_kernel_check_life(call->net->socket, call->rxcall, &life)) {
+		if (!rxrpc_kernel_check_life(call->net->socket, call->rxcall)) {
 			/* rxrpc terminated the call. */
 			rxrpc_complete = true;
 			break;
 		}
 
-		if (call->intr && timeout == 0 &&
-		    life == last_life && signal_pending(current)) {
-			if (stalled)
-				break;
-			__set_current_state(TASK_RUNNING);
-			rxrpc_kernel_probe_life(call->net->socket, call->rxcall);
-			timeout = rtt2;
-			stalled = true;
-			continue;
-		}
-
-		if (life != last_life) {
-			timeout = rtt2;
-			last_life = life;
-			stalled = false;
-		}
-
-		timeout = schedule_timeout(timeout);
+		schedule();
 	}
 
 	remove_wait_queue(&call->waitq, &myself);
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -58,9 +58,7 @@ int rxrpc_kernel_charge_accept(struct so
 			       rxrpc_user_attach_call_t, unsigned long, gfp_t,
 			       unsigned int);
 void rxrpc_kernel_set_tx_length(struct socket *, struct rxrpc_call *, s64);
-bool rxrpc_kernel_check_life(const struct socket *, const struct rxrpc_call *,
-			     u32 *);
-void rxrpc_kernel_probe_life(struct socket *, struct rxrpc_call *);
+bool rxrpc_kernel_check_life(const struct socket *, const struct rxrpc_call *);
 u32 rxrpc_kernel_get_epoch(struct socket *, struct rxrpc_call *);
 bool rxrpc_kernel_get_reply_time(struct socket *, struct rxrpc_call *,
 				 ktime_t *);
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -371,45 +371,18 @@ EXPORT_SYMBOL(rxrpc_kernel_end_call);
  * rxrpc_kernel_check_life - Check to see whether a call is still alive
  * @sock: The socket the call is on
  * @call: The call to check
- * @_life: Where to store the life value
  *
- * Allow a kernel service to find out whether a call is still alive - ie. we're
- * getting ACKs from the server.  Passes back in *_life a number representing
- * the life state which can be compared to that returned by a previous call and
- * return true if the call is still alive.
- *
- * If the life state stalls, rxrpc_kernel_probe_life() should be called and
- * then 2RTT waited.
+ * Allow a kernel service to find out whether a call is still alive -
+ * ie. whether it has completed.
  */
 bool rxrpc_kernel_check_life(const struct socket *sock,
-			     const struct rxrpc_call *call,
-			     u32 *_life)
+			     const struct rxrpc_call *call)
 {
-	*_life = call->acks_latest;
 	return call->state != RXRPC_CALL_COMPLETE;
 }
 EXPORT_SYMBOL(rxrpc_kernel_check_life);
 
 /**
- * rxrpc_kernel_probe_life - Poke the peer to see if it's still alive
- * @sock: The socket the call is on
- * @call: The call to check
- *
- * In conjunction with rxrpc_kernel_check_life(), allow a kernel service to
- * find out whether a call is still alive by pinging it.  This should cause the
- * life state to be bumped in about 2*RTT.
- *
- * The must be called in TASK_RUNNING state on pain of might_sleep() objecting.
- */
-void rxrpc_kernel_probe_life(struct socket *sock, struct rxrpc_call *call)
-{
-	rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, false,
-			  rxrpc_propose_ack_ping_for_check_life);
-	rxrpc_send_ack_packet(call, true, NULL);
-}
-EXPORT_SYMBOL(rxrpc_kernel_probe_life);
-
-/**
  * rxrpc_kernel_get_epoch - Retrieve the epoch value from a call.
  * @sock: The socket the call is on
  * @call: The call to query
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -675,7 +675,6 @@ struct rxrpc_call {
 
 	/* transmission-phase ACK management */
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
-	rxrpc_serial_t		acks_latest;	/* serial number of latest ACK received */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -882,7 +882,6 @@ static void rxrpc_input_ack(struct rxrpc
 	    before(prev_pkt, call->ackr_prev_seq))
 		goto out;
 	call->acks_latest_ts = skb->tstamp;
-	call->acks_latest = sp->hdr.serial;
 
 	call->ackr_first_seq = first_soft_ack;
 	call->ackr_prev_seq = prev_pkt;


