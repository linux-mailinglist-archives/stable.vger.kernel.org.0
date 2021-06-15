Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC993A7DE9
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 14:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFOMMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 08:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFOMMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 08:12:12 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41CDC061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 05:10:07 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id z22so24635694ljh.8
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 05:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WNpdr2S1NDbOx7bwbHaY+rxGjF1pZI1K0hiTte/Oqqs=;
        b=hn6SsOwGYHR0CT0tDtiihzIzNVHWuJ5IrzWQY7kMPAPAkOcNK/166MPvX5oPF0j2qO
         9T/1zTMuqXEJ4b6ZgOC6Knr2m2Yqb2HfB8NrNqGrd4izzEpDRZwQu15NaWtzVMNqbTZ3
         7dJdgKBsPI3lfkwZM1wMH/372Y7ijszwqY2alGxa0ROsPoSE9JOK9BrBKfBi1ucrs+q6
         Y7asH2E5+HafTOB16GdKR1Br5TfolOTf9iW970559LAuX/4rScPQ7EzCAw+yJ8GcPiNj
         XGtWxud65paFus1Ok5qmMCntw4zfOD+Qwpb0VTJslYHXyUYBkuT6DesWQVfZvQ4GEa/3
         i25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WNpdr2S1NDbOx7bwbHaY+rxGjF1pZI1K0hiTte/Oqqs=;
        b=LVTxa2cEZPM09klwJ7lTxpLIqQmByxJHt9isT77TFyeOqJ08tUw6C4woIxaeipAXZB
         JFICgHhsXA6hbo7GGZV0Gisp2a+WWU1Tdz/SaD6A//UH5hVuB8anC3RPPiF6DWjCKRlQ
         jT9jwbVfOH6FNEcac5NctWGyABJzm3RXugnCHqIqi8pMGn9c3LHDLk9U14bS8Xu1wDsb
         qoOYKOUQ1Bz0yublL9BudNTz+Cs41UE4u66p6fLIcU/780qhrFj/mbhfabNBrhWefsEE
         iLjYUAUy2xRD8JnwliJagcQOnnl6s1gNWgORmc3B/slA1EPD1bioZknWJ5LG2k1JQ6uB
         /v3A==
X-Gm-Message-State: AOAM530GB6aCJlkjuzZ8iaEj+RIxWSq4tOhfafORvLWrvSKmD5+obPTs
        SDl/515thWwXkV5LLBrZKys350vKOyxLbpbcto7SIA==
X-Google-Smtp-Source: ABdhPJw8A6vOZsaQEDsWTxdTmFkA/8e8Rr9IEnGktDJsMz7Tqoh1ranC3q6kCm2luqXihS9dlvk8IM++pXxR3peUytE=
X-Received: by 2002:a2e:b5ae:: with SMTP id f14mr17742867ljn.94.1623759005720;
 Tue, 15 Jun 2021 05:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210615012014.1100672-1-jannh@google.com> <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
In-Reply-To: <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 15 Jun 2021 14:09:38 +0200
Message-ID: <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with split_huge_page()
To:     John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 8:37 AM John Hubbard <jhubbard@nvidia.com> wrote:
> On 6/14/21 6:20 PM, Jann Horn wrote:
> > try_grab_compound_head() is used to grab a reference to a page from
> > get_user_pages_fast(), which is only protected against concurrent
> > freeing of page tables (via local_irq_save()), but not against
> > concurrent TLB flushes, freeing of data pages, or splitting of compound
> > pages.
[...]
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>

Thanks!

[...]
> > @@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
> >       if (WARN_ON_ONCE(page_ref_count(head) < 0))
> >               return NULL;
> >       if (unlikely(!page_cache_add_speculative(head, refs)))
> >               return NULL;
> > +
> > +     /*
> > +      * At this point we have a stable reference to the head page; but it
> > +      * could be that between the compound_head() lookup and the refcount
> > +      * increment, the compound page was split, in which case we'd end up
> > +      * holding a reference on a page that has nothing to do with the page
> > +      * we were given anymore.
> > +      * So now that the head page is stable, recheck that the pages still
> > +      * belong together.
> > +      */
> > +     if (unlikely(compound_head(page) != head)) {
>
> I was just wondering about what all could happen here. Such as: page gets split,
> reallocated into a different-sized compound page, one that still has page pointing
> to head. I think that's OK, because we don't look at or change other huge page
> fields.
>
> But I thought I'd mention the idea in case anyone else has any clever ideas about
> how this simple check might be insufficient here. It seems fine to me, but I
> routinely lack enough imagination about concurrent operations. :)

Hmmm... I think the scariest aspect here is probably the interaction
with concurrent allocation of a compound page on architectures with
store-store reordering (like ARM). *If* the page allocator handled
compound pages with lockless, non-atomic percpu freelists, I think it
might be possible that the zeroing of tail_page->compound_head in
put_page() could be reordered after the page has been freed,
reallocated and set to refcount 1 again?

That shouldn't be possible at the moment, but it is still a bit scary.


I think the lockless page cache code also has to deal with somewhat
similar ordering concerns when it uses page_cache_get_speculative(),
e.g. in mapping_get_entry() - first it looks up a page pointer with
xas_load(), and any access to the page later on would be a _dependent
load_, but if the page then gets freed, reallocated, and inserted into
the page cache again before the refcount increment and the re-check
using xas_reload(), then there would be no data dependency from
xas_reload() to the following use of the page...
