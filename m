Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C815E21C0B6
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 01:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgGJX1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 19:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgGJX1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 19:27:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D5E2065F;
        Fri, 10 Jul 2020 23:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594423667;
        bh=69/ojYUk/cJldJEB8/kl8ywu0XBTkXqwFytFXUEy6OQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mn5vpo6LUYfueQstrp4KnZ2CBA/v4960JZkaSA50y52doaVgO9xyTeq3VjVPPg7UN
         YWDKOkVdRMrHDtkFQzP+8mMw4R32WT7yi1K7rngLtqZPyye2vW+9ksol8XJ7SbYl9w
         8hzeGPRS0qQ5o7k5yHz0T2SxQPK6Z57+x632HbAI=
Date:   Fri, 10 Jul 2020 16:27:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, jonathan.cameron@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        song.bao.hua@hisilicon.com, stable@vger.kernel.org
Subject:  [to-be-updated]
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch removed
 from -mm tree
Message-ID: <20200710232746.Bcpk3eftO%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid hardcoding while checking if cma is enabled
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/hugetlb: avoid hardcoding while checking if cma is enabled

hugetlb_cma[0] can be NULL due to various reasons, for example, node0 has
no memory.  so NULL hugetlb_cma[0] doesn't necessarily mean cma is not
enabled.  gigantic pages might have been reserved on other nodes.

Mike Kravetz said:

: Based on the code changes, I believe the following could happen:
: - Someone uses 'hugetlb_cma=' kernel command line parameter to reserve
:   CMA for gigantic pages.
: - The system topology is such that no memory is on node 0.  Therefore,
:   no CMA can be reserved for gigantic pages on node 0.  CMA is reserved
:   on other nodes.
: - The user also specifies a number of gigantic pages to pre-allocate on
:   the command line with hugepagesz=<gigantic_page_size> hugepages=<N>
: - The routine which allocates gigantic pages from the bootmem allocator
:   will not detect CMA has been reserved as there is no memory on node 0.
:   Therefore, pages will be pre-allocated from bootmem allocator as well
:   as reserved in CMA.
: 
: This double allocation (bootmem and CMA) is the worst case scenario.  Not
: sure if this is what Barry saw, and I suspect this would rarely happen.

Link: http://lkml.kernel.org/r/20200707040204.30132-1-song.bao.hua@hisilicon.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable
+++ a/mm/hugetlb.c
@@ -2546,6 +2546,20 @@ static void __init gather_bootmem_preall
 	}
 }
 
+bool __init hugetlb_cma_enabled(void)
+{
+#ifdef CONFIG_CMA
+	int node;
+
+	for_each_online_node(node) {
+		if (hugetlb_cma[node])
+			return true;
+	}
+#endif
+
+	return false;
+}
+
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long i;
@@ -2571,7 +2585,7 @@ static void __init hugetlb_hstate_alloc_
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (hstate_is_gigantic(h)) {
-			if (IS_ENABLED(CONFIG_CMA) && hugetlb_cma[0]) {
+			if (hugetlb_cma_enabled()) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
 				break;
 			}
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-hugetlb-split-hugetlb_cma-in-nodes-with-memory.patch
mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled.patch

