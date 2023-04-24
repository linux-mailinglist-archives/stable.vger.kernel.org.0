Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A319F6ECDE7
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjDXN17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjDXN1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:27:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB11255A6
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52065622E0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64884C433D2;
        Mon, 24 Apr 2023 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342853;
        bh=wA1t6WP7KMG/LNp87R4xwz1Iezu/Ifjq4GQmg9K0sws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfw874fTYqkvzj7ZSBT8VIhuu1dayyN5ucygHoIHHemhaVCemghG/kuPe7jOxqm8w
         zT39NsgwCmwYos71Q8TCGBdb5crrs4/uOAsHuJLKlMrkRjgFOxfvaTMC2hNSHi/Rwc
         1M+VOqHzV+uIIptgWXS8dALsq8fJAT3qkJNvSTxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 54/98] btrfs: get the next extent map during fiemap/lseek more efficiently
Date:   Mon, 24 Apr 2023 15:17:17 +0200
Message-Id: <20230424131135.954387997@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit d47704bd1c78c85831561bcf701b90dd66f811b2 upstream.

At find_delalloc_subrange(), when we need to get the next extent map, we
do a full search on the extent map tree (a red black tree). This is fine
but it's a lot more efficient to simply use rb_next(), which typically
requires iterating over less nodes of the tree and never needs to compare
the ranges of nodes with the one we are looking for.

So add a public helper to extent_map.{h,c} to get the extent map that
immediately follows another extent map, using rb_next(), and use that
helper at find_delalloc_subrange().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c |   31 ++++++++++++++++++++++++++++++-
 fs/btrfs/extent_map.h |    2 ++
 fs/btrfs/file.c       |   44 +++++++++++++++++++++++++++-----------------
 3 files changed, 59 insertions(+), 18 deletions(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -523,7 +523,7 @@ void replace_extent_mapping(struct exten
 	setup_extent_mapping(tree, new, modified);
 }
 
-static struct extent_map *next_extent_map(struct extent_map *em)
+static struct extent_map *next_extent_map(const struct extent_map *em)
 {
 	struct rb_node *next;
 
@@ -533,6 +533,35 @@ static struct extent_map *next_extent_ma
 	return container_of(next, struct extent_map, rb_node);
 }
 
+/*
+ * Get the extent map that immediately follows another one.
+ *
+ * @tree:       The extent map tree that the extent map belong to.
+ *              Holding read or write access on the tree's lock is required.
+ * @em:         An extent map from the given tree. The caller must ensure that
+ *              between getting @em and between calling this function, the
+ *              extent map @em is not removed from the tree - for example, by
+ *              holding the tree's lock for the duration of those 2 operations.
+ *
+ * Returns the extent map that immediately follows @em, or NULL if @em is the
+ * last extent map in the tree.
+ */
+struct extent_map *btrfs_next_extent_map(const struct extent_map_tree *tree,
+					 const struct extent_map *em)
+{
+	struct extent_map *next;
+
+	/* The lock must be acquired either in read mode or write mode. */
+	lockdep_assert_held(&tree->lock);
+	ASSERT(extent_map_in_tree(em));
+
+	next = next_extent_map(em);
+	if (next)
+		refcount_inc(&next->refs);
+
+	return next;
+}
+
 static struct extent_map *prev_extent_map(struct extent_map *em)
 {
 	struct rb_node *prev;
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -87,6 +87,8 @@ static inline u64 extent_map_block_end(s
 void extent_map_tree_init(struct extent_map_tree *tree);
 struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
+struct extent_map *btrfs_next_extent_map(const struct extent_map_tree *tree,
+					 const struct extent_map *em);
 int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em, int modified);
 void remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3248,40 +3248,50 @@ static bool find_delalloc_subrange(struc
 	 */
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, start, len);
-	read_unlock(&em_tree->lock);
+	if (!em) {
+		read_unlock(&em_tree->lock);
+		return (delalloc_len > 0);
+	}
 
 	/* extent_map_end() returns a non-inclusive end offset. */
-	em_end = em ? extent_map_end(em) : 0;
+	em_end = extent_map_end(em);
 
 	/*
 	 * If we have a hole/prealloc extent map, check the next one if this one
 	 * ends before our range's end.
 	 */
-	if (em && (em->block_start == EXTENT_MAP_HOLE ||
-		   test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) && em_end < end) {
+	if ((em->block_start == EXTENT_MAP_HOLE ||
+	     test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) && em_end < end) {
 		struct extent_map *next_em;
 
-		read_lock(&em_tree->lock);
-		next_em = lookup_extent_mapping(em_tree, em_end, len - em_end);
-		read_unlock(&em_tree->lock);
-
+		next_em = btrfs_next_extent_map(em_tree, em);
 		free_extent_map(em);
-		em_end = next_em ? extent_map_end(next_em) : 0;
+
+		/*
+		 * There's no next extent map or the next one starts beyond our
+		 * range, return the range found in the io tree (if any).
+		 */
+		if (!next_em || next_em->start > end) {
+			read_unlock(&em_tree->lock);
+			free_extent_map(next_em);
+			return (delalloc_len > 0);
+		}
+
+		em_end = extent_map_end(next_em);
 		em = next_em;
 	}
 
-	if (em && (em->block_start == EXTENT_MAP_HOLE ||
-		   test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
-		free_extent_map(em);
-		em = NULL;
-	}
+	read_unlock(&em_tree->lock);
 
 	/*
-	 * No extent map or one for a hole or prealloc extent. Use the delalloc
-	 * range we found in the io tree if we have one.
+	 * We have a hole or prealloc extent that ends at or beyond our range's
+	 * end, return the range found in the io tree (if any).
 	 */
-	if (!em)
+	if (em->block_start == EXTENT_MAP_HOLE ||
+	    test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
+		free_extent_map(em);
 		return (delalloc_len > 0);
+	}
 
 	/*
 	 * We don't have any range as EXTENT_DELALLOC in the io tree, so the


