Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 210B619DADD
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgDCQIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 12:08:11 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:60015 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDCQIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 12:08:11 -0400
Received: from 185.80.35.16 (185.80.35.16) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.341)
 id c2d6f9a9fb66b688; Fri, 3 Apr 2020 18:08:08 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Len Brown <lenb@kernel.org>, Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, "5 . 4+" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()
Date:   Fri, 03 Apr 2020 18:08:08 +0200
Message-ID: <3798902.sSGyZ91sKY@kreacher>
In-Reply-To: <20200403154834.303105-2-hdegoede@redhat.com>
References: <20200403154834.303105-1-hdegoede@redhat.com> <20200403154834.303105-2-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday, April 3, 2020 5:48:34 PM CEST Hans de Goede wrote:
> The Power Management Events (PMEs) the INT0002 driver listens for get
> signalled by the Power Management Controller (PMC) using the same IRQ
> as used for the ACPI SCI.
> 
> Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
> waking up the system") the SCI triggering, without there being a wakeup
> cause recognized by the ACPI sleep code, will no longer wakeup the system.
> 
> This breaks PMEs / wakeups signalled to the INT0002 driver, the system
> never leaves the s2idle_loop() now.
> 
> Use acpi_register_wakeup_handler() to register a function which checks
> the GPE0a_STS register for a PME and trigger a wakeup when a PME has
> been signalled.
> 
> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Andy, any objections?

> ---
> Changes in v3:
> - Keep the pm_wakeup_hard_event() call
> 
> Changes in v2:
> - Adjust for the wakeup-handler registration function being renamed to
>   acpi_register_wakeup_handler()
> ---
>  drivers/platform/x86/intel_int0002_vgpio.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
> index f14e2c5f9da5..55f088f535e2 100644
> --- a/drivers/platform/x86/intel_int0002_vgpio.c
> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
> @@ -127,6 +127,14 @@ static irqreturn_t int0002_irq(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> +static bool int0002_check_wake(void *data)
> +{
> +	u32 gpe_sts_reg;
> +
> +	gpe_sts_reg = inl(GPE0A_STS_PORT);
> +	return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
> +}
> +
>  static struct irq_chip int0002_byt_irqchip = {
>  	.name			= DRV_NAME,
>  	.irq_ack		= int0002_irq_ack,
> @@ -220,6 +228,7 @@ static int int0002_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> +	acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);
>  	device_init_wakeup(dev, true);
>  	return 0;
>  }
> @@ -227,6 +236,7 @@ static int int0002_probe(struct platform_device *pdev)
>  static int int0002_remove(struct platform_device *pdev)
>  {
>  	device_init_wakeup(&pdev->dev, false);
> +	acpi_unregister_wakeup_handler(int0002_check_wake, NULL);
>  	return 0;
>  }
>  
> 




