Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0154CF8C2
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbiCGKCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240727AbiCGKBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2683666AD7;
        Mon,  7 Mar 2022 01:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B52B960A28;
        Mon,  7 Mar 2022 09:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B2CC340F5;
        Mon,  7 Mar 2022 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646642;
        bh=mjh7f8+Yb4NnRkOtN88dWS8ISENtaghbL4Bw9Q8yKiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJJo/ciZ+dMBwH9BpUQ7sK3aD1DKYY5NHNQmLVP6GzDsDYgwOU3EGLsfkm0kZrlSo
         f+7/t3FXydvVtLH38no6XseDli9+gb2matEILG5cCidR+vhDJcoJAkfzlNMYSei9S3
         ekNVx6lJ4Dwi+ymnh/x5HpX5iizFBzBRTpqsf8zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 046/186] btrfs: defrag: bring back the old file extent search behavior
Date:   Mon,  7 Mar 2022 10:18:04 +0100
Message-Id: <20220307091655.383171724@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit d5633b0dee02d7d25e93463a03709f11c71500e2 upstream.

For defrag, we don't really want to use btrfs_get_extent() to iterate
all extent maps of an inode.

The reasons are:

- btrfs_get_extent() can merge extent maps
  And the result em has the higher generation of the two, causing defrag
  to mark unnecessary part of such merged large extent map.

  This in fact can result extra IO for autodefrag in v5.16+ kernels.

  However this patch is not going to completely solve the problem, as
  one can still using read() to trigger extent map reading, and got
  them merged.

  The completely solution for the extent map merging generation problem
  will come as an standalone fix.

- btrfs_get_extent() caches the extent map result
  Normally it's fine, but for defrag the target range may not get
  another read/write for a long long time.
  Such cache would only increase the memory usage.

- btrfs_get_extent() doesn't skip older extent map
  Unlike the old find_new_extent() which uses btrfs_search_forward() to
  skip the older subtree, thus it will pick up unnecessary extent maps.

This patch will fix the regression by introducing defrag_get_extent() to
replace the btrfs_get_extent() call.

This helper will:

- Not cache the file extent we found
  It will search the file extent and manually convert it to em.

- Use btrfs_search_forward() to skip entire ranges which is modified in
  the past

This should reduce the IO for autodefrag.

Reported-by: Filipe Manana <fdmanana@suse.com>
Fixes: 7b508037d4ca ("btrfs: defrag: use defrag_one_cluster() to implement btrfs_defrag_file()")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |  161 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 157 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -986,8 +986,155 @@ out:
 	return ret;
 }
 
