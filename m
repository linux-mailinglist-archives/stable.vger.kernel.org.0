Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA6E1B696C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgDWXX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:23:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48394 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728163AbgDWXGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:30 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004au-AE; Fri, 24 Apr 2020 00:06:26 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6hU-69; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "David Sterba" <dsterba@suse.com>,
        "Qu Wenruo" <quwenruo.btrfs@gmx.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:29 +0100
Message-ID: <lsq.1587683028.131416704@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 042/245] btrfs: Move leaf and node validation checker
 to tree-checker.c
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

From: Qu Wenruo <quwenruo.btrfs@gmx.com>

commit 557ea5dd003d371536f6b4e8f7c8209a2b6fd4e3 upstream.

It's no doubt the comprehensive tree block checker will become larger,
so moving them into their own files is quite reasonable.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
[ wording adjustments ]
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4:
 - The moved code is slightly different
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/Makefile       |   2 +-
 fs/btrfs/disk-io.c      | 284 +-----------------------------------
 fs/btrfs/tree-checker.c | 309 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-checker.h |  26 ++++
 4 files changed, 340 insertions(+), 281 deletions(-)
 create mode 100644 fs/btrfs/tree-checker.c
 create mode 100644 fs/btrfs/tree-checker.h

--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o hash.o
+	   uuid-tree.o props.o hash.o tree-checker.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,6 +49,7 @@
 #include "raid56.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "tree-checker.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -507,283 +508,6 @@ static int check_tree_block_fsid(struct
 	return ret;
 }
 
