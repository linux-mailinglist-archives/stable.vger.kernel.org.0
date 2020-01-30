Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4EB14DE53
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgA3QEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:04:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59642 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727158AbgA3QEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580400261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqe+NoPMzT7qAg85et2NM6krGWv/koxPfAUCYSpHnTo=;
        b=aLoii9kJsSFXg7n5QfboD4aEIDFeMVUROrMpS+zuRloR54o3iLt1lOTuJ6U94xIvfpiRpG
        5N1uGsGbT6/WgyENzxzBLVU7NMOdqW+t8DBK86kOSMBKpEMCESkd4DwyN0tGsQNwrQaQAt
        UKe6KdmSz4IOCGHcx6p1tVlsA4871oc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-KkUlaBXSOzW2d0F-vfVDFA-1; Thu, 30 Jan 2020 11:04:19 -0500
X-MC-Unique: KkUlaBXSOzW2d0F-vfVDFA-1
Received: by mail-wm1-f72.google.com with SMTP id a10so1175768wme.9
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 08:04:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yqe+NoPMzT7qAg85et2NM6krGWv/koxPfAUCYSpHnTo=;
        b=CG9mE5u6f4XUnci410eeMOllO1mAo9XQJgtlqkSupWiyZHmx8ZR9sBWgicDtT2pHpE
         L2hBwv+0ZSmUvXGjxyXNZtloSWF/V1ojhKzk56enN4026qPqD/eWPVsnV7qJBtukUXxZ
         FJ6YtZhiwKyeKxnLKk+etPG+6x0Aj0eeQ5e8ngX1RHEPYbINO/DDQQ9rTUKT/VAOMby1
         +GndqF7P/aOqkk7Kp9apLNcSXN5mfsJ7d0HSszz3qfpXq8JrcNuklamHPmDy1yJ6S6tP
         0Mnx5p+1AE14uHg7Nr1jTbU3OmP6UNVaPS+eob2yLTKGbL2QjZt+EfU5DW7P05cz77lw
         S7Jw==
X-Gm-Message-State: APjAAAWws8zE9S9SpAvTS7SyUE3TuFGNhTn76kUPpTBDIBS5R9GltHoc
        XGmtcnC9I41xQAXtUuS/fG8zNI+tKSaZF4tdtMS+WBi3gE9zvtM+AZ0P5bB8W66y0lFRxj8C4T2
        zx5QFkf0qlhiBtIZI
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr537029wro.231.1580400257625;
        Thu, 30 Jan 2020 08:04:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqxw6lgTdMyEhaJP7h4XlCILbKz4N9dAWcpCAl11gNAAd2FRnXy0wgPcZS9AuKOM8Uqa4Lbj6g==
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr536994wro.231.1580400257365;
        Thu, 30 Jan 2020 08:04:17 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id 2sm7773100wrq.31.2020.01.30.08.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 08:04:16 -0800 (PST)
Subject: Re: [PATCH 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
To:     David Laight <David.Laight@ACULAB.COM>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20200130115255.20840-1-hdegoede@redhat.com>
 <20200130115255.20840-3-hdegoede@redhat.com>
 <20200130134310.GX14914@hirez.programming.kicks-ass.net>
 <b77be8c0-7107-bece-5947-a625e556e129@redhat.com>
 <01feee20ee5d4b83ab218c14fc35accb@AcuMS.aculab.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <8a8fd7a1-945e-4541-f0bc-387fae7c6822@redhat.com>
Date:   Thu, 30 Jan 2020 17:04:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <01feee20ee5d4b83ab218c14fc35accb@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 30-01-2020 17:02, David Laight wrote:
> From: Hans de Goede
>> Sent: 30 January 2020 15:55
> ...
>>>> + * Moorefield (CHT MID) SDM MSR_FSB_FREQ frequencies simplified PLL model:
>>>> + * 0000:   100 *  5 /  6  =  83.3333 MHz
>>>> + * 0001:   100 *  1 /  1  = 100.0000 MHz
>>>> + * 0010:   100 *  4 /  3  = 133.3333 MHz
>>>> + * 0011:   100 *  1 /  1  = 100.0000 MHz
>>>
>>> Unless I'm going cross-eyed, that's 4 times the exact same table.
>>
>> Correct, except that the not listed values on the none Cherry Trail
>> table are undefined in the SDM, so we should probably deny them
>> (or as the old code was doing simply return 0).
>>
>> And at least the Moorefield (CHT MID) table is different for 0011, that
>> is again 100 MHz like 0001 instead of 116.6667 as it is for BYT and CHT.
>>
>> Note that the Merriefield (BYT MID) and Moorefield (CHT MID) values are
>> based on the old code I've not seen those values in the current latest
>> version of the SDM.
> 
> I wonder if Moorefield:11 is an old typo?

I have no idea. Andy if you can find any docs on the MSR_FSB_FREQ values
for Merriefield (BYT MID) and Moorefield (CHT MID) that would be great,
if not I suggest we stick with what we have.

Regards,

Hans

