Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A1B3C975B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 06:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhGOEaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 00:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236439AbhGOEaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 00:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 716DC613B2;
        Thu, 15 Jul 2021 04:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323231;
        bh=9m0k110N20kOAoP/o62BcYLkYEF1k7ZEGkRxpN1LxW4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Jxns9f0nh5iFonmRirk9p1rMWpQ+Q8m7zXlPLCYUGL//VCSWxpTAJiEJmFPXEioiC
         KP+PVX0tU8FukAljXxcH4D3djtQiklr87Z4NLuNEjiMj0U+YhMDbdfxm/3KsyAhyPD
         odUbbxsCY7f7uj5pKTT21j3IYnMNvUrfi/cmwNeA=
Date:   Wed, 14 Jul 2021 21:27:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joao.m.martins@oracle.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 13/13] mm/hugetlb: fix refs calculation from
 unaligned @vaddr
Message-ID: <20210715042711.DQ8aY7BZt%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb: fix refs calculation from unaligned @vaddr

commit 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording") refactored
the count of subpages but missed an edge case when @vaddr is not aligned
to PAGE_SIZE e.g.  when close to vma->vm_end.  It would then errousnly set
@refs to 0 and record_subpages_vmas() wouldn't set the @pages array
element to its value, consequently causing the reported null-deref by
syzbot.

Fix it by aligning down @vaddr by PAGE_SIZE in @refs calculation.

Link: https://lkml.kernel.org/r/20210713152440.28650-1-joao.m.martins@oracle.com
Fixes: 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording")
Reported-by: syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-refs-calculation-from-unaligned-vaddr
+++ a/mm/hugetlb.c
@@ -5440,8 +5440,9 @@ long follow_hugetlb_page(struct mm_struc
 			continue;
 		}
 
-		refs = min3(pages_per_huge_page(h) - pfn_offset,
-			    (vma->vm_end - vaddr) >> PAGE_SHIFT, remainder);
+		/* vaddr may not be aligned to PAGE_SIZE */
+		refs = min3(pages_per_huge_page(h) - pfn_offset, remainder,
+		    (vma->vm_end - ALIGN_DOWN(vaddr, PAGE_SIZE)) >> PAGE_SHIFT);
 
 		if (pages || vmas)
 			record_subpages_vmas(mem_map_offset(page, pfn_offset),
_
