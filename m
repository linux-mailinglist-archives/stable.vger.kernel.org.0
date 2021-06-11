Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444493A4AF8
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 00:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhFKWil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 18:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229572AbhFKWik (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 18:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E4C613DE;
        Fri, 11 Jun 2021 22:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623450984;
        bh=HtVrjP1NzBtomUQjA4d5/nvjnishSzc5bPaQjZfmId4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZQjgx8w0tK9x3x1IXhtV3DANxaEfxnBiu6iGsyUMj86+A2djnyx6DFkH7/GZjrtph
         M2X7nECiT6fijvOobbjC9KqdBUUVRU+EUoaelTpkXvh1pWLBXUb5PPud7ZIhndDrjn
         d1v9mQ86n34Eb+wNhvhhBVMk6+O3qWKSCHUOhCxg=
Date:   Fri, 11 Jun 2021 15:36:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH resend] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
Message-Id: <20210611153624.65badf761078f86f76365ab9@linux-foundation.org>
In-Reply-To: <20210611161545.998858-1-jannh@google.com>
References: <20210611161545.998858-1-jannh@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Jun 2021 18:15:45 +0200 Jann Horn <jannh@google.com> wrote:

> try_grab_compound_head() is used to grab a reference to a page from
> get_user_pages_fast(), which is only protected against concurrent
> freeing of page tables (via local_irq_save()), but not against
> concurrent TLB flushes, freeing of data pages, or splitting of compound
> pages.
> 
> Because no reference is held to the page when try_grab_compound_head()
> is called, the page may have been freed and reallocated by the time its
> refcount has been elevated; therefore, once we're holding a stable
> reference to the page, the caller re-checks whether the PTE still points
> to the same page (with the same access rights).
> 
> The problem is that try_grab_compound_head() has to grab a reference on
> the head page; but between the time we look up what the head page is and
> the time we actually grab a reference on the head page, the compound
> page may have been split up (either explicitly through split_huge_page()
> or by freeing the compound page to the buddy allocator and then
> allocating its individual order-0 pages).
> If that happens, get_user_pages_fast() may end up returning the right
> page but lifting the refcount on a now-unrelated page, leading to
> use-after-free of pages.
> 
> To fix it:
> Re-check whether the pages still belong together after lifting the
> refcount on the head page.
> Move anything else that checks compound_head(page) below the refcount
> increment.
> 
> This can't actually happen on bare-metal x86 (because there, disabling
> IRQs locks out remote TLB flushes), but it can happen on virtualized x86
> (e.g. under KVM) and probably also on arm64. The race window is pretty
> narrow, and constantly allocating and shattering hugepages isn't exactly
> fast; for now I've only managed to reproduce this in an x86 KVM guest with
> an artificially widened timing window (by adding a loop that repeatedly
> calls `inl(0x3f8 + 5)` in `try_get_compound_head()` to force VM exits,
> so that PV TLB flushes are used instead of IPIs).
> 
> ...
>
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -43,8 +43,21 @@ static void hpage_pincount_sub(struct page *page, int refs)
>  
>  	atomic_sub(refs, compound_pincount_ptr(page));
>  }
>  
> +/* Equivalent to calling put_page() @refs times. */
> +static void put_page_refs(struct page *page, int refs)
> +{
> +	VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);

I don't think there's a need to nuke the whole kernel in this case. 
Can we warn then simply leak the page?  That way we have a much better
chance of getting a good bug report.

> +	/*
> +	 * Calling put_page() for each ref is unnecessarily slow. Only the last
> +	 * ref needs a put_page().
> +	 */
> +	if (refs > 1)
> +		page_ref_sub(page, refs - 1);
> +	put_page(page);
> +}

