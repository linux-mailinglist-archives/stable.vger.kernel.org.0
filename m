Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF75011CB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244807AbiDNNgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343952AbiDNNaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EC9A1465;
        Thu, 14 Apr 2022 06:25:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC71F612B3;
        Thu, 14 Apr 2022 13:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3534CC385AA;
        Thu, 14 Apr 2022 13:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649942742;
        bh=sX1qu7YDHYA0JsHy2eX7J6i2/0a5r/gQxQOYSL9GlXs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SiCnU1yAXDZJ2DfdqQa0nqjh5+FHDBWFumLLsCupwEInzjqdLNx9j4OcXdXMBpG6s
         Tqih8+A15L9hhdunz3322JI1pAirquE1OhR6j+K0X8ZcYvurIy6lbT8U1QO/Fd9QvP
         Ww3uSatHHP6GUXgGnMCdU9qEatbQePmN/8r36A0Bxu0OE9AgkBMiz8f/rUZWterzFk
         k4rnvq3F1YhfPl1IvxjKeGg4URrv0IO2AlgEWHqj2C7eDa87Pqd8eiJ4AKVYBh8lW7
         KZnX2YQdfZmLspRzfFdiSsKZA4jfNNf+D0KpD2/ccmq9scZMDf6dMIGKzcfTGXLh3K
         phkTavHZ8SviA==
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-df22f50e0cso5237245fac.3;
        Thu, 14 Apr 2022 06:25:42 -0700 (PDT)
X-Gm-Message-State: AOAM5333HlX1XvOoqgDkfgcFEGfiRJodsBr5SQNMoKiv4eaWxHf7L1Uv
        3Yd3LZyi5CgrE1jceU2HLw3thmmYmHmArvOlw88=
X-Google-Smtp-Source: ABdhPJyp/EdraI7LW3lHC+T6Cw6PWGqq4DBse7Ji+a2+SpHK+D9sU7GDpbn+Pvj8viHwA+HcXxMB/Yl6lQNkmRVA9Fs=
X-Received: by 2002:a05:6870:b027:b0:de:7fcd:fabf with SMTP id
 y39-20020a056870b02700b000de7fcdfabfmr1276807oae.126.1649942741344; Thu, 14
 Apr 2022 06:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220414110838.883074566@linuxfoundation.org> <20220414110844.817011928@linuxfoundation.org>
In-Reply-To: <20220414110844.817011928@linuxfoundation.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Apr 2022 15:25:29 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG9ibOZfo60_pjwqACWhfPt8=38MDJD8C_CBoLrTYmCOw@mail.gmail.com>
Message-ID: <CAMj1kXG9ibOZfo60_pjwqACWhfPt8=38MDJD8C_CBoLrTYmCOw@mail.gmail.com>
Subject: Re: [PATCH 4.19 208/338] ARM: ftrace: avoid redundant loads or
 clobbering IP
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Apr 2022 at 15:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
>

NAK. Please don't backport these patches to -stable, I thought I had
been clear on this.


