Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE7F241F79
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 19:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgHKR6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 13:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgHKR6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 13:58:52 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB9FC06178A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 10:58:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o1so7190240plk.1
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 10:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PwLucdZe8Zl1sdg+rBs5gzd1/sOQ/Nnh9Dc69W2ZlPY=;
        b=hppMyx4QKg2UJb3qxcOpI1jplSB7I/4IFRBebdNFDIqOIqmv+o7ixbitDdJGq3vcUG
         /KLrDrbfIybVPxf4/FXQdluXL88QfJ4XeHlgDSolu6c9dhZgMa2k/A4bIO1QoVD7GpgV
         Xwf3wYgXY3X/aoeA7y5BvM3uCAnmjfQ6O8cf/kfy+Jutrx4PW4ESll6hVdsA6UBh8a9o
         HzLpmRdRsGUmK5Tgd0bGDdJBTbblNpmqczmsB0ax2StXBX0bj9yxckMDjNwn4O119Kqj
         5QrM6y8TkZa3EXfv60POSf2PJEcWYUpNGyED/o7RYz4ryhrU01nYUgmZDFGPDTj1Clfs
         Oy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PwLucdZe8Zl1sdg+rBs5gzd1/sOQ/Nnh9Dc69W2ZlPY=;
        b=ab09dPIVgNx73icsDzyipFXh6R8o8ZYdAZnkhQG4YY4mQqzXRc4C4o4npUK1i0DzdS
         rErV1JR0fRw82roQn/jhxH/waBag6UAw2QH4i19BeT48eVhN0juoAB58OD6T+YtxzXdh
         iH8rC5sdWjKqiiKLbONmS4OaZFaRUV8kDEOctfhh2Im6K6DYItNe1lxgwKajQGcRnO1b
         w85AFBu8NhadRjYVj68P1AVuXWpRv8tFPNZXhgPGFmRA0xqa9SPwpCg0gq2EsivS8qGX
         mkUlqJcqi6PWH3ELYszJ5fRDlOYBZuZ+bmt7K5PjgY5aJyaxfRIYTW7zNnOnn1nB58W+
         qdyw==
X-Gm-Message-State: AOAM530B/llANumMUlQJyev2oNau93xJaO0fGAfgdMo4qlZl5K1N19Qz
        +HSm54NiUwyxxDH8+KsYAIRV1UKTBAK4xF2BsS1RSA==
X-Google-Smtp-Source: ABdhPJxrSYKU0WVBLGO8gzWsZ4Pu3tdO1qmy4CCNWHjfKq3SyuYhth5Im8WYLZE7blUD1zlIfFUbNzPcZ9l5upHTYZ8=
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr2287166pjp.32.1597168731165;
 Tue, 11 Aug 2020 10:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
 <20200811173655.1162093-1-nivedita@alum.mit.edu>
In-Reply-To: <20200811173655.1162093-1-nivedita@alum.mit.edu>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 11 Aug 2020 10:58:40 -0700
Message-ID: <CAKwvOdnjLfQ0fWsrFYDJ2O+qFAfEFnTEEnW-aHrPha8G3_WTrg@mail.gmail.com>
Subject: Re: [PATCH] x86/boot/compressed: Disable relocation relaxation for
 non-pie link
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 10:36 AM Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> The x86-64 psABI [0] specifies special relocation types
> (R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
> Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
> can take advantage of for optimization (relaxation) at link time. This
> is supported by LLD and binutils versions 2.26 onwards.
>
> The compressed kernel is position-independent code, however, when using
> LLD or binutils versions before 2.27, it must be linked without the -pie
> option. In this case, the linker may optimize certain instructions into
> a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.
>
> This potential issue has been present with LLD and binutils-2.26 for a
> long time, but it has never manifested itself before now:
> - LLD and binutils-2.26 only relax
>         movq    foo@GOTPCREL(%rip), %reg
>   to
>         leaq    foo(%rip), %reg
>   which is still position-independent, rather than
>         mov     $foo, %reg
>   which is permitted by the psABI when -pie is not enabled.
> - gcc happens to only generate GOTPCREL relocations on mov instructions.
> - clang does generate GOTPCREL relocations on non-mov instructions, but
>   when building the compressed kernel, it uses its integrated assembler
>   (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
>   which has so far defaulted to not generating the GOTPCRELX
>   relocations.
>
> Nick Desaulniers reports [1,2]:
>   A recent change [3] to a default value of configuration variable
>   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
>   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
>   relocations. LLD will relax instructions with these relocations based
>   on whether the image is being linked as position independent or not.
>   When not, then LLD will relax these instructions to use absolute
>   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
>   Clang and linked with LLD to fail to boot.
>
> Patch series [4] is a solution to allow the compressed kernel to be
> linked with -pie unconditionally, but even if merged is unlikely to be
> backported. As a simple solution that can be applied to stable as well,
> prevent the assembler from generating the relaxed relocation types using
> the -mrelax-relocations=no option.
>
> [0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
> [1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
> [2] https://github.com/ClangBuiltLinux/linux/issues/1121
> [3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
> [4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Cc: stable@vger.kernel.org # 4.19.x

Thanks Arvind, good write up.  Just curious about this stable tag, how
come you picked 4.19?  I can see boot failures in our CI for x86+LLD
back to 4.9.  Can we amend that tag to use `# 4.9`? I'd be happy to
help submit backports should they fail to apply cleanly.
https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/builds/179237488

> ---
>  arch/x86/boot/compressed/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 3962f592633d..c5449bea58ec 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -62,6 +62,12 @@ KBUILD_LDFLAGS += $(shell $(LD) --help 2>&1 | grep -q "\-z noreloc-overflow" \
>  endif
>  LDFLAGS_vmlinux := -T
>
> +# Disable relocation relaxation if not linking as PIE
> +ifeq ($(filter -pie,$(KBUILD_LDFLAGS)),)
> +KBUILD_CFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
> +KBUILD_AFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
> +endif
> +
>  hostprogs      := mkpiggy
>  HOST_EXTRACFLAGS += -I$(srctree)/tools/include
>
> --
> 2.26.2
>


-- 
Thanks,
~Nick Desaulniers
