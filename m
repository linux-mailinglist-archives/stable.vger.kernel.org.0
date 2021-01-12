Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F652F2E3A
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 12:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbhALLoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 06:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbhALLoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 06:44:46 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C6C061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 03:44:05 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b5so1497495pjk.2
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 03:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXgK4lRZ9KFIZd6/lO39RKwyKYxTIqhJvO9L+itxVOY=;
        b=E1kst2tXTMFQJDZxPRDVfYPneeubPmbOWsFnTQkvuSZg5zvYvD5+0yEDnDF8qkN9BP
         657+XVe9yrBS8clnMKfyqIIXgqpjvTu0N/NyQaNuLNJWORC4xiZaWRM9xjtlySkNwsM0
         1sDaGLVgx0CnUDPNjy5TqE+G96ULAOU5uOPodXuDdidheJZcvoiodrTwOG2K7N0AaJnH
         umaVi13EGBZKbAH1CAhghwHP3x+vry3WyI20ngDXJh+C2FhyftdlH/HWK9MzjKp0pWMC
         DRZY1fbhTn3YmOVtsOhcJwHFwsJJ/S9l2vvD4t3E6RlAwaVvxDUgBHNNVU9uv28yAzAr
         4JfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXgK4lRZ9KFIZd6/lO39RKwyKYxTIqhJvO9L+itxVOY=;
        b=rw4BT1ZAtvI38EU5C+KorI2NkgkUFIW27aw1F1EG/ZVVj44oMdWmmjWPdtmbgbwwnt
         LgoipLij6VGrQnFcifutU0Wcx+X5iVn/yhlBvFM50OWNp7wnxDx2i1Ehk93bMGSMm5nu
         z3m6e5k73xdsg0fKP8C8MTnsyYTdrrHGRUobSJEml/ARPZdQQ7NgMgG70Y8PNdGiEt3O
         Xh8ts3d8IxNtJ5nbUiTcaGdoMWUHvMyncSsMoqPu1bDZQaJq/TCZpQMeAR+p6xdt1hTm
         72OF6/scig0tXL2p5IwU3dkH5nvXxP8OT2fQyohbaNFPu41iyJBhCg4Jz4E9us7SpcXr
         KIEA==
X-Gm-Message-State: AOAM530YALgWrSq71X9CdmyTBp+ipQH+qlWSRS2U6V2M7zy4qnWBBIuS
        JcR3yoeSGS7g0kd3v325Dp5st/4dSFgaAWX89t7aWw==
X-Google-Smtp-Source: ABdhPJwhJTuvwURefw5F76iCXx8fAufBEOUt+yDBCmtfhDnc12TggdrqEgSGxOoLHs+vnRoKR3Pm9R4V3jihjOTSA1s=
X-Received: by 2002:a17:90a:ba88:: with SMTP id t8mr4162139pjr.229.1610451844939;
 Tue, 12 Jan 2021 03:44:04 -0800 (PST)
MIME-Version: 1.0
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-4-songmuchun@bytedance.com> <20210112100213.GK22493@dhcp22.suse.cz>
 <CAMZfGtVJVsuL39owkT+Sp8A7ywXJLhbiQ6zYgL9FKhqSeAvy=w@mail.gmail.com> <20210112111712.GN22493@dhcp22.suse.cz>
In-Reply-To: <20210112111712.GN22493@dhcp22.suse.cz>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 12 Jan 2021 19:43:21 +0800
Message-ID: <CAMZfGtWt5+03Pne9QjLn53kqUbZWSmi0f-iEOisHO6LjohdXFA@mail.gmail.com>
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

On Tue, Jan 12, 2021 at 7:17 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Tue 12-01-21 18:13:02, Muchun Song wrote:
> > On Tue, Jan 12, 2021 at 6:02 PM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Sun 10-01-21 20:40:14, Muchun Song wrote:
> > > [...]
> > > > @@ -1770,6 +1788,14 @@ int dissolve_free_huge_page(struct page *page)
> > > >               int nid = page_to_nid(head);
> > > >               if (h->free_huge_pages - h->resv_huge_pages == 0)
> > > >                       goto out;
> > > > +
> > > > +             /*
> > > > +              * We should make sure that the page is already on the free list
> > > > +              * when it is dissolved.
> > > > +              */
> > > > +             if (unlikely(!PageHugeFreed(head)))
> > > > +                     goto out;
> > > > +
> > >
> > > Do you really want to report EBUSY in this case? This doesn't make much
> > > sense to me TBH. I believe you want to return 0 same as when you race
> > > and the page is no longer PageHuge.
> >
> > Return 0 is wrong. Because the page is not freed to the buddy allocator.
> > IIUC, dissolve_free_huge_page returns 0 when the page is already freed
> > to the buddy allocator. Right?
>
> 0 is return when the page is either dissolved or it doesn't need
> dissolving. If there is a race with somebody else freeing the page then
> there is nothing to dissolve. Under which condition it makes sense to
> report the failure and/or retry dissolving?

If there is a race with somebody else freeing the page, the page
can be freed to the hugepage pool not the buddy allocator. Do
you think that this page is dissolved?

> --
> Michal Hocko
> SUSE Labs
