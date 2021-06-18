Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007CF3ACC20
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 15:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhFRN2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 09:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhFRN2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 09:28:08 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660C5C06175F
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 06:25:58 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id j184so10884733qkd.6
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 06:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Q0pSocb902nqdu/y77JGz+XB/v2LVNcwiIldSRzK9U=;
        b=hGa0zuDIEfU8WmXM8K16zPr/kDxBumV9k5VY1P1r2DDzA/gpsW5iz9540NpxgxSziK
         Tpb2oMnPp0cQ3vVTW0YftNn3iNpvPHv51IxPtwc6IYJQ/W4nmUleOpw73XXUVgqnEhTa
         Rqdp3yDnXzTNqaD9sCdaipGnFL8+5Uj+Dz+x9o+8l1NZJG+n16ahrDY6qEbIdoCj32Lw
         4EO6ce4/FFd5LCogalj0XnZqsL/T3CxuxUtRIHfWM9OGumzHtwhTyDwdvg2NEteFwr6n
         yQ+rkSMxhacDzlxDJ3tE8XGlJm2wZ2L7GTeEG9yVmI13j48GEYiKh5uSBTnLImdKCVfG
         u7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Q0pSocb902nqdu/y77JGz+XB/v2LVNcwiIldSRzK9U=;
        b=HK1oP3+5em9HeT/317oiCh1xv3KhsbbTN10JWQWlj67HtO+dQsesq7mpM1j29dbOE/
         VOlDR5wkJIRy5/4ij/Zd3CcwAre+xDtKfWZj4lYritdSGM7aVTLXuTxGqSqpyfSI7yJT
         vNOHQY3+d5GBS/NHpFgr9WEcVYVlpTc1PXnM8ZiOz/JpxnF1MrVcsIFlmY7u5BIc4jnV
         L4K5An8I9cPQ8HuWGSa2uKso5skmCgusIN4uQNm+HsbYoLEEzSzwJrnROVqQzVj3Ur50
         Cur6YOhfcQT7XIqjFUvFbENjIDJGcd3eJNINZOrvUleiwgmvUQIyymW92kXxwGZRw81L
         77Yw==
X-Gm-Message-State: AOAM530q9T9KmVuJYVC6wdnq0Dvtkd1mUrYaGsdws96zxQ1x5TFKLUgo
        ZcynPrSO/MBPrbAWVjrZ9HGG4A==
X-Google-Smtp-Source: ABdhPJy1bq0eK26G6TdGQtW2ljiO6j3VkzhRkj5gzT73oFyXrSw2pF54iZgtS7poUYBJ0o9XcnmU7Q==
X-Received: by 2002:a37:a417:: with SMTP id n23mr9604598qke.265.1624022757616;
        Fri, 18 Jun 2021 06:25:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id x9sm5342220qtf.76.2021.06.18.06.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:25:56 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1luEVQ-008X3c-8n; Fri, 18 Jun 2021 10:25:56 -0300
Date:   Fri, 18 Jun 2021 10:25:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jann Horn <jannh@google.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
Message-ID: <20210618132556.GY1096940@ziepe.ca>
References: <20210615012014.1100672-1-jannh@google.com>
 <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
 <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 02:09:38PM +0200, Jann Horn wrote:
> On Tue, Jun 15, 2021 at 8:37 AM John Hubbard <jhubbard@nvidia.com> wrote:
> > On 6/14/21 6:20 PM, Jann Horn wrote:
> > > try_grab_compound_head() is used to grab a reference to a page from
> > > get_user_pages_fast(), which is only protected against concurrent
> > > freeing of page tables (via local_irq_save()), but not against
> > > concurrent TLB flushes, freeing of data pages, or splitting of compound
> > > pages.
> [...]
> > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> 
> Thanks!
> 
> [...]
> > > @@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
> > >       if (WARN_ON_ONCE(page_ref_count(head) < 0))
> > >               return NULL;
> > >       if (unlikely(!page_cache_add_speculative(head, refs)))
> > >               return NULL;
> > > +
> > > +     /*
> > > +      * At this point we have a stable reference to the head page; but it
> > > +      * could be that between the compound_head() lookup and the refcount
> > > +      * increment, the compound page was split, in which case we'd end up
> > > +      * holding a reference on a page that has nothing to do with the page
> > > +      * we were given anymore.
> > > +      * So now that the head page is stable, recheck that the pages still
> > > +      * belong together.
> > > +      */
> > > +     if (unlikely(compound_head(page) != head)) {
> >
> > I was just wondering about what all could happen here. Such as: page gets split,
> > reallocated into a different-sized compound page, one that still has page pointing
> > to head. I think that's OK, because we don't look at or change other huge page
> > fields.
> >
> > But I thought I'd mention the idea in case anyone else has any clever ideas about
> > how this simple check might be insufficient here. It seems fine to me, but I
> > routinely lack enough imagination about concurrent operations. :)
> 
> Hmmm... I think the scariest aspect here is probably the interaction
> with concurrent allocation of a compound page on architectures with
> store-store reordering (like ARM). *If* the page allocator handled
> compound pages with lockless, non-atomic percpu freelists, I think it
> might be possible that the zeroing of tail_page->compound_head in
> put_page() could be reordered after the page has been freed,
> reallocated and set to refcount 1 again?

Oh wow, yes, this all looks sketchy! Doing a RCU access to page->head
is a really challenging thing :\

On the simplified store side:

  page->head = my_compound
  *ptep = page

There must be some kind of release barrier between those two
operations or this is all broken.. That definately deserves a comment.

Ideally we'd use smp_store_release to install the *pte :\

Assuming we cover the release barrier, I would think the algorithm
should be broadly:

 struct page *target_page = READ_ONCE(pte)
 struct page *target_folio = READ_ONCE(target_page->head)

 page_cache_add_speculative(target_folio, refs)

 if (target_folio != READ_ONCE(target_page->head) ||
     target_page != READ_ONCE(pte))
    goto abort

Which is what this patch does but I would like to see the
READ_ONCE's.

And there possibly should be two try_grab_compound_head()'s since we
don't need this overhead on the fully locked path, especially the
double atomic on page_ref_add()

> I think the lockless page cache code also has to deal with somewhat
> similar ordering concerns when it uses page_cache_get_speculative(),
> e.g. in mapping_get_entry() - first it looks up a page pointer with
> xas_load(), and any access to the page later on would be a _dependent
> load_, but if the page then gets freed, reallocated, and inserted into
> the page cache again before the refcount increment and the re-check
> using xas_reload(), then there would be no data dependency from
> xas_reload() to the following use of the page...

xas_store() should have the smp_store_release() inside it at least..

Even so it doesn't seem to do page->head, so this is not quite the
same thing

Jason
