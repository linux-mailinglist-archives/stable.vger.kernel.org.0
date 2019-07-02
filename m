Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C6A5CB75
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfGBIHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbfGBIHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A8721479;
        Tue,  2 Jul 2019 08:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054829;
        bh=hyq6FUzos5qzO6vrkqryZl3ikMhqFOfF9lHPNQ3hmsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjp+yXQnEtgOoLrJT3mx+uCjG2BSVWCsuwic2fBaqesvRowO+J+kupyNzNhPyKHdH
         fVWYTtUGp0soYhhcXh0OFA7BycUNPLqF0VQGIQ0zo0HSsH8/vtRFUWrInnCKxV2FOE
         1dSjszZ0uZWDpVWPLI6cR5Cq9WSdQqrcJube5SeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yihao Wu <wuyihao@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>
Subject: [PATCH 4.19 47/72] SUNRPC: Clean up initialisation of the struct rpc_rqst
Date:   Tue,  2 Jul 2019 10:01:48 +0200
Message-Id: <20190702080127.045443226@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 9dc6edcf676fe188430e8b119f91280bbf285163 upstream.

Move the initialisation back into xprt.c.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Yihao Wu <wuyihao@linux.alibaba.com>
Cc: Caspar Zhang <caspar@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/xprt.h |    1 
 net/sunrpc/clnt.c           |    1 
 net/sunrpc/xprt.c           |   91 ++++++++++++++++++++++++--------------------
 3 files changed, 51 insertions(+), 42 deletions(-)

--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -325,7 +325,6 @@ struct xprt_class {
 struct rpc_xprt		*xprt_create_transport(struct xprt_create *args);
 void			xprt_connect(struct rpc_task *task);
 void			xprt_reserve(struct rpc_task *task);
-void			xprt_request_init(struct rpc_task *task);
 void			xprt_retry_reserve(struct rpc_task *task);
 int			xprt_reserve_xprt(struct rpc_xprt *xprt, struct rpc_task *task);
 int			xprt_reserve_xprt_cong(struct rpc_xprt *xprt, struct rpc_task *task);
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1558,7 +1558,6 @@ call_reserveresult(struct rpc_task *task
 	task->tk_status = 0;
 	if (status >= 0) {
 		if (task->tk_rqstp) {
-			xprt_request_init(task);
 			task->tk_action = call_refresh;
 			return;
 		}
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1257,6 +1257,55 @@ void xprt_free(struct rpc_xprt *xprt)
 }
 EXPORT_SYMBOL_GPL(xprt_free);
 
+static __be32
+xprt_alloc_xid(struct rpc_xprt *xprt)
+{
+	__be32 xid;
+
+	spin_lock(&xprt->reserve_lock);
+	xid = (__force __be32)xprt->xid++;
+	spin_unlock(&xprt->reserve_lock);
+	return xid;
+}
+
+static void
+xprt_init_xid(struct rpc_xprt *xprt)
+{
+	xprt->xid = prandom_u32();
+}
+
+static void
+xprt_request_init(struct rpc_task *task)
+{
+	struct rpc_xprt *xprt = task->tk_xprt;
+	struct rpc_rqst	*req = task->tk_rqstp;
+
+	INIT_LIST_HEAD(&req->rq_list);
+	req->rq_timeout = task->tk_client->cl_timeout->to_initval;
+	req->rq_task	= task;
+	req->rq_xprt    = xprt;
+	req->rq_buffer  = NULL;
+	req->rq_xid	= xprt_alloc_xid(xprt);
+	req->rq_connect_cookie = xprt->connect_cookie - 1;
+	req->rq_bytes_sent = 0;
+	req->rq_snd_buf.len = 0;
+	req->rq_snd_buf.buflen = 0;
+	req->rq_rcv_buf.len = 0;
+	req->rq_rcv_buf.buflen = 0;
+	req->rq_release_snd_buf = NULL;
+	xprt_reset_majortimeo(req);
+	dprintk("RPC: %5u reserved req %p xid %08x\n", task->tk_pid,
+			req, ntohl(req->rq_xid));
+}
+
+static void
+xprt_do_reserve(struct rpc_xprt *xprt, struct rpc_task *task)
+{
+	xprt->ops->alloc_slot(xprt, task);
+	if (task->tk_rqstp != NULL)
+		xprt_request_init(task);
+}
+
 /**
  * xprt_reserve - allocate an RPC request slot
  * @task: RPC task requesting a slot allocation
@@ -1276,7 +1325,7 @@ void xprt_reserve(struct rpc_task *task)
 	task->tk_timeout = 0;
 	task->tk_status = -EAGAIN;
 	if (!xprt_throttle_congested(xprt, task))
-		xprt->ops->alloc_slot(xprt, task);
+		xprt_do_reserve(xprt, task);
 }
 
 /**
@@ -1298,45 +1347,7 @@ void xprt_retry_reserve(struct rpc_task
 
 	task->tk_timeout = 0;
 	task->tk_status = -EAGAIN;
-	xprt->ops->alloc_slot(xprt, task);
-}
-
-static inline __be32 xprt_alloc_xid(struct rpc_xprt *xprt)
-{
-	__be32 xid;
-
-	spin_lock(&xprt->reserve_lock);
-	xid = (__force __be32)xprt->xid++;
-	spin_unlock(&xprt->reserve_lock);
-	return xid;
-}
-
-static inline void xprt_init_xid(struct rpc_xprt *xprt)
-{
-	xprt->xid = prandom_u32();
-}
-
-void xprt_request_init(struct rpc_task *task)
-{
-	struct rpc_xprt *xprt = task->tk_xprt;
-	struct rpc_rqst	*req = task->tk_rqstp;
-
-	INIT_LIST_HEAD(&req->rq_list);
-	req->rq_timeout = task->tk_client->cl_timeout->to_initval;
-	req->rq_task	= task;
-	req->rq_xprt    = xprt;
-	req->rq_buffer  = NULL;
-	req->rq_xid	= xprt_alloc_xid(xprt);
-	req->rq_connect_cookie = xprt->connect_cookie - 1;
-	req->rq_bytes_sent = 0;
-	req->rq_snd_buf.len = 0;
-	req->rq_snd_buf.buflen = 0;
-	req->rq_rcv_buf.len = 0;
-	req->rq_rcv_buf.buflen = 0;
-	req->rq_release_snd_buf = NULL;
-	xprt_reset_majortimeo(req);
-	dprintk("RPC: %5u reserved req %p xid %08x\n", task->tk_pid,
-			req, ntohl(req->rq_xid));
+	xprt_do_reserve(xprt, task);
 }
 
 /**


