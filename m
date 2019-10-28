Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927CAE6C95
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 07:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbfJ1Gz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 02:55:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:48690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726182AbfJ1Gz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 02:55:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D50BAAC24;
        Mon, 28 Oct 2019 06:55:55 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: qgroup: Always free PREALLOC META reserve in btrfs_delalloc_release_extents()
Date:   Mon, 28 Oct 2019 14:55:51 +0800
Message-Id: <20191028065551.99609-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8702ba9396bf7bbae2ab93c94acd4bd37cfa4f09 upstream.

[Background]
Btrfs qgroup uses two types of reserved space for METADATA space,
PERTRANS and PREALLOC.

PERTRANS is metadata space reserved for each transaction started by
btrfs_start_transaction().
While PREALLOC is for delalloc, where we reserve space before joining a
transaction, and finally it will be converted to PERTRANS after the
writeback is done.

[Inconsistency]
However there is inconsistency in how we handle PREALLOC metadata space.

The most obvious one is:
In btrfs_buffered_write():
	btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes, true);

We always free qgroup PREALLOC meta space.

While in btrfs_truncate_block():
	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, (ret != 0));

We only free qgroup PREALLOC meta space when something went wrong.

[The Correct Behavior]
The correct behavior should be the one in btrfs_buffered_write(), we
should always free PREALLOC metadata space.

The reason is, the btrfs_delalloc_* mechanism works by:
- Reserve metadata first, even it's not necessary
  In btrfs_delalloc_reserve_metadata()

- Free the unused metadata space
  Normally in:
  btrfs_delalloc_release_extents()
  |- btrfs_inode_rsv_release()
     Here we do calculation on whether we should release or not.

E.g. for 64K buffered write, the metadata rsv works like:

/* The first page */
reserve_meta:	num_bytes=calc_inode_reservations()
free_meta:	num_bytes=0
total:		num_bytes=calc_inode_reservations()
/* The first page caused one outstanding extent, thus needs metadata
   rsv */

/* The 2nd page */
reserve_meta:	num_bytes=calc_inode_reservations()
free_meta:	num_bytes=calc_inode_reservations()
total:		not changed
/* The 2nd page doesn't cause new outstanding extent, needs no new meta
   rsv, so we free what we have reserved */

/* The 3rd~16th pages */
reserve_meta:	num_bytes=calc_inode_reservations()
free_meta:	num_bytes=calc_inode_reservations()
total:		not changed (still space for one outstanding extent)

This means, if btrfs_delalloc_release_extents() determines to free some
space, then those space should be freed NOW.
So for qgroup, we should call btrfs_qgroup_free_meta_prealloc() other
than btrfs_qgroup_convert_reserved_meta().

The good news is:
- The callers are not that hot
  The hottest caller is in btrfs_buffered_write(), which is already
  fixed by commit 336a8bb8e36a ("btrfs: Fix wrong
  btrfs_delalloc_release_extents parameter"). Thus it's not that
  easy to cause false EDQUOT.

- The trans commit in advance for qgroup would hide the bug
  Since commit f5fef4593653 ("btrfs: qgroup: Make qgroup async transaction
  commit more aggressive"), when btrfs qgroup metadata free space is slow,
  it will try to commit transaction and free the wrongly converted
  PERTRANS space, so it's not that easy to hit such bug.

[FIX]
So to fix the problem, remove the @qgroup_free parameter for
btrfs_delalloc_release_extents(), and always pass true to
btrfs_inode_rsv_release().

Reported-by: Filipe Manana <fdmanana@suse.com>
Fixes: 43b18595d660 ("btrfs: qgroup: Use separate meta reservation type for delalloc")
CC: stable@vger.kernel.org # 5.3
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
[Fix conflicts caused by missing fixes]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h          |  3 +--
 fs/btrfs/delalloc-space.c |  6 ++----
 fs/btrfs/file.c           |  7 +++----
 fs/btrfs/inode-map.c      |  4 ++--
 fs/btrfs/inode.c          | 12 ++++++------
 fs/btrfs/ioctl.c          |  6 ++----
 fs/btrfs/relocation.c     |  7 +++----
 7 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d9541d58ce3d..9990c158b913 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2760,8 +2760,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     int nitems, bool use_global_rsv);
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
-void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
-				    bool qgroup_free);
+void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
 int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 17f7c0d38768..bbce0baf0a29 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -408,7 +408,6 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
  * btrfs_delalloc_release_extents - release our outstanding_extents
  * @inode: the inode to balance the reservation for.
  * @num_bytes: the number of bytes we originally reserved with
