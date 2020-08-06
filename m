Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7307123E2BA
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 22:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgHFUBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 16:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgHFUBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 16:01:01 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33257C061574;
        Thu,  6 Aug 2020 13:01:01 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 9so9846491wmj.5;
        Thu, 06 Aug 2020 13:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1efmHhkESZyyTkV4YjG9R+9VKAGSzU4A2n9DPJ51c6k=;
        b=vXzP8kirTQLXYXApQ4BkSpIMvXB164bzSWnTW5WsT1Th1fa0cfY/x6FOvSEdm6nXnD
         4uMl/EHRTfBE49HyFD6TbXG+Hbt9V3beqowzhdWO9GfYvHI8qphDINlGViHhAJ6zOBrw
         xcAP9Cz9DxEAPnVO0nF7ecih9rDg17vCXQ344u58AwahDEq5GCRn0dLorkX/GEAmHo6o
         pfQZy+AdC2UYQtWrQuCiFIWZ4oPFfcf8KshjJC5hDASRdCQF+B2vyYIHOJRsbCHgRriM
         29ipPohXt9rHbc0XtelExLCVJco6YzCcfGdfwuUTckpc42y+C0xQSd56DatK9MEviAhE
         4lGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1efmHhkESZyyTkV4YjG9R+9VKAGSzU4A2n9DPJ51c6k=;
        b=PyVbbL/HW8sU08I+wou+k2yBZbKSKi/rTHCV+MeaWygvfUVMDZQotRza+qLdn0Cd51
         mZ0WlxQ/4MaLiiv6NSD8iZavAz+9pRfneHpFFDizHTnTH5A+xrwDTi5IZ0LUYa/LCEz3
         brUeE3cdP4IRo6GSxJnC4rE+GRX1bsbTtz5mHjqUFvkHcUFggpP4a6i7o+RzVwXmzzbN
         rXowlv7Ctzp4a5cbfIQuK2NPSgURc188mc0aFHBqVNI5p8OMc1mvlm0ygpCZGFtSQSsJ
         mf1s+JR4/7U+3dS4/b9zDdDx8ft1gM/2UVElwAYBH6zcKqGOB1rSPaOUXPyCW4Bypslh
         k/9w==
X-Gm-Message-State: AOAM530E/2LDXFwA7P+EgWd0cxt13gTbgUjutg6ZGu7YJ5VngUph7Iup
        w1dYN5ADvCNDFoHFDmX9kBo=
X-Google-Smtp-Source: ABdhPJwGV5s3DdZeTmZurz5B8CV3xP8yPdmxkvz6E0i1ONWbghrttEfIOdrVF+lRXrsTMBAlrjsgyw==
X-Received: by 2002:a1c:964b:: with SMTP id y72mr9536627wmd.69.1596744059869;
        Thu, 06 Aug 2020 13:00:59 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y203sm8105701wmc.29.2020.08.06.13.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 13:00:59 -0700 (PDT)
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
From:   Florian Fainelli <f.fainelli@gmail.com>
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
Message-ID: <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
Date:   Thu, 6 Aug 2020 13:00:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/20/2020 11:26 AM, Florian Fainelli wrote:
> On 7/20/20 6:04 AM, Greg KH wrote:
>> On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>>> From: Will Deacon <will.deacon@arm.com>
>>>
>>> commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>>>
>>> Some CPUs can speculate past an ERET instruction and potentially perform
>>> speculative accesses to memory before processing the exception return.
>>> Since the register state is often controlled by a lower privilege level
>>> at the point of an ERET, this could potentially be used as part of a
>>> side-channel attack.
>>>
>>> This patch emits an SB sequence after each ERET so that speculation is
>>> held up on exception return.
>>>
>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>> [florian: Adjust hyp-entry.S to account for the label
>>>  added change to hyp/entry.S]
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>> Changes in v2:
>>>
>>> - added missing hunk in hyp/entry.S per Will's feedback
>>
>> What about 4.19.y and 4.14.y trees?  I can't take something for 4.9.y
>> and then have a regression if someone moves to a newer release, right?
> 
> Sure, send you candidates for 4.14 and 4.19.

Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?

https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/

Thanks
-- 
Florian
