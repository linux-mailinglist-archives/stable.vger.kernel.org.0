Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D1D45147F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345039AbhKOUI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344636AbhKOTZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9ED2636A5;
        Mon, 15 Nov 2021 19:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002883;
        bh=u50yJtA7Usz/ssUbG4nDDfo9JfmygCp02JvSF19jNLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyYeqrC6KJIBNTxosV08iTSuLIsGOhoGTXqkPiGUEqNGhSgkHlVqubUp85ltakv0F
         FthMmznAaUXNnxIqoj1sTe4I2zntcYRvweMD1VIgxeuZjLy+yVmDdcvdOpKapO5sBd
         6rKQBQ+LGPXt8APAFmNCJBHmhrn9l2/X087JiacU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 730/917] NFS: Fix up commit deadlocks
Date:   Mon, 15 Nov 2021 18:03:45 +0100
Message-Id: <20211115165453.676931888@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 133a48abf6ecc535d7eddc6da1c3e4c972445882 ]

If O_DIRECT bumps the commit_info rpcs_out field, then that could lead
to fsync() hangs. The fix is to ensure that O_DIRECT calls
nfs_commit_end().

Fixes: 723c921e7dfc ("sched/wait, fs/nfs: Convert wait_on_atomic_t() usage to the new wait_var_event() API")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c        | 2 +-
 fs/nfs/pnfs_nfs.c      | 2 --
 fs/nfs/write.c         | 9 ++++++---
 include/linux/nfs_fs.h | 1 +
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 2e894fec036b0..3c0335c15a730 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -620,7 +620,7 @@ static void nfs_direct_commit_complete(struct nfs_commit_data *data)
 		nfs_unlock_and_release_request(req);
 	}
 
-	if (atomic_dec_and_test(&cinfo.mds->rpcs_out))
+	if (nfs_commit_end(cinfo.mds))
 		nfs_direct_write_complete(dreq);
 }
 
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 02bd6e83961d9..316f68f96e573 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -468,7 +468,6 @@ pnfs_bucket_alloc_ds_commits(struct list_head *list,
 				goto out_error;
 			data->ds_commit_index = i;
 			list_add_tail(&data->list, list);
-			atomic_inc(&cinfo->mds->rpcs_out);
 			nreq++;
 		}
 		mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
@@ -520,7 +519,6 @@ pnfs_generic_commit_pagelist(struct inode *inode, struct list_head *mds_pages,
 		data->ds_commit_index = -1;
 		list_splice_init(mds_pages, &data->pages);
 		list_add_tail(&data->list, &list);
-		atomic_inc(&cinfo->mds->rpcs_out);
 		nreq++;
 	}
 
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 735a054747752..7dce3e735fc53 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1657,10 +1657,13 @@ static void nfs_commit_begin(struct nfs_mds_commit_info *cinfo)
 	atomic_inc(&cinfo->rpcs_out);
 }
 
-static void nfs_commit_end(struct nfs_mds_commit_info *cinfo)
+bool nfs_commit_end(struct nfs_mds_commit_info *cinfo)
 {
-	if (atomic_dec_and_test(&cinfo->rpcs_out))
+	if (atomic_dec_and_test(&cinfo->rpcs_out)) {
 		wake_up_var(&cinfo->rpcs_out);
+		return true;
+	}
+	return false;
 }
 
 void nfs_commitdata_release(struct nfs_commit_data *data)
@@ -1760,6 +1763,7 @@ void nfs_init_commit(struct nfs_commit_data *data,
 	data->res.fattr   = &data->fattr;
 	data->res.verf    = &data->verf;
 	nfs_fattr_init(&data->fattr);
+	nfs_commit_begin(cinfo->mds);
 }
 EXPORT_SYMBOL_GPL(nfs_init_commit);
 
@@ -1806,7 +1810,6 @@ nfs_commit_list(struct inode *inode, struct list_head *head, int how,
 
 	/* Set up the argument struct */
 	nfs_init_commit(data, head, NULL, cinfo);
-	atomic_inc(&cinfo->mds->rpcs_out);
 	if (NFS_SERVER(inode)->nfs_client->cl_minorversion)
 		task_flags = RPC_TASK_MOVEABLE;
 	return nfs_initiate_commit(NFS_CLIENT(inode), data, NFS_PROTO(inode),
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index b9a8b925db430..4d95cc999d121 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -569,6 +569,7 @@ extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_commit_data *nfs_commitdata_alloc(bool never_fail);
 extern void nfs_commit_free(struct nfs_commit_data *data);
+bool nfs_commit_end(struct nfs_mds_commit_info *cinfo);
 
 static inline int
 nfs_have_writebacks(struct inode *inode)
-- 
2.33.0



