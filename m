Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2753C533
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 08:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbiFCGxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 02:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241525AbiFCGxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 02:53:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD763669D;
        Thu,  2 Jun 2022 23:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D510B8222F;
        Fri,  3 Jun 2022 06:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4E4C34114;
        Fri,  3 Jun 2022 06:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654239192;
        bh=4kiwAXxTd5EFLJFklr/uinCBNS2WrG3A8QFkFVilo/Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZBYlKQXOAG9cVfZy3IEd/nTYWdZLYIdW0bbc2KQpa9ePcizpeffMaiJcxOMI9Te8r
         mrmfLyjdfNKPXUzk2c8tYv56JfShBALH6wc7cvB2AnRbgqPwETeyjha6uw0evbNcdo
         rMDN9Ur8wCOO4OIvtJwLMtmgVD+oBBeznopvRA0OcEKKinIplReg1u73646gzrqakt
         0s0iHYB2MNsPGsqPp2YGwIDLNT+ljyWUHq4G0QrQknAaBcY9Sb5wk6G6qhTaoH+Gcq
         dRWi02zoqp0ngnCCZ0MjxRBhhvJwuzXgK8Z4FGh8nfcqnpFQ7m4d4DAGYE+D6sFeKR
         2DXj/gDrHJwoQ==
Received: by mail-oi1-f172.google.com with SMTP id s8so4100172oib.6;
        Thu, 02 Jun 2022 23:53:12 -0700 (PDT)
X-Gm-Message-State: AOAM530zekfoDHeMaa8aOJ6W5jF5iv/7cSlIGO9miI2JP3OBXeuGpiXz
        xmOCwstGfJTtbgpra05shXipyuum46pfxg0ORN4=
X-Google-Smtp-Source: ABdhPJxa6gfpLwNr4hl8bLWkUKUtjQv5VONEmtC9iB+468r/tHaY4U1DDyhG6VltieIHtY9LINCXH2RU9xq97PsH9GE=
X-Received: by 2002:a05:6808:300e:b0:32c:425e:df34 with SMTP id
 ay14-20020a056808300e00b0032c425edf34mr4652911oib.126.1654239191301; Thu, 02
 Jun 2022 23:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220602212234.344394-1-Jason@zx2c4.com>
In-Reply-To: <20220602212234.344394-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 3 Jun 2022 08:53:00 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
Message-ID: <CAMj1kXE=17f7kVs7RbUnBsUxyJKoH9mr-bR7jVR-XTBivqZRTw@mail.gmail.com>
Subject: Re: [PATCH] ARM: initialize jump labels before setup_machine_fdt()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
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

On Thu, 2 Jun 2022 at 23:22, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Stephen reported that a static key warning splat appears during early
> boot on arm64 systems that credit randomness from device trees that
> contain an "rng-seed" property, because setup_machine_fdt() is called
> before jump_label_init() during setup_arch(), which was fixed by
> 73e2d827a501 ("arm64: Initialize jump labels before
> setup_machine_fdt()").
>
> Upon cursory inspection, the same basic issue appears to apply to arm32
> as well. In this case, we reorder setup_arch() to do things in the same
> order as is now the case on arm64.
>
> Reported-by: Stephen Boyd <swboyd@chromium.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")

Wouldn't it be better to defer the
static_branch_enable(&crng_is_ready) call to later in the boot (e.g.,
using an initcall()), rather than going around 'fixing' fragile,
working early boot code across multiple architectures?

> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/arm/kernel/setup.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 1e8a50a97edf..ef40d9f5d5a7 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -1097,10 +1097,15 @@ void __init setup_arch(char **cmdline_p)
>         const struct machine_desc *mdesc = NULL;
>         void *atags_vaddr = NULL;
>
> +       setup_initial_init_mm(_text, _etext, _edata, _end);
> +       setup_processor();
> +       early_fixmap_init();
> +       early_ioremap_init();
> +       jump_label_init();
> +

Is it really necessary to reorder all these calls? What does
jump_label_init() actually need?

If this is related to the code patching, I wonder whether it wouldn't
be better not to rewrite all the NOPs (this is a x86-ism as every new
x86 uarch appears to have a better [faster?] NOP than the previous
one)

The issue with changes like these is that we might end up with bug
report in ~3 months' time that 'obscure platform X no longer boots or
produces any output'. In the best case, we'll have a bisect report
identifying this patch, but we won't be able to simply revert it as it
would reintroduce this issue into a kernel that is now stable.



>         if (__atags_pointer)
>                 atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
>
> -       setup_processor();
>         if (atags_vaddr) {
>                 mdesc = setup_machine_fdt(atags_vaddr);
>                 if (mdesc)
> @@ -1125,15 +1130,10 @@ void __init setup_arch(char **cmdline_p)
>         if (mdesc->reboot_mode != REBOOT_HARD)
>                 reboot_mode = mdesc->reboot_mode;
>
> -       setup_initial_init_mm(_text, _etext, _edata, _end);
> -
>         /* populate cmd_line too for later use, preserving boot_command_line */
>         strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
>         *cmdline_p = cmd_line;
>
> -       early_fixmap_init();
> -       early_ioremap_init();
> -
>         parse_early_param();
>
>  #ifdef CONFIG_MMU
> --
> 2.35.1
>
