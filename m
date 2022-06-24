Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5FF559259
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 07:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiFXFZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 01:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiFXFZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 01:25:46 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBF4699A4;
        Thu, 23 Jun 2022 22:25:37 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-317a66d62dfso14322227b3.7;
        Thu, 23 Jun 2022 22:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X1yTU2uzLT0uzkceC1nX+e8LlEHb+m5UCZBnQI0lwLg=;
        b=am0a/iALpvDx4fZT5mLy7yLMLp1s6PWwgUaQuxYpmoRbgfDTNE0NoEhZH40PMvqJJ3
         P+1ApRnBRcTtNP584m4wnCIkczctyGTB94ChK/SFDCi2Ivl9lQucTUKp7g8IvBE/l6oy
         L0w0fP0t+0M6zDsO0FLRfF11uHb3zl4ZF89rOJz5E38rzkpa1Ca01sea5H8GMRj4dV97
         oFyfF5Ee+jDOaLcMnc9W8pw0Ro8ZOCrF080mRShFIZbq2KbD0bVQMxmP1g4pfH21D18G
         8nDGaYyuh2FfN/HqqM5mpTp2y8QA1Th7NqLq+LN6umjJXG6zS9a5gOdRFyfPO3fiFLaV
         1vSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X1yTU2uzLT0uzkceC1nX+e8LlEHb+m5UCZBnQI0lwLg=;
        b=mMAOWQC03RCmg8xupSU9UzY8wp3LT+gPK4rCDYyMSNT4O8Rl08iGxbtbwJjhdQP/tD
         X+mpyUdSxUUH8pE4ES6J0eua9LJVa0qzwc4zYv4kc6A+OuFFuSSgKZwdHlhG61SeiEYR
         09EXela+iN/k6I7fIRC5oAUBh8PIt1KMB8JKoEdKiP0A+cRbfHvIp6CmQAsTdu9CXwvp
         UbCjcWe3pBmXTwB4f/T6CIjjoijrCrCFl23Pexwq/txz/E7kcyvp2Ra7BiEE3xrU36e2
         a4/cwtf2v8rkUUFgq79TEcvQoeNJCvOpzUjL7uAzFktRisE3gluRuLeCYBer85JLpjBh
         ZzhA==
X-Gm-Message-State: AJIora9fThDmhtZ5U/7WEDmWcxnSelejYYaQyxMBnd6RWxVF6EUy4066
        F/PKT9H+z4qp/qUFfNi8Ad6C6OIpdOczqwE1XjE=
X-Google-Smtp-Source: AGRyM1tTdtTG+5RebyogUZjKaqaV84A8NZtukJ1JjX/tigZCAgOIH1pyShy0RBTYNfROuPTuTkCetFIz5xUEOotC+Pc=
X-Received: by 2002:a81:110:0:b0:317:a640:ad04 with SMTP id
 16-20020a810110000000b00317a640ad04mr15219110ywb.427.1656048336902; Thu, 23
 Jun 2022 22:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <YrUKUt5nvX8qf1Je@zx2c4.com> <20220624011449.1473399-1-Jason@zx2c4.com>
In-Reply-To: <20220624011449.1473399-1-Jason@zx2c4.com>
From:   Gregory Erwin <gregerwin256@gmail.com>
Date:   Thu, 23 Jun 2022 22:25:26 -0700
Message-ID: <CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com>
Subject: Re: [PATCH] ath9k: rng: escape sleep loop when unregistering
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
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

Hi Jason,

I think you are on the right track, but even with this patch
'ip link set wlan0 down' blocks until the hwrng reader gives up.
The reader can either be userspace (dd, cat, etc) or it can also
be the rng_core module. I can replicate the hang in the two different
situations, so I gathered two stack traces for 'ip' depending on the
reader of hwrng:

