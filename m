Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A11C146A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbgEANjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731138AbgEANjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA961205C9;
        Fri,  1 May 2020 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340344;
        bh=mhWCNRBqxNEFicIbMOJqf+tM5VGm4UgJgeHyU1IFA/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2jao1qaPrUiPCbX0/bD+RFr+WqqY2RlFDM4z5quIfqmzsg7xz4pTyS8p4pW2kNPb
         QpAoL5lxxaEvQAXdXPhRtCG1OqM8yl9lD6IOOSLUn7HHLvKeCH05TwGRLFydZdfdla
         UGXEJOy/KR/Fx2X4LGXuGzbMFzltGy2SNY4LBQ5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 27/83] svcrdma: Fix leak of svc_rdma_recv_ctxt objects
Date:   Fri,  1 May 2020 15:23:06 +0200
Message-Id: <20200501131530.788578173@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 23cf1ee1f1869966b75518c59b5cbda4c6c92450 upstream.

Utilize the xpo_release_rqst transport method to ensure that each
rqstp's svc_rdma_recv_ctxt object is released even when the server
cannot return a Reply for that rqstp.

Without this fix, each RPC whose Reply cannot be sent leaks one
svc_rdma_recv_ctxt. This is a 2.5KB structure, a 4KB DMA-mapped
Receive buffer, and any pages that might be part of the Reply
message.

The leak is infrequent unless the network fabric is unreliable or
Kerberos is in use, as GSS sequence window overruns, which result
in connection loss, are more common on fast transports.

Fixes: 3a88092ee319 ("svcrdma: Preserve Receive buffer until svc_rdma_sendto")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/svc_rdma.h          |    1 +
 net/sunrpc/svc_xprt.c                    |    3 ---
 net/sunrpc/svcsock.c                     |    4 ++++
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |   22 ++++++++++++++++++++++
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   13 +++----------
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    5 -----
 6 files changed, 30 insertions(+), 18 deletions(-)

--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -162,6 +162,7 @@ extern bool svc_rdma_post_recvs(struct s
 extern void svc_rdma_recv_ctxt_put(struct svcxprt_rdma *rdma,
 				   struct svc_rdma_recv_ctxt *ctxt);
 extern void svc_rdma_flush_recv_queues(struct svcxprt_rdma *rdma);
+extern void svc_rdma_release_rqst(struct svc_rqst *rqstp);
 extern int svc_rdma_recvfrom(struct svc_rqst *);
 
 /* svc_rdma_rw.c */
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -897,9 +897,6 @@ int svc_send(struct svc_rqst *rqstp)
 	if (!xprt)
 		goto out;
 
-	/* release the receive skb before sending the reply */
-	xprt->xpt_ops->xpo_release_rqst(rqstp);
-
 	/* calculate over-all length */
 	xb = &rqstp->rq_res;
 	xb->len = xb->head[0].iov_len +
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -605,6 +605,8 @@ svc_udp_sendto(struct svc_rqst *rqstp)
 {
 	int		error;
 
+	svc_release_udp_skb(rqstp);
+
 	error = svc_sendto(rqstp, &rqstp->rq_res);
 	if (error == -ECONNREFUSED)
 		/* ICMP error on earlier request. */
@@ -1137,6 +1139,8 @@ static int svc_tcp_sendto(struct svc_rqs
 	int sent;
 	__be32 reclen;
 
+	svc_release_skb(rqstp);
+
 	/* Set up the first element of the reply kvec.
 	 * Any other kvecs that may be in use have been taken
 	 * care of by the server implementation itself.
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -222,6 +222,26 @@ void svc_rdma_recv_ctxt_put(struct svcxp
 		svc_rdma_recv_ctxt_destroy(rdma, ctxt);
 }
 
+/**
+ * svc_rdma_release_rqst - Release transport-specific per-rqst resources
+ * @rqstp: svc_rqst being released
+ *
+ * Ensure that the recv_ctxt is released whether or not a Reply
+ * was sent. For example, the client could close the connection,
+ * or svc_process could drop an RPC, before the Reply is sent.
+ */
+void svc_rdma_release_rqst(struct svc_rqst *rqstp)
+{
+	struct svc_rdma_recv_ctxt *ctxt = rqstp->rq_xprt_ctxt;
+	struct svc_xprt *xprt = rqstp->rq_xprt;
+	struct svcxprt_rdma *rdma =
+		container_of(xprt, struct svcxprt_rdma, sc_xprt);
+
+	rqstp->rq_xprt_ctxt = NULL;
+	if (ctxt)
+		svc_rdma_recv_ctxt_put(rdma, ctxt);
+}
+
 static int __svc_rdma_post_recv(struct svcxprt_rdma *rdma,
 				struct svc_rdma_recv_ctxt *ctxt)
 {
@@ -756,6 +776,8 @@ int svc_rdma_recvfrom(struct svc_rqst *r
 	__be32 *p;
 	int ret;
 
+	rqstp->rq_xprt_ctxt = NULL;
+
 	spin_lock(&rdma_xprt->sc_rq_dto_lock);
 	ctxt = svc_rdma_next_recv_ctxt(&rdma_xprt->sc_read_complete_q);
 	if (ctxt) {
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -873,12 +873,7 @@ int svc_rdma_sendto(struct svc_rqst *rqs
 				      wr_lst, rp_ch);
 	if (ret < 0)
 		goto err1;
-	ret = 0;
-
-out:
-	rqstp->rq_xprt_ctxt = NULL;
-	svc_rdma_recv_ctxt_put(rdma, rctxt);
-	return ret;
+	return 0;
 
  err2:
 	if (ret != -E2BIG && ret != -EINVAL)
@@ -887,14 +882,12 @@ out:
 	ret = svc_rdma_send_error_msg(rdma, sctxt, rqstp);
 	if (ret < 0)
 		goto err1;
-	ret = 0;
-	goto out;
+	return 0;
 
  err1:
 	svc_rdma_send_ctxt_put(rdma, sctxt);
  err0:
 	trace_svcrdma_send_failed(rqstp, ret);
 	set_bit(XPT_CLOSE, &xprt->xpt_flags);
-	ret = -ENOTCONN;
-	goto out;
+	return -ENOTCONN;
 }
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -71,7 +71,6 @@ static struct svc_xprt *svc_rdma_create(
 					struct sockaddr *sa, int salen,
 					int flags);
 static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt);
-static void svc_rdma_release_rqst(struct svc_rqst *);
 static void svc_rdma_detach(struct svc_xprt *xprt);
 static void svc_rdma_free(struct svc_xprt *xprt);
 static int svc_rdma_has_wspace(struct svc_xprt *xprt);
@@ -558,10 +557,6 @@ static struct svc_xprt *svc_rdma_accept(
 	return NULL;
 }
 
-static void svc_rdma_release_rqst(struct svc_rqst *rqstp)
-{
-}
-
 /*
  * When connected, an svc_xprt has at least two references:
  *


