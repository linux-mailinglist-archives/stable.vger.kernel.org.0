Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6E899927
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 18:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbfHVQ1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 12:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbfHVQ1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 12:27:34 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9109DC049D7C
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 16:27:33 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id w22so3677900edx.8
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 09:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0myGZlrf+si+6rBMCuFo/J3E9FAdOW3CoWgUhxwI1Jo=;
        b=aJR/y2LMCjs1Hpi+LjdZivHDMGorG0grRa2SAUeiKq4CmHI/OSAqrUkJl+BnYaVAZu
         J799MLbIPr0n+CgFB1dg/fDoYCe4uXlnKC41Mr0yd11HWAAgv6eCSTh0SQgX8OtwX5L2
         XXDSmrgJtQhfEWyZvxFVscujFiBi4M0ckUAmUDvl84JZ9Yj0DTLZ2Q9KBEQSEBfe9UIn
         xgRBbEwy1o7ULNHPk2D3q6jj6OYtPT+xu1mkiNMISrNdVNEv13zfo1FHZuQ0MIvRgEu6
         ZeCVAAworCierDU/63h+f95MJd1FtW4U1vFEhWqcGbd0qMq5aqlb7IH+xqCH95CtXxat
         bVrw==
X-Gm-Message-State: APjAAAWBDEABcfNnzP0EEHEYB/0xhEcbFSLPvnu7TySmuQxjs083NWW0
        m2j/uqUHzHUp+/VqVrHPpSmu2Gro7PEbaKNUG+4owD4837Q9zzs65NhnJ2vQ/T7oZqtI5dT9Ily
        HZfZrktn/Xzm5mTJk
X-Received: by 2002:a17:906:eb8d:: with SMTP id mh13mr145280ejb.98.1566491251978;
        Thu, 22 Aug 2019 09:27:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwmVkp4Qv9GivrczG1m0kKOd0zLpwJCYqyhkBdzvMCp/JFRQsO2WoPRpqenixKIXZ1EwD/qaQ==
X-Received: by 2002:a17:906:eb8d:: with SMTP id mh13mr145253ejb.98.1566491251673;
        Thu, 22 Aug 2019 09:27:31 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id i19sm2956163ejf.7.2019.08.22.09.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2019 09:27:30 -0700 (PDT)
Subject: Re: [PATCH v2] Skip deferred request irqs for devices known to fail
From:   Hans de Goede <hdegoede@redhat.com>
To:     Ian W MORRISON <ianwmorrison@gmail.com>,
        benjamin.tissoires@redhat.com, mika.westerberg@linux.intel.com,
        andriy.shevchenko@linux.intel.com, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com
Cc:     linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190819112637.29943-1-ianwmorrison@gmail.com>
 <1bd012ca-9b2f-78c3-abb1-6b5680add404@redhat.com>
Message-ID: <c26493fc-8f7a-cd84-5466-8fa2dc335722@redhat.com>
Date:   Thu, 22 Aug 2019 18:27:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1bd012ca-9b2f-78c3-abb1-6b5680add404@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

On 19-08-19 13:31, Hans de Goede wrote:
> Also I might be able to get my hands on a Minix Neo Z83-4 myself
> in a couple of days and then I can try to reproduce this, so lets
> wait a bit for that and see how that goes.

So I've access to a Minix Neo z83-4 myself now. The problem is
the DSDT contains an _E03 handler on the second (INT33FF UID 2)
GPIO controller which is clearly copy pasted from some DSDT
from a tablet as it deals with the ID pin of the micro-usb
connector, which the Minix Neo z83-4 mini-PC does not have.

This _E03 method switches the XHCI role switch between
host and device roles (those data lines are nor used, so don't
care) *and* for some reason it sets GN66 to 0 or 1, with GN66
being defined as:

                 Connection (
                     GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, IoRestrictionOutputOnly,
                         "\\_SB.GPO1", 0x00, ResourceConsumer, ,
                         )
                         {   // Pin list
                             0x0042
                         }
                 ),

This leads to the following difference in a pinctrl debug dump
between a good (running of ACPI edge GPIO handlers at boot disabled)
and bad run:

@@ -51,7 +51,7 @@
  pin 63 (PANEL1_BKLTCTL) GPIO 0x00008102 0x04c00000
  pin 64 (HV_DDI1_HPD) mode 1 0x03010000 0x04c00020
  pin 65 (PANEL0_BKLTCTL) GPIO 0x30008202 0x04c00003
