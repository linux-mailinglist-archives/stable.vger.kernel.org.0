Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180E059D398
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242419AbiHWIRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242453AbiHWIPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:15:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923686D549;
        Tue, 23 Aug 2022 01:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9749611DD;
        Tue, 23 Aug 2022 08:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B322AC433D6;
        Tue, 23 Aug 2022 08:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242205;
        bh=Rlf/zyX8NPwzyZUHc+x5tXVEWl4HgHAxexgD2KZSQOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2y5ZD72SfY/eWuK1zqErGhG40Wei1n7IDup6btDPiTXC5XT7go7NLaNEf51pV5xc
         RUlfWAB8cEJ4dGJHGV7nvRTZ1ZsMSOxTMS0gSmSSiEt+8wvzA9wlRLn14a3KEpB6iV
         eSrzaJyHT3K9IfHDHS0IZAiKvrnqvvEJoaoORJEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.19 076/365] SUNRPC: Dont reuse bvec on retransmission of the request
Date:   Tue, 23 Aug 2022 09:59:37 +0200
Message-Id: <20220823080121.356816589@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 72691a269f0baad6d5f4aa7af97c29081b86d70f upstream.

If a request is re-encoded and then retransmitted, we need to make sure
that we also re-encode the bvec, in case the page lists have changed.

