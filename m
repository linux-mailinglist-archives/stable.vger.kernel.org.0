Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE71B6943
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgDWXVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48514 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728192AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004bC-RX; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6hy-Fu; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Xu Wen" <wen.xu@gatech.edu>, "David Sterba" <dsterba@suse.com>,
        "Gu Jinxiang" <gujx@cn.fujitsu.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Nikolay Borisov" <nborisov@suse.com>, "Qu Wenruo" <wqu@suse.com>
Date:   Fri, 24 Apr 2020 00:04:35 +0100
Message-ID: <lsq.1587683028.960835989@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 048/245] btrfs: tree-checker: Verify block_group_item
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

From: Qu Wenruo <wqu@suse.com>

commit fce466eab7ac6baa9d2dcd88abcf945be3d4a089 upstream.

A crafted image with invalid block group items could make free space cache
code to cause panic.

We could detect such invalid block group item by checking:
1) Item size
   Known fixed value.
2) Block group size (key.offset)
   We have an upper limit on block group item (10G)
3) Chunk objectid
   Known fixed value.
4) Type
   Only 4 valid type values, DATA, METADATA, SYSTEM and DATA|METADATA.
   No more than 1 bit set for profile type.
5) Used space
   No more than the block group size.

This should allow btrfs to detect and refuse to mount the crafted image.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199849
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4:
 - In check_leaf_item(), pass root->fs_info to check_block_group_item()
 - Include <linux/sizes.h> (in ctree.h, to match upstream)
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/ctree.h        |   1 +
 fs/btrfs/tree-checker.c | 100 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c      |   2 +-
 fs/btrfs/volumes.h      |   2 +
 4 files changed, 104 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/btrfs.h>
 #include <linux/workqueue.h>
+#include <linux/sizes.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -31,6 +31,7 @@
 #include "disk-io.h"
 #include "compression.h"
 #include "hash.h"
+#include "volumes.h"
 
 #define CORRUPT(reason, eb, root, slot)					\
 	btrfs_crit(root->fs_info,					\
@@ -312,6 +313,102 @@ static int check_dir_item(struct btrfs_r
 	return 0;
 }
 
+__printf(4, 5)
+__cold
+static void block_group_err(const struct btrfs_fs_info *fs_info,
+			    const struct extent_buffer *eb, int slot,
+			    const char *fmt, ...)
+{
+	struct btrfs_key key;
+	struct va_format vaf;
+	va_list args;
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	btrfs_crit(fs_info,
+	"corrupt %s: root=%llu block=%llu slot=%d bg_start=%llu bg_len=%llu, %pV",
+		btrfs_header_level(eb) == 0 ? "leaf" : "node",
+		btrfs_header_owner(eb), btrfs_header_bytenr(eb), slot,
+		key.objectid, key.offset, &vaf);
+	va_end(args);
+}
+
+static int check_block_group_item(struct btrfs_fs_info *fs_info,
+				  struct extent_buffer *leaf,
+				  struct btrfs_key *key, int slot)
+{
+	struct btrfs_block_group_item bgi;
+	u32 item_size = btrfs_item_size_nr(leaf, slot);
+	u64 flags;
+	u64 type;
+
+	/*
+	 * Here we don't really care about alignment since extent allocator can
+	 * handle it.  We care more about the size, as if one block group is
+	 * larger than maximum size, it's must be some obvious corruption.
+	 */
+	if (key->offset > BTRFS_MAX_DATA_CHUNK_SIZE || key->offset == 0) {
+		block_group_err(fs_info, leaf, slot,
+			"invalid block group size, have %llu expect (0, %llu]",
+				key->offset, BTRFS_MAX_DATA_CHUNK_SIZE);
+		return -EUCLEAN;
+	}
+
+	if (item_size != sizeof(bgi)) {
+		block_group_err(fs_info, leaf, slot,
+			"invalid item size, have %u expect %zu",
+				item_size, sizeof(bgi));
+		return -EUCLEAN;
+	}
+
+	read_extent_buffer(leaf, &bgi, btrfs_item_ptr_offset(leaf, slot),
+			   sizeof(bgi));
+	if (btrfs_block_group_chunk_objectid(&bgi) !=
+	    BTRFS_FIRST_CHUNK_TREE_OBJECTID) {
+		block_group_err(fs_info, leaf, slot,
+		"invalid block group chunk objectid, have %llu expect %llu",
+				btrfs_block_group_chunk_objectid(&bgi),
+				BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+		return -EUCLEAN;
+	}
+
+	if (btrfs_block_group_used(&bgi) > key->offset) {
+		block_group_err(fs_info, leaf, slot,
+			"invalid block group used, have %llu expect [0, %llu)",
+				btrfs_block_group_used(&bgi), key->offset);
+		return -EUCLEAN;
+	}
+
+	flags = btrfs_block_group_flags(&bgi);
+	if (hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1) {
+		block_group_err(fs_info, leaf, slot,
+"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
+			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
+			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
+		return -EUCLEAN;
+	}
+
+	type = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
+	if (type != BTRFS_BLOCK_GROUP_DATA &&
+	    type != BTRFS_BLOCK_GROUP_METADATA &&
+	    type != BTRFS_BLOCK_GROUP_SYSTEM &&
+	    type != (BTRFS_BLOCK_GROUP_METADATA |
+			   BTRFS_BLOCK_GROUP_DATA)) {
+		block_group_err(fs_info, leaf, slot,
+"invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llu or 0x%llx",
+			type, hweight64(type),
+			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
+			BTRFS_BLOCK_GROUP_SYSTEM,
+			BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -333,6 +430,9 @@ static int check_leaf_item(struct btrfs_
 	case BTRFS_XATTR_ITEM_KEY:
 		ret = check_dir_item(root, leaf, key, slot);
 		break;
+	case BTRFS_BLOCK_GROUP_ITEM_KEY:
+		ret = check_block_group_item(root->fs_info, leaf, key, slot);
+		break;
 	}
 	return ret;
 }
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4134,7 +4134,7 @@ static int __btrfs_alloc_chunk(struct bt
 
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_stripe_size = 1024 * 1024 * 1024;
-		max_chunk_size = 10 * max_stripe_size;
+		max_chunk_size = BTRFS_MAX_DATA_CHUNK_SIZE;
 		if (!devs_max)
 			devs_max = BTRFS_MAX_DEVS(info->chunk_root);
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -24,6 +24,8 @@
 #include <linux/btrfs.h>
 #include "async-thread.h"
 
+#define BTRFS_MAX_DATA_CHUNK_SIZE	(10ULL * SZ_1G)
+
 #define BTRFS_STRIPE_LEN	(64 * 1024)
 
 struct buffer_head;

