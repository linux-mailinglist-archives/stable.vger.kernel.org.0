Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3701CAEE
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 16:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfENOyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 10:54:50 -0400
Received: from foss.arm.com ([217.140.101.70]:57230 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfENOyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 10:54:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC259374;
        Tue, 14 May 2019 07:54:49 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CC6F3F703;
        Tue, 14 May 2019 07:54:48 -0700 (PDT)
Date:   Tue, 14 May 2019 15:54:45 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     jstancek@redhat.com, peterz@infradead.org, namit@vmware.com,
        minchan@kernel.org, mgorman@suse.de, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190514145445.GB2825@fuggles.cambridge.arm.com>
References: <1557444414-12090-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190513163804.GB10754@fuggles.cambridge.arm.com>
 <360170d7-b16f-f130-f930-bfe54be9747a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <360170d7-b16f-f130-f930-bfe54be9747a@linux.alibaba.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 04:01:09PM -0700, Yang Shi wrote:
> 
> 
> On 5/13/19 9:38 AM, Will Deacon wrote:
> > On Fri, May 10, 2019 at 07:26:54AM +0800, Yang Shi wrote:
> > > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > > index 99740e1..469492d 100644
> > > --- a/mm/mmu_gather.c
> > > +++ b/mm/mmu_gather.c
> > > @@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> > >   {
> > >   	/*
> > >   	 * If there are parallel threads are doing PTE changes on same range
> > > -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> > > -	 * flush by batching, a thread has stable TLB entry can fail to flush
> > > -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> > > -	 * forcefully if we detect parallel PTE batching threads.
> > > +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> > > +	 * flush by batching, one thread may end up seeing inconsistent PTEs
> > > +	 * and result in having stale TLB entries.  So flush TLB forcefully
> > > +	 * if we detect parallel PTE batching threads.
> > > +	 *
> > > +	 * However, some syscalls, e.g. munmap(), may free page tables, this
> > > +	 * needs force flush everything in the given range. Otherwise this
> > > +	 * may result in having stale TLB entries for some architectures,
> > > +	 * e.g. aarch64, that could specify flush what level TLB.
> > >   	 */
> > > -	if (mm_tlb_flush_nested(tlb->mm)) {
> > > -		__tlb_reset_range(tlb);
> > > -		__tlb_adjust_range(tlb, start, end - start);
> > > +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->fullmm) {
> > > +		/*
> > > +		 * Since we can't tell what we actually should have
> > > +		 * flushed, flush everything in the given range.
> > > +		 */
> > > +		tlb->freed_tables = 1;
> > > +		tlb->cleared_ptes = 1;
> > > +		tlb->cleared_pmds = 1;
> > > +		tlb->cleared_puds = 1;
> > > +		tlb->cleared_p4ds = 1;
> > > +
> > > +		/*
> > > +		 * Some architectures, e.g. ARM, that have range invalidation
> > > +		 * and care about VM_EXEC for I-Cache invalidation, need force
> > > +		 * vma_exec set.
> > > +		 */
> > > +		tlb->vma_exec = 1;
> > > +
> > > +		/* Force vma_huge clear to guarantee safer flush */
> > > +		tlb->vma_huge = 0;
> > > +
> > > +		tlb->start = start;
> > > +		tlb->end = end;
> > >   	}
> > Whilst I think this is correct, it would be interesting to see whether
> > or not it's actually faster than just nuking the whole mm, as I mentioned
> > before.
> > 
> > At least in terms of getting a short-term fix, I'd prefer the diff below
> > if it's not measurably worse.
> 
> I did a quick test with ebizzy (96 threads with 5 iterations) on my x86 VM,
> it shows slightly slowdown on records/s but much more sys time spent with
> fullmm flush, the below is the data.
> 
>                                     nofullmm                 fullmm
> ops (records/s)              225606                  225119
> sys (s)                            0.69                        1.14
> 
> It looks the slight reduction of records/s is caused by the increase of sys
> time.

That's not what I expected, and I'm unable to explain why moving to fullmm
would /increase/ the system time. I would've thought the time spent doing
the invalidation would decrease, with the downside that the TLB is cold
when returning back to userspace.

FWIW, I ran 10 iterations of ebizzy on my arm64 box using a vanilla 5.1
kernel and the numbers are all over the place (see below). I think
deducing anything meaningful from this benchmark will be a challenge.

Will

--->8

306090 records/s
real 10.00 s
user 1227.55 s
sys   0.54 s
323547 records/s
real 10.00 s
user 1262.95 s
sys   0.82 s
409148 records/s
real 10.00 s
user 1266.54 s
sys   0.94 s
341507 records/s
real 10.00 s
user 1263.49 s
sys   0.66 s
375910 records/s
real 10.00 s
user 1259.87 s
sys   0.82 s
376152 records/s
real 10.00 s
user 1265.76 s
sys   0.96 s
358862 records/s
real 10.00 s
user 1251.13 s
sys   0.72 s
358164 records/s
real 10.00 s
user 1243.48 s
sys   0.85 s
332148 records/s
real 10.00 s
user 1260.93 s
sys   0.70 s
367021 records/s
real 10.00 s
user 1264.06 s
sys   1.43 s
