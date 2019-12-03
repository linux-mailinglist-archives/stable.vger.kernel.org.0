Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEC111E9C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfLCXCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:02:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbfLCWx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EE2A20865;
        Tue,  3 Dec 2019 22:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413637;
        bh=ZJ8gpXQBhU0zBIqGfk5Yz47S/EoXgQRH3InZOl3iSCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKsxlspFcicI+edsttfkauZmJzeYqoPXVP40LHdSuM3bGZBa9bluSxmhiD3pNBkRm
         9nYKcDvd++jUVHeblcMWD/dt+8kfbesUpjVOJz3Z4SKt+wb4l2ElFRcKaP9GcpdceU
         9hCbvPeT2WpwtivH6wfYmExKUfgoGc0naS4e70SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/321] xprtrdma: Prevent leak of rpcrdma_rep objects
Date:   Tue,  3 Dec 2019 23:34:29 +0100
Message-Id: <20191203223437.682769675@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 07e10308ee5da8e6132e0b737ece1c99dd651fb6 ]

If a reply has been processed but the RPC is later retransmitted
anyway, the req->rl_reply field still contains the only pointer to
the old rpcrdma rep. When the next reply comes in, the reply handler
will stomp on the rl_reply field, leaking the old rep.

A trace event is added to capture such leaks.

This problem seems to be worsened by the restructuring of the RPC
Call path in v4.20. Fully addressing this issue will require at
least a re-architecture of the disconnect logic, which is not
appropriate during -rc.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rpcrdma.h | 28 ++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/rpc_rdma.c |  4 ++++
 2 files changed, 32 insertions(+)

diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index 53df203b8057a..4c91cadd1871d 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -917,6 +917,34 @@ TRACE_EVENT(xprtrdma_cb_setup,
 DEFINE_CB_EVENT(xprtrdma_cb_call);
 DEFINE_CB_EVENT(xprtrdma_cb_reply);
 
+TRACE_EVENT(xprtrdma_leaked_rep,
+	TP_PROTO(
+		const struct rpc_rqst *rqst,
+		const struct rpcrdma_rep *rep
+	),
+
+	TP_ARGS(rqst, rep),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, task_id)
+		__field(unsigned int, client_id)
+		__field(u32, xid)
+		__field(const void *, rep)
+	),
+
+	TP_fast_assign(
+		__entry->task_id = rqst->rq_task->tk_pid;
+		__entry->client_id = rqst->rq_task->tk_client->cl_clid;
+		__entry->xid = be32_to_cpu(rqst->rq_xid);
+		__entry->rep = rep;
+	),
+
+	TP_printk("task:%u@%u xid=0x%08x rep=%p",
+		__entry->task_id, __entry->client_id, __entry->xid,
+		__entry->rep
+	)
+);
+
 /**
  ** Server-side RPC/RDMA events
  **/
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index c8ae983c6cc01..f2eaf264726be 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1360,6 +1360,10 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 	spin_unlock(&xprt->recv_lock);
 
 	req = rpcr_to_rdmar(rqst);
+	if (req->rl_reply) {
+		trace_xprtrdma_leaked_rep(rqst, req->rl_reply);
+		rpcrdma_recv_buffer_put(req->rl_reply);
+	}
 	req->rl_reply = rep;
 	rep->rr_rqst = rqst;
 	clear_bit(RPCRDMA_REQ_F_PENDING, &req->rl_flags);
-- 
2.20.1



