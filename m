Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE0217FE6B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgCJMo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbgCJMo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:44:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1CC7246A2;
        Tue, 10 Mar 2020 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844297;
        bh=HE7bthmDCgaQSg3sTImsPkUCSiyWc6UzbDHKxSVA4DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmVcVvgHSm5d9/froL5ETb+sgibsLN5hzeOF13xQAB/G8X1c6t8Wwl95VoH4RB3/O
         DHopeJfr2y1YWJK0o8dKrb0j8k8tLzVX/2+4DBZ9w3hKA18V9zRtNH5tszsnL2aNZn
         uz0SppqhB5XEWRGGSHKVdlJf/IZDvDbjiJjsjBvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suraj Jitindar Singh <surajjs@amazon.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        stable@kernel.org
Subject: [PATCH 4.9 03/88] ext4: fix potential race between s_flex_groups online resizing and access
Date:   Tue, 10 Mar 2020 13:38:11 +0100
Message-Id: <20200310123607.612166054@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <surajjs@amazon.com>

commit 7c990728b99ed6fbe9c75fc202fce1172d9916da upstream.

During an online resize an array of s_flex_groups structures gets replaced
so it can get enlarged. If there is a concurrent access to the array and
this memory has been reused then this can lead to an invalid memory access.

The s_flex_group array has been converted into an array of pointers rather
than an array of structures. This is to ensure that the information
contained in the structures cannot get out of sync during a resize due to
an accessor updating the value in the old structure after it has been
copied but before the array pointer is updated. Since the structures them-
selves are no longer copied but only the pointers to them this case is
mitigated.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206443
Link: https://lore.kernel.org/r/20200221053458.730016-4-tytso@mit.edu
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org # 4.4.x
Cc: stable@kernel.org # 4.9.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/ialloc.c  | 23 +++++++++------
 fs/ext4/mballoc.c |  9 ++++--
 fs/ext4/resize.c  |  7 +++--
 fs/ext4/super.c   | 72 ++++++++++++++++++++++++++++++++---------------
 5 files changed, 76 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 42c6c02382377..faa66b702059a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1475,7 +1475,7 @@ struct ext4_sb_info {
 	unsigned int s_extent_max_zeroout_kb;
 
 	unsigned int s_log_groups_per_flex;
-	struct flex_groups *s_flex_groups;
+	struct flex_groups * __rcu *s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
 	/* workqueue for reserved extent conversions (buffered io) */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4f78e099de1d9..c5af7bbf906fb 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -331,11 +331,13 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 
 	percpu_counter_inc(&sbi->s_freeinodes_counter);
 	if (sbi->s_log_groups_per_flex) {
-		ext4_group_t f = ext4_flex_group(sbi, block_group);
+		struct flex_groups *fg;
 
-		atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+		fg = sbi_array_rcu_deref(sbi, s_flex_groups,
+					 ext4_flex_group(sbi, block_group));
+		atomic_inc(&fg->free_inodes);
 		if (is_directory)
-			atomic_dec(&sbi->s_flex_groups[f].used_dirs);
+			atomic_dec(&fg->used_dirs);
 	}
 	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
 	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
@@ -376,12 +378,13 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
 			    int flex_size, struct orlov_stats *stats)
 {
 	struct ext4_group_desc *desc;
-	struct flex_groups *flex_group = EXT4_SB(sb)->s_flex_groups;
 
 	if (flex_size > 1) {
-		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
-		stats->free_clusters = atomic64_read(&flex_group[g].free_clusters);
-		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
+		struct flex_groups *fg = sbi_array_rcu_deref(EXT4_SB(sb),
+							     s_flex_groups, g);
+		stats->free_inodes = atomic_read(&fg->free_inodes);
+		stats->free_clusters = atomic64_read(&fg->free_clusters);
+		stats->used_dirs = atomic_read(&fg->used_dirs);
 		return;
 	}
 
@@ -988,7 +991,8 @@ got:
 		if (sbi->s_log_groups_per_flex) {
 			ext4_group_t f = ext4_flex_group(sbi, group);
 
-			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
+			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
+							f)->used_dirs);
 		}
 	}
 	if (ext4_has_group_desc_csum(sb)) {
@@ -1011,7 +1015,8 @@ got:
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
-		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
+		atomic_dec(&sbi_array_rcu_deref(sbi, s_flex_groups,
+						flex_group)->free_inodes);
 	}
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a49d0e5d7baf8..c3619f3f40517 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2998,7 +2998,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
 		atomic64_sub(ac->ac_b_ex.fe_len,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4888,7 +4889,8 @@ do_more:
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(count_clusters,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
@@ -5033,7 +5035,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(EXT4_NUM_B2C(sbi, blocks_freed),
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index b788bbe74579b..845d9841c91c2 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1422,11 +1422,14 @@ static void ext4_update_super(struct super_block *sb,
 		   percpu_counter_read(&sbi->s_freeclusters_counter));
 	if (ext4_has_feature_flex_bg(sb) && sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
+		struct flex_groups *fg;
+
 		flex_group = ext4_flex_group(sbi, group_data[0].group);
+		fg = sbi_array_rcu_deref(sbi, s_flex_groups, flex_group);
 		atomic64_add(EXT4_NUM_B2C(sbi, free_blocks),
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &fg->free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
-			   &sbi->s_flex_groups[flex_group].free_inodes);
+			   &fg->free_inodes);
 	}
 
 	/*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 75840eef13417..d2f35321b3346 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -827,6 +827,7 @@ static void ext4_put_super(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head **group_desc;
+	struct flex_groups **flex_groups;
 	int aborted = 0;
 	int i, err;
 
@@ -863,8 +864,13 @@ static void ext4_put_super(struct super_block *sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(group_desc[i]);
 	kvfree(group_desc);
+	flex_groups = rcu_dereference(sbi->s_flex_groups);
+	if (flex_groups) {
+		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
+			kvfree(flex_groups[i]);
+		kvfree(flex_groups);
+	}
 	rcu_read_unlock();
-	kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -2113,8 +2119,8 @@ done:
 int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct flex_groups *new_groups;
-	int size;
+	struct flex_groups **old_groups, **new_groups;
+	int size, i;
 
 	if (!sbi->s_log_groups_per_flex)
 		return 0;
@@ -2123,22 +2129,37 @@ int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
 	if (size <= sbi->s_flex_groups_allocated)
 		return 0;
 
-	size = roundup_pow_of_two(size * sizeof(struct flex_groups));
-	new_groups = ext4_kvzalloc(size, GFP_KERNEL);
+	new_groups = ext4_kvzalloc(roundup_pow_of_two(size *
+				   sizeof(*sbi->s_flex_groups)), GFP_KERNEL);
 	if (!new_groups) {
-		ext4_msg(sb, KERN_ERR, "not enough memory for %d flex groups",
-			 size / (int) sizeof(struct flex_groups));
+		ext4_msg(sb, KERN_ERR,
+			 "not enough memory for %d flex group pointers", size);
 		return -ENOMEM;
 	}
-
-	if (sbi->s_flex_groups) {
-		memcpy(new_groups, sbi->s_flex_groups,
-		       (sbi->s_flex_groups_allocated *
-			sizeof(struct flex_groups)));
-		kvfree(sbi->s_flex_groups);
+	for (i = sbi->s_flex_groups_allocated; i < size; i++) {
+		new_groups[i] = ext4_kvzalloc(roundup_pow_of_two(
+					      sizeof(struct flex_groups)),
+					      GFP_KERNEL);
+		if (!new_groups[i]) {
+			for (i--; i >= sbi->s_flex_groups_allocated; i--)
+				kvfree(new_groups[i]);
+			kvfree(new_groups);
+			ext4_msg(sb, KERN_ERR,
+				 "not enough memory for %d flex groups", size);
+			return -ENOMEM;
+		}
 	}
-	sbi->s_flex_groups = new_groups;
-	sbi->s_flex_groups_allocated = size / sizeof(struct flex_groups);
+	rcu_read_lock();
+	old_groups = rcu_dereference(sbi->s_flex_groups);
+	if (old_groups)
+		memcpy(new_groups, old_groups,
+		       (sbi->s_flex_groups_allocated *
+			sizeof(struct flex_groups *)));
+	rcu_read_unlock();
+	rcu_assign_pointer(sbi->s_flex_groups, new_groups);
+	sbi->s_flex_groups_allocated = size;
+	if (old_groups)
+		ext4_kvfree_array_rcu(old_groups);
 	return 0;
 }
 
@@ -2146,6 +2167,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = NULL;
+	struct flex_groups *fg;
 	ext4_group_t flex_group;
 	int i, err;
 
@@ -2163,12 +2185,11 @@ static int ext4_fill_flex_info(struct super_block *sb)
 		gdp = ext4_get_group_desc(sb, i, NULL);
 
 		flex_group = ext4_flex_group(sbi, i);
-		atomic_add(ext4_free_inodes_count(sb, gdp),
-			   &sbi->s_flex_groups[flex_group].free_inodes);
+		fg = sbi_array_rcu_deref(sbi, s_flex_groups, flex_group);
+		atomic_add(ext4_free_inodes_count(sb, gdp), &fg->free_inodes);
 		atomic64_add(ext4_free_group_clusters(sb, gdp),
-			     &sbi->s_flex_groups[flex_group].free_clusters);
-		atomic_add(ext4_used_dirs_count(sb, gdp),
-			   &sbi->s_flex_groups[flex_group].used_dirs);
+			     &fg->free_clusters);
+		atomic_add(ext4_used_dirs_count(sb, gdp), &fg->used_dirs);
 	}
 
 	return 1;
@@ -3410,6 +3431,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	struct flex_groups **flex_groups;
 	ext4_fsblk_t block;
 	ext4_fsblk_t sb_block = get_sb_block(&data);
 	ext4_fsblk_t logical_sb_block;
@@ -4326,8 +4348,14 @@ failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
 	ext4_mb_release(sb);
-	if (sbi->s_flex_groups)
-		kvfree(sbi->s_flex_groups);
+	rcu_read_lock();
+	flex_groups = rcu_dereference(sbi->s_flex_groups);
+	if (flex_groups) {
+		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
+			kvfree(flex_groups[i]);
+		kvfree(flex_groups);
+	}
+	rcu_read_unlock();
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
2.20.1



