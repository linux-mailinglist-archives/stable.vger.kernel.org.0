Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521961B694D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgDWXWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:22:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48456 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbgDWXGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:31 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004ay-BC; Fri, 24 Apr 2020 00:06:26 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6he-AD; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Qu Wenruo" <wqu@suse.com>, "Filipe Manana" <fdmanana@gmail.com>,
        "Liu Bo" <bo.li.liu@oracle.com>, "David Sterba" <dsterba@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date:   Fri, 24 Apr 2020 00:04:31 +0100
Message-ID: <lsq.1587683028.815585833@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 044/245] btrfs: tree-checker: Fix false panic for
 sanity test
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

commit 69fc6cbbac542c349b3d350d10f6e394c253c81d upstream.

[BUG]
If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y, it will
instantly cause kernel panic like:

------
...
assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
...
Call Trace:
 btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
 setup_items_for_insert+0x385/0x650 [btrfs]
 __btrfs_drop_extents+0x129a/0x1870 [btrfs]
...
-----

[Cause]
Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to check
if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.

However quite some btrfs_mark_buffer_dirty() callers(*) don't really
initialize its item data but only initialize its item pointers, leaving
item data uninitialized.

This makes tree-checker catch uninitialized data as error, causing
such panic.

*: These callers include but not limited to
setup_items_for_insert()
btrfs_split_item()
btrfs_expand_item()

[Fix]
Add a new parameter @check_item_data to btrfs_check_leaf().
With @check_item_data set to false, item data check will be skipped and
fallback to old btrfs_check_leaf() behavior.

So we can still get early warning if we screw up item pointers, and
avoid false panic.

Cc: Filipe Manana <fdmanana@gmail.com>
Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/disk-io.c      | 10 ++++++++--
 fs/btrfs/tree-checker.c | 27 ++++++++++++++++++++++-----
 fs/btrfs/tree-checker.h | 14 +++++++++++++-
 3 files changed, 43 insertions(+), 8 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -575,7 +575,7 @@ static int btree_readpage_end_io_hook(st
 	 * that we don't try and read the other copies of this block, just
 	 * return -EIO.
 	 */
-	if (found_level == 0 && btrfs_check_leaf(root, eb)) {
+	if (found_level == 0 && btrfs_check_leaf_full(root, eb)) {
 		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 		ret = -EIO;
 	}
@@ -3702,7 +3702,13 @@ void btrfs_mark_buffer_dirty(struct exte
 				     buf->len,
 				     root->fs_info->dirty_metadata_batch);
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-	if (btrfs_header_level(buf) == 0 && btrfs_check_leaf(root, buf)) {
+	/*
+	 * Since btrfs_mark_buffer_dirty() can be called with item pointer set
+	 * but item data not updated.
+	 * So here we should only check item pointers, not item data.
+	 */
+	if (btrfs_header_level(buf) == 0 &&
+	    btrfs_check_leaf_relaxed(root, buf)) {
 		btrfs_print_leaf(root, buf);
 		ASSERT(0);
 	}
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -195,7 +195,8 @@ static int check_leaf_item(struct btrfs_
 	return ret;
 }
 
-int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
+static int check_leaf(struct btrfs_root *root, struct extent_buffer *leaf,
+		      bool check_item_data)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	/* No valid key type is 0, so all key should be larger than this key */
@@ -299,10 +300,15 @@ int btrfs_check_leaf(struct btrfs_root *
 			return -EUCLEAN;
 		}
 
-		/* Check if the item size and content meet other criteria */
-		ret = check_leaf_item(root, leaf, &key, slot);
-		if (ret < 0)
-			return ret;
+		if (check_item_data) {
+			/*
+			 * Check if the item size and content meet other
+			 * criteria
+			 */
+			ret = check_leaf_item(root, leaf, &key, slot);
+			if (ret < 0)
+				return ret;
+		}
 
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
@@ -312,6 +318,17 @@ int btrfs_check_leaf(struct btrfs_root *
 	return 0;
 }
 
+int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buffer *leaf)
+{
+	return check_leaf(root, leaf, true);
+}
+
+int btrfs_check_leaf_relaxed(struct btrfs_root *root,
+			     struct extent_buffer *leaf)
+{
+	return check_leaf(root, leaf, false);
+}
+
 int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
 {
 	unsigned long nr = btrfs_header_nritems(node);
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -20,7 +20,19 @@
 #include "ctree.h"
 #include "extent_io.h"
 
-int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf);
+/*
+ * Comprehensive leaf checker.
+ * Will check not only the item pointers, but also every possible member
+ * in item data.
+ */
+int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buffer *leaf);
+
+/*
+ * Less strict leaf checker.
+ * Will only check item pointers, not reading item data.
+ */
+int btrfs_check_leaf_relaxed(struct btrfs_root *root,
+			     struct extent_buffer *leaf);
 int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node);
 
 #endif

