Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD7653C661
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 09:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242603AbiFCHh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 03:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242576AbiFCHh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 03:37:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8C621259;
        Fri,  3 Jun 2022 00:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10403B82235;
        Fri,  3 Jun 2022 07:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4209EC385A9;
        Fri,  3 Jun 2022 07:37:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PEF+Ksuc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654241836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uaKi1IzTIGb2KZNysMhgnYutjudexR4s2hA503VzOxA=;
        b=PEF+KsucGDsxexQZyubJOZY3Cv0nuO0iEFPMhId89lg5OLj4xEhy3qprX9yeYyMAg0MHvk
        dGskzqqj/9V+f/3MicIRzjwgdyMOw3MiWHKGctkVn/Py2neNWmSbSyaJtf7D8+fE1rotzE
        Q4hDTsgxvNjlP/hbRZxtOyWBWufapl4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ec908d53 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 3 Jun 2022 07:37:15 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-30c1c9b9b6cso73853097b3.13;
        Fri, 03 Jun 2022 00:37:15 -0700 (PDT)
X-Gm-Message-State: AOAM533eYWLvO06UG/MhTUtEyCygGYxELt9NJhML9IbqX6BGreVDL6Iv
        r38lY83Bcrh53m11du0c6qDtzZA38EHPwtbXh2U=
X-Google-Smtp-Source: ABdhPJxGOtZyQ0jGzoNpfODNL5uQhchVgw0VI1DxMmMX4ecPrIjECFs5BkyQT/nGBl0nS7B5+pkhSi6Xc2kTpQh3atE=
X-Received: by 2002:a0d:ef03:0:b0:2fa:245:adf3 with SMTP id
 y3-20020a0def03000000b002fa0245adf3mr10202199ywe.100.1654241834028; Fri, 03
 Jun 2022 00:37:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:6407:b0:181:6914:78f6 with HTTP; Fri, 3 Jun 2022
 00:37:13 -0700 (PDT)
In-Reply-To: <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
References: <20220602212234.344394-1-Jason@zx2c4.com> <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 3 Jun 2022 09:37:13 +0200
X-Gmail-Original-Message-ID: <CAHmME9otJN__Hq87JBiy7C_O6ZaFFFpBteuypML10BOAoZPBYw@mail.gmail.com>
Message-ID: <CAHmME9otJN__Hq87JBiy7C_O6ZaFFFpBteuypML10BOAoZPBYw@mail.gmail.com>
Subject: Re: [PATCH] ARM: initialize jump labels before setup_machine_fdt()
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ard,

On 6/3/22, Ard Biesheuvel <ardb@kernel.org> wrote:
> On Thu, 2 Jun 2022 at 23:22, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>>
>> Stephen reported that a static key warning splat appears during early
>> boot on arm64 systems that credit randomness from device trees that
>> contain an "rng-seed" property, because setup_machine_fdt() is called
>> before jump_label_init() during setup_arch(), which was fixed by
>> 73e2d827a501 ("arm64: Initialize jump labels before
>> setup_machine_fdt()").
>>
>> Upon cursory inspection, the same basic issue appears to apply to arm32
>> as well. In this case, we reorder setup_arch() to do things in the same
>> order as is now the case on arm64.
>>
>> Reported-by: Stephen Boyd <swboyd@chromium.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: stable@vger.kernel.org
>> Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
>
> Wouldn't it be better to defer the
> static_branch_enable(&crng_is_ready) call to later in the boot (e.g.,
> using an initcall()), rather than going around 'fixing' fragile,
> working early boot code across multiple architectures?

Yes, maybe. It's just more book keeping that's potentially
unnecessary, which would be nice to avoid. I wrote a patch for this
before, but it wasn't beautiful. And Catalin got a pretty easy arm64
patch queued up sufficiently fast that I figured this was better.

>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> ---
>>  arch/arm/kernel/setup.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> index 1e8a50a97edf..ef40d9f5d5a7 100644
>> --- a/arch/arm/kernel/setup.c
>> +++ b/arch/arm/kernel/setup.c
>> @@ -1097,10 +1097,15 @@ void __init setup_arch(char **cmdline_p)
>>         const struct machine_desc *mdesc = NULL;
>>         void *atags_vaddr = NULL;
>>
>> +       setup_initial_init_mm(_text, _etext, _edata, _end);
>> +       setup_processor();
>> +       early_fixmap_init();
>> +       early_ioremap_init();
>> +       jump_label_init();
>> +
>
> Is it really necessary to reorder all these calls? What does
> jump_label_init() actually need?

I'm not quite sure, but it matched how arm64 does things now. Was
hoping somebody with deep arm32 knowledge (e.g. you or rmk) would be
able to eyeball that to confirm.

Jason
