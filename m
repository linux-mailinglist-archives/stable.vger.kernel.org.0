Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AE8221D5F
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 09:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgGPH1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 03:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPH1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 03:27:20 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB2CC061755;
        Thu, 16 Jul 2020 00:27:20 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id a32so4170171qtb.5;
        Thu, 16 Jul 2020 00:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mG+5r3Bbvfyvan+6MBZ/JpRKfD01WWFPaoiNv0YZf7w=;
        b=Jn671trs6n5nTnZti1vRIBPjT5T06LAsnG/I6MhPlPjgcI9ST7lvhP0NLrvxJtrwge
         nyn0gwE2ggSL2JIYRtSTlG2W52m9yxANKk7uuYhddC25RBdSX+cizQG9Mpe69ht1mj95
         iyerwy63/2w4hgEr4PnT5TdzXywa1m+yzOahAhcuxya0Hb3lqfGReAxTXSiDVj36EBlY
         iNjkIhJodq8jTE+s5Wfg+Xi0Oc5omdDCmpER6iZGu07zAcPXqYTEzymHYeJf6L9kWDYF
         MPqmGS1V1Ydc+FLEryF6Hn8DLphkWdbjFghjDll1nFeezs/tAYtykGEc0f9AaZURauLs
         1bag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mG+5r3Bbvfyvan+6MBZ/JpRKfD01WWFPaoiNv0YZf7w=;
        b=c1YC+1oFH2e2h9zQGEBoucjOfa0Bjz4hALs1uhKNnZ0wxsO4QGFubOxzpT4f28MQu5
         ST8GxW8sp/mnOV9TlTQFGkBmtlaK9gnX/vydfCww8kIjXZliaaFv1Nc5H2CekeGwd0/z
         W2z9BREx/g6wDwIGYenwTQmQ08Sj9UofVBxtPeSwHJm1Wgaj6mQ+HWGoXHM4T/klDAAO
         3cxS9ewbj6U48VPT2e/ICSqjzszqULoxmMkPj7FFdQRqkOBok6cYJCwMN33pX1zAIUIl
         SrY1mu+eVA2ehKTRd1+WQrW/CILZcNsjUxTzMfTHeYmBtpJlhjFzb6dPdevLsMfgI1EF
         BVXQ==
X-Gm-Message-State: AOAM531t+3ZyJxvSNQfBtSyqyIl5qhMe8ZEjy+CLkt7bJwf0ZWmu2QaT
        IgXgLMWDhMqybSvxlAFflDmBeE5LbeFkmDMKLNM=
X-Google-Smtp-Source: ABdhPJysGNQjcai2r2CbeSRjjukHEMXPMsjgUJj66qgAo1u2YzZb7m/C/IhHcy7yV5ZvPH2pJ4AIJUWlj3rRsutLwMc=
X-Received: by 2002:aed:22ef:: with SMTP id q44mr3559256qtc.333.1594884439849;
 Thu, 16 Jul 2020 00:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com> <332d620b-bfe3-3b69-931b-77e3a74edbfd@suse.cz>
In-Reply-To: <332d620b-bfe3-3b69-931b-77e3a74edbfd@suse.cz>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Thu, 16 Jul 2020 16:27:09 +0900
Message-ID: <CAAmzW4NbG0fCtU2mV83pRamUeOEqKKxGTpQK2zuDxzmoF2FVrg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020=EB=85=84 7=EC=9B=94 15=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 5:24, V=
lastimil Babka <vbabka@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 7/15/20 7:05 AM, js1304@gmail.com wrote:
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > Currently, preventing cma area in page allocation is implemented by usi=
ng
> > current_gfp_context(). However, there are two problems of this
> > implementation.
> >
> > First, this doesn't work for allocation fastpath. In the fastpath,
> > original gfp_mask is used since current_gfp_context() is introduced in
> > order to control reclaim and it is on slowpath.
> > Second, clearing __GFP_MOVABLE has a side effect to exclude the memory
> > on the ZONE_MOVABLE for allocation target.
> >
> > To fix these problems, this patch changes the implementation to exclude
> > cma area in page allocation. Main point of this change is using the
> > alloc_flags. alloc_flags is mainly used to control allocation so it fit=
s
> > for excluding cma area in allocation.
>
> Agreed, should have been done with ALLOC_CMA since the beginning.
>
> > Fixes: d7fefcc (mm/cma: add PF flag to force non cma alloc)
>
> More digits please.
> Fixes: d7fefcc8de91 ("mm/cma: add PF flag to force non cma alloc")

Will do.

> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> >  include/linux/sched/mm.h |  4 ----
> >  mm/page_alloc.c          | 27 +++++++++++++++------------
> >  2 files changed, 15 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> > index 44ad5b7..a73847a 100644
> > --- a/include/linux/sched/mm.h
> > +++ b/include/linux/sched/mm.h
> > @@ -191,10 +191,6 @@ static inline gfp_t current_gfp_context(gfp_t flag=
s)
> >                       flags &=3D ~(__GFP_IO | __GFP_FS);
> >               else if (pflags & PF_MEMALLOC_NOFS)
> >                       flags &=3D ~__GFP_FS;
>
> Above this hunk you should also remove PF_MEMALLOC_NOCMA from the test.

