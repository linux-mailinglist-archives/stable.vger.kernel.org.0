Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E51F3D617E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhGZPcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237943AbhGZP3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EDF860F5D;
        Mon, 26 Jul 2021 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315801;
        bh=itntxkn4yqGsWlLw93IK05iUlFFmCEosR302of9QwEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DczMoUuaDUqn7JJjnOyFnb0MCuE75DNzzcUobKvLkMSOESYF4TU2df9dRxfCpgFwU
         bSrbSxxMwCDkopfjJMHS+25N9JvdkWawV1jKWChobL8kPRzcJEqNg7W4/uDkhBMKfe
         9wdjUTuvJIDr5/YvGVZXjtHl5KaL7zPtCsTOKROo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 036/223] mptcp: use fast lock for subflows when possible
Date:   Mon, 26 Jul 2021 17:37:08 +0200
Message-Id: <20210726153847.434346362@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 75e908c33615999abe1f3a8429d25dea30d28e4e ]

There are a bunch of callsite where the ssk socket
lock is acquired using the full-blown version eligible for
the fast variant. Let's move to the latter.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 10 ++++++----
 net/mptcp/protocol.c   | 15 +++++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 3f5d90a20235..fce1d057d19e 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -540,6 +540,7 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
 	if (subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for %s%s%s",
@@ -547,9 +548,9 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 			 mptcp_pm_should_add_signal_ipv6(msk) ? " [ipv6]" : "",
 			 mptcp_pm_should_add_signal_port(msk) ? " [port]" : "");
 
-		lock_sock(ssk);
+		slow = lock_sock_fast(ssk);
 		tcp_send_ack(ssk);
-		release_sock(ssk);
+		unlock_sock_fast(ssk, slow);
 		spin_lock_bh(&msk->pm.lock);
 	}
 }
@@ -566,6 +567,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
+		bool slow;
 
 		local_address((struct sock_common *)ssk, &local);
 		if (!addresses_equal(&local, addr, addr->port))
@@ -578,9 +580,9 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 
 		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for mp_prio");
-		lock_sock(ssk);
+		slow = lock_sock_fast(ssk);
 		tcp_send_ack(ssk);
-		release_sock(ssk);
+		unlock_sock_fast(ssk, slow);
 		spin_lock_bh(&msk->pm.lock);
 
 		return 0;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8ead550df8b1..0f36fefcc77e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -424,23 +424,25 @@ static void mptcp_send_ack(struct mptcp_sock *msk)
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
 
-		lock_sock(ssk);
+		slow = lock_sock_fast(ssk);
 		if (tcp_can_send_ack(ssk))
 			tcp_send_ack(ssk);
-		release_sock(ssk);
+		unlock_sock_fast(ssk, slow);
 	}
 }
 
 static bool mptcp_subflow_cleanup_rbuf(struct sock *ssk)
 {
+	bool slow;
 	int ret;
 
-	lock_sock(ssk);
+	slow = lock_sock_fast(ssk);
 	ret = tcp_can_send_ack(ssk);
 	if (ret)
 		tcp_cleanup_rbuf(ssk, 1);
-	release_sock(ssk);
+	unlock_sock_fast(ssk, slow);
 	return ret;
 }
 
@@ -2288,13 +2290,14 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 
 	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
 
-		lock_sock(tcp_sk);
+		slow = lock_sock_fast(tcp_sk);
 		if (tcp_sk->sk_state != TCP_CLOSE) {
 			tcp_send_active_reset(tcp_sk, GFP_ATOMIC);
 			tcp_set_state(tcp_sk, TCP_CLOSE);
 		}
-		release_sock(tcp_sk);
+		unlock_sock_fast(tcp_sk, slow);
 	}
 
 	inet_sk_state_store(sk, TCP_CLOSE);
-- 
2.30.2



