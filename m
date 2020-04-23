Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B0F1B6944
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgDWXVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:21:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48524 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728197AbgDWXGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:32 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bF-0G; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6i3-Ih; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Xu Wen" <wen.xu@gatech.edu>, "David Sterba" <dsterba@suse.com>,
        "Gu Jinxiang" <gujx@cn.fujitsu.com>, "Qu Wenruo" <wqu@suse.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:36 +0100
Message-ID: <lsq.1587683028.60741686@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 049/245] btrfs: tree-checker: Detect invalid and
 empty essential trees
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

commit ba480dd4db9f1798541eb2d1c423fc95feee8d36 upstream.

A crafted image has empty root tree block, which will later cause NULL
pointer dereference.

The following trees should never be empty:
1) Tree root
   Must contain at least root items for extent tree, device tree and fs
   tree

2) Chunk tree
   Or we can't even bootstrap as it contains the mapping.

3) Fs tree
   At least inode item for top level inode (.).

4) Device tree
   Dev extents for chunks

5) Extent tree
   Must have corresponding extent for each chunk.

If any of them is empty, we are sure the fs is corrupted and no need to
mount it.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199847
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Tested-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.4: Pass root instead of fs_info to generic_err()]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/tree-checker.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -456,9 +456,22 @@ static int check_leaf(struct btrfs_root
 	 * skip this check for relocation trees.
 	 */
 	if (nritems == 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
+		u64 owner = btrfs_header_owner(leaf);
 		struct btrfs_root *check_root;
 
-		key.objectid = btrfs_header_owner(leaf);
+		/* These trees must never be empty */
+		if (owner == BTRFS_ROOT_TREE_OBJECTID ||
+		    owner == BTRFS_CHUNK_TREE_OBJECTID ||
+		    owner == BTRFS_EXTENT_TREE_OBJECTID ||
+		    owner == BTRFS_DEV_TREE_OBJECTID ||
+		    owner == BTRFS_FS_TREE_OBJECTID ||
+		    owner == BTRFS_DATA_RELOC_TREE_OBJECTID) {
+			generic_err(root, leaf, 0,
+			"invalid root, root %llu must never be empty",
+				    owner);
+			return -EUCLEAN;
+		}
+		key.objectid = owner;
 		key.type = BTRFS_ROOT_ITEM_KEY;
 		key.offset = (u64)-1;
 

