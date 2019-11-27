Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6405710BD14
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbfK0VBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731666AbfK0VBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89492158A;
        Wed, 27 Nov 2019 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888466;
        bh=yyh2hufHdLJUI04XCdrrkkLGWjEaQEeLU+E5VS1K7/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qf3OgGxxX2a8ppRPdvcygIjsGstRUm8LW5EZbesl/5hhiBSE8gWSc8Nqt2Li4NzA8
         mtmifeAXu+SQFAwrcTwcZu32pAhdrBkhab/+EmJmHGZoOpQI/7dtwlkl3RqQASPmIZ
         QrH3Xu6ZhyQKkwD8WG0hMZmqG8u/S4kE/CJZPEco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/306] sunrpc: safely reallow resvport min/max inversion
Date:   Wed, 27 Nov 2019 21:29:12 +0100
Message-Id: <20191127203122.712686321@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index c0d7875a64ffc..9dc059dea689d 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -129,7 +129,7 @@ static struct ctl_table xs_tunables_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xprt_min_resvport_limit,
-		.extra2		= &xprt_max_resvport
+		.extra2		= &xprt_max_resvport_limit
 	},
 	{
 		.procname	= "max_resvport",
@@ -137,7 +137,7 @@ static struct ctl_table xs_tunables_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xprt_min_resvport,
+		.extra1		= &xprt_min_resvport_limit,
 		.extra2		= &xprt_max_resvport_limit
 	},
 	{
@@ -1776,11 +1776,17 @@ static void xs_udp_timer(struct rpc_xprt *xprt, struct rpc_task *task)
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
@@ -1836,9 +1842,9 @@ static void xs_set_srcport(struct sock_xprt *transport, struct socket *sock)
 		transport->srcport = xs_sock_getport(sock);
 }
 
-static unsigned short xs_get_srcport(struct sock_xprt *transport)
+static int xs_get_srcport(struct sock_xprt *transport)
 {
-	unsigned short port = transport->srcport;
+	int port = transport->srcport;
 
 	if (port == 0 && transport->xprt.resvport)
 		port = xs_get_random_port();
@@ -1859,7 +1865,7 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 {
 	struct sockaddr_storage myaddr;
 	int err, nloop = 0;
-	unsigned short port = xs_get_srcport(transport);
+	int port = xs_get_srcport(transport);
 	unsigned short last;
 
 	/*
@@ -1877,8 +1883,8 @@ static int xs_bind(struct sock_xprt *transport, struct socket *sock)
 	 * transport->xprt.resvport == 1) xs_get_srcport above will
 	 * ensure that port is non-zero and we will bind as needed.
 	 */
-	if (port == 0)
-		return 0;
+	if (port <= 0)
+		return port;
 
 	memcpy(&myaddr, &transport->srcaddr, transport->xprt.addrlen);
 	do {
@@ -3319,12 +3325,8 @@ static int param_set_uint_minmax(const char *val,
 
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



