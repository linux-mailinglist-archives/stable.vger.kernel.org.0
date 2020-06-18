Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745EB1FFD5A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 23:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgFRVZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 17:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFRVZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 17:25:09 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA57C06174E;
        Thu, 18 Jun 2020 14:25:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id y6so5999277edi.3;
        Thu, 18 Jun 2020 14:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wt2S6gvN5Q8oV3GWEdCg7wrKKfO6iZTKrifPL12Vwnw=;
        b=cXYCsDgm0o8GdK3uVadnCbMyL4WHOMgNDlgOxQ0MK312pFtNKePMajUN9SIQ1c1+nQ
         37T4bLmORGI076SJizqRt2bOG6nZEV+gvZB1HY+/MpawGVWdA1ff7UfVr1MKHPk7lk0s
         F3eoenj1XXYGm6Tt0cGdk0UFkR0k5fJ8eZThQgUF1wvynnuZ87ezWYX/or1mAKPLDAQb
         WZEcM58pp31iiBk0yiaKAWcznq59VRUpfhB5+zWmeBFirn/EqYc0LPb7iVK0T7403cuB
         ECnyl1e6JnePJTEzHCQr9OEyN3AA2SVCTAZkOeIf/JfV/hpruiiPFUYuIXL/V8D/GG9m
         Ixsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wt2S6gvN5Q8oV3GWEdCg7wrKKfO6iZTKrifPL12Vwnw=;
        b=bB5Ga/eNtJZVCX22vrktjIztl9UWzveCbdfjo6EukIa9bpsvEtqXQr9BH0+BsXQW2p
         sW/BsBh9yIF+4Tf3Xpjzy7Yihkm4xtiLMc7iEfbcmUjKLyuWeA+v3Vzj6ugKlFC4j7IF
         LqAs6Fm7oOWneBjsJ8MUg7bvlfrqAYsVFWfdIdK0blXJAejrqOt8w6rjRRc/JzRgHZe4
         oiX/UtA56xQik7WZWK5C8CGf9DJ9DQteL/bDVt+vvg66cxyWHWZd1hPo3BXk3JQ/kZT8
         ylLXvPJ9xFBYdwEWDnseysLZyHTrBdynXRuP0NzlJZnlxkIpTizkKJCkwdy6949rzpQh
         QBxQ==
X-Gm-Message-State: AOAM530J9BKm2dTDZOppT/lLepIkwhlkgUi2LDN668kivUJ/tIrE57w6
        TEcevEPbWau9UrV4z2NEVwv52Oa1vxnbdaSIAd4=
X-Google-Smtp-Source: ABdhPJwxV6Sq0oG3HQwOBCddEvFkYNq9/3VVDKeMLKQ1fnVj5XWPDSW7ptqExTPUcn04odytWCIN78T0mQxIDBlVC5s=
X-Received: by 2002:a05:6402:b5c:: with SMTP id bx28mr189437edb.145.1592515507154;
 Thu, 18 Jun 2020 14:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <1592300467-29196-1-git-send-email-krzk@kernel.org>
In-Reply-To: <1592300467-29196-1-git-send-email-krzk@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 19 Jun 2020 00:24:56 +0300
Message-ID: <CA+h21hoxbgj5qjACbZSX9_JqL0cp1rX12FA3Dba0b9ARvp7vqw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] spi: spi-fsl-dspi: Fix external abort on interrupt
 in resume or exit paths
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Krzysztof,

On Tue, 16 Jun 2020 at 12:42, Krzysztof Kozlowski <krzk@kernel.org> wrote:
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
> index 58190c94561f..7ecc90ec8f2f 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1109,6 +1109,8 @@ static int dspi_suspend(struct device *dev)
>         struct spi_controller *ctlr = dev_get_drvdata(dev);
>         struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
>
> +       if (dspi->irq > 0)

Since the line right above "goto poll_mode" is executing "dspi->irq =
0;" on error, all these checks could have been simplified as "if
(dspi->irq)" which is slightly easier on the eye.


