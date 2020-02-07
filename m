Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0B81553BB
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 09:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgBGIcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 03:32:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41796 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726901AbgBGIcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 03:32:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581064324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h5PxoGF4lW28Wv4+q/wL0t8wnMQQso1jdOdEBv/C2U8=;
        b=E9itMJQq4quKnJtGiXPA0VypiUwKEuf+OBCpCgiVB+7e4vJBhME6tG/GnP+mCB9qRZB+jH
        DOOar+OGvDnH5swcrVfizL15aBxvdGuxAV/0KILmU1WP5byMbb/s3Ei5Z6u7Nfua/EJWg7
        gGibZ3JBa4EhUPt2W4fiuUBOF8JuEBo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-W1w4wT-pPgCutBlNQKEp4Q-1; Fri, 07 Feb 2020 03:32:02 -0500
X-MC-Unique: W1w4wT-pPgCutBlNQKEp4Q-1
Received: by mail-wm1-f71.google.com with SMTP id s25so405343wmj.3
        for <stable@vger.kernel.org>; Fri, 07 Feb 2020 00:32:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h5PxoGF4lW28Wv4+q/wL0t8wnMQQso1jdOdEBv/C2U8=;
        b=Ofja62DgWQlg28BFBrrEkpno0qUHCKfi5lZmIWmZvYkpAqkUaopt4wJzMAUPrOt4nD
         F0DEoXRfZrIdqQ75lYOsTiCSOS3YtOQzZxFo1dYKXr3fy4ZnmFiiUKSY5mKNcOL9INeM
         buITg2XvWhTKslYOLj87QYQ0z3lJg0csGaOwaYl1n/lqXMDoLQX38mfDJ/cmEcuso/AL
         odNsmxnlORmCpPrWUvHLbClVhjND6arnWM//avXpBEJ1e+yuxwQUlNgOwuV0ICxyMYwB
         1g1ERlx5apK19ZIa/GhWl9QFV9+l9CPxFj27nZCDNNDm3MsxJV11FhWachAH99HUy4H3
         CXyg==
X-Gm-Message-State: APjAAAXIb7amsIcMJbUM+iU8099ftndsD08zPXsSuO0MJtuTdI4U5egp
        8bxOIr7LlZ3GvuuDqQOyZKRlyp3N3YJ5+wjCnVuTOQrb1KPvPOU0XAbl0cT73a/WA4WtQnyEgw8
        1J1iH6X5d29SuGKCR
X-Received: by 2002:a5d:5283:: with SMTP id c3mr3434104wrv.148.1581064321175;
        Fri, 07 Feb 2020 00:32:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqwvVIpbfaRt4igrDmgOFpT6SET1fiC7v1wNzmTDIH5FVWwod2izKvg3ymP0O9zwHuWYdtuxQA==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr3434065wrv.148.1581064320898;
        Fri, 07 Feb 2020 00:32:00 -0800 (PST)
Received: from x1.localdomain ([109.36.130.245])
        by smtp.gmail.com with ESMTPSA id q1sm2513114wrw.5.2020.02.07.00.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 00:32:00 -0800 (PST)
From:   Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20200205153428.437087-1-hdegoede@redhat.com>
 <20200205153428.437087-4-hdegoede@redhat.com>
 <CAHp75Vfc=LN+_iDLDZ2s-i-q6tZ-K_FV7hqAcH6fhwBA9-AHUQ@mail.gmail.com>
Message-ID: <b6c1e57e-8001-19f1-7f37-7a5975e565d6@redhat.com>
Date:   Fri, 7 Feb 2020 09:31:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAHp75Vfc=LN+_iDLDZ2s-i-q6tZ-K_FV7hqAcH6fhwBA9-AHUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

