Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5760B171CF1
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbgB0OQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:16:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389513AbgB0OQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:16:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B8D20801;
        Thu, 27 Feb 2020 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812990;
        bh=FlKrRIAMEKvMmcLP3ez6eEKI98uGXQvTVQX5vDMln8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vM1gWTnQ/+mzbGWTpTBXShw5l2LDKA6hKvOslQXfLEnuoxaoT8TqKrCKN8GZ33myP
         TMASiFGaQvBIY4wTP2Z3+py3f0KLpMIrxtAV78gJaJLBp0MX9VJnuufFzrxM2rt+KW
         FyoJxts77TTFGuhCrzRasbQEE+xSd2MaxRsb6CR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suraj Jitindar Singh <surajjs@amazon.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.5 093/150] ext4: fix potential race between s_flex_groups online resizing and access
Date:   Thu, 27 Feb 2020 14:37:10 +0100
Message-Id: <20200227132246.557293869@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
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
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h    |    2 -
 fs/ext4/ialloc.c  |   23 ++++++++++-------
 fs/ext4/mballoc.c |    9 ++++--
 fs/ext4/resize.c  |    7 +++--
 fs/ext4/super.c   |   72 +++++++++++++++++++++++++++++++++++++-----------------
 5 files changed, 76 insertions(+), 37 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1513,7 +1513,7 @@ struct ext4_sb_info {
 	unsigned int s_extent_max_zeroout_kb;
 
 	unsigned int s_log_groups_per_flex;
-	struct flex_groups *s_flex_groups;
+	struct flex_groups * __rcu *s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
 	/* workqueue for reserved extent conversions (buffered io) */
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -325,11 +325,13 @@ void ext4_free_inode(handle_t *handle, s
 
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
@@ -365,12 +367,13 @@ static void get_orlov_stats(struct super
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
 
@@ -1051,7 +1054,8 @@ got:
 		if (sbi->s_log_groups_per_flex) {
 			ext4_group_t f = ext4_flex_group(sbi, group);
 
-			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
+			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
+							f)->used_dirs);
 		}
 	}
 	if (ext4_has_group_desc_csum(sb)) {
@@ -1074,7 +1078,8 @@ got:
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
-		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
+		atomic_dec(&sbi_array_rcu_deref(sbi, s_flex_groups,
+						flex_group)->free_inodes);
 	}
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3038,7 +3038,8 @@ ext4_mb_mark_diskspace_used(struct ext4_
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
 		atomic64_sub(ac->ac_b_ex.fe_len,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4932,7 +4933,8 @@ do_more:
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(count_clusters,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	/*
@@ -5089,7 +5091,8 @@ int ext4_group_add_blocks(handle_t *hand
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(clusters_freed,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1432,11 +1432,14 @@ static void ext4_update_super(struct sup
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
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -971,6 +971,7 @@ static void ext4_put_super(struct super_
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head **group_desc;
+	struct flex_groups **flex_groups;
 	int aborted = 0;
 	int i, err;
 
@@ -1006,8 +1007,13 @@ static void ext4_put_super(struct super_
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
@@ -2339,8 +2345,8 @@ done:
 int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct flex_groups *new_groups;
-	int size;
+	struct flex_groups **old_groups, **new_groups;
+	int size, i;
 
 	if (!sbi->s_log_groups_per_flex)
 		return 0;
@@ -2349,22 +2355,37 @@ int ext4_alloc_flex_bg_array(struct supe
 	if (size <= sbi->s_flex_groups_allocated)
 		return 0;
 
-	size = roundup_pow_of_two(size * sizeof(struct flex_groups));
-	new_groups = kvzalloc(size, GFP_KERNEL);
+	new_groups = kvzalloc(roundup_pow_of_two(size *
+			      sizeof(*sbi->s_flex_groups)), GFP_KERNEL);
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
+		new_groups[i] = kvzalloc(roundup_pow_of_two(
+					 sizeof(struct flex_groups)),
+					 GFP_KERNEL);
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
 
@@ -2372,6 +2393,7 @@ static int ext4_fill_flex_info(struct su
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = NULL;
+	struct flex_groups *fg;
 	ext4_group_t flex_group;
 	int i, err;
 
@@ -2389,12 +2411,11 @@ static int ext4_fill_flex_info(struct su
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
@@ -3596,6 +3617,7 @@ static int ext4_fill_super(struct super_
 	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	struct flex_groups **flex_groups;
 	ext4_fsblk_t block;
 	ext4_fsblk_t sb_block = get_sb_block(&data);
 	ext4_fsblk_t logical_sb_block;
@@ -4647,8 +4669,14 @@ failed_mount7:
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


