Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726192F64E2
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 16:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbhANPjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 10:39:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:49248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbhANPjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 10:39:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610638703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeRFjkYJBJIGL2sjsf3y8jXeoXRfYr95O8LxnCXhhDM=;
        b=oca6QqkWqnSPyzG5NiYYq7/pyff0Ez5l9E2Xzwpbg1mCuf05mT+VEGqYq1KPlmo7lUqXus
        rFEJGEZRfZOBZ22V1aAotvb6OjYH0CiAjNv7PzmTooUIYz76tEK33RDkx5OOvCcxKQhmSQ
        PVg35zjcbUUEb6AN4QKpwr/gjvkre3c=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A01EFB94C;
        Thu, 14 Jan 2021 15:38:22 +0000 (UTC)
Date:   Thu, 14 Jan 2021 16:38:14 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [External] Re: [PATCH v5 3/5] mm: hugetlb: fix a race between
 freeing and dissolving the page
Message-ID: <20210114153814.GB27777@dhcp22.suse.cz>
References: <20210114103515.12955-1-songmuchun@bytedance.com>
 <20210114103515.12955-4-songmuchun@bytedance.com>
 <20210114132036.GA27777@dhcp22.suse.cz>
 <CAMZfGtWFikKztN6DrtmuiHFwc2wHmyGefw6up1xE-koj8WE2SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtWFikKztN6DrtmuiHFwc2wHmyGefw6up1xE-koj8WE2SQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 14-01-21 21:47:36, Muchun Song wrote:
> On Thu, Jan 14, 2021 at 9:20 PM Michal Hocko <mhocko@suse.com> wrote:
[...]
> > > @@ -1770,6 +1789,28 @@ int dissolve_free_huge_page(struct page *page)
> > >               int nid = page_to_nid(head);
> > >               if (h->free_huge_pages - h->resv_huge_pages == 0)
> > >                       goto out;
> > > +
> > > +             /*
> > > +              * We should make sure that the page is already on the free list
> > > +              * when it is dissolved.
> > > +              */
> > > +             if (unlikely(!PageHugeFreed(head))) {
> > > +                     spin_unlock(&hugetlb_lock);
> > > +
> > > +                     /*
> > > +                      * Theoretically, we should return -EBUSY when we
> > > +                      * encounter this race. In fact, we have a chance
> > > +                      * to successfully dissolve the page if we do a
> > > +                      * retry. Because the race window is quite small.
> > > +                      * If we seize this opportunity, it is an optimization
> > > +                      * for increasing the success rate of dissolving page.
> > > +                      */
> > > +                     while (PageHeadHuge(head) && !PageHugeFreed(head))
> > > +                             cond_resched();
> >
> > Sorry, I should have raised that when replying to the previous version
> > already but we have focused more on other things. Is there any special
> > reason that you didn't simply
> >         if (!PageHugeFreed(head)) {
> >                 spin_unlock(&hugetlb_lock);
> >                 cond_resched();
> >                 goto retry;
> >         }
> >
> > This would be less code and a very slight advantage would be that the
> > waiter might get blocked on the spin lock while the concurrent freeing
> > is happening. But maybe you wanted to avoid exactly this contention?
> > Please put your thinking into the changelog.
> 
> I want to avoid the lock contention. I will add this reason
> to the changelog. Thanks.

Please also explain why it matters and whether an unintended contention
is a real problem.
-- 
Michal Hocko
SUSE Labs
