Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37B6C6FA8
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 18:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCWRtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 13:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCWRtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 13:49:14 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561DB234F7
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:49:12 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i9so21491072wrp.3
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679593750;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1BfWN3A1Bobar20T0OZnQswEN0+I8HQeY/5/OI19JVI=;
        b=Hg+LytVXsDCO6+hqd/bMD5vjQyRfbCg1veZnII0Aabyo0aelfba1CiNvMYYWN/baRk
         HrWdyheAYRsH7r6ED3sp5MQfP83+lHzXtr+tBg21lRudQZERamG+46SGrxPL7DIquyw0
         edX1NtlKHgSMTh+sQK1+arrjJQrOtOR9LJ3WwbAoxizCjh6i3tT7/264KH8bT85NUm67
         qOuBXKGS1MpYLF1kmYAtj+RkYWqON5vi+tvbitlD61GcVGmQ4TpuPYVBNelV+OYImURC
         ZnKdsLcgOPTRhQ/lBAcRt5VKfPMS3Y1EqALfSv9NQj44pbvqAuh4fFK5CR5UCUNz9P1q
         5xEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679593750;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1BfWN3A1Bobar20T0OZnQswEN0+I8HQeY/5/OI19JVI=;
        b=qv+9AEmw7Qr50/88SpornFdWO6qpwodBM0fG3NrkOBKWorlDhYFTcHIEypEjHqO8GD
         RRBLvoprtunYcwjqkV5f03xHM4zmCbc842Vf5iEeetg3CXvR1ElqrWMsRpdZtMDmXSxH
         XRmsxFfJ2bY/dLeB/tU/vpOxYmCrQs1bz20VSCJyUQV1jyGoLnE3FJy7S+9xH/RVyWFw
         Wzi4bZfGihd7cEnMWXKpLssQMYr2SZkNMEUsvtk3aRrz141cDl1nLJnCzGuAckZkMbeR
         rvZTQqx8LXLiZ5hHbfqoWfvBKnZWFE6bvQyxFnvs9xose4VT6QYDgqAoXBiSAf0awhwJ
         B2Lg==
X-Gm-Message-State: AAQBX9fisC83WpyV0iOTMH9gcgqye/OctEUKwiFkjX7eHGURyY7xvcEX
        DLhdmaxb/BH3N5fnWq9+kPIpogIr0sJfrmhNKf2tpIwa
X-Google-Smtp-Source: AKy350a5bp740Xdu6DKGbuipFyN+zhVN40OVBY80otZQCprQrgh1+4ZLOJ4AKM4wKZX0ecyvPtbhQg==
X-Received: by 2002:adf:e44f:0:b0:2cf:eb86:bd90 with SMTP id t15-20020adfe44f000000b002cfeb86bd90mr4137wrm.63.1679593750437;
        Thu, 23 Mar 2023 10:49:10 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id a10-20020a056000050a00b002d78a96cf5fsm9534483wrf.70.2023.03.23.10.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:49:10 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 23 Mar 2023 18:49:01 +0100
Subject: [PATCH 6.1 1/2] mptcp: use the workqueue to destroy unaccepted
 sockets
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230323-upstream-stable-conflicts-6-1-v1-1-ef2a6180eaf3@tessares.net>
References: <20230323-upstream-stable-conflicts-6-1-v1-0-ef2a6180eaf3@tessares.net>
In-Reply-To: <20230323-upstream-stable-conflicts-6-1-v1-0-ef2a6180eaf3@tessares.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        Jakub Kicinski <kuba@kernel.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9711;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=zQHyjtXMq8YhMlfgF3RNcLViKWuLafHBG0HJH+4fWWo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHJEUKZYLu+OeK6GbaFSE55UmRp8NHskJzISt9
 Yqevs5Q+eOJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZByRFAAKCRD2t4JPQmmg
 c68wEACToolarCWWGqcBZEsVHd8o/L6M+8HvXv3Bgo6c6K2jqhsU1IkJhF0pvlpdK4RAcp4pOc7
 kglI+IYd2lG2yntxQl6ELCu1IjhoETUblPjk2LAELeYUBGow/rJ9vDyigeM0nERlOJ7UI4OuI88
 nifW3lT1GTMLhyfrmqjg2ubRueo+5QKsnahOOkDapfq7uwnU0Pguu1SDQ3ATEqYEX3bSFcuglBS
 4yRZINOvIIwZD6QBJMqKha6udJN6WfB2Y/Akbimbp9PpXTtDSWrJRypARJqsxLU8TDh0lC5SeQP
 FEbBUX0rdneJQkVsyQrVaZAsdM/ZRWzqsosA+CHfYC8qdJolEVIsLm2lbok+eJh7Cg1Wyd2np+i
 nFPOCSdNx78/1KP3Bk0q138r7pByHab+zZIi79Mn0SF7WF4fJvUSX1nM57XRusZMiZdMHjMoV+4
 WPJ1o5oAuctWHk5TvJo4aRVYEdBAwFoa4SM6ZHrMMBIWHwqPaWjiVXOlYycXm6UMSyal1AloaB2
 gca9uApyNoOXmtD0vgRlhDo0dq0Z1fWaMPk1gey2t1dHwB+Sbqq7W3gpQndVo0zCY+/p2Sskc9y
 ZGLSvhMLopYo0gU0Yp2gOfib+0MXHG8jKR/BWwudvNEIigObMecTB1C2uL2xmZOHZyy3UCxOPQn
 nfaTZf3RggN3s8A==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit b6985b9b82954caa53f862d6059d06c0526254f0 ]

  Backports notes: one simple conflict in net/mptcp/protocol.c with:

    commit a5ef058dc4d9 ("net: introduce and use custom sockopt socket flag")

  Where the two commits add a new line for different actions in the same
  context in mptcp_stream_accept().

