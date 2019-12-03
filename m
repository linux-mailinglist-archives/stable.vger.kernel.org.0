Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A810FD87
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLCMXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:23:03 -0500
Received: from imap1.codethink.co.uk ([176.9.8.82]:39981 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLCMXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 07:23:03 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1ic7Cl-0000E5-7a; Tue, 03 Dec 2019 12:22:59 +0000
Message-ID: <645311d0c03b3ae4604ac297e15af6471a6b0fb4.camel@codethink.co.uk>
Subject: Re: [PATCH STABLE 4.9 1/1] mm, gup: add missing refcount overflow
 checks on x86 and s390
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Ajay Kaher <akaher@vmware.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 03 Dec 2019 12:22:58 +0000
In-Reply-To: <20191129090351.3507-2-vbabka@suse.cz>
References: <20191129090351.3507-1-vbabka@suse.cz>
         <20191129090351.3507-2-vbabka@suse.cz>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-11-29 at 10:03 +0100, Vlastimil Babka wrote:
> The mainline commit 8fde12ca79af ("mm: prevent get_user_pages() from
> overflowing page refcount") was backported to 4.9.y stable as commit
> 2ed768cfd895. The backport however missed that in 4.9, there are several
> arch-specific gup.c versions with fast gup implementations, so these do not
> prevent refcount overflow.
> 
> This is partially fixed for x86 in stable-only commit d73af79742e7 ("x86, mm,
> gup: prevent get_page() race with munmap in paravirt guest"). This stable-only
> commit adds missing parts to x86 version, as well as s390 version, both taken
> from the SUSE SLES/openSUSE 4.12-based kernels.
> 
> The remaining architectures with own gup.c are sparc, mips, sh. It's unlikely
> the known overflow scenario based on FUSE, which needs 140GB of RAM, is a
> problem for those architectures, and I don't feel confident enough to patch
> them.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  arch/s390/mm/gup.c |  9 ++++++---
>  arch/x86/mm/gup.c  | 10 ++++++++--
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
> index 97fc449a7470..33a940389a6d 100644
> --- a/arch/s390/mm/gup.c
> +++ b/arch/s390/mm/gup.c
> @@ -38,7 +38,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
>  		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  		page = pte_page(pte);
>  		head = compound_head(page);
> -		if (!page_cache_get_speculative(head))
> +		if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)

No need for unlikely(); WARN_ON() includes that.

> +		    || !page_cache_get_speculative(head)))
>  			return 0;
>  		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
>  			put_page(head);
[...]
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -202,10 +202,12 @@ static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
>  			undo_dev_pagemap(nr, nr_start, pages);
>  			return 0;
>  		}
> +		if (unlikely(!try_get_page(page))) {
> +			put_dev_pagemap(pgmap);
> +			return 0;
> +		}
>  		SetPageReferenced(page);
>  		pages[*nr] = page;
> -		get_page(page);
> -		put_dev_pagemap(pgmap);

This leaks a pgmap reference on success!

>  		(*nr)++;
>  		pfn++;
>  	} while (addr += PAGE_SIZE, addr != end);
> @@ -230,6 +232,8 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
>  
>  	refs = 0;
>  	head = pmd_page(pmd);
> +	if (WARN_ON_ONCE(page_ref_count(head) <= 0))

Why <= 0, given we use < 0 elsewhere?

> +		return 0;
>  	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>  	do {
>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
> @@ -289,6 +293,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
>  
>  	refs = 0;
>  	head = pud_page(pud);
> +	if (WARN_ON_ONCE(page_ref_count(head) <= 0))

Same question here.

Ben.

> +		return 0;
>  	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>  	do {
>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

