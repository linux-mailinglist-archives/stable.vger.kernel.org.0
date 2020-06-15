Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF81F9343
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 11:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFOJX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 05:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgFOJXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 05:23:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64888C061A0E;
        Mon, 15 Jun 2020 02:23:54 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f7so16647221ejq.6;
        Mon, 15 Jun 2020 02:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oD8vjdJWazweOL92lTM1YOwIbiYENHOh132QMYgI8gE=;
        b=tyR8ebUHS+1VVP7A7LjhtnhlBVQ5GmX8qVefEFv/ae6W4CkIKaf/9OuLkmxoqhNUeC
         Lgs8gzXCn4xtwQe6afmBxVFYuafEvH3Sm/YXT6/UUN1KYrSqsoeDIMCVpiT5tQJXvG+l
         LzEtgjejijmuSFSkT+8izEGZPKXuX+W4cI3bT3SI1CX2ebSxoEf/f8AqRzl4z4AQ9HYS
         aqdWi5xUATJpdqoOliKptxQ/at2RjhL6Sj7Po6sDRiYmwxMK/y14SFBZ7PjVCZmXft6n
         rXDsQQ+COBj/o1bjgpe0GRGYoRBTmm+W1oSqWE7yxKfZspuW5yfAUTfMF5y9+GqCcjWh
         XB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oD8vjdJWazweOL92lTM1YOwIbiYENHOh132QMYgI8gE=;
        b=bLQCaIXI0nCHXvR8iDdHFxc+M7+1pzrxbEKMg/zywDKBodj1WfHh+4x5Smek1WvjFX
         0MT9lMwrnBI3R2RWrbJCupb2r+/47TE27Mz0lDHWoG6UOW3FODCgMEuLwXQ1IMdWXgkR
         TGzaHorQvzJUPzd4f3gYOnhkCxMweHZ1/lVoIfeq3mpeNU0ieBavRpgpyvn9NEusBq7Z
         RnIfWq1C2QxyDwk1vQrEIqsJiQJdgG/Xj7dYeROoGPue0SHrfR4pMOVjbh2nfFcc+TZO
         +oqIspGigSoerJhpm6SSw/1YYh1hI4etkNUZU/pDFw1+Z8Fh/qq/zs3hBkVjULXnyq9m
         OD5w==
X-Gm-Message-State: AOAM533uRIRf/u8Dx8Tm8YXfjvEtd+dkFpmOT+IfrT13xGhQJt9Tko6P
        sdtygkdtpczyjI8CDg4/sN+nmPMUB0SKLKN0FWlQZQ==
X-Google-Smtp-Source: ABdhPJz5ER0VVuyS+Mq5JcwSL5x7CKd6exvW28NFMSRb6aIyU+0LSu36ud3AH+OeLQ1BBC/Bk/TR1xqxOaLfcFSyDKs=
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr23745547ejb.473.1592213032940;
 Mon, 15 Jun 2020 02:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org> <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
In-Reply-To: <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 12:23:41 +0300
Message-ID: <CA+h21hrxQ1fRahyQGFS42Xuop_Q2petE=No1dft4nVb-ijUu2g@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 at 11:18, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 6/15/20 10:07 AM, Krzysztof Kozlowski wrote:
> > If interrupt comes late, during probe error path or device remove (could
> > be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> > dspi_interrupt() will access registers with the clock being disabled.  This
> > leads to external abort on non-linefetch on Toradex Colibri VF50 module
> > (with Vybrid VF5xx):
> >
> >     $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
> >
> >     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
> >     Internal error: : 1008 [#1] ARM
> >     CPU: 0 PID: 136 Comm: sh Not tainted 5.7.0-next-20200610-00009-g5c913fa0f9c5-dirty #74
> >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> >       (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
> >       (regmap_mmio_read) from [<8060e3b8>] (_regmap_bus_reg_read+0x24/0x28)
> >       (_regmap_bus_reg_read) from [<80611c50>] (_regmap_read+0x70/0x1c0)
> >       (_regmap_read) from [<80611dec>] (regmap_read+0x4c/0x6c)
> >       (regmap_read) from [<80678ca0>] (dspi_interrupt+0x3c/0xa8)
> >       (dspi_interrupt) from [<8017acec>] (free_irq+0x26c/0x3cc)
> >       (free_irq) from [<8017dcec>] (devm_irq_release+0x1c/0x20)
> >       (devm_irq_release) from [<805f98ec>] (release_nodes+0x1e4/0x298)
> >       (release_nodes) from [<805f9ac8>] (devres_release_all+0x40/0x60)
> >       (devres_release_all) from [<805f5134>] (device_release_driver_internal+0x108/0x1ac)
> >       (device_release_driver_internal) from [<805f521c>] (device_driver_detach+0x20/0x24)
> >
> > Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> >
> > ---
> >
> > This is an follow up of my other patch for I2C IMX driver [1]. Let's fix the
> > issues consistently.
> >
> > [1] https://lore.kernel.org/lkml/1592130544-19759-2-git-send-email-krzk@kernel.org/T/#u
> >
> > Changes since v1:
> > 1. Disable the IRQ instead of using non-devm interface.
> > ---
> >  drivers/spi/spi-fsl-dspi.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> > index 58190c94561f..023e05c53b85 100644
> > --- a/drivers/spi/spi-fsl-dspi.c
> > +++ b/drivers/spi/spi-fsl-dspi.c
> > @@ -1400,7 +1400,7 @@ static int dspi_probe(struct platform_device *pdev)
> >               ret = dspi_request_dma(dspi, res->start);
> >               if (ret < 0) {
> >                       dev_err(&pdev->dev, "can't get dma channels\n");
> > -                     goto out_clk_put;
> > +                     goto disable_irq;
> >               }
> >       }
> >
> > @@ -1415,11 +1415,14 @@ static int dspi_probe(struct platform_device *pdev)
> >       ret = spi_register_controller(ctlr);
> >       if (ret != 0) {
> >               dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
> > -             goto out_clk_put;
> > +             goto disable_irq;
> >       }
> >
> >       return ret;
> >
> > +disable_irq:
> > +     if (dspi->irq > 0)
> > +             disable_irq(dspi->irq);
> >  out_clk_put:
> >       clk_disable_unprepare(dspi->clk);
> >  out_ctlr_put:
> > @@ -1435,6 +1438,8 @@ static int dspi_remove(struct platform_device *pdev)
> >
> >       /* Disconnect from the SPI framework */
> >       dspi_release_dma(dspi);
> > +     if (dspi->irq > 0)
> > +             disable_irq(dspi->irq);
>
> What happens, if you re-bind the driver?
> Is the IRQ still working?
> Who is taking care of calling the enable_irq() again?
> What happens, if you really have a shared IRQ line?
> Is the IRQ disabled for all other devices on the same IRQ line?
>

Yup, devm is completely broken for shared IRQs.

> >       clk_disable_unprepare(dspi->clk);
> >       spi_unregister_controller(dspi->ctlr);
> >
> >
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
