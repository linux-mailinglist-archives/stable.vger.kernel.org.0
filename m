Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8103B5559
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhF0Vzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhF0Vzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F92561C32;
        Sun, 27 Jun 2021 21:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830803;
        bh=mW2/ySEsXUtncPYZcIhlAZjjyYiCUaA0r8IB+e4L9Cw=;
        h=Date:From:To:Subject:From;
        b=lkGDJ7gZ8RJbEy1nT5b5kS5T376FF0v+nnuRXjpMxY/NnWBGBF2+hAg7FWBVzntk/
         e0XrlnP8Qzit0j+Go7WQZZS/VnnNe4wQQKRqxymwMzmest9DRxmyOQP9WY/k+LeVZa
         bQlwWAnrzR0ZPGNhUQ5wXIhoTYQj/Mqla0StUquQ=
Date:   Sun, 27 Jun 2021 14:53:22 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch removed from -mm tree
Message-ID: <20210627215322.3wOmmiGRX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): use page for pvmw->page
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

