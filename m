Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B4365D6A
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 18:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhDTQee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 12:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbhDTQed (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 12:34:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDD9C06174A;
        Tue, 20 Apr 2021 09:34:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so20740433pjv.1;
        Tue, 20 Apr 2021 09:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UM+dMdbVQhF6/wEeJythbf1GXG4179triuvsT1MCp7k=;
        b=HHguGrca/YnX5zvrg/zyA5ib8dorH+vbiVydZIBGnOTrZDVSPKkxGmn/2Zh0ViYJPP
         vaH5/rVI//OExvBd/zrIjnsC5yHCVHTPY58I3hvbiL4gGqO/dz5QL8NdFeSlbMS9/UN4
         VOR5cWvlhiIOZaM8LvUJpfQTCVEeWBRN5TMJI0eUc1icTDGvxUNdYQfoUAz4odTFhH/M
         ACybpRbRYKvlOi/FzRdRjTl0bykJZodO4cytfZ3Vbq81uVwODLMhNgy5egt9MP4zPxru
         2fTlS+3jdOLqUwBPXtAWYPbwB5dkZncYozBR69l+mhGlPlV75eotHGeHTMhpFYDTInDs
         UGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UM+dMdbVQhF6/wEeJythbf1GXG4179triuvsT1MCp7k=;
        b=k5KCfZsIqkNjY/rTMXD2hD2szv6H6S+4+G7799ow+sQ4Goa2c4m43xA4qMygJEMHnx
         R7uKhYNoAezHsStl/vZrRbvqWKKrmb35Ndb5b+ceCd1p6uYdQo3zUW0DQQtScatfoY9V
         C+aulmNmsZNX/Yuj6uU6M6Jox5QZSX95JQEIVdmiY3k7/SFQnx9V72rROICy+LN4HX/I
         Z2h7CIVj0RAoE7qbQ3noqHEFkj5be9mD8f9ps/jSuPoD5xZqwHGmF+HNxU4+x6ajkRLT
         EcoN53G30kKlCy9hZjvVGotsZFtoe7DMcsj0UQJvSRsOPMFdX6weBw03xQRQhiPHz7vM
         VoYw==
X-Gm-Message-State: AOAM532fjgEeMP/sOkHs9f/SYjrGJz1nBeTpB0Gnkk1VcRHRgOKF7QzO
        +kOI5NM9BfK36oULVXil7Sg=
X-Google-Smtp-Source: ABdhPJzrGgZJ0j6PBXGMdQjic3VH9EIjR5N/4AUT0Jz4ZB0LyvB+65+ONhP5bpiPere+pwlvYQzI/Q==
X-Received: by 2002:a17:902:d506:b029:eb:27ef:3eb5 with SMTP id b6-20020a170902d506b02900eb27ef3eb5mr30070214plg.8.1618936439944;
        Tue, 20 Apr 2021 09:33:59 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j8sm16509941pgn.55.2021.04.20.09.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 09:33:59 -0700 (PDT)
Subject: Re: [v5.4 stable] arm: stm32: Regression observed on "no-map"
 reserved memory region
To:     Ard Biesheuvel <ardb@kernel.org>, Rob Herring <robh+dt@kernel.org>
Cc:     Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Quentin Perret <qperret@google.com>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d7f9607a-9fcb-7ba2-6e39-03030da2deb0@gmail.com>
Date:   Tue, 20 Apr 2021 09:33:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXE2Mgr9CsAMnKXff+96xhDaE5OLeNhypHvpN815vZGZhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/20/2021 9:10 AM, Ard Biesheuvel wrote:
> On Tue, 20 Apr 2021 at 17:54, Rob Herring <robh+dt@kernel.org> wrote:
>>
>> On Tue, Apr 20, 2021 at 10:12 AM Alexandre TORGUE
>> <alexandre.torgue@foss.st.com> wrote:
>>>
>>>
>>>
>>> On 4/20/21 4:45 PM, Rob Herring wrote:
>>>> On Tue, Apr 20, 2021 at 9:03 AM Alexandre TORGUE
>>>> <alexandre.torgue@foss.st.com> wrote:
>>>>>
>>>>> Hi,
>>>>
>>>> Greg or Sasha won't know what to do with this. Not sure who follows
>>>> the stable list either. Quentin sent the patch, but is not the author.
>>>> Given the patch in question is about consistency between EFI memory
>>>> map boot and DT memory map boot, copying EFI knowledgeable folks would
>>>> help (Ard B for starters).
>>>
>>> Ok thanks for the tips. I add Ard in the loop.
>>
>> Sigh. If it was only Ard I was suggesting I would have done that
>> myself. Now everyone on the patch in question and relevant lists are
>> Cc'ed.
>>
> 
> Thanks for the cc.
> 
>>>
>>> Ard, let me know if other people have to be directly added or if I have
>>> to resend to another mailing list.
>>>
>>> thanks
>>> alex
>>>
>>>>
>>>>>
>>>>> Since v5.4.102 I observe a regression on stm32mp1 platform: "no-map"
>>>>> reserved-memory regions are no more "reserved" and make part of the
>>>>> kernel System RAM. This causes allocation failure for devices which try
>>>>> to take a reserved-memory region.
>>>>>
>>>>> It has been introduced by the following path:
>>>>>
>>>>> "fdt: Properly handle "no-map" field in the memory region
>>>>> [ Upstream commit 86588296acbfb1591e92ba60221e95677ecadb43 ]"
>>>>> which replace memblock_remove by memblock_mark_nomap in no-map case.
>>>>>
> 
> Why was this backported? It doesn't look like a bugfix to me.
> 
>>>>> Reverting this patch it's fine.
>>>>>
>>>>> I add part of my DT (something is maybe wrong inside):
>>>>>
>>>>> memory@c0000000 {
>>>>>          reg = <0xc0000000 0x20000000>;
>>>>> };
>>>>>
>>>>> reserved-memory {
>>>>>          #address-cells = <1>;
>>>>>          #size-cells = <1>;
>>>>>          ranges;
>>>>>
>>>>>          gpu_reserved: gpu@d4000000 {
>>>>>                  reg = <0xd4000000 0x4000000>;
>>>>>                  no-map;
>>>>>          };
>>>>> };
>>>>>
>>>>> Sorry if this issue has already been raised and discussed.
>>>>>
> 
> Could you explain why it fails? The region is clearly part of system
> memory, and tagged as no-map, so the patch in itself is not
> unreasonable. However, we obviously have code that relies on how the
> region is represented in /proc/iomem, so it would be helpful to get
> some insight into why this is the case.

I do wonder as well, we have a 32MB "no-map" reserved memory region on
our platforms located at 0xfe000000. Without the offending commit,
/proc/iomem looks like this:

40000000-fdffefff : System RAM
  40008000-40ffffff : Kernel code
  41e00000-41ef1d77 : Kernel data
100000000-13fffffff : System RAM

and with the patch applied, we have this:

40000000-fdffefff : System RAM
  40008000-40ffffff : Kernel code
  41e00000-41ef3db7 : Kernel data
fdfff000-ffffffff : System RAM
100000000-13fffffff : System RAM

so we can now see that the region 0xfe000000 - 0xfffffff is also cobbled
up with the preceding region which is a mailbox between Linux and the
secure monitor at 0xfdfff000 and of size 4KB. It seems like there is

The memblock=debug outputs is also different:

[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0xfdfff000 reserved size = 0x7ce4d20d
[    0.000000]  memory.cnt  = 0x2
[    0.000000]  memory[0x0]     [0x00000040000000-0x000000fdffefff],
0xbdfff000 bytes flags: 0x0
[    0.000000]  memory[0x1]     [0x00000100000000-0x0000013fffffff],
0x40000000 bytes flags: 0x0
[    0.000000]  reserved.cnt  = 0x6
[    0.000000]  reserved[0x0]   [0x00000040003000-0x0000004000e494],
0xb495 bytes flags: 0x0
[    0.000000]  reserved[0x1]   [0x00000040200000-0x00000041ef1d77],
0x1cf1d78 bytes flags: 0x0
[    0.000000]  reserved[0x2]   [0x00000045000000-0x000000450fffff],
0x100000 bytes flags: 0x0
[    0.000000]  reserved[0x3]   [0x00000047000000-0x0000004704ffff],
0x50000 bytes flags: 0x0
[    0.000000]  reserved[0x4]   [0x000000c2c00000-0x000000fdbfffff],
0x3b000000 bytes flags: 0x0
[    0.000000]  reserved[0x5]   [0x00000100000000-0x0000013fffffff],
0x40000000 bytes flags: 0x0

[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x100000000 reserved size = 0x7ca4f24d
[    0.000000]  memory.cnt  = 0x3
[    0.000000]  memory[0x0]     [0x00000040000000-0x000000fdffefff],
0xbdfff000 bytes flags: 0x0
[    0.000000]  memory[0x1]     [0x000000fdfff000-0x000000ffffffff],
0x2001000 bytes flags: 0x4
[    0.000000]  memory[0x2]     [0x00000100000000-0x0000013fffffff],
0x40000000 bytes flags: 0x0
[    0.000000]  reserved.cnt  = 0x6
[    0.000000]  reserved[0x0]   [0x00000040003000-0x0000004000e494],
0xb495 bytes flags: 0x0
[    0.000000]  reserved[0x1]   [0x00000040200000-0x00000041ef3db7],
0x1cf3db8 bytes flags: 0x0
[    0.000000]  reserved[0x2]   [0x00000045000000-0x000000450fffff],
0x100000 bytes flags: 0x0
[    0.000000]  reserved[0x3]   [0x00000047000000-0x0000004704ffff],
0x50000 bytes flags: 0x0
[    0.000000]  reserved[0x4]   [0x000000c3000000-0x000000fdbfffff],
0x3ac00000 bytes flags: 0x0
[    0.000000]  reserved[0x5]   [0x00000100000000-0x0000013fffffff],
0x40000000 bytes flags: 0x0

in the second case we can clearly see that the 32MB no-map region is now
considered as usable RAM.

Hope this helps.

> 
> In any case, the mere fact that this causes a regression should be
> sufficient justification to revert/withdraw it from v5.4, as I don't
> see a reason why it was merged there in the first place. (It has no
> fixes tag or cc:stable)

Agreed, however that means we still need to find out whether a more
recent kernel is also broken, I should be able to tell you that a little
later.
-- 
Florian
