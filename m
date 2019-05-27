Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E78C2B2A8
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 13:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfE0LCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 07:02:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38578 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfE0LCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 07:02:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I9whSJ2VinrW0j3NLJnV4czQ9WVdxEQjVEVjPGpiMfI=; b=kH/AvUKzkvxmQ0xeKEtGJQjXo
        L4GnvZPQK38lbMuLD8dBvpWFEGMIDXjawFj90pc13o/wfHa/egp02W4LPvZtSb1B30ewCzSPQrrAj
        s4sz3F00etWwX8LtHC/8zsx3plBdS8t0Dm54BQ3tzvspXNwaOXKi6X3KrWKzeJjP7S5JqB6eiROs1
        tVArlrf4n0hI0w+uZgLVG6wenTXfAaFkJEozJXvgLSXgaxxZjLKashvAywWL5dmzdfLi1YyBLQb/X
        qs7geaVhhV5zPt6RC31ABngjdlDIaD528FnuzP7K1FcyLlFs0K30+zjsoi6o1SJAKF3GthvX/9gjL
        dQpTwrHKA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hVDOC-0002WO-3f; Mon, 27 May 2019 11:02:00 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D20BE2027F766; Mon, 27 May 2019 13:01:58 +0200 (CEST)
Date:   Mon, 27 May 2019 13:01:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, will.deacon@arm.com,
        stable@vger.kernel.org, npiggin@gmail.com, namit@vmware.com,
        minchan@kernel.org, mgorman@suse.de, jstancek@redhat.com,
        aneesh.kumar@linux.ibm.com, yang.shi@linux.alibaba.com
Subject: Re: + mm-mmu_gather-remove-__tlb_reset_range-for-force-flush.patch
 added to -mm tree
Message-ID: <20190527110158.GB2623@hirez.programming.kicks-ass.net>
References: <20190521231833.P5ThR%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521231833.P5ThR%akpm@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 04:18:33PM -0700, akpm@linux-foundation.org wrote:
> --- a/mm/mmu_gather.c~mm-mmu_gather-remove-__tlb_reset_range-for-force-flush
> +++ a/mm/mmu_gather.c
> @@ -245,14 +245,28 @@ void tlb_finish_mmu(struct mmu_gather *t
>  {
>  	/*
>  	 * If there are parallel threads are doing PTE changes on same range
> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> -	 * flush by batching, a thread has stable TLB entry can fail to flush
> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> -	 * forcefully if we detect parallel PTE batching threads.
> +	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
> +	 * flush by batching, one thread may end up seeing inconsistent PTEs
> +	 * and result in having stale TLB entries.  So flush TLB forcefully
> +	 * if we detect parallel PTE batching threads.
> +	 *
> +	 * However, some syscalls, e.g. munmap(), may free page tables, this
> +	 * needs force flush everything in the given range. Otherwise this
> +	 * may result in having stale TLB entries for some architectures,
> +	 * e.g. aarch64, that could specify flush what level TLB.
>  	 */
>  	if (mm_tlb_flush_nested(tlb->mm)) {
> +		/*
> +		 * The aarch64 yields better performance with fullmm by
> +		 * avoiding multiple CPUs spamming TLBI messages at the
> +		 * same time.
> +		 *
> +		 * On x86 non-fullmm doesn't yield significant difference
> +		 * against fullmm.
> +		 */ 
> +		tlb->fullmm = 1;
>  		__tlb_reset_range(tlb);
> -		__tlb_adjust_range(tlb, start, end - start);
> +		tlb->freed_tables = 1;
>  	}
>  
>  	tlb_flush_mmu(tlb);

Nick, Aneesh, can we now do this?

---

diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 4d841369399f..8d28b83914cb 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -881,39 +881,6 @@ void radix__tlb_flush(struct mmu_gather *tlb)
 	 */
 	if (tlb->fullmm) {
 		__flush_all_mm(mm, true);
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
-	} else if (mm_tlb_flush_nested(mm)) {
-		/*
-		 * If there is a concurrent invalidation that is clearing ptes,
-		 * then it's possible this invalidation will miss one of those
-		 * cleared ptes and miss flushing the TLB. If this invalidate
-		 * returns before the other one flushes TLBs, that can result
-		 * in it returning while there are still valid TLBs inside the
-		 * range to be invalidated.
-		 *
-		 * See mm/memory.c:tlb_finish_mmu() for more details.
-		 *
-		 * The solution to this is ensure the entire range is always
-		 * flushed here. The problem for powerpc is that the flushes
-		 * are page size specific, so this "forced flush" would not
-		 * do the right thing if there are a mix of page sizes in
-		 * the range to be invalidated. So use __flush_tlb_range
-		 * which invalidates all possible page sizes in the range.
-		 *
-		 * PWC flush probably is not be required because the core code
-		 * shouldn't free page tables in this path, but accounting
-		 * for the possibility makes us a bit more robust.
-		 *
-		 * need_flush_all is an uncommon case because page table
-		 * teardown should be done with exclusive locks held (but
-		 * after locks are dropped another invalidate could come
-		 * in), it could be optimized further if necessary.
-		 */
-		if (!tlb->need_flush_all)
-			__radix__flush_tlb_range(mm, start, end, true);
-		else
-			radix__flush_all_mm(mm);
-#endif
 	} else if ( (psize = radix_get_mmu_psize(page_size)) == -1) {
 		if (!tlb->need_flush_all)
 			radix__flush_tlb_mm(mm);

