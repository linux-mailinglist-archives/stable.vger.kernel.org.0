Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBBA24FA8F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgHXJ5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbgHXIfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:35:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F16321741;
        Mon, 24 Aug 2020 08:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258102;
        bh=he0ylmIlBLBPLj4roqzwkFgxGVqsO7Z5gTMXlrBR+38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2HBg6fYEyPXh7h1v2vizWVMJtNITsoxS7ewJcCHt9sQEt3aAx0ngFI80RKOnfCwG
         LQwM/eo4aG/zd8TSGH5zbVvTWHvlAdDcmEPMZHEwLQCOfWfXuIEui47TTfrX64gwbD
         f3eRp2eLe2o0PK6A2EP2KUXMSUuaHe+CmnvV7oDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Frisch <wolfgang.frisch@suse.com>,
        Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 075/148] ext4: check journal inode extents more carefully
Date:   Mon, 24 Aug 2020 10:29:33 +0200
Message-Id: <20200824082417.667619307@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit ce9f24cccdc019229b70a5c15e2b09ad9c0ab5d1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/block_validity.c | 51 ++++++++++++++++++++--------------------
 fs/ext4/ext4.h           |  6 ++---
 fs/ext4/extents.c        | 16 +++++--------
 fs/ext4/indirect.c       |  6 ++---
 fs/ext4/inode.c          |  5 ++--
 fs/ext4/mballoc.c        |  4 ++--
 6 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index b394a50ebbe30..e830a9d4e10d3 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -24,6 +24,7 @@ struct ext4_system_zone {
 	struct rb_node	node;
 	ext4_fsblk_t	start_blk;
 	unsigned int	count;
+	u32		ino;
 };
 
 static struct kmem_cache *ext4_system_zone_cachep;
@@ -45,7 +46,8 @@ void ext4_exit_system_zone(void)
 static inline int can_merge(struct ext4_system_zone *entry1,
 		     struct ext4_system_zone *entry2)
 {
-	if ((entry1->start_blk + entry1->count) == entry2->start_blk)
+	if ((entry1->start_blk + entry1->count) == entry2->start_blk &&
+	    entry1->ino == entry2->ino)
 		return 1;
 	return 0;
 }
@@ -66,7 +68,7 @@ static void release_system_zone(struct ext4_system_blocks *system_blks)
  */
 static int add_system_zone(struct ext4_system_blocks *system_blks,
 			   ext4_fsblk_t start_blk,
-			   unsigned int count)
+			   unsigned int count, u32 ino)
 {
 	struct ext4_system_zone *new_entry, *entry;
 	struct rb_node **n = &system_blks->root.rb_node, *node;
@@ -89,6 +91,7 @@ static int add_system_zone(struct ext4_system_blocks *system_blks,
 		return -ENOMEM;
 	new_entry->start_blk = start_blk;
 	new_entry->count = count;
+	new_entry->ino = ino;
 	new_node = &new_entry->node;
 
 	rb_link_node(new_node, parent, n);
@@ -149,7 +152,7 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
 static int ext4_data_block_valid_rcu(struct ext4_sb_info *sbi,
 				     struct ext4_system_blocks *system_blks,
 				     ext4_fsblk_t start_blk,
-				     unsigned int count)
+				     unsigned int count, ino_t ino)
 {
 	struct ext4_system_zone *entry;
 	struct rb_node *n;
@@ -170,7 +173,7 @@ static int ext4_data_block_valid_rcu(struct ext4_sb_info *sbi,
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = n->rb_right;
 		else
-			return 0;
+			return entry->ino == ino;
 	}
 	return 1;
 }
@@ -204,19 +207,18 @@ static int ext4_protect_reserved_inode(struct super_block *sb,
 		if (n == 0) {
 			i++;
 		} else {
-			if (!ext4_data_block_valid_rcu(sbi, system_blks,
-						map.m_pblk, n)) {
-				err = -EFSCORRUPTED;
-				__ext4_error(sb, __func__, __LINE__, -err,
-					     map.m_pblk, "blocks %llu-%llu "
-					     "from inode %u overlap system zone",
-					     map.m_pblk,
-					     map.m_pblk + map.m_len - 1, ino);
+			err = add_system_zone(system_blks, map.m_pblk, n, ino);
+			if (err < 0) {
+				if (err == -EFSCORRUPTED) {
+					__ext4_error(sb, __func__, __LINE__,
+						     -err, map.m_pblk,
+						     "blocks %llu-%llu from inode %u overlap system zone",
+						     map.m_pblk,
+						     map.m_pblk + map.m_len - 1,
+						     ino);
+				}
 				break;
 			}
-			err = add_system_zone(system_blks, map.m_pblk, n);
-			if (err < 0)
-				break;
 			i += n;
 		}
 	}
@@ -270,19 +272,19 @@ int ext4_setup_system_zone(struct super_block *sb)
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(system_blks,
 					ext4_group_first_block_no(sb, i),
-					ext4_bg_num_gdb(sb, i) + 1);
+					ext4_bg_num_gdb(sb, i) + 1, 0);
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		ret = add_system_zone(system_blks,
-				ext4_block_bitmap(sb, gdp), 1);
+				ext4_block_bitmap(sb, gdp), 1, 0);
 		if (ret)
 			goto err;
 		ret = add_system_zone(system_blks,
-				ext4_inode_bitmap(sb, gdp), 1);
+				ext4_inode_bitmap(sb, gdp), 1, 0);
 		if (ret)
 			goto err;
 		ret = add_system_zone(system_blks,
 				ext4_inode_table(sb, gdp),
-				sbi->s_itb_per_group);
+				sbi->s_itb_per_group, 0);
 		if (ret)
 			goto err;
 	}
