Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE51C394B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 14:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgEDM0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 08:26:44 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54469 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbgEDM0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 08:26:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A0556357;
        Mon,  4 May 2020 08:26:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 08:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7hS//R
        dh6H92eCbhu/Z5u4ZDxZCqNljl3wkPyjsjwFE=; b=BUn0meIzNwG36Wv3wHN4hJ
        vYjKC05SyZ1SNZlnri99omDAKdjR88c9WokroLCkTnLUZ6xm2AcZrnb1FB6C0BIy
        LDz1FuZOA03XBpia826cC6DN/5GdjElbCacCgfq9/do33OgldLVs33B/1xsvzt5f
        t3nzEDmE9lDcsZXWjpbQyIIppbzQargc0fS4GkbxZ7o/vfe0/uaX7vnuGuESI3nZ
        JLRr4idnlpuzcKyDzGLe+279Otso2HDqxUOEIK6Wrm0U7fK+vQedg2Ik5xaQJGJQ
        ulQJM68hZ2O4pj4Na8YchtFGbaCOYlYPbzwuVctQKqGtVA7kggqM5RWt6HlM1fKw
        ==
X-ME-Sender: <xms:AwqwXh0w8NdB5dEfnoxqJjDZZ1wktZMNI1Cbe2c_c60D_jx_YEKYXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:AwqwXjzBaQtz9smKpdnlhbk6rpYsLH7eV8RAF_B1VbVvvJlNrD0NjA>
    <xmx:AwqwXp4io3tp138UvDj6B4WumoHKS3blQELZxwzPgmY_7HemfB2xYQ>
    <xmx:AwqwXs9A8mfKPiOWs41U23ozccTL-fZVXa29FMZCk8GiqmxfrSHXSg>
    <xmx:AwqwXgi1jS6U4zEwCZyX4si4OitJULtgcyA0kpSKOJ1JJijgjC6-ARfNKPk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE16B3066007;
        Mon,  4 May 2020 08:26:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xprtrdma: Fix trace point use-after-free race" failed to apply to 4.4-stable tree
To:     chuck.lever@oracle.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 14:26:37 +0200
Message-ID: <1588595197132197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bdb2ce82818577ba6e57b7d68b698b8d17329281 Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Sun, 19 Apr 2020 20:03:05 -0400
Subject: [PATCH] xprtrdma: Fix trace point use-after-free race

It's not safe to use resources pointed to by the @send_wr of
ib_post_send() _after_ that function returns. Those resources are
typically freed by the Send completion handler, which can run before
ib_post_send() returns.

Thus the trace points currently around ib_post_send() in the
client's RPC/RDMA transport are a hazard, even when they are
disabled. Rearrange them so that they touch the Work Request only
_before_ ib_post_send() is invoked.

Fixes: ab03eff58eb5 ("xprtrdma: Add trace points in RPC Call transmit paths")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index 051f26fedc4d..72f043876019 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -692,11 +692,10 @@ TRACE_EVENT(xprtrdma_prepsend_failed,
 
 TRACE_EVENT(xprtrdma_post_send,
 	TP_PROTO(
-		const struct rpcrdma_req *req,
-		int status
+		const struct rpcrdma_req *req
 	),
 
-	TP_ARGS(req, status),
+	TP_ARGS(req),
 
 	TP_STRUCT__entry(
 		__field(const void *, req)
@@ -705,7 +704,6 @@ TRACE_EVENT(xprtrdma_post_send,
 		__field(unsigned int, client_id)
 		__field(int, num_sge)
 		__field(int, signaled)
-		__field(int, status)
 	),
 
 	TP_fast_assign(
@@ -718,15 +716,13 @@ TRACE_EVENT(xprtrdma_post_send,
 		__entry->sc = req->rl_sendctx;
 		__entry->num_sge = req->rl_wr.num_sge;
 		__entry->signaled = req->rl_wr.send_flags & IB_SEND_SIGNALED;
-		__entry->status = status;
 	),
 
-	TP_printk("task:%u@%u req=%p sc=%p (%d SGE%s) %sstatus=%d",
+	TP_printk("task:%u@%u req=%p sc=%p (%d SGE%s) %s",
 		__entry->task_id, __entry->client_id,
 		__entry->req, __entry->sc, __entry->num_sge,
 		(__entry->num_sge == 1 ? "" : "s"),
-		(__entry->signaled ? "signaled " : ""),
-		__entry->status
+		(__entry->signaled ? "signaled" : "")
 	)
 );
 
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 29ae982d69cf..05c4d3a9cda2 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1356,8 +1356,8 @@ int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 		--ep->re_send_count;
 	}
 
+	trace_xprtrdma_post_send(req);
 	rc = frwr_send(r_xprt, req);
-	trace_xprtrdma_post_send(req, rc);
 	if (rc)
 		return -ENOTCONN;
 	return 0;