> Tweak the ftrace return paths to avoid redundant loads of SP, as well as
> unnecessary clobbering of IP.
>
> This also fixes the inconsistency of using MOV to perform a function
> return, which is sub-optimal on recent micro-architectures but more
> importantly, does not perform an interworking return, unlike compiler
> generated function returns in Thumb2 builds.
>
> Let's fix this by popping PC from the stack like most ordinary code
> does.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/kernel/entry-ftrace.S | 51 +++++++++++++++-------------------
>  1 file changed, 22 insertions(+), 29 deletions(-)
>
> diff --git a/arch/arm/kernel/entry-ftrace.S b/arch/arm/kernel/entry-ftrace.S
> index 1acf4d05e94c..393c342ecd51 100644
> --- a/arch/arm/kernel/entry-ftrace.S
> +++ b/arch/arm/kernel/entry-ftrace.S
> @@ -41,10 +41,7 @@
>   * mcount can be thought of as a function called in the middle of a subroutine
>   * call.  As such, it needs to be transparent for both the caller and the
>   * callee: the original lr needs to be restored when leaving mcount, and no
> - * registers should be clobbered.  (In the __gnu_mcount_nc implementation, we
> - * clobber the ip register.  This is OK because the ARM calling convention
> - * allows it to be clobbered in subroutines and doesn't use it to hold
> - * parameters.)
> + * registers should be clobbered.
>   *
>   * When using dynamic ftrace, we patch out the mcount call by a "mov r0, r0"
>   * for the mcount case, and a "pop {lr}" for the __gnu_mcount_nc case (see
> @@ -96,26 +93,25 @@
>
>  .macro __ftrace_regs_caller
>
> -       sub     sp, sp, #8      @ space for PC and CPSR OLD_R0,
> +       str     lr, [sp, #-8]!  @ store LR as PC and make space for CPSR/OLD_R0,
>                                 @ OLD_R0 will overwrite previous LR
>
> -       add     ip, sp, #12     @ move in IP the value of SP as it was
> -                               @ before the push {lr} of the mcount mechanism
> +       ldr     lr, [sp, #8]    @ get previous LR
>
> -       str     lr, [sp, #0]    @ store LR instead of PC
> +       str     r0, [sp, #8]    @ write r0 as OLD_R0 over previous LR
>
> -       ldr     lr, [sp, #8]    @ get previous LR
> +       str     lr, [sp, #-4]!  @ store previous LR as LR
>
> -       str     r0, [sp, #8]    @ write r0 as OLD_R0 over previous LR
> +       add     lr, sp, #16     @ move in LR the value of SP as it was
> +                               @ before the push {lr} of the mcount mechanism
>
> -       stmdb   sp!, {ip, lr}
> -       stmdb   sp!, {r0-r11, lr}
> +       push    {r0-r11, ip, lr}
>
>         @ stack content at this point:
>         @ 0  4          48   52       56            60   64    68       72
> -       @ R0 | R1 | ... | LR | SP + 4 | previous LR | LR | PSR | OLD_R0 |
> +       @ R0 | R1 | ... | IP | SP + 4 | previous LR | LR | PSR | OLD_R0 |
>
> -       mov r3, sp                              @ struct pt_regs*
> +       mov     r3, sp                          @ struct pt_regs*
>
>         ldr r2, =function_trace_op
>         ldr r2, [r2]                            @ pointer to the current
> @@ -138,11 +134,9 @@ ftrace_graph_regs_call:
>  #endif
>
>         @ pop saved regs
> -       ldmia   sp!, {r0-r12}                   @ restore r0 through r12
> -       ldr     ip, [sp, #8]                    @ restore PC
> -       ldr     lr, [sp, #4]                    @ restore LR
> -       ldr     sp, [sp, #0]                    @ restore SP
> -       mov     pc, ip                          @ return
> +       pop     {r0-r11, ip, lr}                @ restore r0 through r12
> +       ldr     lr, [sp], #4                    @ restore LR
> +       ldr     pc, [sp], #12
>  .endm
>
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> @@ -158,11 +152,9 @@ ftrace_graph_regs_call:
>         bl      prepare_ftrace_return
>
>         @ pop registers saved in ftrace_regs_caller
> -       ldmia   sp!, {r0-r12}                   @ restore r0 through r12
> -       ldr     ip, [sp, #8]                    @ restore PC
> -       ldr     lr, [sp, #4]                    @ restore LR
> -       ldr     sp, [sp, #0]                    @ restore SP
> -       mov     pc, ip                          @ return
> +       pop     {r0-r11, ip, lr}                @ restore r0 through r12
> +       ldr     lr, [sp], #4                    @ restore LR
> +       ldr     pc, [sp], #12
>
>  .endm
>  #endif
> @@ -273,16 +265,17 @@ ENDPROC(ftrace_graph_caller_old)
>  .endm
>
>  .macro mcount_exit
> -       ldmia   sp!, {r0-r3, ip, lr}
> -       ret     ip
> +       ldmia   sp!, {r0-r3}
> +       ldr     lr, [sp, #4]
> +       ldr     pc, [sp], #8
>  .endm
>
>  ENTRY(__gnu_mcount_nc)
>  UNWIND(.fnstart)
>  #ifdef CONFIG_DYNAMIC_FTRACE
> -       mov     ip, lr
> -       ldmia   sp!, {lr}
> -       ret     ip
> +       push    {lr}
> +       ldr     lr, [sp, #4]
> +       ldr     pc, [sp], #8
>  #else
>         __mcount
>  #endif
> --
> 2.34.1
>
>
>
