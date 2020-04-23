Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4201B6976
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgDWXXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:23:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48332 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728156AbgDWXGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:30 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004ah-04; Fri, 24 Apr 2020 00:06:26 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6hB-0d; Fri, 24 Apr 2020 00:06:25 +0100
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
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Nikolay Borisov" <nborisov@suse.com>
Date:   Fri, 24 Apr 2020 00:04:25 +0100
Message-ID: <lsq.1587683028.906525566@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 038/245] btrfs: Refactor check_leaf function for
 later expansion
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

commit c3267bbaa9cae09b62960eafe33ad19196803285 upstream.

Current check_leaf() function does a good job checking key order and
item offset/size.

However it only checks from slot 0 to the last but one slot, this is
good but makes later expansion hard.

So this refactoring iterates from slot 0 to the last slot.
For key comparison, it uses a key with all 0 as initial key, so all
valid keys should be larger than that.

And for item size/offset checks, it compares current item end with
previous item offset.
For slot 0, use leaf end as a special case.

This makes later item/key offset checks and item size checks easier to
be implemented.

Also, makes check_leaf() to return -EUCLEAN other than -EIO to indicate
error.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4:
 - BTRFS_LEAF_DATA_SIZE() takes a root rather than an fs_info
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/disk-io.c | 50 +++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -516,8 +516,9 @@ static int check_tree_block_fsid(struct
 static noinline int check_leaf(struct btrfs_root *root,
 			       struct extent_buffer *leaf)
 {
+	/* No valid key type is 0, so all key should be larger than this key */
+	struct btrfs_key prev_key = {0, 0, 0};
 	struct btrfs_key key;
-	struct btrfs_key leaf_key;
 	u32 nritems = btrfs_header_nritems(leaf);
 	int slot;
 
@@ -550,7 +551,7 @@ static noinline int check_leaf(struct bt
 				CORRUPT("non-root leaf's nritems is 0",
 					leaf, check_root, 0);
 				free_extent_buffer(eb);
-				return -EIO;
+				return -EUCLEAN;
 			}
 			free_extent_buffer(eb);
 		}
@@ -560,28 +561,23 @@ static noinline int check_leaf(struct bt
 	if (nritems == 0)
 		return 0;
 
-	/* Check the 0 item */
-	if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
-	    BTRFS_LEAF_DATA_SIZE(root)) {
-		CORRUPT("invalid item offset size pair", leaf, root, 0);
-		return -EIO;
-	}
-
 	/*
-	 * Check to make sure each items keys are in the correct order and their
-	 * offsets make sense.  We only have to loop through nritems-1 because
-	 * we check the current slot against the next slot, which verifies the
-	 * next slot's offset+size makes sense and that the current's slot
-	 * offset is correct.
+	 * Check the following things to make sure this is a good leaf, and
+	 * leaf users won't need to bother with similar sanity checks:
+	 *
+	 * 1) key order
+	 * 2) item offset and size
+	 *    No overlap, no hole, all inside the leaf.
 	 */
-	for (slot = 0; slot < nritems - 1; slot++) {
-		btrfs_item_key_to_cpu(leaf, &leaf_key, slot);
-		btrfs_item_key_to_cpu(leaf, &key, slot + 1);
+	for (slot = 0; slot < nritems; slot++) {
+		u32 item_end_expected;
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
 
 		/* Make sure the keys are in the right order */
-		if (btrfs_comp_cpu_keys(&leaf_key, &key) >= 0) {
+		if (btrfs_comp_cpu_keys(&prev_key, &key) >= 0) {
 			CORRUPT("bad key order", leaf, root, slot);
-			return -EIO;
+			return -EUCLEAN;
 		}
 
 		/*
@@ -589,10 +585,14 @@ static noinline int check_leaf(struct bt
 		 * item data starts at the end of the leaf and grows towards the
 		 * front.
 		 */
-		if (btrfs_item_offset_nr(leaf, slot) !=
-			btrfs_item_end_nr(leaf, slot + 1)) {
+		if (slot == 0)
+			item_end_expected = BTRFS_LEAF_DATA_SIZE(root);
+		else
+			item_end_expected = btrfs_item_offset_nr(leaf,
+								 slot - 1);
+		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
 			CORRUPT("slot offset bad", leaf, root, slot);
-			return -EIO;
+			return -EUCLEAN;
 		}
 
 		/*
@@ -603,8 +603,12 @@ static noinline int check_leaf(struct bt
 		if (btrfs_item_end_nr(leaf, slot) >
 		    BTRFS_LEAF_DATA_SIZE(root)) {
 			CORRUPT("slot end outside of leaf", leaf, root, slot);
-			return -EIO;
+			return -EUCLEAN;
 		}
+
+		prev_key.objectid = key.objectid;
+		prev_key.type = key.type;
+		prev_key.offset = key.offset;
 	}
 
 	return 0;

