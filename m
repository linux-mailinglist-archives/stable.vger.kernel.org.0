Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD0F4C770E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiB1SL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241615AbiB1SKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:10:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D587B91FF;
        Mon, 28 Feb 2022 09:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9501760B2B;
        Mon, 28 Feb 2022 17:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB926C340F4;
        Mon, 28 Feb 2022 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070582;
        bh=Ctl1DITbHVbdBfKS48ElGs5/qHcBKH9J+pZSVWqw5OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyFHGui1ZSjJ+Ae/i1ikpXo3VJI2ajqFUOtOp6WyD814i4jfBJ+CgB8dSWRSWaTS2
         foSwJDTE+z2qIPALCAYr4cgdZMc5ofWQ0hcby0QE7zHBtVYb9GIa4fjJf90m3RdBcV
         c/CXLFOqVC1wI+XsiTtcZ+dRKS2Of66zhdt/mx4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 144/164] btrfs: reduce extent threshold for autodefrag
Date:   Mon, 28 Feb 2022 18:25:06 +0100
Message-Id: <20220228172412.951650926@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 558732df2122092259ab4ef85594bee11dbb9104 upstream.

There is a big gap between inode_should_defrag() and autodefrag extent
size threshold.  For inode_should_defrag() it has a flexible
@small_write value. For compressed extent is 16K, and for non-compressed
extent it's 64K.

However for autodefrag extent size threshold, it's always fixed to the
default value (256K).

This means, the following write sequence will trigger autodefrag to
defrag ranges which didn't trigger autodefrag:

  pwrite 0 8k
  sync
  pwrite 8k 128K
  sync

The latter 128K write will also be considered as a defrag target (if
other conditions are met). While only that 8K write is really
triggering autodefrag.

Such behavior can cause extra IO for autodefrag.

Close the gap, by copying the @small_write value into inode_defrag, so
that later autodefrag can use the same @small_write value which
triggered autodefrag.

With the existing transid value, this allows autodefrag really to scan
the ranges which triggered autodefrag.

Although this behavior change is mostly reducing the extent_thresh value
for autodefrag, I believe in the future we should allow users to specify
the autodefrag extent threshold through mount options, but that's an
other problem to consider in the future.

CC: stable@vger.kernel.org # 5.16+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/file.c  |   15 ++++++++++++++-
 fs/btrfs/inode.c |    4 ++--
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3315,7 +3315,7 @@ void btrfs_exclop_finish(struct btrfs_fs
 int __init btrfs_auto_defrag_init(void);
 void __cold btrfs_auto_defrag_exit(void);
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
-			   struct btrfs_inode *inode);
+			   struct btrfs_inode *inode, u32 extent_thresh);
 int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -49,6 +49,15 @@ struct inode_defrag {
 
 	/* root objectid */
 	u64 root;
+
+	/*
+	 * The extent size threshold for autodefrag.
+	 *
+	 * This value is different for compressed/non-compressed extents,
+	 * thus needs to be passed from higher layer.
+	 * (aka, inode_should_defrag())
+	 */
+	u32 extent_thresh;
 };
 
 static int __compare_inode_defrag(struct inode_defrag *defrag1,
@@ -101,6 +110,8 @@ static int __btrfs_add_inode_defrag(stru
 			 */
 			if (defrag->transid < entry->transid)
 				entry->transid = defrag->transid;
+			entry->extent_thresh = min(defrag->extent_thresh,
+						   entry->extent_thresh);
 			return -EEXIST;
 		}
 	}
@@ -126,7 +137,7 @@ static inline int __need_auto_defrag(str
  * enabled
  */
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
-			   struct btrfs_inode *inode)
+			   struct btrfs_inode *inode, u32 extent_thresh)
 {
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -152,6 +163,7 @@ int btrfs_add_inode_defrag(struct btrfs_
 	defrag->ino = btrfs_ino(inode);
 	defrag->transid = transid;
 	defrag->root = root->root_key.objectid;
+	defrag->extent_thresh = extent_thresh;
 
 	spin_lock(&fs_info->defrag_inodes_lock);
 	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags)) {
@@ -275,6 +287,7 @@ again:
 	memset(&range, 0, sizeof(range));
 	range.len = (u64)-1;
 	range.start = cur;
+	range.extent_thresh = defrag->extent_thresh;
 
 	sb_start_write(fs_info->sb);
 	ret = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -561,12 +561,12 @@ static inline int inode_need_compress(st
 }
 
 static inline void inode_should_defrag(struct btrfs_inode *inode,
-		u64 start, u64 end, u64 num_bytes, u64 small_write)
+		u64 start, u64 end, u64 num_bytes, u32 small_write)
 {
 	/* If this is a small write inside eof, kick off a defrag */
 	if (num_bytes < small_write &&
 	    (start > 0 || end + 1 < inode->disk_i_size))
-		btrfs_add_inode_defrag(NULL, inode);
+		btrfs_add_inode_defrag(NULL, inode, small_write);
 }
 
 /*


