Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FE8664907
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbjAJSRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbjAJSQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5532840859
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6E6761852
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD13C433EF;
        Tue, 10 Jan 2023 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374495;
        bh=I55RRaJo8CB8Gsjw4Snwb+ITZ5sv/GfIsVsT52D0O5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU9xNfLJfQ2+lGRmx9zBxX0EZ1SArAY0knEA7Z+/kYexPX9Pi4rlu31rUg32L0Cg3
         O+5O2RmY8U6gPrZptlFkixjzE0dfl9jJGp0DXq3ibrDtNgiJpA7LwyukqUUrapWl5a
         RLTswJW6znDvp76XNv1oeEmwiHFUXSTzH4RgVubQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/159] mptcp: fix lockdep false positive
Date:   Tue, 10 Jan 2023 19:02:51 +0100
Message-Id: <20230110180019.045496259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit fec3adfd754ccc99a7230e8ab9f105b65fb07bcc ]

MattB reported a lockdep splat in the mptcp listener code cleanup:

 WARNING: possible circular locking dependency detected
 packetdrill/14278 is trying to acquire lock:
 ffff888017d868f0 ((work_completion)(&msk->work)){+.+.}-{0:0}, at: __flush_work (kernel/workqueue.c:3069)

 but task is already holding lock:
 ffff888017d84130 (sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close (net/mptcp/protocol.c:2973)

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (sk_lock-AF_INET){+.+.}-{0:0}:
        __lock_acquire (kernel/locking/lockdep.c:5055)
        lock_acquire (kernel/locking/lockdep.c:466)
        lock_sock_nested (net/core/sock.c:3463)
        mptcp_worker (net/mptcp/protocol.c:2614)
        process_one_work (kernel/workqueue.c:2294)
        worker_thread (include/linux/list.h:292)
        kthread (kernel/kthread.c:376)
        ret_from_fork (arch/x86/entry/entry_64.S:312)

 -> #0 ((work_completion)(&msk->work)){+.+.}-{0:0}:
        check_prev_add (kernel/locking/lockdep.c:3098)
        validate_chain (kernel/locking/lockdep.c:3217)
        __lock_acquire (kernel/locking/lockdep.c:5055)
        lock_acquire (kernel/locking/lockdep.c:466)
        __flush_work (kernel/workqueue.c:3070)
        __cancel_work_timer (kernel/workqueue.c:3160)
        mptcp_cancel_work (net/mptcp/protocol.c:2758)
        mptcp_subflow_queue_clean (net/mptcp/subflow.c:1817)
        __mptcp_close_ssk (net/mptcp/protocol.c:2363)
        mptcp_destroy_common (net/mptcp/protocol.c:3170)
        mptcp_destroy (include/net/sock.h:1495)
        __mptcp_destroy_sock (net/mptcp/protocol.c:2886)
        __mptcp_close (net/mptcp/protocol.c:2959)
        mptcp_close (net/mptcp/protocol.c:2974)
        inet_release (net/ipv4/af_inet.c:432)
        __sock_release (net/socket.c:651)
        sock_close (net/socket.c:1367)
        __fput (fs/file_table.c:320)
        task_work_run (kernel/task_work.c:181 (discriminator 1))
        exit_to_user_mode_prepare (include/linux/resume_user_mode.h:49)
        syscall_exit_to_user_mode (kernel/entry/common.c:130)
        do_syscall_64 (arch/x86/entry/common.c:87)
        entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(sk_lock-AF_INET);
                                lock((work_completion)(&msk->work));
                                lock(sk_lock-AF_INET);
   lock((work_completion)(&msk->work));

  *** DEADLOCK ***

The report is actually a false positive, since the only existing lock
nesting is the msk socket lock acquired by the mptcp work.
cancel_work_sync() is invoked without the relevant socket lock being
held, but under a different (the msk listener) socket lock.

We could silence the splat adding a per workqueue dynamic lockdep key,
but that looks overkill. Instead just tell lockdep the msk socket lock
is not held around cancel_work_sync().

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/322
Fixes: 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c |  2 +-
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  | 19 +++++++++++++++++--
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e64ea2ca1c7a..e97465f0c667 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2371,7 +2371,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
 		if (ssk->sk_state == TCP_LISTEN) {
 			tcp_set_state(ssk, TCP_CLOSE);
-			mptcp_subflow_queue_clean(ssk);
+			mptcp_subflow_queue_clean(sk, ssk);
 			inet_csk_listen_stop(ssk);
 		}
 		__tcp_close(ssk, 0);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 380bddbc52d4..62e9ff237b6e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -614,7 +614,7 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
-void mptcp_subflow_queue_clean(struct sock *ssk);
+void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 613f515fedf0..9d3701fdb293 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1733,7 +1733,7 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
-void mptcp_subflow_queue_clean(struct sock *listener_ssk)
+void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
 {
 	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
 	struct mptcp_sock *msk, *next, *head = NULL;
@@ -1782,8 +1782,23 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
 
 		do_cancel_work = __mptcp_close(sk, 0);
 		release_sock(sk);
-		if (do_cancel_work)
+		if (do_cancel_work) {
+			/* lockdep will report a false positive ABBA deadlock
+			 * between cancel_work_sync and the listener socket.
+			 * The involved locks belong to different sockets WRT
+			 * the existing AB chain.
+			 * Using a per socket key is problematic as key
+			 * deregistration requires process context and must be
+			 * performed at socket disposal time, in atomic
+			 * context.
+			 * Just tell lockdep to consider the listener socket
+			 * released here.
+			 */
+			mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
 			mptcp_cancel_work(sk);
+			mutex_acquire(&listener_sk->sk_lock.dep_map,
+				      SINGLE_DEPTH_NESTING, 0, _RET_IP_);
+		}
 		sock_put(sk);
 	}
 
-- 
2.35.1



