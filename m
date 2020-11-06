Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F150C2A938F
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 11:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgKFKBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 05:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgKFKBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 05:01:14 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635DFC0613CF
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 02:01:12 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id u21so849994iol.12
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 02:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5A2u4CO44p7qRa+3N4k+11sSwOpF76zVgF+ilbeOAmY=;
        b=rVE9K281n7cVgMX3DP5BV9ICaDURvczPbV0jru6Qt5DoK/afFqSZNVPIPCncQEyvh5
         qj4FKT/DuHvpe8KKFzVq66ISVOJrT7I1TIA4NwAMXi2D+HKYaOnzIVMOhXyhl/V+O9ye
         MILAkHAMJP0crojkzn54NYKP+MVwXgWie7VFoJvnrwg3PhQ36L+GWGH6E1Rmy9LfDeJ/
         jr7IC9Oou5PVLglyxM5JEmPCsQ9FquhqX/2u9TcH1UzR6wnQMlGl0sZ78YEfn5/EpP/1
         TYokbfxlv0eDaV/Cj0TMFFsSeGjLBaT9SURkjB9w1jl+xmilS04q9mpZTwMuOWzOAFni
         pAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5A2u4CO44p7qRa+3N4k+11sSwOpF76zVgF+ilbeOAmY=;
        b=fTyDywWPRoV5e0Cr4mbZF+hcIhnZCQE3/y1lsgbcbcB3l9qLFSzh8lG8E0vepp7bTL
         5SQPqdpBDEo6hBetV/NIj/Oo5smuhxJRQQjtb2Zge4TVMLp/rIr43t7bMyeNDaIidHdp
         TOAMiUu6nGN7ved27/0WcNnv3c01Vhi8R9sQ2fntc9afpqjzgY2xz0FNUNkmmlnT6+ln
         vQcw7JJ1PtMK3EyZhWjmSpIYYp+C+1yW5OXX3z47ZpdLRwYaZYvCqBALqvxJP//SMBCV
         /n29TOFM5hmBqmn4ntMDdazVb46eTyzMc3Jd9NSFDqcby87sY4te1zAhC5x2kXTY5RRw
         gUww==
X-Gm-Message-State: AOAM531UiTHEd7WlTGR9M3R5/sCI0R/3a+/HC0Y/MfnLl2i1wmPwk1NV
        MiS0i8HVr+VXpftaX6bO659vDGSc3cw=
X-Google-Smtp-Source: ABdhPJwPOzmrdLefOQww7n3bSORHaiC3xoqS0+6krtATOKoCsG1qpiLUC7el88BU5gW1LvwEUNvVqw==
X-Received: by 2002:a6b:8b0d:: with SMTP id n13mr867950iod.111.1604656871705;
        Fri, 06 Nov 2020 02:01:11 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id u18sm544150iob.53.2020.11.06.02.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 02:01:10 -0800 (PST)
Date:   Fri, 6 Nov 2020 03:01:09 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-riscv@lists.infradead.org, kernel-team@android.com,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] RISC-V: Fix the VDSO symbol generaton for
 binutils-2.35+
Message-ID: <20201106100109.GA3811063@ubuntu-m3-large-x86>
References: <20201106045902.GA2585953@ubuntu-m3-large-x86>
 <mhng-e82ecf40-679a-41ed-b2b1-69c64a78f0b2@palmerdabbelt-glaptop1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-e82ecf40-679a-41ed-b2b1-69c64a78f0b2@palmerdabbelt-glaptop1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 09:12:25PM -0800, Palmer Dabbelt wrote:
