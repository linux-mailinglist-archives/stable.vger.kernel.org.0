Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2971C399D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 14:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgEDMmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 08:42:19 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51927 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727103AbgEDMmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 08:42:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 1EE726C5;
        Mon,  4 May 2020 08:42:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 08:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OTM/sc
        cuMXYZDQ/ArEobdGZuYHgagOaPFksxalld0fo=; b=SRgrKgSbJldUFo3u03P3V2
        UNNfzDG5DVcMOiSGN1ZMLJSg+PqteOqj82JgmxN57QA+jLs7vpehLh1zXHWXM6sG
        E9RT0BGIOfQIHZu8e6u86xISPK+nfQpSCowAzBKfnhLuE2RkHGIxXk35QcI3HroB
        /Nle1K4yb+ZkCsPzdVOh2bSa1LpSVLXMYu8FjX4jr27Dj/H7py+EV/5NAOJkGjlX
        bPre+SYn0V0lM1ETsIgDvyAr0lfjbHpF9nBWSk049iVU/t8HDQA6RLtiUfMvtCaH
        nosP6o78RTc0Uy+9g0EP9pQ1rnUvEAqC9jHRWKsBpM6JPFKH7TzbEuXnxOw+it+w
        ==
X-ME-Sender: <xms:qA2wXuBLJyT8BY6b5a-79thQiWaHxgFV7wMK9vctQaMHSVroX_WXkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:qA2wXoS5NXp_Mbbvut8942Ewd10kfFLeSp9tQCeKQqhnPG3Wi6-mlw>
    <xmx:qA2wXkE5hCe7_INZNGZV7QX8lodw9gFtdS6JD7MlllzwOWL5reRf5A>
    <xmx:qA2wXsHITpv69xfDYm7t02dptEYjzB1yDwXONLOHcYu23BnoUsMESw>
    <xmx:qA2wXv8c4WCqnCeiNbsmCx_30Go5IKNol2eorBRAhTT0YDnc6oenmESgs3E>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02E803280060;
        Mon,  4 May 2020 08:42:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xprtrdma: Fix trace point use-after-free race" failed to apply to 5.6-stable tree
To:     chuck.lever@oracle.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 14:41:43 +0200
Message-ID: <158859610337134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
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

