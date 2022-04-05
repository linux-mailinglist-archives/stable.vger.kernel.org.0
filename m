Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACCF4F3A5B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244765AbiDELoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354579AbiDEKOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EAD48893;
        Tue,  5 Apr 2022 03:01:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31FEF61500;
        Tue,  5 Apr 2022 10:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90919C385A3;
        Tue,  5 Apr 2022 10:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649152891;
        bh=bIQUhZq95WpkK5yAWtdVarFKUMKy98iiS6Cyp46/2RE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LNzaJRAuwGKUf4c1yf/YdaoF48gjw9uYiJWG2fITIXi7mXu8/iruqQAxXStLJohCW
         xbidywu7sNqiu9OlN7qpVwMM0ABVwAP6EmNQQIorbHmJwp9g68NTQcSah2bLKuSS/1
         kQ5LqGvXtoJduXlTfPww2VHimgOsS7M8fvedfUConKuYQ8AhQ1eVjvqIET5aY5NHi2
         e08tth5H1Gi5hLylylp52FxWTJpqW4f+pYb+AEvHshDQxhQyFbEuqzW98dSPKKeDtd
         hGmFgk5YqgWRsv9vr7I8IbxxzisobAP2IMtv9GoHrO8pF1qJ2Ymx/6UCDl50Wl42vm
         eZiYY9TYap5gg==
Received: by mail-ot1-f48.google.com with SMTP id n19-20020a9d7113000000b005cd9cff76c3so9062219otj.1;
        Tue, 05 Apr 2022 03:01:31 -0700 (PDT)
X-Gm-Message-State: AOAM531k1q/KFDzHe4JJtQdGWTVt8yhrsxgymZo5zwlQGjKa8noF0wkU
        /CJm6q6bjfDxvMXk25dtbezeY4jNb4W5e5yG9z8=
X-Google-Smtp-Source: ABdhPJwdM4h1wuXouDpsMq6+/mM7P8+Bck7gNkRfOEcoBRGyUHNVUre/jN39A2+lpIEupqQwQVMMyozRHgfS8ahHhmA=
X-Received: by 2002:a05:6830:2e7:b0:5b2:68c1:182a with SMTP id
 r7-20020a05683002e700b005b268c1182amr892113ote.71.1649152890703; Tue, 05 Apr
 2022 03:01:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070339.801210740@linuxfoundation.org> <20220405070402.195698649@linuxfoundation.org>
In-Reply-To: <20220405070402.195698649@linuxfoundation.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 5 Apr 2022 12:01:19 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com>
Message-ID: <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com>
Subject: Re: [PATCH 5.15 746/913] ARM: ftrace: avoid redundant loads or
 clobbering IP
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
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

On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
>
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

Please drop all the 32-bit ARM patches authored by me from the stable
queues except the ones that have fixes tags. These are highly likely
to cause an explosion of regressions, and they should have never been
selected, as I don't remember anyone proposing these for stable.


> ---
>  arch/arm/kernel/entry-ftrace.S | 51 +++++++++++++++-------------------
>  1 file changed, 22 insertions(+), 29 deletions(-)
>
> diff --git a/arch/arm/kernel/entry-ftrace.S b/arch/arm/kernel/entry-ftrace.S
> index f4886fb6e9ba..f33c171e3090 100644
> --- a/arch/arm/kernel/entry-ftrace.S
> +++ b/arch/arm/kernel/entry-ftrace.S
> @@ -22,10 +22,7 @@
>   * mcount can be thought of as a function called in the middle of a subroutine
>   * call.  As such, it needs to be transparent for both the caller and the
>   * callee: the original lr needs to be restored when leaving mcount, and no
> - * registers should be clobbered.  (In the __gnu_mcount_nc implementation, we
> - * clobber the ip register.  This is OK because the ARM calling convention
> - * allows it to be clobbered in subroutines and doesn't use it to hold
> - * parameters.)
> + * registers should be clobbered.
>   *
>   * When using dynamic ftrace, we patch out the mcount call by a "pop {lr}"
>   * instead of the __gnu_mcount_nc call (see arch/arm/kernel/ftrace.c).
> @@ -70,26 +67,25 @@
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
> @@ -112,11 +108,9 @@ ftrace_graph_regs_call:
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
> @@ -132,11 +126,9 @@ ftrace_graph_regs_call:
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
> @@ -202,16 +194,17 @@ ftrace_graph_call\suffix:
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
