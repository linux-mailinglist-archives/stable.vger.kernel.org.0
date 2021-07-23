Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00D93D431D
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhGWWKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhGWWKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 18:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A24260F36;
        Fri, 23 Jul 2021 22:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080642;
        bh=qyIRbpPTuKODVQT4LmP5uJdVw2Fzbx73I9+6/4FEAFA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0S9GHftdUxFexHBb6T7VcG3GS1+c34gUtoDgq3obaYlGmuc5ujtkIEOAZYx7Er9fc
         Hj8ju5sfCisE675eufIVHC6aX5N3Xoy+Rqe5+ZMduxAATCMfvqGQR9+GGBJitZ7adz
         4VXTwYT8AM1ilDT0LJWWqQNwWJq1DGKwx1GcM7PU=
Date:   Fri, 23 Jul 2021 15:50:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com, zhengqi.arch@bytedance.com
Subject:  [patch 14/15] mm: fix the deadlock in finish_fault()
Message-ID: <20210723225041.VB3Yq9fkx%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: fix the deadlock in finish_fault()

Commit 63f3655f9501 ("mm, memcg: fix reclaim deadlock with writeback") fix
the following ABBA deadlock by pre-allocating the pte page table without
holding the page lock.

	                                lock_page(A)
                                        SetPageWriteback(A)
                                        unlock_page(A)
  lock_page(B)
                                        lock_page(B)
  pte_alloc_one
    shrink_page_list
      wait_on_page_writeback(A)
                                        SetPageWriteback(B)
                                        unlock_page(B)

                                        # flush A, B to clear the writeback

Commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
codepaths") rework the relevant code but ignore this race.  This will
cause the deadlock above to appear again, so fix it.

Link: https://lkml.kernel.org/r/20210721074849.57004-1-zhengqi.arch@bytedance.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-the-deadlock-in-finish_fault
+++ a/mm/memory.c
@@ -4026,8 +4026,17 @@ vm_fault_t finish_fault(struct vm_fault
 				return ret;
 		}
 
-		if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd)))
+		if (vmf->prealloc_pte) {
+			vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+			if (likely(pmd_none(*vmf->pmd))) {
+				mm_inc_nr_ptes(vma->vm_mm);
+				pmd_populate(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
+				vmf->prealloc_pte = NULL;
+			}
+			spin_unlock(vmf->ptl);
+		} else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd))) {
 			return VM_FAULT_OOM;
+		}
 	}
 
 	/* See comment in handle_pte_fault() */
_
