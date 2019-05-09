Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8032D19044
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfEISgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:36:11 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:42964 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfEISgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 14:36:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0TRHO45d_1557426956;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TRHO45d_1557426956)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 May 2019 02:36:00 +0800
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
 <20190509105446.GL2650@hirez.programming.kicks-ass.net>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <6a907073-67ec-04fe-aaae-c1adcb62e3df@linux.alibaba.com>
Date:   Thu, 9 May 2019 11:35:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190509105446.GL2650@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/9/19 3:54 AM, Peter Zijlstra wrote:
> On Thu, May 09, 2019 at 12:38:13PM +0200, Peter Zijlstra wrote:
>
>> That's tlb->cleared_p*, and yes agreed. That is, right until some
>> architecture has level dependent TLBI instructions, at which point we'll
>> need to have them all set instead of cleared.
>> Anyway; am I correct in understanding that the actual problem is that
>> we've cleared freed_tables and the ARM64 tlb_flush() will then not
>> invalidate the cache and badness happens?
>>
>> Because so far nobody has actually provided a coherent description of
>> the actual problem we're trying to solve. But I'm thinking something
>> like the below ought to do.
> There's another 'fun' issue I think. For architectures like ARM that
> have range invalidation and care about VM_EXEC for I$ invalidation, the
> below doesn't quite work right either.
>
> I suspect we also have to force: tlb->vma_exec = 1.

Isn't the below code in tlb_flush enough to guarantee this?

...
} else if (tlb->end) {
                struct vm_area_struct vma = {
                        .vm_mm = tlb->mm,
                        .vm_flags = (tlb->vma_exec ? VM_EXEC    : 0) |
                                    (tlb->vma_huge ? VM_HUGETLB : 0),
                };
...

>
> And I don't think there's an architecture that cares, but depending on
> details I can construct cases where any setting of tlb->vm_hugetlb is
> wrong, so that is _awesome_. But I suspect the sane thing for now is to
> force it 0.
>
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index 99740e1dd273..fe768f8d612e 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -244,15 +244,20 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>>   		unsigned long start, unsigned long end)
>>   {
>>   	/*
>> -	 * If there are parallel threads are doing PTE changes on same range
>> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
>> -	 * flush by batching, a thread has stable TLB entry can fail to flush
>> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
>> -	 * forcefully if we detect parallel PTE batching threads.
>> +	 * Sensible comment goes here..
>>   	 */
>> -	if (mm_tlb_flush_nested(tlb->mm)) {
>> -		__tlb_reset_range(tlb);
>> -		__tlb_adjust_range(tlb, start, end - start);
>> +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->full_mm) {
>> +		/*
>> +		 * Since we're can't tell what we actually should have
>> +		 * flushed flush everything in the given range.
>> +		 */
>> +		tlb->start = start;
>> +		tlb->end = end;
>> +		tlb->freed_tables = 1;
>> +		tlb->cleared_ptes = 1;
>> +		tlb->cleared_pmds = 1;
>> +		tlb->cleared_puds = 1;
>> +		tlb->cleared_p4ds = 1;
>>   	}
>>   
>>   	tlb_flush_mmu(tlb);

