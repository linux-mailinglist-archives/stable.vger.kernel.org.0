Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5260D6D3E98
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjDCIHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjDCIHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:07:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0FB1FF7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8756B8124F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA01C433D2;
        Mon,  3 Apr 2023 08:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680509217;
        bh=ee87DESojLRv6lfa9MaugaWUojsm4B8lYFmNVjd6xyk=;
        h=Subject:To:Cc:From:Date:From;
        b=spr4fxOGl56VnogVA8cwUVLbDQU9kiq+ALI6GbvQVPs70yF7vfDpl5FYRO7xoIdP2
         OecGJEeYIbI58597Qpf1iJg1/PCurJtZw5OsbsYx5Hs+m30FyE2iFqqgywGjBdM+Iz
         EuFFlhs6LoYqLdKLkAA8qaMZebeNXe3OuvJ33JZM=
Subject: FAILED: patch "[PATCH] btrfs: ignore fiemap path cache when there are multiple paths" failed to apply to 6.1-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, jarno.pelkonen@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:06:55 +0200
Message-ID: <2023040354-ramrod-papyrus-415b@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 2280d425ba3599bdd85c41bd0ec8ba568f00c032
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040354-ramrod-papyrus-415b@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

2280d425ba35 ("btrfs: ignore fiemap path cache when there are multiple paths for a node")
73e339e6ab74 ("btrfs: cache sharedness of the last few data extents during fiemap")
b629685803bc ("btrfs: remove roots ulist when checking data extent sharedness")
84a7949d4097 ("btrfs: move ulists to data extent sharedness check context")
61dbb952f0a5 ("btrfs: turn the backref sharedness check cache into a context object")
ceb707da9ad9 ("btrfs: directly pass the inode to btrfs_is_data_extent_shared()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2280d425ba3599bdd85c41bd0ec8ba568f00c032 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 28 Mar 2023 10:45:20 +0100
Subject: [PATCH] btrfs: ignore fiemap path cache when there are multiple paths
 for a node

During fiemap, when walking backreferences to determine if a b+tree
node/leaf is shared, we may find a tree block (leaf or node) for which
two parents were added to the references ulist. This happens if we get
for example one direct ref (shared tree block ref) and one indirect ref
(non-shared tree block ref) for the tree block at the current level,
which can happen during relocation.

In that case the fiemap path cache can not be used since it's meant for
a single path, with one tree block at each possible level, so having
multiple references for a tree block at any level may result in getting
the level counter exceed BTRFS_MAX_LEVEL and eventually trigger the
warning:

   WARN_ON_ONCE(level >= BTRFS_MAX_LEVEL)

at lookup_backref_shared_cache() and at store_backref_shared_cache().
This is harmless since the code ignores any level >= BTRFS_MAX_LEVEL, the
warning is there just to catch any unexpected case like the one described
above. However if a user finds this it may be scary and get reported.

So just ignore the path cache once we find a tree block for which there
are more than one reference, which is the less common case, and update
the cache with the sharedness check result for all levels below the level
for which we found multiple references.

Reported-by: Jarno Pelkonen <jarno.pelkonen@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAKv8qLmDNAGJGCtsevxx_VZ_YOvvs1L83iEJkTgyA4joJertng@mail.gmail.com/
Fixes: 12a824dc67a6 ("btrfs: speedup checking for extent sharedness during fiemap")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 90e40d5ceccd..e54f0884802a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1921,8 +1921,7 @@ int btrfs_is_data_extent_shared(struct btrfs_inode *inode, u64 bytenr,
 	level = -1;
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
-		bool is_shared;
-		bool cached;
+		const unsigned long prev_ref_count = ctx->refs.nnodes;
 
 		walk_ctx.bytenr = bytenr;
 		ret = find_parent_nodes(&walk_ctx, &shared);
@@ -1940,21 +1939,36 @@ int btrfs_is_data_extent_shared(struct btrfs_inode *inode, u64 bytenr,
 		ret = 0;
 
 		/*
-		 * If our data extent was not directly shared (without multiple
-		 * reference items), than it might have a single reference item
-		 * with a count > 1 for the same offset, which means there are 2
-		 * (or more) file extent items that point to the data extent -
-		 * this happens when a file extent item needs to be split and
-		 * then one item gets moved to another leaf due to a b+tree leaf
-		 * split when inserting some item. In this case the file extent
-		 * items may be located in different leaves and therefore some
-		 * of the leaves may be referenced through shared subtrees while
-		 * others are not. Since our extent buffer cache only works for
-		 * a single path (by far the most common case and simpler to
-		 * deal with), we can not use it if we have multiple leaves
-		 * (which implies multiple paths).
+		 * More than one extent buffer (bytenr) may have been added to
+		 * the ctx->refs ulist, in which case we have to check multiple
+		 * tree paths in case the first one is not shared, so we can not
+		 * use the path cache which is made for a single path. Multiple
+		 * extent buffers at the current level happen when:
+		 *
+		 * 1) level -1, the data extent: If our data extent was not
+		 *    directly shared (without multiple reference items), then
+		 *    it might have a single reference item with a count > 1 for
+		 *    the same offset, which means there are 2 (or more) file
+		 *    extent items that point to the data extent - this happens
+		 *    when a file extent item needs to be split and then one
+		 *    item gets moved to another leaf due to a b+tree leaf split
+		 *    when inserting some item. In this case the file extent
+		 *    items may be located in different leaves and therefore
+		 *    some of the leaves may be referenced through shared
+		 *    subtrees while others are not. Since our extent buffer
+		 *    cache only works for a single path (by far the most common
+		 *    case and simpler to deal with), we can not use it if we
+		 *    have multiple leaves (which implies multiple paths).
+		 *
+		 * 2) level >= 0, a tree node/leaf: We can have a mix of direct
+		 *    and indirect references on a b+tree node/leaf, so we have
+		 *    to check multiple paths, and the extent buffer (the
+		 *    current bytenr) may be shared or not. One example is
+		 *    during relocation as we may get a shared tree block ref
+		 *    (direct ref) and a non-shared tree block ref (indirect
+		 *    ref) for the same node/leaf.
 		 */
-		if (level == -1 && ctx->refs.nnodes > 1)
+		if ((ctx->refs.nnodes - prev_ref_count) > 1)
 			ctx->use_path_cache = false;
 
 		if (level >= 0)
@@ -1964,18 +1978,45 @@ int btrfs_is_data_extent_shared(struct btrfs_inode *inode, u64 bytenr,
 		if (!node)
 			break;
 		bytenr = node->val;
-		level++;
-		cached = lookup_backref_shared_cache(ctx, root, bytenr, level,
-						     &is_shared);
-		if (cached) {
-			ret = (is_shared ? 1 : 0);
-			break;
+		if (ctx->use_path_cache) {
+			bool is_shared;
+			bool cached;
+
+			level++;
+			cached = lookup_backref_shared_cache(ctx, root, bytenr,
+							     level, &is_shared);
+			if (cached) {
+				ret = (is_shared ? 1 : 0);
+				break;
+			}
 		}
 		shared.share_count = 0;
 		shared.have_delayed_delete_refs = false;
 		cond_resched();
 	}
 
+	/*
+	 * If the path cache is disabled, then it means at some tree level we
+	 * got multiple parents due to a mix of direct and indirect backrefs or
+	 * multiple leaves with file extent items pointing to the same data
+	 * extent. We have to invalidate the cache and cache only the sharedness
+	 * result for the levels where we got only one node/reference.
+	 */
+	if (!ctx->use_path_cache) {
+		int i = 0;
+
+		level--;
+		if (ret >= 0 && level >= 0) {
+			bytenr = ctx->path_cache_entries[level].bytenr;
+			ctx->use_path_cache = true;
+			store_backref_shared_cache(ctx, root, bytenr, level, ret);
+			i = level + 1;
+		}
+
+		for ( ; i < BTRFS_MAX_LEVEL; i++)
+			ctx->path_cache_entries[i].bytenr = 0;
+	}
+
 	/*
 	 * Cache the sharedness result for the data extent if we know our inode
 	 * has more than 1 file extent item that refers to the data extent.

