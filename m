Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8A338364C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244440AbhEQPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244288AbhEQP2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E76F3613E6;
        Mon, 17 May 2021 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262221;
        bh=ln8DgWZZl6wormKnAE4by+2Kwd7NdGMYCXGrSFP0qZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKFAfod20V746/Vdwbxor3ewXkf58vAUETl86GwpdGqO5z0hVxj4hMwnvrPL8o1uE
         oCoDYFiNrVyjIVzNrL6viRb861otcK6hfWjv0KzENf2uwPd2IE6BAHy3NsworRyx20
         LzP5UviDMjPHzzolW7dIZrYcvISmFJ14NZFjXS48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/289] xprtrdma: Fix cwnd update ordering
Date:   Mon, 17 May 2021 16:01:01 +0200
Message-Id: <20210517140309.740242381@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 35d8b10a25884050bb3b0149b62c3818ec59f77c ]

After a reconnect, the reply handler is opening the cwnd (and thus
enabling more RPC Calls to be sent) /before/ rpcrdma_post_recvs()
can post enough Receive WRs to receive their replies. This causes an
RNR and the new connection is lost immediately.

The race is most clearly exposed when KASAN and disconnect injection
are enabled. This slows down rpcrdma_rep_create() enough to allow
the send side to post a bunch of RPC Calls before the Receive
completion handler can invoke ib_post_recv().

Fixes: 2ae50ad68cd7 ("xprtrdma: Close window between waking RPC senders and posting Receives")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c  |  3 ++-
 net/sunrpc/xprtrdma/verbs.c     | 10 +++++-----
 net/sunrpc/xprtrdma/xprt_rdma.h |  2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index c48536f2121f..ca267a855a12 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1467,9 +1467,10 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 		credits = 1;	/* don't deadlock */
 	else if (credits > r_xprt->rx_ep->re_max_requests)
 		credits = r_xprt->rx_ep->re_max_requests;
+	rpcrdma_post_recvs(r_xprt, credits + (buf->rb_bc_srv_max_requests << 1),
+			   false);
 	if (buf->rb_credits != credits)
 		rpcrdma_update_cwnd(r_xprt, credits);
-	rpcrdma_post_recvs(r_xprt, false);
 
 	req = rpcr_to_rdmar(rqst);
 	if (req->rl_reply) {
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index ad6e2e4994ce..04325f0267c1 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -535,7 +535,7 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 	 * outstanding Receives.
 	 */
 	rpcrdma_ep_get(ep);
-	rpcrdma_post_recvs(r_xprt, true);
+	rpcrdma_post_recvs(r_xprt, 1, true);
 
 	rc = rdma_connect(ep->re_id, &ep->re_remote_cma);
 	if (rc)
@@ -1377,21 +1377,21 @@ int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 /**
  * rpcrdma_post_recvs - Refill the Receive Queue
  * @r_xprt: controlling transport instance
- * @temp: mark Receive buffers to be deleted after use
+ * @needed: current credit grant
+ * @temp: mark Receive buffers to be deleted after one use
  *
  */
-void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp)
+void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 {
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
 	struct rpcrdma_ep *ep = r_xprt->rx_ep;
 	struct ib_recv_wr *wr, *bad_wr;
 	struct rpcrdma_rep *rep;
-	int needed, count, rc;
+	int count, rc;
 
 	rc = 0;
 	count = 0;
 
-	needed = buf->rb_credits + (buf->rb_bc_srv_max_requests << 1);
 	if (likely(ep->re_receive_count > needed))
 		goto out;
 	needed -= ep->re_receive_count;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 43974ef39a50..3cacc6f4c527 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -452,7 +452,7 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt);
 void rpcrdma_xprt_disconnect(struct rpcrdma_xprt *r_xprt);
 
 int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req);
-void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp);
+void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp);
 
 /*
  * Buffer calls - xprtrdma/verbs.c
-- 
2.30.2



