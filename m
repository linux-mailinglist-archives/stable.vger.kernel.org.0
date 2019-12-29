Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D854F12C9A1
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbfL2SLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:11:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbfL2Rmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C635207FD;
        Sun, 29 Dec 2019 17:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641355;
        bh=RCZOy1dI34S/ewUENORPb/cQYmpSqlt/TmIg5B/QrVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yk2+gmywzM3j0XQTtZa/n+24wqqfcGwnbqKc5316HzkMLIQRzkHfWcaMwTVOnY4kQ
         57CPNRT/Uhn5wGys54yinnquPpsqQF2RXn3BXry9RMeJTFX2mJ0wm9THKbJPCOdhX3
         2IQ7r99GivKo1UfK0hemCYwWsw1/r8G56epd84fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 032/434] Btrfs: fix missing data checksums after replaying a log tree
Date:   Sun, 29 Dec 2019 18:21:25 +0100
Message-Id: <20191229172704.170450694@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 40e046acbd2f369cfbf93c3413639c66514cec2d upstream.

When logging a file that has shared extents (reflinked with other files or
with itself), we can end up logging multiple checksum items that cover
overlapping ranges. This confuses the search for checksums at log replay
time causing some checksums to never be added to the fs/subvolume tree.

Consider the following example of a file that shares the same extent at
offsets 0 and 256Kb:

   [ bytenr 13893632, offset 64Kb, len 64Kb  ]
   0                                         64Kb

   [ bytenr 13631488, offset 64Kb, len 192Kb ]
   64Kb                                      256Kb

   [ bytenr 13893632, offset 0, len 256Kb    ]
   256Kb                                     512Kb

When logging the inode, at tree-log.c:copy_items(), when processing the
file extent item at offset 0, we log a checksum item covering the range
13959168 to 14024704, which corresponds to 13893632 + 64Kb and 13893632 +
64Kb + 64Kb, respectively.

Later when processing the extent item at offset 256K, we log the checksums
for the range from 13893632 to 14155776 (which corresponds to 13893632 +
256Kb). These checksums get merged with the checksum item for the range
from 13631488 to 13893632 (13631488 + 256Kb), logged by a previous fsync.
So after this we get the two following checksum items in the log tree:

   (...)
   item 6 key (EXTENT_CSUM EXTENT_CSUM 13631488) itemoff 3095 itemsize 512
           range start 13631488 end 14155776 length 524288
   item 7 key (EXTENT_CSUM EXTENT_CSUM 13959168) itemoff 3031 itemsize 64
           range start 13959168 end 14024704 length 65536

The first one covers the range from the second one, they overlap.

So far this does not cause a problem after replaying the log, because
when replaying the file extent item for offset 256K, we copy all the
checksums for the extent 13893632 from the log tree to the fs/subvolume
tree, since searching for an checksum item for bytenr 13893632 leaves us
at the first checksum item, which covers the whole range of the extent.

However if we write 64Kb to file offset 256Kb for example, we will
not be able to find and copy the checksums for the last 128Kb of the
extent at bytenr 13893632, referenced by the file range 384Kb to 512Kb.

After writing 64Kb into file offset 256Kb we get the following extent
layout for our file:

   [ bytenr 13893632, offset 64K, len 64Kb   ]
   0                                         64Kb

   [ bytenr 13631488, offset 64Kb, len 192Kb ]
   64Kb                                      256Kb

   [ bytenr 14155776, offset 0, len 64Kb     ]
   256Kb                                     320Kb

   [ bytenr 13893632, offset 64Kb, len 192Kb ]
   320Kb                                     512Kb

After fsync'ing the file, if we have a power failure and then mount
the filesystem to replay the log, the following happens:

1) When replaying the file extent item for file offset 320Kb, we
   lookup for the checksums for the extent range from 13959168
   (13893632 + 64Kb) to 14155776 (13893632 + 256Kb), through a call
   to btrfs_lookup_csums_range();

2) btrfs_lookup_csums_range() finds the checksum item that starts
   precisely at offset 13959168 (item 7 in the log tree, shown before);

3) However that checksum item only covers 64Kb of data, and not 192Kb
   of data;

4) As a result only the checksums for the first 64Kb of data referenced
   by the file extent item are found and copied to the fs/subvolume tree.
   The remaining 128Kb of data, file range 384Kb to 512Kb, doesn't get
   the corresponding data checksums found and copied to the fs/subvolume
   tree.

5) After replaying the log userspace will not be able to read the file
   range from 384Kb to 512Kb, because the checksums are missing and
   resulting in an -EIO error.

