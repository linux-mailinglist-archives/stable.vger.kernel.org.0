Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D12154035
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 09:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBFIb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 03:31:56 -0500
Received: from mga17.intel.com ([192.55.52.151]:52629 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbgBFIb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 03:31:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 00:31:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,409,1574150400"; 
   d="scan'208";a="344634480"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 06 Feb 2020 00:31:49 -0800
Received: by lahna (sSMTP sendmail emulation); Thu, 06 Feb 2020 10:31:49 +0200
Date:   Thu, 6 Feb 2020 10:31:49 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Michal Stanek <mst@semihalf.com>
Cc:     linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stanekm@google.com,
        stable@vger.kernel.org, mw@semihalf.com, levinale@chromium.org,
        andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, rafael.j.wysocki@intel.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] pinctrl: cherryview: Add quirk with custom translation
 of ACPI GPIO numbers
Message-ID: <20200206083149.GK2667@lahna.fi.intel.com>
References: <20200205194804.1647-1-mst@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205194804.1647-1-mst@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 08:48:04PM +0100, Michal Stanek wrote:
> Dropping custom Linux GPIO translation caused some Intel_Strago based Chromebooks
> with old firmware to detect GPIOs incorrectly. Add quirk which restores some code removed by
> commit 03c4749dd6c7ff94 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation").

Hi,

