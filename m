Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9234031C1A8
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhBOSiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:38:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:34770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhBOSiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 13:38:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32CBCACD4;
        Mon, 15 Feb 2021 18:37:21 +0000 (UTC)
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Jann Horn <jannh@google.com>, Nicolai Stange <nstange@suse.de>,
        Michal Hocko <mhocko@kernel.org>
References: <20200619141620.148019466@linuxfoundation.org>
 <20200619141625.314982137@linuxfoundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 4.9 098/128] mm: thp: make the THP mapcount atomic against
 __split_huge_pmd_locked()
Message-ID: <26569718-050f-fc90-e3ac-79edfaae9ac7@suse.cz>
Date:   Mon, 15 Feb 2021 19:37:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20200619141625.314982137@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/19/20 4:33 PM, Greg Kroah-Hartman wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> commit c444eb564fb16645c172d550359cb3d75fe8a040 upstream.
> 
> Write protect anon page faults require an accurate mapcount to decide
> if to break the COW or not. This is implemented in the THP path with
> reuse_swap_page() ->
> page_trans_huge_map_swapcount()/page_trans_huge_mapcount().
> 
> If the COW triggers while the other processes sharing the page are
> under a huge pmd split, to do an accurate reading, we must ensure the
> mapcount isn't computed while it's being transferred from the head
> page to the tail pages.
> 
> reuse_swap_cache() already runs serialized by the page lock, so it's
> enough to add the page lock around __split_huge_pmd_locked too, in
> order to add the missing serialization.
> 
> Note: the commit in "Fixes" is just to facilitate the backporting,
> because the code before such commit didn't try to do an accurate THP
> mapcount calculation and it instead used the page_count() to decide if
> to COW or not. Both the page_count and the pin_count are THP-wide
> refcounts, so they're inaccurate if used in
> reuse_swap_page(). Reverting such commit (besides the unrelated fix to
> the local anon_vma assignment) would have also opened the window for
> memory corruption side effects to certain workloads as documented in
> such commit header.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Suggested-by: Jann Horn <jannh@google.com>
> Reported-by: Jann Horn <jannh@google.com>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Fixes: 6d0a07edd17c ("mm: thp: calculate the mapcount correctly for THP pages during WP faults")
> Cc: stable@vger.kernel.org
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hi, when evaluating this backport for our 4.12 based kernel, Nicolai found out
that Jann's POC still triggers, AFAICS because do_huge_pmd_wp_page() doesn't
take the page lock, which was only added by ba3c4ce6def4 ("mm, THP, swap: make
reuse_swap_page() works for THP swapped out") in 4.14. The upstream stable 4.9
is thus in the same situation (didn't actually test the POC there, but should be
obvious), so this is a heads up.

Now just backporting ba3c4ce6def4 to 4.9 stable isn't that simple, as that's
part of a larger series (maybe with even more prerequisities, didn't check). I'm
considering just taking the part of ba3c4ce6def4 that's wrapping
page_trans_huge_mapcount() in the page lock (without changing it to
reuse_swap_page() and changing the latter to deal with swapped out THP) and will
look at it tomorrow. But suggestions (and/or later review) from Andrea/Kirill
are welcome.

Thanks,
Vlastimil

> ---
>  mm/huge_memory.c |   31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1755,6 +1755,8 @@ void __split_huge_pmd(struct vm_area_str
>  	spinlock_t *ptl;
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long haddr = address & HPAGE_PMD_MASK;
> +	bool was_locked = false;
> +	pmd_t _pmd;
>  
>  	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PMD_SIZE);
>  	ptl = pmd_lock(mm, pmd);
> @@ -1764,11 +1766,32 @@ void __split_huge_pmd(struct vm_area_str
>  	 * pmd against. Otherwise we can end up replacing wrong page.
>  	 */
>  	VM_BUG_ON(freeze && !page);
> -	if (page && page != pmd_page(*pmd))
> -	        goto out;
> +	if (page) {
> +		VM_WARN_ON_ONCE(!PageLocked(page));
> +		was_locked = true;
> +		if (page != pmd_page(*pmd))
> +			goto out;
> +	}
>  
> +repeat:
>  	if (pmd_trans_huge(*pmd)) {
> -		page = pmd_page(*pmd);
> +		if (!page) {
> +			page = pmd_page(*pmd);
> +			if (unlikely(!trylock_page(page))) {
> +				get_page(page);
> +				_pmd = *pmd;
> +				spin_unlock(ptl);
> +				lock_page(page);
> +				spin_lock(ptl);
> +				if (unlikely(!pmd_same(*pmd, _pmd))) {
> +					unlock_page(page);
> +					put_page(page);
> +					page = NULL;
> +					goto repeat;
> +				}
> +				put_page(page);
> +			}
> +		}
>  		if (PageMlocked(page))
>  			clear_page_mlock(page);
>  	} else if (!pmd_devmap(*pmd))
> @@ -1776,6 +1799,8 @@ void __split_huge_pmd(struct vm_area_str
>  	__split_huge_pmd_locked(vma, pmd, haddr, freeze);
>  out:
>  	spin_unlock(ptl);
> +	if (!was_locked && page)
> +		unlock_page(page);
>  	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PMD_SIZE);
>  }
>  
> 
> 
> 

