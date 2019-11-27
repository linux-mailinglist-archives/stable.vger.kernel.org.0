Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417E110BE61
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfK0VgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:36:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730163AbfK0Usn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:48:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471A2217C3;
        Wed, 27 Nov 2019 20:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887722;
        bh=aJgCLU5INSKa8i+HSX657zceEvO95pCi04icG6OYlDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcb+b1me9mZSx/0sYIY1bwpxTovIQ4jiM1EFQN1+T3XW/Ps58CFtCLslOMn0XSrjP
         R8Mq/h/6ifb9cAKGRkpiX75YemjkFmJRxtQTzyqiwAcxpGghn1dK6fKvBdEs30xkm3
         rSCZy6Jz+cPsXwbdlPeFWuLMKuhiWhtVD7Aun/WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/211] sunrpc: safely reallow resvport min/max inversion
Date:   Wed, 27 Nov 2019 21:30:02 +0100
Message-Id: <20191127203100.406589905@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 826799e66e8683e5698e140bb9ef69afc8c0014e ]

Commits ffb6ca33b04b and e08ea3a96fc7 prevent setting xprt_min_resvport
greater than xprt_max_resvport, but may also break simple code that sets
one parameter then the other, if the new range does not overlap the old.

Also it looks racy to me, unless there's some serialization I'm not
seeing.  Granted it would probably require malicious privileged processes
(unless there's a chance these might eventually be settable in unprivileged
containers), but still it seems better not to let userspace panic the
kernel.

Simpler seems to be to allow setting the parameters to whatever you want
but interpret xprt_min_resvport > xprt_max_resvport as the empty range.

Fixes: ffb6ca33b04b "sunrpc: Prevent resvport min/max inversion..."
Fixes: e08ea3a96fc7 "sunrpc: Prevent rexvport min/max inversion..."
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index a42871a59f3b9..f75b5b7c1fc2a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -127,7 +127,7 @@ static struct ctl_table xs_tunables_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xprt_min_resvport_limit,
-		.extra2		= &xprt_max_resvport
+		.extra2		= &xprt_max_resvport_limit
 	},
 	{
 		.procname	= "max_resvport",
@@ -135,7 +135,7 @@ static struct ctl_table xs_tunables_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xprt_min_resvport,
+		.extra1		= &xprt_min_resvport_limit,
 		.extra2		= &xprt_max_resvport_limit
 	},
 	{
@@ -1754,11 +1754,17 @@ static void xs_udp_timer(struct rpc_xprt *xprt, struct rpc_task *task)
 	spin_unlock_bh(&xprt->transport_lock);
 }
 
-static unsigned short xs_get_random_port(void)
+static int xs_get_random_port(void)
 {
-	unsigned short range = xprt_max_resvport - xprt_min_resvport + 1;
-	unsigned short rand = (unsigned short) prandom_u32() % range;
-	return rand + xprt_min_resvport;
+	unsigned short min = xprt_min_resvport, max = xprt_max_resvport;
+	unsigned short range;
+	unsigned short rand;
+
+	if (max < min)
+		return -EADDRINUSE;
+	range = max - min + 1;
+	rand = (unsigned short) prandom_u32() % range;
+	return rand + min;
 }
 
 /**
@@ -1815,9 +1821,9 @@ static void xs_set_srcport(struct sock_xprt *transport, struct socket *sock)
 		transport->srcport = xs_sock_getport(sock);
 }
 
-static unsigned short xs_get_srcport(struct sock_xprt *transport)
+static int xs_get_srcport(struct sock_xprt *transport)
 {
-	unsigned short port = transport->srcport;
+	int port = transport->srcport;
 
 	if (port == 0 && transport->xprt.resvport)
 		port = xs_get_random_port();
@@ -1838,7 +1844,7 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 {
 	struct sockaddr_storage myaddr;
 	int err, nloop = 0;
-	unsigned short port = xs_get_srcport(transport);
+	int port = xs_get_srcport(transport);
 	unsigned short last;
 
 	/*
@@ -1856,8 +1862,8 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 	 * transport->xprt.resvport == 1) xs_get_srcport above will
 	 * ensure that port is non-zero and we will bind as needed.
 	 */
-	if (port == 0)
-		return 0;
+	if (port <= 0)
+		return port;
 
 	memcpy(&myaddr, &transport->srcaddr, transport->xprt.addrlen);
 	do {
@@ -3286,12 +3292,8 @@ static int param_set_uint_minmax(const char *val,
 
 static int param_set_portnr(const char *val, const struct kernel_param *kp)
 {
-	if (kp->arg == &xprt_min_resvport)
-		return param_set_uint_minmax(val, kp,
-			RPC_MIN_RESVPORT,
-			xprt_max_resvport);
 	return param_set_uint_minmax(val, kp,
-			xprt_min_resvport,
+			RPC_MIN_RESVPORT,
 			RPC_MAX_RESVPORT);
 }
 
-- 
2.20.1



