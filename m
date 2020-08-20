Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DD324B33A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgHTJnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729200AbgHTJmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:42:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C123D22D07;
        Thu, 20 Aug 2020 09:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916569;
        bh=SF7eZVx4AhMDo5pdZzuuQPK0L9OAcx0WeH2nI2baB1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMyKJf7+z0tFaAj+qH9YRmYzrPZbHk2S3j1E6J82g19MClBNEiraIuWu32Utitp/x
         MTReLZe8ZSLdWVhCYcwfwuehCZ9wshXc+pDE8NHpcaHTSFJ+Sva0H69YoCXkn9yKR6
         NmpJyoY0n3FM4umVLVb2TWHlW6rrLYUtUuh4PO4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 174/204] NFS: Fix flexfiles read failover
Date:   Thu, 20 Aug 2020 11:21:11 +0200
Message-Id: <20200820091614.897263643@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 563c53e73b8b6ec842828736f77e633f7b0911e9 ]

The current mirrored read failover code is correctly resetting the mirror
index between failed reads, however it is not able to actually flip the
RPC call over to the next RPC client.
The end result is that we keep resending the RPC call to the same client
over and over.

The fix is to use the pnfs_read_resend_pnfs() mechanism to schedule a
new RPC call, but we need to add the ability to pass in a mirror
index so that we always retry the next mirror in the list.

Fixes: 166bd5b889ac ("pNFS/flexfiles: Fix layoutstats handling during read failovers")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 50 ++++++++++++++++++--------
 fs/nfs/pnfs.c                          |  4 ++-
 fs/nfs/pnfs.h                          |  2 +-
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index de03e440b7eef..048272d60a165 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -790,6 +790,19 @@ ff_layout_choose_best_ds_for_read(struct pnfs_layout_segment *lseg,
 	return ff_layout_choose_any_ds_for_read(lseg, start_idx, best_idx);
 }
 
+static struct nfs4_pnfs_ds *
+ff_layout_get_ds_for_read(struct nfs_pageio_descriptor *pgio, int *best_idx)
+{
+	struct pnfs_layout_segment *lseg = pgio->pg_lseg;
+	struct nfs4_pnfs_ds *ds;
+
+	ds = ff_layout_choose_best_ds_for_read(lseg, pgio->pg_mirror_idx,
+					       best_idx);
+	if (ds || !pgio->pg_mirror_idx)
+		return ds;
+	return ff_layout_choose_best_ds_for_read(lseg, 0, best_idx);
+}
+
 static void
 ff_layout_pg_get_read(struct nfs_pageio_descriptor *pgio,
 		      struct nfs_page *req,
@@ -840,7 +853,7 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 			goto out_nolseg;
 	}
 
-	ds = ff_layout_choose_best_ds_for_read(pgio->pg_lseg, 0, &ds_idx);
+	ds = ff_layout_get_ds_for_read(pgio, &ds_idx);
 	if (!ds) {
 		if (!ff_layout_no_fallback_to_mds(pgio->pg_lseg))
 			goto out_mds;
@@ -1028,11 +1041,24 @@ static void ff_layout_reset_write(struct nfs_pgio_header *hdr, bool retry_pnfs)
 	}
 }
 
