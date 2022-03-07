Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD0D4CF8FB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbiCGKDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240415AbiCGKBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162C811145;
        Mon,  7 Mar 2022 01:48:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8851B810A8;
        Mon,  7 Mar 2022 09:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC72C340E9;
        Mon,  7 Mar 2022 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646477;
        bh=aKWI7FxW7YgojpTi0wCa3Cp03GMcrydlkLjqorr25Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mx1xcNEg85Q/z+uinj4kTjVdtjEggbvYqGzit/kryVlmmZdxAQ8b35OshCROLafY/
         +3JD6vs5CdD0Wfl78TqmrPfqgE5N64vUW/XzinuqeEu6LoyGm0Vveqx+TmjawISPke
         qA5pSiILowz0W2AZLif+sc6vX8N3B7+/3cyYCpvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 254/262] btrfs: fix lost prealloc extents beyond eof after full fsync
Date:   Mon,  7 Mar 2022 10:19:58 +0100
Message-Id: <20220307091710.840326288@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Filipe Manana <fdmanana@suse.com>

commit d99478874355d3a7b9d86dfb5d7590d5b1754b1f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4423,7 +4423,7 @@ static int log_one_extent(struct btrfs_t
 
 /*
  * Log all prealloc extents beyond the inode's i_size to make sure we do not
- * lose them after doing a fast fsync and replaying the log. We scan the
+ * lose them after doing a full/fast fsync and replaying the log. We scan the
  * subvolume's root instead of iterating the inode's extent map tree because
  * otherwise we can log incorrect extent items based on extent map conversion.
  * That can happen due to the fact that extent maps are merged when they
@@ -5208,6 +5208,7 @@ static int copy_inode_items_to_log(struc
 				   struct btrfs_log_ctx *ctx,
 				   bool *need_log_inode_item)
 {
+	const u64 i_size = i_size_read(&inode->vfs_inode);
 	struct btrfs_root *root = inode->root;
 	int ins_start_slot = 0;
 	int ins_nr = 0;
@@ -5228,13 +5229,21 @@ again:
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
 
@@ -5265,10 +5274,8 @@ again:
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
@@ -5321,9 +5328,21 @@ next_key:
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


