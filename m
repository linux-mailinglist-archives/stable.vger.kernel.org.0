Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA03A741B
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 04:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhFOCik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 22:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229829AbhFOCik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 22:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02336613FA;
        Tue, 15 Jun 2021 02:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623722433;
        bh=7xF3tLg4trnpNvzypuC15OrE9KArJ5qA7ubwj4+GG1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jGz/ZdF0fpxmdpjjD4gaadDILCbK94CQ9OqZ+PqHP43Puv/u/fsfprJ/mkBZPqYVC
         eJOSkK2ibVP6OPtjSPwv2eq9BjJcjQVSRMNRYctH8dKb0OuNrpIPfpIfvNR8VBwoMY
         bjEtsK+msfuz1jR3wvMJecK4mWL6HHPbTtZpAfHA=
Date:   Mon, 14 Jun 2021 19:00:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
Message-Id: <20210614190032.09d8b7ac530c8b14ace44b82@linux-foundation.org>
In-Reply-To: <20210615012014.1100672-1-jannh@google.com>
References: <20210615012014.1100672-1-jannh@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Jun 2021 03:20:14 +0200 Jann Horn <jannh@google.com> wrote:

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
> As requested on the list, also replace the existing VM_BUG_ON_PAGE()
> with a warning and bailout. Since the existing code only performed the
> BUG_ON check on DEBUG_VM kernels, ensure that the new code also only
> performs the check under that configuration - I don't want to mix two
> logically separate changes together too much.
> The macro VM_WARN_ON_ONCE_PAGE() doesn't return a value on !DEBUG_VM,
> so wrap the whole check in an #ifdef block.
> An alternative would be to change the VM_WARN_ON_ONCE_PAGE() definition
> for !DEBUG_VM such that it always returns false, but since that would
> differ from the behavior of the normal WARN macros, it might be too
> confusing for readers.
> 
> ...
>
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -43,8 +43,25 @@ static void hpage_pincount_sub(struct page *page, int refs)
>  
>  	atomic_sub(refs, compound_pincount_ptr(page));
>  }
>  
> +/* Equivalent to calling put_page() @refs times. */
> +static void put_page_refs(struct page *page, int refs)
> +{
> +#ifdef CONFIG_DEBUG_VM
> +	if (VM_WARN_ON_ONCE_PAGE(page_ref_count(page) < refs, page))
> +		return;
> +#endif

Well dang those ifdefs.

With CONFIG_DEBUG_VM=n, this expands to

	if (((void)(sizeof((__force long)(page_ref_count(page) < refs))))
		return;

which will fail with "void value not ignored as it ought to be". 
Because VM_WARN_ON_ONCE_PAGE() is an rval with CONFIG_DEBUG_VM=y and is
not an rval with CONFIG_DEBUG_VM=n.    So the ifdefs are needed.

I know we've been around this loop before, but it still sucks!  Someone
please remind me of the reasoning?

Can we do

#define VM_WARN_ON_ONCE_PAGE(cond, page) {
	BUILD_BUG_ON_INVALID(cond);
	cond;
}

?

