Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235CE676E3C
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjAVPI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjAVPI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:08:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607F41C336
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC43560C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090F7C433D2;
        Sun, 22 Jan 2023 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400105;
        bh=p/hmQuqIP7l3X3Dj80VmQwGAzqoNHU0/xpbPV8PNXS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqfoNJ6ghpmEDVDRwn7XpDe8/IvC/FkMtSpkeLoZHHeYjFCJxfbfI3M1EShv6B/ic
         fxQpn4//U8HqjYGyHagdsdBTRjX3fOewi/xmCM3E+2hOhCP+FTquajshgLwfJvlRQ1
         s9Do8raqrcubds8VxjEc0xXkxDuqTkMzlb0AtkHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/37] Revert "ext4: fix reserved cluster accounting at delayed write time"
Date:   Sun, 22 Jan 2023 16:04:31 +0100
Message-Id: <20230122150220.967595229@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit d40e09f701cf7a44e595a558b067b2b4f67fbf87 which is
commit 0b02f4c0d6d9e2c611dfbdd4317193e9dca740e6 upstream.

Eric writes:
	I recommend not backporting this patch or the other three
	patches apparently intended to support it to 4.19 stable.  All
	these patches are related to ext4's bigalloc feature, which was
	experimental as of 4.19 (expressly noted by contemporary
	versions of e2fsprogs) and also suffered from a number of bugs.
	A significant number of additional patches that were applied to
	5.X kernels over time would have to be backported to 4.19 for
	the patch below to function correctly. It's really not worth
	doing that given bigalloc's experimental status as of 4.19 and
	the very rare combination of the bigalloc and inline features.

Link: https://lore.kernel.org/r/Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64
Cc: Eric Whitney <enwlinux@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h              |    1 
 fs/ext4/extents.c           |   79 --------------------------------------------
 fs/ext4/extents_status.c    |   53 -----------------------------
 fs/ext4/extents_status.h    |   12 ------
 fs/ext4/inode.c             |   79 ++++++++++----------------------------------
 include/trace/events/ext4.h |   35 -------------------
 6 files changed, 18 insertions(+), 241 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3241,7 +3241,6 @@ extern int ext4_swap_extents(handle_t *h
 				struct inode *inode2, ext4_lblk_t lblk1,
 			     ext4_lblk_t lblk2,  ext4_lblk_t count,
 			     int mark_unwritten,int *err);
-extern int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu);
 
 /* move_extent.c */
 extern void ext4_double_down_write_data_sem(struct inode *first,
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5963,82 +5963,3 @@ ext4_swap_extents(handle_t *handle, stru
 	}
 	return replaced_count;
 }
-
-/*
- * ext4_clu_mapped - determine whether any block in a logical cluster has
- *                   been mapped to a physical cluster
- *
- * @inode - file containing the logical cluster
- * @lclu - logical cluster of interest
- *
- * Returns 1 if any block in the logical cluster is mapped, signifying
- * that a physical cluster has been allocated for it.  Otherwise,
- * returns 0.  Can also return negative error codes.  Derived from
- * ext4_ext_map_blocks().
- */
-int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_ext_path *path;
-	int depth, mapped = 0, err = 0;
-	struct ext4_extent *extent;
-	ext4_lblk_t first_lblk, first_lclu, last_lclu;
-
-	/* search for the extent closest to the first block in the cluster */
-	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
-	if (IS_ERR(path)) {
-		err = PTR_ERR(path);
-		path = NULL;
-		goto out;
-	}
-
-	depth = ext_depth(inode);
-
-	/*
-	 * A consistent leaf must not be empty.  This situation is possible,
-	 * though, _during_ tree modification, and it's why an assert can't
-	 * be put in ext4_find_extent().
-	 */
-	if (unlikely(path[depth].p_ext == NULL && depth != 0)) {
-		EXT4_ERROR_INODE(inode,
-		    "bad extent address - lblock: %lu, depth: %d, pblock: %lld",
-				 (unsigned long) EXT4_C2B(sbi, lclu),
-				 depth, path[depth].p_block);
-		err = -EFSCORRUPTED;
-		goto out;
-	}
-
-	extent = path[depth].p_ext;
-
-	/* can't be mapped if the extent tree is empty */
-	if (extent == NULL)
-		goto out;
-
-	first_lblk = le32_to_cpu(extent->ee_block);
-	first_lclu = EXT4_B2C(sbi, first_lblk);
-
-	/*
-	 * Three possible outcomes at this point - found extent spanning
-	 * the target cluster, to the left of the target cluster, or to the
-	 * right of the target cluster.  The first two cases are handled here.
-	 * The last case indicates the target cluster is not mapped.
-	 */
-	if (lclu >= first_lclu) {
-		last_lclu = EXT4_B2C(sbi, first_lblk +
-				     ext4_ext_get_actual_len(extent) - 1);
-		if (lclu <= last_lclu) {
-			mapped = 1;
-		} else {
-			first_lblk = ext4_ext_next_allocated_block(path);
-			first_lclu = EXT4_B2C(sbi, first_lblk);
-			if (lclu == first_lclu)
-				mapped = 1;
-		}
-	}
-
-out:
-	ext4_ext_drop_refs(path);
-	kfree(path);
-
-	return err ? err : mapped;
-}
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1550,56 +1550,3 @@ bool ext4_is_pending(struct inode *inode
 
 	return ret;
 }
