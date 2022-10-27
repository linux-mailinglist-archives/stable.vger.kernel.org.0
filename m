Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E26D60FE9A
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbiJ0RGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236995AbiJ0RGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4461512FFAB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D183D623F4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC156C433C1;
        Thu, 27 Oct 2022 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890401;
        bh=to4aaDWRVtP0YrzaiMJ1i4k290ti6zJ0rxijbLN07gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2LDxF9gucPD8JNDLSas3Iyj4yfhUe2EUXu0iVAqtVBSgptBFDWXBA2Ka8oaCNmFo
         5aC0+RE3I1wsGbfbXCUDeIv7oDIKokAKQUgHq/0tDPLiiCGx9LxUUFHziWMCk8cxGq
         yfQ6vfgFmrWKsy9hfA/tZB2ZtUWj6eibISU7/9ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/79] btrfs: fix processing of delayed tree block refs during backref walking
Date:   Thu, 27 Oct 2022 18:55:36 +0200
Message-Id: <20221027165055.277945148@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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

[ Upstream commit 943553ef9b51db303ab2b955c1025261abfdf6fb ]

During backref walking, when processing a delayed reference with a type of
BTRFS_TREE_BLOCK_REF_KEY, we have two bugs there:

1) We are accessing the delayed references extent_op, and its key, without
   the protection of the delayed ref head's lock;

2) If there's no extent op for the delayed ref head, we end up with an
   uninitialized key in the stack, variable 'tmp_op_key', and then pass
   it to add_indirect_ref(), which adds the reference to the indirect
   refs rb tree.

   This is wrong, because indirect references should have a NULL key
   when we don't have access to the key, and in that case they should be
   added to the indirect_missing_keys rb tree and not to the indirect rb
   tree.

   This means that if have BTRFS_TREE_BLOCK_REF_KEY delayed ref resulting
   from freeing an extent buffer, therefore with a count of -1, it will
   not cancel out the corresponding reference we have in the extent tree
   (with a count of 1), since both references end up in different rb
   trees.

   When using fiemap, where we often need to check if extents are shared
   through shared subtrees resulting from snapshots, it means we can
   incorrectly report an extent as shared when it's no longer shared.
   However this is temporary because after the transaction is committed
   the extent is no longer reported as shared, as running the delayed
   reference results in deleting the tree block reference from the extent
   tree.

   Outside the fiemap context, the result is unpredictable, as the key was
   not initialized but it's used when navigating the rb trees to insert
   and search for references (prelim_ref_compare()), and we expect all
   references in the indirect rb tree to have valid keys.

The following reproducer triggers the second bug:

   $ cat test.sh
   #!/bin/bash

   DEV=/dev/sdj
   MNT=/mnt/sdj

   mkfs.btrfs -f $DEV
   mount -o compress $DEV $MNT

   # With a compressed 128M file we get a tree height of 2 (level 1 root).
   xfs_io -f -c "pwrite -b 1M 0 128M" $MNT/foo

   btrfs subvolume snapshot $MNT $MNT/snap

   # Fiemap should output 0x2008 in the flags column.
   # 0x2000 means shared extent
   # 0x8 means encoded extent (because it's compressed)
   echo
   echo "fiemap after snapshot, range [120M, 120M + 128K):"
   xfs_io -c "fiemap -v 120M 128K" $MNT/foo
   echo

   # Overwrite one extent and fsync to flush delalloc and COW a new path
   # in the snapshot's tree.
   #
   # After this we have a BTRFS_DROP_DELAYED_REF delayed ref of type
   # BTRFS_TREE_BLOCK_REF_KEY with a count of -1 for every COWed extent
   # buffer in the path.
   #
   # In the extent tree we have inline references of type
   # BTRFS_TREE_BLOCK_REF_KEY, with a count of 1, for the same extent
   # buffers, so they should cancel each other, and the extent buffers in
   # the fs tree should no longer be considered as shared.
   #
   echo "Overwriting file range [120M, 120M + 128K)..."
   xfs_io -c "pwrite -b 128K 120M 128K" $MNT/snap/foo
   xfs_io -c "fsync" $MNT/snap/foo

   # Fiemap should output 0x8 in the flags column. The extent in the range
   # [120M, 120M + 128K) is no longer shared, it's now exclusive to the fs
   # tree.
   echo
   echo "fiemap after overwrite range [120M, 120M + 128K):"
   xfs_io -c "fiemap -v 120M 128K" $MNT/foo
   echo

   umount $MNT

