Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2205C395E65
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhEaN6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhEaN4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC16661926;
        Mon, 31 May 2021 13:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468076;
        bh=gZtrJJ8Aauk60LTaCiUvqUKPaneYdVeGxrDqmpZuG5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJuilepUwW0vB4321pMvtZn1lSuz8DwyO79dc2gr3M+htWOhlEh9f683xSqmpxirJ
         wWpcQ7I1XdcWA+8OgSGMd7m8jY+pxs6X07FpjQqHlUzTlzJMWXrwmiY40pjVsRnOre
         GuIL8lUvROVk2SFjr4jOFxWYpNdBqVc01UjxZZrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 106/252] SUNRPC in case of backlog, hand free slots directly to waiting task
Date:   Mon, 31 May 2021 15:12:51 +0200
Message-Id: <20210531130701.593535314@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit e877a88d1f069edced4160792f42c2a8e2dba942 upstream.

If sunrpc.tcp_max_slot_table_entries is small and there are tasks
on the backlog queue, then when a request completes it is freed and the
first task on the queue is woken.  The expectation is that it will wake
and claim that request.  However if it was a sync task and the waiting
process was killed at just that moment, it will wake and NOT claim the
request.

As long as TASK_CONGESTED remains set, requests can only be claimed by
tasks woken from the backlog, and they are woken only as requests are
freed, so when a task doesn't claim a request, no other task can ever
get that request until TASK_CONGESTED is cleared.  Each time this
happens the number of available requests is decreased by one.

With a sufficiently high workload and sufficiently low setting of
max_slot (16 in the case where this was seen), TASK_CONGESTED can remain
set for an extended period, and the above scenario (of a process being
killed just as its task was woken) can repeat until no requests can be
allocated.  Then traffic stops.

This patch addresses the problem by introducing a positive handover of a
request from a completing task to a backlog task - the request is never
freed when there is a backlog.

When a task is woken it might not already have a request attached in
which case it is *not* freed (as with current code) but is initialised
(if needed) and used.  If it isn't used it will eventually be freed by
rpc_exit_task().  xprt_release() is enhanced to be able to correctly
release an uninitialised request.

Fixes: ba60eb25ff6b ("SUNRPC: Fix a livelock problem in the xprt->backlog queue")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/clnt.c |    7 -----
 net/sunrpc/xprt.c |   68 +++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 47 insertions(+), 28 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1680,13 +1680,6 @@ call_reserveresult(struct rpc_task *task
 		return;
 	}
 
-	/*
-	 * Even though there was an error, we may have acquired
-	 * a request slot somehow.  Make sure not to leak it.
-	 */
-	if (task->tk_rqstp)
-		xprt_release(task);
-
 	switch (status) {
 	case -ENOMEM:
 		rpc_delay(task, HZ >> 2);
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -70,6 +70,7 @@
 static void	 xprt_init(struct rpc_xprt *xprt, struct net *net);
 static __be32	xprt_alloc_xid(struct rpc_xprt *xprt);
 static void	 xprt_destroy(struct rpc_xprt *xprt);
+static void	 xprt_request_init(struct rpc_task *task);
 
 static DEFINE_SPINLOCK(xprt_list_lock);
 static LIST_HEAD(xprt_list);
@@ -1580,10 +1581,26 @@ static void xprt_add_backlog(struct rpc_
 	rpc_sleep_on(&xprt->backlog, task, NULL);
 }
 
-static void xprt_wake_up_backlog(struct rpc_xprt *xprt)
+static bool __xprt_set_rq(struct rpc_task *task, void *data)
 {
-	if (rpc_wake_up_next(&xprt->backlog) == NULL)
+	struct rpc_rqst *req = data;
+
+	if (task->tk_rqstp == NULL) {
+		memset(req, 0, sizeof(*req));	/* mark unused */
+		task->tk_status = -EAGAIN;
+		task->tk_rqstp = req;
+		return true;
+	}
+	return false;
+}
+
+static bool xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req)
+{
+	if (rpc_wake_up_first(&xprt->backlog, __xprt_set_rq, req) == NULL) {
 		clear_bit(XPRT_CONGESTED, &xprt->state);
+		return false;
+	}
+	return true;
 }
 
 static bool xprt_throttle_congested(struct rpc_xprt *xprt, struct rpc_task *task)
