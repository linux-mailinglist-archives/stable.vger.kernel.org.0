Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E1521A938
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 22:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgGIUmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 16:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 16:42:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8D82077D;
        Thu,  9 Jul 2020 20:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594327337;
        bh=k93r+rOT8oLEhLBc/TreRNvCilLm5FbGGDGvVZKXn9o=;
        h=Date:From:To:Subject:From;
        b=eUQzkn+OOAvDGtioaGZmXLbX5FvZ0TFblgE+mDlJATNyZ+R5DdYzkqNMaJu0eygdX
         CLzwOMiK8mHCQc8fDnudxZR5m6Abxi307lJCNvGp7SXwUE/Injp2lpktb8BFQYC+2S
         DiH75VPugPdnjBTQ7W98stBGk2xL+pkOL9XLSKiQ=
Date:   Thu, 09 Jul 2020 13:42:16 -0700
From:   akpm@linux-foundation.org
To:     andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com,
        Jonathan.Cameron@huawei.com, js1304@gmail.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        riel@surriel.com, robin.murphy@arm.com, song.bao.hua@hisilicon.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak.patch removed
 from -mm tree
Message-ID: <20200709204216.K7U2piRZh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/cma.c: use exact_nid true to fix possible per-numa cma leak
has been removed from the -mm tree.  Its filename was
     mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/cma.c: use exact_nid true to fix possible per-numa cma leak

Calling cma_declare_contiguous_nid() with false exact_nid for per-numa
reservation can easily cause cma leak and various confusion.  For example,
mm/hugetlb.c is trying to reserve per-numa cma for gigantic pages.  But it
can easily leak cma and make users confused when system has memoryless
nodes.

In case the system has 4 numa nodes, and only numa node0 has memory.  if
we set hugetlb_cma=4G in bootargs, mm/hugetlb.c will get 4 cma areas for 4
different numa nodes.  since exact_nid=false in current code, all 4 numa
nodes will get cma successfully from node0, but hugetlb_cma[1 to 3] will
never be available to hugepage will only allocate memory from
hugetlb_cma[0].

In case the system has 4 numa nodes, both numa node0&2 has memory, other
nodes have no memory.  if we set hugetlb_cma=4G in bootargs, mm/hugetlb.c
will get 4 cma areas for 4 different numa nodes.  since exact_nid=false in
current code, all 4 numa nodes will get cma successfully from node0 or 2,
but hugetlb_cma[1] and [3] will never be available to hugepage as
mm/hugetlb.c will only allocate memory from hugetlb_cma[0] and
hugetlb_cma[2].  This causes permanent leak of the cma areas which are
supposed to be used by memoryless node.

Of cource we can workaround the issue by letting mm/hugetlb.c scan all cma
areas in alloc_gigantic_page() even node_mask includes node0 only.  that
means when node_mask includes node0 only, we can get page from
hugetlb_cma[1] to hugetlb_cma[3].  But this will cause kernel crash in
free_gigantic_page() while it wants to free page by:
cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order)

On the other hand, exact_nid=false won't consider numa distance, it might
be not that useful to leverage cma areas on remote nodes.  I feel it is
much simpler to make exact_nid true to make everything clear.  After that,
memoryless nodes won't be able to reserve per-numa CMA from other nodes
which have memory.

Link: http://lkml.kernel.org/r/20200628074345.27228-1-song.bao.hua@hisilicon.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Aslan Bakirov <aslan@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andreas Schaufler <andreas.schaufler@gmx.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cmac-use-exact_nid-true-to-fix-possible-per-numa-cma-leak
+++ a/mm/cma.c
@@ -339,13 +339,13 @@ int __init cma_declare_contiguous_nid(ph
 		 */
 		if (base < highmem_start && limit > highmem_start) {
 			addr = memblock_alloc_range_nid(size, alignment,
-					highmem_start, limit, nid, false);
+					highmem_start, limit, nid, true);
 			limit = highmem_start;
 		}
 
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
-					limit, nid, false);
+					limit, nid, true);
 			if (!addr) {
 				ret = -ENOMEM;
 				goto err;
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enable.patch
mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch

