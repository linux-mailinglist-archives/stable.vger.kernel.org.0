Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C272FA916
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390690AbhARSmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390701AbhARLlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8608D22571;
        Mon, 18 Jan 2021 11:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970031;
        bh=U7vXFQFXLH9jPCslZnig7gT7/BpSVLs9Uk+8BYAPDf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFrS2lFwf5H64Bl/fscUCOjxY91sShqZXQFysWGl50qttYMEyvbNSXPcGgHrSlBha
         Qjum4gM8s886sphmhzuQISlFKdAIGvGoOUtJzstV/EikRcmm+QJ2zyDYG4mASS2D7y
         c4pTdZzDkaJNjbhiGxK6pWCzwBXIGuP5GsxLsMzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 56/76] pNFS: We want return-on-close to complete when evicting the inode
Date:   Mon, 18 Jan 2021 12:34:56 +0100
Message-Id: <20210118113343.662876284@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 078000d02d57f02dde61de4901f289672e98c8bc upstream.

If the inode is being evicted, it should be safe to run return-on-close,
so we should do it to ensure we don't inadvertently leak layout segments.

Fixes: 1c5bd76d17cc ("pNFS: Enable layoutreturn operation for return-on-close")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   26 ++++++++++----------------
 fs/nfs/pnfs.c     |    8 +++-----
 fs/nfs/pnfs.h     |    8 +++-----
 3 files changed, 16 insertions(+), 26 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3488,10 +3488,8 @@ static void nfs4_close_done(struct rpc_t
 	trace_nfs4_close(state, &calldata->arg, &calldata->res, task->tk_status);
 
 	/* Handle Layoutreturn errors */
-	if (pnfs_roc_done(task, calldata->inode,
-				&calldata->arg.lr_args,
-				&calldata->res.lr_res,
-				&calldata->res.lr_ret) == -EAGAIN)
+	if (pnfs_roc_done(task, &calldata->arg.lr_args, &calldata->res.lr_res,
+			  &calldata->res.lr_ret) == -EAGAIN)
 		goto out_restart;
 
 	/* hmm. we are done with the inode, and in the process of freeing
@@ -6238,10 +6236,8 @@ static void nfs4_delegreturn_done(struct
 	trace_nfs4_delegreturn_exit(&data->args, &data->res, task->tk_status);
 
 	/* Handle Layoutreturn errors */
-	if (pnfs_roc_done(task, data->inode,
-				&data->args.lr_args,
-				&data->res.lr_res,
-				&data->res.lr_ret) == -EAGAIN)
+	if (pnfs_roc_done(task, &data->args.lr_args, &data->res.lr_res,
+			  &data->res.lr_ret) == -EAGAIN)
 		goto out_restart;
 
 	switch (task->tk_status) {
@@ -6290,10 +6286,10 @@ static void nfs4_delegreturn_release(voi
 	struct nfs4_delegreturndata *data = calldata;
 	struct inode *inode = data->inode;
 
+	if (data->lr.roc)
+		pnfs_roc_release(&data->lr.arg, &data->lr.res,
+				 data->res.lr_ret);
 	if (inode) {
-		if (data->lr.roc)
-			pnfs_roc_release(&data->lr.arg, &data->lr.res,
-					data->res.lr_ret);
 		nfs_post_op_update_inode_force_wcc(inode, &data->fattr);
 		nfs_iput_and_deactive(inode);
 	}
@@ -6368,16 +6364,14 @@ static int _nfs4_proc_delegreturn(struct
 	nfs_fattr_init(data->res.fattr);
 	data->timestamp = jiffies;
 	data->rpc_status = 0;
-	data->lr.roc = pnfs_roc(inode, &data->lr.arg, &data->lr.res, cred);
 	data->inode = nfs_igrab_and_active(inode);
-	if (data->inode) {
+	if (data->inode || issync) {
+		data->lr.roc = pnfs_roc(inode, &data->lr.arg, &data->lr.res,
+					cred);
 		if (data->lr.roc) {
 			data->args.lr_args = &data->lr.arg;
 			data->res.lr_res = &data->lr.res;
 		}
-	} else if (data->lr.roc) {
-		pnfs_roc_release(&data->lr.arg, &data->lr.res, 0);
-		data->lr.roc = false;
 	}
 
 	task_setup_data.callback_data = data;
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1475,10 +1475,8 @@ out_noroc:
 	return false;
 }
 
-int pnfs_roc_done(struct rpc_task *task, struct inode *inode,
-		struct nfs4_layoutreturn_args **argpp,
-		struct nfs4_layoutreturn_res **respp,
-		int *ret)
+int pnfs_roc_done(struct rpc_task *task, struct nfs4_layoutreturn_args **argpp,
+		  struct nfs4_layoutreturn_res **respp, int *ret)
 {
 	struct nfs4_layoutreturn_args *arg = *argpp;
 	int retval = -EAGAIN;
@@ -1511,7 +1509,7 @@ int pnfs_roc_done(struct rpc_task *task,
 		return 0;
 	case -NFS4ERR_OLD_STATEID:
 		if (!nfs4_layout_refresh_old_stateid(&arg->stateid,
-					&arg->range, inode))
+						     &arg->range, arg->inode))
 			break;
 		*ret = -NFS4ERR_NOMATCHING_LAYOUT;
 		return -EAGAIN;
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -283,10 +283,8 @@ bool pnfs_roc(struct inode *ino,
 		struct nfs4_layoutreturn_args *args,
 		struct nfs4_layoutreturn_res *res,
 		const struct cred *cred);
-int pnfs_roc_done(struct rpc_task *task, struct inode *inode,
-		struct nfs4_layoutreturn_args **argpp,
-		struct nfs4_layoutreturn_res **respp,
-		int *ret);
+int pnfs_roc_done(struct rpc_task *task, struct nfs4_layoutreturn_args **argpp,
+		  struct nfs4_layoutreturn_res **respp, int *ret);
 void pnfs_roc_release(struct nfs4_layoutreturn_args *args,
 		struct nfs4_layoutreturn_res *res,
 		int ret);
@@ -711,7 +709,7 @@ pnfs_roc(struct inode *ino,
 }
 
 static inline int
-pnfs_roc_done(struct rpc_task *task, struct inode *inode,
+pnfs_roc_done(struct rpc_task *task,
 		struct nfs4_layoutreturn_args **argpp,
 		struct nfs4_layoutreturn_res **respp,
 		int *ret)


