Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A043AEFA4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhFUQkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232964AbhFUQi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D9B61433;
        Mon, 21 Jun 2021 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292960;
        bh=Dz7WSDe0jRWE2G+mOrLFRhOYZbpinR8MxnAo0w2yotQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gskOt12JTV2fCGxzd/fDDJ6K4hiGzRZnatP2Vvsmpyng3Q/aL7WulGyjhie4RNO4d
         RqB4tLthm/dSeibS5nRTAc1CMEvPeeNURyzzxKcY+jO3m9RxR5fF6DgW7r5ASeD3+o
         LhCm0rSW2mhxIhMv52yBPNAXQiJVQZuAhXZMhr2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Galaganov <max@internet.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 048/178] mptcp: fix soft lookup in subflow_error_report()
Date:   Mon, 21 Jun 2021 18:14:22 +0200
Message-Id: <20210621154923.973814556@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 499ada5073361c631f2a3c4a8aed44d53b6f82ec ]

Maxim reported a soft lookup in subflow_error_report():

 watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
 RIP: 0010:native_queued_spin_lock_slowpath
 RSP: 0018:ffffa859c0003bc0 EFLAGS: 00000202
 RAX: 0000000000000101 RBX: 0000000000000001 RCX: 0000000000000000
 RDX: ffff9195c2772d88 RSI: 0000000000000000 RDI: ffff9195c2772d88
 RBP: ffff9195c2772d00 R08: 00000000000067b0 R09: c6e31da9eb1e44f4
 R10: ffff9195ef379700 R11: ffff9195edb50710 R12: ffff9195c2772d88
 R13: ffff9195f500e3d0 R14: ffff9195ef379700 R15: ffff9195ef379700
 FS:  0000000000000000(0000) GS:ffff91961f400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000c000407000 CR3: 0000000002988000 CR4: 00000000000006f0
 Call Trace:
  <IRQ>
 _raw_spin_lock_bh
 subflow_error_report
 mptcp_subflow_data_available
 __mptcp_move_skbs_from_subflow
 mptcp_data_ready
 tcp_data_queue
 tcp_rcv_established
 tcp_v4_do_rcv
 tcp_v4_rcv
 ip_protocol_deliver_rcu
 ip_local_deliver_finish
 __netif_receive_skb_one_core
 netif_receive_skb
 rtl8139_poll 8139too
 __napi_poll
 net_rx_action
 __do_softirq
 __irq_exit_rcu
 common_interrupt
  </IRQ>

The calling function - mptcp_subflow_data_available() - can be invoked
from different contexts:
- plain ssk socket lock
- ssk socket lock + mptcp_data_lock
- ssk socket lock + mptcp_data_lock + msk socket lock.

Since subflow_error_report() tries to acquire the mptcp_data_lock, the
latter two call chains will cause soft lookup.

This change addresses the issue moving the error reporting call to
outer functions, where the held locks list is known and the we can
acquire only the needed one.

Reported-by: Maxim Galaganov <max@internet.ru>
Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/199
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c |  9 ++++++
 net/mptcp/subflow.c  | 75 +++++++++++++++++++++++---------------------
 2 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 78152b0820ce..d8187ac06539 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -699,6 +699,12 @@ static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 
 	__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 	__mptcp_ofo_queue(msk);
+	if (unlikely(ssk->sk_err)) {
+		if (!sock_owned_by_user(sk))
+			__mptcp_error_report(sk);
+		else
+			set_bit(MPTCP_ERROR_REPORT,  &msk->flags);
+	}
 
 	/* If the moves have caught up with the DATA_FIN sequence number
 	 * it's time to ack the DATA_FIN and change socket state, but
@@ -1932,6 +1938,9 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 		mptcp_data_unlock(sk);
 		tcp_cleanup_rbuf(ssk, moved);
+
+		if (unlikely(ssk->sk_err))
+			__mptcp_error_report(sk);
 		unlock_sock_fast(ssk, slowpath);
 	} while (!done);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 98a5a68ec15d..d6d8ad4f918e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1033,7 +1033,6 @@ fallback:
 		 * subflow_error_report() will introduce the appropriate barriers
 		 */
 		ssk->sk_err = EBADMSG;
-		ssk->sk_error_report(ssk);
 		tcp_set_state(ssk, TCP_CLOSE);
 		tcp_send_active_reset(ssk, GFP_ATOMIC);
 		WRITE_ONCE(subflow->data_avail, 0);
@@ -1086,41 +1085,6 @@ void mptcp_space(const struct sock *ssk, int *space, int *full_space)
 	*full_space = tcp_full_space(sk);
 }
 
-static void subflow_data_ready(struct sock *sk)
-{
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	u16 state = 1 << inet_sk_state_load(sk);
-	struct sock *parent = subflow->conn;
-	struct mptcp_sock *msk;
-
-	msk = mptcp_sk(parent);
-	if (state & TCPF_LISTEN) {
-		/* MPJ subflow are removed from accept queue before reaching here,
-		 * avoid stray wakeups
-		 */
-		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
-			return;
-
-		set_bit(MPTCP_DATA_READY, &msk->flags);
-		parent->sk_data_ready(parent);
-		return;
-	}
-
-	WARN_ON_ONCE(!__mptcp_check_fallback(msk) && !subflow->mp_capable &&
-		     !subflow->mp_join && !(state & TCPF_CLOSE));
-
-	if (mptcp_subflow_data_available(sk))
-		mptcp_data_ready(parent, sk);
-}
-
-static void subflow_write_space(struct sock *ssk)
-{
-	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
-
-	mptcp_propagate_sndbuf(sk, ssk);
-	mptcp_write_space(sk);
-}
-
 void __mptcp_error_report(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -1161,6 +1125,43 @@ static void subflow_error_report(struct sock *ssk)
 	mptcp_data_unlock(sk);
 }
 
+static void subflow_data_ready(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	u16 state = 1 << inet_sk_state_load(sk);
+	struct sock *parent = subflow->conn;
+	struct mptcp_sock *msk;
+
+	msk = mptcp_sk(parent);
+	if (state & TCPF_LISTEN) {
+		/* MPJ subflow are removed from accept queue before reaching here,
+		 * avoid stray wakeups
+		 */
+		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
+			return;
+
+		set_bit(MPTCP_DATA_READY, &msk->flags);
+		parent->sk_data_ready(parent);
+		return;
+	}
+
+	WARN_ON_ONCE(!__mptcp_check_fallback(msk) && !subflow->mp_capable &&
+		     !subflow->mp_join && !(state & TCPF_CLOSE));
+
+	if (mptcp_subflow_data_available(sk))
+		mptcp_data_ready(parent, sk);
+	else if (unlikely(sk->sk_err))
+		subflow_error_report(sk);
+}
+
+static void subflow_write_space(struct sock *ssk)
+{
+	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
+
+	mptcp_propagate_sndbuf(sk, ssk);
+	mptcp_write_space(sk);
+}
+
 static struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
@@ -1469,6 +1470,8 @@ static void subflow_state_change(struct sock *sk)
 	 */
 	if (mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
+	else if (unlikely(sk->sk_err))
+		subflow_error_report(sk);
 
 	subflow_sched_work_if_closed(mptcp_sk(parent), sk);
 
-- 
2.30.2



