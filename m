Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74B84CF293
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 08:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiCGH3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 02:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiCGH3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 02:29:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0090220F5B
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 23:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9DD2B80B50
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B1C340F3;
        Mon,  7 Mar 2022 07:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646638094;
        bh=IzleLHstUbgTLZJY9U/rRE84CyqCx2KssBUkjauSlJ0=;
        h=Subject:To:Cc:From:Date:From;
        b=OYRWgx5K6sBmUF49qvJKlJ0vEtn5I91vY967Iu2WUrUPv3CvOT69lIak8GiCTuu+E
         hqgw8/nL5DRwIm3iceoCFORHaMzkPr3i9rje+VKtwG3aA2e3GjZmQrN3CHLFl/yGHy
         EEV1XcHBEuyvUx3xLo3DiDzrJsVvBD6XbnuZwqAA=
Subject: FAILED: patch "[PATCH] btrfs: fix lost prealloc extents beyond eof after full fsync" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Mar 2022 08:28:05 +0100
Message-ID: <1646638085217144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d99478874355d3a7b9d86dfb5d7590d5b1754b1f Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 17 Feb 2022 12:12:02 +0000
Subject: [PATCH] btrfs: fix lost prealloc extents beyond eof after full fsync

When doing a full fsync, if we have prealloc extents beyond (or at) eof,
and the leaves that contain them were not modified in the current
transaction, we end up not logging them. This results in losing those
extents when we replay the log after a power failure, since the inode is
truncated to the current value of the logged i_size.

Just like for the fast fsync path, we need to always log all prealloc
extents starting at or beyond i_size. The fast fsync case was fixed in
commit 471d557afed155 ("Btrfs: fix loss of prealloc extents past i_size
after fsync log replay") but it missed the full fsync path. The problem
exists since the very early days, when the log tree was added by
commit e02119d5a7b439 ("Btrfs: Add a write ahead tree log to optimize
synchronous operations").

Example reproducer:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt

  # Create our test file with many file extent items, so that they span
  # several leaves of metadata, even if the node/page size is 64K. Use
  # direct IO and not fsync/O_SYNC because it's both faster and it avoids
  # clearing the full sync flag from the inode - we want the fsync below
  # to trigger the slow full sync code path.
  $ xfs_io -f -d -c "pwrite -b 4K 0 16M" /mnt/foo

  # Now add two preallocated extents to our file without extending the
  # file's size. One right at i_size, and another further beyond, leaving
  # a gap between the two prealloc extents.
  $ xfs_io -c "falloc -k 16M 1M" /mnt/foo
  $ xfs_io -c "falloc -k 20M 1M" /mnt/foo

  # Make sure everything is durably persisted and the transaction is
  # committed. This makes all created extents to have a generation lower
  # than the generation of the transaction used by the next write and
  # fsync.
  sync

  # Now overwrite only the first extent, which will result in modifying
  # only the first leaf of metadata for our inode. Then fsync it. This
  # fsync will use the slow code path (inode full sync bit is set) because
  # it's the first fsync since the inode was created/loaded.
  $ xfs_io -c "pwrite 0 4K" -c "fsync" /mnt/foo

  # Extent list before power failure.
  $ xfs_io -c "fiemap -v" /mnt/foo
  /mnt/foo:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..7]:          2178048..2178055     8   0x0
     1: [8..16383]:      26632..43007     16376   0x0
     2: [16384..32767]:  2156544..2172927 16384   0x0
     3: [32768..34815]:  2172928..2174975  2048 0x800
     4: [34816..40959]:  hole              6144
     5: [40960..43007]:  2174976..2177023  2048 0x801

  <power fail>

  # Mount fs again, trigger log replay.
  $ mount /dev/sdc /mnt

  # Extent list after power failure and log replay.
  $ xfs_io -c "fiemap -v" /mnt/foo
  /mnt/foo:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..7]:          2178048..2178055     8   0x0
     1: [8..16383]:      26632..43007     16376   0x0
     2: [16384..32767]:  2156544..2172927 16384   0x1

  # The prealloc extents at file offsets 16M and 20M are missing.

So fix this by calling btrfs_log_prealloc_extents() when we are doing a
full fsync, so that we always log all prealloc extents beyond eof.

A test case for fstests will follow soon.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3ee014c06b82..42caf595c936 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4635,7 +4635,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
 /*
  * Log all prealloc extents beyond the inode's i_size to make sure we do not
- * lose them after doing a fast fsync and replaying the log. We scan the
+ * lose them after doing a full/fast fsync and replaying the log. We scan the
  * subvolume's root instead of iterating the inode's extent map tree because
  * otherwise we can log incorrect extent items based on extent map conversion.
  * That can happen due to the fact that extent maps are merged when they
@@ -5414,6 +5414,7 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				   struct btrfs_log_ctx *ctx,
 				   bool *need_log_inode_item)
 {
+	const u64 i_size = i_size_read(&inode->vfs_inode);
 	struct btrfs_root *root = inode->root;
 	int ins_start_slot = 0;
 	int ins_nr = 0;
@@ -5434,13 +5435,21 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 		if (min_key->type > max_key->type)
 			break;
 
-		if (min_key->type == BTRFS_INODE_ITEM_KEY)
+		if (min_key->type == BTRFS_INODE_ITEM_KEY) {
 			*need_log_inode_item = false;
-
-		if ((min_key->type == BTRFS_INODE_REF_KEY ||
-		     min_key->type == BTRFS_INODE_EXTREF_KEY) &&
-		    inode->generation == trans->transid &&
-		    !recursive_logging) {
+		} else if (min_key->type == BTRFS_EXTENT_DATA_KEY &&
+			   min_key->offset >= i_size) {
+			/*
+			 * Extents at and beyond eof are logged with
+			 * btrfs_log_prealloc_extents().
+			 * Only regular files have BTRFS_EXTENT_DATA_KEY keys,
+			 * and no keys greater than that, so bail out.
+			 */
+			break;
+		} else if ((min_key->type == BTRFS_INODE_REF_KEY ||
+			    min_key->type == BTRFS_INODE_EXTREF_KEY) &&
+			   inode->generation == trans->transid &&
+			   !recursive_logging) {
 			u64 other_ino = 0;
 			u64 other_parent = 0;
 
@@ -5471,10 +5480,8 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 				btrfs_release_path(path);
 				goto next_key;
 			}
-		}
-
-		/* Skip xattrs, we log them later with btrfs_log_all_xattrs() */
-		if (min_key->type == BTRFS_XATTR_ITEM_KEY) {
+		} else if (min_key->type == BTRFS_XATTR_ITEM_KEY) {
+			/* Skip xattrs, logged later with btrfs_log_all_xattrs() */
 			if (ins_nr == 0)
 				goto next_slot;
 			ret = copy_items(trans, inode, dst_path, path,
@@ -5527,9 +5534,21 @@ static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
 			break;
 		}
 	}
-	if (ins_nr)
+	if (ins_nr) {
 		ret = copy_items(trans, inode, dst_path, path, ins_start_slot,
 				 ins_nr, inode_only, logged_isize);
+		if (ret)
+			return ret;
+	}
+
+	if (inode_only == LOG_INODE_ALL && S_ISREG(inode->vfs_inode.i_mode)) {
+		/*
+		 * Release the path because otherwise we might attempt to double
+		 * lock the same leaf with btrfs_log_prealloc_extents() below.
+		 */
+		btrfs_release_path(path);
+		ret = btrfs_log_prealloc_extents(trans, inode, dst_path);
+	}
 
 	return ret;
 }

