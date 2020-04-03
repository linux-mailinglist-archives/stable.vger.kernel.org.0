Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19C819D9AF
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 17:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404074AbgDCPDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 11:03:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728121AbgDCPDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 11:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585926203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AyMiQZBYNObrGTC5/0a1f5GECR6R9fTBrBZGyOFzxdk=;
        b=CgJOMhnIgW/xffohi/IlMNQc39PGl8L1g7kbNoDH21g+Q/nVb53QrIfE/BU4IYWhRUtbbw
        qibcWdLJq8PqCjB8Nd+bzLA9LeWaMIQD4GuBoblcShINf73vxR2io+4eO4HozI4Idwe4pM
        bXwH37IvyePesafqr0MCT+aRCBP0FB8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-zaXAB7LIN3aKp9SL12aG-A-1; Fri, 03 Apr 2020 11:03:21 -0400
X-MC-Unique: zaXAB7LIN3aKp9SL12aG-A-1
Received: by mail-wm1-f71.google.com with SMTP id s22so2146656wmh.8
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 08:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AyMiQZBYNObrGTC5/0a1f5GECR6R9fTBrBZGyOFzxdk=;
        b=RHJvWRHJvvgRkdFlEqHLObiqUgYclt9dv/pYrUFVOOjFvy105wM80+HNki5HjX5fTs
         anCUkqUnKtLquYUgY9T2lFnA2LR4CPmjWTpLS3M2+9j3qseZcu8farMDH2l2UXckpw6z
         cH3ZhxhIMbTGjPbA2WYH9xnMa7VLPjmMhWFQYc6sDtcXid68fZVNCEdltP8vRHXVxur0
         b16wfWbMRo1abWfkfFzNgrDygNXy9n9uTUT3DlFsmAG6i2cvYYcPIf/hGuG8S2zbQw+Z
         55Qg6GjvDOvWuCsGDwH6weKWWLErhHgjUzu9F43qBG1f6h44UluJq4ikbYxhXeJb/hg4
         adbg==
X-Gm-Message-State: AGi0PuYdFG9oFlL6hCl3t6DYzE/wPOVc1Ukp1xUpKhQCUtNJWVZbv5iN
        9I8D/7x3HvCYYCbn8LcscOQQ2GrcoVn9Dw6fZeCvRyrU7nYLpo0RMBGceiq03ubQDoF3CTj3v2g
        rzpTtwhyFI6YpiJoE
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr10004951wrs.132.1585926200163;
        Fri, 03 Apr 2020 08:03:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypKRAL+3/jSICo54b+5w03Rl9FI4HrOdsnmfDTGRCDp1bwdcrlu1b5fzPMA6R6d27iYl+ZX8Qw==
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr10004919wrs.132.1585926199965;
        Fri, 03 Apr 2020 08:03:19 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id 189sm12149137wme.31.2020.04.03.08.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 08:03:19 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] platform/x86: intel_int0002_vgpio: Use
 acpi_register_wakeup_handler()
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 4+" <stable@vger.kernel.org>
References: <20200403105235.105187-1-hdegoede@redhat.com>
 <20200403105235.105187-2-hdegoede@redhat.com>
 <CAJZ5v0gcRgTTRfCKHS00y599NBhWPgAYQF0RfFo6-vDegYA6Eg@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <873c0209-c335-a9fe-d17b-b8e089bdcc04@redhat.com>
Date:   Fri, 3 Apr 2020 17:03:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0gcRgTTRfCKHS00y599NBhWPgAYQF0RfFo6-vDegYA6Eg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/3/20 3:25 PM, Rafael J. Wysocki wrote:
> On Fri, Apr 3, 2020 at 12:52 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> The Power Management Events (PMEs) the INT0002 driver listens for get
>> signalled by the Power Management Controller (PMC) using the same IRQ
>> as used for the ACPI SCI.
>>
>> Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
>> waking up the system") the SCI triggering, without there being a wakeup
>> cause recognized by the ACPI sleep code, will no longer wakeup the system.
>>
>> This breaks PMEs / wakeups signalled to the INT0002 driver, the system
>> never leaves the s2idle_loop() now.
>>
>> Use acpi_register_wakeup_handler() to register a function which checks
>> the GPE0a_STS register for a PME and trigger a wakeup when a PME has
>> been signalled.
>>
>> With this new mechanism the pm_wakeup_hard_event() call is no longer
>> necessary, so remove it and also remove the matching device_init_wakeup()
>> calls.
>>
>> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
>> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Adjust for the wakeup-handler registration function being renamed to
>>    acpi_register_wakeup_handler()
>> ---
>>   drivers/platform/x86/intel_int0002_vgpio.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
>> index f14e2c5f9da5..9da19168b4f6 100644
>> --- a/drivers/platform/x86/intel_int0002_vgpio.c
>> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
>> @@ -122,11 +122,17 @@ static irqreturn_t int0002_irq(int irq, void *data)
>>          generic_handle_irq(irq_find_mapping(chip->irq.domain,
>>                                              GPE0A_PME_B0_VIRT_GPIO_PIN));
>>
>> -       pm_wakeup_hard_event(chip->parent);
>> -
> 
> If the event occurs before the "noirq" phase of suspending devices, it
> can be missed with this change AFAICS.
> 
>>          return IRQ_HANDLED;
>>   }
>>
>> +static bool int0002_check_wake(void *data)
>> +{
>> +       u32 gpe_sts_reg;
>> +
>> +       gpe_sts_reg = inl(GPE0A_STS_PORT);
>> +       return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
>> +}
>> +
>>   static struct irq_chip int0002_byt_irqchip = {
>>          .name                   = DRV_NAME,
>>          .irq_ack                = int0002_irq_ack,
>> @@ -220,13 +226,13 @@ static int int0002_probe(struct platform_device *pdev)
>>                  return ret;
>>          }
>>
>> -       device_init_wakeup(dev, true);
>> +       acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);
> 
> So I would just add the wakeup handler registration here.

Ok, will fix for the upcoming v3 of the series.

Regards,

Hans



> 
>>          return 0;
>>   }
>>
>>   static int int0002_remove(struct platform_device *pdev)
>>   {
>> -       device_init_wakeup(&pdev->dev, false);
>> +       acpi_unregister_wakeup_handler(int0002_check_wake, NULL);
>>          return 0;
>>   }
>>
>> --
> 

