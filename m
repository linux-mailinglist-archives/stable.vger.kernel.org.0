Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A444B3B801E
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhF3Jiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbhF3Jiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 05:38:52 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219C1C06175F
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 02:36:23 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id q16so1755260qke.10
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 02:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YK/zuKzkHZUw7vkPacOqzwtQxHzQHK8toR9/3Xi8XcQ=;
        b=kJvavOsDqqkeQ4CemydJCurCo7x4tLobkVSbycu14OfBqye/Ozw9xlx49rr5CJOSH6
         JZIUIUFdX6ezz8Spq61dKM6mFjjGW1QS1hiEiLPTzcIyxXEQSSy2HVbIj/1eGYZiltIL
         pVADbItRVPPrhh1bvtmkk7hQasfP6kAlnl4x/bIzc/eFN59y+pP7tjzW1pBYPhfOalAA
         ITsDlapjObokgaeeScXtEBOUN8KD5Abgdc4MELB5pKq5HFo1PjoHI8BgCJmOjdeVWpza
         3XxDx5PXx1uTR4yMabufi1P0ammR576k4rLrO2tfzw4ZPTEKGW4NGRZ3fVWpmqehIXPT
         /JFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YK/zuKzkHZUw7vkPacOqzwtQxHzQHK8toR9/3Xi8XcQ=;
        b=GTmNgWemi1iciobc25ZvFUFIzYQQHYWXkYG5rOD79elUJK1eMZXMgsbKI4rjaM7ZIH
         l1fmlFdofO6Ne6AaKKNIKhr9BFXB3GNkkUX91ViKHPjVn+oXTxdgxex+rbE8mDZqB/aI
         pP9LQkuilyTBnoH2ejHZous2tBcKE4evmli+MTV6LLwsyveHG46XBAuCaVLGXJs88X3h
         MdVO2zE3HbdatP/ZaCGmAPMq+D131yQeeJHYYxsHITd240433Xfn7x/5oqv5PGGIUSt3
         FNwOFRx3ntyEsN1BvD8lnLnAK5OGxC2M+/MB3mYIYN3PSvfw0xiSc4aqZZl0XbxQvAhG
         E4BA==
X-Gm-Message-State: AOAM530pwLT/RtSz5fDvoxH+c2qeXLlC5TDtOkaGAywPAHOu26ZhBHqj
        a5loEHbSr1aRcyn24mvW09GPvVRt6BfzB0e/TqMmlQ==
X-Google-Smtp-Source: ABdhPJzsA7rgIHXJqCcVDE8TQTI1dTRKBA5JolE1telOysvTzOsVavirF7XwexYMuCEosJU8X47HQONDn+NdIkeUNp0=
X-Received: by 2002:a05:620a:805:: with SMTP id s5mr25245254qks.326.1625045782023;
 Wed, 30 Jun 2021 02:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210629161738.936790-1-glider@google.com> <CAFqt6zZ8ZL8WtTg368VJ0WHjXc+YzMuA9D8OBXJ5T9j0ePctQQ@mail.gmail.com>
In-Reply-To: <CAFqt6zZ8ZL8WtTg368VJ0WHjXc+YzMuA9D8OBXJ5T9j0ePctQQ@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 30 Jun 2021 11:35:45 +0200
Message-ID: <CAG_fn=XJdZiWrm1o_xqe-V2nAsT6aVBsUTWE9zphwd=LZXGCFA@mail.gmail.com>
Subject: Re: [PATCH v2] kfence: skip DMA allocations
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 9:02 AM Souptick Joarder <jrdr.linux@gmail.com> wro=
te:
>
> On Tue, Jun 29, 2021 at 9:47 PM Alexander Potapenko <glider@google.com> w=
rote:
> >
> > Allocation requests with __GFP_DMA/__GFP_DMA32 or
> > SLAB_CACHE_DMA/SLAB_CACHE_DMA32 cannot be fulfilled by KFENCE, because
> > they must reside in low memory, whereas KFENCE memory pool is located i=
n
> > high memory.
> >
> > Skip such allocations to avoid crashes where DMAable memory is expected=
.
> >
> > Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Marco Elver <elver@google.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: stable@vger.kernel.org # 5.12+
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> >
> > ---
> >
> > v2:
> >  - added parentheses around the GFP clause, as requested by Marco
> > ---
> >  mm/kfence/core.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> > index 4d21ac44d5d35..f7ce3d876bc9e 100644
> > --- a/mm/kfence/core.c
> > +++ b/mm/kfence/core.c
> > @@ -760,6 +760,14 @@ void *__kfence_alloc(struct kmem_cache *s, size_t =
size, gfp_t flags)
> >         if (size > PAGE_SIZE)
> >                 return NULL;
> >
> > +       /*
> > +        * Skip DMA allocations. These must reside in the low memory, w=
hich we
> > +        * cannot guarantee.
> > +        */
> > +       if ((flags & (__GFP_DMA | __GFP_DMA32)) ||
> > +           (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
> > +               return NULL;
> > +
>
> I prefer to move this check at the top of the function.
> Although it won't make much difference except avoiding atomic operations
> in case this condition is true.

Agreed, we probably shouldn't be expecting a constant flow of
allocations from these zones that will be slowed down by this check.
On a related note, Marco suggested moving the PAGE_SIZE check to the
top of the function as well.

It will also make sense to check for GFP_ZONEMASK instead of just GFP DMA f=
lags.
I couldn't see anyone passing e.g. __GFP_HIGHMEM or __GFP_MOVABLE to
kmem_cache_alloc(), but according to mm/slab.c it is possible, so just
to be on the safe side we'd better ignore them as well.

> >         return kfence_guarded_alloc(s, size, flags);
> >  }
> >
> > --
> > 2.32.0.93.g670b81a890-goog
> >
> >



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