Running it before this patch:

   $ ./test.sh
   (...)
   wrote 134217728/134217728 bytes at offset 0
   128 MiB, 128 ops; 0.1152 sec (1.085 GiB/sec and 1110.5809 ops/sec)
   Create a snapshot of '/mnt/sdj' in '/mnt/sdj/snap'

   fiemap after snapshot, range [120M, 120M + 128K):
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [245760..246015]: 34304..34559       256 0x2008

   Overwriting file range [120M, 120M + 128K)...
   wrote 131072/131072 bytes at offset 125829120
   128 KiB, 1 ops; 0.0001 sec (683.060 MiB/sec and 5464.4809 ops/sec)

   fiemap after overwrite range [120M, 120M + 128K):
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [245760..246015]: 34304..34559       256 0x2008

The extent in the range [120M, 120M + 128K) is still reported as shared
(0x2000 bit set) after overwriting that range and flushing delalloc, which
is not correct - an entire path was COWed in the snapshot's tree and the
extent is now only referenced by the original fs tree.

Running it after this patch:

   $ ./test.sh
   (...)
   wrote 134217728/134217728 bytes at offset 0
   128 MiB, 128 ops; 0.1198 sec (1.043 GiB/sec and 1068.2067 ops/sec)
   Create a snapshot of '/mnt/sdj' in '/mnt/sdj/snap'

   fiemap after snapshot, range [120M, 120M + 128K):
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [245760..246015]: 34304..34559       256 0x2008

   Overwriting file range [120M, 120M + 128K)...
   wrote 131072/131072 bytes at offset 125829120
   128 KiB, 1 ops; 0.0001 sec (694.444 MiB/sec and 5555.5556 ops/sec)

   fiemap after overwrite range [120M, 120M + 128K):
   /mnt/sdj/foo:
    EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
      0: [245760..246015]: 34304..34559       256   0x8

Now the extent is not reported as shared anymore.

So fix this by passing a NULL key pointer to add_indirect_ref() when
processing a delayed reference for a tree block if there's no extent op
for our delayed ref head with a defined key. Also access the extent op
only after locking the delayed ref head's lock.

The reproducer will be converted later to a test case for fstests.

Fixes: 86d5f994425252 ("btrfs: convert prelimary reference tracking to use rbtrees")
Fixes: a6dbceafb915e8 ("btrfs: Remove unused op_key var from add_delayed_refs")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7e8fac12f3f8..92cb16c0e5ee 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -818,16 +818,11 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			    struct preftrees *preftrees, struct share_check *sc)
 {
 	struct btrfs_delayed_ref_node *node;
-	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct btrfs_key key;
-	struct btrfs_key tmp_op_key;
 	struct rb_node *n;
 	int count;
 	int ret = 0;
 
-	if (extent_op && extent_op->update_key)
-		btrfs_disk_key_to_cpu(&tmp_op_key, &extent_op->key);
-
 	spin_lock(&head->lock);
 	for (n = rb_first_cached(&head->ref_tree); n; n = rb_next(n)) {
 		node = rb_entry(n, struct btrfs_delayed_ref_node,
@@ -853,10 +848,16 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 		case BTRFS_TREE_BLOCK_REF_KEY: {
 			/* NORMAL INDIRECT METADATA backref */
 			struct btrfs_delayed_tree_ref *ref;
+			struct btrfs_key *key_ptr = NULL;
+
+			if (head->extent_op && head->extent_op->update_key) {
+				btrfs_disk_key_to_cpu(&key, &head->extent_op->key);
+				key_ptr = &key;
+			}
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
-					       &tmp_op_key, ref->level + 1,
+					       key_ptr, ref->level + 1,
 					       node->bytenr, count, sc,
 					       GFP_ATOMIC);
 			break;
-- 
2.35.1



