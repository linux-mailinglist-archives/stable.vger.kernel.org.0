Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A247685C51
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjBAAo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjBAAoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:44:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EC54F87F;
        Tue, 31 Jan 2023 16:44:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 557AD6174D;
        Wed,  1 Feb 2023 00:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B24C433D2;
        Wed,  1 Feb 2023 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212292;
        bh=RNV0F2382BoY1TRlw1Uo5cLgNWDk0QWRQxeE1HjkfJ4=;
        h=Date:To:From:Subject:From;
        b=B6FLfH0sj99sQ9kPRs8LG9REHbL99uXFrf79mFUK8BbmJb6KkSuphQyHZ0YTTht/G
         kHGIRRb79L9QTBwMMjn5Dt2RXTGZqW25Tqit8Q2/6U3Hm16zYTrMrWQJIxkARtb9g3
         MkBaG5hgUnTIeOij0ilgJwcmeoticAI0fRt9qpzg=
Date:   Tue, 31 Jan 2023 16:44:51 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, holger@applied-asynchrony.com,
        amanieu@gmail.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch removed from -mm tree
Message-Id: <20230201004452.A6B24C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix mas_empty_area_rev() lower bound validation
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_empty_area_rev() lower bound validation
Date: Wed, 11 Jan 2023 20:02:07 +0000

mas_empty_area_rev() was not correctly validating the start of a gap
against the lower limit.  This could lead to the range starting lower than
the requested minimum.

Fix the issue by better validating a gap once one is found.

This commit also adds tests to the maple tree test suite for this issue
and tests the mas_empty_area() function for similar bound checking.

Link: https://lkml.kernel.org/r/20230111200136.1851322-1-Liam.Howlett@oracle.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216911
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: <amanieu@gmail.com>
  Link: https://lore.kernel.org/linux-mm/0b9f5425-08d4-8013-aa4c-e620c3b10bb2@leemhuis.info/
Tested-by: Holger Hoffsttte <holger@applied-asynchrony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c      |   17 +++----
 lib/test_maple_tree.c |   89 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_empty_area_rev-lower-bound-validation
+++ a/lib/maple_tree.c
@@ -4887,7 +4887,7 @@ static bool mas_rev_awalk(struct ma_stat
 	unsigned long *pivots, *gaps;
 	void __rcu **slots;
 	unsigned long gap = 0;
-	unsigned long max, min, index;
+	unsigned long max, min;
 	unsigned char offset;
 
 	if (unlikely(mas_is_err(mas)))
@@ -4909,8 +4909,7 @@ static bool mas_rev_awalk(struct ma_stat
 		min = mas_safe_min(mas, pivots, --offset);
 
 	max = mas_safe_pivot(mas, pivots, offset, type);
-	index = mas->index;
-	while (index <= max) {
+	while (mas->index <= max) {
 		gap = 0;
 		if (gaps)
 			gap = gaps[offset];
@@ -4941,10 +4940,8 @@ static bool mas_rev_awalk(struct ma_stat
 		min = mas_safe_min(mas, pivots, offset);
 	}
 
-	if (unlikely(index > max)) {
-		mas_set_err(mas, -EBUSY);
-		return false;
-	}
+	if (unlikely((mas->index > max) || (size - 1 > max - mas->index)))
+		goto no_space;
 
 	if (unlikely(ma_is_leaf(type))) {
 		mas->offset = offset;
@@ -4961,9 +4958,11 @@ static bool mas_rev_awalk(struct ma_stat
 	return false;
 
 ascend:
-	if (mte_is_root(mas->node))
-		mas_set_err(mas, -EBUSY);
+	if (!mte_is_root(mas->node))
+		return false;
 
+no_space:
+	mas_set_err(mas, -EBUSY);
 	return false;
 }
 
--- a/lib/test_maple_tree.c~maple_tree-fix-mas_empty_area_rev-lower-bound-validation
+++ a/lib/test_maple_tree.c
@@ -2517,6 +2517,91 @@ static noinline void check_bnode_min_spa
 	mt_set_non_kernel(0);
 }
 
+static noinline void check_empty_area_window(struct maple_tree *mt)
+{
+	unsigned long i, nr_entries = 20;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i = 1; i <= nr_entries; i++)
+		mtree_store_range(mt, i*10, i*10 + 9,
+				  xa_mk_value(i), GFP_KERNEL);
+
+	/* Create another hole besides the one at 0 */
+	mtree_store_range(mt, 160, 169, NULL, GFP_KERNEL);
+
+	/* Check lower bounds that don't fit */
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 90, 10) != -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 6, 90, 5) != -EBUSY);
+
+	/* Check lower bound that does fit */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 90, 5) != 0);
+	MT_BUG_ON(mt, mas.index != 5);
+	MT_BUG_ON(mt, mas.last != 9);
+	rcu_read_unlock();
+
+	/* Check one gap that doesn't fit and one that does */
+	rcu_read_lock();
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 5, 217, 9) != 0);
+	MT_BUG_ON(mt, mas.index != 161);
+	MT_BUG_ON(mt, mas.last != 169);
+
+	/* Check one gap that does fit above the min */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 218, 3) != 0);
+	MT_BUG_ON(mt, mas.index != 216);
+	MT_BUG_ON(mt, mas.last != 218);
+
+	/* Check size that doesn't fit any gap */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 218, 16) != -EBUSY);
+
+	/*
+	 * Check size that doesn't fit the lower end of the window but
+	 * does fit the gap
+	 */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 167, 200, 4) != -EBUSY);
+
+	/*
+	 * Check size that doesn't fit the upper end of the window but
+	 * does fit the gap
+	 */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area_rev(&mas, 100, 162, 4) != -EBUSY);
+
+	/* Check mas_empty_area forward */
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 9) != 0);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 8);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 4) != 0);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 3);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 100, 11) != -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 5, 100, 6) != -EBUSY);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 8, 10) != -EBUSY);
+
+	mas_reset(&mas);
+	mas_empty_area(&mas, 100, 165, 3);
+
+	mas_reset(&mas);
+	MT_BUG_ON(mt, mas_empty_area(&mas, 100, 163, 6) != -EBUSY);
+	rcu_read_unlock();
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2765,6 +2850,10 @@ static int maple_tree_seed(void)
 	check_bnode_min_spanning(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_window(&tree);
+	mtree_destroy(&tree);
+
 #if defined(BENCH)
 skip:
 #endif
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


