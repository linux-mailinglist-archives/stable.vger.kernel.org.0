Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7B84F47DE
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346361AbiDEVWW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 5 Apr 2022 17:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457863AbiDEQxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:53:15 -0400
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2428326E9
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 09:51:14 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id l26so11644365ejx.1
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 09:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IPrQE+Xi3gKFHtaa4iFeqv2z1Mz1gUVNTO0GQNazrug=;
        b=HHXCmD+uVuM8aSPM3qus4jJSl49EU+QEeSxf0WVF7zBYMsi8HLY7qqK2rtHEhdevzs
         A++iwC+/XGGzLye9c202RHsQYbfsdh4Z+6Ki3rSHhvFGdJj7J3lJ2lFDOpJYeEf+Yfsz
         deWZZVrLvf0ekrD+KTI1I5V79Xhwm/3sZo/auQ8P/i8GJjWYDQjSkD6PTGEn3B5X/2tv
         ZEykWZ0Y+FBuStoJ/vBWM8+FVbZjfhCQLslnEcX7JYgvTkOsFDV+OpZyvpRcG7ATcQlD
         uHIta7XP1YQR8NAGMQaJjLLMM3kEnxtkgvgQL67dImGmejR+ZkOm4yj6Ap8xQ13Genqk
         0VIg==
X-Gm-Message-State: AOAM531euZa2J0ys7WOFyTpS4sEBT5kYklppuo2isinhLY56IRhq9RQt
        vjkVKaEOPI5cIYhKRthp5rEmK63K1ISgXADyFpdxyQ==
X-Google-Smtp-Source: ABdhPJyZW/jtaBf+smr/b2HpqbwulVx0oqg/WWEhSXUKh3LtpTZgEBwALPc6rzivGSbB+HNhFhDLiW9iIutaI4bUvA0=
X-Received: by 2002:a17:907:1b20:b0:6da:649b:d99e with SMTP id
 mp32-20020a1709071b2000b006da649bd99emr4506275ejc.712.1649177473217; Tue, 05
 Apr 2022 09:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070407.513532867@linuxfoundation.org> <20220405070435.188697055@linuxfoundation.org>
