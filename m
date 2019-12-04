Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD851137D3
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 23:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfLDWwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 17:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfLDWwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 17:52:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 072BE2245C;
        Wed,  4 Dec 2019 22:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575499964;
        bh=n8L4HjG0nstbb5b9L7QsBYJ4DJxlKRRjcjIL7qJTEVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w7DTbYL0lMEOlHXfnKBOVRMVuIrEbUX6D0T5WbW2lPNWDK3QXrDjXUHjB5hvRyC98
         J7wjLJlN7Y2LB6z04ZMBQtXbQJqLoOgvObidMg4kXETgmU9VNqJHbBs30KIyPE037+
         pUPjF6oPZc15pNtXsEZ9/IPD/20z9A/Mo65GaLOM=
Date:   Wed, 4 Dec 2019 23:52:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Ajay Kaher <akaher@vmware.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH STABLE ONLY] add missing page refcount overflow checks
Message-ID: <20191204225241.GA3715390@kroah.com>
References: <20191129090351.3507-1-vbabka@suse.cz>
 <20191201165510.GT5861@sasha-vm>
 <c53e1e47-f30a-3458-42d6-4c09ba937a7d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c53e1e47-f30a-3458-42d6-4c09ba937a7d@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 01:50:26PM +0100, Vlastimil Babka wrote:
> On 12/1/19 5:55 PM, Sasha Levin wrote:
> > On Fri, Nov 29, 2019 at 10:03:48AM +0100, Vlastimil Babka wrote:
> >> This collection of patches add the missing overflow checks in arch-specific
> >> gup.c variants for x86 and s390. Those were missed in backport of 8fde12ca79af
> >> ("mm: prevent get_user_pages() from overflowing page refcount") as mainline
> >> had a single gup.c implementation at that point. See individual patches for
> >> details.
> > 
> > Queued up, thanks!
> 
> Please replace the 4.9 version with the following fixed one, thanks to Ben:
> 
> ----8<----
> >From fe7f18bd152094f8516d79e847fcb5453a6f8368 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Wed, 6 Nov 2019 16:32:57 +0100
> Subject: [PATCH] mm, gup: add missing refcount overflow checks on x86 and s390
> 
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
>  arch/s390/mm/gup.c | 9 ++++++---
>  arch/x86/mm/gup.c  | 9 ++++++++-
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
> index 97fc449a7470..cf045f56581e 100644
> --- a/arch/s390/mm/gup.c
> +++ b/arch/s390/mm/gup.c
> @@ -38,7 +38,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
>  		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  		page = pte_page(pte);
>  		head = compound_head(page);
> -		if (!page_cache_get_speculative(head))
> +		if (WARN_ON_ONCE(page_ref_count(head) < 0)
> +		    || !page_cache_get_speculative(head))
>  			return 0;
>  		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
>  			put_page(head);
> @@ -76,7 +77,8 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  
> -	if (!page_cache_add_speculative(head, refs)) {
> +	if (WARN_ON_ONCE(page_ref_count(head) < 0)
> +	    || !page_cache_add_speculative(head, refs)) {
>  		*nr -= refs;
>  		return 0;
>  	}
> @@ -150,7 +152,8 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  
> -	if (!page_cache_add_speculative(head, refs)) {
> +	if (WARN_ON_ONCE(page_ref_count(head) < 0)
> +	    || !page_cache_add_speculative(head, refs)) {
>  		*nr -= refs;
>  		return 0;
>  	}
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index d7db45bdfb3b..82f727fbbbd2 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -202,9 +202,12 @@ static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
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
>  		put_dev_pagemap(pgmap);
>  		(*nr)++;
>  		pfn++;
> @@ -230,6 +233,8 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
>  
>  	refs = 0;
>  	head = pmd_page(pmd);
> +	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
> +		return 0;
>  	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>  	do {
>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
> @@ -289,6 +294,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
>  
>  	refs = 0;
>  	head = pud_page(pud);
> +	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
> +		return 0;
>  	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>  	do {
>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
> -- 
> 2.24.0
> 
> 
> 

Now updated, sorry I missed this earlier.

greg k-h
