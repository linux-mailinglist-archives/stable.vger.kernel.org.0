Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CA727C634
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgI2Lmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbgI2Lmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02F89206DB;
        Tue, 29 Sep 2020 11:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379752;
        bh=9H2IkHGf1BKs826WwCRNNg56rcCbpHAkxILLNh04e8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eC9s8F4QVcp7QEY59OR3raWqSaFn1C4cPZFAke+e052Rh4BXLeOSnnRPDImZfUKOF
         f2LmOdAhyclptBOxGLk+3bpZ5bzbWlnn580j3wXckhQbx7cGygxxo9yL46JlRDRZmY
         127HIsF2nGed1juSt3LqW9vhhBu3jxQV3nbC+tPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 302/388] NFS: nfs_xdr_status should record the procedure name
Date:   Tue, 29 Sep 2020 13:00:33 +0200
Message-Id: <20200929110025.085021206@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



