Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817A014C073
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgA1S56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 13:57:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36804 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgA1S56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 13:57:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580237876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eba3cPslaWVIGys6JOSUIkWNz+RT18HC/DD3SgBIw5A=;
        b=RSM3uDhechJV29vaT8Ft5obM5PKuqb87pc3CZ0lnCWxKy0HbikRlxs8zZiJ04TsQpgHOtk
        aAerx3b2PlyBbpZ7Mw0YsUB1Zzg6DIkpiGbCFvzozMSUZkizLxGPc7jXlBZ11kJbiL1JoG
        ZPEtFghk27lJZxoqttRmoH/CiY200WU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-yTjP4H6GO6abmZkjRn0PcA-1; Tue, 28 Jan 2020 13:57:55 -0500
X-MC-Unique: yTjP4H6GO6abmZkjRn0PcA-1
Received: by mail-wr1-f70.google.com with SMTP id u18so8494477wrn.11
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 10:57:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eba3cPslaWVIGys6JOSUIkWNz+RT18HC/DD3SgBIw5A=;
        b=BDx2bqBZgETQ9LdH5Q6QtnH4yL4cLVi+8Q/qMcArjpLDxWaxGkZl+zHIrB07zk1Kk3
         LHXVoOS91qeeOcj74BgOKJr0WWGTk+495NwLVbPoFYfXvKGGSus74q2y01dH9DUGkUDT
         gEqRssKj51FCPWwBVJShRF1z6fqwaLTABlQ8O+kXUA6hbadn6x0+iPzoCJSvbwqFLuC0
         QNw47fXOQ/82DBV8mDFbXuLgz/LE0RvSwaqeraUQ5vicCCDoxp6l5ypEVq7RwpOK4uwY
         0e4w1yjGkmcxVyjEJbD/u/3iBX92GAenF9ibgkZsT/iM5ksQtNr8MDnm7Zxt14N+uVQE
         OpBw==
X-Gm-Message-State: APjAAAVoR9Ekrk/GPqxbayykFz3A4XU5VtARF6do0HeDWVCU6zbUoB6P
        1MKOBwXxN54ycpJgy1rX9sA/3as5z6AUfCRI7wynaVCk1gdWw8KlvcKt7bo9ZW+GDfDQWP6B+wY
        mPbetyEosbxhG0lv6
X-Received: by 2002:a05:600c:21ce:: with SMTP id x14mr6507705wmj.120.1580237873425;
        Tue, 28 Jan 2020 10:57:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBCCBqrkyam360kWK23MeH1yz+JHFhF5X8j6WFZZcVebBDCP3AheFH7S+MrChctaqyQ3hNzw==
X-Received: by 2002:a05:600c:21ce:: with SMTP id x14mr6507682wmj.120.1580237873170;
        Tue, 28 Jan 2020 10:57:53 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id w13sm27623387wru.38.2020.01.28.10.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 10:57:52 -0800 (PST)
From:   Hans de Goede <hdegoede@redhat.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Thomas Gleixner <tglx@linutronix.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vipul kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <87eevs7lfd.fsf@nanos.tec.linutronix.de>
 <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de>
 <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
Message-ID: <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
Date:   Tue, 28 Jan 2020 19:57:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87ftg5131x.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/24/20 12:55 PM, Thomas Gleixner wrote:
> Hans,
> 
> Hans de Goede <hdegoede@redhat.com> writes:
>> On 1/24/20 9:35 AM, Thomas Gleixner wrote:
>>> Where does that number come from? Just math?
>>
>> Yes just math, but perhaps the Intel folks can see if they can find some
>> datasheet to back this up ?
> 
> Can you observe the issue on one of the machines in your zoo as well?

Ok, I have been testing this on various devices and I'm pretty sure now
that my initial hunch is correct. The problem is that the accuracy of
the FSB frequency as listed in the Intel docs is not so great:

The "Intel 64 and IA-32 Architectures Software Developer’s Manual Volume 4:
Model-Specific Registers" has the following table for the values from
freq_desc_byt:

    000B: 083.3 MHz
    001B: 100.0 MHz
    010B: 133.3 MHz
    011B: 116.7 MHz
    100B: 080.0 MHz

Notice how for e.g the 83.3 MHz value there are 3 significant digits,
which translates to an accuracy of a 1000 ppm, where as your typical
crystal oscillator is 20 - 100 ppm, so the accuracy of the frequency
format used in the Software Developer’s Manual is not really helpful.

