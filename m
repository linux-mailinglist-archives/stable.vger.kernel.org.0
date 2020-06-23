Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F032064BD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390035AbgFWV0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388755AbgFWURq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409E520E65;
        Tue, 23 Jun 2020 20:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943464;
        bh=vA9mbqZEwE/CjXhTZ2ZQxo2eR5Oz8BcJq2rZsxxh6Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvrJWGE9SAImF8YGucKDP1jy+RcSvJUGYgbwTe5moftb/Rwg3WZK3ihLYzK8nPKJe
         csBFnZ2hIgoESlRgneHu8gzTZI7eE0NUrUKB3r/LmGYf3/o/jfdy4eHHefcTr/Zzh7
         glx+FKyg4qxFVYD/9ATahBD/MItxIBT+A0f1mqqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 372/477] nfs: set invalid blocks after NFSv4 writes
Date:   Tue, 23 Jun 2020 21:56:09 +0200
Message-Id: <20200623195425.114179823@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b9d0921cb4fe3..0bf1f835de014 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -833,6 +833,8 @@ int nfs_getattr(const struct path *path, struct kstat *stat,
 		do_update |= cache_validity & NFS_INO_INVALID_ATIME;
 	if (request_mask & (STATX_CTIME|STATX_MTIME))
 		do_update |= cache_validity & NFS_INO_REVAL_PAGECACHE;
+	if (request_mask & STATX_BLOCKS)
+		do_update |= cache_validity & NFS_INO_INVALID_BLOCKS;
 	if (do_update) {
 		/* Update the attribute cache */
 		if (!(server->flags & NFS_MOUNT_NOAC))
@@ -1764,7 +1766,8 @@ out_noforce:
 	status = nfs_post_op_update_inode_locked(inode, fattr,
 			NFS_INO_INVALID_CHANGE
 			| NFS_INO_INVALID_CTIME
-			| NFS_INO_INVALID_MTIME);
+			| NFS_INO_INVALID_MTIME
+			| NFS_INO_INVALID_BLOCKS);
 	return status;
 }
 
@@ -1871,7 +1874,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	nfsi->cache_validity &= ~(NFS_INO_INVALID_ATTR
 			| NFS_INO_INVALID_ATIME
 			| NFS_INO_REVAL_FORCED
-			| NFS_INO_REVAL_PAGECACHE);
+			| NFS_INO_REVAL_PAGECACHE
+			| NFS_INO_INVALID_BLOCKS);
 
 	/* Do atomic weak cache consistency updates */
 	nfs_wcc_update_inode(inode, fattr);
@@ -2033,8 +2037,12 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
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
index 73eda45f1cfd9..6ee9119acc5d9 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -230,6 +230,7 @@ struct nfs4_copy_state {
 #define NFS_INO_INVALID_OTHER	BIT(12)		/* other attrs are invalid */
 #define NFS_INO_DATA_INVAL_DEFER	\
 				BIT(13)		/* Deferred cache invalidation */
+#define NFS_INO_INVALID_BLOCKS	BIT(14)         /* cached blocks are invalid */
 
 #define NFS_INO_INVALID_ATTR	(NFS_INO_INVALID_CHANGE \
 		| NFS_INO_INVALID_CTIME \
-- 
2.25.1



