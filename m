Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC63B5562
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhF0V4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6EDF61C31;
        Sun, 27 Jun 2021 21:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830830;
        bh=w8DPIgiNAdDNa4gTGOmTfO7RuCs+3w79+kjkVi9Tc7I=;
        h=Date:From:To:Subject:From;
        b=HPrMv5LloQIExGLBou7390TieDj0tvmBCYNlhTv5HzZmQkcu9vgcBO+PH1do6GRxR
         O7mROaDtK6GQb/LLNDOis3P4XCf3GaaHRKy7RhQHZI/hKknlHKGNxztlKaLxyPd/L/
         8Tyze6aLJLedPrCsUExzDQZbsFvKwjztpb9FR2rQ=
Date:   Sun, 27 Jun 2021 14:53:49 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rcampbell@nvidia.com, shy828301@gmail.com,
        stable@vger.kernel.org, wangyugui@e16-tech.com, will@kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch removed from -mm
 tree
Message-ID: <20210627215349.QjAsSy7ki%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
has been removed from the -mm tree.  Its filename was
     mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()

Aha!  Shouldn't that quick scan over pte_none()s make sure that it holds
ptlock in the PVMW_SYNC case?  That too might have been responsible for
BUGs or WARNs in split_huge_page_to_list() or its unmap_page(), though
I've never seen any.

Link: https://lkml.kernel.org/r/1bdf384c-8137-a149-2a1e-475a4791c3c@google.com
Link: https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Wang Yugui <wangyugui@e16-tech.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
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
@@ -276,6 +276,10 @@ next_pte:
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

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

