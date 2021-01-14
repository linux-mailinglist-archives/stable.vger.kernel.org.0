Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4364E2F625C
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 14:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbhANNtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 08:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbhANNtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 08:49:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C920C061575
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 05:48:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l23so3220415pjg.1
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 05:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMAwTolIz7BCXLPef7/V0xFFPky4VaH+dzKWAXw2Md4=;
        b=RKUJGdmzoHCY767iJgJb4RgZDksjjlM/bZ2pzDYdnm6YwNmhYZhcMS3S5/+az0bX8L
         ru08QVVt0u7DoUVkN0fEew3C+0xkHF+/2TZK3WBOyL8QclgjJfUCzrfiihPxQhMxYP2D
         4+8EE8jl35IZf2oSxFxse6HtBpEM0t2nRTmh6xwshp6EP3UCIu+5/6e+/e6IITxqC+vN
         3H0+n0dyFzXLzhLd68uVIFCUxYCfYnFjfOz/jMk8pTCoC4I0UrihEOB4m78a9Uv0KkwE
         Q1WwV1RCGRCzutAQoIXKcGZyUUazeDE7zx3wzSBUGK4Sft1Mp9umFLLnpHnEkQYZ0nBv
         d6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMAwTolIz7BCXLPef7/V0xFFPky4VaH+dzKWAXw2Md4=;
        b=Wr56/qeRufAAf4gl2iqSK5cYG8AHLPacE/hNan1kVGGSidtnW5pyeSj4bw7mwgg/IO
         j8bcvSj3wn0sh/2pUUqqpF2rAiqRj02qx0dG4Jx2NNkeXC5IEdII8ImJnI1G9y515mz7
         Yy51UD6huRZQq46og9I39dxg159Z7NP1moBAR1pi4XuK1jR6BEpN6sdFEsmBdbtwjpwO
         k7YgDdMmoID1DTIu6eLJSZuNIBy5+GF4qRXMrruX4GpUf/+X4iaE0cnb5Z/h1ORQ6UGj
         Ecrc/mgBtXdisuw8UcI1XuaRg84oa4YqvOTgB5aIWRJ5MJLqTWzb36UVBDiOTIBOCrkX
         TYcQ==
X-Gm-Message-State: AOAM53264S53b+y85FMXJhbTks7iHvXv8ztAI9NNeT/WLe3syUPTDzF1
        dq6PszlhcNuVY2egzY1mDjIvSzJoFDXnDX4+9p4VVQ==
X-Google-Smtp-Source: ABdhPJyweVc8rWi3+2qzxJ9OFjKhe/VPakkxKSdANKScqHC3U/euQDfJJNkASKGF7HBN8KKN2WlEQlAQXCDLNAGiYhI=
X-Received: by 2002:a17:902:b416:b029:dc:3657:9265 with SMTP id
 x22-20020a170902b416b02900dc36579265mr7670391plr.24.1610632097712; Thu, 14
 Jan 2021 05:48:17 -0800 (PST)
MIME-Version: 1.0
References: <20210114103515.12955-1-songmuchun@bytedance.com>
 <20210114103515.12955-4-songmuchun@bytedance.com> <20210114132036.GA27777@dhcp22.suse.cz>
In-Reply-To: <20210114132036.GA27777@dhcp22.suse.cz>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Thu, 14 Jan 2021 21:47:36 +0800
Message-ID: <CAMZfGtWFikKztN6DrtmuiHFwc2wHmyGefw6up1xE-koj8WE2SQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5 3/5] mm: hugetlb: fix a race between
 freeing and dissolving the page
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 9:20 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Thu 14-01-21 18:35:13, Muchun Song wrote:
> > There is a race condition between __free_huge_page()
> > and dissolve_free_huge_page().
> >
> > CPU0:                         CPU1:
> >
> > // page_count(page) == 1
> > put_page(page)
> >   __free_huge_page(page)
> >                               dissolve_free_huge_page(page)
> >                                 spin_lock(&hugetlb_lock)
> >                                 // PageHuge(page) && !page_count(page)
> >                                 update_and_free_page(page)
> >                                 // page is freed to the buddy
> >                                 spin_unlock(&hugetlb_lock)
> >     spin_lock(&hugetlb_lock)
> >     clear_page_huge_active(page)
> >     enqueue_huge_page(page)
> >     // It is wrong, the page is already freed
> >     spin_unlock(&hugetlb_lock)
> >
> > The race windows is between put_page() and dissolve_free_huge_page().
> >
> > We should make sure that the page is already on the free list
> > when it is dissolved.
>
> Please describe user visible effects as suggested in
> http://lkml.kernel.org/r/20210113093134.GU22493@dhcp22.suse.cz

Sorry forgot to update this.

>
> > Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  mm/hugetlb.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> [...]
> > +retry:
> >       /* Not to disrupt normal path by vainly holding hugetlb_lock */
> >       if (!PageHuge(page))
> >               return 0;
> > @@ -1770,6 +1789,28 @@ int dissolve_free_huge_page(struct page *page)
> >               int nid = page_to_nid(head);
> >               if (h->free_huge_pages - h->resv_huge_pages == 0)
> >                       goto out;
> > +
> > +             /*
> > +              * We should make sure that the page is already on the free list
> > +              * when it is dissolved.
> > +              */
> > +             if (unlikely(!PageHugeFreed(head))) {
> > +                     spin_unlock(&hugetlb_lock);
> > +
> > +                     /*
> > +                      * Theoretically, we should return -EBUSY when we
> > +                      * encounter this race. In fact, we have a chance
> > +                      * to successfully dissolve the page if we do a
> > +                      * retry. Because the race window is quite small.
> > +                      * If we seize this opportunity, it is an optimization
> > +                      * for increasing the success rate of dissolving page.
> > +                      */
> > +                     while (PageHeadHuge(head) && !PageHugeFreed(head))
> > +                             cond_resched();
>
> Sorry, I should have raised that when replying to the previous version
> already but we have focused more on other things. Is there any special
> reason that you didn't simply
>         if (!PageHugeFreed(head)) {
>                 spin_unlock(&hugetlb_lock);
>                 cond_resched();
>                 goto retry;
>         }
>
> This would be less code and a very slight advantage would be that the
> waiter might get blocked on the spin lock while the concurrent freeing
> is happening. But maybe you wanted to avoid exactly this contention?
> Please put your thinking into the changelog.

I want to avoid the lock contention. I will add this reason
to the changelog. Thanks.

>
> > +
> > +                     goto retry;
> > +             }
> > +
> >               /*
> >                * Move PageHWPoison flag from head page to the raw error page,
> >                * which makes any subpages rather than the error page reusable.
> > --
> > 2.11.0
>
> --
> Michal Hocko
> SUSE Labs
