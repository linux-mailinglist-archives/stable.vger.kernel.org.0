Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935793A3705
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhFJW1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhFJW1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F1D3613DE;
        Thu, 10 Jun 2021 22:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363928;
        bh=yB5gYvbM7RY4hTIvRcPgPzf831V2XWjApZlqKb60qY4=;
        h=Date:From:To:Subject:From;
        b=WOXNq8z8EKaIEyl2k/LDfPZZuURPvz7htezz+VPOica6eTwgMh7pgx6ApQzSY95Ja
         dQn5x25K6Vo+MeEn7tKog6QV4uOmPv6hkpXMMf7nMtzQIAEyx7fZdrVXxP0HOxUYnK
         8W7MRfB4xmypGox+ujuAKnEkJiCc9reJ9rmFyDuM=
Date:   Thu, 10 Jun 2021 15:25:27 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch added to -mm
 tree
Message-ID: <20210610222527.xZZsnMVjW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
has been added to the -mm tree.  Its filename is
     mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch

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
Subject: mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes

Running certain tests with a DEBUG_VM kernel would crash within hours, on
the total_mapcount BUG() in split_huge_page_to_list(), while trying to
free up some memory by punching a hole in a shmem huge page: split's
try_to_unmap() was unable to find all the mappings of the page (which, on
a !DEBUG_VM kernel, would then keep the huge page pinned in memory).

Crash dumps showed two tail pages of a shmem huge page remained mapped by
pte: ptes in a non-huge-aligned vma of a gVisor process, at the end of a
long unmapped range; and no page table had yet been allocated for the head
of the huge page to be mapped into.

Although designed to handle these odd misaligned huge-page-mapped-by-pte
cases, page_vma_mapped_walk() falls short by returning false prematurely
when !pmd_present or !pud_present or !p4d_present or !pgd_present: there
are cases when a huge page may span the boundary, with ptes present in the
next.

Restructure page_vma_mapped_walk() as a loop to continue in these cases,
while keeping its layout much as before.  Add a step_forward() helper to
advance pvmw->address across those boundaries: originally I tried to use
mm's standard p?d_addr_end() macros, but hit the same crash 512 times less
often: because of the way redundant levels are folded together, but folded
differently in different configurations, it was just too difficult to use
them correctly; and step_forward() is simpler anyway.

Link: https://lkml.kernel.org/r/fedb8632-1798-de42-f39e-873551d5bc81@google.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
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

 mm/page_vma_mapped.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/mm/page_vma_mapped.c~mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes
+++ a/mm/page_vma_mapped.c
@@ -116,6 +116,13 @@ static bool check_pte(struct page_vma_ma
 	return pfn_is_match(pvmw->page, pfn);
 }
 
+static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
+{
+	pvmw->address = (pvmw->address + size) & ~(size - 1);
+	if (!pvmw->address)
+		pvmw->address = ULONG_MAX;
+}
+
 /**
  * page_vma_mapped_walk - check if @pvmw->page is mapped in @pvmw->vma at
  * @pvmw->address
@@ -183,16 +190,22 @@ bool page_vma_mapped_walk(struct page_vm
 	if (pvmw->pte)
 		goto next_pte;
 restart:
-	{
+	do {
 		pgd = pgd_offset(mm, pvmw->address);
-		if (!pgd_present(*pgd))
-			return false;
+		if (!pgd_present(*pgd)) {
+			step_forward(pvmw, PGDIR_SIZE);
+			continue;
+		}
 		p4d = p4d_offset(pgd, pvmw->address);
-		if (!p4d_present(*p4d))
-			return false;
+		if (!p4d_present(*p4d)) {
+			step_forward(pvmw, P4D_SIZE);
+			continue;
+		}
 		pud = pud_offset(p4d, pvmw->address);
-		if (!pud_present(*pud))
-			return false;
+		if (!pud_present(*pud)) {
+			step_forward(pvmw, PUD_SIZE);
+			continue;
+		}
 
 		pvmw->pmd = pmd_offset(pud, pvmw->address);
 		/*
@@ -240,7 +253,8 @@ restart:
 
 				spin_unlock(ptl);
 			}
-			return false;
+			step_forward(pvmw, PMD_SIZE);
+			continue;
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
@@ -270,7 +284,9 @@ next_pte:
 			spin_lock(pvmw->ptl);
 		}
 		goto this_pte;
-	}
+	} while (pvmw->address < end);
+
+	return false;
 }
 
 /**
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

