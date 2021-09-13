Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179834092C4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344676AbhIMOP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344269AbhIMOLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 206836128B;
        Mon, 13 Sep 2021 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540530;
        bh=p67OvtEXGKW7+yYua+XeV265X6qkcb8gVrxNzNO1ktA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEZBNssg/yMcnFh4cge9GDAjgNy4VzvpJybt6Q12F5JmtGXdKXONl15tiPwiNh2OI
         F0Zst79oevP7jCCiIASUdtq4HNrGBZ+RTnnJX9pL61RL1SB1kYXqItM0IV3LJDwvwa
         9ew5KEn0dieC2OTZENvY6zYqLDiaKg7aVSwQ92cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 199/300] SUNRPC: Fix a NULL pointer deref in trace_svc_stats_latency()
Date:   Mon, 13 Sep 2021 15:14:20 +0200
Message-Id: <20210913131116.094811038@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5c11720767f70d34357d00a15ba5a0ad052c40fe ]

Some paths through svc_process() leave rqst->rq_procinfo set to
NULL, which triggers a crash if tracing happens to be enabled.

Fixes: 89ff87494c6e ("SUNRPC: Display RPC procedure names instead of proc numbers")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h    |  1 +
 include/trace/events/sunrpc.h |  8 ++++----
 net/sunrpc/svc.c              | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index e91d51ea028b..65185d1e07ea 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -523,6 +523,7 @@ void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
 struct svc_pool *  svc_pool_for_cpu(struct svc_serv *serv, int cpu);
 char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
+const char *	   svc_proc_name(const struct svc_rqst *rqstp);
 int		   svc_encode_result_payload(struct svc_rqst *rqstp,
 					     unsigned int offset,
 					     unsigned int length);
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index d02e01a27b69..87569dbf2fe7 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1642,7 +1642,7 @@ TRACE_EVENT(svc_process,
 		__field(u32, vers)
 		__field(u32, proc)
 		__string(service, name)
-		__string(procedure, rqst->rq_procinfo->pc_name)
+		__string(procedure, svc_proc_name(rqst))
 		__string(addr, rqst->rq_xprt ?
 			 rqst->rq_xprt->xpt_remotebuf : "(null)")
 	),
@@ -1652,7 +1652,7 @@ TRACE_EVENT(svc_process,
 		__entry->vers = rqst->rq_vers;
 		__entry->proc = rqst->rq_proc;
 		__assign_str(service, name);
-		__assign_str(procedure, rqst->rq_procinfo->pc_name);
+		__assign_str(procedure, svc_proc_name(rqst));
 		__assign_str(addr, rqst->rq_xprt ?
 			     rqst->rq_xprt->xpt_remotebuf : "(null)");
 	),
@@ -1918,7 +1918,7 @@ TRACE_EVENT(svc_stats_latency,
 	TP_STRUCT__entry(
 		__field(u32, xid)
 		__field(unsigned long, execute)
-		__string(procedure, rqst->rq_procinfo->pc_name)
+		__string(procedure, svc_proc_name(rqst))
 		__string(addr, rqst->rq_xprt->xpt_remotebuf)
 	),
 
@@ -1926,7 +1926,7 @@ TRACE_EVENT(svc_stats_latency,
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->execute = ktime_to_us(ktime_sub(ktime_get(),
 							 rqst->rq_stime));
-		__assign_str(procedure, rqst->rq_procinfo->pc_name);
+		__assign_str(procedure, svc_proc_name(rqst));
 		__assign_str(addr, rqst->rq_xprt->xpt_remotebuf);
 	),
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 0de918cb3d90..a47e290b0668 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1629,6 +1629,21 @@ u32 svc_max_payload(const struct svc_rqst *rqstp)
 }
 EXPORT_SYMBOL_GPL(svc_max_payload);
 
+/**
+ * svc_proc_name - Return RPC procedure name in string form
+ * @rqstp: svc_rqst to operate on
+ *
+ * Return value:
+ *   Pointer to a NUL-terminated string
+ */
+const char *svc_proc_name(const struct svc_rqst *rqstp)
+{
+	if (rqstp && rqstp->rq_procinfo)
+		return rqstp->rq_procinfo->pc_name;
+	return "unknown";
+}
+
+
 /**
  * svc_encode_result_payload - mark a range of bytes as a result payload
  * @rqstp: svc_rqst to operate on
-- 
2.30.2



