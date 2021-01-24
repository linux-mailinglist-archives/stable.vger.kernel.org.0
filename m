Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2A3301C56
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbhAXNu2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 24 Jan 2021 08:50:28 -0500
Received: from aposti.net ([89.234.176.197]:51952 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbhAXNu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 08:50:26 -0500
Date:   Sun, 24 Jan 2021 13:49:32 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [BACKPORT 5.4 PATCH] pinctrl: ingenic: Fix JZ4760 support
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        stable <stable@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, od@zcrc.me
Message-Id: <KEYFNQ.YUG2S0J7JWMP2@crapouillou.net>
In-Reply-To: <20210124134704.202931-1-paul@crapouillou.net>
References: <1611494593252195@kroah.com>
        <20210124134704.202931-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le dim. 24 janv. 2021 à 13:47, Paul Cercueil <paul@crapouillou.net> a 
écrit :
> - JZ4760 and JZ4760B have a similar register layout as the JZ4740, and
>   don't use the new register layout, which was introduced with the
>   JZ4770 SoC and not the JZ4760 or JZ4760B SoCs.
> 
> - The JZ4740 code path only expected two function modes to be
>   configurable for each pin, and wouldn't work with more than two. Fix
>   it for the JZ4760, which has four configurable function modes.

Forgot to add the original commit ID: 
9a85c09a3f507b925d75cb0c7c8f364467038052

Cheers,
-Paul

> Fixes: 0257595a5cf4 ("pinctrl: Ingenic: Add pinctrl driver for JZ4760 
> and JZ4760B.")
> Cc: <stable@vger.kernel.org> # 5.3
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/pinctrl/pinctrl-ingenic.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-ingenic.c 
> b/drivers/pinctrl/pinctrl-ingenic.c
> index 8bd0a078bfc4..61e7d938d4c5 100644
> --- a/drivers/pinctrl/pinctrl-ingenic.c
> +++ b/drivers/pinctrl/pinctrl-ingenic.c
> @@ -1378,7 +1378,7 @@ static inline bool 
> ingenic_gpio_get_value(struct ingenic_gpio_chip *jzgc,
>  static void ingenic_gpio_set_value(struct ingenic_gpio_chip *jzgc,
>  				   u8 offset, int value)
>  {
> -	if (jzgc->jzpc->version >= ID_JZ4760)
> +	if (jzgc->jzpc->version >= ID_JZ4770)
>  		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_PAT0, offset, !!value);
>  	else
>  		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, offset, !!value);
> @@ -1389,7 +1389,7 @@ static void irq_set_type(struct 
> ingenic_gpio_chip *jzgc,
>  {
>  	u8 reg1, reg2;
> 
> -	if (jzgc->jzpc->version >= ID_JZ4760) {
> +	if (jzgc->jzpc->version >= ID_JZ4770) {
>  		reg1 = JZ4760_GPIO_PAT1;
>  		reg2 = JZ4760_GPIO_PAT0;
>  	} else {
> @@ -1464,7 +1464,7 @@ static void ingenic_gpio_irq_enable(struct 
> irq_data *irqd)
>  	struct ingenic_gpio_chip *jzgc = gpiochip_get_data(gc);
>  	int irq = irqd->hwirq;
> 
> -	if (jzgc->jzpc->version >= ID_JZ4760)
> +	if (jzgc->jzpc->version >= ID_JZ4770)
>  		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, true);
>  	else
>  		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, true);
> @@ -1480,7 +1480,7 @@ static void ingenic_gpio_irq_disable(struct 
> irq_data *irqd)
> 
>  	ingenic_gpio_irq_mask(irqd);
> 
> -	if (jzgc->jzpc->version >= ID_JZ4760)
> +	if (jzgc->jzpc->version >= ID_JZ4770)
>  		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_INT, irq, false);
>  	else
>  		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_SELECT, irq, false);
> @@ -1505,7 +1505,7 @@ static void ingenic_gpio_irq_ack(struct 
> irq_data *irqd)
>  			irq_set_type(jzgc, irq, IRQ_TYPE_LEVEL_HIGH);
>  	}
> 
> -	if (jzgc->jzpc->version >= ID_JZ4760)
> +	if (jzgc->jzpc->version >= ID_JZ4770)
>  		ingenic_gpio_set_bit(jzgc, JZ4760_GPIO_FLAG, irq, false);
>  	else
>  		ingenic_gpio_set_bit(jzgc, JZ4740_GPIO_DATA, irq, true);
> @@ -1562,7 +1562,7 @@ static void ingenic_gpio_irq_handler(struct 
> irq_desc *desc)
> 
>  	chained_irq_enter(irq_chip, desc);
> 
> -	if (jzgc->jzpc->version >= ID_JZ4760)
> +	if (jzgc->jzpc->version >= ID_JZ4770)
>  		flag = ingenic_gpio_read_reg(jzgc, JZ4760_GPIO_FLAG);
>  	else
>  		flag = ingenic_gpio_read_reg(jzgc, JZ4740_GPIO_FLAG);
> @@ -1643,7 +1643,7 @@ static int ingenic_gpio_get_direction(struct 
> gpio_chip *gc, unsigned int offset)
>  	struct ingenic_pinctrl *jzpc = jzgc->jzpc;
>  	unsigned int pin = gc->base + offset;
> 
> -	if (jzpc->version >= ID_JZ4760)
> +	if (jzpc->version >= ID_JZ4770)
>  		return ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_INT) ||
>  			ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PAT1);
> 
> @@ -1676,7 +1676,7 @@ static int ingenic_pinmux_set_pin_fn(struct 
> ingenic_pinctrl *jzpc,
>  		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
>  		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT0, func & 0x1);
>  		ingenic_shadow_config_pin_load(jzpc, pin);
> -	} else if (jzpc->version >= ID_JZ4760) {
> +	} else if (jzpc->version >= ID_JZ4770) {
>  		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
>  		ingenic_config_pin(jzpc, pin, GPIO_MSK, false);
>  		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, func & 0x2);
> @@ -1684,7 +1684,7 @@ static int ingenic_pinmux_set_pin_fn(struct 
> ingenic_pinctrl *jzpc,
>  	} else {
>  		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_FUNC, true);
>  		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_TRIG, func & 0x2);
> -		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func > 0);
> +		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_SELECT, func & 0x1);
>  	}
> 
>  	return 0;
> @@ -1734,7 +1734,7 @@ static int 
> ingenic_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
>  		ingenic_shadow_config_pin(jzpc, pin, GPIO_MSK, true);
>  		ingenic_shadow_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
>  		ingenic_shadow_config_pin_load(jzpc, pin);
> -	} else if (jzpc->version >= ID_JZ4760) {
> +	} else if (jzpc->version >= ID_JZ4770) {
>  		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_INT, false);
>  		ingenic_config_pin(jzpc, pin, GPIO_MSK, true);
>  		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PAT1, input);
> @@ -1764,7 +1764,7 @@ static int ingenic_pinconf_get(struct 
> pinctrl_dev *pctldev,
>  	unsigned int offt = pin / PINS_PER_GPIO_CHIP;
>  	bool pull;
> 
> -	if (jzpc->version >= ID_JZ4760)
> +	if (jzpc->version >= ID_JZ4770)
>  		pull = !ingenic_get_pin_config(jzpc, pin, JZ4760_GPIO_PEN);
>  	else
>  		pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
> @@ -1796,7 +1796,7 @@ static int ingenic_pinconf_get(struct 
> pinctrl_dev *pctldev,
>  static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
>  		unsigned int pin, bool enabled)
>  {
> -	if (jzpc->version >= ID_JZ4760)
> +	if (jzpc->version >= ID_JZ4770)
>  		ingenic_config_pin(jzpc, pin, JZ4760_GPIO_PEN, !enabled);
>  	else
>  		ingenic_config_pin(jzpc, pin, JZ4740_GPIO_PULL_DIS, !enabled);
> --
> 2.29.2
> 


