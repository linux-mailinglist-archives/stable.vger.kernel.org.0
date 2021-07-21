Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2503D1862
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 22:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhGUUJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 16:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229604AbhGUUJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 16:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E76561221;
        Wed, 21 Jul 2021 20:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900630;
        bh=nEbhg4BaoRkVHKaJzJW1XMJA4EPL7AUa3/vQoVnjPaQ=;
        h=Date:From:To:Subject:From;
        b=1XgZBB69syUr7c0zEIufO5+YS5UqLeSWCOjeDpUT1mXE/FeNHSH2ZywjudVJ81Ym/
         VYxLbkSdZdcoJPVoen/mMQR0ifEg0tMo/qadQxOpldvUyez09P4uHUUU8gBI/sImhl
         KV8ujotR4IIb5J2a+N6R/uvhMDN+Qs4xrZbmupUo=
Date:   Wed, 21 Jul 2021 13:50:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, hannes@cmpxchg.org,
        zhengqi.arch@bytedance.com
Subject:  + mm-fix-the-deadlock-in-finish_fault.patch added to -mm
 tree
Message-ID: <20210721205028.u0rxk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix the deadlock in finish_fault()
has been added to the -mm tree.  Its filename is
     mm-fix-the-deadlock-in-finish_fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-deadlock-in-finish_fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-deadlock-in-finish_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-the-deadlock-in-finish_fault.patch

