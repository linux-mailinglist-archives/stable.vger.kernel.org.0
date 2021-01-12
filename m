Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EEC2F2C60
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 11:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbhALKO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 05:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388583AbhALKO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 05:14:26 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE1CC061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 02:13:45 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q4so1145289plr.7
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 02:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mY8MybgGMFbo1rC5H8TQU94N3Kb/DFvasQ9m5cTkwXs=;
        b=wCY57lWHUIgLP2FDNXDOKdzL/H6OgCcH8g4MAefiujLmQtrsF+E/kALUe/qog9Rhr8
         mvn0VVtdLHiouNOo7EjVoge/SONbmvyR0ZqMf2ojtNCmO9XCAzMafK0uGhs3k1h/URrv
         JIwRwU6vnhJt9B7+IdM40cvTH/0ahQmx4GNxAk2mrC9OxV5tqBND15FI+sExak91NLw3
         97jvsyhjDH2/hWgHlH9ZYFI3AS7ctiaIHQkGPo3BGdI8jEZff6yUSt/qg6TnbtMuTof9
         H61edkeMGT1icNNQvyoFs7dTrUoAM3zbipZMNkKFLoFVZed9Zmd4nuyXxPoAeoa1spYb
         GCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mY8MybgGMFbo1rC5H8TQU94N3Kb/DFvasQ9m5cTkwXs=;
        b=d8p601C1w13MVpQc7SLy1KYOQiikucHE8DFhsh9mDfzSqTKJBVzloPNpaTTqn0eGHv
         gQ0Asy6HtscuIQAhyiRyg871tcfivlULyXmCQUPc5uZZeAMu5Mq6EQgYcV6DZso9Dauw
         MOXkLswDvFkIVIJW8E4e2zhkCJmxCS2DtH8AvwXrPf/efrDwYQPvgNaMwopXPpD4ZINQ
         S3/j20oBQSu530VVUXwV6laou9lF9RexOrh4y7tEw0ZH/XCvdSVTwfl8o7XYHEiLwfuo
         2ywYKE+FrdSQ0Gf+Lq+hqUwvQdxEp1LLijCP+69oHsIxchfMxDmYK+Xr1xfijm57f7nr
         CXqw==
X-Gm-Message-State: AOAM532xS0yO4pOREqqbBZre1FexZX+7S/qhxw2hHoj12vL0uNE9BUo7
        1s3AourNzdAAT7bWzBYRDcGXNZ/dc0fWUrj7rEVYrbc4Dr2CRZu/HQ4=
X-Google-Smtp-Source: ABdhPJxyaUnzFN35cP+WtGSHkOnQlRu2Pwk/F/lCiCoPhLPtHWoBPh3yMZ5ZS4hmMe8y9fq3ZpwGpBo0sKqkICVJg/I=
X-Received: by 2002:a17:902:ed0d:b029:da:c83b:5f40 with SMTP id
 b13-20020a170902ed0db02900dac83b5f40mr4112174pld.20.1610446425119; Tue, 12
 Jan 2021 02:13:45 -0800 (PST)
MIME-Version: 1.0
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-4-songmuchun@bytedance.com> <20210112100213.GK22493@dhcp22.suse.cz>
In-Reply-To: <20210112100213.GK22493@dhcp22.suse.cz>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 12 Jan 2021 18:13:02 +0800
Message-ID: <CAMZfGtVJVsuL39owkT+Sp8A7ywXJLhbiQ6zYgL9FKhqSeAvy=w@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3 3/6] mm: hugetlb: fix a race between
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

On Tue, Jan 12, 2021 at 6:02 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Sun 10-01-21 20:40:14, Muchun Song wrote:
> [...]
> > @@ -1770,6 +1788,14 @@ int dissolve_free_huge_page(struct page *page)
> >               int nid = page_to_nid(head);
> >               if (h->free_huge_pages - h->resv_huge_pages == 0)
> >                       goto out;
> > +
> > +             /*
> > +              * We should make sure that the page is already on the free list
> > +              * when it is dissolved.
> > +              */
> > +             if (unlikely(!PageHugeFreed(head)))
> > +                     goto out;
> > +
>
> Do you really want to report EBUSY in this case? This doesn't make much
> sense to me TBH. I believe you want to return 0 same as when you race
> and the page is no longer PageHuge.

Return 0 is wrong. Because the page is not freed to the buddy allocator.
IIUC, dissolve_free_huge_page returns 0 when the page is already freed
to the buddy allocator. Right?

>
> >               /*
> >                * Move PageHWPoison flag from head page to the raw error page,
> >                * which makes any subpages rather than the error page reusable.
> > --
> > 2.11.0
>
> --
> Michal Hocko
> SUSE Labs
