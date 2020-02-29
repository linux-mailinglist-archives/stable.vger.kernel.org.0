Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231681743F5
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 01:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB2Ave (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 19:51:34 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:61740 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgB2Ave (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 19:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582937493; x=1614473493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=kuECGKNsf1zkq606h6f0Qa/4zldlxB3xkhCag+fbcs8=;
  b=fDkSaHnAKYQdf6axdg9yMLx0Hlcw+47VKo6yF/oGzpUmCmaNukM/et1P
   /AdxK+j9acr/kGa7rfLISDUI2BCG71LfVvTco/YcE2C/aWFr7mM5bw8Hu
   C52TpfHo1x3KXzj1ifPtw06u4uk6LOCwQBPv6lC/mCMEtDBkHxyEJGwaY
   E=;
IronPort-SDR: lmfPEUrnC9RkDq2CyCVgJ2U3yh/5JtkuivDMtDqnu1bDX0mKebhQC6RoySfHLyN7H0cgtMFKrQ
 L6JgCA7TTCPA==
X-IronPort-AV: E=Sophos;i="5.70,497,1574121600"; 
   d="scan'208";a="18798402"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 Feb 2020 00:51:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id F3F7FA2499;
        Sat, 29 Feb 2020 00:51:30 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 00:51:30 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.8) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 00:51:30 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <tytso@mit.edu>, <surajjs@amazon.com>, <stable@kernel.org>
Subject: [PATCH 4.4.x 4.9.x 1/3] ext4: fix potential race between online resizing and write operations
Date:   Fri, 28 Feb 2020 16:51:17 -0800
Message-ID: <20200229005119.14635-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <1582790919145241@kroah.com>
References: <1582790919145241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 1d0c3924a92e69bfa91163bda83c12a994b4d106 upstream.

During an online resize an array of pointers to buffer heads gets
replaced so it can get enlarged.  If there is a racing block
allocation or deallocation which uses the old array, and the old array
has gotten reused this can lead to a GPF or some other random kernel
memory getting modified.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206443
Link: https://lore.kernel.org/r/20200221053458.730016-2-tytso@mit.edu
Reported-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org # 4.4.x
Cc: stable@kernel.org # 4.9.x

---

Changes against upstream:
fs/ext4/ext4.h:
 - Missing context, massage to apply
 - No functional change
fs/ext4/super.c:ext4_fill_super()
 - ext4_kvmalloc converted to kvmalloc_array upstream
 - preservce ext4_kvmalloc usage
 - No functional change
---
 fs/ext4/balloc.c | 14 +++++++++---
 fs/ext4/ext4.h   | 20 +++++++++++++++++-
 fs/ext4/resize.c | 55 ++++++++++++++++++++++++++++++++++++++----------
 fs/ext4/super.c  | 31 +++++++++++++++++++--------
 4 files changed, 96 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 2455fe1446d6..de601f3c023d 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -279,6 +279,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	struct ext4_group_desc *desc;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct buffer_head *bh_p;
 
 	if (block_group >= ngroups) {
 		ext4_error(sb, "block_group >= groups_count - block_group = %u,"
@@ -289,7 +290,14 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 
 	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
-	if (!sbi->s_group_desc[group_desc]) {
+	bh_p = sbi_array_rcu_deref(sbi, s_group_desc, group_desc);
+	/*
+	 * sbi_array_rcu_deref returns with rcu unlocked, this is ok since
+	 * the pointer being dereferenced won't be dereferenced again. By
+	 * looking at the usage in add_new_gdb() the value isn't modified,
+	 * just the pointer, and so it remains valid.
+	 */
+	if (!bh_p) {
 		ext4_error(sb, "Group descriptor not loaded - "
 			   "block_group = %u, group_desc = %u, desc = %u",
 			   block_group, group_desc, offset);
@@ -297,10 +305,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	}
 
 	desc = (struct ext4_group_desc *)(
-		(__u8 *)sbi->s_group_desc[group_desc]->b_data +
+		(__u8 *)bh_p->b_data +
 		offset * EXT4_DESC_SIZE(sb));
 	if (bh)
-		*bh = sbi->s_group_desc[group_desc];
+		*bh = bh_p;
 	return desc;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 567a6c7af677..87634a82294a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1367,7 +1367,7 @@ struct ext4_sb_info {
 	loff_t s_bitmap_maxbytes;	/* max bytes for bitmap files */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block *s_es;	/* Pointer to the super block in the buffer */
-	struct buffer_head **s_group_desc;
+	struct buffer_head * __rcu *s_group_desc;
 	unsigned int s_mount_opt;
 	unsigned int s_mount_opt2;
 	unsigned int s_mount_flags;
@@ -1546,6 +1546,23 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
 
+/*
+ * Returns: sbi->field[index]
+ * Used to access an array element from the following sbi fields which require
+ * rcu protection to avoid dereferencing an invalid pointer due to reassignment
+ * - s_group_desc
+ * - s_group_info
+ * - s_flex_group
+ */
+#define sbi_array_rcu_deref(sbi, field, index)				   \
+({									   \
+	typeof(*((sbi)->field)) _v;					   \
+	rcu_read_lock();						   \
+	_v = ((typeof(_v)*)rcu_dereference((sbi)->field))[index];	   \
+	rcu_read_unlock();						   \
+	_v;								   \
+})
+
 /*
  * Inode dynamic state flags
  */
@@ -2552,6 +2569,7 @@ extern int ext4_generic_delete_entry(handle_t *handle,
 extern bool ext4_empty_dir(struct inode *inode);
 
 /* resize.c */
+extern void ext4_kvfree_array_rcu(void *to_free);
 extern int ext4_group_add(struct super_block *sb,
 				struct ext4_new_group_data *input);
 extern int ext4_group_extend(struct super_block *sb,
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index aef2a24dc9f9..b788bbe74579 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -16,6 +16,33 @@
 
 #include "ext4_jbd2.h"
 
+struct ext4_rcu_ptr {
+	struct rcu_head rcu;
+	void *ptr;
+};
+
+static void ext4_rcu_ptr_callback(struct rcu_head *head)
+{
+	struct ext4_rcu_ptr *ptr;
+
+	ptr = container_of(head, struct ext4_rcu_ptr, rcu);
+	kvfree(ptr->ptr);
+	kfree(ptr);
+}
+
+void ext4_kvfree_array_rcu(void *to_free)
+{
+	struct ext4_rcu_ptr *ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
+
+	if (ptr) {
+		ptr->ptr = to_free;
+		call_rcu(&ptr->rcu, ext4_rcu_ptr_callback);
+		return;
+	}
+	synchronize_rcu();
+	kvfree(to_free);
+}
+
 int ext4_resize_begin(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -541,8 +568,8 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 				brelse(gdb);
 				goto out;
 			}
-			memcpy(gdb->b_data, sbi->s_group_desc[j]->b_data,
-			       gdb->b_size);
+			memcpy(gdb->b_data, sbi_array_rcu_deref(sbi,
+				s_group_desc, j)->b_data, gdb->b_size);
 			set_buffer_uptodate(gdb);
 
 			err = ext4_handle_dirty_metadata(handle, NULL, gdb);
@@ -849,13 +876,15 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	}
 	brelse(dind);
 
-	o_group_desc = EXT4_SB(sb)->s_group_desc;
+	rcu_read_lock();
+	o_group_desc = rcu_dereference(EXT4_SB(sb)->s_group_desc);
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
+	rcu_read_unlock();
 	n_group_desc[gdb_num] = gdb_bh;
-	EXT4_SB(sb)->s_group_desc = n_group_desc;
+	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
 	EXT4_SB(sb)->s_gdb_count++;
-	kvfree(o_group_desc);
+	ext4_kvfree_array_rcu(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
 	err = ext4_handle_dirty_super(handle, sb);
@@ -903,9 +932,11 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 		return err;
 	}
 
-	o_group_desc = EXT4_SB(sb)->s_group_desc;
+	rcu_read_lock();
+	o_group_desc = rcu_dereference(EXT4_SB(sb)->s_group_desc);
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
+	rcu_read_unlock();
 	n_group_desc[gdb_num] = gdb_bh;
 
 	BUFFER_TRACE(gdb_bh, "get_write_access");
@@ -916,9 +947,9 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 		return err;
 	}
 
-	EXT4_SB(sb)->s_group_desc = n_group_desc;
+	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
 	EXT4_SB(sb)->s_gdb_count++;
-	kvfree(o_group_desc);
+	ext4_kvfree_array_rcu(o_group_desc);
 	return err;
 }
 
@@ -1180,7 +1211,8 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 		 * use non-sparse filesystems anymore.  This is already checked above.
 		 */
 		if (gdb_off) {
-			gdb_bh = sbi->s_group_desc[gdb_num];
+			gdb_bh = sbi_array_rcu_deref(sbi, s_group_desc,
+						     gdb_num);
 			BUFFER_TRACE(gdb_bh, "get_write_access");
 			err = ext4_journal_get_write_access(handle, gdb_bh);
 
@@ -1262,7 +1294,7 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 		/*
 		 * get_write_access() has been called on gdb_bh by ext4_add_new_desc().
 		 */
-		gdb_bh = sbi->s_group_desc[gdb_num];
+		gdb_bh = sbi_array_rcu_deref(sbi, s_group_desc, gdb_num);
 		/* Update group descriptor block for new group */
 		gdp = (struct ext4_group_desc *)(gdb_bh->b_data +
 						 gdb_off * EXT4_DESC_SIZE(sb));
@@ -1489,7 +1521,8 @@ static int ext4_flex_group_add(struct super_block *sb,
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
 
-			gdb_bh = sbi->s_group_desc[gdb_num];
+			gdb_bh = sbi_array_rcu_deref(sbi, s_group_desc,
+						     gdb_num);
 			if (old_gdb == gdb_bh->b_blocknr)
 				continue;
 			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 391ab55808c9..3fbbd3e1e308 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -826,6 +826,7 @@ static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	struct buffer_head **group_desc;
 	int aborted = 0;
 	int i, err;
 
@@ -857,9 +858,12 @@ static void ext4_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
+	rcu_read_lock();
+	group_desc = rcu_dereference(sbi->s_group_desc);
 	for (i = 0; i < sbi->s_gdb_count; i++)
-		brelse(sbi->s_group_desc[i]);
-	kvfree(sbi->s_group_desc);
+		brelse(group_desc[i]);
+	kvfree(group_desc);
+	rcu_read_unlock();
 	kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
@@ -3409,7 +3413,7 @@ static void ext4_set_resv_clusters(struct super_block *sb)
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
 	char *orig_data = kstrdup(data, GFP_KERNEL);
-	struct buffer_head *bh;
+	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	ext4_fsblk_t block;
@@ -3961,9 +3965,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			goto failed_mount;
 		}
 	}
-	sbi->s_group_desc = ext4_kvmalloc(db_count *
+	rcu_assign_pointer(sbi->s_group_desc,
+			   ext4_kvmalloc(db_count *
 					  sizeof(struct buffer_head *),
-					  GFP_KERNEL);
+					  GFP_KERNEL));
 	if (sbi->s_group_desc == NULL) {
 		ext4_msg(sb, KERN_ERR, "not enough memory");
 		ret = -ENOMEM;
@@ -3973,14 +3978,19 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
+		struct buffer_head *bh;
+
 		block = descriptor_loc(sb, logical_sb_block, i);
-		sbi->s_group_desc[i] = sb_bread_unmovable(sb, block);
-		if (!sbi->s_group_desc[i]) {
+		bh = sb_bread_unmovable(sb, block);
+		if (!bh) {
 			ext4_msg(sb, KERN_ERR,
 			       "can't read group descriptor %d", i);
 			db_count = i;
 			goto failed_mount2;
 		}
+		rcu_read_lock();
+		rcu_dereference(sbi->s_group_desc)[i] = bh;
+		rcu_read_unlock();
 	}
 	sbi->s_gdb_count = db_count;
 	if (!ext4_check_descriptors(sb, logical_sb_block, &first_not_zeroed)) {
@@ -4355,9 +4365,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 failed_mount2:
+	rcu_read_lock();
+	group_desc = rcu_dereference(sbi->s_group_desc);
 	for (i = 0; i < db_count; i++)
-		brelse(sbi->s_group_desc[i]);
-	kvfree(sbi->s_group_desc);
+		brelse(group_desc[i]);
+	kvfree(group_desc);
+	rcu_read_unlock();
 failed_mount:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
-- 
2.17.1

