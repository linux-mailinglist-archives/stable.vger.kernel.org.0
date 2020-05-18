Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F0C1D84C1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgERSOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732339AbgERSA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24AE520715;
        Mon, 18 May 2020 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824854;
        bh=U0nGBAXnXM7Tw+rZ0/kIFaLfed/pznDVsWUflpE+rpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl2c7RH5sfjo913putm+FAEwISwUvH1RRC2lKGqKg0ZrqfhwzMkhaDGxQO6dDxMCU
         YEhyyO/BWZnTrXF2lBd9wxKKJ/GpAqnd5NbFFE1ZMG2MA0863RuDH6y/Z4ubtlMzTw
         Ts6AEHTmNo/dHzC2gu6riEob3USVH+viNJ5lriY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 003/194] xprtrdma: Clean up the post_send path
Date:   Mon, 18 May 2020 19:34:53 +0200
Message-Id: <20200518173531.808301937@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 97d0de8812a10a66510ff95f8fe6e8d3053fd2ca ]

Clean up: Simplify the synopses of functions in the post_send path
by combining the struct rpcrdma_ia and struct rpcrdma_ep arguments.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/backchannel.c |  2 +-
 net/sunrpc/xprtrdma/frwr_ops.c    | 14 +++++++++-----
 net/sunrpc/xprtrdma/transport.c   |  2 +-
 net/sunrpc/xprtrdma/verbs.c       | 13 +++++--------
 net/sunrpc/xprtrdma/xprt_rdma.h   |  5 ++---
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index 1a0ae0c61353c..4b43910a6ed21 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -115,7 +115,7 @@ int xprt_rdma_bc_send_reply(struct rpc_rqst *rqst)
 	if (rc < 0)
 		goto failed_marshal;
 
-	if (rpcrdma_ep_post(&r_xprt->rx_ia, &r_xprt->rx_ep, req))
+	if (rpcrdma_post_sends(r_xprt, req))
 		goto drop_connection;
 	return 0;
 
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 125297c9aa3e7..79059d48f52b7 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -372,18 +372,22 @@ static void frwr_wc_fastreg(struct ib_cq *cq, struct ib_wc *wc)
 }
 
 /**
- * frwr_send - post Send WR containing the RPC Call message
- * @ia: interface adapter
- * @req: Prepared RPC Call
+ * frwr_send - post Send WRs containing the RPC Call message
+ * @r_xprt: controlling transport instance
+ * @req: prepared RPC Call
  *
  * For FRWR, chain any FastReg WRs to the Send WR. Only a
  * single ib_post_send call is needed to register memory
  * and then post the Send WR.
  *
- * Returns the result of ib_post_send.
+ * Returns the return code from ib_post_send.
+ *
+ * Caller must hold the transport send lock to ensure that the
+ * pointers to the transport's rdma_cm_id and QP are stable.
  */
-int frwr_send(struct rpcrdma_ia *ia, struct rpcrdma_req *req)
+int frwr_send(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 {
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct ib_send_wr *post_wr;
 	struct rpcrdma_mr *mr;
 
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 3cfeba68ee9a1..46e7949788e1a 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -694,7 +694,7 @@ xprt_rdma_send_request(struct rpc_rqst *rqst)
 		goto drop_connection;
 	rqst->rq_xtime = ktime_get();
 
-	if (rpcrdma_ep_post(&r_xprt->rx_ia, &r_xprt->rx_ep, req))
+	if (rpcrdma_post_sends(r_xprt, req))
 		goto drop_connection;
 
 	rqst->rq_xmit_bytes_sent += rqst->rq_snd_buf.len;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 353f61ac8d519..4b9fbf69b4955 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1502,20 +1502,17 @@ static void rpcrdma_regbuf_free(struct rpcrdma_regbuf *rb)
 }
 
 /**
- * rpcrdma_ep_post - Post WRs to a transport's Send Queue
- * @ia: transport's device information
- * @ep: transport's RDMA endpoint information
+ * rpcrdma_post_sends - Post WRs to a transport's Send Queue
+ * @r_xprt: controlling transport instance
  * @req: rpcrdma_req containing the Send WR to post
  *
  * Returns 0 if the post was successful, otherwise -ENOTCONN
  * is returned.
  */
-int
-rpcrdma_ep_post(struct rpcrdma_ia *ia,
-		struct rpcrdma_ep *ep,
-		struct rpcrdma_req *req)
+int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 {
 	struct ib_send_wr *send_wr = &req->rl_wr;
+	struct rpcrdma_ep *ep = &r_xprt->rx_ep;
 	int rc;
 
 	if (!ep->rep_send_count || kref_read(&req->rl_kref) > 1) {
@@ -1526,7 +1523,7 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
 		--ep->rep_send_count;
 	}
 
-	rc = frwr_send(ia, req);
+	rc = frwr_send(r_xprt, req);
 	trace_xprtrdma_post_send(req, rc);
 	if (rc)
 		return -ENOTCONN;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 37d5080c250b8..600574a0d8387 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -469,8 +469,7 @@ void rpcrdma_ep_destroy(struct rpcrdma_xprt *r_xprt);
 int rpcrdma_ep_connect(struct rpcrdma_ep *, struct rpcrdma_ia *);
 void rpcrdma_ep_disconnect(struct rpcrdma_ep *, struct rpcrdma_ia *);
 
-int rpcrdma_ep_post(struct rpcrdma_ia *, struct rpcrdma_ep *,
-				struct rpcrdma_req *);
+int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req);
 void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp);
 
 /*
@@ -544,7 +543,7 @@ struct rpcrdma_mr_seg *frwr_map(struct rpcrdma_xprt *r_xprt,
 				struct rpcrdma_mr_seg *seg,
 				int nsegs, bool writing, __be32 xid,
 				struct rpcrdma_mr *mr);
-int frwr_send(struct rpcrdma_ia *ia, struct rpcrdma_req *req);
+int frwr_send(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req);
 void frwr_reminv(struct rpcrdma_rep *rep, struct list_head *mrs);
 void frwr_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req);
 void frwr_unmap_async(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req);
-- 
2.20.1



