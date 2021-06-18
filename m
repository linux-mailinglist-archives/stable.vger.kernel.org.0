Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6563ACE25
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 16:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhFRPAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbhFRPAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 11:00:42 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98D3C0617AF
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 07:58:32 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id l2so4960773qtq.10
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 07:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=repfQyDKTAMeHKXGuDmTN3Wtz95/exNHme61bRWFg+k=;
        b=NowrGpf/C+bkFi8CG9LI5D/bmOQq5TDoeixlbZs0EWotTC5jYFGNA9ip90Yw6DvbZy
         ScXR8pPQH8ctKBBUcFcRVunrNTcRsQDgMoyMHNJC/72R/4A/i46FIGsWKZRxz7jCr9RV
         B/nfwrkzS71Mwn2gJCvvC2ueoUlU+uyfd8RiMPi2898nKJ9JQ5yXItUQe7gECOz+9Ax7
         8UrFGrA3RGZGm7MkYWoE7tCWl9DjJqhxezOQRqK1aRLKr+bkXwp++beSO31Dy0j16XVn
         85j9YnKW74TqM0DdwAKEA30nOfnGx9pYyFT5DSANJEhocUr5Qf/q4zdMX3qprxaKdBeh
         f7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=repfQyDKTAMeHKXGuDmTN3Wtz95/exNHme61bRWFg+k=;
        b=VUZEeN1EESbq0PW5kaKPaIoNhN9BWYjIdRAowaIkAkjWLbffzCsBVgUAnU4qm9luLL
         AKBEZN3DtOiuqSpnRFjwZubuuya6A3W57chsuW5YvXvKvkwnQ4lUv5dTR5HA1KYwN2LP
         Djqno+B/mK44U1Ydo9F1tM5jUFZGsJisPhy1Z5L8GCM9EjuLvBsUAZBWT1EOVc0ma7da
         LPosqPh4XyTSuYyTE70ysjvzEmLNvbTK8cQgSgSs71+xzQAliNpFjresyaKs6OcnW/OZ
         iXzmzfVMWL+SeOkJGVq3s9n1QpddZeFQq5WrIZqWv/da5RPuP97hLEMnZGOQMIXMDvcZ
         Sm8w==
X-Gm-Message-State: AOAM5302HYEc1qGVbNLiPE8T703Atq2cYIvszIQDsbOcTVXuOFJAhkdF
        LxuPd/P74SIhZ3wREDoykY6qnA==
X-Google-Smtp-Source: ABdhPJwTC0HmCXRT2TBG+mPczj34Kxdt8JxOZvxCw5dBA8SK1MsxRcZZI+HtnPitJIZwDWkd+iQn0Q==
X-Received: by 2002:ac8:444f:: with SMTP id m15mr1880050qtn.340.1624028311456;
        Fri, 18 Jun 2021 07:58:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id d19sm925301qkl.10.2021.06.18.07.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 07:58:31 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1luFx0-008Ydr-5l; Fri, 18 Jun 2021 11:58:30 -0300
Date:   Fri, 18 Jun 2021 11:58:30 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jann Horn <jannh@google.com>, John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
Message-ID: <20210618145830.GZ1096940@ziepe.ca>
References: <20210615012014.1100672-1-jannh@google.com>
 <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
 <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
 <20210618132556.GY1096940@ziepe.ca>
 <YMykiGuZYMqF7DuU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMykiGuZYMqF7DuU@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 18, 2021 at 02:50:00PM +0100, Matthew Wilcox wrote:
