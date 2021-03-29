Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5AE34D740
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 20:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhC2Scw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 14:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhC2Sc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 14:32:26 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B29C061762
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:32:24 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id b4so19906683lfi.6
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 11:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yeNB5sEY4cPt05lVN+HkG1LRzxIjnMB5Dy/N7XWvZCE=;
        b=VGhHMfmTPR07v1DfjHVVtzyLQnebdGInigQbMPBfwaYWt7mDv7tCcmrMKvooZ7qfPg
         8sBmbelC6srradbru+Tn3QaZTcn1TPK3Za/wdwVFmyE3spGat6Ch/6BZLGj+leAqTLQ2
         yFMaWb5ErXa78ZuA9OGsHv2AUuqQMT4aH/j+9wKm7pt3E3xJo7NkTSEB1tF4ITo9s1+7
         g/GUR82HiGb+F480CL/zjgxBdmw10RnaycBZLGKoewnCjx/dND6HC2IKDkLIDOeNdE09
         WeHsHDWAbIC/O8KeG8BI2alXNkfkn+31/Qh1a/tjD5BUPgC2OpWFA4x9dj2iz5Xo7J0B
         XlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yeNB5sEY4cPt05lVN+HkG1LRzxIjnMB5Dy/N7XWvZCE=;
        b=Xq9c6gUJHxUPWpivPCJWvj5YHjvX8a5zEKCDFWL7411Pqg7g+sLNDczTJmuhKPgx7v
         7ilXcpwmncBkK6B+z3MrN1Jn2E+nFioa9Majp0B+mA+VqZdeAWBFspRin40XHBTF9QEM
         lVDCT9GsB6/3vd/osjTuwRNpF+2ztKUydxubNPzVzKRpoJ3fNRdVOCMLhqfTTUUbh7AP
         TKwn/JHrofWPxihUGe8pmlcUI8HFVWlIopNZ1vM49HjT/pj7BOGZB9mXAnFRHL2XjjO/
         pvr69PU5gMZoIeIP7AuOK7M1N4ugqWCmH92Gm/RcAUj6HsXwa7aF9wac6np/k1I2q0ca
         OcKA==
X-Gm-Message-State: AOAM530dPGHfKOTXsqk0oHYQwSjoQBRO1jDEeFwjStErJL584b7csNK6
        v7oW8BKST8GUZ+LfR014tVYP7enlYMTKhwt8X14Ssg==
X-Google-Smtp-Source: ABdhPJwAGxmrKYI2hGyfRS7Wb9JTt63w/JwuZYJF+oFLfI527SQZRGmeLq01wCEqqMpCh9u2g3EQyWjaykxNNsCTiWY=
X-Received: by 2002:a19:5055:: with SMTP id z21mr17019928lfj.297.1617042743134;
 Mon, 29 Mar 2021 11:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210325223807.2423265-1-nathan@kernel.org> <20210325223807.2423265-3-nathan@kernel.org>
