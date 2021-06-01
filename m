Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E093962C4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhEaPA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234429AbhEaO7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E036128A;
        Mon, 31 May 2021 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469696;
        bh=JQppAQEZVSwNkD/dSxwDXfeNX+ilbBapXPNJJFF1hcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4932dEHH7zNyrvq2C3mpR0oTafvcOP6wfALmuOwKdyO11GpqVZS+GzxClzADA8lC
         sIPPjwF4IyLCDQ5ENEezIHBVumRuWcmYCjAQeg1jf8iVYRKLT/A2cggmSVipF2OmYn
         Q1M53RyWVxvbdTBDi0Hzx0YOc9zhxJyhanwqIv1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 285/296] SUNRPC: More fixes for backlog congestion
Date:   Mon, 31 May 2021 15:15:40 +0200
Message-Id: <20210531130713.297629976@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e86be3a04bc4aeaf12f93af35f08f8d4385bcd98 ]

Ensure that we fix the XPRT_CONGESTED starvation issue for RDMA as well
as socket based transports.
Ensure we always initialise the request after waking up from the backlog
list.

Fixes: e877a88d1f06 ("SUNRPC in case of backlog, hand free slots directly to waiting task")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprt.h     |  2 ++
 net/sunrpc/xprt.c               | 58 ++++++++++++++++-----------------
 net/sunrpc/xprtrdma/transport.c | 12 +++----
 net/sunrpc/xprtrdma/verbs.c     | 18 ++++++++--
 net/sunrpc/xprtrdma/xprt_rdma.h |  1 +
 5 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index d2e97ee802af..8a063b2b944d 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -367,6 +367,8 @@ struct rpc_xprt *	xprt_alloc(struct net *net, size_t size,
 				unsigned int num_prealloc,
 				unsigned int max_req);
 void			xprt_free(struct rpc_xprt *);
+void			xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task);
+bool			xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req);
 
 static inline int
 xprt_enable_swap(struct rpc_xprt *xprt)
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 7f9fa1c66627..dc9207c1ff07 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1603,11 +1603,18 @@ xprt_transmit(struct rpc_task *task)
 	spin_unlock(&xprt->queue_lock);
 }
 
-static void xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task)
+static void xprt_complete_request_init(struct rpc_task *task)
+{
+	if (task->tk_rqstp)
+		xprt_request_init(task);
+}
+
+void xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task)
 {
 	set_bit(XPRT_CONGESTED, &xprt->state);
-	rpc_sleep_on(&xprt->backlog, task, NULL);
+	rpc_sleep_on(&xprt->backlog, task, xprt_complete_request_init);
 }
+EXPORT_SYMBOL_GPL(xprt_add_backlog);
 
 static bool __xprt_set_rq(struct rpc_task *task, void *data)
 {
@@ -1615,14 +1622,13 @@ static bool __xprt_set_rq(struct rpc_task *task, void *data)
 
 	if (task->tk_rqstp == NULL) {
 		memset(req, 0, sizeof(*req));	/* mark unused */
-		task->tk_status = -EAGAIN;
 		task->tk_rqstp = req;
 		return true;
 	}
 	return false;
 }
 
-static bool xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req)
+bool xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req)
 {
 	if (rpc_wake_up_first(&xprt->backlog, __xprt_set_rq, req) == NULL) {
 		clear_bit(XPRT_CONGESTED, &xprt->state);
@@ -1630,6 +1636,7 @@ static bool xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req)
 	}
 	return true;
 }
