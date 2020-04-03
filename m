Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B2119D785
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 15:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgDCNZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 09:25:54 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37101 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDCNZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 09:25:53 -0400
Received: by mail-oi1-f196.google.com with SMTP id u20so6061692oic.4;
        Fri, 03 Apr 2020 06:25:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5bl0oW2UaMbm846MDbnqihMiQu6ij4SqNZLt2jQkKdU=;
        b=G26iveqllpugosFx4k9CzIOEjokj18JAKguIZ/lQVRAm0v16lQnSJ2Fqs2yZ4ktKOw
         J/zbaVP8JDLYhbyemnIg9twlgX7G33DcR5YiE5g5PMO++mmIG/2etTNijzvNtVvv9NB1
         pVLEgv1RsYgCJEk+kdol2wUvj1Xb3OyNjxbIaQkKdOYNlCiihPSZXq7M0t9XsbA38Oeg
         vFb7gAAo82BseNV9GwJPxWdirxEeDLLWSSs451aZJjZLisRJfiY9dGyAzH1InLY3oCQA
         8sbwAvzyxJwf1/rYSqGSkJRyQe8xFCsMMjBJYzSLirmVRzucnI32ChpY8fKMsjfnN5Mp
         X6Lg==
X-Gm-Message-State: AGi0PuaeEWHG8JzOPmD2covqSLg4R5Wcnku/bMwKYrcdRmDyaDJVV8ty
        3lnu9UuhYEnmUeQ+3ug2TUtzpY9uogG+Gh7Bf4E=
X-Google-Smtp-Source: APiQypKZPO0JhoWTs/XSnrPSPcz/KXDIsII7JLUge7QN3UZ7VSoLgRf1WErGGN8QSjpAiedtM5tpf0hb+p7dfG1a2Vs=
X-Received: by 2002:aca:2209:: with SMTP id b9mr3021772oic.103.1585920352757;
 Fri, 03 Apr 2020 06:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200403105235.105187-1-hdegoede@redhat.com> <20200403105235.105187-2-hdegoede@redhat.com>
In-Reply-To: <20200403105235.105187-2-hdegoede@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 3 Apr 2020 15:25:41 +0200
Message-ID: <CAJZ5v0gcRgTTRfCKHS00y599NBhWPgAYQF0RfFo6-vDegYA6Eg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 4+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 3, 2020 at 12:52 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
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
> With this new mechanism the pm_wakeup_hard_event() call is no longer
> necessary, so remove it and also remove the matching device_init_wakeup()
> calls.
>
> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> - Adjust for the wakeup-handler registration function being renamed to
>   acpi_register_wakeup_handler()
> ---
>  drivers/platform/x86/intel_int0002_vgpio.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
> index f14e2c5f9da5..9da19168b4f6 100644
> --- a/drivers/platform/x86/intel_int0002_vgpio.c
> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
> @@ -122,11 +122,17 @@ static irqreturn_t int0002_irq(int irq, void *data)
>         generic_handle_irq(irq_find_mapping(chip->irq.domain,
>                                             GPE0A_PME_B0_VIRT_GPIO_PIN));
>
> -       pm_wakeup_hard_event(chip->parent);
> -

If the event occurs before the "noirq" phase of suspending devices, it
can be missed with this change AFAICS.

>         return IRQ_HANDLED;
>  }
>
> +static bool int0002_check_wake(void *data)
> +{
> +       u32 gpe_sts_reg;
> +
> +       gpe_sts_reg = inl(GPE0A_STS_PORT);
> +       return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
> +}
> +
>  static struct irq_chip int0002_byt_irqchip = {
>         .name                   = DRV_NAME,
>         .irq_ack                = int0002_irq_ack,
> @@ -220,13 +226,13 @@ static int int0002_probe(struct platform_device *pdev)
>                 return ret;
>         }
>
> -       device_init_wakeup(dev, true);
> +       acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);

So I would just add the wakeup handler registration here.

>         return 0;
>  }
>
>  static int int0002_remove(struct platform_device *pdev)
>  {
> -       device_init_wakeup(&pdev->dev, false);
> +       acpi_unregister_wakeup_handler(int0002_check_wake, NULL);
>         return 0;
>  }
>
> --
