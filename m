Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3271148A0
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfLEV1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 16:27:39 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16001 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729587AbfLEV1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 16:27:39 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de976450000>; Thu, 05 Dec 2019 13:27:33 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 05 Dec 2019 13:27:37 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 05 Dec 2019 13:27:37 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec
 2019 21:27:37 +0000
Received: from [10.110.48.28] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Dec 2019
 21:27:37 +0000
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Yang Shi <yang.shi@linux.alibaba.com>, <fabecassis@nvidia.com>,
        <mhocko@suse.com>, <cl@linux.com>, <vbabka@suse.cz>,
        <mgorman@techsingularity.net>, <akpm@linux-foundation.org>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <d09644da-8a8c-bb89-c01b-75a4dbdfa719@nvidia.com>
Date:   Thu, 5 Dec 2019 13:27:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575581253; bh=xgBdbV+OEy9Ehl8QZe0kT/WnGrgj8wI1+wLBPxiYQZY=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BjYSV+TFuqmuxw14fEEV+DBTWtMMMlTcGmgWy68Y70m7xHdC72/OmeqK/DJQiq27a
         IySWBGo9mFllNbFLpJI+opE1cs9NSOvmDtconR6siuBl1qx9/Ol4nOGUeZTw5wqgHI
         JNIgJ3C0/tqkS/1EUTjl7u8KagsEcWfs8w+FeUECo/3vtUkXe0h3LEjUdSPOAhdLTi
         NtaBE0t4mrU012wKH0UIdOHsYBsl4Y+CHZx0ccsC9yD3T7agTBaANbbp2Aa4KzTQfw
         DuSGEz23X9noR5g5hLkSHuPlelGbNc1+TnZMuwrdxKlnz0/sapvwu2Vf3adt1cZ08B
         5yFpRHR5q5K2g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/19 10:54 AM, Yang Shi wrote:
> Felix Abecassis reports move_pages() would return random status if the
> pages are already on the target node by the below test program:
> 
> ---8<---
> 
> int main(void)
> {
> 	const long node_id = 1;
> 	const long page_size = sysconf(_SC_PAGESIZE);
> 	const int64_t num_pages = 8;
> 
> 	unsigned long nodemask =  1 << node_id;
> 	long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	void **pages = malloc(sizeof(void*) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
> 				MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
> 				-1, 0);
> 		if (pages[i] == MAP_FAILED)
> 			return (EXIT_FAILURE);
> 	}
> 
> 	ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	int *nodes = malloc(sizeof(int) * num_pages);
> 	int *status = malloc(sizeof(int) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		nodes[i] = node_id;
> 		status[i] = 0xd0; /* simulate garbage values */
> 	}
> 
> 	ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
> 	printf("move_pages: %ld\n", ret);
> 	for (int i = 0; i < num_pages; ++i)
> 		printf("status[%d] = %d\n", i, status[i]);
> }
> ---8<---
> 
> Then running the program would return nonsense status values:
> $ ./move_pages_bug
> move_pages: 0
> status[0] = 208
> status[1] = 208
> status[2] = 208
> status[3] = 208
> status[4] = 208
> status[5] = 208
> status[6] = 208
> status[7] = 208
> 
> This is because the status is not set if the page is already on the
> target node, but move_pages() should return valid status as long as it
> succeeds.  The valid status may be errno or node id.
> 
> We can't simply initialize status array to zero since the pages may be
> not on node 0.  Fix it by updating status with node id which the page is
> already on.
> 
> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Reported-by: Felix Abecassis <fabecassis@nvidia.com>
> Tested-by: Felix Abecassis <fabecassis@nvidia.com>
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: <stable@vger.kernel.org> 4.17+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> ---
> v3: * Adopted the suggestion from Michal.
> v2: * Correted the return value when add_page_for_migration() returns 1.
> 
>  mm/migrate.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a8f87cb..9c172f4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1512,9 +1512,11 @@ static int do_move_pages_to_node(struct mm_struct *mm,
>  /*
>   * Resolves the given address to a struct page, isolates it from the LRU and
>   * puts it to the given pagelist.
> - * Returns -errno if the page cannot be found/isolated or 0 when it has been
> - * queued or the page doesn't need to be migrated because it is already on
> - * the target node
> + * Returns:
> + *     errno - if the page cannot be found/isolated
> + *     0 - when it doesn't have to be migrated because it is already on the
> + *         target node
> + *     1 - when it has been queued
>   */
>  static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  		int node, struct list_head *pagelist, bool migrate_all)
> @@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  	if (PageHuge(page)) {
>  		if (PageHead(page)) {
>  			isolate_huge_page(page, pagelist);
> -			err = 0;
> +			err = 1;
>  		}
>  	} else {
>  		struct page *head;
> @@ -1563,7 +1565,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  		if (err)
>  			goto out_putpage;
>  
> -		err = 0;
> +		err = 1;
>  		list_add_tail(&head->lru, pagelist);
>  		mod_node_page_state(page_pgdat(head),
>  			NR_ISOLATED_ANON + page_is_file_cache(head),
> @@ -1578,6 +1580,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  	put_page(page);
>  out:
>  	up_read(&mm->mmap_sem);
> +
>  	return err;
>  }
>  
> @@ -1640,8 +1643,17 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  		 */
>  		err = add_page_for_migration(mm, addr, current_node,
>  				&pagelist, flags & MPOL_MF_MOVE_ALL);
> -		if (!err)
> +
> +		/* The page is already on the target node */
> +		if (!err) {
> +			err = store_status(status, i, current_node, 1);
> +			if (err)
> +				goto out_flush;
>  			continue;
> +		/* The page is successfully queued */

Nit: could you move this comment down one line, so that it's clear that it
applies to the "else" branch? Like this:

		} else if (err > 0) {
			/* The page is successfully queued for migration */
			continue;
		}


> +		} else if (err > 0) {
> +			continue;
> +		}
>  
>  		err = store_status(status, i, err, 1);
>  		if (err)
> 

Also agree with Christopher's requests, but all of these don't affect the
correct operation of the patch, so you can add:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard
NVIDIA