-pin 66 (HV_DDI0_DDC_SDA) GPIO 0x00018000 0x04c00000
+pin 66 (HV_DDI0_DDC_SDA) mode 1 0x00010001 0x04c00000
  pin 67 (HV_DDI2_DDC_SCL) mode 3 0x00930301 0x04c00000
  pin 68 (HV_DDI2_HPD) mode 1 0x03010001 0x04c00020
  pin 69 (PANEL1_VDDEN) GPIO 0x00008102 0x04c00000

With a bad run ssh still works, basically everything still works except
for DDC on the  HDMI conector which is causing the blackscreen.

Through ssh I could get the above pinctrl difference and
also see this new errors in the logs:

kernel: i915 0000:00:02.0: HDMI-A-1: EDID is invalid:
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel:         [00] ZERO 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
kernel: [drm] Cannot find any crtc or sizes
kernel: [drm] Cannot find any crtc or sizes

Which matches with the DDC data pin being changes from connected
to the DDC i2c-controller into a generic (G)PIO

So this is really a case of a broken DSDT I am afraid and as such
the DMI blacklist seems the best (least bad) we can do.

But I do not believe that the current patch is a good fix, this problem
first surfaced when we started running edge ACPI GPIO event handlers at
boot to ensure that any state which is set by the handler matches the
current value of the pin. So that e.g. USB host/device role switches are
set the right value.

Where as the fix proposed by Ian, disabled us from registering a
handler all together, not only for the troublesome _E03 (which will
never trigger normally since there is no id-pin), but also for the
e.g. the INT0002 vgpio device.

And not registering a handler for the INT0002 vgpio device causes
an interrupt storm on irq 9, although for some reason that storm
stops after a 100000 interrupts or so on the Minix Neo Z83-4.
which is different from other devices where it never stops and we
get millions of interrupts.

So I believe a better fix would be to:

1) Add a kernel parameter to disable the run of edge ACPI
GPIO events at startup:

gpiolib_acpi_run_edge_events_on_startup

2) Make this default to auto which uses a DMI blacklist

This will allow us to easily test for similar problems on other
hardware and it fixes the issue at hand without disabling all
ACPI GPIO event handlers.

I will prep a patch implementing this approach sometime this
weekend.

Regards,

Hans



>> ---
>>   drivers/gpio/gpiolib-acpi.c | 33 +++++++++++++++++++++++++++------
>>   1 file changed, 27 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
>> index fdee8afa5339..f6c3dcdc91c9 100644
>> --- a/drivers/gpio/gpiolib-acpi.c
>> +++ b/drivers/gpio/gpiolib-acpi.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/gpio/machine.h>
>>   #include <linux/export.h>
>>   #include <linux/acpi.h>
>> +#include <linux/dmi.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/mutex.h>
>>   #include <linux/pinctrl/pinctrl.h>
>> @@ -20,6 +21,17 @@
>>   #include "gpiolib.h"
>>   #include "gpiolib-acpi.h"
>> +static const struct dmi_system_id skip_deferred_request_irqs_table[] = {
>> +    {
>> +        .ident = "MINIX Z83-4",
>> +        .matches = {
>> +            DMI_EXACT_MATCH(DMI_SYS_VENDOR, "MINIX"),
>> +            DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
>> +        },
>> +    },
>> +    {}
>> +};
>> +
>>   /**
>>    * struct acpi_gpio_event - ACPI GPIO event handler data
>>    *
>> @@ -1273,19 +1285,28 @@ bool acpi_can_fallback_to_crs(struct acpi_device *adev, const char *con_id)
>>       return con_id == NULL;
>>   }
>> -/* Run deferred acpi_gpiochip_request_irqs() */
>> +/*
>> + * Run deferred acpi_gpiochip_request_irqs()
>> + * but exclude devices known to fail
>> +*/
>>   static int acpi_gpio_handle_deferred_request_irqs(void)
>>   {
>>       struct acpi_gpio_chip *acpi_gpio, *tmp;
>> +    const struct dmi_system_id *dmi_id;
>> -    mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
>> -    list_for_each_entry_safe(acpi_gpio, tmp,
>> +    dmi_id = dmi_first_match(skip_deferred_request_irqs_table);
>> +    if (dmi_id)
>> +        return 0;
>> +    else {
>> +        mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
>> +        list_for_each_entry_safe(acpi_gpio, tmp,
>>                    &acpi_gpio_deferred_req_irqs_list,
>>                    deferred_req_irqs_list_entry)
>> -        acpi_gpiochip_request_irqs(acpi_gpio);
>> +            acpi_gpiochip_request_irqs(acpi_gpio);
>> -    acpi_gpio_deferred_req_irqs_done = true;
>> -    mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
>> +        acpi_gpio_deferred_req_irqs_done = true;
>> +        mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
>> +    }
>>       return 0;
>>   }
>>
