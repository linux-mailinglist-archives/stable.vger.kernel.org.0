Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2946DE47AE
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 11:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438753AbfJYJp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 05:45:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:17164 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392213AbfJYJp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 05:45:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 02:45:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="400058174"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006.fm.intel.com with ESMTP; 25 Oct 2019 02:45:10 -0700
Received: from andy by smile with local (Exim 4.92.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iNw9d-0003LE-Oq; Fri, 25 Oct 2019 12:45:09 +0300
Date:   Fri, 25 Oct 2019 12:45:09 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] ACPI / LPSS: Add dmi quirk for skipping _DEP
 check for some device-links
Message-ID: <20191025094509.GO32742@smile.fi.intel.com>
References: <20191024215723.145922-1-hdegoede@redhat.com>
 <20191024215723.145922-3-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024215723.145922-3-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 11:57:23PM +0200, Hans de Goede wrote:
> The iGPU / GFX0 device's _PS0 method on the ASUS T200TA depends on the
> I2C1 controller (which is connected to the embedded controller). But unlike
> in the T100TA/T100CHI this dependency is not listed in the _DEP of the GFX0
> device.
> 
> This results in the dev_WARN_ONCE(..., "Transfer while suspended\n") call
> in i2c-designware-master.c triggering and the AML code not working as it
> should.
> 
> This commit fixes this by adding a dmi based quirk mechanism for devices
> which miss a _DEP, and adding a quirk for the LNXVIDEO depending on the
> I2C1 device on the Asus T200TA.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

One comment below.

> Cc: stable@vger.kernel.org
> Fixes: 2d71ee0ce72f ("ACPI / LPSS: Add a device link from the GPU to the BYT I2C5 controller")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Add Fixes: tag
> 
> Changes in v3:
> -Point Fixes tag to a more apropriate commit
> ---
>  drivers/acpi/acpi_lpss.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index cd8cf3333f04..751ed38f2a10 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -10,6 +10,7 @@
>  #include <linux/acpi.h>
>  #include <linux/clkdev.h>
>  #include <linux/clk-provider.h>
> +#include <linux/dmi.h>
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/mutex.h>
> @@ -463,6 +464,18 @@ struct lpss_device_links {
>  	const char *consumer_hid;
>  	const char *consumer_uid;
>  	u32 flags;
> +	const struct dmi_system_id *dep_missing_ids;
> +};
> +
> +/* Please keep this list sorted alphabetically by vendor and model */
> +static const struct dmi_system_id i2c1_dep_missing_dmi_ids[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "T200TA"),
> +		},
> +	},
> +	{}
>  };
>  
>  /*
> @@ -478,7 +491,8 @@ static const struct lpss_device_links lpss_device_links[] = {
>  	/* CHT iGPU depends on PMIC I2C controller */
>  	{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>  	/* BYT iGPU depends on the Embedded Controller I2C controller (UID 1) */
> -	{"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
> +	{"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME,
> +	 i2c1_dep_missing_dmi_ids},
>  	/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
>  	{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>  	/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
> @@ -577,7 +591,8 @@ static void acpi_lpss_link_consumer(struct device *dev1,
>  	if (!dev2)
>  		return;
>  

> -	if (acpi_lpss_dep(ACPI_COMPANION(dev2), ACPI_HANDLE(dev1)))
> +	if ((link->dep_missing_ids && dmi_check_system(link->dep_missing_ids))
> +	    || acpi_lpss_dep(ACPI_COMPANION(dev2), ACPI_HANDLE(dev1)))
>  		device_link_add(dev2, dev1, link->flags);

Perhaps a helper?

>  
>  	put_device(dev2);
> @@ -592,7 +607,8 @@ static void acpi_lpss_link_supplier(struct device *dev1,
>  	if (!dev2)
>  		return;
>  
> -	if (acpi_lpss_dep(ACPI_COMPANION(dev1), ACPI_HANDLE(dev2)))
> +	if ((link->dep_missing_ids && dmi_check_system(link->dep_missing_ids))
> +	    || acpi_lpss_dep(ACPI_COMPANION(dev1), ACPI_HANDLE(dev2)))
>  		device_link_add(dev1, dev2, link->flags);

And use it here?

>  
>  	put_device(dev2);
> -- 
> 2.23.0
> 

-- 
With Best Regards,
Andy Shevchenko


