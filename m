Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57FD19E6EB
	for <lists+stable@lfdr.de>; Sat,  4 Apr 2020 19:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgDDRwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Apr 2020 13:52:06 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41322 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgDDRwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Apr 2020 13:52:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id k9so9243540oia.8;
        Sat, 04 Apr 2020 10:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mzdz7p9mv9xyq9yL2rAMSDGg8ULijyiVFqVtXC5vAZI=;
        b=csONXObCOhrFYiHCsXmrmllg6YSE+2A9z0LvpOtso72qRaJ6n95njeC/szS6wfU2AE
         SARupRBjk/GC0ALWbvTbcOnBCmA4Y46jSxQbzfgJ7i4BbEVIiQd8B+sCuKAu0jhVH5d0
         y5JxgxT+BO62TzXylqBLopKDHC/IIN3LZn8ZcdQZ4lJNB9GJChwjpK9C6kTR4rEj9D7s
         QqHNSKi1ZM2SLqiwEJ0QjTkOxMOKw97Y1lM9kUCdDQnT5gsGPnTqrmPb0c+75K1wURSX
         PBSID7La/f93NRMoOZj7IsXzqszNa+hLKe64AJ2Cf4n8v1J3/LD7vN+b2nhx/7DSl2av
         iCyQ==
X-Gm-Message-State: AGi0PubDE67IliEITBMEEoFRZBwdM/beUqCCtiXXotPgSiUCTeAbTsHA
        Y39TaVOpR/tY2Ux80tkYzZPYA3CLI/gR+RGNDAo=
X-Google-Smtp-Source: APiQypJU6CmnYcQ5hnHERUf+Pufavi2BvjOoD9SaKXourFIdExsIiII4dqcUakrdbJUwbZG+WDwD4lz6851PyMjlqpg=
X-Received: by 2002:a05:6808:8f:: with SMTP id s15mr7572122oic.110.1586022724987;
 Sat, 04 Apr 2020 10:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200403154834.303105-1-hdegoede@redhat.com>
In-Reply-To: <20200403154834.303105-1-hdegoede@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Sat, 4 Apr 2020 19:51:53 +0200
Message-ID: <CAJZ5v0hSU4JUWzEOtwi2Jz-9k9WSi_1pgnGy9SX+0aCZMeRQkw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ACPI: PM: Add acpi_[un]register_wakeup_handler()
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

On Fri, Apr 3, 2020 at 5:48 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
> waking up the system") the SCI triggering without there being a wakeup
> cause recognized by the ACPI sleep code will no longer wakeup the system.
>
> This works as intended, but this is a problem for devices where the SCI
> is shared with another device which is also a wakeup source.
>
> In the past these, from the pov of the ACPI sleep code, spurious SCIs
> would still cause a wakeup so the wakeup from the device sharing the
> interrupt would actually wakeup the system. This now no longer works.
>
> This is a problem on e.g. Bay Trail-T and Cherry Trail devices where
> some peripherals (typically the XHCI controller) can signal a
> Power Management Event (PME) to the Power Management Controller (PMC)
> to wakeup the system, this uses the same interrupt as the SCI.
> These wakeups are handled through a special INT0002 ACPI device which
> checks for events in the GPE0a_STS for this and takes care of acking
> the PME so that the shared interrupt stops triggering.
>
> The change to the ACPI sleep code to ignore the spurious SCI, causes
> the system to no longer wakeup on these PME events. To make things
> worse this means that the INT0002 device driver interrupt handler will
> no longer run, causing the PME to not get cleared and resulting in the
> system hanging. Trying to wakeup the system after such a PME through e.g.
> the power button no longer works.
>
> Add an acpi_register_wakeup_handler() function which registers
> a handler to be called from acpi_s2idle_wake() and when the handler
> returns true, return true from acpi_s2idle_wake().
>
> The INT0002 driver will use this mechanism to check the GPE0a_STS
> register from acpi_s2idle_wake() and to tell the system to wakeup
> if a PME is signaled in the register.
>
> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Rebased on top of the current mainline and applied as 5.7-rc material
along with the [2/2], thanks!