The following steps reproduce this scenario:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ xfs_io -f -c "pwrite -S 0xa3 0 256K" /mnt/sdc/foobar
  $ xfs_io -c "fsync" /mnt/sdc/foobar
  $ xfs_io -c "pwrite -S 0xc7 256K 256K" /mnt/sdc/foobar

  $ xfs_io -c "reflink /mnt/sdc/foobar 320K 0 64K" /mnt/sdc/foobar
  $ xfs_io -c "fsync" /mnt/sdc/foobar

  $ xfs_io -c "pwrite -S 0xe5 256K 64K" /mnt/sdc/foobar
  $ xfs_io -c "fsync" /mnt/sdc/foobar

  <power failure>

  $ mount /dev/sdc /mnt/sdc
  $ md5sum /mnt/sdc/foobar
  md5sum: /mnt/sdc/foobar: Input/output error

  $ dmesg | tail
  [165305.003464] BTRFS info (device sdc): no csum found for inode 257 start 401408
  [165305.004014] BTRFS info (device sdc): no csum found for inode 257 start 405504
  [165305.004559] BTRFS info (device sdc): no csum found for inode 257 start 409600
  [165305.005101] BTRFS info (device sdc): no csum found for inode 257 start 413696
  [165305.005627] BTRFS info (device sdc): no csum found for inode 257 start 417792
  [165305.006134] BTRFS info (device sdc): no csum found for inode 257 start 421888
  [165305.006625] BTRFS info (device sdc): no csum found for inode 257 start 425984
  [165305.007278] BTRFS info (device sdc): no csum found for inode 257 start 430080
  [165305.008248] BTRFS warning (device sdc): csum failed root 5 ino 257 off 393216 csum 0x1337385e expected csum 0x00000000 mirror 1
  [165305.009550] BTRFS warning (device sdc): csum failed root 5 ino 257 off 393216 csum 0x1337385e expected csum 0x00000000 mirror 1

Fix this simply by deleting first any checksums, from the log tree, for the
range of the extent we are logging at copy_items(). This ensures we do not
get checksum items in the log tree that have overlapping ranges.

This is a long time issue that has been present since we have the clone
(and deduplication) ioctl, and can happen both when an extent is shared
between different files and within the same file.

A test case for fstests follows soon.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/extent-tree.c |    7 ++++---
 fs/btrfs/file-item.c   |    7 +++++--
 fs/btrfs/tree-log.c    |   29 ++++++++++++++++++++++++++---
 4 files changed, 36 insertions(+), 9 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2785,7 +2785,7 @@ struct btrfs_inode_extref *btrfs_find_na
 /* file-item.c */
 struct btrfs_dio_private;
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len);
+		    struct btrfs_root *root, u64 bytenr, u64 len);
 blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 				   u8 *dst);
 blk_status_t btrfs_lookup_bio_sums_dio(struct inode *inode, struct bio *bio,
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1848,8 +1848,8 @@ static int cleanup_ref_head(struct btrfs
 		btrfs_pin_extent(fs_info, head->bytenr,
 				 head->num_bytes, 1);
 		if (head->is_data) {
-			ret = btrfs_del_csums(trans, fs_info, head->bytenr,
-					      head->num_bytes);
+			ret = btrfs_del_csums(trans, fs_info->csum_root,
+					      head->bytenr, head->num_bytes);
 		}
 	}
 
@@ -3155,7 +3155,8 @@ static int __btrfs_free_extent(struct bt
 		btrfs_release_path(path);
 
 		if (is_data) {
-			ret = btrfs_del_csums(trans, info, bytenr, num_bytes);
+			ret = btrfs_del_csums(trans, info->csum_root, bytenr,
+					      num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				goto out;
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -590,9 +590,9 @@ static noinline void truncate_one_csum(s
  * range of bytes.
  */
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len)
+		    struct btrfs_root *root, u64 bytenr, u64 len)
 {
-	struct btrfs_root *root = fs_info->csum_root;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	u64 end_byte = bytenr + len;
@@ -602,6 +602,9 @@ int btrfs_del_csums(struct btrfs_trans_h
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	int blocksize_bits = fs_info->sb->s_blocksize_bits;
 
+	ASSERT(root == fs_info->csum_root ||
+	       root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -808,7 +808,8 @@ static noinline int replay_one_extent(st
 						struct btrfs_ordered_sum,
 						list);
 				if (!ret)
-					ret = btrfs_del_csums(trans, fs_info,
+					ret = btrfs_del_csums(trans,
+							      fs_info->csum_root,
 							      sums->bytenr,
 							      sums->len);
 				if (!ret)
@@ -3927,6 +3928,28 @@ static int log_inode_item(struct btrfs_t
 	return 0;
 }
 
+static int log_csums(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *log_root,
+		     struct btrfs_ordered_sum *sums)
+{
+	int ret;
+
+	/*
+	 * Due to extent cloning, we might have logged a csum item that covers a
+	 * subrange of a cloned extent, and later we can end up logging a csum
+	 * item for a larger subrange of the same extent or the entire range.
+	 * This would leave csum items in the log tree that cover the same range
+	 * and break the searches for checksums in the log tree, resulting in
+	 * some checksums missing in the fs/subvolume tree. So just delete (or
+	 * trim and adjust) any existing csum items in the log for this range.
+	 */
+	ret = btrfs_del_csums(trans, log_root, sums->bytenr, sums->len);
+	if (ret)
+		return ret;
+
+	return btrfs_csum_file_blocks(trans, log_root, sums);
+}
+
 static noinline int copy_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_inode *inode,
 			       struct btrfs_path *dst_path,
@@ -4072,7 +4095,7 @@ static noinline int copy_items(struct bt
 						   struct btrfs_ordered_sum,
 						   list);
 		if (!ret)
-			ret = btrfs_csum_file_blocks(trans, log, sums);
+			ret = log_csums(trans, log, sums);
 		list_del(&sums->list);
 		kfree(sums);
 	}
@@ -4292,7 +4315,7 @@ static int log_extent_csums(struct btrfs
 						   struct btrfs_ordered_sum,
 						   list);
 		if (!ret)
-			ret = btrfs_csum_file_blocks(trans, log_root, sums);
+			ret = log_csums(trans, log_root, sums);
 		list_del(&sums->list);
 		kfree(sums);
 	}


