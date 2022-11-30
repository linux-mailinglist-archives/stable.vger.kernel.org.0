Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8887B63E3B4
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiK3Wv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiK3Wvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225698DFED;
        Wed, 30 Nov 2022 14:51:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3DB7B81D12;
        Wed, 30 Nov 2022 22:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912A7C433D6;
        Wed, 30 Nov 2022 22:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848707;
        bh=QNlu7uBKlHkTo8d3sbNCwpzjq0HKdwijBeFxAA8c37k=;
        h=Date:To:From:Subject:From;
        b=0oJpGxezsZWuEBH4O4dbBjXtFB2n6eybCOD0gFkDtRhwBm+Bpnbjot2pQQMemdfLu
         ZuXVPZA+xyGMdXSqWsId4VSvGV524B56IWbEoOYhsfgdewmqUdxIi7u8qCcwiF0+2X
         2SlULl2VSOo3VLaMJTlGyynyeLABkYO47RN3wvzo=
Date:   Wed, 30 Nov 2022 14:51:46 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, peterx@redhat.com, jhubbard@nvidia.com,
        david@redhat.com, jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-gup-fast-interaction-by-sending-ipi.patch removed from -mm tree
Message-Id: <20221130225147.912A7C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: fix GUP-fast interaction by sending IPI
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-gup-fast-interaction-by-sending-ipi.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/khugepaged: fix GUP-fast interaction by sending IPI
Date: Fri, 25 Nov 2022 22:37:13 +0100

Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
ensure that the page table was not removed by khugepaged in between.

However, lockless_pages_from_mm() still requires that the page table is
not concurrently freed.  Fix it by sending IPIs (if the architecture uses
semi-RCU-style page table freeing) before freeing/reusing page tables.

Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
Fixes: ba76149f47d8 ("thp: khugepaged")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    4 ++++
 mm/khugepaged.c           |    2 ++
 mm/mmu_gather.c           |    4 +---
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/asm-generic/tlb.h~mm-khugepaged-fix-gup-fast-interaction-by-sending-ipi
+++ a/include/asm-generic/tlb.h
@@ -222,12 +222,16 @@ extern void tlb_remove_table(struct mmu_
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+void tlb_remove_table_sync_one(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
 #error tlb_needs_table_invalidate() requires MMU_GATHER_RCU_TABLE_FREE
 #endif
 
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
--- a/mm/khugepaged.c~mm-khugepaged-fix-gup-fast-interaction-by-sending-ipi
+++ a/mm/khugepaged.c
@@ -1051,6 +1051,7 @@ static int collapse_huge_page(struct mm_
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	result =  __collapse_huge_page_isolate(vma, address, pte, cc,
@@ -1410,6 +1411,7 @@ static void collapse_and_free_pmd(struct
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
 
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
+	tlb_remove_table_sync_one();
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
--- a/mm/mmu_gather.c~mm-khugepaged-fix-gup-fast-interaction-by-sending-ipi
+++ a/mm/mmu_gather.c
@@ -153,7 +153,7 @@ static void tlb_remove_table_smp_sync(vo
 	/* Simply deliver the interrupt */
 }
 
-static void tlb_remove_table_sync_one(void)
+void tlb_remove_table_sync_one(void)
 {
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
@@ -177,8 +177,6 @@ static void tlb_remove_table_free(struct
 
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
-static void tlb_remove_table_sync_one(void) { }
-
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
 {
 	__tlb_remove_table_free(batch);
_

Patches currently in -mm which might be from jannh@google.com are


