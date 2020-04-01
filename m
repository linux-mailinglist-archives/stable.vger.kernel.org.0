Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E02E19B3B8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388177AbgDAQc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:32:59 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34677 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388459AbgDAQcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 12:32:53 -0400
Received: by mail-oi1-f196.google.com with SMTP id d3so49391oic.1;
        Wed, 01 Apr 2020 09:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQ6dbMnuQmYakwtYkaDd8ZPL0bNSKkspp4CDCfrrxEk=;
        b=bCA41ZaOArp5tLpKVEfndDwvC46wA6b99I837JR563W7K7Gso8Z4mBsYnYmsUMYTnQ
         vvpT4PT9jhfGVtY/ksaMGADGomGlNK0h9KjQO0NHctbg3+eN2VchxJit/BQqZOUntVGF
         YQ4zwWvoAQkNEKM/o5g2XMnUW56eozuZN6ukKMCuOXUBifdOuEhzXWDA5J/BYIUwRsNw
         iTaaUFWT30CR1jUT/jUAkICLs/RCYD275++136oqE7WKRk0HhA479+czAhkMmH8FrNMO
         idTEL++Wb8lkxvz6Jul5yDhPWkEB0ADpnO6yW0fD0SK9cFwjPQ/MDjZfHbj9uFBHqICd
         iTyQ==
X-Gm-Message-State: AGi0PubgWls7ecBlBeSz3riKETx3UwOGwBG5kirq3BEQ7hMBPNvGDp13
        z7CPvRtRNhxGHTCZwqmzyzGo2tvoqFKuUU/uj38=
X-Google-Smtp-Source: APiQypIbcz5zIhvmhQId+hN/inqiB0CGc/pOWNe7i8QekTGn+0r2FRSM42dYTgD5Rp0mPjYuXdSADPqyuCaVbpfRhBE=
X-Received: by 2002:a05:6808:8f:: with SMTP id s15mr3565793oic.110.1585758772561;
 Wed, 01 Apr 2020 09:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200329223419.122796-1-hdegoede@redhat.com> <20200329223419.122796-2-hdegoede@redhat.com>
In-Reply-To: <20200329223419.122796-2-hdegoede@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 1 Apr 2020 18:32:41 +0200
Message-ID: <CAJZ5v0iapuqnfsQHhTQTWXdEtzX_MMTBUqdAzCej19AF9rtrNA@mail.gmail.com>
Subject: Re: [PATCH 5.6 regression fix 1/2] ACPI: PM: Add acpi_s2idle_register_wake_callback()
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

On Mon, Mar 30, 2020 at 12:34 AM Hans de Goede <hdegoede@redhat.com> wrote:
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
> Add an acpi_s2idle_register_wake_callback() function which registers
> a callback to be called from acpi_s2idle_wake() and when the callback
> returns true, return true from acpi_s2idle_wake().
>
> The INT0002 driver will use this mechanism to check the GPE0a_STS
> register from acpi_s2idle_wake() and to tell the system to wakeup
> if a PME is signaled in the register.
>
> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I generally agree with the approach, but I would make some, mostly
cosmetic, changes.

First off, I'd put the new code into drivers/acpi/wakeup.c.

I'd export one function from there to be called from
acpi_s2idle_wake() and the install/uninstall routines for the users.

> ---
>  drivers/acpi/sleep.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/acpi.h |  7 +++++
>  2 files changed, 77 insertions(+)
>
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index e5f95922bc21..e360e51afa8e 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -943,6 +943,65 @@ static struct acpi_scan_handler lps0_handler = {
>         .attach = lps0_device_attach,
>  };
>
> +struct s2idle_wake_callback {

I'd call this acpi_wakeup_handler.

> +       struct list_head list;

list_node?

> +       bool (*function)(void *data);

bool (*wakeup)(void *context)?

> +       void *user_data;

context?

> +};
> +
> +static LIST_HEAD(s2idle_wake_callback_head);
> +static DEFINE_MUTEX(s2idle_wake_callback_mutex);
> +
> +/*
> + * Drivers which may share an IRQ with the SCI can use this to register
> + * a callback which returns true when the device they are managing wants
> + * to trigger a wakeup.
> + */
> +int acpi_s2idle_register_wake_callback(
> +       int wake_irq, bool (*function)(void *data), void *user_data)
> +{
> +       struct s2idle_wake_callback *callback;
> +
> +       /*
> +        * If the device is not sharing its IRQ with the SCI, there is no
> +        * need to register the callback.
> +        */
> +       if (!acpi_sci_irq_valid() || wake_irq != acpi_sci_irq)
> +               return 0;
> +
> +       callback = kmalloc(sizeof(*callback), GFP_KERNEL);
> +       if (!callback)
> +               return -ENOMEM;
> +
> +       callback->function = function;
> +       callback->user_data = user_data;
> +
> +       mutex_lock(&s2idle_wake_callback_mutex);
> +       list_add(&callback->list, &s2idle_wake_callback_head);
> +       mutex_unlock(&s2idle_wake_callback_mutex);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(acpi_s2idle_register_wake_callback);
> +
> +void acpi_s2idle_unregister_wake_callback(
> +       bool (*function)(void *data), void *user_data)
> +{
> +       struct s2idle_wake_callback *cb;
> +
> +       mutex_lock(&s2idle_wake_callback_mutex);
> +       list_for_each_entry(cb, &s2idle_wake_callback_head, list) {
> +               if (cb->function == function &&
> +                   cb->user_data == user_data) {
> +                       list_del(&cb->list);
> +                       kfree(cb);
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&s2idle_wake_callback_mutex);
> +}
> +EXPORT_SYMBOL_GPL(acpi_s2idle_unregister_wake_callback);
> +
>  static int acpi_s2idle_begin(void)
>  {
>         acpi_scan_lock_acquire();
> @@ -992,6 +1051,8 @@ static void acpi_s2idle_sync(void)
>
>  static bool acpi_s2idle_wake(void)
>  {
> +       struct s2idle_wake_callback *cb;
> +
>         if (!acpi_sci_irq_valid())
>                 return pm_wakeup_pending();
>
> @@ -1025,6 +1086,15 @@ static bool acpi_s2idle_wake(void)
>                 if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
>                         return true;
>
> +               /*
> +                * Check callbacks registered by drivers sharing the SCI.
> +                * Note no need to lock, nothing else is running.
> +                */
> +               list_for_each_entry(cb, &s2idle_wake_callback_head, list) {
> +                       if (cb->function(cb->user_data))
> +                               return true;
> +               }

AFAICS this needs to be done in acpi_s2idle_restore() too to clear the
status bits in case one of these wakeup sources triggers along with a
GPE or a fixed event and the other one wins the race.

> +
>                 /*
>                  * Cancel the wakeup and process all pending events in case
>                  * there are any wakeup ones in there.
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 0f24d701fbdc..9f06e1dc79c1 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -488,6 +488,13 @@ void __init acpi_nvs_nosave_s3(void);
>  void __init acpi_sleep_no_blacklist(void);
>  #endif /* CONFIG_PM_SLEEP */
>
> +#ifdef CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT
> +int acpi_s2idle_register_wake_callback(
> +       int wake_irq, bool (*function)(void *data), void *user_data);
> +void acpi_s2idle_unregister_wake_callback(
> +       bool (*function)(void *data), void *user_data);
> +#endif
> +
>  struct acpi_osc_context {
>         char *uuid_str;                 /* UUID string */
>         int rev;
> --

Thanks!
