Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB33829FB2B
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 03:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJ3CZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 22:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3CZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 22:25:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943DEC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 19:25:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so3908163pgb.10
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 19:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JCLkm7+Zth9H4Ep/9Ry3oTGjaCYQs85rwFGOzKVYCKk=;
        b=VRQjNPlfBETExe5GPaQobkcbO046YkCjn7ALJTSm2xGUxUIkTfssU44hILw02Cbpng
         EVNV5kDStjHW3HcxGDGiCgm9M/BRkohA6KKR7egVZWeiarnvyJ/W9PgbvGPAgB4LCM4g
         hgbG6NP6UooFAUiDBzrRqcWlQ/8XthzommypmozNnvvybeZuDcb8mHxpuv1xV3pwFpr9
         GE/x2xInIZnSfW2P5aZKndyngMJoBTtV5a5BZmXXRWlw22YaS70UDZVUHsvhbxKL565j
         eBOhru5emoo/tgdEZY++6/YeIz/KXQHNRJ14jP6F1Gn8y7UqI/5qZ1Mx1LiV2NJ35/MF
         A3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JCLkm7+Zth9H4Ep/9Ry3oTGjaCYQs85rwFGOzKVYCKk=;
        b=nX+gbkwWT7dCsJ0xkBwdXOQsM4OvqJ7nIsXwArvqVY/oHnykylx8hIPA6G9zlsdYE8
         L+vrwxOSGcuxOy789QlWS7EG/WLo3/qFFS0P3j0jMufuOgVVyv8Oq3AjBWgcRGhUehTv
         7qxehRZ/FbF0M5JnsYbbjePwIMmJ/ac4sNkWKqLdcZmCmoOU/C0Mo/3PnkqRZ/yphusD
         NeOM5IEY3ZNOwlCmrQtaKHEYyZllJc+t3FSeKPWzw2dRYYdcct9yDEhfePaK26QNzq7i
         RFCveZUKcq593bx26210q9HPQM2mFZJnx1uu9vCm7ONCArtRWnCGr/0UiU3Jb7Sh5/CX
         CVLg==
X-Gm-Message-State: AOAM531QHALQQQTsiyOUw/cs0oOMJlJPZNpkEo6QdEytyFtYNeJO8vo4
        lEshoXq99zkG+1/06wgJt2N5iqZLP/g=
X-Google-Smtp-Source: ABdhPJyZR77mJYExxhbgb+OeyOGd3G4c/Y+dd+eBIw5ZhvhyP6NOJ4RBi4lTWq9fNfq36d80tc9NAQ==
X-Received: by 2002:a63:e705:: with SMTP id b5mr219910pgi.230.1604024748510;
        Thu, 29 Oct 2020 19:25:48 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t26sm4429198pfq.8.2020.10.29.19.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 19:25:47 -0700 (PDT)
Subject: Re: [PATCH] ARM: highmem: avoid clobbering non-page aligned memory
 reservations
To:     Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20201029110334.4118-1-ardb@kernel.org>
 <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <013f82d6-d20f-1242-2cdd-9ea9c2ab9f9c@gmail.com>
Date:   Thu, 29 Oct 2020 19:25:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/29/2020 4:14 AM, Ard Biesheuvel wrote:
> On Thu, 29 Oct 2020 at 12:03, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>> free_highpages() iterates over the free memblock regions in high
>> memory, and marks each page as available for the memory management
>> system. However, as it rounds the end of each region downwards, we
>> may end up freeing a page that is memblock_reserve()d, resulting
>> in memory corruption. So align the end of the range to the next
>> page instead.
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  arch/arm/mm/init.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index a391804c7ce3..d41781cb5496 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -354,7 +354,7 @@ static void __init free_highpages(void)
>>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
>>                                 &range_start, &range_end, NULL) {
>>                 unsigned long start = PHYS_PFN(range_start);
>> -               unsigned long end = PHYS_PFN(range_end);
>> +               unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
>>
> 
> Apologies, this should be
> 
> -               unsigned long start = PHYS_PFN(range_start);
> +               unsigned long start = PHYS_PFN(PAGE_ALIGN(range_start));
>                 unsigned long end = PHYS_PFN(range_end);
> 
> 
> Strangely enough, the wrong version above also fixed the issue I was
> seeing, but it is start that needs rounding up, not end.

Is there a particular commit that you identified which could be used as
 Fixes: tag to ease the back porting of such a change?
-- 
Florian
