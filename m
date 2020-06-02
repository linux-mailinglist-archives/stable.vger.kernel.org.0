Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F461EBEF5
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 17:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgFBPXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 11:23:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:37056 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBPXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 11:23:17 -0400
IronPort-SDR: P+RBTUB7ErLJ9hhPE6G4tjYG3yKkidRXmjLVzHGbtiBU86H27+WHEj8KKaLGw9LXnhAmBYxm95
 O2C9FcnRhHzg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 08:23:16 -0700
IronPort-SDR: oDnmhZP3Rwydxr084zg6I/PeVIiIFHszafqGPUVcgvg56cjPXY9cmAuiBa2IgX/ndNEf4KzIl5
 N+8vsILgOc4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,464,1583222400"; 
   d="scan'208";a="268733672"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003.jf.intel.com with ESMTP; 02 Jun 2020 08:23:14 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jg8l3-00ARss-LB; Tue, 02 Jun 2020 18:23:17 +0300
Date:   Tue, 2 Jun 2020 18:23:17 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while
 on gpiod_get(..., GPIOD_OUT_HIGH)
Message-ID: <20200602152317.GI2428291@smile.fi.intel.com>
References: <20200602122130.45630-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602122130.45630-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 02:21:30PM +0200, Hans de Goede wrote:
> The pins on the Bay Trail SoC have separate input-buffer and output-buffer
> enable bits and a read of the level bit of the value register will always
> return the value from the input-buffer.
> 
> The BIOS of a device may configure a pin in output-only mode, only enabling
> the output buffer, and write 1 to the level bit to drive the pin high.
> This 1 written to the level bit will be stored inside the data-latch of the
> output buffer.
> 
> But a subsequent read of the value register will return 0 for the level bit
> because the input-buffer is disabled. This causes a read-modify-write as
> done by byt_gpio_set_direction() to write 0 to the level bit, driving the
> pin low!
> 
> Before this commit byt_gpio_direction_output() relied on
> pinctrl_gpio_direction_output() to set the direction, followed by a call
> to byt_gpio_set() to apply the selected value. This causes the pin to
> go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
> calls.
> 
> Change byt_gpio_direction_output() to directly make the register
> modifications itself instead. Replacing the 2 subsequent writes to the
> value register with a single write.
> 
> Note that the pinctrl code does not keep track internally of the direction,
> so not going through pinctrl_gpio_direction_output() is not an issue.
> 
> This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
> already on at boot (no external monitor connected), then the i915 driver
> does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
> temporarily going low of that GPIO was causing the panel to reset itself
> after which it would not show an image until it was turned off and back on
> again (until a full modeset was done on it). This commit fixes this.

No Fixes tag?

> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

...

> +static void byt_gpio_direct_irq_check(struct intel_pinctrl *vg,
> +				      unsigned int offset)
> +{
> +	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
> +
> +	/*
> +	 * Before making any direction modifications, do a check if gpio is set

> +	 * for direct IRQ.  On baytrail, setting GPIO to output does not make

Since we change this, perhaps

'IRQ.  On baytrail' -> 'IRQ. On Baytrail' (one space and capital 'B').

> +	 * sense, so let's at least inform the caller before they shoot
> +	 * themselves in the foot.
> +	 */
> +	if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
> +		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
> +}

...

>  static int byt_gpio_direction_output(struct gpio_chip *chip,
>  				     unsigned int offset, int value)
>  {
> -	int ret = pinctrl_gpio_direction_output(chip->base + offset);
> +	struct intel_pinctrl *vg = gpiochip_get_data(chip);
> +	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
> +	unsigned long flags;
> +	u32 reg;
>  
> -	if (ret)
> -		return ret;
> +	raw_spin_lock_irqsave(&byt_lock, flags);
>  
> -	byt_gpio_set(chip, offset, value);
> +	byt_gpio_direct_irq_check(vg, offset);
>  
> +	reg = readl(val_reg);
> +	reg &= ~BYT_DIR_MASK;
> +	if (value)
> +		reg |= BYT_LEVEL;
> +	else
> +		reg &= ~BYT_LEVEL;
> +
> +	writel(reg, val_reg);
> +
> +	raw_spin_unlock_irqrestore(&byt_lock, flags);
>  	return 0;
>  }

Wouldn't be simple below fix the issue?

@@ -1171,14 +1171,10 @@ static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 static int byt_gpio_direction_output(struct gpio_chip *chip,
                                     unsigned int offset, int value)
 {
-       int ret = pinctrl_gpio_direction_output(chip->base + offset);
-
-       if (ret)
-               return ret;
-
+       /* Set value first to avoid a glitch */
        byt_gpio_set(chip, offset, value);
 
-       return 0;
+       return pinctrl_gpio_direction_output(chip->base + offset);
 }
 

P.S. It's mangled, sorry.

-- 
With Best Regards,
Andy Shevchenko


