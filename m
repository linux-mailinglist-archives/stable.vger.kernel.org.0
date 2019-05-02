Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD26E11ECE
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfEBPkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbfEBP3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:29:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A4820C01;
        Thu,  2 May 2019 15:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810942;
        bh=shnJjxOVEBN89QkMxvpbS0GFmvGCqpz53oQ8+rPWbIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvNJJcTWCj/X0VqKwN/e8vCpDL2UFt+e2j8GVYZgC1L9Cfe317dH0/97ivtTVAJGP
         dDCgLcQB9r6HReATd9+l2IbBoHN6j1mvRlEfpACrWjJzqw2yx2trpyxvHTRINPFMd2
         O+gNZHOn6Qqry0RJtcK8LqNKjdA2bdx4J0+z955M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 016/101] Btrfs: fix file corruption after snapshotting due to mix of buffered/DIO writes
Date:   Thu,  2 May 2019 17:20:18 +0200
Message-Id: <20190502143341.147009688@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 609e804d771f59dc5d45a93e5ee0053c74bbe2bf ]

When we are mixing buffered writes with direct IO writes against the same
file and snapshotting is happening concurrently, we can end up with a
corrupt file content in the snapshot. Example:

1) Inode/file is empty.

2) Snapshotting starts.

2) Buffered write at offset 0 length 256Kb. This updates the i_size of the
   inode to 256Kb, disk_i_size remains zero. This happens after the task
   doing the snapshot flushes all existing delalloc.

3) DIO write at offset 256Kb length 768Kb. Once the ordered extent
   completes it sets the inode's disk_i_size to 1Mb (256Kb + 768Kb) and
   updates the inode item in the fs tree with a size of 1Mb (which is
   the value of disk_i_size).

4) The dealloc for the range [0, 256Kb[ did not start yet.

5) The transaction used in the DIO ordered extent completion, which updated
   the inode item, is committed by the snapshotting task.

6) Snapshot creation completes.

7) Dealloc for the range [0, 256Kb[ is flushed.

After that when reading the file from the snapshot we always get zeroes for
the range [0, 256Kb[, the file has a size of 1Mb and the data written by
the direct IO write is found. From an application's point of view this is
a corruption, since in the source subvolume it could never read a version
of the file that included the data from the direct IO write without the
data from the buffered write included as well. In the snapshot's tree,
file extent items are missing for the range [0, 256Kb[.

The issue, obviously, does not happen when using the -o flushoncommit
mount option.

Fix this by flushing delalloc for all the roots that are about to be
snapshotted when committing a transaction. This guarantees total ordering
when updating the disk_i_size of an inode since the flush for dealloc is
done when a transaction is in the TRANS_STATE_COMMIT_START state and wait
is done once no more external writers exist. This is similar to what we
do when using the flushoncommit mount option, but we do it only if the
transaction has snapshots to create and only for the roots of the
subvolumes to be snapshotted. The bulk of the dealloc is flushed in the
snapshot creation ioctl, so the flush work we do inside the transaction
is minimized.

This issue, involving buffered and direct IO writes with snapshotting, is
often triggered by fstest btrfs/078, and got reported by fsck when not
using the NO_HOLES features, for example:

  $ cat results/btrfs/078.full
  (...)
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
  *** fsck.btrfs output ***
  [1/7] checking root items
  [2/7] checking extents
  [3/7] checking free space cache
  [4/7] checking fs roots
  root 258 inode 264 errors 100, file extent discount
  Found file extent holes:
        start: 524288, len: 65536
  ERROR: errors found in fs roots

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 49 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4ec2b660d014..7f3ece91a4d0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1886,8 +1886,10 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
        }
 }
 
-static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
+static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+
 	/*
 	 * We use writeback_inodes_sb here because if we used
 	 * btrfs_start_delalloc_roots we would deadlock with fs freeze.
@@ -1897,15 +1899,50 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 	 * from already being in a transaction and our join_transaction doesn't
 	 * have to re-take the fs freeze lock.
 	 */
-	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
+	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
 		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
+	} else {
+		struct btrfs_pending_snapshot *pending;
+		struct list_head *head = &trans->transaction->pending_snapshots;
+
+		/*
+		 * Flush dellaloc for any root that is going to be snapshotted.
+		 * This is done to avoid a corrupted version of files, in the
+		 * snapshots, that had both buffered and direct IO writes (even
+		 * if they were done sequentially) due to an unordered update of
+		 * the inode's size on disk.
+		 */
+		list_for_each_entry(pending, head, list) {
+			int ret;
+
+			ret = btrfs_start_delalloc_snapshot(pending->root);
+			if (ret)
+				return ret;
+		}
+	}
 	return 0;
 }
 
-static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
+static inline void btrfs_wait_delalloc_flush(struct btrfs_trans_handle *trans)
 {
-	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+
+	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
 		btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
+	} else {
+		struct btrfs_pending_snapshot *pending;
+		struct list_head *head = &trans->transaction->pending_snapshots;
+
+		/*
+		 * Wait for any dellaloc that we started previously for the roots
+		 * that are going to be snapshotted. This is to avoid a corrupted
+		 * version of files in the snapshots that had both buffered and
+		 * direct IO writes (even if they were done sequentially).
+		 */
+		list_for_each_entry(pending, head, list)
+			btrfs_wait_ordered_extents(pending->root,
+						   U64_MAX, 0, U64_MAX);
+	}
 }
 
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
@@ -2024,7 +2061,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	extwriter_counter_dec(cur_trans, trans->type);
 
-	ret = btrfs_start_delalloc_flush(fs_info);
+	ret = btrfs_start_delalloc_flush(trans);
 	if (ret)
 		goto cleanup_transaction;
 
@@ -2040,7 +2077,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (ret)
 		goto cleanup_transaction;
 
-	btrfs_wait_delalloc_flush(fs_info);
+	btrfs_wait_delalloc_flush(trans);
 
 	btrfs_scrub_pause(fs_info);
 	/*
-- 
2.19.1