-
-/*
- * ext4_es_insert_delayed_block - adds a delayed block to the extents status
- *                                tree, adding a pending reservation where
- *                                needed
- *
- * @inode - file containing the newly added block
- * @lblk - logical block to be added
- * @allocated - indicates whether a physical cluster has been allocated for
- *              the logical cluster that contains the block
- *
- * Returns 0 on success, negative error code on failure.
- */
-int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
-				 bool allocated)
-{
-	struct extent_status newes;
-	int err = 0;
-
-	es_debug("add [%u/1) delayed to extent status tree of inode %lu\n",
-		 lblk, inode->i_ino);
-
-	newes.es_lblk = lblk;
-	newes.es_len = 1;
-	ext4_es_store_pblock_status(&newes, ~0, EXTENT_STATUS_DELAYED);
-	trace_ext4_es_insert_delayed_block(inode, &newes, allocated);
-
-	ext4_es_insert_extent_check(inode, &newes);
-
-	write_lock(&EXT4_I(inode)->i_es_lock);
-
-	err = __es_remove_extent(inode, lblk, lblk);
-	if (err != 0)
-		goto error;
-retry:
-	err = __es_insert_extent(inode, &newes);
-	if (err == -ENOMEM && __es_shrink(EXT4_SB(inode->i_sb),
-					  128, EXT4_I(inode)))
-		goto retry;
-	if (err != 0)
-		goto error;
-
-	if (allocated)
-		__insert_pending(inode, lblk);
-
-error:
-	write_unlock(&EXT4_I(inode)->i_es_lock);
-
-	ext4_es_print_tree(inode);
-	ext4_print_pending_tree(inode);
-
-	return err;
-}
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -178,16 +178,6 @@ static inline int ext4_es_is_hole(struct
 	return (ext4_es_type(es) & EXTENT_STATUS_HOLE) != 0;
 }
 
-static inline int ext4_es_is_mapped(struct extent_status *es)
-{
-	return (ext4_es_is_written(es) || ext4_es_is_unwritten(es));
-}
-
-static inline int ext4_es_is_delonly(struct extent_status *es)
-{
-	return (ext4_es_is_delayed(es) && !ext4_es_is_unwritten(es));
-}
-
 static inline void ext4_es_set_referenced(struct extent_status *es)
 {
 	es->es_pblk |= ((ext4_fsblk_t)EXTENT_STATUS_REFERENCED) << ES_SHIFT;
@@ -242,7 +232,5 @@ extern void ext4_exit_pending(void);
 extern void ext4_init_pending_tree(struct ext4_pending_tree *tree);
 extern void ext4_remove_pending(struct inode *inode, ext4_lblk_t lblk);
 extern bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk);
