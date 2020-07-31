Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAEA233CCF
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 03:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgGaBPR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 Jul 2020 21:15:17 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:39684 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728080AbgGaBPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 21:15:17 -0400
Received: from dggemi405-hub.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 6182BBEC6774B1DB2CF6;
        Fri, 31 Jul 2020 08:51:26 +0800 (CST)
Received: from DGGEMI525-MBS.china.huawei.com ([169.254.6.120]) by
 dggemi405-hub.china.huawei.com ([10.3.17.143]) with mapi id 14.03.0487.000;
 Fri, 31 Jul 2020 08:51:24 +0800
From:   "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Roman Gushchin" <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] cma: don't quit at first error when activating reserved
 areas
Thread-Topic: [PATCH] cma: don't quit at first error when activating
 reserved areas
Thread-Index: AQHWZo8CMi6/QpZbIkKrpG3q5y96kKkg21Tw
Date:   Fri, 31 Jul 2020 00:51:23 +0000
Message-ID: <B926444035E5E2439431908E3842AFD25CE8C2@DGGEMI525-MBS.china.huawei.com>
References: <20200730163123.6451-1-mike.kravetz@oracle.com>
In-Reply-To: <20200730163123.6451-1-mike.kravetz@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.201.208]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Mike Kravetz [mailto:mike.kravetz@oracle.com]
> Sent: Friday, July 31, 2020 4:31 AM
> To: linux-mm@kvack.org; linux-kernel@vger.kernel.org
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>; Michal Nazarewicz
> <mina86@mina86.com>; Kyungmin Park <kyungmin.park@samsung.com>;
> Song Bao Hua (Barry Song) <song.bao.hua@hisilicon.com>; Roman Gushchin
> <guro@fb.com>; Andrew Morton <akpm@linux-foundation.org>; Mike Kravetz
> <mike.kravetz@oracle.com>; stable@vger.kernel.org
> Subject: [PATCH] cma: don't quit at first error when activating reserved areas
> 
> The routine cma_init_reserved_areas is designed to activate all reserved cma
> areas.  It quits when it first encounters an error.
> This can leave some areas in a state where they are reserved but not activated.
> There is no feedback to code which performed the reservation.  Attempting to
> allocate memory from areas in such a state will result in a BUG.
> 
> Modify cma_init_reserved_areas to always attempt to activate all areas.  The
> called routine, cma_activate_area is responsible for leaving the area in a valid
> state.  No one is making active use of returned error codes, so change the
> routine to void.
> 
> How to reproduce:  This example uses kernelcore, hugetlb and cma as an easy
> way to reproduce.  However, this is a more general cma issue.
> 
> Two node x86 VM 16GB total, 8GB per node Kernel command line parameters,
> kernelcore=4G hugetlb_cma=8G Related boot time messages,
>   hugetlb_cma: reserve 8192 MiB, up to 4096 MiB per node
>   cma: Reserved 4096 MiB at 0x0000000100000000
>   hugetlb_cma: reserved 4096 MiB on node 0
>   cma: Reserved 4096 MiB at 0x0000000300000000
>   hugetlb_cma: reserved 4096 MiB on node 1
>   cma: CMA area hugetlb could not be activated
> 
>  # echo 8 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] SMP PTI
>   ...
>   Call Trace:
>     bitmap_find_next_zero_area_off+0x51/0x90
>     cma_alloc+0x1a5/0x310
>     alloc_fresh_huge_page+0x78/0x1a0
>     alloc_pool_huge_page+0x6f/0xf0
>     set_max_huge_pages+0x10c/0x250
>     nr_hugepages_store_common+0x92/0x120
>     ? __kmalloc+0x171/0x270
>     kernfs_fop_write+0xc1/0x1a0
>     vfs_write+0xc7/0x1f0
>     ksys_write+0x5f/0xe0
>     do_syscall_64+0x4d/0x90
>     entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: c64be2bb1c6e ("drivers: add Contiguous Memory Allocator")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Barry Song <song.bao.hua@hisilicon.com>

> ---
>  mm/cma.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 26ecff818881..0963c0f9c502 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -93,17 +93,15 @@ static void cma_clear_bitmap(struct cma *cma,
> unsigned long pfn,
>  	mutex_unlock(&cma->lock);
>  }
> 
> -static int __init cma_activate_area(struct cma *cma)
> +static void __init cma_activate_area(struct cma *cma)
>  {
>  	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
>  	unsigned i = cma->count >> pageblock_order;
>  	struct zone *zone;
> 
>  	cma->bitmap = bitmap_zalloc(cma_bitmap_maxno(cma), GFP_KERNEL);
> -	if (!cma->bitmap) {
> -		cma->count = 0;
> -		return -ENOMEM;
> -	}
> +	if (!cma->bitmap)
> +		goto out_error;
> 
>  	WARN_ON_ONCE(!pfn_valid(pfn));
>  	zone = page_zone(pfn_to_page(pfn));
> @@ -133,25 +131,22 @@ static int __init cma_activate_area(struct cma
> *cma)
>  	spin_lock_init(&cma->mem_head_lock);
>  #endif
> 
> -	return 0;
> +	return;
> 
>  not_in_zone:
> -	pr_err("CMA area %s could not be activated\n", cma->name);
>  	bitmap_free(cma->bitmap);
> +out_error:
>  	cma->count = 0;
> -	return -EINVAL;
> +	pr_err("CMA area %s could not be activated\n", cma->name);
> +	return;
>  }
> 
>  static int __init cma_init_reserved_areas(void)  {
>  	int i;
> 
> -	for (i = 0; i < cma_area_count; i++) {
> -		int ret = cma_activate_area(&cma_areas[i]);
> -
> -		if (ret)
> -			return ret;
> -	}
> +	for (i = 0; i < cma_area_count; i++)
> +		cma_activate_area(&cma_areas[i]);
> 
>  	return 0;
>  }
> --
> 2.25.4

