Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75711F97E9
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgFONIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:08:32 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:40785 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFONIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:08:31 -0400
Received: by mail-ej1-f67.google.com with SMTP id q19so17356132eja.7;
        Mon, 15 Jun 2020 06:08:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uEfo8b2oGA/RF5D4h01gUn0rBAtABIlUd1JHMHMPDcU=;
        b=rqV8Xm5+hLpKh53e47+AF1JuxUWpy37KePWHVmyvuC0cCAHGnuONGLfaf0iTEiB+LM
         rTckWNaiVQhK9Y9gBZO1idEgjC7eCDtMj+cHILreMfi13pU2xMBD3vFAnvmMDVAnQZRf
         dhvH8OVfVdsrhwHqreGgEfJCqJm3YF9X3YTRvo4z7+QCPCkJobs8lCmbkwSbqLxp/pvz
         lIiYvIzILPSO0do7Ic5BUcFWHRFACuZxEggaK/m4irARcYZT5Dt4d0xCSGLBqt1Yu3MB
         fHyuswWw82RhZmwkHtStA+hr8kWcF5yfPurlOeME8PF/rtJ1oScbafJsPhyazHUpiJy8
         NbPg==
X-Gm-Message-State: AOAM530HDatIIzOX822HAl11ZcAG6nYRA6R/sJSDV2amvLsjP6+wNRPQ
        h/PNMCwJw9O/DK5jY7U/tCA=
X-Google-Smtp-Source: ABdhPJzTsLPoy+Tdwxd9Pi2RDK6DJe+eZn5/8FejwDeKXrZIhvmHMNsnUFZD5BSrPyGX8Jr78E+e3A==
X-Received: by 2002:a17:906:5602:: with SMTP id f2mr24770617ejq.381.1592226508183;
        Mon, 15 Jun 2020 06:08:28 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id ew9sm9043561ejb.121.2020.06.15.06.08.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 06:08:27 -0700 (PDT)
Date:   Mon, 15 Jun 2020 15:08:25 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on
 interrupt in exit paths
Message-ID: <20200615130825.GA2634@kozik-lap>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
 <CA+h21hrxQ1fRahyQGFS42Xuop_Q2petE=No1dft4nVb-ijUu2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hrxQ1fRahyQGFS42Xuop_Q2petE=No1dft4nVb-ijUu2g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 12:23:41PM +0300, Vladimir Oltean wrote:
> On Mon, 15 Jun 2020 at 11:18, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >
> > On 6/15/20 10:07 AM, Krzysztof Kozlowski wrote:
> > > If interrupt comes late, during probe error path or device remove (could
> > > be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> > > dspi_interrupt() will access registers with the clock being disabled.  This
> > > leads to external abort on non-linefetch on Toradex Colibri VF50 module
> > > (with Vybrid VF5xx):
> > >
> > >     $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
> > >
> > >     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
> > >     Internal error: : 1008 [#1] ARM
> > >     CPU: 0 PID: 136 Comm: sh Not tainted 5.7.0-next-20200610-00009-g5c913fa0f9c5-dirty #74
> > >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> > >       (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
> > >       (regmap_mmio_read) from [<8060e3b8>] (_regmap_bus_reg_read+0x24/0x28)
> > >       (_regmap_bus_reg_read) from [<80611c50>] (_regmap_read+0x70/0x1c0)
> > >       (_regmap_read) from [<80611dec>] (regmap_read+0x4c/0x6c)
> > >       (regmap_read) from [<80678ca0>] (dspi_interrupt+0x3c/0xa8)
> > >       (dspi_interrupt) from [<8017acec>] (free_irq+0x26c/0x3cc)
> > >       (free_irq) from [<8017dcec>] (devm_irq_release+0x1c/0x20)
> > >       (devm_irq_release) from [<805f98ec>] (release_nodes+0x1e4/0x298)
> > >       (release_nodes) from [<805f9ac8>] (devres_release_all+0x40/0x60)
> > >       (devres_release_all) from [<805f5134>] (device_release_driver_internal+0x108/0x1ac)
> > >       (device_release_driver_internal) from [<805f521c>] (device_driver_detach+0x20/0x24)
> > >
> > > Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > >
> > > ---
> > >
> > > This is an follow up of my other patch for I2C IMX driver [1]. Let's fix the
> > > issues consistently.
> > >
> > > [1] https://lore.kernel.org/lkml/1592130544-19759-2-git-send-email-krzk@kernel.org/T/#u
> > >
> > > Changes since v1:
> > > 1. Disable the IRQ instead of using non-devm interface.
> > > ---
> > >  drivers/spi/spi-fsl-dspi.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> > > index 58190c94561f..023e05c53b85 100644
> > > --- a/drivers/spi/spi-fsl-dspi.c
> > > +++ b/drivers/spi/spi-fsl-dspi.c
> > > @@ -1400,7 +1400,7 @@ static int dspi_probe(struct platform_device *pdev)
> > >               ret = dspi_request_dma(dspi, res->start);
> > >               if (ret < 0) {
> > >                       dev_err(&pdev->dev, "can't get dma channels\n");
> > > -                     goto out_clk_put;
> > > +                     goto disable_irq;
> > >               }
> > >       }
> > >
> > > @@ -1415,11 +1415,14 @@ static int dspi_probe(struct platform_device *pdev)
> > >       ret = spi_register_controller(ctlr);
> > >       if (ret != 0) {
> > >               dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
> > > -             goto out_clk_put;
> > > +             goto disable_irq;
> > >       }
> > >
> > >       return ret;
> > >
> > > +disable_irq:
> > > +     if (dspi->irq > 0)
> > > +             disable_irq(dspi->irq);
> > >  out_clk_put:
> > >       clk_disable_unprepare(dspi->clk);
> > >  out_ctlr_put:
> > > @@ -1435,6 +1438,8 @@ static int dspi_remove(struct platform_device *pdev)
> > >
> > >       /* Disconnect from the SPI framework */
> > >       dspi_release_dma(dspi);
> > > +     if (dspi->irq > 0)
> > > +             disable_irq(dspi->irq);
> >
> > What happens, if you re-bind the driver?
> > Is the IRQ still working?
> > Who is taking care of calling the enable_irq() again?
> > What happens, if you really have a shared IRQ line?
> > Is the IRQ disabled for all other devices on the same IRQ line?
> >
> 
> Yup, devm is completely broken for shared IRQs.

Then we're back to this massive rework of using non-devm interface.

Best regards,
Krzysztof

