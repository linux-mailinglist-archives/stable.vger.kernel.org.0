Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C560FEE4
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbiJ0RJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbiJ0RJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:09:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1E4199F5E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFDFC62401
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FE8C433D6;
        Thu, 27 Oct 2022 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890561;
        bh=CyQx9GAUGWXzWn70pCCL3CyRegRQSdJSZRzbAt8lbAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QplbHnP2NibLStHiQZOFqN+z6bJloQfHStXEAo7xxymgu5Gy8DjTWgS0sTckTX2wX
         qPUTS294pyEsEqoyFP8dn5/OjM1ooxGSt4/oYTBDaIPwtW6pqdhKJMNBg+QFiqO3NI
         ecfMRjsbBEi1CqVf8uDGO1Obg5ywsGHcHtDRXnaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/53] btrfs: fix processing of delayed data refs during backref walking
Date:   Thu, 27 Oct 2022 18:56:25 +0200
Message-Id: <20221027165051.229185052@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 4fc7b57228243d09c0d878873bf24fa64a90fa01 ]

When processing delayed data references during backref walking and we are
using a share context (we are being called through fiemap), whenever we
find a delayed data reference for an inode different from the one we are
interested in, then we immediately exit and consider the data extent as
shared. This is wrong, because:

1) This might be a DROP reference that will cancel out a reference in the
   extent tree;

2) Even if it's an ADD reference, it may be followed by a DROP reference
   that cancels it out.

In either case we should not exit immediately.

Fix this by never exiting when we find a delayed data reference for
another inode - instead add the reference and if it does not cancel out
other delayed reference, we will exit early when we call
extent_is_shared() after processing all delayed references. If we find
a drop reference, then signal the code that processes references from
the extent tree (add_inline_refs() and add_keyed_refs()) to not exit
immediately if it finds there a reference for another inode, since we
have delayed drop references that may cancel it out. In this later case
we exit once we don't have references in the rb trees that cancel out
each other and have two references for different inodes.

Example reproducer for case 1):

   $ cat test-1.sh
   #!/bin/bash

   DEV=/dev/sdj
   MNT=/mnt/sdj

   mkfs.btrfs -f $DEV
   mount $DEV $MNT

   xfs_io -f -c "pwrite 0 64K" $MNT/foo
   cp --reflink=always $MNT/foo $MNT/bar

   echo
   echo "fiemap after cloning:"
   xfs_io -c "fiemap -v" $MNT/foo

   rm -f $MNT/bar
   echo
   echo "fiemap after removing file bar:"
   xfs_io -c "fiemap -v" $MNT/foo

   umount $MNT

Running it before this patch, the extent is still listed as shared, it has
the flag 0x2000 (FIEMAP_EXTENT_SHARED) set:

   $ ./test-1.sh
   fiemap after cloning:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128 0x2001

   fiemap after removing file bar:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128 0x2001

Example reproducer for case 2):

   $ cat test-2.sh
   #!/bin/bash

   DEV=/dev/sdj
   MNT=/mnt/sdj

   mkfs.btrfs -f $DEV
   mount $DEV $MNT

   xfs_io -f -c "pwrite 0 64K" $MNT/foo
   cp --reflink=always $MNT/foo $MNT/bar

   # Flush delayed references to the extent tree and commit current
   # transaction.
   sync

   echo
   echo "fiemap after cloning:"
   xfs_io -c "fiemap -v" $MNT/foo

   rm -f $MNT/bar
   echo
   echo "fiemap after removing file bar:"
   xfs_io -c "fiemap -v" $MNT/foo

   umount $MNT

Running it before this patch, the extent is still listed as shared, it has
the flag 0x2000 (FIEMAP_EXTENT_SHARED) set:

   $ ./test-2.sh
   fiemap after cloning:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128 0x2001

   fiemap after removing file bar:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128 0x2001

After this patch, after deleting bar in both tests, the extent is not
reported with the 0x2000 flag anymore, it gets only the flag 0x1
(which is FIEMAP_EXTENT_LAST):

   $ ./test-1.sh
   fiemap after cloning:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128 0x2001

   fiemap after removing file bar:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128   0x1

   $ ./test-2.sh
   fiemap after cloning:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128 0x2001

   fiemap after removing file bar:
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [0..127]:        26624..26751       128   0x1

These tests will later be converted to a test case for fstests.

Fixes: dc046b10c8b7d4 ("Btrfs: make fiemap not blow when you have lots of snapshots")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index c701a19fac53..9c969b90aec4 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -136,6 +136,7 @@ struct share_check {
 	u64 root_objectid;
 	u64 inum;
 	int share_count;
+	bool have_delayed_delete_refs;
 };
 
 static inline int extent_is_shared(struct share_check *sc)
@@ -876,13 +877,22 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			key.offset = ref->offset;
 
 			/*
-			 * Found a inum that doesn't match our known inum, we
-			 * know it's shared.
+			 * If we have a share check context and a reference for
+			 * another inode, we can't exit immediately. This is
+			 * because even if this is a BTRFS_ADD_DELAYED_REF
+			 * reference we may find next a BTRFS_DROP_DELAYED_REF
+			 * which cancels out this ADD reference.
+			 *
+			 * If this is a DROP reference and there was no previous
+			 * ADD reference, then we need to signal that when we
+			 * process references from the extent tree (through
+			 * add_inline_refs() and add_keyed_refs()), we should
+			 * not exit early if we find a reference for another
+			 * inode, because one of the delayed DROP references
+			 * may cancel that reference in the extent tree.
 			 */
-			if (sc && sc->inum && ref->objectid != sc->inum) {
-				ret = BACKREF_FOUND_SHARED;
-				goto out;
-			}
+			if (sc && count < 0)
+				sc->have_delayed_delete_refs = true;
 
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
 					       &key, 0, node->bytenr, count, sc,
@@ -912,7 +922,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 	}
 	if (!ret)
 		ret = extent_is_shared(sc);
-out:
+
 	spin_unlock(&head->lock);
 	return ret;
 }
@@ -1015,7 +1025,8 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1025,6 +1036,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			ret = add_indirect_ref(fs_info, preftrees, root,
 					       &key, 0, bytenr, count,
 					       sc, GFP_NOFS);
+
 			break;
 		}
 		default:
@@ -1114,7 +1126,8 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1537,6 +1550,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr,
 		.root_objectid = root->root_key.objectid,
 		.inum = inum,
 		.share_count = 0,
+		.have_delayed_delete_refs = false,
 	};
 
 	ulist_init(roots);
@@ -1571,6 +1585,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr,
 			break;
 		bytenr = node->val;
 		shared.share_count = 0;
+		shared.have_delayed_delete_refs = false;
 		cond_resched();
 	}
 
-- 
2.35.1



