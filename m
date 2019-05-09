Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4885719025
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfEISYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:24:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfEISYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 14:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=N9B1cpMq+/LvLmsepUerJSSHdTQN572R9HJQBCxTJBE=; b=FcMOrOHHcG1ZwURclcVBLK1Ut
        SPCIj8zaGs/U/st2rzMJHf1OgImQ3EzUSC3TzCjw8nolbOJvNd3b6VlKt0SE5qNFqiDR5YBOG4ygR
        F/LmZ8zNvc0VBqSiZrRP6vWWPOky/GDT0DXYAtxxopXEC1s9RSO7Fx6HqCM/2x+4E3qFk3xsjK243
        74JqVIF6vW3wMw1mPLz0vu0bvweRPPoQvXwIULz5rhYepTZUucDiZ1lIgpVeSmAG9dCHVfWp2DSJe
        0O2zDhqo3Um0naQTSkmMqwac4xnGnRsEd5odZRu4gdFHlSAGSBlj2BJLp6LzKD/biQI838QA8VM3l
        T/Bkhm4tw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hOnig-00030y-1J; Thu, 09 May 2019 18:24:38 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B75302143093D; Thu,  9 May 2019 20:24:35 +0200 (CEST)
Date:   Thu, 9 May 2019 20:24:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Will Deacon <will.deacon@arm.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190509182435.GA2623@hirez.programming.kicks-ass.net>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 05:36:29PM +0000, Nadav Amit wrote:
> > On May 9, 2019, at 3:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > index 99740e1dd273..fe768f8d612e 100644
> > --- a/mm/mmu_gather.c
> > +++ b/mm/mmu_gather.c
> > @@ -244,15 +244,20 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> > 		unsigned long start, unsigned long end)
> > {
> > 	/*
> > -	 * If there are parallel threads are doing PTE changes on same range
> > -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> > -	 * flush by batching, a thread has stable TLB entry can fail to flush
> > -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> > -	 * forcefully if we detect parallel PTE batching threads.
> > +	 * Sensible comment goes here..
> > 	 */
> > -	if (mm_tlb_flush_nested(tlb->mm)) {
> > -		__tlb_reset_range(tlb);
> > -		__tlb_adjust_range(tlb, start, end - start);
> > +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->full_mm) {
> > +		/*
> > +		 * Since we're can't tell what we actually should have
> > +		 * flushed flush everything in the given range.
> > +		 */
> > +		tlb->start = start;
> > +		tlb->end = end;
> > +		tlb->freed_tables = 1;
> > +		tlb->cleared_ptes = 1;
> > +		tlb->cleared_pmds = 1;
> > +		tlb->cleared_puds = 1;
> > +		tlb->cleared_p4ds = 1;
> > 	}
> > 
> > 	tlb_flush_mmu(tlb);
> 
> As a simple optimization, I think it is possible to hold multiple nesting
> counters in the mm, similar to tlb_flush_pending, for freed_tables,
> cleared_ptes, etc.
> 
> The first time you set tlb->freed_tables, you also atomically increase
> mm->tlb_flush_freed_tables. Then, in tlb_flush_mmu(), you just use
> mm->tlb_flush_freed_tables instead of tlb->freed_tables.

That sounds fraught with races and expensive; I would much prefer to not
go there for this arguably rare case.

Consider such fun cases as where CPU-0 sees and clears a PTE, CPU-1
races and doesn't see that PTE. Therefore CPU-0 sets and counts
cleared_ptes. Then if CPU-1 flushes while CPU-0 is still in mmu_gather,
it will see cleared_ptes count increased and flush that granularity,
OTOH if CPU-1 flushes after CPU-0 completes, it will not and potentiall
miss an invalidate it should have had.

This whole concurrent mmu_gather stuff is horrible.

  /me ponders more....

So I think the fundamental race here is this:

	CPU-0				CPU-1

	tlb_gather_mmu(.start=1,	tlb_gather_mmu(.start=2,
		       .end=3);			       .end=4);

	ptep_get_and_clear_full(2)
	tlb_remove_tlb_entry(2);
	__tlb_remove_page();
					if (pte_present(2)) // nope

					tlb_finish_mmu();

					// continue without TLBI(2)
					// whoopsie

	tlb_finish_mmu();
	  tlb_flush()		->	TLBI(2)


And we can fix that by having tlb_finish_mmu() sync up. Never let a
concurrent tlb_finish_mmu() complete until all concurrenct mmu_gathers
have completed.

This should not be too hard to make happen.
