Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78C5338C70
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhCLMMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:12:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:50128 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhCLMLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:11:41 -0500
IronPort-SDR: LrlIhptVLt42/2dZ7p60BcPshbqPJOh0FqY7OaOMvN/Hn2pitIOpL4WQC8yzL2LgfB7cqZNpfi
 WKeOWspLTsHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="168096639"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="168096639"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:11:41 -0800
IronPort-SDR: iOdw7o6F5U3cc0EscbL3/FaWR4sPnkZpE5axPrdyOO0dBMwKAlWPFT+PCFGJhOfezVlzhGnRKD
 LS3zZc3kbjcg==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="448607684"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:11:39 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lKgdk-00BqRn-Qg; Fri, 12 Mar 2021 14:11:36 +0200
Date:   Fri, 12 Mar 2021 14:11:36 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpiolib: acpi: Add
 ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.10-stable tree
Message-ID: <YEtaeHrJ7lS4p8HS@smile.fi.intel.com>
References: <161548637597119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161548637597119@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 07:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I will send an updated version.

> From 62d5247d239d4b48762192a251c647d7c997616a Mon Sep 17 00:00:00 2001
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Thu, 25 Feb 2021 18:33:18 +0200
> Subject: [PATCH] gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk
> 
> On some systems the ACPI tables has wrong pin number and instead of
> having a relative one it provides an absolute one in the global GPIO
> number space.
> 
> Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk to cope with such cases.
> 
> Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
> Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index 86efa2d9bf7f..0fa0127d50ec 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -677,6 +677,7 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
>  	if (!lookup->desc) {
>  		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
>  		bool gpioint = agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
> +		struct gpio_desc *desc;

>  		u16 pin_index;

It's simply old type of this variable in old tree.

>  
>  		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ONLY_GPIOIO && gpioint)
> @@ -689,8 +690,12 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
>  		if (pin_index >= agpio->pin_table_length)
>  			return 1;
>  
> -		lookup->desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
> +		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER)
> +			desc = gpio_to_desc(agpio->pin_table[pin_index]);
> +		else
> +			desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
>  					      agpio->pin_table[pin_index]);
> +		lookup->desc = desc;
>  		lookup->info.pin_config = agpio->pin_config;
>  		lookup->info.debounce = agpio->debounce_timeout;
>  		lookup->info.gpioint = gpioint;
> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
> index ef49307611d2..c73b25bc9213 100644
> --- a/include/linux/gpio/consumer.h
> +++ b/include/linux/gpio/consumer.h
> @@ -674,6 +674,8 @@ struct acpi_gpio_mapping {
>   * get GpioIo type explicitly, this quirk may be used.
>   */
>  #define ACPI_GPIO_QUIRK_ONLY_GPIOIO		BIT(1)
> +/* Use given pin as an absolute GPIO number in the system */
> +#define ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER		BIT(2)
>  
>  	unsigned int quirks;
>  };
> 

-- 
With Best Regards,
Andy Shevchenko


