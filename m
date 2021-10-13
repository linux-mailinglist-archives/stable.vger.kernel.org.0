Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09E242BAF8
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbhJMI6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhJMI6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 04:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D9D56044F;
        Wed, 13 Oct 2021 08:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634115368;
        bh=WpJOGyh4s66or5KaDQW7+2h9qF5Qch9oejuMLmQgcBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIEJfIrS26jFmByyFMI1qCgTsjahSmBfGKIRl5K4p4/Gs85lsue9yGHhu7eKv5saa
         6z32LBeBIGsCuG04cw0h3YJBttF/mEclCew7xfMWmtDQl5lLUdd/wl9c3G10vzaE21
         wIL9QEduEV8H5kOlZOueRuLEP69WKgi4nqVe4/io=
Date:   Wed, 13 Oct 2021 10:56:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org,
        jannh@google.com, torvalds@linux-foundation.org, peterx@redhat.com,
        aarcange@redhat.com, david@redhat.com, jgg@ziepe.ca,
        ktkhai@virtuozzo.com, shli@fb.com, namit@vmware.com, hch@lst.de,
        oleg@redhat.com, kirill@shutemov.name, willy@infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
Message-ID: <YWafJuq6GHzW9Tlt@kroah.com>
References: <20211012015244.693594-1-surenb@google.com>
 <20211012080649.GE9697@quack2.suse.cz>
 <b9568b73-70ef-cd0f-f533-41556cae6a0f@suse.cz>
 <YWVKgIUY6hWagEPo@kroah.com>
 <YWXar5/JJD4NYcHa@mussarela>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWXar5/JJD4NYcHa@mussarela>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 03:57:51PM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Tue, Oct 12, 2021 at 10:42:40AM +0200, Greg KH wrote:
> > On Tue, Oct 12, 2021 at 10:14:27AM +0200, Vlastimil Babka wrote:
> > > On 10/12/21 10:06, Jan Kara wrote:
> > > > On Mon 11-10-21 18:52:44, Suren Baghdasaryan wrote:
> > > >> From: Linus Torvalds <torvalds@linux-foundation.org>
> > > >> 
> > > >> From: Linus Torvalds <torvalds@linux-foundation.org>
> > > >> 
> > > >> commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.
> > > >> 
> > > >> Doing a "get_user_pages()" on a copy-on-write page for reading can be
> > > >> ambiguous: the page can be COW'ed at any time afterwards, and the
> > > >> direction of a COW event isn't defined.
> > > >> 
> > > >> Yes, whoever writes to it will generally do the COW, but if the thread
> > > >> that did the get_user_pages() unmapped the page before the write (and
> > > >> that could happen due to memory pressure in addition to any outright
> > > >> action), the writer could also just take over the old page instead.
> > > >> 
> > > >> End result: the get_user_pages() call might result in a page pointer
> > > >> that is no longer associated with the original VM, and is associated
> > > >> with - and controlled by - another VM having taken it over instead.
> > > >> 
> > > >> So when doing a get_user_pages() on a COW mapping, the only really safe
> > > >> thing to do would be to break the COW when getting the page, even when
> > > >> only getting it for reading.
> > > >> 
> > > >> At the same time, some users simply don't even care.
> > > >> 
> > > >> For example, the perf code wants to look up the page not because it
> > > >> cares about the page, but because the code simply wants to look up the
> > > >> physical address of the access for informational purposes, and doesn't
> > > >> really care about races when a page might be unmapped and remapped
> > > >> elsewhere.
> > > >> 
> > > >> This adds logic to force a COW event by setting FOLL_WRITE on any
> > > >> copy-on-write mapping when FOLL_GET (or FOLL_PIN) is used to get a page
> > > >> pointer as a result.
> > > >> 
> > > >> The current semantics end up being:
> > > >> 
> > > >>  - __get_user_pages_fast(): no change. If you don't ask for a write,
> > > >>    you won't break COW. You'd better know what you're doing.
> > > >> 
> > > >>  - get_user_pages_fast(): the fast-case "look it up in the page tables
> > > >>    without anything getting mmap_sem" now refuses to follow a read-only
> > > >>    page, since it might need COW breaking.  Which happens in the slow
> > > >>    path - the fast path doesn't know if the memory might be COW or not.
> > > >> 
> > > >>  - get_user_pages() (including the slow-path fallback for gup_fast()):
> > > >>    for a COW mapping, turn on FOLL_WRITE for FOLL_GET/FOLL_PIN, with
> > > >>    very similar semantics to FOLL_FORCE.
> > > >> 
> > > >> If it turns out that we want finer granularity (ie "only break COW when
> > > >> it might actually matter" - things like the zero page are special and
> > > >> don't need to be broken) we might need to push these semantics deeper
> > > >> into the lookup fault path.  So if people care enough, it's possible
> > > >> that we might end up adding a new internal FOLL_BREAK_COW flag to go
> > > >> with the internal FOLL_COW flag we already have for tracking "I had a
> > > >> COW".
> > > >> 
> > > >> Alternatively, if it turns out that different callers might want to
> > > >> explicitly control the forced COW break behavior, we might even want to
> > > >> make such a flag visible to the users of get_user_pages() instead of
> > > >> using the above default semantics.
> > > >> 
> > > >> But for now, this is mostly commentary on the issue (this commit message
> > > >> being a lot bigger than the patch, and that patch in turn is almost all
> > > >> comments), with that minimal "enable COW breaking early" logic using the
> > > >> existing FOLL_WRITE behavior.
> > > >> 
> > > >> [ It might be worth noting that we've always had this ambiguity, and it
> > > >>   could arguably be seen as a user-space issue.
> > > >> 
> > > >>   You only get private COW mappings that could break either way in
> > > >>   situations where user space is doing cooperative things (ie fork()
> > > >>   before an execve() etc), but it _is_ surprising and very subtle, and
> > > >>   fork() is supposed to give you independent address spaces.
> > > >> 
> > > >>   So let's treat this as a kernel issue and make the semantics of
> > > >>   get_user_pages() easier to understand. Note that obviously a true
> > > >>   shared mapping will still get a page that can change under us, so this
> > > >>   does _not_ mean that get_user_pages() somehow returns any "stable"
> > > >>   page ]
> > > >> 
> > > >> [surenb: backport notes
> > > >>         Since gup_pgd_range does not exist, made appropriate changes on
> > > >>         the the gup_huge_pgd, gup_huge_pd and gup_pud_range calls instead.
> > > >> 	Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_huge_pgd,
> > > >>         gup_huge_pd and gup_pud_range.
> > > >> 	Removed FOLL_PIN usage in should_force_cow_break since it's missing in
> > > >> 	the earlier kernels.]
> > > > 
> > > > I'd be really careful with backporting this to stable. There was a lot of
> > > > userspace breakage caused by this change if I remember right which needed
> > > > to be fixed up later. There is a nice summary at
> > > > https://lwn.net/Articles/849638/ and https://lwn.net/Articles/849876/ and
> > > > some problems are still being found...
> > > 
> > > Yeah that was my initial reaction. But looks like back in April we agreed
> > > that backporting only this commit could be feasible - the relevant subthread
> > > starts around here [1]. The known breakage for just this commit was uffd
> > > functionality introduced only in 5.7, and strace on dax on pmem (that was
> > > never properly root caused). 5.4 stable already has the backport since year
> > > ago, Suren posted 4.14 and 4.19 in April after [1]. Looks like nobody
> > > reported issues? Continuing with 4.4 and 4.9 makes this consistent at least,
> > > although the risk of breaking something is always there and the CVE probably
> > > not worth it, but whatever...
> > 
> > I have had people "complain" that the issue was not fixed on these older
> > kernels, now if that is just because those groups have a "it has a CVE
> > so it must be fixed!" policy or not, it is hard to tell.
> > 
> > But this seems to be exploitable, and we have a reproducer somewhere
> > around here, so it would be nice to get resolved for the reason of it
> > being a bug that we should fix if possible.
> > 
> > So I would err on the side of "lets merge this" as fixing a known issue
> > is ALWAYS better than the fear of "maybe something might break".  We can
> > always revert if the latter happens in testing.
> > 
> > thanks,
> > 
> > greg k-h
> 
> When we backported this to the Ubuntu kernel based on 4.4, we found a
> regression that required commit 38e088546522e1e86d2b8f401a1354ad3a9b3303
> ("mm: check VMA flags to avoid invalid PROT_NONE NUMA balancing") as a fix.
> 
> I tested that this was also the case with the 4.4.y stable-rc tree and I am
> providing our backport below, which I also tested. The reproducer that
> regresses reads from /proc/self/mem. Writing to /proc/self/mem seems to
> have been a bug on 4.4 for a while and is also fixed by this backport, so
> should be considered in any case.

Thank you for the backport, and letting us know, now queued up!

greg k-h