@@ -331,7 +333,7 @@ void ext4_release_system_zone(struct super_block *sb)
 		call_rcu(&system_blks->rcu, ext4_destroy_system_zone);
 }
 
-int ext4_data_block_valid(struct ext4_sb_info *sbi, ext4_fsblk_t start_blk,
+int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
 			  unsigned int count)
 {
 	struct ext4_system_blocks *system_blks;
@@ -343,9 +345,9 @@ int ext4_data_block_valid(struct ext4_sb_info *sbi, ext4_fsblk_t start_blk,
 	 * mount option.
 	 */
 	rcu_read_lock();
-	system_blks = rcu_dereference(sbi->system_blks);
-	ret = ext4_data_block_valid_rcu(sbi, system_blks, start_blk,
-					count);
+	system_blks = rcu_dereference(EXT4_SB(inode->i_sb)->system_blks);
+	ret = ext4_data_block_valid_rcu(EXT4_SB(inode->i_sb), system_blks,
+					start_blk, count, inode->i_ino);
 	rcu_read_unlock();
 	return ret;
 }
@@ -364,8 +366,7 @@ int ext4_check_blockref(const char *function, unsigned int line,
 	while (bref < p+max) {
 		blk = le32_to_cpu(*bref++);
 		if (blk &&
-		    unlikely(!ext4_data_block_valid(EXT4_SB(inode->i_sb),
-						    blk, 1))) {
+		    unlikely(!ext4_inode_block_valid(inode, blk, 1))) {
 			ext4_error_inode(inode, function, line, blk,
 					 "invalid block");
 			return -EFSCORRUPTED;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 42f5060f3cdf1..42815304902b8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3363,9 +3363,9 @@ extern void ext4_release_system_zone(struct super_block *sb);
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
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 221f240eae604..d75054570e44c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -340,7 +340,7 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 	 */
 	if (lblock + len <= lblock)
 		return 0;
-	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
+	return ext4_inode_block_valid(inode, block, len);
 }
 
 static int ext4_valid_extent_idx(struct inode *inode,
@@ -348,7 +348,7 @@ static int ext4_valid_extent_idx(struct inode *inode,
 {
 	ext4_fsblk_t block = ext4_idx_pblock(ext_idx);
 
-	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, 1);
+	return ext4_inode_block_valid(inode, block, 1);
 }
 
 static int ext4_valid_extent_entries(struct inode *inode,
@@ -507,14 +507,10 @@ __read_extent_tree_block(const char *function, unsigned int line,
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
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index be2b66eb65f7a..4026418257121 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -858,8 +858,7 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 	else if (ext4_should_journal_data(inode))
 		flags |= EXT4_FREE_BLOCKS_FORGET;
 
-	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), block_to_free,
-				   count)) {
+	if (!ext4_inode_block_valid(inode, block_to_free, count)) {
 		EXT4_ERROR_INODE(inode, "attempt to clear invalid "
 				 "blocks %llu len %lu",
 				 (unsigned long long) block_to_free, count);
@@ -1004,8 +1003,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			if (!nr)
 				continue;		/* A hole */
 
-			if (!ext4_data_block_valid(EXT4_SB(inode->i_sb),
-						   nr, 1)) {
+			if (!ext4_inode_block_valid(inode, nr, 1)) {
 				EXT4_ERROR_INODE(inode,
 						 "invalid indirect mapped "
 						 "block %lu (level %d)",
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 10dd470876b30..92573f8540ab7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -394,8 +394,7 @@ static int __check_block_validity(struct inode *inode, const char *func,
 	    (inode->i_ino ==
 	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
 		return 0;
-	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), map->m_pblk,
-				   map->m_len)) {
+	if (!ext4_inode_block_valid(inode, map->m_pblk, map->m_len)) {
 		ext4_error_inode(inode, func, line, map->m_pblk,
 				 "lblock %lu mapped to illegal pblock %llu "
 				 "(length %d)", (unsigned long) map->m_lblk,
@@ -4760,7 +4759,7 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 
 	ret = 0;
 	if (ei->i_file_acl &&
-	    !ext4_data_block_valid(EXT4_SB(sb), ei->i_file_acl, 1)) {
+	    !ext4_inode_block_valid(inode, ei->i_file_acl, 1)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad extended attribute block %llu",
 				 ei->i_file_acl);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c0a331e2feb02..38719c156573c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3090,7 +3090,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	block = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
 
 	len = EXT4_C2B(sbi, ac->ac_b_ex.fe_len);
-	if (!ext4_data_block_valid(sbi, block, len)) {
+	if (!ext4_inode_block_valid(ac->ac_inode, block, len)) {
 		ext4_error(sb, "Allocating blocks %llu-%llu which overlap "
 			   "fs metadata", block, block+len);
 		/* File system mounted not to panic on error
@@ -4915,7 +4915,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 
 	sbi = EXT4_SB(sb);
 	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
-	    !ext4_data_block_valid(sbi, block, count)) {
+	    !ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks not in datazone - "
 			   "block = %llu, count = %lu", block, count);
 		goto error_return;
-- 
2.25.1



