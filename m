Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD87D3B555C
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhF0Vz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0Vz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5C161C31;
        Sun, 27 Jun 2021 21:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830812;
        bh=4kfpmM0PzHM2tYHNw7OCKzLEgNtyXW33p2f6PdzupMg=;
        h=Date:From:To:Subject:From;
        b=i+o5+HvAUZ8exWGguMablUtEQPRAGssjvlV7+jjqnSPvdkTuV6EmPfJDSbnK08y5G
         IhEvSsrodvct37G+tMBv0CjU2jG+1o787lhHwSOiXCk3XdjTAMb+yZHigCE4fjN5DE
         hd8Z51m2uIIyuX93/UgeWNI2pT2DX06Lm+jlLpmw=
Date:   Sun, 27 Jun 2021 14:53:31 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch removed from
 -mm tree
Message-ID: <20210627215331.YKNTXcW4J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -198,24 +198,22 @@ restart:
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

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

