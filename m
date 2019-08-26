Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107699CC4C
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 11:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbfHZJLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 05:11:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:58104 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729753AbfHZJLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 05:11:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 02:11:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="380471920"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga006.fm.intel.com with ESMTP; 26 Aug 2019 02:11:12 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i2B1q-0000Le-2U; Mon, 26 Aug 2019 12:11:10 +0300
Date:   Mon, 26 Aug 2019 12:11:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>
Subject: Re: [PATCH] gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot
 option and blacklist
Message-ID: <20190826091110.GY30120@smile.fi.intel.com>
References: <20190823215255.7631-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823215255.7631-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 11:52:55PM +0200, Hans de Goede wrote:
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
> gpiolib_acpi_run_edge_events_on_boot kernel commandline option which
> can be "on", "off", or "auto" (default).
> 
> In auto mode the default is on and a DMI based blacklist is used,
> the initial version of this blacklist contains the Minix Neo Z83-4
> fixing the HDMI being broken on this device.

> +static int gpiolib_acpi_run_edge_events_on_boot = -1;
> +
> +static int __init gpiolib_acpi_run_edge_events_on_boot_setup(char *arg)
> +{

> +	if (!strcmp(arg, "on"))
> +		gpiolib_acpi_run_edge_events_on_boot = 1;
> +	else if (!strcmp(arg, "off"))
> +		gpiolib_acpi_run_edge_events_on_boot = 0;

kstrtobool() ?

> +	else if (!strcmp(arg, "auto"))
> +		gpiolib_acpi_run_edge_events_on_boot = -1;
> +
> +	return 1;
> +}

> +
> +__setup("gpiolib_acpi_run_edge_events_on_boot=",
> +        gpiolib_acpi_run_edge_events_on_boot_setup);

Can't we use module_param() ?
The resulting option would be 'gpiolib_acpi.foo=...'

> +{

> +	if (gpiolib_acpi_run_edge_events_on_boot == -1) {
> +		if (dmi_check_system(run_edge_events_on_boot_blacklist))
> +			gpiolib_acpi_run_edge_events_on_boot = 0;
> +		else
> +			gpiolib_acpi_run_edge_events_on_boot = 1;
> +	}

Can we run this at an initcall once and use variable instead of calling a
method below?

> +	return gpiolib_acpi_run_edge_events_on_boot;
> +}
> +
>  static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
>  				      struct acpi_gpio_event *event)
>  {
> @@ -170,10 +211,13 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
>  	event->irq_requested = true;
>  
>  	/* Make sure we trigger the initial state of edge-triggered IRQs */
> -	value = gpiod_get_raw_value_cansleep(event->desc);
> -	if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
> -	    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
> -		event->handler(event->irq, event);
> +	if (acpi_gpiochip_run_edge_events_on_boot() &&
> +	    (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
> +		value = gpiod_get_raw_value_cansleep(event->desc);
> +		if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
> +		    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
> +			event->handler(event->irq, event);
> +	}

-- 
With Best Regards,
Andy Shevchenko


