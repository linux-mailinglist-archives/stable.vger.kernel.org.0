Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3403B3A85
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhFYBll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhFYBll (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD0061220;
        Fri, 25 Jun 2021 01:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585161;
        bh=Gg5smAB42gp6ciOE+Avp+9NE+1VjecbAaiYsOYAlaOY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oUPBtV4pXiSeTN6zp09bcKWkTvyqgsNKSM7GwnNINM8lj1aKKA/Bdtl9Ntf8cMY/J
         STMMGO4HtzK4ReP+bo+6JvfA9V60pG5PQ35p0KDgLHeux/L++Jx+x9NvzHFtMLGX1m
         OYhdkVGNRR0S37QB9DZWVS1Nu3c1SgrmOaw3raxo=
Date:   Thu, 24 Jun 2021 18:39:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        will@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 07/24] mm: page_vma_mapped_walk(): use goto
 instead of while (1)
Message-ID: <20210625013920.Hun6MvfTf%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): use goto instead of while (1)

page_vma_mapped_walk() cleanup: add a label this_pte, matching next_pte,
and use "goto this_pte", in place of the "while (1)" loop at the end.

Link: https://lkml.kernel.org/r/a52b234a-851-3616-2525-f42736e8934@google.com
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

 mm/page_vma_mapped.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-use-goto-instead-of-while-1
+++ a/mm/page_vma_mapped.c
@@ -144,6 +144,7 @@ bool page_vma_mapped_walk(struct page_vm
 {
 	struct mm_struct *mm = pvmw->vma->vm_mm;
 	struct page *page = pvmw->page;
+	unsigned long end;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -233,10 +234,7 @@ restart:
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
-	}
-	while (1) {
-		unsigned long end;
-
+this_pte:
 		if (check_pte(pvmw))
 			return true;
 next_pte:
@@ -265,6 +263,7 @@ next_pte:
 			pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
 			spin_lock(pvmw->ptl);
 		}
+		goto this_pte;
 	}
 }
 
_
