Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4BC1711FA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 09:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgB0IJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 03:09:39 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58635 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728443AbgB0IJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 03:09:39 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B98EA21FDF;
        Thu, 27 Feb 2020 03:09:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 03:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I1Tkms
        YX6daqArrtqNMsxKXP7vQ+NuVSvNffN/2esy0=; b=pq5Nf6gMpGqM+1wPYMEP+h
        wiP10n8yPCNH2LHykvrrmgPoJyDvpUwE3OsoTpcMAoANlPLlbiDtLyq1ABPbhmpp
        3gnN18GevjC5pn1wnTsTvUm5tTMTsosq6BAVyKPqAIHNiFNFhdwtfeJ47tLJFScH
        iLF14LVx5+SBs0T04jth85zscCXVKaxNGP/46CDOKGZzfnB9jcBc4GNdkfptTVAu
        4pNqLEBRl5FH8wNtWbQPxQX4+p+v1mLz/ols31colbMlRzDk8KJYlQdNNMFwJUa/
        BMytc54ORgrmCVM58ZwvkvpnGmkJuloGhrIfQkNsbA5nB0gETECrsDV+ve7+9XqA
        ==
X-ME-Sender: <xms:QXlXXmt89_LnpDfajojafIqUqzc6Kmlc2pKgVho-UJHZ-ousSMkvSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleehgdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:QXlXXrLwU4CSc4H3pqyMwKdXGRKzkFjCtpJwyRB2DDUwzBoEQ0KtWw>
    <xmx:QXlXXsmt76DDYIjiMDveHOukoiU_hjM4zi-5EqcgtG7eiMiWAS1_EQ>
    <xmx:QXlXXjpQzH2V40cfb5axgut6oTABKDihfGDbeaGYAPY2Z4lkpXmrjA>
    <xmx:QXlXXoulgZqvsEg-hUJp2omcRsh29ZZl3gzMptPj5ArDH-54EkWfCw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59AC3328005D;
        Thu, 27 Feb 2020 03:09:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix potential race between s_flex_groups online" failed to apply to 4.14-stable tree
To:     surajjs@amazon.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 09:09:35 +0100
Message-ID: <1582790975412@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c990728b99ed6fbe9c75fc202fce1172d9916da Mon Sep 17 00:00:00 2001
From: Suraj Jitindar Singh <surajjs@amazon.com>
Date: Tue, 18 Feb 2020 19:08:51 -0800
Subject: [PATCH] ext4: fix potential race between s_flex_groups online
 resizing and access

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

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b1ece5329738..614fefa7dc7a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1512,7 +1512,7 @@ struct ext4_sb_info {
 	unsigned int s_extent_max_zeroout_kb;
 
 	unsigned int s_log_groups_per_flex;
-	struct flex_groups *s_flex_groups;
+	struct flex_groups * __rcu *s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
 	/* workqueue for reserved extent conversions (buffered io) */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c66e8f9451a2..f95ee99091e4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -328,11 +328,13 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 
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
@@ -368,12 +370,13 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
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
 
@@ -1054,7 +1057,8 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		if (sbi->s_log_groups_per_flex) {
 			ext4_group_t f = ext4_flex_group(sbi, group);
 
-			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
+			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
+							f)->used_dirs);
 		}
 	}
 	if (ext4_has_group_desc_csum(sb)) {
@@ -1077,7 +1081,8 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
-		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
+		atomic_dec(&sbi_array_rcu_deref(sbi, s_flex_groups,
+						flex_group)->free_inodes);
 	}
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1b46fb63692a..51a78eb65f3c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3038,7 +3038,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
 		atomic64_sub(ac->ac_b_ex.fe_len,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4936,7 +4937,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(count_clusters,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	/*
@@ -5093,7 +5095,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(clusters_freed,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 536cc9f38091..a50b51270ea9 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1430,11 +1430,14 @@ static void ext4_update_super(struct super_block *sb,
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
index e00bcc19099f..6b7e628b7903 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1015,6 +1015,7 @@ static void ext4_put_super(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head **group_desc;
+	struct flex_groups **flex_groups;
 	int aborted = 0;
 	int i, err;
 
@@ -1052,8 +1053,13 @@ static void ext4_put_super(struct super_block *sb)
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
@@ -2384,8 +2390,8 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct flex_groups *new_groups;
-	int size;
+	struct flex_groups **old_groups, **new_groups;
+	int size, i;
 
 	if (!sbi->s_log_groups_per_flex)
 		return 0;
@@ -2394,22 +2400,37 @@ int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
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
 
@@ -2417,6 +2438,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = NULL;
+	struct flex_groups *fg;
 	ext4_group_t flex_group;
 	int i, err;
 
@@ -2434,12 +2456,11 @@ static int ext4_fill_flex_info(struct super_block *sb)
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
@@ -3641,6 +3662,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	struct flex_groups **flex_groups;
 	ext4_fsblk_t block;
 	ext4_fsblk_t sb_block = get_sb_block(&data);
 	ext4_fsblk_t logical_sb_block;
@@ -4692,8 +4714,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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