Fixes: ff053dbbaffe ("SUNRPC: Move the call to xprt_send_pagedata() out of xprt_sock_sendmsg()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/xprt.h |    3 ++-
 net/sunrpc/clnt.c           |    1 -
 net/sunrpc/xprt.c           |   27 ++++++++++++++++++---------
 net/sunrpc/xprtsock.c       |   12 ++----------
 4 files changed, 22 insertions(+), 21 deletions(-)

--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -144,7 +144,8 @@ struct rpc_xprt_ops {
 	unsigned short	(*get_srcport)(struct rpc_xprt *xprt);
 	int		(*buf_alloc)(struct rpc_task *task);
 	void		(*buf_free)(struct rpc_task *task);
-	int		(*prepare_request)(struct rpc_rqst *req);
+	int		(*prepare_request)(struct rpc_rqst *req,
+					   struct xdr_buf *buf);
 	int		(*send_request)(struct rpc_rqst *req);
 	void		(*wait_for_reply_request)(struct rpc_task *task);
 	void		(*timer)(struct rpc_xprt *xprt, struct rpc_task *task);
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1856,7 +1856,6 @@ rpc_xdr_encode(struct rpc_task *task)
 	req->rq_snd_buf.head[0].iov_len = 0;
 	xdr_init_encode(&xdr, &req->rq_snd_buf,
 			req->rq_snd_buf.head[0].iov_base, req);
-	xdr_free_bvec(&req->rq_snd_buf);
 	if (rpc_encode_header(task, &xdr))
 		return;
 
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -73,7 +73,7 @@ static void	xprt_init(struct rpc_xprt *x
 static __be32	xprt_alloc_xid(struct rpc_xprt *xprt);
 static void	xprt_destroy(struct rpc_xprt *xprt);
 static void	xprt_request_init(struct rpc_task *task);
-static int	xprt_request_prepare(struct rpc_rqst *req);
+static int	xprt_request_prepare(struct rpc_rqst *req, struct xdr_buf *buf);
 
 static DEFINE_SPINLOCK(xprt_list_lock);
 static LIST_HEAD(xprt_list);
@@ -1149,7 +1149,7 @@ xprt_request_enqueue_receive(struct rpc_
 	if (!xprt_request_need_enqueue_receive(task, req))
 		return 0;
 
-	ret = xprt_request_prepare(task->tk_rqstp);
+	ret = xprt_request_prepare(task->tk_rqstp, &req->rq_rcv_buf);
 	if (ret)
 		return ret;
 	spin_lock(&xprt->queue_lock);
@@ -1179,8 +1179,11 @@ xprt_request_dequeue_receive_locked(stru
 {
 	struct rpc_rqst *req = task->tk_rqstp;
 
-	if (test_and_clear_bit(RPC_TASK_NEED_RECV, &task->tk_runstate))
+	if (test_and_clear_bit(RPC_TASK_NEED_RECV, &task->tk_runstate)) {
 		xprt_request_rb_remove(req->rq_xprt, req);
+		xdr_free_bvec(&req->rq_rcv_buf);
+		req->rq_private_buf.bvec = NULL;
+	}
 }
 
 /**
@@ -1336,8 +1339,14 @@ xprt_request_enqueue_transmit(struct rpc
 {
 	struct rpc_rqst *pos, *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = req->rq_xprt;
+	int ret;
 
 	if (xprt_request_need_enqueue_transmit(task, req)) {
+		ret = xprt_request_prepare(task->tk_rqstp, &req->rq_snd_buf);
+		if (ret) {
+			task->tk_status = ret;
+			return;
+		}
 		req->rq_bytes_sent = 0;
 		spin_lock(&xprt->queue_lock);
 		/*
@@ -1397,6 +1406,7 @@ xprt_request_dequeue_transmit_locked(str
 	} else
 		list_del(&req->rq_xmit2);
 	atomic_long_dec(&req->rq_xprt->xmit_queuelen);
+	xdr_free_bvec(&req->rq_snd_buf);
 }
 
 /**
@@ -1433,8 +1443,6 @@ xprt_request_dequeue_xprt(struct rpc_tas
 	    test_bit(RPC_TASK_NEED_RECV, &task->tk_runstate) ||
 	    xprt_is_pinned_rqst(req)) {
 		spin_lock(&xprt->queue_lock);
-		xprt_request_dequeue_transmit_locked(task);
-		xprt_request_dequeue_receive_locked(task);
 		while (xprt_is_pinned_rqst(req)) {
 			set_bit(RPC_TASK_MSG_PIN_WAIT, &task->tk_runstate);
 			spin_unlock(&xprt->queue_lock);
@@ -1442,6 +1450,8 @@ xprt_request_dequeue_xprt(struct rpc_tas
 			spin_lock(&xprt->queue_lock);
 			clear_bit(RPC_TASK_MSG_PIN_WAIT, &task->tk_runstate);
 		}
+		xprt_request_dequeue_transmit_locked(task);
+		xprt_request_dequeue_receive_locked(task);
 		spin_unlock(&xprt->queue_lock);
 	}
 }
@@ -1449,18 +1459,19 @@ xprt_request_dequeue_xprt(struct rpc_tas
 /**
  * xprt_request_prepare - prepare an encoded request for transport
  * @req: pointer to rpc_rqst
+ * @buf: pointer to send/rcv xdr_buf
  *
  * Calls into the transport layer to do whatever is needed to prepare
  * the request for transmission or receive.
  * Returns error, or zero.
  */
 static int
-xprt_request_prepare(struct rpc_rqst *req)
+xprt_request_prepare(struct rpc_rqst *req, struct xdr_buf *buf)
 {
 	struct rpc_xprt *xprt = req->rq_xprt;
 
 	if (xprt->ops->prepare_request)
-		return xprt->ops->prepare_request(req);
+		return xprt->ops->prepare_request(req, buf);
 	return 0;
 }
 
@@ -1961,8 +1972,6 @@ void xprt_release(struct rpc_task *task)
 	spin_unlock(&xprt->transport_lock);
 	if (req->rq_buffer)
 		xprt->ops->buf_free(task);
-	xdr_free_bvec(&req->rq_rcv_buf);
-	xdr_free_bvec(&req->rq_snd_buf);
 	if (req->rq_cred != NULL)
 		put_rpccred(req->rq_cred);
 	if (req->rq_release_snd_buf)
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -822,17 +822,9 @@ static int xs_stream_nospace(struct rpc_
 	return ret;
 }
 
-static int
-xs_stream_prepare_request(struct rpc_rqst *req)
+static int xs_stream_prepare_request(struct rpc_rqst *req, struct xdr_buf *buf)
 {
-	gfp_t gfp = rpc_task_gfp_mask();
-	int ret;
-
-	ret = xdr_alloc_bvec(&req->rq_snd_buf, gfp);
-	if (ret < 0)
-		return ret;
-	xdr_free_bvec(&req->rq_rcv_buf);
-	return xdr_alloc_bvec(&req->rq_rcv_buf, gfp);
+	return xdr_alloc_bvec(buf, rpc_task_gfp_mask());
 }
 
 /*


