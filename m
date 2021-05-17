Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3475383414
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbhEQPFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242543AbhEQPCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A17D61493;
        Mon, 17 May 2021 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261664;
        bh=udhIfNy6AghWVRixPerSegAgZTYFpkeriRae/MKt/24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3t8zJMKXf+VUe4CqN7rhPowUHsleEHXI7QmdGRA3RsRW7ho+L4sMzrS/ijWp2SsG
         2nR5RvZU2MJJWtCHlC0aNFFZVDTjyV7Km7JntqM/mTXDS5gRWGVbwXy+Kk6aVXo3QS
         xPMVsiUG/FWzsJ8YRugiLY3aIXJ+Kk2fGYzborSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 147/329] SUNRPC: Move fault injection call sites
Date:   Mon, 17 May 2021 16:00:58 +0200
Message-Id: <20210517140307.093136189@linuxfoundation.org>
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

[ Upstream commit 7638e0bfaed1b653d3ca663e560e9ffb44bb1030 ]

I've hit some crashes that occur in the xprt_rdma_inject_disconnect
path. It appears that, for some provides, rdma_disconnect() can
take so long that the transport can disconnect and release its
hardware resources while rdma_disconnect() is still running,
resulting in a UAF in the provider.

The transport's fault injection method may depend on the stability
of transport data structures. That means it needs to be invoked
only from contexts that hold the transport write lock.

Fixes: 4a0682583988 ("SUNRPC: Transport fault injection")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c               | 1 -
 net/sunrpc/xprt.c               | 6 ++++--
 net/sunrpc/xprtrdma/transport.c | 6 ++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 612f0a641f4c..c2a01125be1a 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1799,7 +1799,6 @@ call_allocate(struct rpc_task *task)
 
 	status = xprt->ops->buf_alloc(task);
 	trace_rpc_buf_alloc(task, status);
-	xprt_inject_disconnect(xprt);
 	if (status == 0)
 		return;
 	if (status != -ENOMEM) {
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 691ccf8049a4..d616b93751d8 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1483,7 +1483,10 @@ bool xprt_prepare_transmit(struct rpc_task *task)
 
 void xprt_end_transmit(struct rpc_task *task)
 {
-	xprt_release_write(task->tk_rqstp->rq_xprt, task);
+	struct rpc_xprt	*xprt = task->tk_rqstp->rq_xprt;
+
+	xprt_inject_disconnect(xprt);
+	xprt_release_write(xprt, task);
 }
 
 /**
@@ -1885,7 +1888,6 @@ void xprt_release(struct rpc_task *task)
 	spin_unlock(&xprt->transport_lock);
 	if (req->rq_buffer)
 		xprt->ops->buf_free(task);
-	xprt_inject_disconnect(xprt);
 	xdr_free_bvec(&req->rq_rcv_buf);
 	xdr_free_bvec(&req->rq_snd_buf);
 	if (req->rq_cred != NULL)
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 78d29d1bcc20..09953597d055 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -262,8 +262,10 @@ xprt_rdma_connect_worker(struct work_struct *work)
  * xprt_rdma_inject_disconnect - inject a connection fault
  * @xprt: transport context
  *
- * If @xprt is connected, disconnect it to simulate spurious connection
- * loss.
+ * If @xprt is connected, disconnect it to simulate spurious
+ * connection loss. Caller must hold @xprt's send lock to
+ * ensure that data structures and hardware resources are
+ * stable during the rdma_disconnect() call.
  */
 static void
 xprt_rdma_inject_disconnect(struct rpc_xprt *xprt)
-- 
2.30.2



