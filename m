Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B83D0FBA
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 15:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfJINNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 09:13:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:37200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731145AbfJINNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 09:13:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD171ABCB;
        Wed,  9 Oct 2019 13:13:13 +0000 (UTC)
Subject: Re: [PATCH v2 6/8] mm: prevent get_user_pages() from overflowing page
 refcount
To:     Ajay Kaher <akaher@vmware.com>, gregkh@linuxfoundation.org
Cc:     torvalds@linux-foundation.org, punit.agrawal@arm.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        willy@infradead.org, will.deacon@arm.com, mszeredi@redhat.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        bvikas@vmware.com, anishs@vmware.com, vsirnapalli@vmware.com,
        srostedt@vmware.com, stable@kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
References: <1570581863-12090-1-git-send-email-akaher@vmware.com>
 <1570581863-12090-7-git-send-email-akaher@vmware.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f899be71-4bc0-d07b-f650-d85a335cdebb@suse.cz>
Date:   Wed, 9 Oct 2019 15:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <1570581863-12090-7-git-send-email-akaher@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/9/19 2:44 AM, Ajay Kaher wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 8fde12ca79aff9b5ba951fce1a2641901b8d8e64 upstream.
> 
> If the page refcount wraps around past zero, it will be freed while
> there are still four billion references to it.  One of the possible
> avenues for an attacker to try to make this happen is by doing direct IO
> on a page multiple times.  This patch makes get_user_pages() refuse to
> take a new page reference if there are already more than two billion
> references to the page.
> 
> Reported-by: Jann Horn <jannh@google.com>
> Acked-by: Matthew Wilcox <willy@infradead.org>
> Cc: stable@kernel.org
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [ 4.4.y backport notes:
>   Ajay: Added local variable 'err' with-in follow_hugetlb_page()
>         from 2be7cfed995e, to resolve compilation error
>   Srivatsa: Replaced call to get_page_foll() with try_get_page_foll() ]
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  mm/gup.c     | 43 ++++++++++++++++++++++++++++++++-----------
>  mm/hugetlb.c | 16 +++++++++++++++-
>  2 files changed, 47 insertions(+), 12 deletions(-)

This seems to have the same issue as the 4.9 stable version [1], in not
touching the arch-specific gup.c variants.

[1]
https://lore.kernel.org/lkml/6650323f-dbc9-f069-000b-f6b0f941a065@suse.cz/

> diff --git a/mm/gup.c b/mm/gup.c
> index fae4d1e..171b460 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -126,8 +126,12 @@ retry:
>  		}
>  	}
>  
> -	if (flags & FOLL_GET)
> -		get_page_foll(page);
> +	if (flags & FOLL_GET) {
> +		if (unlikely(!try_get_page_foll(page))) {
> +			page = ERR_PTR(-ENOMEM);
> +			goto out;
> +		}
> +	}
>  	if (flags & FOLL_TOUCH) {
>  		if ((flags & FOLL_WRITE) &&
>  		    !pte_dirty(pte) && !PageDirty(page))
> @@ -289,7 +293,10 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
>  			goto unmap;
>  		*page = pte_page(*pte);
>  	}
> -	get_page(*page);
> +	if (unlikely(!try_get_page(*page))) {
> +		ret = -ENOMEM;
> +		goto unmap;
> +	}
>  out:
>  	ret = 0;
>  unmap:
> @@ -1053,6 +1060,20 @@ struct page *get_dump_page(unsigned long addr)
>   */
>  #ifdef CONFIG_HAVE_GENERIC_RCU_GUP
>  
> +/*
> + * Return the compund head page with ref appropriately incremented,
> + * or NULL if that failed.
> + */
> +static inline struct page *try_get_compound_head(struct page *page, int refs)
> +{
> +	struct page *head = compound_head(page);
> +	if (WARN_ON_ONCE(atomic_read(&head->_count) < 0))
> +		return NULL;
> +	if (unlikely(!page_cache_add_speculative(head, refs)))
> +		return NULL;
> +	return head;
> +}
> +
>  #ifdef __HAVE_ARCH_PTE_SPECIAL
>  static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>  			 int write, struct page **pages, int *nr)
> @@ -1082,9 +1103,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>  
>  		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  		page = pte_page(pte);
> -		head = compound_head(page);
>  
> -		if (!page_cache_get_speculative(head))
> +		head = try_get_compound_head(page, 1);
> +		if (!head)
>  			goto pte_unmap;
>  
>  		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
> @@ -1141,8 +1162,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  
> -	head = compound_head(pmd_page(orig));
> -	if (!page_cache_add_speculative(head, refs)) {
> +	head = try_get_compound_head(pmd_page(orig), refs);
> +	if (!head) {
>  		*nr -= refs;
>  		return 0;
>  	}
> @@ -1187,8 +1208,8 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  
> -	head = compound_head(pud_page(orig));
> -	if (!page_cache_add_speculative(head, refs)) {
> +	head = try_get_compound_head(pud_page(orig), refs);
> +	if (!head) {
>  		*nr -= refs;
>  		return 0;
>  	}
> @@ -1229,8 +1250,8 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  
> -	head = compound_head(pgd_page(orig));
> -	if (!page_cache_add_speculative(head, refs)) {
> +	head = try_get_compound_head(pgd_page(orig), refs);
> +	if (!head) {
>  		*nr -= refs;
>  		return 0;
>  	}
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index fd932e7..3a1501e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3886,6 +3886,7 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	unsigned long vaddr = *position;
>  	unsigned long remainder = *nr_pages;
>  	struct hstate *h = hstate_vma(vma);
> +	int err = -EFAULT;
>  
>  	while (vaddr < vma->vm_end && remainder) {
>  		pte_t *pte;
> @@ -3957,6 +3958,19 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  
>  		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
>  		page = pte_page(huge_ptep_get(pte));
> +
> +		/*
> +		 * Instead of doing 'try_get_page_foll()' below in the same_page
> +		 * loop, just check the count once here.
> +		 */
> +		if (unlikely(page_count(page) <= 0)) {
> +			if (pages) {
> +				spin_unlock(ptl);
> +				remainder = 0;
> +				err = -ENOMEM;
> +				break;
> +			}
> +		}
>  same_page:
>  		if (pages) {
>  			pages[i] = mem_map_offset(page, pfn_offset);
> @@ -3983,7 +3997,7 @@ same_page:
>  	*nr_pages = remainder;
>  	*position = vaddr;
>  
> -	return i ? i : -EFAULT;
> +	return i ? i : err;
>  }
>  
>  unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
> 

