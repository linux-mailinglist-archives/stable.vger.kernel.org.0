Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3BDD1A17F4
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 00:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgDGWX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 18:23:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25403 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726530AbgDGWX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 18:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586298237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jL2SlKj1gk+SXatVva+PLT8Nc9hxvdVqnXrq13Ge/nc=;
        b=GxB+IU+x38mC86nTE0jI4LoFYnazKcibew/CBNfdJDn2NbEoq7y51VFPHahhTn3sJtcLFg
        kznp3UFfMuVg1gQWkKltIFaum/IEY02pdTL7PisSwSuVdDEZrG5wx9UXk389tBk6MknvpG
        Agaqir9crLSdwbQHC2hoc+nAInqKuQs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-P7ChDPc8PMWHZXrhysIDrQ-1; Tue, 07 Apr 2020 18:23:56 -0400
X-MC-Unique: P7ChDPc8PMWHZXrhysIDrQ-1
Received: by mail-wr1-f72.google.com with SMTP id n7so2940662wru.9
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 15:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jL2SlKj1gk+SXatVva+PLT8Nc9hxvdVqnXrq13Ge/nc=;
        b=Hyrw4FMgSDtdg8ecZdMoeH8hXupmQiYto2zOnnqUh+IZtPkjKeVqiMlVH9ocfXbx+g
         gel6gw6gYFbkugCEyW+hN0iUt6F+X7Y0KPUpUQ6atn61gjBOwhSFLzQXOIQzn5I/ol5j
         kbkAoexlGmuhrfAE0AJ/YGGCl3Gn/E5BHyXGqOH9Bc0gS9FaZemHWe3MRwaHrWzGrVOU
         iqrBir4Fk8D97vDBbTAH+GgxkXaubjhwunVxy/arE1maAFoPFtII1hZciPb3/s9zuUPh
         zsya4DYFJ5GWrdvRTA5Ybs/gmtbk0vi/BVt1bh2MfZNc3fRTgfyzyGTNsOqjEA1Qiq+g
         1naQ==
X-Gm-Message-State: AGi0PuYeqYTZSkSkh1xbjjKiwVrk34/BJSAcD6KFbNL6fQQ3YZ2uwiBV
        zpDqSBc50X0zvlk7Z9Q8sC+WW+85P0cb1R7k5fpQsFpsOwJisB+Z408vmHtfkkJ1MdB8Om9BgOK
        yXH4mK2lt43CfX84u
X-Received: by 2002:adf:9168:: with SMTP id j95mr4723925wrj.145.1586298234906;
        Tue, 07 Apr 2020 15:23:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypL4WQ5BTkhOmSbeGTJVlGkzsuoHwtVtlTLcOKyFI5IwdvkPb/QQ9R8igODcabSrxvjJdF+oNQ==
X-Received: by 2002:adf:9168:: with SMTP id j95mr4723914wrj.145.1586298234661;
        Tue, 07 Apr 2020 15:23:54 -0700 (PDT)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id h81sm4565064wme.42.2020.04.07.15.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:23:54 -0700 (PDT)
Subject: Re: [PATCH] platform/x86: intel_int0002_vgpio: Only bind to the
 INT0002 dev when using s2idle
To:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        "5 . 3+" <stable@vger.kernel.org>
References: <20200407213058.62870-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <cfd3171a-94fb-7382-28e1-a236cb6759cc@redhat.com>
Date:   Wed, 8 Apr 2020 00:23:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407213058.62870-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I just realized that I should have added a cover letter to this
patch to discuss how to merge it.

Rafael has already queued up the
"[PATCH v3 2/2] platform/x86: intel_int0002_vgpio: Use acpi_register_wakeup_handler()"
in his tree. Looking at both patches the parts of the file the
touch are different enough that that should not be a problem though.

So I guess this can go through platform/x86 as usual, or
(assuming everyone is ok with the change itself) alternatively
Rafael can take it to make sure there will be no conflicts?

Regards,

Hans


On 07-04-2020 23:30, Hans de Goede wrote:
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
> parents IRQ, by not binding to the INT0002 device when s2idle is not used.
> This fixes USB kbd wakeups not working on some Cherry Trail devices,
> while still avoiding mucking with the wakeup flags on the Asus E202SA
> (and other Brasswell devices).
> 
> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
> Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
> Fixes: 871f1f2bcb01 ("platform/x86: intel_int0002_vgpio: Only implement irq_set_wake on Bay Trail")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>   drivers/platform/x86/intel_int0002_vgpio.c | 18 +++++-------------
>   1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
> index 55f088f535e2..e8bec72d3823 100644
> --- a/drivers/platform/x86/intel_int0002_vgpio.c
> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
> @@ -143,21 +143,9 @@ static struct irq_chip int0002_byt_irqchip = {
>   	.irq_set_wake		= int0002_irq_set_wake,
>   };
>   
> -static struct irq_chip int0002_cht_irqchip = {
> -	.name			= DRV_NAME,
> -	.irq_ack		= int0002_irq_ack,
> -	.irq_mask		= int0002_irq_mask,
> -	.irq_unmask		= int0002_irq_unmask,
> -	/*
> -	 * No set_wake, on CHT the IRQ is typically shared with the ACPI SCI
> -	 * and we don't want to mess with the ACPI SCI irq settings.
> -	 */
> -	.flags			= IRQCHIP_SKIP_SET_WAKE,
> -};
> -
>   static const struct x86_cpu_id int0002_cpu_ids[] = {
>   	INTEL_CPU_FAM6(ATOM_SILVERMONT, int0002_byt_irqchip),	/* Valleyview, Bay Trail  */
> -	INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_cht_irqchip),	/* Braswell, Cherry Trail */
> +	INTEL_CPU_FAM6(ATOM_AIRMONT, int0002_byt_irqchip),	/* Braswell, Cherry Trail */
>   	{}
>   };
>   
> @@ -181,6 +169,10 @@ static int int0002_probe(struct platform_device *pdev)
>   	if (!cpu_id)
>   		return -ENODEV;
>   
> +	/* We only need to directly deal with PMEs when using s2idle */
> +	if (!pm_suspend_default_s2idle())
> +		return -ENODEV;
> +
>   	irq = platform_get_irq(pdev, 0);
>   	if (irq < 0)
>   		return irq;
> 

