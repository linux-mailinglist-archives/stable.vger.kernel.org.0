Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C4D203599
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 13:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgFVLRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 07:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgFVLRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 07:17:17 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C19C061794;
        Mon, 22 Jun 2020 04:17:16 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w6so6274466ejq.6;
        Mon, 22 Jun 2020 04:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xRgc106IClsBkerWdpV7o3Ej76hMI8w2L4S15Jz9qXY=;
        b=fB9slUTarzXRJTHa4T9swRVflB6DTVmLD6Vk+rhdqGmtKDTgJeuE5oGFpmhZs5k+lg
         HxvZ1LSSkpnvHnuWfGshWfJdqUP7JcfyH4+yzLLqszSl4iGUBDySUKZAMtsh7IGBVSwy
         Io6p8Us49X+oRuM58zR2XfSL8EI0Wh6prSecdOXi/fnkqNqvn5ads2WURIRmDwgnmfaL
         cMzDX+KTxO7WJ6id3U2914S9L/mMFqjuZfsNaGGYTPIZ14XWWzTJDZp+o9HbP6Tt5Cxh
         cQCZxbH5H8uPVdCOsVbI7EIbUiEAFd4EK/RXgQJM6e4Y9DB7DFb9C5k7g9QOZxfmbbBP
         r8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xRgc106IClsBkerWdpV7o3Ej76hMI8w2L4S15Jz9qXY=;
        b=nw04SjpZ9E9erWsQN3nZ6NN/Idu0Mce+E8nvcvQLMjPRHoTikebFJ8M6BcYycQEojW
         7cjxpuFFORox8ssqsUHwkJCKXGFIH97JZEYRsgYmKO3nHcOCwErB1Ia928T3/1TJl0mq
         EnEt+i/26C3500IQXndoKl1YnngmHV595EJk0nCpMxh1rQ2Zwz6/FMVcGjjV1yVsiQKD
         gfTV8/+SYzV0X+AQjGF6WMI5MsOF3eeVd1bZmZCm7trAE18A/NVZxBQTxmNBMDxpTtIP
         t1mxAWXa50dty40mVeK94nBEpiRrn8H4RHaqJoPcyNNAhWqd9kgVFR8WM7GcJgPnvyGs
         Z/Kg==
X-Gm-Message-State: AOAM532pnYuos301XlVF9jEPCBTSmc6GGTnm2suwQu/XgbbKDLFGXg1l
        VGnC8rVuqsOx6/oMc5BrXD7+OdRKsBPajGZZtCg=
X-Google-Smtp-Source: ABdhPJxTZH2Ha+9mM+K5fT09glTGfXycVzRPrkrstxFV9zsl/qYCoUqY/1fjKeOmYFyWCPh8DOcdfnWgpAlKs6QB7AE=
X-Received: by 2002:a17:906:885:: with SMTP id n5mr2862040eje.406.1592824635307;
 Mon, 22 Jun 2020 04:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200622110543.5035-1-krzk@kernel.org> <20200622110543.5035-3-krzk@kernel.org>
In-Reply-To: <20200622110543.5035-3-krzk@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 22 Jun 2020 14:17:03 +0300
Message-ID: <CA+h21hqSfTQDOf87msrx8R44O_h_5NivQn7R5-V8-M5dBHBv4A@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] spi: spi-fsl-dspi: Fix external abort on interrupt
 in resume or exit paths
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>, Peng Ma <peng.ma@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Jun 2020 at 14:07, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> If shared interrupt comes late, during probe error path or device remove
> (could be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> dspi_interrupt() will access registers with the clock being disabled.
> This leads to external abort on non-linefetch on Toradex Colibri VF50
> module (with Vybrid VF5xx):
>
>     $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
>
>     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
>     Internal error: : 1008 [#1] ARM
>     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
>     Backtrace:
>       (regmap_mmio_read32le)
>       (regmap_mmio_read)
>       (_regmap_bus_reg_read)
>       (_regmap_read)
>       (regmap_read)
>       (dspi_interrupt)
>       (free_irq)
>       (devm_irq_release)
>       (release_nodes)
>       (devres_release_all)
>       (device_release_driver_internal)
>
> The resource-managed framework should not be used for shared interrupt
> handling, because the interrupt handler might be called after releasing
> other resources and disabling clocks.
>
> Similar bug could happen during suspend - the shared interrupt handler
> could be invoked after suspending the device.  Each device sharing this
> interrupt line should disable the IRQ during suspend so handler will be
> invoked only in following cases:
> 1. None suspended,
> 2. All devices resumed.
>
> Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>
> Changes since v3:
> 1. Use simpler if (dspi->irq).
>
> Changes since v2:
> 1. Go back to v1 and use non-devm interface,
> 2. Fix also suspend/resume paths.
>
> Changes since v1:
> 1. Disable the IRQ instead of using non-devm interface.
> ---
>  drivers/spi/spi-fsl-dspi.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index ec7919d9c0d9..e0b30e4b1b69 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1109,6 +1109,8 @@ static int dspi_suspend(struct device *dev)
>         struct spi_controller *ctlr = dev_get_drvdata(dev);
>         struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
>
> +       if (dspi->irq)
> +               disable_irq(dspi->irq);
>         spi_controller_suspend(ctlr);
>         clk_disable_unprepare(dspi->clk);
>
> @@ -1129,6 +1131,8 @@ static int dspi_resume(struct device *dev)
>         if (ret)
>                 return ret;
>         spi_controller_resume(ctlr);
> +       if (dspi->irq)
> +               enable_irq(dspi->irq);
>
>         return 0;
>  }
> @@ -1385,8 +1389,8 @@ static int dspi_probe(struct platform_device *pdev)
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
> @@ -1400,7 +1404,7 @@ static int dspi_probe(struct platform_device *pdev)
>                 ret = dspi_request_dma(dspi, res->start);
>                 if (ret < 0) {
>                         dev_err(&pdev->dev, "can't get dma channels\n");
> -                       goto out_clk_put;
> +                       goto out_free_irq;
>                 }
>         }
>
> @@ -1415,11 +1419,14 @@ static int dspi_probe(struct platform_device *pdev)
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
> +       if (dspi->irq)
> +               free_irq(dspi->irq, dspi);
>  out_clk_put:
>         clk_disable_unprepare(dspi->clk);
>  out_ctlr_put:
> @@ -1445,6 +1452,8 @@ static int dspi_remove(struct platform_device *pdev)
>         regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
>
>         dspi_release_dma(dspi);
> +       if (dspi->irq)
> +               free_irq(dspi->irq, dspi);
>         clk_disable_unprepare(dspi->clk);
>
>         return 0;
> --
> 2.17.1
>
