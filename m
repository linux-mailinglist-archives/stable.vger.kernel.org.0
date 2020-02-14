Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0749215F0FA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbgBNR7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:59:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387990AbgBNP4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C909922314;
        Fri, 14 Feb 2020 15:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695809;
        bh=b7NQGU52C2v45c6anXKkBxNyh6txPgiMoWz05rtCQVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB5P65AA0eKrsC8N0ND/YKEtobe1FNrrmO7/gsfW0p10XPvbqyOppk4MQuf9gD4/H
         +vW6O5nXuni4PioleHPgEbbKqzU6o+1U80E1bV1C606rS2lRZhC/a0zvhe57PUlLt+
         GUgCLDphW+xurbhxJSO4ILcEmqoFeDdKwP2SF88U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 368/542] NFS: Fix fix of show_nfs_errors
Date:   Fri, 14 Feb 2020 10:46:00 -0500
Message-Id: <20200214154854.6746-368-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 118b6292195cfb86a9f43cb65610fc6d980c65f4 ]

Casting a negative value to an unsigned long is not the same as
converting it to its absolute value.

Fixes: 96650e2effa2 ("NFS: Fix show_nfs_errors macros again")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4trace.h | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index e60b6fbd5ada1..d405557cb43f1 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -352,7 +352,7 @@ DECLARE_EVENT_CLASS(nfs4_clientid_event,
 		),
 
 		TP_fast_assign(
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__assign_str(dstaddr, clp->cl_hostname);
 		),
 
@@ -432,7 +432,8 @@ TRACE_EVENT(nfs4_sequence_done,
 			__entry->target_highest_slotid =
 					res->sr_target_highest_slotid;
 			__entry->status_flags = res->sr_status_flags;
-			__entry->error = res->sr_status;
+			__entry->error = res->sr_status < 0 ?
+					-res->sr_status : 0;
 		),
 		TP_printk(
 			"error=%ld (%s) session=0x%08x slot_nr=%u seq_nr=%u "
@@ -640,7 +641,7 @@ TRACE_EVENT(nfs4_state_mgr_failed,
 		),
 
 		TP_fast_assign(
-			__entry->error = status;
+			__entry->error = status < 0 ? -status : 0;
 			__entry->state = clp->cl_state;
 			__assign_str(hostname, clp->cl_hostname);
 			__assign_str(section, section);
@@ -659,7 +660,7 @@ TRACE_EVENT(nfs4_xdr_status,
 		TP_PROTO(
 			const struct xdr_stream *xdr,
 			u32 op,
-			int error
+			u32 error
 		),
 
 		TP_ARGS(xdr, op, error),
@@ -849,7 +850,7 @@ TRACE_EVENT(nfs4_close,
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->fhandle = nfs_fhandle_hash(NFS_FH(inode));
 			__entry->fmode = (__force unsigned int)state->state;
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(args->stateid.seqid);
 			__entry->stateid_hash =
@@ -914,7 +915,7 @@ DECLARE_EVENT_CLASS(nfs4_lock_event,
 		TP_fast_assign(
 			const struct inode *inode = state->inode;
 
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->cmd = cmd;
 			__entry->type = request->fl_type;
 			__entry->start = request->fl_start;
@@ -986,7 +987,7 @@ TRACE_EVENT(nfs4_set_lock,
 		TP_fast_assign(
 			const struct inode *inode = state->inode;
 
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->cmd = cmd;
 			__entry->type = request->fl_type;
 			__entry->start = request->fl_start;
@@ -1164,7 +1165,7 @@ TRACE_EVENT(nfs4_delegreturn_exit,
 		TP_fast_assign(
 			__entry->dev = res->server->s_dev;
 			__entry->fhandle = nfs_fhandle_hash(args->fhandle);
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(args->stateid->seqid);
 			__entry->stateid_hash =
@@ -1204,7 +1205,7 @@ DECLARE_EVENT_CLASS(nfs4_test_stateid_event,
 		TP_fast_assign(
 			const struct inode *inode = state->inode;
 
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->fhandle = nfs_fhandle_hash(NFS_FH(inode));
@@ -1306,7 +1307,7 @@ TRACE_EVENT(nfs4_lookupp,
 		TP_fast_assign(
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->ino = NFS_FILEID(inode);
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 		),
 
 		TP_printk(
@@ -1342,7 +1343,7 @@ TRACE_EVENT(nfs4_rename,
 			__entry->dev = olddir->i_sb->s_dev;
 			__entry->olddir = NFS_FILEID(olddir);
 			__entry->newdir = NFS_FILEID(newdir);
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__assign_str(oldname, oldname->name);
 			__assign_str(newname, newname->name);
 		),
@@ -1433,7 +1434,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_stateid_event,
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->fhandle = nfs_fhandle_hash(NFS_FH(inode));
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(stateid->seqid);
 			__entry->stateid_hash =
@@ -1489,7 +1490,7 @@ DECLARE_EVENT_CLASS(nfs4_getattr_event,
 			__entry->valid = fattr->valid;
 			__entry->fhandle = nfs_fhandle_hash(fhandle);
 			__entry->fileid = (fattr->valid & NFS_ATTR_FATTR_FILEID) ? fattr->fileid : 0;
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 		),
 
 		TP_printk(
@@ -1536,7 +1537,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_callback_event,
 		),
 
 		TP_fast_assign(
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->fhandle = nfs_fhandle_hash(fhandle);
 			if (!IS_ERR_OR_NULL(inode)) {
 				__entry->fileid = NFS_FILEID(inode);
@@ -1593,7 +1594,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_stateid_callback_event,
 		),
 
 		TP_fast_assign(
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->fhandle = nfs_fhandle_hash(fhandle);
 			if (!IS_ERR_OR_NULL(inode)) {
 				__entry->fileid = NFS_FILEID(inode);
@@ -1896,7 +1897,7 @@ TRACE_EVENT(nfs4_layoutget,
 			__entry->iomode = args->iomode;
 			__entry->offset = args->offset;
 			__entry->count = args->length;
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(state->stateid.seqid);
 			__entry->stateid_hash =
-- 
2.20.1

