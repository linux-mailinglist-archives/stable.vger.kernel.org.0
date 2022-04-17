Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9548550490F
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 20:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiDQSzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 14:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiDQSzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 14:55:17 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4FB31513;
        Sun, 17 Apr 2022 11:52:41 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id b68so5192287qkc.4;
        Sun, 17 Apr 2022 11:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DKPqe4vxsfpDCAxr6uDwyU8L0kabjODZzJ2aaWg93X4=;
        b=SJAS0tTJ0yUp7FKnGhO8wDRBkGapS6ydq8XHGhxspU5t05aFLNRyJxz+d1bW9cjn/b
         8iP2X8URvIeICAlM5UTPtqPGEUlSllS0NbLsD1D6FXsQRjacX/CBy7YBjlNG0x6TBwOa
         WB7g0jw59grOHGX1lI33Rfjp1R/5PX4fgTlP2Gf5uIQ/zgssNc7yN9raiAPuZv57jI8g
         Pbl33BZKSPQl1wbsBAXlZdcVyw3iN7aJb8OehTqYnabyxn18qitmyEqQAP7B8F6jsVhg
         tCcKTGEyN79RxgjKfzCQ/4S4A+dWCLVfAi814LxDOTl8kRN8fnXh/37miEU4zMRF1LkP
         o7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DKPqe4vxsfpDCAxr6uDwyU8L0kabjODZzJ2aaWg93X4=;
        b=21OQWr5XdaXvYvr5K/xe0EI5wejSNAyRGEoxXXVvREiVZdIy8S4vCnRYcWNKchy8m2
         XSAJTYWxJLhVST5fq4pFFSM7aTcUKczFD6o3l43FXR3OVxtt72SdUFjdzFqtuLcyxpS/
         C+OXCVnIC5E3FXY5jQZ0Y66OhZT0DxlNSLqormrU8zQ5bOp5zbA+z1cmMsQxPNpTyjB1
         HzWqg49SR3A7XInzcKLnDNbBfZwzZ1BmcbVE9shHNj3hIoeTzNRkNm6ydwPkawZMQ0el
         Q0k2cqFB5irXZF6SOvUiwPuSggyis2fSKFfye1cOLOmcxq9kL3F5C2IHDe3Gct/3QxEO
         Ilug==
X-Gm-Message-State: AOAM531jbtqf7PSLYz7KyIJS225T9b29WTBs4pTNB7uBQABvzwb0dNxe
        S4AAbwDIBjuE/KMY6hHvNnymY857tS0a1ejNm4s=
X-Google-Smtp-Source: ABdhPJw5ioWuK6KYOxB+eNIYwXCpLUNlLGzQO3ZUkgmzLjhz6PEg7Q7CP3vXuI2wIu09bFHApK/bAErbQoGYGdI0ze4=
X-Received: by 2002:a05:620a:4009:b0:69c:62ad:5673 with SMTP id
 h9-20020a05620a400900b0069c62ad5673mr4788279qko.420.1650221560575; Sun, 17
 Apr 2022 11:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220417181538.57fa1303@blackhole>
In-Reply-To: <20220417181538.57fa1303@blackhole>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Sun, 17 Apr 2022 11:52:14 -0700
Message-ID: <CA+E=qVeX2aU0hiDMxLXzVk-YiMsqKKFKpm=cc=72joMhZmNV1g@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: fix anx6345 power up sequence
To:     Torsten Duwe <duwe@lst.de>
Cc:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <treding@nvidia.com>,
        Lyude Paul <lyude@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Geyer <harald@ccbib.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 17, 2022 at 9:15 AM Torsten Duwe <duwe@lst.de> wrote:
>
> Align the power-up sequence with the known-good procedure documented in [1]:
> un-swap dvdd12 and dvdd25, and allow a little extra time for them to settle
> before de-asserting reset.

Hi Torsten,

Interesting find! I tried to fix the issue several times by playing
with the delays to no avail.

What's interesting, ANX6345 datasheet allows DVDD12 to come up either
earlier or later than DVDD25 with the delay of T1 (2ms typical)
between them, and actually bringing up DVDD12 first works fine in
u-boot.

The datasheet also requires reset to be deasserted no earlier than T2
(2-5ms) after all the rails are stable.

Another thing it mentions is that the system clock must be stable for
T3 (1-3ms) before reset is deasserted, T3 is already a part of T2,
however it cannot be gated on Pinebook, see [1], page 15

The change looks good to me, but I'll need some time to actually test
it. If you don't hear from me for longer than a week please ping me.

[1] https://files.pine64.org/doc/pinebook/pinebook_mainboard_schematic_3.0.pdf

Regards,
Vasily

> Fixes: 6aa192698089b ("drm/bridge: Add Analogix anx6345 support")
>
> [1] https://github.com/OLIMEX/DIY-LAPTOP/blob/master/
> HARDWARE/A64-TERES/TERES-PCB1-A64-MAIN/Rev.C/TERES_PCB1-A64-MAIN_Rev.C.pdf
> (page 5, blue comment down left)
>
> Reported-by: Harald Geyer <harald@ccbib.org>
> Signed-off-by: Torsten Duwe <duwe@lst.de>
> Cc: stable@vger.kernel.org
> ---
>
> This fixes the problem that e.g. X screensaver turns the screen black,
> and it stays black until the next reboot; definitely on the Teres-I,
> probably on the pinebook64, too.

You should probably move this comment up to be included in the commit message.



>
> --- a/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
> +++ b/drivers/gpu/drm/bridge/analogix/analogix-anx6345.c
> @@ -309,27 +309,27 @@ static void anx6345_poweron(struct anx63
>         gpiod_set_value_cansleep(anx6345->gpiod_reset, 1);
>         usleep_range(1000, 2000);
>
> -       err = regulator_enable(anx6345->dvdd12);
> +       err = regulator_enable(anx6345->dvdd25);
>         if (err) {
> -               DRM_ERROR("Failed to enable dvdd12 regulator: %d\n",
> +               DRM_ERROR("Failed to enable dvdd25 regulator: %d\n",
>                           err);
>                 return;
>         }
>
> -       /* T1 - delay between VDD12 and VDD25 should be 0-2ms */
> +       /* T1 - delay between VDD25 and VDD12 should be 0-2ms */
>         usleep_range(1000, 2000);
>
> -       err = regulator_enable(anx6345->dvdd25);
> +       err = regulator_enable(anx6345->dvdd12);
>         if (err) {
> -               DRM_ERROR("Failed to enable dvdd25 regulator: %d\n",
> +               DRM_ERROR("Failed to enable dvdd12 regulator: %d\n",
>                           err);
>                 return;
>         }
>
>         /* T2 - delay between RESETN and all power rail stable,
> -        * should be 2-5ms
> +        * should be at least 2-5ms, 10ms to be safe.
>          */
> -       usleep_range(2000, 5000);
> +       usleep_range(9000, 11000);
>
>         gpiod_set_value_cansleep(anx6345->gpiod_reset, 0);
>
