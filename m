Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE8EEC7E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbfKDV5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388615AbfKDV5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:34 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1087020659;
        Mon,  4 Nov 2019 21:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904653;
        bh=5GSPOWbNL118fAnmHsLzi3UD9nX7tYpdY+plEkQTB18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6enVke6eiUFnHcsKDobOxl8XoSn8lniNyiRkRBA5XJRq2DyvvPaRYEJejIrvuA/5
         XiaAd/qDk8jSjDMh4gIUuFsDTGOEX1giJKScGOonk0Zje3+rc5K+LXVJLwOBmsBIBt
         Z61pruAicgZXGEQIBH7IuRfoQiKAywtPukIqebgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Nelson <andrew.s.nelson@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/149] Btrfs: fix deadlock on tree root leaf when finding free extent
Date:   Mon,  4 Nov 2019 22:43:35 +0100
Message-Id: <20191104212137.076733873@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 4222ea7100c0e37adace2790c8822758bbeee179 ]

When we are writing out a free space cache, during the transaction commit
phase, we can end up in a deadlock which results in a stack trace like the
following:

 schedule+0x28/0x80
 btrfs_tree_read_lock+0x8e/0x120 [btrfs]
 ? finish_wait+0x80/0x80
 btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
 btrfs_search_slot+0xf6/0x9f0 [btrfs]
 ? evict_refill_and_join+0xd0/0xd0 [btrfs]
 ? inode_insert5+0x119/0x190
 btrfs_lookup_inode+0x3a/0xc0 [btrfs]
 ? kmem_cache_alloc+0x166/0x1d0
 btrfs_iget+0x113/0x690 [btrfs]
 __lookup_free_space_inode+0xd8/0x150 [btrfs]
 lookup_free_space_inode+0x5b/0xb0 [btrfs]
 load_free_space_cache+0x7c/0x170 [btrfs]
 ? cache_block_group+0x72/0x3b0 [btrfs]
 cache_block_group+0x1b3/0x3b0 [btrfs]
 ? finish_wait+0x80/0x80
 find_free_extent+0x799/0x1010 [btrfs]
 btrfs_reserve_extent+0x9b/0x180 [btrfs]
 btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
 __btrfs_cow_block+0x11d/0x500 [btrfs]
 btrfs_cow_block+0xdc/0x180 [btrfs]
 btrfs_search_slot+0x3bd/0x9f0 [btrfs]
 btrfs_lookup_inode+0x3a/0xc0 [btrfs]
 ? kmem_cache_alloc+0x166/0x1d0
 btrfs_update_inode_item+0x46/0x100 [btrfs]
 cache_save_setup+0xe4/0x3a0 [btrfs]
 btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
 btrfs_commit_transaction+0xcb/0x8b0 [btrfs]

At cache_save_setup() we need to update the inode item of a block group's
cache which is located in the tree root (fs_info->tree_root), which means
that it may result in COWing a leaf from that tree. If that happens we
need to find a free metadata extent and while looking for one, if we find
a block group which was not cached yet we attempt to load its cache by
calling cache_block_group(). However this function will try to load the
inode of the free space cache, which requires finding the matching inode
item in the tree root - if that inode item is located in the same leaf as
the inode item of the space cache we are updating at cache_save_setup(),
we end up in a deadlock, since we try to obtain a read lock on the same
extent buffer that we previously write locked.

So fix this by using the tree root's commit root when searching for a
block group's free space cache inode item when we are attempting to load
a free space cache. This is safe since block groups once loaded stay in
memory forever, as well as their caches, so after they are first loaded
we will never need to read their inode items again. For new block groups,
once they are created they get their ->cached field set to
BTRFS_CACHE_FINISHED meaning we will not need to read their inode item.

Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h            |  3 +++
 fs/btrfs/free-space-cache.c | 22 +++++++++++++++++++++-
 fs/btrfs/inode.c            | 32 ++++++++++++++++++++++----------
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ef7a352d72ed8..cc2d268e2cd7a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3177,6 +3177,9 @@ void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
 int __init btrfs_init_cachep(void);
 void __cold btrfs_destroy_cachep(void);
+struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
+			      struct btrfs_root *root, int *new,
+			      struct btrfs_path *path);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4381e0aba8c01..ec01bd38d675c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -75,7 +75,8 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	 * sure NOFS is set to keep us from deadlocking.
 	 */
 	nofs_flag = memalloc_nofs_save();
-	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
+	inode = btrfs_iget_path(fs_info->sb, &location, root, NULL, path);
+	btrfs_release_path(path);
 	memalloc_nofs_restore(nofs_flag);
 	if (IS_ERR(inode))
 		return inode;
@@ -839,6 +840,25 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
+	/*
+	 * We must pass a path with search_commit_root set to btrfs_iget in
+	 * order to avoid a deadlock when allocating extents for the tree root.
+	 *
+	 * When we are COWing an extent buffer from the tree root, when looking
+	 * for a free extent, at extent-tree.c:find_free_extent(), we can find
+	 * block group without its free space cache loaded. When we find one
+	 * we must load its space cache which requires reading its free space
+	 * cache's inode item from the root tree. If this inode item is located
+	 * in the same leaf that we started COWing before, then we end up in
+	 * deadlock on the extent buffer (trying to read lock it when we
+	 * previously write locked it).
+	 *
+	 * It's safe to read the inode item using the commit root because
+	 * block groups, once loaded, stay in memory forever (until they are
+	 * removed) as well as their space caches once loaded. New block groups
+	 * once created get their ->cached field set to BTRFS_CACHE_FINISHED so
+	 * we will never try to read their inode item while the fs is mounted.
+	 */
 	inode = lookup_free_space_inode(fs_info, block_group, path);
 	if (IS_ERR(inode)) {
 		btrfs_free_path(path);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9aea9381ceeb6..f0f7bc5d2e4a0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3607,10 +3607,11 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
 /*
  * read an inode from the btree into the in-memory inode
  */
-static int btrfs_read_locked_inode(struct inode *inode)
+static int btrfs_read_locked_inode(struct inode *inode,
+				   struct btrfs_path *in_path)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_path *path;
+	struct btrfs_path *path = in_path;
 	struct extent_buffer *leaf;
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -3626,15 +3627,18 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	if (!ret)
 		filled = true;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		path = btrfs_alloc_path();
+		if (!path)
+			return -ENOMEM;
+	}
 
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
 	if (ret) {
-		btrfs_free_path(path);
+		if (path != in_path)
+			btrfs_free_path(path);
 		return ret;
 	}
 
@@ -3774,7 +3778,8 @@ cache_acl:
 				  btrfs_ino(BTRFS_I(inode)),
 				  root->root_key.objectid, ret);
 	}
-	btrfs_free_path(path);
+	if (path != in_path)
+		btrfs_free_path(path);
 
 	if (!maybe_acls)
 		cache_no_acl(inode);
@@ -5716,8 +5721,9 @@ static struct inode *btrfs_iget_locked(struct super_block *s,
 /* Get an inode object given its location and corresponding root.
  * Returns in *is_new if the inode was read from disk
  */
-struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
-			 struct btrfs_root *root, int *new)
+struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
+			      struct btrfs_root *root, int *new,
+			      struct btrfs_path *path)
 {
 	struct inode *inode;
 
@@ -5728,7 +5734,7 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 	if (inode->i_state & I_NEW) {
 		int ret;
 
-		ret = btrfs_read_locked_inode(inode);
+		ret = btrfs_read_locked_inode(inode, path);
 		if (!ret) {
 			inode_tree_add(inode);
 			unlock_new_inode(inode);
@@ -5750,6 +5756,12 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 	return inode;
 }
 
+struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
+			 struct btrfs_root *root, int *new)
+{
+	return btrfs_iget_path(s, location, root, new, NULL);
+}
+
 static struct inode *new_simple_dir(struct super_block *s,
 				    struct btrfs_key *key,
 				    struct btrfs_root *root)
-- 
2.20.1



