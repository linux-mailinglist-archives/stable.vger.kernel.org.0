Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12B73A36FC
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFJW1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhFJW1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0096761403;
        Thu, 10 Jun 2021 22:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363907;
        bh=ENvB32Gl334FPoIyvVikTUldk1vSgRYUTIbkkhXjZ6A=;
        h=Date:From:To:Subject:From;
        b=IPZ3NMYHjLCXmitP+gMX67A0EhBvHJakChT7Z/dghicwhBoyRozGprTC147GbgkQx
         ana5FTwKxEAKspE8glL2OzxGdOa2tX2/pABU01JgMz5u5AgRZXVVQy4JeP5Xpl9ceU
         muiIgGX6adM2HNZMsX+QAbYNpFDoxvoRQd3brqlc=
Date:   Thu, 10 Jun 2021 15:25:06 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  + mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
 added to -mm tree
Message-ID: <20210610222506.xY1WgYkb6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): use page for pvmw->page
has been added to the -mm tree.  Its filename is
     mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch

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
Subject: mm: page_vma_mapped_walk(): use page for pvmw->page

Patch series "mm: page_vma_mapped_walk() cleanup and THP fixes".

I've marked all of these for stable: many are merely cleanups,
but I think they are much better before the main fix than after.


This patch (of 11):

page_vma_mapped_walk() cleanup: sometimes the local copy of pvwm->page was
used, sometimes pvmw->page itself: use the local copy "page" throughout.

Link: https://lkml.kernel.org/r/589b358c-febc-c88e-d4c2-7834b37fa7bf@google.com
Link: https://lkml.kernel.org/r/88e67645-f467-c279-bf5e-af4b5c6b13eb@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-use-page-for-pvmw-page
+++ a/mm/page_vma_mapped.c
@@ -156,7 +156,7 @@ bool page_vma_mapped_walk(struct page_vm
 	if (pvmw->pte)
 		goto next_pte;
 
-	if (unlikely(PageHuge(pvmw->page))) {
+	if (unlikely(PageHuge(page))) {
 		/* when pud is not present, pte will be NULL */
 		pvmw->pte = huge_pte_offset(mm, pvmw->address, page_size(page));
 		if (!pvmw->pte)
@@ -217,8 +217,7 @@ restart:
 		 * cannot return prematurely, while zap_huge_pmd() has
 		 * cleared *pmd but not decremented compound_mapcount().
 		 */
-		if ((pvmw->flags & PVMW_SYNC) &&
-		    PageTransCompound(pvmw->page)) {
+		if ((pvmw->flags & PVMW_SYNC) && PageTransCompound(page)) {
 			spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
 
 			spin_unlock(ptl);
@@ -234,9 +233,9 @@ restart:
 			return true;
 next_pte:
 		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
+		if (!PageTransHuge(page) || PageHuge(page))
 			return not_found(pvmw);
-		end = vma_address_end(pvmw->page, pvmw->vma);
+		end = vma_address_end(page, pvmw->vma);
 		do {
 			pvmw->address += PAGE_SIZE;
 			if (pvmw->address >= end)
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

