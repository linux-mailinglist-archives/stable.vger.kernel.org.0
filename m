Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3522AB966
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgKINIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbgKINIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B35A20663;
        Mon,  9 Nov 2020 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927330;
        bh=uxnZ67T9Nz/XfSrujzwdM4zE9pSHvDkKdasUv4+d0qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzA2CvmfIu2NsUD7sftYVFGmegDybgma+HgKIn/Uf965mTLunxdLl8CuVm4R0TxQI
         /hl+4ttbyrVAGSqswaq9MTLA4oF3cbixoJdLQr6cQD52Cf/GFkloD8ISFVEJUA+mC5
         wjFIA2a5oC/6RsWl/gcBHB1/RkAlnkbNWbdHYW+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 22/71] btrfs: Move btrfs_check_chunk_valid() to tree-check.[ch] and export it
Date:   Mon,  9 Nov 2020 13:55:16 +0100
Message-Id: <20201109125020.947045578@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 82fc28fbedbb59642f05215db3b0ef4eb91aa31d upstream.

By function, chunk item verification is more suitable to be done inside
tree-checker.

So move btrfs_check_chunk_valid() to tree-checker.c and export it.

And since it's now moved to tree-checker, also add a better comment for
what this function is doing.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Cherry-picked for 4.19 to ease backporting later fixes]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-checker.h |    4 +
 fs/btrfs/volumes.c      |   94 ----------------------------------------------
 3 files changed, 102 insertions(+), 93 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -449,6 +449,103 @@ static int check_block_group_item(struct
 }
 
 /*
+ * The common chunk check which could also work on super block sys chunk array.
+ *
+ * Return -EIO if anything is corrupted.
+ * Return 0 if everything is OK.
+ */
+int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *leaf,
+			    struct btrfs_chunk *chunk, u64 logical)
+{
+	u64 length;
+	u64 stripe_len;
+	u16 num_stripes;
+	u16 sub_stripes;
+	u64 type;
+	u64 features;
+	bool mixed = false;
+
+	length = btrfs_chunk_length(leaf, chunk);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+	type = btrfs_chunk_type(leaf, chunk);
+
+	if (!num_stripes) {
+		btrfs_err(fs_info, "invalid chunk num_stripes: %u",
+			  num_stripes);
+		return -EIO;
+	}
+	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
+		btrfs_err(fs_info, "invalid chunk logical %llu", logical);
+		return -EIO;
+	}
+	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
+		btrfs_err(fs_info, "invalid chunk sectorsize %u",
+			  btrfs_chunk_sector_size(leaf, chunk));
+		return -EIO;
+	}
+	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
+		btrfs_err(fs_info, "invalid chunk length %llu", length);
+		return -EIO;
+	}
+	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
+		btrfs_err(fs_info, "invalid chunk stripe length: %llu",
+			  stripe_len);
+		return -EIO;
+	}
+	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+	    type) {
+		btrfs_err(fs_info, "unrecognized chunk type: %llu",
+			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+			  btrfs_chunk_type(leaf, chunk));
+		return -EIO;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
+		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
+		return -EIO;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
+	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
+		btrfs_err(fs_info,
+			"system chunk with data or metadata type: 0x%llx", type);
+		return -EIO;
+	}
+
+	features = btrfs_super_incompat_flags(fs_info->super_copy);
+	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+		mixed = true;
+
+	if (!mixed) {
+		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
+		    (type & BTRFS_BLOCK_GROUP_DATA)) {
+			btrfs_err(fs_info,
+			"mixed chunk type in non-mixed mode: 0x%llx", type);
+			return -EIO;
+		}
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes != 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
+	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 && num_stripes != 1)) {
+		btrfs_err(fs_info,
+			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
+			num_stripes, sub_stripes,
+			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/*
  * Common point to switch the item-specific validation.
  */
 static int check_leaf_item(struct btrfs_fs_info *fs_info,
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -25,4 +25,8 @@ int btrfs_check_leaf_relaxed(struct btrf
 			     struct extent_buffer *leaf);
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
 
+int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *leaf,
+			    struct btrfs_chunk *chunk, u64 logical);
+
 #endif
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -28,6 +28,7 @@
 #include "math.h"
 #include "dev-replace.h"
 #include "sysfs.h"
+#include "tree-checker.h"
 
 const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
@@ -6370,99 +6371,6 @@ struct btrfs_device *btrfs_alloc_device(
 	return dev;
 }
 
-/* Return -EIO if any error, otherwise return 0. */
-static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
-				   struct extent_buffer *leaf,
-				   struct btrfs_chunk *chunk, u64 logical)
-{
-	u64 length;
-	u64 stripe_len;
-	u16 num_stripes;
-	u16 sub_stripes;
-	u64 type;
-	u64 features;
-	bool mixed = false;
-
-	length = btrfs_chunk_length(leaf, chunk);
-	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
-	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
-	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
-	type = btrfs_chunk_type(leaf, chunk);
-
-	if (!num_stripes) {
-		btrfs_err(fs_info, "invalid chunk num_stripes: %u",
-			  num_stripes);
-		return -EIO;
-	}
-	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk logical %llu", logical);
-		return -EIO;
-	}
-	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
-		btrfs_err(fs_info, "invalid chunk sectorsize %u",
-			  btrfs_chunk_sector_size(leaf, chunk));
-		return -EIO;
-	}
-	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk length %llu", length);
-		return -EIO;
-	}
-	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
-		btrfs_err(fs_info, "invalid chunk stripe length: %llu",
-			  stripe_len);
-		return -EIO;
-	}
-	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
-	    type) {
-		btrfs_err(fs_info, "unrecognized chunk type: %llu",
-			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
-			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
-			  btrfs_chunk_type(leaf, chunk));
-		return -EIO;
-	}
-
-	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
-		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
-		return -EIO;
-	}
-
-	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
-	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
-		btrfs_err(fs_info,
-			"system chunk with data or metadata type: 0x%llx", type);
-		return -EIO;
-	}
-
-	features = btrfs_super_incompat_flags(fs_info->super_copy);
-	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
-		mixed = true;
-
-	if (!mixed) {
-		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
-		    (type & BTRFS_BLOCK_GROUP_DATA)) {
-			btrfs_err(fs_info,
-			"mixed chunk type in non-mixed mode: 0x%llx", type);
-			return -EIO;
-		}
-	}
-
-	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes != 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
-	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
-	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
-	     num_stripes != 1)) {
-		btrfs_err(fs_info,
-			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
-			num_stripes, sub_stripes,
-			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
 					u64 devid, u8 *uuid, bool error)
 {


