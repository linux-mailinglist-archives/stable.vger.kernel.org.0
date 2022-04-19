Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683575067F3
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 11:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbiDSJrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 05:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241722AbiDSJrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 05:47:02 -0400
X-Greylist: delayed 203 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Apr 2022 02:44:19 PDT
Received: from lithium.sammserver.com (lithium.sammserver.com [168.119.122.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529C922B28;
        Tue, 19 Apr 2022 02:44:19 -0700 (PDT)
Received: from mail.sammserver.com (sammserver.wg [10.32.40.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by lithium.sammserver.com (Postfix) with ESMTPS id 496A331181E2;
        Tue, 19 Apr 2022 11:40:54 +0200 (CEST)
Received: from mail.sammserver.com (localhost.localdomain [127.0.0.1])
        by mail.sammserver.com (Postfix) with ESMTP id D753441F32;
        Tue, 19 Apr 2022 11:40:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cavoj.net; s=email;
        t=1650361253; bh=FiIViUHrFRwZkM13AuWCuKWDSKKH/CAkIfoO4iiRyfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DnTiafivrAjTJsKoHVBGX03OCf6WFR+8yVXcgY3DvCvc0Q9QkizrO8vol8/gXs5by
         PG6510meHeznig0kl2WDEWzB/FMP0+lJ8vdrfi4G+H2OyOr44mZFIRdT+j3Mejk0fF
         RSWTQQMX7mCbZU8l7WRjG7kRJAIXcml0z8wVPe9A=
MIME-Version: 1.0
Date:   Tue, 19 Apr 2022 11:40:53 +0200
From:   =?UTF-8?Q?Samuel_=C4=8Cavoj?= <samuel@cavoj.net>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Basavaraj.Natikar@amd.com, Richard.Gong@amd.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
In-Reply-To: <20220414025705.598-1-mario.limonciello@amd.com>
References: <20220414025705.598-1-mario.limonciello@amd.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <932104ce8d454cfded85d1f65095510a@cavoj.net>
X-Sender: samuel@cavoj.net
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

this fixes the issue on an ASUS UM325 laptop.

On 2022-04-14 04:57, Mario Limonciello wrote:
> commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members 
> before
> initialization") attempted to fix a race condition that lead to a NULL
> pointer, but in the process caused a regression for _AEI/_EVT declared
> GPIOs. This manifests in messages showing deferred probing while trying
> to allocate IRQs like so:
> 
> [    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x0000 to IRQ, err -517
> [    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x002C to IRQ, err -517
> [    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x003D to IRQ, err -517
> [    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x003E to IRQ, err -517
> [    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x003A to IRQ, err -517
> [    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x003B to IRQ, err -517
> [    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x0002 to IRQ, err -517
> [    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x0011 to IRQ, err -517
> [    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x0012 to IRQ, err -517
> [    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin
> 0x0007 to IRQ, err -517
> 
> The code for walking _AEI doesn't handle deferred probing and so this 
> leads
> to non-functional GPIO interrupts.
> 
> Fix this issue by moving the call to `acpi_gpiochip_request_interrupts` 
> to
> occur after gc->irc.initialized is set.
> 
> Cc: Shreeya Patel <shreeya.patel@collabora.com>
> Cc: stable@vger.kernel.org
> Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members
> before initialization")
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Link:
> https://lore.kernel.org/linux-gpio/BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#u
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Tested-By: Samuel Čavoj <samuel@cavoj.net>

> ---
>  drivers/gpio/gpiolib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 085348e08986..b7694171655c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip 
> *gc,
> 
>  	gpiochip_set_irq_hooks(gc);
> 
> -	acpi_gpiochip_request_interrupts(gc);
> -
>  	/*
>  	 * Using barrier() here to prevent compiler from reordering
>  	 * gc->irq.initialized before initialization of above
> @@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip 
> *gc,
> 
>  	gc->irq.initialized = true;
> 
> +	acpi_gpiochip_request_interrupts(gc);
> +
>  	return 0;
>  }

Sam
