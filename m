Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BD023F29B
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHGSRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 14:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGSRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 14:17:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABD1C061756;
        Fri,  7 Aug 2020 11:17:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 9so2489322wmj.5;
        Fri, 07 Aug 2020 11:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+RLcMf039Fja7+NVYfWd7LsUb0HLd5N8YbD0HQCYGKs=;
        b=hEYA/snmkEnBTWT41qnElh5RISovyGYu/KkzthXY5h6DXG3W0hdwlPVFr/1TAoXzeN
         g3hdpKG0rlvrSWBRhz3pHgXCOMaLU4F64766xythYWHQHlIEwrrFLdcqeFPRyJmojb1E
         heapMjHWiXzttkUCvdfk+AGwfd5/QdZ4kkv5nO1iVEmH96vtecMuYb4rsXnqnFW2BoXK
         pLMpM+R+B5IagfhSenzb51rHcZH1tGJMgwVOQRwG6S2/ilDdHL7Dd/kVhwIF3HsUKr17
         VHBukSpEB9zVSSuJ5A3A0ny9PKP+RldiUG6Jami6ucXsNk21I6t1AdOCQvr0jFMJott7
         F22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+RLcMf039Fja7+NVYfWd7LsUb0HLd5N8YbD0HQCYGKs=;
        b=FQmI4RAVFODthMteDm97WeLLFTiXRNRoWxCrZhcRAtMYB0J/u1IvGSRK9Eo8FWTN8y
         rViufjyZnyj/SPSpN3JfZBRdCy2axQ5KpFXd9n449IzbQjetMoxrSFZSxYR0XOaH+pXX
         o6+IWseA3ZTl+Q5ACk69DxTHSmEI1qvSF3exVNtBHXA3mxjPVAvzi4QftuTwaEz7+3fH
         0gwt9db24CUDtIW/IAg5RLFK4aUm5sT+eqUxzVyhbtKzeIOxybp3fS2lJsONOV35TK5A
         +U0Ib2kLWEPP1aA7buXYfinpl52gUwpn15rWqvjJenBpVVFE/h+dz6DoxNbGQLFUmrAe
         /Bxg==
X-Gm-Message-State: AOAM530WGKmnqBs1R8mukzy80klq9uUWXvwm70j4e+jgoED5ApkR7DHd
        tvQBDXNLFqFvBmu55BJslmw=
X-Google-Smtp-Source: ABdhPJw1gAmZHJQX55Ci8aLNAo0vKfunS/WHs1CJQjlHAcjBEZCQV97jdptYDEHSsVMoBeR0Tazsvg==
X-Received: by 2002:a7b:c38a:: with SMTP id s10mr14609217wmj.13.1596824250547;
        Fri, 07 Aug 2020 11:17:30 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k184sm11289988wme.1.2020.08.07.11.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 11:17:29 -0700 (PDT)
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fb3be972-106e-e171-1c2f-6df20ce186d6@gmail.com>
Date:   Fri, 7 Aug 2020 11:17:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807131429.GB664450@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/7/2020 6:14 AM, Greg KH wrote:
> On Thu, Aug 06, 2020 at 01:00:54PM -0700, Florian Fainelli wrote:
>>
>>
>> On 7/20/2020 11:26 AM, Florian Fainelli wrote:
>>> On 7/20/20 6:04 AM, Greg KH wrote:
>>>> On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>>>>> From: Will Deacon <will.deacon@arm.com>
>>>>>
>>>>> commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>>>>>
>>>>> Some CPUs can speculate past an ERET instruction and potentially perform
>>>>> speculative accesses to memory before processing the exception return.
>>>>> Since the register state is often controlled by a lower privilege level
>>>>> at the point of an ERET, this could potentially be used as part of a
>>>>> side-channel attack.
>>>>>
>>>>> This patch emits an SB sequence after each ERET so that speculation is
>>>>> held up on exception return.
>>>>>
>>>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>>>> [florian: Adjust hyp-entry.S to account for the label
>>>>>  added change to hyp/entry.S]
>>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>>> ---
>>>>> Changes in v2:
>>>>>
>>>>> - added missing hunk in hyp/entry.S per Will's feedback
>>>>
>>>> What about 4.19.y and 4.14.y trees?  I can't take something for 4.9.y
>>>> and then have a regression if someone moves to a newer release, right?
>>>
>>> Sure, send you candidates for 4.14 and 4.19.
>>
>> Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?
>>
>> https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
>> https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
>> https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/
> 
> Nope, I was waiting for Will's "ack" for these.

OK, Will, can you review those? Thanks
-- 
Florian
