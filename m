Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF671148FB
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 23:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbfLEWAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 17:00:40 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:12080 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387396AbfLEWAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 17:00:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07486;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Tk4-tJ8_1575583231;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tk4-tJ8_1575583231)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Dec 2019 06:00:35 +0800
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     John Hubbard <jhubbard@nvidia.com>, fabecassis@nvidia.com,
        mhocko@suse.com, cl@linux.com, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
 <d09644da-8a8c-bb89-c01b-75a4dbdfa719@nvidia.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <93b8f639-baff-b198-84b5-713df9406a51@linux.alibaba.com>
Date:   Thu, 5 Dec 2019 14:00:31 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <d09644da-8a8c-bb89-c01b-75a4dbdfa719@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/5/19 1:27 PM, John Hubbard wrote:
> On 12/5/19 10:54 AM, Yang Shi wrote:
>> Felix Abecassis reports move_pages() would return random status if the
>> pages are already on the target node by the below test program:
>>
>> ---8<---
>>
>> int main(void)
>> {
>> 	const long node_id = 1;
>> 	const long page_size = sysconf(_SC_PAGESIZE);
>> 	const int64_t num_pages = 8;
>>
>> 	unsigned long nodemask =  1 << node_id;
>> 	long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
>> 	if (ret < 0)
>> 		return (EXIT_FAILURE);
>>
>> 	void **pages = malloc(sizeof(void*) * num_pages);
>> 	for (int i = 0; i < num_pages; ++i) {
>> 		pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
>> 				MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
>> 				-1, 0);
>> 		if (pages[i] == MAP_FAILED)
>> 			return (EXIT_FAILURE);
>> 	}
>>
>> 	ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
>> 	if (ret < 0)
>> 		return (EXIT_FAILURE);
>>
>> 	int *nodes = malloc(sizeof(int) * num_pages);
>> 	int *status = malloc(sizeof(int) * num_pages);
>> 	for (int i = 0; i < num_pages; ++i) {
>> 		nodes[i] = node_id;
>> 		status[i] = 0xd0; /* simulate garbage values */
>> 	}
>>
>> 	ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
>> 	printf("move_pages: %ld\n", ret);
>> 	for (int i = 0; i < num_pages; ++i)
>> 		printf("status[%d] = %d\n", i, status[i]);
>> }
>> ---8<---
>>
>> Then running the program would return nonsense status values:
>> $ ./move_pages_bug
>> move_pages: 0
>> status[0] = 208
>> status[1] = 208
>> status[2] = 208
>> status[3] = 208
>> status[4] = 208
>> status[5] = 208
>> status[6] = 208
>> status[7] = 208
>>
>> This is because the status is not set if the page is already on the
>> target node, but move_pages() should return valid status as long as it
>> succeeds.  The valid status may be errno or node id.
>>
>> We can't simply initialize status array to zero since the pages may be
>> not on node 0.  Fix it by updating status with node id which the page is
>> already on.
>>
>> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>> Reported-by: Felix Abecassis <fabecassis@nvidia.com>
>> Tested-by: Felix Abecassis <fabecassis@nvidia.com>
>> Suggested-by: Michal Hocko <mhocko@suse.com>
>> Cc: John Hubbard <jhubbard@nvidia.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: <stable@vger.kernel.org> 4.17+
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> ---
>> v3: * Adopted the suggestion from Michal.
>> v2: * Correted the return value when add_page_for_migration() returns 1.
>>
>>   mm/migrate.c | 24 ++++++++++++++++++------
>>   1 file changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index a8f87cb..9c172f4 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1512,9 +1512,11 @@ static int do_move_pages_to_node(struct mm_struct *mm,
>>   /*
>>    * Resolves the given address to a struct page, isolates it from the LRU and
>>    * puts it to the given pagelist.
>> - * Returns -errno if the page cannot be found/isolated or 0 when it has been
>> - * queued or the page doesn't need to be migrated because it is already on
>> - * the target node
>> + * Returns:
>> + *     errno - if the page cannot be found/isolated
>> + *     0 - when it doesn't have to be migrated because it is already on the
>> + *         target node
>> + *     1 - when it has been queued
>>    */
>>   static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>>   		int node, struct list_head *pagelist, bool migrate_all)
>> @@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>>   	if (PageHuge(page)) {
>>   		if (PageHead(page)) {
>>   			isolate_huge_page(page, pagelist);
>> -			err = 0;
>> +			err = 1;
>>   		}
>>   	} else {
>>   		struct page *head;
>> @@ -1563,7 +1565,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>>   		if (err)
>>   			goto out_putpage;
>>   
>> -		err = 0;
>> +		err = 1;
>>   		list_add_tail(&head->lru, pagelist);
>>   		mod_node_page_state(page_pgdat(head),
>>   			NR_ISOLATED_ANON + page_is_file_cache(head),
>> @@ -1578,6 +1580,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>>   	put_page(page);
>>   out:
>>   	up_read(&mm->mmap_sem);
>> +
>>   	return err;
>>   }
>>   
>> @@ -1640,8 +1643,17 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>>   		 */
>>   		err = add_page_for_migration(mm, addr, current_node,
>>   				&pagelist, flags & MPOL_MF_MOVE_ALL);
>> -		if (!err)
>> +
>> +		/* The page is already on the target node */
>> +		if (!err) {
>> +			err = store_status(status, i, current_node, 1);
>> +			if (err)
>> +				goto out_flush;
>>   			continue;
>> +		/* The page is successfully queued */
> Nit: could you move this comment down one line, so that it's clear that it
> applies to the "else" branch? Like this:
>
> 		} else if (err > 0) {
> 			/* The page is successfully queued for migration */
> 			continue;
> 		}

Sure.

>
>
>> +		} else if (err > 0) {
>> +			continue;
>> +		}
>>   
>>   		err = store_status(status, i, err, 1);
>>   		if (err)
>>
> Also agree with Christopher's requests, but all of these don't affect the
> correct operation of the patch, so you can add:
>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
>
> thanks,