-userspace-
$ ip link set wlan0 up
$ dd if=3D/dev/hwrng count=3D1 & # blocks until interrupted or receives -EI=
O
$ ip link set wlan0 down & # blocks until dd exits
$ cat /proc/$(pidof ip)/stack
[<0>] devres_release+0x2b/0x60
[<0>] ath9k_rng_stop+0x27/0x40 [ath9k]
[<0>] ath9k_stop+0x40/0x230 [ath9k]
[<0>] drv_stop+0x34/0x100 [mac80211]
[<0>] ieee80211_do_stop+0x685/0x880 [mac80211]
[<0>] ieee80211_stop+0x41/0x170 [mac80211]
[<0>] __dev_close_many+0x9e/0x110
[<0>] __dev_change_flags+0x1a7/0x250
[<0>] dev_change_flags+0x26/0x60
[<0>] do_setlink+0x32d/0x1220
[<0>] __rtnl_newlink+0x5a2/0x9f0
[<0>] rtnl_newlink+0x47/0x70
[<0>] rtnetlink_rcv_msg+0x143/0x370
[<0>] netlink_rcv_skb+0x55/0x100
[<0>] netlink_unicast+0x243/0x390
[<0>] netlink_sendmsg+0x254/0x4b0
[<0>] sock_sendmsg+0x60/0x70
[<0>] ____sys_sendmsg+0x264/0x2a0
[<0>] ___sys_sendmsg+0x96/0xd0
[<0>] __sys_sendmsg+0x7a/0xd0
[<0>] do_syscall_64+0x5f/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

-rng_core-
$ ip link set wlan0 up
$ # wait a while, maybe a minute or two
$ ip link set wlan0 down & # blocks until 10s after 'hwrng: no data availab=
le'
$ cat /proc/$(pidof ip)/stack
[<0>] kthread_stop+0x65/0x170
[<0>] hwrng_unregister+0xbe/0xe0 [rng_core]
[<0>] devres_release+0x2b/0x60
[<0>] ath9k_rng_stop+0x27/0x40 [ath9k]
[<0>] ath9k_stop+0x40/0x230 [ath9k]
[<0>] drv_stop+0x34/0x100 [mac80211]
[<0>] ieee80211_do_stop+0x685/0x880 [mac80211]
[<0>] ieee80211_stop+0x41/0x170 [mac80211]
[<0>] __dev_close_many+0x9e/0x110
[<0>] __dev_change_flags+0x1a7/0x250
[<0>] dev_change_flags+0x26/0x60
[<0>] do_setlink+0x32d/0x1220
[<0>] __rtnl_newlink+0x5a2/0x9f0
[<0>] rtnl_newlink+0x47/0x70
[<0>] rtnetlink_rcv_msg+0x143/0x370
[<0>] netlink_rcv_skb+0x55/0x100
[<0>] netlink_unicast+0x243/0x390
[<0>] netlink_sendmsg+0x254/0x4b0
[<0>] sock_sendmsg+0x60/0x70
[<0>] ____sys_sendmsg+0x264/0x2a0
[<0>] ___sys_sendmsg+0x96/0xd0
[<0>] __sys_sendmsg+0x7a/0xd0
[<0>] do_syscall_64+0x5f/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Regards,
 - Greg.



