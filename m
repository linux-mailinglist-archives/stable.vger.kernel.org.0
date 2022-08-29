Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8CF5A48BB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiH2LPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiH2LNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:13:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0581425CA;
        Mon, 29 Aug 2022 04:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 409B6B80F62;
        Mon, 29 Aug 2022 11:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D89C433D7;
        Mon, 29 Aug 2022 11:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771388;
        bh=svBdi+3+7U53TCPK9t5UPWQQBfSRiYx6w+u5LCNu/Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzu29qIsDOCCPS1SuZnDCPTcfZbInXFcyaLjdFik50RZ+BSpEWAk1X8XjxNF2ShOX
         s7pQe24vSVud7HVeNsgHWkXIf6Un0SDhmFJanq21PitywPHDiCAKSMS7jntA2qXbRu
         +IbBAmtYa48uH4rklJPlfCEE5dcwIfDQlP/sR33w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        Khalid Masum <khalid.masum.92@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-afs@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/86] rxrpc: Fix locking in rxrpcs sendmsg
Date:   Mon, 29 Aug 2022 12:59:28 +0200
Message-Id: <20220829105759.101683873@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit b0f571ecd7943423c25947439045f0d352ca3dbf ]

Fix three bugs in the rxrpc's sendmsg implementation:

 (1) rxrpc_new_client_call() should release the socket lock when returning
     an error from rxrpc_get_call_slot().

 (2) rxrpc_wait_for_tx_window_intr() will return without the call mutex
     held in the event that we're interrupted by a signal whilst waiting
     for tx space on the socket or relocking the call mutex afterwards.

     Fix this by: (a) moving the unlock/lock of the call mutex up to
     rxrpc_send_data() such that the lock is not held around all of
     rxrpc_wait_for_tx_window*() and (b) indicating to higher callers
     whether we're return with the lock dropped.  Note that this means
     recvmsg() will not block on this call whilst we're waiting.

 (3) After dropping and regaining the call mutex, rxrpc_send_data() needs
     to go and recheck the state of the tx_pending buffer and the
     tx_total_len check in case we raced with another sendmsg() on the same
     call.

Thinking on this some more, it might make sense to have different locks for
sendmsg() and recvmsg().  There's probably no need to make recvmsg() wait
for sendmsg().  It does mean that recvmsg() can return MSG_EOR indicating
that a call is dead before a sendmsg() to that call returns - but that can
currently happen anyway.

Without fix (2), something like the following can be induced:

	WARNING: bad unlock balance detected!
	5.16.0-rc6-syzkaller #0 Not tainted
	-------------------------------------
	syz-executor011/3597 is trying to release lock (&call->user_mutex) at:
	[<ffffffff885163a3>] rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendmsg.c:748
	but there are no more locks to release!

	other info that might help us debug this:
	no locks held by syz-executor011/3597.
	...
	Call Trace:
	 <TASK>
	 __dump_stack lib/dump_stack.c:88 [inline]
	 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
	 print_unlock_imbalance_bug include/trace/events/lock.h:58 [inline]
	 __lock_release kernel/locking/lockdep.c:5306 [inline]
	 lock_release.cold+0x49/0x4e kernel/locking/lockdep.c:5657
	 __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:900
	 rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendmsg.c:748
	 rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:561
	 sock_sendmsg_nosec net/socket.c:704 [inline]
	 sock_sendmsg+0xcf/0x120 net/socket.c:724
	 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
	 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
	 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
	 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
	 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
	 entry_SYSCALL_64_after_hwframe+0x44/0xae

[Thanks to Hawkins Jiawei and Khalid Masum for their attempts to fix this]

Fixes: bc5e3a546d55 ("rxrpc: Use MSG_WAITALL to tell sendmsg() to temporarily ignore signals")
Reported-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com
cc: Hawkins Jiawei <yin31149@gmail.com>
cc: Khalid Masum <khalid.masum.92@gmail.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/166135894583.600315.7170979436768124075.stgit@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_object.c |  4 +-
 net/rxrpc/sendmsg.c     | 92 ++++++++++++++++++++++++-----------------
 2 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 043508fd8d8a5..150cd7b2154c8 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -285,8 +285,10 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	_enter("%p,%lx", rx, p->user_call_ID);
 
 	limiter = rxrpc_get_call_slot(p, gfp);
-	if (!limiter)
+	if (!limiter) {
+		release_sock(&rx->sk);
 		return ERR_PTR(-ERESTARTSYS);
+	}
 
 	call = rxrpc_alloc_client_call(rx, srx, gfp, debug_id);
 	if (IS_ERR(call)) {
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index aa23ba4e25662..eef3c14fd1c18 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -51,10 +51,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 			return sock_intr_errno(*timeo);
 
 		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
-		mutex_unlock(&call->user_mutex);
 		*timeo = schedule_timeout(*timeo);
-		if (mutex_lock_interruptible(&call->user_mutex) < 0)
-			return sock_intr_errno(*timeo);
 	}
 }
 
