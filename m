Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD668275947
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 16:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgIWOAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 10:00:51 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:60161 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgIWOAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 10:00:50 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N7zW7-1kXXyV3dYp-0153Ri; Wed, 23 Sep 2020 16:00:49 +0200
Received: by mail-qk1-f169.google.com with SMTP id c2so3247997qkf.10;
        Wed, 23 Sep 2020 07:00:48 -0700 (PDT)
X-Gm-Message-State: AOAM532WbjWFqoPLs5mT9O4vM77pMPOtUCiDGaJU+DjYMwsYVsrSJVJa
        QvT+YVfwuTExOs+2m5n+xs8Eizp/Mbpl6vgN2bY=
X-Google-Smtp-Source: ABdhPJxXESklaivIXzQ968fTEsIrcE3DWT9feSILmcmi8tbGgjtV4HaWGcVIC9yHT4lQ1WgKmXoX5Y9Le1PvsAoXQVA=
X-Received: by 2002:a05:620a:15a7:: with SMTP id f7mr7626qkk.3.1600869647538;
 Wed, 23 Sep 2020 07:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com> <1600627038-40000-5-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1600627038-40000-5-git-send-email-clabbe@baylibre.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 23 Sep 2020 16:00:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a34V16PUoVJjoUOVCik_rdb6vAy=54qRzWdO+aJcwUwsg@mail.gmail.com>
Message-ID: <CAK8P3a34V16PUoVJjoUOVCik_rdb6vAy=54qRzWdO+aJcwUwsg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] crypto: sun4i-ss: handle BigEndian for cipher
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:2bpN2sFSxfZKkmsTy1EpAAHr0i+EJ6f146zf4oJiD/jO8k+1DRR
 Cq65zHZFWwl2tpROk+LvM3vYxXI9jFEngmCQ1AaeqvROH3Qf8dUWg7FG803KKQESM+lbkUn
 F2XMqJihQDEQgeEulUhwVJ8DN8Ig0Ir3J4cuAzVjDbIW8YMouN42p16b0szTDgN6NaqAlbI
 7i6JiI7BhhEgx2c2BgYRg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wHaJLo4XGd4=:lVCQMRn8E+C7ukE7EWQIM8
 TmfuxZtEEUYAoYJ4cbfznrf04JA1m4HLnzhJFbhEjVje9SpKjJAACuSPrMTbhmEq/eTn9DRYM
 VxmS/tcfWm+xC4IMXUNDPm61fWaFKSVmulM0mr06NgnWpwIW4XhqtCMexVPDEr2z7MjkvFKN+
 2zAhrcqpM0HfUzIGkBnQHLxQOHFFSejT7FJlhLRrfnnQq/l4P9p55ExnV0jbqRdD8re3hlzT0
 VQtj9ypD5l9R4rqhaeq8W8Gipv2EvUfSGXc/V96IrflMqezEX6VxNXhmVOUXNYuJiP4UNoF5B
 mFdngfWEh+7CKG4z3XY5y5Q7SidESzWLnI2e/xbzY/2tu2V0X3D6Xqv8UwooJCLJItAwV+ci7
 BNjHwLJn0OtH1wE/PkfLHDZupuMsvCe4oW+N0Kb7Xy54753ws5Ryh+uwTIJ0L6o2so1npu/Qz
 LlX3RdPq6mPTegYTLPqMYMB0JSs6wyLPnzsrs2MUswPqS9p+8EptEf9Ytu2sBV47uRjZS+SsG
 ZnBd8eeRG1DfzZZqXJq6WgK6tiPOdd+njqTYmylOLcwTqoS0q5KnuGw/7MtpY8fx1JPO89MeU
 Jawixm9yF5AoYSPDfZ9ySYdvzVPHSvTySTor3rEuV8gGlQcoFIXAycOqfi9fBOVkW//2U/k8T
 2Nz+TOoqPFqVKJNXss/fpamnQ57ORjYIxAXCWs7if3WY16DH2a0TgA6GCANHla5i0agdOGYep
 ++Dd3s9DMmt6bcayYNnupIcCfCr5YJTx8xR09/xEmEYbC5rOK5LqptWMpm3CHz/XQ7imHfKm7
 Nqbc0Dh9K0lmD6iq4RrfPtmIUxr2WQfz+GsBAoMnOeDAKDEOuVYdZTON7I6cc9cpkO4PA/+
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 20, 2020 at 8:37 PM Corentin Labbe <clabbe@baylibre.com> wrote:
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
> index c6c25204780d..a05889745097 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> @@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
>
>         spin_lock_irqsave(&ss->slock, flags);
>
> -       for (i = 0; i < op->keylen; i += 4)
> -               writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
> +       for (i = 0; i < op->keylen / 4; i++)
> +               writel(cpu_to_le32(op->key[i]), ss->base + SS_KEY0 + i * 4);

I suspect what you actually want here is writesl() in place of the
loop. This skips the byteswap on big-endian, rather than swapping
each word twice.

The point is that this register seems to act as a FIFO for a byte-stream
rather than a 32-bit fixed-endian register.

     Arnd