> On Thu, 05 Nov 2020 20:59:02 PST (-0800), natechancellor@gmail.com wrote:
> > On Thu, Nov 05, 2020 at 08:42:22PM -0800, 'Palmer Dabbelt' via Clang Built Linux wrote:
> > > On Mon, 26 Oct 2020 12:48:08 PDT (-0700), Nick Desaulniers wrote:
> > > > On Fri, Oct 23, 2020 at 10:03 PM 'Palmer Dabbelt' via Clang Built
> > > > Linux <clang-built-linux@googlegroups.com> wrote:
> > > > >
> > > > > We were relying on GNU ld's ability to re-link executable files in order
> > > > > to extract our VDSO symbols.  This behavior was deemed a bug as of
> > > > > binutils-2.35 (specifically the binutils-gdb commit a87e1817a4 ("Have
> > > > > the linker fail if any attempt to link in an executable is made."), but as that
> > > > > has been backported to at least Debian's binutils-2.34 in may manifest in other
> > > > > places.
> > > > >
> > > > > The previous version of this was a bit of a mess: we were linking a
> > > > > static executable version of the VDSO, containing only a subset of the
> > > > > input symbols, which we then linked into the kernel.  This worked, but
> > > > > certainly wasn't a supported path through the toolchain.  Instead this
> > > > > new version parses the textual output of nm to produce a symbol table.
> > > > > Both rely on near-zero addresses being linkable, but as we rely on weak
> > > > > undefined symbols being linkable elsewhere I don't view this as a major
> > > > > issue.
> > > > >
> > > > > Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
> > > > > Cc: clang-built-linux@googlegroups.com
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> > > >
> > > > Any way to improve the error message if/when this fails?
> > > > https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/407165683
> > > 
> > > Probably, but I can't get that command to actually run this stuff.  I tried
> > > pulling the commands, but I'm getting some weirdness
> > > 
> > > $ rm -f arch/riscv/kernel/vdso/vdso-syms.S
> > > $ make ARCH=riscv defconfig
> > > $ make -j2 AR=llvm-ar 'CC=clang' 'HOSTCC=clang' HOSTLD=ld KCFLAGS=-Wno-implicit-fallthrough LD=riscv64-linux-gnu-ld LLVM_IAS=1 NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump OBJSIZE=llvm-size READELF=llvm-readelf STRIP=llvm-strip ARCH=riscv Image
> > 
> > This command is simpler and reproduces it for me locally on next-20201105.
> > 
> > $ make -skj"$(nproc)" ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- LD=riscv64-linux-gnu-ld LLVM=1 distclean defconfig Image
> > clang-12: warning: argument unused during compilation: '-no-pie' [-Wunused-command-line-argument]
> > make[4]: *** [arch/riscv/kernel/vdso/Makefile:53: arch/riscv/kernel/vdso/vdso-syms.S] Error 1
> > make[4]: *** Deleting file 'arch/riscv/kernel/vdso/vdso-syms.S'
> > make[4]: Target '__build' not remade because of errors.
> > make[3]: *** [scripts/Makefile.build:500: arch/riscv/kernel/vdso] Error 2
> > make[3]: Target '__build' not remade because of errors.
> > make[2]: *** [scripts/Makefile.build:500: arch/riscv/kernel] Error 2
> > make[2]: Target '__build' not remade because of errors.
> > make[1]: *** [Makefile:1797: arch/riscv] Error 2
> > make[1]: Target 'Image' not remade because of errors.
> > make: *** [Makefile:335: __build_one_by_one] Error 2
> > make: Target 'distclean' not remade because of errors.
> > make: Target 'defconfig' not remade because of errors.
> > make: Target 'Image' not remade because of errors.
> > 
> > <snip>
> > 
> > > diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
> > > index 3a19def868ec..88206dd8b472 100644
> > > --- a/arch/riscv/kernel/vdso/.gitignore
> > > +++ b/arch/riscv/kernel/vdso/.gitignore
> > > @@ -2,3 +2,4 @@
> > > vdso.lds
> > > *.tmp
> > > vdso-syms.S
> > > +vdso-syms.nm
> > > diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
> > > index a8ecf102e09b..fe5c969a6bf4 100644
> > > --- a/arch/riscv/kernel/vdso/Makefile
> > > +++ b/arch/riscv/kernel/vdso/Makefile
> > > @@ -49,8 +49,11 @@ SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
> > > # We also create a special relocatable object that should mirror the symbol
> > > # table and layout of the linked DSO. With ld --just-symbols we can then
> > > # refer to these symbols in the kernel code rather than hand-coded addresses.
> > > -$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
> > > -	$(call if_changed,so2s)
> > > +$(obj)/vdso-syms.nm: $(obj)/vdso.so
> > > +	$(call if_changed,nm_d)
> > > +
> > > +$(obj)/vdso-syms.S: $(obj)/vdso-syms.nm
> > > +	$(call if_changed,nm2s)
> > > 
> > > # strip rule for the .so file
> > > $(obj)/%.so: OBJCOPYFLAGS := -S
> > > @@ -68,9 +71,13 @@ quiet_cmd_vdsold = VDSOLD  $@
> > >                            $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
> > >                    rm $@.tmp
> > > 
> > > -# Extracts
> > > -quiet_cmd_so2s = SO2S    $@
> > > -      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
> > > +# Extracts symbol offsets from the VDSO, converting them into an assembly file
> > > +# that contains the same symbols at the same offsets.
> > > +quiet_cmd_nm_d = NM -D   $@
> > > +      cmd_nm_d = $(NM) -D $< > $@
> > > +
> > > +quiet_cmd_nm2s = SYMS2S  $@
> > > +      cmd_nm2s = cat $< | $(srctree)/$(src)/so2s.sh > $@
> > > 
> > > # install commands for the unstripped file
> > > quiet_cmd_vdso_install = INSTALL $@
> > > 
> > > For reference, here's the output of nmo for me:
> > > 
> > > $ cat arch/riscv/kernel/vdso/vdso-syms.nm 0000000000000000 A LINUX_4.15
> > > 00000000000009e0 T __vdso_clock_getres@@LINUX_4.15
> > > 000000000000080a T __vdso_clock_gettime@@LINUX_4.15
> > > 0000000000000a48 T __vdso_flush_icache@@LINUX_4.15
> > > 0000000000000a3c T __vdso_getcpu@@LINUX_4.15
> > > 0000000000000916 T __vdso_gettimeofday@@LINUX_4.15
> > > 0000000000000800 T __vdso_rt_sigreturn@@LINUX_4.15
> > 
> > This diff does not solve the issue for me with the above command.
> 
> It wasn't really meant to solve anything, just split the commands up a touch
> more so we could see what's going on.
> 
> I just installed Debian's toolchain, which is LLVM 9.  IIRC that's pretty
> ancient WRT RISC-V, so my guess is that it's just a long way from building
> Linux.  Looks like llvm-nm on my system doesn't put the @@LINUX_4.15 after the
> symbol names, I think this should do it?
> 
> diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
> index 3c5b43207658..e64cb6d9440e 100755
> --- a/arch/riscv/kernel/vdso/so2s.sh
> +++ b/arch/riscv/kernel/vdso/so2s.sh
> @@ -2,5 +2,5 @@
> # SPDX-License-Identifier: GPL-2.0+
> # Copyright 2020 Palmer Dabbelt <palmerdabbelt@google.com>
> 
> -sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)@@LINUX_4.15!.global \2\n.set \2,0x\1!' \
> +sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)\(@@LINUX_4.15\)*!.global \2\n.set \2,0x\1!' \
> | grep '^\.'
> 
> It works for me, at least for this specific problem.

Same here. defconfig minus CONFIG_EFI builds and boots in QEMU with that
diff (plus LLVM_IAS=1 in the make command, I forgot that earlier).

Tested-by: Nathan Chancellor <natechancellor@gmail.com>

> $ llvm-nm-9 -D arch/riscv/kernel/vdso/vdso.so |
> ./arch/riscv/kernel/vdso/so2s.sh .global __vdso_clock_getres
> .set __vdso_clock_getres,0x00000000000009e0
> .global __vdso_clock_gettime
> .set __vdso_clock_gettime,0x000000000000080a
> .global __vdso_flush_icache
> .set __vdso_flush_icache,0x0000000000000a48
> .global __vdso_getcpu
> .set __vdso_getcpu,0x0000000000000a3c
> .global __vdso_gettimeofday
> .set __vdso_gettimeofday,0x0000000000000916
> .global __vdso_rt_sigreturn
> .set __vdso_rt_sigreturn,0x0000000000000800
> $ nm -D arch/riscv/kernel/vdso/vdso.so | ./arch/riscv/kernel/vdso/so2s.sh
> .global __vdso_clock_getres
> .set __vdso_clock_getres,0x00000000000009e0
> .global __vdso_clock_gettime
> .set __vdso_clock_gettime,0x000000000000080a
> .global __vdso_flush_icache
> .set __vdso_flush_icache,0x0000000000000a48
> .global __vdso_getcpu
> .set __vdso_getcpu,0x0000000000000a3c
> .global __vdso_gettimeofday
> .set __vdso_gettimeofday,0x0000000000000916
> .global __vdso_rt_sigreturn
> .set __vdso_rt_sigreturn,0x0000000000000800
> 
> > 
> > Cheers,
> > Nathan
