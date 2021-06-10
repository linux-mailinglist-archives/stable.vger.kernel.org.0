Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EAF3A3708
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFJW1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhFJW13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC9F761403;
        Thu, 10 Jun 2021 22:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363918;
        bh=brYdOYJ1uWTXDAO7Hz7tR9t7JPABuqceM2JlzTplZvU=;
        h=Date:From:To:Subject:From;
        b=X+UBaWdBifUiiweenawN4HREcRI12zMZJUS+LLgeeuJy/wVDswFrYW2ZbT0LXFsPn
         Frd8Ymrfrj1UkHntlWoxiJjacg59eJ5B5y4aCd5DM/0OHWstv3DR8s5O6tuCvqadoU
         kcmvWGVAqYfqcLEhHnXHaVUsrjTVvQtfYcDTBbcw=
Date:   Thu, 10 Jun 2021 15:25:17 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-page_vma_mapped_walk-crossing-page-table-boundary.patch added to -mm
 tree
Message-ID: <20210610222517.nyqjt_Ebs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): crossing page table boundary
has been added to the -mm tree.  Its filename is
     mm-page_vma_mapped_walk-crossing-page-table-boundary.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_vma_mapped_walk-crossing-page-table-boundary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): crossing page table boundary

page_vma_mapped_walk() cleanup: adjust the test for crossing page table
boundary - I believe pvmw->address is always page-aligned, but nothing
else here assumed that; and remember to reset pvmw->pte to NULL after
unmapping the page table, though I never saw any bug from that.

Link: https://lkml.kernel.org/r/799b3f9c-2a9e-dfef-5d89-26e9f76fd97@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-crossing-page-table-boundary
+++ a/mm/page_vma_mapped.c
@@ -247,16 +247,16 @@ next_pte:
 			if (pvmw->address >= end)
 				return not_found(pvmw);
 			/* Did we cross page table boundary? */
-			if (pvmw->address % PMD_SIZE == 0) {
-				pte_unmap(pvmw->pte);
+			if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
 				if (pvmw->ptl) {
 					spin_unlock(pvmw->ptl);
 					pvmw->ptl = NULL;
 				}
+				pte_unmap(pvmw->pte);
+				pvmw->pte = NULL;
 				goto restart;
-			} else {
-				pvmw->pte++;
 			}
+			pvmw->pte++;
 		} while (pte_none(*pvmw->pte));
 
 		if (!pvmw->ptl) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch
mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch
mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch
mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch
mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch
mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmd_read_atomic.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

