Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E97B263B51
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 05:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgIJDWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 23:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIJDV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 23:21:58 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64234C061573;
        Wed,  9 Sep 2020 20:21:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o8so6521355ejb.10;
        Wed, 09 Sep 2020 20:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A79j38TeGo0FTeKhZJ6Z5HVKC+rNAm+2XLbIiEuCKUY=;
        b=aVrMkYlo/d+zmyouXTJxSqtB33bFfF1/mNixCVCCODQPmxJhhUiurbpS/1nRAOrm6o
         M8pON54OhrBwxLNcItuOcyfQnJK26edZu8Do4NxxPQoqMoGIeDFGaWwG3ADZCs9fUq1m
         8zuZ4YYIv1t1KKfwfaGw+isSSyNpgR6Cm4ZpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A79j38TeGo0FTeKhZJ6Z5HVKC+rNAm+2XLbIiEuCKUY=;
        b=AbqWG5ulRkvDqCSuW46bK6/hgR3CybMvdP7CVxtwW9YM0GgqYzmngRh8PVIL8kkgQ7
         E1P9efkn+Hfe/vPOT99LVmh/AVRGkk7N9IILhyKDAADtgFFzIwGSLyaRATOyTUvsfZ7V
         v/V12qFbGXFvbH5bSz9te1k63McQicC2Bze/prFp2G+jjSkWyMQxtI1zc403XfaFWAjQ
         NMJun/zD5c5vy939ugTS7hfL1eb6ZpZxSmcFWoC4IShtpPT/ugiKb/5ycmt6NujwK27d
         OVr+Zisf8GzkOGu/73QHWZ0VdguZSeEe53PrSlMEKY+ee1fMeHC56o1bgD62wx0ocDKC
         0Gaw==
X-Gm-Message-State: AOAM533aaJYpHwX8dzzwt3Y/9zm/eFDoHt9rqWJXtjksSoqhhp0y9+P6
        dcbfiohbPJSlG58M/S0exVnwMwwxojDR2cv28gc=
X-Google-Smtp-Source: ABdhPJyKppctq6u7ic9iz13bTUlMW2PIg2/iotUNWAl8CNxSQjvLXnJMdPO7f/onda7kLt48QCQ9ONhY4jV5TO6/oKg=
X-Received: by 2002:a17:906:4c58:: with SMTP id d24mr7092918ejw.108.1599708116944;
 Wed, 09 Sep 2020 20:21:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200826071916.3081953-1-joel@jms.id.au>
