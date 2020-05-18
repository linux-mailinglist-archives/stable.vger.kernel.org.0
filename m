Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885161D84BC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732657AbgERSOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732376AbgERSBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E200E20829;
        Mon, 18 May 2020 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824874;
        bh=6NoDHuyUjbD1VRYy9KYkvyxDEQqnWpl0fO+zIhe750U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/LuYQ/7TfYp6snGnudIvLzAcLsyXs7+Jq/scHOyP0f98yMdifgQ566ku5U5GgSp+
         Ys85RWRganQ7DaVoUmszcgHyO/PYeya2tqVQQWc2QIj5bD9v/RX8cXBvY/oMELC+eQ
         mn12rFVmayGua+aA1h2hsIz/GDCmc2YWjcXFLrEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 004/194] xprtrdma: Fix trace point use-after-free race
Date:   Mon, 18 May 2020 19:34:54 +0200
Message-Id: <20200518173531.920337563@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bdb2ce82818577ba6e57b7d68b698b8d17329281 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rpcrdma.h | 12 ++++--------
 net/sunrpc/xprtrdma/verbs.c    |  2 +-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index fa14adf242353..43158151821c4 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -721,11 +721,10 @@ TRACE_EVENT(xprtrdma_prepsend_failed,
 
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
@@ -734,7 +733,6 @@ TRACE_EVENT(xprtrdma_post_send,
 		__field(unsigned int, client_id)
 		__field(int, num_sge)
 		__field(int, signaled)
-		__field(int, status)
 	),
 
 	TP_fast_assign(
@@ -747,15 +745,13 @@ TRACE_EVENT(xprtrdma_post_send,
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
index 4b9fbf69b4955..a48b99f3682c3 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1523,8 +1523,8 @@ int rpcrdma_post_sends(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 		--ep->rep_send_count;
 	}
 
+	trace_xprtrdma_post_send(req);
 	rc = frwr_send(r_xprt, req);
-	trace_xprtrdma_post_send(req, rc);
 	if (rc)
 		return -ENOTCONN;
 	return 0;
-- 
2.20.1



