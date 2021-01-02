Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BFA2E8711
	for <lists+stable@lfdr.de>; Sat,  2 Jan 2021 12:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbhABLaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jan 2021 06:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbhABLaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 Jan 2021 06:30:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 917B020857;
        Sat,  2 Jan 2021 11:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609586982;
        bh=12e/d5y8XXJahAgaxYFj4bELsUe5cAYIOPjRCVbsCa8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RdKVQTm+6SQLs5RsdmZLf63WqRtN8cwFFlLM7+G9JsLrkOt2DbGEPZKSolcI5Zl5R
         0nMECjauCyWEpTlcHemc2Oqjk9yHT26n27W29gaSzUInmrs8yyUupsu2FUna3i4F3d
         xCF6nmbH/6hpGdXM6DCKy5EVVJb1sJuwKKKqUZ7QqJY2SsygUFoGXZwZrhVmtV5FkF
         jR18hiSM6B4WEnVoYLW+QQpcDRR8TrlUwbvOx50NN2xJj3ELhtrtijIBLEx+X1NhW+
         QYHOct6dxebhhMJ51zvXYLdoA85sEwe+e9CfS33EMKy2hF4RXieQsTpb+2RxkgfFeI
         xc0mX/qdecHNQ==
Received: by mail-oi1-f180.google.com with SMTP id s2so26668030oij.2;
        Sat, 02 Jan 2021 03:29:42 -0800 (PST)
X-Gm-Message-State: AOAM532rItAiD6qxosU/k5lQXSrDD7a6GD4sxDHnx/xLF1/nRMAqZSuB
        awog02esWxeVmP9UuAOpYfEOC96P/+8P8kYHzl4=
X-Google-Smtp-Source: ABdhPJwOoZJeWc4//XjRrhGjpBMg/U98KqEnfR9Yy6/+iQ0miwRI9ziRuNwH0dnt5/BAc6q3t6rn+pozBVHq3Qu2tJ4=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr12999133oig.33.1609586981969;
 Sat, 02 Jan 2021 03:29:41 -0800 (PST)
MIME-Version: 1.0
References: <20201228124919.745526410@linuxfoundation.org> <20201228124933.649086790@linuxfoundation.org>
 <20201231200913.GA32313@amd>
In-Reply-To: <20201231200913.GA32313@amd>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 2 Jan 2021 12:29:31 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGPtz5Qh4CDE=wBG29U8ESxfOEjZLi9DK4a-9LH7kcMow@mail.gmail.com>
Message-ID: <CAMj1kXGPtz5Qh4CDE=wBG29U8ESxfOEjZLi9DK4a-9LH7kcMow@mail.gmail.com>
Subject: Re: [PATCH 4.19 287/346] crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 31 Dec 2020 at 21:09, Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > ecdh_set_secret() casts a void* pointer to a const u64* in order to
> > feed it into ecc_is_key_valid(). This is not generally permitted by
> > the C standard, and leads to actual misalignment faults on ARMv6
> > cores. In some cases, these are fixed up in software, but this still
> > leads to performance hits that are entirely avoidable.
> >
> > So let's copy the key into the ctx buffer first, which we will do
> > anyway in the common case, and which guarantees correct alignment.
>
> Fair enough... but: params.key_size is validated in
> ecc_is_key_valid(), and that now happens _after_ memcpy.
>
> How is it guaranteed that we don't overflow the buffer during memcpy?
>

It is not, thanks for pointing that out. There are some redundant
checks being performed, so you won't trigger it easily with fuzzing,
but afaict, an intentionally crafted invalid input could indeed
overflow the buffer.

I'll send a fix shortly.

> > +++ b/crypto/ecdh.c
> > @@ -57,12 +57,13 @@ static int ecdh_set_secret(struct crypto
> >               return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
> >                                      ctx->private_key);
> >
> > -     if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
> > -                          (const u64 *)params.key, params.key_size) < 0)
> > -             return -EINVAL;
> > -
> >       memcpy(ctx->private_key, params.key, params.key_size);
> >
> > +     if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
> > +                          ctx->private_key, params.key_size) < 0) {
> > +             memzero_explicit(ctx->private_key, params.key_size);
> > +             return -EINVAL;
> > +     }
> >       return 0;
>
> Best regards,
>                                                                 Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
