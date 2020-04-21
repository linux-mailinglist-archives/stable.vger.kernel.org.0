Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81251B276F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 15:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgDUNS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 09:18:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728479AbgDUNSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 09:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587475098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g7gI8fb6o6LKlf8vISbpJtZJf7jBBUPaOiqBddbrn1E=;
        b=FZSd0Tfwup2GpS49a2qMUt9WRIQB+Ter7YwrwFMFhyka0Cj+K3XlbGxWZi3RaMLQpmUaRR
        lCv3CqXF/i6VK0/geW8MvxHprfm+RZQo3gloJn/BTwYoe+0ea5QKmgzd5HMVS31wTMmkp/
        dutgrvLanAB3785Zb6aVDC3mdOhbbUQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-Ftnh42BTNteKnBSQKvX2nw-1; Tue, 21 Apr 2020 09:18:17 -0400
X-MC-Unique: Ftnh42BTNteKnBSQKvX2nw-1
Received: by mail-wr1-f72.google.com with SMTP id j22so7517356wrb.4
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 06:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g7gI8fb6o6LKlf8vISbpJtZJf7jBBUPaOiqBddbrn1E=;
        b=Q43NH069Nrp0gvxQQP+bzdJuqEKf0hSmTIteg9IOHy9/NHcn9zGGbHgnYHdjq2s7AH
         fWodo3qFZ6AhXJke6mUG0dXn42aUDL9CIfFKUVf1T6MgwEnndvTZ7Glu2CHCSzU7reRR
         /GBdFbtWXH/JyK4KnS2jnKpCFRoqOEeRIpexs4zILD0GMVRnU//eE6Nib2wyi1eMlth6
         NNwHqBNNvfPPLO2Udqc9Mi0qo5a8t0qnHXRwk4/FYFrx2FhRvB+X+a6rFXGS2zuJWJ4T
         MXH/yKtoCTODbugTEEZ0gzi0+j6t+Xox856DJqHRf0UsOvPFi6JQ7j2k7kMuq3sW+Yqc
         5xgQ==
X-Gm-Message-State: AGi0PubXdE2BBsDSZyID2Ds4quJdmfs31YQ2RTcA/ofWoOVG7UENNy+w
        UpRhJSBBUHAtwMM1F0YzU9mM4pKuZfBIo6c3fEFcwPu1I005jm17X0OBb5sfTbD0BMY2ZyL+TI3
        eoAru4K+jE7c891DG
X-Received: by 2002:a1c:32c7:: with SMTP id y190mr5179329wmy.13.1587475095510;
        Tue, 21 Apr 2020 06:18:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypJOo/12F9ol8UfBE3egEGUQetFBzPEkWc2rpUqQFmDVtIeQhiFoZGNO+C0Ad/Gn0F+CkJNmwQ==
X-Received: by 2002:a1c:32c7:: with SMTP id y190mr5179300wmy.13.1587475095124;
        Tue, 21 Apr 2020 06:18:15 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id s30sm3800805wrb.67.2020.04.21.06.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:18:14 -0700 (PDT)
Subject: Re: [PATCH v2] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        "5 . 3+" <stable@vger.kernel.org>
References: <20200414131953.131533-1-hdegoede@redhat.com>
 <4380034.KJPSqyn9gG@kreacher>
 <a9c4b315-2784-fe59-1236-3e3bf391fd4c@redhat.com>
 <15138701.54mejVaKjr@kreacher>
 <6e85613c-e129-831a-bbe8-9f0c4f9fadad@redhat.com>
