Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF99655A55B
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 02:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiFYAOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 20:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiFYAN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 20:13:58 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A0947AEE;
        Fri, 24 Jun 2022 17:13:56 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id p136so898459ybg.4;
        Fri, 24 Jun 2022 17:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kUeybIn8X7wyy6Zxj+SxpbUQYku41FrJsXHclUQTNlw=;
        b=MQNX2eBTgxNvfqEtsvOfyCw3snA8m6U7+Gr8gBr1OvDnMl8uqZ17d6OHSjjrZXb1Li
         GSFxXRJRFdJ6gHItlMuVK7GSN/vtoH+wmv0GIGhlwRRtN1Tx0vfkcpq8Vw90YxSVWWdp
         ze+RAvnxKd8sEfUf3PQKQv1PJze5xC/8toLe/PgO0oZSK/odghX1umGElOPdWOnPUIQl
         Vx1lsg57/ySv9KSYMBGsjiawYV+kDIHAOqZ0iUg/ZY/k2rR3yco1Mi4v5pPbzECNG6Mq
         3/N0ny4cIIKmKG1TfeAvHvI6XAbzBPFiX0EwNzcrMeeXJP/g9II7NQGdiaMzxY1n5fyX
         pAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kUeybIn8X7wyy6Zxj+SxpbUQYku41FrJsXHclUQTNlw=;
        b=6YYMKCuid6giTO2X63qflKXaNR6qdfaDdZoQy/eRlmhFtMkjt8uRz4yUn7vNS7y7iV
         TBPIFEfA520z5y/Wah5sIalp7uRSU9F6OGBAsKjG7rtNRiKQFPOKhZfdaIaT1iscU73a
         9qWdUyABkFXQF1BlqVZrv73Ft0Qbuv7xTBM+4l+6xJU+2lQFRNpBdtjUMHNAUf8VNL8o
         DFQ+xu/7jExh8REUWJXeMUNtzF4Y3/OjnL9CTld5yOTEXa8agtDAIbYCQ3AtX8h6ABwQ
         jS4GsgkOXxjjO0+1OiMoZuPMHIUe7vpYu5LVuiiwuvtQWsAX3amvV9Z+/J5RPzUYOkNo
         Seew==
X-Gm-Message-State: AJIora93nFlrUhEb/EvV6Bz7jY723BLhuf1XxyNwJ2ZikxgG9x7KOPTV
        MccWRUuhugJavLyAlc0NangTHrsPidh2gvcHm9U=
X-Google-Smtp-Source: AGRyM1tRZaba/bO8ABEMIUqBpMTNfutVwCEyYAhUljUgqV8N5HClCEsYg39IXjrSu5NaI/IE5iY+IsKVmQkGzIW6jOM=
X-Received: by 2002:a5b:a4f:0:b0:669:9661:55e4 with SMTP id
 z15-20020a5b0a4f000000b00669966155e4mr1907120ybq.466.1656116035923; Fri, 24
 Jun 2022 17:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <YrYMqqqoK7HBAXgJ@zx2c4.com> <20220624204433.2371980-1-Jason@zx2c4.com>
In-Reply-To: <20220624204433.2371980-1-Jason@zx2c4.com>
From:   Gregory Erwin <gregerwin256@gmail.com>
Date:   Fri, 24 Jun 2022 17:13:44 -0700
Message-ID: <CAO+Okf7z0EQN19N_g=pLq71GY+pNejAWEQQDG5VsX=z=J3EM5A@mail.gmail.com>
Subject: Re: [PATCH v2] ath9k: sleep for less time when unregistering hwrng
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 24, 2022 at 1:44 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Even though hwrng provides a `wait` parameter, it doesn't work very well
> when waiting for a long time. There are numerous deadlocks that emerge
> related to shutdown. Work around this API limitation by waiting for a
> shorter amount of time and erroring more frequently. This commit also
> prevents hwrng from splatting messages to dmesg when there's a timeout
> and prevents calling msleep_interruptible() for tons of time when a
> thread is supposed to be shutting down, since msleep_interruptible()
> isn't actually interrupted by kthread_stop().
>
> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: stable@vger.kernel.org
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumpin=
g into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsF=
GTEjs0c00giw@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8H=
ys_DVXtent3HA@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> I do not have an ath9k and therefore I can't test this myself. The
> analysis above was done completely statically, with no dynamic tracing
> and just a bug report of symptoms from Gregory. So it might be totally
> wrong. Thus, this patch very much requires Gregory's testing. Please
> don't apply it until we have his `Tested-by` line.
>
>  drivers/char/hw_random/core.c        | 10 ++++++++--
>  drivers/net/wireless/ath/ath9k/rng.c | 19 ++-----------------
>  2 files changed, 10 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.=
c
> index 16f227b995e8..af1c1905bb7e 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -513,8 +513,13 @@ static int hwrng_fillfn(void *unused)
>                         break;
>
>                 if (rc <=3D 0) {
> -                       pr_warn("hwrng: no data available\n");
> -                       msleep_interruptible(10000);
> +                       int i;
> +
> +                       for (i =3D 0; i < 100; ++i) {
> +                               if (kthread_should_stop() ||
> +                                   msleep_interruptible(10000 / 100))
> +                                       goto out;
> +                       }
>                         continue;
>                 }
>
> @@ -529,6 +534,7 @@ static int hwrng_fillfn(void *unused)
>                 add_hwgenerator_randomness((void *)rng_fillbuf, rc,
>                                            entropy >> 10);
>         }
> +out:
>         hwrng_fill =3D NULL;
>         return 0;
>  }
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/=
ath/ath9k/rng.c
> index cb5414265a9b..883110c66e5e 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -52,20 +52,6 @@ static int ath9k_rng_data_read(struct ath_softc *sc, u=
32 *buf, u32 buf_size)
>         return j << 2;
>  }
>
> -static u32 ath9k_rng_delay_get(u32 fail_stats)
> -{
> -       u32 delay;
> -
> -       if (fail_stats < 100)
> -               delay =3D 10;
> -       else if (fail_stats < 105)
> -               delay =3D 1000;
> -       else
> -               delay =3D 10000;
> -
> -       return delay;
> -}
> -
>  static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool=
 wait)
>  {
>         struct ath_softc *sc =3D container_of(rng, struct ath_softc, rng_=
ops);
> @@ -80,10 +66,9 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf=
, size_t max, bool wait)
>                         bytes_read +=3D max & 3UL;
>                         memzero_explicit(&word, sizeof(word));
>                 }
> -               if (!wait || !max || likely(bytes_read) || fail_stats > 1=
10)
> +               if (!wait || !max || likely(bytes_read) ||
> +                   ++fail_stats >=3D 100 || msleep_interruptible(5))
>                         break;
> -
> -               msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
>         }
>
>         if (wait && !bytes_read && max)
> --
> 2.35.1
>

Jason,

This patch is working as you described. Trying to read from /dev/hwrng
consistently blocks for only 1.3s before returning an IO error. The longest
that I observed 'ip link set wlan0 down' to block was also about 1.3s,
and that was immediately after 'cat /dev/hwrng'. Additionally, the longest
duration that I observed for wiphy_suspend() to return was just under 100ms=
.

Tested-by: Gregory Erwin <gregerwin256@gmail.com>
