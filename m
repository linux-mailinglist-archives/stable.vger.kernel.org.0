Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05B22E3E60
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503945AbgL1O1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437889AbgL1O1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79F402245C;
        Mon, 28 Dec 2020 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165597;
        bh=Gi6D82AkIFNN4agrj6UcUQDEqA2lb7JlCqtgyxCrQ3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0xw2ptWv9hp42+4+oyO15OdbBKY9z2es3eQJrtPfcoptMdIIli8qLICJFtRsYcQgQ
         g5XwmS4x6gHvpoUwe3nIf8eXC60TQ52nz8afqF5hkunizarsPYyP2ibUH/AY/Aq22t
         BVEOtwxkiIxmzJ0rLbaKo0STRnfHQRZaUxU89O6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 588/717] btrfs: update last_byte_to_unpin in switch_commit_roots
Date:   Mon, 28 Dec 2020 13:49:46 +0100
Message-Id: <20201228125049.078902800@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 27d56e62e4748c2135650c260024e9904b8c1a0a upstream.

While writing an explanation for the need of the commit_root_sem for
btrfs_prepare_extent_commit, I realized we have a slight hole that could
result in leaked space if we have to do the old style caching.  Consider
the following scenario

 commit root
 +----+----+----+----+----+----+----+
 |\\\\|    |\\\\|\\\\|    |\\\\|\\\\|
 +----+----+----+----+----+----+----+
 0    1    2    3    4    5    6    7

 new commit root
 +----+----+----+----+----+----+----+
 |    |    |    |\\\\|    |    |\\\\|
 +----+----+----+----+----+----+----+
 0    1    2    3    4    5    6    7

Prior to this patch, we run btrfs_prepare_extent_commit, which updates
the last_byte_to_unpin, and then we subsequently run
switch_commit_roots.  In this example lets assume that
caching_ctl->progress == 1 at btrfs_prepare_extent_commit() time, which
means that cache->last_byte_to_unpin == 1.  Then we go and do the
switch_commit_roots(), but in the meantime the caching thread has made
some more progress, because we drop the commit_root_sem and re-acquired
it.  Now caching_ctl->progress == 3.  We swap out the commit root and
carry on to unpin.

The race can happen like:

  1) The caching thread was running using the old commit root when it
     found the extent for [2, 3);

  2) Then it released the commit_root_sem because it was in the last
     item of a leaf and the semaphore was contended, and set ->progress
     to 3 (value of 'last'), as the last extent item in the current leaf
     was for the extent for range [2, 3);

  3) Next time it gets the commit_root_sem, will start using the new
     commit root and search for a key with offset 3, so it never finds
     the hole for [2, 3).

  So the caching thread never saw [2, 3) as free space in any of the
  commit roots, and by the time finish_extent_commit() was called for
  the range [0, 3), ->last_byte_to_unpin was 1, so it only returned the
  subrange [0, 1) to the free space cache, skipping [2, 3).

In the unpin code we have last_byte_to_unpin == 1, so we unpin [0,1),
but do not unpin [2,3).  However because caching_ctl->progress == 3 we
do not see the newly freed section of [2,3), and thus do not add it to
our free space cache.  This results in us missing a chunk of free space
in memory (on disk too, unless we have a power failure before writing
the free space cache to disk).

Fix this by making sure the ->last_byte_to_unpin is set at the same time
that we swap the commit roots, this ensures that we will always be
consistent.

CC: stable@vger.kernel.org # 5.8+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ update changelog with Filipe's review comments ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h       |    1 -
 fs/btrfs/extent-tree.c |   25 -------------------------
 fs/btrfs/transaction.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 28 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2593,7 +2593,6 @@ int btrfs_free_reserved_extent(struct bt
 			       u64 start, u64 len, int delalloc);
 int btrfs_pin_reserved_extent(struct btrfs_trans_handle *trans, u64 start,
 			      u64 len);
-void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_ref *generic_ref);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2730,31 +2730,6 @@ btrfs_inc_block_group_reservations(struc
 	atomic_inc(&bg->reservations);
 }
 
-void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_caching_control *next;
-	struct btrfs_caching_control *caching_ctl;
-	struct btrfs_block_group *cache;
-
-	down_write(&fs_info->commit_root_sem);
-
-	list_for_each_entry_safe(caching_ctl, next,
-				 &fs_info->caching_block_groups, list) {
-		cache = caching_ctl->block_group;
-		if (btrfs_block_group_done(cache)) {
-			cache->last_byte_to_unpin = (u64)-1;
-			list_del_init(&caching_ctl->list);
-			btrfs_put_caching_control(caching_ctl);
-		} else {
-			cache->last_byte_to_unpin = caching_ctl->progress;
-		}
-	}
-
-	up_write(&fs_info->commit_root_sem);
-
-	btrfs_update_global_block_rsv(fs_info);
-}
-
 /*
  * Returns the free cluster for the given space info and sets empty_cluster to
  * what it should be based on the mount options.
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -155,6 +155,7 @@ static noinline void switch_commit_roots
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root, *tmp;
+	struct btrfs_caching_control *caching_ctl, *next;
 
 	down_write(&fs_info->commit_root_sem);
 	list_for_each_entry_safe(root, tmp, &cur_trans->switch_commits,
@@ -180,6 +181,45 @@ static noinline void switch_commit_roots
 		spin_lock(&cur_trans->dropped_roots_lock);
 	}
 	spin_unlock(&cur_trans->dropped_roots_lock);
+
+	/*
+	 * We have to update the last_byte_to_unpin under the commit_root_sem,
+	 * at the same time we swap out the commit roots.
+	 *
+	 * This is because we must have a real view of the last spot the caching
+	 * kthreads were while caching.  Consider the following views of the
+	 * extent tree for a block group
+	 *
+	 * commit root
+	 * +----+----+----+----+----+----+----+
+	 * |\\\\|    |\\\\|\\\\|    |\\\\|\\\\|
+	 * +----+----+----+----+----+----+----+
+	 * 0    1    2    3    4    5    6    7
+	 *
+	 * new commit root
+	 * +----+----+----+----+----+----+----+
+	 * |    |    |    |\\\\|    |    |\\\\|
+	 * +----+----+----+----+----+----+----+
+	 * 0    1    2    3    4    5    6    7
+	 *
+	 * If the cache_ctl->progress was at 3, then we are only allowed to
+	 * unpin [0,1) and [2,3], because the caching thread has already
+	 * processed those extents.  We are not allowed to unpin [5,6), because
+	 * the caching thread will re-start it's search from 3, and thus find
+	 * the hole from [4,6) to add to the free space cache.
+	 */
+	list_for_each_entry_safe(caching_ctl, next,
+				 &fs_info->caching_block_groups, list) {
+		struct btrfs_block_group *cache = caching_ctl->block_group;
+
+		if (btrfs_block_group_done(cache)) {
+			cache->last_byte_to_unpin = (u64)-1;
+			list_del_init(&caching_ctl->list);
+			btrfs_put_caching_control(caching_ctl);
+		} else {
+			cache->last_byte_to_unpin = caching_ctl->progress;
+		}
+	}
 	up_write(&fs_info->commit_root_sem);
 }
 
@@ -2293,8 +2333,6 @@ int btrfs_commit_transaction(struct btrf
 		goto unlock_tree_log;
 	}
 
-	btrfs_prepare_extent_commit(fs_info);
-
 	cur_trans = fs_info->running_transaction;
 
 	btrfs_set_root_node(&fs_info->tree_root->root_item,


