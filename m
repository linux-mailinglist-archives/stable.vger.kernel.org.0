Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A5113FFE7
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389142AbgAPXW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgAPXWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 360862087E;
        Thu, 16 Jan 2020 23:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216944;
        bh=COuWNv7K28EFP5mFwnIlHQd+fYQXwF09BHhodM8sLDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KI1Etwz/bLGgFWORZGTMkt0wUw3mBZquZfJd/B+0mOH9OSWNxtBTaDETFSDKx5rnr
         xLuzGnyEyrrDvOMmUUYx0mIf8bi8dolZA7Q+Gg1Iu89Sxdf6cjq43DwyF+cTIOan3a
         9XejxQIi2nJYJBPg/Z/q3bnB4khaR/CxWvZ3YD1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Bill Baker <bill.baker@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 068/203] xprtrdma: Add unique trace points for posting Local Invalidate WRs
Date:   Fri, 17 Jan 2020 00:16:25 +0100
Message-Id: <20200116231750.078216614@linuxfoundation.org>
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

commit 4b93dab36f28e673725e5e6123ebfccf7697f96a upstream.

When adding frwr_unmap_async way back when, I re-used the existing
trace_xprtrdma_post_send() trace point to record the return code
of ib_post_send.

Unfortunately there are some cases where re-using that trace point
causes a crash. Instead, construct a trace point specific to posting
Local Invalidate WRs that will always be safe to use in that context,
and will act as a trace log eye-catcher for Local Invalidation.

Fixes: 847568942f93 ("xprtrdma: Remove fr_state")
Fixes: d8099feda483 ("xprtrdma: Reduce context switching due ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Bill Baker <bill.baker@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/rpcrdma.h |   25 +++++++++++++++++++++++++
 net/sunrpc/xprtrdma/frwr_ops.c |    4 ++--
 2 files changed, 27 insertions(+), 2 deletions(-)

--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -735,6 +735,31 @@ TRACE_EVENT(xprtrdma_post_recvs,
 	)
 );
 
+TRACE_EVENT(xprtrdma_post_linv,
+	TP_PROTO(
+		const struct rpcrdma_req *req,
+		int status
+	),
+
+	TP_ARGS(req, status),
+
+	TP_STRUCT__entry(
+		__field(const void *, req)
+		__field(int, status)
+		__field(u32, xid)
+	),
+
+	TP_fast_assign(
+		__entry->req = req;
+		__entry->status = status;
+		__entry->xid = be32_to_cpu(req->rl_slot.rq_xid);
+	),
+
+	TP_printk("req=%p xid=0x%08x status=%d",
+		__entry->req, __entry->xid, __entry->status
+	)
+);
+
 /**
  ** Completion events
  **/
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -570,7 +570,6 @@ void frwr_unmap_sync(struct rpcrdma_xprt
 	 */
 	bad_wr = NULL;
 	rc = ib_post_send(r_xprt->rx_ia.ri_id->qp, first, &bad_wr);
-	trace_xprtrdma_post_send(req, rc);
 
 	/* The final LOCAL_INV WR in the chain is supposed to
 	 * do the wake. If it was never posted, the wake will
@@ -583,6 +582,7 @@ void frwr_unmap_sync(struct rpcrdma_xprt
 
 	/* Recycle MRs in the LOCAL_INV chain that did not get posted.
 	 */
+	trace_xprtrdma_post_linv(req, rc);
 	while (bad_wr) {
 		frwr = container_of(bad_wr, struct rpcrdma_frwr,
 				    fr_invwr);
@@ -673,12 +673,12 @@ void frwr_unmap_async(struct rpcrdma_xpr
 	 */
 	bad_wr = NULL;
 	rc = ib_post_send(r_xprt->rx_ia.ri_id->qp, first, &bad_wr);
-	trace_xprtrdma_post_send(req, rc);
 	if (!rc)
 		return;
 
 	/* Recycle MRs in the LOCAL_INV chain that did not get posted.
 	 */
+	trace_xprtrdma_post_linv(req, rc);
 	while (bad_wr) {
 		frwr = container_of(bad_wr, struct rpcrdma_frwr, fr_invwr);
 		mr = container_of(frwr, struct rpcrdma_mr, frwr);


