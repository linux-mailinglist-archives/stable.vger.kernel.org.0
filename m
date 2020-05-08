Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CFE1CAF80
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgEHMkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbgEHMkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E19D21835;
        Fri,  8 May 2020 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941615;
        bh=6uqWm6HgmX1j4KNLXi6sBJlCOQN9Fv5P2ay+6/T0/Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGvrEfQ4fCkKJoQZLfMYwF7Vffofe6+LaEsOzH48151QOZpmETkUPbpCe9CTf99Cp
         qtqmkqg2I/R8DBokckcuoLxJCyA9qV1rKv312KRKNbWmkzD4vJoAWl42NhbryXCu7V
         Y4Ro+eBGdYA1oiZ71FQqQtn96Oe4OAPLnSN3GPU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Devesh Sharma <devesh.sharma@avagotech.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.4 101/312] xprtrdma: Fix additional uses of spin_lock_irqsave(rb_lock)
Date:   Fri,  8 May 2020 14:31:32 +0200
Message-Id: <20200508123131.625057345@linuxfoundation.org>
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

commit 9b06688bc3b9f13f8de90f832c455fddec3d4e8a upstream.

Clean up.

rb_lock critical sections added in rpcrdma_ep_post_extra_recv()
should have first been converted to use normal spin_lock now that
the reply handler is a work queue.

The backchannel set up code should use the appropriate helper
instead of open-coding a rb_recv_bufs list add.

Problem introduced by glib patch re-ordering on my part.

Fixes: f531a5dbc451 ('xprtrdma: Pre-allocate backward rpc_rqst')
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Devesh Sharma <devesh.sharma@avagotech.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/backchannel.c |    6 +-----
 net/sunrpc/xprtrdma/verbs.c       |    7 +++----
 2 files changed, 4 insertions(+), 9 deletions(-)

--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -84,9 +84,7 @@ out_fail:
 static int rpcrdma_bc_setup_reps(struct rpcrdma_xprt *r_xprt,
 				 unsigned int count)
 {
-	struct rpcrdma_buffer *buffers = &r_xprt->rx_buf;
 	struct rpcrdma_rep *rep;
-	unsigned long flags;
 	int rc = 0;
 
 	while (count--) {
@@ -98,9 +96,7 @@ static int rpcrdma_bc_setup_reps(struct
 			break;
 		}
 
-		spin_lock_irqsave(&buffers->rb_lock, flags);
-		list_add(&rep->rr_list, &buffers->rb_recv_bufs);
-		spin_unlock_irqrestore(&buffers->rb_lock, flags);
+		rpcrdma_recv_buffer_put(rep);
 	}
 
 	return rc;
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1337,15 +1337,14 @@ rpcrdma_ep_post_extra_recv(struct rpcrdm
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct rpcrdma_ep *ep = &r_xprt->rx_ep;
 	struct rpcrdma_rep *rep;
-	unsigned long flags;
 	int rc;
 
 	while (count--) {
-		spin_lock_irqsave(&buffers->rb_lock, flags);
+		spin_lock(&buffers->rb_lock);
 		if (list_empty(&buffers->rb_recv_bufs))
 			goto out_reqbuf;
 		rep = rpcrdma_buffer_get_rep_locked(buffers);
-		spin_unlock_irqrestore(&buffers->rb_lock, flags);
+		spin_unlock(&buffers->rb_lock);
 
 		rc = rpcrdma_ep_post_recv(ia, ep, rep);
 		if (rc)
@@ -1355,7 +1354,7 @@ rpcrdma_ep_post_extra_recv(struct rpcrdm
 	return 0;
 
 out_reqbuf:
-	spin_unlock_irqrestore(&buffers->rb_lock, flags);
+	spin_unlock(&buffers->rb_lock);
 	pr_warn("%s: no extra receive buffers\n", __func__);
 	return -ENOMEM;
 


