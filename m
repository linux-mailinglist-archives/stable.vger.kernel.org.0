Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF448353FA5
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbhDEJNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239458AbhDEJN3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA50D61399;
        Mon,  5 Apr 2021 09:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614002;
        bh=Svdgr/AA0UCfIVJfBErFFvZ0jE6s3P7Fj4FC/UT4QBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBBrGETD6jb/cnsc8lRa9fSJYaF/cTRxUg1YITGblhmL8cp2N3G9bl+4Zw4+JlFlu
         YW29jnqx2sC0PLvL6n4giG8qEoHeP3ak7db52/Ne7AuDbGkV0QmHDVPJldF+jWYxlR
         6JOm+1vGmS/h2iOiBib+vZCD4JRjbnLVTP2owA44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 047/152] mptcp: provide subflow aware release function
Date:   Mon,  5 Apr 2021 10:53:16 +0200
Message-Id: <20210405085035.805522114@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ad98dd37051e14fa8c785609430d907fcfd518ba ]

mptcp re-used inet(6)_release, so the subflow sockets are ignored.
Need to invoke ip(v6)_mc_drop_socket function to ensure mcast join
resources get free'd.

Fixes: 717e79c867ca5 ("mptcp: Add setsockopt()/getsockopt() socket operations")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/110
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 55 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 88f2d900a347..c3299a4568a0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
 #include <linux/atomic.h>
+#include <linux/igmp.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -19,6 +20,7 @@
 #include <net/tcp_states.h>
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 #include <net/transp_v6.h>
+#include <net/addrconf.h>
 #endif
 #include <net/mptcp.h>
 #include <net/xfrm.h>
@@ -3368,10 +3370,34 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static int mptcp_release(struct socket *sock)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = sock->sk;
+	struct mptcp_sock *msk;
+
+	if (!sk)
+		return 0;
+
+	lock_sock(sk);
+
+	msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		ip_mc_drop_socket(ssk);
+	}
+
+	release_sock(sk);
+
+	return inet_release(sock);
+}
+
 static const struct proto_ops mptcp_stream_ops = {
 	.family		   = PF_INET,
 	.owner		   = THIS_MODULE,
-	.release	   = inet_release,
+	.release	   = mptcp_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
@@ -3418,10 +3444,35 @@ void __init mptcp_proto_init(void)
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static int mptcp6_release(struct socket *sock)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk;
+	struct sock *sk = sock->sk;
+
+	if (!sk)
+		return 0;
+
+	lock_sock(sk);
+
+	msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		ip_mc_drop_socket(ssk);
+		ipv6_sock_mc_close(ssk);
+		ipv6_sock_ac_close(ssk);
+	}
+
+	release_sock(sk);
+	return inet6_release(sock);
+}
+
 static const struct proto_ops mptcp_v6_stream_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
-	.release	   = inet6_release,
+	.release	   = mptcp6_release,
 	.bind		   = mptcp_bind,
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
-- 
2.30.1



