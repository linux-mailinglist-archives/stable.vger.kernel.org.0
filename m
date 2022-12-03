Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6698641660
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiLCLW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiLCLW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:22:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2AF65E53
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E84CA60BA8
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ACDC433C1;
        Sat,  3 Dec 2022 11:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670066546;
        bh=1rfGvHbnU9cBbZpkW1neJ0fkBhDRQrQh/rKHt0sSElk=;
        h=Subject:To:Cc:From:Date:From;
        b=1Io1ZOKUhX/l1Fvmy0/R3NViPLHbZgBdwvj9wl/1zTqFhCDAaZRf5GIU/B8jT/Kr+
         tIX3EO71xqq7lVb+dqmgjs9mIyDz8ZhS4QfxHJ5tvl/zaQqykDCi9Ak7ztzZY0OEY8
         Oo9kIhTJ6begHtWJ5tZAy3CKKFyd06LPwDGhEaMo=
Subject: FAILED: patch "[PATCH] mm/khugepaged: fix GUP-fast interaction by sending IPI" failed to apply to 5.4-stable tree
To:     jannh@google.com, akpm@linux-foundation.org, david@redhat.com,
        jhubbard@nvidia.com, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:22:17 +0100
Message-ID: <1670066537175182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2ba99c5e0881 ("mm/khugepaged: fix GUP-fast interaction by sending IPI")
8d3c106e19e8 ("mm/khugepaged: take the right locks for page table retraction")
34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
780a4b6fb865 ("mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()")
b26e27015ec9 ("mm: thp: convert to use common struct mm_slot")
685405020b9f ("mm/khugepaged: stop using vma linked list")
7d2c4385c341 ("mm/khugepaged: rename prefix of shared collapse functions")
7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
507228044236 ("mm/khugepaged: record SCAN_PMD_MAPPED when scan_pmd() finds hugepage")
a7f4e6e4c47c ("mm/thp: add flag to enforce sysfs THP in hugepage_vma_check()")
50ad2f24b3b4 ("mm/khugepaged: propagate enum scan_result codes back to callers")
9710a78ab2ae ("mm/khugepaged: dedup and simplify hugepage alloc and charging")
34d6b470ab9c ("mm/khugepaged: add struct collapse_control")
c6a7f445a272 ("mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA")
1064026bab9f ("mm: khugepaged: reorg some khugepaged helpers")
7da4e2cb8b1f ("mm: thp: kill __transhuge_page_enabled()")
9fec51689ff6 ("mm: thp: kill transparent_hugepage_active()")
f707fa493784 ("mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate")
4fa6893faeaa ("mm: thp: consolidate vma size check to transhuge_vma_suitable")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ba99c5e08812494bc57f319fb562f527d9bacd8 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Nov 2022 22:37:13 +0100
Subject: [PATCH] mm/khugepaged: fix GUP-fast interaction by sending IPI

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

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 492dce43236e..cab7cfebf40b 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -222,12 +222,16 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
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
 
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0a11e132ad6b..294cb75d9c22 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1051,6 +1051,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	result =  __collapse_huge_page_isolate(vma, address, pte, cc,
@@ -1410,6 +1411,7 @@ static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *v
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
 
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
+	tlb_remove_table_sync_one();
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index add4244e5790..3a2c3f8cad2f 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -153,7 +153,7 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
-static void tlb_remove_table_sync_one(void)
+void tlb_remove_table_sync_one(void)
 {
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
@@ -177,8 +177,6 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
-static void tlb_remove_table_sync_one(void) { }
-
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
 {
 	__tlb_remove_table_free(batch);

