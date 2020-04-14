Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E991A7DB2
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgDNNZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:25:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731858AbgDNNYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 09:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586870693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xK5X/B7ag2uXKoGEZNCA7U2ETPUP/XgJDhZI72OQB2Y=;
        b=DoCaXk7/xkegaxE3dCAyd8sCHh9pIVGt8fM6AZXlh5E6jeIzfi8kjcMfAnfxyNnc0+lRsZ
        Ru1W6LK8nsxxvOkpjkwK4xVKGxg1/lhGqU5EMdLBYTlnksgMAh0Zbdb2NFe7+8acsDg8LT
        KyUmcHQFoEjDqR8VT0F2Ck+1baw/BA0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-et3dvU7eMhurWK1ikfNVpw-1; Tue, 14 Apr 2020 09:24:51 -0400
X-MC-Unique: et3dvU7eMhurWK1ikfNVpw-1
Received: by mail-wr1-f72.google.com with SMTP id r11so7624385wrx.21
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 06:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xK5X/B7ag2uXKoGEZNCA7U2ETPUP/XgJDhZI72OQB2Y=;
        b=uV6MRRYn01DOkIwLzTgm4KMbgXjnI0rzIxwS6FiQ+wWH+OchidolgiNDaNjadU6WxN
         Glh+vILnoiCNhXFTI5gwupxaENzofa8P8W/Yc8uadMNahDy58YbaeHb6R3Bjxuc2BGxw
         nX3Jl2uVRggJdL5PUOPwXf/sTV0qfx60CicWnK0euDAPnPlFb/9DTGccve9PaC0InoV4
         HbtiyuOHDIc/COpwn9LujBGOa+WpeJ7tbpxkmH5m4WAIYPLjBn51r7D2mhGYO5wQ7cri
         FUVn6aTZowNHci3r9n6BoazPGEaaCnwgvAiArvDINQH+zJ7lrTuTvv7ZXs68yyJCpomt
         RPcA==
X-Gm-Message-State: AGi0PuZtAJCRcDstE/rwzPFGqej1BQHKqwn0VZJFKjx0sX/1Z62Fdrgk
        f+zN2r2Oiu3xZtLnJYZEqaoXVJ9mzSFURDZ7dCwO7WyMU8UC8vMlJbAFsV6Xz/5gBoSPCE0PNlz
        wUElg2cObMFZVs8jW
X-Received: by 2002:a7b:c2a1:: with SMTP id c1mr22766286wmk.138.1586870690274;
        Tue, 14 Apr 2020 06:24:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ/EVunTSUHM+/VekOfjL62vR964qaRjHEtICG+w1z2Qry21JAfW49aG+MVMwm/rqoz3V4yWg==
X-Received: by 2002:a7b:c2a1:: with SMTP id c1mr22766234wmk.138.1586870689517;
        Tue, 14 Apr 2020 06:24:49 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id b82sm20112230wme.25.2020.04.14.06.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 06:24:48 -0700 (PDT)
Subject: Re: [PATCH] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 3+" <stable@vger.kernel.org>
References: <20200407213058.62870-1-hdegoede@redhat.com>
 <CAKErNvqM9ax8RB+Hm0e70a_uk_Ok3KfSQDmy0q9jKFaAQM3Fsg@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <b876973e-71f4-1dbc-1b41-138f81511685@redhat.com>
