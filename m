Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42E2ABB0C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387814AbgKINTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387829AbgKINTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0226022202;
        Mon,  9 Nov 2020 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927986;
        bh=Lk1Ioj5OtEIFCoX9BPJweRf7WGn5dk56LBW1heo/3hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rowoux4n4HAUfmeEwLHRegubOodhGp8c6J6HP1WLzmy9Ch8lCUq4CiKUpKm2DsgPd
         yGjP47+aqThUREtpeGiL7ifE/X4TO4xUSOPyzIgCqj02fybL9UjFRPBFnPwnVFDAvq
         cj/rkqeDiBQehWseK0dXa/SiNc89w59LJmLt7kX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 088/133] btrfs: add a helper to read the tree_root commit root for backref lookup
Date:   Mon,  9 Nov 2020 13:55:50 +0100
Message-Id: <20201109125034.939995014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 49d11bead7d596e031fbd34051d8765587cd645b ]

I got the following lockdep splat with tree locks converted to rwsem
patches on btrfs/104:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.9.0+ #102 Not tainted
  ------------------------------------------------------
  btrfs-cleaner/903 is trying to acquire lock:
  ffff8e7fab6ffe30 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x32/0x170

  but task is already holding lock:
  ffff8e7fab628a88 (&fs_info->commit_root_sem){++++}-{3:3}, at: btrfs_find_all_roots+0x41/0x80

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #3 (&fs_info->commit_root_sem){++++}-{3:3}:
	 down_read+0x40/0x130
	 caching_thread+0x53/0x5a0
	 btrfs_work_helper+0xfa/0x520
	 process_one_work+0x238/0x540
	 worker_thread+0x55/0x3c0
	 kthread+0x13a/0x150
	 ret_from_fork+0x1f/0x30

  -> #2 (&caching_ctl->mutex){+.+.}-{3:3}:
	 __mutex_lock+0x7e/0x7b0
	 btrfs_cache_block_group+0x1e0/0x510
	 find_free_extent+0xb6e/0x12f0
	 btrfs_reserve_extent+0xb3/0x1b0
	 btrfs_alloc_tree_block+0xb1/0x330
	 alloc_tree_block_no_bg_flush+0x4f/0x60
	 __btrfs_cow_block+0x11d/0x580
	 btrfs_cow_block+0x10c/0x220
	 commit_cowonly_roots+0x47/0x2e0
	 btrfs_commit_transaction+0x595/0xbd0
	 sync_filesystem+0x74/0x90
	 generic_shutdown_super+0x22/0x100
	 kill_anon_super+0x14/0x30
	 btrfs_kill_super+0x12/0x20
	 deactivate_locked_super+0x36/0xa0
	 cleanup_mnt+0x12d/0x190
	 task_work_run+0x5c/0xa0
	 exit_to_user_mode_prepare+0x1df/0x200
	 syscall_exit_to_user_mode+0x54/0x280
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #1 (&space_info->groups_sem){++++}-{3:3}:
	 down_read+0x40/0x130
	 find_free_extent+0x2ed/0x12f0
	 btrfs_reserve_extent+0xb3/0x1b0
	 btrfs_alloc_tree_block+0xb1/0x330
	 alloc_tree_block_no_bg_flush+0x4f/0x60
	 __btrfs_cow_block+0x11d/0x580
	 btrfs_cow_block+0x10c/0x220
	 commit_cowonly_roots+0x47/0x2e0
	 btrfs_commit_transaction+0x595/0xbd0
	 sync_filesystem+0x74/0x90
	 generic_shutdown_super+0x22/0x100
	 kill_anon_super+0x14/0x30
	 btrfs_kill_super+0x12/0x20
	 deactivate_locked_super+0x36/0xa0
	 cleanup_mnt+0x12d/0x190
	 task_work_run+0x5c/0xa0
	 exit_to_user_mode_prepare+0x1df/0x200
	 syscall_exit_to_user_mode+0x54/0x280
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (btrfs-root-00){++++}-{3:3}:
	 __lock_acquire+0x1167/0x2150
	 lock_acquire+0xb9/0x3d0
	 down_read_nested+0x43/0x130
	 __btrfs_tree_read_lock+0x32/0x170
	 __btrfs_read_lock_root_node+0x3a/0x50
	 btrfs_search_slot+0x614/0x9d0
	 btrfs_find_root+0x35/0x1b0
	 btrfs_read_tree_root+0x61/0x120
	 btrfs_get_root_ref+0x14b/0x600
	 find_parent_nodes+0x3e6/0x1b30
	 btrfs_find_all_roots_safe+0xb4/0x130
	 btrfs_find_all_roots+0x60/0x80
	 btrfs_qgroup_trace_extent_post+0x27/0x40
	 btrfs_add_delayed_data_ref+0x3fd/0x460
	 btrfs_free_extent+0x42/0x100
	 __btrfs_mod_ref+0x1d7/0x2f0
	 walk_up_proc+0x11c/0x400
	 walk_up_tree+0xf0/0x180
	 btrfs_drop_snapshot+0x1c7/0x780
	 btrfs_clean_one_deleted_snapshot+0xfb/0x110
	 cleaner_kthread+0xd4/0x140
	 kthread+0x13a/0x150
	 ret_from_fork+0x1f/0x30

  other info that might help us debug this:

  Chain exists of:
    btrfs-root-00 --> &caching_ctl->mutex --> &fs_info->commit_root_sem

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(&fs_info->commit_root_sem);
				 lock(&caching_ctl->mutex);
				 lock(&fs_info->commit_root_sem);
    lock(btrfs-root-00);

   *** DEADLOCK ***

  3 locks held by btrfs-cleaner/903:
   #0: ffff8e7fab628838 (&fs_info->cleaner_mutex){+.+.}-{3:3}, at: cleaner_kthread+0x6e/0x140
   #1: ffff8e7faadac640 (sb_internal){.+.+}-{0:0}, at: start_transaction+0x40b/0x5c0
   #2: ffff8e7fab628a88 (&fs_info->commit_root_sem){++++}-{3:3}, at: btrfs_find_all_roots+0x41/0x80

  stack backtrace:
  CPU: 0 PID: 903 Comm: btrfs-cleaner Not tainted 5.9.0+ #102
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
  Call Trace:
   dump_stack+0x8b/0xb0
   check_noncircular+0xcf/0xf0
   __lock_acquire+0x1167/0x2150
   ? __bfs+0x42/0x210
   lock_acquire+0xb9/0x3d0
   ? __btrfs_tree_read_lock+0x32/0x170
   down_read_nested+0x43/0x130
   ? __btrfs_tree_read_lock+0x32/0x170
   __btrfs_tree_read_lock+0x32/0x170
   __btrfs_read_lock_root_node+0x3a/0x50
   btrfs_search_slot+0x614/0x9d0
   ? find_held_lock+0x2b/0x80
   btrfs_find_root+0x35/0x1b0
   ? do_raw_spin_unlock+0x4b/0xa0
   btrfs_read_tree_root+0x61/0x120
   btrfs_get_root_ref+0x14b/0x600
   find_parent_nodes+0x3e6/0x1b30
   btrfs_find_all_roots_safe+0xb4/0x130
   btrfs_find_all_roots+0x60/0x80
   btrfs_qgroup_trace_extent_post+0x27/0x40
   btrfs_add_delayed_data_ref+0x3fd/0x460
   btrfs_free_extent+0x42/0x100
   __btrfs_mod_ref+0x1d7/0x2f0
   walk_up_proc+0x11c/0x400
   walk_up_tree+0xf0/0x180
   btrfs_drop_snapshot+0x1c7/0x780
   ? btrfs_clean_one_deleted_snapshot+0x73/0x110
   btrfs_clean_one_deleted_snapshot+0xfb/0x110
   cleaner_kthread+0xd4/0x140
   ? btrfs_alloc_root+0x50/0x50
   kthread+0x13a/0x150
   ? kthread_create_worker_on_cpu+0x40/0x40
   ret_from_fork+0x1f/0x30
  BTRFS info (device sdb): disk space caching is enabled
  BTRFS info (device sdb): has skinny extents

