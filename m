Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258B564165B
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiLCLWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLCLWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:22:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0D66720A
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:22:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BBA960B82
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5CDC433D6;
        Sat,  3 Dec 2022 11:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670066524;
        bh=bJn4Rl91zCOTSbk5FnhTgsOMtbQZzjfXq8xyqHb3i5s=;
        h=Subject:To:Cc:From:Date:From;
        b=126TzlXIDC0vHCojn67mkzsnKZ6kOyUIWU2L/wv2MjZQW7EZ6KtTNq9Jr76LbzTVV
         X9BDk5YlyJrjyB5mKlchfy+18zcsWqQtVVdsacLzhiXf3aIQXI8zB/wVH0bGL1FQc7
         SWKCu/nbPNJMwUauAofnPJhAPGx03C7xcJIYIIL8=
Subject: FAILED: patch "[PATCH] mm/khugepaged: take the right locks for page table retraction" failed to apply to 5.10-stable tree
To:     jannh@google.com, akpm@linux-foundation.org, david@redhat.com,
        jhubbard@nvidia.com, peterx@redhat.com, shy828301@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:21:58 +0100
Message-ID: <16700665183580@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

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
66137fb34a4b ("mm: khugepaged: check THP flag in hugepage_vma_check()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8d3c106e19e8d251da31ff4cc7462e4565d65084 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Nov 2022 22:37:12 +0100
Subject: [PATCH] mm/khugepaged: take the right locks for page table retraction

pagetable walks on address ranges mapped by VMAs can be done under the
mmap lock, the lock of an anon_vma attached to the VMA, or the lock of the
VMA's address_space.  Only one of these needs to be held, and it does not
need to be held in exclusive mode.

Under those circumstances, the rules for concurrent access to page table
entries are:

 - Terminal page table entries (entries that don't point to another page
   table) can be arbitrarily changed under the page table lock, with the
   exception that they always need to be consistent for
   hardware page table walks and lockless_pages_from_mm().
   This includes that they can be changed into non-terminal entries.
 - Non-terminal page table entries (which point to another page table)
   can not be modified; readers are allowed to READ_ONCE() an entry, verify
   that it is non-terminal, and then assume that its value will stay as-is.

Retracting a page table involves modifying a non-terminal entry, so
page-table-level locks are insufficient to protect against concurrent page
table traversal; it requires taking all the higher-level locks under which
it is possible to start a page walk in the relevant range in exclusive
mode.

The collapse_huge_page() path for anonymous THP already follows this rule,
but the shmem/file THP path was getting it wrong, making it possible for
concurrent rmap-based operations to cause corruption.

Link: https://lkml.kernel.org/r/20221129154730.2274278-1-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-1-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-1-jannh@google.com
Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a8d5ef2a77d2..0a11e132ad6b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1379,16 +1379,37 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return SCAN_SUCCEED;
 }
 
+/*
+ * A note about locking:
+ * Trying to take the page table spinlocks would be useless here because those
+ * are only used to synchronize:
+ *
+ *  - modifying terminal entries (ones that point to a data page, not to another
+ *    page table)
+ *  - installing *new* non-terminal entries
+ *
+ * Instead, we need roughly the same kind of protection as free_pgtables() or
+ * mm_take_all_locks() (but only for a single VMA):
+ * The mmap lock together with this VMA's rmap locks covers all paths towards
+ * the page table entries we're messing with here, except for hardware page
+ * table walks and lockless_pages_from_mm().
+ */
 static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t *pmdp)
 {
-	spinlock_t *ptl;
 	pmd_t pmd;
 
 	mmap_assert_write_locked(mm);
-	ptl = pmd_lock(vma->vm_mm, pmdp);
+	if (vma->vm_file)
+		lockdep_assert_held_write(&vma->vm_file->f_mapping->i_mmap_rwsem);
+	/*
+	 * All anon_vmas attached to the VMA have the same root and are
+	 * therefore locked by the same lock.
+	 */
+	if (vma->anon_vma)
+		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
+
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
-	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
@@ -1439,6 +1460,14 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	if (!hugepage_vma_check(vma, vma->vm_flags, false, false, false))
 		return SCAN_VMA_CHECK;
 
+	/*
+	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
+	 * that got written to. Without this, we'd have to also lock the
+	 * anon_vma if one exists.
+	 */
+	if (vma->anon_vma)
+		return SCAN_VMA_CHECK;
+
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
 		return SCAN_PTE_UFFD_WP;
@@ -1472,6 +1501,20 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		goto drop_hpage;
 	}
 
+	/*
+	 * We need to lock the mapping so that from here on, only GUP-fast and
+	 * hardware page walks can access the parts of the page tables that
+	 * we're operating on.
+	 * See collapse_and_free_pmd().
+	 */
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+
+	/*
+	 * This spinlock should be unnecessary: Nobody else should be accessing
+	 * the page tables under spinlock protection here, only
+	 * lockless_pages_from_mm() and the hardware page walker can access page
+	 * tables while all the high-level locks are held in write mode.
+	 */
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 	result = SCAN_FAIL;
 
@@ -1526,6 +1569,8 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	/* step 4: remove pte entries */
 	collapse_and_free_pmd(mm, vma, haddr, pmd);
 
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
@@ -1539,6 +1584,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1595,7 +1641,8 @@ static int retract_page_tables(struct address_space *mapping, pgoff_t pgoff,
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma) {
 			result = SCAN_PAGE_ANON;

