Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDA935677F
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 11:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349833AbhDGJAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 05:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349834AbhDGJAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 05:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0FD4613AF;
        Wed,  7 Apr 2021 09:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617786039;
        bh=fMpsd6/3AdZowr8uUdPzoLkHuvWBGtqJSRxeuK8Gsyo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I6Trl4WXfXvULtvaMMWeECjjN/7ZQVWVPQ5DKNBRogAXB/4kweusOsIFo9UVbJrK0
         tprbih6ugO62OC+RbgnUM7mpJx7F3sW+sGG1y1fN9UNu+o+sgDdnVV+qr6fBoa5Hv4
         VtspMBnAhZjYYpuKk6kE2Yg5wU6vKpnttJcDv+75oiSq4Eo0amr1SBGBuCA7HCJVYv
         eVc82fVtChtt7BkR1nOK2vgnjGzwYBrDh5ie65fHIl6vj4ZPircD7R8ga2+qyEh2Pg
         MPQPj5D2NoesUwqkjWHoMGKFgtRFZYRWp4E18ZS99rW5L/RRBrpD4M3jCg2l2NzWrX
         KvHSxR6x6fXHA==
Received: by mail-il1-f180.google.com with SMTP id b17so208426ilh.6;
        Wed, 07 Apr 2021 02:00:39 -0700 (PDT)
X-Gm-Message-State: AOAM530Ofov6dWCdhMBIx1LiMQaLW55vgZjrPMusVLKBCy2gN52TBR0U
        Mial+tqY7Rbt4zngfuzWlb2MvsLunyeQtz3G8rQ=
X-Google-Smtp-Source: ABdhPJyIeE9jtyhpe0uhXLjV3hgbaGodJEHOo8fhE+WDAdJBEO7RhLKwzGUrApj/M9LzB23wrxU9f4e9dNcKeJFLmGs=
X-Received: by 2002:a92:1311:: with SMTP id 17mr1528534ilt.134.1617786039153;
 Wed, 07 Apr 2021 02:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210407062916.3465459-1-chenhuacai@loongson.cn> <62DEADA1-E599-4909-84B3-5EF5FF144874@goldelico.com>
In-Reply-To: <62DEADA1-E599-4909-84B3-5EF5FF144874@goldelico.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Wed, 7 Apr 2021 17:00:27 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4cohyqmLEwPQ5B_1ZviOPegB-LSNFGKXvOV6s2zOmh-Q@mail.gmail.com>
Message-ID: <CAAhV-H4cohyqmLEwPQ5B_1ZviOPegB-LSNFGKXvOV6s2zOmh-Q@mail.gmail.com>
Subject: Re: [PATCH V2] MIPS: Fix longstanding errors in div64.h
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Nikolaus,

On Wed, Apr 7, 2021 at 2:57 PM H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
>
> > Am 07.04.2021 um 08:29 schrieb Huacai Chen <chenhuacai@kernel.org>:
> >
> > There are three errors in div64.h caused by commit c21004cd5b4cb7d479514
> > ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."):
> >
> > 1, Only 32bit kernel need __div64_32(), but the above commit makes it
> > depend on 64bit kernel by mistake.
> >
> > 2, asm-generic/div64.h should be included after __div64_32() definition.
> >
> > 3, __n should be initialized as *n before use (and "*__n >> 32" should
> > be "__n >> 32") in __div64_32() definition.
> >
> > Fixes: c21004cd5b4cb7d479514 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> > arch/mips/include/asm/div64.h | 10 +++++-----
> > 1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
> > index dc5ea5736440..3be2318f8e0e 100644
> > --- a/arch/mips/include/asm/div64.h
> > +++ b/arch/mips/include/asm/div64.h
> > @@ -9,9 +9,7 @@
> > #ifndef __ASM_DIV64_H
> > #define __ASM_DIV64_H
> >
> > -#include <asm-generic/div64.h>
> > -
> > -#if BITS_PER_LONG == 64
> > +#if BITS_PER_LONG == 32
> >
> > #include <linux/types.h>
> >
> > @@ -24,9 +22,9 @@
> >       unsigned long __cf, __tmp, __tmp2, __i;                         \
> >       unsigned long __quot32, __mod32;                                \
> >       unsigned long __high, __low;                                    \
> > -     unsigned long long __n;                                         \
> > +     unsigned long long __n = *n;                                    \
> >                                                                       \
> > -     __high = *__n >> 32;                                            \
> > +     __high = __n >> 32;                                             \
> >       __low = __n;                                                    \
> >       __asm__(                                                        \
> >       "       .set    push                                    \n"     \
> > @@ -65,4 +63,6 @@
> >
> > #endif /* BITS_PER_LONG == 64 */
>
> IMHO these #if/else/endif comments should also be fixed.
>
> >
> > +#include <asm-generic/div64.h>
> > +
> > #endif /* __ASM_DIV64_H */
> > --
> > 2.27.0
> >
>
> compiles fine now. But I still get a linker issue:
>
> fs/ubifs/budget.o: In function `div_u64_rem':
> fs/ubifs/budget.c:(.text+0x1fc): undefined reference to `__div64_32'
> fs/ubifs/lpt.o: In function `div_u64_rem':
> fs/ubifs/lpt.c:(.text+0x8fc): undefined reference to `__div64_32'
> make[2]: *** [vmlinux] Error 1
> make[1]: *** [__build_one_by_one] Error 2
> make: *** [__sub-make] Error 2
Oh, there is the 4th bug in this file....
linux/types.h should be included at the first place, otherwise
BITS_PER_LONG is not defined...

Huacai
>
> BR and thanks,
> Nikolaus Schaller
>
