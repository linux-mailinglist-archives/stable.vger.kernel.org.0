Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43D7A00CF
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 13:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfH1Lhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 07:37:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:54301 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbfH1Lhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 07:37:53 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 04:37:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="188196893"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Aug 2019 04:37:50 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i2wGq-0007UH-Up; Wed, 28 Aug 2019 14:37:48 +0300
Date:   Wed, 28 Aug 2019 14:37:48 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>
Subject: Re: [PATCH v2] gpiolib: acpi: Add
 gpiolib_acpi_run_edge_events_on_boot option and blacklist
Message-ID: <20190828113748.GK2680@smile.fi.intel.com>
References: <20190827202835.213456-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827202835.213456-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 10:28:35PM +0200, Hans de Goede wrote:
> Another day; another DSDT bug we need to workaround...
> 
> Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
> at least once on boot") we call _AEI edge handlers at boot.
> 
> In some rare cases this causes problems. One example of this is the Minix
> Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
> and pasted code for dealing with Micro USB-B connector host/device role
> switching, while the mini PC does not even have a micro-USB connector.
> This code, which should not be there, messes with the DDC data pin from
> the HDMI connector (switching it to GPIO mode) breaking HDMI support.
> 
> To avoid problems like this, this commit adds a new
> gpiolib_acpi.run_edge_events_on_boot kernel commandline option, which
> allows disabling the running of _AEI edge event handlers at boot.
> 
> The default value is -1/auto which uses a DMI based blacklist, the initial
> version of this blacklist contains the Neo Z83-4 fixing the HDMI breakage.

Thank you!

Assuming it works for Ian,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> 
> Cc: stable@vger.kernel.org
> Cc: Daniel Drake <drake@endlessm.com>
> Cc: Ian W MORRISON <ianwmorrison@gmail.com>
> Reported-by: Ian W MORRISON <ianwmorrison@gmail.com>
> Suggested-by: Ian W MORRISON <ianwmorrison@gmail.com>
> Fixes: ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> - Use a module_param instead of __setup
> - Do DMI check only once from a postcore_initcall
> ---
>  drivers/gpio/gpiolib-acpi.c | 42 +++++++++++++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index 39f2f9035c11..bda28eb82c3f 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -7,6 +7,7 @@
>   *          Mika Westerberg <mika.westerberg@linux.intel.com>
>   */
>  
> +#include <linux/dmi.h>
>  #include <linux/errno.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/gpio/driver.h>
> @@ -19,6 +20,11 @@
>  
>  #include "gpiolib.h"
>  
> +static int run_edge_events_on_boot = -1;
> +module_param(run_edge_events_on_boot, int, 0444);
> +MODULE_PARM_DESC(run_edge_events_on_boot,
> +		 "Run edge _AEI event-handlers at boot: 0=no, 1=yes, -1=auto");
> +
>  /**
>   * struct acpi_gpio_event - ACPI GPIO event handler data
>   *
> @@ -170,10 +176,13 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
>  	event->irq_requested = true;
>  
>  	/* Make sure we trigger the initial state of edge-triggered IRQs */
> -	value = gpiod_get_raw_value_cansleep(event->desc);
> -	if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
> -	    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
> -		event->handler(event->irq, event);
> +	if (run_edge_events_on_boot &&
> +	    (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
> +		value = gpiod_get_raw_value_cansleep(event->desc);
> +		if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
> +		    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
> +			event->handler(event->irq, event);
> +	}
>  }
>  
>  static void acpi_gpiochip_request_irqs(struct acpi_gpio_chip *acpi_gpio)
> @@ -1283,3 +1292,28 @@ static int acpi_gpio_handle_deferred_request_irqs(void)
>  }
>  /* We must use _sync so that this runs after the first deferred_probe run */
>  late_initcall_sync(acpi_gpio_handle_deferred_request_irqs);
> +
> +static const struct dmi_system_id run_edge_events_on_boot_blacklist[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
> +		}
> +	},
> +	{} /* Terminating entry */
> +};
> +
> +static int acpi_gpio_setup_params(void)
> +{
> +	if (run_edge_events_on_boot < 0) {
> +		if (dmi_check_system(run_edge_events_on_boot_blacklist))
> +			run_edge_events_on_boot = 0;
> +		else
> +			run_edge_events_on_boot = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Directly after dmi_setup() which runs as core_initcall() */
> +postcore_initcall(acpi_gpio_setup_params);
> -- 
> 2.23.0
> 

-- 
With Best Regards,
Andy Shevchenko


