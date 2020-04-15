Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D924A1A9942
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 11:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895815AbgDOJsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 05:48:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49467 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2895810AbgDOJs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 05:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586944105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ug9COLY/YhK3wDyJaFP4QjMwRSRIqTSu+CJpF4CbDvs=;
        b=W0mSPiX1HNkIxgOKDKczZcJy2D9DT9NCkLN/MiUqsMJ+nSnl7nXFbdfPEyUPkhzhrhYdvr
        RJ92i0sGhgYrdhVuMbA5U2bQkxDOdMGGvjUFzEq3JAP54BQAo/GBvizjJlpG9xXuH3biPQ
        ByY0Y44IhBQkaB7sQ4K/PlMU7GoRU3M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-qf7aqgBdPVy5NOUqnhwzQA-1; Wed, 15 Apr 2020 05:48:24 -0400
X-MC-Unique: qf7aqgBdPVy5NOUqnhwzQA-1
Received: by mail-wm1-f70.google.com with SMTP id 72so7502286wmb.1
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 02:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ug9COLY/YhK3wDyJaFP4QjMwRSRIqTSu+CJpF4CbDvs=;
        b=cAJPv9gWX5ti2y+maGcF6hEPc4klZSsgZjIiE7Hai/sPjdrODHR8nXYk3aCLGA+dny
         UXtYVk3EYwMhI5qU4G9gcNCU2X2hidq51XU7MrY/Io0aLRYnbuo0WjtqxlmakLZPx/7f
         i8wkgKmMWSHptYtTPMZfyHWvSKAQrvlkys43xyviTdvVPpY8vSW/dxfyxgHREfsBS27w
         xXttV9hMJwcfPBGjDTBHvzSfrNB0Qvio2wnuNlr9RMkvhbav7cjzLkd0eRRyD7wZwpY4
         5IP6K/kfaarOPmVSfez+D1739G64s0QAHnbd0zSatL4ly0DMSxPyzFZrVr7SJmn5PLiN
         DXCA==
X-Gm-Message-State: AGi0PuaIqlhbLp3Jte5YV7Ng2/4TyY8oxUhaCdn3RvGOsaQGkbkG90f3
        /PGLzYHrCPFVsSEIjQos33SLy50Nq/f//IF1C2MzxO7iksOPDFau+/Om4oey9FkoSaQqsmrnVYE
        wKTQaIkQ1aZv0VhZf
X-Received: by 2002:a1c:9e43:: with SMTP id h64mr4291791wme.0.1586944102147;
        Wed, 15 Apr 2020 02:48:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypKUG80qfuOm5k54Q2sYK5dSgdmjv0kwB06qovoaM2PgbZClDJCAYTf/jozp54s3aKzh8FISyQ==
X-Received: by 2002:a1c:9e43:: with SMTP id h64mr4291777wme.0.1586944101909;
        Wed, 15 Apr 2020 02:48:21 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id v21sm21528522wmj.8.2020.04.15.02.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 02:48:21 -0700 (PDT)
Subject: Re: [PATCH v2] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        "5 . 3+" <stable@vger.kernel.org>
References: <20200414131953.131533-1-hdegoede@redhat.com>
 <4380034.KJPSqyn9gG@kreacher>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <a9c4b315-2784-fe59-1236-3e3bf391fd4c@redhat.com>
Date:   Wed, 15 Apr 2020 11:48:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <4380034.KJPSqyn9gG@kreacher>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/15/20 11:45 AM, Rafael J. Wysocki wrote:
> On Tuesday, April 14, 2020 3:19:53 PM CEST Hans de Goede wrote:
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
>>
>> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
>> Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
>> Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement irq_set_wake on Bay Trail")
>> Tested-by: Maxim Mikityanskiy <maxtram95@gmail.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Rebase on top of 5.7-rc1
>> ---
>>   drivers/platform/x86/intel_int0002_vgpio.c | 18 +++++-------------
>>   1 file changed, 5 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
>> index 289c6655d425..30806046b664 100644
>> --- a/drivers/platform/x86/intel_int0002_vgpio.c
>> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
>> @@ -143,21 +143,9 @@ static struct irq_chip int0002_byt_irqchip = {
>>   	.irq_set_wake		= int0002_irq_set_wake,
>>   };
>>   
>> -static struct irq_chip int0002_cht_irqchip = {
>> -	.name			= DRV_NAME,
>> -	.irq_ack		= int0002_irq_ack,
>> -	.irq_mask		= int0002_irq_mask,
>> -	.irq_unmask		= int0002_irq_unmask,
>> -	/*
>> -	 * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
>> -	 * and we don't want to mess with the ACPI SCI irq settings.
>> -	 */
>> -	.flags			= IRQCHIP_SKIP_SET_WAKE,
>> -};
>> -
>>   static const struct x86_cpu_id int0002_cpu_ids[] = {
>>   	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,	&int0002_byt_irqchip),
>> -	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&int0002_cht_irqchip),
>> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,	&int0002_byt_irqchip),
>>   	{}
>>   };
>>   
>> @@ -181,6 +169,10 @@ static int int0002_probe(struct platform_device *pdev)
>>   	if (!cpu_id)
>>   		return -ENODEV;
>>   
>> +	/* We only need to directly deal with PMEs when using s2idle */
>> +	if (!pm_suspend_default_s2idle())
>> +		return -ENODEV;
>> +
> 
> What if the system supports s2idle which is not the default suspend option
> and then it is selected by user space (overriding the default)?

This driver only binds (the cpuid check still visible above) on Bay Trail
and Cherry Trail/Brasswell systems. AFAIK those never support both modes,
the laptop variants of these SoCs always use S3 and the tablet versions
always use s2idle.

Regards,

Hans

