Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9731292E65
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 21:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbgJSTYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 15:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730845AbgJSTYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 15:24:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FA1C0613CE
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 12:24:14 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id r10so302948plx.3
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 12:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uIfWuzz/Oi2OkmAg7QQj+om01xgjYQC13tivpsY4ap0=;
        b=ju2ohyzmil762bBA/+brUwTLU43sMSwJMV0FhC8+6ixcmC2U/oxWhswQCiDoLgBTUq
         p38dzwpBKwDZa/efpZvK4m6WhqPMHbQ2nXWl6u+aLkz1P1YvH2ZTBMGTYtlij0fGVrR1
         8/4wmK5ZOlv3i1Wo/uWqlSeTjUL8TPN+LYBhvCcT+4ll1YeCG4PA5efit4fMi7TBt36X
         446mVLHBrmxiOeOxV3oXOWdivJ5xLjlSbBhAidBizfZ88KKnU02l2rj8QkkZBYdfpXMO
         V9o0f74EhHJEqH7/ORiwM5hXl41CnZyh2cXElz3eU497i0hMHhN0wQhJHKmr9CwS/VwY
         thnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uIfWuzz/Oi2OkmAg7QQj+om01xgjYQC13tivpsY4ap0=;
        b=OsMFV5mRiNv3/iY+JTQ6P5OWJmI16ByK5CEsl0Ow7NIdRq33Q4tyVF1psa4rJTcfUo
         0I3qUjfjeDvB6ggLZROcD7QP6wtj+0jBtkyGdRYBsan0FqHCcjCoTKotASkO50uerXTY
         xx2RWJ1i572Bw2Cj4ssOjMRw+PPtwEej+E7skNLgynrHEv2hNM7V9hgu6ux/8aNphjJT
         39o9XDS2NQS6CmVq7LYk3qvG5WvfLevFhTKnYl25v3mmBkNW2ibHNg/L7iMC7PZStkRM
         G7KgHo3l1VRe0HtjVJzowsHi9yxy5vIapotwUN7dFSHEgJtsd3Glb8XjjoSGAqKX9WK4
         P8Hg==
X-Gm-Message-State: AOAM531zYCBAG5o7KjFSmNlO3QFPV7j4eYe5zfCiuUV+zYe8VOebr7GW
        7bg28pAj5wWVfV5qS6k0JFBlCMsLRvamuPJiOmrYhQ==
X-Google-Smtp-Source: ABdhPJwkm9qKOonfmzQG2CiafojX189ed37IunFvJ5nWQQY16dHeLxrFVDxkHYRel+Q/LZos+oZFpTmwL6ODbB6paFw=
X-Received: by 2002:a17:902:c40b:b029:d3:def2:d90f with SMTP id
 k11-20020a170902c40bb02900d3def2d90fmr1361931plk.29.1603135453759; Mon, 19
 Oct 2020 12:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201017002500.503011-1-palmerdabbelt@google.com>
In-Reply-To: <20201017002500.503011-1-palmerdabbelt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 19 Oct 2020 12:24:02 -0700
Message-ID: <CAKwvOdnsRHA1WMb7OWi-jV662xLrBBBZ=zBbB1gvfpBqVFeSfQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Fix the VDSO symbol generaton for binutils-2.34+
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     linux-riscv@lists.infradead.org,
        kernel-team <kernel-team@android.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 5:44 PM 'Palmer Dabbelt' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> We were relying on GNU ld's ability to re-link executable files in order