This happens because qgroups does a backref lookup when we create a
delayed ref.  From here it may have to look up a root from an indirect
ref, which does a normal lookup on the tree_root, which takes the read
lock on the tree_root nodes.

To fix this we need to add a variant for looking up roots that searches
the commit root of the tree_root.  Then when we do the backref search
using the commit root we are sure to not take any locks on the tree_root
nodes.  This gets rid of the lockdep splat when running btrfs/104.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c |  13 ++++-
 fs/btrfs/disk-io.c | 139 ++++++++++++++++++++++++++++++++-------------
 fs/btrfs/disk-io.h |   3 +
 3 files changed, 114 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index ea1c28ccb44ff..b948df7a929eb 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -544,7 +544,18 @@ static int resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	int level = ref->level;
 	struct btrfs_key search_key = ref->key_for_search;
 
-	root = btrfs_get_fs_root(fs_info, ref->root_id, false);
+	/*
+	 * If we're search_commit_root we could possibly be holding locks on
+	 * other tree nodes.  This happens when qgroups does backref walks when
+	 * adding new delayed refs.  To deal with this we need to look in cache
+	 * for the root, and if we don't find it then we need to search the
+	 * tree_root's commit root, thus the btrfs_get_fs_root_commit_root usage
+	 * here.
+	 */
+	if (path->search_commit_root)
+		root = btrfs_get_fs_root_commit_root(fs_info, path, ref->root_id);
+	else
+		root = btrfs_get_fs_root(fs_info, ref->root_id, false);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
 		goto out_free;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7882c07645014..2a0a1c032a72c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1338,32 +1338,26 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
