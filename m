Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0F6648AA
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbjAJSNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbjAJSM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:12:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BC913F11
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0EA0B818FB
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21335C433EF;
        Tue, 10 Jan 2023 18:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374290;
        bh=LNWYlUCy0MOi3iBUdkwCPI9cQM40ZRYmj8Gt68j/1ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DQV02okFKjvM/t0bk8d71QFkQuIkNkFJ5ZbJ8+9HXIF6cMR7fSfG7e7ehoEcu9pQ
         Th3Q8D31Mvh4mKGY4KZzdhB0wH2Wda4G1EC4aqknRBBFfWt/Wj0NBrHepdZeNmBiJt
         RLUTj5h5XqqWkN73rlmL9p/hbzKnHOyNvkEBUn0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 118/148] btrfs: separate BLOCK_GROUP_TREE compat RO flag from EXTENT_TREE_V2
Date:   Tue, 10 Jan 2023 19:03:42 +0100
Message-Id: <20230110180020.940361866@linuxfoundation.org>
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

[ Upstream commit 1c56ab991903dce60e905a08f431c0e6f79b9b9e ]

The problem of long mount time caused by block group item search is
already known for some time, and the solution of block group tree has
been proposed.

There is really no need to bound this feature into extent tree v2, just
introduce compat RO flag, BLOCK_GROUP_TREE, to correctly solve the
problem.

All the code handling block group root is already in the upstream
kernel, thus this patch really only needs to introduce the new compat RO
flag.

This patch introduces one extra artificial limitation on block group
tree feature, that free space cache v2 and no-holes feature must be
enabled to use this new compat RO feature.

This artificial requirement is mostly to reduce the test combinations,
and can be a guideline for future features, to mostly rely on the latest
default features.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 2ba48b20049b ("btrfs: fix compat_ro checks against remount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h           |  3 ++-
 fs/btrfs/disk-io.c         | 26 ++++++++++++++------------
 fs/btrfs/disk-io.h         |  2 +-
 fs/btrfs/sysfs.c           |  2 ++
 include/uapi/linux/btrfs.h |  6 ++++++
 5 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6b1a8b295970..8e77acdecd25 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -302,7 +302,8 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
 #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
 	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
 	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID | \
-	 BTRFS_FEATURE_COMPAT_RO_VERITY)
+	 BTRFS_FEATURE_COMPAT_RO_VERITY |		\
+	 BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE)
 
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a4f78a347a1f..386039e13922 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1983,7 +1983,7 @@ static void backup_super_roots(struct btrfs_fs_info *info)
 	btrfs_set_backup_chunk_root_level(root_backup,
 			       btrfs_header_level(info->chunk_root->node));
 
-	if (!btrfs_fs_incompat(info, EXTENT_TREE_V2)) {
+	if (!btrfs_fs_compat_ro(info, BLOCK_GROUP_TREE)) {
 		struct btrfs_root *extent_root = btrfs_extent_root(info, 0);
 		struct btrfs_root *csum_root = btrfs_csum_root(info, 0);
 
@@ -2528,7 +2528,7 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 	location.type = BTRFS_ROOT_ITEM_KEY;
 	location.offset = 0;
 
-	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
+	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE)) {
 		location.objectid = BTRFS_BLOCK_GROUP_TREE_OBJECTID;
 		root = btrfs_read_tree_root(tree_root, &location);
 		if (IS_ERR(root)) {
@@ -2715,6 +2715,18 @@ int btrfs_validate_super(struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
+	/*
+	 * Artificial requirement for block-group-tree to force newer features
+	 * (free-space-tree, no-holes) so the test matrix is smaller.
+	 */
+	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE) &&
+	    (!btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID) ||
+	     !btrfs_fs_incompat(fs_info, NO_HOLES))) {
+		btrfs_err(fs_info,
+		"block-group-tree feature requires fres-space-tree and no-holes");
+		ret = -EINVAL;
+	}
+
 	if (memcmp(fs_info->fs_devices->metadata_uuid, sb->dev_item.fsid,
 		   BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
@@ -2884,16 +2896,6 @@ static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
 	int ret = 0;
 	int i;
 
-	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
-		struct btrfs_root *root;
-
-		root = btrfs_alloc_root(fs_info, BTRFS_BLOCK_GROUP_TREE_OBJECTID,
-					GFP_KERNEL);
-		if (!root)
-			return -ENOMEM;
-		fs_info->block_group_root = root;
-	}
-
 	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
 		if (handle_error) {
 			if (!IS_ERR(tree_root->node))
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index aef981de672c..7e545ec09a10 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -105,7 +105,7 @@ static inline struct btrfs_root *btrfs_grab_root(struct btrfs_root *root)
 
 static inline struct btrfs_root *btrfs_block_group_root(struct btrfs_fs_info *fs_info)
 {
-	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2))
+	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE))
 		return fs_info->block_group_root;
 	return btrfs_extent_root(fs_info, 0);
 }
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 00b97e6eb507..897367ba68d2 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -286,6 +286,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_INCOMPAT(metadata_uuid, METADATA_UUID);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
+BTRFS_FEAT_ATTR_COMPAT_RO(block_group_tree, BLOCK_GROUP_TREE);
 BTRFS_FEAT_ATTR_INCOMPAT(raid1c34, RAID1C34);
 #ifdef CONFIG_BLK_DEV_ZONED
 BTRFS_FEAT_ATTR_INCOMPAT(zoned, ZONED);
@@ -317,6 +318,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(metadata_uuid),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
 	BTRFS_FEAT_ATTR_PTR(raid1c34),
+	BTRFS_FEAT_ATTR_PTR(block_group_tree),
 #ifdef CONFIG_BLK_DEV_ZONED
 	BTRFS_FEAT_ATTR_PTR(zoned),
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 7ada84e4a3ed..5655e89b962b 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -290,6 +290,12 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
 #define BTRFS_FEATURE_COMPAT_RO_VERITY			(1ULL << 2)
 
+/*
+ * Put all block group items into a dedicated block group tree, greatly
+ * reducing mount time for large filesystem due to better locality.
+ */
+#define BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE	(1ULL << 3)
+
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
-- 
2.35.1



