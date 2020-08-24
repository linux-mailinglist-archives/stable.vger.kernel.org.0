Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3713725034D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgHXQnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgHXQm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 12:42:56 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204CCC061573;
        Mon, 24 Aug 2020 09:42:56 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t11so4500153plr.5;
        Mon, 24 Aug 2020 09:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w41OmkoPspYNv6XjOAw8ahtDnY6c9BDmvOxAxpZTttk=;
        b=ZOiYUyUZBx+y2twZVDLNRNj7XcDKPZeSrlH1pKR2XVXQPyltnrUiF5XIL2Pi3UOJE0
         QESR928QCAsMbVv7IvrTsNl9dzQkt7ttEVo22hbkdd8dUrifgdVOREvnTvtePmoSa168
         LUMoDzFfey129AAzeHQzzhMcEFJEBuPwK0iIGyg5eV7eeKQsyzjJYoSHqPx+kktCO0WP
         gucacHnk+svFErQYZFyKb3ISKViLF8l6FlE982tB0lCYr6KbI36mn3lZKElTno2t7VnW
         88Qp4uOlQ1ROHrTxVoECzjBJHSxrk7CtSabgsYgfuVEBBLi35E8V9OKPG1xS/gAt6i3x
         vcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w41OmkoPspYNv6XjOAw8ahtDnY6c9BDmvOxAxpZTttk=;
        b=XWjF0UWuEodlXjHNgp8i//apwu5KIYoieQSC4toxkMu09gFzWdCQnk3rS7/xvpeNtD
         st+6SV3Z1J2s+bRDB4RQQbJIHEb7VVgJ0VYZJuxeTpRHHmgBKfeqEkT1xU96ZGk6ccyv
         Dk3w1Ez/sKQjAoPebUPk3ekkwdbf3CiHE6iFUd4M88Dtxy2ywb4mURuPKPSYLRtLuBNC
         FPtjfd43LhwlLAdd07FHAmmdkevC7pom7i3JkTfxVFsecOj9SpGIxlAK5/pcnicV8FWy
         Jnra4iO/MrFRGiQqrzopEhPbqxhgXWx9axkA9dnAdkVXwmO1gWw2lQo35G9qwdQTzm59
         bgJQ==
X-Gm-Message-State: AOAM532xbyb0CjwGzPbVqBnXExJ6zXrEpBj5In+HIk6sk0oV9TD5yPAy
        UQgr2Blrw3iSF/zN7FltwEo=
X-Google-Smtp-Source: ABdhPJxoYGplA4PD2xcotuP1hn0qFIYRCnXteeEmPRirh/XXpaV6W9tmtVZLocyIxdzG6AVoTaXu5g==
X-Received: by 2002:a17:90a:850b:: with SMTP id l11mr142577pjn.15.1598287375409;
        Mon, 24 Aug 2020 09:42:55 -0700 (PDT)
Received: from [10.67.51.206] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 2sm72768pjg.32.2020.08.24.09.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 09:42:54 -0700 (PDT)
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
To:     Will Deacon <will@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
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
 <20200807131429.GB664450@kroah.com> <20200821160316.GE21517@willie-the-truck>
 <7480435b-355d-b9f7-3a42-b72a9c4b6f63@gmail.com>
 <20200824163208.GA25316@willie-the-truck>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f47841b0-bbbf-f03a-dfd1-88e92f4db7c6@gmail.com>
Date:   Mon, 24 Aug 2020 09:42:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200824163208.GA25316@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/24/2020 9:32 AM, Will Deacon wrote:
> Hi Florian,
> 
> On Fri, Aug 21, 2020 at 10:16:23AM -0700, Florian Fainelli wrote:
>> On 8/21/20 9:03 AM, Will Deacon wrote:
>>> On Fri, Aug 07, 2020 at 03:14:29PM +0200, Greg KH wrote:
>>>> On Thu, Aug 06, 2020 at 01:00:54PM -0700, Florian Fainelli wrote:
>>>>> Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?
>>>>>
>>>>> https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
>>>>> https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
>>>>> https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/
>>>>
>>>> Nope, I was waiting for Will's "ack" for these.
>>>
>>> This patch doesn't even build for me (the 'sb' macro is not defined in 4.9),
>>> and I really wonder why we bother backporting it at all. Nobody's ever shown
>>> it to be a problem in practice, and it's clear that this is just being
>>> submitted to tick a box rather than anything else (otherwise it would build,
>>> right?).
>>
>> Doh, I completely missed submitting the patch this depended on that's
>> why I did not notice the build failure locally, sorry about that, what a
>> shame.
>>
>> Would not be the same "tick a box" argument be used against your
>> original submission then? Sure, I have not been able to demonstrate in
>> real life this was a problem, however the same can be said about a lot
>> security related fixes.
> 
> Sort of, although I wrote the original patch because it was dead easy to do
> and saved having to think too much about the problem, whereas the complexity
> of backporting largerly diminishes that imo.
> 
>> What if it becomes exploitable in the future, would not it be nice to
>> have it in a 6 year LTS kernel?
> 
> Even if people are stuck on an old LTS, they should still be taking the
> regular updates for it, and we would obviously need to backport the fix if
> it turned out to be exploitable (and hey, we could even test it then!).
> 
>>> So I'm not going to Ack any of them. As with a lot of this side-channel
>>> stuff the cure is far worse than the disease.
>> Assuming that my v3 does build correctly, which it will, would you be
>> keen on changing your position?
> 
> Note that I'm not trying to block this patch from going in, I'm just saying
> that I'm not supportive of it. Perhaps somebody from Arm can review it if
> they think it's worth the effort.

How about I submit the actual full series (two patches) and we take the 
discussion from there?

Thanks for responding!
-- 
Florian
