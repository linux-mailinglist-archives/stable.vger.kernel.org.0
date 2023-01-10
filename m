Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724336648A9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbjAJSNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbjAJSM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:12:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9993392EB
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6A161866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFF5C433D2;
        Tue, 10 Jan 2023 18:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374287;
        bh=6xBLK/vxGsRr/YngLXvQxTMpWB3M/uwGvWk9InodsZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEjm9lMj5xdYzeMI7hBGhlFPOolQyQaAV55c1K27QvWaPoKMdnBL5Zwje8xGPJ9Fy
         qizTMHvZ8g2jpDfOvMtdvtWnM6gADyN4M0pTfDmoMLiD4BMkmZnfVK0fs5T/nw+R1P
         Zd3m/9O5gPaslAXVE4rIWnOY8dXeso9vERWNO04U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 117/148] btrfs: dont save block group root into super block
Date:   Tue, 10 Jan 2023 19:03:41 +0100
Message-Id: <20230110180020.909769414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 14033b08a02916e85ffc5397e4ac15337359f3ae ]

The extent tree v2 needs a new root for storing all block group items,
the whole feature hasn't been finished yet so we can afford to do some
changes.

My initial proposal years ago just added a new tree rootid, and load it
from tree root, just like what we did for quota/free space tree/uuid/extent
roots.

But the extent tree v2 patches introduced a completely new way to store
block group tree root into super block which is arguably wasteful.

Currently there are only 3 trees stored in super blocks, and they all
have their valid reasons:

- Chunk root
  Needed for bootstrap.

- Tree root
  Really the entry point for all trees.

- Log root
  This is special as log root has to be updated out of existing
  transaction mechanism.

There is not even any reason to put block group root into super blocks,
the block group tree is updated at the same time as the old extent tree,
no need for extra bootstrap/out-of-transaction update.

