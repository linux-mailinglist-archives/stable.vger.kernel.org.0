Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAC43B3A80
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 03:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhFYBl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 21:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhFYBlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D906C613B9;
        Fri, 25 Jun 2021 01:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585145;
        bh=ZcNubpwxRZpZ8HyeY7zOH9cmVZJhx5kgAiX8YhGJtVQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xiP4xoEs5Siwl49YgDGRHJkAMRZhpi4uJP64pgmsXgykar8Pp5YK9wj3LnpBhX9QM
         tkbIC0Q8XAR7HJ7qt+vlVXtlH4OqPvUm9Gmvw6q6cGVFYkR1iH4A+Pytq/8oBhPK2a
         XXPNjUD1YcRZr3LuY0g9EKIWoXNLDIvcQMjl42OE=
Date:   Thu, 24 Jun 2021 18:39:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        will@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 02/24] mm: page_vma_mapped_walk(): settle PageHuge
 on entry
Message-ID: <20210625013904.dOSX0-9cG%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): settle PageHuge on entry

page_vma_mapped_walk() cleanup: get the hugetlbfs PageHuge case out of the
way at the start, so no need to worry about it later.

Link: https://lkml.kernel.org/r/e31a483c-6d73-a6bb-26c5-43c3b880a2@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-settle-pagehuge-on-entry
+++ a/mm/page_vma_mapped.c
@@ -153,10 +153,11 @@ bool page_vma_mapped_walk(struct page_vm
 	if (pvmw->pmd && !pvmw->pte)
 		return not_found(pvmw);
 
-	if (pvmw->pte)
-		goto next_pte;
-
 	if (unlikely(PageHuge(page))) {
+		/* The only possible mapping was handled on last iteration */
+		if (pvmw->pte)
+			return not_found(pvmw);
+
 		/* when pud is not present, pte will be NULL */
 		pvmw->pte = huge_pte_offset(mm, pvmw->address, page_size(page));
 		if (!pvmw->pte)
@@ -168,6 +169,9 @@ bool page_vma_mapped_walk(struct page_vm
 			return not_found(pvmw);
 		return true;
 	}
+
+	if (pvmw->pte)
+		goto next_pte;
 restart:
 	pgd = pgd_offset(mm, pvmw->address);
 	if (!pgd_present(*pgd))
@@ -233,7 +237,7 @@ restart:
 			return true;
 next_pte:
 		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(page) || PageHuge(page))
+		if (!PageTransHuge(page))
 			return not_found(pvmw);
 		end = vma_address_end(page, pvmw->vma);
 		do {
_
