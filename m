Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC42B1B6968
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgDWXWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:22:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48486 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004b0-Ia; Fri, 24 Apr 2020 00:06:26 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6hj-BN; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Su Yue" <suy.fnst@cn.fujitsu.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Nikolay Borisov" <nborisov@suse.com>, "Qu Wenruo" <wqu@suse.com>
Date:   Fri, 24 Apr 2020 00:04:32 +0100
Message-ID: <lsq.1587683028.237450494@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 045/245] btrfs: tree-checker: Add checker for dir item
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

commit ad7b0368f33cffe67fecd302028915926e50ef7e upstream.

Add checker for dir item, for key types DIR_ITEM, DIR_INDEX and
XATTR_ITEM.

This checker does comprehensive checks for:

1) dir_item header and its data size
   Against item boundary and maximum name/xattr length.
   This part is mostly the same as old verify_dir_item().

2) dir_type
   Against maximum file types, and against key type.
   Since XATTR key should only have FT_XATTR dir item, and normal dir
   item type should not have XATTR key.

   The check between key->type and dir_type is newly introduced by this
   patch.

3) name hash
   For XATTR and DIR_ITEM key, key->offset is name hash (crc32c).
   Check the hash of the name against the key to ensure it's correct.

   The name hash check is only found in btrfs-progs before this patch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4: BTRFS_MAX_XATTR_SIZE() takes a root instead of an
 fs_info, and yields a value of type size_t instead of unsigned int]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/tree-checker.c | 141 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -30,6 +30,7 @@
 #include "tree-checker.h"
 #include "disk-io.h"
 #include "compression.h"
+#include "hash.h"
 
 #define CORRUPT(reason, eb, root, slot)					\
 	btrfs_crit(root->fs_info,					\
@@ -176,6 +177,141 @@ static int check_csum_item(struct btrfs_
 }
 
 /*
+ * Customized reported for dir_item, only important new info is key->objectid,
+ * which represents inode number
+ */
+__printf(4, 5)
+static void dir_item_err(const struct btrfs_root *root,
+			 const struct extent_buffer *eb, int slot,
+			 const char *fmt, ...)
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
+	btrfs_crit(root->fs_info,
+	"corrupt %s: root=%llu block=%llu slot=%d ino=%llu, %pV",
+		btrfs_header_level(eb) == 0 ? "leaf" : "node", root->objectid,
+		btrfs_header_bytenr(eb), slot, key.objectid, &vaf);
+	va_end(args);
+}
+
+static int check_dir_item(struct btrfs_root *root,
+			  struct extent_buffer *leaf,
+			  struct btrfs_key *key, int slot)
+{
+	struct btrfs_dir_item *di;
+	u32 item_size = btrfs_item_size_nr(leaf, slot);
+	u32 cur = 0;
+
+	di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
+	while (cur < item_size) {
+		char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+		u32 name_len;
+		u32 data_len;
+		u32 max_name_len;
+		u32 total_size;
+		u32 name_hash;
+		u8 dir_type;
+
+		/* header itself should not cross item boundary */
+		if (cur + sizeof(*di) > item_size) {
+			dir_item_err(root, leaf, slot,
+		"dir item header crosses item boundary, have %lu boundary %u",
+				cur + sizeof(*di), item_size);
+			return -EUCLEAN;
+		}
+
+		/* dir type check */
+		dir_type = btrfs_dir_type(leaf, di);
+		if (dir_type >= BTRFS_FT_MAX) {
+			dir_item_err(root, leaf, slot,
+			"invalid dir item type, have %u expect [0, %u)",
+				dir_type, BTRFS_FT_MAX);
+			return -EUCLEAN;
+		}
+
+		if (key->type == BTRFS_XATTR_ITEM_KEY &&
+		    dir_type != BTRFS_FT_XATTR) {
+			dir_item_err(root, leaf, slot,
+		"invalid dir item type for XATTR key, have %u expect %u",
+				dir_type, BTRFS_FT_XATTR);
+			return -EUCLEAN;
+		}
+		if (dir_type == BTRFS_FT_XATTR &&
+		    key->type != BTRFS_XATTR_ITEM_KEY) {
+			dir_item_err(root, leaf, slot,
+			"xattr dir type found for non-XATTR key");
+			return -EUCLEAN;
+		}
+		if (dir_type == BTRFS_FT_XATTR)
+			max_name_len = XATTR_NAME_MAX;
+		else
+			max_name_len = BTRFS_NAME_LEN;
+
+		/* Name/data length check */
+		name_len = btrfs_dir_name_len(leaf, di);
+		data_len = btrfs_dir_data_len(leaf, di);
+		if (name_len > max_name_len) {
+			dir_item_err(root, leaf, slot,
+			"dir item name len too long, have %u max %u",
+				name_len, max_name_len);
+			return -EUCLEAN;
+		}
+		if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root)) {
+			dir_item_err(root, leaf, slot,
+			"dir item name and data len too long, have %u max %zu",
+				name_len + data_len,
+				BTRFS_MAX_XATTR_SIZE(root));
+			return -EUCLEAN;
+		}
+
+		if (data_len && dir_type != BTRFS_FT_XATTR) {
+			dir_item_err(root, leaf, slot,
+			"dir item with invalid data len, have %u expect 0",
+				data_len);
+			return -EUCLEAN;
+		}
+
+		total_size = sizeof(*di) + name_len + data_len;
+
+		/* header and name/data should not cross item boundary */
+		if (cur + total_size > item_size) {
+			dir_item_err(root, leaf, slot,
+		"dir item data crosses item boundary, have %u boundary %u",
+				cur + total_size, item_size);
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Special check for XATTR/DIR_ITEM, as key->offset is name
+		 * hash, should match its name
+		 */
+		if (key->type == BTRFS_DIR_ITEM_KEY ||
+		    key->type == BTRFS_XATTR_ITEM_KEY) {
+			read_extent_buffer(leaf, namebuf,
+					(unsigned long)(di + 1), name_len);
+			name_hash = btrfs_name_hash(namebuf, name_len);
+			if (key->offset != name_hash) {
+				dir_item_err(root, leaf, slot,
+		"name hash mismatch with key, have 0x%016x expect 0x%016llx",
+					name_hash, key->offset);
+				return -EUCLEAN;
+			}
+		}
+		cur += total_size;
+		di = (struct btrfs_dir_item *)((void *)di + total_size);
+	}
+	return 0;
+}
+
+/*
  * Common point to switch the item-specific validation.
  */
 static int check_leaf_item(struct btrfs_root *root,
@@ -191,6 +327,11 @@ static int check_leaf_item(struct btrfs_
 	case BTRFS_EXTENT_CSUM_KEY:
 		ret = check_csum_item(root, leaf, key, slot);
 		break;
+	case BTRFS_DIR_ITEM_KEY:
+	case BTRFS_DIR_INDEX_KEY:
+	case BTRFS_XATTR_ITEM_KEY:
+		ret = check_dir_item(root, leaf, key, slot);
+		break;
 	}
 	return ret;
 }

