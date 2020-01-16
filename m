Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4162C13FD27
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388010AbgAPXWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733309AbgAPXWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAF32072E;
        Thu, 16 Jan 2020 23:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216952;
        bh=qoJiw2UXqelVfmejQw9na4k5RWtdEIUMon8F8KKTfQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1tSku9dsfQIJQ7SruDHJUTsAU0PUlDg2wmnQyEZsSepN9L3FMYhEMPMMUGDlnPeC
         xCNKFaBFn/3bgfl4TexVb1IlGq/JWc98Pl1BO45wGF1GU9aC6vzvyNKR27m1UUE9ZK
         wYcTSbO2IdI7fRRQjSjSHxcL5cgNE24HgU8/AVIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 071/203] xprtrdma: Close window between waking RPC senders and posting Receives
Date:   Fri, 17 Jan 2020 00:16:28 +0100
Message-Id: <20200116231750.370321270@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 2ae50ad68cd79224198b525f7bd645c9da98b6ff upstream.

A recent clean up attempted to separate Receive handling and RPC
Reply processing, in the name of clean layering.

Unfortunately, we can't do this because the Receive Queue has to be
refilled _after_ the most recent credit update from the responder
is parsed from the transport header, but _before_ we wake up the
next RPC sender. That is right in the middle of
rpcrdma_reply_handler().

Usually this isn't a problem because current responder
implementations don't vary their credit grant. The one exception is
when a connection is established: the grant goes from one to a much
larger number on the first Receive. The requester MUST post enough
Receives right then so that any outstanding requests can be sent
without risking RNR and connection loss.

Fixes: 6ceea36890a0 ("xprtrdma: Refactor Receive accounting")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/rpc_rdma.c  |    1 +
 net/sunrpc/xprtrdma/verbs.c     |   11 +++++++----
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1362,6 +1362,7 @@ void rpcrdma_reply_handler(struct rpcrdm
 		xprt->cwnd = credits << RPC_CWNDSHIFT;
 		spin_unlock(&xprt->transport_lock);
 	}
+	rpcrdma_post_recvs(r_xprt, false);
 
 	req = rpcr_to_rdmar(rqst);
 	if (req->rl_reply) {
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -84,7 +84,6 @@ rpcrdma_regbuf_alloc(size_t size, enum d
 		     gfp_t flags);
 static void rpcrdma_regbuf_dma_unmap(struct rpcrdma_regbuf *rb);
 static void rpcrdma_regbuf_free(struct rpcrdma_regbuf *rb);
-static void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp);
 
 /* Wait for outstanding transport work to finish. ib_drain_qp
  * handles the drains in the wrong order for us, so open code
@@ -170,7 +169,6 @@ rpcrdma_wc_receive(struct ib_cq *cq, str
 				   rdmab_addr(rep->rr_rdmabuf),
 				   wc->byte_len, DMA_FROM_DEVICE);
 
-	rpcrdma_post_recvs(r_xprt, false);
 	rpcrdma_reply_handler(rep);
 	return;
 
@@ -1478,8 +1476,13 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
 	return 0;
 }
 
-static void
-rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp)
+/**
+ * rpcrdma_post_recvs - Refill the Receive Queue
+ * @r_xprt: controlling transport instance
+ * @temp: mark Receive buffers to be deleted after use
+ *
+ */
+void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp)
 {
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
 	struct rpcrdma_ep *ep = &r_xprt->rx_ep;
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -474,6 +474,7 @@ void rpcrdma_ep_disconnect(struct rpcrdm
 
 int rpcrdma_ep_post(struct rpcrdma_ia *, struct rpcrdma_ep *,
 				struct rpcrdma_req *);
+void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp);
 
 /*
  * Buffer calls - xprtrdma/verbs.c


