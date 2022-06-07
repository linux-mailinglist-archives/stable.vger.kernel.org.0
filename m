Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375D6540652
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347288AbiFGReg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347913AbiFGRbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8152E11CA20;
        Tue,  7 Jun 2022 10:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36343B82285;
        Tue,  7 Jun 2022 17:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7E9C34115;
        Tue,  7 Jun 2022 17:28:41 +0000 (UTC)
Date:   Tue, 7 Jun 2022 18:28:38 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 5.10 001/452] arm64: Initialize jump labels before
 setup_machine_fdt()
Message-ID: <Yp+KxkkTctBDLJTA@arm.com>
References: <20220607164908.521895282@linuxfoundation.org>
 <20220607164908.572141803@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164908.572141803@linuxfoundation.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 07, 2022 at 06:57:38PM +0200, Greg Kroah-Hartman wrote:
> From: Stephen Boyd <swboyd@chromium.org>
> 
> commit 73e2d827a501d48dceeb5b9b267a4cd283d6b1ae upstream.
> 
> A static key warning splat appears during early boot on arm64 systems
> that credit randomness from devicetrees that contain an "rng-seed"
> property. This is because setup_machine_fdt() is called before
> jump_label_init() during setup_arch(). Let's swap the order of these two
> calls so that jump labels are initialized before the devicetree is
> unflattened and the rng seed is credited.
> 
>  static_key_enable_cpuslocked(): static key '0xffffffe51c6fcfc0' used before call to jump_label_init()
>  WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:166 static_key_enable_cpuslocked+0xb0/0xb8
>  Modules linked in:
>  CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0+ #224 44b43e377bfc84bc99bb5ab885ff694984ee09ff
>  pstate: 600001c9 (nZCv dAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>  pc : static_key_enable_cpuslocked+0xb0/0xb8
>  lr : static_key_enable_cpuslocked+0xb0/0xb8
>  sp : ffffffe51c393cf0
>  x29: ffffffe51c393cf0 x28: 000000008185054c x27: 00000000f1042f10
>  x26: 0000000000000000 x25: 00000000f10302b2 x24: 0000002513200000
>  x23: 0000002513200000 x22: ffffffe51c1c9000 x21: fffffffdfdc00000
>  x20: ffffffe51c2f0831 x19: ffffffe51c6fcfc0 x18: 00000000ffff1020
>  x17: 00000000e1e2ac90 x16: 00000000000000e0 x15: ffffffe51b710708
>  x14: 0000000000000066 x13: 0000000000000018 x12: 0000000000000000
>  x11: 0000000000000000 x10: 00000000ffffffff x9 : 0000000000000000
>  x8 : 0000000000000000 x7 : 61632065726f6665 x6 : 6220646573752027
>  x5 : ffffffe51c641d25 x4 : ffffffe51c13142c x3 : ffff0a00ffffff05
>  x2 : 40000000ffffe003 x1 : 00000000000001c0 x0 : 0000000000000065
>  Call trace:
>   static_key_enable_cpuslocked+0xb0/0xb8
>   static_key_enable+0x2c/0x40
>   crng_set_ready+0x24/0x30
>   execute_in_process_context+0x80/0x90
>   _credit_init_bits+0x100/0x154
>   add_bootloader_randomness+0x64/0x78
>   early_init_dt_scan_chosen+0x140/0x184
>   early_init_dt_scan_nodes+0x28/0x4c
>   early_init_dt_scan+0x40/0x44
>   setup_machine_fdt+0x7c/0x120
>   setup_arch+0x74/0x1d8
>   start_kernel+0x84/0x44c
>   __primary_switched+0xc0/0xc8
>  ---[ end trace 0000000000000000 ]---
>  random: crng init done
>  Machine model: Google Lazor (rev1 - 2) with LTE
> 
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Link: https://lore.kernel.org/r/20220602022109.780348-1-swboyd@chromium.org
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Since Jason asked for the fixed commit (f5bda35fba61) to be reverted in
stable, please don't push this arm64 patch either. Given the risks of
breakage as on arm32 (it doesn't look like but you never know), I'm
tempted to revert it from mainline as well if Jason finds a better
solution for the early crng_reseed() call.

Thanks.

-- 
Catalin
