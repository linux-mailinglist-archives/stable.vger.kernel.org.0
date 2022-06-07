Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAEA5402C2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 17:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344325AbiFGPve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 11:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344335AbiFGPva (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 11:51:30 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1743F68BA
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 08:51:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k19so24745009wrd.8
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 08:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=K5CuqGvNcDyd9yi9QoNJfMD+eVto/9nC9r6LjdgJwPQ=;
        b=ot/s7RX/JBxW4UYpGFOQ9SUMALLp6FYPSxhJoMGZ0iIHsnn08a8LkP7T517suEvX4t
         JGSLTlCGIOpWqkT/T6cpPTY+Ey7cy/7Mo6rQg89XDFb79NMkFrWmBqnK5eWAKVsJi6Ru
         HeU2LZKRa87uYCbSOV9hjANMwctX2Wmq0F3tXU+cQwTD52+cOC6Je9Ag9uXjd0NE32Ur
         wlCe/2WETAJ63fomkIBHEqzswV02xjVKDgwIU7uN5+6I1u6uKmFxJNpcdiHhUUntvQoZ
         oR9C+JhWLlzIz170SLsu1btpxLPQ4NaQZX6P4QtM+6i3TpxbAXPWoAfXLO2fChAFKL/S
         FFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K5CuqGvNcDyd9yi9QoNJfMD+eVto/9nC9r6LjdgJwPQ=;
        b=Ibq791V9MncvoEgsra9s94/8Ke1YpORITdBhJTY9xNtDdMgCuVYMOqKdwF7eKeYSP8
         HpDvios0+d1GV7hRXO+cirOa2flQSk4vwPZCyZPLnYgPSOw5P6GbspHK7HkxIoUAnmPU
         WoVhsE5fnGZSTnxe/mjq+UksX8dhSYv4K69zGTpnzpLqHJOLUvP9i3GYUGV2PZ0FB6tI
         WVT4CuInbX0Ov4DgaO0KMxXe+DdI31wdmFmvsRpoeZaKyzmkZRt0x2DLpiriGCy50Q0O
         +q5e/Hy9ezk+V60oIwTCqw0Z0pkPBD/9hIrBNVTf+hHuxKLbDAWqLsuRyP/6DcVT3VCa
         uwsQ==
X-Gm-Message-State: AOAM531C6xF8K96dsOU+G/kBkSwJSN4wx+V3/ZyGkhXuvQVoohdIXZgU
        FjZ2wIuvssjhxTgokl23jeQsiIQqivhpGA54
X-Google-Smtp-Source: ABdhPJyEcO3tLwsW37kFBKhU2cLcNbI8JHPKRItBuLBMVhHZcRPY1PLYXUTx4FXd9LwMN6oTCY2txg==
X-Received: by 2002:a5d:6d84:0:b0:217:e7af:224b with SMTP id l4-20020a5d6d84000000b00217e7af224bmr13602300wrs.512.1654617087049;
        Tue, 07 Jun 2022 08:51:27 -0700 (PDT)
Received: from [192.168.187.211] ([86.12.200.143])
        by smtp.gmail.com with ESMTPSA id y6-20020a5d6146000000b0020d106c0386sm18671940wrt.89.2022.06.07.08.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 08:51:26 -0700 (PDT)
Message-ID: <5bf38235-39f4-6275-9047-f645cd25fc93@raspberrypi.com>
Date:   Tue, 7 Jun 2022 16:51:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9o6R2RRdwzB9f+464xH+Aw-9wx2dm=ZsQYFbTk_-66yJw@mail.gmail.com>
 <8c3fe744-0181-043a-3af9-dd00165a6356@raspberrypi.com>
 <Yp9rc1G6xfTSSUjF@zx2c4.com>
 <25c1a57e-af67-ebc8-ab13-6532bf6e6e75@raspberrypi.com>
 <Yp9yUqHNNaAxZ/5y@zx2c4.com>
From:   Phil Elwell <phil@raspberrypi.com>
In-Reply-To: <Yp9yUqHNNaAxZ/5y@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/06/2022 16:44, Jason A. Donenfeld wrote:
> Hi Phil,
> 
> On Tue, Jun 07, 2022 at 04:35:32PM +0100, Phil Elwell wrote:
>> Jason,
>>
>> On 07/06/2022 16:14, Jason A. Donenfeld wrote:
>>> Hey again,
>>>
>>> On Tue, Jun 07, 2022 at 10:15:27AM +0100, Phil Elwell wrote:
>>>> On 07/06/2022 09:43, Jason A. Donenfeld wrote:
>>>>> Hi Phil,
>>>>>
>>>>> On Tue, Jun 7, 2022 at 10:29 AM Phil Elwell <phil@raspberrypi.com> wrote:
>>>>>>
>>>>>> This patch is fatal for me in the downstream Raspberry Pi kernel - it locks up
>>>>>> on boot even before the earlycon output is available. Hacking jump_label_init to
>>>>>> skip the jump_entry for "crng_is_ready" allows it to boot, but is likely to have
>>>>>> consequences further down the line.
>>>>>
>>>>> Also, reading this a few times, I'm not 100% sure I understand what
>>>>> you did to hack around this and why that works. Think you could paste
>>>>> your hackpatch just out of interest to the discussion (but obviously
>>>>> not to be applied)?
>>>>
>>>> This is the minimal version of my workaround patch that at least allows the
>>>> board to boot. Bear in mind that it was written with no previous knowledge of
>>>> jump labels and was arrived at by iteratively bisecting the list of jump_labels
>>>> until the first dangerous one was found, then later working out that there was
>>>> only one.
>>>
>>> Looks like this patch fails due to CONFIG_STRICT_KERNEL_RWX.
>>> Investigating deeper now, but that for starters seems to be the
>>> differentiating factor between my prior test rig and one that reproduces
>>> the error. I assume your raspi also sets CONFIG_STRICT_KERNEL_RWX.
>>
>> Yes, it does, as does multi_v7_defconfig.
> 
> Oh good. Adjusting my CI now to have that.
> 
> Having tickled arch/arm/ a little bit now, this is looking sort of
> complicated. So I think I might be leaning toward giving up and just
> rolling with <https://git.zx2c4.com/linux-rng/commit/?id=78f79dda>.
> 
> Unless of course somebody has some ARM chops and can think of a quick
> easy fix.

I've not looked at the performance implications (if any), but in terms of when the RNG initilialization completes and the lack of a WARN I'm happy with that patch, a.k.a. [1].

Phil

[1] https://lore.kernel.org/lkml/20220607100210.683136-1-Jason@zx2c4.com/
