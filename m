Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA43E1A2174
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 14:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgDHMMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 08:12:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40133 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgDHMMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 08:12:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id s8so7517434wrt.7;
        Wed, 08 Apr 2020 05:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4oBWtnB+AHmz4Nj8u6gcWza06OmPrpkuIS2H9Ro5sVM=;
        b=UER6qfihxL/25HM0sbCl8NoXGLpvoBaJhn0C/a7sOYGwN++t+U4nxnJ36Ghcrvuh9J
         Liy8Flxrt05qSGhbcVeX76xpyinM76Mi0dTOY4f0NZnJBgbdpvPB2/7m5ldkgYF91Kqg
         0npcwqWIgZlZxaWjxZD24HsJaQFNQitnoY4aI7+dgZfjGh3JMGeJA7SiVMpktB0aKJku
         8n1ba2CqrWLO84S/nWTQXJxhZk1ixAaZhg0v3DRq231yzK15b8X9avmxfYlKvV5UtMte
         42yktEv5oGdX73iMQMKJ3oEmmLgqsexd0dkq8uRZSgkSJ97uShcxbHxZoxBOvsC9l1RH
         5pjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4oBWtnB+AHmz4Nj8u6gcWza06OmPrpkuIS2H9Ro5sVM=;
        b=BW8YPKqM64mhpOQDqKQJqv93rN8it5LADvIbI9986kSuWT16UcULR/xEr9Eqf/GR7T
         FyRUN3uzltICyQInCgfQgGqsVW1nigUerBVgpE28X6LFgIBYKrpUwOumYVba3WlyLliT
         RIT3OHtd89zINUnzp+yVzI8DGO7fvuTtH662NTkmnz3SEAnwWn7RUW7UY9xPW95WXOqd
         b4nerSaFNyn++tj5cMDCKEUMoCns5ssioTejBO/g4n2WgG+q1EfRjjWSZSciiRfiOK4i
         5ybF/GaMMSjNVoTLZ5Sj4S3QNVLAs6QZvmbnzIoNm2Mt7JZ8ZmbuMGzgsesjLYKqEyA7
         uNGA==
X-Gm-Message-State: AGi0PuY/4fTJFx2AOD+LNU+5rLHy7OepB3673jCLazHdJpl9ePDUEAXZ
        4JBNorpD+2qIPjhIHdS2gU7sQPL4IZrniNdhVC4=
X-Google-Smtp-Source: APiQypL6mZfbVeqX2oW9O9VwevxlZXhVbfN7PwXL+V8tturb6+tilG9IrnX56wB1IKgk5BIy1aYEzPOwOkoazqTjSA4=
X-Received: by 2002:adf:b6ab:: with SMTP id j43mr8243098wre.109.1586347937671;
 Wed, 08 Apr 2020 05:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200407213058.62870-1-hdegoede@redhat.com>
In-Reply-To: <20200407213058.62870-1-hdegoede@redhat.com>
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Wed, 8 Apr 2020 15:11:51 +0300
Message-ID: <CAKErNvqM9ax8RB+Hm0e70a_uk_Ok3KfSQDmy0q9jKFaAQM3Fsg@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 3+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 8, 2020 at 12:31 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Commit 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement
> irq_set_wake on Bay Trail") stopped passing irq_set_wake requests on to
> the parents IRQ because this was breaking suspend (causing immediate
> wakeups) on an Asus E202SA.
>
> This workaround for this issue is mostly fine, on most Cherry Trail
> devices where we need the INT0002 device for wakeups by e.g. USB kbds,
> the parent IRQ is shared with the ACPI SCI and that is marked as wakeup
> anyways.
>
> But not on all devices, specifically on a Medion Akoya E1239T there is
> no SCI at all, and because the irq_set_wake request is not passed on to
> the parent IRQ, wake up by the builtin USB kbd does not work here.
>
> So the workaround for the Asus E202SA immediate wake problem is causing
> problems elsewhere; and in hindsight it is not the correct fix,
> the Asus E202SA uses Airmont CPU cores, but this does not mean it is a
> Cherry Trail based device, Brasswell uses Airmont CPU cores too and this
> actually is a Braswell device.
>
> Most (all?) Braswell devices use classic S3 mode suspend rather then
> s2idle suspend and in this case directly dealing with PME events as
> the INT0002 driver does likely is not the best idea, so that this is
> causing issues is not surprising.
>
> Replace the workaround of not passing irq_set_wake requests on to the
> parents IRQ, by not binding to the INT0002 device when s2idle is not used=
.
> This fixes USB kbd wakeups not working on some Cherry Trail devices,
> while still avoiding mucking with the wakeup flags on the Asus E202SA
> (and other Brasswell devices).

I tested this patch over kernel 5.6.2 on Asus E202SA and didn't notice
any regressions. Wakeup by opening lid, by pressing a button on
keyboard, by USB keyboard =E2=80=94 all seem to work fine. So, if appropria=
te:

Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>

I have a question though. After your patch this driver will basically
be a no-op on my laptop. Does it mean I don't even need it in the
first place? What about the IRQ storm this driver is meant to deal
with =E2=80=94 does it never happen on Braswell? What are the reproduction
steps to verify my hardware is not affected? I have that INT0002
device, so I'm worried it may cause issues if not bound to the driver.

> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
> Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement i=
rq_set_wake on Bay Trail")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/platform/x86/intel_int0002_vgpio.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platfor=
m/x86/intel_int0002_vgpio.c
> index 55f088f535e2..e8bec72d3823 100644
> --- a/drivers/platform/x86/intel_int0002_vgpio.c
> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
> @@ -143,21 +143,9 @@ static struct irq_chip int0002_byt_irqchip =3D {
>         .irq_set_wake           =3D int0002_irq_set_wake,
>  };
>
> -static struct irq_chip int0002_cht_irqchip =3D {
> -       .name                   =3D DRV_NAME,
> -       .irq_ack                =3D int0002_irq_ack,
> -       .irq_mask               =3D int0002_irq_mask,
> -       .irq_unmask             =3D int0002_irq_unmask,
> -       /*
> -        * No set_wake, on CHT the IRQ is typically shared with the ACPI =
SCI
> -        * and we don't want to mess with the ACPI SCI irq settings.
> -        */
> -       .flags                  =3D IRQCHIP_SKIP_SET_WAKE,
> -};
> -
>  static const struct x86_cpu_id int0002_cpu_ids[] =3D {
>         INTEL_CPU_FAM6(ATOM_SILVERMONT, int0002_byt_irqchip),   /* Valley=
view, Bay Trail  */
> -       INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_cht_irqchip),      /* Braswe=
ll, Cherry Trail */
> +       INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_byt_irqchip),      /* Braswe=
ll, Cherry Trail */
>         {}
>  };
>
> @@ -181,6 +169,10 @@ static int int0002_probe(struct platform_device *pde=
v)
>         if (!cpu_id)
>                 return -ENODEV;
>
> +       /* We only need to directly deal with PMEs when using s2idle */
> +       if (!pm_suspend_default_s2idle())
> +               return -ENODEV;
> +
>         irq =3D platform_get_irq(pdev, 0);
>         if (irq < 0)
>                 return irq;
> --
> 2.26.0
>
