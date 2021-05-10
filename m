Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C453787C9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhEJLSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236643AbhEJLIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEBC8619B8;
        Mon, 10 May 2021 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644566;
        bh=yD7Fzm9gIZ8+icEuOs7G8uu6AxACr7qsrAAvtRqBKbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQsPcg9+FujSgXnVUswxOhdd7lFRsAwFPyY9z0Y/MCRbTj2h2BEVS8MNXaBK2GGOx
         peMCrlQBZ+aT4BLcebT/BRXwXCFWN+rVV6Fl4xmeKKcYUwrP1F/U8fsglncRTVOAI9
         hut0IcrUCmKVP3kwFQL4ttGx3zxMSoHsBulyeiZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 134/384] btrfs: use btrfs_inode_lock/btrfs_inode_unlock inode lock helpers
Date:   Mon, 10 May 2021 12:18:43 +0200
Message-Id: <20210510102019.316424281@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 64708539cd23b31d0f235a2c12a0cf782f95908a ]

A few places we intermix btrfs_inode_lock with a inode_unlock, and some
places we just use inode_lock/inode_unlock instead of btrfs_inode_lock.

None of these places are using this incorrectly, but as we adjust some
of these callers it would be nice to keep everything consistent, so
convert everybody to use btrfs_inode_lock/btrfs_inode_unlock.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c |  4 ++--
 fs/btrfs/file.c          | 18 +++++++++---------
 fs/btrfs/ioctl.c         | 26 +++++++++++++-------------
 fs/btrfs/reflink.c       |  4 ++--
 fs/btrfs/relocation.c    |  4 ++--
 5 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bf25401c9768..c1d2b6786129 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1589,8 +1589,8 @@ bool btrfs_readdir_get_delayed_items(struct inode *inode,
 	 * We can only do one readdir with delayed items at a time because of
 	 * item->readdir_list.
 	 */
-	inode_unlock_shared(inode);
-	inode_lock(inode);
+	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
+	btrfs_inode_lock(inode, 0);
 
 	mutex_lock(&delayed_node->mutex);
 	item = __btrfs_first_delayed_insertion_item(delayed_node);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0e155f013839..6d4e15222775 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2122,7 +2122,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (ret)
 		goto out;
 
-	inode_lock(inode);
+	btrfs_inode_lock(inode, 0);
 
 	atomic_inc(&root->log_batch);
 
@@ -2154,7 +2154,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	ret = start_ordered_ops(inode, start, end);
 	if (ret) {
-		inode_unlock(inode);
+		btrfs_inode_unlock(inode, 0);
 		goto out;
 	}
 
@@ -2255,7 +2255,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * file again, but that will end up using the synchronization
 	 * inside btrfs_sync_log to keep things safe.
 	 */
-	inode_unlock(inode);
+	btrfs_inode_unlock(inode, 0);
 
 	if (ret != BTRFS_NO_LOG_SYNC) {
 		if (!ret) {
@@ -2285,7 +2285,7 @@ out:
 
 out_release_extents:
 	btrfs_release_log_ctx_extents(&ctx);
-	inode_unlock(inode);
+	btrfs_inode_unlock(inode, 0);
 	goto out;
 }
 
@@ -2868,7 +2868,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (ret)
 		return ret;
 
-	inode_lock(inode);
+	btrfs_inode_lock(inode, 0);
 	ino_size = round_up(inode->i_size, fs_info->sectorsize);
 	ret = find_first_non_hole(BTRFS_I(inode), &offset, &len);
 	if (ret < 0)
@@ -2908,7 +2908,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		truncated_block = true;
 		ret = btrfs_truncate_block(BTRFS_I(inode), offset, 0, 0);
 		if (ret) {
-			inode_unlock(inode);
+			btrfs_inode_unlock(inode, 0);
 			return ret;
 		}
 	}
@@ -3009,7 +3009,7 @@ out_only_mutex:
 				ret = ret2;
 		}
 	}
-	inode_unlock(inode);
+	btrfs_inode_unlock(inode, 0);
 	return ret;
 }
 
@@ -3377,7 +3377,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 
 	if (mode & FALLOC_FL_ZERO_RANGE) {
 		ret = btrfs_zero_range(inode, offset, len, mode);
-		inode_unlock(inode);
+		btrfs_inode_unlock(inode, 0);
 		return ret;
 	}
 
@@ -3487,7 +3487,7 @@ out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 			     &cached_state);
 out:
