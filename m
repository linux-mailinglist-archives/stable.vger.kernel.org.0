Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A277106ED2
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbfKVK6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:58:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729942AbfKVK6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BAD20706;
        Fri, 22 Nov 2019 10:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420309;
        bh=W7M7we8yAzERJNCZacQf7ww3N5kJLza7S+Uvn99TDEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGccn5LgyqZJKEM7/C6wddqkZLiWSAhPPpVvBspCUGlLXJuXGHNrkZ3xw6JX9hbnP
         zOnM32dH38UMLlHEZK0WUuo07otByIsyHs2hT8AxFL/ogn35+2mmZxF33Fpu8nkyUM
         oOHCr0IowABJRvW4y5aO1egaX63oNn97hpSU+nXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/220] sunrpc: Fix connect metrics
Date:   Fri, 22 Nov 2019 11:27:07 +0100
Message-Id: <20191122100916.553025367@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3968a8a5310404c2f0b9e4d9f28cab13a12bc4fd ]

For TCP, the logic in xprt_connect_status is currently never invoked
to record a successful connection. Commit 2a4919919a97 ("SUNRPC:
Return EAGAIN instead of ENOTCONN when waking up xprt->pending")
changed the way TCP xprt's are awoken after a connect succeeds.

Instead, change connection-oriented transports to bump connect_count
and compute connect_time the moment that XPRT_CONNECTED is set.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c               | 14 ++++----------
 net/sunrpc/xprtrdma/transport.c |  6 +++++-
 net/sunrpc/xprtsock.c           | 10 ++++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 3581168e6b99b..5e7c13aa66d0d 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -796,17 +796,11 @@ void xprt_connect(struct rpc_task *task)
 
 static void xprt_connect_status(struct rpc_task *task)
 {
-	struct rpc_xprt	*xprt = task->tk_rqstp->rq_xprt;
-
-	if (task->tk_status == 0) {
-		xprt->stat.connect_count++;
-		xprt->stat.connect_time += (long)jiffies - xprt->stat.connect_start;
+	switch (task->tk_status) {
+	case 0:
 		dprintk("RPC: %5u xprt_connect_status: connection established\n",
 				task->tk_pid);
-		return;
-	}
-
-	switch (task->tk_status) {
+		break;
 	case -ECONNREFUSED:
 	case -ECONNRESET:
 	case -ECONNABORTED:
@@ -823,7 +817,7 @@ static void xprt_connect_status(struct rpc_task *task)
 	default:
 		dprintk("RPC: %5u xprt_connect_status: error %d connecting to "
 				"server %s\n", task->tk_pid, -task->tk_status,
-				xprt->servername);
+				task->tk_rqstp->rq_xprt->servername);
 		task->tk_status = -EIO;
 	}
 }
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 98cbc7b060bad..f56f36b4d742d 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -242,8 +242,12 @@ rpcrdma_connect_worker(struct work_struct *work)
 
 	spin_lock_bh(&xprt->transport_lock);
 	if (ep->rep_connected > 0) {
-		if (!xprt_test_and_set_connected(xprt))
+		if (!xprt_test_and_set_connected(xprt)) {
+			xprt->stat.connect_count++;
+			xprt->stat.connect_time += (long)jiffies -
+						   xprt->stat.connect_start;
 			xprt_wake_pending_tasks(xprt, 0);
+		}
 	} else {
 		if (xprt_test_and_clear_connected(xprt))
 			xprt_wake_pending_tasks(xprt, -ENOTCONN);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7d8cce1dfcad3..c0d7875a64ffc 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1611,6 +1611,9 @@ static void xs_tcp_state_change(struct sock *sk)
 			clear_bit(XPRT_SOCK_CONNECTING, &transport->sock_state);
 			xprt_clear_connecting(xprt);
 
+			xprt->stat.connect_count++;
+			xprt->stat.connect_time += (long)jiffies -
+						   xprt->stat.connect_start;
 			xprt_wake_pending_tasks(xprt, -EAGAIN);
 		}
 		spin_unlock(&xprt->transport_lock);
@@ -2029,8 +2032,6 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 	}
 
 	/* Tell the socket layer to start connecting... */
-	xprt->stat.connect_count++;
-	xprt->stat.connect_start = jiffies;
 	return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
 }
 
@@ -2062,6 +2063,9 @@ static int xs_local_setup_socket(struct sock_xprt *transport)
 	case 0:
 		dprintk("RPC:       xprt %p connected to %s\n",
 				xprt, xprt->address_strings[RPC_DISPLAY_ADDR]);
+		xprt->stat.connect_count++;
+		xprt->stat.connect_time += (long)jiffies -
+					   xprt->stat.connect_start;
 		xprt_set_connected(xprt);
 	case -ENOBUFS:
 		break;
@@ -2387,8 +2391,6 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 	xs_set_memalloc(xprt);
 
 	/* Tell the socket layer to start connecting... */
-	xprt->stat.connect_count++;
-	xprt->stat.connect_start = jiffies;
 	set_bit(XPRT_SOCK_CONNECTING, &transport->sock_state);
 	ret = kernel_connect(sock, xs_addr(xprt), xprt->addrlen, O_NONBLOCK);
 	switch (ret) {
-- 
2.20.1