On 2/5/20 5:59 PM, Andy Shevchenko wrote:
> On Wed, Feb 5, 2020 at 5:34 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> The "Intel 64 and IA-32 Architectures Software Developer’s Manual
>> Volume 4: Model-Specific Registers" has the following table for the
>> values from freq_desc_byt:
>>
>>     000B: 083.3 MHz
>>     001B: 100.0 MHz
>>     010B: 133.3 MHz
>>     011B: 116.7 MHz
>>     100B: 080.0 MHz
>>
>> Notice how for e.g the 83.3 MHz value there are 3 significant digits,
>> which translates to an accuracy of a 1000 ppm, where as your typical
>> crystal oscillator is 20 - 100 ppm, so the accuracy of the frequency
>> format used in the Software Developer’s Manual is not really helpful.
>>
>> As far as we know Bay Trail SoCs use a 25 MHz crystal and Cherry Trail
>> uses a 19.2 MHz crystal, the crystal is the source clk for a root PLL
>> which outputs 1600 and 100 MHz. It is unclear if the root PLL outputs are
>> used directly by the CPU clock PLL or if there is another PLL in between.
>>
>> This does not matter though, we can model the chain of PLLs as a single
>> PLL with a quotient equal to the quotients of all PLLs in the chain
>> multiplied.
>>
>> So we can create a simplified model of the CPU clock setup using a
>> reference clock of 100 MHz plus a quotient which gets us as close to the
>> frequency from the SDM as possible.
>>
>> For the 83.3 MHz example from above this would give us 100 MHz * 5 / 6 =
>> 83 and 1/3 MHz, which matches exactly what has been measured on actual hw.
>>
>> This commit makes the tsc_msr.c code use a simplified PLL model with a
>> reference clock of 100 MHz for all Bay and Cherry Trail models.
>>
>> This has been tested on the following models:
>>
>>                CPU freq before:        CPU freq after this commit:
>> Intel N2840   2165.800 MHz            2166.667 MHz
>> Intel Z3736   1332.800 MHz            1333.333 MHz
>> Intel Z3775   1466.300 MHz            1466.667 MHz
>> Intel Z8350   1440.000 MHz            1440.000 MHz
>> Intel Z8750   1600.000 MHz            1600.000 MHz
>>
>> This fixes the time drifting by about 1 second per hour (20 - 30 seconds
>> per day) on (some) devices which rely on the tsc_msr.c code to determine
>> the TSC frequency.
> 
> Thanks for this effort!
> 
> ...
> 
>> +#define REFERENCE_KHZ 100000
> 
> Perhaps TSC_REFERENCE_KHZ ?

Ok, changed to TSC_REFERENCE_KHZ for v3

> 
> ...
> 
>> +       struct {
>> +               u32 multiplier;
>> +               u32 divider;
>> +       } pairs[MAX_NUM_FREQS];
> 
> Perhaps pairs -> muldiv ?

Ok, changed to muldiv for v3

> 
> ...
> 
>> +       .pairs = { {  5,  6 }, { 1,  1 }, { 4, 3 }, { 7, 6 }, { 4, 5 },
>> +                  { 14, 15 }, { 9, 10 }, { 8, 9 }, { 7, 8 } },
> 
> Maybe 4 per line or alike (8 per line) for better understanding which
> muldiv maps to which value?

Ok, changed for v3.

> 
> ...
> 
>> +       .pairs = { { 0, 0 }, { 1, 1 }, { 4, 3 } },
> 
> And maybe list all of them always? (I'm fine with either approach).

I prefer to just list the valid ones.

> 
> ...
> 
>> +/* 24 MHz crystal? : 24 * 13 / 4 = 78 MHz */
> 
> Perhaps Cc to LGM SoC developers team (they did it recently, so, they
> have to know).

Ok, I've added the following people to the Cc for v3 based on the Sob-s and Cc-s of:
0cc5359d8fd45bc("x86/cpu: Update init data for new Airmont CPU model"):

Cc: Rahul Tanwar <rahul.tanwar@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Gayatri Kammela <gayatri.kammela@intel.com>


> ...
> 
>> +       if (freq_desc->pairs[index].divider) {
> 
>> +               freq = DIV_ROUND_CLOSEST(REFERENCE_KHZ *
>> +                                           freq_desc->pairs[index].multiplier,
>> +                                        freq_desc->pairs[index].divider);
> 
> Maybe helper?
> 
>> +               /* Multiply by ratio before the divide for better accuracy */
>> +               res = DIV_ROUND_CLOSEST(REFERENCE_KHZ *
>> +                                           freq_desc->pairs[index].multiplier *
>> +                                           ratio,
>> +                                       freq_desc->pairs[index].divider);
> 
> ...which may be used here as well.

Nah, I would prefer to keep this as is. I'm never a fan of single line
helpers they just make it harder to see what the code is actually doing.

Regards,

Hans

