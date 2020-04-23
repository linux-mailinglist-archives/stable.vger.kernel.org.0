Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01581B6992
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgDWXYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48288 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728137AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004aU-Mc; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6gv-Ny; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "David Sterba" <dsterba@suse.com>, "Liu Bo" <bo.li.liu@oracle.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:22 +0100
Message-ID: <lsq.1587683028.381048962@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 035/245] Btrfs: memset to avoid stale content in
 btree leaf
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

commit 851cd173f06045816528176001cf82948282029c upstream.

This is an additional patch to
"Btrfs: memset to avoid stale content in btree node block".

This uses memset to initialize the unused space in a leaf to avoid
potential stale content, which may be incurred by pushing items
between sibling leaves.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/ctree.c     | 14 --------------
 fs/btrfs/ctree.h     | 15 +++++++++++++++
 fs/btrfs/extent_io.c | 18 +++++++++++++-----
 3 files changed, 28 insertions(+), 19 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1721,20 +1721,6 @@ int btrfs_realloc_node(struct btrfs_tran
 	return err;
 }
 
-/*
- * The leaf data grows from end-to-front in the node.
- * this returns the address of the start of the last item,
- * which is the stop of the leaf data stack
- */
-static inline unsigned int leaf_data_end(struct btrfs_root *root,
-					 struct extent_buffer *leaf)
-{
-	u32 nr = btrfs_header_nritems(leaf);
-	if (nr == 0)
-		return BTRFS_LEAF_DATA_SIZE(root);
-	return btrfs_item_offset_nr(leaf, nr - 1);
-}
-
 
 /*
  * search for key in the extent_buffer.  The items start at offset p,
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3036,6 +3036,21 @@ static inline unsigned long btrfs_leaf_d
 	return offsetof(struct btrfs_leaf, items);
 }
 
+/*
+ * The leaf data grows from end-to-front in the node.
+ * this returns the address of the start of the last item,
+ * which is the stop of the leaf data stack
+ */
+static inline unsigned int leaf_data_end(struct btrfs_root *root,
+					 struct extent_buffer *leaf)
+{
+	u32 nr = btrfs_header_nritems(leaf);
+
+	if (nr == 0)
+		return BTRFS_LEAF_DATA_SIZE(root);
+	return btrfs_item_offset_nr(leaf, nr - 1);
+}
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_bytenr,
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3617,8 +3617,10 @@ static noinline_for_stack int write_one_
 	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
 	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
 	u64 offset = eb->start;
+	u32 nritems;
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
+	unsigned long start, end;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
 	int ret = 0;
 
@@ -3628,15 +3630,21 @@ static noinline_for_stack int write_one_
 	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 		bio_flags = EXTENT_BIO_TREE_LOG;
 
-	/* set btree node beyond nritems with 0 to avoid stale content */
+	/* set btree blocks beyond nritems with 0 to avoid stale content. */
+	nritems = btrfs_header_nritems(eb);
 	if (btrfs_header_level(eb) > 0) {
-		u32 nritems;
-		unsigned long end;
-
-		nritems = btrfs_header_nritems(eb);
 		end = btrfs_node_key_ptr_offset(nritems);
 
 		memset_extent_buffer(eb, 0, end, eb->len - end);
+	} else {
+		/*
+		 * leaf:
+		 * header 0 1 2 .. N ... data_N .. data_2 data_1 data_0
+		 */
+		start = btrfs_item_nr_offset(nritems);
+		end = btrfs_leaf_data(eb) +
+		      leaf_data_end(fs_info->tree_root, eb);
+		memset_extent_buffer(eb, 0, start, end - start);
 	}
 
 	for (i = 0; i < num_pages; i++) {