In-Reply-To: <20210325223807.2423265-3-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 29 Mar 2021 11:32:12 -0700
Message-ID: <CAKwvOdn3y6DSu8i=3T9ro5KoXVNUuSrJQa-UOQB00z5ASY659Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] riscv: Workaround mcount name prior to clang-13
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 3:38 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Prior to clang 13.0.0, the RISC-V name for the mcount symbol was
> "mcount", which differs from the GCC version of "_mcount", which results
> in the following errors:
>
> riscv64-linux-gnu-ld: init/main.o: in function `__traceiter_initcall_level':
> main.c:(.text+0xe): undefined reference to `mcount'
> riscv64-linux-gnu-ld: init/main.o: in function `__traceiter_initcall_start':
> main.c:(.text+0x4e): undefined reference to `mcount'
> riscv64-linux-gnu-ld: init/main.o: in function `__traceiter_initcall_finish':
> main.c:(.text+0x92): undefined reference to `mcount'
> riscv64-linux-gnu-ld: init/main.o: in function `.LBB32_28':
> main.c:(.text+0x30c): undefined reference to `mcount'
> riscv64-linux-gnu-ld: init/main.o: in function `free_initmem':
> main.c:(.text+0x54c): undefined reference to `mcount'
>
> This has been corrected in https://reviews.llvm.org/D98881 but the
> minimum supported clang version is 10.0.1. To avoid build errors and to
> gain a working function tracer, adjust the name of the mcount symbol for
> older versions of clang in mount.S and recordmcount.pl.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1331
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for keeping this alive on clang-10, and resolving it for future releases!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/riscv/include/asm/ftrace.h | 14 ++++++++++++--
>  arch/riscv/kernel/mcount.S      | 10 +++++-----
>  scripts/recordmcount.pl         |  2 +-
>  3 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
> index 845002cc2e57..04dad3380041 100644
> --- a/arch/riscv/include/asm/ftrace.h
> +++ b/arch/riscv/include/asm/ftrace.h
> @@ -13,9 +13,19 @@
>  #endif
>  #define HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
>
> +/*
> + * Clang prior to 13 had "mcount" instead of "_mcount":
> + * https://reviews.llvm.org/D98881
> + */
> +#if defined(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 130000
> +#define MCOUNT_NAME _mcount
> +#else
> +#define MCOUNT_NAME mcount
> +#endif
> +
>  #define ARCH_SUPPORTS_FTRACE_OPS 1
>  #ifndef __ASSEMBLY__
> -void _mcount(void);
> +void MCOUNT_NAME(void);
>  static inline unsigned long ftrace_call_adjust(unsigned long addr)
>  {
>         return addr;
> @@ -36,7 +46,7 @@ struct dyn_arch_ftrace {
>   * both auipc and jalr at the same time.
>   */
>
> -#define MCOUNT_ADDR            ((unsigned long)_mcount)
> +#define MCOUNT_ADDR            ((unsigned long)MCOUNT_NAME)
>  #define JALR_SIGN_MASK         (0x00000800)
>  #define JALR_OFFSET_MASK       (0x00000fff)
>  #define AUIPC_OFFSET_MASK      (0xfffff000)
> diff --git a/arch/riscv/kernel/mcount.S b/arch/riscv/kernel/mcount.S
> index 8a5593ff9ff3..6d462681c9c0 100644
> --- a/arch/riscv/kernel/mcount.S
> +++ b/arch/riscv/kernel/mcount.S
> @@ -47,8 +47,8 @@
>
>  ENTRY(ftrace_stub)
>  #ifdef CONFIG_DYNAMIC_FTRACE
> -       .global _mcount
> -       .set    _mcount, ftrace_stub
> +       .global MCOUNT_NAME
> +       .set    MCOUNT_NAME, ftrace_stub
>  #endif
>         ret
>  ENDPROC(ftrace_stub)
> @@ -78,7 +78,7 @@ ENDPROC(return_to_handler)
>  #endif
>
>  #ifndef CONFIG_DYNAMIC_FTRACE
> -ENTRY(_mcount)
> +ENTRY(MCOUNT_NAME)
>         la      t4, ftrace_stub
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>         la      t0, ftrace_graph_return
> @@ -124,6 +124,6 @@ do_trace:
>         jalr    t5
>         RESTORE_ABI_STATE
>         ret
> -ENDPROC(_mcount)
> +ENDPROC(MCOUNT_NAME)
>  #endif
> -EXPORT_SYMBOL(_mcount)
> +EXPORT_SYMBOL(MCOUNT_NAME)
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index a36df04cfa09..7b83a1aaec98 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -392,7 +392,7 @@ if ($arch eq "x86_64") {
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
>  } elsif ($arch eq "riscv") {
>      $function_regex = "^([0-9a-fA-F]+)\\s+<([^.0-9][0-9a-zA-Z_\\.]+)>:";
> -    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_mcount\$";
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_?mcount\$";
>      $type = ".quad";
>      $alignment = 2;
>  } elsif ($arch eq "nds32") {
> --
> 2.31.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20210325223807.2423265-3-nathan%40kernel.org.



-- 
Thanks,
~Nick Desaulniers