+/*
+ * Defrag specific helper to get an extent map.
+ *
+ * Differences between this and btrfs_get_extent() are:
+ *
+ * - No extent_map will be added to inode->extent_tree
+ *   To reduce memory usage in the long run.
+ *
+ * - Extra optimization to skip file extents older than @newer_than
+ *   By using btrfs_search_forward() we can skip entire file ranges that
+ *   have extents created in past transactions, because btrfs_search_forward()
+ *   will not visit leaves and nodes with a generation smaller than given
+ *   minimal generation threshold (@newer_than).
+ *
+ * Return valid em if we find a file extent matching the requirement.
+ * Return NULL if we can not find a file extent matching the requirement.
+ *
+ * Return ERR_PTR() for error.
+ */
+static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
+					    u64 start, u64 newer_than)
+{
+	struct btrfs_root *root = inode->root;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_path path = { 0 };
+	struct extent_map *em;
+	struct btrfs_key key;
+	u64 ino = btrfs_ino(inode);
+	int ret;
+
+	em = alloc_extent_map();
+	if (!em) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = start;
+
+	if (newer_than) {
+		ret = btrfs_search_forward(root, &key, &path, newer_than);
+		if (ret < 0)
+			goto err;
+		/* Can't find anything newer */
+		if (ret > 0)
+			goto not_found;
+	} else {
+		ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+		if (ret < 0)
+			goto err;
+	}
+	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+		/*
+		 * If btrfs_search_slot() makes path to point beyond nritems,
+		 * we should not have an empty leaf, as this inode must at
+		 * least have its INODE_ITEM.
+		 */
+		ASSERT(btrfs_header_nritems(path.nodes[0]));
+		path.slots[0] = btrfs_header_nritems(path.nodes[0]) - 1;
+	}
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	/* Perfect match, no need to go one slot back */
+	if (key.objectid == ino && key.type == BTRFS_EXTENT_DATA_KEY &&
+	    key.offset == start)
+		goto iterate;
+
+	/* We didn't find a perfect match, needs to go one slot back */
+	if (path.slots[0] > 0) {
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.objectid == ino && key.type == BTRFS_EXTENT_DATA_KEY)
+			path.slots[0]--;
+	}
+
+iterate:
+	/* Iterate through the path to find a file extent covering @start */
+	while (true) {
+		u64 extent_end;
+
+		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0]))
+			goto next;
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+
+		/*
+		 * We may go one slot back to INODE_REF/XATTR item, then
+		 * need to go forward until we reach an EXTENT_DATA.
+		 * But we should still has the correct ino as key.objectid.
+		 */
+		if (WARN_ON(key.objectid < ino) || key.type < BTRFS_EXTENT_DATA_KEY)
+			goto next;
+
+		/* It's beyond our target range, definitely not extent found */
+		if (key.objectid > ino || key.type > BTRFS_EXTENT_DATA_KEY)
+			goto not_found;
+
+		/*
+		 *	|	|<- File extent ->|
+		 *	\- start
+		 *
+		 * This means there is a hole between start and key.offset.
+		 */
+		if (key.offset > start) {
+			em->start = start;
+			em->orig_start = start;
+			em->block_start = EXTENT_MAP_HOLE;
+			em->len = key.offset - start;
+			break;
+		}
+
+		fi = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_file_extent_item);
+		extent_end = btrfs_file_extent_end(&path);
+
+		/*
+		 *	|<- file extent ->|	|
+		 *				\- start
+		 *
+		 * We haven't reached start, search next slot.
+		 */
+		if (extent_end <= start)
+			goto next;
+
+		/* Now this extent covers @start, convert it to em */
+		btrfs_extent_item_to_extent_map(inode, &path, fi, false, em);
+		break;
+next:
+		ret = btrfs_next_item(root, &path);
+		if (ret < 0)
+			goto err;
+		if (ret > 0)
+			goto not_found;
+	}
+	btrfs_release_path(&path);
+	return em;
+
+not_found:
+	btrfs_release_path(&path);
+	free_extent_map(em);
+	return NULL;
+
+err:
+	btrfs_release_path(&path);
+	free_extent_map(em);
+	return ERR_PTR(ret);
+}
+
 static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start,
-					       bool locked)
+					       u64 newer_than, bool locked)
 {
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -1009,7 +1156,7 @@ static struct extent_map *defrag_lookup_
 		/* get the big lock and read metadata off disk */
 		if (!locked)
 			lock_extent_bits(io_tree, start, end, &cached);
-		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, sectorsize);
+		em = defrag_get_extent(BTRFS_I(inode), start, newer_than);
 		if (!locked)
 			unlock_extent_cached(io_tree, start, end, &cached);
 
@@ -1037,7 +1184,12 @@ static bool defrag_check_next_extent(str
 	if (em->start + em->len >= i_size_read(inode))
 		return false;
 
-	next = defrag_lookup_extent(inode, em->start + em->len, locked);
+	/*
+	 * We want to check if the next extent can be merged with the current
+	 * one, which can be an extent created in a past generation, so we pass
+	 * a minimum generation of 0 to defrag_lookup_extent().
+	 */
+	next = defrag_lookup_extent(inode, em->start + em->len, 0, locked);
 	/* No more em or hole */
 	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE)
 		goto out;
@@ -1188,7 +1340,8 @@ static int defrag_collect_targets(struct
 		u64 range_len;
 
 		last_is_target = false;
-		em = defrag_lookup_extent(&inode->vfs_inode, cur, locked);
+		em = defrag_lookup_extent(&inode->vfs_inode, cur,
+					  newer_than, locked);
 		if (!em)
 			break;
 


