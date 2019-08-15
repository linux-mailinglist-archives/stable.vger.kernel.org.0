Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFEB8E93B
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 12:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbfHOKr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 06:47:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35779 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731030AbfHOKr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 06:47:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id w20so1777222edd.2;
        Thu, 15 Aug 2019 03:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6U+9D9VuzYk/UuusQ5D1oT/kFrMb8QVt6mqzdB7pgOY=;
        b=KrdfUvvuzk0m1+qMR6fl7FPrf+1zxRSwNUGzcCNRGla2KLdNyJNyuIVnE1xuakRAtL
         6005Rj4jQN956PE+vCsolvwoAQwIZpwvy1IHkWo1un1yAhlU/WBje9Uy1o2KbQ2O6Zbv
         T0T3SN8XX2Qxa8bDvrwm9b4nclmgCEOzNa6hHsKw2fFPUjBDSpMWBHzx5Uy/ZHkEZqul
         EEQaGUAn7vaRaYpFBQs5TLfhvnHQmlctqZkmI6CIN8qwH04y16XIl7UE6OzsubU08ymS
         9E2hIFzExuzqMeY5TidqgJYa3PIUhrxUSJMM9n6G1s0j44RdTs5l2VzX618LmlMgjnp3
         8PLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6U+9D9VuzYk/UuusQ5D1oT/kFrMb8QVt6mqzdB7pgOY=;
        b=nMa1hFG+ExO8r4RPBa1eAJT2kISnN0wDBly0q+1p4Q7VauitsLX1Qon3YFIKYmDO7b
         9OJ8kFbemTny3D1HeVJa6OiGYxUfBt6ECKcaRIavTRaxCN6Ns+/3td1qL7xxnuLKeG1D
         ziSU3GSiFLK9Kq/fTiEnB0tY4XPBwk9Zdshjzhink8P8l+HmGAtgl27U6uoQ4L+UCQhq
         jqL2nW21SwrLn8vLLYm/sUzD1TCiNiZl4LvHj1mRJY0PhNADexOCDDdZohvo7CM9Nttt
         HB4nxfQbSYf7YPOvtNvtGJWz+IZxdMVv4hC7a3rnRYpBwK6GYuUhrL26lwDgvvKcBNfl
         HKtQ==
X-Gm-Message-State: APjAAAXHI+LF5PL1uHvEO2O5Ejk4I3ZwRyb5jDZ3AGxfoxyqDcjvrKEM
        6yJi3xNOTnRgFNgatsblTYc4sqE2UO7o1niTLVc=
X-Google-Smtp-Source: APXvYqzmrdeI4nHryo00UaovrqqzY7SNIBF6HYZgikYNhd2vK0pG0uun+ybu7F39OpfTr/sRL1rpPsgkZ3lRM3m3Lck=
X-Received: by 2002:a17:906:1989:: with SMTP id g9mr3716381ejd.302.1565866046214;
 Thu, 15 Aug 2019 03:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190814214319.24087-1-andreas@kemnade.info>
In-Reply-To: <20190814214319.24087-1-andreas@kemnade.info>
From:   Adam Ford <aford173@gmail.com>
Date:   Thu, 15 Aug 2019 05:47:14 -0500
Message-ID: <CAHCN7xL4K+1nJDXDRs7yVi6LhGL-4uPu9M+SN1dcOPu8=M8s2g@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: twl: voltage lists for vdd1/2 on twl4030
To:     Andreas Kemnade <andreas@kemnade.info>
Cc:     Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Nishanth Menon <nm@ti.com>, vireshk@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 5:18 PM Andreas Kemnade <andreas@kemnade.info> wrote:
>
> _opp_supported_by_regulators() wrongly ignored errors from
> regulator_is_supported_voltage(), so it considered errors as
> success. Since
> commit 498209445124 ("regulator: core: simplify return value on suported_voltage")
> regulator_is_supported_voltage() returns a real boolean, so
> errors make _opp_supported_by_regulators() return false.
>
> That reveals a problem with the declaration of the VDD1/2
> regulators on twl4030.
> The VDD1/VDD2 regulators on twl4030 are neither defined with
> voltage lists nor with the continuous flag set, so
> regulator_is_supported_voltage() returns false and an error
> before above mentioned commit (which was considered success)
> The result is that after the above mentioned commit cpufreq
> does not work properly e.g. dm3730.
>
> [    2.490997] core: _opp_supported_by_regulators: OPP minuV: 1012500 maxuV: 1012500, not supported by regulator
> [    2.501617] cpu cpu0: _opp_add: OPP not supported by regulators (300000000)
> [    2.509246] core: _opp_supported_by_regulators: OPP minuV: 1200000 maxuV: 1200000, not supported by regulator
> [    2.519775] cpu cpu0: _opp_add: OPP not supported by regulators (600000000)
> [    2.527313] core: _opp_supported_by_regulators: OPP minuV: 1325000 maxuV: 1325000, not supported by regulator
> [    2.537750] cpu cpu0: _opp_add: OPP not supported by regulators (800000000)
>
> The patch fixes declaration of VDD1/2 regulators by
> adding proper voltage lists.
>
> Fixes: 498209445124 ("regulator: core: simplify return value on suported_voltage")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andreas Kemnade <andreas@kemnade.info>

