Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB3214170
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 00:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgGCWPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 18:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgGCWPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 18:15:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875A020826;
        Fri,  3 Jul 2020 22:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593814518;
        bh=+nfGdZt1LLgrYX1ftLbDO2yiAuB4uCbDFhz//zXbqHI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vbUFwl5CuOfBiWLrovR9Yz68sp/SpAcg25OIFaZqluREOWBI7p42zhl/Yyad+5g32
         LwZLy7YuiAaARbR4pLO7x1ZkIJwRqHg9TMPfMCQKMi1GAlReWYnSLzPT6H1SP2HdEn
         8ChmVRkGJTnuQpQdrJBxjIk9TKMu9nlgKvf6WVgE=
Date:   Fri, 03 Jul 2020 15:15:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 1/5] mm/hugetlb.c: fix pages per hugetlb
 calculation
Message-ID: <20200703221518.lcjqvNHG1%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
