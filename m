Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93C85AB1CC
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiIBNlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237782AbiIBNk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:40:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE164161DDF;
        Fri,  2 Sep 2022 06:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED768B829E0;
        Fri,  2 Sep 2022 12:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF923C433B5;
        Fri,  2 Sep 2022 12:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121977;
        bh=ziVxvl07FZJezI/7I9ibZmcYd2eWyl3wZ1FTUaU40Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwj1ZKvDGcsH0xNNrN/5ObN9LAXqGPnKnBAQwWzvv1XLxJw16PtVAM8iYQw7kcoKO
         00mV47WLXgBV3l96ysZ1AYPQQjJp8/GbLyosBFxrBNdKXwVLH+r8WR0meyOi+XcV0S
         WfcxUdofB/8TODTFLBOX7v35P/LMzrWtTl9zAw5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/73] btrfs: remove no longer needed logic for replaying directory deletes
Date:   Fri,  2 Sep 2022 14:19:11 +0200
Message-Id: <20220902121406.013105463@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ccae4a19c9140a34a0c5f0658812496dd8bbdeaf ]

Now that we log only dir index keys when logging a directory, we no longer
need to deal with dir item keys in the log replay code for replaying
directory deletes. This is also true for the case when we replay a log
tree created by a kernel that still logs dir items.