> On Fri, Jun 18, 2021 at 10:25:56AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 15, 2021 at 02:09:38PM +0200, Jann Horn wrote:
> > > On Tue, Jun 15, 2021 at 8:37 AM John Hubbard <jhubbard@nvidia.com> wrote:
> > > > On 6/14/21 6:20 PM, Jann Horn wrote:
> > > > > @@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
> > > > >       if (WARN_ON_ONCE(page_ref_count(head) < 0))
> > > > >               return NULL;
> > > > >       if (unlikely(!page_cache_add_speculative(head, refs)))
> > > > >               return NULL;
> > > > > +
> > > > > +     /*
> > > > > +      * At this point we have a stable reference to the head page; but it
> > > > > +      * could be that between the compound_head() lookup and the refcount
> > > > > +      * increment, the compound page was split, in which case we'd end up
> > > > > +      * holding a reference on a page that has nothing to do with the page
> > > > > +      * we were given anymore.
> > > > > +      * So now that the head page is stable, recheck that the pages still
> > > > > +      * belong together.
> > > > > +      */
> > > > > +     if (unlikely(compound_head(page) != head)) {
> > > >
> > > > I was just wondering about what all could happen here. Such as: page gets split,
> > > > reallocated into a different-sized compound page, one that still has page pointing
> > > > to head. I think that's OK, because we don't look at or change other huge page
> > > > fields.
> > > >
> > > > But I thought I'd mention the idea in case anyone else has any clever ideas about
> > > > how this simple check might be insufficient here. It seems fine to me, but I
> > > > routinely lack enough imagination about concurrent operations. :)
> > > 
> > > Hmmm... I think the scariest aspect here is probably the interaction
> > > with concurrent allocation of a compound page on architectures with
> > > store-store reordering (like ARM). *If* the page allocator handled
> > > compound pages with lockless, non-atomic percpu freelists, I think it
> > > might be possible that the zeroing of tail_page->compound_head in
> > > put_page() could be reordered after the page has been freed,
> > > reallocated and set to refcount 1 again?
> > 
> > Oh wow, yes, this all looks sketchy! Doing a RCU access to page->head
> > is a really challenging thing :\
> > 
> > On the simplified store side:
> > 
> >   page->head = my_compound
> >   *ptep = page
> > 
> > There must be some kind of release barrier between those two
> > operations or this is all broken.. That definately deserves a comment.
> 
> set_compound_head() includes a WRITE_ONCE.  Is that enough, or does it
> need an smp_wmb()?

Probably, at least the generic code maps smp_store_release() to
__smp_wmb.

I think Jann was making the argument that there is going to be some
other release operation due to locking between the two above, eg a
lock unlock or something.

> > Ideally we'd use smp_store_release to install the *pte :\
> > 
> > Assuming we cover the release barrier, I would think the algorithm
> > should be broadly:
> > 
> >  struct page *target_page = READ_ONCE(pte)
> >  struct page *target_folio = READ_ONCE(target_page->head)
> 
> compound_head() includes a READ_ONCE already.

Ah, see I obviously haven't memorized that detail :\

> >  page_cache_add_speculative(target_folio, refs)
> 
> That's spelled folio_ref_try_add_rcu() right now.

That seems a much better name

> >  if (target_folio != READ_ONCE(target_page->head) ||
> >      target_page != READ_ONCE(pte))
> >     goto abort
> > 
> > Which is what this patch does but I would like to see the
> > READ_ONCE's.
> 
> ... you want them to be uninlined from compound_head(), et al?

Not really (though see below), I was mostly looking at the pte which
just does pte_val(), no READ_ONCE in there

> > And there possibly should be two try_grab_compound_head()'s since we
> > don't need this overhead on the fully locked path, especially the
> > double atomic on page_ref_add()
> 
> There's only one atomic on page_ref_add(). 

Look at the original patch, it adds this:

+		else
+			page_ref_add(page, refs * (GUP_PIN_COUNTING_BIAS - 1));

Where page is the folio, which is now two atomics to do the same
ref. This is happening because we can't do hpage_pincount_available()
before having initially locked the folio, thus we can no longer
precompute what 'ref' to give to the first folio_ref_try_add_rcu()

> And you need more of this overhead on the fully locked path than you
> realise; the page might be split without holding the mmap_sem, for
> example.

Fully locked here means holding the PTL spinlocks, so we know the pte
cannot change and particularly the refcount of a folio can't go to
zero. We can't change compound_head if the refcount is
elevated.

Keep in mind we also do this in gpu:

 folio_ref_try_add_rcu(READ_ONCE(target_page->head), 1)
 [..]
 folio_put_refs(READ_ONCE(target_page->head), 1)

Which makes me wonder why we have READ_ONCE inside compound_head?

I'm reading the commit message of 1d798ca3f164 ("mm: make
compound_head() robust"), and to me that looks like another special
lockless algorithm that should have the READ_ONCE in it, not the
general code.

Jason