-#define CORRUPT(reason, eb, root, slot)				\
-	btrfs_crit(root->fs_info, "corrupt %s, %s: block=%llu,"	\
-		   " root=%llu, slot=%d",			\
-		   btrfs_header_level(eb) == 0 ? "leaf" : "node",\
-		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
-
-static int check_extent_data_item(struct btrfs_root *root,
-				  struct extent_buffer *leaf,
-				  struct btrfs_key *key, int slot)
-{
-	struct btrfs_file_extent_item *fi;
-	u32 sectorsize = root->sectorsize;
-	u32 item_size = btrfs_item_size_nr(leaf, slot);
-
-	if (!IS_ALIGNED(key->offset, sectorsize)) {
-		CORRUPT("unaligned key offset for file extent",
-			leaf, root, slot);
-		return -EUCLEAN;
-	}
-
-	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
-
-	if (btrfs_file_extent_type(leaf, fi) > BTRFS_FILE_EXTENT_TYPES) {
-		CORRUPT("invalid file extent type", leaf, root, slot);
-		return -EUCLEAN;
-	}
-
-	/*
-	 * Support for new compression/encrption must introduce incompat flag,
-	 * and must be caught in open_ctree().
-	 */
-	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
-		CORRUPT("invalid file extent compression", leaf, root, slot);
-		return -EUCLEAN;
-	}
-	if (btrfs_file_extent_encryption(leaf, fi)) {
-		CORRUPT("invalid file extent encryption", leaf, root, slot);
-		return -EUCLEAN;
-	}
-	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
-		/* Inline extent must have 0 as key offset */
-		if (key->offset) {
-			CORRUPT("inline extent has non-zero key offset",
-				leaf, root, slot);
-			return -EUCLEAN;
-		}
-
-		/* Compressed inline extent has no on-disk size, skip it */
-		if (btrfs_file_extent_compression(leaf, fi) !=
-		    BTRFS_COMPRESS_NONE)
-			return 0;
-
-		/* Uncompressed inline extent size must match item size */
-		if (item_size != BTRFS_FILE_EXTENT_INLINE_DATA_START +
-		    btrfs_file_extent_ram_bytes(leaf, fi)) {
-			CORRUPT("plaintext inline extent has invalid size",
-				leaf, root, slot);
-			return -EUCLEAN;
-		}
-		return 0;
-	}
-
-	/* Regular or preallocated extent has fixed item size */
-	if (item_size != sizeof(*fi)) {
-		CORRUPT(
-		"regluar or preallocated extent data item size is invalid",
-			leaf, root, slot);
-		return -EUCLEAN;
-	}
-	if (!IS_ALIGNED(btrfs_file_extent_ram_bytes(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_disk_bytenr(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_disk_num_bytes(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_offset(leaf, fi), sectorsize) ||
-	    !IS_ALIGNED(btrfs_file_extent_num_bytes(leaf, fi), sectorsize)) {
-		CORRUPT(
-		"regular or preallocated extent data item has unaligned value",
-			leaf, root, slot);
-		return -EUCLEAN;
-	}
-
-	return 0;
-}
-
-static int check_csum_item(struct btrfs_root *root, struct extent_buffer *leaf,
-			   struct btrfs_key *key, int slot)
-{
-	u32 sectorsize = root->sectorsize;
-	u32 csumsize = btrfs_super_csum_size(root->fs_info->super_copy);
-
-	if (key->objectid != BTRFS_EXTENT_CSUM_OBJECTID) {
-		CORRUPT("invalid objectid for csum item", leaf, root, slot);
-		return -EUCLEAN;
-	}
-	if (!IS_ALIGNED(key->offset, sectorsize)) {
-		CORRUPT("unaligned key offset for csum item", leaf, root, slot);
-		return -EUCLEAN;
-	}
-	if (!IS_ALIGNED(btrfs_item_size_nr(leaf, slot), csumsize)) {
-		CORRUPT("unaligned csum item size", leaf, root, slot);
-		return -EUCLEAN;
-	}
-	return 0;
-}
-
-/*
- * Common point to switch the item-specific validation.
- */
-static int check_leaf_item(struct btrfs_root *root,
-			   struct extent_buffer *leaf,
-			   struct btrfs_key *key, int slot)
-{
-	int ret = 0;
-
-	switch (key->type) {
-	case BTRFS_EXTENT_DATA_KEY:
-		ret = check_extent_data_item(root, leaf, key, slot);
-		break;
-	case BTRFS_EXTENT_CSUM_KEY:
-		ret = check_csum_item(root, leaf, key, slot);
-		break;
-	}
-	return ret;
-}
-
-static noinline int check_leaf(struct btrfs_root *root,
-			       struct extent_buffer *leaf)
-{
-	/* No valid key type is 0, so all key should be larger than this key */
-	struct btrfs_key prev_key = {0, 0, 0};
-	struct btrfs_key key;
-	u32 nritems = btrfs_header_nritems(leaf);
-	int slot;
-
-	/*
-	 * Extent buffers from a relocation tree have a owner field that
-	 * corresponds to the subvolume tree they are based on. So just from an
-	 * extent buffer alone we can not find out what is the id of the
-	 * corresponding subvolume tree, so we can not figure out if the extent
-	 * buffer corresponds to the root of the relocation tree or not. So skip
-	 * this check for relocation trees.
-	 */
-	if (nritems == 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
-		struct btrfs_root *check_root;
-
-		key.objectid = btrfs_header_owner(leaf);
-		key.type = BTRFS_ROOT_ITEM_KEY;
-		key.offset = (u64)-1;
-
-		check_root = btrfs_get_fs_root(root->fs_info, &key, false);
-		/*
-		 * The only reason we also check NULL here is that during
-		 * open_ctree() some roots has not yet been set up.
-		 */
-		if (!IS_ERR_OR_NULL(check_root)) {
-			struct extent_buffer *eb;
-
-			eb = btrfs_root_node(check_root);
-			/* if leaf is the root, then it's fine */
-			if (leaf != eb) {
-				CORRUPT("non-root leaf's nritems is 0",
-					leaf, check_root, 0);
-				free_extent_buffer(eb);
-				return -EUCLEAN;
-			}
-			free_extent_buffer(eb);
-		}
-		return 0;
-	}
-
-	if (nritems == 0)
-		return 0;
-
-	/*
-	 * Check the following things to make sure this is a good leaf, and
-	 * leaf users won't need to bother with similar sanity checks:
-	 *
-	 * 1) key order
-	 * 2) item offset and size
-	 *    No overlap, no hole, all inside the leaf.
-	 * 3) item content
-	 *    If possible, do comprehensive sanity check.
-	 *    NOTE: All checks must only rely on the item data itself.
-	 */
-	for (slot = 0; slot < nritems; slot++) {
-		u32 item_end_expected;
-		int ret;
-
-		btrfs_item_key_to_cpu(leaf, &key, slot);
-
-		/* Make sure the keys are in the right order */
-		if (btrfs_comp_cpu_keys(&prev_key, &key) >= 0) {
-			CORRUPT("bad key order", leaf, root, slot);
-			return -EUCLEAN;
-		}
-
-		/*
-		 * Make sure the offset and ends are right, remember that the
-		 * item data starts at the end of the leaf and grows towards the
-		 * front.
-		 */
-		if (slot == 0)
-			item_end_expected = BTRFS_LEAF_DATA_SIZE(root);
-		else
-			item_end_expected = btrfs_item_offset_nr(leaf,
-								 slot - 1);
-		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
-			CORRUPT("slot offset bad", leaf, root, slot);
-			return -EUCLEAN;
-		}
-
-		/*
-		 * Check to make sure that we don't point outside of the leaf,
-		 * just incase all the items are consistent to eachother, but
-		 * all point outside of the leaf.
-		 */
-		if (btrfs_item_end_nr(leaf, slot) >
-		    BTRFS_LEAF_DATA_SIZE(root)) {
-			CORRUPT("slot end outside of leaf", leaf, root, slot);
-			return -EUCLEAN;
-		}
-
-		/* Also check if the item pointer overlaps with btrfs item. */
-		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
-		    btrfs_item_ptr_offset(leaf, slot)) {
-			CORRUPT("slot overlap with its data", leaf, root, slot);
-			return -EUCLEAN;
-		}
-
-		/* Check if the item size and content meet other criteria */
-		ret = check_leaf_item(root, leaf, &key, slot);
-		if (ret < 0)
-			return ret;
-
-		prev_key.objectid = key.objectid;
-		prev_key.type = key.type;
-		prev_key.offset = key.offset;
-	}
-
-	return 0;
-}
-
-static int check_node(struct btrfs_root *root, struct extent_buffer *node)
-{
-	unsigned long nr = btrfs_header_nritems(node);
-	struct btrfs_key key, next_key;
-	int slot;
-	u64 bytenr;
-	int ret = 0;
-
-	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root)) {
-		btrfs_crit(root->fs_info,
-			   "corrupt node: block %llu root %llu nritems %lu",
-			   node->start, root->objectid, nr);
-		return -EIO;
-	}
-
-	for (slot = 0; slot < nr - 1; slot++) {
-		bytenr = btrfs_node_blockptr(node, slot);
-		btrfs_node_key_to_cpu(node, &key, slot);
-		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
-
-		if (!bytenr) {
-			CORRUPT("invalid item slot", node, root, slot);
-			ret = -EIO;
-			goto out;
-		}
-
-		if (btrfs_comp_cpu_keys(&key, &next_key) >= 0) {
-			CORRUPT("bad key order", node, root, slot);
-			ret = -EIO;
-			goto out;
-		}
-	}
-out:
-	return ret;
-}
-
 static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 				      u64 phy_offset, struct page *page,
 				      u64 start, u64 end, int mirror)
