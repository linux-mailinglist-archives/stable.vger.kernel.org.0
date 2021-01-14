Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1952F6597
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 17:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbhANQRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 11:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbhANQRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 11:17:25 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F062FC061757
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 08:16:44 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 30so4094663pgr.6
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 08:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EdNTOqOvyf8Tea3ZmWu3U3/lQGFILtHgmE8Sp1YYSBw=;
        b=mPaB30g+aaNeYsC8ThEUmugQmr7YYF34vDTtDJQ5bSF2ariYpJUXrAKrWcKzQml1Ce
         BZHHntW620nED3kCQ+r1JnUoQDjP8ItVpFq91JYcbIbfIHkuHd6z6gZDnm16mK/FDifa
         CtkmsHnS1G8bT813sIqDMpSklmtUMYB8DJbbjdhLNs5shLsb+FOEPIOOxyb5HMTs5uYY
         9U2gXhOL5uryQ8sV4z2+GTmCUCZ59gdl4kxCN5hlQxlZTfGTcfvr+L/8CODLM/cWx1Eh
         g2jQqNL7dGAkpZasBARQp0TME7jqU8q/qeU7R49Qv4DH/4AJhCVeDMw3iSSdCHI8/fY/
         q0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EdNTOqOvyf8Tea3ZmWu3U3/lQGFILtHgmE8Sp1YYSBw=;
        b=hgIq0Vl+0jFpL4efBhwNbp26WZIkhzYtMH8Y0e3+i01xQR3CroFKzELBTdJljERPVt
         M5uxxR88D2HQUiedzFDu3t5TpFd0Tw4WOutXjWayYAVN8hVksmD1xlJosvEHqPl1FAx8
         ZrEx9cpnTq/070zpCklXhm3RG3h0A5toWICdDbaF6G3IU4+bHaX2n4pYkTvlyydszKq1
         PWo89s0QHOxKsgwG+1opoPrNPD3TJCg9b0EaAuUQTDUlrgyqmJOxjEONqNyvznX6aMbD
         IdzNy9OjmQlR8DaWn5tWiy+h+4x93L1aI+xK/JtrTlyYvtLVnXUP7eFMiC9Phb7/AqHT
         Hq7Q==
X-Gm-Message-State: AOAM5335zbEXfHOfouf2DIddawmj315Q3oifQdQtEif3+qlH5H2LFu6o
        Dp0Q+LNk7PExnzQfGsuKEijEiVrUWQRGdksrt+yNjA==
X-Google-Smtp-Source: ABdhPJyak9V+7hTS5nAbw63BmX6DhXM6u6obe1PXWk3slHn4QmreKq+n9mbFRtV10UZWIMO1JV5pgg0xda97yeyfIV0=
X-Received: by 2002:a63:50a:: with SMTP id 10mr8230385pgf.273.1610641004434;
 Thu, 14 Jan 2021 08:16:44 -0800 (PST)
MIME-Version: 1.0
References: <20210114103515.12955-1-songmuchun@bytedance.com>
 <20210114103515.12955-4-songmuchun@bytedance.com> <20210114132036.GA27777@dhcp22.suse.cz>
 <CAMZfGtWFikKztN6DrtmuiHFwc2wHmyGefw6up1xE-koj8WE2SQ@mail.gmail.com> <20210114153814.GB27777@dhcp22.suse.cz>
In-Reply-To: <20210114153814.GB27777@dhcp22.suse.cz>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Fri, 15 Jan 2021 00:16:04 +0800
Message-ID: <CAMZfGtW4N-CMKJUWOxQXCz+8kCLw9Hg1P3aG9nST91=18g-CvQ@mail.gmail.com>
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

On Thu, Jan 14, 2021 at 11:38 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Thu 14-01-21 21:47:36, Muchun Song wrote:
> > On Thu, Jan 14, 2021 at 9:20 PM Michal Hocko <mhocko@suse.com> wrote:
> [...]
> > > > @@ -1770,6 +1789,28 @@ int dissolve_free_huge_page(struct page *page)
> > > >               int nid = page_to_nid(head);
> > > >               if (h->free_huge_pages - h->resv_huge_pages == 0)
> > > >                       goto out;
> > > > +
> > > > +             /*
> > > > +              * We should make sure that the page is already on the free list
> > > > +              * when it is dissolved.
> > > > +              */
> > > > +             if (unlikely(!PageHugeFreed(head))) {
> > > > +                     spin_unlock(&hugetlb_lock);
> > > > +
> > > > +                     /*
> > > > +                      * Theoretically, we should return -EBUSY when we
> > > > +                      * encounter this race. In fact, we have a chance
> > > > +                      * to successfully dissolve the page if we do a
> > > > +                      * retry. Because the race window is quite small.
> > > > +                      * If we seize this opportunity, it is an optimization
> > > > +                      * for increasing the success rate of dissolving page.
> > > > +                      */
> > > > +                     while (PageHeadHuge(head) && !PageHugeFreed(head))
> > > > +                             cond_resched();
> > >
> > > Sorry, I should have raised that when replying to the previous version
> > > already but we have focused more on other things. Is there any special
> > > reason that you didn't simply
> > >         if (!PageHugeFreed(head)) {
> > >                 spin_unlock(&hugetlb_lock);
> > >                 cond_resched();
> > >                 goto retry;
> > >         }
> > >
> > > This would be less code and a very slight advantage would be that the
> > > waiter might get blocked on the spin lock while the concurrent freeing
> > > is happening. But maybe you wanted to avoid exactly this contention?
> > > Please put your thinking into the changelog.
> >
> > I want to avoid the lock contention. I will add this reason
> > to the changelog. Thanks.
>
> Please also explain why it matters and whether an unintended contention
> is a real problem.

I have no idea about this, it is just my opinion.
I will follow your suggestion.

> --
> Michal Hocko
> SUSE Labs
