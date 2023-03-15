Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C5F6BB1D7
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjCOMbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjCOMat (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5FBDBC3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D20761D58
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1A0C433D2;
        Wed, 15 Mar 2023 12:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883389;
        bh=dAr4CsWQ3PFiWECTqIDKxRG93ARMMEFxO82YsLvsQ7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpIRMNixD3txzXNHH/+S8NtELXYzwxOhG8TAPPpE6qyVHER+kgKjhICSSxkKdv05j
         ++7ndenHee3qfRUPdG1KuZ3WMbWpfZtObl9b/k2ps8xCBRAS7XNHNwX3BItvpAJmam
         v6PP0H6LA8zv/+0yQA2IsJeqxN8IRqAvnHh7yyS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.15 125/145] ext4: refactor ext4_free_blocks() to pull out ext4_mb_clear_bb()
Date:   Wed, 15 Mar 2023 13:13:11 +0100
Message-Id: <20230315115743.088288597@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 8ac3939db99f99667b8eb670cf4baf292896e72d upstream.

ext4_free_blocks() function became too long and confusing, this patch
just pulls out the ext4_mb_clear_bb() function logic from it
which clears the block bitmap and frees it.

No functionality change in this patch

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/22c30fbb26ba409cf8aa5f0c7912970272c459e8.1644992610.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |  180 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 102 insertions(+), 78 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5888,7 +5888,8 @@ static void ext4_free_blocks_simple(stru
 }
 
 /**
- * ext4_free_blocks() -- Free given blocks and update quota
+ * ext4_mb_clear_bb() -- helper function for freeing blocks.
+ *			Used by ext4_free_blocks()
  * @handle:		handle for this transaction
  * @inode:		inode
  * @bh:			optional buffer of the block to be freed
@@ -5896,9 +5897,9 @@ static void ext4_free_blocks_simple(stru
  * @count:		number of blocks to be freed
  * @flags:		flags used by ext4_free_blocks
  */
-void ext4_free_blocks(handle_t *handle, struct inode *inode,
-		      struct buffer_head *bh, ext4_fsblk_t block,
-		      unsigned long count, int flags)
+static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
+			       ext4_fsblk_t block, unsigned long count,
+			       int flags)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
@@ -5915,80 +5916,6 @@ void ext4_free_blocks(handle_t *handle,
 
 	sbi = EXT4_SB(sb);
 
-	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
-		ext4_free_blocks_simple(inode, block, count);
-		return;
-	}
-
-	might_sleep();
-	if (bh) {
-		if (block)
-			BUG_ON(block != bh->b_blocknr);
-		else
-			block = bh->b_blocknr;
-	}
-
-	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
-	    !ext4_inode_block_valid(inode, block, count)) {
-		ext4_error(sb, "Freeing blocks not in datazone - "
-			   "block = %llu, count = %lu", block, count);
-		goto error_return;
-	}
-
-	ext4_debug("freeing block %llu\n", block);
-	trace_ext4_free_blocks(inode, block, count, flags);
-
-	if (bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
-		BUG_ON(count > 1);
-
-		ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
-			    inode, bh, block);
-	}
-
-	/*
-	 * If the extent to be freed does not begin on a cluster
-	 * boundary, we need to deal with partial clusters at the
-	 * beginning and end of the extent.  Normally we will free
-	 * blocks at the beginning or the end unless we are explicitly
-	 * requested to avoid doing so.
-	 */
-	overflow = EXT4_PBLK_COFF(sbi, block);
-	if (overflow) {
-		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
-			overflow = sbi->s_cluster_ratio - overflow;
-			block += overflow;
-			if (count > overflow)
-				count -= overflow;
-			else
-				return;
-		} else {
-			block -= overflow;
-			count += overflow;
-		}
-	}
-	overflow = EXT4_LBLK_COFF(sbi, count);
-	if (overflow) {
-		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
-			if (count > overflow)
-				count -= overflow;
-			else
-				return;
-		} else
-			count += sbi->s_cluster_ratio - overflow;
-	}
-
-	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
-		int i;
-		int is_metadata = flags & EXT4_FREE_BLOCKS_METADATA;
-
-		for (i = 0; i < count; i++) {
-			cond_resched();
-			if (is_metadata)
-				bh = sb_find_get_block(inode->i_sb, block + i);
-			ext4_forget(handle, is_metadata, inode, bh, block + i);
-		}
-	}
-
 do_more:
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
@@ -6156,6 +6083,103 @@ error_return:
 	return;
 }
 
+/**
+ * ext4_free_blocks() -- Free given blocks and update quota
+ * @handle:		handle for this transaction
+ * @inode:		inode
+ * @bh:			optional buffer of the block to be freed
+ * @block:		starting physical block to be freed
+ * @count:		number of blocks to be freed
+ * @flags:		flags used by ext4_free_blocks
+ */
+void ext4_free_blocks(handle_t *handle, struct inode *inode,
+		      struct buffer_head *bh, ext4_fsblk_t block,
+		      unsigned long count, int flags)
+{
+	struct super_block *sb = inode->i_sb;
+	unsigned int overflow;
+	struct ext4_sb_info *sbi;
+
+	sbi = EXT4_SB(sb);
+
+	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
+		ext4_free_blocks_simple(inode, block, count);
+		return;
+	}
+
+	might_sleep();
+	if (bh) {
+		if (block)
+			BUG_ON(block != bh->b_blocknr);
+		else
+			block = bh->b_blocknr;
+	}
+
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
+		ext4_error(sb, "Freeing blocks not in datazone - "
+			   "block = %llu, count = %lu", block, count);
+		return;
+	}
+
+	ext4_debug("freeing block %llu\n", block);
+	trace_ext4_free_blocks(inode, block, count, flags);
+
+	if (bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
+		BUG_ON(count > 1);
+
+		ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
+			    inode, bh, block);
+	}
+
+	/*
+	 * If the extent to be freed does not begin on a cluster
+	 * boundary, we need to deal with partial clusters at the
+	 * beginning and end of the extent.  Normally we will free
+	 * blocks at the beginning or the end unless we are explicitly
+	 * requested to avoid doing so.
+	 */
+	overflow = EXT4_PBLK_COFF(sbi, block);
+	if (overflow) {
+		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
+			overflow = sbi->s_cluster_ratio - overflow;
+			block += overflow;
+			if (count > overflow)
+				count -= overflow;
+			else
+				return;
+		} else {
+			block -= overflow;
+			count += overflow;
+		}
+	}
+	overflow = EXT4_LBLK_COFF(sbi, count);
+	if (overflow) {
+		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
+			if (count > overflow)
+				count -= overflow;
+			else
+				return;
+		} else
+			count += sbi->s_cluster_ratio - overflow;
+	}
+
+	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
+		int i;
+		int is_metadata = flags & EXT4_FREE_BLOCKS_METADATA;
+
+		for (i = 0; i < count; i++) {
+			cond_resched();
+			if (is_metadata)
+				bh = sb_find_get_block(inode->i_sb, block + i);
+			ext4_forget(handle, is_metadata, inode, bh, block + i);
+		}
+	}
+
+	ext4_mb_clear_bb(handle, inode, block, count, flags);
+	return;
+}
+
 /**
  * ext4_group_add_blocks() -- Add given blocks to an existing group
  * @handle:			handle to this transaction


