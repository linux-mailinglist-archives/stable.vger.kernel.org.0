Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBCC11A15FB
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 21:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDGTas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 15:30:48 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45304 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDGTas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 15:30:48 -0400
Received: by mail-oi1-f193.google.com with SMTP id l22so2539489oii.12;
        Tue, 07 Apr 2020 12:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUcEP0TazvfHwi9YzKaViOgtAT941NHsPz2PZlh30Iw=;
        b=lPxpkeRIA4SIyM21lAdOng9/MaO1rms0Fnz7jgYHnvf+olFppC8T5JWL+be5RKlQbu
         MRodNzd8LE3dfEFKZ5a+hFTk273gXi0f6eANBihtj154kAx8q9h7GbjRfvMXOd9E4W/t
         tYgv5zqIt/O9ilxmBdvq9rCFP4SB86crp6WN7ZR8lPkDtnEqKtYaXIohIk7khie6fhdr
         RdF0YpHcX1RRkRolHh3eVI6VBkHzy5k4+412sjDhT5c5FS7pFuUSW3BZUvxGBTEwim54
         2pJexeVD4tKTrfBClgyvde3iqq2TudzNvT0CufJ0apR71txdMsXjMoXvwtwHB1Me0seC
         tFqA==
X-Gm-Message-State: AGi0PuaLdKhXpxderVvR1c/TMeB7t4vj6HHRz57cvTqH2tXq/4QS1BDr
        o/rIHz+YvTGiI4njdtXbfjY4euiIU32pin0eNu4=
X-Google-Smtp-Source: APiQypJaHKqnOYt8rsO5MsLP7g/irH2QvMiIsryzq4OHsxry1Xm282OKP8VaV+lbyTMS/Oahpui/xrmaLzl0jl9ZJfM=
X-Received: by 2002:aca:f07:: with SMTP id 7mr370949oip.68.1586287845667; Tue,
 07 Apr 2020 12:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200407181116.61066-1-hdegoede@redhat.com>
In-Reply-To: <20200407181116.61066-1-hdegoede@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 7 Apr 2020 21:30:34 +0200
Message-ID: <CAJZ5v0g2vvCHssUS4QG3UccH-wFNueo_zbAzdVMdHfVwrtyMWg@mail.gmail.com>
Subject: Re: [PATCH] i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND
 flag on BYT and CHT
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 7, 2020 at 8:11 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> We already set DPM_FLAG_SMART_PREPARE, so we completely skip all
> callbacks (other then prepare) where possible, quoting from
> dw_i2c_plat_prepare():
>
>         /*
>          * If the ACPI companion device object is present for this device, it
>          * may be accessed during suspend and resume of other devices via I2C
>          * operation regions, so tell the PM core and middle layers to avoid
>          * skipping system suspend/resume callbacks for it in that case.
>          */
>         return !has_acpi_companion(dev);
>
> Also setting the DPM_FLAG_SMART_SUSPEND will cause acpi_subsys_suspend()
> to leave the controller runtime-suspended even if dw_i2c_plat_prepare()
> returned 0.
>
> Leaving the controller runtime-suspended normally, when the I2C controller
> is suspended during the suspend_late phase, is not an issue because
> the pm_runtime_get_sync() done by i2c_dw_xfer() will (runtime-)resume it.
>
> But for dw I2C controllers on Bay- and Cherry-Trail devices acpi_lpss.c
> leaves the controller alive until the suspend_noirq phase, because it may
> be used by the _PS3 ACPI methods of PCI devices and PCI devices are left
> powered on until the suspend_noirq phase.
>
> Between the suspend_late and resume_early phases runtime-pm is disabled.
> So for any ACPI I2C OPRegion accesses done after the suspend_late phase,
> the pm_runtime_get_sync() done by i2c_dw_xfer() is a no-op and the
> controller is left runtime-suspended.
>
> i2c_dw_xfer() has a check to catch this condition (rather then waiting
> for the I2C transfer to timeout because the controller is suspended).
> acpi_subsys_suspend() leaving the controller runtime-suspended in
> combination with an ACPI I2C OPRegion access done after the suspend_late
> phase triggers this check, leading to the following error being logged
> on a Bay Trail based Lenovo Thinkpad 8 tablet:
>
> [   93.275882] i2c_designware 80860F41:00: Transfer while suspended
> [   93.275993] WARNING: CPU: 0 PID: 412 at drivers/i2c/busses/i2c-designware-master.c:429 i2c_dw_xfer+0x239/0x280
> ...
> [   93.276252] Workqueue: kacpi_notify acpi_os_execute_deferred
> [   93.276267] RIP: 0010:i2c_dw_xfer+0x239/0x280
> ...
> [   93.276340] Call Trace:
> [   93.276366]  __i2c_transfer+0x121/0x520
> [   93.276379]  i2c_transfer+0x4c/0x100
> [   93.276392]  i2c_acpi_space_handler+0x219/0x510
> [   93.276408]  ? up+0x40/0x60
> [   93.276419]  ? i2c_acpi_notify+0x130/0x130
> [   93.276433]  acpi_ev_address_space_dispatch+0x1e1/0x252
> ...
>
> So since on BYT and CHT platforms we want ACPI I2c OPRegion accesses
> to work until the suspend_noirq phase, we need the controller to be
> runtime-resumed during the suspend phase if it is runtime-suspended
> suspended at that time. This means that we must not set the
> DPM_FLAG_SMART_SUSPEND on these platforms.
>
> On BYT and CHT we already have a special ACCESS_NO_IRQ_SUSPEND flag
> to make sure the controller stays functional until the suspend_noirq
> phase. This commit makes the driver not set the DPM_FLAG_SMART_SUSPEND
> flag when that flag is set.

OK

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> Cc: stable@vger.kernel.org
> Fixes: b30f2f65568f ("i2c: designware: Set IRQF_NO_SUSPEND flag for all BYT and CHT controllers")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/i2c/busses/i2c-designware-platdrv.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index 3b7d58c2fe85..15b4b965b443 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -371,10 +371,16 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
>         adap->dev.of_node = pdev->dev.of_node;
>         adap->nr = -1;
>
> -       dev_pm_set_driver_flags(&pdev->dev,
> -                               DPM_FLAG_SMART_PREPARE |
> -                               DPM_FLAG_SMART_SUSPEND |
> -                               DPM_FLAG_LEAVE_SUSPENDED);
> +       if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
> +               dev_pm_set_driver_flags(&pdev->dev,
> +                                       DPM_FLAG_SMART_PREPARE |
> +                                       DPM_FLAG_LEAVE_SUSPENDED);
> +       } else {
> +               dev_pm_set_driver_flags(&pdev->dev,
> +                                       DPM_FLAG_SMART_PREPARE |
> +                                       DPM_FLAG_SMART_SUSPEND |
> +                                       DPM_FLAG_LEAVE_SUSPENDED);
> +       }
>
>         /* The code below assumes runtime PM to be disabled. */
>         WARN_ON(pm_runtime_enabled(&pdev->dev));
> --
> 2.26.0
>