So remove the remaining code of the replay of directory deletes algorithm
that deals with dir item keys.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c             | 158 ++++++++++++++------------------
 include/uapi/linux/btrfs_tree.h |   4 +-
 2 files changed, 72 insertions(+), 90 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6f51c4d922d48..4ab1bbc344760 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2197,7 +2197,7 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
  */
 static noinline int find_dir_range(struct btrfs_root *root,
 				   struct btrfs_path *path,
-				   u64 dirid, int key_type,
+				   u64 dirid,
 				   u64 *start_ret, u64 *end_ret)
 {
 	struct btrfs_key key;
@@ -2210,7 +2210,7 @@ static noinline int find_dir_range(struct btrfs_root *root,
 		return 1;
 
 	key.objectid = dirid;
-	key.type = key_type;
+	key.type = BTRFS_DIR_LOG_INDEX_KEY;
 	key.offset = *start_ret;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -2224,7 +2224,7 @@ static noinline int find_dir_range(struct btrfs_root *root,
 	if (ret != 0)
 		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 
-	if (key.type != key_type || key.objectid != dirid) {
+	if (key.type != BTRFS_DIR_LOG_INDEX_KEY || key.objectid != dirid) {
 		ret = 1;
 		goto next;
 	}
@@ -2251,7 +2251,7 @@ static noinline int find_dir_range(struct btrfs_root *root,
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 
-	if (key.type != key_type || key.objectid != dirid) {
+	if (key.type != BTRFS_DIR_LOG_INDEX_KEY || key.objectid != dirid) {
 		ret = 1;
 		goto out;
 	}
@@ -2282,95 +2282,82 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 	int ret;
 	struct extent_buffer *eb;
 	int slot;
-	u32 item_size;
 	struct btrfs_dir_item *di;
-	struct btrfs_dir_item *log_di;
 	int name_len;
-	unsigned long ptr;
-	unsigned long ptr_end;
 	char *name;
-	struct inode *inode;
+	struct inode *inode = NULL;
 	struct btrfs_key location;
 
-again:
+	/*
+	 * Currenly we only log dir index keys. Even if we replay a log created
+	 * by an older kernel that logged both dir index and dir item keys, all
+	 * we need to do is process the dir index keys, we (and our caller) can
+	 * safely ignore dir item keys (key type BTRFS_DIR_ITEM_KEY).
+	 */
+	ASSERT(dir_key->type == BTRFS_DIR_INDEX_KEY);
+
 	eb = path->nodes[0];
 	slot = path->slots[0];
-	item_size = btrfs_item_size_nr(eb, slot);
-	ptr = btrfs_item_ptr_offset(eb, slot);
-	ptr_end = ptr + item_size;
-	while (ptr < ptr_end) {
-		di = (struct btrfs_dir_item *)ptr;
-		name_len = btrfs_dir_name_len(eb, di);
-		name = kmalloc(name_len, GFP_NOFS);
-		if (!name) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		read_extent_buffer(eb, name, (unsigned long)(di + 1),
-				  name_len);
-		log_di = NULL;
-		if (log && dir_key->type == BTRFS_DIR_ITEM_KEY) {
-			log_di = btrfs_lookup_dir_item(trans, log, log_path,
-						       dir_key->objectid,
-						       name, name_len, 0);
-		} else if (log && dir_key->type == BTRFS_DIR_INDEX_KEY) {
-			log_di = btrfs_lookup_dir_index_item(trans, log,
-						     log_path,
-						     dir_key->objectid,
-						     dir_key->offset,
-						     name, name_len, 0);
-		}
-		if (!log_di) {
-			btrfs_dir_item_key_to_cpu(eb, di, &location);
-			btrfs_release_path(path);
-			btrfs_release_path(log_path);
-			inode = read_one_inode(root, location.objectid);
-			if (!inode) {
-				kfree(name);
-				return -EIO;
-			}
+	di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
+	name_len = btrfs_dir_name_len(eb, di);
+	name = kmalloc(name_len, GFP_NOFS);
+	if (!name) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-			ret = link_to_fixup_dir(trans, root,
-						path, location.objectid);
-			if (ret) {
-				kfree(name);
-				iput(inode);
-				goto out;
-			}
+	read_extent_buffer(eb, name, (unsigned long)(di + 1), name_len);
 
-			inc_nlink(inode);
-			ret = btrfs_unlink_inode(trans, BTRFS_I(dir),
-					BTRFS_I(inode), name, name_len);
-			if (!ret)
-				ret = btrfs_run_delayed_items(trans);
-			kfree(name);
-			iput(inode);
-			if (ret)
-				goto out;
+	if (log) {
+		struct btrfs_dir_item *log_di;
 
-			/* there might still be more names under this key
-			 * check and repeat if required
-			 */
-			ret = btrfs_search_slot(NULL, root, dir_key, path,
-						0, 0);
-			if (ret == 0)
-				goto again;
+		log_di = btrfs_lookup_dir_index_item(trans, log, log_path,
+						     dir_key->objectid,
+						     dir_key->offset,
+						     name, name_len, 0);
+		if (IS_ERR(log_di)) {
+			ret = PTR_ERR(log_di);
+			goto out;
+		} else if (log_di) {
+			/* The dentry exists in the log, we have nothing to do. */
 			ret = 0;
 			goto out;
-		} else if (IS_ERR(log_di)) {
-			kfree(name);
-			return PTR_ERR(log_di);
 		}
-		btrfs_release_path(log_path);
-		kfree(name);
+	}
 
-		ptr = (unsigned long)(di + 1);
-		ptr += name_len;
+	btrfs_dir_item_key_to_cpu(eb, di, &location);
+	btrfs_release_path(path);
+	btrfs_release_path(log_path);
+	inode = read_one_inode(root, location.objectid);
+	if (!inode) {
+		ret = -EIO;
+		goto out;
 	}
-	ret = 0;
+
+	ret = link_to_fixup_dir(trans, root, path, location.objectid);
+	if (ret)
+		goto out;
+
+	inc_nlink(inode);
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(inode), name,
+				 name_len);
+	if (ret)
+		goto out;
+
+	ret = btrfs_run_delayed_items(trans);
+	if (ret)
+		goto out;
+
+	/*
+	 * Unlike dir item keys, dir index keys can only have one name (entry) in
+	 * them, as there are no key collisions since each key has a unique offset
+	 * (an index number), so we're done.
+	 */
 out:
 	btrfs_release_path(path);
 	btrfs_release_path(log_path);
+	kfree(name);
+	iput(inode);
 	return ret;
 }
 
@@ -2490,7 +2477,6 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 {
 	u64 range_start;
 	u64 range_end;
-	int key_type = BTRFS_DIR_LOG_ITEM_KEY;
 	int ret = 0;
 	struct btrfs_key dir_key;
 	struct btrfs_key found_key;
@@ -2498,7 +2484,7 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 	struct inode *dir;
 
 	dir_key.objectid = dirid;
-	dir_key.type = BTRFS_DIR_ITEM_KEY;
+	dir_key.type = BTRFS_DIR_INDEX_KEY;
 	log_path = btrfs_alloc_path();
 	if (!log_path)
 		return -ENOMEM;
@@ -2512,14 +2498,14 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 		btrfs_free_path(log_path);
 		return 0;
 	}
-again:
+
 	range_start = 0;
 	range_end = 0;
 	while (1) {
 		if (del_all)
 			range_end = (u64)-1;
 		else {
-			ret = find_dir_range(log, path, dirid, key_type,
+			ret = find_dir_range(log, path, dirid,
 					     &range_start, &range_end);
 			if (ret < 0)
 				goto out;
@@ -2546,8 +2532,10 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 					      path->slots[0]);
 			if (found_key.objectid != dirid ||
-			    found_key.type != dir_key.type)
-				goto next_type;
+			    found_key.type != dir_key.type) {
+				ret = 0;
+				goto out;
+			}
 
 			if (found_key.offset > range_end)
 				break;
@@ -2566,15 +2554,7 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 			break;
 		range_start = range_end + 1;
 	}
-
-next_type:
 	ret = 0;
-	if (key_type == BTRFS_DIR_LOG_ITEM_KEY) {
-		key_type = BTRFS_DIR_LOG_INDEX_KEY;
-		dir_key.type = BTRFS_DIR_INDEX_KEY;
-		btrfs_release_path(path);
-		goto again;
-	}
 out:
 	btrfs_release_path(path);
 	btrfs_free_path(log_path);
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index e1c4c732aabac..5416f1f1a77a8 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -146,7 +146,9 @@
 
 /*
  * dir items are the name -> inode pointers in a directory.  There is one
- * for every name in a directory.
+ * for every name in a directory.  BTRFS_DIR_LOG_ITEM_KEY is no longer used
+ * but it's still defined here for documentation purposes and to help avoid
+ * having its numerical value reused in the future.
  */
 #define BTRFS_DIR_LOG_ITEM_KEY  60
 #define BTRFS_DIR_LOG_INDEX_KEY 72
-- 
2.35.1



