Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F071C576
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 10:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfENI6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 04:58:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:47916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbfENI6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 04:58:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 68BF8AE1C;
        Tue, 14 May 2019 08:58:20 +0000 (UTC)
Date:   Tue, 14 May 2019 09:58:16 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Nadav Amit <namit@vmware.com>
Cc:     Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190514085816.GB23719@suse.de>
References: <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
 <20190513083606.GL2623@hirez.programming.kicks-ass.net>
 <75FD46B2-2E0C-41F2-9308-AB68C8780E33@vmware.com>
 <20190513163752.GA10754@fuggles.cambridge.arm.com>
 <43638259-8EDB-4B8D-A93D-A2E86D8B2489@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <43638259-8EDB-4B8D-A93D-A2E86D8B2489@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 05:06:03PM +0000, Nadav Amit wrote:
> > On May 13, 2019, at 9:37 AM, Will Deacon <will.deacon@arm.com> wrote:
> > 
> > On Mon, May 13, 2019 at 09:11:38AM +0000, Nadav Amit wrote:
> >>> On May 13, 2019, at 1:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>> 
> >>> On Thu, May 09, 2019 at 09:21:35PM +0000, Nadav Amit wrote:
> >>> 
> >>>>>>> And we can fix that by having tlb_finish_mmu() sync up. Never let a
> >>>>>>> concurrent tlb_finish_mmu() complete until all concurrenct mmu_gathers
> >>>>>>> have completed.
> >>>>>>> 
> >>>>>>> This should not be too hard to make happen.
> >>>>>> 
> >>>>>> This synchronization sounds much more expensive than what I proposed. But I
> >>>>>> agree that cache-lines that move from one CPU to another might become an
> >>>>>> issue. But I think that the scheme I suggested would minimize this overhead.
> >>>>> 
> >>>>> Well, it would have a lot more unconditional atomic ops. My scheme only
> >>>>> waits when there is actual concurrency.
> >>>> 
> >>>> Well, something has to give. I didn???t think that if the same core does the
> >>>> atomic op it would be too expensive.
> >>> 
> >>> They're still at least 20 cycles a pop, uncontended.
> >>> 
> >>>>> I _think_ something like the below ought to work, but its not even been
> >>>>> near a compiler. The only problem is the unconditional wakeup; we can
> >>>>> play games to avoid that if we want to continue with this.
> >>>>> 
> >>>>> Ideally we'd only do this when there's been actual overlap, but I've not
> >>>>> found a sensible way to detect that.
> >>>>> 
> >>>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> >>>>> index 4ef4bbe78a1d..b70e35792d29 100644
> >>>>> --- a/include/linux/mm_types.h
> >>>>> +++ b/include/linux/mm_types.h
> >>>>> @@ -590,7 +590,12 @@ static inline void dec_tlb_flush_pending(struct mm_struct *mm)
> >>>>> 	 *
> >>>>> 	 * Therefore we must rely on tlb_flush_*() to guarantee order.
> >>>>> 	 */
> >>>>> -	atomic_dec(&mm->tlb_flush_pending);
> >>>>> +	if (atomic_dec_and_test(&mm->tlb_flush_pending)) {
> >>>>> +		wake_up_var(&mm->tlb_flush_pending);
> >>>>> +	} else {
> >>>>> +		wait_event_var(&mm->tlb_flush_pending,
> >>>>> +			       !atomic_read_acquire(&mm->tlb_flush_pending));
> >>>>> +	}
> >>>>> }
> >>>> 
> >>>> It still seems very expensive to me, at least for certain workloads (e.g.,
> >>>> Apache with multithreaded MPM).
> >>> 
> >>> Is that Apache-MPM workload triggering this lots? Having a known
> >>> benchmark for this stuff is good for when someone has time to play with
> >>> things.
> >> 
> >> Setting Apache2 with mpm_worker causes every request to go through
> >> mmap-writev-munmap flow on every thread. I didn???t run this workload after
> >> the patches that downgrade the mmap_sem to read before the page-table
> >> zapping were introduced. I presume these patches would allow the page-table
> >> zapping to be done concurrently, and therefore would hit this flow.
> > 
> > Hmm, I don't think so: munmap() still has to take the semaphore for write
> > initially, so it will be serialised against other munmap() threads even
> > after they've downgraded afaict.
> > 
> > The initial bug report was about concurrent madvise() vs munmap().
> 
> I guess you are right (and I???m wrong).
> 
> Short search suggests that ebizzy might be affected (a thread by Mel
> Gorman): https://lkml.org/lkml/2015/2/2/493
> 

Glibc has since been fixed to be less munmap/mmap intensive and the
system CPU usage of ebizzy is generally negligible unless configured so
specifically use mmap/munmap instead of malloc/free which is unrealistic
for good application behaviour.

-- 
Mel Gorman
SUSE Labs