Can you elaborate this? I was under the impression that all the
different Strago systems have been already worked around by patches from
Dmitry (Cc'd).

What GPIO(s) we are talking about and how does it show up to the user?

> Fixes: 03c4749dd6c7ff94 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation")
> Cc: <stable@vger.kernel.org>
> Reported-by: Alex Levin <levinale@chromium.org>
> Signed-off-by: Michal Stanek <mst@semihalf.com>
> ---
>  drivers/gpio/gpiolib-acpi.c                | 102 ++++++++++++++++++++-
>  drivers/pinctrl/intel/pinctrl-cherryview.c |  63 ++++++++++---
>  2 files changed, 150 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index 31fee5e918b7..b5358facf3fb 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -23,6 +23,7 @@
>  
>  #define QUIRK_NO_EDGE_EVENTS_ON_BOOT		0x01l
>  #define QUIRK_NO_WAKEUP				0x02l
> +#define QUIRK_NEED_ACPI_GPIO_TRANSLATION	0x04l
>  
>  static int run_edge_events_on_boot = -1;
>  module_param(run_edge_events_on_boot, int, 0444);
> @@ -34,6 +35,11 @@ module_param(honor_wakeup, int, 0444);
>  MODULE_PARM_DESC(honor_wakeup,
>  		 "Honor the ACPI wake-capable flag: 0=no, 1=yes, -1=auto");
>  
> +static int need_acpi_gpio_translation = -1;
> +module_param(need_acpi_gpio_translation, int, 0444);
> +MODULE_PARM_DESC(need_acpi_gpio_translation,
> +		 "Do custom ACPI GPIO number translation: 0=no, 1=yes, -1=auto");
> +
>  /**
>   * struct acpi_gpio_event - ACPI GPIO event handler data
>   *
> @@ -98,6 +104,62 @@ static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
>  	return ACPI_HANDLE(gc->parent) == data;
>  }
>  
> +#ifdef CONFIG_PINCTRL
> +/**
> + * acpi_gpiochip_pin_to_gpio_offset() - translates ACPI GPIO to Linux GPIO
> + * @gdev: GPIO device
> + * @pin: ACPI GPIO pin number from GpioIo/GpioInt resource
> + *
> + * Function takes ACPI GpioIo/GpioInt pin number as a parameter and
> + * translates it to a corresponding offset suitable to be passed to a
> + * GPIO controller driver.
> + *
> + * Typically the returned offset is same as @pin, but if the GPIO
> + * controller uses pin controller and the mapping is not contiguous the
> + * offset might be different.
> + */
> +static int acpi_gpiochip_pin_to_gpio_offset(struct gpio_device *gdev, int pin)
> +{
> +	struct gpio_pin_range *pin_range;
> +
> +	/* Only do translation on selected platforms */
> +	if (!need_acpi_gpio_translation)
> +		return pin;
> +
> +	/* If there are no ranges in this chip, use 1:1 mapping */
> +	if (list_empty(&gdev->pin_ranges))
> +		return pin;
> +
> +	list_for_each_entry(pin_range, &gdev->pin_ranges, node) {
> +		const struct pinctrl_gpio_range *range = &pin_range->range;
> +		int i;
> +
> +		if (range->pins) {
> +			for (i = 0; i < range->npins; i++) {
> +				if (range->pins[i] == pin)
> +					return range->base + i - gdev->base;
> +			}
> +		} else {
> +			if (pin >= range->pin_base &&
> +			    pin < range->pin_base + range->npins) {
> +				unsigned int gpio_base;
> +
> +				gpio_base = range->base - gdev->base;
> +				return gpio_base + pin - range->pin_base;
> +			}
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +#else
> +static inline int acpi_gpiochip_pin_to_gpio_offset(struct gpio_device *gdev,
> +						   int pin)
> +{
> +	return pin;
> +}
> +#endif
> +
>  /**
>   * acpi_get_gpiod() - Translate ACPI GPIO pin to GPIO descriptor usable with GPIO API
>   * @path:	ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
> @@ -113,6 +175,7 @@ static struct gpio_desc *acpi_get_gpiod(char *path, int pin)
>  	struct gpio_chip *chip;
>  	acpi_handle handle;
>  	acpi_status status;
> +	int offset;
>  
>  	status = acpi_get_handle(NULL, path, &handle);
>  	if (ACPI_FAILURE(status))
> @@ -122,7 +185,11 @@ static struct gpio_desc *acpi_get_gpiod(char *path, int pin)
>  	if (!chip)
>  		return ERR_PTR(-EPROBE_DEFER);
>  
> -	return gpiochip_get_desc(chip, pin);
> +	offset = acpi_gpiochip_pin_to_gpio_offset(chip->gpiodev, pin);
> +	if (offset < 0)
> +		return ERR_PTR(offset);
> +
> +	return gpiochip_get_desc(chip, offset);
>  }
>  
>  static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
> @@ -236,6 +303,10 @@ static acpi_status acpi_gpiochip_alloc_event(struct acpi_resource *ares,
>  	if (!handler)
>  		return AE_OK;
>  
> +	pin = acpi_gpiochip_pin_to_gpio_offset(chip->gpiodev, pin);
> +	if (pin < 0)
> +		return AE_BAD_PARAMETER;
> +
>  	desc = gpiochip_request_own_desc(chip, pin, "ACPI:Event",
>  					 GPIO_ACTIVE_HIGH, GPIOD_IN);
>  	if (IS_ERR(desc)) {
> @@ -958,6 +1029,12 @@ acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
>  		struct gpio_desc *desc;
>  		bool found;
>  
> +		pin = acpi_gpiochip_pin_to_gpio_offset(chip->gpiodev, pin);
> +		if (pin < 0) {
> +			status = AE_BAD_PARAMETER;
> +			goto out;
> +		}
> +
>  		mutex_lock(&achip->conn_lock);
>  
>  		found = false;
> @@ -1086,7 +1163,11 @@ acpi_gpiochip_parse_own_gpio(struct acpi_gpio_chip *achip,
>  	if (ret < 0)
>  		return ERR_PTR(ret);
>  
> -	desc = gpiochip_get_desc(chip, gpios[0]);
> +	ret = acpi_gpiochip_pin_to_gpio_offset(chip->gpiodev, gpios[0]);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	desc = gpiochip_get_desc(chip, ret);
>  	if (IS_ERR(desc))
>  		return desc;
>  
> @@ -1360,6 +1441,17 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] = {
>  		},
>  		.driver_data = (void *)QUIRK_NO_WAKEUP,
>  	},
> +	{
> +		/*
> +		 * Some Braswell based Google Chromebooks need custom ACPI GPIO
> +		 * number translation due to hardcoded GPIO numbers in firmware.
> +		 */
> +		.matches = {
> +		       DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
> +		       DMI_MATCH(DMI_PRODUCT_FAMILY, "Intel_Strago"),
> +		},

AFAIK this now applies pretty much all Strago systems so at least this
one should explicitly match only the affected firmware versions.

> +		.driver_data = (void *)QUIRK_NEED_ACPI_GPIO_TRANSLATION,
> +	},
>  	{} /* Terminating entry */
>  };
>  
> @@ -1385,6 +1477,12 @@ static int acpi_gpio_setup_params(void)
>  		else
>  			honor_wakeup = 1;
>  	}
> +	if (need_acpi_gpio_translation < 0) {
> +		if (quirks & QUIRK_NEED_ACPI_GPIO_TRANSLATION)
> +			need_acpi_gpio_translation = 1;
> +		else
> +			need_acpi_gpio_translation = 0;
> +	}
>  
>  	return 0;
>  }
> diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
> index 4c74fdde576d..dd190ac6b11c 100644
> --- a/drivers/pinctrl/intel/pinctrl-cherryview.c
> +++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
> @@ -119,6 +119,7 @@ struct chv_gpio_pinrange {
>   * @nfunctions: Number of functions
>   * @gpio_ranges: An array of GPIO ranges in this community
>   * @ngpio_ranges: Number of GPIO ranges
> + * @ngpios: Total number of GPIOs in this community
>   * @nirqs: Total number of IRQs this community can generate
>   * @acpi_space_id: An address space ID for ACPI OpRegion handler
>   */
> @@ -132,6 +133,7 @@ struct chv_community {
>  	size_t nfunctions;
>  	const struct chv_gpio_pinrange *gpio_ranges;
>  	size_t ngpio_ranges;
> +	size_t ngpios;
>  	size_t nirqs;
>  	acpi_adr_space_type acpi_space_id;
>  };
> @@ -380,6 +382,7 @@ static const struct chv_community southwest_community = {
>  	.nfunctions = ARRAY_SIZE(southwest_functions),
>  	.gpio_ranges = southwest_gpio_ranges,
>  	.ngpio_ranges = ARRAY_SIZE(southwest_gpio_ranges),
> +	.ngpios = ARRAY_SIZE(southwest_pins),
>  	/*
>  	 * Southwest community can generate GPIO interrupts only for the
>  	 * first 8 interrupts. The upper half (8-15) can only be used to
> @@ -469,6 +472,7 @@ static const struct chv_community north_community = {
>  	.npins = ARRAY_SIZE(north_pins),
>  	.gpio_ranges = north_gpio_ranges,
>  	.ngpio_ranges = ARRAY_SIZE(north_gpio_ranges),
> +	.ngpios = ARRAY_SIZE(north_pins),
>  	/*
>  	 * North community can generate GPIO interrupts only for the first
>  	 * 8 interrupts. The upper half (8-15) can only be used to trigger
> @@ -517,6 +521,7 @@ static const struct chv_community east_community = {
>  	.npins = ARRAY_SIZE(east_pins),
>  	.gpio_ranges = east_gpio_ranges,
>  	.ngpio_ranges = ARRAY_SIZE(east_gpio_ranges),
> +	.ngpios = ARRAY_SIZE(east_pins),
>  	.nirqs = 16,
>  	.acpi_space_id = 0x93,
>  };
> @@ -643,6 +648,7 @@ static const struct chv_community southeast_community = {
>  	.nfunctions = ARRAY_SIZE(southeast_functions),
>  	.gpio_ranges = southeast_gpio_ranges,
>  	.ngpio_ranges = ARRAY_SIZE(southeast_gpio_ranges),
> +	.ngpios = ARRAY_SIZE(southeast_pins),
>  	.nirqs = 16,
>  	.acpi_space_id = 0x94,
>  };
> @@ -1236,14 +1242,39 @@ static struct pinctrl_desc chv_pinctrl_desc = {
>  	.owner = THIS_MODULE,
>  };
>  
> +static const struct dmi_system_id need_acpi_gpio_translation[] = {
> +	{
> +		/*
> +		 * Some Braswell based Google Chromebooks need custom ACPI GPIO
> +		 * number translation due to hardcoded GPIO numbers in firmware.
> +		 */
> +		.ident = "Intel_Strago based Chromebooks (All models)",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
> +			DMI_MATCH(DMI_PRODUCT_FAMILY, "Intel_Strago"),

Same comment here. Are you saying all Stragos are broken in the current
mainline?

> +		},
> +	},
> +};
> +
> +static unsigned int chv_gpio_offset_to_pin(struct chv_pinctrl *pctrl,
> +				      unsigned int offset)
> +{
> +	/* Mapping is not 1:1 on some platforms */
> +	if (dmi_check_system(need_acpi_gpio_translation))
> +		return pctrl->community->pins[offset].number;
> +	else
> +		return offset;
> +}
> +
>  static int chv_gpio_get(struct gpio_chip *chip, unsigned int offset)
>  {
>  	struct chv_pinctrl *pctrl = gpiochip_get_data(chip);
> +	unsigned int pin = chv_gpio_offset_to_pin(pctrl, offset);
>  	unsigned long flags;
>  	u32 ctrl0, cfg;
>  
>  	raw_spin_lock_irqsave(&chv_lock, flags);
> -	ctrl0 = readl(chv_padreg(pctrl, offset, CHV_PADCTRL0));
> +	ctrl0 = readl(chv_padreg(pctrl, pin, CHV_PADCTRL0));
>  	raw_spin_unlock_irqrestore(&chv_lock, flags);
>  
>  	cfg = ctrl0 & CHV_PADCTRL0_GPIOCFG_MASK;
> @@ -1257,13 +1288,14 @@ static int chv_gpio_get(struct gpio_chip *chip, unsigned int offset)
>  static void chv_gpio_set(struct gpio_chip *chip, unsigned int offset, int value)
>  {
>  	struct chv_pinctrl *pctrl = gpiochip_get_data(chip);
> +	unsigned int pin = chv_gpio_offset_to_pin(pctrl, offset);
>  	unsigned long flags;
>  	void __iomem *reg;
>  	u32 ctrl0;
>  
>  	raw_spin_lock_irqsave(&chv_lock, flags);
>  
> -	reg = chv_padreg(pctrl, offset, CHV_PADCTRL0);
> +	reg = chv_padreg(pctrl, pin, CHV_PADCTRL0);
>  	ctrl0 = readl(reg);
>  
>  	if (value)
> @@ -1279,11 +1311,12 @@ static void chv_gpio_set(struct gpio_chip *chip, unsigned int offset, int value)
>  static int chv_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
>  {
>  	struct chv_pinctrl *pctrl = gpiochip_get_data(chip);
> +	unsigned int pin = chv_gpio_offset_to_pin(pctrl, offset);
>  	u32 ctrl0, direction;
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&chv_lock, flags);
> -	ctrl0 = readl(chv_padreg(pctrl, offset, CHV_PADCTRL0));
> +	ctrl0 = readl(chv_padreg(pctrl, pin, CHV_PADCTRL0));
>  	raw_spin_unlock_irqrestore(&chv_lock, flags);
>  
>  	direction = ctrl0 & CHV_PADCTRL0_GPIOCFG_MASK;
> @@ -1322,7 +1355,7 @@ static void chv_gpio_irq_ack(struct irq_data *d)
>  {
>  	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
>  	struct chv_pinctrl *pctrl = gpiochip_get_data(gc);
> -	int pin = irqd_to_hwirq(d);
> +	unsigned int pin = chv_gpio_offset_to_pin(pctrl, irqd_to_hwirq(d));
>  	u32 intr_line;
>  
>  	raw_spin_lock(&chv_lock);
> @@ -1339,7 +1372,7 @@ static void chv_gpio_irq_mask_unmask(struct irq_data *d, bool mask)
>  {
>  	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
>  	struct chv_pinctrl *pctrl = gpiochip_get_data(gc);
> -	int pin = irqd_to_hwirq(d);
> +	unsigned int pin = chv_gpio_offset_to_pin(pctrl, irqd_to_hwirq(d));
>  	u32 value, intr_line;
>  	unsigned long flags;
>  
> @@ -1384,7 +1417,8 @@ static unsigned chv_gpio_irq_startup(struct irq_data *d)
>  	if (irqd_get_trigger_type(d) == IRQ_TYPE_NONE) {
>  		struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
>  		struct chv_pinctrl *pctrl = gpiochip_get_data(gc);
> -		unsigned int pin = irqd_to_hwirq(d);
> +		unsigned int offset = irqd_to_hwirq(d);
> +		unsigned int pin = chv_gpio_offset_to_pin(pctrl, offset);
>  		irq_flow_handler_t handler;
>  		unsigned long flags;
>  		u32 intsel, value;
> @@ -1402,7 +1436,7 @@ static unsigned chv_gpio_irq_startup(struct irq_data *d)
>  
>  		if (!pctrl->intr_lines[intsel]) {
>  			irq_set_handler_locked(d, handler);
> -			pctrl->intr_lines[intsel] = pin;
> +			pctrl->intr_lines[intsel] = offset;
>  		}
>  		raw_spin_unlock_irqrestore(&chv_lock, flags);
>  	}
> @@ -1415,7 +1449,8 @@ static int chv_gpio_irq_type(struct irq_data *d, unsigned int type)
>  {
>  	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
>  	struct chv_pinctrl *pctrl = gpiochip_get_data(gc);
> -	unsigned int pin = irqd_to_hwirq(d);
> +	unsigned int offset = irqd_to_hwirq(d);
> +	unsigned int pin = chv_gpio_offset_to_pin(pctrl, offset);
>  	unsigned long flags;
>  	u32 value;
>  
> @@ -1461,7 +1496,7 @@ static int chv_gpio_irq_type(struct irq_data *d, unsigned int type)
>  	value &= CHV_PADCTRL0_INTSEL_MASK;
>  	value >>= CHV_PADCTRL0_INTSEL_SHIFT;
>  
> -	pctrl->intr_lines[value] = pin;
> +	pctrl->intr_lines[value] = offset;
>  
>  	if (type & IRQ_TYPE_EDGE_BOTH)
>  		irq_set_handler_locked(d, handle_edge_irq);
> @@ -1591,17 +1626,19 @@ static int chv_gpio_add_pin_ranges(struct gpio_chip *chip)
>  	struct chv_pinctrl *pctrl = gpiochip_get_data(chip);
>  	const struct chv_community *community = pctrl->community;
>  	const struct chv_gpio_pinrange *range;
> -	int ret, i;
> +	int ret, i, offset;
>  
> -	for (i = 0; i < community->ngpio_ranges; i++) {
> +	for (i = 0, offset = 0; i < community->ngpio_ranges; i++) {
>  		range = &community->gpio_ranges[i];
>  		ret = gpiochip_add_pin_range(chip, dev_name(pctrl->dev),
> -					     range->base, range->base,
> +					     offset, range->base,
>  					     range->npins);
>  		if (ret) {
>  			dev_err(pctrl->dev, "failed to add GPIO pin range\n");
>  			return ret;
>  		}
> +
> +		offset += range->npins;
>  	}
>  
>  	return 0;
> @@ -1617,7 +1654,7 @@ static int chv_gpio_probe(struct chv_pinctrl *pctrl, int irq)
>  
>  	*chip = chv_gpio_chip;
>  
> -	chip->ngpio = community->pins[community->npins - 1].number + 1;
> +	chip->ngpio = community->ngpios;
>  	chip->label = dev_name(pctrl->dev);
>  	chip->add_pin_ranges = chv_gpio_add_pin_ranges;
>  	chip->parent = pctrl->dev;
> -- 
> 2.17.1