Tested-by: Adam Ford <aford173@gmail.com> #logicpd-torpedo-37xx-devkit

> ---
> resent because it was rejected by mailing lists, due to technical
> issues, sorry for the noise.
> changes in v2:
>   using a proper voltage list instead of misusing the continuous flag
>   subject was regulator: twl: mark vdd1/2 as continuous on twl4030
>
>  drivers/regulator/twl-regulator.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> index 6fa15b2d6fb3..866b4dd01da9 100644
> --- a/drivers/regulator/twl-regulator.c
> +++ b/drivers/regulator/twl-regulator.c
> @@ -359,6 +359,17 @@ static const u16 VINTANA2_VSEL_table[] = {
>         2500, 2750,
>  };
>
> +/* 600mV to 1450mV in 12.5 mV steps */
> +static const struct regulator_linear_range VDD1_ranges[] = {
> +       REGULATOR_LINEAR_RANGE(600000, 0, 68, 12500)
> +};
> +
> +/* 600mV to 1450mV in 12.5 mV steps, everything above = 1500mV */
> +static const struct regulator_linear_range VDD2_ranges[] = {
> +       REGULATOR_LINEAR_RANGE(600000, 0, 68, 12500),
> +       REGULATOR_LINEAR_RANGE(1500000, 69, 69, 12500)
> +};
> +
>  static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
>  {
>         struct twlreg_info      *info = rdev_get_drvdata(rdev);
> @@ -427,6 +438,8 @@ static int twl4030smps_get_voltage(struct regulator_dev *rdev)
>  }
>
>  static const struct regulator_ops twl4030smps_ops = {
> +       .list_voltage   = regulator_list_voltage_linear_range,
> +
>         .set_voltage    = twl4030smps_set_voltage,
>         .get_voltage    = twl4030smps_get_voltage,
>  };
> @@ -466,7 +479,8 @@ static const struct twlreg_info TWL4030_INFO_##label = { \
>                 }, \
>         }
>
> -#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf) \
> +#define TWL4030_ADJUSTABLE_SMPS(label, offset, num, turnon_delay, remap_conf, \
> +               n_volt) \
>  static const struct twlreg_info TWL4030_INFO_##label = { \
>         .base = offset, \
>         .id = num, \
> @@ -479,6 +493,9 @@ static const struct twlreg_info TWL4030_INFO_##label = { \
>                 .owner = THIS_MODULE, \
>                 .enable_time = turnon_delay, \
>                 .of_map_mode = twl4030reg_map_mode, \
> +               .n_voltages = n_volt, \
> +               .n_linear_ranges = ARRAY_SIZE(label ## _ranges), \
> +               .linear_ranges = label ## _ranges, \
>                 }, \
>         }
>
> @@ -518,8 +535,8 @@ TWL4030_ADJUSTABLE_LDO(VSIM, 0x37, 9, 100, 0x00);
>  TWL4030_ADJUSTABLE_LDO(VDAC, 0x3b, 10, 100, 0x08);
>  TWL4030_ADJUSTABLE_LDO(VINTANA2, 0x43, 12, 100, 0x08);
>  TWL4030_ADJUSTABLE_LDO(VIO, 0x4b, 14, 1000, 0x08);
> -TWL4030_ADJUSTABLE_SMPS(VDD1, 0x55, 15, 1000, 0x08);
> -TWL4030_ADJUSTABLE_SMPS(VDD2, 0x63, 16, 1000, 0x08);
> +TWL4030_ADJUSTABLE_SMPS(VDD1, 0x55, 15, 1000, 0x08, 68);
> +TWL4030_ADJUSTABLE_SMPS(VDD2, 0x63, 16, 1000, 0x08, 69);
>  /* VUSBCP is managed *only* by the USB subchip */
>  TWL4030_FIXED_LDO(VINTANA1, 0x3f, 1500, 11, 100, 0x08);
>  TWL4030_FIXED_LDO(VINTDIG, 0x47, 1500, 13, 100, 0x08);
> --
> 2.20.1
>
