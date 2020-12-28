Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1AD2E69C3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgL1Rci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 12:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgL1Rci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 12:32:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13827C061798;
        Mon, 28 Dec 2020 09:31:58 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ce23so15068266ejb.8;
        Mon, 28 Dec 2020 09:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMJv2lHE34Rym/NavReAV+zZuMZZwc2rochor9I7cUk=;
        b=vLPjujywSriLbbbiWgkv3ouyHNliTmrBC13fnxtXf3p5EdEkmPy8fjwLxYBzletbU2
         Y9VXV4wEV2YlNjWsd50etSvFYzhK6CanfhVa14AC0JRHzsAvc9QqZkaLC1okmuwCI/zp
         6SgsMIAXYonjX0eU77bCj5AuZy4cUE1gc+vLMGI92yXhNKtyJ1w7Zi7ibDXAFuNn+1IR
         W+gouTA96SF6W2a5hufEGWescv0KcA2OD/8Y7DLgL9YETPfbM+f/HCvQP0V/DDiT3JjA
         80cZnTEJSqcl1k1jt968Mr69xOR+mHhFrrMBjy32xqIX/PjPpgQl1t88jsxwp90dfoZL
         Byzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMJv2lHE34Rym/NavReAV+zZuMZZwc2rochor9I7cUk=;
        b=prwfh93Sc8/i4F2/NF8pQuiJUAGnRvTltbFRrFxtjvQwmOSZKRrFV+5bhY6QlVAOqv
         Kr/eKd5RRumEaiEMFUqejVzUjHgW3lenWSbblT2wV36cCUIdpLItKm7qbSJr5gQAekzY
         HHaNFPxy74u28oEr3l/HwKHNWpJ0OH0HKYaNg6Qo5QkgR6bFuoV1PImghEnNFlXv6v4O
         xWDNBqnL55v1U8fMbOz0fsx0Pbd4CeVG2ntm00eojw65wwxirq6IYcE0OlGKudyPPFHE
         DmfjCYQnNNHF6H/DX7kGlELYpadpX6K06ratubq8d9pTrI8jZuviw7qA5/w5DLfTkjES
         yrGg==
X-Gm-Message-State: AOAM531SWrZokgHolok/Wyiri2SgrRqWIlMH/qUqWUMyZlLtkvthlROX
        QhvAsLyVBAAkbUriDA9Hfz7p3qgOp3ngHwaonwA=
X-Google-Smtp-Source: ABdhPJwlEdPEG6+Ljrdij9m+oxcj4tYDG90MJqOSvbjZQgN/UtokII1B0CsF/WGzvH1xL8Y92L+rW2nu+KGZWALfB5Y=
X-Received: by 2002:a17:906:6a45:: with SMTP id n5mr43209968ejs.514.1609176716860;
 Mon, 28 Dec 2020 09:31:56 -0800 (PST)
MIME-Version: 1.0
References: <20201227181310.3235210-1-shakeelb@google.com> <20201227181310.3235210-2-shakeelb@google.com>
 <CALvZod5bH6gP=_Qo5d2wx=mpRxXDKGcoxwO3oXGPqe=HXx8ifA@mail.gmail.com>
In-Reply-To: <CALvZod5bH6gP=_Qo5d2wx=mpRxXDKGcoxwO3oXGPqe=HXx8ifA@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 28 Dec 2020 09:31:45 -0800
Message-ID: <CAHbLzkrR1VQLN8+i4S52F-6dJiTx7TExj+rMuMWqou7Ff7SkPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: fix numa stats for thp migration
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 10:16 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Sun, Dec 27, 2020 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > Currently the kernel is not correctly updating the numa stats for
> > NR_FILE_PAGES and NR_SHMEM on THP migration. Fix that. For NR_FILE_DIRTY
> > and NR_ZONE_WRITE_PENDING, although at the moment there is no need to
> > handle THP migration as kernel still does not have write support for
> > file THP but to be more future proof, this patch adds the THP support
> > for those stats as well.
> >
> > Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  mm/migrate.c | 23 ++++++++++++-----------
> >  1 file changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 613794f6a433..ade163c6ecdf 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -402,6 +402,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
> >         struct zone *oldzone, *newzone;
> >         int dirty;
> >         int expected_count = expected_page_refs(mapping, page) + extra_count;
> > +       int nr = thp_nr_pages(page);
> >
> >         if (!mapping) {
> >                 /* Anonymous page without mapping */
> > @@ -437,7 +438,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
> >          */
> >         newpage->index = page->index;
> >         newpage->mapping = page->mapping;
> > -       page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
> > +       page_ref_add(newpage, nr); /* add cache reference */
> >         if (PageSwapBacked(page)) {
> >                 __SetPageSwapBacked(newpage);
> >                 if (PageSwapCache(page)) {
> > @@ -459,7 +460,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
> >         if (PageTransHuge(page)) {
> >                 int i;
> >
> > -               for (i = 1; i < HPAGE_PMD_NR; i++) {
> > +               for (i = 1; i < nr; i++) {
> >                         xas_next(&xas);
> >                         xas_store(&xas, newpage);
> >                 }
> > @@ -470,7 +471,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
> >          * to one less reference.
> >          * We know this isn't the last reference.
> >          */
> > -       page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
> > +       page_ref_unfreeze(page, expected_count - nr);
> >
> >         xas_unlock(&xas);
> >         /* Leave irq disabled to prevent preemption while updating stats */
> > @@ -493,17 +494,17 @@ int migrate_page_move_mapping(struct address_space *mapping,
> >                 old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
> >                 new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
> >
> > -               __dec_lruvec_state(old_lruvec, NR_FILE_PAGES);
> > -               __inc_lruvec_state(new_lruvec, NR_FILE_PAGES);
> > +               __mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
> > +               __mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
> >                 if (PageSwapBacked(page) && !PageSwapCache(page)) {
> > -                       __dec_lruvec_state(old_lruvec, NR_SHMEM);
> > -                       __inc_lruvec_state(new_lruvec, NR_SHMEM);
> > +                       __mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
> > +                       __mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
> >                 }
> >                 if (dirty && mapping_can_writeback(mapping)) {
> > -                       __dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
> > -                       __dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
> > -                       __inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
> > -                       __inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
> > +                       __mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
> > +                       __mod_zone_page_tate(oldzone, NR_ZONE_WRITE_PENDING, -nr);
>
> This should be __mod_zone_page_state(). I fixed locally but sent the
> older patch by mistake.

Acked-by: Yang Shi <shy828301@gmail.com>

>
> > +                       __mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
> > +                       __mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
> >                 }
> >         }
> >         local_irq_enable();
> > --
> > 2.29.2.729.g45daf8777d-goog
> >
>
