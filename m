Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E48130814
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 14:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgAENAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 08:00:46 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46143 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgAENAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 08:00:46 -0500
Received: by mail-lj1-f194.google.com with SMTP id m26so45769600ljc.13;
        Sun, 05 Jan 2020 05:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wtj4ycfHH4tNcald6Hu3wfTW6bDI5OTHJjc7dzUfoq0=;
        b=meOv6NbxWkh2QWiN19ICU9RrFOj8sUAIx0weTKNSjxrNhTKdZhtHhN4TVLEDBDqAs3
         7KzeubXZ4ueV9A0YSa0gdaBYC7IlB6YgaiYbfwr9IUL3GobCmcnLZHBy8PTUHsDp4B3G
         ELln8M4CfcVt70mY8YO+yYVtYVsgCDFxJOxSo3ljD15KNsjvdrnrQol7BtXVi8bDJ9F1
         ub8M2R0ZQ82ESmbQWq+fw9lH1SL/dV1M1l0yU59c/xT2APU49eZnEru0hMqmxwuH2m2Y
         23c25jZB3BiBuxHDk+u1R8ZQrz3ZK2FmEiM6aDsXYWDJTzBAa0Cut7J7bRVqY1HU3G2g
         AokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wtj4ycfHH4tNcald6Hu3wfTW6bDI5OTHJjc7dzUfoq0=;
        b=HGRELdr1HqkM4zO5zCnstcj0VYAy0V2dkLXYgwFj95MWxD5kTeVUmjju62zPemIMBC
         mjNlKPF2vnItVHl0Gd+NvIdribi13fFs0P8sulyO194dFbjXzwMYXEu+QiJcbZPLRv8t
         xhQDEkFCVBXLA3YDaScuswaxLMNXw0vk0iaGzm2PscjWF7jIXIUO36zmibjKZBnTbNYu
         hHETX6Dl+xHVr283kLW5Nr2GS+8NVjFJ6C6fam3LFGqzSv/Qh6LIc/Zj6tQZ97iMgORq
         VWQ/dOYO59f+b0e7fvW8IOJRmIGgvAqYBYdUUD0NUeDvTNI67Z+pH5WiWciYhFMjNFmk
         di9A==
X-Gm-Message-State: APjAAAUfOi9/XUJjU34DAA5DTDRyrWhyab9tj0ZSLJ+oMwshmraPhqCm
        aPpBBXTY2OQdkoJbEXhLss5pFOgnCWZ3xHqCu0g=
X-Google-Smtp-Source: APXvYqxLzGCvQ7IBDoin+iaNIeacu1bK/X/6zdfCpgWpTUtPRqxu/mEv7lEFYRmG+unV4mfFAHxTXgC1OAZQvXNIC8Y=
X-Received: by 2002:a2e:8544:: with SMTP id u4mr54341659ljj.70.1578229243841;
 Sun, 05 Jan 2020 05:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20200105012416.23296-1-samuel@sholland.org> <20200105012416.23296-3-samuel@sholland.org>
In-Reply-To: <20200105012416.23296-3-samuel@sholland.org>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Mon, 6 Jan 2020 00:00:32 +1100
Message-ID: <CAGRGNgXeenNYMNXY0dewQaeG2QecUPgE_MOofURg7HzcND782w@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 2/9] power: supply: axp20x_ac_power: Fix
 reporting online status
To:     samuel@sholland.org
Cc:     Chen-Yu Tsai <wens@csie.org>, Sebastian Reichel <sre@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Oskari Lemmela <oskari@lemmela.net>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Samuel,

On Sun, Jan 5, 2020 at 12:24 PM Samuel Holland <samuel@sholland.org> wrote:
>
> AXP803/AXP813 have a flag that enables/disables the AC power supply
> input. This flag does not affect the status bits in PWR_INPUT_STATUS.
> Its effect can be verified by checking the battery charge/discharge
> state (bit 2 of PWR_INPUT_STATUS), or by examining the current draw on
> the AC input.
>
> Take this flag into account when getting the ONLINE property of the AC
> input, on PMICs where this flag is present.
>
> Fixes: 7693b5643fd2 ("power: supply: add AC power supply driver for AXP813")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  drivers/power/supply/axp20x_ac_power.c | 31 +++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/power/supply/axp20x_ac_power.c b/drivers/power/supply/axp20x_ac_power.c
> index 0d34a932b6d5..ca0a28f72a27 100644
> --- a/drivers/power/supply/axp20x_ac_power.c
> +++ b/drivers/power/supply/axp20x_ac_power.c
> @@ -23,6 +23,8 @@
>  #define AXP20X_PWR_STATUS_ACIN_PRESENT BIT(7)
>  #define AXP20X_PWR_STATUS_ACIN_AVAIL   BIT(6)
>
> +#define AXP813_ACIN_PATH_SEL           BIT(7)
> +
>  #define AXP813_VHOLD_MASK              GENMASK(5, 3)
>  #define AXP813_VHOLD_UV_TO_BIT(x)      ((((x) / 100000) - 40) << 3)
>  #define AXP813_VHOLD_REG_TO_UV(x)      \
> @@ -40,6 +42,7 @@ struct axp20x_ac_power {
>         struct power_supply *supply;
>         struct iio_channel *acin_v;
>         struct iio_channel *acin_i;
> +       bool has_acin_path_sel;
>  };
>
>  static irqreturn_t axp20x_ac_power_irq(int irq, void *devid)
> @@ -86,6 +89,17 @@ static int axp20x_ac_power_get_property(struct power_supply *psy,
>                         return ret;
>
>                 val->intval = !!(reg & AXP20X_PWR_STATUS_ACIN_AVAIL);
> +
> +               /* ACIN_PATH_SEL disables ACIN even if ACIN_AVAIL is set. */
> +               if (power->has_acin_path_sel) {

Do we need to check this bit if ACIN_AVAIL is not set?

> +                       ret = regmap_read(power->regmap, AXP813_ACIN_PATH_CTRL,
> +                                         &reg);
> +                       if (ret)
> +                               return ret;
> +
> +                       val->intval &= !!(reg & AXP813_ACIN_PATH_SEL);

If we only check this bit if ACIN_AVAIL is set, then we don't need the
"&" in the "&=". (I'm assuming that val->intval is an int, not a bool,
otherwise this is the wrong operator)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
