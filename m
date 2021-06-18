Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2B43ACCBC
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 15:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhFRNw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 09:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhFRNw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 09:52:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4092C061574;
        Fri, 18 Jun 2021 06:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ewwK7sg1H70Jke6Z5DisBb+g+MN1RA6uvk0li+GYvDw=; b=pzlu4L3D71tGoinu8Rd1rBqER+
        uBcmcBdM4dRVw+a9JlVbz/puS2EwW4hf8qENTtZ211JLmTYykx2oWnNVRzEU5LD1Rejgu9t9i6gkC
        KGRd1yDlp50zgjz4UWOiIV4/kd2i02PrvhriGWGHuRJUsZWBQjfRe8P24gTDvKnr5dLSyjL63Uoi6
        hOWh9kvFmMbTSyiQTx0p6HeVKKQHNLhiQCnPcOtllMAnHUSQwExqiOB0pTnU0RnfSnFxXrx1gKc56
        yaXM1bCMFUHLCY8Bt5O7G2YC4IF9pxI7SjXK1ffg7mHnzN5O3LouHVh5clIdd3UVEVsYtG671UuPp
        Yf65JvQg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luEsi-00AK2X-CO; Fri, 18 Jun 2021 13:50:03 +0000
Date:   Fri, 18 Jun 2021 14:50:00 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jann Horn <jannh@google.com>, John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
Message-ID: <YMykiGuZYMqF7DuU@casper.infradead.org>
References: <20210615012014.1100672-1-jannh@google.com>
 <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
 <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
 <20210618132556.GY1096940@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618132556.GY1096940@ziepe.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 18, 2021 at 10:25:56AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 15, 2021 at 02:09:38PM +0200, Jann Horn wrote:
> > On Tue, Jun 15, 2021 at 8:37 AM John Hubbard <jhubbard@nvidia.com> wrote:
> > > On 6/14/21 6:20 PM, Jann Horn wrote:
> > > > @@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
> > > >       if (WARN_ON_ONCE(page_ref_count(head) < 0))
> > > >               return NULL;
> > > >       if (unlikely(!page_cache_add_speculative(head, refs)))
> > > >               return NULL;
> > > > +
> > > > +     /*
> > > > +      * At this point we have a stable reference to the head page; but it
> > > > +      * could be that between the compound_head() lookup and the refcount
> > > > +      * increment, the compound page was split, in which case we'd end up
> > > > +      * holding a reference on a page that has nothing to do with the page
> > > > +      * we were given anymore.
> > > > +      * So now that the head page is stable, recheck that the pages still
> > > > +      * belong together.
> > > > +      */
> > > > +     if (unlikely(compound_head(page) != head)) {
> > >
> > > I was just wondering about what all could happen here. Such as: page gets split,
> > > reallocated into a different-sized compound page, one that still has page pointing
> > > to head. I think that's OK, because we don't look at or change other huge page
> > > fields.
> > >
> > > But I thought I'd mention the idea in case anyone else has any clever ideas about
> > > how this simple check might be insufficient here. It seems fine to me, but I
> > > routinely lack enough imagination about concurrent operations. :)
> > 
> > Hmmm... I think the scariest aspect here is probably the interaction
> > with concurrent allocation of a compound page on architectures with
> > store-store reordering (like ARM). *If* the page allocator handled
> > compound pages with lockless, non-atomic percpu freelists, I think it
> > might be possible that the zeroing of tail_page->compound_head in
> > put_page() could be reordered after the page has been freed,
> > reallocated and set to refcount 1 again?
> 
> Oh wow, yes, this all looks sketchy! Doing a RCU access to page->head
> is a really challenging thing :\
> 
> On the simplified store side:
> 
>   page->head = my_compound
>   *ptep = page
> 
> There must be some kind of release barrier between those two
> operations or this is all broken.. That definately deserves a comment.

set_compound_head() includes a WRITE_ONCE.  Is that enough, or does it
need an smp_wmb()?

> Ideally we'd use smp_store_release to install the *pte :\
> 
> Assuming we cover the release barrier, I would think the algorithm
> should be broadly:
> 
>  struct page *target_page = READ_ONCE(pte)
>  struct page *target_folio = READ_ONCE(target_page->head)

compound_head() includes a READ_ONCE already.

>  page_cache_add_speculative(target_folio, refs)

That's spelled folio_ref_try_add_rcu() right now.

>  if (target_folio != READ_ONCE(target_page->head) ||
>      target_page != READ_ONCE(pte))
>     goto abort
> 
> Which is what this patch does but I would like to see the
> READ_ONCE's.

... you want them to be uninlined from compound_head(), et al?

> And there possibly should be two try_grab_compound_head()'s since we
> don't need this overhead on the fully locked path, especially the
> double atomic on page_ref_add()

There's only one atomic on page_ref_add().  And you need more of this
overhead on the fully locked path than you realise; the page might be
split without holding the mmap_sem, for example.

> > I think the lockless page cache code also has to deal with somewhat
> > similar ordering concerns when it uses page_cache_get_speculative(),
> > e.g. in mapping_get_entry() - first it looks up a page pointer with
> > xas_load(), and any access to the page later on would be a _dependent
> > load_, but if the page then gets freed, reallocated, and inserted into
> > the page cache again before the refcount increment and the re-check
> > using xas_reload(), then there would be no data dependency from
> > xas_reload() to the following use of the page...
> 
> xas_store() should have the smp_store_release() inside it at least..
> 
> Even so it doesn't seem to do page->head, so this is not quite the
> same thing

The page cache only stores head pages, so it's a little simpler than
lookup from PTE.  I have ideas for making PFN->folio lookup go directly
to the folio without passing through a page on the way, but that's for
much, much later.
