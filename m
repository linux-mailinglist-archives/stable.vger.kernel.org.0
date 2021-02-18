Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9211531EB46
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 16:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhBRPIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 10:08:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232871AbhBROGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 09:06:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613657072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DameG4NN+XhJX2cINYFl0XGxWm6k+VvwqQIKiHlU8pk=;
        b=eznkQ5pWyWk71+N/pRDEGT/wZIvm7n23sv1AwfS8qRi8LqZTH7SURjljHGjb4R6pmTeF0I
        nqlxsJl+4jVeOOeJA/wlq0QfQeSfZBXmQg8htkviBdzPqUY0hOT7jWLbo3rXS0MmaYZzoB
        JfqIq2AkFEWIODZJgEzao3V6qMAElpk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-z2JElaY4N0SRaC26UmdOPg-1; Thu, 18 Feb 2021 09:04:21 -0500
X-MC-Unique: z2JElaY4N0SRaC26UmdOPg-1
Received: by mail-ej1-f70.google.com with SMTP id 7so721208ejh.10
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 06:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DameG4NN+XhJX2cINYFl0XGxWm6k+VvwqQIKiHlU8pk=;
        b=kGRh5MQKQC4QUOko7r8EUBWnAT2SGVu6Qk2hRinNrsMhN+xx6ajN6whFZ1NSXgjyn7
         nd0CQVZoke1oFo8l/z4kRCRhjjXVT+VuPEps7ZY33a3XGF+Uh7Obeai6iq0UKw8DkOCd
         5g7rH//ziNNsY8ZCjINytn/pdhIwpldhddBrhCaisd/7meZNdx70yrw0eujPfWeg+dFf
         gom65mnEC5T5S0CPXAr4J/WNm1KEAtul+e4WD+piudgulUU2pE8I1+fRxABMNTdK2FhZ
         uSUn8lR8EOT+wWdWYXnh3NW4ww7z63tOj8rQAWXZcRlY/KN9FEepBLVkkLVUgAPtPfhd
         V8bg==
X-Gm-Message-State: AOAM532R3f6I+s1pGNiwYdcNdA9Ag46mLJNiB1p6i9CRqZ64LkglNaJf
        6AYPfGPAYEJSCPqskBh8XyHpTHF8jkVi5NT3cjto73BiIjiZjI1KzPM4he34Unz2qPGt+TRNKIZ
        A64MzaijM8JsMOcgn+ncfUIcZqmtSIH5VDVZYPClEq1nhcpZjjUPEDpszuUNEAXBNmfe4
X-Received: by 2002:a17:906:7697:: with SMTP id o23mr4310540ejm.292.1613657059253;
        Thu, 18 Feb 2021 06:04:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzP/zABQrXHdJhOBKCVdZ9S02vMhPi1HVFijw+J9omB3IY9JVoV3G4Wp1LvT7/TrAr9/f4RJg==
X-Received: by 2002:a17:906:7697:: with SMTP id o23mr4310513ejm.292.1613657058956;
        Thu, 18 Feb 2021 06:04:18 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id o8sm2814226edj.79.2021.02.18.06.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 06:04:18 -0800 (PST)
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation
 is causing gfx issues
From:   Hans de Goede <hdegoede@redhat.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
References: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com>
 <161282685855.9448.10484374241892252440@build.alporthouse.com>
 <f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com>
 <161291205642.6673.10994709665368036431@build.alporthouse.com>
 <02fd493c-957f-890d-d0ad-ebd4119f55f2@redhat.com>
 <161296131275.7731.862746142230006325@build.alporthouse.com>
 <8f550b67-2c7c-c726-09d1-dc8842152974@redhat.com>
 <161304059194.7731.17263409378570191651@build.alporthouse.com>
 <e00f5813-37c6-52e7-4fd3-691be9d062d9@redhat.com>
 <96614fc1-c92d-1532-fd92-beb19e490075@redhat.com>
Message-ID: <a20993b8-5877-b501-56f1-4048c3457b1a@redhat.com>
Date:   Thu, 18 Feb 2021 15:04:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <96614fc1-c92d-1532-fd92-beb19e490075@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/14/21 5:00 PM, Hans de Goede wrote:
> Hi,
> 
> On 2/11/21 1:26 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 2/11/21 11:49 AM, Chris Wilson wrote:

<snip>

>>>>> Started looking for scratch page overwrites, and found this little gem:
>>>>> https://patchwork.freedesktop.org/patch/420436/?series=86947&rev=1
>>>>>
>>>>> Looks promising wrt the cause of overwriting random addresses -- and
>>>>> I hope that is the explanation for the glitches/hangs. I have a hsw gt2
>>>>> with gnome shell, piglit is happy, but I suspect it is all due to
>>>>> placement and so will only occur at random.
>>>>
>>>> If you can give me a list of commits to cherry-pick then I can prepare
>>>> a Fedora 5.10.y kernel which those added for the group of Fedora users
>>>> who are hitting this to test.
>>>
>>> e627d5923cae ("drm/i915/gt: One more flush for Baytrail clear residuals")
>>> d30bbd62b1bf ("drm/i915/gt: Flush before changing register state")
>>> 1914911f4aa0 ("drm/i915/gt: Correct surface base address for renderclear")
>>
>> Thanks, the test-kernel is building now. I will let you know when I have
>> heard back from the Fedora users (this will likely take 1-2 days).
> 
> I've heard back from 2 of the reporters who were seeing issues with 5.10.9+
> 
> And I'm happy to report 5.10.15 + the 3 commits mentioned above cherry-picked
> on top fixes the graphics glitches for them.
> 
> So if we can get these 3 commits into 5.10.y and 5.11.y then this should be
> resolved.

Unfortunately I just got a report that 5.10.15 + the 3 extra fixes mentioned
above is still causing issues for one user with a
"thinkpad x230 with i5-3320M (HD Graphics 4000)"

The user descibes the problem as: "still have some minor black squares popping
up while scrolling on Firefox."

I've asked this user to test 5.10.14 + the 3 reverts mentioned earlier in the
thread and that kernel does not have this issue.

Chris, any ideas / more fixes to cherry pick for testing ?

Regards,

Hans