-	inode_unlock(inode);
+	btrfs_inode_unlock(inode, 0);
 	/* Let go of our reservation. */
 	if (ret != 0 && !(mode & FALLOC_FL_ZERO_RANGE))
 		btrfs_free_reserved_data_space(BTRFS_I(inode), data_reserved,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 49fea3d945f4..5efd6c7fe620 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -226,7 +226,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	inode_lock(inode);
+	btrfs_inode_lock(inode, 0);
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
 	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
 
@@ -353,7 +353,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
  out_end_trans:
 	btrfs_end_transaction(trans);
  out_unlock:
-	inode_unlock(inode);
+	btrfs_inode_unlock(inode, 0);
 	mnt_drop_write_file(file);
 	return ret;
 }
@@ -449,7 +449,7 @@ static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	inode_lock(inode);
+	btrfs_inode_lock(inode, 0);
 
 	old_flags = binode->flags;
 	old_i_flags = inode->i_flags;
@@ -501,7 +501,7 @@ out_unlock:
 		inode->i_flags = old_i_flags;
 	}
 
-	inode_unlock(inode);
+	btrfs_inode_unlock(inode, 0);
 	mnt_drop_write_file(file);
 
 	return ret;
@@ -1026,7 +1026,7 @@ out_up_read:
 out_dput:
 	dput(dentry);
 out_unlock:
-	inode_unlock(dir);
+	btrfs_inode_unlock(dir, 0);
 	return error;
 }
 
@@ -1624,7 +1624,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			ra_index += cluster;
 		}
 
-		inode_lock(inode);
+		btrfs_inode_lock(inode, 0);
 		if (IS_SWAPFILE(inode)) {
 			ret = -ETXTBSY;
 		} else {
@@ -1633,13 +1633,13 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			ret = cluster_pages_for_defrag(inode, pages, i, cluster);
 		}
 		if (ret < 0) {
-			inode_unlock(inode);
+			btrfs_inode_unlock(inode, 0);
 			goto out_ra;
 		}
 
 		defrag_count += ret;
 		balance_dirty_pages_ratelimited(inode->i_mapping);
-		inode_unlock(inode);
+		btrfs_inode_unlock(inode, 0);
 
 		if (newer_than) {
 			if (newer_off == (u64)-1)
@@ -1687,9 +1687,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 out_ra:
 	if (do_compress) {
-		inode_lock(inode);
+		btrfs_inode_lock(inode, 0);
 		BTRFS_I(inode)->defrag_compress = BTRFS_COMPRESS_NONE;
-		inode_unlock(inode);
+		btrfs_inode_unlock(inode, 0);
 	}
 	if (!file)
 		kfree(ra);
@@ -3124,9 +3124,9 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		goto out_dput;
 	}
 
-	inode_lock(inode);
+	btrfs_inode_lock(inode, 0);
 	err = btrfs_delete_subvolume(dir, dentry);
-	inode_unlock(inode);
+	btrfs_inode_unlock(inode, 0);
 	if (!err) {
 		fsnotify_rmdir(dir, dentry);
 		d_delete(dentry);
@@ -3135,7 +3135,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 out_dput:
 	dput(dentry);
 out_unlock_dir:
-	inode_unlock(dir);
+	btrfs_inode_unlock(dir, 0);
 free_subvol_name:
 	kfree(subvol_name_ptr);
 free_parent:
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 762881b777b3..0abbf050580d 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -833,7 +833,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 		return -EINVAL;
 
 	if (same_inode)
-		inode_lock(src_inode);
+		btrfs_inode_lock(src_inode, 0);
 	else
 		lock_two_nondirectories(src_inode, dst_inode);
 
@@ -849,7 +849,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 
 out_unlock:
 	if (same_inode)
-		inode_unlock(src_inode);
+		btrfs_inode_unlock(src_inode, 0);
 	else
 		unlock_two_nondirectories(src_inode, dst_inode);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 232d5da7b7be..bf269ee17e68 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2578,7 +2578,7 @@ static noinline_for_stack int prealloc_file_extent_cluster(
 		return btrfs_end_transaction(trans);
 	}
 
-	inode_lock(&inode->vfs_inode);
+	btrfs_inode_lock(&inode->vfs_inode, 0);
 	for (nr = 0; nr < cluster->nr; nr++) {
 		start = cluster->boundary[nr] - offset;
 		if (nr + 1 < cluster->nr)
@@ -2596,7 +2596,7 @@ static noinline_for_stack int prealloc_file_extent_cluster(
 		if (ret)
 			break;
 	}
-	inode_unlock(&inode->vfs_inode);
+	btrfs_inode_unlock(&inode->vfs_inode, 0);
 
 	if (cur_offset < prealloc_end)
 		btrfs_free_reserved_data_space_noquota(inode->root->fs_info,
-- 
2.30.2



