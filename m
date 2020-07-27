Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D7822F0CB
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbgG0OZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732467AbgG0OZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:25:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 013BA2177B;
        Mon, 27 Jul 2020 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859936;
        bh=ggkb6GNnAaJi1PDawlhwRfvMEN7RJxZwWjUYOHVfT6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3tEhvI1/riuJb/Co9smKlmg0cwUB+5cq1/QJor1AxLwNTuaUs3WyDKOdjzyuPlgn
         Ypa+usFCWBNmwnfBce4V+9393KgMEFN4PNX4jMkiBFLfjv9Du9ruTj+0+c14Q4/ZkE
         eyB0uex4AzCg6O2JGyHaGUqQv8shAzcf5kVN4rVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Barry Song <song.bao.hua@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Roman Gushchin <guro@fb.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 163/179] mm/hugetlb: avoid hardcoding while checking if cma is enabled
Date:   Mon, 27 Jul 2020 16:05:38 +0200
Message-Id: <20200727134940.606780792@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>

commit dbda8feadfa46b3d8dd7a2304f84ccbc036effe9 upstream.

hugetlb_cma[0] can be NULL due to various reasons, for example, node0
has no memory.  so NULL hugetlb_cma[0] doesn't necessarily mean cma is
not enabled.  gigantic pages might have been reserved on other nodes.
This patch fixes possible double reservation and CMA leak.

[akpm@linux-foundation.org: fix CONFIG_CMA=n warning]
[sfr@canb.auug.org.au: better checks before using hugetlb_cma]
  Link: http://lkml.kernel.org/r/20200721205716.6dbaa56b@canb.auug.org.au

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200710005726.36068-1-song.bao.hua@hisilicon.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -46,7 +46,10 @@ int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
+#ifdef CONFIG_CMA
 static struct cma *hugetlb_cma[MAX_NUMNODES];
+#endif
+static unsigned long hugetlb_cma_size __initdata;
 
 /*
  * Minimum page order among possible hugepage sizes, set to a proper value
@@ -1236,9 +1239,10 @@ static void free_gigantic_page(struct pa
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
@@ -1249,7 +1253,8 @@ static struct page *alloc_gigantic_page(
 {
 	unsigned long nr_pages = 1UL << huge_page_order(h);
 
-	if (IS_ENABLED(CONFIG_CMA)) {
+#ifdef CONFIG_CMA
+	{
 		struct page *page;
 		int node;
 
@@ -1263,6 +1268,7 @@ static struct page *alloc_gigantic_page(
 				return page;
 		}
 	}
+#endif
 
 	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
 }
@@ -2572,7 +2578,7 @@ static void __init hugetlb_hstate_alloc_
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (hstate_is_gigantic(h)) {
-			if (IS_ENABLED(CONFIG_CMA) && hugetlb_cma[0]) {
+			if (hugetlb_cma_size) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
 				break;
 			}
@@ -5548,7 +5554,6 @@ void move_hugetlb_state(struct page *old
 }
 
 #ifdef CONFIG_CMA
-static unsigned long hugetlb_cma_size __initdata;
 static bool cma_reserve_called __initdata;
 
 static int __init cmdline_parse_hugetlb_cma(char *p)


