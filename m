Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DEA3834E2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243227AbhEQPNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241879AbhEQPLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4469461864;
        Mon, 17 May 2021 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261857;
        bh=U6gq9psvxV9ReQVnJZJjIA78xvwHY8/l1lAawTQkcvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdAmARxQHK5M60tNDLc9QLXnFgAGkVPWfq6ZO1oR+KlzBBb15B/+s61kZh4Ib85Gm
         2fXzJJiOqo5ee+npTxWhWvcv4HnG8gnSz9qP1DKpHPz0WTONPK4uzQEy2k7mwlJj5f
         L6bY3mLrodLoMYnx7kxxNrfPtszR352Yj3Vtuitc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 169/329] xprtrdma: Fix cwnd update ordering
Date:   Mon, 17 May 2021 16:01:20 +0200
Message-Id: <20210517140307.848909421@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 8f5d0cb68360..d40ace8a973d 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1459,9 +1459,10 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 		credits = 1;	/* don't deadlock */
 	else if (credits > r_xprt->rx_ep->re_max_requests)
 		credits = r_xprt->rx_ep->re_max_requests;
+	rpcrdma_post_recvs(r_xprt, credits + (buf->rb_bc_srv_max_requests << 1),
+			   false);
 	if (buf->rb_credits != credits)
 		rpcrdma_update_cwnd(r_xprt, credits);
-	rpcrdma_post_recvs(r_xprt, false);
 
 	req = rpcr_to_rdmar(rqst);
 	if (unlikely(req->rl_reply))
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index ec912cf9c618..f3fffc74ab0f 100644
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
@@ -1364,21 +1364,21 @@ int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
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
index 94b28657aeeb..c3bcc84c16c4 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -460,7 +460,7 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt);
 void rpcrdma_xprt_disconnect(struct rpcrdma_xprt *r_xprt);
 
 int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req);
-void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp);
+void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp);
 
 /*
  * Buffer calls - xprtrdma/verbs.c
-- 
2.30.2



