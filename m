Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FA235B92C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 05:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhDLD6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 23:58:05 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:51987 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235261AbhDLD6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 23:58:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UVD5kgn_1618199860;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UVD5kgn_1618199860)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 12 Apr 2021 11:57:46 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chen si <cici.cs@alibaba-inc.com>,
        Baoyou Xie <baoyou.xie@aliyun.com>,
        Wen Yang <wenyang@linux.alibaba.org>,
        Zijiang Huang <zijiang.hzj@alibaba-inc.com>
Subject: [PATCH 4.9] mm: add cond_resched() in gather_pte_stats()
Date:   Mon, 12 Apr 2021 11:57:31 +0800
Message-Id: <20210412035731.82811-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit a66c0410b97c07a5708881198528ce724f7a3226 upstream.

The other pagetable walks in task_mmu.c have a cond_resched() after
walking their ptes: add a cond_resched() in gather_pte_stats() too, for
reading /proc/<id>/numa_maps.  Only pagemap_pmd_range() has a
cond_resched() in its (unusually expensive) pmd_trans_huge case: more
should probably be added, but leave them unchanged for now.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052157400.13021@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 4.9.x
Reported-by: Chen si <cici.cs@alibaba-inc.com>
Signed-off-by: Baoyou Xie <baoyou.xie@aliyun.com>
Signed-off-by: Wen Yang <wenyang@linux.alibaba.org>
Signed-off-by: Zijiang Huang <zijiang.hzj@alibaba-inc.com>
---
 fs/proc/task_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4b207b1..e6c8ead 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1609,6 +1609,7 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	pte_unmap_unlock(orig_pte, ptl);
+	cond_resched();
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
-- 
1.8.3.1

