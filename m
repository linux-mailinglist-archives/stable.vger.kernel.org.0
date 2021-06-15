Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3441F3A8C44
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 01:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFOXNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 19:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhFOXNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 19:13:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300F2C061574;
        Tue, 15 Jun 2021 16:10:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id nd37so483306ejc.3;
        Tue, 15 Jun 2021 16:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AOuKGzIskjJRbFedWFW/C+I5PYhV95WPLhId+SvqihU=;
        b=Me2pvvkHKVtdhQPvq+vIdIjnZAeubKot8b/msdA4OqCL1eyPpVYMJhSJuwehR5FBtp
         zGQpbV5sNiw7tpr5PC9fuj0INw/rDTiZOnbpOKe3rN4J+7xRnaMpUSlp0lw7nzBjIzof
         XR9ZGP6GO2VbPNBm0LzcqY69dN2IVr5yvQpPs/ChBWQthPwRm9dRLowiuYIur5sPJAI5
         su4rRk+RoRx+/IFezW+YNI4eF/ydVlTryAMjvre8g1ginl+2jCSfGopyI4safI3wohhG
         1c2BnEG2yu4pdwJ0xZS5g4VM2eazl8SxMDP7YHBqqsHmC/iqzg9udNztQWaLc28Y8imH
         c+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AOuKGzIskjJRbFedWFW/C+I5PYhV95WPLhId+SvqihU=;
        b=YFeWDYlUPpQXi99cUegW74+PA7NTO2X7KpPEVX4kHmimzTICLc79xUn5S59VGiWYR8
         vE4UxmInboEAeLguzeoH/E/aND0wuYQnLGqfd315PYZiWAKliBqJPLba8Mvki00EL3HE
         IAda7cJez2ATx3/3ieO0dOEdZg5IqiETfmtwIfHzKHGjQPUEE6orkd3TobM5m6LxOW1q
         bVzpWaGleR/MWmvjK3mI4Qai64qXhAwH9GWttWW47bE1TV+p3pNbLMdY+s1PFoCxWPFs
         Ip7IlxvFCzFcJFauL/tVQefhxYrGk93qgalQTvvYRmzn8oY3oz3RifJvUq+GHQfKjBsz
         s8Yg==
X-Gm-Message-State: AOAM532PQU0EfxW/pED61uFMMaj3IuyVCcmkohNlOwVEM/XzKewGnv0k
        LAHqR/muIY0BtYuynMgLhax/dmkuQTeaHcQcLGs=
X-Google-Smtp-Source: ABdhPJzHX1BNpwnfCqqm59hp1H0X6TtuHe5B6/m0KBULTJlIVinWp8ZuuFM8L436LMgFXdlox6fVRlHjxCbLiYTB1uA=
X-Received: by 2002:a17:907:9d1:: with SMTP id bx17mr1956080ejc.238.1623798657801;
 Tue, 15 Jun 2021 16:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210615012014.1100672-1-jannh@google.com> <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
 <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
In-Reply-To: <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Tue, 15 Jun 2021 16:10:46 -0700
Message-ID: <CAHbLzkomex+fgC8RyogXu-s5o2UrORMO6D2yTsSXW5Wo5z9WRA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with split_huge_page()
To:     Jann Horn <jannh@google.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 5:10 AM Jann Horn <jannh@google.com> wrote:
>
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
>
> That shouldn't be possible at the moment, but it is still a bit scary.

It might be possible after Mel's "mm/page_alloc: Allow high-order
pages to be stored on the per-cpu lists" patch
(https://patchwork.kernel.org/project/linux-mm/patch/20210611135753.GC30378@techsingularity.net/).

>
>
> I think the lockless page cache code also has to deal with somewhat
> similar ordering concerns when it uses page_cache_get_speculative(),
> e.g. in mapping_get_entry() - first it looks up a page pointer with
> xas_load(), and any access to the page later on would be a _dependent
> load_, but if the page then gets freed, reallocated, and inserted into
> the page cache again before the refcount increment and the re-check
> using xas_reload(), then there would be no data dependency from
> xas_reload() to the following use of the page...
>
