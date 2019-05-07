Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29DE516D3E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 23:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfEGVfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 17:35:00 -0400
Received: from out4437.biz.mail.alibaba.com ([47.88.44.37]:43938 "EHLO
        out4437.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbfEGVfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 17:35:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TR8MvA1_1557264889;
Received: from e19h19392.et15sqa.tbsite.net(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TR8MvA1_1557264889)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 May 2019 05:34:56 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     jstancek@redhat.com, will.deacon@arm.com, akpm@linux-foundation.org
Cc:     yang.shi@linux.alibaba.com, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force flush
Date:   Wed,  8 May 2019 05:34:49 +0800
Message-Id: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A few new fields were added to mmu_gather to make TLB flush smarter for
huge page by telling what level of page table is changed.

__tlb_reset_range() is used to reset all these page table state to
unchanged, which is called by TLB flush for parallel mapping changes for
the same range under non-exclusive lock (i.e. read mmap_sem).  Before
commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
munmap"), MADV_DONTNEED is the only one who may do page zapping in
parallel and it doesn't remove page tables.  But, the forementioned commit
may do munmap() under read mmap_sem and free page tables.  This causes a
bug [1] reported by Jan Stancek since __tlb_reset_range() may pass the
wrong page table state to architecture specific TLB flush operations.

So, removing __tlb_reset_range() sounds sane.  This may cause more TLB
flush for MADV_DONTNEED, but it should be not called very often, hence
the impact should be negligible.

The original proposed fix came from Jan Stancek who mainly debugged this
issue, I just wrapped up everything together.

[1] https://lore.kernel.org/linux-mm/342bf1fd-f1bf-ed62-1127-e911b5032274@linux.alibaba.com/T/#m7a2ab6c878d5a256560650e56189cfae4e73217f

Reported-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Jan Stancek <jstancek@redhat.com>
---
 mm/mmu_gather.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 99740e1..9fd5272 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -249,11 +249,12 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
 	 * flush by batching, a thread has stable TLB entry can fail to flush
 	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
 	 * forcefully if we detect parallel PTE batching threads.
+	 *
+	 * munmap() may change mapping under non-excluse lock and also free
+	 * page tables.  Do not call __tlb_reset_range() for it.
 	 */
-	if (mm_tlb_flush_nested(tlb->mm)) {
-		__tlb_reset_range(tlb);
+	if (mm_tlb_flush_nested(tlb->mm))
 		__tlb_adjust_range(tlb, start, end - start);
-	}
 
 	tlb_flush_mmu(tlb);
 
-- 
1.8.3.1

