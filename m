Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E08338C76
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhCLMNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:13:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:40630 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhCLMNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:13:16 -0500
IronPort-SDR: VWytZ2uPNNA+frpgbWDdanrfEQQaKJDfic7vFV8tHMHONMuBNWk5CNb8PJsRukuMVGoZXF6346
 qFH4j37vlYpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="252839172"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="252839172"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:13:16 -0800
IronPort-SDR: fMXmGWDBo03364/pqBx/I45clYaW/5ClTjqJRgJRF+vhKW49sRZldgfT/B59+Mz2dqgRR0qiAZ
 C5MWBsChknbg==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="370883459"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:13:14 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lKgfI-00BqTO-98; Fri, 12 Mar 2021 14:13:12 +0200
Date:   Fri, 12 Mar 2021 14:13:12 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: pca953x: Set IRQ type when handle
 Intel Galileo Gen 2" failed to apply to 5.10-stable tree
Message-ID: <YEta2IUohT5m28Oi@smile.fi.intel.com>
References: <161548729112453@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <161548729112453@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 07:28:11PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This is strange. I have just cherry-picked it clean on top of v5.10.23.

> ------------------ original commit in Linus's tree ------------------
> 
> From eb441337c7147514ab45036cadf09c3a71e4ce31 Mon Sep 17 00:00:00 2001
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Thu, 25 Feb 2021 18:33:20 +0200
> Subject: [PATCH] gpio: pca953x: Set IRQ type when handle Intel Galileo Gen 2
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> The commit 0ea683931adb ("gpio: dwapb: Convert driver to using the
> GPIO-lib-based IRQ-chip") indeliberately made a regression on how
> IRQ line from GPIO I²C expander is handled. I.e. it reveals that
> the quirk for Intel Galileo Gen 2 misses the part of setting IRQ type
> which previously was predefined by gpio-dwapb driver. Now, we have to
> reorganize the approach to call necessary parts, which can be done via
> ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk.
> 
> Without this fix and with above mentioned change the kernel hangs
> on the first IRQ event with:
> 
>     gpio gpiochip3: Persistence not supported for GPIO 1
>     irq 32, desc: 62f8fb50, depth: 0, count: 0, unhandled: 0
>     ->handle_irq():  41c7b0ab, handle_bad_irq+0x0/0x40
>     ->irq_data.chip(): e03f1e72, 0xc2539218
>     ->action(): 0ecc7e6f
>     ->action->handler(): 8a3db21e, irq_default_primary_handler+0x0/0x10
>        IRQ_NOPROBE set
>     unexpected IRQ trap at vector 20
> 
> Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
> Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index 5ea09fd01544..c91d05651596 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -113,8 +113,29 @@ MODULE_DEVICE_TABLE(i2c, pca953x_id);
>  #ifdef CONFIG_GPIO_PCA953X_IRQ
>  
>  #include <linux/dmi.h>
> -#include <linux/gpio.h>
> -#include <linux/list.h>
> +
> +static const struct acpi_gpio_params pca953x_irq_gpios = { 0, 0, true };
> +
> +static const struct acpi_gpio_mapping pca953x_acpi_irq_gpios[] = {
> +	{ "irq-gpios", &pca953x_irq_gpios, 1, ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER },
> +	{ }
> +};
> +
> +static int pca953x_acpi_get_irq(struct device *dev)
> +{
> +	int ret;
> +
> +	ret = devm_acpi_dev_add_driver_gpios(dev, pca953x_acpi_irq_gpios);
> +	if (ret)
> +		dev_warn(dev, "can't add GPIO ACPI mapping\n");
> +
> +	ret = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "irq-gpios", 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_info(dev, "ACPI interrupt quirk (IRQ %d)\n", ret);
> +	return ret;
> +}
>  
>  static const struct dmi_system_id pca953x_dmi_acpi_irq_info[] = {
>  	{
> @@ -133,59 +154,6 @@ static const struct dmi_system_id pca953x_dmi_acpi_irq_info[] = {
>  	},
>  	{}
>  };
> -
> -#ifdef CONFIG_ACPI
> -static int pca953x_acpi_get_pin(struct acpi_resource *ares, void *data)
> -{
> -	struct acpi_resource_gpio *agpio;
> -	int *pin = data;
> -
> -	if (acpi_gpio_get_irq_resource(ares, &agpio))
> -		*pin = agpio->pin_table[0];
> -	return 1;
> -}
> -
> -static int pca953x_acpi_find_pin(struct device *dev)
> -{
> -	struct acpi_device *adev = ACPI_COMPANION(dev);
> -	int pin = -ENOENT, ret;
> -	LIST_HEAD(r);
> -
> -	ret = acpi_dev_get_resources(adev, &r, pca953x_acpi_get_pin, &pin);
> -	acpi_dev_free_resource_list(&r);
> -	if (ret < 0)
> -		return ret;
> -
> -	return pin;
> -}
> -#else
> -static inline int pca953x_acpi_find_pin(struct device *dev) { return -ENXIO; }
> -#endif
> -
> -static int pca953x_acpi_get_irq(struct device *dev)
> -{
> -	int pin, ret;
> -
> -	pin = pca953x_acpi_find_pin(dev);
> -	if (pin < 0)
> -		return pin;
> -
> -	dev_info(dev, "Applying ACPI interrupt quirk (GPIO %d)\n", pin);
> -
> -	if (!gpio_is_valid(pin))
> -		return -EINVAL;
> -
> -	ret = gpio_request(pin, "pca953x interrupt");
> -	if (ret)
> -		return ret;
> -
> -	ret = gpio_to_irq(pin);
> -
> -	/* When pin is used as an IRQ, no need to keep it requested */
> -	gpio_free(pin);
> -
> -	return ret;
> -}
>  #endif
>  
>  static const struct acpi_device_id pca953x_acpi_ids[] = {
> 

-- 
With Best Regards,
Andy Shevchenko


