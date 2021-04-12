Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840C535C0B4
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbhDLJPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240454AbhDLJKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48B1561285;
        Mon, 12 Apr 2021 09:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218333;
        bh=r/X//ApDsyWNF/tt+ADyLbC57YUHIBrmiykx+q5JCmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhlqROOaesFmVfnOSmNt7I2O/1FAax7/nGMhJxLvj6EhVq+Zjyf+7RvYKLNkM6HLi
         dtn/ORvgHwrY66IAqrAdfF0vl/3+UrnqhVMGrXNyCuVEUTH1DUuhlE2ORE04zw9AA+
         rGbCr+ZkvAEtFFj+5Zm0hF5eyrWIoVKJOW3gPb/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 157/210] mptcp: revert "mptcp: provide subflow aware release function"
Date:   Mon, 12 Apr 2021 10:41:02 +0200
Message-Id: <20210412084021.230371028@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0a3cc57978d1d1448312f8973bd84dca4a71433a ]

This change reverts commit ad98dd37051e ("mptcp: provide subflow aware
release function"). The latter introduced a deadlock spotted by
syzkaller and is not needed anymore after the previous commit.

Fixes: ad98dd37051e ("mptcp: provide subflow aware release function")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 55 ++------------------------------------------
 1 file changed, 2 insertions(+), 53 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index de9f2509acbe..e337b35a368f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -11,7 +11,6 @@
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
 #include <linux/atomic.h>
-#include <linux/igmp.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -20,7 +19,6 @@
 #include <net/tcp_states.h>
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 #include <net/transp_v6.h>
-#include <net/addrconf.h>
 #endif
 #include <net/mptcp.h>
 #include <net/xfrm.h>
@@ -3424,34 +3422,10 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
-static int mptcp_release(struct socket *sock)
-{
-	struct mptcp_subflow_context *subflow;
-	struct sock *sk = sock->sk;
-	struct mptcp_sock *msk;
-
-	if (!sk)
-		return 0;
-
-	lock_sock(sk);
-
-	msk = mptcp_sk(sk);
-
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		ip_mc_drop_socket(ssk);
-	}
-
-	release_sock(sk);
-
-	return inet_release(sock);
-}
-
 static const struct proto_ops mptcp_stream_ops = {
 	.family		   = PF_INET,
 	.owner		   = THIS_MODULE,
-	.release	   = mptcp_release,
+	.release	   = inet_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
@@ -3498,35 +3472,10 @@ void __init mptcp_proto_init(void)
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static int mptcp6_release(struct socket *sock)
-{
-	struct mptcp_subflow_context *subflow;
-	struct mptcp_sock *msk;
-	struct sock *sk = sock->sk;
-
-	if (!sk)
-		return 0;
-
-	lock_sock(sk);
-
-	msk = mptcp_sk(sk);
-
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		ip_mc_drop_socket(ssk);
-		ipv6_sock_mc_close(ssk);
-		ipv6_sock_ac_close(ssk);
-	}
-
-	release_sock(sk);
-	return inet6_release(sock);
-}
-
 static const struct proto_ops mptcp_v6_stream_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
-	.release	   = mptcp6_release,
+	.release	   = inet6_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
-- 
2.30.2



