Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF362F1D89
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 19:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390149AbhAKSHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 13:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390147AbhAKSHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 13:07:44 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1430C0617BD
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 10:07:01 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id j59so132846uad.5
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 10:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kjroq5IVcsaocRlWVqumBmAjNs8Q1T2UaLZmChWgxjU=;
        b=XEEsKYXMfqgNLBsBkUHKknxUjINn9OYd+Vbtf7fXC+xDMBW+NzkCwoOG5tYyW0TbLk
         2MB6siADi+yjsiMKcNz1rRo55EPwSQolwPp1Zg2iZx1W/ZYi+gpj55YvUDAnFc5A8bC3
         pWi3H4E5yjoCzI/7mp/+y2lZRdSfshXZuwuNipS6Jb25c/xXqJcplYXo/0lJFGy6YAsw
         YOlxp5r6cDjojE1przzzBB6fxaNCL0/YIlTtwFGAT06GMgAJigNHbg8XcZhxLttHBgdR
         ln16xnYPacs9YMm5DYAqeBqHXLywSLWQ6zzL8UUDYNLjK9Gmufqy4k0GwV9iHrhSP1m4
         84xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kjroq5IVcsaocRlWVqumBmAjNs8Q1T2UaLZmChWgxjU=;
        b=KQDMBRGGsMb6poQn5cBupQGZV6vmyAtgHVI+Y6s8aUwZPKLLKDfVFI+T+Z9p04hAdm
         9CUJ7c6vI4nVHfI7WClVc1fHLsPn9m9uv6dFqD8GauyphOMm9ebRmC7S4h6Qi0OkP+uF
         xTBP3lsVn+islH6SMQYIz/iksWi9IGnKyPeSE8X0GtbgTePjbXU+P5ZGY6zYFMsGGAd0
         lLAmn++8GEXrfSsBdQMC+eHXiTsIL2J8XwZIVUpDgcGNEaiVXx9Jxsw9pS1hui85sngA
         v/l8VNVL+YDmSf3PrB6J9j+yc6OowVoAdDCHNev+qeQIY7wg9nliFTX548EfboJ1rMjN
         5dWQ==
X-Gm-Message-State: AOAM530xBzWXZDtHUC1I09w+kKpeBTQ6zDdxy2eiOJuuk/YfutF8fo28
        gpU69XjYklq+T1rVF6JRYpzyNibJnnVBj2OqvRZYnA==
X-Google-Smtp-Source: ABdhPJxMPRMEkGTAbXkhnrrN+swnMYAQSC+WKmQmUp8nsi7df3jLRu3fgfIQ6FiYJhzQrb9jsDMgCm19+v6Gjlha7XU=
X-Received: by 2002:ab0:78d:: with SMTP id c13mr653601uaf.129.1610388420862;
 Mon, 11 Jan 2021 10:07:00 -0800 (PST)
MIME-Version: 1.0
References: <20201211141656.24915-1-mw@semihalf.com>
In-Reply-To: <20201211141656.24915-1-mw@semihalf.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 11 Jan 2021 19:06:24 +0100
Message-ID: <CAPDyKFqsSO+f9iG8vccwXZXDDNHgLEg7bfUe-KfHn2C-ZnOU4A@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-xenon: fix 1.8v regulator stabilization
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Ziji Hu <huziji@marvell.com>,
        Adrian Hunter <adrian.hunter@intel.com>, jaz@semihalf.com,
        tn@semihalf.com, Kostya Porotchkin <kostap@marvell.com>,
        Alex Leibovich <alexl@marvell.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Dec 2020 at 15:17, Marcin Wojtas <mw@semihalf.com> wrote:
>
> From: Alex Leibovich <alexl@marvell.com>
>
> Automatic Clock Gating is a feature used for the power
> consumption optimisation. It turned out that
> during early init phase it may prevent the stable voltage
> switch to 1.8V - due to that on some platfroms an endless
> printout in dmesg can be observed:
> "mmc1: 1.8V regulator output did not became stable"
> Fix the problem by disabling the ACG at very beginning
> of the sdhci_init and let that be enabled later.
>
> Fixes: 3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
> Signed-off-by: Alex Leibovich <alexl@marvell.com>
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> Cc: stable@vger.kernel.org

Applied for fixes (by fixing the typos), thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/sdhci-xenon.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
> index c67611fdaa8a..4b05f6fdefb4 100644
> --- a/drivers/mmc/host/sdhci-xenon.c
> +++ b/drivers/mmc/host/sdhci-xenon.c
> @@ -168,7 +168,12 @@ static void xenon_reset_exit(struct sdhci_host *host,
>         /* Disable tuning request and auto-retuning again */
>         xenon_retune_setup(host);
>
> -       xenon_set_acg(host, true);
> +       /*
> +        * The ACG should be turned off at the early init time, in order
> +        * to solve a possile issues with the 1.8V regulator stabilization.
> +        * The feature is enabled in later stage.
> +        */
> +       xenon_set_acg(host, false);
>
>         xenon_set_sdclk_off_idle(host, sdhc_id, false);
>
> --
> 2.29.0
>
