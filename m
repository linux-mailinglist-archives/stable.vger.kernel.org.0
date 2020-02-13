Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B1E15C6C5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgBMQDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:03:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728641AbgBMPYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:15 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0535C24690;
        Thu, 13 Feb 2020 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607455;
        bh=6x5qbOEETPkZJggjqxr11f+PDTVt078MYMk8TKzoEa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOcLoBtngQpEI1bKaAAE8T4WvqcX9NVA1/PZy9VBIRxnSeVau5g/wTO2XMiTB8guQ
         jeNE09CB/ooEkfYme7qhRyzzmyDaXuiphpCyx+PkQbvUtkFHCPzoWdy5t62OTHG+h6
         lhe1hRQLuH8ET8zlf3mt7ZCFwdUUuck0kOmj/Q/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 084/116] btrfs: remove trivial locking wrappers of tree mod log
Date:   Thu, 13 Feb 2020 07:20:28 -0800
Message-Id: <20200213151915.438639490@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit b1a09f1ec540408abf3a50d15dff5d9506932693 ]

The wrappers are trivial and do not bring any extra value on top of the
plain locking primitives.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 58 ++++++++++++++++--------------------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 305deb6e59c36..5e552947666c9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -331,26 +331,6 @@ struct tree_mod_elem {
 	struct tree_mod_root old_root;
 };
 
-static inline void tree_mod_log_read_lock(struct btrfs_fs_info *fs_info)
-{
-	read_lock(&fs_info->tree_mod_log_lock);
-}
-
-static inline void tree_mod_log_read_unlock(struct btrfs_fs_info *fs_info)
-{
-	read_unlock(&fs_info->tree_mod_log_lock);
-}
-
-static inline void tree_mod_log_write_lock(struct btrfs_fs_info *fs_info)
-{
-	write_lock(&fs_info->tree_mod_log_lock);
-}
-
-static inline void tree_mod_log_write_unlock(struct btrfs_fs_info *fs_info)
-{
-	write_unlock(&fs_info->tree_mod_log_lock);
-}
-
 /*
  * Pull a new tree mod seq number for our operation.
  */
@@ -370,14 +350,14 @@ static inline u64 btrfs_inc_tree_mod_seq(struct btrfs_fs_info *fs_info)
 u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
 			   struct seq_list *elem)
 {
-	tree_mod_log_write_lock(fs_info);
+	write_lock(&fs_info->tree_mod_log_lock);
 	spin_lock(&fs_info->tree_mod_seq_lock);
 	if (!elem->seq) {
 		elem->seq = btrfs_inc_tree_mod_seq(fs_info);
 		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
 	}
 	spin_unlock(&fs_info->tree_mod_seq_lock);
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&fs_info->tree_mod_log_lock);
 
 	return elem->seq;
 }
@@ -419,7 +399,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	 * anything that's lower than the lowest existing (read: blocked)
 	 * sequence number can be removed from the tree.
 	 */
-	tree_mod_log_write_lock(fs_info);
+	write_lock(&fs_info->tree_mod_log_lock);
 	tm_root = &fs_info->tree_mod_log;
 	for (node = rb_first(tm_root); node; node = next) {
 		next = rb_next(node);
@@ -429,7 +409,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 		rb_erase(node, tm_root);
 		kfree(tm);
 	}
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&fs_info->tree_mod_log_lock);
 }
 
 /*
@@ -440,7 +420,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
  * for root replace operations, or the logical address of the affected
  * block for all other operations.
  *
- * Note: must be called with write lock (tree_mod_log_write_lock).
+ * Note: must be called with write lock for fs_info::tree_mod_log_lock.
  */
 static noinline int
 __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
@@ -480,7 +460,7 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
  * Determines if logging can be omitted. Returns 1 if it can. Otherwise, it
  * returns zero with the tree_mod_log_lock acquired. The caller must hold
  * this until all tree mod log insertions are recorded in the rb tree and then
- * call tree_mod_log_write_unlock() to release.
+ * write unlock fs_info::tree_mod_log_lock.
  */
 static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
 				    struct extent_buffer *eb) {
@@ -490,9 +470,9 @@ static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
 	if (eb && btrfs_header_level(eb) == 0)
 		return 1;
 
-	tree_mod_log_write_lock(fs_info);
+	write_lock(&fs_info->tree_mod_log_lock);
 	if (list_empty(&(fs_info)->tree_mod_seq_list)) {
-		tree_mod_log_write_unlock(fs_info);
+		write_unlock(&fs_info->tree_mod_log_lock);
 		return 1;
 	}
 
@@ -556,7 +536,7 @@ tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = __tree_mod_log_insert(fs_info, tm);
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&eb->fs_info->tree_mod_log_lock);
 	if (ret)
 		kfree(tm);
 
@@ -620,7 +600,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	ret = __tree_mod_log_insert(fs_info, tm);
 	if (ret)
 		goto free_tms;
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&eb->fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 
 	return 0;
@@ -631,7 +611,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 		kfree(tm_list[i]);
 	}
 	if (locked)
-		tree_mod_log_write_unlock(fs_info);
+		write_unlock(&eb->fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 	kfree(tm);
 
@@ -712,7 +692,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	if (!ret)
 		ret = __tree_mod_log_insert(fs_info, tm);
 
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&fs_info->tree_mod_log_lock);
 	if (ret)
 		goto free_tms;
 	kfree(tm_list);
@@ -739,7 +719,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 	struct tree_mod_elem *cur = NULL;
 	struct tree_mod_elem *found = NULL;
 
-	tree_mod_log_read_lock(fs_info);
+	read_lock(&fs_info->tree_mod_log_lock);
 	tm_root = &fs_info->tree_mod_log;
 	node = tm_root->rb_node;
 	while (node) {
@@ -767,7 +747,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 			break;
 		}
 	}
-	tree_mod_log_read_unlock(fs_info);
+	read_unlock(&fs_info->tree_mod_log_lock);
 
 	return found;
 }
@@ -848,7 +828,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 			goto free_tms;
 	}
 
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 
 	return 0;
@@ -860,7 +840,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		kfree(tm_list[i]);
 	}
 	if (locked)
-		tree_mod_log_write_unlock(fs_info);
+		write_unlock(&fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 
 	return ret;
@@ -920,7 +900,7 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 		goto free_tms;
 
 	ret = __tree_mod_log_free_eb(fs_info, tm_list, nritems);
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&eb->fs_info->tree_mod_log_lock);
 	if (ret)
 		goto free_tms;
 	kfree(tm_list);
@@ -1271,7 +1251,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 	unsigned long p_size = sizeof(struct btrfs_key_ptr);
 
 	n = btrfs_header_nritems(eb);
-	tree_mod_log_read_lock(fs_info);
+	read_lock(&fs_info->tree_mod_log_lock);
 	while (tm && tm->seq >= time_seq) {
 		/*
 		 * all the operations are recorded with the operator used for
@@ -1326,7 +1306,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		if (tm->logical != first_tm->logical)
 			break;
 	}
-	tree_mod_log_read_unlock(fs_info);
+	read_unlock(&fs_info->tree_mod_log_lock);
 	btrfs_set_header_nritems(eb, n);
 }
 
-- 
2.20.1



