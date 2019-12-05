Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80651145B9
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 18:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfLERUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 12:20:24 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55676 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729430AbfLERUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 12:20:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Tk3V.AY_1575566412;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tk3V.AY_1575566412)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Dec 2019 01:20:15 +0800
Subject: Re: [v2 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     John Hubbard <jhubbard@nvidia.com>, fabecassis@nvidia.com,
        mhocko@suse.com, cl@linux.com, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1575519678-86510-1-git-send-email-yang.shi@linux.alibaba.com>
 <d4935b9f-39ef-fb91-1786-be84784dccd0@nvidia.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <45c6de9c-fa4b-c060-045a-1c7dde3fac36@linux.alibaba.com>
Date:   Thu, 5 Dec 2019 09:20:10 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <d4935b9f-39ef-fb91-1786-be84784dccd0@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/4/19 9:44 PM, John Hubbard wrote:
> On 12/4/19 8:21 PM, Yang Shi wrote:
>> Felix Abecassis reports move_pages() would return random status if the
>> pages are already on the target node by the below test program:
>>
>> ---8<---
>
> This is correct correct code, so:
>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
>
> ...with a few nitpicky notes about comments, below, that might help:

Thanks, John. Will take in new version.

>
>>
>> int main(void)
>> {
>>     const long node_id = 1;
>>     const long page_size = sysconf(_SC_PAGESIZE);
>>     const int64_t num_pages = 8;
>>
>>     unsigned long nodemask =  1 << node_id;
>>     long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
>>     if (ret < 0)
>>         return (EXIT_FAILURE);
>>
>>     void **pages = malloc(sizeof(void*) * num_pages);
>>     for (int i = 0; i < num_pages; ++i) {
>>         pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
>>                 MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
>>                 -1, 0);
>>         if (pages[i] == MAP_FAILED)
>>             return (EXIT_FAILURE);
>>     }
>>
>>     ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
>>     if (ret < 0)
>>         return (EXIT_FAILURE);
>>
>>     int *nodes = malloc(sizeof(int) * num_pages);
>>     int *status = malloc(sizeof(int) * num_pages);
>>     for (int i = 0; i < num_pages; ++i) {
>>         nodes[i] = node_id;
>>         status[i] = 0xd0; /* simulate garbage values */
>>     }
>>
>>     ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
>>     printf("move_pages: %ld\n", ret);
>>     for (int i = 0; i < num_pages; ++i)
>>         printf("status[%d] = %d\n", i, status[i]);
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
>> succeeds.  The valid status may be errno or node id.
>>
>> We can't simply initialize status array to zero since the pages may be
>> not on node 0.  Fix it by updating status with node id which the page is
>> already on.  And, it looks we have to update the status inside
>> add_page_for_migration() since the page struct is not available outside
>> it.
>>
>> Make add_page_for_migration() return 1 if store_status() is failed in
>> order to not mix up the status value since -EFAULT is also a valid
>> status.
>>
>> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>> Reported-by: Felix Abecassis <fabecassis@nvidia.com>
>> Tested-by: Felix Abecassis <fabecassis@nvidia.com>
>> Cc: John Hubbard <jhubbard@nvidia.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: <stable@vger.kernel.org> 4.17+
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> ---
>> v2: *Correted the return value when add_page_for_migration() returns 1.
>>
>> John noticed another return value inconsistency between the 
>> implementation and
>> the manpage.  The manpage says it should return -ENOENT if the page 
>> is already
>> on the target node, but it doesn't.  It looks the original code 
>> didn't return
>> -ENOENT either, I'm not sure if this is a document issue or not.  
>> Anyway this
>> is another issue, once we confirm it we can fix it later.
>>
>>   mm/migrate.c | 36 ++++++++++++++++++++++++++++++------
>>   1 file changed, 30 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index a8f87cb..f1090a0 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -1512,17 +1512,21 @@ static int do_move_pages_to_node(struct 
>> mm_struct *mm,
>>   /*
>>    * Resolves the given address to a struct page, isolates it from 
>> the LRU and
>>    * puts it to the given pagelist.
>> - * Returns -errno if the page cannot be found/isolated or 0 when it 
>> has been
>> - * queued or the page doesn't need to be migrated because it is 
>> already on
>> - * the target node
>> + * Returns:
>> + *     errno - if the page cannot be found/isolated
>> + *     0 - when it has been queued or the page doesn't need to be 
>> migrated
>> + *         because it is already on the target node
>> + *     1 - if store_status() is failed
>
>
> I recommend this wording instead:
>
>  * Returns:
>  *     errno - if the page cannot be found/isolated
>  *     0 - when it has been queued or the page doesn't need to be 
> migrated
>  *         because it is already on the target node
>  *     1 - The page doesn't need to be migrated because it is already 
> on the
>  *         target node. However, attempting to store the node ID in 
> the status
>  *         array failed. Unlike other failures in this function, this 
> case
>  *         needs to turn into a fatal failure in the calling function.
>
>
>>    */
>>   static int add_page_for_migration(struct mm_struct *mm, unsigned 
>> long addr,
>> -        int node, struct list_head *pagelist, bool migrate_all)
>> +        int node, struct list_head *pagelist, bool migrate_all,
>> +        int __user *status, int start)
>>   {
>>       struct vm_area_struct *vma;
>>       struct page *page;
>>       unsigned int follflags;
>>       int err;
>> +    bool same_node = false;
>>         down_read(&mm->mmap_sem);
>>       err = -EFAULT;
>> @@ -1543,8 +1547,10 @@ static int add_page_for_migration(struct 
>> mm_struct *mm, unsigned long addr,
>>           goto out;
>>         err = 0;
>> -    if (page_to_nid(page) == node)
>> +    if (page_to_nid(page) == node) {
>> +        same_node = true;
>>           goto out_putpage;
>> +    }
>>         err = -EACCES;
>>       if (page_mapcount(page) > 1 && !migrate_all)
>> @@ -1578,6 +1584,16 @@ static int add_page_for_migration(struct 
>> mm_struct *mm, unsigned long addr,
>>       put_page(page);
>>   out:
>>       up_read(&mm->mmap_sem);
>> +
>> +    /*
>> +     * Must call store_status() after releasing mmap_sem since put_user
>> +     * need acquire mmap_sem too, otherwise potential deadlock may 
>> exist.
>> +     */
>> +    if (same_node) {
>> +        if (store_status(status, start, node, 1))
>> +            err = 1;
>> +    }
>> +
>>       return err;
>>   }
>>   @@ -1639,10 +1655,18 @@ static int do_pages_move(struct mm_struct 
>> *mm, nodemask_t task_nodes,
>>            * report them via status
>>            */
>
> Let's change the comment above add_page_for_migration(), to read:
>
>         /*
>          * Most errors in the page lookup or isolation are not fatal
>          * and we simply report them via the status array. However,
>          * positive error values are fatal.
>          */
>
>
>>           err = add_page_for_migration(mm, addr, current_node,
>> -                &pagelist, flags & MPOL_MF_MOVE_ALL);
>> +                &pagelist, flags & MPOL_MF_MOVE_ALL, status,
>> +                i);
>> +
>>           if (!err)
>>               continue;
>>   +        /* store_status() failed in add_page_for_migration() */
>
> ...and let's replace the above line, with the following:
>
>         /*
>          * Most errors in the page lookup or isolation are not fatal
>          * and we simply report them via the status array. However,
>          * positive error values are fatal.
>          */
>
>
>> +        if (err > 0) {
>> +            err = -EFAULT;
>> +            goto out_flush;
>> +        }
>> +
>>           err = store_status(status, i, err, 1);
>>           if (err)
>>               goto out_flush;
>>
>
> And with that, I think the comments help a little bit more, in reading
> through the code.
>
>
> thanks,

