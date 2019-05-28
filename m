Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12B2C41B
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 12:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfE1KSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 06:18:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:32826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbfE1KSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 06:18:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F2CD6AC66;
        Tue, 28 May 2019 10:18:44 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: honor path->skip_locking in backref code
Date:   Tue, 28 May 2019 18:18:35 +0800
Message-Id: <20190528101835.20377-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

Commit 38e3eebff643db725633657d1d87a3be019d1018.

Qgroups will do the old roots lookup at delayed ref time, which could be
while walking down the extent root while running a delayed ref.  This
should be fine, except we specifically lock eb's in the backref walking
code irrespective of path->skip_locking, which deadlocks the system.
Fix up the backref code to honor path->skip_locking, nobody will be
modifying the commit_root when we're searching so it's completely safe
to do.

This happens since fb235dc06fac ("btrfs: qgroup: Move half of the qgroup
accounting time out of commit trans"), kernel may lockup with quota
enabled.

There is one backref trace triggered by snapshot dropping along with
write operation in the source subvolume.  The example can be reliably
reproduced:

  btrfs-cleaner   D    0  4062      2 0x80000000
  Call Trace:
   schedule+0x32/0x90
   btrfs_tree_read_lock+0x93/0x130 [btrfs]
   find_parent_nodes+0x29b/0x1170 [btrfs]
   btrfs_find_all_roots_safe+0xa8/0x120 [btrfs]
   btrfs_find_all_roots+0x57/0x70 [btrfs]
   btrfs_qgroup_trace_extent_post+0x37/0x70 [btrfs]
   btrfs_qgroup_trace_leaf_items+0x10b/0x140 [btrfs]
   btrfs_qgroup_trace_subtree+0xc8/0xe0 [btrfs]
   do_walk_down+0x541/0x5e3 [btrfs]
   walk_down_tree+0xab/0xe7 [btrfs]
   btrfs_drop_snapshot+0x356/0x71a [btrfs]
   btrfs_clean_one_deleted_snapshot+0xb8/0xf0 [btrfs]
   cleaner_kthread+0x12b/0x160 [btrfs]
   kthread+0x112/0x130
   ret_from_fork+0x27/0x50

When dropping snapshots with qgroup enabled, we will trigger backref
walk.

However such backref walk at that timing is pretty dangerous, as if one
of the parent nodes get WRITE locked by other thread, we could cause a
dead lock.

For example:

           FS 260     FS 261 (Dropped)
            node A        node B
           /      \      /      \
       node C      node D      node E
      /   \         /  \        /     \
  leaf F|leaf G|leaf H|leaf I|leaf J|leaf K

The lock sequence would be:

      Thread A (cleaner)             |       Thread B (other writer)
-----------------------------------------------------------------------
write_lock(B)                        |
write_lock(D)                        |
^^^ called by walk_down_tree()       |
                                     |       write_lock(A)
                                     |       write_lock(D) << Stall
read_lock(H) << for backref walk     |
read_lock(D) << lock owner is        |
                the same thread A    |
                so read lock is OK   |
read_lock(A) << Stall                |

So thread A hold write lock D, and needs read lock A to unlock.
While thread B holds write lock A, while needs lock D to unlock.

This will cause a deadlock.

This is not only limited to snapshot dropping case.  As the backref
walk, even only happens on commit trees, is breaking the normal top-down
locking order, makes it deadlock prone.

Fixes: fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting time out of commit trans")
CC: stable@vger.kernel.org # 4.19
Reported-and-tested-by: David Sterba <dsterba@suse.com>
Reported-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
[ rebase to latest branch and fix lock assert bug in btrfs/007 ]
[ backport to linux-4.19.y branch, solve minor conflicts ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
[ copy logs and deadlock analysis from Qu's patch ]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 2a4f52c7be22..ac6c383d6314 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -710,7 +710,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
  * read tree blocks and add keys where required.
  */
 static int add_missing_keys(struct btrfs_fs_info *fs_info,
-			    struct preftrees *preftrees)
+			    struct preftrees *preftrees, bool lock)
 {
 	struct prelim_ref *ref;
 	struct extent_buffer *eb;
@@ -735,12 +735,14 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 			free_extent_buffer(eb);
 			return -EIO;
 		}
-		btrfs_tree_read_lock(eb);
+		if (lock)
+			btrfs_tree_read_lock(eb);
 		if (btrfs_header_level(eb) == 0)
 			btrfs_item_key_to_cpu(eb, &ref->key_for_search, 0);
 		else
 			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
-		btrfs_tree_read_unlock(eb);
+		if (lock)
+			btrfs_tree_read_unlock(eb);
 		free_extent_buffer(eb);
 		prelim_ref_insert(fs_info, &preftrees->indirect, ref, NULL);
 		cond_resched();
@@ -1225,7 +1227,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
-	ret = add_missing_keys(fs_info, &preftrees);
+	ret = add_missing_keys(fs_info, &preftrees, path->skip_locking == 0);
 	if (ret)
 		goto out;
 
@@ -1286,11 +1288,14 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 					ret = -EIO;
 					goto out;
 				}
-				btrfs_tree_read_lock(eb);
-				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+				if (!path->skip_locking) {
+					btrfs_tree_read_lock(eb);
+					btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+				}
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie, ignore_offset);
-				btrfs_tree_read_unlock_blocking(eb);
+				if (!path->skip_locking)
+					btrfs_tree_read_unlock_blocking(eb);
 				free_extent_buffer(eb);
 				if (ret < 0)
 					goto out;
-- 
2.21.0

