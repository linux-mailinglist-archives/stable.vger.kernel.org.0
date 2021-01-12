Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0E52F2F3E
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388057AbhALMi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:38:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:39110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbhALMi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:38:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610455060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=38R9LgWGn4HEbk8lBrJ1162Zlh+4fmrREhjPSswCAzI=;
        b=N7O1JFwWEvZ23+2FUC5qF2sVBZeBWItKxBIalOcY9CTay4lcsHp+Nc1Qv/jJhOXZ0CgXO0
        i239RmMfoqjUxt2+iW75dpQMiO+QV+40IBMc4p0PbqjwxlNM0rtKvMYLHTRQV9b0jFuf4U
        SY7AsDPptkXSQWlSymYDRmMyS7h13T4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DCDF9ACF5;
        Tue, 12 Jan 2021 12:37:39 +0000 (UTC)
Date:   Tue, 12 Jan 2021 13:37:38 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [External] Re: [PATCH v3 3/6] mm: hugetlb: fix a race between
 freeing and dissolving the page
Message-ID: <20210112123738.GQ22493@dhcp22.suse.cz>
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-4-songmuchun@bytedance.com>
 <20210112100213.GK22493@dhcp22.suse.cz>
 <CAMZfGtVJVsuL39owkT+Sp8A7ywXJLhbiQ6zYgL9FKhqSeAvy=w@mail.gmail.com>
 <20210112111712.GN22493@dhcp22.suse.cz>
 <CAMZfGtWt5+03Pne9QjLn53kqUbZWSmi0f-iEOisHO6LjohdXFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtWt5+03Pne9QjLn53kqUbZWSmi0f-iEOisHO6LjohdXFA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 12-01-21 19:43:21, Muchun Song wrote:
> On Tue, Jan 12, 2021 at 7:17 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Tue 12-01-21 18:13:02, Muchun Song wrote:
> > > On Tue, Jan 12, 2021 at 6:02 PM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Sun 10-01-21 20:40:14, Muchun Song wrote:
> > > > [...]
> > > > > @@ -1770,6 +1788,14 @@ int dissolve_free_huge_page(struct page *page)
> > > > >               int nid = page_to_nid(head);
> > > > >               if (h->free_huge_pages - h->resv_huge_pages == 0)
> > > > >                       goto out;
> > > > > +
> > > > > +             /*
> > > > > +              * We should make sure that the page is already on the free list
> > > > > +              * when it is dissolved.
> > > > > +              */
> > > > > +             if (unlikely(!PageHugeFreed(head)))
> > > > > +                     goto out;
> > > > > +
> > > >
> > > > Do you really want to report EBUSY in this case? This doesn't make much
> > > > sense to me TBH. I believe you want to return 0 same as when you race
> > > > and the page is no longer PageHuge.
> > >
> > > Return 0 is wrong. Because the page is not freed to the buddy allocator.
> > > IIUC, dissolve_free_huge_page returns 0 when the page is already freed
> > > to the buddy allocator. Right?
> >
> > 0 is return when the page is either dissolved or it doesn't need
> > dissolving. If there is a race with somebody else freeing the page then
> > there is nothing to dissolve. Under which condition it makes sense to
> > report the failure and/or retry dissolving?
> 
> If there is a race with somebody else freeing the page, the page
> can be freed to the hugepage pool not the buddy allocator. Do
> you think that this page is dissolved?

OK, I see what you mean. Effectively the page would be in a limbo, not
yet in the pool nor in the allocator but it can find its way to the
either of the two. But I still dislike returning a failure because that
would mean e.g. memory hotplug to fail. Can you simply retry inside this
code path (drop the lock, cond_resched and retry)?
-- 
Michal Hocko
SUSE Labs
