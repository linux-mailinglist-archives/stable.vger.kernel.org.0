Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242AB1A1388
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 20:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgDGS1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 14:27:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:47432 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgDGS1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 14:27:32 -0400
IronPort-SDR: AGIFBY52DEGlRcB/Ds1wR2aIfae6cCfwDuo6hp2Cd13CFqqMtia57rVI1FNLY/f4pSOQbeI2Rj
 6EFfkeoLX67w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 11:27:32 -0700
IronPort-SDR: xPhvIsQvuXq+o8+4hPv+aTL3m1AJELt6wtU7AN5DO9/qQ+prItv6wsLiibBCxxOLFSyagElg2a
 cqKZRnxF/vOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,356,1580803200"; 
   d="scan'208";a="397946599"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga004.jf.intel.com with ESMTP; 07 Apr 2020 11:27:29 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jLswd-00GUoV-Ld; Tue, 07 Apr 2020 21:27:31 +0300
Date:   Tue, 7 Apr 2020 21:27:31 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: platdrv: Remove DPM_FLAG_SMART_SUSPEND
 flag on BYT and CHT
Message-ID: <20200407182731.GL3676135@smile.fi.intel.com>
References: <20200407181116.61066-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407181116.61066-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 08:11:16PM +0200, Hans de Goede wrote:
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

FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

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
>  	adap->dev.of_node = pdev->dev.of_node;
>  	adap->nr = -1;
>  
> -	dev_pm_set_driver_flags(&pdev->dev,
> -				DPM_FLAG_SMART_PREPARE |
> -				DPM_FLAG_SMART_SUSPEND |
> -				DPM_FLAG_LEAVE_SUSPENDED);
> +	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
> +		dev_pm_set_driver_flags(&pdev->dev,
> +					DPM_FLAG_SMART_PREPARE |
> +					DPM_FLAG_LEAVE_SUSPENDED);
> +	} else {
> +		dev_pm_set_driver_flags(&pdev->dev,
> +					DPM_FLAG_SMART_PREPARE |
> +					DPM_FLAG_SMART_SUSPEND |
> +					DPM_FLAG_LEAVE_SUSPENDED);
> +	}
>  
>  	/* The code below assumes runtime PM to be disabled. */
>  	WARN_ON(pm_runtime_enabled(&pdev->dev));
> -- 
> 2.26.0
> 

-- 
With Best Regards,
Andy Shevchenko


