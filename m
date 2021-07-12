Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF143C541A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345769AbhGLH5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240770AbhGLHwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B65F6112D;
        Mon, 12 Jul 2021 07:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076191;
        bh=EPQo4y4FBsZF11pglyr36rMy9zlzUYnKYJywUyH4blQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=roDNLliG1RJCKAUweZtRRZAzk+4SR+GtvIDlHqbv/a0nf9oC8QYNp+ZAPyHvimxzx
         7ehNoE1WBXPew/o9tN299E3PcptOIEVv1QFuIlDYxRW3Gw9j1k8p8dn5cfQ3vLZyRn
         CVYWwCbEkiGhOmEHbq4RmDtN+VaBI013D102Mmos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 537/800] mptcp: avoid race on msk state changes
Date:   Mon, 12 Jul 2021 08:09:20 +0200
Message-Id: <20210712061024.488418029@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 490274b47468793e3e157c2df6b2da0e646cc4a9 ]

The msk socket state is currently updated in a few spots without
owning the msk socket lock itself.

Some of such operations are safe, as they happens before exposing
the msk socket to user-space and can't race with other changes.

A couple of them, at connect time, can actually race with close()
or shutdown(), leaving breaking the socket state machine.

This change addresses the issue moving such update under the msk
socket lock with the usual:

<acquire spinlock>
<check sk lock onwers>
<ev defer to release_cb>

scheme.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/56
Fixes: 8fd738049ac3 ("mptcp: fallback in case of simultaneous connect")
Fixes: c3c123d16c0e ("net: mptcp: don't hang in mptcp_sendmsg() after TCP fallback")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c |  5 +++++
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  | 30 ++++++++++++++++++++++--------
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 632350018fb6..8ead550df8b1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2946,6 +2946,11 @@ static void mptcp_release_cb(struct sock *sk)
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
 
+	/* be sure to set the current sk state before tacking actions
+	 * depending on sk_state
+	 */
+	if (test_and_clear_bit(MPTCP_CONNECTED, &mptcp_sk(sk)->flags))
+		__mptcp_set_connected(sk);
 	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
 		__mptcp_clean_una_wakeup(sk);
 	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5d7c44028e47..7b634568f49c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -109,6 +109,7 @@
 #define MPTCP_ERROR_REPORT	8
 #define MPTCP_RETRANSMIT	9
 #define MPTCP_WORK_SYNC_SETSOCKOPT 10
+#define MPTCP_CONNECTED		11
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -579,6 +580,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
 void mptcp_finish_connect(struct sock *sk);
+void __mptcp_set_connected(struct sock *sk);
 static inline bool mptcp_is_fully_established(struct sock *sk)
 {
 	return inet_sk_state_load(sk) == TCP_ESTABLISHED &&
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index f5bb3a0e9975..cbc452d0901e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -371,6 +371,24 @@ static bool subflow_use_different_dport(struct mptcp_sock *msk, const struct soc
 	return inet_sk(sk)->inet_dport != inet_sk((struct sock *)msk)->inet_dport;
 }
 
+void __mptcp_set_connected(struct sock *sk)
+{
+	if (sk->sk_state == TCP_SYN_SENT) {
+		inet_sk_state_store(sk, TCP_ESTABLISHED);
+		sk->sk_state_change(sk);
+	}
+}
+
+static void mptcp_set_connected(struct sock *sk)
+{
+	mptcp_data_lock(sk);
+	if (!sock_owned_by_user(sk))
+		__mptcp_set_connected(sk);
+	else
+		set_bit(MPTCP_CONNECTED, &mptcp_sk(sk)->flags);
+	mptcp_data_unlock(sk);
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -379,10 +397,6 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
 
-	if (inet_sk_state_load(parent) == TCP_SYN_SENT) {
-		inet_sk_state_store(parent, TCP_ESTABLISHED);
-		parent->sk_state_change(parent);
-	}
 
 	/* be sure no special action on any packet other than syn-ack */
 	if (subflow->conn_finished)
@@ -411,6 +425,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			 subflow->remote_key);
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEACTIVEACK);
 		mptcp_finish_connect(sk);
+		mptcp_set_connected(parent);
 	} else if (subflow->request_join) {
 		u8 hmac[SHA256_DIGEST_SIZE];
 
@@ -451,6 +466,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	} else if (mptcp_check_fallback(sk)) {
 fallback:
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);
+		mptcp_set_connected(parent);
 	}
 	return;
 
@@ -558,6 +574,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 
 static void mptcp_force_close(struct sock *sk)
 {
+	/* the msk is not yet exposed to user-space */
 	inet_sk_state_store(sk, TCP_CLOSE);
 	sk_common_release(sk);
 }
@@ -1474,10 +1491,7 @@ static void subflow_state_change(struct sock *sk)
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);
 		pr_fallback(mptcp_sk(parent));
 		subflow->conn_finished = 1;
-		if (inet_sk_state_load(parent) == TCP_SYN_SENT) {
-			inet_sk_state_store(parent, TCP_ESTABLISHED);
-			parent->sk_state_change(parent);
-		}
+		mptcp_set_connected(parent);
 	}
 
 	/* as recvmsg() does not acquire the subflow socket for ssk selection
-- 
2.30.2



