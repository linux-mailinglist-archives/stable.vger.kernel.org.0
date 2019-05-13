Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EB91B1F3
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 10:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfEMIgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 04:36:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52574 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbfEMIgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 04:36:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A/LTjUKq3u7qRwt9jLoPyIVtj9SXda11NSro60RTqLg=; b=Z+A0uN9kY/5akyp9FoyRxb1Be5
        1Qigih1z3BK4FURzUf9KoYBXn/anfPh+e1A+sbbSS/HRRb8MLcbOyWKifHMJ6oOv0qad6VkOVfvEJ
        iGe88evRSwyM6FRC08g6CBx0tpkMhp48t8Kbm6mK8WCsLjexMnSkrXTh+sRt2arZOAjGkP39tYOS7
        T51OK83w1YaMZIPXUD9OPs7Wk3gDOWhiSrb6U2N47GR8LVKO99CX+8SHYzddKQgQtl0PQbA5ex2nJ
        U5nzALEj53adVcan72GkNuBvJFAZ1nEhaMYuuT/t+BmkH3e2itGHs14rd1JPKaoMkAA5I9LKvYDEb
        NeDXz1/A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQ6RL-0005UE-KR; Mon, 13 May 2019 08:36:07 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 25DFF2029FD7A; Mon, 13 May 2019 10:36:06 +0200 (CEST)
Date:   Mon, 13 May 2019 10:36:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190513083606.GL2623@hirez.programming.kicks-ass.net>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 09:21:35PM +0000, Nadav Amit wrote:

> >>> And we can fix that by having tlb_finish_mmu() sync up. Never let a
> >>> concurrent tlb_finish_mmu() complete until all concurrenct mmu_gathers
> >>> have completed.
> >>> 
> >>> This should not be too hard to make happen.
> >> 
> >> This synchronization sounds much more expensive than what I proposed. But I
> >> agree that cache-lines that move from one CPU to another might become an
> >> issue. But I think that the scheme I suggested would minimize this overhead.
> > 
> > Well, it would have a lot more unconditional atomic ops. My scheme only
> > waits when there is actual concurrency.
> 
> Well, something has to give. I didn’t think that if the same core does the
> atomic op it would be too expensive.

They're still at least 20 cycles a pop, uncontended.

> > I _think_ something like the below ought to work, but its not even been
> > near a compiler. The only problem is the unconditional wakeup; we can
> > play games to avoid that if we want to continue with this.
> > 
> > Ideally we'd only do this when there's been actual overlap, but I've not
> > found a sensible way to detect that.
> > 
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 4ef4bbe78a1d..b70e35792d29 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -590,7 +590,12 @@ static inline void dec_tlb_flush_pending(struct mm_struct *mm)
> > 	 *
> > 	 * Therefore we must rely on tlb_flush_*() to guarantee order.
> > 	 */
> > -	atomic_dec(&mm->tlb_flush_pending);
> > +	if (atomic_dec_and_test(&mm->tlb_flush_pending)) {
> > +		wake_up_var(&mm->tlb_flush_pending);
> > +	} else {
> > +		wait_event_var(&mm->tlb_flush_pending,
> > +			       !atomic_read_acquire(&mm->tlb_flush_pending));
> > +	}
> > }
> 
> It still seems very expensive to me, at least for certain workloads (e.g.,
> Apache with multithreaded MPM).

Is that Apache-MPM workload triggering this lots? Having a known
benchmark for this stuff is good for when someone has time to play with
things.

> It may be possible to avoid false-positive nesting indications (when the
> flushes do not overlap) by creating a new struct mmu_gather_pending, with
> something like:
> 
>   struct mmu_gather_pending {
>  	u64 start;
> 	u64 end;
> 	struct mmu_gather_pending *next;
>   }
> 
> tlb_finish_mmu() would then iterate over the mm->mmu_gather_pending
> (pointing to the linked list) and find whether there is any overlap. This
> would still require synchronization (acquiring a lock when allocating and
> deallocating or something fancier).

We have an interval_tree for this, and yes, that's how far I got :/

The other thing I was thinking of is trying to detect overlap through
the page-tables themselves, but we have a distinct lack of storage
there.

The things is, if this threaded monster runs on all CPUs (busy front end
server) and does a ton of invalidation due to all the short lived
request crud, then all the extra invalidations will add up too. Having
to do process (machine in this case) wide invalidations is expensive,
having to do more of them surely isn't cheap either.

So there might be something to win here.
