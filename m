Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCD353FAB
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbhDEJNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239524AbhDEJNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 353B960FE4;
        Mon,  5 Apr 2021 09:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614009;
        bh=BsPMej0mbQcaWo1bHU7u5CGNe9wd7fAHNGHDgkC37aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMO9yrLBta6IKI/m5PTHWDU4rJJW6D2ApZ0QuiXDRjCEpGusMysHZZ4dkGKWzUPsA
         H2vtB50iqqYtQRLeaka4GdwKBWGiYoVEvSMPC5tw5ZooJBZKdaqWk9XrTzhIMfoFUx
         vZ7LPTRtDlpNpE1fhi31grmwoY5KUrgyIdpqI7ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 050/152] mptcp: fix race in release_cb
Date:   Mon,  5 Apr 2021 10:53:19 +0200
Message-Id: <20210405085035.904567228@linuxfoundation.org>
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

[ Upstream commit c2e6048fa1cf2228063aec299f93ac6eb256b457 ]

If we receive a MPTCP_PUSH_PENDING even from a subflow when
mptcp_release_cb() is serving the previous one, the latter
will be delayed up to the next release_sock(msk).

Address the issue implementing a test/serve loop for such
event.

Additionally rename the push helper to __mptcp_push_pending()
to be more consistent with the existing code.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c3299a4568a0..7cbb544c6d02 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1442,7 +1442,7 @@ static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 }
 
-static void mptcp_push_pending(struct sock *sk, unsigned int flags)
+static void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 {
 	struct sock *prev_ssk = NULL, *ssk = NULL;
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1681,14 +1681,14 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 wait_for_memory:
 		set_bit(MPTCP_NOSPACE, &msk->flags);
-		mptcp_push_pending(sk, msg->msg_flags);
+		__mptcp_push_pending(sk, msg->msg_flags);
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
 			goto out;
 	}
 
 	if (copied)
-		mptcp_push_pending(sk, msg->msg_flags);
+		__mptcp_push_pending(sk, msg->msg_flags);
 
 out:
 	release_sock(sk);
@@ -2944,13 +2944,14 @@ static void mptcp_release_cb(struct sock *sk)
 {
 	unsigned long flags, nflags;
 
-	/* push_pending may touch wmem_reserved, do it before the later
-	 * cleanup
-	 */
-	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
-		__mptcp_clean_una(sk);
-	if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags)) {
-		/* mptcp_push_pending() acquires the subflow socket lock
+	for (;;) {
+		flags = 0;
+		if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
+			flags |= MPTCP_PUSH_PENDING;
+		if (!flags)
+			break;
+
+		/* the following actions acquire the subflow socket lock
 		 *
 		 * 1) can't be invoked in atomic scope
 		 * 2) must avoid ABBA deadlock with msk socket spinlock: the RX
@@ -2959,13 +2960,21 @@ static void mptcp_release_cb(struct sock *sk)
 		 */
 
 		spin_unlock_bh(&sk->sk_lock.slock);
-		mptcp_push_pending(sk, 0);
+		if (flags & MPTCP_PUSH_PENDING)
+			__mptcp_push_pending(sk, 0);
+
+		cond_resched();
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
+
+	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
+		__mptcp_clean_una(sk);
 	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
 		__mptcp_error_report(sk);
 
-	/* clear any wmem reservation and errors */
+	/* push_pending may touch wmem_reserved, ensure we do the cleanup
+	 * later
+	 */
 	__mptcp_update_wmem(sk);
 	__mptcp_update_rmem(sk);
 
-- 
2.30.1