-					struct btrfs_key *key)
+static struct btrfs_root *read_tree_root_path(struct btrfs_root *tree_root,
+					      struct btrfs_path *path,
+					      struct btrfs_key *key)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
-	struct btrfs_path *path;
 	u64 generation;
 	int ret;
 	int level;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return ERR_PTR(-ENOMEM);
-
 	root = btrfs_alloc_root(fs_info, key->objectid, GFP_NOFS);
-	if (!root) {
-		ret = -ENOMEM;
-		goto alloc_fail;
-	}
+	if (!root)
+		return ERR_PTR(-ENOMEM);
 
 	ret = btrfs_find_root(tree_root, key, path,
 			      &root->root_item, &root->root_key);
 	if (ret) {
 		if (ret > 0)
 			ret = -ENOENT;
-		goto find_fail;
+		goto fail;
 	}
 
 	generation = btrfs_root_generation(&root->root_item);
@@ -1374,21 +1368,31 @@ struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 	if (IS_ERR(root->node)) {
 		ret = PTR_ERR(root->node);
 		root->node = NULL;
-		goto find_fail;
+		goto fail;
 	} else if (!btrfs_buffer_uptodate(root->node, generation, 0)) {
 		ret = -EIO;
-		goto find_fail;
+		goto fail;
 	}
 	root->commit_root = btrfs_root_node(root);
-out:
-	btrfs_free_path(path);
 	return root;
-
-find_fail:
+fail:
 	btrfs_put_root(root);
