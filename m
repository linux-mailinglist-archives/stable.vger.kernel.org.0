Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650641FDCE8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgFRBWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbgFRBWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92CAD21D82;
        Thu, 18 Jun 2020 01:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443331;
        bh=GrXHVtwxhb7GAQ5w2+0nA8HW2ks88zZMM+TVvt4858s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBMJQjoMC+0nUXW70w6MLleQAgjisRTQ1MvRcL6XHWd8TI5QtWgdVGz19F1Fm+ZkY
         BTwQKGgbgNhTDfekmgZbsVcMcf0WHieSiIe8MIzf3QwavybdNUq9bIFYg/KcItSN0I
         oAf+QrmCK5b0NZZfDjP/eueltYBLOycFFSHNIglo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Bin <zhengbin13@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 263/266] nfs: set invalid blocks after NFSv4 writes
Date:   Wed, 17 Jun 2020 21:16:28 -0400
Message-Id: <20200618011631.604574-263-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit 3a39e778690500066b31fe982d18e2e394d3bce2 ]

Use the following command to test nfsv4(size of file1M is 1MB):
mount -t nfs -o vers=4.0,actimeo=60 127.0.0.1/dir1 /mnt
cp file1M /mnt
du -h /mnt/file1M  -->0 within 60s, then 1M

When write is done(cp file1M /mnt), will call this:
nfs_writeback_done
  nfs4_write_done
    nfs4_write_done_cb
      nfs_writeback_update_inode
        nfs_post_op_update_inode_force_wcc_locked(change, ctime, mtime
nfs_post_op_update_inode_force_wcc_locked
   nfs_set_cache_invalid
   nfs_refresh_inode_locked
     nfs_update_inode

nfsd write response contains change, ctime, mtime, the flag will be
clear after nfs_update_inode. Howerver, write response does not contain
space_used, previous open response contains space_used whose value is 0,
so inode->i_blocks is still 0.

nfs_getattr  -->called by "du -h"
  do_update |= force_sync || nfs_attribute_cache_expired -->false in 60s
  cache_validity = READ_ONCE(NFS_I(inode)->cache_validity)
  do_update |= cache_validity & (NFS_INO_INVALID_ATTR    -->false
  if (do_update) {
        __nfs_revalidate_inode
  }

Within 60s, does not send getattr request to nfsd, thus "du -h /mnt/file1M"
is 0.

Add a NFS_INO_INVALID_BLOCKS flag, set it when nfsv4 write is done.

Fixes: 16e143751727 ("NFS: More fine grained attribute tracking")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c         | 14 +++++++++++---
 include/linux/nfs_fs.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 3802c88e8372..6de41f741280 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -826,6 +826,8 @@ int nfs_getattr(const struct path *path, struct kstat *stat,
 		do_update |= cache_validity & NFS_INO_INVALID_ATIME;
 	if (request_mask & (STATX_CTIME|STATX_MTIME))
 		do_update |= cache_validity & NFS_INO_REVAL_PAGECACHE;
+	if (request_mask & STATX_BLOCKS)
+		do_update |= cache_validity & NFS_INO_INVALID_BLOCKS;
 	if (do_update) {
 		/* Update the attribute cache */
 		if (!(server->flags & NFS_MOUNT_NOAC))
@@ -1750,7 +1752,8 @@ int nfs_post_op_update_inode_force_wcc_locked(struct inode *inode, struct nfs_fa
 	status = nfs_post_op_update_inode_locked(inode, fattr,
 			NFS_INO_INVALID_CHANGE
 			| NFS_INO_INVALID_CTIME
-			| NFS_INO_INVALID_MTIME);
+			| NFS_INO_INVALID_MTIME
+			| NFS_INO_INVALID_BLOCKS);
 	return status;
 }
 
@@ -1857,7 +1860,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	nfsi->cache_validity &= ~(NFS_INO_INVALID_ATTR
 			| NFS_INO_INVALID_ATIME
 			| NFS_INO_REVAL_FORCED
-			| NFS_INO_REVAL_PAGECACHE);
+			| NFS_INO_REVAL_PAGECACHE
+			| NFS_INO_INVALID_BLOCKS);
 
 	/* Do atomic weak cache consistency updates */
 	nfs_wcc_update_inode(inode, fattr);
@@ -2019,8 +2023,12 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		inode->i_blocks = nfs_calc_block_size(fattr->du.nfs3.used);
 	} else if (fattr->valid & NFS_ATTR_FATTR_BLOCKS_USED)
 		inode->i_blocks = fattr->du.nfs2.blocks;
-	else
+	else {
+		nfsi->cache_validity |= save_cache_validity &
+				(NFS_INO_INVALID_BLOCKS
+				| NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
+	}
 
 	/* Update attrtimeo value if we're out of the unstable period */
 	if (attr_changed) {
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 570a60c2f4f4..ad09c0cc5464 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -225,6 +225,7 @@ struct nfs4_copy_state {
 #define NFS_INO_INVALID_OTHER	BIT(12)		/* other attrs are invalid */
 #define NFS_INO_DATA_INVAL_DEFER	\
 				BIT(13)		/* Deferred cache invalidation */
+#define NFS_INO_INVALID_BLOCKS	BIT(14)         /* cached blocks are invalid */
 
 #define NFS_INO_INVALID_ATTR	(NFS_INO_INVALID_CHANGE \
 		| NFS_INO_INVALID_CTIME \
-- 
2.25.1