+EXPORT_SYMBOL_GPL(xprt_wake_up_backlog);
 
 static bool xprt_throttle_congested(struct rpc_xprt *xprt, struct rpc_task *task)
 {
@@ -1639,7 +1646,7 @@ static bool xprt_throttle_congested(struct rpc_xprt *xprt, struct rpc_task *task
 		goto out;
 	spin_lock(&xprt->reserve_lock);
 	if (test_bit(XPRT_CONGESTED, &xprt->state)) {
-		rpc_sleep_on(&xprt->backlog, task, NULL);
+		xprt_add_backlog(xprt, task);
 		ret = true;
 	}
 	spin_unlock(&xprt->reserve_lock);
@@ -1808,10 +1815,6 @@ xprt_request_init(struct rpc_task *task)
 	struct rpc_xprt *xprt = task->tk_xprt;
 	struct rpc_rqst	*req = task->tk_rqstp;
 
-	if (req->rq_task)
-		/* Already initialized */
-		return;
-
 	req->rq_task	= task;
 	req->rq_xprt    = xprt;
 	req->rq_buffer  = NULL;
@@ -1872,10 +1875,8 @@ void xprt_retry_reserve(struct rpc_task *task)
 	struct rpc_xprt *xprt = task->tk_xprt;
 
 	task->tk_status = 0;
-	if (task->tk_rqstp != NULL) {
-		xprt_request_init(task);
+	if (task->tk_rqstp != NULL)
 		return;
-	}
 
 	task->tk_status = -EAGAIN;
 	xprt_do_reserve(xprt, task);
@@ -1900,24 +1901,21 @@ void xprt_release(struct rpc_task *task)
 	}
 
 	xprt = req->rq_xprt;
-	if (xprt) {
-		xprt_request_dequeue_xprt(task);
-		spin_lock(&xprt->transport_lock);
-		xprt->ops->release_xprt(xprt, task);
-		if (xprt->ops->release_request)
-			xprt->ops->release_request(task);
-		xprt_schedule_autodisconnect(xprt);
-		spin_unlock(&xprt->transport_lock);
-		if (req->rq_buffer)
-			xprt->ops->buf_free(task);
-		xdr_free_bvec(&req->rq_rcv_buf);
-		xdr_free_bvec(&req->rq_snd_buf);
-		if (req->rq_cred != NULL)
-			put_rpccred(req->rq_cred);
-		if (req->rq_release_snd_buf)
-			req->rq_release_snd_buf(req);
-	} else
-		xprt = task->tk_xprt;
+	xprt_request_dequeue_xprt(task);
+	spin_lock(&xprt->transport_lock);
+	xprt->ops->release_xprt(xprt, task);
+	if (xprt->ops->release_request)
+		xprt->ops->release_request(task);
+	xprt_schedule_autodisconnect(xprt);
+	spin_unlock(&xprt->transport_lock);
+	if (req->rq_buffer)
+		xprt->ops->buf_free(task);
+	xdr_free_bvec(&req->rq_rcv_buf);
+	xdr_free_bvec(&req->rq_snd_buf);
+	if (req->rq_cred != NULL)
+		put_rpccred(req->rq_cred);
+	if (req->rq_release_snd_buf)
+		req->rq_release_snd_buf(req);
 
 	task->tk_rqstp = NULL;
 	if (likely(!bc_prealloc(req)))
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 09953597d055..19a49d26b1e4 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -520,9 +520,8 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
-	set_bit(XPRT_CONGESTED, &xprt->state);
-	rpc_sleep_on(&xprt->backlog, task, NULL);
 	task->tk_status = -EAGAIN;
+	xprt_add_backlog(xprt, task);
 }
 
 /**
@@ -537,10 +536,11 @@ xprt_rdma_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *rqst)
 	struct rpcrdma_xprt *r_xprt =
 		container_of(xprt, struct rpcrdma_xprt, rx_xprt);
 
-	memset(rqst, 0, sizeof(*rqst));
-	rpcrdma_buffer_put(&r_xprt->rx_buf, rpcr_to_rdmar(rqst));
-	if (unlikely(!rpc_wake_up_next(&xprt->backlog)))
-		clear_bit(XPRT_CONGESTED, &xprt->state);
+	rpcrdma_reply_put(&r_xprt->rx_buf, rpcr_to_rdmar(rqst));
+	if (!xprt_wake_up_backlog(xprt, rqst)) {
+		memset(rqst, 0, sizeof(*rqst));
+		rpcrdma_buffer_put(&r_xprt->rx_buf, rpcr_to_rdmar(rqst));
+	}
 }
 
 static bool rpcrdma_check_regbuf(struct rpcrdma_xprt *r_xprt,
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index f3fffc74ab0f..0731b4756c49 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1184,6 +1184,20 @@ rpcrdma_mr_get(struct rpcrdma_xprt *r_xprt)
 	return mr;
 }
 
+/**
+ * rpcrdma_reply_put - Put reply buffers back into pool
+ * @buffers: buffer pool
+ * @req: object to return
+ *
+ */
+void rpcrdma_reply_put(struct rpcrdma_buffer *buffers, struct rpcrdma_req *req)
+{
+	if (req->rl_reply) {
+		rpcrdma_rep_put(buffers, req->rl_reply);
+		req->rl_reply = NULL;
+	}
+}
+
 /**
  * rpcrdma_buffer_get - Get a request buffer
  * @buffers: Buffer pool from which to obtain a buffer
@@ -1212,9 +1226,7 @@ rpcrdma_buffer_get(struct rpcrdma_buffer *buffers)
  */
 void rpcrdma_buffer_put(struct rpcrdma_buffer *buffers, struct rpcrdma_req *req)
 {
-	if (req->rl_reply)
-		rpcrdma_rep_put(buffers, req->rl_reply);
-	req->rl_reply = NULL;
+	rpcrdma_reply_put(buffers, req);
 
 	spin_lock(&buffers->rb_lock);
 	list_add(&req->rl_list, &buffers->rb_send_bufs);
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 28af11fbe643..ac13b93af9bd 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -481,6 +481,7 @@ struct rpcrdma_req *rpcrdma_buffer_get(struct rpcrdma_buffer *);
 void rpcrdma_buffer_put(struct rpcrdma_buffer *buffers,
 			struct rpcrdma_req *req);
 void rpcrdma_recv_buffer_put(struct rpcrdma_rep *);
+void rpcrdma_reply_put(struct rpcrdma_buffer *buffers, struct rpcrdma_req *req);
 
 bool rpcrdma_regbuf_realloc(struct rpcrdma_regbuf *rb, size_t size,
 			    gfp_t flags);
-- 
2.30.2



