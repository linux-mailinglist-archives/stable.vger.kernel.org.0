Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59DF205F54
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391216AbgFWUb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390959AbgFWUbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D57AF20702;
        Tue, 23 Jun 2020 20:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944315;
        bh=hx8BGee8MJDNYt9B91ooy0vDGgvzquB2ThITlU8Mj7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrh3NPJhwT/mogcEEqvM4hAJDILBuAdb87lYMgM6RWWM8GBMRqciMz4p2pCuyrLke
         qp1aTqEZ/YmWMh4HTaMfDjbOy3rjNYwpVn4A6PxVB4V5E1wRsAIJFT9fXn1ruc9kZJ
         EBC65akz7PfyA6rDNNzP1v9Za3p8KEM9brgoVc+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 256/314] nfs: set invalid blocks after NFSv4 writes
Date:   Tue, 23 Jun 2020 21:57:31 +0200
Message-Id: <20200623195351.184939772@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index 3802c88e83720..6de41f7412808 100644
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
@@ -1750,7 +1752,8 @@ out_noforce:
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
index 570a60c2f4f48..ad09c0cc54645 100644
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



