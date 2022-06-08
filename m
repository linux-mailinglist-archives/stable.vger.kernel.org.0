Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AA5542834
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 09:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiFHHpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 03:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345236AbiFHHSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 03:18:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FDD1DE2CC;
        Tue,  7 Jun 2022 23:55:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C376192F;
        Wed,  8 Jun 2022 06:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A43C341C0;
        Wed,  8 Jun 2022 06:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654671330;
        bh=Rnn1xBK4SIoD9hGohMKvEaSOmmA84kgkDcpeFkCbE0I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=svnvyldiri3TXNI0HtXisFJvUOEMCZUraz5tktAacH1aAMa2Utu1B+kdcb9Ej87lA
         Ww64rvIpAeQvbZHOHSsnrRn3S+wKiGHTiXJ7M2+6KVZmNjCT1+R6AJqDKg2WPK9SqV
         2zGOJDV77zZvhgObklf6u0vjGcW9TDy7VJ4ysUUtA0mBlssDtkj50N/Q9dSb+8Yhuy
         UTpt64QdvVNSn+4RcqEVqI1oyDSMTsW5/FRpGT4OxuoiseBtB7oVOKgfgkRcopsbiY
         HUypxIZPeu7NkrfxoOFLO9RJVQl3gvVfzS5LhPqg4iWXpY1ZuIRBwH2rY2bwRjyl35
         QIIhue+kEdwjA==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-fb1ae0cd9cso15504570fac.13;
        Tue, 07 Jun 2022 23:55:29 -0700 (PDT)
X-Gm-Message-State: AOAM530F0TCVcmgoIWh3aZnJ9ZqlY+RREbDpyYGEp+yV8VGVpq6IaiB/
        PcPak7XoRz+XFLshophF9qT0cTLT+SGNOmcWPTQ=
X-Google-Smtp-Source: ABdhPJx2F1i643WQL+zBTDpGnFGWhgyrQmob/a9LQ18PsuWS0BUtU+nfj0OwGQyxh8pQl5ZYzouobThzNc+Do1iFKbQ=
X-Received: by 2002:a05:6871:5c8:b0:f3:3c1c:126f with SMTP id
 v8-20020a05687105c800b000f33c1c126fmr1577934oan.126.1654671329179; Tue, 07
 Jun 2022 23:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164908.521895282@linuxfoundation.org> <20220607164908.572141803@linuxfoundation.org>
 <Yp+KxkkTctBDLJTA@arm.com>
In-Reply-To: <Yp+KxkkTctBDLJTA@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 8 Jun 2022 08:55:17 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEtFVWgTgKh+vV2oi-mgqfzVJnqJpTneM9mwTEC3+Nasg@mail.gmail.com>
Message-ID: <CAMj1kXEtFVWgTgKh+vV2oi-mgqfzVJnqJpTneM9mwTEC3+Nasg@mail.gmail.com>
Subject: Re: [PATCH 5.10 001/452] arm64: Initialize jump labels before setup_machine_fdt()
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Stephen Boyd <swboyd@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Jun 2022 at 19:28, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Hi Greg,
>
> On Tue, Jun 07, 2022 at 06:57:38PM +0200, Greg Kroah-Hartman wrote:
> > From: Stephen Boyd <swboyd@chromium.org>
> >
> > commit 73e2d827a501d48dceeb5b9b267a4cd283d6b1ae upstream.
> >
> > A static key warning splat appears during early boot on arm64 systems
> > that credit randomness from devicetrees that contain an "rng-seed"
> > property. This is because setup_machine_fdt() is called before
> > jump_label_init() during setup_arch(). Let's swap the order of these two
> > calls so that jump labels are initialized before the devicetree is
> > unflattened and the rng seed is credited.
> >
> >  static_key_enable_cpuslocked(): static key '0xffffffe51c6fcfc0' used before call to jump_label_init()
> >  WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:166 static_key_enable_cpuslocked+0xb0/0xb8
> >  Modules linked in:
> >  CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0+ #224 44b43e377bfc84bc99bb5ab885ff694984ee09ff
> >  pstate: 600001c9 (nZCv dAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >  pc : static_key_enable_cpuslocked+0xb0/0xb8
> >  lr : static_key_enable_cpuslocked+0xb0/0xb8
> >  sp : ffffffe51c393cf0
> >  x29: ffffffe51c393cf0 x28: 000000008185054c x27: 00000000f1042f10
> >  x26: 0000000000000000 x25: 00000000f10302b2 x24: 0000002513200000
> >  x23: 0000002513200000 x22: ffffffe51c1c9000 x21: fffffffdfdc00000
> >  x20: ffffffe51c2f0831 x19: ffffffe51c6fcfc0 x18: 00000000ffff1020
> >  x17: 00000000e1e2ac90 x16: 00000000000000e0 x15: ffffffe51b710708
> >  x14: 0000000000000066 x13: 0000000000000018 x12: 0000000000000000
> >  x11: 0000000000000000 x10: 00000000ffffffff x9 : 0000000000000000
> >  x8 : 0000000000000000 x7 : 61632065726f6665 x6 : 6220646573752027
> >  x5 : ffffffe51c641d25 x4 : ffffffe51c13142c x3 : ffff0a00ffffff05
> >  x2 : 40000000ffffe003 x1 : 00000000000001c0 x0 : 0000000000000065
> >  Call trace:
> >   static_key_enable_cpuslocked+0xb0/0xb8
> >   static_key_enable+0x2c/0x40
> >   crng_set_ready+0x24/0x30
> >   execute_in_process_context+0x80/0x90
> >   _credit_init_bits+0x100/0x154
> >   add_bootloader_randomness+0x64/0x78
> >   early_init_dt_scan_chosen+0x140/0x184
> >   early_init_dt_scan_nodes+0x28/0x4c
> >   early_init_dt_scan+0x40/0x44
> >   setup_machine_fdt+0x7c/0x120
> >   setup_arch+0x74/0x1d8
> >   start_kernel+0x84/0x44c
> >   __primary_switched+0xc0/0xc8
> >  ---[ end trace 0000000000000000 ]---
> >  random: crng init done
> >  Machine model: Google Lazor (rev1 - 2) with LTE
> >
> > Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Link: https://lore.kernel.org/r/20220602022109.780348-1-swboyd@chromium.org
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Since Jason asked for the fixed commit (f5bda35fba61) to be reverted in
> stable, please don't push this arm64 patch either. Given the risks of
> breakage as on arm32 (it doesn't look like but you never know), I'm
> tempted to revert it from mainline as well if Jason finds a better
> solution for the early crng_reseed() call.
>

So as I understand it, there are basically three options:
0. don't use a static branch in the RNG code
1. use a static branch but don't patch it extremely early
2. fix all the arch code so that it is safe to patch static branches
extremely early.

We have been digging into the ARM code yesterday, and identified that
RISC-V needs to be fixed as well. In fact, every arch that calls
early_init_dt_scan() from setup_arch() will need to be vetted to
ensure that jump label patching is possible this early.

Jason already proposed an implementation of 1) here

https://lore.kernel.org/lkml/20220607100210.683136-1-Jason@zx2c4.com/

which seems to me to be the most suitable approach by far, given that
it removes the need to fiddle with very early boot code on many
different architectures. That would also allow the arm64 of /this/
patch to be reverted from mainline.