In-Reply-To: <20200826071916.3081953-1-joel@jms.id.au>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 10 Sep 2020 03:21:43 +0000
Message-ID: <CACPK8XcNc=O99Fuup=OnFacJJnRHd0bt0BiuSrYUCTSVs_shuw@mail.gmail.com>
Subject: Re: [PATCH] ARM: config: aspeed: Fix selection of media drivers
To:     Andrew Jeffery <andrew@aj.id.au>, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Tony Lindgren <tony@atomide.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 07:19, Joel Stanley <joel@jms.id.au> wrote:
>
> In the 5.7 merge window the media kconfig was restructued. For most
> platforms these changes set CONFIG_MEDIA_SUPPORT_FILTER=y which keeps
> unwanted drivers disabled.
>
> The exception is if a config sets EMBEDDED or EXPERT (see b0cd4fb27665).
> In that case the filter is set to =n, causing a bunch of DVB tuner drivers
> (MEDIA_TUNER_*) to be accidentally enabled. This was noticed as it blew
> out the build time for the Aspeed defconfigs.
>
> Enabling the filter means the Aspeed config also needs to set
> CONFIG_MEDIA_PLATFORM_SUPPORT=y in order to have the CONFIG_VIDEO_ASPEED
> driver enabled.
>
> Fixes: 06b93644f4d1 ("media: Kconfig: add an option to filter in/out platform drivers")
> Fixes: b0cd4fb27665 ("media: Kconfig: on !EMBEDDED && !EXPERT, enable driver filtering")
> Cc: stable@vger.kernel.org
> CC: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
>
> Another solution would be to revert b0cd4fb27665 ("media: Kconfig: on
> !EMBEDDED && !EXPERT, enable driver filtering"). I assume this was done
> to be helpful, but in practice it has enabled the TUNER drivers (and
> others) for the following configs that didn't have them before:

Mauro, did you have any thoughts here?

Otherwise I'll merge the fix for the aspeed configs for 5.10.

Cheers,

Joel

>
> $ git grep -lE "(CONFIG_EXPERT|CONFIG_EMBEDDED)"  arch/*/configs/ | xargs grep -l MEDIA_SUPPORT
> arch/arm/configs/aspeed_g4_defconfig
> arch/arm/configs/aspeed_g5_defconfig
> arch/arm/configs/at91_dt_defconfig
> arch/arm/configs/bcm2835_defconfig
> arch/arm/configs/davinci_all_defconfig
> arch/arm/configs/ezx_defconfig
> arch/arm/configs/imote2_defconfig
> arch/arm/configs/imx_v4_v5_defconfig
> arch/arm/configs/imx_v6_v7_defconfig
> arch/arm/configs/milbeaut_m10v_defconfig
> arch/arm/configs/multi_v7_defconfig
> arch/arm/configs/omap2plus_defconfig
> arch/arm/configs/pxa_defconfig
> arch/arm/configs/qcom_defconfig
> arch/arm/configs/sama5_defconfig
> arch/arm/configs/tegra_defconfig
> arch/mips/configs/ci20_defconfig
> arch/mips/configs/lemote2f_defconfig
> arch/mips/configs/loongson3_defconfig
> arch/mips/configs/pistachio_defconfig
>
> I've cc'd the maintainers of these defconfigs so they are aware.
>
> ---
>  arch/arm/configs/aspeed_g4_defconfig | 3 ++-
>  arch/arm/configs/aspeed_g5_defconfig | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
> index 303f75a3baec..58d293b63581 100644
> --- a/arch/arm/configs/aspeed_g4_defconfig
> +++ b/arch/arm/configs/aspeed_g4_defconfig
> @@ -160,7 +160,8 @@ CONFIG_SENSORS_TMP421=y
>  CONFIG_SENSORS_W83773G=y
>  CONFIG_WATCHDOG_SYSFS=y
>  CONFIG_MEDIA_SUPPORT=y
> -CONFIG_MEDIA_CAMERA_SUPPORT=y
> +CONFIG_MEDIA_SUPPORT_FILTER=y
> +CONFIG_MEDIA_PLATFORM_SUPPORT=y
>  CONFIG_V4L_PLATFORM_DRIVERS=y
>  CONFIG_VIDEO_ASPEED=y
>  CONFIG_DRM=y
> diff --git a/arch/arm/configs/aspeed_g5_defconfig b/arch/arm/configs/aspeed_g5_defconfig
> index b0d056d49abe..cc2449ed6e6d 100644
> --- a/arch/arm/configs/aspeed_g5_defconfig
> +++ b/arch/arm/configs/aspeed_g5_defconfig
> @@ -175,7 +175,8 @@ CONFIG_SENSORS_TMP421=y
>  CONFIG_SENSORS_W83773G=y
>  CONFIG_WATCHDOG_SYSFS=y
>  CONFIG_MEDIA_SUPPORT=y
> -CONFIG_MEDIA_CAMERA_SUPPORT=y
> +CONFIG_MEDIA_SUPPORT_FILTER=y
> +CONFIG_MEDIA_PLATFORM_SUPPORT=y
>  CONFIG_V4L_PLATFORM_DRIVERS=y
>  CONFIG_VIDEO_ASPEED=y
>  CONFIG_DRM=y
> --
> 2.28.0
>
