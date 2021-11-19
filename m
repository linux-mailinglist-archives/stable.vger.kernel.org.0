Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF49F4575E6
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhKSRm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237057AbhKSRmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB636121D;
        Fri, 19 Nov 2021 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343589;
        bh=gdkqEXJbECQ2nkO2xt9iIqxq26yia8ikixDtEcPk9dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLvU6G7vXJP1dtVvbWgcuKXObwGPkWlyYDDZ9+Wy4vK+yStJKfobLGSC2nHIqcWXy
         MvkWBFh22tXik4h7ICgKmRcAPcA7vOPUJHnI/XG/Ps6hZRkYlA1qfbZ/t+M64pKMEM
         sPWAHVPwsK9VYPMa1eyCuuDAIyxV+c1AYJpEEJxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 10/20] btrfs: zoned: allow preallocation for relocation inodes
Date:   Fri, 19 Nov 2021 18:39:28 +0100
Message-Id: <20211119171444.992343653@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 960a3166aed015887cd54423a6589ae4d0b65bd5 upstream

Now that we use a dedicated block group and regular writes for data
relocation, we can preallocate the space needed for a relocated inode,
just like we do in regular mode.

Essentially this reverts commit 32430c614844 ("btrfs: zoned: enable
relocation on a zoned filesystem") as it is not needed anymore.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/relocation.c |   35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2852,31 +2852,6 @@ static noinline_for_stack int prealloc_f
 	if (ret)
 		return ret;
 
-	/*
-	 * On a zoned filesystem, we cannot preallocate the file region.
-	 * Instead, we dirty and fiemap_write the region.
-	 */
-	if (btrfs_is_zoned(inode->root->fs_info)) {
-		struct btrfs_root *root = inode->root;
-		struct btrfs_trans_handle *trans;
-
-		end = cluster->end - offset + 1;
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
-
-		inode->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
-		i_size_write(&inode->vfs_inode, end);
-		ret = btrfs_update_inode(trans, root, inode);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			btrfs_end_transaction(trans);
-			return ret;
-		}
-
-		return btrfs_end_transaction(trans);
-	}
-
 	btrfs_inode_lock(&inode->vfs_inode, 0);
 	for (nr = 0; nr < cluster->nr; nr++) {
 		start = cluster->boundary[nr] - offset;
@@ -3084,7 +3059,6 @@ release_page:
 static int relocate_file_extent_cluster(struct inode *inode,
 					struct file_extent_cluster *cluster)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 offset = BTRFS_I(inode)->index_cnt;
 	unsigned long index;
 	unsigned long last_index;
@@ -3114,8 +3088,6 @@ static int relocate_file_extent_cluster(
 	for (index = (cluster->start - offset) >> PAGE_SHIFT;
 	     index <= last_index && !ret; index++)
 		ret = relocate_one_page(inode, ra, cluster, &cluster_nr, index);
-	if (btrfs_is_zoned(fs_info) && !ret)
-		ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	if (ret == 0)
 		WARN_ON(cluster_nr != cluster->nr);
 out:
@@ -3770,12 +3742,8 @@ static int __insert_orphan_inode(struct
 	struct btrfs_path *path;
 	struct btrfs_inode_item *item;
 	struct extent_buffer *leaf;
-	u64 flags = BTRFS_INODE_NOCOMPRESS | BTRFS_INODE_PREALLOC;
 	int ret;
 
-	if (btrfs_is_zoned(trans->fs_info))
-		flags &= ~BTRFS_INODE_PREALLOC;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -3790,7 +3758,8 @@ static int __insert_orphan_inode(struct
 	btrfs_set_inode_generation(leaf, item, 1);
 	btrfs_set_inode_size(leaf, item, 0);
 	btrfs_set_inode_mode(leaf, item, S_IFREG | 0600);
-	btrfs_set_inode_flags(leaf, item, flags);
+	btrfs_set_inode_flags(leaf, item, BTRFS_INODE_NOCOMPRESS |
+					  BTRFS_INODE_PREALLOC);
 	btrfs_mark_buffer_dirty(leaf);
 out:
 	btrfs_free_path(path);


