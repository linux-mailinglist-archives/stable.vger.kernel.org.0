Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334EA6664F2
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 21:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjAKUoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 15:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjAKUnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 15:43:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0B53D1D9;
        Wed, 11 Jan 2023 12:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A74261E61;
        Wed, 11 Jan 2023 20:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D88C433D2;
        Wed, 11 Jan 2023 20:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673469811;
        bh=HKoy0XQNF0dxKkjQVKXkVMgiOLxYtrrNnhv2VpKfZ2g=;
        h=Date:To:From:Subject:From;
        b=kRCHL/cJwmbdzFG1+ExNEpUqEJF+fZoAF3DI4Ehia+hi+WjZmaxVnr6ngstXTD0rA
         wp9+RBfjT3sW3k6OJDEWpHVKSZf2YwXwVLxT4Zp0HWuVUYuRD2cxYrVGTXsE18LBAJ
         Vx/sKa27fruzkIV/Y9zI2WMmwnSqH02zO68ZXVS4=
Date:   Wed, 11 Jan 2023 12:43:31 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, amanieu@gmail.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230111204331.A9D88C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_empty_area_rev() lower bound validation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nommu-fix-memory-leak-in-do_mmap-error-path.patch
nommu-fix-do_munmap-error-path.patch
nommu-fix-split_vma-map_count-error.patch
maple_tree-fix-mas_empty_area_rev-lower-bound-validation.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