Message-ID: <9683ad9e-5969-5f22-74cb-fed232437b35@redhat.com>
Date:   Tue, 21 Apr 2020 15:18:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6e85613c-e129-831a-bbe8-9f0c4f9fadad@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/16/20 11:00 AM, Hans de Goede wrote:
> Hi,
> 
> On 4/15/20 11:34 PM, Rafael J. Wysocki wrote:
>> On Wednesday, April 15, 2020 11:48:20 AM CEST Hans de Goede wrote:
>>> Hi,
>>>
>>> On 4/15/20 11:45 AM, Rafael J. Wysocki wrote:
>>>> On Tuesday, April 14, 2020 3:19:53 PM CEST Hans de Goede wrote:
>>>>> Commit 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement
>>>>> irq_set_wake on Bay Trail") stopped passing irq_set_wake requests on to
>>>>> the parents IRQ because this was breaking suspend (causing immediate
>>>>> wakeups) on an Asus E202SA.
>>>>>
>>>>> This workaround for this issue is mostly fine, on most Cherry Trail
>>>>> devices where we need the INT0002 device for wakeups by e.g. USB kbds,
>>>>> the parent IRQ is shared with the ACPI SCI and that is marked as wakeup
>>>>> anyways.
>>>>>
>>>>> But not on all devices, specifically on a Medion Akoya E1239T there is
>>>>> no SCI at all, and because the irq_set_wake request is not passed on to
>>>>> the parent IRQ, wake up by the builtin USB kbd does not work here.
>>>>>
>>>>> So the workaround for the Asus E202SA immediate wake problem is causing
>>>>> problems elsewhere; and in hindsight it is not the correct fix,
>>>>> the Asus E202SA uses Airmont CPU cores, but this does not mean it is a
>>>>> Cherry Trail based device, Brasswell uses Airmont CPU cores too and this
>>>>> actually is a Braswell device.
>>>>>
>>>>> Most (all?) Braswell devices use classic S3 mode suspend rather then
>>>>> s2idle suspend and in this case directly dealing with PME events as
>>>>> the INT0002 driver does likely is not the best idea, so that this is
>>>>> causing issues is not surprising.
>>>>>
>>>>> Replace the workaround of not passing irq_set_wake requests on to the
>>>>> parents IRQ, by not binding to the INT0002 device when s2idle is not used.
>>>>> This fixes USB kbd wakeups not working on some Cherry Trail devices,
>>>>> while still avoiding mucking with the wakeup flags on the Asus E202SA
>>>>> (and other Brasswell devices).
>>>>>
>>>>> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
>>>>> Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
>>>>> Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement irq_set_wake on Bay Trail")
>>>>> Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>> ---
>>>>> Changes in v2:
>>>>> - Rebase on top of 5.7-rc1
>>>>> ---
>>>>>    drivers/platform/x86/intel_int0002_vgpio.c | 18 +++++-------------
>>>>>    1 file changed, 5 insertions(+), 13 deletions(-)
>>>>>
>>>>> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
>>>>> index 289c6655d425..30806046b664 100644
>>>>> --- a/drivers/platform/x86/intel_int0002_vgpio.c
>>>>> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
>>>>> @@ -143,21 +143,9 @@ static struct irq_chip int0002_byt_irqchip = {
>>>>>        .irq_set_wake        = int0002_irq_set_wake,
>>>>>    };
>>>>> -static struct irq_chip int0002_cht_irqchip = {
>>>>> -    .name            = DRV_NAME,
>>>>> -    .irq_ack        = int0002_irq_ack,
>>>>> -    .irq_mask        = int0002_irq_mask,
>>>>> -    .irq_unmask        = int0002_irq_unmask,
>>>>> -    /*
>>>>> -     * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
>>>>> -     * and we don't want to mess with the ACPI SCI irq settings.
>>>>> -     */
>>>>> -    .flags            = IRQCHIP_SKIP_SET_WAKE,
>>>>> -};
>>>>> -
>>>>>    static const struct x86_cpu_id int0002_cpu_ids[] = {
>>>>>        X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,    &int0002_byt_irqchip),
>>>>> -    X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,    &int0002_cht_irqchip),
>>>>> +    X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,    &int0002_byt_irqchip),
>>>>>        {}
>>>>>    };
>>>>> @@ -181,6 +169,10 @@ static int int0002_probe(struct platform_device *pdev)
>>>>>        if (!cpu_id)
>>>>>            return -ENODEV;
>>>>> +    /* We only need to directly deal with PMEs when using s2idle */
>>>>> +    if (!pm_suspend_default_s2idle())
>>>>> +        return -ENODEV;
>>>>> +
>>>>
>>>> What if the system supports s2idle which is not the default suspend option
>>>> and then it is selected by user space (overriding the default)?
>>>
>>> This driver only binds (the cpuid check still visible above) on Bay Trail
>>> and Cherry Trail/Brasswell systems. AFAIK those never support both modes,
>>> the laptop variants of these SoCs always use S3 and the tablet versions
>>> always use s2idle.
>>
>> But this means that at least the laptop variants can use s2idle if users choose
>> that option.
> 
> I was under the impression that the laptop variants only supported S3,
> butyou are right they support both.
> 
> Still I believe that the intent of this patch is right as is. The
> laptop variants are much more like standard X86 devices then the
> tablet devices.
> 
> E.g. they use standard HDA for audio instead of ASoC, the always use
> the ACPI ac and battery drivers instead of needing native PMIC drivers,
> etc.  Basically the tablet variants are a lot more like SoCs from other
> (ARM) vendors, so they need some special handling.  I consider the
> (undocumented, lifted from android-x86) INT0002 / special manual poking
> of PMC GPE registers to also be part of the tablet variant special
> sauce.
> 
> My intent of the pm_suspend_default_s2idle() check really is to
> check for the tablet variant. As Maxim's regression on the laptop
> (aka normal x86 machine) variant has shown doing the manual
> poking there seems to be a bad idea.
> 
> So I guess I need to rewrite this patch to better match my original
> intent. Does anyone have any ideas how to check it we are dealing
> with the tablet variant ?  One option would be to see if s2idle
> is supported, while S3 is not supported. Rafael any idea how to
> neatly check for those conditions ?   Anyone else an idea to
> more directly check if we are running on a tablet version ?
> 
>> Switching over from S3 to s2idle and back needs to be supported.
> 
> Ack, but even for the laptop variant s2idle path I believe that
> letting the INT0002 driver bind and poke PMC GPE registers
> directly is a bad idea.

Ping? I'll happily rework this patch to replace the s2idle check
with an are we running on a tablet version of the SoC check,
but I could use some input on how exactly to detect that we
are running on a tablet version of the SoC.

Regards,

Hans

