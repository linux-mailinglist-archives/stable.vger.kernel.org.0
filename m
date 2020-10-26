Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C2F29974E
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 20:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgJZTsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 15:48:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39211 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgJZTsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 15:48:20 -0400
Received: by mail-pg1-f196.google.com with SMTP id o7so6646379pgv.6
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 12:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=doiRAFC5F5k0Pyq4fvs/ODdap3/UO+Ut/LZ4yfCBqcQ=;
        b=FrcQ2jUFe4WvgbiY4vxGQxzWTKB09nYh5F9jaFKLDJV2pIlD6AmzIr/mMbvK6AkxzN
         c9x8TcE/YmkmT40PSBDKUjBLWd8a9vwOpcvBQITSl+1OMkwCP5j/QGDzqCtWi5pkctVb
         +Ne/vkvyGH+gp8mslhLSekhWG5CYwQ7rj0ZRP2++tJG3hdY1c62fw6+koDCTmKVqaEW4
         QmCkUs19URqbr73JbhHch1Ef7U7PhB7O53NdtNW4asv6ml39JuBUlp1ajVbEeU2/roVy
         asj7FvxAAyB9h+JKw3m8ws8eo5XF8MLoztMA9VtZwxa0Hs4E4F1QNLHdS8RGQz8MdF5n
         Q2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=doiRAFC5F5k0Pyq4fvs/ODdap3/UO+Ut/LZ4yfCBqcQ=;
        b=SmhtngYHMBpd9sVasRH1btnf+vgNuu4LIywBKafs5WDTDpq/iD34IMWM3SUkO+Yb2D
         VC9wNCwzezhFL0SoWDmlgA6wdH+Vv2roJN3N3OiOlxEdkPJ7V/fv/wj87Uj72vaeCBW3
         MVXpkNTjpH1NqXg5Z+kACWjAsqmQRl7R20jCnwx7Go6a0fkEhuucVC4ozmwwlzWfWvQY
         Mz31JZ95ToZjYLp6GKli17n4ymp9o4B672/5LBkBGDZEncQOLabwMPm76hfnnVxaPkq/
         1tlbCt0eGbTvtlh8AVm1J/GLrt1rsDTMAjz50pqYyLlyKRZUKwldCYOvgmVUtk8jZ9h3
         9aHw==
X-Gm-Message-State: AOAM532oz5+C+uKTO5oJTnbNjAzg65LrCIX54+Px5RYkRa5h/MLHCOPM
        n6bfVCNCfI/yMWXNlt3Nph/2gh0GvZDHXoEN8FEqUA==
X-Google-Smtp-Source: ABdhPJyDrUHKeb08a2I8Bc7zcdgb45iTqty7MePTVMxTuJuvlkxrX48Ze7NNkghUEIwbeysCilJCOtxaOJivQLbsMHs=
X-Received: by 2002:aa7:9a04:0:b029:163:fe2a:9e04 with SMTP id
 w4-20020aa79a040000b0290163fe2a9e04mr3150062pfj.30.1603741699320; Mon, 26 Oct
 2020 12:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201024045046.3018271-1-palmerdabbelt@google.com>
In-Reply-To: <20201024045046.3018271-1-palmerdabbelt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 26 Oct 2020 12:48:08 -0700
Message-ID: <CAKwvOdn5ib_WHpTg8YpHtqeOMLs+QDxVkzb8fuyDUL_N9BA_xw@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: Fix the VDSO symbol generaton for binutils-2.35+
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     linux-riscv@lists.infradead.org,
        kernel-team <kernel-team@android.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 23, 2020 at 10:03 PM 'Palmer Dabbelt' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> We were relying on GNU ld's ability to re-link executable files in order
> to extract our VDSO symbols.  This behavior was deemed a bug as of
> binutils-2.35 (specifically the binutils-gdb commit a87e1817a4 ("Have
> the linker fail if any attempt to link in an executable is made."), but as that
> has been backported to at least Debian's binutils-2.34 in may manifest in other
> places.
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
> Cc: clang-built-linux@googlegroups.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

Any way to improve the error message if/when this fails?
https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/407165683

>
> ---
>
> Changes since v2 <20201019235630.762886-1-palmerdabbelt@google.com>:
>
> * Uses $(srctree)/$(src) to allow for out-of-tree builds.
>
> Changes since v1 <20201017002500.503011-1-palmerdabbelt@google.com>:
>
> * Uses $(NM) instead of $(CROSS_COMPILE)nm.  We use the $(CROSS_COMPILE) form
>   elsewhere in this file, but we'll fix that later.
> * Removed the unnecesary .map file creation.
>
> ---
>  arch/riscv/kernel/vdso/.gitignore |  1 +
>  arch/riscv/kernel/vdso/Makefile   | 17 ++++++++---------
>  arch/riscv/kernel/vdso/so2s.sh    |  6 ++++++
>  3 files changed, 15 insertions(+), 9 deletions(-)
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
> index 478e7338ddc1..a8ecf102e09b 100644
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
> @@ -73,6 +68,10 @@ quiet_cmd_vdsold = VDSOLD  $@
>                             $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
>                     rm $@.tmp
>
> +# Extracts
> +quiet_cmd_so2s = SO2S    $@
> +      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
> +
>  # install commands for the unstripped file
>  quiet_cmd_vdso_install = INSTALL $@
>        cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
> diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
> new file mode 100755
> index 000000000000..3c5b43207658
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
> 2.29.0.rc1.297.gfa9743e501-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201024045046.3018271-1-palmerdabbelt%40google.com.



-- 
Thanks,
~Nick Desaulniers
