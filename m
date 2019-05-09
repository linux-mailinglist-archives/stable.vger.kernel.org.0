Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299041888F
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfEIKzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 06:55:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57240 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIKzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 06:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bxtS26xVOjMNdacI/cyf12bZjI1vE2fsrBEFKhrTk7g=; b=iDGKS2ppg8lbhcOC+BzYkdvjM
        z5i/B1R6hdkzVBmMJWHMxfFimmt4hdp3TzbU+MywQd+Xwu663pbMFF8BIv0Iarlkg/ymD1fSsC9bo
        6Zu8tuFyf6WvfJvQh+SKe+oHS378YgAqvmedIMRbj/Q6ReFedtC9T2QQJ7SFiF8Nkkvb4Ze5tbYGt
        lyKf09vFEeOoMkA7Tt3FgpN43Cdw0XE5U5EWAPI32slF+0IWwSfFHvJSta5SlAuhDVCMUcapq/mfh
        eU+riuTeHZPZqLqIcGmHqsuZW8z6GV8wszrd2pJXqjK14AKZpqVeiInwSygR0y95cUmGO4Ls9iavp
        xryW1hWcw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hOghM-0002T0-Bg; Thu, 09 May 2019 10:54:48 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D7A9220274AF5; Thu,  9 May 2019 12:54:46 +0200 (CEST)
Date:   Thu, 9 May 2019 12:54:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, jstancek@redhat.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com, npiggin@gmail.com,
        namit@vmware.com, minchan@kernel.org, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190509105446.GL2650@hirez.programming.kicks-ass.net>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509103813.GP2589@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 12:38:13PM +0200, Peter Zijlstra wrote:

> That's tlb->cleared_p*, and yes agreed. That is, right until some
> architecture has level dependent TLBI instructions, at which point we'll
> need to have them all set instead of cleared.

> Anyway; am I correct in understanding that the actual problem is that
> we've cleared freed_tables and the ARM64 tlb_flush() will then not
> invalidate the cache and badness happens?
> 
> Because so far nobody has actually provided a coherent description of
> the actual problem we're trying to solve. But I'm thinking something
> like the below ought to do.

There's another 'fun' issue I think. For architectures like ARM that
have range invalidation and care about VM_EXEC for I$ invalidation, the
below doesn't quite work right either.

I suspect we also have to force: tlb->vma_exec = 1.

And I don't think there's an architecture that cares, but depending on
details I can construct cases where any setting of tlb->vm_hugetlb is
wrong, so that is _awesome_. But I suspect the sane thing for now is to
force it 0.

> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 99740e1dd273..fe768f8d612e 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -244,15 +244,20 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>  		unsigned long start, unsigned long end)
>  {
>  	/*
> -	 * If there are parallel threads are doing PTE changes on same range
> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> -	 * flush by batching, a thread has stable TLB entry can fail to flush
> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> -	 * forcefully if we detect parallel PTE batching threads.
> +	 * Sensible comment goes here..
>  	 */
> -	if (mm_tlb_flush_nested(tlb->mm)) {
> -		__tlb_reset_range(tlb);
> -		__tlb_adjust_range(tlb, start, end - start);
> +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->full_mm) {
> +		/*
> +		 * Since we're can't tell what we actually should have
> +		 * flushed flush everything in the given range.
> +		 */
> +		tlb->start = start;
> +		tlb->end = end;
> +		tlb->freed_tables = 1;
> +		tlb->cleared_ptes = 1;
> +		tlb->cleared_pmds = 1;
> +		tlb->cleared_puds = 1;
> +		tlb->cleared_p4ds = 1;
>  	}
>  
>  	tlb_flush_mmu(tlb);
