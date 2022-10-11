Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59BA5FB56D
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiJKOyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiJKOxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9FA9835C;
        Tue, 11 Oct 2022 07:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13E4611C9;
        Tue, 11 Oct 2022 14:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712BFC433D7;
        Tue, 11 Oct 2022 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499879;
        bh=ptHK7WdZqSkQiDDJdholcrf68LBw0lFkm2ozn3wgcMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJw+r3Re9r2QEWNsvERZ1GmiIfQee1oPEoZURJ1uP/V0VtZg2QVq/RJYO6OPRRtKE
         Mlk9Z02fyAR8mTDP8WKMMmzcyVBaW2fdaUjof6/KL4aHYE231xPkr7TrbZXfqeZx5r
         EIkZI1O21t+tfU1cuk8r9EqdFcZl3GImAnNvejDukd8ZWUTYKZwIZ3qKkoL4ISr4PI
         bnq3Jw7yHX2Y1EEvY5AioyKJBJO5AY4ujCLcvxAyF1OM8pdJlv7F1pIs0eSd/9OFLE
         FDqDURbBIayzuRirJFnnxNGN/NfC4iDZa3RD37bQ+X99f6w1XtkpxlELdDRff+up0z
         Fh81WsNxKj1zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 41/46] btrfs: relax block-group-tree feature dependency checks
Date:   Tue, 11 Oct 2022 10:50:09 -0400
Message-Id: <20221011145015.1622882-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit d7f67ac9a928fa158a95573406eac0a887bbc28c ]

[BUG]
When one user did a wrong attempt to clear block group tree, which can
not be done through mount option, by using "-o clear_cache,space_cache=v2",
it will cause the following error on a fs with block-group-tree feature:

  BTRFS info (device dm-1): force clearing of disk cache
  BTRFS info (device dm-1): using free space tree
  BTRFS info (device dm-1): clearing free space tree
  BTRFS info (device dm-1): clearing compat-ro feature flag for FREE_SPACE_TREE (0x1)
  BTRFS info (device dm-1): clearing compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
  BTRFS error (device dm-1): block-group-tree feature requires fres-space-tree and no-holes
  BTRFS error (device dm-1): super block corruption detected before writing it to disk
  BTRFS: error (device dm-1) in write_all_supers:4318: errno=-117 Filesystem corrupted (unexpected superblock corruption detected)
  BTRFS warning (device dm-1: state E): Skipping commit of aborted transaction.

[CAUSE]
Although the dependency for block-group-tree feature is just an
artificial one (to reduce test matrix), we put the dependency check into
btrfs_validate_super().

This is too strict, and during space cache clearing, we will have a
window where free space tree is cleared, and we need to commit the super
block.

In that window, we had block group tree without v2 cache, and triggered
the artificial dependency check.

This is not necessary at all, especially for such a soft dependency.

[FIX]
Introduce a new helper, btrfs_check_features(), to do all the runtime
limitation checks, including:

- Unsupported incompat flags check

- Unsupported compat RO flags check

- Setting missing incompat flags

- Artificial feature dependency checks
  Currently only block group tree will rely on this.

- Subpage runtime check for v1 cache

With this helper, we can move quite some checks from
open_ctree()/btrfs_remount() into it, and just call it after
btrfs_parse_options().

Now "-o clear_cache,space_cache=v2" will not trigger the above error
anymore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ edit messages ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 172 ++++++++++++++++++++++++++++-----------------
 fs/btrfs/disk-io.h |   1 +
 fs/btrfs/super.c   |  10 +--
 3 files changed, 113 insertions(+), 70 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d9881b54efd1..0161f294f025 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3292,6 +3292,112 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Do various sanity and dependency checks of different features.