-extern int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
-					bool allocated);
 
 #endif /* _EXT4_EXTENTS_STATUS_H */
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1824,65 +1824,6 @@ static int ext4_bh_delay_or_unwritten(ha
 }
 
 /*
- * ext4_insert_delayed_block - adds a delayed block to the extents status
- *                             tree, incrementing the reserved cluster/block
- *                             count or making a pending reservation
- *                             where needed
- *
- * @inode - file containing the newly added block
- * @lblk - logical block to be added
- *
- * Returns 0 on success, negative error code on failure.
- */
-static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int ret;
-	bool allocated = false;
-
-	/*
-	 * If the cluster containing lblk is shared with a delayed,
-	 * written, or unwritten extent in a bigalloc file system, it's
-	 * already been accounted for and does not need to be reserved.
-	 * A pending reservation must be made for the cluster if it's
-	 * shared with a written or unwritten extent and doesn't already
-	 * have one.  Written and unwritten extents can be purged from the
-	 * extents status tree if the system is under memory pressure, so
-	 * it's necessary to examine the extent tree if a search of the
-	 * extents status tree doesn't get a match.
-	 */
-	if (sbi->s_cluster_ratio == 1) {
-		ret = ext4_da_reserve_space(inode);
-		if (ret != 0)   /* ENOSPC */
-			goto errout;
-	} else {   /* bigalloc */
-		if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
-			if (!ext4_es_scan_clu(inode,
-					      &ext4_es_is_mapped, lblk)) {
-				ret = ext4_clu_mapped(inode,
-						      EXT4_B2C(sbi, lblk));
-				if (ret < 0)
-					goto errout;
-				if (ret == 0) {
-					ret = ext4_da_reserve_space(inode);
-					if (ret != 0)   /* ENOSPC */
-						goto errout;
-				} else {
-					allocated = true;
-				}
-			} else {
-				allocated = true;
-			}
-		}
-	}
-
-	ret = ext4_es_insert_delayed_block(inode, lblk, allocated);
-
-errout:
-	return ret;
-}
-
-/*
  * This function is grabs code from the very beginning of
  * ext4_map_blocks, but assumes that the caller is from delayed write
  * time. This function looks up the requested blocks and sets the
@@ -1966,9 +1907,25 @@ add_delayed:
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
 		 */
+		/*
+		 * If the block was allocated from previously allocated cluster,
+		 * then we don't need to reserve it again. However we still need
+		 * to reserve metadata for every block we're going to write.
+		 */
+		if (EXT4_SB(inode->i_sb)->s_cluster_ratio == 1 ||
+		    !ext4_es_scan_clu(inode,
+				      &ext4_es_is_delayed, map->m_lblk)) {
+			ret = ext4_da_reserve_space(inode);
+			if (ret) {
+				/* not enough space to reserve */
+				retval = ret;
+				goto out_unlock;
+			}
+		}
 
-		ret = ext4_insert_delayed_block(inode, map->m_lblk);
-		if (ret != 0) {
+		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
+					    ~0, EXTENT_STATUS_DELAYED);
+		if (ret) {
 			retval = ret;
 			goto out_unlock;
 		}
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2532,41 +2532,6 @@ TRACE_EVENT(ext4_es_shrink,
 		  __entry->scan_time, __entry->nr_skipped, __entry->retried)
 );
 
-TRACE_EVENT(ext4_es_insert_delayed_block,
-	TP_PROTO(struct inode *inode, struct extent_status *es,
-		 bool allocated),
-
-	TP_ARGS(inode, es, allocated),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,		dev		)
-		__field(	ino_t,		ino		)
-		__field(	ext4_lblk_t,	lblk		)
-		__field(	ext4_lblk_t,	len		)
-		__field(	ext4_fsblk_t,	pblk		)
-		__field(	char,		status		)
-		__field(	bool,		allocated	)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= inode->i_sb->s_dev;
-		__entry->ino		= inode->i_ino;
-		__entry->lblk		= es->es_lblk;
-		__entry->len		= es->es_len;
-		__entry->pblk		= ext4_es_pblock(es);
-		__entry->status		= ext4_es_status(es);
-		__entry->allocated	= allocated;
-	),
-
-	TP_printk("dev %d,%d ino %lu es [%u/%u) mapped %llu status %s "
-		  "allocated %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long) __entry->ino,
-		  __entry->lblk, __entry->len,
-		  __entry->pblk, show_extent_status(__entry->status),
-		  __entry->allocated)
-);
-
 /* fsmap traces */
 DECLARE_EVENT_CLASS(ext4_fsmap_class,
 	TP_PROTO(struct super_block *sb, u32 keydev, u32 agno, u64 bno, u64 len,


