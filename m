Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B04F189F7
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfEIMpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 08:45:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfEIMpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 08:45:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75C62369D2;
        Thu,  9 May 2019 12:45:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FDE64F84;
        Thu,  9 May 2019 12:45:00 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 31EFE3FAF4;
        Thu,  9 May 2019 12:45:00 +0000 (UTC)
Date:   Thu, 9 May 2019 08:44:57 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Will Deacon <will.deacon@arm.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        aneesh kumar <aneesh.kumar@linux.vnet.ibm.com>,
        npiggin@gmail.com, namit@vmware.com, minchan@kernel.org,
        Mel Gorman <mgorman@suse.de>, Jan Stancek <jstancek@redhat.com>
Message-ID: <436298752.21855393.1557405897147.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190509103813.GP2589@hirez.programming.kicks-ass.net>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com> <20190509083726.GA2209@brain-police> <20190509103813.GP2589@hirez.programming.kicks-ass.net>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.204.125, 10.4.195.27]
Thread-Topic: mmu_gather: remove __tlb_reset_range() for force flush
Thread-Index: DI/vebM+Rldg1xz41Sw2XzYn9lA53w==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 09 May 2019 12:45:00 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> > I don't think we can elide the call __tlb_reset_range() entirely, since I
> > think we do want to clear the freed_pXX bits to ensure that we walk the
> > range with the smallest mapping granule that we have. Otherwise couldn't we
> > have a problem if we hit a PMD that had been cleared, but the TLB
> > invalidation for the PTEs that used to be linked below it was still
> > pending?
> 
> That's tlb->cleared_p*, and yes agreed. That is, right until some
> architecture has level dependent TLBI instructions, at which point we'll
> need to have them all set instead of cleared.
> 
> > Perhaps we should just set fullmm if we see that here's a concurrent
> > unmapper rather than do a worst-case range invalidation. Do you have a
> > feeling
> > for often the mm_tlb_flush_nested() triggers in practice?
> 
> Quite a bit for certain workloads I imagine, that was the whole point of
> doing it.
> 
> Anyway; am I correct in understanding that the actual problem is that
> we've cleared freed_tables and the ARM64 tlb_flush() will then not
> invalidate the cache and badness happens?

That is my understanding, only last level is flushed, which is not enough.

> 
> Because so far nobody has actually provided a coherent description of
> the actual problem we're trying to solve. But I'm thinking something
> like the below ought to do.

I applied it (and fixed small typo: s/tlb->full_mm/tlb->fullmm/).
It fixes the problem for me.

> 
> 
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 99740e1dd273..fe768f8d612e 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -244,15 +244,20 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>  		unsigned long start, unsigned long end)
>  {
>  	/*
> -	 * If there are parallel threads are doing PTE changes on same range
> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> -	 * flush by batching, a thread has stable TLB entry can fail to flush
> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> -	 * forcefully if we detect parallel PTE batching threads.
> +	 * Sensible comment goes here..
>  	 */
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
>  	}
>  
>  	tlb_flush_mmu(tlb);
> 
