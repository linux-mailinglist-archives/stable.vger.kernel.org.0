Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598FE3443D9
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhCVMys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhCVMw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9955619E1;
        Mon, 22 Mar 2021 12:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417210;
        bh=WRYXx8vm9rKYhVzRQcAQhXEG4op5x0QdK5e4N1Es7I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mN3l0ISNAxv991bFkRVtvb0+QOaRekzp3s3qwDMIV3NELvhYWv5rwh1pkQA7xrHgC
         GsCgrvOjtyp1RKqHj1wNxxJ+p5x2LhWVZ/o41xdOHBS2PB7ZGXOHelBWYLxRHuGtRR
         evPCR3JNPcG5Cld1wKd3IUvlQDdLbNksp1lyHi7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Frisch <wolfgang.frisch@suse.com>,
        Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 03/25] ext4: check journal inode extents more carefully
Date:   Mon, 22 Mar 2021 13:28:53 +0100
Message-Id: <20210322121920.510183013@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
References: <20210322121920.399826335@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit ce9f24cccdc019229b70a5c15e2b09ad9c0ab5d1 upstream.

Currently, system zones just track ranges of block, that are "important"
fs metadata (bitmaps, group descriptors, journal blocks, etc.). This
however complicates how extent tree (or indirect blocks) can be checked
for inodes that actually track such metadata - currently the journal
inode but arguably we should be treating quota files or resize inode
similarly. We cannot run __ext4_ext_check() on such metadata inodes when
loading their extents as that would immediately trigger the validity
checks and so we just hack around that and special-case the journal
inode. This however leads to a situation that a journal inode which has
extent tree of depth at least one can have invalid extent tree that gets
unnoticed until ext4_cache_extents() crashes.

To overcome this limitation, track inode number each system zone belongs
to (0 is used for zones not belonging to any inode). We can then verify
inode number matches the expected one when verifying extent tree and
thus avoid the false errors. With this there's no need to to
special-case journal inode during extent tree checking anymore so remove
it.

Fixes: 0a944e8a6c66 ("ext4: don't perform block validity checks on the journal inode")
Reported-by: Wolfgang Frisch <wolfgang.frisch@suse.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200728130437.7804-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/block_validity.c |   37 +++++++++++++++++++++----------------
 fs/ext4/ext4.h           |    6 +++---
 fs/ext4/extents.c        |   16 ++++++----------
 fs/ext4/indirect.c       |    6 ++----
 fs/ext4/inode.c          |    5 ++---
 fs/ext4/mballoc.c        |    4 ++--
 6 files changed, 36 insertions(+), 38 deletions(-)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -23,6 +23,7 @@ struct ext4_system_zone {
 	struct rb_node	node;
 	ext4_fsblk_t	start_blk;
 	unsigned int	count;
+	u32		ino;
 };
 
 static struct kmem_cache *ext4_system_zone_cachep;
@@ -43,7 +44,8 @@ void ext4_exit_system_zone(void)
 static inline int can_merge(struct ext4_system_zone *entry1,
 		     struct ext4_system_zone *entry2)
 {
-	if ((entry1->start_blk + entry1->count) == entry2->start_blk)
+	if ((entry1->start_blk + entry1->count) == entry2->start_blk &&
+	    entry1->ino == entry2->ino)
 		return 1;
 	return 0;
 }
