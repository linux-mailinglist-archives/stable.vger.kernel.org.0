Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798332B602D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgKQNHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbgKQNHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:07:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85E1D221EB;
        Tue, 17 Nov 2020 13:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618423;
        bh=LNZuy9ndNPfOV1EXe5VTgCg1MZvORSf4NFK4JU1ECuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mt9FnRUcPmGFW0Hod8I7qTYiwTTK5dWVjf0ypXcAcS/mZzx452qTEfZhmA7pxMdht
         j/9zQ1mKzzhEUPEeG7RL85xnEStliWF+uVB8GmPAZewB8Ycfbvt1ELoDd6WnBAUhs5
         VFuic7gDBmrGsfRuVRpk6E7Yl2BW3URNCFCX0ZtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijie Luo <luoshijie1@huawei.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Feilong Lin <linfeilong@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/64] mm: mempolicy: fix potential pte_unmap_unlock pte error
Date:   Tue, 17 Nov 2020 14:04:26 +0100
Message-Id: <20201117122106.299492637@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shijie Luo <luoshijie1@huawei.com>

[ Upstream commit 3f08842098e842c51e3b97d0dcdebf810b32558e ]

When flags in queue_pages_pte_range don't have MPOL_MF_MOVE or
MPOL_MF_MOVE_ALL bits, code breaks and passing origin pte - 1 to
pte_unmap_unlock seems like not a good idea.

queue_pages_pte_range can run in MPOL_MF_MOVE_ALL mode which doesn't
migrate misplaced pages but returns with EIO when encountering such a
page.  Since commit a7f40cfe3b7a ("mm: mempolicy: make mbind() return
-EIO when MPOL_MF_STRICT is specified") and early break on the first pte
in the range results in pte_unmap_unlock on an underflow pte.  This can
lead to lockups later on when somebody tries to lock the pte resp.
page_table_lock again..

Fixes: a7f40cfe3b7a ("mm: mempolicy: make mbind() return -EIO when MPOL_MF_STRICT is specified")
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Shijie Luo <luoshijie1@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201019074853.50856-1-luoshijie1@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e101cac3d4a63..9ab7969ee7e30 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -490,14 +490,14 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
 	int nid;
-	pte_t *pte;
+	pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 
 	split_huge_page_pmd(vma, addr, pmd);
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	mapped_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
@@ -521,7 +521,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		} else
 			break;
 	}
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 	cond_resched();
 	return addr != end ? -EIO : 0;
 }
-- 
2.27.0



