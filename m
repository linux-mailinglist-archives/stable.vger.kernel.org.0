Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906CC3A73E6
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 04:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhFOC2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 22:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhFOC2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 22:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48B896128B;
        Tue, 15 Jun 2021 02:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623723962;
        bh=LGhzZvCXy9jXjlZPzQcUe0YceEzbMsORUWMI7xnGbwE=;
        h=Date:From:To:Subject:From;
        b=pvQcIe6smcI/eK2VfRWP2yujJ1vvwI+WaqIuvZjfV8UnBsf1pdsePn4ls4FgBjnKd
         XSOaylyi1unWmmq/bh9LnsXbhDla63SfLwFpJizOmCQ4bPAQlY8TnRqr2W8Ttp21y4
         80a8ZlelucfLByEUQSAp859E84iAslw/zq6HMShQ=
Date:   Mon, 14 Jun 2021 19:26:01 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [withdrawn]
 mm-page_vma_mapped_walk-use-pmd_read_atomic.patch removed from -mm tree
Message-ID: <20210615022601.2rVBCGlMk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): use pmd_read_atomic()
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-use-pmd_read_atomic.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): use pmd_read_atomic()

page_vma_mapped_walk() cleanup: use pmd_read_atomic() with barrier()
instead of READ_ONCE() for pmde: some architectures (e.g.  i386 with PAE)
have a multi-word pmd entry, for which READ_ONCE() is not good enough.

Link: https://lkml.kernel.org/r/594c1f0-d396-5346-1f36-606872cddb18@google.com
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

 mm/page_vma_mapped.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-use-pmd_read_atomic
+++ a/mm/page_vma_mapped.c
@@ -182,13 +182,16 @@ restart:
 	pud = pud_offset(p4d, pvmw->address);
 	if (!pud_present(*pud))
 		return false;
+
 	pvmw->pmd = pmd_offset(pud, pvmw->address);
 	/*
 	 * Make sure the pmd value isn't cached in a register by the
 	 * compiler and used as a stale value after we've observed a
 	 * subsequent update.
 	 */
-	pmde = READ_ONCE(*pvmw->pmd);
+	pmde = pmd_read_atomic(pvmw->pmd);
+	barrier();
+
 	if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
 		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 		if (likely(pmd_trans_huge(*pvmw->pmd))) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch
mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch
mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch
mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch
mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch
mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

