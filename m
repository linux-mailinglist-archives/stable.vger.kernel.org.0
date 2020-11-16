Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88FF2B49D1
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 16:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgKPPra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 10:47:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730348AbgKPPr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 10:47:29 -0500
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F03F20888;
        Mon, 16 Nov 2020 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605541649;
        bh=sMTgzNRsrEqsRuLvdBLUUHqrR3j8TcZ0NCD0/HoI52c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bBUZ5kG07Yl8a9tQMs/QdhJgpIaoPTud6FawcN9OIs3t8G9s3zzlLhWIGXOmKQw0Q
         lw+SUJxC+qG2I6dS8v3Kuh7w4YrO6RAfSxFxi4uKSIlOIxHuC/NFn7LSoCOjVf7zfV
         qErWtbDy3ggUbV0M4v4TRxc4qy6jk0RXtcQL8k3s=
Received: by mail-oi1-f179.google.com with SMTP id w145so19245537oie.9;
        Mon, 16 Nov 2020 07:47:29 -0800 (PST)
X-Gm-Message-State: AOAM531v8sfnX2QL40VFNd5FxrSeooIxUji+9SsMOhhg1LtTFVf7IwNl
        +ZgLE/D64xcPs9KqZUVRajF41nHp5IXmxil1IVA=
X-Google-Smtp-Source: ABdhPJwtEdUsppLCAadjjssiA4VW6Mu0wAQgb+s+CdH11TnsM2ahFBi35u8Nh6V2aCMqX1p/8Wi7ZuPnGhFDWKPXXTw=
X-Received: by 2002:aca:3c54:: with SMTP id j81mr51617oia.11.1605541647968;
 Mon, 16 Nov 2020 07:47:27 -0800 (PST)
MIME-Version: 1.0
References: <20201116135345.11834-1-clabbe@baylibre.com> <20201116135345.11834-5-clabbe@baylibre.com>
In-Reply-To: <20201116135345.11834-5-clabbe@baylibre.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 16 Nov 2020 16:47:11 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0UZHmM2xfKegZ4mo_7N15614YPhx_FoY_h6WWF9M58Uw@mail.gmail.com>
Message-ID: <CAK8P3a0UZHmM2xfKegZ4mo_7N15614YPhx_FoY_h6WWF9M58Uw@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] crypto: sun4i-ss: handle BigEndian for cipher
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 2:53 PM Corentin Labbe <clabbe@baylibre.com> wrote:
>
> Ciphers produce invalid results on BE.
> Key and IV need to be written in LE.
>
> Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> index 53478c3feca6..8f4621826330 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> @@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
>
>         spin_lock_irqsave(&ss->slock, flags);
>
> -       for (i = 0; i < op->keylen; i += 4)
> -               writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
> +       for (i = 0; i < op->keylen / 4; i++)
> +               writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
>

This looks correct, but I wonder if we should just introduce
memcpy_toio32() and memcpy_fromio32() as a generic interface,
as this seems to come up occasionally, and the method here
(a loop around an inline function with another loop) is a bit clumsy.

      Arnd
