Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0F2336D7
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgG3Qci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:32:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38357 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Qch (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:32:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UGMvsZ090374;
        Thu, 30 Jul 2020 16:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=E1ucT1zc2XuteTwgQHD0kqKj6eDXbHg49Zk16afbYZQ=;
 b=D+CsCwZdlk9mXj4JZhDkq9bodnSEtaso9JXA6qYEAROCokzn/lv1lGVm7OSiFd4IFWCs
 QOyiLWwYBLJ+vcuQYLy/vHpB+7SPGJDccFu0KcY8sl/uu53pE1L4hOjimUlFhvKvtWaD
 j/+iJuMuJn6ZkArXXA74qd+REQyDWqa25U6eT8BV4bvRenMeWAClVEh/kmB24/FK2jpt
 g51C8Rx998SfIm0iCbv+rWdvQthLcgaLXKYKtKPQhZzVXxsVozZkph2s3yquiBPa/H/A
 c+SLnIIZsYxWy58XbWdDWvW/LWjjFOpOtVQZEs70XSx8bDsBpyNYVHlRkffNeQKL+Ejo nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32hu1jmrkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 16:31:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UGTRWo169610;
        Thu, 30 Jul 2020 16:31:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32hu5x0b4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 16:31:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06UGVqb6024197;
        Thu, 30 Jul 2020 16:31:52 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 09:31:45 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] cma: don't quit at first error when activating reserved areas
Date:   Thu, 30 Jul 2020 09:31:23 -0700
Message-Id: <20200730163123.6451-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=2 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300116
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
---
 mm/cma.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 26ecff818881..0963c0f9c502 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -93,17 +93,15 @@ static void cma_clear_bitmap(struct cma *cma, unsigned long pfn,
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
@@ -133,25 +131,22 @@ static int __init cma_activate_area(struct cma *cma)
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
-- 
2.25.4