Date:   Tue, 14 Apr 2020 15:24:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAKErNvqM9ax8RB+Hm0e70a_uk_Ok3KfSQDmy0q9jKFaAQM3Fsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/8/20 2:11 PM, Maxim Mikityanskiy wrote:
> On Wed, Apr 8, 2020 at 12:31 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Commit 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement
>> irq_set_wake on Bay Trail") stopped passing irq_set_wake requests on to
>> the parents IRQ because this was breaking suspend (causing immediate
>> wakeups) on an Asus E202SA.
>>
>> This workaround for this issue is mostly fine, on most Cherry Trail
>> devices where we need the INT0002 device for wakeups by e.g. USB kbds,
>> the parent IRQ is shared with the ACPI SCI and that is marked as wakeup
>> anyways.
>>
>> But not on all devices, specifically on a Medion Akoya E1239T there is
>> no SCI at all, and because the irq_set_wake request is not passed on to
>> the parent IRQ, wake up by the builtin USB kbd does not work here.
>>
>> So the workaround for the Asus E202SA immediate wake problem is causing
>> problems elsewhere; and in hindsight it is not the correct fix,
>> the Asus E202SA uses Airmont CPU cores, but this does not mean it is a
>> Cherry Trail based device, Brasswell uses Airmont CPU cores too and this
>> actually is a Braswell device.
>>
>> Most (all?) Braswell devices use classic S3 mode suspend rather then
>> s2idle suspend and in this case directly dealing with PME events as
>> the INT0002 driver does likely is not the best idea, so that this is
>> causing issues is not surprising.
>>
>> Replace the workaround of not passing irq_set_wake requests on to the
>> parents IRQ, by not binding to the INT0002 device when s2idle is not used.
>> This fixes USB kbd wakeups not working on some Cherry Trail devices,
>> while still avoiding mucking with the wakeup flags on the Asus E202SA
>> (and other Brasswell devices).
> 
> I tested this patch over kernel 5.6.2 on Asus E202SA and didn't notice
> any regressions. Wakeup by opening lid, by pressing a button on
> keyboard, by USB keyboard — all seem to work fine. So, if appropriate:
> 
> Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>

Thank you for testing this.

> I have a question though. After your patch this driver will basically
> be a no-op on my laptop. Does it mean I don't even need it in the
> first place? What about the IRQ storm this driver is meant to deal
> with — does it never happen on Braswell? What are the reproduction
> steps to verify my hardware is not affected? I have that INT0002
> device, so I'm worried it may cause issues if not bound to the driver.

I do not expect Braswell platforms to suffer from the IRQ storm
issue. That was something which I hit on a Cherry Trail based device.

To test this, try waking up the device from suspend by an USB attached
keyboard (this may not work, in that case wake it some other way).

After this do:

cat /proc/interrupts | grep " 9-fasteoi"

This should output something like this:

[root@localhost ~]# cat /proc/interrupts | grep " 9-fasteoi"
    9:          0          0          0          0   IO-APIC    9-fasteoi   acpi

Repeat this a couple of times, of the numbers after the 9:
increase (very) rapidly you have an interrupt storm. Likely
they will either be fully unchanged or change very slowly.

Note if nothing is output then IRQ 9 is not used on your
model, then the INT0002 device cannot cause an interrupt storm.

Regards,

Hans



> 
>> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
>> Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
>> Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement irq_set_wake on Bay Trail")
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/platform/x86/intel_int0002_vgpio.c | 18 +++++-------------
>>   1 file changed, 5 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
>> index 55f088f535e2..e8bec72d3823 100644
>> --- a/drivers/platform/x86/intel_int0002_vgpio.c
>> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
>> @@ -143,21 +143,9 @@ static struct irq_chip int0002_byt_irqchip = {
>>          .irq_set_wake           = int0002_irq_set_wake,
>>   };
>>
>> -static struct irq_chip int0002_cht_irqchip = {
>> -       .name                   = DRV_NAME,
>> -       .irq_ack                = int0002_irq_ack,
>> -       .irq_mask               = int0002_irq_mask,
>> -       .irq_unmask             = int0002_irq_unmask,
>> -       /*
>> -        * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
>> -        * and we don't want to mess with the ACPI SCI irq settings.
>> -        */
>> -       .flags                  = IRQCHIP_SKIP_SET_WAKE,
>> -};
>> -
>>   static const struct x86_cpu_id int0002_cpu_ids[] = {
>>          INTEL_CPU_FAM6(ATOM_SILVERMONT, int0002_byt_irqchip),   /* Valleyview, Bay Trail  */
>> -       INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_cht_irqchip),      /* Braswell, Cherry Trail */
>> +       INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_byt_irqchip),      /* Braswell, Cherry Trail */
>>          {}
>>   };
>>
>> @@ -181,6 +169,10 @@ static int int0002_probe(struct platform_device *pdev)
>>          if (!cpu_id)
>>                  return -ENODEV;
>>
>> +       /* We only need to directly deal with PMEs when using s2idle */
>> +       if (!pm_suspend_default_s2idle())
>> +               return -ENODEV;
>> +
>>          irq = platform_get_irq(pdev, 0);
>>          if (irq < 0)
>>                  return irq;
>> --
>> 2.26.0
>>
> 