In-Reply-To: <20220405070435.188697055@linuxfoundation.org>
From:   Justin Forbes <jforbes@fedoraproject.org>
Date:   Tue, 5 Apr 2022 11:51:02 -0500
Message-ID: <CAFxkdAov41sA0V7D82BVophn8Nn6RPyLwPz-VmW5mLOXg1NYEw@mail.gmail.com>
Subject: Re: [PATCH 5.17 0943/1126] ASoC: Intel: sof_es8336: use NHLT
 information to set dmic and SSP
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?Q?P=C3=A9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 5, 2022 at 4:14 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>
> [ Upstream commit 651c304df7f6e3fbb4779527efa3eb128ef91329 ]
>
> Since we see a proliferation of devices with various configurations,
> we want to automatically set the DMIC and SSP information. This patch
> relies on the information extracted from NHLT and partially reverts
> existing DMI quirks added by commit a164137ce91a ("ASoC: Intel: add
> machine driver for SOF+ES8336")
>
> Note that NHLT can report multiple SSPs, choosing from the
> ssp_link_mask in an MSB-first manner was found experimentally to work
> fine.
>
> The only thing that cannot be detected is the GPIO type, and users may
> want to use the quirk override parameter if the 'wrong' solution is
> provided.
>
> Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
> Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
> Link: https://lore.kernel.org/r/20220308192610.392950-15-pierre-louis.bossart@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

It seems this patch is missing a dependent patch in the backport,
specifically commit
679aa83a0fb70dcbf9e97cbdfd573e6fc8bf9b1a ASoC: soc-acpi: add
information on I2S/TDM link mask

sound/soc/intel/boards/sof_es8336.c: In function 'sof_es8336_probe':
sound/soc/intel/boards/sof_es8336.c:482:32: error: 'struct
snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you
mean 'link_mask'?
  482 |         if (!mach->mach_params.i2s_link_mask) {
      |                                ^~~~~~~~~~~~~
      |                                link_mask
sound/soc/intel/boards/sof_es8336.c:494:39: error: 'struct
snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you
mean 'link_mask'?
  494 |                 if (mach->mach_params.i2s_link_mask & BIT(2))
      |                                       ^~~~~~~~~~~~~
      |                                       link_mask
sound/soc/intel/boards/sof_es8336.c:496:44: error: 'struct
snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you
mean 'link_mask'?
  496 |                 else if (mach->mach_params.i2s_link_mask & BIT(1))
      |                                            ^~~~~~~~~~~~~
      |                                            link_mask
sound/soc/intel/boards/sof_es8336.c:498:45: error: 'struct
snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you
mean 'link_mask'?
  498 |                 else  if (mach->mach_params.i2s_link_mask & BIT(0))
      |                                             ^~~~~~~~~~~~~
      |                                             link_mask
make[4]: *** [scripts/Makefile.build:288:
sound/soc/intel/boards/sof_es8336.o] Error 1

Justin

>  sound/soc/intel/boards/sof_es8336.c | 56 +++++++++++++++++++++--------
>  1 file changed, 41 insertions(+), 15 deletions(-)
>
> diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
> index 20d577eaab6d..46e453915f82 100644
> --- a/sound/soc/intel/boards/sof_es8336.c
> +++ b/sound/soc/intel/boards/sof_es8336.c
> @@ -228,24 +228,25 @@ static int sof_es8336_quirk_cb(const struct dmi_system_id *id)
>         return 1;
>  }
>
> +/*
> + * this table should only be used to add GPIO or jack-detection quirks
> + * that cannot be detected from ACPI tables. The SSP and DMIC
> + * information are providing by the platform driver and are aligned
> + * with the topology used.
> + *
> + * If the GPIO support is missing, the quirk parameter can be used to
> + * enable speakers. In that case it's recommended to keep the SSP and DMIC
> + * information consistent, overriding the SSP and DMIC can only be done
> + * if the topology file is modified as well.
> + */
>  static const struct dmi_system_id sof_es8336_quirk_table[] = {
> -       {
> -               .callback = sof_es8336_quirk_cb,
> -               .matches = {
> -                       DMI_MATCH(DMI_SYS_VENDOR, "CHUWI Innovation And Technology"),
> -                       DMI_MATCH(DMI_BOARD_NAME, "Hi10 X"),
> -               },
> -               .driver_data = (void *)SOF_ES8336_SSP_CODEC(2)
> -       },
>         {
>                 .callback = sof_es8336_quirk_cb,
>                 .matches = {
>                         DMI_MATCH(DMI_SYS_VENDOR, "IP3 tech"),
>                         DMI_MATCH(DMI_BOARD_NAME, "WN1"),
>                 },
> -               .driver_data = (void *)(SOF_ES8336_SSP_CODEC(0) |
> -                                       SOF_ES8336_TGL_GPIO_QUIRK |
> -                                       SOF_ES8336_ENABLE_DMIC)
> +               .driver_data = (void *)(SOF_ES8336_TGL_GPIO_QUIRK)
>         },
>         {}
>  };
> @@ -470,11 +471,33 @@ static int sof_es8336_probe(struct platform_device *pdev)
>         card = &sof_es8336_card;
>         card->dev = dev;
>
> -       if (!dmi_check_system(sof_es8336_quirk_table))
> -               quirk = SOF_ES8336_SSP_CODEC(2);
> +       /* check GPIO DMI quirks */
> +       dmi_check_system(sof_es8336_quirk_table);
>
> -       if (quirk & SOF_ES8336_ENABLE_DMIC)
> -               dmic_be_num = 2;
> +       if (!mach->mach_params.i2s_link_mask) {
> +               dev_warn(dev, "No I2S link information provided, using SSP0. This may need to be modified with the quirk module parameter\n");
> +       } else {
> +               /*
> +                * Set configuration based on platform NHLT.
> +                * In this machine driver, we can only support one SSP for the
> +                * ES8336 link, the else-if below are intentional.
> +                * In some cases multiple SSPs can be reported by NHLT, starting MSB-first
> +                * seems to pick the right connection.
> +                */
> +               unsigned long ssp = 0;
> +
> +               if (mach->mach_params.i2s_link_mask & BIT(2))
> +                       ssp = SOF_ES8336_SSP_CODEC(2);
> +               else if (mach->mach_params.i2s_link_mask & BIT(1))
> +                       ssp = SOF_ES8336_SSP_CODEC(1);
> +               else  if (mach->mach_params.i2s_link_mask & BIT(0))
> +                       ssp = SOF_ES8336_SSP_CODEC(0);
> +
> +               quirk |= ssp;
> +       }
> +
> +       if (mach->mach_params.dmic_num)
> +               quirk |= SOF_ES8336_ENABLE_DMIC;
>
>         if (quirk_override != -1) {
>                 dev_info(dev, "Overriding quirk 0x%lx => 0x%x\n",
> @@ -483,6 +506,9 @@ static int sof_es8336_probe(struct platform_device *pdev)
>         }
>         log_quirks(dev);
>
> +       if (quirk & SOF_ES8336_ENABLE_DMIC)
> +               dmic_be_num = 2;
> +
>         sof_es8336_card.num_links += dmic_be_num + hdmi_num;
>         dai_links = sof_card_dai_links_create(dev,
>                                               SOF_ES8336_SSP_CODEC(quirk),
> --
> 2.34.1
>
>
>
