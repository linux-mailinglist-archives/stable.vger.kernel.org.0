Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A3F32DB2
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 12:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfFCKaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 06:30:14 -0400
Received: from foss.arm.com ([217.140.101.70]:48360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfFCKaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 06:30:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AC57374;
        Mon,  3 Jun 2019 03:30:13 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A88A3F5AF;
        Mon,  3 Jun 2019 03:30:11 -0700 (PDT)
Date:   Mon, 3 Jun 2019 11:30:09 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        jstancek@redhat.com, mgorman@suse.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, namit@vmware.com,
        stable@vger.kernel.org, yang.shi@linux.alibaba.com
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
Message-ID: <20190603103009.GB27507@fuggles.cambridge.arm.com>
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
 <20190527110158.GB2623@hirez.programming.kicks-ass.net>
 <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com>
 <20190527142552.GD2623@hirez.programming.kicks-ass.net>
 <1559270298.wiy8c3d4zs.astroid@bobo.none>
 <20190531094931.GM2623@hirez.programming.kicks-ass.net>
 <1559527383.76rykleqz1.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559527383.76rykleqz1.astroid@bobo.none>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nick,

On Mon, Jun 03, 2019 at 12:11:38PM +1000, Nicholas Piggin wrote:
> Peter Zijlstra's on May 31, 2019 7:49 pm:
> > On Fri, May 31, 2019 at 12:46:56PM +1000, Nicholas Piggin wrote:
> >> I don't think it's very nice to set fullmm and freed_tables for this 
> >> case though. Is this concurrent zapping an important fast path? It
> >> must have been, in order to justify all this complexity to the mm, so
> >> we don't want to tie this boat anchor to it AFAIKS?
> > 
> > I'm not convinced its an important fast path, afaict it is an
> > unfortunate correctness issue caused by allowing concurrenct frees.
> 
> I mean -- concurrent freeing was an important fastpath, right?
> And concurrent freeing means that you hit this case. So this
> case itself should be important too.

I honestly don't think we (Peter and I) know. Our first involvement with
this was because TLBs were found to contain stale user entries:

https://lore.kernel.org/linux-arm-kernel/1817839533.20996552.1557065445233.JavaMail.zimbra@redhat.com/

so the initial work to support the concurrent freeing was done separately
and, I assume, motivated by some real workloads. I would also very much
like to know more about that, since nothing remotely realistic has surfaced
in this discussion, other than some historical glibc thing which has long
since been fixed.

> >> Is the problem just that the freed page tables flags get cleared by
> >> __tlb_reset_range()? Why not just remove that then, so the bits are
> >> set properly for the munmap?
> > 
> > That's insufficient; as argued in my initial suggestion:
> > 
> >   https://lkml.kernel.org/r/20190509103813.GP2589@hirez.programming.kicks-ass.net
> > 
> > Since we don't know what was flushed by the concorrent flushes, we must
> > flush all state (page sizes, tables etc..).
> 
> Page tables should not be concurrently freed I think. Just don't clear
> those page table free flags and it should be okay. Page sizes yes,
> but we accommodated for that in the arch code. I could see reason to
> add a flag to the gather struct like "concurrent_free" and set that
> from the generic code, which the arch has to take care of.

I think you're correct that two CPUs cannot free the page tables
concurrently (I misunderstood this initially), although I also think
there may be some subtle issues if tlb->freed_tables is not set,
depending on the architecture. Roughly speaking, if one CPU is clearing
a PMD as part of munmap() and another CPU in madvise() does only last-level
TLB invalidation, then I think there's the potential for the invalidation
to be ineffective if observing a cleared PMD doesn't imply that the last
level has been unmapped from the perspective of the page-table walker.

> > But it looks like benchmarks (for the one test-case we have) seem to
> > favour flushing the world over flushing a smaller range.
> 
> Testing on 16MB unmap is possibly not a good benchmark, I didn't run
> it exactly but it looks likely to go beyond the range flush threshold
> and flush the entire PID anyway.

If we can get a better idea of what a "good benchmark" might look like (i.e.
something that is representative of the cases in which real workloads are
likely to trigger this path) then we can definitely try to optimise around
that.

In the meantime, I would really like to see this patch land in mainline
since it fixes a regression.

Will
