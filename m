Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BD8366E4F
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbhDUOei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 10:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243607AbhDUOeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 10:34:37 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E2DC06174A;
        Wed, 21 Apr 2021 07:34:04 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s22so8915056pgk.6;
        Wed, 21 Apr 2021 07:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1MMJc9E2vJ4S7Mny58l5zqOl5ND0C+JpidbUw7b0wr8=;
        b=hmCLQPukuwX5xjaiFufvuWOBk/GDwoQezj8xLqvWrNJKbeXdhYEcx9oQOKRoQgN9VD
         O1ZpkhRTflPPxkWOsy3GiUNM9gcl0aypYx5HNwhsaG56YoSCEmUeEc4D1PqNoE2Hzjv7
         t3Rzdx7S2zIx1OU6Lrq9zofN703C9q3CYsiAMnOLMYPbsqDsYn7BiXSb3irOPD1wCDLU
         rxIsiw63E4Q0jR0M7gfeob9kGUQmH1CwZZKE7QPyXUilwshoKeofozWas1Q/QDpgxumQ
         1zpS8n03cBXQ3iPvump4FS51nouHFpO9NKPYmLWISCTk+BVe+L9Y3u0WTXIqScpU/oMf
         CmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1MMJc9E2vJ4S7Mny58l5zqOl5ND0C+JpidbUw7b0wr8=;
        b=ngCJeapmzi62YN0qnnKIyoFM7KLGm313tqtlaU4yGORsNQSRBTMHLoQqncf68CfDCw
         uNHWYEteQ3ctyQ9Bo5Yjy21uPeEKbW5iHFj8PZ3vsAWucAYDM4PQpyaTeoEcN9VibIRW
         kW9HKXbPiRYsJpCXRe0RCAhQyh2CmXqCUfuodt5oldcqvuKAmswI7YEeaClaWXzz0j22
         0XrlLIeYkxkCVDw3QvEaeZgEUdisGiAvZ8Kx9TFrNBTFYu0WcJZKfMEjSPLGxhdXEAj4
         X5WgqTBB4Vd5iLqT1/k0lHrvUzAKGKT0+5HyO4mYKy/o+jmhahx4zHJyxRQRl7091PeT
         XUKA==
X-Gm-Message-State: AOAM530j44crAyu4EqU1dQ1fv0AGAXPzHRazTVZXrAktsXQ+1IRqoPUj
        SdjyyzjjV7FMAI0HEuM3rL8=
X-Google-Smtp-Source: ABdhPJzJoeMfm9yb4ykA4VQqjob3L1dTR1jGK0bpZKmOxdgkOzg82y+ruzcbLkM1cWTVuglShYikiQ==
X-Received: by 2002:a17:90a:684d:: with SMTP id e13mr11225600pjm.161.1619015643726;
        Wed, 21 Apr 2021 07:34:03 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 14sm2072289pfi.145.2021.04.21.07.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 07:34:02 -0700 (PDT)
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Quentin Perret <qperret@google.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Android Kernel Team <kernel-team@android.com>,
        Architecture Mailman List <boot-architecture@lists.linaro.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <4a4734d6-49df-677b-71d3-b926c44d89a9@foss.st.com>
 <CAL_JsqKGG8E9Y53+az+5qAOOGiZRAA-aD-1tKB-hcOp+m3CJYw@mail.gmail.com>
 <001f8550-b625-17d2-85a6-98a483557c70@foss.st.com>
 <CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com>
 <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
 <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
 <YH/ixPnHMxNo08mJ@google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc8f96a4-6c85-b869-d3cf-5dc543982054@gmail.com>