> +               disable_irq(dspi->irq);
>         spi_controller_suspend(ctlr);
>         clk_disable_unprepare(dspi->clk);
>
> @@ -1129,6 +1131,8 @@ static int dspi_resume(struct device *dev)
>         if (ret)
>                 return ret;
>         spi_controller_resume(ctlr);
> +       if (dspi->irq > 0)
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
> +       if (dspi->irq > 0)
> +               free_irq(dspi->irq, dspi);
>  out_clk_put:
>         clk_disable_unprepare(dspi->clk);
>  out_ctlr_put:
> @@ -1435,6 +1442,8 @@ static int dspi_remove(struct platform_device *pdev)
>
>         /* Disconnect from the SPI framework */
>         dspi_release_dma(dspi);
> +       if (dspi->irq > 0)
> +               free_irq(dspi->irq, dspi);

There is a subtle but important bug here: by waiting for the current
interrupt to finish and removing the handler, you are effectively
causing dspi_transfer_one_message to deadlock. The way this driver
works (and I'm sure many others) is that it transmits a SPI buffer
through a train of interrupts: each completion of a chunk triggers the
transmission of the next one, which will eventually raise an IRQ and
the process continues. But if you just disable the IRQ like that, you
effectively chop the interrupt train in the middle, and
dspi_transfer_one_message will remain stuck in
wait_for_completion(&dspi->xfer_done).
The reason why you don't do this (while I very much do) is that you
seem to be on Vybrid which uses DMA mode, and for DMA, the DSPI
interrupt line doesn't really do much of anything at all (which makes
it a bit funny that you're spending so much time working on it).
Instead, the completion events go from the DSPI controller directly to
the DMA controller, requesting for more data, and that's where IRQs
are raised to the CPU.
So, to avoid this deadlock, I would suggest you move
spi_unregister_controller as the first thing that gets called in the
teardown process. And yes, this should be a bugfix patch in itself.

And while I'm at it, let me add another one: this recent commit:

commit dc234825997ec6ff05980ca9e2204f4ac3f8d695
Author: Peng Ma <peng.ma@nxp.com>
Date:   Fri Apr 24 14:12:16 2020 +0800

    spi: spi-fsl-dspi: Adding shutdown hook

    We need to ensure dspi controller could be stopped in order for kexec
    to start the next kernel.
    So add the shutdown operation support.

    Signed-off-by: Peng Ma <peng.ma@nxp.com>
    Link: https://lore.kernel.org/r/20200424061216.27445-1-peng.ma@nxp.com
    Signed-off-by: Mark Brown <broonie@kernel.org>

is causing some very similar issues: if you look at the code it adds,
it disables the FIFOs and halts the module, which is bad for the same
reason that it will hang an ongoing interrupt train in
dspi_transfer_one_message:

[17159.264026] INFO: task init:1870 blocked for more than 120 seconds.
[17159.270385]       Not tainted 5.8.0-rc1-00133-g923e4b5032dd-dirty #208
[17159.276953] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[17159.284828] init            D    0  1870      1 0x00000008
[17159.290353] Call trace:
[17159.292828]  __switch_to+0x108/0x158
[17159.296433]  __schedule+0x320/0x870
[17159.299933]  schedule+0x50/0x110
[17159.303188]  schedule_timeout+0x35c/0x438
[17159.307229]  wait_for_completion+0xb0/0x148
[17159.311444]  dspi_transfer_one_message+0x8c/0x4d0
[17159.316180]  __spi_pump_messages+0x434/0x9a8
[17159.320480]  __spi_sync+0x2ec/0x3a8
[17159.323994]  spi_sync+0x3c/0x60
[17159.327149]  spi_sync_transfer+0x94/0xb8
[17159.331101]  sja1105_xfer.isra.0+0x26c/0x2f8
[17159.335402]  sja1105_xfer_buf+0x20/0x30
[17159.339267]  sja1105_dynamic_config_write+0x18c/0x1e0
[17159.344353]  sja1105_bridge_stp_state_set+0x58/0xd0
[17159.349265]  dsa_port_set_state+0x74/0xd0
[17159.353303]  dsa_port_set_state_now+0x28/0x58
[17159.357690]  dsa_port_disable_rt+0x74/0x78
[17159.361818]  dsa_slave_close+0x2c/0xd0
[17159.365601]  __dev_close_many+0xcc/0x150
[17159.369553]  dev_close_many+0x8c/0x130
[17159.373330]  rollback_registered_many+0x128/0x550
[17159.378066]  unregister_netdevice_queue+0x98/0x120
[17159.382891]  unregister_netdev+0x2c/0x40
[17159.386843]  dsa_slave_destroy+0x4c/0x80
[17159.390795]  dsa_port_teardown+0xa0/0xd0
[17159.394746]  dsa_tree_teardown_switches+0x40/0x98
[17159.399481]  dsa_unregister_switch+0xbc/0x170
[17159.403868]  sja1105_remove+0x20/0x30
[17159.407557]  spi_drv_remove+0x34/0x58
[17159.411247]  device_release_driver_internal+0x104/0x1d8
[17159.416506]  device_release_driver+0x20/0x30
[17159.420808]  bus_remove_device+0xdc/0x168
[17159.424847]  device_del+0x15c/0x3b0
[17159.428363]  device_unregister+0x28/0x80
[17159.432313]  spi_unregister_device+0x8c/0xb0
[17159.436613]  __unregister+0x18/0x28
[17159.440130]  device_for_each_child+0x64/0xb0
[17159.444430]  spi_unregister_controller+0x44/0x140
[17159.449168]  dspi_shutdown+0x88/0x98
[17159.452770]  platform_drv_shutdown+0x28/0x38
[17159.457072]  device_shutdown+0x168/0x340
[17159.461024]  kernel_restart_prepare+0x40/0x50
[17159.465416]  kernel_restart+0x20/0x70
[17159.469107]  __do_sys_reboot+0x22c/0x258
[17159.473058]  __arm64_sys_reboot+0x2c/0x38
[17159.477098]  el0_svc_common.constprop.0+0x7c/0x180
[17159.481921]  do_el0_svc+0x2c/0x98
[17159.485261]  el0_sync_handler+0x9c/0x1b8
[17159.489213]  el0_sync+0x158/0x180
[17159.492556] INFO: lockdep is turned off.
[17159.496508] Kernel panic - not syncing: hung_task: blocked tasks
[17159.502537] CPU: 1 PID: 25 Comm: khungtaskd Not tainted
5.8.0-rc1-00133-g923e4b5032dd-dirty #208
[17159.516767] Call trace:
[17159.519218]  dump_backtrace+0x0/0x1e0
[17159.522889]  show_stack+0x20/0x30
[17159.526214]  dump_stack+0xec/0x158
[17159.529624]  panic+0x16c/0x37c
[17159.532686]  watchdog+0x3d8/0x7f8
[17159.536008]  kthread+0x158/0x168
[17159.539245]  ret_from_fork+0x10/0x1c
[17159.542844] Kernel Offset: 0x5bd125880000 from 0xffff800010000000
[17159.548957] PHYS_OFFSET: 0xffffafdb00000000
[17159.553151] CPU features: 0x240022,21806008
[17159.557346] Memory Limit: none
[17159.560414] Rebooting in 3 seconds..

So for this third issue, what I would suggest would be to merge
dspi_shutdown with the reworked version of dspi_remove (i.e. to move
"/* Disable RX and TX */" and "/* Stop Running */" to dspi_remove,
right before clk_disable_unprepare, and then just call dspi_remove
from dspi_shutdown. It would end up looking like this:

static int dspi_remove(struct platform_device *pdev)
{
    struct spi_controller *ctlr = platform_get_drvdata(pdev);
    struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);

    /* Disconnect from the SPI framework */
    spi_unregister_controller(dspi->ctlr);

    dspi_release_dma(dspi);
    if (dspi->irq > 0)
        free_irq(dspi->irq, dspi);

    /* Disable RX and TX */
    regmap_update_bits(dspi->regmap, SPI_MCR,
               SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
               SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);

    /* Stop Running */
    regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);

    clk_disable_unprepare(dspi->clk);

    return 0;
}

static void dspi_shutdown(struct platform_device *pdev)
{
    dspi_remove(pdev);
}

If you think it's too complicated or that you can't test, let me know
and I can take over the patch series.

>         clk_disable_unprepare(dspi->clk);
>         spi_unregister_controller(dspi->ctlr);
>
> --
> 2.7.4
>

Thanks,
-Vladimir
