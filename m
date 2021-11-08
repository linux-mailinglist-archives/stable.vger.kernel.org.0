Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF40447B86
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 09:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhKHIJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 03:09:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhKHIJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 03:09:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A486125F;
        Mon,  8 Nov 2021 08:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636358815;
        bh=wFrYQYcCiXXh+Q8kD72HnRRnPHObi25norI94Y6SVA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ccp3Rtr0sFzZ4+0tDqvlGKQSOu6k5EVraHHm+hAwHqH3GK4XOHPzZKKHsHdOD2J2j
         peh1zuMXSC1tf9CfJo55pj8xE5w44Fu2PfYwuwqnwXtH9BHqXcR9Fj3fLEGKukmz9G
         HQ4VgPwiRIWOf+YuJcC3+hz1NyZSe1W2f/nzkqZE=
Date:   Mon, 8 Nov 2021 09:06:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     naoya.horiguchi@nec.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        osalvador@suse.de, peterx@redhat.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable 5.10 v2 PATCH 1/2] mm: hwpoison: remove the unnecessary
 THP check
Message-ID: <YYjalO3gt3YczsY5@kroah.com>
References: <20211104210752.390351-1-shy828301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104210752.390351-1-shy828301@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 02:07:51PM -0700, Yang Shi wrote:
> commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream.
> 
> When handling THP hwpoison checked if the THP is in allocation or free
> stage since hwpoison may mistreat it as hugetlb page.  After commit
> 415c64c1453a ("mm/memory-failure: split thp earlier in memory error
> handling") the problem has been fixed, so this check is no longer
> needed.  Remove it.  The side effect of the removal is hwpoison may
> report unsplit THP instead of unknown error for shmem THP.  It seems not
> like a big deal.
> 
> The following patch "mm: filemap: check if THP has hwpoisoned subpage
> for PMD page fault" depends on this, which fixes shmem THP with
> hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
> backported to -stable as well.
> 
> Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
> Signed-off-by: Yang Shi <shy828301@gmail.com>
> Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  mm/memory-failure.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 01445ddff58d..bd2cd4dd59b6 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -956,20 +956,6 @@ static int get_hwpoison_page(struct page *page)
>  {
>  	struct page *head = compound_head(page);
>  
> -	if (!PageHuge(head) && PageTransHuge(head)) {
> -		/*
> -		 * Non anonymous thp exists only in allocation/free time. We
> -		 * can't handle such a case correctly, so let's give it up.
> -		 * This should be better than triggering BUG_ON when kernel
> -		 * tries to touch the "partially handled" page.
> -		 */
> -		if (!PageAnon(head)) {
> -			pr_err("Memory failure: %#lx: non anonymous thp\n",
> -				page_to_pfn(page));
> -			return 0;
> -		}
> -	}
> -
>  	if (get_page_unless_zero(head)) {
>  		if (head == compound_head(page))
>  			return 1;
> -- 
> 2.26.2
> 

Thanks, both now queued up.

greg k-h
