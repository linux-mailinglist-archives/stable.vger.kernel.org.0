Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C74240D09
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 20:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgHJSdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 14:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgHJSdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 14:33:07 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9312BC061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 11:33:07 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so5470009plt.3
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 11:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ut33wnU3evyQXWlinpE8dvgKmV5UI4ScBRUoelbVE5c=;
        b=nUJZ+7e+ugKadp89+aDttSKsNbyKiECi6l1q0lnNDnjAHdqrNOwHUJFShF0dRdANUC
         gFVN0wlLIaiMLfXT3LbqH99WySabzY6sZHcBIVsV3SIZnMlxZRadKWP31AAbygRHAPIg
         /1UuneFNUiR6Rsw12+LO9R5mV6zWrzJ3ZPWrM5RCsEhDT66+2muKAhiXRW4phT7H1Eeq
         pjos4h9KBBchONnzeGpCAh/QpxUhAFlF9EalPcQeBf0ACfS0uYm1LOutdNJy+quUajhM
         pqwR01v5BN0Spk3TMk4owmlDK65JXycdECNCzR8SsfnzbMpBXjjPNbtSMcQbcTTNXhXj
         PrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ut33wnU3evyQXWlinpE8dvgKmV5UI4ScBRUoelbVE5c=;
        b=HokrG/Ro1rhmqUYAe0IBsmkXvjkI9kRfk8Tw/ElA5eMXbkjM/6iwJ7GKKn+0QZnnm7
         lR6SqP365c8cHFG/se+kEOPWBsJI/GyWSb4TZwAOgrxDBAkvSztc9XcSG7VmxTdpdj4q
         iuO6RSoAzDHqSxdRfFIy2PDOzw05LS4GsknMjyaT3BxlbDn5IzuJsZoTShsoYLIQglRB
         gS+ykd77/eo3TJ3UyvbKzLWOVp2ETA6O2onXe1Tili5j9k8cZOMDjDg3epgd/ZnUKhvj
         KrVEGcDwg5XoLlkaqplNaDJ6jLTvgxA1wV4TGnpcxj3aLfpU5vu6PiHyyv1pF42sUTha
         AVLw==
X-Gm-Message-State: AOAM530ZuLaeWIRTvZwdXlTQK5IMjM60WoldK0CNlhikCFJdNuVyB8fN
        GEXKAb7JHehFMI/ySssCHY4seCFU7TZPMguTbfjsaA==
X-Google-Smtp-Source: ABdhPJwLLd2XN6b1odd6eKq0W0Tyf7sODkGSZuRVexJlvP6Fg8WG5riY3XPblus+Bd/M3m74TEqSKBhKCEodNsagM2I=
X-Received: by 2002:a17:90a:fc98:: with SMTP id ci24mr639051pjb.101.1597084386868;
 Mon, 10 Aug 2020 11:33:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200807194100.3570838-1-ndesaulniers@google.com>
 <20200807212914.GB1454138@rani.riverdale.lan> <CAKwvOdmD1OMnYE55O+YUkAh+C4Der+2CqKd7JVzfr0+6hYx6jw@mail.gmail.com>
 <20200808014327.GA1925552@rani.riverdale.lan>
In-Reply-To: <20200808014327.GA1925552@rani.riverdale.lan>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 10 Aug 2020 11:32:55 -0700
Message-ID: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
Subject: Re: [PATCH] x86/boot: avoid relaxable symbols with Clang
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com, "# 3.4.x" <stable@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Dmitry Golovin <dima@golovin.in>,
        Marco Elver <elver@google.com>, Nick Terrell <terrelln@fb.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 6:43 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Fri, Aug 07, 2020 at 02:54:39PM -0700, Nick Desaulniers wrote:
> > On Fri, Aug 7, 2020 at 2:29 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
> > >
> > > On Fri, Aug 07, 2020 at 12:41:00PM -0700, Nick Desaulniers wrote:
> > > > A recent change to a default value of configuration variable
> > > > (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
> > > > integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
> > > > relocations. LLD will relax instructions with these relocations based on
> > > > whether the image is being linked as position independent or not.  When
> > > > not, then LLD will relax these instructions to use absolute addressing
> > > > mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with Clang
> > > > and linked with LLD to fail to boot.
> > >
> > > It could also cause kernels compiled with gcc and linked with LLD to
> > > fail in the same way, no? The gcc/gas combination will generate the
> > > relaxed relocations from I think gas-2.26 onward. Although the only
> > > troublesome symbol in the case of gcc/gas is trampoline_32bit_src,
> > > referenced from pgtable_64.c (gcc doesn't use a GOTPC reloc for _pgtable
> > > etc).
> >
> > Thanks for taking a look, and the feedback. I appreciate it!
> >
> > $ gcc --version | head -n 1
> > gcc (Debian 9.3.0-11) 9.3.0
> > $ make -j71 clean defconfig bzImage
> > $ llvm-readelf -r arch/x86/boot/compressed/*.o | grep -e
> > R_X86_64_GOTPCRELX -e R_X86_64_REX_GOTPCRELX
> > 0000000000000114  000000120000002a R_X86_64_REX_GOTPCRELX
> > 0000000000000000 trampoline_32bit_src - 4
> > $ llvm-readelf -r arch/x86/boot/compressed/vmlinux | grep -e
> > R_X86_64_GOTPCRELX -e R_X86_64_REX_GOTPCRELX
> > $
> >
> > So it looks like yes.  I guess then we'd need to add a check for
> > CONFIG_LD_IS_LLD and CONFIG_CC_IS_GCC and binutils version is 2.26+?
> > I don't mind adding support for that combination, but I'd like to skip
> > it in this patch for the sake of backporting something small to stable
> > to get our CI green ASAP, since CONFIG_LD_IS_LLD probably doesn't
> > exist for those stable branches, which will complicate the backport of
> > such a patch.  So I'd do it in a follow up patch if we're cool with
> > that?
> >
>
> What if we did it only if we couldn't enable -pie, like the below patch?
> I think this should cover all the cases without needing LD_IS_LLD
> checks.
>
> For BFD, the only case that should change is binutils-2.26, which
> supports relaxations but not -z noreloc-overflow, and will now have
> relax-relocations disabled. It currently works (with gcc) only because
> the relaxation of
>         movq foo@GOTPCREL(%rip), %reg
> to
>         movq $foo, %reg
> in the non-pie case was only added in 2.27, which is also when -z
> noreloc-overflow was added, allowing -pie to be enabled. With 2.26, it
> only gets relaxed to
>         leaq foo(%rip), %reg
> which is all LLD currently does as well.

Sure, that will work, too.  If you'd like to send it along, please add my:
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 8abc30b27ba3..d25bb71f195a 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -60,6 +60,13 @@ else
>  KBUILD_LDFLAGS += $(shell $(LD) --help 2>&1 | grep -q "\-z noreloc-overflow" \
>         && echo "-z noreloc-overflow -pie --no-dynamic-linker")
>  endif
> +
> +# Disable relocation relaxation if not building as PIE
> +ifeq ($(filter -pie,$(KBUILD_LDFLAGS)),)
> +KBUILD_CFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
> +KBUILD_AFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
> +endif
> +
>  LDFLAGS_vmlinux := -T
>
>  hostprogs      := mkpiggy



-- 
Thanks,
~Nick Desaulniers
