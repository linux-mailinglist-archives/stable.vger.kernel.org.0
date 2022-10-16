Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8031B5FFF26
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 14:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJPM2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 08:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJPM2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 08:28:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560083D5A4
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 05:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D66C960A4B
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 12:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BD4C433C1;
        Sun, 16 Oct 2022 12:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665923325;
        bh=BPb1GeI+zCci1ZLZKd45+KXaEsQh9bDPkdPd+t+GGeQ=;
        h=Subject:To:Cc:From:Date:From;
        b=thc1EFz84sTPxoKDDqeFNeC/qZaP8OS/lu/JO97Laww5QCkwlgaeToVFNX6VrbMGB
         0ipeaWSpS3YZiUfZxKohm9gFgwrVyX9Uevx1zY44gaAhKSR8PkmseIPH0otFVEdTN3
         pi09mHqWB9m2AhgGTxzRhbQbdK8HVX1fDf3w7vv0=
Subject: FAILED: patch "[PATCH] btrfs: fix missed extent on fsync after dropping extent maps" failed to apply to 5.15-stable tree
To:     fdmanana@suse.com, anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 14:29:31 +0200
Message-ID: <1665923371147149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

cef7820d6abf ("btrfs: fix missed extent on fsync after dropping extent maps")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cef7820d6abf8d61f8e1db411eae3c712f6d72a2 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 19 Sep 2022 15:06:28 +0100
Subject: [PATCH] btrfs: fix missed extent on fsync after dropping extent maps

When dropping extent maps for a range, through btrfs_drop_extent_cache(),
if we find an extent map that starts before our target range and/or ends
before the target range, and we are not able to allocate extent maps for
splitting that extent map, then we don't fail and simply remove the entire
extent map from the inode's extent map tree.

This is generally fine, because in case anyone needs to access the extent
map, it can just load it again later from the respective file extent
item(s) in the subvolume btree. However, if that extent map is new and is
in the list of modified extents, then a fast fsync will miss the parts of
the extent that were outside our range (that needed to be split),
therefore not logging them. Fix that by marking the inode for a full
fsync. This issue was introduced after removing BUG_ON()s triggered when
the split extent map allocations failed, done by commit 7014cdb49305ed
("Btrfs: btrfs_drop_extent_cache should never fail"), back in 2012, and
the fast fsync path already existed but was very recent.

Also, in the case where we could allocate extent maps for the split
operations but then fail to add a split extent map to the tree, mark the
inode for a full fsync as well. This is not supposed to ever fail, and we
assert that, but in case assertions are disabled (CONFIG_BTRFS_ASSERT is
not set), it's the correct thing to do to make sure a fast fsync will not
miss a new extent.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index df958fdb140c..8786b2b8f0a1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -523,6 +523,7 @@ void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
 		testend = 0;
 	}
 	while (1) {
+		bool ends_after_range = false;
 		int no_splits = 0;
 
 		modified = false;
@@ -539,10 +540,12 @@ void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
 			write_unlock(&em_tree->lock);
 			break;
 		}
+		if (testend && em->start + em->len > start + len)
+			ends_after_range = true;
 		flags = em->flags;
 		gen = em->generation;
 		if (skip_pinned && test_bit(EXTENT_FLAG_PINNED, &em->flags)) {
-			if (testend && em->start + em->len >= start + len) {
+			if (ends_after_range) {
 				free_extent_map(em);
 				write_unlock(&em_tree->lock);
 				break;
@@ -592,7 +595,7 @@ void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
 			split = split2;
 			split2 = NULL;
 		}
-		if (testend && em->start + em->len > start + len) {
+		if (ends_after_range) {
 			u64 diff = start + len - em->start;
 
 			split->start = start + len;
@@ -630,14 +633,42 @@ void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
 			} else {
 				ret = add_extent_mapping(em_tree, split,
 							 modified);
-				ASSERT(ret == 0); /* Logic error */
+				/* Logic error, shouldn't happen. */
+				ASSERT(ret == 0);
+				if (WARN_ON(ret != 0) && modified)
+					btrfs_set_inode_full_sync(inode);
 			}
 			free_extent_map(split);
 			split = NULL;
 		}
 next:
-		if (extent_map_in_tree(em))
+		if (extent_map_in_tree(em)) {
+			/*
+			 * If the extent map is still in the tree it means that
+			 * either of the following is true:
+			 *
+			 * 1) It fits entirely in our range (doesn't end beyond
+			 *    it or starts before it);
+			 *
+			 * 2) It starts before our range and/or ends after our
+			 *    range, and we were not able to allocate the extent
+			 *    maps for split operations, @split and @split2.
+			 *
+			 * If we are at case 2) then we just remove the entire
+			 * extent map - this is fine since if anyone needs it to
+			 * access the subranges outside our range, will just
+			 * load it again from the subvolume tree's file extent
+			 * item. However if the extent map was in the list of
+			 * modified extents, then we must mark the inode for a
+			 * full fsync, otherwise a fast fsync will miss this
+			 * extent if it's new and needs to be logged.
+			 */
+			if ((em->start < start || ends_after_range) && modified) {
+				ASSERT(no_splits);
+				btrfs_set_inode_full_sync(inode);
+			}
 			remove_extent_mapping(em_tree, em);
+		}
 		write_unlock(&em_tree->lock);
 
 		/* once for us */
@@ -2260,14 +2291,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	atomic_inc(&root->log_batch);
 
-	/*
-	 * Always check for the full sync flag while holding the inode's lock,
-	 * to avoid races with other tasks. The flag must be either set all the
-	 * time during logging or always off all the time while logging.
-	 */
-	full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-			     &BTRFS_I(inode)->runtime_flags);
-
 	/*
 	 * Before we acquired the inode's lock and the mmap lock, someone may
 	 * have dirtied more pages in the target range. We need to make sure
@@ -2292,6 +2315,17 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
+	/*
+	 * Always check for the full sync flag while holding the inode's lock,
+	 * to avoid races with other tasks. The flag must be either set all the
+	 * time during logging or always off all the time while logging.
+	 * We check the flag here after starting delalloc above, because when
+	 * running delalloc the full sync flag may be set if we need to drop
+	 * extra extent map ranges due to temporary memory allocation failures.
+	 */
+	full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+			     &BTRFS_I(inode)->runtime_flags);
+
 	/*
 	 * We have to do this here to avoid the priority inversion of waiting on
 	 * IO of a lower priority task while holding a transaction open.