+ *
+ * This is the place for less strict checks (like for subpage or artificial
+ * feature dependencies).
+ *
+ * For strict checks or possible corruption detection, see
+ * btrfs_validate_super().
+ *
+ * This should be called after btrfs_parse_options(), as some mount options
+ * (space cache related) can modify on-disk format like free space tree and
+ * screw up certain feature dependencies.
+ */
+int btrfs_check_features(struct btrfs_fs_info *fs_info, struct super_block *sb)
+{
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	u64 incompat = btrfs_super_incompat_flags(disk_super);
+	const u64 compat_ro = btrfs_super_compat_ro_flags(disk_super);
+	const u64 compat_ro_unsupp = (compat_ro & ~BTRFS_FEATURE_COMPAT_RO_SUPP);
+
+	if (incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
+		btrfs_err(fs_info,
+		"cannot mount because of unknown incompat features (0x%llx)",
+		    incompat);
+		return -EINVAL;
+	}
+
+	/* Runtime limitation for mixed block groups. */
+	if ((incompat & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
+	    (fs_info->sectorsize != fs_info->nodesize)) {
+		btrfs_err(fs_info,
+"unequal nodesize/sectorsize (%u != %u) are not allowed for mixed block groups",
+			fs_info->nodesize, fs_info->sectorsize);
+		return -EINVAL;
+	}
+
+	/* Mixed backref is an always-enabled feature. */
+	incompat |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
+
+	/* Set compression related flags just in case. */
+	if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
+		incompat |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+	else if (fs_info->compress_type == BTRFS_COMPRESS_ZSTD)
+		incompat |= BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD;
+
+	/*
+	 * An ancient flag, which should really be marked deprecated.
+	 * Such runtime limitation doesn't really need a incompat flag.
+	 */
+	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE)
+		incompat |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
+
+	if (compat_ro_unsupp && !sb_rdonly(sb)) {
+		btrfs_err(fs_info,
+	"cannot mount read-write because of unknown compat_ro features (0x%llx)",
+		       compat_ro);
+		return -EINVAL;
+	}
+
+	/*
+	 * We have unsupported RO compat features, although RO mounted, we
+	 * should not cause any metadata writes, including log replay.
+	 * Or we could screw up whatever the new feature requires.
+	 */
+	if (compat_ro_unsupp && btrfs_super_log_root(disk_super) &&
+	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
+		btrfs_err(fs_info,
+"cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
+			  compat_ro);
+		return -EINVAL;
+	}
+
+	/*
+	 * Artificial limitations for block group tree, to force
+	 * block-group-tree to rely on no-holes and free-space-tree.
+	 */
+	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE) &&
+	    (!btrfs_fs_incompat(fs_info, NO_HOLES) ||
+	     !btrfs_test_opt(fs_info, FREE_SPACE_TREE))) {
+		btrfs_err(fs_info,
+"block-group-tree feature requires no-holes and free-space-tree features");
+		return -EINVAL;
+	}
+
+	/*
+	 * Subpage runtime limitation on v1 cache.
+	 *
+	 * V1 space cache still has some hard codeed PAGE_SIZE usage, while
+	 * we're already defaulting to v2 cache, no need to bother v1 as it's
+	 * going to be deprecated anyway.
+	 */
+	if (fs_info->sectorsize < PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+		btrfs_warn(fs_info,
+	"v1 space cache is not supported for page size %lu with sectorsize %u",
+			   PAGE_SIZE, fs_info->sectorsize);
+		return -EINVAL;
+	}
+
+	/* This can be called by remount, we need to protect the super block. */
+	spin_lock(&fs_info->super_lock);
+	btrfs_set_super_incompat_flags(disk_super, incompat);
+	spin_unlock(&fs_info->super_lock);
+
+	return 0;
+}
+
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices,
 		      char *options)
 {
@@ -3441,72 +3547,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_alloc;
 	}
 
-	features = btrfs_super_incompat_flags(disk_super) &
-		~BTRFS_FEATURE_INCOMPAT_SUPP;
-	if (features) {
-		btrfs_err(fs_info,
-		    "cannot mount because of unsupported optional features (0x%llx)",
-		    features);
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
-	features = btrfs_super_incompat_flags(disk_super);
-	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-	if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-	else if (fs_info->compress_type == BTRFS_COMPRESS_ZSTD)
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD;
-
-	/*
-	 * Flag our filesystem as having big metadata blocks if they are bigger
-	 * than the page size.
-	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE)
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-
-	/*
-	 * mixed block groups end up with duplicate but slightly offset
-	 * extent buffers for the same range.  It leads to corruptions
-	 */
-	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
-	    (sectorsize != nodesize)) {
-		btrfs_err(fs_info,
-"unequal nodesize/sectorsize (%u != %u) are not allowed for mixed block groups",
-			nodesize, sectorsize);
-		goto fail_alloc;
-	}
-
-	/*
-	 * Needn't use the lock because there is no other task which will
-	 * update the flag.
-	 */
-	btrfs_set_super_incompat_flags(disk_super, features);
-
-	features = btrfs_super_compat_ro_flags(disk_super) &
-		~BTRFS_FEATURE_COMPAT_RO_SUPP;
-	if (!sb_rdonly(sb) && features) {
-		btrfs_err(fs_info,
-	"cannot mount read-write because of unsupported optional features (0x%llx)",
-		       features);
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-	/*
-	 * We have unsupported RO compat features, although RO mounted, we
-	 * should not cause any metadata write, including log replay.
-	 * Or we could screw up whatever the new feature requires.
-	 */
-	if (unlikely(features && btrfs_super_log_root(disk_super) &&
-		     !btrfs_test_opt(fs_info, NOLOGREPLAY))) {
-		btrfs_err(fs_info,
-"cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
-			  features);
-		err = -EINVAL;
+	ret = btrfs_check_features(fs_info, sb);
+	if (ret < 0) {
+		err = ret;
 		goto fail_alloc;
 	}
 
-
 	if (sectorsize < PAGE_SIZE) {
 		struct btrfs_subpage_info *subpage_info;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index aef981de672c..5b615b371589 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -48,6 +48,7 @@ int __cold open_ctree(struct super_block *sb,
 void __cold close_ctree(struct btrfs_fs_info *fs_info);
 int btrfs_validate_super(struct btrfs_fs_info *fs_info,
 			 struct btrfs_super_block *sb, int mirror_num);
+int btrfs_check_features(struct btrfs_fs_info *fs_info, struct super_block *sb);
 int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
 struct btrfs_super_block *btrfs_read_dev_super(struct block_device *bdev);
 struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 692983e69ba1..b6f3f24ac95d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2012,14 +2012,10 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if (ret)
 		goto restore;
 
-	/* V1 cache is not supported for subpage mount. */
-	if (fs_info->sectorsize < PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
-		btrfs_warn(fs_info,
-	"v1 space cache is not supported for page size %lu with sectorsize %u",
-			   PAGE_SIZE, fs_info->sectorsize);
-		ret = -EINVAL;
+	ret = btrfs_check_features(fs_info, sb);
+	if (ret < 0)
 		goto restore;
-	}
+
 	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
-- 
2.35.1

