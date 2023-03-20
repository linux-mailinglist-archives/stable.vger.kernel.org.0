Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5836C0FB9
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCTKwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCTKv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:51:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E240F0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CDF1B80DF3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DE0C4339B;
        Mon, 20 Mar 2023 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679309313;
        bh=p63MWvLj1HI/mn1suZqAoA1bT5rQWZ0IYzZ7d2cFe90=;
        h=Subject:To:Cc:From:Date:From;
        b=oGbukBbzrHdrmotSz+FysKsnApR0isVkLEh3pu2pw4up+YvEF9nGKO5zNAtbmXVje
         6lj04PBf6ZL/N9mYfsDQM2DwURLgitf72F4tI/yEwpbjtamiYQ6qNFaXcydnoA07mi
         t6W5ffl4LWluFwf1e5EJqjIUFZN2YmXjBzoDznGM=
Subject: FAILED: patch "[PATCH] mptcp: fix UaF in listener shutdown" failed to apply to 6.1-stable tree
To:     pabeni@redhat.com, cpaasch@apple.com, kuba@kernel.org,
        matthieu.baerts@tessares.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:48:30 +0100
Message-ID: <167930931021437@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 0a3f4f1f9c27215e4ddcd312558342e57b93e518
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167930931021437@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

0a3f4f1f9c27 ("mptcp: fix UaF in listener shutdown")
b6985b9b8295 ("mptcp: use the workqueue to destroy unaccepted sockets")
fec3adfd754c ("mptcp: fix lockdep false positive")
7d803344fdc3 ("mptcp: fix deadlock in fastopen error path")
f8c9dfbd875b ("mptcp: add pm listener events")
f2bb566f5c97 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0a3f4f1f9c27215e4ddcd312558342e57b93e518 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 9 Mar 2023 15:50:00 +0100
Subject: [PATCH] mptcp: fix UaF in listener shutdown

As reported by Christoph after having refactored the passive
socket initialization, the mptcp listener shutdown path is prone
to an UaF issue.

  BUG: KASAN: use-after-free in _raw_spin_lock_bh+0x73/0xe0
  Write of size 4 at addr ffff88810cb23098 by task syz-executor731/1266

  CPU: 1 PID: 1266 Comm: syz-executor731 Not tainted 6.2.0-rc59af4eaa31c1f6c00c8f1e448ed99a45c66340dd5 #6
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6e/0x91
   print_report+0x16a/0x46f
   kasan_report+0xad/0x130
   kasan_check_range+0x14a/0x1a0
   _raw_spin_lock_bh+0x73/0xe0
   subflow_error_report+0x6d/0x110
   sk_error_report+0x3b/0x190
   tcp_disconnect+0x138c/0x1aa0
   inet_child_forget+0x6f/0x2e0
   inet_csk_listen_stop+0x209/0x1060
   __mptcp_close_ssk+0x52d/0x610
   mptcp_destroy_common+0x165/0x640
   mptcp_destroy+0x13/0x80
   __mptcp_destroy_sock+0xe7/0x270
   __mptcp_close+0x70e/0x9b0
   mptcp_close+0x2b/0x150
   inet_release+0xe9/0x1f0
   __sock_release+0xd2/0x280
   sock_close+0x15/0x20
   __fput+0x252/0xa20
   task_work_run+0x169/0x250
   exit_to_user_mode_prepare+0x113/0x120
   syscall_exit_to_user_mode+0x1d/0x40
   do_syscall_64+0x48/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

The msk grace period can legitly expire in between the last
reference count dropped in mptcp_subflow_queue_clean() and
the later eventual access in inet_csk_listen_stop()

After the previous patch we don't need anymore special-casing
msk listener socket cleanup: the mptcp worker will process each
of the unaccepted msk sockets.

Just drop the now unnecessary code.

Please note this commit depends on the two parent ones:

  mptcp: refactor passive socket initialization
  mptcp: use the workqueue to destroy unaccepted sockets

Fixes: 6aeed9045071 ("mptcp: fix race on unaccepted mptcp sockets")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/346
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2a2093d61835..60b23b2716c4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2365,12 +2365,9 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
-		if (ssk->sk_state == TCP_LISTEN) {
-			tcp_set_state(ssk, TCP_CLOSE);
-			mptcp_subflow_queue_clean(sk, ssk);
-			inet_csk_listen_stop(ssk);
+		if (ssk->sk_state == TCP_LISTEN)
 			mptcp_event_pm_listener(ssk, MPTCP_EVENT_LISTENER_CLOSED);
-		}
+
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3a2db1b862dd..339a6f072989 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -629,7 +629,6 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
-void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 932a3e0eb22d..9c57575df84c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1826,78 +1826,6 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
-void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
-{
-	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
-	struct mptcp_sock *msk, *next, *head = NULL;
-	struct request_sock *req;
-
-	/* build a list of all unaccepted mptcp sockets */
-	spin_lock_bh(&queue->rskq_lock);
-	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
-		struct mptcp_subflow_context *subflow;
-		struct sock *ssk = req->sk;
-		struct mptcp_sock *msk;
-
-		if (!sk_is_mptcp(ssk))
-			continue;
-
-		subflow = mptcp_subflow_ctx(ssk);
-		if (!subflow || !subflow->conn)
-			continue;
-
-		/* skip if already in list */
-		msk = mptcp_sk(subflow->conn);
-		if (msk->dl_next || msk == head)
-			continue;
-
-		msk->dl_next = head;
-		head = msk;
-	}
-	spin_unlock_bh(&queue->rskq_lock);
-	if (!head)
-		return;
-
-	/* can't acquire the msk socket lock under the subflow one,
-	 * or will cause ABBA deadlock
-	 */
-	release_sock(listener_ssk);
-
-	for (msk = head; msk; msk = next) {
-		struct sock *sk = (struct sock *)msk;
-		bool do_cancel_work;
-
-		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
-		next = msk->dl_next;
-		msk->first = NULL;
-		msk->dl_next = NULL;
-
-		do_cancel_work = __mptcp_close(sk, 0);
-		release_sock(sk);
-		if (do_cancel_work) {
-			/* lockdep will report a false positive ABBA deadlock
-			 * between cancel_work_sync and the listener socket.
-			 * The involved locks belong to different sockets WRT
-			 * the existing AB chain.
-			 * Using a per socket key is problematic as key
-			 * deregistration requires process context and must be
-			 * performed at socket disposal time, in atomic
-			 * context.
-			 * Just tell lockdep to consider the listener socket
-			 * released here.
-			 */
-			mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
-			mptcp_cancel_work(sk);
-			mutex_acquire(&listener_sk->sk_lock.dep_map,
-				      SINGLE_DEPTH_NESTING, 0, _RET_IP_);
-		}
-		sock_put(sk);
-	}
-
-	/* we are still under the listener msk socket lock */
-	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
-}
-
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);

