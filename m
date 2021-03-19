Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA058341C7F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhCSMVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhCSMUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8B0964F6E;
        Fri, 19 Mar 2021 12:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156451;
        bh=nY6YsqPYxFmKHe2OjtlwfkshWJEhQXXf+JGu0beZnkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuoKzhyC0RU8ZLFr6nmFMM7V9UUppXmyrOmMRN67vXEqJpkESFqV7zeKnZTiQ9jik
         jhz3lJNi8J6aQvcB3VjQBAMi5TH3SpCeoqHyzJuyafdvyGkUZq7jASf4guCc3gAASf
         evoD4T75Hr8otd7P/oU0k7GiW+gQPku+3/iHM/3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 06/31] mptcp: dispose initial struct socket when its subflow is closed
Date:   Fri, 19 Mar 2021 13:19:00 +0100
Message-Id: <20210319121747.415250250@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 17aee05dc8822e354f5ad2d68ee39e3ba4b6acf2 ]

Christoph Paasch reported following crash:
dst_release underflow
WARNING: CPU: 0 PID: 1319 at net/core/dst.c:175 dst_release+0xc1/0xd0 net/core/dst.c:175
CPU: 0 PID: 1319 Comm: syz-executor217 Not tainted 5.11.0-rc6af8e85128b4d0d24083c5cac646e891227052e0c #70
Call Trace:
 rt_cache_route+0x12e/0x140 net/ipv4/route.c:1503
 rt_set_nexthop.constprop.0+0x1fc/0x590 net/ipv4/route.c:1612
 __mkroute_output net/ipv4/route.c:2484 [inline]
...

The worker leaves msk->subflow alone even when it
happened to close the subflow ssk associated with it.

Fixes: 866f26f2a9c33b ("mptcp: always graft subflow socket to parent")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/157
Reported-by: Christoph Paasch <cpaasch@apple.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 64b8a49652ae..7345df40385a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2100,6 +2100,14 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 	return backup;
 }
 
+static void mptcp_dispose_initial_subflow(struct mptcp_sock *msk)
+{
+	if (msk->subflow) {
+		iput(SOCK_INODE(msk->subflow));
+		msk->subflow = NULL;
+	}
+}
+
 /* subflow sockets can be either outgoing (connect) or incoming
  * (accept).
  *
@@ -2144,6 +2152,9 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 
 	if (ssk == msk->last_snd)
 		msk->last_snd = NULL;
+
+	if (msk->subflow && ssk == msk->subflow->sk)
+		mptcp_dispose_initial_subflow(msk);
 }
 
 static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
@@ -2533,12 +2544,6 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	might_sleep();
 
-	/* dispose the ancillatory tcp socket, if any */
-	if (msk->subflow) {
-		iput(SOCK_INODE(msk->subflow));
-		msk->subflow = NULL;
-	}
-
 	/* be sure to always acquire the join list lock, to sync vs
 	 * mptcp_finish_join().
 	 */
@@ -2563,6 +2568,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
 	sk_refcnt_debug_release(sk);
+	mptcp_dispose_initial_subflow(msk);
 	sock_put(sk);
 }
 
-- 
2.30.1



