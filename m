Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE021EDE3C
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 09:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgFDHa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 03:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgFDHaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 03:30:25 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D24C05BD1E;
        Thu,  4 Jun 2020 00:30:25 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m81so5258334ioa.1;
        Thu, 04 Jun 2020 00:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=4MlBFAtCKoBGLDCt0vFCazTJmxySzwKV/mzAX+mxpRo=;
        b=Aw6aE6YYs1vf0ZvytGCmTJpEgnyDebpotilnLdgL3gggKOORLyLfAYTfAcccvZ6fbF
         x8D0PdYwL/MyWj5u28x0I8LxEy62SSRs2txlF3um3Qig61Km3qtetfwrdTk2D8q8fi9V
         fXNvaKchPhyMY+uA5281jIIxrwoY4U9MlWRomYvxgTDDbo7mj8XJSiBRZDpl6Bp8fXly
         6q+2ttw4kv9AE59v/u42Y8Pfiyg4hFkyuxLNpuByg3jg0cdm/56iFqs/8Cv8OzMaKq8l
         qsFm8KvTzovAq9DwjOYIDMdzysqPpKv5qvmqCQ/JEaTmo0iNxsniJUV/iXS4Qmp2Uqw/
         Xc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=4MlBFAtCKoBGLDCt0vFCazTJmxySzwKV/mzAX+mxpRo=;
        b=AB70GWUGaDVb+5wMAolIRCdighINhKHzZJFt/AXeAcz4gEHvYpLPf/8erDMCUu6Eer
         WsG00NBT8QoZNvXEOEhg6t/1RG9aQXbLlKeGSp2YY8UCfkGvIIsXbW1O6DlV6qFD58Pc
         MAfTr8dd+iYtWQbEgpojLXKdZIvy/7caYsJebnQsyCjTwqhe1l68LIyDa+uHyWT2YtyG
         e1gl11dJ3fJlnBsaCAxNQdXGAVTamFniy+RAJOMSoeOtlj+rgx32+K+mMj2kDfFSrKPW
         /41R0LfexkO6xRtipWKHh0T/6tx8fz3CcRg57n8Z2uTMepvO/qoeB5Uf1yERbAF65ozu
         0rNg==
X-Gm-Message-State: AOAM5334iEx/Nx6sdomgUZvJ8ZISY/rvCV35rpCmUKxJtuDD0rMGr29M
        BMfxJwKTR8uDyh1zMtav9FeyXxiTF64ZBGCFP78=
X-Google-Smtp-Source: ABdhPJxBgqjQl2KLHWQAdSszXSVQnbUmbEFSXhlhTk5cB6cT1BQC/J42JPcUgI56K8MtsC891r7tTSIXhJA+tn6x/c0=
X-Received: by 2002:a05:6602:2c45:: with SMTP id x5mr2921898iov.80.1591255824895;
 Thu, 04 Jun 2020 00:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200602132702.y3tjwvqdbww7oy5i@treble> <20200602193100.229287-1-inglorion@google.com>
