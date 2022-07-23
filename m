Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C3157EF3A
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiGWNky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGWNkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:40:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34921D312
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F636611F6
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 13:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FE5C341C0;
        Sat, 23 Jul 2022 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658583649;
        bh=52XFf5AgKmfpt/l70k6hpIAVO+MGyKJ9grDcO6QVd/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D3luHO2UIFKeDkERGrypY8ftwNVGKVBzystgX8a8cUxsBnus/YGOPPDqHPMRLScYA
         BZjDbjcTIdxt+fTryuEnE6eco9gWdK0g7dxF+lWSuS0z9iU/QL7tKx3UH/zSr0iaWV
         S9PSqUg6lj7csxc0ePqQu9aU9RDumbHJCTbZaBFA=
Date:   Sat, 23 Jul 2022 15:40:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabien DESSENNE <fabien.dessenne@foss.st.com>
Cc:     linus.walleij@linaro.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: stm32: fix optional IRQ support
 to gpios" failed to apply to 5.18-stable tree
Message-ID: <Ytv6Xkbek4R7YiHQ@kroah.com>
References: <1657523339795@kroah.com>
 <d696b6bb-3a2a-f179-aaed-8155dbf4af1f@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d696b6bb-3a2a-f179-aaed-8155dbf4af1f@foss.st.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 05:44:29PM +0200, Fabien DESSENNE wrote:
> On 11/07/2022 09:08, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.18-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> >  From a1d4ef1adf8bbd302067534ead671a94759687ed Mon Sep 17 00:00:00 2001
> > From: Fabien Dessenne <fabien.dessenne@foss.st.com>
> > Date: Mon, 27 Jun 2022 16:23:50 +0200
> > Subject: [PATCH] pinctrl: stm32: fix optional IRQ support to gpios
> > 
> > To act as an interrupt controller, a gpio bank relies on the
> > "interrupt-parent" of the pin controller.
> > When this optional "interrupt-parent" misses, do not create any IRQ domain.
> > 
> > This fixes a "NULL pointer in stm32_gpio_domain_alloc()" kernel crash when
> > the interrupt-parent = <exti> property is not declared in the Device Tree.
> > 
> > Fixes: 0eb9f683336d ("pinctrl: Add IRQ support to STM32 gpios")
> > Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
> > Link: https://lore.kernel.org/r/20220627142350.742973-1-fabien.dessenne@foss.st.com
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > 
> > diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
> > index 57a33fb0f2d7..14bcca73238a 100644
> > --- a/drivers/pinctrl/stm32/pinctrl-stm32.c
> > +++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
> > @@ -1338,16 +1338,18 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
> >   	bank->secure_control = pctl->match_data->secure_control;
> >   	spin_lock_init(&bank->lock);
> > -	/* create irq hierarchical domain */
> > -	bank->fwnode = fwnode;
> > +	if (pctl->domain) {
> > +		/* create irq hierarchical domain */
> > +		bank->fwnode = fwnode;
> > -	bank->domain = irq_domain_create_hierarchy(pctl->domain, 0,
> > -					STM32_GPIO_IRQ_LINE, bank->fwnode,
> > -					&stm32_gpio_domain_ops, bank);
> > +		bank->domain = irq_domain_create_hierarchy(pctl->domain, 0, STM32_GPIO_IRQ_LINE,
> > +							   bank->fwnode, &stm32_gpio_domain_ops,
> > +							   bank);
> > -	if (!bank->domain) {
> > -		err = -ENODEV;
> > -		goto err_clk;
> > +		if (!bank->domain) {
> > +			err = -ENODEV;
> > +			goto err_clk;
> > +		}
> >   	}
> >   	err = gpiochip_add_data(&bank->gpio_chip, bank);
> > @@ -1510,6 +1512,8 @@ int stm32_pctl_probe(struct platform_device *pdev)
> >   	pctl->domain = stm32_pctrl_get_irq_domain(pdev);
> >   	if (IS_ERR(pctl->domain))
> >   		return PTR_ERR(pctl->domain);
> > +	if (!pctl->domain)
> > +		dev_warn(dev, "pinctrl without interrupt support\n");
> >   	/* hwspinlock is optional */
> >   	hwlock_id = of_hwspin_lock_get_id(pdev->dev.of_node, 0);
> > 
> 
> Hi,
> 
> Below is an updated patch which fixes the problem on all 5.x releases (5.18,
> 5.15, 5.10, 5.4).
> The initial patch can be dropped on any 4.x releases.

Thanks, now queued up.  Note, this was white-spaced damaged, I had to
fix it up by hand, you should fix your email client.

greg k-h
