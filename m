Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357862034DB
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 12:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgFVKbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 06:31:14 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:33089 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgFVKbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 06:31:01 -0400
Received: by mail-ej1-f66.google.com with SMTP id n24so17502008ejd.0;
        Mon, 22 Jun 2020 03:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ckKsMq8ITFq/ilrKu/PZQQYxxR9UxebEGV3IDPDQoOU=;
        b=Y2xNvV0GHEdWuFX/qa2KwuuRzA1uI7yOHW1gVEKieZbm4vz0We0RaGNdvkvm842lXj
         FMneXczzVWzSm1ugGlD5WQtaI3yIoLl7IPys4UvXuK2P2vgEJrtSYOsxTWcoyNXYBmNw
         Bffdf/lTHXZDKVbBDXxDEKfFELUJrnsviNrbK8LWc8qcRP2bzm60wggolfbR355/T3cQ
         xHdu15RIXu+Q6cNY/nJ62UxYN7mQhPtln/RzFgxSkbIczzlMMrYTWpYpRCLPna2XKrNv
         aWoZ3apxfYmY6UMAmfr8hSpUHpL7Ux8VlVDiSMIj0jad+7334k9I/j38/zigmRbbU7l+
         Cc6A==
X-Gm-Message-State: AOAM533kqdWsZrlvGKPh7ehqHanJ0z7mSdBhbS4X7KEz/xkmVOZ2bk3Y
        xgm+gRj5B8mUGvXDb5CeMYE=
X-Google-Smtp-Source: ABdhPJzspbUk0TaXHXx2IG8Cd+8R8X3TjTS7GIKo4oqBOiIEFK5i4OtxEgcDmLIVRGMrP3kjqYHFVg==
X-Received: by 2002:a17:906:7e19:: with SMTP id e25mr14835761ejr.319.1592821855835;
        Mon, 22 Jun 2020 03:30:55 -0700 (PDT)
Received: from kozik-lap ([194.230.155.235])
        by smtp.googlemail.com with ESMTPSA id aq25sm3071996ejc.11.2020.06.22.03.30.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2020 03:30:54 -0700 (PDT)
Date:   Mon, 22 Jun 2020 12:30:52 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] spi: spi-fsl-dspi: Fix external abort on
 interrupt in resume or exit paths
Message-ID: <20200622103052.GA2929@kozik-lap>
References: <1592300467-29196-1-git-send-email-krzk@kernel.org>
 <CA+h21hoxbgj5qjACbZSX9_JqL0cp1rX12FA3Dba0b9ARvp7vqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hoxbgj5qjACbZSX9_JqL0cp1rX12FA3Dba0b9ARvp7vqw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 12:24:56AM +0300, Vladimir Oltean wrote:
> Hi Krzysztof,
> 
> On Tue, 16 Jun 2020 at 12:42, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > If shared interrupt comes late, during probe error path or device remove
> > (could be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> > dspi_interrupt() will access registers with the clock being disabled.
> > This leads to external abort on non-linefetch on Toradex Colibri VF50
> > module (with Vybrid VF5xx):
> >
> >     $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
> >
> >     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
> >     Internal error: : 1008 [#1] ARM
> >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> >     Backtrace:
> >       (regmap_mmio_read32le)
> >       (regmap_mmio_read)
> >       (_regmap_bus_reg_read)
> >       (_regmap_read)
> >       (regmap_read)
> >       (dspi_interrupt)
> >       (free_irq)
> >       (devm_irq_release)
> >       (release_nodes)
> >       (devres_release_all)
> >       (device_release_driver_internal)
> >
> > The resource-managed framework should not be used for shared interrupt
> > handling, because the interrupt handler might be called after releasing
> > other resources and disabling clocks.
> >
> > Similar bug could happen during suspend - the shared interrupt handler
> > could be invoked after suspending the device.  Each device sharing this
> > interrupt line should disable the IRQ during suspend so handler will be
> > invoked only in following cases:
> > 1. None suspended,
> > 2. All devices resumed.
> >
> > Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> >
> > ---
> >
> > Changes since v2:
> > 1. Go back to v1 and use non-devm interface,
> > 2. Fix also suspend/resume paths.
> >
> > Changes since v1:
> > 1. Disable the IRQ instead of using non-devm interface.
> > ---
> >  drivers/spi/spi-fsl-dspi.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> > index 58190c94561f..7ecc90ec8f2f 100644
> > --- a/drivers/spi/spi-fsl-dspi.c
> > +++ b/drivers/spi/spi-fsl-dspi.c
> > @@ -1109,6 +1109,8 @@ static int dspi_suspend(struct device *dev)
> >         struct spi_controller *ctlr = dev_get_drvdata(dev);
> >         struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
> >
> > +       if (dspi->irq > 0)
> 
> Since the line right above "goto poll_mode" is executing "dspi->irq =
> 0;" on error, all these checks could have been simplified as "if
> (dspi->irq)" which is slightly easier on the eye.

Indeed.

> 
> 
> > +               disable_irq(dspi->irq);
> >         spi_controller_suspend(ctlr);
> >         clk_disable_unprepare(dspi->clk);
> >
> > @@ -1129,6 +1131,8 @@ static int dspi_resume(struct device *dev)
> >         if (ret)
> >                 return ret;
> >         spi_controller_resume(ctlr);
> > +       if (dspi->irq > 0)
> > +               enable_irq(dspi->irq);
> >
> >         return 0;
> >  }
> > @@ -1385,8 +1389,8 @@ static int dspi_probe(struct platform_device *pdev)
> >                 goto poll_mode;
> >         }
> >
> > -       ret = devm_request_irq(&pdev->dev, dspi->irq, dspi_interrupt,
> > -                              IRQF_SHARED, pdev->name, dspi);
> > +       ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
> > +                                  IRQF_SHARED, pdev->name, dspi);
> >         if (ret < 0) {
> >                 dev_err(&pdev->dev, "Unable to attach DSPI interrupt\n");
> >                 goto out_clk_put;
> > @@ -1400,7 +1404,7 @@ static int dspi_probe(struct platform_device *pdev)
> >                 ret = dspi_request_dma(dspi, res->start);
> >                 if (ret < 0) {
> >                         dev_err(&pdev->dev, "can't get dma channels\n");
> > -                       goto out_clk_put;
> > +                       goto out_free_irq;
> >                 }
> >         }
> >
> > @@ -1415,11 +1419,14 @@ static int dspi_probe(struct platform_device *pdev)
> >         ret = spi_register_controller(ctlr);
> >         if (ret != 0) {
> >                 dev_err(&pdev->dev, "Problem registering DSPI ctlr\n");
> > -               goto out_clk_put;
> > +               goto out_free_irq;
> >         }
> >
> >         return ret;
> >
> > +out_free_irq:
> > +       if (dspi->irq > 0)
> > +               free_irq(dspi->irq, dspi);
> >  out_clk_put:
> >         clk_disable_unprepare(dspi->clk);
> >  out_ctlr_put:
> > @@ -1435,6 +1442,8 @@ static int dspi_remove(struct platform_device *pdev)
> >
> >         /* Disconnect from the SPI framework */
> >         dspi_release_dma(dspi);
> > +       if (dspi->irq > 0)
> > +               free_irq(dspi->irq, dspi);
> 
> There is a subtle but important bug here: by waiting for the current
> interrupt to finish and removing the handler, you are effectively
> causing dspi_transfer_one_message to deadlock. The way this driver
> works (and I'm sure many others) is that it transmits a SPI buffer
> through a train of interrupts: each completion of a chunk triggers the
> transmission of the next one, which will eventually raise an IRQ and
> the process continues. But if you just disable the IRQ like that, you
> effectively chop the interrupt train in the middle, and
> dspi_transfer_one_message will remain stuck in
> wait_for_completion(&dspi->xfer_done).
> The reason why you don't do this (while I very much do) is that you
> seem to be on Vybrid which uses DMA mode, and for DMA, the DSPI
> interrupt line doesn't really do much of anything at all (which makes
> it a bit funny that you're spending so much time working on it).
> Instead, the completion events go from the DSPI controller directly to
> the DMA controller, requesting for more data, and that's where IRQs
> are raised to the CPU.
> So, to avoid this deadlock, I would suggest you move
> spi_unregister_controller as the first thing that gets called in the
> teardown process. And yes, this should be a bugfix patch in itself.

You're right. It also makes sense from the reverse-probe-order point of
view.

> 
> And while I'm at it, let me add another one: this recent commit:
> 
> commit dc234825997ec6ff05980ca9e2204f4ac3f8d695
> Author: Peng Ma <peng.ma@nxp.com>
> Date:   Fri Apr 24 14:12:16 2020 +0800
> 
>     spi: spi-fsl-dspi: Adding shutdown hook
> 
>     We need to ensure dspi controller could be stopped in order for kexec
>     to start the next kernel.
>     So add the shutdown operation support.
> 
>     Signed-off-by: Peng Ma <peng.ma@nxp.com>
>     Link: https://lore.kernel.org/r/20200424061216.27445-1-peng.ma@nxp.com
>     Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> is causing some very similar issues: if you look at the code it adds,
> it disables the FIFOs and halts the module, which is bad for the same
> reason that it will hang an ongoing interrupt train in
> dspi_transfer_one_message:
> 
> [17159.264026] INFO: task init:1870 blocked for more than 120 seconds.
> [17159.270385]       Not tainted 5.8.0-rc1-00133-g923e4b5032dd-dirty #208
> [17159.276953] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [17159.284828] init            D    0  1870      1 0x00000008
> [17159.290353] Call trace:
> [17159.292828]  __switch_to+0x108/0x158
> [17159.296433]  __schedule+0x320/0x870
> [17159.299933]  schedule+0x50/0x110
> [17159.303188]  schedule_timeout+0x35c/0x438
> [17159.307229]  wait_for_completion+0xb0/0x148
> [17159.311444]  dspi_transfer_one_message+0x8c/0x4d0
> [17159.316180]  __spi_pump_messages+0x434/0x9a8
> [17159.320480]  __spi_sync+0x2ec/0x3a8
> [17159.323994]  spi_sync+0x3c/0x60
> [17159.327149]  spi_sync_transfer+0x94/0xb8
> [17159.331101]  sja1105_xfer.isra.0+0x26c/0x2f8
> [17159.335402]  sja1105_xfer_buf+0x20/0x30
> [17159.339267]  sja1105_dynamic_config_write+0x18c/0x1e0
> [17159.344353]  sja1105_bridge_stp_state_set+0x58/0xd0
> [17159.349265]  dsa_port_set_state+0x74/0xd0
> [17159.353303]  dsa_port_set_state_now+0x28/0x58
> [17159.357690]  dsa_port_disable_rt+0x74/0x78
> [17159.361818]  dsa_slave_close+0x2c/0xd0
> [17159.365601]  __dev_close_many+0xcc/0x150
> [17159.369553]  dev_close_many+0x8c/0x130
> [17159.373330]  rollback_registered_many+0x128/0x550
> [17159.378066]  unregister_netdevice_queue+0x98/0x120
> [17159.382891]  unregister_netdev+0x2c/0x40
> [17159.386843]  dsa_slave_destroy+0x4c/0x80
> [17159.390795]  dsa_port_teardown+0xa0/0xd0
> [17159.394746]  dsa_tree_teardown_switches+0x40/0x98
> [17159.399481]  dsa_unregister_switch+0xbc/0x170
> [17159.403868]  sja1105_remove+0x20/0x30
> [17159.407557]  spi_drv_remove+0x34/0x58
> [17159.411247]  device_release_driver_internal+0x104/0x1d8
> [17159.416506]  device_release_driver+0x20/0x30
> [17159.420808]  bus_remove_device+0xdc/0x168
> [17159.424847]  device_del+0x15c/0x3b0
> [17159.428363]  device_unregister+0x28/0x80
> [17159.432313]  spi_unregister_device+0x8c/0xb0
> [17159.436613]  __unregister+0x18/0x28
> [17159.440130]  device_for_each_child+0x64/0xb0
> [17159.444430]  spi_unregister_controller+0x44/0x140
> [17159.449168]  dspi_shutdown+0x88/0x98
> [17159.452770]  platform_drv_shutdown+0x28/0x38
> [17159.457072]  device_shutdown+0x168/0x340
> [17159.461024]  kernel_restart_prepare+0x40/0x50
> [17159.465416]  kernel_restart+0x20/0x70
> [17159.469107]  __do_sys_reboot+0x22c/0x258
> [17159.473058]  __arm64_sys_reboot+0x2c/0x38
> [17159.477098]  el0_svc_common.constprop.0+0x7c/0x180
> [17159.481921]  do_el0_svc+0x2c/0x98
> [17159.485261]  el0_sync_handler+0x9c/0x1b8
> [17159.489213]  el0_sync+0x158/0x180
> [17159.492556] INFO: lockdep is turned off.
> [17159.496508] Kernel panic - not syncing: hung_task: blocked tasks
> [17159.502537] CPU: 1 PID: 25 Comm: khungtaskd Not tainted
> 5.8.0-rc1-00133-g923e4b5032dd-dirty #208
> [17159.516767] Call trace:
> [17159.519218]  dump_backtrace+0x0/0x1e0
> [17159.522889]  show_stack+0x20/0x30
> [17159.526214]  dump_stack+0xec/0x158
> [17159.529624]  panic+0x16c/0x37c
> [17159.532686]  watchdog+0x3d8/0x7f8
> [17159.536008]  kthread+0x158/0x168
> [17159.539245]  ret_from_fork+0x10/0x1c
> [17159.542844] Kernel Offset: 0x5bd125880000 from 0xffff800010000000
> [17159.548957] PHYS_OFFSET: 0xffffafdb00000000
> [17159.553151] CPU features: 0x240022,21806008
> [17159.557346] Memory Limit: none
> [17159.560414] Rebooting in 3 seconds..
> 
> So for this third issue, what I would suggest would be to merge
> dspi_shutdown with the reworked version of dspi_remove (i.e. to move
> "/* Disable RX and TX */" and "/* Stop Running */" to dspi_remove,
> right before clk_disable_unprepare, and then just call dspi_remove
> from dspi_shutdown. It would end up looking like this:
> 
> static int dspi_remove(struct platform_device *pdev)
> {
>     struct spi_controller *ctlr = platform_get_drvdata(pdev);
>     struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
> 
>     /* Disconnect from the SPI framework */
>     spi_unregister_controller(dspi->ctlr);
> 
>     dspi_release_dma(dspi);
>     if (dspi->irq > 0)
>         free_irq(dspi->irq, dspi);
> 
>     /* Disable RX and TX */
>     regmap_update_bits(dspi->regmap, SPI_MCR,
>                SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
>                SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);
> 
>     /* Stop Running */
>     regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
> 
>     clk_disable_unprepare(dspi->clk);
> 
>     return 0;
> }
> 
> static void dspi_shutdown(struct platform_device *pdev)
> {
>     dspi_remove(pdev);
> }

Yes, good point. The shutdown also lacks the interrupt freeing in my
patch.

Best regards,
Krzysztof

> 
> If you think it's too complicated or that you can't test, let me know
> and I can take over the patch series.
> 
> >         clk_disable_unprepare(dspi->clk);
> >         spi_unregister_controller(dspi->ctlr);
> >
> > --
> > 2.7.4
> >
> 
> Thanks,
> -Vladimir
