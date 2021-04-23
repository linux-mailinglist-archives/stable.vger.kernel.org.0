Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537A8369590
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhDWPGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242874AbhDWPGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4525461445;
        Fri, 23 Apr 2021 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190324;
        bh=UuMwQdQzedTjF03IiVsmEEn4c4jnynThG+MXqhw+SKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CK9kDmV4/0oa5ycS4/vYB6l5Xcq3ncze3y37puw6hzrdIKnV2cYoejEOevvBaBFOS
         57TR4bExrTL6omXzk17Er9uPVsLJXndGBfhvaHG9TS9pETanedcF8FojWzTeoSAQ2B
         /t7ZWfRWktLILrHScEo0mup05ol2lQnr0UjXdPao=
Date:   Fri, 23 Apr 2021 17:05:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     stable@vger.kernel.org, jannh@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, peterx@redhat.com,
        aarcange@redhat.com, david@redhat.com, jgg@ziepe.ca,
        ktkhai@virtuozzo.com, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
Message-ID: <YILiMSSHUvPZxI4l@kroah.com>
References: <20210421225613.60124-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421225613.60124-1-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 03:56:13PM -0700, Suren Baghdasaryan wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.
> 
> Doing a "get_user_pages()" on a copy-on-write page for reading can be
> ambiguous: the page can be COW'ed at any time afterwards, and the
> direction of a COW event isn't defined.
> 
> Yes, whoever writes to it will generally do the COW, but if the thread
> that did the get_user_pages() unmapped the page before the write (and
> that could happen due to memory pressure in addition to any outright
> action), the writer could also just take over the old page instead.
> 
> End result: the get_user_pages() call might result in a page pointer
> that is no longer associated with the original VM, and is associated
> with - and controlled by - another VM having taken it over instead.
> 
> So when doing a get_user_pages() on a COW mapping, the only really safe
> thing to do would be to break the COW when getting the page, even when
> only getting it for reading.
> 
> At the same time, some users simply don't even care.
> 
> For example, the perf code wants to look up the page not because it
> cares about the page, but because the code simply wants to look up the
> physical address of the access for informational purposes, and doesn't
> really care about races when a page might be unmapped and remapped
> elsewhere.
> 
> This adds logic to force a COW event by setting FOLL_WRITE on any
> copy-on-write mapping when FOLL_GET (or FOLL_PIN) is used to get a page
> pointer as a result.
> 
> The current semantics end up being:
> 
>  - __get_user_pages_fast(): no change. If you don't ask for a write,
>    you won't break COW. You'd better know what you're doing.
> 
>  - get_user_pages_fast(): the fast-case "look it up in the page tables
>    without anything getting mmap_sem" now refuses to follow a read-only
>    page, since it might need COW breaking.  Which happens in the slow
>    path - the fast path doesn't know if the memory might be COW or not.
> 
>  - get_user_pages() (including the slow-path fallback for gup_fast()):
>    for a COW mapping, turn on FOLL_WRITE for FOLL_GET/FOLL_PIN, with
>    very similar semantics to FOLL_FORCE.
> 
> If it turns out that we want finer granularity (ie "only break COW when
> it might actually matter" - things like the zero page are special and
> don't need to be broken) we might need to push these semantics deeper
> into the lookup fault path.  So if people care enough, it's possible
> that we might end up adding a new internal FOLL_BREAK_COW flag to go
> with the internal FOLL_COW flag we already have for tracking "I had a
> COW".
> 
> Alternatively, if it turns out that different callers might want to
> explicitly control the forced COW break behavior, we might even want to
> make such a flag visible to the users of get_user_pages() instead of
> using the above default semantics.
> 
> But for now, this is mostly commentary on the issue (this commit message
> being a lot bigger than the patch, and that patch in turn is almost all
> comments), with that minimal "enable COW breaking early" logic using the
> existing FOLL_WRITE behavior.
> 
> [ It might be worth noting that we've always had this ambiguity, and it
>   could arguably be seen as a user-space issue.
> 
>   You only get private COW mappings that could break either way in
>   situations where user space is doing cooperative things (ie fork()
>   before an execve() etc), but it _is_ surprising and very subtle, and
>   fork() is supposed to give you independent address spaces.
> 
>   So let's treat this as a kernel issue and make the semantics of
>   get_user_pages() easier to understand. Note that obviously a true
>   shared mapping will still get a page that can change under us, so this
>   does _not_ mean that get_user_pages() somehow returns any "stable"
>   page ]
> 
> [surenb: backport notes]
> Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_pgd_range.
> Removed FOLL_PIN usage in should_force_cow_break since it's missing in
> the earlier kernels.
> 
> Reported-by: Jann Horn <jannh@google.com>
> Tested-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Kirill Shutemov <kirill@shutemov.name>
> Acked-by: Jan Kara <jack@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [surenb: backport to 4.19 kernel]
> Cc: stable@vger.kernel.org # 4.19.x
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/gup.c         | 44 ++++++++++++++++++++++++++++++++++++++------
>  mm/huge_memory.c |  7 +++----
>  2 files changed, 41 insertions(+), 10 deletions(-)

Thanks for these backports, I've now queued them up.

greg k-h
