Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED833B824
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhCOOCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232906AbhCOOAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8CAB64EE9;
        Mon, 15 Mar 2021 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816783;
        bh=jYTb5d7v2gYJDX3bUOyQV54hcXxLWvhGXSiovtS5onc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmtxIz+ybuFHTx/lNEroFhYOexXBbYWPj/dgLtvVxer3mdEdor68nzhj/AZ6otLHv
         Us+PgIkSDJNnRq4wQ5UIgb4VLaKtWFShg79SIHBHik6vxfoF2quYkD4jUC0F67SgKe
         S9M01Bt9P2E+bHQtLdb3+NaYpC+nC03EvkwgUPQc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 122/306] mptcp: always graft subflow socket to parent
Date:   Mon, 15 Mar 2021 14:53:05 +0100
Message-Id: <20210315135511.792253111@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 866f26f2a9c33bc70eb0f07ffc37fd9424ffe501 ]

Currently, incoming subflows link to the parent socket,
while outgoing ones link to a per subflow socket. The latter
is not really needed, except at the initial connect() time and
for the first subflow.

Always graft the outgoing subflow to the parent socket and
free the unneeded ones early.

This allows some code cleanup, reduces the amount of memory
used and will simplify the next patch

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 36 ++++++++++--------------------------
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  |  3 +++
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b51872b9dd61..3cc7be259396 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -114,11 +114,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	list_add(&subflow->node, &msk->conn_list);
 	sock_hold(ssock->sk);
 	subflow->request_mptcp = 1;
-
-	/* accept() will wait on first subflow sk_wq, and we always wakes up
-	 * via msk->sk_socket
-	 */
-	RCU_INIT_POINTER(msk->first->sk_wq, &sk->sk_socket->wq);
+	mptcp_sock_graft(msk->first, sk->sk_socket);
 
 	return 0;
 }
@@ -2114,9 +2110,6 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		       struct mptcp_subflow_context *subflow)
 {
-	bool dispose_socket = false;
-	struct socket *sock;
-
 	list_del(&subflow->node);
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
@@ -2124,11 +2117,8 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	/* if we are invoked by the msk cleanup code, the subflow is
 	 * already orphaned
 	 */
-	sock = ssk->sk_socket;
-	if (sock) {
-		dispose_socket = sock != sk->sk_socket;
+	if (ssk->sk_socket)
 		sock_orphan(ssk);
-	}
 
 	subflow->disposable = 1;
 
@@ -2146,8 +2136,6 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		__sock_put(ssk);
 	}
 	release_sock(ssk);
-	if (dispose_socket)
-		iput(SOCK_INODE(sock));
 
 	sock_put(ssk);
 }
@@ -2535,6 +2523,12 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	pr_debug("msk=%p", msk);
 
+	/* dispose the ancillatory tcp socket, if any */
+	if (msk->subflow) {
+		iput(SOCK_INODE(msk->subflow));
+		msk->subflow = NULL;
+	}
+
 	/* be sure to always acquire the join list lock, to sync vs
 	 * mptcp_finish_join().
 	 */
@@ -2585,20 +2579,10 @@ cleanup:
 	inet_csk(sk)->icsk_mtup.probe_timestamp = tcp_jiffies32;
 	list_for_each_entry(subflow, &mptcp_sk(sk)->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow, dispose_socket;
-		struct socket *sock;
+		bool slow = lock_sock_fast(ssk);
 
-		slow = lock_sock_fast(ssk);
-		sock = ssk->sk_socket;
-		dispose_socket = sock && sock != sk->sk_socket;
 		sock_orphan(ssk);
 		unlock_sock_fast(ssk, slow);
-
-		/* for the outgoing subflows we additionally need to free
-		 * the associated socket
-		 */
-		if (dispose_socket)
-			iput(SOCK_INODE(sock));
 	}
 	sock_orphan(sk);
 
@@ -3040,7 +3024,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	mptcp_rcv_space_init(msk, ssk);
 }
 
-static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
+void mptcp_sock_graft(struct sock *sk, struct socket *parent)
 {
 	write_lock_bh(&sk->sk_callback_lock);
 	rcu_assign_pointer(sk->sk_wq, &parent->wq);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index dbf62e74fcc1..18fef4273bdc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -460,6 +460,7 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
 void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		       struct mptcp_subflow_context *subflow);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9d28f6e3dc49..81b7be67d288 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1165,6 +1165,9 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (err && err != -EINPROGRESS)
 		goto failed_unlink;
 
+	/* discard the subflow socket */
+	mptcp_sock_graft(ssk, sk->sk_socket);
+	iput(SOCK_INODE(sf));
 	return err;
 
 failed_unlink:
-- 
2.30.1



