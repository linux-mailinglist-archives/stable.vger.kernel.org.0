Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507BA1F8992
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 17:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgFNPsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 11:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgFNPsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 11:48:16 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A05C05BD43;
        Sun, 14 Jun 2020 08:48:16 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id x25so2765063edr.8;
        Sun, 14 Jun 2020 08:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ME3U0G8Zt/SJ5gubx2EfaaOcuEB5wP9pzS5fCVI+pj8=;
        b=V79ryVetzGA0qr5vZ7Vnt83Uyb9oXPnBDHqomghjxUYmingxu7NgaRktd9cGiJIU5A
         e2/bQNc942hIsvBY1OTB1dN4MQdr1CXoNKn5XGGfvymlcY1DH7fHJI7/XPY0+yVKgjqv
         T1mQkFBGRDwaKdh93H/D96w4M4x7vJ63uFs8tzPUhXFd0mtVEc4DcZRBON3IgtwI8kW6
         AEX90mMNe9WX/vtFHDhZ//4LPhJ4Kqez1yyWU4ef13JINCsgEk2AIDQhymIxnb+jLYhR
         +QClAr618cV7DmDmkzJw+gv+HyGCiPqcEn+jm/XnKg4KFC5Wyjre1GUPgdRBHexL7sd5
         nzkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ME3U0G8Zt/SJ5gubx2EfaaOcuEB5wP9pzS5fCVI+pj8=;
        b=YrGnge5/xUnqhWHJQJnpvjTmBZZ/3oSLVG7LtyJv77qeGt5muPI9VUR3ae7Yr1dNeo
         Geb2dyFtvpIo85koOXo9em+pTSF3/B5NJDvUcCdKMxz2InpBZdfKaxDyo5b03g8Ouxyf
         bdPQ+cNTYOPCvMy9d9RfO4ELuFE5/eylyfFnUOKE+x3l0Qk+n+6OZUD2QEG3wvfUQiw6
         u18LPmoHFEzrJsteEau00BJeSC9Q3ZbfSKN+tBzAwJVadnS7XIAuoAftwOghauJtRBzt
         26CA6OAbtr4XoybIbxaqMXODBJ7WmvB4jTGl2LhA0WELctNNakp3BnHPTdnEZ+Z/g/kS
         BFLw==
X-Gm-Message-State: AOAM532tIugjdebBOMCpyjkoN0HRvb/9iMm1BL3LFlmIFw7ArdjrZEcZ
        aK+cNR/noftohFD5yFnGwv/Xth5qKvE7IfzeqVs=
X-Google-Smtp-Source: ABdhPJyp4wBOegUn+3seNKmQIGLb0wXHmGsh6jzPeHw/EUphwLWjy3o460vOieqsqWdkPR1Wnf6x22oR7ibYyUDszas=
X-Received: by 2002:a05:6402:545:: with SMTP id i5mr20655346edx.179.1592149695061;
 Sun, 14 Jun 2020 08:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
In-Reply-To: <1592132154-20175-1-git-send-email-krzk@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 14 Jun 2020 18:48:04 +0300
Message-ID: <CA+h21hpsmG+xUjWgaNcSojxeWYm4bcbMsn6_hmZrJ0A3zfVEag@mail.gmail.com>
Subject: Re: [PATCH 1/2] spi: spi-fsl-dspi: Fix external abort on interrupt in
 exit paths
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 14 Jun 2020 at 13:57, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> If interrupt comes late, during probe error path or device remove (could
> be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> dspi_interrupt() will access registers with the clock being disabled.  This
> leads to external abort on non-linefetch on Toradex Colibri VF50 module
> (with Vybrid VF5xx):
>
>     $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
>
>     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
>     Internal error: : 1008 [#1] ARM
>     CPU: 0 PID: 136 Comm: sh Not tainted 5.7.0-next-20200610-00009-g5c913fa0f9c5-dirty #74
>     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
>       (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
>       (regmap_mmio_read) from [<8060e3b8>] (_regmap_bus_reg_read+0x24/0x28)
>       (_regmap_bus_reg_read) from [<80611c50>] (_regmap_read+0x70/0x1c0)
>       (_regmap_read) from [<80611dec>] (regmap_read+0x4c/0x6c)
>       (regmap_read) from [<80678ca0>] (dspi_interrupt+0x3c/0xa8)
>       (dspi_interrupt) from [<8017acec>] (free_irq+0x26c/0x3cc)
>       (free_irq) from [<8017dcec>] (devm_irq_release+0x1c/0x20)
>       (devm_irq_release) from [<805f98ec>] (release_nodes+0x1e4/0x298)
>       (release_nodes) from [<805f9ac8>] (devres_release_all+0x40/0x60)
>       (devres_release_all) from [<805f5134>] (device_release_driver_internal+0x108/0x1ac)
>       (device_release_driver_internal) from [<805f521c>] (device_driver_detach+0x20/0x24)
>
> The resource-managed framework should not be used for interrupt handling,
> because the resource will be released too late - after disabling clocks.
> The interrupt handler is not prepared for such case.
>
> Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> ---

I don't buy this argument that "the resource-managed framework should
not be used for interrupt handling". What is it there for, then?
Could you just call disable_irq before clk_disable_unprepare instead
of this massive rework?

>
> This is an follow up of my other patch for I2C IMX driver [1]. Let's fix the
> issues consistently.
>
> [1] https://lore.kernel.org/lkml/1592130544-19759-2-git-send-email-krzk@kernel.org/T/#u
> ---
>  drivers/spi/spi-fsl-dspi.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index 58190c94561f..57e7a626ba00 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1385,8 +1385,8 @@ static int dspi_probe(struct platform_device *pdev)
>                 goto poll_mode;
>         }
>
> -       ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
> -                              IRQF_SHARED, pdev->name, dspi);
> +       ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
> +                                  IRQF_SHARED, pdev->name, dspi);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "Unable to attach DSPI interrupt\n");
>                 goto out_clk_put;
> @@ -1400,7 +1400,7 @@ static int dspi_probe(struct platform_device *pdev)
>                 ret = dspi_request_dma(dspi, res->start);
>                 if (ret < 0) {
>                         dev_err(&pdev->dev, "can't get dma channels\n");
> -                       goto out_clk_put;
> +                       goto out_free_irq;
>                 }
>         }
>
> @@ -1415,11 +1415,14 @@ static int dspi_probe(struct platform_device *pdev)
>         ret = spi_register_controller(ctlr);
>         if (ret != 0) {
>                 dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
> -               goto out_clk_put;
> +               goto out_free_irq;
>         }
>
>         return ret;
>
> +out_free_irq:
> +       if (dspi->irq > 0)
> +               free_irq(dspi->irq, dspi);
>  out_clk_put:
>         clk_disable_unprepare(dspi->clk);
>  out_ctlr_put:
> @@ -1435,6 +1438,8 @@ static int dspi_remove(struct platform_device *pdev)
>
>         /* Disconnect from the SPI framework */
>         dspi_release_dma(dspi);
> +       if (dspi->irq > 0)
> +               free_irq(dspi->irq, dspi);
>         clk_disable_unprepare(dspi->clk);
>         spi_unregister_controller(dspi->ctlr);
>
> --
> 2.7.4
>

Thanks,
-Vladimir
