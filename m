Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F25B21A937
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 22:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgGIUmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 16:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 16:42:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF1620774;
        Thu,  9 Jul 2020 20:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594327331;
        bh=ifkgy+/BXxH0yjPpHJVlko0Tg4YYFmCSH7VMsYRhFb0=;
        h=Date:From:To:Subject:From;
        b=xgFxenhyE/Hzl/K097lR2U+eNLf1HfgoBk6NHL2GahNX0tmFjGeTx+ZUwTYt52V1n
         8NNYqHst4h8accOTAPFHKHwhvS/F0JXZm897qa1RaS+/deTntg18oLJU4PHVZlT9zv
         iUSeSW59/Wh4zU5vadyYzP1oB2pEKfaRTGYDhIrg=
Date:   Thu, 09 Jul 2020 13:42:11 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, willy@infradead.org
Subject:  [merged] hugetlb-fix-pages-per-hugetlb-calculation.patch
 removed from -mm tree
Message-ID: <20200709204211.XNvtwJpBJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix pages per hugetlb calculation
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-pages-per-hugetlb-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb.c: fix pages per hugetlb calculation

The routine hpage_nr_pages() was incorrectly used to calculate the number
of base pages in a hugetlb page.  hpage_nr_pages is designed to be called
for THP pages and will return HPAGE_PMD_NR for hugetlb pages of any size.

Due to the context in which hpage_nr_pages was called, it is unlikely to
produce a user visible error.  The routine with the incorrect call is only
exercised in the case of hugetlb memory error or migration.  In addition,
this would need to be on an architecture which supports huge page sizes
less than PMD_SIZE.  And, the vma containing the huge page would also need
to smaller than PMD_SIZE.

Link: http://lkml.kernel.org/r/20200629185003.97202-1-mike.kravetz@oracle.com
Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-fix-pages-per-hugetlb-calculation
+++ a/mm/hugetlb.c
@@ -1593,7 +1593,7 @@ static struct address_space *_get_hugetl
 
 	/* Use first found vma */
 	pgoff_start = page_to_pgoff(hpage);
-	pgoff_end = pgoff_start + hpage_nr_pages(hpage) - 1;
+	pgoff_end = pgoff_start + pages_per_huge_page(page_hstate(hpage)) - 1;
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 					pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch

