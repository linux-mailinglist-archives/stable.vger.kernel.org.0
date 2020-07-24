Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B822BCCA
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 06:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgGXEPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 00:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgGXEPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FF75206F6;
        Fri, 24 Jul 2020 04:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564131;
        bh=mtw2EEoiuHpwYHfIRBouMullb8c/OCREGNuvAPFOicU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0PJseAylspNtz1fSYQ/RDQtJEEdianmMahOa/ylAxb++VzC+k8w72tihdSU4KJ3GT
         q9ooMlKFhZ0kBzc9Ggc66fHUntRULp5ukol3prmlaH/pGaAW7LAAM+0g5QCG3aWNUC
         9Tz89tL+pENSSF7f16aAfenJidMWjmCKpdEjrOww=
Date:   Thu, 23 Jul 2020 21:15:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com,
        jonathan.cameron@huawei.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        song.bao.hua@hisilicon.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/15] mm/hugetlb: avoid hardcoding while checking
 if cma is enabled
Message-ID: <20200724041530.pF__Ua2kE%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/hugetlb: avoid hardcoding while checking if cma is enabled

hugetlb_cma[0] can be NULL due to various reasons, for example, node0 has
no memory.  so NULL hugetlb_cma[0] doesn't necessarily mean cma is not
enabled.  gigantic pages might have been reserved on other nodes.  This
patch fixes possible double reservation and CMA leak.

[akpm@linux-foundation.org: fix CONFIG_CMA=n warning]
[sfr@canb.auug.org.au: better checks before using hugetlb_cma]
  Link: http://lkml.kernel.org/r/20200721205716.6dbaa56b@canb.auug.org.au
Link: http://lkml.kernel.org/r/20200710005726.36068-1-song.bao.hua@hisilicon.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled
+++ a/mm/hugetlb.c
@@ -45,7 +45,10 @@ int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
+#ifdef CONFIG_CMA
 static struct cma *hugetlb_cma[MAX_NUMNODES];
+#endif
+static unsigned long hugetlb_cma_size __initdata;
 
 /*
  * Minimum page order among possible hugepage sizes, set to a proper value
@@ -1235,9 +1238,10 @@ static void free_gigantic_page(struct pa
 	 * If the page isn't allocated using the cma allocator,
 	 * cma_release() returns false.
 	 */
-	if (IS_ENABLED(CONFIG_CMA) &&
-	    cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
+#ifdef CONFIG_CMA
+	if (cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
 		return;
+#endif
 
 	free_contig_range(page_to_pfn(page), 1 << order);
 }
@@ -1248,7 +1252,8 @@ static struct page *alloc_gigantic_page(
 {
 	unsigned long nr_pages = 1UL << huge_page_order(h);
 
-	if (IS_ENABLED(CONFIG_CMA)) {
+#ifdef CONFIG_CMA
+	{
 		struct page *page;
 		int node;
 
@@ -1262,6 +1267,7 @@ static struct page *alloc_gigantic_page(
 				return page;
 		}
 	}
+#endif
 
 	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
 }
@@ -2571,7 +2577,7 @@ static void __init hugetlb_hstate_alloc_
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (hstate_is_gigantic(h)) {
-			if (IS_ENABLED(CONFIG_CMA) && hugetlb_cma[0]) {
+			if (hugetlb_cma_size) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
 				break;
 			}
@@ -5654,7 +5660,6 @@ void move_hugetlb_state(struct page *old
 }
 
 #ifdef CONFIG_CMA
-static unsigned long hugetlb_cma_size __initdata;
 static bool cma_reserve_called __initdata;
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
_
