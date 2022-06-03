Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB80153C6BD
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 10:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbiFCIGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 04:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiFCIGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 04:06:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D0366A0;
        Fri,  3 Jun 2022 01:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCE6AB8223C;
        Fri,  3 Jun 2022 08:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEA1C34114;
        Fri,  3 Jun 2022 08:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654243575;
        bh=jOV+4kFXxe0Izp6qfoGIZGnSMAjSISLkHUXMmU5Ma48=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=n81v8zzmlZiXXK4SJ2kJ16T41dNZjrV3LAQdUsLCBQ0BoUr99AvQhS1MHOUgpALrZ
         pK39rk+qSvvrNwSjqerMMKe9B5aw23jGdbpJx/eEHcCXKR4RHuluc2CR7tYaIsdsIc
         02Sb9F2hl57xWLbsabjw+tqCQHN9YYIx1owzcSlPWvLLkJyBqdmM2oveNyMnxxrkl0
         giIeJyscI2lEnythaEmuf8TCT9UgPa0HOM8J8T5unp+AW1a1XMusEAAMDdDOofm7h2
         Io1KP9yh3g/mR5PppyhD8Q8u3Q2xhHlu3v9WxDdnUbvDQVpOFpZ7XrF95D+n9wJant
         DURu5b6acboAQ==
Received: by mail-oi1-f175.google.com with SMTP id m82so9483095oif.13;
        Fri, 03 Jun 2022 01:06:15 -0700 (PDT)
X-Gm-Message-State: AOAM5326UKZFTIy1HxueMgIPSM2b1baNdZ9mcPjtla2PAmBqju/kIs2k
        8DDZT1ADfQYOHy9hyp4Df1EvuCblnnLcCXn1od0=
X-Google-Smtp-Source: ABdhPJw/6Ot/7ORY+siZEHzE7xqvrizivnS2lpIwWPL5vwKdw9ZBSnsK11wCCZUSF7zPJsWa5B2gMoW5gIbnqvAOQbY=
X-Received: by 2002:a05:6808:300e:b0:32c:425e:df34 with SMTP id
 ay14-20020a056808300e00b0032c425edf34mr4753594oib.126.1654243574554; Fri, 03
 Jun 2022 01:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220602212234.344394-1-Jason@zx2c4.com> <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
 <CAHmME9otJN__Hq87JBiy7C_O6ZaFFFpBteuypML10BOAoZPBYw@mail.gmail.com> <CAMj1kXFJ2d-8aEV0-NNzXeL5qQO1JHdhqEDN+84DkA=8+jpoKg@mail.gmail.com>
In-Reply-To: <CAMj1kXFJ2d-8aEV0-NNzXeL5qQO1JHdhqEDN+84DkA=8+jpoKg@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 3 Jun 2022 10:06:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGo=Jr2mZJ2ryh7Z7FgoXSBttAyX=yMhBnikK6vCXnRGg@mail.gmail.com>
Message-ID: <CAMj1kXGo=Jr2mZJ2ryh7Z7FgoXSBttAyX=yMhBnikK6vCXnRGg@mail.gmail.com>
Subject: Re: [PATCH] ARM: initialize jump labels before setup_machine_fdt()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Jun 2022 at 09:51, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> (+ Greg)
>
> On Fri, 3 Jun 2022 at 09:37, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi Ard,
> >
> > On 6/3/22, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > On Thu, 2 Jun 2022 at 23:22, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >>
> > >> Stephen reported that a static key warning splat appears during early
> > >> boot on arm64 systems that credit randomness from device trees that
> > >> contain an "rng-seed" property, because setup_machine_fdt() is called
> > >> before jump_label_init() during setup_arch(), which was fixed by
> > >> 73e2d827a501 ("arm64: Initialize jump labels before
> > >> setup_machine_fdt()").
> > >>
> > >> Upon cursory inspection, the same basic issue appears to apply to arm32
> > >> as well. In this case, we reorder setup_arch() to do things in the same
> > >> order as is now the case on arm64.
> > >>
> > >> Reported-by: Stephen Boyd <swboyd@chromium.org>
> > >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> > >> Cc: Ard Biesheuvel <ardb@kernel.org>
> > >> Cc: stable@vger.kernel.org
> > >> Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
> > >
> > > Wouldn't it be better to defer the
> > > static_branch_enable(&crng_is_ready) call to later in the boot (e.g.,
> > > using an initcall()), rather than going around 'fixing' fragile,
> > > working early boot code across multiple architectures?
> >
> > Yes, maybe. It's just more book keeping that's potentially
> > unnecessary, which would be nice to avoid. I wrote a patch for this
> > before, but it wasn't beautiful. And Catalin got a pretty easy arm64
> > patch queued up sufficiently fast that I figured this was better.
> >
>
> The problem is that your original patch was already backported as far
> back as 5.10, and so this fix will need to be as well.
>
> Playing with the code that runs before the call to setup_machine_fdt()
> is risky because it implies that issues that are introduced are likely
> to limit the ability of the system to generate diagnostic output of
> any kind, given that the device tree is what describes the topology of
> the system to the kernel. Before that, there is no serial or graphical
> console, and the only way to figure out what goes on is to connect a
> JTAG debugger and single step through the code or dump the contents of
> __log_buf[].
>
> I like the /dev/random work you have been doing but as you know, I was
> skeptical about the need to backport all of that work to -stable, and
> it appears my skepticism may have been justified.
>
> The patch in question is an unquantified performance optimization,
> which means it does not meet the stable-kernel-rules.rst criteria, but
> it was backported nonetheless. Now, we are in a situation where we
> must refactor very early boot code to address a regression introduced
> by that backport.
>
> > >
> > >> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > >> ---
> > >>  arch/arm/kernel/setup.c | 12 ++++++------
> > >>  1 file changed, 6 insertions(+), 6 deletions(-)
> > >>
> > >> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > >> index 1e8a50a97edf..ef40d9f5d5a7 100644
> > >> --- a/arch/arm/kernel/setup.c
> > >> +++ b/arch/arm/kernel/setup.c
> > >> @@ -1097,10 +1097,15 @@ void __init setup_arch(char **cmdline_p)
> > >>         const struct machine_desc *mdesc = NULL;
> > >>         void *atags_vaddr = NULL;
> > >>
> > >> +       setup_initial_init_mm(_text, _etext, _edata, _end);
> > >> +       setup_processor();
> > >> +       early_fixmap_init();
> > >> +       early_ioremap_init();
> > >> +       jump_label_init();
> > >> +
> > >
> > > Is it really necessary to reorder all these calls? What does
> > > jump_label_init() actually need?
> >
> > I'm not quite sure, but it matched how arm64 does things now. Was
> > hoping somebody with deep arm32 knowledge (e.g. you or rmk) would be
> > able to eyeball that to confirm.
> >
>
> As far as I can tell, the early patching code on ARM does not rely on
> the early fixmap code. Did you try just moving jump_label_init()
> earlier in the function?
>

The below seems to work too:

--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1101,6 +1101,7 @@ void __init setup_arch(char **cmdline_p)
                atags_vaddr = FDT_VIRT_BASE(__atags_pointer);

        setup_processor();
+       jump_label_init();
        if (atags_vaddr) {
                mdesc = setup_machine_fdt(atags_vaddr);
                if (mdesc)
