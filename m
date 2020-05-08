Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259901CAEAD
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgEHMpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbgEHMpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B668C21974;
        Fri,  8 May 2020 12:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941951;
        bh=+/gWU91NRcjLp1SF+8ye1yzd+kcLPTmZXVxyEtiOY+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuuWYN8L4hfo1fwHUckOkg3N3PMEHSn6BHmC2zeRXE/ikYcrJufeC3329CEoIy0in
         T4L+d+U9np00mf3UKsszIgdB8vJl/SzOU3ZRXlaP25+0YcYIILHSg3aE7ackkYmY5L
         yuT3Zn7q/NR8y8MdqZxDGTs1OwWEDApYkdcQ70KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.4 238/312] xprtrdma: Fix backchannel allocation of extra rpcrdma_reps
Date:   Fri,  8 May 2020 14:33:49 +0200
Message-Id: <20200508123141.165135340@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit d698c4a02ee02053bbebe051322ff427a2dad56a upstream.

The backchannel code uses rpcrdma_recv_buffer_put to add new reps
to the free rep list. This also decrements rb_recv_count, which
spoofs the receive overrun logic in rpcrdma_buffer_get_rep.

Commit 9b06688bc3b9 ("xprtrdma: Fix additional uses of
spin_lock_irqsave(rb_lock)") replaced the original open-coded
list_add with a call to rpcrdma_recv_buffer_put(), but then a year
later, commit 05c974669ece ("xprtrdma: Fix receive buffer
accounting") added rep accounting to rpcrdma_recv_buffer_put.
It was an oversight to let the backchannel continue to use this
function.

The fix this, let's combine the "add to free list" logic with
rpcrdma_create_rep.

Also, do not allocate RPCRDMA_MAX_BC_REQUESTS rpcrdma_reps in
rpcrdma_buffer_create and then allocate additional rpcrdma_reps in
rpcrdma_bc_setup_reps. Allocating the extra reps during backchannel
set-up is sufficient.

Fixes: 05c974669ece ("xprtrdma: Fix receive buffer accounting")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/backchannel.c |   12 ++----------
 net/sunrpc/xprtrdma/verbs.c       |   34 ++++++++++++++++++++--------------
 net/sunrpc/xprtrdma/xprt_rdma.h   |    2 +-
 3 files changed, 23 insertions(+), 25 deletions(-)

--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -84,21 +84,13 @@ out_fail:
 static int rpcrdma_bc_setup_reps(struct rpcrdma_xprt *r_xprt,
 				 unsigned int count)
 {
-	struct rpcrdma_rep *rep;
 	int rc = 0;
 
 	while (count--) {
-		rep = rpcrdma_create_rep(r_xprt);
-		if (IS_ERR(rep)) {
-			pr_err("RPC:       %s: reply buffer alloc failed\n",
-			       __func__);
-			rc = PTR_ERR(rep);
+		rc = rpcrdma_create_rep(r_xprt);
+		if (rc)
 			break;
-		}
-
-		rpcrdma_recv_buffer_put(rep);
 	}
-
 	return rc;
 }
 
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -911,10 +911,17 @@ rpcrdma_create_req(struct rpcrdma_xprt *
 	return req;
 }
 
-struct rpcrdma_rep *
-rpcrdma_create_rep(struct rpcrdma_xprt *r_xprt)
+/**
+ * rpcrdma_create_rep - Allocate an rpcrdma_rep object
+ * @r_xprt: controlling transport
+ *
+ * Returns 0 on success or a negative errno on failure.
+ */
+int
+ rpcrdma_create_rep(struct rpcrdma_xprt *r_xprt)
 {
 	struct rpcrdma_create_data_internal *cdata = &r_xprt->rx_data;
+	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct rpcrdma_rep *rep;
 	int rc;
@@ -934,12 +941,18 @@ rpcrdma_create_rep(struct rpcrdma_xprt *
 	rep->rr_device = ia->ri_device;
 	rep->rr_rxprt = r_xprt;
 	INIT_WORK(&rep->rr_work, rpcrdma_receive_worker);
-	return rep;
+
+	spin_lock(&buf->rb_lock);
+	list_add(&rep->rr_list, &buf->rb_recv_bufs);
+	spin_unlock(&buf->rb_lock);
+	return 0;
 
 out_free:
 	kfree(rep);
 out:
-	return ERR_PTR(rc);
+	dprintk("RPC:       %s: reply buffer %d alloc failed\n",
+		__func__, rc);
+	return rc;
 }
 
 int
@@ -975,17 +988,10 @@ rpcrdma_buffer_create(struct rpcrdma_xpr
 	}
 
 	INIT_LIST_HEAD(&buf->rb_recv_bufs);
-	for (i = 0; i < buf->rb_max_requests + 2; i++) {
-		struct rpcrdma_rep *rep;
-
-		rep = rpcrdma_create_rep(r_xprt);
-		if (IS_ERR(rep)) {
-			dprintk("RPC:       %s: reply buffer %d alloc failed\n",
-				__func__, i);
-			rc = PTR_ERR(rep);
+	for (i = 0; i <= buf->rb_max_requests; i++) {
+		rc = rpcrdma_create_rep(r_xprt);
+		if (rc)
 			goto out;
-		}
-		list_add(&rep->rr_list, &buf->rb_recv_bufs);
 	}
 
 	return 0;
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -431,8 +431,8 @@ int rpcrdma_ep_post_recv(struct rpcrdma_
  * Buffer calls - xprtrdma/verbs.c
  */
 struct rpcrdma_req *rpcrdma_create_req(struct rpcrdma_xprt *);
-struct rpcrdma_rep *rpcrdma_create_rep(struct rpcrdma_xprt *);
 void rpcrdma_destroy_req(struct rpcrdma_ia *, struct rpcrdma_req *);
+int rpcrdma_create_rep(struct rpcrdma_xprt *r_xprt);
 int rpcrdma_buffer_create(struct rpcrdma_xprt *);
 void rpcrdma_buffer_destroy(struct rpcrdma_buffer *);
 