So just move block group root from super block into tree root.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 2ba48b20049b ("btrfs: fix compat_ro checks against remount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-rsv.c   |  1 +
 fs/btrfs/ctree.h       | 27 ++-------------------------
 fs/btrfs/disk-io.c     | 40 ++++++++++++++++++++--------------------
 fs/btrfs/transaction.c |  8 --------
 4 files changed, 23 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 06be0644dd37..6ce704d3bdd2 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -424,6 +424,7 @@ void btrfs_init_root_block_rsv(struct btrfs_root *root)
 	case BTRFS_CSUM_TREE_OBJECTID:
 	case BTRFS_EXTENT_TREE_OBJECTID:
 	case BTRFS_FREE_SPACE_TREE_OBJECTID:
+	case BTRFS_BLOCK_GROUP_TREE_OBJECTID:
 		root->block_rsv = &fs_info->delayed_refs_rsv;
 		break;
 	case BTRFS_ROOT_TREE_OBJECTID:
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bad06add93d7..6b1a8b295970 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -280,14 +280,9 @@ struct btrfs_super_block {
 	/* the UUID written into btree blocks */
 	u8 metadata_uuid[BTRFS_FSID_SIZE];
 
-	/* Extent tree v2 */
-	__le64 block_group_root;
-	__le64 block_group_root_generation;
-	u8 block_group_root_level;
-
 	/* future expansion */
-	u8 reserved8[7];
-	__le64 reserved[25];
+	u8 reserved8[8];
+	__le64 reserved[27];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 
@@ -2391,17 +2386,6 @@ BTRFS_SETGET_STACK_FUNCS(backup_bytes_used, struct btrfs_root_backup,
 BTRFS_SETGET_STACK_FUNCS(backup_num_devices, struct btrfs_root_backup,
 		   num_devices, 64);
 
-/*
- * For extent tree v2 we overload the extent root with the block group root, as
- * we will have multiple extent roots.
- */
-BTRFS_SETGET_STACK_FUNCS(backup_block_group_root, struct btrfs_root_backup,
-			 extent_root, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_block_group_root_gen, struct btrfs_root_backup,
-			 extent_root_gen, 64);
-BTRFS_SETGET_STACK_FUNCS(backup_block_group_root_level,
-			 struct btrfs_root_backup, extent_root_level, 8);
-
 /* struct btrfs_balance_item */
 BTRFS_SETGET_FUNCS(balance_flags, struct btrfs_balance_item, flags, 64);
 
@@ -2534,13 +2518,6 @@ BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_super_block, magic, 64);
 BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
 			 uuid_tree_generation, 64);
-BTRFS_SETGET_STACK_FUNCS(super_block_group_root, struct btrfs_super_block,
-			 block_group_root, 64);
-BTRFS_SETGET_STACK_FUNCS(super_block_group_root_generation,
-			 struct btrfs_super_block,
-			 block_group_root_generation, 64);
-BTRFS_SETGET_STACK_FUNCS(super_block_group_root_level, struct btrfs_super_block,
-			 block_group_root_level, 8);
 
 int btrfs_super_csum_size(const struct btrfs_super_block *s);
 const char *btrfs_super_csum_name(u16 csum_type);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c72074a234d2..a4f78a347a1f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1524,6 +1524,9 @@ static struct btrfs_root *btrfs_get_global_root(struct btrfs_fs_info *fs_info,
 	if (objectid == BTRFS_UUID_TREE_OBJECTID)
 		return btrfs_grab_root(fs_info->uuid_root) ?
 			fs_info->uuid_root : ERR_PTR(-ENOENT);
+	if (objectid == BTRFS_BLOCK_GROUP_TREE_OBJECTID)
+		return btrfs_grab_root(fs_info->block_group_root) ?
+			fs_info->block_group_root : ERR_PTR(-ENOENT);
 	if (objectid == BTRFS_FREE_SPACE_TREE_OBJECTID) {
 		struct btrfs_root *root = btrfs_global_root(fs_info, &key);
 
@@ -1980,14 +1983,7 @@ static void backup_super_roots(struct btrfs_fs_info *info)
 	btrfs_set_backup_chunk_root_level(root_backup,
 			       btrfs_header_level(info->chunk_root->node));
 
-	if (btrfs_fs_incompat(info, EXTENT_TREE_V2)) {
-		btrfs_set_backup_block_group_root(root_backup,
-					info->block_group_root->node->start);
-		btrfs_set_backup_block_group_root_gen(root_backup,
-			btrfs_header_generation(info->block_group_root->node));
-		btrfs_set_backup_block_group_root_level(root_backup,
-			btrfs_header_level(info->block_group_root->node));
-	} else {
+	if (!btrfs_fs_incompat(info, EXTENT_TREE_V2)) {
 		struct btrfs_root *extent_root = btrfs_extent_root(info, 0);
 		struct btrfs_root *csum_root = btrfs_csum_root(info, 0);
 
@@ -2529,10 +2525,24 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 	if (ret)
 		return ret;
 
-	location.objectid = BTRFS_DEV_TREE_OBJECTID;
 	location.type = BTRFS_ROOT_ITEM_KEY;
 	location.offset = 0;
 
+	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
+		location.objectid = BTRFS_BLOCK_GROUP_TREE_OBJECTID;
+		root = btrfs_read_tree_root(tree_root, &location);
+		if (IS_ERR(root)) {
+			if (!btrfs_test_opt(fs_info, IGNOREBADROOTS)) {
+				ret = PTR_ERR(root);
+				goto out;
+			}
+		} else {
+			set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+			fs_info->block_group_root = root;
+		}
+	}
+
+	location.objectid = BTRFS_DEV_TREE_OBJECTID;
 	root = btrfs_read_tree_root(tree_root, &location);
 	if (IS_ERR(root)) {
 		if (!btrfs_test_opt(fs_info, IGNOREBADROOTS)) {
@@ -2862,17 +2872,7 @@ static int load_important_roots(struct btrfs_fs_info *fs_info)
 		btrfs_warn(fs_info, "couldn't read tree root");
 		return ret;
 	}
-
-	if (!btrfs_fs_incompat(fs_info, EXTENT_TREE_V2))
-		return 0;
-
-	bytenr = btrfs_super_block_group_root(sb);
-	gen = btrfs_super_block_group_root_generation(sb);
-	level = btrfs_super_block_group_root_level(sb);
-	ret = load_super_root(fs_info->block_group_root, bytenr, gen, level);
-	if (ret)
-		btrfs_warn(fs_info, "couldn't read block group root");
-	return ret;
+	return 0;
 }
 
 static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0bec10740ad3..8fab3b274957 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1912,14 +1912,6 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
 		super->cache_generation = 0;
 	if (test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))
 		super->uuid_tree_generation = root_item->generation;
-
-	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
-		root_item = &fs_info->block_group_root->root_item;
-
-		super->block_group_root = root_item->bytenr;
-		super->block_group_root_generation = root_item->generation;
-		super->block_group_root_level = root_item->level;
-	}
 }
 
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
-- 
2.35.1



