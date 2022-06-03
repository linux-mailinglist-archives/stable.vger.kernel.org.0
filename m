Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF8E53C6CC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 10:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiFCIOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 04:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbiFCIOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 04:14:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6B52C644;
        Fri,  3 Jun 2022 01:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BADDCB82234;
        Fri,  3 Jun 2022 08:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258B6C385A9;
        Fri,  3 Jun 2022 08:14:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="JnRTfXkH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654244074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mkED7xl6Y+hL+Yr5/b1KF4ayONkRG9uKdwaqYnKSpn4=;
        b=JnRTfXkHW8Jf31xUHHvXf3aykXzVaGN9264fAH5pef/58zJ+jO6hWPnLk5cyIvUhsmXOa3
        gFQO9M0RZ67ig/xdJRPLBIsmsMqg+DRSJZvY/soffdaRIepTVLzA0wu/XYVpUTx4Go06n7
        A1x6RdhuikoYdQy2kBHjZ0FgsSTTQms=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0b6a4d55 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 3 Jun 2022 08:14:34 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id l204so12453578ybf.10;
        Fri, 03 Jun 2022 01:14:33 -0700 (PDT)
X-Gm-Message-State: AOAM531NNaj3R6kaGq0OVXymuztJ26g+b6mJVX1bYNXv6wE4y8UJ8qJb
        kP/l875XT3JsQx6+5MvazA3JiYzNL/rbRwim5Ng=
X-Google-Smtp-Source: ABdhPJyL1kW/0BY+NkZYTD8vD6nVQfxkehWWdvbPnzXdJhb23w5wk00pqsH0/rYJAbhFwfBzCyQre8QTRjlburtanZg=
X-Received: by 2002:a25:8d92:0:b0:656:a73e:a7f with SMTP id
 o18-20020a258d92000000b00656a73e0a7fmr9513279ybl.382.1654244072682; Fri, 03
 Jun 2022 01:14:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:6407:b0:181:6914:78f6 with HTTP; Fri, 3 Jun 2022
 01:14:32 -0700 (PDT)
In-Reply-To: <CAMj1kXGo=Jr2mZJ2ryh7Z7FgoXSBttAyX=yMhBnikK6vCXnRGg@mail.gmail.com>
References: <20220602212234.344394-1-Jason@zx2c4.com> <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
 <CAHmME9otJN__Hq87JBiy7C_O6ZaFFFpBteuypML10BOAoZPBYw@mail.gmail.com>
 <CAMj1kXFJ2d-8aEV0-NNzXeL5qQO1JHdhqEDN+84DkA=8+jpoKg@mail.gmail.com> <CAMj1kXGo=Jr2mZJ2ryh7Z7FgoXSBttAyX=yMhBnikK6vCXnRGg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 3 Jun 2022 10:14:32 +0200
