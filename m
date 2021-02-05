Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32256310E14
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhBEPFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233067AbhBEPCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA8B76504A;
        Fri,  5 Feb 2021 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534327;
        bh=rOu5yDcGGSPkN6O0ZC2g6yc75dhE4RKFd28GfC/QVBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJjlX3jEI4sKYwPRtMfj6IaINsFowKeXTAoQMishdM7SmASgh87gmNS5SykHgH7Pt
         1DKR0sazFkSLwyx/BuuFHruI1cXIbaL+Et7PY5gvSrLnnyjYghUeb+cNqAigExPIGm
         Vna2cK2BiY0/WCxMSPakc0U/M8EkjFRsS8xlgSlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        ethanwu <ethanwu@synology.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 12/32] btrfs: backref, use correct count to resolve normal data refs
Date:   Fri,  5 Feb 2021 15:07:27 +0100
Message-Id: <20210205140652.872668805@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ethanwu <ethanwu@synology.com>

commit b25b0b871f206936d5bca02b80d38c05623e27da upstream.

With the following patches:

- btrfs: backref, only collect file extent items matching backref offset
- btrfs: backref, not adding refs from shared block when resolving normal backref
- btrfs: backref, only search backref entries from leaves of the same root

we only collect the normal data refs we want, so the imprecise upper
bound total_refs of that EXTENT_ITEM could now be changed to the count
of the normal backref entry we want to search.

Background and how the patches fit together:

Btrfs has two types of data backref.
For BTRFS_EXTENT_DATA_REF_KEY type of backref, we don't have the
exact block number. Therefore, we need to call resolve_indirect_refs.
It uses btrfs_search_slot to locate the leaf block. Then
we need to walk through the leaves to search for the EXTENT_DATA items
that have disk bytenr matching the extent item (add_all_parents).

When resolving indirect refs, we could take entries that don't
belong to the backref entry we are searching for right now.
For that reason when searching backref entry, we always use total
refs of that EXTENT_ITEM rather than individual count.

For example:
item 11 key (40831553536 EXTENT_ITEM 4194304) itemoff 15460 itemsize
  extent refs 24 gen 7302 flags DATA
  shared data backref parent 394985472 count 10 #1
  extent data backref root 257 objectid 260 offset 1048576 count 3 #2
  extent data backref root 256 objectid 260 offset 65536 count 6 #3
  extent data backref root 257 objectid 260 offset 65536 count 5 #4

For example, when searching backref entry #4, we'll use total_refs
24, a very loose loop ending condition, instead of total_refs = 5.

But using total_refs = 24 is not accurate. Sometimes, we'll never find
all the refs from specific root.  As a result, the loop keeps on going
until we reach the end of that inode.

The first 3 patches, handle 3 different types refs we might encounter.
These refs do not belong to the normal backref we are searching, and
hence need to be skipped.

This patch changes the total_refs to correct number so that we could
end loop as soon as we find all the refs we want.

btrfs send uses backref to find possible clone sources, the following
is a simple test to compare the results with and without this patch:

 $ btrfs subvolume create /sub1
 $ for i in `seq 1 163840`; do
     dd if=/dev/zero of=/sub1/file bs=64K count=1 seek=$((i-1)) conv=notrunc oflag=direct
   done
 $ btrfs subvolume snapshot /sub1 /sub2
 $ for i in `seq 1 163840`; do
     dd if=/dev/zero of=/sub1/file bs=4K count=1 seek=$(((i-1)*16+10)) conv=notrunc oflag=direct
   done
 $ btrfs subvolume snapshot -r /sub1 /snap1
 $ time btrfs send /snap1 | btrfs receive /volume2

Without this patch:

real 69m48.124s
user 0m50.199s
sys  70m15.600s

With this patch:

real    1m59.683s
user    0m35.421s
sys     2m42.684s

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: ethanwu <ethanwu@synology.com>
[ add patchset cover letter with background and numbers ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -415,7 +415,7 @@ static int add_all_parents(struct btrfs_
 			   struct ulist *parents,
 			   struct preftrees *preftrees, struct prelim_ref *ref,
 			   int level, u64 time_seq, const u64 *extent_item_pos,
-			   u64 total_refs, bool ignore_offset)
+			   bool ignore_offset)
 {
 	int ret = 0;
 	int slot;
@@ -457,7 +457,7 @@ static int add_all_parents(struct btrfs_
 			ret = btrfs_next_old_leaf(root, path, time_seq);
 	}
 
-	while (!ret && count < total_refs) {
+	while (!ret && count < ref->count) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
 
@@ -534,8 +534,7 @@ static int resolve_indirect_ref(struct b
 				struct btrfs_path *path, u64 time_seq,
 				struct preftrees *preftrees,
 				struct prelim_ref *ref, struct ulist *parents,
-				const u64 *extent_item_pos, u64 total_refs,
-				bool ignore_offset)
+				const u64 *extent_item_pos, bool ignore_offset)
 {
 	struct btrfs_root *root;
 	struct btrfs_key root_key;
@@ -627,7 +626,7 @@ static int resolve_indirect_ref(struct b
 	}
 
 	ret = add_all_parents(root, path, parents, preftrees, ref, level,
-			      time_seq, extent_item_pos, total_refs, ignore_offset);
+			      time_seq, extent_item_pos, ignore_offset);
 out:
 	path->lowest_level = 0;
 	btrfs_release_path(path);
@@ -661,7 +660,7 @@ unode_aux_to_inode_list(struct ulist_nod
 static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path, u64 time_seq,
 				 struct preftrees *preftrees,
-				 const u64 *extent_item_pos, u64 total_refs,
+				 const u64 *extent_item_pos,
 				 struct share_check *sc, bool ignore_offset)
 {
 	int err;
@@ -707,7 +706,7 @@ static int resolve_indirect_refs(struct
 		}
 		err = resolve_indirect_ref(fs_info, path, time_seq, preftrees,
 					   ref, parents, extent_item_pos,
-					   total_refs, ignore_offset);
+					   ignore_offset);
 		/*
 		 * we can only tolerate ENOENT,otherwise,we should catch error
 		 * and return directly.
@@ -810,8 +809,7 @@ static int add_missing_keys(struct btrfs
  */
 static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			    struct btrfs_delayed_ref_head *head, u64 seq,
-			    struct preftrees *preftrees, u64 *total_refs,
-			    struct share_check *sc)
+			    struct preftrees *preftrees, struct share_check *sc)
 {
 	struct btrfs_delayed_ref_node *node;
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
@@ -845,7 +843,6 @@ static int add_delayed_refs(const struct
 		default:
 			BUG();
 		}
-		*total_refs += count;
 		switch (node->type) {
 		case BTRFS_TREE_BLOCK_REF_KEY: {
 			/* NORMAL INDIRECT METADATA backref */
@@ -928,7 +925,7 @@ out:
 static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			   struct btrfs_path *path, u64 bytenr,
 			   int *info_level, struct preftrees *preftrees,
-			   u64 *total_refs, struct share_check *sc)
+			   struct share_check *sc)
 {
 	int ret = 0;
 	int slot;
@@ -952,7 +949,6 @@ static int add_inline_refs(const struct
 
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(leaf, ei);
-	*total_refs += btrfs_extent_refs(leaf, ei);
 	btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 	ptr = (unsigned long)(ei + 1);
@@ -1177,8 +1173,6 @@ static int find_parent_nodes(struct btrf
 	struct prelim_ref *ref;
 	struct rb_node *node;
 	struct extent_inode_elem *eie = NULL;
-	/* total of both direct AND indirect refs! */
-	u64 total_refs = 0;
 	struct preftrees preftrees = {
 		.direct = PREFTREE_INIT,
 		.indirect = PREFTREE_INIT,
@@ -1247,7 +1241,7 @@ again:
 			}
 			spin_unlock(&delayed_refs->lock);
 			ret = add_delayed_refs(fs_info, head, time_seq,
-					       &preftrees, &total_refs, sc);
+					       &preftrees, sc);
 			mutex_unlock(&head->mutex);
 			if (ret)
 				goto out;
@@ -1268,8 +1262,7 @@ again:
 		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
 			ret = add_inline_refs(fs_info, path, bytenr,
-					      &info_level, &preftrees,
-					      &total_refs, sc);
+					      &info_level, &preftrees, sc);
 			if (ret)
 				goto out;
 			ret = add_keyed_refs(fs_info, path, bytenr, info_level,
@@ -1288,7 +1281,7 @@ again:
 	WARN_ON(!RB_EMPTY_ROOT(&preftrees.indirect_missing_keys.root.rb_root));
 
 	ret = resolve_indirect_refs(fs_info, path, time_seq, &preftrees,
-				    extent_item_pos, total_refs, sc, ignore_offset);
+				    extent_item_pos, sc, ignore_offset);
 	if (ret)
 		goto out;
 