> to extract our VDSO symbols.  This behavior was deemed a bug as of
> binutils-2.34 (specifically the binutils-gdb commit a87e1817a4 ("Have
> the linker fail if any attempt to link in an executable is made."),
> which IIUC landed in 2.34), which recently installed itself on my build
> setup.
>
> The previous version of this was a bit of a mess: we were linking a
> static executable version of the VDSO, containing only a subset of the
> input symbols, which we then linked into the kernel.  This worked, but
> certainly wasn't a supported path through the toolchain.  Instead this
> new version parses the textual output of nm to produce a symbol table.
> Both rely on near-zero addresses being linkable, but as we rely on weak
> undefined symbols being linkable elsewhere I don't view this as a major
> issue.
>
> Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
> Cc: stable@vger.kernel.org
> Cc: clang-built-linux@googlegroups.com
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

Ah, I do see a build failure to link the vdso with:
$ riscv64-linux-gnu-ld --version
GNU ld (GNU Binutils for Debian) 2.34.90.20200706

riscv64-linux-gnu-ld: cannot use executable file
'arch/riscv/kernel/vdso/vdso-dummy.o' as input to a link

This patch fixes that for me, but there's a problem related to related
to `nm` below.

After this, there's two other things we might want to fix up related
to the build of the vdso:
1. it looks like $(CC) is being used to link the vdso, rather than
$(LD).  While it's generally fine to use the compiler as the driver
for building a linked object file, it does not respect the set $(LD).
`-fuse-ld=` needs to be passed to invoke the linker the user
specified.  See also:
https://lore.kernel.org/linux-kbuild/20201013033947.2257501-1-natechancellor@gmail.com/T/#u
(this has popped up in a few places when trying to do hermetic builds
with LLD).
2. I observe the warning when building with clang: `argument unused
during compilation: '-no-pie' [-Wunused-command-line-argument]`. IIRC,
the top level Makefile sets `-Qunused-arguments` for builds with
clang.  `cmd_vdsold` may need that, but it's curious why it's unused
and makes me wonder why/if `-no-pie` is necessary?  That also might be
fixed by fixing 1.

> ---
>  arch/riscv/kernel/vdso/.gitignore |  1 +
>  arch/riscv/kernel/vdso/Makefile   | 19 +++++++++----------
>  arch/riscv/kernel/vdso/so2s.sh    |  7 +++++++
>  3 files changed, 17 insertions(+), 10 deletions(-)
>  create mode 100755 arch/riscv/kernel/vdso/so2s.sh
>
> diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
> index 11ebee9e4c1d..3a19def868ec 100644
> --- a/arch/riscv/kernel/vdso/.gitignore
> +++ b/arch/riscv/kernel/vdso/.gitignore
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  vdso.lds
>  *.tmp
> +vdso-syms.S
> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
> index 478e7338ddc1..2e02958f6224 100644
> --- a/arch/riscv/kernel/vdso/Makefile
> +++ b/arch/riscv/kernel/vdso/Makefile
> @@ -43,19 +43,14 @@ $(obj)/vdso.o: $(obj)/vdso.so
>  SYSCFLAGS_vdso.so.dbg = $(c_flags)
>  $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
>         $(call if_changed,vdsold)
> +SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
> +       -Wl,--build-id -Wl,--hash-style=both
>
>  # We also create a special relocatable object that should mirror the symbol
>  # table and layout of the linked DSO. With ld --just-symbols we can then
>  # refer to these symbols in the kernel code rather than hand-coded addresses.
> -
> -SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
> -       -Wl,--build-id -Wl,--hash-style=both
> -$(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
> -       $(call if_changed,vdsold)
> -
> -LDFLAGS_vdso-syms.o := -r --just-symbols
> -$(obj)/vdso-syms.o: $(obj)/vdso-dummy.o FORCE
> -       $(call if_changed,ld)
> +$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
> +       $(call if_changed,so2s)
>
>  # strip rule for the .so file
>  $(obj)/%.so: OBJCOPYFLAGS := -S
> @@ -68,11 +63,15 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
>  # Make sure only to export the intended __vdso_xxx symbol offsets.
>  quiet_cmd_vdsold = VDSOLD  $@
>        cmd_vdsold = $(CC) $(KBUILD_CFLAGS) $(call cc-option, -no-pie) -nostdlib -nostartfiles $(SYSCFLAGS_$(@F)) \
> -                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp && \
> +                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp -Wl,-Map,$@.map && \
>                     $(CROSS_COMPILE)objcopy \
>                             $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
>                     rm $@.tmp
>
> +# Extracts
> +quiet_cmd_so2s = SO2S    $@
> +      cmd_so2s = $(CROSS_COMPILE)nm -D $< | $(src)/so2s.sh > $@

This should use `$(NM)` rather than `$(CROSS_COMPILE)nm` which
hardcodes the use of GNU nm from GNU binutils.

> +
>  # install commands for the unstripped file
>  quiet_cmd_vdso_install = INSTALL $@
>        cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
> diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
> new file mode 100755
> index 000000000000..7862866b5ebb
> --- /dev/null
> +++ b/arch/riscv/kernel/vdso/so2s.sh
> @@ -0,0 +1,6 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright 2020 Palmer Dabbelt <palmerdabbelt@google.com>
> +
> +sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)@@LINUX_4.15!.global \2\n.set \2,0x\1!' \
> +| grep '^\.'
> --

-- 
Thanks,
~Nick Desaulniers
