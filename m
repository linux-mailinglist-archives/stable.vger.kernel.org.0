Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A772ABBD7
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgKINbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731771AbgKINIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3651620731;
        Mon,  9 Nov 2020 13:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927332;
        bh=sFPebxc2D+hnC/52KdhJQ9lWsjP7YN3M6sPSMeYOHh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2e0qRcFEiiJ5+b0HzpjccRNnuS2yw85XkELgRK33T/9SrtTRqGQJQykNfYCB+k9JV
         yzDKvikJb3qiN/4KHxEd0ERVvUr23wpL2a8OB/zQEmM4BxW7ynN6Sx0O0N9QUSlRap
         66+YCGvxwjYLB8j/NXtwDL3aW3lLAfhEZs4WEDHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 23/71] btrfs: tree-checker: Make chunk item checker messages more readable
Date:   Mon,  9 Nov 2020 13:55:17 +0100
Message-Id: <20201109125020.995502064@linuxfoundation.org>
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

commit f114024376bceb1c0f61a7bad4a72a0f978767af upstream.

Old error message would be something like:
  BTRFS error (device dm-3): invalid chunk num_stipres: 0

New error message would be:
  Btrfs critical (device dm-3): corrupt superblock syschunk array: chunk_start=2097152, invalid chunk num_stripes: 0
Or
  Btrfs critical (device dm-3): corrupt leaf: root=3 block=8388608 slot=3 chunk_start=2097152, invalid chunk num_stripes: 0

And for certain error message, also output expected value.

The error message levels are changed from error to critical.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Cherry-picked for 4.19 to ease backporting later fixes]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   81 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 68 insertions(+), 13 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -448,6 +448,51 @@ static int check_block_group_item(struct
 	return 0;
 }
 
+__printf(5, 6)
+__cold
+static void chunk_err(const struct btrfs_fs_info *fs_info,
+		      const struct extent_buffer *leaf,
+		      const struct btrfs_chunk *chunk, u64 logical,
+		      const char *fmt, ...)
+{
+	bool is_sb;
+	struct va_format vaf;
+	va_list args;
+	int i;
+	int slot = -1;
+
+	/* Only superblock eb is able to have such small offset */
+	is_sb = (leaf->start == BTRFS_SUPER_INFO_OFFSET);
+
+	if (!is_sb) {
+		/*
+		 * Get the slot number by iterating through all slots, this
+		 * would provide better readability.
+		 */
+		for (i = 0; i < btrfs_header_nritems(leaf); i++) {
+			if (btrfs_item_ptr_offset(leaf, i) ==
+					(unsigned long)chunk) {
+				slot = i;
+				break;
+			}
+		}
+	}
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (is_sb)
+		btrfs_crit(fs_info,
+		"corrupt superblock syschunk array: chunk_start=%llu, %pV",
+			   logical, &vaf);
+	else
+		btrfs_crit(fs_info,
+	"corrupt leaf: root=%llu block=%llu slot=%d chunk_start=%llu, %pV",
+			   BTRFS_CHUNK_TREE_OBJECTID, leaf->start, slot,
+			   logical, &vaf);
+	va_end(args);
+}
+
 /*
  * The common chunk check which could also work on super block sys chunk array.
  *
@@ -473,31 +518,38 @@ int btrfs_check_chunk_valid(struct btrfs
 	type = btrfs_chunk_type(leaf, chunk);
 
 	if (!num_stripes) {
-		btrfs_err(fs_info, "invalid chunk num_stripes: %u",
-			  num_stripes);
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk num_stripes, have %u", num_stripes);
 		return -EIO;
 	}
 	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk logical %llu", logical);
+		chunk_err(fs_info, leaf, chunk, logical,
+		"invalid chunk logical, have %llu should aligned to %u",
+			  logical, fs_info->sectorsize);
 		return -EIO;
 	}
 	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
-		btrfs_err(fs_info, "invalid chunk sectorsize %u",
-			  btrfs_chunk_sector_size(leaf, chunk));
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk sectorsize, have %u expect %u",
+			  btrfs_chunk_sector_size(leaf, chunk),
+			  fs_info->sectorsize);
 		return -EIO;
 	}
 	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
-		btrfs_err(fs_info, "invalid chunk length %llu", length);
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk length, have %llu", length);
 		return -EIO;
 	}
 	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
-		btrfs_err(fs_info, "invalid chunk stripe length: %llu",
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "invalid chunk stripe length: %llu",
 			  stripe_len);
 		return -EIO;
 	}
 	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 	    type) {
-		btrfs_err(fs_info, "unrecognized chunk type: %llu",
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "unrecognized chunk type: 0x%llx",
 			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
 			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 			  btrfs_chunk_type(leaf, chunk));
@@ -505,14 +557,17 @@ int btrfs_check_chunk_valid(struct btrfs
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
-		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
+		chunk_err(fs_info, leaf, chunk, logical,
+	"missing chunk type flag, have 0x%llx one bit must be set in 0x%llx",
+			  type, BTRFS_BLOCK_GROUP_TYPE_MASK);
 		return -EIO;
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
 	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
-		btrfs_err(fs_info,
-			"system chunk with data or metadata type: 0x%llx", type);
+		chunk_err(fs_info, leaf, chunk, logical,
+			  "system chunk with data or metadata type: 0x%llx",
+			  type);
 		return -EIO;
 	}
 
@@ -523,7 +578,7 @@ int btrfs_check_chunk_valid(struct btrfs
 	if (!mixed) {
 		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
 		    (type & BTRFS_BLOCK_GROUP_DATA)) {
-			btrfs_err(fs_info,
+			chunk_err(fs_info, leaf, chunk, logical,
 			"mixed chunk type in non-mixed mode: 0x%llx", type);
 			return -EIO;
 		}
@@ -535,7 +590,7 @@ int btrfs_check_chunk_valid(struct btrfs
 	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
 	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
 	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 && num_stripes != 1)) {
-		btrfs_err(fs_info,
+		chunk_err(fs_info, leaf, chunk, logical,
 			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
 			num_stripes, sub_stripes,
 			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);


