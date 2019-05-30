Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4163044F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 23:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfE3Vzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 17:55:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbfE3Vzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 17:55:45 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19481C058CBD;
        Thu, 30 May 2019 21:55:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07F731B466;
        Thu, 30 May 2019 21:55:36 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7CDD554D3C;
        Thu, 30 May 2019 21:55:33 +0000 (UTC)
Date:   Thu, 30 May 2019 17:55:33 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, will deacon <will.deacon@arm.com>,
        stable@vger.kernel.org, npiggin@gmail.com, namit@vmware.com,
        minchan@kernel.org, mgorman@suse.de,
        yang shi <yang.shi@linux.alibaba.com>,
        Jan Stancek <jstancek@redhat.com>
Message-ID: <958265315.25446907.1559253333301.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190527142552.GD2623@hirez.programming.kicks-ass.net>
References: <20190521231833.P5ThR%akpm@linux-foundation.org> <20190527110158.GB2623@hirez.programming.kicks-ass.net> <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com> <20190527142552.GD2623@hirez.programming.kicks-ass.net>
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.17.163, 10.4.195.12]
Thread-Topic: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch added to -mm tree
Thread-Index: M9HvFUE9BWXY9cWsyuEVZC3U3ZB4sA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 30 May 2019 21:55:44 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> On Mon, May 27, 2019 at 06:59:08PM +0530, Aneesh Kumar K.V wrote:
> > On 5/27/19 4:31 PM, Peter Zijlstra wrote:
> > > On Tue, May 21, 2019 at 04:18:33PM -0700, akpm@linux-foundation.org
> > > wrote:
> > > > ---
> > > > a/mm/mmu_gather.c~mm-mmu_gather-remove-__tlb_reset_range-for-force-flush
> > > > +++ a/mm/mmu_gather.c
> > > > @@ -245,14 +245,28 @@ void tlb_finish_mmu(struct mmu_gather *t
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
> > > >   	if (mm_tlb_flush_nested(tlb->mm)) {
> > > > +		/*
> > > > +		 * The aarch64 yields better performance with fullmm by
> > > > +		 * avoiding multiple CPUs spamming TLBI messages at the
> > > > +		 * same time.
> > > > +		 *
> > > > +		 * On x86 non-fullmm doesn't yield significant difference
> > > > +		 * against fullmm.
> > > > +		 */
> > > > +		tlb->fullmm = 1;
> > > >   		__tlb_reset_range(tlb);
> > > > -		__tlb_adjust_range(tlb, start, end - start);
> > > > +		tlb->freed_tables = 1;
> > > >   	}
> > > >   	tlb_flush_mmu(tlb);
> > > 
> > > Nick, Aneesh, can we now do this?
> > > 
> > > ---
> > > 
> > > diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c
> > > b/arch/powerpc/mm/book3s64/radix_tlb.c
> > > index 4d841369399f..8d28b83914cb 100644
> > > --- a/arch/powerpc/mm/book3s64/radix_tlb.c
> > > +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
> > > @@ -881,39 +881,6 @@ void radix__tlb_flush(struct mmu_gather *tlb)
> > >   	 */
> > >   	if (tlb->fullmm) {
> > >   		__flush_all_mm(mm, true);
> > > -#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
> > > -	} else if (mm_tlb_flush_nested(mm)) {
> > > -		/*
> > > -		 * If there is a concurrent invalidation that is clearing ptes,
> > > -		 * then it's possible this invalidation will miss one of those
> > > -		 * cleared ptes and miss flushing the TLB. If this invalidate
> > > -		 * returns before the other one flushes TLBs, that can result
> > > -		 * in it returning while there are still valid TLBs inside the
> > > -		 * range to be invalidated.
> > > -		 *
> > > -		 * See mm/memory.c:tlb_finish_mmu() for more details.
> > > -		 *
> > > -		 * The solution to this is ensure the entire range is always
> > > -		 * flushed here. The problem for powerpc is that the flushes
> > > -		 * are page size specific, so this "forced flush" would not
> > > -		 * do the right thing if there are a mix of page sizes in
> > > -		 * the range to be invalidated. So use __flush_tlb_range
> > > -		 * which invalidates all possible page sizes in the range.
> > > -		 *
> > > -		 * PWC flush probably is not be required because the core code
> > > -		 * shouldn't free page tables in this path, but accounting
> > > -		 * for the possibility makes us a bit more robust.
> > > -		 *
> > > -		 * need_flush_all is an uncommon case because page table
> > > -		 * teardown should be done with exclusive locks held (but
> > > -		 * after locks are dropped another invalidate could come
> > > -		 * in), it could be optimized further if necessary.
> > > -		 */
> > > -		if (!tlb->need_flush_all)
> > > -			__radix__flush_tlb_range(mm, start, end, true);
> > > -		else
> > > -			radix__flush_all_mm(mm);
> > > -#endif
> > >   	} else if ( (psize = radix_get_mmu_psize(page_size)) == -1) {
> > >   		if (!tlb->need_flush_all)
> > >   			radix__flush_tlb_mm(mm);
> > > 
> > 
> > 
> > I guess we can revert most of the commit
> > 02390f66bd2362df114a0a0770d80ec33061f6d1. That is the only place we flush
> > multiple page sizes? . But should we evaluate the performance impact of
> > that
> > fullmm flush on ppc64?

Hi,

I ran a test on ppc64le, using [1] as benchmark (it's same one that produced
aarch64 numbers in [2]):

16 threads, each looping 100k times over:
  mmap(16M)
  touch 1 page
  madvise(DONTNEED)
  munmap(16M)

10 runs averaged with and without v3 patch:

v5.2-rc2-24-gbec7550cca10
--------------------------
        mean     stddev
real    37.382   2.780
user     1.420   0.078
sys     54.658   1.855

v5.2-rc2-24-gbec7550cca10 + "mm: mmu_gather: remove __tlb_reset_range() for force flush"
-----------------------------------------------------------------------------------------
        mean     stddev
real    37.119   2.105
user     1.548   0.087
sys     55.698   1.357

Hardware
---------
Power9 Model 8335-GTH (ibm,witherspoon,128CPUs,256GB RAM,6 nodes).

cpu             : POWER9, altivec supported
clock           : 3300.000000MHz
revision        : 2.2 (pvr 004e 1202)

# numactl -H
available: 6 nodes (0,8,252-255)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
node 0 size: 130722 MB
node 0 free: 127327 MB
node 8 cpus: 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127
node 8 size: 130784 MB
node 8 free: 129864 MB
node 252 cpus:
node 252 size: 0 MB
node 252 free: 0 MB
node 253 cpus:
node 253 size: 0 MB
node 253 free: 0 MB
node 254 cpus:
node 254 size: 0 MB
node 254 free: 0 MB
node 255 cpus:
node 255 size: 0 MB
node 255 free: 0 MB
node distances:
node   0   8  252  253  254  255
  0:  10  40  80  80  80  80
  8:  40  10  80  80  80  80
 252:  80  80  10  80  80  80
 253:  80  80  80  10  80  80
 254:  80  80  80  80  10  80
 255:  80  80  80  80  80  10

Regards,
Jan

[1] https://github.com/jstancek/reproducers/blob/master/kernel/page_fault_stall/mmap8.c
[2] https://lore.kernel.org/linux-mm/1158926942.23199905.1558020575293.JavaMail.zimbra@redhat.com/

> 
> Maybe, but given the patch that went into -mm, PPC will never hit that
> branch I killed anymore -- and that really shouldn't be in architecture
> code anyway.
> 
> Also; as I noted last time: __radix___flush_tlb_range() and
> __radix__flush_tlb_range_psize() look similar enough that they might
> want to be a single function (and instead of @flush_all_sizes, have it
> take @gflush, @hflush, @flush and @pwc).
> 
