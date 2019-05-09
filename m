Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E871901E
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfEISWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:22:47 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54627 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfEISWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 14:22:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07486;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0TRHI4lD_1557426158;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TRHI4lD_1557426158)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 May 2019 02:22:41 +0800
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
To:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>
Cc:     jstancek@redhat.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
        npiggin@gmail.com, namit@vmware.com, minchan@kernel.org,
        Mel Gorman <mgorman@suse.de>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <df1247c3-a5dc-e4aa-cf0f-674f74f31d1f@linux.alibaba.com>
Date:   Thu, 9 May 2019 11:22:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190509103813.GP2589@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/9/19 3:38 AM, Peter Zijlstra wrote:
> On Thu, May 09, 2019 at 09:37:26AM +0100, Will Deacon wrote:
>> Hi all, [+Peter]
> Right, mm/mmu_gather.c has a MAINTAINERS entry; use it.

Sorry for that, I didn't realize we have mmu_gather maintainers. I 
should run maintainer.pl.

>
> Also added Nadav and Minchan who've poked at this issue before. And Mel,
> because he loves these things :-)
>
>> Apologies for the delay; I'm attending a conference this week so it's tricky
>> to keep up with email.
>>
>> On Wed, May 08, 2019 at 05:34:49AM +0800, Yang Shi wrote:
>>> A few new fields were added to mmu_gather to make TLB flush smarter for
>>> huge page by telling what level of page table is changed.
>>>
>>> __tlb_reset_range() is used to reset all these page table state to
>>> unchanged, which is called by TLB flush for parallel mapping changes for
>>> the same range under non-exclusive lock (i.e. read mmap_sem).  Before
>>> commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
>>> munmap"), MADV_DONTNEED is the only one who may do page zapping in
>>> parallel and it doesn't remove page tables.  But, the forementioned commit
>>> may do munmap() under read mmap_sem and free page tables.  This causes a
>>> bug [1] reported by Jan Stancek since __tlb_reset_range() may pass the
> Please don't _EVER_ refer to external sources to describe the actual bug
> a patch is fixing. That is the primary purpose of the Changelog.
>
> Worse, the email you reference does _NOT_ describe the actual problem.
> Nor do you.

Sure, will articulate the real bug in the commit log.

>
>>> wrong page table state to architecture specific TLB flush operations.
>> Yikes. Is it actually safe to run free_pgtables() concurrently for a given
>> mm?
> Yeah.. sorta.. it's been a source of 'interesting' things. This really
> isn't the first issue here.
>
> Also, change_protection_range() is 'fun' too.
>
>>> So, removing __tlb_reset_range() sounds sane.  This may cause more TLB
>>> flush for MADV_DONTNEED, but it should be not called very often, hence
>>> the impact should be negligible.
>>>
>>> The original proposed fix came from Jan Stancek who mainly debugged this
>>> issue, I just wrapped up everything together.
>> I'm still paging the nested flush logic back in, but I have some comments on
>> the patch below.
>>
>>> [1] https://lore.kernel.org/linux-mm/342bf1fd-f1bf-ed62-1127-e911b5032274@linux.alibaba.com/T/#m7a2ab6c878d5a256560650e56189cfae4e73217f
>>>
>>> Reported-by: Jan Stancek <jstancek@redhat.com>
>>> Tested-by: Jan Stancek <jstancek@redhat.com>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>>> Signed-off-by: Jan Stancek <jstancek@redhat.com>
>>> ---
>>>   mm/mmu_gather.c | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>>> index 99740e1..9fd5272 100644
>>> --- a/mm/mmu_gather.c
>>> +++ b/mm/mmu_gather.c
>>> @@ -249,11 +249,12 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>>>   	 * flush by batching, a thread has stable TLB entry can fail to flush
>> Urgh, we should rewrite this comment while we're here so that it makes sense...
> Yeah, that's atrocious. We should put the actual race in there.
>
>>>   	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
>>>   	 * forcefully if we detect parallel PTE batching threads.
>>> +	 *
>>> +	 * munmap() may change mapping under non-excluse lock and also free
>>> +	 * page tables.  Do not call __tlb_reset_range() for it.
>>>   	 */
>>> -	if (mm_tlb_flush_nested(tlb->mm)) {
>>> -		__tlb_reset_range(tlb);
>>> +	if (mm_tlb_flush_nested(tlb->mm))
>>>   		__tlb_adjust_range(tlb, start, end - start);
>>> -	}
>> I don't think we can elide the call __tlb_reset_range() entirely, since I
>> think we do want to clear the freed_pXX bits to ensure that we walk the
>> range with the smallest mapping granule that we have. Otherwise couldn't we
>> have a problem if we hit a PMD that had been cleared, but the TLB
>> invalidation for the PTEs that used to be linked below it was still pending?
> That's tlb->cleared_p*, and yes agreed. That is, right until some
> architecture has level dependent TLBI instructions, at which point we'll
> need to have them all set instead of cleared.
>
>> Perhaps we should just set fullmm if we see that here's a concurrent
>> unmapper rather than do a worst-case range invalidation. Do you have a feeling
>> for often the mm_tlb_flush_nested() triggers in practice?
> Quite a bit for certain workloads I imagine, that was the whole point of
> doing it.
>
> Anyway; am I correct in understanding that the actual problem is that
> we've cleared freed_tables and the ARM64 tlb_flush() will then not
> invalidate the cache and badness happens?

Yes.

>
> Because so far nobody has actually provided a coherent description of
> the actual problem we're trying to solve. But I'm thinking something
> like the below ought to do.

Thanks for the suggestion, will do in v2.

>
>
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 99740e1dd273..fe768f8d612e 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -244,15 +244,20 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>   		unsigned long start, unsigned long end)
>   {
>   	/*
> -	 * If there are parallel threads are doing PTE changes on same range
> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> -	 * flush by batching, a thread has stable TLB entry can fail to flush
> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> -	 * forcefully if we detect parallel PTE batching threads.
> +	 * Sensible comment goes here..
>   	 */
> -	if (mm_tlb_flush_nested(tlb->mm)) {
> -		__tlb_reset_range(tlb);
> -		__tlb_adjust_range(tlb, start, end - start);
> +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->full_mm) {
> +		/*
> +		 * Since we're can't tell what we actually should have
> +		 * flushed flush everything in the given range.
> +		 */
> +		tlb->start = start;
> +		tlb->end = end;
> +		tlb->freed_tables = 1;
> +		tlb->cleared_ptes = 1;
> +		tlb->cleared_pmds = 1;
> +		tlb->cleared_puds = 1;
> +		tlb->cleared_p4ds = 1;
>   	}
>   
>   	tlb_flush_mmu(tlb);

