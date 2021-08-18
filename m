Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B94A3F0513
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 15:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbhHRNo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 09:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237528AbhHRNoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 09:44:23 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17705C0613CF
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 06:43:47 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id bj38so2979750qkb.9
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 06:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S5eDEdgJSEI6ifHq/vU3nLhIVHOqJcFRYhjJl8EuhE0=;
        b=Pj9w/afK4xCzTgMwxRehQ4cL3ZQPYEgqHGelBemKLayuGCdC/u/UQ7GJN/pVLWLFLz
         0wDpiapzrWdc/40d0vQF+Mbo6J2QYXmAIiqJq7X69VSww6XYpCy3xJGgY22JNCI5JcRx
         A+EoxuqAdKVG4w+4Gb58kJCvte0r2AazrRVOG/R2dxBd33f1KsLZSJobusbiI3IJSFrS
         NwU3wmxwAae8Smx9NmCXgRWXQ68c87R/8XhB61knpl/zCj8GGV3A5/w+GhMtApXAfeQ4
         lqqkwVCkE4l6QYdWE7tvHbhu4bvpdFGpB9Shu0s1w9Q9+Q8Ure+NROOQVPlG7mSsbnb7
         kI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S5eDEdgJSEI6ifHq/vU3nLhIVHOqJcFRYhjJl8EuhE0=;
        b=OSH8P8BfVEl3HQ0eV8N6dv8eynPvBYDq3D5UE12mU01P5EhDXZ6kgb/ixSEl/7Wd7q
         NUjIbXP7traAEMjBZziU6uPOfBHVsZ1TTEd8RwFfdhAoqMvS8ndjU202l0/nX8ThpFjs
         E+sxScOP0Wnp5ceyJDvmQt9RfEssEmh1j/JuU0j3cAuIGPkX8a1Dd3kt98vWDqT++jxv
         yJsk1Yc+HR1bXUfJO+wpXLuS1X+V0nLHlv+wkk9h9FMdOOj7+o/Xgpfmm0+rrQNFpGxS
         vbqiwbwRy1PADdnYDV4QLaGlW+3kdcWxXXv7STbAp6w7Xyr9dzqZKvyE8nBe9pgxT+aq
         uM/g==
X-Gm-Message-State: AOAM5330CsPd0JRIkYuqFar0xAKQcoj2VEdwC1KdiepvSaUOkFO0D4NW
        zJDNYUIVvVfqWVqJ9uqmKEqYWThJ6XYtslmksjiJEg==
X-Google-Smtp-Source: ABdhPJzl8uL1pta8qcUndh6lp7PpcHPpAa7sjxUZA4U7T7YY7r2wNM73Pq55xSwo7n9r1hQDFzSnZCqDCNWgbSsG/YA=
X-Received: by 2002:a05:620a:d54:: with SMTP id o20mr9700090qkl.326.1629294226642;
 Wed, 18 Aug 2021 06:43:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210818130300.2482437-1-elver@google.com> <CANpmjNPX0SANJ6oDoxDecMfvbZXFhk4qCuaYPyWT1M8FNpy_vw@mail.gmail.com>
In-Reply-To: <CANpmjNPX0SANJ6oDoxDecMfvbZXFhk4qCuaYPyWT1M8FNpy_vw@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 18 Aug 2021 15:43:09 +0200
Message-ID: <CAG_fn=WvyuFbDyx5g8qkjak7H87htc=yk6+5hazXgK5nMZvx1Q@mail.gmail.com>
Subject: Re: [PATCH] kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE
To:     Marco Elver <elver@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 3:40 PM Marco Elver <elver@google.com> wrote:
>
> +Cc Jann
>
> On Wed, 18 Aug 2021 at 15:03, Marco Elver <elver@google.com> wrote:
> >
> > Originally the addr !=3D NULL check was meant to take care of the case
> > where __kfence_pool =3D=3D NULL (KFENCE is disabled). However, this doe=
s not
> > work for addresses where addr > 0 && addr < KFENCE_POOL_SIZE.
> >
> > This can be the case on NULL-deref where addr > 0 && addr < PAGE_SIZE o=
r
> > any other faulting access with addr < KFENCE_POOL_SIZE. While the kerne=
l
> > would likely crash, the stack traces and report might be confusing due
> > to double faults upon KFENCE's attempt to unprotect such an address.
> >
> > Fix it by just checking that __kfence_pool !=3D NULL instead.
> >
> > Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> > Reported-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
> > Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
> > Cc: <stable@vger.kernel.org>    [5.12+]
> > ---
> >  include/linux/kfence.h | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> > index a70d1ea03532..3fe6dd8a18c1 100644
> > --- a/include/linux/kfence.h
> > +++ b/include/linux/kfence.h
> > @@ -51,10 +51,11 @@ extern atomic_t kfence_allocation_gate;
> >  static __always_inline bool is_kfence_address(const void *addr)
> >  {
> >         /*
> > -        * The non-NULL check is required in case the __kfence_pool poi=
nter was
> > -        * never initialized; keep it in the slow-path after the range-=
check.
> > +        * The __kfence_pool !=3D NULL check is required to deal with t=
he case
> > +        * where __kfence_pool =3D=3D NULL && addr < KFENCE_POOL_SIZE. =
Keep it in
> > +        * the slow-path after the range-check!
> >          */
> > -       return unlikely((unsigned long)((char *)addr - __kfence_pool) <=
 KFENCE_POOL_SIZE && addr);
> > +       return unlikely((unsigned long)((char *)addr - __kfence_pool) <=
 KFENCE_POOL_SIZE && __kfence_pool);
> >  }
>
> Jann, I recall discussing this check somewhere around:
> https://lore.kernel.org/linux-doc/CAG48ez0D1+hStZaDOigwbqNqFHJAJtXK+8Nade=
uiu1Byv+xp5A@mail.gmail.com/
>
> I think you pointed out initially that we need another check, but
> somehow that turned into '&& addr' -- I think that's what we ended up
> with because of worry about another memory load, which is clearly
> wrong as that only works if addr=3D=3DNULL. Simply checking
> __kfence_pool!=3DNULL is enough. I also checked codegen, and the
> compiler is smart enough to not reload the global __kfence_pool.
>
> Wanted to call it out, just in case you see something even more
> efficient (probably the only way to do better is to get rid of the 2nd
> branch, which I don't think is possible). :-)
>
> Thanks,
> -- Marco



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
