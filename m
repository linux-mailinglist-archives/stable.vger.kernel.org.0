Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AD03A3701
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhFJW1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhFJW1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDEAF613FF;
        Thu, 10 Jun 2021 22:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363916;
        bh=a/UYJaHh0gAAjHKfPDXzIPVZ74wdtv3PjCUXdugFN1I=;
        h=Date:From:To:Subject:From;
        b=QGxn2Cb9O3kbIvhONZ4HFPjIxvOmygPK0axXU68iDOfmU5THXh1rsl4eQm2JUhmAW
         FgdbBcnzRQ0Qv0NXXeoJEYZd5uZ4Fim1SyR2NQvysalh31bzVwtw+Z9ZwHTs3uAjl8
         Sx3GQyPlh44fjxRtGFWWWdUnKQKkYUYEjrQB4BPc=
Date:   Thu, 10 Jun 2021 15:25:15 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch added to -mm
 tree
Message-ID: <20210610222515.9k2NoDC6w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
has been added to the -mm tree.  Its filename is
     mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch

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
Subject: mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block

page_vma_mapped_walk() cleanup: rearrange the !pmd_present() block to
follow the same "return not_found, return not_found, return true" pattern
as the block above it (note: returning not_found there is never premature,
since existence or prior existence of huge pmd guarantees good alignment).

Link: https://lkml.kernel.org/r/378c8650-1488-2edf-9647-32a53cf2e21@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-prettify-pvmw_migration-block
+++ a/mm/page_vma_mapped.c
@@ -201,24 +201,22 @@ restart:
 			if (pmd_page(pmde) != page)
 				return not_found(pvmw);
 			return true;
-		} else if (!pmd_present(pmde)) {
-			if (thp_migration_supported()) {
-				if (!(pvmw->flags & PVMW_MIGRATION))
-					return not_found(pvmw);
-				if (is_migration_entry(pmd_to_swp_entry(pmde))) {
-					swp_entry_t entry = pmd_to_swp_entry(pmde);
+		}
+		if (!pmd_present(pmde)) {
+			swp_entry_t entry;
 
-					if (migration_entry_to_page(entry) != page)
-						return not_found(pvmw);
-					return true;
-				}
-			}
-			return not_found(pvmw);
-		} else {
-			/* THP pmd was split under us: handle on pte level */
-			spin_unlock(pvmw->ptl);
-			pvmw->ptl = NULL;
+			if (!thp_migration_supported() ||
+			    !(pvmw->flags & PVMW_MIGRATION))
+				return not_found(pvmw);
+			entry = pmd_to_swp_entry(pmde);
+			if (!is_migration_entry(entry) ||
+			    migration_entry_to_page(entry) != page)
+				return not_found(pvmw);
+			return true;
 		}
+		/* THP pmd was split under us: handle on pte level */
+		spin_unlock(pvmw->ptl);
+		pvmw->ptl = NULL;
 	} else if (!pmd_present(pmde)) {
 		/*
 		 * If PVMW_SYNC, take and drop THP pmd lock so that we
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

