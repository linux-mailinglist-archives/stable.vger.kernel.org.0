Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04883375A
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 19:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFCR53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 13:57:29 -0400
Received: from foss.arm.com ([217.140.101.70]:57226 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfFCR52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 13:57:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22C6B80D;
        Mon,  3 Jun 2019 10:57:28 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2FFC33F5AF;
        Mon,  3 Jun 2019 10:57:26 -0700 (PDT)
Date:   Mon, 3 Jun 2019 18:57:19 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     akpm@linux-foundation.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        jstancek@redhat.com, mgorman@suse.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, namit@vmware.com,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        yang.shi@linux.alibaba.com
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
Message-ID: <20190603175719.GA13018@fuggles.cambridge.arm.com>
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
 <20190527110158.GB2623@hirez.programming.kicks-ass.net>
 <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com>
 <20190527142552.GD2623@hirez.programming.kicks-ass.net>
 <1559270298.wiy8c3d4zs.astroid@bobo.none>
 <20190531094931.GM2623@hirez.programming.kicks-ass.net>
 <1559527383.76rykleqz1.astroid@bobo.none>
 <20190603103009.GB27507@fuggles.cambridge.arm.com>
 <1559569861.n3f6bbdn43.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559569861.n3f6bbdn43.astroid@bobo.none>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nick,

On Tue, Jun 04, 2019 at 12:10:37AM +1000, Nicholas Piggin wrote:
> Will Deacon's on June 3, 2019 8:30 pm:
> > On Mon, Jun 03, 2019 at 12:11:38PM +1000, Nicholas Piggin wrote:
> >> Peter Zijlstra's on May 31, 2019 7:49 pm:
> >> > On Fri, May 31, 2019 at 12:46:56PM +1000, Nicholas Piggin wrote:
> >> >> I don't think it's very nice to set fullmm and freed_tables for this 
> >> >> case though. Is this concurrent zapping an important fast path? It
> >> >> must have been, in order to justify all this complexity to the mm, so
> >> >> we don't want to tie this boat anchor to it AFAIKS?
> >> > 
> >> > I'm not convinced its an important fast path, afaict it is an
> >> > unfortunate correctness issue caused by allowing concurrenct frees.
> >> 
> >> I mean -- concurrent freeing was an important fastpath, right?
> >> And concurrent freeing means that you hit this case. So this
> >> case itself should be important too.
> > 
> > I honestly don't think we (Peter and I) know. Our first involvement with
> > this was because TLBs were found to contain stale user entries:
> > 
> > https://lore.kernel.org/linux-arm-kernel/1817839533.20996552.1557065445233.JavaMail.zimbra@redhat.com/
> > 
> > so the initial work to support the concurrent freeing was done separately
> > and, I assume, motivated by some real workloads. I would also very much
> > like to know more about that, since nothing remotely realistic has surfaced
> > in this discussion, other than some historical glibc thing which has long
> > since been fixed.
> 
> Well, it seems like it is important. While the complexity is carried
> in the mm, we should not skimp on this last small piece.

As I say, I really don't know. But yes, if we can do something better we
should.

> >> >> Is the problem just that the freed page tables flags get cleared by
> >> >> __tlb_reset_range()? Why not just remove that then, so the bits are
> >> >> set properly for the munmap?
> >> > 
> >> > That's insufficient; as argued in my initial suggestion:
> >> > 
> >> >   https://lkml.kernel.org/r/20190509103813.GP2589@hirez.programming.kicks-ass.net
> >> > 
> >> > Since we don't know what was flushed by the concorrent flushes, we must
> >> > flush all state (page sizes, tables etc..).
> >> 
> >> Page tables should not be concurrently freed I think. Just don't clear
> >> those page table free flags and it should be okay. Page sizes yes,
> >> but we accommodated for that in the arch code. I could see reason to
> >> add a flag to the gather struct like "concurrent_free" and set that
> >> from the generic code, which the arch has to take care of.
> > 
> > I think you're correct that two CPUs cannot free the page tables
> > concurrently (I misunderstood this initially), although I also think
> > there may be some subtle issues if tlb->freed_tables is not set,
> > depending on the architecture. Roughly speaking, if one CPU is clearing
> > a PMD as part of munmap() and another CPU in madvise() does only last-level
> > TLB invalidation, then I think there's the potential for the invalidation
> > to be ineffective if observing a cleared PMD doesn't imply that the last
> > level has been unmapped from the perspective of the page-table walker.
> 
> That should not be the case because the last level table should have
> had all entries cleared before the pointer to it has been cleared.

The devil is in the detail here, and I think specifically it depends
what you mean by "before". Does that mean memory barrier, or special
page-table walker barrier, or TLB invalidation or ...?

> So the page table walker could begin from the now-freed page table,
> but it would never instantiate a valid TLB entry from there. So a
> TLB invalidation would behave properly despite not flushing page
> tables.
> 
> Powerpc at least would want to avoid over flushing here, AFAIKS.

For arm64 it really depends how often this hits. Simply not setting
tlb->freed_tables would also break things for us, because we have an
optimisation where we elide invalidation in the fullmm && !freed_tables
case, since this is indicative of the mm going away and so we simply
avoid reallocating its ASID.

> >> > But it looks like benchmarks (for the one test-case we have) seem to
> >> > favour flushing the world over flushing a smaller range.
> >> 
> >> Testing on 16MB unmap is possibly not a good benchmark, I didn't run
> >> it exactly but it looks likely to go beyond the range flush threshold
> >> and flush the entire PID anyway.
> > 
> > If we can get a better idea of what a "good benchmark" might look like (i.e.
> > something that is representative of the cases in which real workloads are
> > likely to trigger this path) then we can definitely try to optimise around
> > that.
> 
> Hard to say unfortunately. A smaller unmap range to start with, but
> even then when you have a TLB over-flushing case, then an unmap micro
> benchmark is not a great test because you'd like to see more impact of
> other useful entries being flushed (e.g., you need an actual working
> set).

Right, sounds like somebody needs to do some better analysis than what's
been done so far.

> > In the meantime, I would really like to see this patch land in mainline
> > since it fixes a regression.
> 
> Sorry I didn't provide input earlier. I would like to improve the fix or 
> at least make an option for archs to provide an optimised way to flush 
> this case, so it would be nice not to fix archs this way and then have 
> to change the fix significantly right away.

Please send patches ;)

> But the bug does need to be fixed of course, if there needs to be more
> thought about it maybe it's best to take this fix for next release.

Agreed.

Will
