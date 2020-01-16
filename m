Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7910D13FFE8
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgAPXqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389145AbgAPXW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E22B2072E;
        Thu, 16 Jan 2020 23:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216947;
        bh=+u79EGEWU7tG3I/iN79MCTPpFJk0xtRQEd8Du1GoO2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YN0DkP0ddflbcXo9rP5NiPYIyGJSQbNBx5bdre+4Vm9Jkg7+iS/X1If/FamD+GCX/
         660HVghCAjtUvwXLt0YvG/nIC4Lu5oM7ALYeEk91c89JddQT7liTYgTmTcWbBunMar
         84DntYInnDVFxZ55TWVVH4kKqM6gNvSyrdh1iBOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 069/203] xprtrdma: Connection becomes unstable after a reconnect
Date:   Fri, 17 Jan 2020 00:16:26 +0100
Message-Id: <20200116231750.164006120@linuxfoundation.org>
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

commit a31b2f939219dd9bffdf01a45bd91f209f8cc369 upstream.

This is because xprt_request_get_cong() is allowing more than one
RPC Call to be transmitted before the first Receive on the new
connection. The first Receive fills the Receive Queue based on the
server's credit grant. Before that Receive, there is only a single
Receive WR posted because the client doesn't know the server's
credit grant.

Solution is to clear rq_cong on all outstanding rpc_rqsts when the
the cwnd is reset. This is because an RPC/RDMA credit is good for
one connection instance only.

Fixes: 75891f502f5f ("SUNRPC: Support for congestion control ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/transport.c |    3 +++
 net/sunrpc/xprtrdma/verbs.c     |   22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -428,8 +428,11 @@ void xprt_rdma_close(struct rpc_xprt *xp
 	/* Prepare @xprt for the next connection by reinitializing
 	 * its credit grant to one (see RFC 8166, Section 3.3.3).
 	 */
+	spin_lock(&xprt->transport_lock);
 	r_xprt->rx_buf.rb_credits = 1;
+	xprt->cong = 0;
 	xprt->cwnd = RPC_CWNDSHIFT;
+	spin_unlock(&xprt->transport_lock);
 
 out:
 	xprt->reestablish_timeout = 0;
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -75,6 +75,7 @@
  * internal functions
  */
 static void rpcrdma_sendctx_put_locked(struct rpcrdma_sendctx *sc);
+static void rpcrdma_reqs_reset(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_reps_destroy(struct rpcrdma_buffer *buf);
 static void rpcrdma_mrs_create(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_mrs_destroy(struct rpcrdma_buffer *buf);
@@ -780,6 +781,7 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep
 	trace_xprtrdma_disconnect(r_xprt, rc);
 
 	rpcrdma_xprt_drain(r_xprt);
+	rpcrdma_reqs_reset(r_xprt);
 }
 
 /* Fixed-size circular FIFO queue. This implementation is wait-free and
@@ -1042,6 +1044,26 @@ out1:
 	return NULL;
 }
 
+/**
+ * rpcrdma_reqs_reset - Reset all reqs owned by a transport
+ * @r_xprt: controlling transport instance
+ *
+ * ASSUMPTION: the rb_allreqs list is stable for the duration,
+ * and thus can be walked without holding rb_lock. Eg. the
+ * caller is holding the transport send lock to exclude
+ * device removal or disconnection.
+ */
+static void rpcrdma_reqs_reset(struct rpcrdma_xprt *r_xprt)
+{
+	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
+	struct rpcrdma_req *req;
+
+	list_for_each_entry(req, &buf->rb_allreqs, rl_all) {
+		/* Credits are valid only for one connection */
+		req->rl_slot.rq_cong = 0;
+	}
+}
+
 static struct rpcrdma_rep *rpcrdma_rep_create(struct rpcrdma_xprt *r_xprt,
 					      bool temp)
 {


