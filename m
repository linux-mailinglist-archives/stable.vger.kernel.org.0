Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F944245434
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgHOWPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgHOWPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 18:15:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6685EC03D1C3
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 13:57:01 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a79so6213581pfa.8
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 13:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UtBjDqPvO0XxPgS4w2mz5FIgUERc0EMLvaI4Ab10ZQQ=;
        b=ALUgM3FcF2qEVoH7TniGeuZI28YG4mu8n0qX2RGR2POGI/b0FKkpQKy8WDD0tC0dT1
         CpoWwlyn4FknyQJQhjOx2qfR6ReXiG3WbYHm/KzYPyZZwIh9C4cM7npX0ICIF8YbXAQX
         l47yl2FUm9LZPzZluz0jEV4QWZlX9+lzjyFb8DJ6H1xbel7UPK9MrAVDE2K1Yxr+YkGP
         RW+zt6+uTntEs24vQyJfLU/9fG9lMHHTC4KhjVirZ9rgmofCC9BfFQDjfBAc4GCX7CJT
         siFosB/+mUhX/nK7lcm35Sp+8LJHyQDwk4ykhd8VxF1FigK0VPwjc7QQAagi2OGc4XHF
         X5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UtBjDqPvO0XxPgS4w2mz5FIgUERc0EMLvaI4Ab10ZQQ=;
        b=mX2nSR0IC352Nx0nJBK0KaTCevYQ2NYjzN3Vdw69Zlk7JLUAMXsG/dv9dy8VOgwSAc
         ANiVi83vUCRAwVkB3DbGOYd1YOYmDDWtowt4sHfHHfR8OhP6lLjOZ3kb/vrvXZe7LhK/
         O+1U8AkWmLuB8PlhTWGs2pUlLHTmGbnAamJWhtGIWrcQzvspOb7x8/1lFDp9nlUtXJe9
         rKDoXFmPgyb6DI0bOFX43fPuchs4On6oDw5/DAV7K6Jz04OfODxl6lfi7WJMf3JyLggz
         W3udzhjCw11ybLPkd+hcD51DWiBGXDkjjmc1/ueMFbRhjJ3JvtD1u015dHY85rK8Rfsk
         +GWg==
X-Gm-Message-State: AOAM531nblMsQhE4vBaDVY+G8GGS5gXpmxeZqZbjXEiLKT9j8nP6SkD/
        GVBbijULzOeMUcfshAz247h4IQ1EvCb9mbF72C9uVA==
X-Google-Smtp-Source: ABdhPJzczVhCaED7MWfeMK93Dcd77/zRrJQu9LHftmA8LrAopKmTRRIolOVSp11IYSfyOljqyR6hqYHY6bjzXsn0foE=
X-Received: by 2002:a62:8303:: with SMTP id h3mr6288262pfe.169.1597525020265;
 Sat, 15 Aug 2020 13:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200812004158.GA1447296@rani.riverdale.lan> <20200812004308.1448603-1-nivedita@alum.mit.edu>
 <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
In-Reply-To: <CA+icZUVdTT1Vz8ACckj-SQyKi+HxJyttM52s6HUtCDLFCKbFgQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Sat, 15 Aug 2020 13:56:49 -0700
Message-ID: <CAKwvOdmHxsLzou=6WN698LOGq9ahWUmztAHfUYYAUcgpH1FGRA@mail.gmail.com>
Subject: Re: [PATCH v2] x86/boot/compressed: Disable relocation relaxation
To:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ingo,
I saw you picked up Arvind's other series into x86/boot.  Would you
mind please including this, as well?  Our CI is quite red for x86...

EOM

On Sat, Aug 15, 2020 at 8:49 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Wed, Aug 12, 2020 at 2:43 AM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> >
> > The x86-64 psABI [0] specifies special relocation types
> > (R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
> > Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
> > can take advantage of for optimization (relaxation) at link time. This
> > is supported by LLD and binutils versions 2.26 onwards.
> >
> > The compressed kernel is position-independent code, however, when using
> > LLD or binutils versions before 2.27, it must be linked without the -pie
> > option. In this case, the linker may optimize certain instructions into
> > a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.
> >
> > This potential issue has been present with LLD and binutils-2.26 for a
> > long time, but it has never manifested itself before now:
> > - LLD and binutils-2.26 only relax
> >         movq    foo@GOTPCREL(%rip), %reg
> >   to
> >         leaq    foo(%rip), %reg
> >   which is still position-independent, rather than
> >         mov     $foo, %reg
> >   which is permitted by the psABI when -pie is not enabled.
> > - gcc happens to only generate GOTPCREL relocations on mov instructions.
> > - clang does generate GOTPCREL relocations on non-mov instructions, but
> >   when building the compressed kernel, it uses its integrated assembler
> >   (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
> >   which has so far defaulted to not generating the GOTPCRELX
> >   relocations.
> >
> > Nick Desaulniers reports [1,2]:
> >   A recent change [3] to a default value of configuration variable
> >   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
> >   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
> >   relocations. LLD will relax instructions with these relocations based
> >   on whether the image is being linked as position independent or not.
> >   When not, then LLD will relax these instructions to use absolute
> >   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
> >   Clang and linked with LLD to fail to boot.
> >
> > Patch series [4] is a solution to allow the compressed kernel to be
> > linked with -pie unconditionally, but even if merged is unlikely to be
> > backported. As a simple solution that can be applied to stable as well,
> > prevent the assembler from generating the relaxed relocation types using
> > the -mrelax-relocations=no option. For ease of backporting, do this
> > unconditionally.
> >
> > [0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
> > [1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
> > [2] https://github.com/ClangBuiltLinux/linux/issues/1121
> > [3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
> > [4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/
> >
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
>
> Thanks for the patch.
>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> - Sedat -
>
> [1] https://github.com/ClangBuiltLinux/linux/issues/1120#issuecomment-674409705
>
> > ---
> >  arch/x86/boot/compressed/Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> > index 3962f592633d..ff7894f39e0e 100644
> > --- a/arch/x86/boot/compressed/Makefile
> > +++ b/arch/x86/boot/compressed/Makefile
> > @@ -43,6 +43,8 @@ KBUILD_CFLAGS += -Wno-pointer-sign
> >  KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
> >  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
> >  KBUILD_CFLAGS += -D__DISABLE_EXPORTS
> > +# Disable relocation relaxation in case the link is not PIE.
> > +KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
> >
> >  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
> >  GCOV_PROFILE := n
> > --
> > 2.26.2
> >
> > --
> > You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200812004308.1448603-1-nivedita%40alum.mit.edu.



-- 
Thanks,
~Nick Desaulniers
