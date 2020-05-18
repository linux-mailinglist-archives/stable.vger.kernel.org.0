Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F5A1D7732
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 13:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgERLdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 07:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgERLdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 07:33:55 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1EDC061A0C;
        Mon, 18 May 2020 04:33:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id b8so4660313pgi.11;
        Mon, 18 May 2020 04:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eJccfybN0sdNJ8ylX53cDwC7dY9jWBu+I0/w3Xw+cBs=;
        b=dhzh1omwrLM8jvSd0mWoUvTHmS4XEDbVWxMoTMADnXAKl3vN8Vx+B1sr4yx8mpwhN8
         ERGpklHuqHhD7nk+hCZ6OD5cAEt1Q4kw+ePgxqT9Aa+eZT+Pf92cktTooIV4J4zrYVzK
         GEwdlt9w1w6jQPJA2UB83YNy2B8J+lyYRfBcsXWSvI+VoyEzgjnp2/tNXESdBC2s0iVE
         nvTsnGj4U40Yqdmkxqpq6Ow5jtHIWMuPxYMTahWTbGLLh42LHaNrB7Bzm2KTMxXfvQ53
         +qPfPP2unWxuvvdjHxPdJU9VWELTuPyXY1LUwCAdDFYvJ+9Of06RfW7ltfDlwpc9rGVi
         5NjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eJccfybN0sdNJ8ylX53cDwC7dY9jWBu+I0/w3Xw+cBs=;
        b=jw5Gvc2dWAVM3kOXjqy6sPebmb2jpeiePPVgF3usdTvDlEIs4FGDckA4z3Hm6yPNwR
         byf0p1FaNDcJw/1A+Z2zok2xZbw6DiHB7OsEkBwT1+efz5SAIINtZqek1r0WW2GojWrC
         2z2/3JdEKgdLiyDNpvuGETVXIrhMN98gnJw7yZpzW78a3t2W4D39FyYGJXP2Vht8YP6x
         BSuxFN7Inuwxs/slJ2Tpc4wXxpWjdme1GG8Gq3l6XHlIcsa+HdjEPPBEirGOOEaiQDUy
         25Eh+D7Br3C+efh/ZTU5wCl1RUbIdQYQar3wcy8TCzTwMu9eQGHG+7nssYbOa8fogZp9
         ac5Q==
X-Gm-Message-State: AOAM530lDtwHam4UZFNDtTnmncIZ+JhvnH8J5mdGBrHCUkr9Q/U7JIIO
        6NHFc4qwJj8dabJ2KunUOxee4aTWF4agBUZ0n/X2kZkD5As=
X-Google-Smtp-Source: ABdhPJzvOKa+Hpz8yWlRZuCdRSLjZynM4FloBpo5HWvOJMO9MDeg+BZQ1TwU24yvRdCHiAzMpk5JcPujLByGvphCoag=
X-Received: by 2002:a62:5ec7:: with SMTP id s190mr15951343pfb.130.1589801634593;
 Mon, 18 May 2020 04:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <1589798090-11136-1-git-send-email-agordeev@linux.ibm.com>
In-Reply-To: <1589798090-11136-1-git-send-email-agordeev@linux.ibm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 18 May 2020 14:33:43 +0300
Message-ID: <CAHp75VdM2yrpd2d3pK2RkmbhF3yiM4=fiTXL4i3yu3AxV3wY-A@mail.gmail.com>
Subject: Re: [PATCH RESEND] lib: fix bitmap_parse() on 64-bit big endian archs
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 1:40 PM Alexander Gordeev
<agordeev@linux.ibm.com> wrote:
>
> Commit 2d6261583be0 ("lib: rework bitmap_parse()") does
> not take into account order of halfwords on 64-bit big
> endian architectures.

Thanks for report and the patch!

Did it work before? Can we have a test case for that that we will see
the failure?

> Fixes: 2d6261583be0 ("lib: rework bitmap_parse()")
> Cc: stable@vger.kernel.org
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Amritha Nambiar <amritha.nambiar@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: "Tobin C . Harding" <tobin@kernel.org>
> Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  lib/bitmap.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 89260aa..a725e46 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -717,6 +717,19 @@ static const char *bitmap_get_x32_reverse(const char *start,
>         return end;
>  }
>
> +#if defined(__BIG_ENDIAN) && defined(CONFIG_64BIT)
> +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> +{
> +       maskp += (chunk_idx / 2);
> +       ((u32 *)maskp)[(chunk_idx & 1) ^ 1] = chunk;
> +}
> +#else
> +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> +{
> +       ((u32 *)maskp)[chunk_idx] = chunk;
> +}
> +#endif
> +
>  /**
>   * bitmap_parse - convert an ASCII hex string into a bitmap.
>   * @start: pointer to buffer containing string.
> @@ -738,7 +751,8 @@ int bitmap_parse(const char *start, unsigned int buflen,
>  {
>         const char *end = strnchrnul(start, buflen, '\n') - 1;
>         int chunks = BITS_TO_U32(nmaskbits);
> -       u32 *bitmap = (u32 *)maskp;
> +       int chunk_idx = 0;
> +       u32 chunk;
>         int unset_bit;
>
>         while (1) {
> @@ -749,9 +763,11 @@ int bitmap_parse(const char *start, unsigned int buflen,
>                 if (!chunks--)
>                         return -EOVERFLOW;
>
> -               end = bitmap_get_x32_reverse(start, end, bitmap++);
> +               end = bitmap_get_x32_reverse(start, end, &chunk);
>                 if (IS_ERR(end))
>                         return PTR_ERR(end);
> +
> +               save_x32_chunk(maskp, chunk, chunk_idx++);
>         }
>
>         unset_bit = (BITS_TO_U32(nmaskbits) - chunks) * 32;
> --
> 1.8.3.1
>


-- 
With Best Regards,
Andy Shevchenko