Date:   Wed, 21 Apr 2021 07:33:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YH/ixPnHMxNo08mJ@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/21/2021 1:31 AM, Quentin Perret wrote:
> On Tuesday 20 Apr 2021 at 09:33:56 (-0700), Florian Fainelli wrote:
>> I do wonder as well, we have a 32MB "no-map" reserved memory region on
>> our platforms located at 0xfe000000. Without the offending commit,
>> /proc/iomem looks like this:
>>
>> 40000000-fdffefff : System RAM
>>   40008000-40ffffff : Kernel code
>>   41e00000-41ef1d77 : Kernel data
>> 100000000-13fffffff : System RAM
>>
>> and with the patch applied, we have this:
>>
>> 40000000-fdffefff : System RAM
>>   40008000-40ffffff : Kernel code
>>   41e00000-41ef3db7 : Kernel data
>> fdfff000-ffffffff : System RAM
>> 100000000-13fffffff : System RAM
>>
>> so we can now see that the region 0xfe000000 - 0xfffffff is also cobbled
>> up with the preceding region which is a mailbox between Linux and the
>> secure monitor at 0xfdfff000 and of size 4KB. It seems like there is
>>
>> The memblock=debug outputs is also different:
>>
>> [    0.000000] MEMBLOCK configuration:
>> [    0.000000]  memory size = 0xfdfff000 reserved size = 0x7ce4d20d
>> [    0.000000]  memory.cnt  = 0x2
>> [    0.000000]  memory[0x0]     [0x00000040000000-0x000000fdffefff],
>> 0xbdfff000 bytes flags: 0x0
>> [    0.000000]  memory[0x1]     [0x00000100000000-0x0000013fffffff],
>> 0x40000000 bytes flags: 0x0
>> [    0.000000]  reserved.cnt  = 0x6
>> [    0.000000]  reserved[0x0]   [0x00000040003000-0x0000004000e494],
>> 0xb495 bytes flags: 0x0
>> [    0.000000]  reserved[0x1]   [0x00000040200000-0x00000041ef1d77],
>> 0x1cf1d78 bytes flags: 0x0
>> [    0.000000]  reserved[0x2]   [0x00000045000000-0x000000450fffff],
>> 0x100000 bytes flags: 0x0
>> [    0.000000]  reserved[0x3]   [0x00000047000000-0x0000004704ffff],
>> 0x50000 bytes flags: 0x0
>> [    0.000000]  reserved[0x4]   [0x000000c2c00000-0x000000fdbfffff],
>> 0x3b000000 bytes flags: 0x0
>> [    0.000000]  reserved[0x5]   [0x00000100000000-0x0000013fffffff],
>> 0x40000000 bytes flags: 0x0
>>
>> [    0.000000] MEMBLOCK configuration:
>> [    0.000000]  memory size = 0x100000000 reserved size = 0x7ca4f24d
>> [    0.000000]  memory.cnt  = 0x3
>> [    0.000000]  memory[0x0]     [0x00000040000000-0x000000fdffefff],
>> 0xbdfff000 bytes flags: 0x0
>> [    0.000000]  memory[0x1]     [0x000000fdfff000-0x000000ffffffff],
>> 0x2001000 bytes flags: 0x4
>> [    0.000000]  memory[0x2]     [0x00000100000000-0x0000013fffffff],
>> 0x40000000 bytes flags: 0x0
>> [    0.000000]  reserved.cnt  = 0x6
>> [    0.000000]  reserved[0x0]   [0x00000040003000-0x0000004000e494],
>> 0xb495 bytes flags: 0x0
>> [    0.000000]  reserved[0x1]   [0x00000040200000-0x00000041ef3db7],
>> 0x1cf3db8 bytes flags: 0x0
>> [    0.000000]  reserved[0x2]   [0x00000045000000-0x000000450fffff],
>> 0x100000 bytes flags: 0x0
>> [    0.000000]  reserved[0x3]   [0x00000047000000-0x0000004704ffff],
>> 0x50000 bytes flags: 0x0
>> [    0.000000]  reserved[0x4]   [0x000000c3000000-0x000000fdbfffff],
>> 0x3ac00000 bytes flags: 0x0
>> [    0.000000]  reserved[0x5]   [0x00000100000000-0x0000013fffffff],
>> 0x40000000 bytes flags: 0x0
>>
>> in the second case we can clearly see that the 32MB no-map region is now
>> considered as usable RAM.
>>
>> Hope this helps.
>>
>>>
>>> In any case, the mere fact that this causes a regression should be
>>> sufficient justification to revert/withdraw it from v5.4, as I don't
>>> see a reason why it was merged there in the first place. (It has no
>>> fixes tag or cc:stable)
>>
>> Agreed, however that means we still need to find out whether a more
>> recent kernel is also broken, I should be able to tell you that a little
>> later.
> 
> FWIW I did test this on Qemu before posting. With 5.12-rc8 and a 1MiB
> no-map region at 0x80000000, I have the following:
> 
> 40000000-7fffffff : System RAM
>   40210000-417fffff : Kernel code
>   41800000-41daffff : reserved
>   41db0000-4210ffff : Kernel data
>   48000000-48008fff : reserved
> 80000000-800fffff : reserved
> 80100000-13fffffff : System RAM
>   fa000000-ffffffff : reserved
>   13b000000-13f5fffff : reserved
>   13f6de000-13f77dfff : reserved
>   13f77e000-13f77efff : reserved
>   13f77f000-13f7dafff : reserved
>   13f7dd000-13f7defff : reserved
>   13f7df000-13f7dffff : reserved
>   13f7e0000-13f7f3fff : reserved
>   13f7f4000-13f7fdfff : reserved
>   13f7fe000-13fffffff : reserved
> 
> If I remove the 'no-map' qualifier from DT, I get this:
> 
> 40000000-13fffffff : System RAM
>   40210000-417fffff : Kernel code
>   41800000-41daffff : reserved
>   41db0000-4210ffff : Kernel data
>   48000000-48008fff : reserved
>   80000000-800fffff : reserved
>   fa000000-ffffffff : reserved
>   13b000000-13f5fffff : reserved
>   13f6de000-13f77dfff : reserved
>   13f77e000-13f77efff : reserved
>   13f77f000-13f7dafff : reserved
>   13f7dd000-13f7defff : reserved
>   13f7df000-13f7dffff : reserved
>   13f7e0000-13f7f3fff : reserved
>   13f7f4000-13f7fdfff : reserved
>   13f7fe000-13fffffff : reserved
> 
> So this does seem to be working fine on my setup. I'll try again with
> 5.4 to see if I can repro.
> 
> Also, 8a5a75e5e9e5 ("of/fdt: Make sure no-map does not remove already
> reserved regions") looks more likely to cause the issue observed here,
> but that shouldn't be silent. I get the following error message in dmesg
> if I if place the no-map region on top of the kernel image:
> 
> OF: fdt: Reserved memory: failed to reserve memory for node 'foobar@40210000': base 0x0000000040210000, size 1 MiB
> 
> Is that triggering on your end?

It is not, otherwise I would have noticed earlier, can you try the same
thing that happens on my platform with a reserved region (without
no-map) adjacent to a reserved region with 'no-map'? I will test
different and newer kernels than 5.4 today to find out if this is still
a problem with upstream. I could confirm that v4.9.259 also have this
problem now.
-- 
Florian
