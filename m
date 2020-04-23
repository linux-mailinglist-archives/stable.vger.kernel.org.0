Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6761B6971
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgDWXXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:23:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48382 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727890AbgDWXGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:30 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004an-8U; Fri, 24 Apr 2020 00:06:26 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6hK-3A; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Nikolay Borisov" <nborisov@suse.com>,
        "Qu Wenruo" <quwenruo.btrfs@gmx.com>
Date:   Fri, 24 Apr 2020 00:04:27 +0100
Message-ID: <lsq.1587683028.314449038@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 040/245] btrfs: Add sanity check for EXTENT_DATA when
 reading out leaf
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

commit 40c3c40947324d9f40bf47830c92c59a9bbadf4a upstream.

Add extra checks for item with EXTENT_DATA type.  This checks the
following thing:

0) Key offset
   All key offsets must be aligned to sectorsize.
   Inline extent must have 0 for key offset.

1) Item size
   Uncompressed inline file extent size must match item size.
   (Compressed inline file extent has no information about its on-disk size.)
   Regular/preallocated file extent size must be a fixed value.

2) Every member of regular file extent item
   Including alignment for bytenr and offset, possible value for
   compression/encryption/type.

3) Type/compression/encode must be one of the valid values.

This should be the most comprehensive and strict check in the context
of btrfs_item for EXTENT_DATA.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ switch to BTRFS_FILE_EXTENT_TYPES, similar to what
  BTRFS_COMPRESS_TYPES does ]
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4:
 - Use root->sectorsize instead of root->fs_info->sectorsize
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/ctree.h   |   1 +
 fs/btrfs/disk-io.c | 103 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -874,6 +874,7 @@ struct btrfs_balance_item {
 #define BTRFS_FILE_EXTENT_INLINE 0
 #define BTRFS_FILE_EXTENT_REG 1
 #define BTRFS_FILE_EXTENT_PREALLOC 2
+#define BTRFS_FILE_EXTENT_TYPES	2
 
 struct btrfs_file_extent_item {
 	/*
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -513,6 +513,100 @@ static int check_tree_block_fsid(struct
 		   btrfs_header_level(eb) == 0 ? "leaf" : "node",\
 		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
 
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
+	}
+	return ret;
+}
+
 static noinline int check_leaf(struct btrfs_root *root,
 			       struct extent_buffer *leaf)
 {
@@ -568,9 +662,13 @@ static noinline int check_leaf(struct bt
 	 * 1) key order
 	 * 2) item offset and size
 	 *    No overlap, no hole, all inside the leaf.
+	 * 3) item content
+	 *    If possible, do comprehensive sanity check.
+	 *    NOTE: All checks must only rely on the item data itself.
 	 */
 	for (slot = 0; slot < nritems; slot++) {
 		u32 item_end_expected;
+		int ret;
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 
@@ -613,6 +711,11 @@ static noinline int check_leaf(struct bt
 			return -EUCLEAN;
 		}
 
+		/* Check if the item size and content meet other criteria */
+		ret = check_leaf_item(root, leaf, &key, slot);
+		if (ret < 0)
+			return ret;
+
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
 		prev_key.offset = key.offset;

