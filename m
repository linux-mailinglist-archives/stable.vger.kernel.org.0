Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671CD14D7FB
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 09:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgA3Iyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 03:54:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43012 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726882AbgA3Iyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 03:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580374493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=McUOstczDURx7+qr2WYD4xlhpvzGM+i25AylL9C8fxU=;
        b=LilIbMPmmEdb8zTC2e4sdQsEgMJQWx5RXrLiXBKa9LxyuyqKl2yWM+n2j9vCKqm6J9iBWH
        P9JBRZxyxB8xKfJEHKWKjhWldiL3gIffqXZCNTk4FGP0F4qm+ByKQudXeCyTf/IWck37qk
        Fz9zOAi9gm0aveFygj5kKrrqf04WyPs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-TWlo19sNM0-9c7VVH_QhOw-1; Thu, 30 Jan 2020 03:54:52 -0500
X-MC-Unique: TWlo19sNM0-9c7VVH_QhOw-1
Received: by mail-wr1-f70.google.com with SMTP id 50so525940wrc.2
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 00:54:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=McUOstczDURx7+qr2WYD4xlhpvzGM+i25AylL9C8fxU=;
        b=cJikIjEaZBukliY3Yskz116Z1QtpOYmSiJnHEmDiuTcWypBrAPlJK6dy7w481FHESq
         Z6wDnLmqQLvHPYVCccqu4+FhNMJrD+EIFw0K9GNIbgcyv5QBfRyLYKLOGdvEKhaSM6dT
         gcY6oA0BQUDPS1NxNAWLUvE5IKx1EFeJo67+i0MSSaFZBrMbCEvitv5Sm56ZVnhT0pnX
         AFwN7pvVha9/ZHnxzUwtKuSjeBaRVxrTFbVLD4ftv3MY+dTpkEqZcTLbTwRVbv71Q+MO
         XBJfK5ScbICsKLSLYCL+zw1ijFHtnJqVpR0mDkJe6wgrmnyJs95ntfDf5wHK3M6taSue
         sexQ==
X-Gm-Message-State: APjAAAVNRSekgtZrTFawiCWqV1rFROhBxrXs2jY3CevbsZ0tlP1c4wqc
        yeK8WiGLaXXdCyqGUo7XGeuNlVm/dU+JMv8AxCv3w/HX/NAZv2IDcaS57VHv3w6Wx1GaewpC5ZL
        OfSDq3cA81N0fLbIh
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr4055618wru.411.1580374490784;
        Thu, 30 Jan 2020 00:54:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7l4/qetA7mM3/W77rIZPXQCj4tC20wiML4nw+/k8ozF7BR/mBC5OAwbYAUqSbPMVN8FAFNw==
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr4055581wru.411.1580374490551;
        Thu, 30 Jan 2020 00:54:50 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id y8sm5334392wma.10.2020.01.30.00.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 00:54:49 -0800 (PST)
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
 <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
 <87sgjz434v.fsf@nanos.tec.linutronix.de>
 <20200129130350.GD32742@smile.fi.intel.com>
 <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com>
 <20200129141444.GE32742@smile.fi.intel.com>
 <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com>
 <87imku2t3w.fsf@nanos.tec.linutronix.de>
 <20200129155353.GI32742@smile.fi.intel.com>
 <87a7662d7l.fsf@nanos.tec.linutronix.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <990e69fc-c4d4-a40b-34bc-4ee4aab06970@redhat.com>
Date:   Thu, 30 Jan 2020 09:54:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87a7662d7l.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 29-01-2020 21:57, Thomas Gleixner wrote:
> Andy,
> 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
>> On Wed, Jan 29, 2020 at 04:13:39PM +0100, Thomas Gleixner wrote:
>>> Andy, can you please make sure that people inside Intel who can look
>>> into the secrit documentation confirm what we are aiming for?
>>>
>>> Ideally they should provide the X-tal frequency and the mult/div pair
>>> themself :)
>>
>> So, I don't have access to the CPU core documentation (and may be will not be
>> given), nevertheless I dug a bit to what I have for Cherrytrail. So, the XTAL
>> is 19.2MHz, which becomes 100MHz and 1600MHz by some root PLL, then, the latter
>> two frequencies are being used by another PLL to provide a reference clock (*)
>> to PLL which derives CPU clock.
>>
>> *) According to colleagues of mine it's a fixed rate source.
>>
>> That's all what I have.
> 
> I'm surely not blaming you for this, you're just the messenger.
> 
> Just to make it entirely clear. We are wasting days already due to the
> fact that Intel, who designs, specifies and most importantly sells these
> CPUs is either unable or unwilling to provide accurate information about
> the trivial and essential information to support these CPUs:
> 
>      1) The crystal frequency
> 
>      2) The nominator/denominator pair to calculate the TSC frequency
>         from #1
> 
> The numbers which are in the kernel have been provided by Intel, but
> they are inaccurate as we have proven.
> 
> Sure, we can reverse engineer the exact numbers assumed that we have
> access to all variants of affected devices and enough spare time to
> waste.
> 
> But why should we do that?
> 
> Intel has the exact numbers at their fingertip and is just not providing
> them for whatever reasons (I really don't want to know).
> 
> So instead of wasting our precious time further, I'm going to apply the
> patch below unless Intel comes forth with the information they should
> have provided many years ago.

Thomas, although I fully agree with your sentiment here, especially since
I've been spending pretty much the entirety of my day on this for the last
2 days, I do not think such a patch would be of great service to our end-users...

Between your initial "model the PLL" idea and Andy's provided info I've
come up with a patch which although not pretty I believe addresses this.

I'm running some final tests now and then I will post the patch series
for this upstream.

Regards,

Hans






> 
> Thanks,
> 
>          tglx
> 
> 8<--------------
>   arch/x86/kernel/tsc_msr.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> --- a/arch/x86/kernel/tsc_msr.c
> +++ b/arch/x86/kernel/tsc_msr.c
> @@ -73,6 +73,13 @@ static const struct x86_cpu_id tsc_msr_c
>   	{}
>   };
>   
> +static char msr_warning[] = \
> +	"The TSC/APIC timer frequency for your CPU is guesswork.\n\n"	\
> +	"It is derived from frequency tables provided by Intel.\n"	\
> +	"These tables are demonstrably inaccurate, but Intel is\n"	\
> +	"either unable or unwilling to provide the correct data.\n"	\
> +	"Please report this to Intel and not on LKML.\n";
> +
>   /*
>    * MSR-based CPU/TSC frequency discovery for certain CPUs.
>    *
> @@ -90,6 +97,8 @@ unsigned long cpu_khz_from_msr(void)
>   	if (!id)
>   		return 0;
>   
> +	WARN_ONCE(1, "%s\n", msr_warning);
> +
>   	freq_desc = (struct freq_desc *)id->driver_data;
>   	if (freq_desc->msr_plat) {
>   		rdmsr(MSR_PLATFORM_INFO, lo, hi);
> 