X-Gmail-Original-Message-ID: <CAHmME9qPdEwx9LQj_U2S+DRjp3qiOMjGieYehsHLYqhKjAbs0g@mail.gmail.com>
Message-ID: <CAHmME9qPdEwx9LQj_U2S+DRjp3qiOMjGieYehsHLYqhKjAbs0g@mail.gmail.com>
Subject: Re: [PATCH] ARM: initialize jump labels before setup_machine_fdt()
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
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
> On Fri, 3 Jun 2022 at 09:51, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>> (+ Greg)
>>
>> On Fri, 3 Jun 2022 at 09:37, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> >
>> > Hi Ard,
>> >
>> > On 6/3/22, Ard Biesheuvel <ardb@kernel.org> wrote:
>> > > On Thu, 2 Jun 2022 at 23:22, Jason A. Donenfeld <Jason@zx2c4.com>
>> > > wrote:
>> > >>
>> > >> Stephen reported that a static key warning splat appears during
>> > >> early
>> > >> boot on arm64 systems that credit randomness from device trees that
>> > >> contain an "rng-seed" property, because setup_machine_fdt() is
>> > >> called
>> > >> before jump_label_init() during setup_arch(), which was fixed by
>> > >> 73e2d827a501 ("arm64: Initialize jump labels before
>> > >> setup_machine_fdt()").
>> > >>
>> > >> Upon cursory inspection, the same basic issue appears to apply to
>> > >> arm32
>> > >> as well. In this case, we reorder setup_arch() to do things in the
>> > >> same
>> > >> order as is now the case on arm64.
>> > >>
>> > >> Reported-by: Stephen Boyd <swboyd@chromium.org>
>> > >> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> > >> Cc: Ard Biesheuvel <ardb@kernel.org>
>> > >> Cc: stable@vger.kernel.org
>> > >> Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
>> > >
>> > > Wouldn't it be better to defer the
>> > > static_branch_enable(&crng_is_ready) call to later in the boot (e.g.,
>> > > using an initcall()), rather than going around 'fixing' fragile,
>> > > working early boot code across multiple architectures?
>> >
>> > Yes, maybe. It's just more book keeping that's potentially
>> > unnecessary, which would be nice to avoid. I wrote a patch for this
>> > before, but it wasn't beautiful. And Catalin got a pretty easy arm64
>> > patch queued up sufficiently fast that I figured this was better.
>> >
>>
>> The problem is that your original patch was already backported as far
>> back as 5.10, and so this fix will need to be as well.
>>
>> Playing with the code that runs before the call to setup_machine_fdt()
>> is risky because it implies that issues that are introduced are likely
>> to limit the ability of the system to generate diagnostic output of
>> any kind, given that the device tree is what describes the topology of
>> the system to the kernel. Before that, there is no serial or graphical
>> console, and the only way to figure out what goes on is to connect a
>> JTAG debugger and single step through the code or dump the contents of
>> __log_buf[].
>>
>> I like the /dev/random work you have been doing but as you know, I was
>> skeptical about the need to backport all of that work to -stable, and
>> it appears my skepticism may have been justified.
>>
>> The patch in question is an unquantified performance optimization,
>> which means it does not meet the stable-kernel-rules.rst criteria, but
>> it was backported nonetheless. Now, we are in a situation where we
>> must refactor very early boot code to address a regression introduced
>> by that backport.
>>
>> > >
>> > >> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> > >> ---
>> > >>  arch/arm/kernel/setup.c | 12 ++++++------
>> > >>  1 file changed, 6 insertions(+), 6 deletions(-)
>> > >>
>> > >> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> > >> index 1e8a50a97edf..ef40d9f5d5a7 100644
>> > >> --- a/arch/arm/kernel/setup.c
>> > >> +++ b/arch/arm/kernel/setup.c
>> > >> @@ -1097,10 +1097,15 @@ void __init setup_arch(char **cmdline_p)
>> > >>         const struct machine_desc *mdesc = NULL;
>> > >>         void *atags_vaddr = NULL;
>> > >>
>> > >> +       setup_initial_init_mm(_text, _etext, _edata, _end);
>> > >> +       setup_processor();
>> > >> +       early_fixmap_init();
>> > >> +       early_ioremap_init();
>> > >> +       jump_label_init();
>> > >> +
>> > >
>> > > Is it really necessary to reorder all these calls? What does
>> > > jump_label_init() actually need?
>> >
>> > I'm not quite sure, but it matched how arm64 does things now. Was
>> > hoping somebody with deep arm32 knowledge (e.g. you or rmk) would be
>> > able to eyeball that to confirm.
>> >
>>
>> As far as I can tell, the early patching code on ARM does not rely on
>> the early fixmap code. Did you try just moving jump_label_init()
>> earlier in the function?
>>
>
> The below seems to work too:
>
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -1101,6 +1101,7 @@ void __init setup_arch(char **cmdline_p)
>                 atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
>
>         setup_processor();
> +       jump_label_init();
>         if (atags_vaddr) {
>                 mdesc = setup_machine_fdt(atags_vaddr);
>                 if (mdesc)
>

Oh, awesome, that's exactly what I was about to try when I got to my
laptop in a few hours. Do you want to send the v2 with that, or should
I do so after also testing it in a bit?

Jason
