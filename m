Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A15AAFC8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbiIBMoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbiIBMnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B41AE115C;
        Fri,  2 Sep 2022 05:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCAC6217A;
        Fri,  2 Sep 2022 12:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63484C433C1;
        Fri,  2 Sep 2022 12:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121841;
        bh=/pLes/ZYaRkDgTtjtjwyJmOWv8M+asLRXrofEb6ZSho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5rXAc+t1QBZ990Rm0ysxHFCYO3/xoIikMRhAtPjTLpA669fa0IexP+GP7xplRsYg
         e9vIAmwimEtcNEvvFq1H5vlC77Ce0kt/4Ajwv6Zh6VQOvCoBzpKBQ0LruJ33k+uD5v
         0o9389YP5LC5oUMV1oscUGZOJOYfz/cwa3Cd3oys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/77] btrfs: introduce btrfs_lookup_match_dir
Date:   Fri,  2 Sep 2022 14:19:11 +0200
Message-Id: <20220902121405.741653606@linuxfoundation.org>
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

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[ Upstream commit a7d1c5dc8632e9b370ad26478c468d4e4e29f263 ]

btrfs_search_slot is called in multiple places in dir-item.c to search
for a dir entry, and then calling btrfs_match_dir_name to return a
btrfs_dir_item.

In order to reduce the number of callers of btrfs_search_slot, create a
common function that looks for the dir key, and if found call
btrfs_match_dir_item_name.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dir-item.c | 76 +++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 863367c2c6205..1c0a7cd6b9b0a 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -171,6 +171,25 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, const char *name,
 	return 0;
 }
 
+static struct btrfs_dir_item *btrfs_lookup_match_dir(
+			struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, struct btrfs_path *path,
+			struct btrfs_key *key, const char *name,
+			int name_len, int mod)
+{
+	const int ins_len = (mod < 0 ? -1 : 0);
+	const int cow = (mod != 0);
+	int ret;
+
+	ret = btrfs_search_slot(trans, root, key, path, ins_len, cow);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0)
+		return ERR_PTR(-ENOENT);
+
+	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+}
+
 /*
  * lookup a directory item based on name.  'dir' is the objectid
  * we're searching in, and 'mod' tells us if you plan on deleting the
@@ -182,23 +201,18 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     const char *name, int name_len,
 					     int mod)
 {
-	int ret;
 	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
+	struct btrfs_dir_item *di;
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_ITEM_KEY;
-
 	key.offset = btrfs_name_hash(name, name_len);
 
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
+	di = btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	if (IS_ERR(di) && PTR_ERR(di) == -ENOENT)
 		return NULL;
 
-	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+	return di;
 }
 
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
@@ -212,7 +226,6 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 	int slot;
 	struct btrfs_path *path;
 
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -221,20 +234,20 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(name, name_len);
 
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-
-	/* return back any errors */
-	if (ret < 0)
-		goto out;
+	di = btrfs_lookup_match_dir(NULL, root, path, &key, name, name_len, 0);
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		/* Nothing found, we're safe */
+		if (ret == -ENOENT) {
+			ret = 0;
+			goto out;
+		}
 
-	/* nothing found, we're safe */
-	if (ret > 0) {
-		ret = 0;
-		goto out;
+		if (ret < 0)
+			goto out;
 	}
 
 	/* we found an item, look for our name in the item */
-	di = btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
 	if (di) {
 		/* our exact name was found */
 		ret = -EEXIST;
@@ -275,21 +288,13 @@ btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    u64 objectid, const char *name, int name_len,
 			    int mod)
 {
-	int ret;
 	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = objectid;
 
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
-		return ERR_PTR(-ENOENT);
-	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+	return btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
 }
 
 struct btrfs_dir_item *
@@ -346,21 +351,18 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 					  const char *name, u16 name_len,
 					  int mod)
 {
-	int ret;
 	struct btrfs_key key;
-	int ins_len = mod < 0 ? -1 : 0;
-	int cow = mod != 0;
+	struct btrfs_dir_item *di;
 
 	key.objectid = dir;
 	key.type = BTRFS_XATTR_ITEM_KEY;
 	key.offset = btrfs_name_hash(name, name_len);
-	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	if (ret > 0)
+
+	di = btrfs_lookup_match_dir(trans, root, path, &key, name, name_len, mod);
+	if (IS_ERR(di) && PTR_ERR(di) == -ENOENT)
 		return NULL;
 
-	return btrfs_match_dir_item_name(root->fs_info, path, name, name_len);
+	return di;
 }
 
 /*
-- 
2.35.1



