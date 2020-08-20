Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8BC24BD94
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgHTNIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgHTJiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95D9D207DE;
        Thu, 20 Aug 2020 09:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916280;
        bh=3rhEvQdtaZVkjicRvpomqlnahjTQxYkIgWBGzz3QM9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdrEckhWphq+cGowOWprNU5O1RpOqWGRV0KFz1loVAVxDyRXIvu3mGJll3iAf+xv4
         Rxhc7HaI+eIP7si5ThwIf/ezkArm1SDnQIt8djGf4s3dutVBkWBjX9FwSCd5vDy3pe
         fACHo0MUeu9WSX+ppC5sWgkemDmUjemDyF2MEzWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 074/204] cma: dont quit at first error when activating reserved areas
Date:   Thu, 20 Aug 2020 11:19:31 +0200
Message-Id: <20200820091610.049019725@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 3a5139f1c5bb76d69756fb8f13fffa173e261153 upstream.

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

Fixes: c64be2bb1c6e ("drivers: add Contiguous Memory Allocator")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200730163123.6451-1-mike.kravetz@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/cma.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/mm/cma.c
+++ b/mm/cma.c
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


