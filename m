Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D7C244023
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 22:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHMUxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 16:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgHMUxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 16:53:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB549C061757;
        Thu, 13 Aug 2020 13:53:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u10so3163190plr.7;
        Thu, 13 Aug 2020 13:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KMEdmNBQWTzUTOzp1bnF8SX2rCsME0fqtsH4k5tjFgk=;
        b=BY/RaFL1BVNPFlGHJzyLzey4vsiBfNtRMsw3MUihtFPevNI6wBAodIqL8l9LyiC8Oq
         Eo21w0GU1xVIaAU2FMgX28MU4LpFfWXG7LZOiSCe0R/mxr8L/6WKNnWW/OPaTZa0B53o
         auaWm/ULLH4BluQuWM3Ptb6CmqOTrQ3wf7Xp/8XN/Tn5603OECm26w+DcCTMJtNaXmdp
         5P4+FVUNcAC7KebDKPDI9F01gUfj1ezszF/xQ4G1kPSHW2W3DFX2M7WfibPvOkoiAQnl
         +w3p5mbG0qTjS+NjvbNWIeaVGsRmDPPrP1xx/Yl/fB3LWVgi4GjTn4XyHDbY7oQiXx+I
         3eEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KMEdmNBQWTzUTOzp1bnF8SX2rCsME0fqtsH4k5tjFgk=;
        b=Vn5LSwrtCbvUnH3DNMnd7cHbNPNKTFXcs8VMTsBo56E7PVmMZ/c9x9KRUKnEngJ/LD
         HoA9l61jJ7MYOzk8PHFBWnh+Rwt1TfoZG11spTjdPs7PXVVnpdH9tpcXWobby/KjS4l4
         z1PvdzJSY+lnlikb3wmhYF/RDQKBcoF6LKE4tWIAZFk9PnYjlgReSw8STbc6ACCueL68
         jgu36wXjUjXJ87qYEukCQaJudPmT1FqJ0y+EJZUavBRu8ChBuEpdCp198dDPUrrChq0j
         XXf4BA+eNPAew4irM/9jC/KSPlwkHkN+oU8+y3UC1QzRRqe7oHMmE5e0ypb5YItgUkZ/
         uuAQ==
X-Gm-Message-State: AOAM531Bpxw9roDExDN4wEGR8yyNVYiVk5ntXQk7q25ZFKbIg6nrpX15
        hVXuN0uTltSu2Hs0rO/o2z0=
X-Google-Smtp-Source: ABdhPJwJ7SDcRA3ZGymFvn6xsKEpJWj4sIm+NKcGlAI2M7tYtar9FKkQpMc6BjAOeT2ZGaSmFR8MVw==
X-Received: by 2002:a17:90a:8918:: with SMTP id u24mr6329006pjn.7.1597351988125;
        Thu, 13 Aug 2020 13:53:08 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z25sm6975261pfg.150.2020.08.13.13.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 13:53:07 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
To:     Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
 <20200720130411.GB494210@kroah.com>
 <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
 <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
 <20200807131429.GB664450@kroah.com>
 <fb3be972-106e-e171-1c2f-6df20ce186d6@gmail.com>
Message-ID: <647d771d-441b-39f9-809a-19335ef16036@gmail.com>
Date:   Thu, 13 Aug 2020 13:52:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <fb3be972-106e-e171-1c2f-6df20ce186d6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/7/2020 11:17 AM, Florian Fainelli wrote:
> 
> 
> On 8/7/2020 6:14 AM, Greg KH wrote:
>> On Thu, Aug 06, 2020 at 01:00:54PM -0700, Florian Fainelli wrote:
>>>
>>>
>>> On 7/20/2020 11:26 AM, Florian Fainelli wrote:
>>>> On 7/20/20 6:04 AM, Greg KH wrote:
>>>>> On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>>>>>> From: Will Deacon <will.deacon@arm.com>
>>>>>>
>>>>>> commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>>>>>>
>>>>>> Some CPUs can speculate past an ERET instruction and potentially perform
>>>>>> speculative accesses to memory before processing the exception return.
>>>>>> Since the register state is often controlled by a lower privilege level
>>>>>> at the point of an ERET, this could potentially be used as part of a
>>>>>> side-channel attack.
>>>>>>
>>>>>> This patch emits an SB sequence after each ERET so that speculation is
>>>>>> held up on exception return.
>>>>>>
>>>>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>>>>> [florian: Adjust hyp-entry.S to account for the label
>>>>>>   added change to hyp/entry.S]
>>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>>> ---
>>>>>> Changes in v2:
>>>>>>
>>>>>> - added missing hunk in hyp/entry.S per Will's feedback
>>>>>
>>>>> What about 4.19.y and 4.14.y trees?  I can't take something for 4.9.y
>>>>> and then have a regression if someone moves to a newer release, right?
>>>>
>>>> Sure, send you candidates for 4.14 and 4.19.
>>>
>>> Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?
>>>
>>> https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
>>> https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
>>> https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/
>>
>> Nope, I was waiting for Will's "ack" for these.
> 
> OK, Will, can you review those? Thanks

Will, can you please review those patches?
-- 
Florian