Christoph reported a UaF at token lookup time after having
refactored the passive socket initialization part:

  BUG: KASAN: use-after-free in __token_bucket_busy+0x253/0x260
  Read of size 4 at addr ffff88810698d5b0 by task syz-executor653/3198

  CPU: 1 PID: 3198 Comm: syz-executor653 Not tainted 6.2.0-rc59af4eaa31c1f6c00c8f1e448ed99a45c66340dd5 #6
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6e/0x91
   print_report+0x16a/0x46f
   kasan_report+0xad/0x130
   __token_bucket_busy+0x253/0x260
   mptcp_token_new_connect+0x13d/0x490
   mptcp_connect+0x4ed/0x860
   __inet_stream_connect+0x80e/0xd90
   tcp_sendmsg_fastopen+0x3ce/0x710
   mptcp_sendmsg+0xff1/0x1a20
   inet_sendmsg+0x11d/0x140
   __sys_sendto+0x405/0x490
   __x64_sys_sendto+0xdc/0x1b0
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

We need to properly clean-up all the paired MPTCP-level
resources and be sure to release the msk last, even when
the unaccepted subflow is destroyed by the TCP internals
via inet_child_forget().

We can re-use the existing MPTCP_WORK_CLOSE_SUBFLOW infra,
explicitly checking that for the critical scenario: the
closed subflow is the MPC one, the msk is not accepted and
eventually going through full cleanup.

With such change, __mptcp_destroy_sock() is always called
on msk sockets, even on accepted ones. We don't need anymore
to transiently drop one sk reference at msk clone time.

Please note this commit depends on the parent one:

  mptcp: refactor passive socket initialization

Fixes: 58b09919626b ("mptcp: create msk early")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/347
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 41 +++++++++++++++++++++++++++++++----------
 net/mptcp/protocol.h |  5 ++++-
 net/mptcp/subflow.c  | 17 ++++++++++++-----
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 777f795246ed..b679e8a430a8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2357,7 +2357,6 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		goto out;
 	}
 
-	sock_orphan(ssk);
 	subflow->disposable = 1;
 
 	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
@@ -2365,7 +2364,20 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	 * reference owned by msk;
 	 */
 	if (!inet_csk(ssk)->icsk_ulp_ops) {
+		WARN_ON_ONCE(!sock_flag(ssk, SOCK_DEAD));
 		kfree_rcu(subflow, rcu);
+	} else if (msk->in_accept_queue && msk->first == ssk) {
+		/* if the first subflow moved to a close state, e.g. due to
+		 * incoming reset and we reach here before inet_child_forget()
+		 * the TCP stack could later try to close it via
+		 * inet_csk_listen_stop(), or deliver it to the user space via
+		 * accept().
+		 * We can't delete the subflow - or risk a double free - nor let
+		 * the msk survive - or will be leaked in the non accept scenario:
+		 * fallback and let TCP cope with the subflow cleanup.
+		 */
+		WARN_ON_ONCE(sock_flag(ssk, SOCK_DEAD));
+		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
 		if (ssk->sk_state == TCP_LISTEN) {
@@ -2412,9 +2424,10 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 	return 0;
 }
 
-static void __mptcp_close_subflow(struct mptcp_sock *msk)
+static void __mptcp_close_subflow(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	might_sleep();
 
@@ -2428,7 +2441,15 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 		if (!skb_queue_empty_lockless(&ssk->sk_receive_queue))
 			continue;
 
-		mptcp_close_ssk((struct sock *)msk, ssk, subflow);
+		mptcp_close_ssk(sk, ssk, subflow);
+	}
+
+	/* if the MPC subflow has been closed before the msk is accepted,
+	 * msk will never be accept-ed, close it now
+	 */
+	if (!msk->first && msk->in_accept_queue) {
+		sock_set_flag(sk, SOCK_DEAD);
+		inet_sk_state_store(sk, TCP_CLOSE);
 	}
 }
 