On Thu, Jun 23, 2022 at 6:15 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> There's currently an almost deadlock when ath9k shuts down if no random
> bytes are available:
>
> Thread A                                Thread B
> -------------------------------------------------------------------------
> rng_dev_read
>  get_current_rng
>   kref_get(&current_rng->ref)
>  rng_get_data
>   ath9k_rng_read
>    msleep_interruptible(...)
>                                        ath9k_rng_stop
>                                         devm_hwrng_unregister
>                                          devm_hwrng_release
>                                           hwrng_unregister
>                                            drop_current_rng
>                                              kref_put(&current_rng->ref, =
cleanup_rng)
>                                               // Does NOT call cleanup_rn=
g here,
>                                               // because of thread A's kr=
ef_get.
>                                            wait_for_completion(&rng->clea=
nup_done);
>                                             // Waits for a really long ti=
me...
>    // Eventually sleep is over...
>  put_rng
>   kref_put(&rng->ref, cleanup_rng);
>    cleanup_rng
>     complete(&rng->cleanup_done);
>                                            return
>
> When thread B doesn't return right away, sleep and other functions that
> are waiting for ath9k_rng_stop to complete time out, and problems ensue.
>
> This commit fixes the problem by using another completion inside of
> ath9k_rng_read so that hwrng_unregister can interrupt it as needed.
>
> Reported-by: Gregory Erwin <gregerwin256@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: stable@vger.kernel.org
> Fixes: fcd09c90c3c5 ("ath9k: use hw_random API instead of directly dumpin=
g into random.c")
> Link: https://lore.kernel.org/all/CAO+Okf6ZJC5-nTE_EJUGQtd8JiCkiEHytGgDsF=
GTEjs0c00giw@mail.gmail.com/
> Link: https://bugs.archlinux.org/task/75138
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> I do not have an ath9k and therefore I can't test this myself. The
> analysis above was done completely statically, with no dynamic tracing
> and just a bug report of symptoms from Gregory. So it might be totally
> wrong. Thus, this patch very much requires Gregory's testing. Please
> don't apply it until we have his `Tested-by` line.
>
>  drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
>  drivers/net/wireless/ath/ath9k/rng.c   | 26 ++++++++++++++++----------
>  2 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireles=
s/ath/ath9k/ath9k.h
> index 3ccf8cfc6b63..731db7f70e5d 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -1072,6 +1072,7 @@ struct ath_softc {
>
>  #ifdef CONFIG_ATH9K_HWRNG
>         struct hwrng rng_ops;
> +       struct completion rng_shutdown;
>         u32 rng_last;
>         char rng_name[sizeof("ath9k_65535")];
>  #endif
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/=
ath/ath9k/rng.c
> index cb5414265a9b..67c6b03a22ac 100644
> --- a/drivers/net/wireless/ath/ath9k/rng.c
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2015 Qualcomm Atheros, Inc.
> + * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights R=
eserved.
>   *
>   * Permission to use, copy, modify, and/or distribute this software for =
any
>   * purpose with or without fee is hereby granted, provided that the abov=
e
> @@ -52,18 +53,13 @@ static int ath9k_rng_data_read(struct ath_softc *sc, =
u32 *buf, u32 buf_size)
>         return j << 2;
>  }
>
> -static u32 ath9k_rng_delay_get(u32 fail_stats)
> +static unsigned long ath9k_rng_delay_get(u32 fail_stats)
>  {
> -       u32 delay;
> -
>         if (fail_stats < 100)
> -               delay =3D 10;
> +               return msecs_to_jiffies(10);
>         else if (fail_stats < 105)
> -               delay =3D 1000;
> -       else
> -               delay =3D 10000;
> -
> -       return delay;
> +               return msecs_to_jiffies(1000);
> +       return msecs_to_jiffies(10000);
>  }
>
>  static int ath9k_rng_read(struct hwrng *rng, void *buf, size_t max, bool=
 wait)
> @@ -83,7 +79,10 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf=
, size_t max, bool wait)
>                 if (!wait || !max || likely(bytes_read) || fail_stats > 1=
10)
>                         break;
>
> -               msleep_interruptible(ath9k_rng_delay_get(++fail_stats));
> +               if (wait_for_completion_interruptible_timeout(
> +                           &sc->rng_shutdown,
> +                           ath9k_rng_delay_get(++fail_stats)))
> +                       break;
>         }
>
>         if (wait && !bytes_read && max)
> @@ -91,6 +90,11 @@ static int ath9k_rng_read(struct hwrng *rng, void *buf=
, size_t max, bool wait)
>         return bytes_read;
>  }
>
> +static void ath9k_rng_cleanup(struct hwrng *rng)
> +{
> +       complete(&container_of(rng, struct ath_softc, rng_ops)->rng_shutd=
own);
> +}
> +
>  void ath9k_rng_start(struct ath_softc *sc)
>  {
>         static atomic_t serial =3D ATOMIC_INIT(0);
> @@ -104,8 +108,10 @@ void ath9k_rng_start(struct ath_softc *sc)
>
>         snprintf(sc->rng_name, sizeof(sc->rng_name), "ath9k_%u",
>                  (atomic_inc_return(&serial) - 1) & U16_MAX);
> +       init_completion(&sc->rng_shutdown);
>         sc->rng_ops.name =3D sc->rng_name;
>         sc->rng_ops.read =3D ath9k_rng_read;
> +       sc->rng_ops.cleanup =3D ath9k_rng_cleanup;
>         sc->rng_ops.quality =3D 320;
>
>         if (devm_hwrng_register(sc->dev, &sc->rng_ops))
> --
> 2.35.1
>
