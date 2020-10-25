Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637B029836E
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 20:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418633AbgJYTum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 15:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1418632AbgJYTum (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Oct 2020 15:50:42 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B47372223C;
        Sun, 25 Oct 2020 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603655439;
        bh=4u7IFYWQqFOEsOoLnc7N2hujBL8SzGW7WJh4BG/C7F4=;
        h=Date:From:To:Subject:From;
        b=eCENUkA038aDarcvLXGZIGXybrvMGT61OarSbGd7dhB1Lhhi6H5t7UVII0PTYb3Hf
         j6X/Gos54PCwwvMGsDB+05f3IyVdxQ6ZXbmzfLw8EQ/WPimUsPlaZ70qRu+O8nXpym
         fF4wqxTeDtkMVgeMem9rw8GB5ug1MakaTUbbgxYg=
Date:   Sun, 25 Oct 2020 12:50:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, mhocko@suse.com, linmiaohe@huawei.com,
        linfeilong@huawei.com, luoshijie1@huawei.com
Subject:  +
 mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error.patch added to -mm tree
Message-ID: <20201025195037.YsXPE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: fix potential pte_unmap_unlock pte error
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mempolicy-fix-potential-pte_unmap_unlock-pte-error.patch