@@ -2637,6 +2658,9 @@ static void mptcp_worker(struct work_struct *work)
 	__mptcp_check_send_data_fin(sk);
 	mptcp_check_data_fin(sk);
 
+	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		__mptcp_close_subflow(sk);
+
 	/* There is no point in keeping around an orphaned sk timedout or
 	 * closed, but we need the msk around to reply to incoming DATA_FIN,
 	 * even if it is orphaned and in FIN_WAIT2 state
@@ -2652,9 +2676,6 @@ static void mptcp_worker(struct work_struct *work)
 		}
 	}
 
-	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-		__mptcp_close_subflow(msk);
-
 	if (test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		__mptcp_retrans(sk);
 
@@ -3084,6 +3105,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->local_key = subflow_req->local_key;
 	msk->token = subflow_req->token;
 	msk->subflow = NULL;
+	msk->in_accept_queue = 1;
 	WRITE_ONCE(msk->fully_established, false);
 	if (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD)
 		WRITE_ONCE(msk->csum_enabled, true);
@@ -3110,8 +3132,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	security_inet_csk_clone(nsk, req);
 	bh_unlock_sock(nsk);
 
-	/* keep a single reference */
-	__sock_put(nsk);
+	/* note: the newly allocated socket refcount is 2 now */
 	return nsk;
 }
 
@@ -3167,8 +3188,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			goto out;
 		}
 
-		/* acquire the 2nd reference for the owning socket */
-		sock_hold(new_mptcp_sock);
 		newsk = new_mptcp_sock;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
 	} else {
@@ -3726,6 +3745,8 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		struct mptcp_subflow_context *subflow;
 		struct sock *newsk = newsock->sk;
 
+		msk->in_accept_queue = 0;
+
 		lock_sock(newsk);
 
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6f22ae13c984..2cddd5b52e8f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -286,7 +286,8 @@ struct mptcp_sock {
 	u8		recvmsg_inq:1,
 			cork:1,
 			nodelay:1,
-			fastopening:1;
+			fastopening:1,
+			in_accept_queue:1;
 	int		connect_flags;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
@@ -651,6 +652,8 @@ void mptcp_subflow_set_active(struct mptcp_subflow_context *subflow);
 
 bool mptcp_subflow_active(struct mptcp_subflow_context *subflow);
 
+void mptcp_subflow_drop_ctx(struct sock *ssk);
+
 static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 					      struct mptcp_subflow_context *ctx)
 {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index fe815103060c..459621a0410c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -636,9 +636,10 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 
 static void mptcp_force_close(struct sock *sk)
 {
-	/* the msk is not yet exposed to user-space */
+	/* the msk is not yet exposed to user-space, and refcount is 2 */
 	inet_sk_state_store(sk, TCP_CLOSE);
 	sk_common_release(sk);
+	sock_put(sk);
 }
 
 static void subflow_ulp_fallback(struct sock *sk,
@@ -654,7 +655,7 @@ static void subflow_ulp_fallback(struct sock *sk,
 	mptcp_subflow_ops_undo_override(sk);
 }
 
-static void subflow_drop_ctx(struct sock *ssk)
+void mptcp_subflow_drop_ctx(struct sock *ssk)
 {
 	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(ssk);
 
@@ -758,7 +759,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 			if (new_msk)
 				mptcp_copy_inaddrs(new_msk, child);
-			subflow_drop_ctx(child);
+			mptcp_subflow_drop_ctx(child);
 			goto out;
 		}
 
@@ -849,7 +850,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	return child;
 
 dispose_child:
-	subflow_drop_ctx(child);
+	mptcp_subflow_drop_ctx(child);
 	tcp_rsk(req)->drop_req = true;
 	inet_csk_prepare_for_destroy_sock(child);
 	tcp_done(child);
@@ -1804,7 +1805,6 @@ void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_s
 		struct sock *sk = (struct sock *)msk;
 		bool do_cancel_work;
 
-		sock_hold(sk);
 		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 		next = msk->dl_next;
 		msk->first = NULL;
@@ -1892,6 +1892,13 @@ static void subflow_ulp_release(struct sock *ssk)
 		 * when the subflow is still unaccepted
 		 */
 		release = ctx->disposable || list_empty(&ctx->node);
+
+		/* inet_child_forget() does not call sk_state_change(),
+		 * explicitly trigger the socket close machinery
+		 */
+		if (!release && !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW,
+						  &mptcp_sk(sk)->flags))
+			mptcp_schedule_work(sk);
 		sock_put(sk);
 	}
 

-- 
2.39.2

