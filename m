Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0099122D244
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 01:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgGXXic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 19:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgGXXib (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 909FE206E3;
        Fri, 24 Jul 2020 23:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633910;
        bh=OULYzzB1oL/XkXavOdm88thtAEoWPQeJivBxEoa0JTc=;
        h=Date:From:To:Subject:From;
        b=18ZyziARtMu9wwMWTR0l5wgyFI8uuep7zOuFVZ2y8jJWhhJZJPwTKQaWvHwqiFV20
         Pwn3l0oaEvYKhh2X9QJ2B8+3tBBA58wuBE3uX3/s91LBrKIz5X4acszvHId/iRj08r
         QwQG/VelTPBWsvxVX/n27pWRYbvQDPHVI+YSr9vo=
Date:   Fri, 24 Jul 2020 16:38:30 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, jonathan.cameron@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch removed
 from -mm tree
Message-ID: <20200724233830.f18nkAdoS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid hardcoding while checking if cma is enabled
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch
mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch

