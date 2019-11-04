Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE11EEF61
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbfKDV61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbfKDV6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:24 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674FF214D8;
        Mon,  4 Nov 2019 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904702;
        bh=AROn0YCWfbPiCHD2vM+7j+ctwnzsiqI1LfLX4Yiv1qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGarnP7K1XZtc/YQLGhFAVo3F391bxCy3wK2EWdRyla7rMaElXkoC0XO/NvT4odG5
         +Hsc/NGForWzHTeMGh5w3NM5uEQl7oSijUa20j4NUQrhHw/dWvq9KrLfnGuJg2evSz
         LAQxHHP7HB2pn+vlQPEan6L2DqV9AI2GceHlbPno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/149] btrfs: qgroup: Always free PREALLOC META reserve in btrfs_delalloc_release_extents()
Date:   Mon,  4 Nov 2019 22:43:19 +0100
Message-Id: <20191104212129.175112288@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 8702ba9396bf7bbae2ab93c94acd4bd37cfa4f09 ]

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
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h       |  3 +--
 fs/btrfs/extent-tree.c |  5 ++---
 fs/btrfs/file.c        |  7 +++----
 fs/btrfs/inode-map.c   |  4 ++--
 fs/btrfs/inode.c       | 12 ++++++------
 fs/btrfs/ioctl.c       |  6 ++----
 fs/btrfs/relocation.c  |  9 ++++-----
 7 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index faca485ccd8f4..ef7a352d72ed8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2747,8 +2747,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     int nitems, bool use_global_rsv);
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
-void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
-				    bool qgroup_free);
+void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 72c745682996f..024dd336b20ae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5980,8 +5980,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
  * temporarily tracked outstanding_extents.  This _must_ be used in conjunction
  * with btrfs_delalloc_reserve_metadata.
  */
-void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
-				    bool qgroup_free)
+void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned num_extents;
@@ -5995,7 +5994,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
 	if (btrfs_is_testing(fs_info))
 		return;
 
-	btrfs_inode_rsv_release(inode, qgroup_free);
+	btrfs_inode_rsv_release(inode, true);
 }
 
 /**
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5d036b794e4af..a456801e0cd54 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1692,7 +1692,7 @@ again:
 				    force_page_uptodate);
 		if (ret) {
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes, true);
+						       reserve_bytes);
 			break;
 		}
 
@@ -1704,7 +1704,7 @@ again:
 			if (extents_locked == -EAGAIN)
 				goto again;
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes, true);
+						       reserve_bytes);
 			ret = extents_locked;
 			break;
 		}
@@ -1772,8 +1772,7 @@ again:
 		else
 			free_extent_state(cached_state);
 
-		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes,
-					       true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
 			break;
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 0141fc08d317e..e1b50c62ba650 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -483,13 +483,13 @@ again:
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc);
 		btrfs_delalloc_release_metadata(BTRFS_I(inode), prealloc, true);
 		goto out_put;
 	}
 
 	ret = btrfs_write_out_ino_cache(root, trans, path, inode);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc);
 out_put:
 	iput(inode);
 out_release:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 37332f83a3a96..9aea9381ceeb6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2166,7 +2166,7 @@ again:
 
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			     &cached_state);
@@ -4918,7 +4918,7 @@ again:
 	if (!page) {
 		btrfs_delalloc_release_space(inode, data_reserved,
 					     block_start, blocksize, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4986,7 +4986,7 @@ out_unlock:
 	if (ret)
 		btrfs_delalloc_release_space(inode, data_reserved, block_start,
 					     blocksize, true);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, (ret != 0));
+	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize);
 	unlock_page(page);
 	put_page(page);
 out:
@@ -8660,7 +8660,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, data_reserved,
 					offset, count - (size_t)ret, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), count, false);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), count);
 	}
 out:
 	if (wakeup)
@@ -9013,7 +9013,7 @@ again:
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
 	if (!ret2) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 		sb_end_pagefault(inode->i_sb);
 		extent_changeset_free(data_reserved);
 		return VM_FAULT_LOCKED;
@@ -9022,7 +9022,7 @@ again:
 out_unlock:
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 	btrfs_delalloc_release_space(inode, data_reserved, page_start,
 				     reserved_space, (ret != 0));
 out_noreserve:
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0eb333c62fe46..7592beb53fc4e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1359,8 +1359,7 @@ again:
 		unlock_page(pages[i]);
 		put_page(pages[i]);
 	}
-	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
-				       false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return i_done;
 out:
@@ -1371,8 +1370,7 @@ out:
 	btrfs_delalloc_release_space(inode, data_reserved,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, true);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
-				       true);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return ret;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index bccd9dede2af4..b4958f724ce5f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3188,7 +3188,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							PAGE_SIZE, true);
 				btrfs_delalloc_release_extents(BTRFS_I(inode),
-							PAGE_SIZE, true);
+							PAGE_SIZE);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3209,7 +3209,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							PAGE_SIZE, true);
 				btrfs_delalloc_release_extents(BTRFS_I(inode),
-							       PAGE_SIZE, true);
+							       PAGE_SIZE);
 				ret = -EIO;
 				goto out;
 			}
@@ -3238,7 +3238,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							 PAGE_SIZE, true);
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-			                               PAGE_SIZE, true);
+			                               PAGE_SIZE);
 
 			clear_extent_bits(&BTRFS_I(inode)->io_tree,
 					  page_start, page_end,
@@ -3254,8 +3254,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		put_page(page);
 
 		index++;
-		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE,
-					       false);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 		balance_dirty_pages_ratelimited(inode->i_mapping);
 		btrfs_throttle(fs_info);
 	}
-- 
2.20.1



