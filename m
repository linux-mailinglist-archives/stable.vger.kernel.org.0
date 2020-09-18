Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AF126EBDA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgIRCHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbgIRCHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CBC02389E;
        Fri, 18 Sep 2020 02:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394856;
        bh=9H2IkHGf1BKs826WwCRNNg56rcCbpHAkxILLNh04e8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7CbcuQPwAnXjHwfMibEnMowMCtO0OID9cN7pgcMJnxB/MEbCQlypKCrOUGfE2KtE
         a7Z++2T39wmHQDNa/roOL1ioW+P7lshMxgy20qZzf+7GDFb0mqSR8gm9++7XAQrDo2
         G1HS6G7EryW06+brPLaxU2TGPgu5+EgSQr4UNXXs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 311/330] NFS: nfs_xdr_status should record the procedure name
Date:   Thu, 17 Sep 2020 22:00:51 -0400
Message-Id: <20200918020110.2063155-311-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5be5945864ea143fda628e8179c8474457af1f43 ]

When sunrpc trace points are not enabled, the recorded task ID
information alone is not helpful.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfstrace.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index 361cc10d6f95d..c8081d2b4166a 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -1147,7 +1147,12 @@ TRACE_EVENT(nfs_xdr_status,
 			__field(unsigned int, task_id)
 			__field(unsigned int, client_id)
 			__field(u32, xid)
+			__field(int, version)
 			__field(unsigned long, error)
+			__string(program,
+				 xdr->rqst->rq_task->tk_client->cl_program->name)
+			__string(procedure,
+				 xdr->rqst->rq_task->tk_msg.rpc_proc->p_name)
 		),
 
 		TP_fast_assign(
@@ -1157,13 +1162,19 @@ TRACE_EVENT(nfs_xdr_status,
 			__entry->task_id = task->tk_pid;
 			__entry->client_id = task->tk_client->cl_clid;
 			__entry->xid = be32_to_cpu(rqstp->rq_xid);
+			__entry->version = task->tk_client->cl_vers;
 			__entry->error = error;
+			__assign_str(program,
+				     task->tk_client->cl_program->name)
+			__assign_str(procedure, task->tk_msg.rpc_proc->p_name)
 		),
 
 		TP_printk(
-			"task:%u@%d xid=0x%08x error=%ld (%s)",
+			"task:%u@%d xid=0x%08x %sv%d %s error=%ld (%s)",
 			__entry->task_id, __entry->client_id, __entry->xid,
-			-__entry->error, nfs_show_status(__entry->error)
+			__get_str(program), __entry->version,
+			__get_str(procedure), -__entry->error,
+			nfs_show_status(__entry->error)
 		)
 );
 
-- 
2.25.1