- * @qgroup_free: do we need to free qgroup meta reservation or convert them.
  *
  * When we reserve space we increase outstanding_extents for the extents we may
  * add.  Once we've set the range as delalloc or created our ordered extents we
@@ -416,8 +415,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
  * temporarily tracked outstanding_extents.  This _must_ be used in conjunction
  * with btrfs_delalloc_reserve_metadata.
  */
-void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
-				    bool qgroup_free)
+void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned num_extents;
@@ -431,7 +429,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
 	if (btrfs_is_testing(fs_info))
 		return;
 
-	btrfs_inode_rsv_release(inode, qgroup_free);
+	btrfs_inode_rsv_release(inode, true);
 }
 
 /**
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index abcda051eee2..5dab739f8776 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1692,7 +1692,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 				    force_page_uptodate);
 		if (ret) {
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes, true);
+						       reserve_bytes);
 			break;
 		}
 
@@ -1704,7 +1704,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 			if (extents_locked == -EAGAIN)
 				goto again;
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes, true);
+						       reserve_bytes);
 			ret = extents_locked;
 			break;
 		}
@@ -1772,8 +1772,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		else
 			free_extent_state(cached_state);
 
-		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes,
-					       true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
 			break;
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 2e8bb402050b..9b82dc042cd0 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -484,12 +484,12 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc);
 		goto out_put;
 	}
 
 	ret = btrfs_write_out_ino_cache(root, trans, path, inode);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc);
 out_put:
 	iput(inode);
 out_release:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b3453adb214d..1b85278471f6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2167,7 +2167,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			     &cached_state);
@@ -4912,7 +4912,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	if (!page) {
 		btrfs_delalloc_release_space(inode, data_reserved,
 					     block_start, blocksize, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4980,7 +4980,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	if (ret)
 		btrfs_delalloc_release_space(inode, data_reserved, block_start,
 					     blocksize, true);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, (ret != 0));
+	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize);
 	unlock_page(page);
 	put_page(page);
 out:
@@ -8685,7 +8685,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, data_reserved,
 					offset, count - (size_t)ret, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), count, false);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), count);
 	}
 out:
 	if (wakeup)
@@ -9038,7 +9038,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
 	if (!ret2) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 		sb_end_pagefault(inode->i_sb);
 		extent_changeset_free(data_reserved);
 		return VM_FAULT_LOCKED;
@@ -9047,7 +9047,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 out_unlock:
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 	btrfs_delalloc_release_space(inode, data_reserved, page_start,
 				     reserved_space, (ret != 0));
 out_noreserve:
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 818f7ec8bb0e..8dad66df74ed 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1360,8 +1360,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		unlock_page(pages[i]);
 		put_page(pages[i]);
 	}
-	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
-				       false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return i_done;
 out:
@@ -1372,8 +1371,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	btrfs_delalloc_release_space(inode, data_reserved,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, true);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
-				       true);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return ret;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fbd66c33dd63..89e3640fccdb 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3296,7 +3296,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							PAGE_SIZE, true);
 				btrfs_delalloc_release_extents(BTRFS_I(inode),
-							       PAGE_SIZE, true);
+							       PAGE_SIZE);
 				ret = -EIO;
 				goto out;
 			}
@@ -3325,7 +3325,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							 PAGE_SIZE, true);
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-			                               PAGE_SIZE, true);
+			                               PAGE_SIZE);
 
 			clear_extent_bits(&BTRFS_I(inode)->io_tree,
 					  page_start, page_end,
@@ -3341,8 +3341,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		put_page(page);
 
 		index++;
-		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE,
-					       false);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 		balance_dirty_pages_ratelimited(inode->i_mapping);
 		btrfs_throttle(fs_info);
 	}
-- 
2.23.0

