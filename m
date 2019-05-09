Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC3F194E7
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 23:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEIVsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 17:48:45 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:53267 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbfEIVsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 17:48:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0TRHcHwW_1557438515;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TRHcHwW_1557438515)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 May 2019 05:48:39 +0800
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
To:     Jan Stancek <jstancek@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Nadav Amit <namit@vmware.com>, Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        aneesh kumar <aneesh.kumar@linux.vnet.ibm.com>,
        npiggin@gmail.com, minchan@kernel.org, Mel Gorman <mgorman@suse.de>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <84720bb8-bf3d-8c10-d675-0670f13b2efc@linux.alibaba.com>
 <249230644.21949166.1557435998550.JavaMail.zimbra@redhat.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <6f606e4f-d151-0c43-11f4-4a78e6dfabbf@linux.alibaba.com>
Date:   Thu, 9 May 2019 14:48:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <249230644.21949166.1557435998550.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/9/19 2:06 PM, Jan Stancek wrote:
> ----- Original Message -----
>>
>> On 5/9/19 11:24 AM, Peter Zijlstra wrote:
>>> On Thu, May 09, 2019 at 05:36:29PM +0000, Nadav Amit wrote:
>>>>> On May 9, 2019, at 3:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>>>>> index 99740e1dd273..fe768f8d612e 100644
>>>>> --- a/mm/mmu_gather.c
>>>>> +++ b/mm/mmu_gather.c
>>>>> @@ -244,15 +244,20 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>>>>> 		unsigned long start, unsigned long end)
>>>>> {
>>>>> 	/*
>>>>> -	 * If there are parallel threads are doing PTE changes on same range
>>>>> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
>>>>> -	 * flush by batching, a thread has stable TLB entry can fail to flush
>>>>> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
>>>>> -	 * forcefully if we detect parallel PTE batching threads.
>>>>> +	 * Sensible comment goes here..
>>>>> 	 */
>>>>> -	if (mm_tlb_flush_nested(tlb->mm)) {
>>>>> -		__tlb_reset_range(tlb);
>>>>> -		__tlb_adjust_range(tlb, start, end - start);
>>>>> +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->full_mm) {
>>>>> +		/*
>>>>> +		 * Since we're can't tell what we actually should have
>>>>> +		 * flushed flush everything in the given range.
>>>>> +		 */
>>>>> +		tlb->start = start;
>>>>> +		tlb->end = end;
>>>>> +		tlb->freed_tables = 1;
>>>>> +		tlb->cleared_ptes = 1;
>>>>> +		tlb->cleared_pmds = 1;
>>>>> +		tlb->cleared_puds = 1;
>>>>> +		tlb->cleared_p4ds = 1;
>>>>> 	}
>>>>>
>>>>> 	tlb_flush_mmu(tlb);
>>>> As a simple optimization, I think it is possible to hold multiple nesting
>>>> counters in the mm, similar to tlb_flush_pending, for freed_tables,
>>>> cleared_ptes, etc.
>>>>
>>>> The first time you set tlb->freed_tables, you also atomically increase
>>>> mm->tlb_flush_freed_tables. Then, in tlb_flush_mmu(), you just use
>>>> mm->tlb_flush_freed_tables instead of tlb->freed_tables.
>>> That sounds fraught with races and expensive; I would much prefer to not
>>> go there for this arguably rare case.
>>>
>>> Consider such fun cases as where CPU-0 sees and clears a PTE, CPU-1
>>> races and doesn't see that PTE. Therefore CPU-0 sets and counts
>>> cleared_ptes. Then if CPU-1 flushes while CPU-0 is still in mmu_gather,
>>> it will see cleared_ptes count increased and flush that granularity,
>>> OTOH if CPU-1 flushes after CPU-0 completes, it will not and potentiall
>>> miss an invalidate it should have had.
>>>
>>> This whole concurrent mmu_gather stuff is horrible.
>>>
>>>     /me ponders more....
>>>
>>> So I think the fundamental race here is this:
>>>
>>> 	CPU-0				CPU-1
>>>
>>> 	tlb_gather_mmu(.start=1,	tlb_gather_mmu(.start=2,
>>> 		       .end=3);			       .end=4);
>>>
>>> 	ptep_get_and_clear_full(2)
>>> 	tlb_remove_tlb_entry(2);
>>> 	__tlb_remove_page();
>>> 					if (pte_present(2)) // nope
>>>
>>> 					tlb_finish_mmu();
>>>
>>> 					// continue without TLBI(2)
>>> 					// whoopsie
>>>
>>> 	tlb_finish_mmu();
>>> 	  tlb_flush()		->	TLBI(2)
>> I'm not quite sure if this is the case Jan really met. But, according to
>> his test, once correct tlb->freed_tables and tlb->cleared_* are set, his
>> test works well.
> My theory was following sequence:
>
> t1: map_write_unmap()                 t2: dummy()
>
>    map_address = mmap()
>    map_address[i] = 'b'
>    munmap(map_address)
>    downgrade_write(&mm->mmap_sem);
>    unmap_region()
>    tlb_gather_mmu()
>      inc_tlb_flush_pending(tlb->mm);
>    free_pgtables()
>      tlb->freed_tables = 1
>      tlb->cleared_pmds = 1
>
>                                          pthread_exit()
>                                          madvise(thread_stack, 8M, MADV_DONTNEED)

I'm not quite familiar with the implementation detail of pthread_exit(), 
does pthread_exit() call MADV_DONTNEED all the time? I don't see your 
test call it. If so this pattern is definitely possible.

>                                            zap_page_range()
>                                              tlb_gather_mmu()
>                                                inc_tlb_flush_pending(tlb->mm);
>
>    tlb_finish_mmu()
>      if (mm_tlb_flush_nested(tlb->mm))
>        __tlb_reset_range()
>          tlb->freed_tables = 0
>          tlb->cleared_pmds = 0
>      __flush_tlb_range(last_level = 0)
>    ...
>    map_address = mmap()
>      map_address[i] = 'b'
>        <page fault loop>
>        # PTE appeared valid to me,
>        # so I suspected stale TLB entry at higher level as result of "freed_tables = 0"
>
>
> I'm happy to apply/run any debug patches to get more data that would help.
>
>>>
>>> And we can fix that by having tlb_finish_mmu() sync up. Never let a
>>> concurrent tlb_finish_mmu() complete until all concurrenct mmu_gathers
>>> have completed.
>> Not sure if this will scale well.
>>
>>> This should not be too hard to make happen.
>>

