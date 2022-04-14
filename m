Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A11D501B9A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 21:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiDNTOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 15:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiDNTOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 15:14:12 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD8BE996B;
        Thu, 14 Apr 2022 12:11:46 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: shreeya)
        with ESMTPSA id A99041F47C76
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1649963504;
        bh=QzazdTkJUyPxoWMBQtS0j3+6PWTkOSNi4bctVgjyFy4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SnxNYl7LNmTWZVkOCTGlL6LmjkwXInzk0zIBF9kXMlaKKZ8bMWzDBl9BjJe0BVjKe
         4Yud9mz9d8h9Ed6luJlZTVHyY2QuBGZ+EQKjZHaJzQY34tCqeRJ68MZuVebpKzH188
         t9v7fC7/VFJQGn3jmAtrU6bFFFwQKeRZU+CxwDKL9VQY5u3iP2b/qDteB4k+wo6Q6U
         zI9ON8nPLrsMHmiXEcSF07pTqx9zWj7E0DAsuHm4Bo1GWzrUgFxGeun3PFfwJm/Nxm
         +iqsnGNFnXMRInUdaAGKhp0pHMP59zrA9uVbBt1Sfy0IvYDZEYNjMj79TjUC4tLcWT
         U0lPYUwffoP5w==
Message-ID: <207d6171-173a-3d77-4b13-ea6f7476478d@collabora.com>
Date:   Fri, 15 Apr 2022 00:41:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Basavaraj.Natikar@amd.com, Richard.Gong@amd.com,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        gabriel Krisman Bertazi <krisman@collabora.com>,
        Collabora Kernel ML <kernel@collabora.com>
References: <20220414025705.598-1-mario.limonciello@amd.com>
From:   Shreeya Patel <shreeya.patel@collabora.com>
In-Reply-To: <20220414025705.598-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/04/22 08:27, Mario Limonciello wrote:
> commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before
> initialization") attempted to fix a race condition that lead to a NULL
> pointer, but in the process caused a regression for _AEI/_EVT declared
> GPIOs. This manifests in messages showing deferred probing while trying
> to allocate IRQs like so:
>
> [    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0000 to IRQ, err -517
> [    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x002C to IRQ, err -517
> [    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003D to IRQ, err -517
> [    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003E to IRQ, err -517
> [    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003A to IRQ, err -517
> [    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x003B to IRQ, err -517
> [    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0002 to IRQ, err -517
> [    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0011 to IRQ, err -517
> [    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0012 to IRQ, err -517
> [    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin 0x0007 to IRQ, err -517
>
> The code for walking _AEI doesn't handle deferred probing and so this leads
> to non-functional GPIO interrupts.
>
> Fix this issue by moving the call to `acpi_gpiochip_request_interrupts` to
> occur after gc->irc.initialized is set.


Thanks Mario for sending a fix for this issue, I didn't realize 
gpiod_to_irq() was also
being called through acpi_gpiochip_request_interrupts().
Change looks good to me.
Reviewed-by: Shreeya Patel <shreeya.patel@collabora.com>

> Cc: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>   drivers/gpio/gpiolib.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 085348e08986..b7694171655c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>   
>   	gpiochip_set_irq_hooks(gc);
>   
> -	acpi_gpiochip_request_interrupts(gc);
> -
>   	/*
>   	 * Using barrier() here to prevent compiler from reordering
>   	 * gc->irq.initialized before initialization of above
> @@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>   
>   	gc->irq.initialized = true;
>   
> +	acpi_gpiochip_request_interrupts(gc);
> +
>   	return 0;
>   }
>   
