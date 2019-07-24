Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15207392F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389103AbfGXThm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389508AbfGXThk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:37:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36AC920665;
        Wed, 24 Jul 2019 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997059;
        bh=kkdb9rpIpqLfoQlsjJfFqsf8rrboPnAdP2Hxt735zmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgfGfvH/rLN2tnre85Cv93LOKbGP0bluzQBS5E76/jU6fDVJmQegCVzuJxuicva+f
         eQKq26GThp8wfHlY9HZ/k7JJZncLTk4J4VnsNuOoDW2P6O9z6xMDQNM0625daRcGD+
         DEj1+RxWTrWenLcpU61UyXWjlANM7PhAnxxlHYHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 308/413] SUNRPC: Ensure the bvecs are reset when we re-encode the RPC request
Date:   Wed, 24 Jul 2019 21:19:59 +0200
Message-Id: <20190724191757.796535775@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 75369089820473eac45e9ddd970081901a373c08 upstream.

The bvec tracks the list of pages, so if the number of pages changes
due to a re-encode, we need to reset the bvec as well.

Fixes: 277e4ab7d530 ("SUNRPC: Simplify TCP receive code by switching...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c     |    3 +--
 net/sunrpc/xprt.c     |    2 ++
 net/sunrpc/xprtsock.c |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1788,6 +1788,7 @@ rpc_xdr_encode(struct rpc_task *task)
 	req->rq_snd_buf.head[0].iov_len = 0;
 	xdr_init_encode(&xdr, &req->rq_snd_buf,
 			req->rq_snd_buf.head[0].iov_base, req);
+	xdr_free_bvec(&req->rq_snd_buf);
 	if (rpc_encode_header(task, &xdr))
 		return;
 
@@ -1827,8 +1828,6 @@ call_encode(struct rpc_task *task)
 			rpc_call_rpcerror(task, task->tk_status);
 		}
 		return;
-	} else {
-		xprt_request_prepare(task->tk_rqstp);
 	}
 
 	/* Add task to reply queue before transmission to avoid races */
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1013,6 +1013,8 @@ xprt_request_enqueue_receive(struct rpc_
 
 	if (!xprt_request_need_enqueue_receive(task, req))
 		return;
+
+	xprt_request_prepare(task->tk_rqstp);
 	spin_lock(&xprt->queue_lock);
 
 	/* Update the softirq receive buffer */
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -909,6 +909,7 @@ static int xs_nospace(struct rpc_rqst *r
 static void
 xs_stream_prepare_request(struct rpc_rqst *req)
 {
+	xdr_free_bvec(&req->rq_rcv_buf);
 	req->rq_task->tk_status = xdr_alloc_bvec(&req->rq_rcv_buf, GFP_KERNEL);
 }
 


