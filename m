Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D9505A61
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345022AbiDRO6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345174AbiDRO6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:58:23 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480AC33A1F;
        Mon, 18 Apr 2022 06:46:57 -0700 (PDT)
Received: from [2a02:8108:963f:de38:6624:6d8d:f790:d5c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ngRiQ-00085g-0c; Mon, 18 Apr 2022 15:46:54 +0200
Message-ID: <e0c79586-3501-050d-f279-2506770324ee@leemhuis.info>
Date:   Mon, 18 Apr 2022 15:46:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Basavaraj.Natikar@amd.com, Richard.Gong@amd.com,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
References: <20220414025705.598-1-mario.limonciello@amd.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220414025705.598-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1650289617;5c8eb2ee;
X-HE-SMSGID: 1ngRiQ-00085g-0c
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

Greg, this seems to be a regression that made the news
https://www.reddit.com/r/linux/comments/u5hbk6/psa_linux_5173_on_dell_amd_laptops_might_cause/

That made me wonder "how can we get issues like this fixed really
quickly in stable". Are you in cases like this maybe willing to drop the
backport of 5467801f1fcb quickly (in this case maybe even for the new
stable kernel versions that just were sent out as rc1) and then reapply
it later together with below fix once that was reviewed and merged to
mainline? Or is that too much of a hassle even for special case like this?

Ciao, Thorsten


On 14.04.22 04:57, Mario Limonciello wrote:
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
> 
> Cc: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Link: https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/gpio/gpiolib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 085348e08986..b7694171655c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>  
>  	gpiochip_set_irq_hooks(gc);
>  
> -	acpi_gpiochip_request_interrupts(gc);
> -
>  	/*
>  	 * Using barrier() here to prevent compiler from reordering
>  	 * gc->irq.initialized before initialization of above
> @@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
>  
>  	gc->irq.initialized = true;
>  
> +	acpi_gpiochip_request_interrupts(gc);
> +
>  	return 0;
>  }
>  