In-Reply-To: <20200602193100.229287-1-inglorion@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Jun 2020 09:30:13 +0200
Message-ID: <CA+icZUWe3ezev3rQJO4rJ5trSPoSfUX+eOBqPXbJhRe-EZQ6-w@mail.gmail.com>
Subject: Re: [PATCH v2] x86_64: fix jiffies ODR violation
To:     Bob Haarman <inglorion@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alistair Delva <adelva@google.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        Ross Zwisler <zwisler@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 2, 2020 at 9:31 PM 'Bob Haarman' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> 'jiffies' and 'jiffies_64' are meant to alias (two different symbols
> that share the same address).  Most architectures make the symbols alias
> to the same address via linker script assignment in their
> arch/<arch>/kernel/vmlinux.lds.S:
>
> jiffies = jiffies_64;
>
> which is effectively a definition of jiffies.
>
> jiffies and jiffies_64 are both forward declared for all arch's in:
> include/linux/jiffies.h.
>
> jiffies_64 is defined in kernel/time/timer.c for all arch's.
>
> x86_64 was peculiar in that it wasn't doing the above linker script
> assignment, but rather was:
> 1. defining jiffies in arch/x86/kernel/time.c instead via linker script.
> 2. overriding the symbol jiffies_64 from kernel/time/timer.c in
> arch/x86/kernel/vmlinux.lds.s via 'jiffies_64 = jiffies;'.
>
> As Fangrui notes:
>
>   In LLD, symbol assignments in linker scripts override definitions in
>   object files. GNU ld appears to have the same behavior. It would
>   probably make sense for LLD to error "duplicate symbol" but GNU ld
>   is unlikely to adopt for compatibility reasons.
>
> So we have an ODR violation (UB), which we seem to have gotten away
> with thus far. Where it becomes harmful is when we:
>
> 1. Use -fno-semantic-interposition.
>
> As Fangrui notes:
>
>   Clang after LLVM commit 5b22bcc2b70d
>   ("[X86][ELF] Prefer to lower MC_GlobalAddress operands to .Lfoo$local")
>   defaults to -fno-semantic-interposition similar semantics which help
>   -fpic/-fPIC code avoid GOT/PLT when the referenced symbol is defined
>   within the same translation unit. Unlike GCC
>   -fno-semantic-interposition, Clang emits such relocations referencing
>   local symbols for non-pic code as well.
>
> This causes references to jiffies to refer to '.Ljiffies$local' when
> jiffies is defined in the same translation unit. Likewise, references
> to jiffies_64 become references to '.Ljiffies_64$local' in translation
> units that define jiffies_64.  Because these differ from the names
> used in the linker script, they will not be rewritten to alias one
> another.
>
> Combined with ...
>
> 2. Full LTO effectively treats all source files as one translation
> unit, causing these local references to be produced everywhere.  When
> the linker processes the linker script, there are no longer any
> references to jiffies_64' anywhere to replace with 'jiffies'.  And
> thus '.Ljiffies$local' and '.Ljiffies_64$local' no longer alias
> at all.
>
> In the process of porting patches enabling Full LTO from arm64 to
> x86_64, we observe spooky bugs where the kernel appeared to boot, but
> init doesn't get scheduled.
>
> Instead, we can avoid the ODR violation by matching other arch's by
> defining jiffies only by linker script.  For -fno-semantic-interposition
> + Full LTO, there is no longer a global definition of jiffies for the
> compiler to produce a local symbol which the linker script won't ensure
> aliases to jiffies_64.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/852
> Fixes: 40747ffa5aa8 ("asmlinkage: Make jiffies visible")
> Cc: stable@vger.kernel.org
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Reported-by: Alistair Delva <adelva@google.com>
> Suggested-by: Fangrui Song <maskray@google.com>
> Debugged-by: Nick Desaulniers <ndesaulniers@google.com>
> Debugged-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Bob Haarman <inglorion@google.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
> v2:
> * Changed commit message as requested by Josh Poimboeuf
>   (no code change)
>

Hi,

I have tested v2 with my local patch-series together.

Feel free to add my...

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # build+boot on
Debian/testing AMD64 with selfmade llvm-toolchain v10.0.1-rc1+

Thanks.

Regards,
- Sedat -

> ---
>  arch/x86/kernel/time.c        | 4 ----
>  arch/x86/kernel/vmlinux.lds.S | 4 ++--
>  2 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
> index 371a6b348e44..e42faa792c07 100644
> --- a/arch/x86/kernel/time.c
> +++ b/arch/x86/kernel/time.c
> @@ -25,10 +25,6 @@
>  #include <asm/hpet.h>
>  #include <asm/time.h>
>
> -#ifdef CONFIG_X86_64
> -__visible volatile unsigned long jiffies __cacheline_aligned_in_smp = INITIAL_JIFFIES;
> -#endif
> -
>  unsigned long profile_pc(struct pt_regs *regs)
>  {
>         unsigned long pc = instruction_pointer(regs);
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 1bf7e312361f..7c35556c7827 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -40,13 +40,13 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT)
>  #ifdef CONFIG_X86_32
>  OUTPUT_ARCH(i386)
>  ENTRY(phys_startup_32)
> -jiffies = jiffies_64;
>  #else
>  OUTPUT_ARCH(i386:x86-64)
>  ENTRY(phys_startup_64)
> -jiffies_64 = jiffies;
>  #endif
>
> +jiffies = jiffies_64;
> +
>  #if defined(CONFIG_X86_64)
>  /*
>   * On 64-bit, align RODATA to 2MB so we retain large page mappings for
> --
> 2.27.0.rc2.251.g90737beb825-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200602193100.229287-1-inglorion%40google.com.
