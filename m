Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093B415C428
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgBMP1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387442AbgBMP1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:10 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CC792468E;
        Thu, 13 Feb 2020 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607630;
        bh=4QkuN9SGNkBxl20cdT7u0C8UIirhtj0E+SQsTBeZEvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=je5rftfqqxRKSD1Mvo/4yzzxY0fy4IYFlKKpTsTjcZMjLyM0B6z3d3kJDz2WMmWyg
         nD1EgsjY8FkC+hNklD0deiOFCWG5rEQBtGRQtUS2nYP59Esgm0JiUFe5VNCc9Qk0Uz
         XGOzkFWCe9H/eL9HYj5QonmWQYbBaUZ75CnAOzlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 30/96] NFS: Fix fix of show_nfs_errors
Date:   Thu, 13 Feb 2020 07:20:37 -0800
Message-Id: <20200213151850.618020764@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 118b6292195cfb86a9f43cb65610fc6d980c65f4 upstream.

Casting a negative value to an unsigned long is not the same as
converting it to its absolute value.

Fixes: 96650e2effa2 ("NFS: Fix show_nfs_errors macros again")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4trace.h |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

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
@@ -566,7 +567,7 @@ TRACE_EVENT(nfs4_xdr_status,
 		TP_PROTO(
 			const struct xdr_stream *xdr,
 			u32 op,
-			int error
+			u32 error
 		),
 
 		TP_ARGS(xdr, op, error),
@@ -756,7 +757,7 @@ TRACE_EVENT(nfs4_close,
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->fhandle = nfs_fhandle_hash(NFS_FH(inode));
 			__entry->fmode = (__force unsigned int)state->state;
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(args->stateid.seqid);
 			__entry->stateid_hash =
@@ -821,7 +822,7 @@ DECLARE_EVENT_CLASS(nfs4_lock_event,
 		TP_fast_assign(
 			const struct inode *inode = state->inode;
 
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->cmd = cmd;
 			__entry->type = request->fl_type;
 			__entry->start = request->fl_start;
@@ -893,7 +894,7 @@ TRACE_EVENT(nfs4_set_lock,
 		TP_fast_assign(
 			const struct inode *inode = state->inode;
 
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->cmd = cmd;
 			__entry->type = request->fl_type;
 			__entry->start = request->fl_start;
@@ -989,7 +990,7 @@ TRACE_EVENT(nfs4_delegreturn_exit,
 		TP_fast_assign(
 			__entry->dev = res->server->s_dev;
 			__entry->fhandle = nfs_fhandle_hash(args->fhandle);
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(args->stateid->seqid);
 			__entry->stateid_hash =
@@ -1029,7 +1030,7 @@ DECLARE_EVENT_CLASS(nfs4_test_stateid_ev
 		TP_fast_assign(
 			const struct inode *inode = state->inode;
 
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->fhandle = nfs_fhandle_hash(NFS_FH(inode));
@@ -1131,7 +1132,7 @@ TRACE_EVENT(nfs4_lookupp,
 		TP_fast_assign(
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->ino = NFS_FILEID(inode);
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 		),
 
 		TP_printk(
@@ -1167,7 +1168,7 @@ TRACE_EVENT(nfs4_rename,
 			__entry->dev = olddir->i_sb->s_dev;
 			__entry->olddir = NFS_FILEID(olddir);
 			__entry->newdir = NFS_FILEID(newdir);
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__assign_str(oldname, oldname->name);
 			__assign_str(newname, newname->name);
 		),
@@ -1258,7 +1259,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_stateid_e
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->fhandle = nfs_fhandle_hash(NFS_FH(inode));
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(stateid->seqid);
 			__entry->stateid_hash =
@@ -1314,7 +1315,7 @@ DECLARE_EVENT_CLASS(nfs4_getattr_event,
 			__entry->valid = fattr->valid;
 			__entry->fhandle = nfs_fhandle_hash(fhandle);
 			__entry->fileid = (fattr->valid & NFS_ATTR_FATTR_FILEID) ? fattr->fileid : 0;
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 		),
 
 		TP_printk(
@@ -1361,7 +1362,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_callback_
 		),
 
 		TP_fast_assign(
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->fhandle = nfs_fhandle_hash(fhandle);
 			if (!IS_ERR_OR_NULL(inode)) {
 				__entry->fileid = NFS_FILEID(inode);
@@ -1418,7 +1419,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_stateid_c
 		),
 
 		TP_fast_assign(
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->fhandle = nfs_fhandle_hash(fhandle);
 			if (!IS_ERR_OR_NULL(inode)) {
 				__entry->fileid = NFS_FILEID(inode);
@@ -1721,7 +1722,7 @@ TRACE_EVENT(nfs4_layoutget,
 			__entry->iomode = args->iomode;
 			__entry->offset = args->offset;
 			__entry->count = args->length;
-			__entry->error = error;
+			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
 				be32_to_cpu(state->stateid.seqid);
 			__entry->stateid_hash =