-alloc_fail:
-	root = ERR_PTR(ret);
-	goto out;
+	return ERR_PTR(ret);
+}
+
+struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
+					struct btrfs_key *key)
+{
+	struct btrfs_root *root;
+	struct btrfs_path *path;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return ERR_PTR(-ENOMEM);
+	root = read_tree_root_path(tree_root, path, key);
+	btrfs_free_path(path);
+
+	return root;
 }
 
 /*
@@ -1476,6 +1480,31 @@ static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
 	return root;
 }
 
+static struct btrfs_root *btrfs_get_global_root(struct btrfs_fs_info *fs_info,
+						u64 objectid)
+{
+	if (objectid == BTRFS_ROOT_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->tree_root);
+	if (objectid == BTRFS_EXTENT_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->extent_root);
+	if (objectid == BTRFS_CHUNK_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->chunk_root);
+	if (objectid == BTRFS_DEV_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->dev_root);
+	if (objectid == BTRFS_CSUM_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->csum_root);
+	if (objectid == BTRFS_QUOTA_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->quota_root) ?
+			fs_info->quota_root : ERR_PTR(-ENOENT);
+	if (objectid == BTRFS_UUID_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->uuid_root) ?
+			fs_info->uuid_root : ERR_PTR(-ENOENT);
+	if (objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->free_space_root) ?
+			fs_info->free_space_root : ERR_PTR(-ENOENT);
+	return NULL;
+}
+
 int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 			 struct btrfs_root *root)
 {
@@ -1573,25 +1602,9 @@ static struct btrfs_root *btrfs_get_root_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	int ret;
 
-	if (objectid == BTRFS_ROOT_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->tree_root);
-	if (objectid == BTRFS_EXTENT_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->extent_root);
-	if (objectid == BTRFS_CHUNK_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->chunk_root);
-	if (objectid == BTRFS_DEV_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->dev_root);
-	if (objectid == BTRFS_CSUM_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->csum_root);
-	if (objectid == BTRFS_QUOTA_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->quota_root) ?
-			fs_info->quota_root : ERR_PTR(-ENOENT);
-	if (objectid == BTRFS_UUID_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->uuid_root) ?
-			fs_info->uuid_root : ERR_PTR(-ENOENT);
-	if (objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
-		return btrfs_grab_root(fs_info->free_space_root) ?
-			fs_info->free_space_root : ERR_PTR(-ENOENT);
+	root = btrfs_get_global_root(fs_info, objectid);
+	if (root)
+		return root;
 again:
 	root = btrfs_lookup_fs_root(fs_info, objectid);
 	if (root) {
@@ -1676,6 +1689,52 @@ struct btrfs_root *btrfs_get_new_fs_root(struct btrfs_fs_info *fs_info,
 	return btrfs_get_root_ref(fs_info, objectid, anon_dev, true);
 }
 
+/*
+ * btrfs_get_fs_root_commit_root - return a root for the given objectid
+ * @fs_info:	the fs_info
+ * @objectid:	the objectid we need to lookup
+ *
+ * This is exclusively used for backref walking, and exists specifically because
+ * of how qgroups does lookups.  Qgroups will do a backref lookup at delayed ref
+ * creation time, which means we may have to read the tree_root in order to look
+ * up a fs root that is not in memory.  If the root is not in memory we will
+ * read the tree root commit root and look up the fs root from there.  This is a
+ * temporary root, it will not be inserted into the radix tree as it doesn't
+ * have the most uptodate information, it'll simply be discarded once the
+ * backref code is finished using the root.
+ */
+struct btrfs_root *btrfs_get_fs_root_commit_root(struct btrfs_fs_info *fs_info,
+						 struct btrfs_path *path,
+						 u64 objectid)
+{
+	struct btrfs_root *root;
+	struct btrfs_key key;
+
+	ASSERT(path->search_commit_root && path->skip_locking);
+
+	/*
+	 * This can return -ENOENT if we ask for a root that doesn't exist, but
+	 * since this is called via the backref walking code we won't be looking
+	 * up a root that doesn't exist, unless there's corruption.  So if root
+	 * != NULL just return it.
+	 */
+	root = btrfs_get_global_root(fs_info, objectid);
+	if (root)
+		return root;
+
+	root = btrfs_lookup_fs_root(fs_info, objectid);
+	if (root)
+		return root;
+
+	key.objectid = objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	root = read_tree_root_path(fs_info->tree_root, path, &key);
+	btrfs_release_path(path);
+
+	return root;
+}
+
 /*
  * called by the kthread helper functions to finally call the bio end_io
  * functions.  This is where read checksum verification actually happens
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 00dc39d47ed34..2e6da9ae8462f 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -69,6 +69,9 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 				     u64 objectid, bool check_ref);
 struct btrfs_root *btrfs_get_new_fs_root(struct btrfs_fs_info *fs_info,
 					 u64 objectid, dev_t anon_dev);
+struct btrfs_root *btrfs_get_fs_root_commit_root(struct btrfs_fs_info *fs_info,
+						 struct btrfs_path *path,
+						 u64 objectid);
 
 void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
-- 
2.27.0



