Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AA615C166
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgBMPXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgBMPXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:04 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EEF2246B1;
        Thu, 13 Feb 2020 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607383;
        bh=/HSKAYtfM+rTPNv7Go2pmGjAX6lhyCcJMStXBSWlkTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jk9EKgmIzYBAXVhFP7+OdpQTsA3zj4iRnEglZ66/KJ8hfRLYpiq+62TgTJNFByJjH
         kE+5Nc6oM1cey17DfBHPv3oynHjhGb1HdpC+tZRCLd2Nv1Sh+Q/aEyIZFjcQ+egDCH
         2ac2TQbCZtxVA88Emk4Dj4uU/ronDJp8qwVrSpDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 64/91] btrfs: remove trivial locking wrappers of tree mod log
Date:   Thu, 13 Feb 2020 07:20:21 -0800
Message-Id: <20200213151847.037090188@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
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
index 62caf3bcadf8e..f770488a0723b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -332,26 +332,6 @@ struct tree_mod_elem {
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
@@ -371,14 +351,14 @@ static inline u64 btrfs_inc_tree_mod_seq(struct btrfs_fs_info *fs_info)
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
@@ -420,7 +400,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	 * anything that's lower than the lowest existing (read: blocked)
 	 * sequence number can be removed from the tree.
 	 */
-	tree_mod_log_write_lock(fs_info);
+	write_lock(&fs_info->tree_mod_log_lock);
 	tm_root = &fs_info->tree_mod_log;
 	for (node = rb_first(tm_root); node; node = next) {
 		next = rb_next(node);
@@ -430,7 +410,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 		rb_erase(node, tm_root);
 		kfree(tm);
 	}
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&fs_info->tree_mod_log_lock);
 }
 
 /*
@@ -441,7 +421,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
  * operations, or the shifted logical of the affected block for all other
  * operations.
  *
- * Note: must be called with write lock (tree_mod_log_write_lock).
+ * Note: must be called with write lock for fs_info::tree_mod_log_lock.
  */
 static noinline int
 __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
@@ -481,7 +461,7 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
  * Determines if logging can be omitted. Returns 1 if it can. Otherwise, it
  * returns zero with the tree_mod_log_lock acquired. The caller must hold
  * this until all tree mod log insertions are recorded in the rb tree and then
- * call tree_mod_log_write_unlock() to release.
+ * write unlock fs_info::tree_mod_log_lock.
  */
 static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
 				    struct extent_buffer *eb) {
@@ -491,9 +471,9 @@ static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
 	if (eb && btrfs_header_level(eb) == 0)
 		return 1;
 
-	tree_mod_log_write_lock(fs_info);
+	write_lock(&fs_info->tree_mod_log_lock);
 	if (list_empty(&(fs_info)->tree_mod_seq_list)) {
-		tree_mod_log_write_unlock(fs_info);
+		write_unlock(&fs_info->tree_mod_log_lock);
 		return 1;
 	}
 
@@ -557,7 +537,7 @@ tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = __tree_mod_log_insert(fs_info, tm);
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&eb->fs_info->tree_mod_log_lock);
 	if (ret)
 		kfree(tm);
 
@@ -621,7 +601,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	ret = __tree_mod_log_insert(fs_info, tm);
 	if (ret)
 		goto free_tms;
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&eb->fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 
 	return 0;
@@ -632,7 +612,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 		kfree(tm_list[i]);
 	}
 	if (locked)
-		tree_mod_log_write_unlock(fs_info);
+		write_unlock(&eb->fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 	kfree(tm);
 
@@ -713,7 +693,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	if (!ret)
 		ret = __tree_mod_log_insert(fs_info, tm);
 
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&fs_info->tree_mod_log_lock);
 	if (ret)
 		goto free_tms;
 	kfree(tm_list);
@@ -741,7 +721,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 	struct tree_mod_elem *found = NULL;
 	u64 index = start >> PAGE_CACHE_SHIFT;
 
-	tree_mod_log_read_lock(fs_info);
+	read_lock(&fs_info->tree_mod_log_lock);
 	tm_root = &fs_info->tree_mod_log;
 	node = tm_root->rb_node;
 	while (node) {
@@ -769,7 +749,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 			break;
 		}
 	}
-	tree_mod_log_read_unlock(fs_info);
+	read_unlock(&fs_info->tree_mod_log_lock);
 
 	return found;
 }
@@ -850,7 +830,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 			goto free_tms;
 	}
 
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 
 	return 0;
@@ -862,7 +842,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		kfree(tm_list[i]);
 	}
 	if (locked)
-		tree_mod_log_write_unlock(fs_info);
+		write_unlock(&fs_info->tree_mod_log_lock);
 	kfree(tm_list);
 
 	return ret;
@@ -922,7 +902,7 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 		goto free_tms;
 
 	ret = __tree_mod_log_free_eb(fs_info, tm_list, nritems);
-	tree_mod_log_write_unlock(fs_info);
+	write_unlock(&eb->fs_info->tree_mod_log_lock);
 	if (ret)
 		goto free_tms;
 	kfree(tm_list);
@@ -1284,7 +1264,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 	unsigned long p_size = sizeof(struct btrfs_key_ptr);
 
 	n = btrfs_header_nritems(eb);
-	tree_mod_log_read_lock(fs_info);
+	read_lock(&fs_info->tree_mod_log_lock);
 	while (tm && tm->seq >= time_seq) {
 		/*
 		 * all the operations are recorded with the operator used for
@@ -1339,7 +1319,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		if (tm->index != first_tm->index)
 			break;
 	}
-	tree_mod_log_read_unlock(fs_info);
+	read_unlock(&fs_info->tree_mod_log_lock);
 	btrfs_set_header_nritems(eb, n);
 }
 
-- 
2.20.1



