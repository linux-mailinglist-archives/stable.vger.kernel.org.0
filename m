Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD65AAF84
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237055AbiIBMkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237378AbiIBMj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:39:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94D7C46;
        Fri,  2 Sep 2022 05:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D387B82AA7;
        Fri,  2 Sep 2022 12:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A7BC433D7;
        Fri,  2 Sep 2022 12:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121848;
        bh=dxxxXMPTlbcdYf3HhBHrcAH67i6aFZ1wVpRrYhiAmF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r48RLpYulOqwmDb+h5b1DGMG20vaUGHRZD/9lhs6hV4qlE0QbKmxNFK4UjsEdxYnG
         X/aAZ152Argl7UGts0HaoJdGrY5B4VQmTkl6ITa52BxCcSv7OviQ434Dv29Mozzexv
         3VeKnuleBE/4RCRisfElUcLNyG2mUoxE4ug+8iTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/77] btrfs: unify lookup return value when dir entry is missing
Date:   Fri,  2 Sep 2022 14:19:13 +0200
Message-Id: <20220902121405.804936802@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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

[ Upstream commit 8dcbc26194eb872cc3430550fb70bb461424d267 ]

btrfs_lookup_dir_index_item() and btrfs_lookup_dir_item() lookup for dir
entries and both are used during log replay or when updating a log tree
during an unlink.

However when the dir item does not exists, btrfs_lookup_dir_item() returns
NULL while btrfs_lookup_dir_index_item() returns PTR_ERR(-ENOENT), and if
the dir item exists but there is no matching entry for a given name or
index, both return NULL. This makes the call sites during log replay to
be more verbose than necessary and it makes it easy to miss this slight
difference. Since we don't need to distinguish between those two cases,
make btrfs_lookup_dir_index_item() always return NULL when there is no
matching directory entry - either because there isn't any dir entry or
because there is one but it does not match the given name and index.

Also rename the argument 'objectid' of btrfs_lookup_dir_index_item() to
'index' since it is supposed to match an index number, and the name
'objectid' is not very good because it can easily be confused with an
inode number (like the inode number a dir entry points to).

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h    |  2 +-
 fs/btrfs/dir-item.c | 48 ++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/tree-log.c | 14 ++++---------
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cd77c0621a555..c2e5fe972f566 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2727,7 +2727,7 @@ struct btrfs_dir_item *
 btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dir,
-			    u64 objectid, const char *name, int name_len,
+			    u64 index, const char *name, int name_len,
 			    int mod);
 struct btrfs_dir_item *
 btrfs_search_dir_index_item(struct btrfs_root *root,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 1c0a7cd6b9b0a..98c6faa8ce15b 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -191,9 +191,20 @@ static struct btrfs_dir_item *btrfs_lookup_match_dir(
 }
 
 /*
- * lookup a directory item based on name.  'dir' is the objectid
- * we're searching in, and 'mod' tells us if you plan on deleting the
- * item (use mod < 0) or changing the options (use mod > 0)
+ * Lookup for a directory item by name.
+ *
+ * @trans:	The transaction handle to use. Can be NULL if @mod is 0.
+ * @root:	The root of the target tree.
+ * @path:	Path to use for the search.
+ * @dir:	The inode number (objectid) of the directory.
+ * @name:	The name associated to the directory entry we are looking for.
+ * @name_len:	The length of the name.
+ * @mod:	Used to indicate if the tree search is meant for a read only
+ *		lookup, for a modification lookup or for a deletion lookup, so
+ *		its value should be 0, 1 or -1, respectively.
+ *
+ * Returns: NULL if the dir item does not exists, an error pointer if an error
+ * happened, or a pointer to a dir item if a dir item exists for the given name.
  */
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
@@ -274,27 +285,42 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 }
 
 /*
- * lookup a directory item based on index.  'dir' is the objectid
- * we're searching in, and 'mod' tells us if you plan on deleting the
- * item (use mod < 0) or changing the options (use mod > 0)
+ * Lookup for a directory index item by name and index number.
  *
- * The name is used to make sure the index really points to the name you were
- * looking for.
+ * @trans:	The transaction handle to use. Can be NULL if @mod is 0.
+ * @root:	The root of the target tree.
+ * @path:	Path to use for the search.
+ * @dir:	The inode number (objectid) of the directory.
+ * @index:	The index number.
+ * @name:	The name associated to the directory entry we are looking for.
+ * @name_len:	The length of the name.
+ * @mod:	Used to indicate if the tree search is meant for a read only
+ *		lookup, for a modification lookup or for a deletion lookup, so
+ *		its value should be 0, 1 or -1, respectively.
+ *
+ * Returns: NULL if the dir index item does not exists, an error pointer if an
+ * error happened, or a pointer to a dir item if the dir index item exists and
+ * matches the criteria (name and index number).
  */
 struct btrfs_dir_item *
 btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dir,
-			    u64 objectid, const char *name, int name_len,
+			    u64 index, const char *name, int name_len,
 			    int mod)
 {
+	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_INDEX_KEY;
-	key.offset = objectid;
+	key.offset = index;
 
-	return btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	di = btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	if (di == ERR_PTR(-ENOENT))
+		return NULL;
+
+	return di;
 }
 
 struct btrfs_dir_item *
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index bebd74267bed6..926b1d34e55cc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -918,8 +918,7 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 	di = btrfs_lookup_dir_index_item(NULL, root, path, dirid,
 					 index, name, name_len, 0);
 	if (IS_ERR(di)) {
-		if (PTR_ERR(di) != -ENOENT)
-			ret = PTR_ERR(di);
+		ret = PTR_ERR(di);
 		goto out;
 	} else if (di) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
@@ -1171,8 +1170,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
 					 ref_index, name, namelen, 0);
 	if (IS_ERR(di)) {
-		if (PTR_ERR(di) != -ENOENT)
-			return PTR_ERR(di);
+		return PTR_ERR(di);
 	} else if (di) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
 		if (ret)
@@ -2022,9 +2020,6 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	if (dst_di == ERR_PTR(-ENOENT))
-		dst_di = NULL;
-
 	if (IS_ERR(dst_di)) {
 		ret = PTR_ERR(dst_di);
 		goto out;
@@ -2309,7 +2304,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 						     dir_key->offset,
 						     name, name_len, 0);
 		}
-		if (!log_di || log_di == ERR_PTR(-ENOENT)) {
+		if (!log_di) {
 			btrfs_dir_item_key_to_cpu(eb, di, &location);
 			btrfs_release_path(path);
 			btrfs_release_path(log_path);
@@ -3522,8 +3517,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (err == -ENOSPC) {
 		btrfs_set_log_full_commit(trans);
 		err = 0;
-	} else if (err < 0 && err != -ENOENT) {
-		/* ENOENT can be returned if the entry hasn't been fsynced yet */
+	} else if (err < 0) {
 		btrfs_abort_transaction(trans, err);
 	}
 
-- 
2.35.1



