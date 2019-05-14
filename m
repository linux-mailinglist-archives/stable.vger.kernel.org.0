Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF311C802
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 13:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfENLwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 07:52:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58238 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfENLwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 07:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kV9fT0KmOxuF+T41tUiDHBswBBV2DoIvK7WOkx75qek=; b=kDdgHx3228aF+DbfBwQD1cHRG
        u/MMbPjYEL0gI73Cjho8IW7rrNyWJy4SF3XGW94P8Iix0SV2SjWlCxAwbmOOTV6tTRG35LBFf4ipQ
        WmEQCqLcYVJNZRlMVG00mMJ3Qv2lX8Iz+NrAgp1/x5TvoLry+b+txJvm39UcpnKHKEv+LHnYevmog
        fegtKzNMW/YO31a+A3Y1v4wfIbgywog0U1mYkFEiP+JkWkud8tASItZBQ4YG4Ag6sY0EPevk/NcTD
        SZDLr79gKNk3xpJDx8ce5YhH5Q/HME7A5PGRbiT2hGoODErs/vd1MEby9pArSOAdz9E3f1/+6MSVm
        8NgwrlXfA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQVyr-0004nf-Bl; Tue, 14 May 2019 11:52:25 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D1F0D2029F877; Tue, 14 May 2019 13:52:23 +0200 (CEST)
Date:   Tue, 14 May 2019 13:52:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, jstancek@redhat.com,
        namit@vmware.com, minchan@kernel.org, mgorman@suse.de,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190514115223.GP2589@hirez.programming.kicks-ass.net>
References: <1557444414-12090-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190513163804.GB10754@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513163804.GB10754@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 05:38:04PM +0100, Will Deacon wrote:
> On Fri, May 10, 2019 at 07:26:54AM +0800, Yang Shi wrote:
> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> > index 99740e1..469492d 100644
> > --- a/mm/mmu_gather.c
> > +++ b/mm/mmu_gather.c
> > @@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> >  {
> >  	/*
> >  	 * If there are parallel threads are doing PTE changes on same range
> > +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> > +	 * flush by batching, one thread may end up seeing inconsistent PTEs
> > +	 * and result in having stale TLB entries.  So flush TLB forcefully
> > +	 * if we detect parallel PTE batching threads.
> > +	 *
> > +	 * However, some syscalls, e.g. munmap(), may free page tables, this
> > +	 * needs force flush everything in the given range. Otherwise this
> > +	 * may result in having stale TLB entries for some architectures,
> > +	 * e.g. aarch64, that could specify flush what level TLB.
> >  	 */
> > +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->fullmm) {
> > +		/*
> > +		 * Since we can't tell what we actually should have
> > +		 * flushed, flush everything in the given range.
> > +		 */
> > +		tlb->freed_tables = 1;
> > +		tlb->cleared_ptes = 1;
> > +		tlb->cleared_pmds = 1;
> > +		tlb->cleared_puds = 1;
> > +		tlb->cleared_p4ds = 1;
> > +
> > +		/*
> > +		 * Some architectures, e.g. ARM, that have range invalidation
> > +		 * and care about VM_EXEC for I-Cache invalidation, need force
> > +		 * vma_exec set.
> > +		 */
> > +		tlb->vma_exec = 1;
> > +
> > +		/* Force vma_huge clear to guarantee safer flush */
> > +		tlb->vma_huge = 0;
> > +
> > +		tlb->start = start;
> > +		tlb->end = end;
> >  	}
> 
> Whilst I think this is correct, it would be interesting to see whether
> or not it's actually faster than just nuking the whole mm, as I mentioned
> before.
> 
> At least in terms of getting a short-term fix, I'd prefer the diff below
> if it's not measurably worse.

So what point? General paranoia? Either change should allow PPC to get
rid of its magic mushrooms, the below would be a little bit easier for
them because they already do full invalidate correct.

> --->8
> 
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 99740e1dd273..cc251422d307 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -251,8 +251,9 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>  	 * forcefully if we detect parallel PTE batching threads.
>  	 */
>  	if (mm_tlb_flush_nested(tlb->mm)) {
> +		tlb->fullmm = 1;
>  		__tlb_reset_range(tlb);
> -		__tlb_adjust_range(tlb, start, end - start);
> +		tlb->freed_tables = 1;
>  	}
>  
>  	tlb_flush_mmu(tlb);
