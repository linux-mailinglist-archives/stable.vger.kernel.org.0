Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252B91B6988
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgDWXYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48282 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728128AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004a9-7s; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6gD-CU; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Vegard Nossum" <vegard.nossum@oracle.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Liu Bo" <bo.li.liu@oracle.com>,
        "Quentin Casasnovas" <quentin.casasnovas@oracle.com>,
        "David Sterba" <dsterba@suse.com>
Date:   Fri, 24 Apr 2020 00:04:13 +0100
Message-ID: <lsq.1587683028.655365305@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 026/245] Btrfs: add validadtion checks for chunk loading
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit e06cd3dd7cea50e87663a88acdfdb7ac1c53a5ca upstream.

To prevent fuzzed filesystem images from panic the whole system,
we need various validation checks to refuse to mount such an image
if btrfs finds any invalid value during loading chunks, including
both sys_array and regular chunks.

Note that these checks may not be sufficient to cover all corner cases,
feel free to add more checks.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 82 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 67 insertions(+), 15 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5805,27 +5805,23 @@ struct btrfs_device *btrfs_alloc_device(
 	return dev;
 }
 
-static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
-			  struct extent_buffer *leaf,
-			  struct btrfs_chunk *chunk)
+/* Return -EIO if any error, otherwise return 0. */
+static int btrfs_check_chunk_valid(struct btrfs_root *root,
+				   struct extent_buffer *leaf,
+				   struct btrfs_chunk *chunk, u64 logical)
 {
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
-	struct map_lookup *map;
-	struct extent_map *em;
-	u64 logical;
 	u64 length;
 	u64 stripe_len;
-	u64 devid;
-	u8 uuid[BTRFS_UUID_SIZE];
-	int num_stripes;
-	int ret;
-	int i;
+	u16 num_stripes;
+	u16 sub_stripes;
+	u64 type;
 
-	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
-	/* Validation check */
+	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+	type = btrfs_chunk_type(leaf, chunk);
+
 	if (!num_stripes) {
 		btrfs_err(root->fs_info, "invalid chunk num_stripes: %u",
 			  num_stripes);
@@ -5836,6 +5832,11 @@ static int read_one_chunk(struct btrfs_r
 			  "invalid chunk logical %llu", logical);
 		return -EIO;
 	}
+	if (btrfs_chunk_sector_size(leaf, chunk) != root->sectorsize) {
+		btrfs_err(root->fs_info, "invalid chunk sectorsize %u",
+			  btrfs_chunk_sector_size(leaf, chunk));
+		return -EIO;
+	}
 	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
 		btrfs_err(root->fs_info,
 			"invalid chunk length %llu", length);
@@ -5847,13 +5848,54 @@ static int read_one_chunk(struct btrfs_r
 		return -EIO;
 	}
 	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
-	    btrfs_chunk_type(leaf, chunk)) {
+	    type) {
 		btrfs_err(root->fs_info, "unrecognized chunk type: %llu",
 			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
 			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
 			  btrfs_chunk_type(leaf, chunk));
 		return -EIO;
 	}
+	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
+	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
+	     num_stripes != 1)) {
+		btrfs_err(root->fs_info,
+			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
+			num_stripes, sub_stripes,
+			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
+			  struct extent_buffer *leaf,
+			  struct btrfs_chunk *chunk)
+{
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	struct map_lookup *map;
+	struct extent_map *em;
+	u64 logical;
+	u64 length;
+	u64 stripe_len;
+	u64 devid;
+	u8 uuid[BTRFS_UUID_SIZE];
+	int num_stripes;
+	int ret;
+	int i;
+
+	logical = key->offset;
+	length = btrfs_chunk_length(leaf, chunk);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+
+	ret = btrfs_check_chunk_valid(root, leaf, chunk, logical);
+	if (ret)
+		return ret;
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
@@ -6070,6 +6112,7 @@ int btrfs_read_sys_array(struct btrfs_ro
 	u32 array_size;
 	u32 len = 0;
 	u32 cur_offset;
+	u64 type;
 	struct btrfs_key key;
 
 	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
@@ -6130,6 +6173,15 @@ int btrfs_read_sys_array(struct btrfs_ro
 				ret = -EIO;
 				break;
 			}
+
+			type = btrfs_chunk_type(sb, chunk);
+			if ((type & BTRFS_BLOCK_GROUP_SYSTEM) == 0) {
+				btrfs_err(root->fs_info,
+			    "invalid chunk type %llu in sys_array at offset %u",
+					type, cur_offset);
+				ret = -EIO;
+				break;
+			}
 
 			len = btrfs_chunk_item_size(num_stripes);
 			if (cur_offset + len > array_size)

