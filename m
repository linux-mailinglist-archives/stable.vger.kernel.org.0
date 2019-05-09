Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A8A1931D
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfEIT4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:56:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59868 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfEIT4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 15:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ot8IQXIdycRfbnAGWMYEHNduuMkLuyWPm0ppqN5UQU8=; b=sjWzpAf+RG2sk7Xun0Y3JguxV
        Clw1VlgAF/0VHkox15p7PkRgGlnwoIoavF+resBPd0UAGNn4gi97iGsnxZirGpFCSa6ap5WOqu0XI
        4JQ+eSoyPMii+x8peXrFm/WTEcesMShFMutGTh4ovK/0s7M+xAiz5DLPpslbg6CuvDwEGl4th5As8
        +leYhoatWAVVGYkU4jZkU+mLA/BrV9kLnkCKewWS/Xkrxw6sp81AOu3UUPhSV6CLlwmEsuGcmR/3U
        9LDMxX6avTpVNSNJkBEsIXjtiaaqgiGrqCaoTO6DA3FHyal3Wgqo28gxNRm9WTA1u4U/D3QzaRrrD
        w+Xph81gQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hOp9T-00066y-M8; Thu, 09 May 2019 19:56:23 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3640623E95D36; Thu,  9 May 2019 21:56:21 +0200 (CEST)
Date:   Thu, 9 May 2019 21:56:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, jstancek@redhat.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        aneesh.kumar@linux.vnet.ibm.com, npiggin@gmail.com,
        namit@vmware.com, minchan@kernel.org, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190509195621.GM2650@hirez.programming.kicks-ass.net>
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

So PPC-radix has page-size dependent TLBI, but the above doesn't work
for them, because they use the tlb_change_page_size() interface and
don't look at tlb->cleared_p*().

Concequently, they have their own special magic :/

Nick, how about you use the tlb_change_page_size() interface to
find/flush on the page-size boundaries, but otherwise use the
tlb->cleared_p* flags to select which actual sizes to flush?

AFAICT that should work just fine for you guys. Maybe something like so?

(fwiw, there's an aweful lot of almost identical functions there)

---

diff --git a/arch/powerpc/mm/tlb-radix.c b/arch/powerpc/mm/tlb-radix.c
index 6a23b9ebd2a1..efc99ef78db6 100644
--- a/arch/powerpc/mm/tlb-radix.c
+++ b/arch/powerpc/mm/tlb-radix.c
@@ -692,7 +692,7 @@ static unsigned long tlb_local_single_page_flush_ceiling __read_mostly = POWER9_
 
 static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 					unsigned long start, unsigned long end,
-					bool flush_all_sizes)
+					bool pflush, bool hflush, bool gflush)
 
 {
 	unsigned long pid;
@@ -734,14 +734,9 @@ static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 				_tlbie_pid(pid, RIC_FLUSH_TLB);
 		}
 	} else {
-		bool hflush = flush_all_sizes;
-		bool gflush = flush_all_sizes;
 		unsigned long hstart, hend;
 		unsigned long gstart, gend;
 
-		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-			hflush = true;
-
 		if (hflush) {
 			hstart = (start + PMD_SIZE - 1) & PMD_MASK;
 			hend = end & PMD_MASK;
@@ -758,7 +753,9 @@ static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 
 		asm volatile("ptesync": : :"memory");
 		if (local) {
-			__tlbiel_va_range(start, end, pid, page_size, mmu_virtual_psize);
+			if (pflush)
+				__tlbiel_va_range(start, end, pid,
+						page_size, mmu_virtual_psize);
 			if (hflush)
 				__tlbiel_va_range(hstart, hend, pid,
 						PMD_SIZE, MMU_PAGE_2M);
@@ -767,7 +764,9 @@ static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 						PUD_SIZE, MMU_PAGE_1G);
 			asm volatile("ptesync": : :"memory");
 		} else {
-			__tlbie_va_range(start, end, pid, page_size, mmu_virtual_psize);
+			if (pflush)
+				__tlbie_va_range(start, end, pid,
+						page_size, mmu_virtual_psize);
 			if (hflush)
 				__tlbie_va_range(hstart, hend, pid,
 						PMD_SIZE, MMU_PAGE_2M);
@@ -785,12 +784,17 @@ void radix__flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end)
 
 {
+	bool hflush = false;
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (is_vm_hugetlb_page(vma))
 		return radix__flush_hugetlb_tlb_range(vma, start, end);
 #endif
 
-	__radix__flush_tlb_range(vma->vm_mm, start, end, false);
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		hflush = true;
+
+	__radix__flush_tlb_range(vma->vm_mm, start, end, true, hflush, false);
 }
 EXPORT_SYMBOL(radix__flush_tlb_range);
 
@@ -881,49 +885,14 @@ void radix__tlb_flush(struct mmu_gather *tlb)
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
-	} else if ( (psize = radix_get_mmu_psize(page_size)) == -1) {
-		if (!tlb->need_flush_all)
-			radix__flush_tlb_mm(mm);
-		else
-			radix__flush_all_mm(mm);
 	} else {
 		if (!tlb->need_flush_all)
-			radix__flush_tlb_range_psize(mm, start, end, psize);
+			__radix__flush_tlb_range(mm, start, end,
+					tlb->cleared_pte,
+				        tlb->cleared_pmd,
+					tlb->cleared_pud);
 		else
-			radix__flush_tlb_pwc_range_psize(mm, start, end, psize);
+			radix__flush_all_mm(mm);
 	}
 	tlb->need_flush_all = 0;
 }
