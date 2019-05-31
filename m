Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574A530C07
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfEaJtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 05:49:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59354 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfEaJtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 05:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=K3k1VAarhMfMRUvAQT9gKdYaQHSyI+5eH98KEAZFo2I=; b=KwlrwascO32UIyKm2tYcDV94u
        B5UHTCXyTyIrR6MTCWMhwcQfaGc3wpuBQEHNBf5K10RfjZfKAbW+Yx8m5D1d030gX2eo1irx72XOq
        y5ll0lwxI7OZjIqQlR/OkYpavIRf/xAw5H3dQdxFIOqCEzdOrJ/kzmR4zMdXMfrY3QwV/Woa60+vd
        pB3SQFFijhIsk9VX/9+By8Ca1uSdzaGs3taMZ4dwMPbT3fnmY/2XShgmWpoZKd5KYqzqs7mng323V
        iEhdzoNYdEbaG8VOXSEqoIgAYyAiO3CcenmNdPtI6TUWg8OmP6QL9cEDXEDHsdK/bvdTPrqpjIxAH
        EhZcuuONw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hWeAH-0003h8-SD; Fri, 31 May 2019 09:49:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 528C4201D5AB1; Fri, 31 May 2019 11:49:31 +0200 (CEST)
Date:   Fri, 31 May 2019 11:49:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        akpm@linux-foundation.org, jstancek@redhat.com, mgorman@suse.de,
        minchan@kernel.org, mm-commits@vger.kernel.org, namit@vmware.com,
        stable@vger.kernel.org, will.deacon@arm.com,
        yang.shi@linux.alibaba.com
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
Message-ID: <20190531094931.GM2623@hirez.programming.kicks-ass.net>
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
 <20190527110158.GB2623@hirez.programming.kicks-ass.net>
 <335de44e-02f5-ce92-c026-e8ac4a34a766@linux.ibm.com>
 <20190527142552.GD2623@hirez.programming.kicks-ass.net>
 <1559270298.wiy8c3d4zs.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559270298.wiy8c3d4zs.astroid@bobo.none>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 12:46:56PM +1000, Nicholas Piggin wrote:
> Peter Zijlstra's on May 28, 2019 12:25 am:
> > On Mon, May 27, 2019 at 06:59:08PM +0530, Aneesh Kumar K.V wrote:
> >> On 5/27/19 4:31 PM, Peter Zijlstra wrote:
> >> > On Tue, May 21, 2019 at 04:18:33PM -0700, akpm@linux-foundation.org wrote:
> >> > > --- a/mm/mmu_gather.c~mm-mmu_gather-remove-__tlb_reset_range-for-force-flush
> >> > > +++ a/mm/mmu_gather.c
> >> > > @@ -245,14 +245,28 @@ void tlb_finish_mmu(struct mmu_gather *t
> >> > >   {
> >> > >   	/*
> >> > >   	 * If there are parallel threads are doing PTE changes on same range
> >> > > -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> >> > > -	 * flush by batching, a thread has stable TLB entry can fail to flush
> >> > > -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> >> > > -	 * forcefully if we detect parallel PTE batching threads.
> >> > > +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> >> > > +	 * flush by batching, one thread may end up seeing inconsistent PTEs
> >> > > +	 * and result in having stale TLB entries.  So flush TLB forcefully
> >> > > +	 * if we detect parallel PTE batching threads.
> >> > > +	 *
> >> > > +	 * However, some syscalls, e.g. munmap(), may free page tables, this
> >> > > +	 * needs force flush everything in the given range. Otherwise this
> >> > > +	 * may result in having stale TLB entries for some architectures,
> >> > > +	 * e.g. aarch64, that could specify flush what level TLB.
> >> > >   	 */
> >> > >   	if (mm_tlb_flush_nested(tlb->mm)) {
> >> > > +		/*
> >> > > +		 * The aarch64 yields better performance with fullmm by
> >> > > +		 * avoiding multiple CPUs spamming TLBI messages at the
> >> > > +		 * same time.
> >> > > +		 *
> >> > > +		 * On x86 non-fullmm doesn't yield significant difference
> >> > > +		 * against fullmm.
> >> > > +		 */
> >> > > +		tlb->fullmm = 1;
> >> > >   		__tlb_reset_range(tlb);
> >> > > -		__tlb_adjust_range(tlb, start, end - start);
> >> > > +		tlb->freed_tables = 1;
> >> > >   	}
> >> > >   	tlb_flush_mmu(tlb);

> > Maybe, but given the patch that went into -mm, PPC will never hit that
> > branch I killed anymore -- and that really shouldn't be in architecture
> > code anyway.
> 
> Yeah well if mm/ does this then sure it's dead and can go.
> 
> I don't think it's very nice to set fullmm and freed_tables for this 
> case though. Is this concurrent zapping an important fast path? It
> must have been, in order to justify all this complexity to the mm, so
> we don't want to tie this boat anchor to it AFAIKS?

I'm not convinced its an important fast path, afaict it is an
unfortunate correctness issue caused by allowing concurrenct frees.

> Is the problem just that the freed page tables flags get cleared by
> __tlb_reset_range()? Why not just remove that then, so the bits are
> set properly for the munmap?

That's insufficient; as argued in my initial suggestion:

  https://lkml.kernel.org/r/20190509103813.GP2589@hirez.programming.kicks-ass.net

Since we don't know what was flushed by the concorrent flushes, we must
flush all state (page sizes, tables etc..).

But it looks like benchmarks (for the one test-case we have) seem to
favour flushing the world over flushing a smaller range.


