Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD663E3B2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiK3Wvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiK3Wvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B486934F9;
        Wed, 30 Nov 2022 14:51:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D533061E28;
        Wed, 30 Nov 2022 22:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CD2C433D6;
        Wed, 30 Nov 2022 22:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848706;
        bh=LcQNxxSeuzAOXSJQHfaqGhcB5Q9HHdUPkBfoXUPHx+8=;
        h=Date:To:From:Subject:From;
        b=Px73FXWR+jNNn+8g91cbzDYp0GFNJE7m3Jztx0kBH3uGKasTUJjwDtbUAYLPAC3w5
         d8dAthFugK910pwsZ+VM6ZMToEC6aYZ1AQgRO4bchkQOnOG8JmlNHHG47lIiSC/T+Y
         aA3yiVIZcv7EooNga0qlaOBEC7o8MnpWouBoor2Q=
Date:   Wed, 30 Nov 2022 14:51:45 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, peterx@redhat.com, jhubbard@nvidia.com,
        david@redhat.com, jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-take-the-right-locks-for-page-table-retraction.patch removed from -mm tree
Message-Id: <20221130225146.34CD2C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: take the right locks for page table retraction
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-take-the-right-locks-for-page-table-retraction.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/khugepaged: take the right locks for page table retraction
Date: Fri, 25 Nov 2022 22:37:12 +0100

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
---

 mm/khugepaged.c |   55 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-take-the-right-locks-for-page-table-retraction
+++ a/mm/khugepaged.c
@@ -1379,16 +1379,37 @@ static int set_huge_pmd(struct vm_area_s
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
@@ -1439,6 +1460,14 @@ int collapse_pte_mapped_thp(struct mm_st
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
@@ -1472,6 +1501,20 @@ int collapse_pte_mapped_thp(struct mm_st
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
 
@@ -1526,6 +1569,8 @@ int collapse_pte_mapped_thp(struct mm_st
 	/* step 4: remove pte entries */
 	collapse_and_free_pmd(mm, vma, haddr, pmd);
 
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
@@ -1539,6 +1584,7 @@ drop_hpage:
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1595,7 +1641,8 @@ static int retract_page_tables(struct ad
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma) {
 			result = SCAN_PAGE_ANON;
_

Patches currently in -mm which might be from jannh@google.com are


