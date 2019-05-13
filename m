Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F86B1BFB5
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 01:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEMXBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 19:01:23 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:55044 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbfEMXBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 19:01:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TRe7atb_1557788475;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TRe7atb_1557788475)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 May 2019 07:01:18 +0800
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
To:     Will Deacon <will.deacon@arm.com>
Cc:     jstancek@redhat.com, peterz@infradead.org, namit@vmware.com,
        minchan@kernel.org, mgorman@suse.de, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1557444414-12090-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190513163804.GB10754@fuggles.cambridge.arm.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <360170d7-b16f-f130-f930-bfe54be9747a@linux.alibaba.com>
Date:   Mon, 13 May 2019 16:01:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190513163804.GB10754@fuggles.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/13/19 9:38 AM, Will Deacon wrote:
> On Fri, May 10, 2019 at 07:26:54AM +0800, Yang Shi wrote:
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index 99740e1..469492d 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>>   {
>>   	/*
>>   	 * If there are parallel threads are doing PTE changes on same range
>> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
>> -	 * flush by batching, a thread has stable TLB entry can fail to flush
>> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
>> -	 * forcefully if we detect parallel PTE batching threads.
>> +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
>> +	 * flush by batching, one thread may end up seeing inconsistent PTEs
>> +	 * and result in having stale TLB entries.  So flush TLB forcefully
>> +	 * if we detect parallel PTE batching threads.
>> +	 *
>> +	 * However, some syscalls, e.g. munmap(), may free page tables, this
>> +	 * needs force flush everything in the given range. Otherwise this
>> +	 * may result in having stale TLB entries for some architectures,
>> +	 * e.g. aarch64, that could specify flush what level TLB.
>>   	 */
>> -	if (mm_tlb_flush_nested(tlb->mm)) {
>> -		__tlb_reset_range(tlb);
>> -		__tlb_adjust_range(tlb, start, end - start);
>> +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->fullmm) {
>> +		/*
>> +		 * Since we can't tell what we actually should have
>> +		 * flushed, flush everything in the given range.
>> +		 */
>> +		tlb->freed_tables = 1;
>> +		tlb->cleared_ptes = 1;
>> +		tlb->cleared_pmds = 1;
>> +		tlb->cleared_puds = 1;
>> +		tlb->cleared_p4ds = 1;
>> +
>> +		/*
>> +		 * Some architectures, e.g. ARM, that have range invalidation
>> +		 * and care about VM_EXEC for I-Cache invalidation, need force
>> +		 * vma_exec set.
>> +		 */
>> +		tlb->vma_exec = 1;
>> +
>> +		/* Force vma_huge clear to guarantee safer flush */
>> +		tlb->vma_huge = 0;
>> +
>> +		tlb->start = start;
>> +		tlb->end = end;
>>   	}
> Whilst I think this is correct, it would be interesting to see whether
> or not it's actually faster than just nuking the whole mm, as I mentioned
> before.
>
> At least in terms of getting a short-term fix, I'd prefer the diff below
> if it's not measurably worse.

I did a quick test with ebizzy (96 threads with 5 iterations) on my x86 
VM, it shows slightly slowdown on records/s but much more sys time spent 
with fullmm flush, the below is the data.

                                     nofullmm                 fullmm
ops (records/s)              225606                  225119
sys (s)                            0.69                        1.14

It looks the slight reduction of records/s is caused by the increase of 
sys time.

>
> Will
>
> --->8
>
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 99740e1dd273..cc251422d307 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -251,8 +251,9 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>   	 * forcefully if we detect parallel PTE batching threads.
>   	 */
>   	if (mm_tlb_flush_nested(tlb->mm)) {
> +		tlb->fullmm = 1;
>   		__tlb_reset_range(tlb);
> -		__tlb_adjust_range(tlb, start, end - start);
> +		tlb->freed_tables = 1;
>   	}
>   
>   	tlb_flush_mmu(tlb);

