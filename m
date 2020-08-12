Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DDE243050
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 23:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHLVCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 17:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FF7207F7;
        Wed, 12 Aug 2020 21:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266139;
        bh=91WhLQqXQB4/3dEqcVgcqRmOGGlZ5yB7vF2MFJ3jiaU=;
        h=Date:From:To:Subject:From;
        b=e45d7y0SNNgg+fXYy1le7YAZ2r0/Ldn4b3XYrEaFMo30exs/gRoO3fj3RPXkJQFx6
         K6TsU1VaUsWnsaGmVpaL8SBvATXU+RM3skMzo/S+Dq3oG6NXOMxu/+jFJrvSDHGliI
         xOhk0CXnLt2gR+tpwI4qwscIimLoiMiFJ1An3hts=
Date:   Wed, 12 Aug 2020 14:02:18 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, mike.kravetz@oracle.com,
        mina86@mina86.com, mm-commits@vger.kernel.org,
        song.bao.hua@hisilicon.com, stable@vger.kernel.org
Subject:  [merged]
 cma-dont-quit-at-first-error-when-activating-reserved-areas.patch removed
 from -mm tree
Message-ID: <20200812210218.Bei0iztuR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: cma: don't quit at first error when activating reserved areas
has been removed from the -mm tree.  Its filename was
     cma-dont-quit-at-first-error-when-activating-reserved-areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: cma: don't quit at first error when activating reserved areas

The routine cma_init_reserved_areas is designed to activate all
reserved cma areas.  It quits when it first encounters an error.
This can leave some areas in a state where they are reserved but
not activated.  There is no feedback to code which performed the
reservation.  Attempting to allocate memory from areas in such a
state will result in a BUG.

Modify cma_init_reserved_areas to always attempt to activate all
areas.  The called routine, cma_activate_area is responsible for
leaving the area in a valid state.  No one is making active use
of returned error codes, so change the routine to void.

How to reproduce:  This example uses kernelcore, hugetlb and cma
as an easy way to reproduce.  However, this is a more general cma
issue.

Two node x86 VM 16GB total, 8GB per node
Kernel command line parameters, kernelcore=4G hugetlb_cma=8G
Related boot time messages,
  hugetlb_cma: reserve 8192 MiB, up to 4096 MiB per node
  cma: Reserved 4096 MiB at 0x0000000100000000
  hugetlb_cma: reserved 4096 MiB on node 0
  cma: Reserved 4096 MiB at 0x0000000300000000
  hugetlb_cma: reserved 4096 MiB on node 1
  cma: CMA area hugetlb could not be activated

 # echo 8 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP PTI
  ...
  Call Trace:
    bitmap_find_next_zero_area_off+0x51/0x90
    cma_alloc+0x1a5/0x310
    alloc_fresh_huge_page+0x78/0x1a0
    alloc_pool_huge_page+0x6f/0xf0
    set_max_huge_pages+0x10c/0x250
    nr_hugepages_store_common+0x92/0x120
    ? __kmalloc+0x171/0x270
    kernfs_fop_write+0xc1/0x1a0
    vfs_write+0xc7/0x1f0
    ksys_write+0x5f/0xe0
    do_syscall_64+0x4d/0x90
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Link: http://lkml.kernel.org/r/20200730163123.6451-1-mike.kravetz@oracle.com
Fixes: c64be2bb1c6e ("drivers: add Contiguous Memory Allocator")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/mm/cma.c~cma-dont-quit-at-first-error-when-activating-reserved-areas
+++ a/mm/cma.c
@@ -93,17 +93,15 @@ static void cma_clear_bitmap(struct cma
 	mutex_unlock(&cma->lock);
 }
 
-static int __init cma_activate_area(struct cma *cma)
+static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
 	unsigned i = cma->count >> pageblock_order;
 	struct zone *zone;
 
 	cma->bitmap = bitmap_zalloc(cma_bitmap_maxno(cma), GFP_KERNEL);
-	if (!cma->bitmap) {
-		cma->count = 0;
-		return -ENOMEM;
-	}
+	if (!cma->bitmap)
+		goto out_error;
 
 	WARN_ON_ONCE(!pfn_valid(pfn));
 	zone = page_zone(pfn_to_page(pfn));
@@ -133,25 +131,22 @@ static int __init cma_activate_area(stru
 	spin_lock_init(&cma->mem_head_lock);
 #endif
 
-	return 0;
+	return;
 
 not_in_zone:
-	pr_err("CMA area %s could not be activated\n", cma->name);
 	bitmap_free(cma->bitmap);
+out_error:
 	cma->count = 0;
-	return -EINVAL;
+	pr_err("CMA area %s could not be activated\n", cma->name);
+	return;
 }
 
 static int __init cma_init_reserved_areas(void)
 {
 	int i;
 
-	for (i = 0; i < cma_area_count; i++) {
-		int ret = cma_activate_area(&cma_areas[i]);
-
-		if (ret)
-			return ret;
-	}
+	for (i = 0; i < cma_area_count; i++)
+		cma_activate_area(&cma_areas[i]);
 
 	return 0;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


