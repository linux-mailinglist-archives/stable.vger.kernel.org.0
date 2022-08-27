Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64E55A33D4
	for <lists+stable@lfdr.de>; Sat, 27 Aug 2022 04:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiH0CiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 22:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiH0CiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 22:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA05DD742;
        Fri, 26 Aug 2022 19:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D8A261D52;
        Sat, 27 Aug 2022 02:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BAEC433C1;
        Sat, 27 Aug 2022 02:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661567891;
        bh=xAh3+xuOAJg4/Wh56t+f8yWCmCtKfXQ2/fZXPFuBCbU=;
        h=Date:To:From:Subject:From;
        b=xqlyjPpAx2yDQlq3vKCnIEckt56WY52zhElp72zmCQpaDctV+NaqCA+EEDKcMbkSR
         11LcveILKGnIkZXscNAVtRi20u7T0VQ82tp6fyuESCA6uYShuZxGmJEA//Ff8KN57Q
         Y7URzLbJly23QY9aS9FsJT2arBFpxQbNSl5DfH4M=
Date:   Fri, 26 Aug 2022 19:38:10 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, stable@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, paulus@ozlabs.org, lyude@redhat.com,
        logang@deltatee.com, kherbst@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, felix.kuehling@amd.com, david@redhat.com,
        bskeggs@redhat.com, alex.sierra@amd.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch removed from -mm tree
Message-Id: <20220827023810.E2BAEC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device.c: copy pte dirty bit to page
has been removed from the -mm tree.  Its filename was
     mm-migrate_devicec-copy-pte-dirty-bit-to-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device.c: copy pte dirty bit to page
Date: Tue, 16 Aug 2022 17:39:24 +1000

migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
installs migration entries directly if it can lock the migrating page. 
When removing a dirty pte the dirty bit is supposed to be carried over to
the underlying page to prevent it being lost.

Currently migrate_vma_*() can only be used for private anonymous mappings.
That means loss of the dirty bit usually doesn't result in data loss
because these pages are typically not file-backed.  However pages may be
backed by swap storage which can result in data loss if an attempt is made
to migrate a dirty page that doesn't yet have the PageDirty flag set.

In this case migration will fail due to unexpected references but the
dirty pte bit will be lost.  If the page is subsequently reclaimed data
won't be written back to swap storage as it is considered uptodate,
resulting in data loss if the page is subsequently accessed.

Prevent this by copying the dirty bit to the page when removing the pte to
match what try_to_migrate_one() does.

Link: https://lkml.kernel.org/r/6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reported-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_devicec-copy-pte-dirty-bit-to-page
+++ a/mm/migrate_device.c
@@ -7,6 +7,7 @@
 #include <linux/export.h>
 #include <linux/memremap.h>
 #include <linux/migrate.h>
+#include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/oom.h>
@@ -61,7 +62,7 @@ static int migrate_vma_collect_pmd(pmd_t
 	struct migrate_vma *migrate = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
+	unsigned long addr = start;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
@@ -193,11 +194,10 @@ again:
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
+			pte = ptep_clear_flush(vma, addr, ptep);
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
-				ptep_clear_flush(vma, addr, ptep);
-
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
 					unlock_page(page);
@@ -205,12 +205,14 @@ again:
 					mpfn = 0;
 					goto next;
 				}
-			} else {
-				ptep_get_and_clear(mm, addr, ptep);
 			}
 
 			migrate->cpages++;
 
+			/* Set the dirty flag on the folio now the pte is gone. */
+			if (pte_dirty(pte))
+				folio_mark_dirty(page_folio(page));
+
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
 				entry = make_writable_migration_entry(
@@ -242,9 +244,6 @@ again:
 			 */
 			page_remove_rmap(page, vma, false);
 			put_page(page);
-
-			if (pte_present(pte))
-				unmapped++;
 		} else {
 			put_page(page);
 			mpfn = 0;
@@ -257,10 +256,6 @@ next:
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(ptep - 1, ptl);
 
-	/* Only flush the TLB if we actually modified any entries */
-	if (unmapped)
-		flush_tlb_range(walk->vma, start, end);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch
selftests-hmm-tests-add-test-for-dirty-bits.patch
mm-gupc-dont-pass-gup_flags-to-check_and_migrate_movable_pages.patch
mm-gupc-refactor-check_and_migrate_movable_pages.patch

