Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F050D353F9A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbhDEJNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239367AbhDEJNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F9A8611BD;
        Mon,  5 Apr 2021 09:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613984;
        bh=n3pXM755WW712Ml7VXglVwGonP+JN7bdElzhltsk5Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtwegaDDrsJv9OpK897OE8YrvKIlaTjKZ6T38h3KPK6AgZeQGk9asK59y5Gmnv8u5
         ZI2JP6SsY+pFED1Uyw8d5lf9p4zYmRrTbnEXIeKXdT2kn3VurfaQCuY6BorC/0HLqo
         ibjh8CrA8rYVIAZxptxXXItafHDlQTGrGQvrhTwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 041/152] mptcp: deliver ssk errors to msk
Date:   Mon,  5 Apr 2021 10:53:10 +0200
Message-Id: <20210405085035.617347229@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 15cc10453398c22f78f6c2b897119ecce5e5dd89 ]

Currently all errors received on msk subflows are ignored.
We need to catch at least the errors on connect() and
on fallback sockets.

Use a custom sk_error_report callback at subflow level,
and do the real action under the msk socket lock - via
the usual sock_owned_by_user()/release_callback() schema.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c |  7 +++++++
 net/mptcp/protocol.h |  4 ++++
 net/mptcp/subflow.c  | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7345df40385a..f588332eebb4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2958,6 +2958,8 @@ static void mptcp_release_cb(struct sock *sk)
 		mptcp_push_pending(sk, 0);
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
+	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
+		__mptcp_error_report(sk);
 
 	/* clear any wmem reservation and errors */
 	__mptcp_update_wmem(sk);
@@ -3354,6 +3356,11 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
+	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	smp_rmb();
+	if (sk->sk_err)
+		mask |= EPOLLERR;
+
 	return mask;
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c374345ad134..62288836d053 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -96,6 +96,7 @@
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
 #define MPTCP_PUSH_PENDING	6
 #define MPTCP_CLEAN_UNA		7
+#define MPTCP_ERROR_REPORT	8
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -413,6 +414,7 @@ struct mptcp_subflow_context {
 	void	(*tcp_data_ready)(struct sock *sk);
 	void	(*tcp_state_change)(struct sock *sk);
 	void	(*tcp_write_space)(struct sock *sk);
+	void	(*tcp_error_report)(struct sock *sk);
 
 	struct	rcu_head rcu;
 };
@@ -478,6 +480,7 @@ static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 	sk->sk_data_ready = ctx->tcp_data_ready;
 	sk->sk_state_change = ctx->tcp_state_change;
 	sk->sk_write_space = ctx->tcp_write_space;
+	sk->sk_error_report = ctx->tcp_error_report;
 
 	inet_csk(sk)->icsk_af_ops = ctx->icsk_af_ops;
 }
@@ -505,6 +508,7 @@ bool mptcp_finish_join(struct sock *sk);
 bool mptcp_schedule_work(struct sock *sk);
 void __mptcp_check_push(struct sock *sk, struct sock *ssk);
 void __mptcp_data_acked(struct sock *sk);
+void __mptcp_error_report(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
 void __mptcp_flush_join_list(struct mptcp_sock *msk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 96e040951cd4..6c0205816a5d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1054,6 +1054,46 @@ static void subflow_write_space(struct sock *ssk)
 	/* we take action in __mptcp_clean_una() */
 }
 
+void __mptcp_error_report(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int err = sock_error(ssk);
+
+		if (!err)
+			continue;
+
+		/* only propagate errors on fallen-back sockets or
+		 * on MPC connect
+		 */
+		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
+			continue;
+
+		inet_sk_state_store(sk, inet_sk_state_load(ssk));
+		sk->sk_err = -err;
+
+		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
+		smp_wmb();
+		sk->sk_error_report(sk);
+		break;
+	}
+}
+
+static void subflow_error_report(struct sock *ssk)
+{
+	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
+
+	mptcp_data_lock(sk);
+	if (!sock_owned_by_user(sk))
+		__mptcp_error_report(sk);
+	else
+		set_bit(MPTCP_ERROR_REPORT,  &mptcp_sk(sk)->flags);
+	mptcp_data_unlock(sk);
+}
+
 static struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
@@ -1367,9 +1407,11 @@ static int subflow_ulp_init(struct sock *sk)
 	ctx->tcp_data_ready = sk->sk_data_ready;
 	ctx->tcp_state_change = sk->sk_state_change;
 	ctx->tcp_write_space = sk->sk_write_space;
+	ctx->tcp_error_report = sk->sk_error_report;
 	sk->sk_data_ready = subflow_data_ready;
 	sk->sk_write_space = subflow_write_space;
 	sk->sk_state_change = subflow_state_change;
+	sk->sk_error_report = subflow_error_report;
 out:
 	return err;
 }
@@ -1422,6 +1464,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	new_ctx->tcp_data_ready = old_ctx->tcp_data_ready;
 	new_ctx->tcp_state_change = old_ctx->tcp_state_change;
 	new_ctx->tcp_write_space = old_ctx->tcp_write_space;
+	new_ctx->tcp_error_report = old_ctx->tcp_error_report;
 	new_ctx->rel_write_seq = 1;
 	new_ctx->tcp_sock = newsk;
 
-- 
2.30.1