@@ -851,12 +575,12 @@ static int btree_readpage_end_io_hook(st
 	 * that we don't try and read the other copies of this block, just
 	 * return -EIO.
 	 */
-	if (found_level == 0 && check_leaf(root, eb)) {
+	if (found_level == 0 && btrfs_check_leaf(root, eb)) {
 		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 		ret = -EIO;
 	}
 
-	if (found_level > 0 && check_node(root, eb))
+	if (found_level > 0 && btrfs_check_node(root, eb))
 		ret = -EIO;
 
 	if (!ret)
@@ -3978,7 +3702,7 @@ void btrfs_mark_buffer_dirty(struct exte
 				     buf->len,
 				     root->fs_info->dirty_metadata_batch);
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-	if (btrfs_header_level(buf) == 0 && check_leaf(root, buf)) {
+	if (btrfs_header_level(buf) == 0 && btrfs_check_leaf(root, buf)) {
 		btrfs_print_leaf(root, buf);
 		ASSERT(0);
 	}
--- /dev/null
+++ b/fs/btrfs/tree-checker.c
@@ -0,0 +1,309 @@
+/*
+ * Copyright (C) Qu Wenruo 2017.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program.
+ */
+
+/*
+ * The module is used to catch unexpected/corrupted tree block data.
+ * Such behavior can be caused either by a fuzzed image or bugs.
+ *
+ * The objective is to do leaf/node validation checks when tree block is read
+ * from disk, and check *every* possible member, so other code won't
+ * need to checking them again.
+ *
+ * Due to the potential and unwanted damage, every checker needs to be
+ * carefully reviewed otherwise so it does not prevent mount of valid images.
+ */
+
+#include "ctree.h"
+#include "tree-checker.h"
+#include "disk-io.h"
+#include "compression.h"
+
+#define CORRUPT(reason, eb, root, slot)					\
+	btrfs_crit(root->fs_info,					\
+		   "corrupt %s, %s: block=%llu, root=%llu, slot=%d",	\
+		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
+		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
+
+static int check_extent_data_item(struct btrfs_root *root,
+				  struct extent_buffer *leaf,
+				  struct btrfs_key *key, int slot)
+{
+	struct btrfs_file_extent_item *fi;
+	u32 sectorsize = root->sectorsize;
+	u32 item_size = btrfs_item_size_nr(leaf, slot);
+
+	if (!IS_ALIGNED(key->offset, sectorsize)) {
+		CORRUPT("unaligned key offset for file extent",
+			leaf, root, slot);
+		return -EUCLEAN;
+	}
+
+	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_type(leaf, fi) > BTRFS_FILE_EXTENT_TYPES) {
+		CORRUPT("invalid file extent type", leaf, root, slot);
+		return -EUCLEAN;
+	}
+
+	/*
+	 * Support for new compression/encrption must introduce incompat flag,
+	 * and must be caught in open_ctree().
+	 */
+	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
+		CORRUPT("invalid file extent compression", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (btrfs_file_extent_encryption(leaf, fi)) {
+		CORRUPT("invalid file extent encryption", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
+		/* Inline extent must have 0 as key offset */
+		if (key->offset) {
+			CORRUPT("inline extent has non-zero key offset",
+				leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/* Compressed inline extent has no on-disk size, skip it */
+		if (btrfs_file_extent_compression(leaf, fi) !=
+		    BTRFS_COMPRESS_NONE)
+			return 0;
+
+		/* Uncompressed inline extent size must match item size */
+		if (item_size != BTRFS_FILE_EXTENT_INLINE_DATA_START +
+		    btrfs_file_extent_ram_bytes(leaf, fi)) {
+			CORRUPT("plaintext inline extent has invalid size",
+				leaf, root, slot);
+			return -EUCLEAN;
+		}
+		return 0;
+	}
+
+	/* Regular or preallocated extent has fixed item size */
+	if (item_size != sizeof(*fi)) {
+		CORRUPT(
+		"regluar or preallocated extent data item size is invalid",
+			leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(btrfs_file_extent_ram_bytes(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_disk_bytenr(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_disk_num_bytes(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_offset(leaf, fi), sectorsize) ||
+	    !IS_ALIGNED(btrfs_file_extent_num_bytes(leaf, fi), sectorsize)) {
+		CORRUPT(
+		"regular or preallocated extent data item has unaligned value",
+			leaf, root, slot);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
+static int check_csum_item(struct btrfs_root *root, struct extent_buffer *leaf,
+			   struct btrfs_key *key, int slot)
+{
+	u32 sectorsize = root->sectorsize;
+	u32 csumsize = btrfs_super_csum_size(root->fs_info->super_copy);
+
+	if (key->objectid != BTRFS_EXTENT_CSUM_OBJECTID) {
+		CORRUPT("invalid objectid for csum item", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(key->offset, sectorsize)) {
+		CORRUPT("unaligned key offset for csum item", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	if (!IS_ALIGNED(btrfs_item_size_nr(leaf, slot), csumsize)) {
+		CORRUPT("unaligned csum item size", leaf, root, slot);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
+/*
+ * Common point to switch the item-specific validation.
+ */
+static int check_leaf_item(struct btrfs_root *root,
+			   struct extent_buffer *leaf,
+			   struct btrfs_key *key, int slot)
+{
+	int ret = 0;
+
+	switch (key->type) {
+	case BTRFS_EXTENT_DATA_KEY:
+		ret = check_extent_data_item(root, leaf, key, slot);
+		break;
+	case BTRFS_EXTENT_CSUM_KEY:
+		ret = check_csum_item(root, leaf, key, slot);
+		break;
+	}
+	return ret;
+}
+
+int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	/* No valid key type is 0, so all key should be larger than this key */
+	struct btrfs_key prev_key = {0, 0, 0};
+	struct btrfs_key key;
+	u32 nritems = btrfs_header_nritems(leaf);
+	int slot;
+
+	/*
+	 * Extent buffers from a relocation tree have a owner field that
+	 * corresponds to the subvolume tree they are based on. So just from an
+	 * extent buffer alone we can not find out what is the id of the
+	 * corresponding subvolume tree, so we can not figure out if the extent
+	 * buffer corresponds to the root of the relocation tree or not. So
+	 * skip this check for relocation trees.
+	 */
+	if (nritems == 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
+		struct btrfs_root *check_root;
+
+		key.objectid = btrfs_header_owner(leaf);
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		check_root = btrfs_get_fs_root(fs_info, &key, false);
+		/*
+		 * The only reason we also check NULL here is that during
+		 * open_ctree() some roots has not yet been set up.
+		 */
+		if (!IS_ERR_OR_NULL(check_root)) {
+			struct extent_buffer *eb;
+
+			eb = btrfs_root_node(check_root);
+			/* if leaf is the root, then it's fine */
+			if (leaf != eb) {
+				CORRUPT("non-root leaf's nritems is 0",
+					leaf, check_root, 0);
+				free_extent_buffer(eb);
+				return -EUCLEAN;
+			}
+			free_extent_buffer(eb);
+		}
+		return 0;
+	}
+
+	if (nritems == 0)
+		return 0;
+
+	/*
+	 * Check the following things to make sure this is a good leaf, and
+	 * leaf users won't need to bother with similar sanity checks:
+	 *
+	 * 1) key ordering
+	 * 2) item offset and size
+	 *    No overlap, no hole, all inside the leaf.
+	 * 3) item content
+	 *    If possible, do comprehensive sanity check.
+	 *    NOTE: All checks must only rely on the item data itself.
+	 */
+	for (slot = 0; slot < nritems; slot++) {
+		u32 item_end_expected;
+		int ret;
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		/* Make sure the keys are in the right order */
+		if (btrfs_comp_cpu_keys(&prev_key, &key) >= 0) {
+			CORRUPT("bad key order", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Make sure the offset and ends are right, remember that the
+		 * item data starts at the end of the leaf and grows towards the
+		 * front.
+		 */
+		if (slot == 0)
+			item_end_expected = BTRFS_LEAF_DATA_SIZE(root);
+		else
+			item_end_expected = btrfs_item_offset_nr(leaf,
+								 slot - 1);
+		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
+			CORRUPT("slot offset bad", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Check to make sure that we don't point outside of the leaf,
+		 * just in case all the items are consistent to each other, but
+		 * all point outside of the leaf.
+		 */
+		if (btrfs_item_end_nr(leaf, slot) >
+		    BTRFS_LEAF_DATA_SIZE(root)) {
+			CORRUPT("slot end outside of leaf", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/* Also check if the item pointer overlaps with btrfs item. */
+		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
+		    btrfs_item_ptr_offset(leaf, slot)) {
+			CORRUPT("slot overlap with its data", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
+		/* Check if the item size and content meet other criteria */
+		ret = check_leaf_item(root, leaf, &key, slot);
+		if (ret < 0)
+			return ret;
+
+		prev_key.objectid = key.objectid;
+		prev_key.type = key.type;
+		prev_key.offset = key.offset;
+	}
+
+	return 0;
+}
+
+int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
+{
+	unsigned long nr = btrfs_header_nritems(node);
+	struct btrfs_key key, next_key;
+	int slot;
+	u64 bytenr;
+	int ret = 0;
+
+	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root)) {
+		btrfs_crit(root->fs_info,
+			   "corrupt node: block %llu root %llu nritems %lu",
+			   node->start, root->objectid, nr);
+		return -EIO;
+	}
+
+	for (slot = 0; slot < nr - 1; slot++) {
+		bytenr = btrfs_node_blockptr(node, slot);
+		btrfs_node_key_to_cpu(node, &key, slot);
+		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
+
+		if (!bytenr) {
+			CORRUPT("invalid item slot", node, root, slot);
+			ret = -EIO;
+			goto out;
+		}
+
+		if (btrfs_comp_cpu_keys(&key, &next_key) >= 0) {
+			CORRUPT("bad key order", node, root, slot);
+			ret = -EIO;
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
--- /dev/null
+++ b/fs/btrfs/tree-checker.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) Qu Wenruo 2017.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program.
+ */
+
+#ifndef __BTRFS_TREE_CHECKER__
+#define __BTRFS_TREE_CHECKER__
+
+#include "ctree.h"
+#include "extent_io.h"
+
+int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf);
+int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node);
+
+#endif

