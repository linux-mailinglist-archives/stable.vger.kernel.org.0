Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B5B3B3A83
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhFYBlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhFYBlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78B696044F;
        Fri, 25 Jun 2021 01:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585154;
        bh=JmjujSDruL4vbxq24MCV9pysNj4XsLMyQsStxkqC7tQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WkKOZBrqJVyp+TzG1Q81ohiPUzMdlt7JrqazSVZC+Nb2os29j3SU6ewEhMsMngx9J
         ugdy16NhzhB/mQZYQyRqOKghM67NgjwsCKc2GsHsETdet2NZ2GCcScbEj/W4sCTz+W
         VWKXxSwDmHWUpqZ7OlFSUr1o5prve7FJvidm/ndY=
Date:   Thu, 24 Jun 2021 18:39:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        will@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 05/24] mm: page_vma_mapped_walk(): crossing page
 table boundary
Message-ID: <20210625013914.f4FSy3CBd%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): crossing page table boundary

page_vma_mapped_walk() cleanup: adjust the test for crossing page table
boundary - I believe pvmw->address is always page-aligned, but nothing
else here assumed that; and remember to reset pvmw->pte to NULL after
unmapping the page table, though I never saw any bug from that.

Link: https://lkml.kernel.org/r/799b3f9c-2a9e-dfef-5d89-26e9f76fd97@google.com
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

 mm/page_vma_mapped.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-crossing-page-table-boundary
+++ a/mm/page_vma_mapped.c
@@ -244,16 +244,16 @@ next_pte:
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
