Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773116A8FB0
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 04:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCCDLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 22:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCCDLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 22:11:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA12E14E81;
        Thu,  2 Mar 2023 19:11:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 534FA616EF;
        Fri,  3 Mar 2023 03:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FECC433EF;
        Fri,  3 Mar 2023 03:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677813081;
        bh=skqkE0lASJwbHdctQKeuS2fNe1ZPkvEMIEWsND8HdiY=;
        h=Date:To:From:Subject:From;
        b=zK8xUUYjz4lRwtNUw8pBgL/ag/qGCI/+vxJ7UiAmnFSqPbqXQOplZ2JrJfoZvXoZ4
         Df/SDLWKYEt320kvKaUMzXtNlTluc+zCCKdAMR+cn6QrFx7QcZBD4+0bWI3WBxXw7l
         tZweOa3sb6jEf9+RRMIeNgzil2LPioPdDM1xrrPs=
Date:   Thu, 02 Mar 2023 19:11:21 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, snild@sony.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + test_maple_tree-add-more-testing-for-mas_empty_area.patch added to mm-hotfixes-unstable branch
Message-Id: <20230303031121.A1FECC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: test_maple_tree: add more testing for mas_empty_area()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     test_maple_tree-add-more-testing-for-mas_empty_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_maple_tree-add-more-testing-for-mas_empty_area.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: test_maple_tree: add more testing for mas_empty_area()
Date: Thu, 2 Mar 2023 21:15:40 -0500

Test robust filling of an entire area of the tree, then test one beyond. 
This is to test the walking back up the tree at the end of nodes and error
condition.

Test inspired by the reproducer code provided by Snild Dolkow.

Link: https://lkml.kernel.org/r/20230303021540.1056603-2-Liam.Howlett@oracle.com
Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Fixes: e15e06a83923 ("lib/test_maple_tree: add testing for maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Snild Dolkow <snild@sony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/test_maple_tree.c~test_maple_tree-add-more-testing-for-mas_empty_area
+++ a/lib/test_maple_tree.c
@@ -2670,6 +2670,36 @@ static noinline void check_empty_area_wi
 	rcu_read_unlock();
 }
 
+static noinline void check_empty_area_fill(struct maple_tree *mt)
+{
+	int loop, shift;
+	unsigned long max = 0x25D78000;
+	unsigned long size;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(99999);
+	for (shift = 12; shift <= 16; shift++) {
+		loop = 5000;
+		size = 1 << shift;
+		while (loop--) {
+			mas_lock(&mas);
+			MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != 0);
+			MT_BUG_ON(mt, mas.last != mas.index + size - 1);
+			mas_store_gfp(&mas, &check_empty_area_fill, GFP_KERNEL);
+			mas_unlock(&mas);
+			mas_reset(&mas);
+		}
+	}
+
+	/* No space left. */
+	size = 0x1000;
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != -EBUSY);
+	rcu_read_unlock();
+
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2926,6 +2956,11 @@ static int maple_tree_seed(void)
 	check_empty_area_window(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_fill(&tree);
+	mtree_destroy(&tree);
+
+
 #if defined(BENCH)
 skip:
 #endif
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch
maple_tree-fix-mas_skip_node-end-slot-detection.patch
test_maple_tree-add-more-testing-for-mas_empty_area.patch
maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

