Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAE8310E16
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhBEPEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233069AbhBEPCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FC3C65042;
        Fri,  5 Feb 2021 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534321;
        bh=RC4wRZDrZA0fZbK+UMQHFykRCWnDFMVXhScHL7ahyvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2Xc8UniRzTJ00cNICnVeU0+GAkh9mn6KpqOvL/bSHaNz+jqm95EG4LdLuBuGzq44
         rOglSDhV8d8VdZIvOQchoFyl1wii2ZzoLo1U/mZ313uWq+GFRmXMW6Ppbdd82VpOrS
         GDwiSK3JMt3jADZB8E226QeixdwVzdQ+aXfhdyzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        ethanwu <ethanwu@synology.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 10/32] btrfs: backref, dont add refs from shared block when resolving normal backref
Date:   Fri,  5 Feb 2021 15:07:25 +0100
Message-Id: <20210205140652.781147189@linuxfoundation.org>
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

commit ed58f2e66e849c34826083e5a6c1b506ee8a4d8e upstream.

All references from the block of SHARED_DATA_REF belong to that shared
block backref.

For example:

  item 11 key (40831553536 EXTENT_ITEM 4194304) itemoff 15460 itemsize 95
      extent refs 24 gen 7302 flags DATA
      extent data backref root 257 objectid 260 offset 65536 count 5
      extent data backref root 258 objectid 265 offset 0 count 9
      shared data backref parent 394985472 count 10

Block 394985472 might be leaf from root 257, and the item obejctid and
(file_pos - file_extent_item::offset) in that leaf just happens to be
260 and 65536 which is equal to the first extent data backref entry.

Before this patch, when we resolve backref:

  root 257 objectid 260 offset 65536

we will add those refs in block 394985472 and wrongly treat those as the
refs we want.

Fix this by checking if the leaf we are processing is shared data
backref, if so, just skip this leaf.

Shared data refs added into preftrees.direct have all entry value = 0
(root_id = 0, key = NULL, level = 0) except parent entry.

Other refs from indirect tree will have key value and root id != 0, and
these values won't be changed when their parent is resolved and added to
preftrees.direct. Therefore, we could reuse the preftrees.direct and
search ref with all values = 0 except parent is set to avoid getting
those resolved refs block.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: ethanwu <ethanwu@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/backref.c |   61 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 9 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -386,8 +386,34 @@ static int add_indirect_ref(const struct
 			      wanted_disk_byte, count, sc, gfp_mask);
 }
 
+static int is_shared_data_backref(struct preftrees *preftrees, u64 bytenr)
+{
+	struct rb_node **p = &preftrees->direct.root.rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct prelim_ref *ref = NULL;
+	struct prelim_ref target = {0};
+	int result;
+
+	target.parent = bytenr;
+
+	while (*p) {
+		parent = *p;
+		ref = rb_entry(parent, struct prelim_ref, rbnode);
+		result = prelim_ref_compare(ref, &target);
+
+		if (result < 0)
+			p = &(*p)->rb_left;
+		else if (result > 0)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+	return 0;
+}
+
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
-			   struct ulist *parents, struct prelim_ref *ref,
+			   struct ulist *parents,
+			   struct preftrees *preftrees, struct prelim_ref *ref,
 			   int level, u64 time_seq, const u64 *extent_item_pos,
 			   u64 total_refs, bool ignore_offset)
 {
@@ -412,11 +438,16 @@ static int add_all_parents(struct btrfs_
 	}
 
 	/*
-	 * We normally enter this function with the path already pointing to
-	 * the first item to check. But sometimes, we may enter it with
-	 * slot==nritems. In that case, go to the next leaf before we continue.
+	 * 1. We normally enter this function with the path already pointing to
+	 *    the first item to check. But sometimes, we may enter it with
+	 *    slot == nritems.
+	 * 2. We are searching for normal backref but bytenr of this leaf
+	 *    matches shared data backref
+	 * For these cases, go to the next leaf before we continue.
 	 */
-	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+	eb = path->nodes[0];
+	if (path->slots[0] >= btrfs_header_nritems(eb) ||
+	    is_shared_data_backref(preftrees, eb->start)) {
 		if (time_seq == SEQ_LAST)
 			ret = btrfs_next_leaf(root, path);
 		else
@@ -433,6 +464,17 @@ static int add_all_parents(struct btrfs_
 		    key.type != BTRFS_EXTENT_DATA_KEY)
 			break;
 
+		/*
+		 * We are searching for normal backref but bytenr of this leaf
+		 * matches shared data backref.
+		 */
+		if (slot == 0 && is_shared_data_backref(preftrees, eb->start)) {
+			if (time_seq == SEQ_LAST)
+				ret = btrfs_next_leaf(root, path);
+			else
+				ret = btrfs_next_old_leaf(root, path, time_seq);
+			continue;
+		}
 		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
 		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
 		data_offset = btrfs_file_extent_offset(eb, fi);
@@ -484,6 +526,7 @@ next:
  */
 static int resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path, u64 time_seq,
+				struct preftrees *preftrees,
 				struct prelim_ref *ref, struct ulist *parents,
 				const u64 *extent_item_pos, u64 total_refs,
 				bool ignore_offset)
@@ -577,8 +620,8 @@ static int resolve_indirect_ref(struct b
 		eb = path->nodes[level];
 	}
 
-	ret = add_all_parents(root, path, parents, ref, level, time_seq,
-			      extent_item_pos, total_refs, ignore_offset);
+	ret = add_all_parents(root, path, parents, preftrees, ref, level,
+			      time_seq, extent_item_pos, total_refs, ignore_offset);
 out:
 	path->lowest_level = 0;
 	btrfs_release_path(path);
@@ -656,8 +699,8 @@ static int resolve_indirect_refs(struct
 			ret = BACKREF_FOUND_SHARED;
 			goto out;
 		}
-		err = resolve_indirect_ref(fs_info, path, time_seq, ref,
-					   parents, extent_item_pos,
+		err = resolve_indirect_ref(fs_info, path, time_seq, preftrees,
+					   ref, parents, extent_item_pos,
 					   total_refs, ignore_offset);
 		/*
 		 * we can only tolerate ENOENT,otherwise,we should catch error


