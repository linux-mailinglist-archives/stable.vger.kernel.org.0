Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85EE0171BE6
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbgB0OGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733178AbgB0OGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:06:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C764920801;
        Thu, 27 Feb 2020 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812402;
        bh=xPvRjPJDp1nnOvlu6ZytP2FbGavNbtuOmmE3glSws8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZA9NsJ9S2DtdDqBtb9uIo/H49aXVD3de8cPtyEwEAeE1p6ifp6zz2RCulQfd6wiEl
         VfpAgaDLHtBM04qnorjwxHh8sLNogfuiM/ncQbekyFLOyax85orkx22rCaC8O/YFGz
         xuQ4EwKYJNQmo6TKcM3e/84WHBn7yMkhGSU61gqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suraj Jitindar Singh <surajjs@amazon.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 65/97] ext4: fix potential race between online resizing and write operations
Date:   Thu, 27 Feb 2020 14:37:13 +0100
Message-Id: <20200227132225.120415734@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/balloc.c |   14 +++++++++++---
 fs/ext4/ext4.h   |   20 +++++++++++++++++++-
 fs/ext4/resize.c |   55 ++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/super.c  |   33 +++++++++++++++++++++++----------
 4 files changed, 97 insertions(+), 25 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -270,6 +270,7 @@ struct ext4_group_desc * ext4_get_group_
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	struct ext4_group_desc *desc;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct buffer_head *bh_p;
 
 	if (block_group >= ngroups) {
 		ext4_error(sb, "block_group >= groups_count - block_group = %u,"
@@ -280,7 +281,14 @@ struct ext4_group_desc * ext4_get_group_
 
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
@@ -288,10 +296,10 @@ struct ext4_group_desc * ext4_get_group_
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
 
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1372,7 +1372,7 @@ struct ext4_sb_info {
 	loff_t s_bitmap_maxbytes;	/* max bytes for bitmap files */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block *s_es;	/* Pointer to the super block in the buffer */
-	struct buffer_head **s_group_desc;
+	struct buffer_head * __rcu *s_group_desc;
 	unsigned int s_mount_opt;
 	unsigned int s_mount_opt2;
 	unsigned int s_mount_flags;
@@ -1542,6 +1542,23 @@ static inline int ext4_valid_inum(struct
 }
 
 /*
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
+/*
  * Inode dynamic state flags
  */
 enum {
@@ -2564,6 +2581,7 @@ extern int ext4_generic_delete_entry(han
 extern bool ext4_empty_dir(struct inode *inode);
 
 /* resize.c */
+extern void ext4_kvfree_array_rcu(void *to_free);
 extern int ext4_group_add(struct super_block *sb,
 				struct ext4_new_group_data *input);
 extern int ext4_group_extend(struct super_block *sb,
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -17,6 +17,33 @@
 
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
@@ -560,8 +587,8 @@ static int setup_new_flex_group_blocks(s
 				brelse(gdb);
 				goto out;
 			}
-			memcpy(gdb->b_data, sbi->s_group_desc[j]->b_data,
-			       gdb->b_size);
+			memcpy(gdb->b_data, sbi_array_rcu_deref(sbi,
+				s_group_desc, j)->b_data, gdb->b_size);
 			set_buffer_uptodate(gdb);
 
 			err = ext4_handle_dirty_metadata(handle, NULL, gdb);
@@ -879,13 +906,15 @@ static int add_new_gdb(handle_t *handle,
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
@@ -929,9 +958,11 @@ static int add_new_gdb_meta_bg(struct su
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
@@ -942,9 +973,9 @@ static int add_new_gdb_meta_bg(struct su
 		return err;
 	}
 
-	EXT4_SB(sb)->s_group_desc = n_group_desc;
+	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
 	EXT4_SB(sb)->s_gdb_count++;
-	kvfree(o_group_desc);
+	ext4_kvfree_array_rcu(o_group_desc);
 	return err;
 }
 
@@ -1210,7 +1241,8 @@ static int ext4_add_new_descs(handle_t *
 		 * use non-sparse filesystems anymore.  This is already checked above.
 		 */
 		if (gdb_off) {
-			gdb_bh = sbi->s_group_desc[gdb_num];
+			gdb_bh = sbi_array_rcu_deref(sbi, s_group_desc,
+						     gdb_num);
 			BUFFER_TRACE(gdb_bh, "get_write_access");
 			err = ext4_journal_get_write_access(handle, gdb_bh);
 
@@ -1292,7 +1324,7 @@ static int ext4_setup_new_descs(handle_t
 		/*
 		 * get_write_access() has been called on gdb_bh by ext4_add_new_desc().
 		 */
-		gdb_bh = sbi->s_group_desc[gdb_num];
+		gdb_bh = sbi_array_rcu_deref(sbi, s_group_desc, gdb_num);
 		/* Update group descriptor block for new group */
 		gdp = (struct ext4_group_desc *)(gdb_bh->b_data +
 						 gdb_off * EXT4_DESC_SIZE(sb));
@@ -1519,7 +1551,8 @@ exit_journal:
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
 
-			gdb_bh = sbi->s_group_desc[gdb_num];
+			gdb_bh = sbi_array_rcu_deref(sbi, s_group_desc,
+						     gdb_num);
 			if (old_gdb == gdb_bh->b_blocknr)
 				continue;
 			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -969,6 +969,7 @@ static void ext4_put_super(struct super_
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	struct buffer_head **group_desc;
 	int aborted = 0;
 	int i, err;
 
@@ -999,9 +1000,12 @@ static void ext4_put_super(struct super_
 	if (!sb_rdonly(sb))
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
@@ -3548,7 +3552,7 @@ static int ext4_fill_super(struct super_
 {
 	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
 	char *orig_data = kstrdup(data, GFP_KERNEL);
-	struct buffer_head *bh;
+	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	ext4_fsblk_t block;
@@ -4166,9 +4170,10 @@ static int ext4_fill_super(struct super_
 			goto failed_mount;
 		}
 	}
-	sbi->s_group_desc = kvmalloc_array(db_count,
-					   sizeof(struct buffer_head *),
-					   GFP_KERNEL);
+	rcu_assign_pointer(sbi->s_group_desc,
+			   kvmalloc_array(db_count,
+					  sizeof(struct buffer_head *),
+					  GFP_KERNEL));
 	if (sbi->s_group_desc == NULL) {
 		ext4_msg(sb, KERN_ERR, "not enough memory");
 		ret = -ENOMEM;
@@ -4184,14 +4189,19 @@ static int ext4_fill_super(struct super_
 	}
 
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
@@ -4588,9 +4598,12 @@ failed_mount3:
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


