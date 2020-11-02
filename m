Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835E62A22A9
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 02:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbgKBBHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 20:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:41 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A592224E;
        Mon,  2 Nov 2020 01:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279261;
        bh=KQyvInCeV8g8Ip77u4HjEJIrTODVwkoIzUOSzXtWyY4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kR/xOWdwkhCqYSCjwEjElCcsdcEI0/JSSGemIaB3T10K2uK+Rz0g65f7DHmKNDq17
         VLPKvc8FrY7ymsI8pYZTEgSMKYYQX2tx5KSTrZ5E7AovwEBKRfsDt5HF5I+Yf6iCbo
         y2EM8EZvY1HLol2ysyenciw/vdpJEw0zDUc/hUzA=
Date:   Sun, 01 Nov 2020 17:07:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linfeilong@huawei.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, luoshijie1@huawei.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 06/15] mm: mempolicy: fix potential
 pte_unmap_unlock pte error
Message-ID: <20201102010740._TcS3al1I%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
