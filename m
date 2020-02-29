Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC481743ED
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 01:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB2As5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 19:48:57 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:61377 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB2As5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 19:48:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582937336; x=1614473336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MvCjt4Y/YjXfahV+zdb++0MQglax7hUrkcBKMpHfzhs=;
  b=k0CYxqq/h/cOrWcEJmc3pYiWT92cb7TAjMrgti/dbbE123BP6z5XlC3Z
   Zx6I1VK4dcUxD6u2nyPDfP1Nerz2ZLhFKVK8BSswROao2og9fz9w+tFTu
   hykOd1uPHl5lzMdr1PDer3abWjnDbpjFxh8QTLjVcbZfoLTnlzt7dLnWK
   w=;
IronPort-SDR: KaqWaFA2VbwgqdHnu7zXHvmKlsmqzlcIkdRVKfh+s3N/ZkIJTTUs626U2jx3rddID3YsQE+aLw
 Lr9UV8NoNNlA==
X-IronPort-AV: E=Sophos;i="5.70,497,1574121600"; 
   d="scan'208";a="18798157"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 Feb 2020 00:48:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id A5CE2A25BE;
        Sat, 29 Feb 2020 00:48:41 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 00:48:41 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.8) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 00:48:41 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <tytso@mit.edu>, <surajjs@amazon.com>, <stable@kernel.org>
Subject: [PATCH 4.14.x 3/3] ext4: fix potential race between s_flex_groups online resizing and access
Date:   Fri, 28 Feb 2020 16:48:17 -0800
Message-ID: <20200229004817.13283-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229004817.13283-1-surajjs@amazon.com>
References: <1582790918190214@kroah.com>
 <20200229004817.13283-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D12UWC001.ant.amazon.com (10.43.162.78) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@kernel.org # 4.14.x

---

Changes against upstream:
fs/ext4/mballoc.c:ext4_group_add_blocks()
 - blocks_freed converted to clusters_freed upstream
 - preserve blocks_freed usage
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/ialloc.c  | 23 +++++++++------
 fs/ext4/mballoc.c |  9 ++++--
 fs/ext4/resize.c  |  7 +++--
 fs/ext4/super.c   | 72 ++++++++++++++++++++++++++++++++---------------
 5 files changed, 76 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ef3204caf2da..e06a0b818256 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1492,7 +1492,7 @@ struct ext4_sb_info {
 	unsigned int s_extent_max_zeroout_kb;
 
 	unsigned int s_log_groups_per_flex;
-	struct flex_groups *s_flex_groups;
+	struct flex_groups * __rcu *s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
 	/* workqueue for reserved extent conversions (buffered io) */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2f46564d3fca..2a480c0ef1bc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -333,11 +333,13 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 
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
@@ -378,12 +380,13 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
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
 
@@ -1062,7 +1065,8 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		if (sbi->s_log_groups_per_flex) {
 			ext4_group_t f = ext4_flex_group(sbi, group);
 
-			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
+			atomic_inc(&sbi_array_rcu_deref(sbi, s_flex_groups,
+							f)->used_dirs);
 		}
 	}
 	if (ext4_has_group_desc_csum(sb)) {
@@ -1085,7 +1089,8 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
-		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
+		atomic_dec(&sbi_array_rcu_deref(sbi, s_flex_groups,
+						flex_group)->free_inodes);
 	}
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4ca540c3b14a..745a89d30a57 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3070,7 +3070,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		ext4_group_t flex_group = ext4_flex_group(sbi,
 							  ac->ac_b_ex.fe_group);
 		atomic64_sub(ac->ac_b_ex.fe_len,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
@@ -4965,7 +4966,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(count_clusters,
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
@@ -5110,7 +5112,8 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
 		atomic64_add(EXT4_NUM_B2C(sbi, blocks_freed),
-			     &sbi->s_flex_groups[flex_group].free_clusters);
+			     &sbi_array_rcu_deref(sbi, s_flex_groups,
+						  flex_group)->free_clusters);
 	}
 
 	ext4_mb_unload_buddy(&e4b);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 16e3830da548..d42f7471fd5b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1425,11 +1425,14 @@ static void ext4_update_super(struct super_block *sb,
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
index 3d4e8a2a1f7a..f08d7266358f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -901,6 +901,7 @@ static void ext4_put_super(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head **group_desc;
+	struct flex_groups **flex_groups;
 	int aborted = 0;
 	int i, err;
 
@@ -937,8 +938,13 @@ static void ext4_put_super(struct super_block *sb)
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
@@ -2231,8 +2237,8 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct flex_groups *new_groups;
-	int size;
+	struct flex_groups **old_groups, **new_groups;
+	int size, i;
 
 	if (!sbi->s_log_groups_per_flex)
 		return 0;
@@ -2241,22 +2247,37 @@ int ext4_alloc_flex_bg_array(struct super_block *sb, ext4_group_t ngroup)
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
 
@@ -2264,6 +2285,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_desc *gdp = NULL;
+	struct flex_groups *fg;
 	ext4_group_t flex_group;
 	int i, err;
 
@@ -2281,12 +2303,11 @@ static int ext4_fill_flex_info(struct super_block *sb)
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
@@ -3502,6 +3523,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	struct flex_groups **flex_groups;
 	ext4_fsblk_t block;
 	ext4_fsblk_t sb_block = get_sb_block(&data);
 	ext4_fsblk_t logical_sb_block;
@@ -4498,8 +4520,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
2.17.1

