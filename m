Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D16CC163AD9
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 04:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgBSDKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 22:10:39 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:16151 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbgBSDKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 22:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582081838; x=1613617838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ilHieDRKRSEmK/Rz82SZwTDUet+plAjO93JZpdnaP84=;
  b=YNQGLfTFHF8BUlKpEf2UkibvAArJDbTFqlfFI9TrzhoOuNAcqwE6M6/S
   fhrXX3h2JU5xA08wwpnnjO6hyRHR4MTcJyO3DyXmhy6U1O1WPqLubUiSe
   EMcn1ibivTnh1GnjbPNHWGvCHRSdjRL/4RovI3V/GucoUiv4C/QgRgbPq
   A=;
IronPort-SDR: xT0vFGxKPFg5kUA4QFdYuexrVJJSlwoEyohL8GD0vzb6zXrTxN9OJHNcLKKBc8Vff6u1UdoDTy
 hcB2z+1N/+WA==
X-IronPort-AV: E=Sophos;i="5.70,458,1574121600"; 
   d="scan'208";a="17811614"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Feb 2020 03:10:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 06BB014285D;
        Wed, 19 Feb 2020 03:10:23 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 03:10:23 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.235) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 03:10:22 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <sblbir@amazon.com>, <sjitindarsingh@gmail.com>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 3/3] ext4: fix potential race between s_flex_groups online resizing and access
Date:   Tue, 18 Feb 2020 19:08:51 -0800
Message-ID: <20200219030851.2678-4-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219030851.2678-1-surajjs@amazon.com>
References: <20200219030851.2678-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.235]
X-ClientProxiedBy: EX13D33UWB004.ant.amazon.com (10.43.161.225) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Cc: stable@vger.kernel.org
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/ialloc.c  | 21 +++++++++++-------
 fs/ext4/mballoc.c |  9 +++++---
 fs/ext4/resize.c  |  4 ++--
 fs/ext4/super.c   | 56 ++++++++++++++++++++++++++++++++---------------
 5 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f4aaaae7da6..e8157ce5988b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1512,7 +1512,7 @@ struct ext4_sb_info {
 	unsigned int s_extent_max_zeroout_kb;
 
 	unsigned int s_log_groups_per_flex;
-	struct flex_groups *s_flex_groups;
+	struct flex_groups **s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
 	/* workqueue for reserved extent conversions (buffered io) */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c66e8f9451a2..9324552a2ac2 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -330,9 +330,11 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t f = ext4_flex_group(sbi, block_group);
 
-		atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+		atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
+						f)->free_inodes);
 		if (is_directory)
-			atomic_dec(&sbi->s_flex_groups[f].used_dirs);
+			atomic_dec(&sbi_array_rcu_deref(sbi, s_flex_groups,
+							f)->used_dirs);
 	}
 	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
 	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
@@ -368,12 +370,13 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
 			    int flex_size, struct orlov_stats *stats)
 {
 	struct ext4_group_desc *desc;
-	struct flex_groups *flex_group = EXT4_SB(sb)->s_flex_groups;
+	struct flex_groups *flex_group = sbi_array_rcu_deref(EXT4_SB(sb),
+							     s_flex_groups, g);
 
 	if (flex_size > 1) {
-		stats->free_inodes = atomic_read(&flex_group[g].free_inodes);
-		stats->free_clusters = atomic64_read(&flex_group[g].free_clusters);
-		stats->used_dirs = atomic_read(&flex_group[g].used_dirs);
+		stats->free_inodes = atomic_read(&flex_group->free_inodes);
+		stats->free_clusters = atomic64_read(&flex_group->free_clusters);
+		stats->used_dirs = atomic_read(&flex_group->used_dirs);
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
index 0d9b17afc85f..0de1191e12a8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3022,7 +3022,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
 		atomic64_sub(ac->ac_b_ex.fe_len,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4920,7 +4921,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(count_clusters,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	/*
@@ -5077,7 +5079,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(clusters_freed,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 6fbe8607095f..941941a629a3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1427,9 +1427,9 @@ static void ext4_update_super(struct super_block *sb,
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, group_data[0].group);
 		atomic64_add(EXT4_NUM_B2C(sbi, free_blocks),
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi->s_flex_groups[flex_group]->free_clusters);
 		atomic_add(EXT4_INODES_PER_GROUP(sb) * flex_gd->count,
-			   &sbi->s_flex_groups[flex_group].free_inodes);
+			   &sbi->s_flex_groups[flex_group]->free_inodes);
 	}
 
 	/*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f464dff09774..3a401f930bca 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1049,7 +1049,11 @@ static void ext4_put_super(struct super_block *sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kvfree(sbi->s_group_desc);
-	kvfree(sbi->s_flex_groups);
+	if (sbi->s_flex_groups) {
+		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
+			kvfree(sbi->s_flex_groups[i]);
+		kvfree(sbi->s_flex_groups);
+	}
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -2380,8 +2384,8 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct flex_groups *new_groups;
-	int size;
+	struct flex_groups **old_groups, **new_groups;
+	int size, i;
 
 	if (!sbi->s_log_groups_per_flex)
 		return 0;
@@ -2390,22 +2394,35 @@ int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
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
+	}
+	old_groups = sbi->s_flex_groups;
+	if (sbi->s_flex_groups)
 		memcpy(new_groups, sbi->s_flex_groups,
 		       (sbi->s_flex_groups_allocated *
-			sizeof(struct flex_groups)));
-		kvfree(sbi->s_flex_groups);
-	}
-	sbi->s_flex_groups = new_groups;
-	sbi->s_flex_groups_allocated = size / sizeof(struct flex_groups);
+			sizeof(struct flex_groups *)));
+	rcu_assign_pointer(sbi->s_flex_groups, new_groups);
+	sbi->s_flex_groups_allocated = size;
+	if (old_groups)
+		ext4_kvfree_array_rcu(old_groups);
 	return 0;
 }
 
@@ -2431,11 +2448,11 @@ static int ext4_fill_flex_info(struct super_block *sb)
 
 		flex_group = ext4_flex_group(sbi, i);
 		atomic_add(ext4_free_inodes_count(sb, gdp),
-			   &sbi->s_flex_groups[flex_group].free_inodes);
+			   &sbi->s_flex_groups[flex_group]->free_inodes);
 		atomic64_add(ext4_free_group_clusters(sb, gdp),
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi->s_flex_groups[flex_group]->free_clusters);
 		atomic_add(ext4_used_dirs_count(sb, gdp),
-			   &sbi->s_flex_groups[flex_group].used_dirs);
+			   &sbi->s_flex_groups[flex_group]->used_dirs);
 	}
 
 	return 1;
@@ -4682,8 +4699,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	ext4_unregister_li_request(sb);
 failed_mount6:
 	ext4_mb_release(sb);
-	if (sbi->s_flex_groups)
+	if (sbi->s_flex_groups) {
+		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
+			kvfree(sbi->s_flex_groups[i]);
 		kvfree(sbi->s_flex_groups);
+	}
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
2.17.1

