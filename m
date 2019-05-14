Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E248B1C818
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 14:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfENMC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 08:02:27 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:54668 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfENMC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 08:02:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3890D341;
        Tue, 14 May 2019 05:02:27 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F02D3F71E;
        Tue, 14 May 2019 05:02:25 -0700 (PDT)
Date:   Tue, 14 May 2019 13:02:20 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, jstancek@redhat.com,
        namit@vmware.com, minchan@kernel.org, mgorman@suse.de,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190514120220.GA16314@fuggles.cambridge.arm.com>
References: <1557444414-12090-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190513163804.GB10754@fuggles.cambridge.arm.com>
 <20190514115223.GP2589@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514115223.GP2589@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 01:52:23PM +0200, Peter Zijlstra wrote:
> On Mon, May 13, 2019 at 05:38:04PM +0100, Will Deacon wrote:
> > On Fri, May 10, 2019 at 07:26:54AM +0800, Yang Shi wrote:
> > > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > > index 99740e1..469492d 100644
> > > --- a/mm/mmu_gather.c
> > > +++ b/mm/mmu_gather.c
> > > @@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> > >  {
> > >  	/*
> > >  	 * If there are parallel threads are doing PTE changes on same range
> > > +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> > > +	 * flush by batching, one thread may end up seeing inconsistent PTEs
> > > +	 * and result in having stale TLB entries.  So flush TLB forcefully
> > > +	 * if we detect parallel PTE batching threads.
> > > +	 *
> > > +	 * However, some syscalls, e.g. munmap(), may free page tables, this
> > > +	 * needs force flush everything in the given range. Otherwise this
> > > +	 * may result in having stale TLB entries for some architectures,
> > > +	 * e.g. aarch64, that could specify flush what level TLB.
> > >  	 */
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
> > >  	}
> > 
> > Whilst I think this is correct, it would be interesting to see whether
> > or not it's actually faster than just nuking the whole mm, as I mentioned
> > before.
> > 
> > At least in terms of getting a short-term fix, I'd prefer the diff below
> > if it's not measurably worse.
> 
> So what point? General paranoia? Either change should allow PPC to get
> rid of its magic mushrooms, the below would be a little bit easier for
> them because they already do full invalidate correct.

Right; a combination of paranoia (need to remember to update this code
to "flush everything" if we add new fields to the gather structure) but
I also expected the performance to be better on arm64, where having two
CPUs spamming TLBI messages at the same time is likely to suck.

I'm super confused about the system time being reported as higher with
this change.  That's really not what I expected.

Will
