Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C01919B56C
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 20:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732860AbgDAS0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 14:26:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55227 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732928AbgDAS0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 14:26:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585765581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Acn/JRNYZl9LcndQ8j8QhECk/FmgXfJf7w+PhnRfkkA=;
        b=giyYk2zYJXjHHTJN8kV/4updxqEQ/c4QdiLU7XIvlIW4uV4qzol+ooAGOyri9OZvGlSY88
        VJPk6B+Gza6uY6y/eN9wx7qNVIlaiWrl2t6H8/3Xs+UK73ZKoTTn0mrc6uiEi7l0BHdZD/
        6ZI9XWc0+ilq64Wk5jLFHvA8oStsNSs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-bnc7csu2NkyKEQ4zMmA-dw-1; Wed, 01 Apr 2020 14:26:19 -0400
X-MC-Unique: bnc7csu2NkyKEQ4zMmA-dw-1
Received: by mail-wm1-f71.google.com with SMTP id v8so310096wml.8
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 11:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Acn/JRNYZl9LcndQ8j8QhECk/FmgXfJf7w+PhnRfkkA=;
        b=TZ1ehvPGw005DqgBnvfg2neBBEBpndInz1PA5XxDN18h7q9lnk1fYUHCxK3z0nGSG6
         8VXuxmTWzoFB2yIEUKxIdNW7y0LsosJX8kGhXI7NzsJVcUJBqZeZIU+3RuBxCfBhGNr6
         EQUnPrATmMSxRrxJQQz5Z9/4E6Q7yuFg9w0pbl+LnSz+zSlCh3xVYVVIYB4kMc5j8iLv
         SuYlYMQ+fyTa45KKbTD8oHqxH1Zzim626kFj3Pd4f/o+8FOip4QvpaUqMF8y6Fzrl5ly
         1JpYMnQEjZXMUjf37NOK8jPEGxfoT+fKCk/m3BKHDxFMcxFC1CW40JjdGTVis6OS9lAa
         AS6w==
X-Gm-Message-State: AGi0PubHV31GU8iFcSUquZWEBPgXfvR+7NJ+tH9OkLH9OhMRqxqhG21x
        K+nqQQ4RZXNvqfkJd6Q1nJeFJ+8yVk8CtrkCPxfCWPl05SjUZo0inm7CiIHVQUuC0SDiVPBPknN
        2v3QfCCZvyIhtosBi
X-Received: by 2002:a1c:4805:: with SMTP id v5mr5398248wma.98.1585765577986;
        Wed, 01 Apr 2020 11:26:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypLx23H4C+MO+AA+AAeCfEZ3Mg44k3QvPtK+gZW+sUI+wJitu8GFgVoWhoYiOuzVaD+ha6hNiA==
X-Received: by 2002:a1c:4805:: with SMTP id v5mr5398218wma.98.1585765577635;
        Wed, 01 Apr 2020 11:26:17 -0700 (PDT)
Received: from x1-7.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id c85sm3655872wmd.48.2020.04.01.11.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 11:26:17 -0700 (PDT)
Subject: Re: [PATCH 5.6 regression fix 1/2] ACPI: PM: Add
 acpi_s2idle_register_wake_callback()
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 4+" <stable@vger.kernel.org>
References: <20200329223419.122796-1-hdegoede@redhat.com>
 <20200329223419.122796-2-hdegoede@redhat.com>
 <CAJZ5v0iapuqnfsQHhTQTWXdEtzX_MMTBUqdAzCej19AF9rtrNA@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <daea7dad-73ac-3f2a-75a1-58017988ec89@redhat.com>