Will do.

> > -#ifdef CONFIG_CMA
> > -             if (pflags & PF_MEMALLOC_NOCMA)
> > -                     flags &=3D ~__GFP_MOVABLE;
> > -#endif
> >       }
> >       return flags;
> >  }
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 6416d08..cd53894 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2791,7 +2791,7 @@ __rmqueue(struct zone *zone, unsigned int order, =
int migratetype,
> >        * allocating from CMA when over half of the zone's free memory
> >        * is in the CMA area.
> >        */
> > -     if (migratetype =3D=3D MIGRATE_MOVABLE &&
> > +     if (alloc_flags & ALLOC_CMA &&
> >           zone_page_state(zone, NR_FREE_CMA_PAGES) >
> >           zone_page_state(zone, NR_FREE_PAGES) / 2) {
> >               page =3D __rmqueue_cma_fallback(zone, order);
> > @@ -2802,7 +2802,7 @@ __rmqueue(struct zone *zone, unsigned int order, =
int migratetype,
> >  retry:
> >       page =3D __rmqueue_smallest(zone, order, migratetype);
> >       if (unlikely(!page)) {
> > -             if (migratetype =3D=3D MIGRATE_MOVABLE)
> > +             if (alloc_flags & ALLOC_CMA)
> >                       page =3D __rmqueue_cma_fallback(zone, order);
> >
> >               if (!page && __rmqueue_fallback(zone, order, migratetype,
> > @@ -3502,11 +3502,9 @@ static inline long __zone_watermark_unusable_fre=
e(struct zone *z,
> >       if (likely(!alloc_harder))
> >               unusable_free +=3D z->nr_reserved_highatomic;
> >
> > -#ifdef CONFIG_CMA
> >       /* If allocation can't use CMA areas don't use free CMA pages */
> > -     if (!(alloc_flags & ALLOC_CMA))
> > +     if (IS_ENABLED(CONFIG_CMA) && !(alloc_flags & ALLOC_CMA))
> >               unusable_free +=3D zone_page_state(z, NR_FREE_CMA_PAGES);
> > -#endif
> >
> >       return unusable_free;
> >  }
> > @@ -3693,6 +3691,16 @@ alloc_flags_nofragment(struct zone *zone, gfp_t =
gfp_mask)
> >       return alloc_flags;
> >  }
> >
> > +static inline void current_alloc_flags(gfp_t gfp_mask,
> > +                             unsigned int *alloc_flags)
> > +{
> > +     unsigned int pflags =3D READ_ONCE(current->flags);
> > +
> > +     if (!(pflags & PF_MEMALLOC_NOCMA) &&
> > +             gfp_migratetype(gfp_mask) =3D=3D MIGRATE_MOVABLE)
> > +             *alloc_flags |=3D ALLOC_CMA;
> > +}
>
> I don't like the modification through parameter, would just do what
> current_gfp_context() does and return the modified value.
> Also make it a no-op (including no READ_ONCE(current->flags)) if !CONFIG_=
CMA,
> please.

Okay.

> >  /*
> >   * get_page_from_freelist goes through the zonelist trying to allocate
> >   * a page.
> > @@ -3706,6 +3714,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned i=
nt order, int alloc_flags,
> >       struct pglist_data *last_pgdat_dirty_limit =3D NULL;
> >       bool no_fallback;
> >
> > +     current_alloc_flags(gfp_mask, &alloc_flags);
>
> I don't see why to move the test here? It will still be executed in the
> fastpath, if that's what you wanted to avoid.

I want to execute it on the fastpath, too. Reason that I moved it here
is that alloc_flags could be reset on slowpath. See the code where
__gfp_pfmemalloc_flags() is on. This is the only place that I can apply
this option to all the allocation paths at once.

Thanks.

> > +
> >  retry:
> >       /*
> >        * Scan zonelist, looking for a zone with enough free.
> > @@ -4339,10 +4349,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
> >       } else if (unlikely(rt_task(current)) && !in_interrupt())
> >               alloc_flags |=3D ALLOC_HARDER;
> >
> > -#ifdef CONFIG_CMA
> > -     if (gfp_migratetype(gfp_mask) =3D=3D MIGRATE_MOVABLE)
> > -             alloc_flags |=3D ALLOC_CMA;
> > -#endif
>
> I would just replace this here with:
> alloc_flags =3D current_alloc_flags(gfp_mask, alloc_flags);
>
> >       return alloc_flags;
> >  }
> >
> > @@ -4808,9 +4814,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_=
mask, unsigned int order,
> >       if (should_fail_alloc_page(gfp_mask, order))
> >               return false;
> >
> > -     if (IS_ENABLED(CONFIG_CMA) && ac->migratetype =3D=3D MIGRATE_MOVA=
BLE)
> > -             *alloc_flags |=3D ALLOC_CMA;
>
> And same here... Ah, I see. current_alloc_flags() should probably take a
> migratetype parameter instead of gfp_mask then.
>
> > -
> >       return true;
> >  }
> >
> >
>
