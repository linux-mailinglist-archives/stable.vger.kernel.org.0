Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB68F2237F5
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgGQJO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 05:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgGQJO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 05:14:26 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344FAC061755;
        Fri, 17 Jul 2020 02:14:26 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 145so8123884qke.9;
        Fri, 17 Jul 2020 02:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TTah83XUjnFYRYk4+z1WzNDw5yUiECajFe5/YPDgJlc=;
        b=TQheRHn1cXzAuyeAdVJtG46D6J951Kk4qGPQR2X703/XXvKFQrxQ5YJZpo8d0xYzfA
         G1Ghdb7LaYEqxJkZO+RLdKrzPdfnQ43SnF9QgXLfe/odBI6RU7CpT7+hAzjoLxDWUJPE
         taRBvSd/PXI3ypGn1mKESnLFG6nTFmfYRafYZGCGYfYtOVoJjwB9krtehBjwWXbre8m6
         sEnA90M7w/zCaf3qrS530VXFdciyuBxBx9IXXX17qBpYVAkTaPhQwguTSTWNlAegbnVP
         x07Hacdjp0FdkYy3TCxXSj+flKd3GJhCX8lWfQolxLCNiKb2+RrMgrnlhTgoomzxCs8O
         g15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TTah83XUjnFYRYk4+z1WzNDw5yUiECajFe5/YPDgJlc=;
        b=mtCC1NoSlW+kpiTDm04oR2aNLvhvvXPYSpcM4FFoGqDAy5ALH5agID/spyx/kUAeo4
         smTi0k93VoQak074A0+tWWz1SI6E0qkOvq9+/5qvCcptM5epsK6EwO9JQmGbT9F0TYyN
         wBoQH28MdMEE/GJDcy/dqvW32breZVVOtLXfZjrIf7YoxrYMpMVz2Nz7qHgOxtphpkXo
         3Px8DFJHNrvRj/06SCnkhKnmLJCciAA9IaL9sDZhM0PxS7syFET0RD4uP7qqvIa805ao
         OyigYff+WFQn9NPFv744O+dzzOe8y6Toq3H/cgJOhCT7lH5IRDPJ+3TUdKsStR3ow/9Z
         q2xQ==
X-Gm-Message-State: AOAM533+ZBHRB29/p96nemEvNGz1ceqwbPDYaaPPkTYH4ezijnI5MUzA
        kdijLxdx+0yrh/VWqTlhLuzNerSkQRodOCh7udGCoQ==
X-Google-Smtp-Source: ABdhPJxvM0u07hwrbNojbkX69s729/X1zvnefAfZ7a28oA6/z8xgZwIufAPfsMk3UtbX7ynthXdoomYlrLvjC7Mvhw8=
X-Received: by 2002:a37:6d2:: with SMTP id 201mr7473861qkg.187.1594977265463;
 Fri, 17 Jul 2020 02:14:25 -0700 (PDT)
MIME-Version: 1.0
References: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com> <be55deff4ef1453983522d247bd36110@AcuMS.aculab.com>
In-Reply-To: <be55deff4ef1453983522d247bd36110@AcuMS.aculab.com>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Fri, 17 Jul 2020 18:14:14 +0900
Message-ID: <CAAmzW4PPoSU6s8SQKRZAgLbfHz6LY5QXPWWjv2+iCM5iM3j51A@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
To:     David Laight <David.Laight@aculab.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@lge.com" <kernel-team@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020=EB=85=84 7=EC=9B=94 17=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 5:32, D=
avid Laight <David.Laight@aculab.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> From: js1304@gmail.com
> > Sent: 15 July 2020 06:05
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > Currently, preventing cma area in page allocation is implemented by usi=
ng
> > current_gfp_context(). However, there are two problems of this
> > implementation.
> ...
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 6416d08..cd53894 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> ...
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
> > +
>
> I'd guess this would be easier to understand and probably generate
> better code if renamed and used as:
>         alloc_flags |=3D can_alloc_cma(gpf_mask);
>
> Given it is a 'static inline' the compiler might end up
> generating the same code.
> If you needed to clear a flag doing:
>         alloc_flags =3D current_alloc_flags(gpf_mask, alloc_flags);
> is much better for non-inlined function.

Vlastimil suggested this way and I have agreed with that. Anyway,
thanks for the suggestion.

Thanks.
