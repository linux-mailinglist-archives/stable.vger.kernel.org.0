Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378383A370A
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFJW1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhFJW1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01CD6613FF;
        Thu, 10 Jun 2021 22:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363931;
        bh=wEVzECxTWxGUrtN8RoFwdlYbvSPKjSSAUuffbKvLGLE=;
        h=Date:From:To:Subject:From;
        b=dE8o3ghCaUfYmwV7UvwP1tFvpmwMHt3qTt4IRNbr1OBfTT4/+h7JzkP4KqiKtNSN4
         ZACVHsBiJ3x5E1qXGWWxHIT7KAVjj9rvlwd1hgBEjhx29NRvyBphPk87IyZA/YNfrp
         mBsONh+WPkMi/9ke0R++bnvG1tP+jwMbLItPJ9AQ=
Date:   Thu, 10 Jun 2021 15:25:30 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch added to -mm
 tree
Message-ID: <20210610222530.k0Dw3wymb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
has been added to the -mm tree.  Its filename is
     mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch

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
Subject: mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()

Aha!  Shouldn't that quick scan over pte_none()s make sure that it holds
ptlock in the PVMW_SYNC case?  That too might have been responsible for
BUGs or WARNs in split_huge_page_to_list() or its unmap_page(), though
I've never seen any.

Link: https://lkml.kernel.org/r/1bdf384c-8137-a149-2a1e-475a4791c3c@google.com
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

 mm/page_vma_mapped.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_vma_mapped.c~mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk
+++ a/mm/page_vma_mapped.c
@@ -277,6 +277,10 @@ next_pte:
 				goto restart;
 			}
 			pvmw->pte++;
+			if ((pvmw->flags & PVMW_SYNC) && !pvmw->ptl) {
+				pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
+				spin_lock(pvmw->ptl);
+			}
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

