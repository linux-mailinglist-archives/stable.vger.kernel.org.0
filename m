Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFFD3B3A7F
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhFYBlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhFYBlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98EA161220;
        Fri, 25 Jun 2021 01:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585142;
        bh=DsRLpAhxGXVi4qKVXcSAFnKMtU65qkrjCMA4rNM5AyU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ItSNY5CkN//XMHm5uASXsfsrK/eFkZ7jI2tAK4O9UjjE78zLORqHy/YLHKR+4jXZO
         lVjXs276WP+g1rX3BKoAcHHLis893yqKRqpk34AT8DJBxYtx7h7U73R1ebwsiBloOU
         Zb2HTgWQPcJCJZwK5otpPJlIjiDC/g+Txw3MXK8Q=
Date:   Thu, 24 Jun 2021 18:39:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        will@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 01/24] mm: page_vma_mapped_walk(): use page for
 pvmw->page
Message-ID: <20210625013901.BV8rXpKTb%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
