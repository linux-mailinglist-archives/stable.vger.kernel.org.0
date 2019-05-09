Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B49D186DA
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 10:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfEIIho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 04:37:44 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:34174 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfEIIhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 04:37:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B800374;
        Thu,  9 May 2019 01:37:43 -0700 (PDT)
Received: from brain-police (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D54E3F575;
        Thu,  9 May 2019 01:37:40 -0700 (PDT)
Date:   Thu, 9 May 2019 09:37:26 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>, peterz@infradead.org
Cc:     jstancek@redhat.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190509083726.GA2209@brain-police>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all, [+Peter]

Apologies for the delay; I'm attending a conference this week so it's tricky
to keep up with email.

On Wed, May 08, 2019 at 05:34:49AM +0800, Yang Shi wrote:
> A few new fields were added to mmu_gather to make TLB flush smarter for
> huge page by telling what level of page table is changed.
> 
> __tlb_reset_range() is used to reset all these page table state to
> unchanged, which is called by TLB flush for parallel mapping changes for
> the same range under non-exclusive lock (i.e. read mmap_sem).  Before
> commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
> munmap"), MADV_DONTNEED is the only one who may do page zapping in
> parallel and it doesn't remove page tables.  But, the forementioned commit
> may do munmap() under read mmap_sem and free page tables.  This causes a
> bug [1] reported by Jan Stancek since __tlb_reset_range() may pass the
> wrong page table state to architecture specific TLB flush operations.

Yikes. Is it actually safe to run free_pgtables() concurrently for a given
mm?

> So, removing __tlb_reset_range() sounds sane.  This may cause more TLB
> flush for MADV_DONTNEED, but it should be not called very often, hence
> the impact should be negligible.
> 
> The original proposed fix came from Jan Stancek who mainly debugged this
> issue, I just wrapped up everything together.

I'm still paging the nested flush logic back in, but I have some comments on
the patch below.

> [1] https://lore.kernel.org/linux-mm/342bf1fd-f1bf-ed62-1127-e911b5032274@linux.alibaba.com/T/#m7a2ab6c878d5a256560650e56189cfae4e73217f
> 
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Tested-by: Jan Stancek <jstancek@redhat.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> Signed-off-by: Jan Stancek <jstancek@redhat.com>
> ---
>  mm/mmu_gather.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 99740e1..9fd5272 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -249,11 +249,12 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>  	 * flush by batching, a thread has stable TLB entry can fail to flush

Urgh, we should rewrite this comment while we're here so that it makes sense...

>  	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
>  	 * forcefully if we detect parallel PTE batching threads.
> +	 *
> +	 * munmap() may change mapping under non-excluse lock and also free
> +	 * page tables.  Do not call __tlb_reset_range() for it.
>  	 */
> -	if (mm_tlb_flush_nested(tlb->mm)) {
> -		__tlb_reset_range(tlb);
> +	if (mm_tlb_flush_nested(tlb->mm))
>  		__tlb_adjust_range(tlb, start, end - start);
> -	}

I don't think we can elide the call __tlb_reset_range() entirely, since I
think we do want to clear the freed_pXX bits to ensure that we walk the
range with the smallest mapping granule that we have. Otherwise couldn't we
have a problem if we hit a PMD that had been cleared, but the TLB
invalidation for the PTEs that used to be linked below it was still pending?

Perhaps we should just set fullmm if we see that here's a concurrent
unmapper rather than do a worst-case range invalidation. Do you have a feeling
for often the mm_tlb_flush_nested() triggers in practice?

Will