> ---
> Changes in v3:
> - Some small indentation changes
>
> Changes in v2:
> - Move the new helpers to drivers/acpi/wakeup.c
> - Rename the helpers to acpi_[un]register_wakeup_handler(), also give some
>   types/variables better names
> ---
>  drivers/acpi/sleep.c  |  4 +++
>  drivers/acpi/sleep.h  |  1 +
>  drivers/acpi/wakeup.c | 81 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/acpi.h  |  5 +++
>  4 files changed, 91 insertions(+)
>
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index e5f95922bc21..dc8c71c47285 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -1025,6 +1025,10 @@ static bool acpi_s2idle_wake(void)
>                 if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
>                         return true;
>
> +               /* Check wakeups from drivers sharing the SCI. */
> +               if (acpi_check_wakeup_handlers())
> +                       return true;
> +
>                 /*
>                  * Cancel the wakeup and process all pending events in case
>                  * there are any wakeup ones in there.
> diff --git a/drivers/acpi/sleep.h b/drivers/acpi/sleep.h
> index 41675d24a9bc..3d90480ce1b1 100644
> --- a/drivers/acpi/sleep.h
> +++ b/drivers/acpi/sleep.h
> @@ -2,6 +2,7 @@
>
>  extern void acpi_enable_wakeup_devices(u8 sleep_state);
>  extern void acpi_disable_wakeup_devices(u8 sleep_state);
> +extern bool acpi_check_wakeup_handlers(void);
>
>  extern struct list_head acpi_wakeup_device_list;
>  extern struct mutex acpi_device_lock;
> diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
> index 9614126bf56e..90c40f992e13 100644
> --- a/drivers/acpi/wakeup.c
> +++ b/drivers/acpi/wakeup.c
> @@ -12,6 +12,15 @@
>  #include "internal.h"
>  #include "sleep.h"
>
> +struct acpi_wakeup_handler {
> +       struct list_head list_node;
> +       bool (*wakeup)(void *context);
> +       void *context;
> +};
> +
> +static LIST_HEAD(acpi_wakeup_handler_head);
> +static DEFINE_MUTEX(acpi_wakeup_handler_mutex);
> +
>  /*
>   * We didn't lock acpi_device_lock in the file, because it invokes oops in
>   * suspend/resume and isn't really required as this is called in S-state. At
> @@ -96,3 +105,75 @@ int __init acpi_wakeup_device_init(void)
>         mutex_unlock(&acpi_device_lock);
>         return 0;
>  }
> +
> +/**
> + * acpi_register_wakeup_handler - Register wakeup handler
> + * @wake_irq: The IRQ through which the device may receive wakeups
> + * @wakeup:   Wakeup-handler to call when the SCI has triggered a wakeup
> + * @context:  Context to pass to the handler when calling it
> + *
> + * Drivers which may share an IRQ with the SCI can use this to register
> + * a handler which returns true when the device they are managing wants
> + * to trigger a wakeup.
> + */
> +int acpi_register_wakeup_handler(int wake_irq, bool (*wakeup)(void *context),
> +                                void *context)
> +{
> +       struct acpi_wakeup_handler *handler;
> +
> +       /*
> +        * If the device is not sharing its IRQ with the SCI, there is no
> +        * need to register the handler.
> +        */
> +       if (!acpi_sci_irq_valid() || wake_irq != acpi_sci_irq)
> +               return 0;
> +
> +       handler = kmalloc(sizeof(*handler), GFP_KERNEL);
> +       if (!handler)
> +               return -ENOMEM;
> +
> +       handler->wakeup = wakeup;
> +       handler->context = context;
> +
> +       mutex_lock(&acpi_wakeup_handler_mutex);
> +       list_add(&handler->list_node, &acpi_wakeup_handler_head);
> +       mutex_unlock(&acpi_wakeup_handler_mutex);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(acpi_register_wakeup_handler);
> +
> +/**
> + * acpi_unregister_wakeup_handler - Unregister wakeup handler
> + * @wakeup:   Wakeup-handler passed to acpi_register_wakeup_handler()
> + * @context:  Context passed to acpi_register_wakeup_handler()
> + */
> +void acpi_unregister_wakeup_handler(bool (*wakeup)(void *context),
> +                                   void *context)
> +{
> +       struct acpi_wakeup_handler *handler;
> +
> +       mutex_lock(&acpi_wakeup_handler_mutex);
> +       list_for_each_entry(handler, &acpi_wakeup_handler_head, list_node) {
> +               if (handler->wakeup == wakeup && handler->context == context) {
> +                       list_del(&handler->list_node);
> +                       kfree(handler);
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&acpi_wakeup_handler_mutex);
> +}
> +EXPORT_SYMBOL_GPL(acpi_unregister_wakeup_handler);
> +
> +bool acpi_check_wakeup_handlers(void)
> +{
> +       struct acpi_wakeup_handler *handler;
> +
> +       /* No need to lock, nothing else is running when we're called. */
> +       list_for_each_entry(handler, &acpi_wakeup_handler_head, list_node) {
> +               if (handler->wakeup(handler->context))
> +                       return true;
> +       }
> +
> +       return false;
> +}
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 0f24d701fbdc..efac0f9c01a2 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -488,6 +488,11 @@ void __init acpi_nvs_nosave_s3(void);
>  void __init acpi_sleep_no_blacklist(void);
>  #endif /* CONFIG_PM_SLEEP */
>
> +int acpi_register_wakeup_handler(
> +       int wake_irq, bool (*wakeup)(void *context), void *context);
> +void acpi_unregister_wakeup_handler(
> +       bool (*wakeup)(void *context), void *context);
> +
>  struct acpi_osc_context {
>         char *uuid_str;                 /* UUID string */
>         int rev;
> --
> 2.26.0
>