@@ -55,7 +57,7 @@ static inline int can_merge(struct ext4_
  */
 static int add_system_zone(struct ext4_sb_info *sbi,
 			   ext4_fsblk_t start_blk,
-			   unsigned int count)
+			   unsigned int count, u32 ino)
 {
 	struct ext4_system_zone *new_entry, *entry;
 	struct rb_node **n = &sbi->system_blks.rb_node, *node;
@@ -78,6 +80,7 @@ static int add_system_zone(struct ext4_s
 		return -ENOMEM;
 	new_entry->start_blk = start_blk;
 	new_entry->count = count;
+	new_entry->ino = ino;
 	new_node = &new_entry->node;
 
 	rb_link_node(new_node, parent, n);
@@ -153,16 +156,16 @@ static int ext4_protect_reserved_inode(s
 		if (n == 0) {
 			i++;
 		} else {
-			if (!ext4_data_block_valid(sbi, map.m_pblk, n)) {
-				ext4_error(sb, "blocks %llu-%llu from inode %u "
+			err = add_system_zone(sbi, map.m_pblk, n, ino);
+			if (err < 0) {
+				if (err == -EFSCORRUPTED) {
+					ext4_error(sb,
+					   "blocks %llu-%llu from inode %u "
 					   "overlap system zone", map.m_pblk,
 					   map.m_pblk + map.m_len - 1, ino);
-				err = -EFSCORRUPTED;
+				}
 				break;
 			}
-			err = add_system_zone(sbi, map.m_pblk, n);
-			if (err < 0)
-				break;
 			i += n;
 		}
 	}
@@ -191,16 +194,16 @@ int ext4_setup_system_zone(struct super_
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
-					ext4_bg_num_gdb(sb, i) + 1);
+					ext4_bg_num_gdb(sb, i) + 1, 0);
 		gdp = ext4_get_group_desc(sb, i, NULL);
-		ret = add_system_zone(sbi, ext4_block_bitmap(sb, gdp), 1);
+		ret = add_system_zone(sbi, ext4_block_bitmap(sb, gdp), 1, 0);
 		if (ret)
 			return ret;
-		ret = add_system_zone(sbi, ext4_inode_bitmap(sb, gdp), 1);
+		ret = add_system_zone(sbi, ext4_inode_bitmap(sb, gdp), 1, 0);
 		if (ret)
 			return ret;
 		ret = add_system_zone(sbi, ext4_inode_table(sb, gdp),
-				sbi->s_itb_per_group);
+				sbi->s_itb_per_group, 0);
 		if (ret)
 			return ret;
 	}
@@ -233,10 +236,11 @@ void ext4_release_system_zone(struct sup
  * start_blk+count) is valid; 0 if some part of the block region
  * overlaps with filesystem metadata blocks.
  */
-int ext4_data_block_valid(struct ext4_sb_info *sbi, ext4_fsblk_t start_blk,
-			  unsigned int count)
+int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
+			   unsigned int count)
 {
 	struct ext4_system_zone *entry;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct rb_node *n = sbi->system_blks.rb_node;
 
 	if ((start_blk <= le32_to_cpu(sbi->s_es->s_first_data_block)) ||
@@ -252,6 +256,8 @@ int ext4_data_block_valid(struct ext4_sb
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = n->rb_right;
 		else {
+			if (entry->ino == inode->i_ino)
+				return 1;
 			sbi->s_es->s_last_error_block = cpu_to_le64(start_blk);
 			return 0;
 		}
@@ -274,8 +280,7 @@ int ext4_check_blockref(const char *func
 	while (bref < p+max) {
 		blk = le32_to_cpu(*bref++);
 		if (blk &&
-		    unlikely(!ext4_data_block_valid(EXT4_SB(inode->i_sb),
-						    blk, 1))) {
+		    unlikely(!ext4_inode_block_valid(inode, blk, 1))) {
 			es->s_last_error_block = cpu_to_le64(blk);
 			ext4_error_inode(inode, function, line, blk,
 					 "invalid block");
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3136,9 +3136,9 @@ extern void ext4_release_system_zone(str
 extern int ext4_setup_system_zone(struct super_block *sb);
 extern int __init ext4_init_system_zone(void);
 extern void ext4_exit_system_zone(void);
-extern int ext4_data_block_valid(struct ext4_sb_info *sbi,
-				 ext4_fsblk_t start_blk,
-				 unsigned int count);
+extern int ext4_inode_block_valid(struct inode *inode,
+				  ext4_fsblk_t start_blk,
+				  unsigned int count);
 extern int ext4_check_blockref(const char *, unsigned int,
 			       struct inode *, __le32 *, unsigned int);
 
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -389,7 +389,7 @@ static int ext4_valid_extent(struct inod
 	 */
 	if (lblock + len <= lblock)
 		return 0;
-	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
+	return ext4_inode_block_valid(inode, block, len);
 }
 
 static int ext4_valid_extent_idx(struct inode *inode,
@@ -397,7 +397,7 @@ static int ext4_valid_extent_idx(struct
 {
 	ext4_fsblk_t block = ext4_idx_pblock(ext_idx);
 
-	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, 1);
+	return ext4_inode_block_valid(inode, block, 1);
 }
 
 static int ext4_valid_extent_entries(struct inode *inode,
@@ -554,14 +554,10 @@ __read_extent_tree_block(const char *fun
 	}
 	if (buffer_verified(bh) && !(flags & EXT4_EX_FORCE_CACHE))
 		return bh;
-	if (!ext4_has_feature_journal(inode->i_sb) ||
-	    (inode->i_ino !=
-	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum))) {
-		err = __ext4_ext_check(function, line, inode,
-				       ext_block_hdr(bh), depth, pblk);
-		if (err)
-			goto errout;
-	}
+	err = __ext4_ext_check(function, line, inode,
+			       ext_block_hdr(bh), depth, pblk);
+	if (err)
+		goto errout;
 	set_buffer_verified(bh);
 	/*
 	 * If this is a leaf block, cache all of its entries
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -840,8 +840,7 @@ static int ext4_clear_blocks(handle_t *h
 	else if (ext4_should_journal_data(inode))
 		flags |= EXT4_FREE_BLOCKS_FORGET;
 
-	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), block_to_free,
-				   count)) {
+	if (!ext4_inode_block_valid(inode, block_to_free, count)) {
 		EXT4_ERROR_INODE(inode, "attempt to clear invalid "
 				 "blocks %llu len %lu",
 				 (unsigned long long) block_to_free, count);
@@ -1003,8 +1002,7 @@ static void ext4_free_branches(handle_t
 			if (!nr)
 				continue;		/* A hole */
 
-			if (!ext4_data_block_valid(EXT4_SB(inode->i_sb),
-						   nr, 1)) {
+			if (!ext4_inode_block_valid(inode, nr, 1)) {
 				EXT4_ERROR_INODE(inode,
 						 "invalid indirect mapped "
 						 "block %lu (level %d)",
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -378,8 +378,7 @@ static int __check_block_validity(struct
 	    (inode->i_ino ==
 	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
 		return 0;
-	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), map->m_pblk,
-				   map->m_len)) {
+	if (!ext4_inode_block_valid(inode, map->m_pblk, map->m_len)) {
 		ext4_error_inode(inode, func, line, map->m_pblk,
 				 "lblock %lu mapped to illegal pblock %llu "
 				 "(length %d)", (unsigned long) map->m_lblk,
@@ -4704,7 +4703,7 @@ struct inode *__ext4_iget(struct super_b
 
 	ret = 0;
 	if (ei->i_file_acl &&
-	    !ext4_data_block_valid(EXT4_SB(sb), ei->i_file_acl, 1)) {
+	    !ext4_inode_block_valid(inode, ei->i_file_acl, 1)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad extended attribute block %llu",
 				 ei->i_file_acl);
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2963,7 +2963,7 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
 
 	len = EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
-	if (!ext4_data_block_valid(sbi, block, len)) {
+	if (!ext4_inode_block_valid(ac->ac_inode, block, len)) {
 		ext4_error(sb, "Allocating blocks %llu-%llu which overlap "
 			   "fs metadata", block, block+len);
 		/* File system mounted not to panic on error
@@ -4725,7 +4725,7 @@ void ext4_free_blocks(handle_t *handle,
 
 	sbi = EXT4_SB(sb);
 	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
-	    !ext4_data_block_valid(sbi, block, count)) {
+	    !ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks not in datazone - "
 			   "block = %llu, count = %lu", block, count);
 		goto error_return;


