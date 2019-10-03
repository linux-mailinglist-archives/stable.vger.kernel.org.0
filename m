Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7D2CA79A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405463AbfJCQwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405685AbfJCQwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:52:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22EF420867;
        Thu,  3 Oct 2019 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121539;
        bh=P7wwFBQ92PMoNElICaZjH/2DVh4B1IGlpsufPB36m4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x10cdvu/M9CJNyEvKjD/960Jjj05ducXpnM7K4bCm8j3n706TX2FJhgaqW1rqx1e7
         XfloJz3ebXHzGIfrDoqxVxTR/3FDNivgtzkOFShH0anENug9qCfHzCniZm1vi2gN74
         9Y8l0AT1hC052HpzGDaD70yeyYSdtobVlE9HOBfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.3 317/344] SUNRPC: Dequeue the request from the receive queue while were re-encoding
Date:   Thu,  3 Oct 2019 17:54:42 +0200
Message-Id: <20191003154610.359977343@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit cc204d01262a69218b2d0db5cdea371de85871d9 upstream.

Ensure that we dequeue the request from the transport receive queue
while we're re-encoding to prevent issues like use-after-free when
we release the bvec.

Fixes: 7536908982047 ("SUNRPC: Ensure the bvecs are reset when we re-encode...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/xprt.h |    1 
 net/sunrpc/clnt.c           |    6 ++--
 net/sunrpc/xprt.c           |   54 +++++++++++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 26 deletions(-)

--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -352,6 +352,7 @@ bool			xprt_prepare_transmit(struct rpc_
 void			xprt_request_enqueue_transmit(struct rpc_task *task);
 void			xprt_request_enqueue_receive(struct rpc_task *task);
 void			xprt_request_wait_receive(struct rpc_task *task);
+void			xprt_request_dequeue_xprt(struct rpc_task *task);
 bool			xprt_request_need_retransmit(struct rpc_task *task);
 void			xprt_transmit(struct rpc_task *task);
 void			xprt_end_transmit(struct rpc_task *task);
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1862,6 +1862,7 @@ rpc_xdr_encode(struct rpc_task *task)
 		     req->rq_rbuffer,
 		     req->rq_rcvsize);
 
+	req->rq_reply_bytes_recvd = 0;
 	req->rq_snd_buf.head[0].iov_len = 0;
 	xdr_init_encode(&xdr, &req->rq_snd_buf,
 			req->rq_snd_buf.head[0].iov_base, req);
@@ -1881,6 +1882,8 @@ call_encode(struct rpc_task *task)
 	if (!rpc_task_need_encode(task))
 		goto out;
 	dprint_status(task);
+	/* Dequeue task from the receive queue while we're encoding */
+	xprt_request_dequeue_xprt(task);
 	/* Encode here so that rpcsec_gss can use correct sequence number. */
 	rpc_xdr_encode(task);
 	/* Did the encode result in an error condition? */
@@ -2518,9 +2521,6 @@ call_decode(struct rpc_task *task)
 		return;
 	case -EAGAIN:
 		task->tk_status = 0;
-		xdr_free_bvec(&req->rq_rcv_buf);
-		req->rq_reply_bytes_recvd = 0;
-		req->rq_rcv_buf.len = 0;
 		if (task->tk_client->cl_discrtry)
 			xprt_conditional_disconnect(req->rq_xprt,
 						    req->rq_connect_cookie);
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1324,6 +1324,36 @@ xprt_request_dequeue_transmit(struct rpc
 }
 
 /**
+ * xprt_request_dequeue_xprt - remove a task from the transmit+receive queue
+ * @task: pointer to rpc_task
+ *
+ * Remove a task from the transmit and receive queues, and ensure that
+ * it is not pinned by the receive work item.
+ */
+void
+xprt_request_dequeue_xprt(struct rpc_task *task)
+{
+	struct rpc_rqst	*req = task->tk_rqstp;
+	struct rpc_xprt *xprt = req->rq_xprt;
+
+	if (test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate) ||
+	    test_bit(RPC_TASK_NEED_RECV, &task->tk_runstate) ||
+	    xprt_is_pinned_rqst(req)) {
+		spin_lock(&xprt->queue_lock);
+		xprt_request_dequeue_transmit_locked(task);
+		xprt_request_dequeue_receive_locked(task);
+		while (xprt_is_pinned_rqst(req)) {
+			set_bit(RPC_TASK_MSG_PIN_WAIT, &task->tk_runstate);
+			spin_unlock(&xprt->queue_lock);
+			xprt_wait_on_pinned_rqst(req);
+			spin_lock(&xprt->queue_lock);
+			clear_bit(RPC_TASK_MSG_PIN_WAIT, &task->tk_runstate);
+		}
+		spin_unlock(&xprt->queue_lock);
+	}
+}
+
+/**
  * xprt_request_prepare - prepare an encoded request for transport
  * @req: pointer to rpc_rqst
  *
@@ -1747,28 +1777,6 @@ void xprt_retry_reserve(struct rpc_task
 	xprt_do_reserve(xprt, task);
 }
 
-static void
-xprt_request_dequeue_all(struct rpc_task *task, struct rpc_rqst *req)
-{
-	struct rpc_xprt *xprt = req->rq_xprt;
-
-	if (test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate) ||
-	    test_bit(RPC_TASK_NEED_RECV, &task->tk_runstate) ||
-	    xprt_is_pinned_rqst(req)) {
-		spin_lock(&xprt->queue_lock);
-		xprt_request_dequeue_transmit_locked(task);
-		xprt_request_dequeue_receive_locked(task);
-		while (xprt_is_pinned_rqst(req)) {
-			set_bit(RPC_TASK_MSG_PIN_WAIT, &task->tk_runstate);
-			spin_unlock(&xprt->queue_lock);
-			xprt_wait_on_pinned_rqst(req);
-			spin_lock(&xprt->queue_lock);
-			clear_bit(RPC_TASK_MSG_PIN_WAIT, &task->tk_runstate);
-		}
-		spin_unlock(&xprt->queue_lock);
-	}
-}
-
 /**
  * xprt_release - release an RPC request slot
  * @task: task which is finished with the slot
@@ -1788,7 +1796,7 @@ void xprt_release(struct rpc_task *task)
 	}
 
 	xprt = req->rq_xprt;
-	xprt_request_dequeue_all(task, req);
+	xprt_request_dequeue_xprt(task);
 	spin_lock(&xprt->transport_lock);
 	xprt->ops->release_xprt(xprt, task);
 	if (xprt->ops->release_request)


