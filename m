Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A342A4E2B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgKCSRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgKCSRB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 13:17:01 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF3C207BB;
        Tue,  3 Nov 2020 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427421;
        bh=WEtXOWE1xtG4/g8Lhug1ADD82+cZ0V/XgIGg1k7XHcs=;
        h=Date:From:To:Subject:From;
        b=WWgWq0xO/cxR3MZA//gHUBX1Z+twp0UP+9IhOXeX6cwHoZ9J+9PT3lHqSVObdF7Tu
         4GhxaNE3aFGEQiXGEqitkVkk0uGhYbY1zcAK/1AKFtPcOIO/EmGkvOtWhWnxBJQj3R
         35xLh4ZuVVoVBlNYwaye8aUo1dNTaNb2wxeedJQo=
Date:   Tue, 03 Nov 2020 10:17:00 -0800
From:   akpm@linux-foundation.org
To:     linfeilong@huawei.com, linmiaohe@huawei.com, luoshijie1@huawei.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org
Subject:  [merged]
 mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error.patch removed from
 -mm tree
Message-ID: <20201103181700.9blVqSSEg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: fix potential pte_unmap_unlock pte error
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shijie Luo <luoshijie1@huawei.com>
Subject: mm: mempolicy: fix potential pte_unmap_unlock pte error

When flags in queue_pages_pte_range don't have MPOL_MF_MOVE or
MPOL_MF_MOVE_ALL bits, code breaks and passing origin pte - 1 to
pte_unmap_unlock seems like not a good idea.

queue_pages_pte_range can run in MPOL_MF_MOVE_ALL mode which doesn't
migrate misplaced pages but returns with EIO when encountering such a
page.  Since commit a7f40cfe3b7a ("mm: mempolicy: make mbind() return -EIO
when MPOL_MF_STRICT is specified") and early break on the first pte in the
range results in pte_unmap_unlock on an underflow pte.  This can lead to
lockups later on when somebody tries to lock the pte resp. 
page_table_lock again..

Link: https://lkml.kernel.org/r/20201019074853.50856-1-luoshijie1@huawei.com
Fixes: a7f40cfe3b7a ("mm: mempolicy: make mbind() return -EIO when MPOL_MF_STRICT is specified")
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Shijie Luo <luoshijie1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error
+++ a/mm/mempolicy.c
@@ -525,7 +525,7 @@ static int queue_pages_pte_range(pmd_t *
 	unsigned long flags = qp->flags;
 	int ret;
 	bool has_unmovable = false;
-	pte_t *pte;
+	pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
@@ -539,7 +539,7 @@ static int queue_pages_pte_range(pmd_t *
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	mapped_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
@@ -571,7 +571,7 @@ static int queue_pages_pte_range(pmd_t *
 		} else
 			break;
 	}
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 	cond_resched();
 
 	if (has_unmovable)
_

Patches currently in -mm which might be from luoshijie1@huawei.com are