+static void ff_layout_resend_pnfs_read(struct nfs_pgio_header *hdr)
+{
+	u32 idx = hdr->pgio_mirror_idx + 1;
+	int new_idx = 0;
+
+	if (ff_layout_choose_any_ds_for_read(hdr->lseg, idx + 1, &new_idx))
+		ff_layout_send_layouterror(hdr->lseg);
+	else
+		pnfs_error_mark_layout_for_return(hdr->inode, hdr->lseg);
+	pnfs_read_resend_pnfs(hdr, new_idx);
+}
+
 static void ff_layout_reset_read(struct nfs_pgio_header *hdr)
 {
 	struct rpc_task *task = &hdr->task;
 
 	pnfs_layoutcommit_inode(hdr->inode, false);
+	pnfs_error_mark_layout_for_return(hdr->inode, hdr->lseg);
 
 	if (!test_and_set_bit(NFS_IOHDR_REDO, &hdr->flags)) {
 		dprintk("%s Reset task %5u for i/o through MDS "
@@ -1234,6 +1260,12 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		break;
 	case NFS4ERR_NXIO:
 		ff_layout_mark_ds_unreachable(lseg, idx);
+		/*
+		 * Don't return the layout if this is a read and we still
+		 * have layouts to try
+		 */
+		if (opnum == OP_READ)
+			break;
 		/* Fallthrough */
 	default:
 		pnfs_error_mark_layout_for_return(lseg->pls_layout->plh_inode,
@@ -1247,7 +1279,6 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 static int ff_layout_read_done_cb(struct rpc_task *task,
 				struct nfs_pgio_header *hdr)
 {
-	int new_idx = hdr->pgio_mirror_idx;
 	int err;
 
 	if (task->tk_status < 0) {
@@ -1267,10 +1298,6 @@ static int ff_layout_read_done_cb(struct rpc_task *task,
 	clear_bit(NFS_IOHDR_RESEND_MDS, &hdr->flags);
 	switch (err) {
 	case -NFS4ERR_RESET_TO_PNFS:
-		if (ff_layout_choose_best_ds_for_read(hdr->lseg,
-					hdr->pgio_mirror_idx + 1,
-					&new_idx))
-			goto out_layouterror;
 		set_bit(NFS_IOHDR_RESEND_PNFS, &hdr->flags);
 		return task->tk_status;
 	case -NFS4ERR_RESET_TO_MDS:
@@ -1281,10 +1308,6 @@ static int ff_layout_read_done_cb(struct rpc_task *task,
 	}
 
 	return 0;
-out_layouterror:
-	ff_layout_read_record_layoutstats_done(task, hdr);
-	ff_layout_send_layouterror(hdr->lseg);
-	hdr->pgio_mirror_idx = new_idx;
 out_eagain:
 	rpc_restart_call_prepare(task);
 	return -EAGAIN;
@@ -1411,10 +1434,9 @@ static void ff_layout_read_release(void *data)
 	struct nfs_pgio_header *hdr = data;
 
 	ff_layout_read_record_layoutstats_done(&hdr->task, hdr);
-	if (test_bit(NFS_IOHDR_RESEND_PNFS, &hdr->flags)) {
-		ff_layout_send_layouterror(hdr->lseg);
-		pnfs_read_resend_pnfs(hdr);
-	} else if (test_bit(NFS_IOHDR_RESEND_MDS, &hdr->flags))
+	if (test_bit(NFS_IOHDR_RESEND_PNFS, &hdr->flags))
+		ff_layout_resend_pnfs_read(hdr);
+	else if (test_bit(NFS_IOHDR_RESEND_MDS, &hdr->flags))
 		ff_layout_reset_read(hdr);
 	pnfs_generic_rw_release(data);
 }
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index d61dac48dff50..75e988caf3cd7 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2939,7 +2939,8 @@ pnfs_try_to_read_data(struct nfs_pgio_header *hdr,
 }
 
 /* Resend all requests through pnfs. */
-void pnfs_read_resend_pnfs(struct nfs_pgio_header *hdr)
+void pnfs_read_resend_pnfs(struct nfs_pgio_header *hdr,
+			   unsigned int mirror_idx)
 {
 	struct nfs_pageio_descriptor pgio;
 
@@ -2950,6 +2951,7 @@ void pnfs_read_resend_pnfs(struct nfs_pgio_header *hdr)
 
 		nfs_pageio_init_read(&pgio, hdr->inode, false,
 					hdr->completion_ops);
+		pgio.pg_mirror_idx = mirror_idx;
 		hdr->task.tk_status = nfs_pageio_resend(&pgio, hdr);
 	}
 }
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 8e0ada581b92e..2661c44c62db4 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -311,7 +311,7 @@ int _pnfs_return_layout(struct inode *);
 int pnfs_commit_and_return_layout(struct inode *);
 void pnfs_ld_write_done(struct nfs_pgio_header *);
 void pnfs_ld_read_done(struct nfs_pgio_header *);
-void pnfs_read_resend_pnfs(struct nfs_pgio_header *);
+void pnfs_read_resend_pnfs(struct nfs_pgio_header *, unsigned int mirror_idx);
 struct pnfs_layout_segment *pnfs_update_layout(struct inode *ino,
 					       struct nfs_open_context *ctx,
 					       loff_t pos,
-- 
2.25.1