Date:   Wed, 1 Apr 2020 20:26:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0iapuqnfsQHhTQTWXdEtzX_MMTBUqdAzCej19AF9rtrNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/1/20 6:32 PM, Rafael J. Wysocki wrote:
> On Mon, Mar 30, 2020 at 12:34 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
>> waking up the system") the SCI triggering without there being a wakeup
>> cause recognized by the ACPI sleep code will no longer wakeup the system.
>>
>> This works as intended, but this is a problem for devices where the SCI
>> is shared with another device which is also a wakeup source.
>>
>> In the past these, from the pov of the ACPI sleep code, spurious SCIs
>> would still cause a wakeup so the wakeup from the device sharing the
>> interrupt would actually wakeup the system. This now no longer works.
>>
>> This is a problem on e.g. Bay Trail-T and Cherry Trail devices where
>> some peripherals (typically the XHCI controller) can signal a
>> Power Management Event (PME) to the Power Management Controller (PMC)
>> to wakeup the system, this uses the same interrupt as the SCI.
>> These wakeups are handled through a special INT0002 ACPI device which
>> checks for events in the GPE0a_STS for this and takes care of acking
>> the PME so that the shared interrupt stops triggering.
>>
>> The change to the ACPI sleep code to ignore the spurious SCI, causes
>> the system to no longer wakeup on these PME events. To make things
>> worse this means that the INT0002 device driver interrupt handler will
>> no longer run, causing the PME to not get cleared and resulting in the
>> system hanging. Trying to wakeup the system after such a PME through e.g.
>> the power button no longer works.
>>
>> Add an acpi_s2idle_register_wake_callback() function which registers
>> a callback to be called from acpi_s2idle_wake() and when the callback
>> returns true, return true from acpi_s2idle_wake().
>>
>> The INT0002 driver will use this mechanism to check the GPE0a_STS
>> register from acpi_s2idle_wake() and to tell the system to wakeup
>> if a PME is signaled in the register.
>>
>> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
>> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> I generally agree with the approach, but I would make some, mostly
> cosmetic, changes.
> 
> First off, I'd put the new code into drivers/acpi/wakeup.c.
> 
> I'd export one function from there to be called from
> acpi_s2idle_wake() and the install/uninstall routines for the users.

Ok.

>> ---
>>   drivers/acpi/sleep.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/acpi.h |  7 +++++
>>   2 files changed, 77 insertions(+)
>>
>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
>> index e5f95922bc21..e360e51afa8e 100644
>> --- a/drivers/acpi/sleep.c
>> +++ b/drivers/acpi/sleep.c
>> @@ -943,6 +943,65 @@ static struct acpi_scan_handler lps0_handler = {
>>          .attach = lps0_device_attach,
>>   };
>>
>> +struct s2idle_wake_callback {
> 
> I'd call this acpi_wakeup_handler.
> 
>> +       struct list_head list;
> 
> list_node?
> 
>> +       bool (*function)(void *data);
> 
> bool (*wakeup)(void *context)?
> 
>> +       void *user_data;
> 
> context?

Sure (for all of the above).

> 
>> +};
>> +
>> +static LIST_HEAD(s2idle_wake_callback_head);
>> +static DEFINE_MUTEX(s2idle_wake_callback_mutex);
>> +
>> +/*
>> + * Drivers which may share an IRQ with the SCI can use this to register
>> + * a callback which returns true when the device they are managing wants
>> + * to trigger a wakeup.
>> + */
>> +int acpi_s2idle_register_wake_callback(
>> +       int wake_irq, bool (*function)(void *data), void *user_data)
>> +{
>> +       struct s2idle_wake_callback *callback;
>> +
>> +       /*
>> +        * If the device is not sharing its IRQ with the SCI, there is no
>> +        * need to register the callback.
>> +        */
>> +       if (!acpi_sci_irq_valid() || wake_irq != acpi_sci_irq)
>> +               return 0;
>> +
>> +       callback = kmalloc(sizeof(*callback), GFP_KERNEL);
>> +       if (!callback)
>> +               return -ENOMEM;
>> +
>> +       callback->function = function;
>> +       callback->user_data = user_data;
>> +
>> +       mutex_lock(&s2idle_wake_callback_mutex);
>> +       list_add(&callback->list, &s2idle_wake_callback_head);
>> +       mutex_unlock(&s2idle_wake_callback_mutex);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_s2idle_register_wake_callback);
>> +
>> +void acpi_s2idle_unregister_wake_callback(
>> +       bool (*function)(void *data), void *user_data)
>> +{
>> +       struct s2idle_wake_callback *cb;
>> +
>> +       mutex_lock(&s2idle_wake_callback_mutex);
>> +       list_for_each_entry(cb, &s2idle_wake_callback_head, list) {
>> +               if (cb->function == function &&
>> +                   cb->user_data == user_data) {
>> +                       list_del(&cb->list);
>> +                       kfree(cb);
>> +                       break;
>> +               }
>> +       }
>> +       mutex_unlock(&s2idle_wake_callback_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_s2idle_unregister_wake_callback);
>> +
>>   static int acpi_s2idle_begin(void)
>>   {
>>          acpi_scan_lock_acquire();
>> @@ -992,6 +1051,8 @@ static void acpi_s2idle_sync(void)
>>
>>   static bool acpi_s2idle_wake(void)
>>   {
>> +       struct s2idle_wake_callback *cb;
>> +
>>          if (!acpi_sci_irq_valid())
>>                  return pm_wakeup_pending();
>>
>> @@ -1025,6 +1086,15 @@ static bool acpi_s2idle_wake(void)
>>                  if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
>>                          return true;
>>
>> +               /*
>> +                * Check callbacks registered by drivers sharing the SCI.
>> +                * Note no need to lock, nothing else is running.
>> +                */
>> +               list_for_each_entry(cb, &s2idle_wake_callback_head, list) {
>> +                       if (cb->function(cb->user_data))
>> +                               return true;
>> +               }
> 
> AFAICS this needs to be done in acpi_s2idle_restore() too to clear the
> status bits in case one of these wakeup sources triggers along with a
> GPE or a fixed event and the other one wins the race.

The "wakeup" callback does not actually clear the interrupt source, just like
for normal interrupts it relies on the actual interrupt handling (which at this
point is still suspended) to do this.

All the wakeup callback does is check if the flag which the shared IRQ handler
checks to see if it should handle the IRQ (so if it should return IRQ_HANDLED
vs IRQ_NONE) is set and if the flag is set so that the actual IRQ handler
would return IRQ_HANDLED (IOW the shared IRQ is relevant for the device)
then it returns true from the wakeup callback.

The actual handling of the IRQ and clearing of the PME status bit is
then done by normal IRQ handling.

The idea here is to have the IRQ be handled as any other IRQ even though it
happens to be shared with the SCI, so in essence we want to behave as
if the first if check here:

         while (pm_wakeup_pending()) {
                 /*
                  * If IRQD_WAKEUP_ARMED is set for the SCI at this point, the
                  * SCI has not triggered while suspended, so bail out (the
                  * wakeup is pending anyway and the SCI is not the source of
                  * it).
                  */
                 if (irqd_is_wakeup_armed(irq_get_irq_data(acpi_sci_irq)))
                         return true;

Is triggering, the idea here is that yes the SCI IRQ is no longer armed,
but the cause for that is (*) not an actual SCI but another device which
shares the IRQ line. If any other IRQ is the cause for the wakeup then
we would exit the loop here, so in this case we want to treat the non SCI
IRQ event on the shared line the same as any other IRQ.

*) potentially, there could be multiple causes

Does this make sense ?  Note you know this code a lot better then me, so
you may be right we need to do something extra in s2idle_restore here
but ATM I'm not seeing what we should do there. As I've tried to explain
the wakeup callback only checks for events, it does not actually process
them and as such also does not ack them / clear any flags.

Regards,

Hans





> 
>> +
>>                  /*
>>                   * Cancel the wakeup and process all pending events in case
>>                   * there are any wakeup ones in there.
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index 0f24d701fbdc..9f06e1dc79c1 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -488,6 +488,13 @@ void __init acpi_nvs_nosave_s3(void);
>>   void __init acpi_sleep_no_blacklist(void);
>>   #endif /* CONFIG_PM_SLEEP */
>>
>> +#ifdef CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT
>> +int acpi_s2idle_register_wake_callback(
>> +       int wake_irq, bool (*function)(void *data), void *user_data);
>> +void acpi_s2idle_unregister_wake_callback(
>> +       bool (*function)(void *data), void *user_data);
>> +#endif
>> +
>>   struct acpi_osc_context {
>>          char *uuid_str;                 /* UUID string */
>>          int rev;
>> --
> 
> Thanks!
> 

