Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA392F4AB6
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbhAMLww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbhAMLwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 06:52:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE633233FA;
        Wed, 13 Jan 2021 11:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610538726;
        bh=ronTwB+LJABXCk1cB+9XpKj/yin7qoHqqnV7QUMI9DE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IIhQsroYOYPKncNEPN6YyjyMWqLM8oZPU37QAiDxO/45evxhEcvPj3g1B6V/HonVR
         Zlgqrl3X7jIIEPf3pyQW7N00vkArxo8XFnI0AgpuUpi0JreJqGs/rNbzfuEpzI3lPR
         beG8B3sOKYMgnRzeoly/GoLS135u/MKHLwotKDgHgA6o9QmMgqtf5lMaa4hpjUW4/F
         An4E/O4Dhu339d4yESEVyRDHT5lxxgGeSU9dgOUL9Ep6WuDik40f6Dn2Popv0DRPND
         /xUNcT1DMjlSN5PgOSEoGIllf/w6UmBk3fIYBRXS7genfOhsCX4MJqBzHoxjAjmxW8
         XTkEaJmDxoD0g==
Received: by mail-oi1-f177.google.com with SMTP id l207so1791672oib.4;
        Wed, 13 Jan 2021 03:52:06 -0800 (PST)
X-Gm-Message-State: AOAM531xe0RjahGji5XjOFxjffxJfICARKOEPuMjHAkjMzPlP+ZIfYOD
        gQabDi7Ve5Bf5FQrf+gqfyH2p7KBnsF1CU08WRc=
X-Google-Smtp-Source: ABdhPJxU3PbRXBqqSYoc5gfshHv8AGoTp+L7cm4PqAzYQ//+7JjiKblQjlwanTAvAYwLPZ5K8E7mlAbWK8lEjDdlXHA=
X-Received: by 2002:aca:dd03:: with SMTP id u3mr920758oig.47.1610538725951;
 Wed, 13 Jan 2021 03:52:05 -0800 (PST)
MIME-Version: 1.0
References: <20210112192818.69921-1-ebiggers@kernel.org>
In-Reply-To: <20210112192818.69921-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 13 Jan 2021 12:51:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGC+TXPCPhVj6KisCPfCZHfRFF45zBiU1KjaBXOsL0xkg@mail.gmail.com>
Message-ID: <CAMj1kXGC+TXPCPhVj6KisCPfCZHfRFF45zBiU1KjaBXOsL0xkg@mail.gmail.com>
Subject: Re: [PATCH RESEND] random: fix the RNDRESEEDCRNG ioctl
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Jan 2021 at 20:30, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
> doesn't make sense.  Reseed it from the input_pool instead.
>
> Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
> Cc: stable@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>
> Andrew, please consider taking this patch since the maintainer has been
> ignoring it for 4 months
> (https://lkml.kernel.org/lkml/20200916041908.66649-1-ebiggers@kernel.org/T/#u).
>
>
>  drivers/char/random.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 5f3b8ac9d97b0..a894c0559a8cf 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1972,7 +1972,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
>                         return -EPERM;
>                 if (crng_init < 2)
>                         return -ENODATA;
> -               crng_reseed(&primary_crng, NULL);
> +               crng_reseed(&primary_crng, &input_pool);
>                 crng_global_init_time = jiffies - 1;
>                 return 0;
>         default:
> --
> 2.30.0
>