So the 00 part of 83300 which I'm suggesting to replace with 33 in
essence is not specified and when the tsc_msr.c code was written /
Bay Trail support was added the value from the datasheet was simply
padded with zeros.

There is already a hint that that likely is not correct in the values
from the Software Developer’s Manual, we have values ending at 3.3,
but also at 6.7, which to me feels like it is 6.66666666666667 rounded
up and thus the 3.3 likely is 3.33333333333333.

Test 1: Intel(R) Celeron(R) CPU  N2840  @ 2.16GHz"
--------------------------------------------------

As said I've also ran some tests. The first device I have tested is
a HP stream 11 x360 with an "Intel(R) Celeron(R) CPU  N2840  @ 2.16GHz"
(from /proc/cpuinfo) this is the "laptop' version of Bay Trail rather
then the tablet version, so like Vipul's case I can comment out the 2
lines setting the TSC_KNOWN_FREQ and TSC_RELIABLE flags and get
"Refined TSC clocksource calibration". I've also added the changes with
the extra pr_info calls which you requested. Here is the relevant output
from a kernel with the 2 flags commented out + your pr_info changes,
note I changed the REF_CLOCK format from %x to %d as that seems easier
to interpret to me.

[    0.000000] MSR_PINFO: 0000060000001a00 -> 26
[    0.000000] MSR_FSBF: 0000000000000000
[    0.000000] REF_CLOCK: 83000
[    0.000000] tsc: Detected 2165.800 MHz processor
[    3.586805] tsc: Refined TSC clocksource calibration: 2166.666 MHz

And with my suggested change:

[    0.000000] MSR_PINFO: 0000060000001a00 -> 26
[    0.000000] MSR_FSBF: 0000000000000000
[    0.000000] REF_CLOCK: 83333
[    0.000000] tsc: Detected 2166.658 MHz processor
[    3.587326] tsc: Refined TSC clocksource calibration: 2166.667 MHz

Note we are still 0.009 MHz of from the refined calibration, so my
suggestion to really fix this would be to change the freqs part
of struct freq_desc to be in Hz rather then KHz and then calculate
res as:

res = DIV_ROUND_CLOSEST(freq * ratio, 1000); /* res is in KHz */

Which would give us:

[    0.000000] tsc: Detected 2166.667 MHz processor


Test 2: "Intel(R) Atom(TM) CPU  Z3736F @ 1.33GHz"
-------------------------------------------------

Second device tested: HP Pavilion x2 Detachable 10" version
with Bay Trail SoC: "Intel(R) Atom(TM) CPU  Z3736F @ 1.33GHz".

Relevant log messages, unpatched:
[    0.000000] MSR_PINFO: 0000060000001000 -> 16
[    0.000000] MSR_FSBF: 0000000000000000
[    0.000000] REF_CLOCK: 83000
[    0.000000] tsc: Detected 1332.800 MHz processor

Patched:
[    0.000000] MSR_PINFO: 0000060000001000 -> 16
[    0.000000] MSR_FSBF: 0000000000000000
[    0.000000] REF_CLOCK: 83333
[    0.000000] tsc: Detected 1333.328 MHz processor

Now since we do not have another clock source, we do not
know for sure that the 1333.328 MHz is better then the
original 1332.800, but it does seem to be a more logical
value; and from the N2840 @ 2.16GHz string, which runs
at 2166.667 MHz we have learned that the number in the
string is rounded down (at least for Bay Trail devices),
so if the 1332.800 MHz where correct then we would
expect the string to contain 1.32GHz, but it says 1.33GHz


Test 3: "Intel(R) Atom(TM) CPU  Z3775  @ 1.46GHz"
-------------------------------------------------

Third device tested: Asus T200TA" with:
"Intel(R) Atom(TM) CPU  Z3775  @ 1.46GHz"
again this is the tablet version, so only one clocksource
and thus no "Refined TSC clocksource calibration"

[    0.000000] MSR_PINFO: 0000040000000b00 -> 11
[    0.000000] MSR_FSBF: 0000000000000002
[    0.000000] REF_CLOCK: 133300
[    0.000000] tsc: Detected 1466.300 MHz processor

Since we have no other clocksource, we cannot be
sure that this is wrong, unless we compare to say
the RTC using using the commands Vipul used to
test. So I'm leaving this device running for say
12 hours and then I'll check.

I have a hunch that in this case too we need to replace the
00 with 33, so use 133333 as ref-clock, but we will see.

Regards,

Hans