@@ -1671,11 +1688,11 @@ EXPORT_SYMBOL_GPL(xprt_alloc_slot);
 void xprt_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *req)
 {
 	spin_lock(&xprt->reserve_lock);
-	if (!xprt_dynamic_free_slot(xprt, req)) {
+	if (!xprt_wake_up_backlog(xprt, req) &&
+	    !xprt_dynamic_free_slot(xprt, req)) {
 		memset(req, 0, sizeof(*req));	/* mark unused */
 		list_add(&req->rq_list, &xprt->free);
 	}
-	xprt_wake_up_backlog(xprt);
 	spin_unlock(&xprt->reserve_lock);
 }
 EXPORT_SYMBOL_GPL(xprt_free_slot);
@@ -1763,6 +1780,10 @@ xprt_request_init(struct rpc_task *task)
 	struct rpc_xprt *xprt = task->tk_xprt;
 	struct rpc_rqst	*req = task->tk_rqstp;
 
+	if (req->rq_task)
+		/* Already initialized */
+		return;
+
 	req->rq_task	= task;
 	req->rq_xprt    = xprt;
 	req->rq_buffer  = NULL;
@@ -1823,8 +1844,10 @@ void xprt_retry_reserve(struct rpc_task
 	struct rpc_xprt *xprt = task->tk_xprt;
 
 	task->tk_status = 0;
-	if (task->tk_rqstp != NULL)
+	if (task->tk_rqstp != NULL) {
+		xprt_request_init(task);
 		return;
+	}
 
 	task->tk_status = -EAGAIN;
 	xprt_do_reserve(xprt, task);
@@ -1849,23 +1872,26 @@ void xprt_release(struct rpc_task *task)
 	}
 
 	xprt = req->rq_xprt;
-	xprt_request_dequeue_xprt(task);
-	spin_lock(&xprt->transport_lock);
-	xprt->ops->release_xprt(xprt, task);
-	if (xprt->ops->release_request)
-		xprt->ops->release_request(task);
-	xprt_schedule_autodisconnect(xprt);
-	spin_unlock(&xprt->transport_lock);
-	if (req->rq_buffer)
-		xprt->ops->buf_free(task);
-	xdr_free_bvec(&req->rq_rcv_buf);
-	xdr_free_bvec(&req->rq_snd_buf);
-	if (req->rq_cred != NULL)
-		put_rpccred(req->rq_cred);
-	task->tk_rqstp = NULL;
-	if (req->rq_release_snd_buf)
-		req->rq_release_snd_buf(req);
+	if (xprt) {
+		xprt_request_dequeue_xprt(task);
+		spin_lock(&xprt->transport_lock);
+		xprt->ops->release_xprt(xprt, task);
+		if (xprt->ops->release_request)
+			xprt->ops->release_request(task);
+		xprt_schedule_autodisconnect(xprt);
+		spin_unlock(&xprt->transport_lock);
+		if (req->rq_buffer)
+			xprt->ops->buf_free(task);
+		xdr_free_bvec(&req->rq_rcv_buf);
+		xdr_free_bvec(&req->rq_snd_buf);
+		if (req->rq_cred != NULL)
+			put_rpccred(req->rq_cred);
+		if (req->rq_release_snd_buf)
+			req->rq_release_snd_buf(req);
+	} else
+		xprt = task->tk_xprt;
 
+	task->tk_rqstp = NULL;
 	if (likely(!bc_prealloc(req)))
 		xprt->ops->free_slot(xprt, req);
 	else


