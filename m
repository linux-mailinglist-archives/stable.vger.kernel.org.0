Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDE235AD2C
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 14:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhDJMIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 08:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhDJMIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 08:08:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C0661165;
        Sat, 10 Apr 2021 12:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618056470;
        bh=TOGFWa9Nn+4J9hISS6++HsfYZalNKWKelOxu1CZ9JKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XeX6B1Wg1409bUXGrRz+W/5iV3gdA2dVbOF7KHXy+lzXYaOmYWK0hgL4Mma+PnYKk
         zdaPSYSdFXcrLzsLvGuxh6SHUgp2XT0s2DkSzQss2/8A2Co5Z+SoqWtvcXg4cmim7j
         Nm6MekC8iMXLpIxiQc/2Nsoo4r/Q3PHhMrQsUAHs=
Date:   Sat, 10 Apr 2021 14:07:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Roman Guskov <rguskov@dh-electronics.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH stable] gpiolib: Read "gpio-line-names" from a firmware
 node
Message-ID: <YHGVE1hMDUiK0P2A@kroah.com>
References: <20210410090919.3157-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410090919.3157-1-brgl@bgdev.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 10, 2021 at 11:09:19AM +0200, Bartosz Golaszewski wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> On STM32MP1, the GPIO banks are subnodes of pin-controller@50002000,
> see arch/arm/boot/dts/stm32mp151.dtsi. The driver for
> pin-controller@50002000 is in drivers/pinctrl/stm32/pinctrl-stm32.c
> and iterates over all of its DT subnodes when registering each GPIO
> bank gpiochip. Each gpiochip has:
> 
>   - gpio_chip.parent = dev,
>     where dev is the device node of the pin controller
>   - gpio_chip.of_node = np,
>     which is the OF node of the GPIO bank
> 
> Therefore, dev_fwnode(chip->parent) != of_fwnode_handle(chip.of_node),
> i.e. pin-controller@50002000 != pin-controller@50002000/gpio@5000*000.
> 
> The original code behaved correctly, as it extracted the "gpio-line-names"
> from of_fwnode_handle(chip.of_node) = pin-controller@50002000/gpio@5000*000.
> 
> To achieve the same behaviour, read property from the firmware node.
> 
> Fixes: 7cba1a4d5e162 ("gpiolib: generalize devprop_gpiochip_set_names() for device properties")
> Cc: stable@vger.kernel.org
> Reported-by: Marek Vasut <marex@denx.de>
> Reported-by: Roman Guskov <rguskov@dh-electronics.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Tested-by: Marek Vasut <marex@denx.de>
> Reviewed-by: Marek Vasut <marex@denx.de>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
> Hi Greg,
> 
> This patch somehow got lost and never made its way into stable. Could you
> please apply it?

This has been added and removed more times than I can remember already.

Are you all _SURE_ this is safe for a stable kernel release?  Look in
the archives for complaints when we added this in the past.

thanks,

greg k-h
