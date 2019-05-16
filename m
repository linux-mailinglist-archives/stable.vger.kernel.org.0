Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E53320B3D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfEPP3k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 16 May 2019 11:29:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17233 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbfEPP3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 11:29:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51C93307C940;
        Thu, 16 May 2019 15:29:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 371B45D6A9;
        Thu, 16 May 2019 15:29:39 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 902B31806B11;
        Thu, 16 May 2019 15:29:38 +0000 (UTC)
Date:   Thu, 16 May 2019 11:29:35 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, peterz@infradead.org,
        namit@vmware.com, minchan@kernel.org, mgorman@suse.de,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jan Stancek <jstancek@redhat.com>
Message-ID: <1158926942.23199905.1558020575293.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190514145445.GB2825@fuggles.cambridge.arm.com>
References: <1557444414-12090-1-git-send-email-yang.shi@linux.alibaba.com> <20190513163804.GB10754@fuggles.cambridge.arm.com> <360170d7-b16f-f130-f930-bfe54be9747a@linux.alibaba.com> <20190514145445.GB2825@fuggles.cambridge.arm.com>
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.43.17.163, 10.4.195.10]
Thread-Topic: mmu_gather: remove __tlb_reset_range() for force flush
Thread-Index: uzKTPt4zsaol+2IqXYgAH+t+3N7Fug==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 16 May 2019 15:29:39 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> On Mon, May 13, 2019 at 04:01:09PM -0700, Yang Shi wrote:
> > 
> > 
> > On 5/13/19 9:38 AM, Will Deacon wrote:
> > > On Fri, May 10, 2019 at 07:26:54AM +0800, Yang Shi wrote:
> > > > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > > > index 99740e1..469492d 100644
> > > > --- a/mm/mmu_gather.c
> > > > +++ b/mm/mmu_gather.c
> > > > @@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> > > >   {
> > > >   	/*
> > > >   	 * If there are parallel threads are doing PTE changes on same range
> > > > -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> > > > -	 * flush by batching, a thread has stable TLB entry can fail to flush
> > > > -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> > > > -	 * forcefully if we detect parallel PTE batching threads.
> > > > +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> > > > +	 * flush by batching, one thread may end up seeing inconsistent PTEs
> > > > +	 * and result in having stale TLB entries.  So flush TLB forcefully
> > > > +	 * if we detect parallel PTE batching threads.
> > > > +	 *
> > > > +	 * However, some syscalls, e.g. munmap(), may free page tables, this
> > > > +	 * needs force flush everything in the given range. Otherwise this
> > > > +	 * may result in having stale TLB entries for some architectures,
> > > > +	 * e.g. aarch64, that could specify flush what level TLB.
> > > >   	 */
> > > > -	if (mm_tlb_flush_nested(tlb->mm)) {
> > > > -		__tlb_reset_range(tlb);
> > > > -		__tlb_adjust_range(tlb, start, end - start);
> > > > +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->fullmm) {
> > > > +		/*
> > > > +		 * Since we can't tell what we actually should have
> > > > +		 * flushed, flush everything in the given range.
> > > > +		 */
> > > > +		tlb->freed_tables = 1;
> > > > +		tlb->cleared_ptes = 1;
> > > > +		tlb->cleared_pmds = 1;
> > > > +		tlb->cleared_puds = 1;
> > > > +		tlb->cleared_p4ds = 1;
> > > > +
> > > > +		/*
> > > > +		 * Some architectures, e.g. ARM, that have range invalidation
> > > > +		 * and care about VM_EXEC for I-Cache invalidation, need force
> > > > +		 * vma_exec set.
> > > > +		 */
> > > > +		tlb->vma_exec = 1;
> > > > +
> > > > +		/* Force vma_huge clear to guarantee safer flush */
> > > > +		tlb->vma_huge = 0;
> > > > +
> > > > +		tlb->start = start;
> > > > +		tlb->end = end;
> > > >   	}
> > > Whilst I think this is correct, it would be interesting to see whether
> > > or not it's actually faster than just nuking the whole mm, as I mentioned
> > > before.
> > > 
> > > At least in terms of getting a short-term fix, I'd prefer the diff below
> > > if it's not measurably worse.
> > 
> > I did a quick test with ebizzy (96 threads with 5 iterations) on my x86 VM,
> > it shows slightly slowdown on records/s but much more sys time spent with
> > fullmm flush, the below is the data.
> > 
> >                                     nofullmm                 fullmm
> > ops (records/s)              225606                  225119
> > sys (s)                            0.69                        1.14
> > 
> > It looks the slight reduction of records/s is caused by the increase of sys
> > time.
> 
> That's not what I expected, and I'm unable to explain why moving to fullmm
> would /increase/ the system time. I would've thought the time spent doing
> the invalidation would decrease, with the downside that the TLB is cold
> when returning back to userspace.
> 

I tried ebizzy with various parameters (malloc vs mmap, ran it for hour),
but performance was very similar for both patches.

So, I was looking for workload that would demonstrate the largest difference.
Inspired by python xml-rpc, which can handle each request in new thread,
I tried following [1]:

16 threads, each looping 100k times over:
  mmap(16M)
  touch 1 page
  madvise(DONTNEED)
  munmap(16M)

This yields quite significant difference for 2 patches when running on
my 46 CPU arm host. I checked it twice - applied patch, recompiled, rebooted,
but numbers stayed +- couple seconds the same.

Does it somewhat match your expectation?

v2 patch
---------
real    2m33.460s
user    0m3.359s
sys     15m32.307s

real    2m33.895s
user    0m2.749s
sys     16m34.500s

real    2m35.666s
user    0m3.528s
sys     15m23.377s

real    2m32.898s
user    0m2.789s
sys     16m18.801s

real    2m33.087s
user    0m3.565s
sys     16m23.815s


fullmm version
---------------
real    0m46.811s
user    0m1.596s
sys     1m47.500s

real    0m47.322s
user    0m1.803s
sys     1m48.449s

real    0m46.668s
user    0m1.508s
sys     1m47.352s

real    0m46.742s
user    0m2.007s
sys     1m47.217s

real    0m46.948s
user    0m1.785s
sys     1m47.906s

[1] https://github.com/jstancek/reproducers/blob/master/kernel/page_fault_stall/mmap8.c
