Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C813D7E8D
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhG0Tfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhG0Tfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D74560FBF;
        Tue, 27 Jul 2021 19:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414534;
        bh=bb/7g31J6MHpjw7BKImW8c8wcmO5Moz6fsjclduLRoY=;
        h=Date:From:To:Subject:From;
        b=zkwFIhF24XgmqRjuEjH2XsZfQy2ZYAUHXuuGKgnINaKjSBqIIQO/c1WY/O1H/pIbc
         Lo52qxX/OHW16BFapvyDWo+bxauAsmWhJX5gxxeKvsNhiqg5501e6uzFEtRe6qCgfL
         /B/0rmjTLmxeW05KmD/9yqQMB/ktg0Fy8haseC00=
Date:   Tue, 27 Jul 2021 12:35:33 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, kirill.shutemov@linux.intel.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        tglx@linutronix.de, vdavydov.dev@gmail.com,
        zhengqi.arch@bytedance.com
Subject:  [merged] mm-fix-the-deadlock-in-finish_fault.patch
 removed from -mm tree
Message-ID: <20210727193533.dhRF2-eso%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix the deadlock in finish_fault()
has been removed from the -mm tree.  Its filename was
     mm-fix-the-deadlock-in-finish_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