@@ -290,37 +287,48 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx)
+			   rxrpc_notify_end_tx_t notify_end_tx,
+			   bool *_dropped_lock)
 {
 	struct rxrpc_skb_priv *sp;
 	struct sk_buff *skb;
 	struct sock *sk = &rx->sk;
+	enum rxrpc_call_state state;
 	long timeo;
-	bool more;
-	int ret, copied;
+	bool more = msg->msg_flags & MSG_MORE;
+	int ret, copied = 0;
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
 	/* this should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
+reload:
+	ret = -EPIPE;
 	if (sk->sk_shutdown & SEND_SHUTDOWN)
-		return -EPIPE;
-
-	more = msg->msg_flags & MSG_MORE;
-
+		goto maybe_error;
+	state = READ_ONCE(call->state);
+	ret = -ESHUTDOWN;
+	if (state >= RXRPC_CALL_COMPLETE)
+		goto maybe_error;
+	ret = -EPROTO;
+	if (state != RXRPC_CALL_CLIENT_SEND_REQUEST &&
+	    state != RXRPC_CALL_SERVER_ACK_REQUEST &&
+	    state != RXRPC_CALL_SERVER_SEND_REPLY)
+		goto maybe_error;
+
+	ret = -EMSGSIZE;
 	if (call->tx_total_len != -1) {
-		if (len > call->tx_total_len)
-			return -EMSGSIZE;
-		if (!more && len != call->tx_total_len)
-			return -EMSGSIZE;
+		if (len - copied > call->tx_total_len)
+			goto maybe_error;
+		if (!more && len - copied != call->tx_total_len)
+			goto maybe_error;
 	}
 
 	skb = call->tx_pending;
 	call->tx_pending = NULL;
 	rxrpc_see_skb(skb, rxrpc_skb_seen);
 
-	copied = 0;
 	do {
 		/* Check to see if there's a ping ACK to reply to. */
 		if (call->ackr_reason == RXRPC_ACK_PING_RESPONSE)
@@ -331,16 +339,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			_debug("alloc");
 
-			if (!rxrpc_check_tx_space(call, NULL)) {
-				ret = -EAGAIN;
-				if (msg->msg_flags & MSG_DONTWAIT)
-					goto maybe_error;
-				ret = rxrpc_wait_for_tx_window(rx, call,
-							       &timeo,
-							       msg->msg_flags & MSG_WAITALL);
-				if (ret < 0)
-					goto maybe_error;
-			}
+			if (!rxrpc_check_tx_space(call, NULL))
+				goto wait_for_space;
 
 			max = RXRPC_JUMBO_DATALEN;
 			max -= call->conn->security_size;
@@ -485,6 +485,27 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 efault:
 	ret = -EFAULT;
 	goto out;
+
+wait_for_space:
+	ret = -EAGAIN;
+	if (msg->msg_flags & MSG_DONTWAIT)
+		goto maybe_error;
+	mutex_unlock(&call->user_mutex);
+	*_dropped_lock = true;
+	ret = rxrpc_wait_for_tx_window(rx, call, &timeo,
+				       msg->msg_flags & MSG_WAITALL);
+	if (ret < 0)
+		goto maybe_error;
+	if (call->interruptibility == RXRPC_INTERRUPTIBLE) {
+		if (mutex_lock_interruptible(&call->user_mutex) < 0) {
+			ret = sock_intr_errno(timeo);
+			goto maybe_error;
+		}
+	} else {
+		mutex_lock(&call->user_mutex);
+	}
+	*_dropped_lock = false;
+	goto reload;
 }
 
 /*
@@ -646,6 +667,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	enum rxrpc_call_state state;
 	struct rxrpc_call *call;
 	unsigned long now, j;
+	bool dropped_lock = false;
 	int ret;
 
 	struct rxrpc_send_params p = {
@@ -754,21 +776,13 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 			ret = rxrpc_send_abort_packet(call);
 	} else if (p.command != RXRPC_CMD_SEND_DATA) {
 		ret = -EINVAL;
-	} else if (rxrpc_is_client_call(call) &&
-		   state != RXRPC_CALL_CLIENT_SEND_REQUEST) {
-		/* request phase complete for this client call */
-		ret = -EPROTO;
-	} else if (rxrpc_is_service_call(call) &&
-		   state != RXRPC_CALL_SERVER_ACK_REQUEST &&
-		   state != RXRPC_CALL_SERVER_SEND_REPLY) {
-		/* Reply phase not begun or not complete for service call. */
-		ret = -EPROTO;
 	} else {
-		ret = rxrpc_send_data(rx, call, msg, len, NULL);
+		ret = rxrpc_send_data(rx, call, msg, len, NULL, &dropped_lock);
 	}
 
 out_put_unlock:
-	mutex_unlock(&call->user_mutex);
+	if (!dropped_lock)
+		mutex_unlock(&call->user_mutex);
 error_put:
 	rxrpc_put_call(call, rxrpc_call_put);
 	_leave(" = %d", ret);
@@ -796,6 +810,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
 			   rxrpc_notify_end_tx_t notify_end_tx)
 {
+	bool dropped_lock = false;
 	int ret;
 
 	_enter("{%d,%s},", call->debug_id, rxrpc_call_states[call->state]);
@@ -813,7 +828,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 	case RXRPC_CALL_SERVER_SEND_REPLY:
 		ret = rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-				      notify_end_tx);
+				      notify_end_tx, &dropped_lock);
 		break;
 	case RXRPC_CALL_COMPLETE:
 		read_lock_bh(&call->state_lock);
@@ -827,7 +842,8 @@ int rxrpc_kernel_send_data(struct socket *sock, struct rxrpc_call *call,
 		break;
 	}
 
-	mutex_unlock(&call->user_mutex);
+	if (!dropped_lock)
+		mutex_unlock(&call->user_mutex);
 	_leave(" = %d", ret);
 	return ret;
 }
-- 
2.35.1



