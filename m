Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD6D2A8E74
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 05:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgKFEmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 23:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgKFEmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 23:42:24 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD41C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 20:42:23 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 72so175224pfv.7
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 20:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=Ax5zV7FSmcjIfWKm54rtVh6fphlFUgHu2iCY8lxaavQ=;
        b=VuEQErz/kkgmLWEdhr74OsfiRSUaGDbOk7L9VNm7RaNS3NoRXhLYLm2VFSXvIJ58+z
         SrVVroq7cFZOQUyPAL4McSjPzxM0kpDKO2vtn24fLbgmvaHf9xfOru84rLDspNHyBgco
         9THQzoLgWbz8B9xjOBCPwxA9LS40vJ2MFO7vRrxB2q4lal/G7ItIgUMCONVpbfGlBo97
         oOs9/ISn9hP3KIHoyB6mZe0fFxS17FxzGvRQx+mGtpAaWUnIj+Mn/gA1ljhqCIEclHKn
         FtTLgoP2FSWpXynYTbpTlsP+sRnpiFTqdol/1i802heW/M1bpQ3VDClwS5NeubDWhpdY
         aYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=Ax5zV7FSmcjIfWKm54rtVh6fphlFUgHu2iCY8lxaavQ=;
        b=Z8dW4iQw1d11u/dLoZz4yWwjlHP/TO0Jr/H1eK/k9bPX6TLskW662cKM4hMA3G+pgm
         8S3bOTorom4xrYiZgCFpPUa1lLJYbAug7cspcJQNjWTsnN7qH2GA8fCY9Ej9h+vBBWNV
         ho8W73MJKOxqI0wSJ3E4nz2MxdRbbzKS1+eRyWmB5Cf04BcpCUcUFJUrM0EFGSWZNUQs
         6cx7vMj/JNk9BOjYkYLc3N1BxSaaCVAK8i5obQF3yayrmIWX5sT/dYOw7TFIzObzlwwO
         65R5dHZ/qPzk21/VtyBKYOE2ML2Lhk3qRM4gVIIeM3/LqLi6BGVxZ8cPBp+Ec5m4DlAO
         PHjg==
X-Gm-Message-State: AOAM5339q6cXKy878mBne+TURYqoX5KNtFrxDj6Jo9rNF51HGbLncq3U
        Cl2/N0ltlmIAHstvIzlVXC/xTA==
X-Google-Smtp-Source: ABdhPJxEmHhXMo+DSF/Yi6xu5DtL6ePC8Nr9pEC+eEWoWhjTS3QjjpRtWmQFct0NOcHRrxJtL3TU0w==
X-Received: by 2002:a62:7d89:0:b029:18b:86d4:7cbe with SMTP id y131-20020a627d890000b029018b86d47cbemr313143pfc.77.1604637742926;
        Thu, 05 Nov 2020 20:42:22 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id n125sm239935pfn.127.2020.11.05.20.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 20:42:22 -0800 (PST)
Date:   Thu, 05 Nov 2020 20:42:22 -0800 (PST)
X-Google-Original-Date: Thu, 05 Nov 2020 20:40:54 PST (-0800)
Subject:     Re: [PATCH v3] RISC-V: Fix the VDSO symbol generaton for binutils-2.35+
In-Reply-To: <CAKwvOdn5ib_WHpTg8YpHtqeOMLs+QDxVkzb8fuyDUL_N9BA_xw@mail.gmail.com>
CC:     linux-riscv@lists.infradead.org, kernel-team@android.com,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Message-ID: <mhng-dba8756e-d51b-4ce0-8987-51fcf9674c24@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Oct 2020 12:48:08 PDT (-0700), Nick Desaulniers wrote:
> On Fri, Oct 23, 2020 at 10:03 PM 'Palmer Dabbelt' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
>>
>> We were relying on GNU ld's ability to re-link executable files in order
>> to extract our VDSO symbols.  This behavior was deemed a bug as of
>> binutils-2.35 (specifically the binutils-gdb commit a87e1817a4 ("Have
>> the linker fail if any attempt to link in an executable is made."), but as that
>> has been backported to at least Debian's binutils-2.34 in may manifest in other
>> places.
>>
>> The previous version of this was a bit of a mess: we were linking a
>> static executable version of the VDSO, containing only a subset of the
>> input symbols, which we then linked into the kernel.  This worked, but
>> certainly wasn't a supported path through the toolchain.  Instead this
>> new version parses the textual output of nm to produce a symbol table.
>> Both rely on near-zero addresses being linkable, but as we rely on weak
>> undefined symbols being linkable elsewhere I don't view this as a major
>> issue.
>>
>> Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
>> Cc: clang-built-linux@googlegroups.com
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
>
> Any way to improve the error message if/when this fails?
> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/407165683

Probably, but I can't get that command to actually run this stuff.  I tried
pulling the commands, but I'm getting some weirdness

$ rm -f arch/riscv/kernel/vdso/vdso-syms.S
$ make ARCH=riscv defconfig
$ make -j2 AR=llvm-ar 'CC=clang' 'HOSTCC=clang' HOSTLD=ld KCFLAGS=-Wno-implicit-fallthrough LD=riscv64-linux-gnu-ld LLVM_IAS=1 NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump OBJSIZE=llvm-size READELF=llvm-readelf STRIP=llvm-strip ARCH=riscv Image
  SYNC    include/config/auto.conf.cmd
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/confdata.o
  HOSTCC  scripts/kconfig/expr.o
  HOSTCC  scripts/kconfig/lexer.lex.o
  HOSTCC  scripts/kconfig/parser.tab.o
  HOSTCC  scripts/kconfig/preprocess.o
  HOSTCC  scripts/kconfig/symbol.o
  HOSTCC  scripts/kconfig/util.o
  HOSTLD  scripts/kconfig/conf
*
* Restart config...
*
*
* Memory initialization
*
Initialize kernel stack variables at function entry
> 1. no automatic initialization (weakest) (INIT_STACK_NONE)
  2. 0xAA-init everything on the stack (strongest) (INIT_STACK_ALL_PATTERN) (NEW)
  3. zero-init everything on the stack (strongest and safest) (INIT_STACK_ALL_ZERO) (NEW)
choice[1-3?]: 
Enable heap memory zeroing on allocation by default (INIT_ON_ALLOC_DEFAULT_ON) [N/y/?] n
Enable heap memory zeroing on free by default (INIT_ON_FREE_DEFAULT_ON) [N/y/?] n
  HOSTCC  scripts/dtc/dtc.o
  HOSTCC  scripts/dtc/flattree.o
  HOSTCC  scripts/dtc/fstree.o
  HOSTCC  scripts/dtc/data.o
  HOSTCC  scripts/dtc/livetree.o
  HOSTCC  scripts/dtc/treesource.o
  HOSTCC  scripts/dtc/srcpos.o
  HOSTCC  scripts/dtc/checks.o
  HOSTCC  scripts/dtc/util.o
  HOSTCC  scripts/dtc/dtc-lexer.lex.o
  HOSTCC  scripts/dtc/dtc-parser.tab.o
  HOSTLD  scripts/dtc/dtc
  HOSTCC  scripts/kallsyms
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
error: invalid value 'medany' in '-mcode-model medany'
make[1]: *** [scripts/Makefile.build:283: scripts/mod/empty.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1199: prepare0] Error 2

I have no idea where the space in '-mcode-model medany' comes from.

Does this fail in general for LLVM, or is the issue just the error message?
I've put this on fixes assuming it's just the error message, but LMK if it's
actually not working in which case I won't send it out as I don't want to break
stuff that was working.

Either way I'd be happy to fix it if I can reproduce it.  I always just guess
at regexes until they work for me, so I bet there's something subtly different
in LLVM.  This splits out the calls, which might be enough to sort it out (I've
fixed the comment on fixes):

diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
index 3a19def868ec..88206dd8b472 100644
--- a/arch/riscv/kernel/vdso/.gitignore
+++ b/arch/riscv/kernel/vdso/.gitignore
@@ -2,3 +2,4 @@
 vdso.lds
 *.tmp
 vdso-syms.S
+vdso-syms.nm
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index a8ecf102e09b..fe5c969a6bf4 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -49,8 +49,11 @@ SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
 # We also create a special relocatable object that should mirror the symbol
 # table and layout of the linked DSO. With ld --just-symbols we can then
 # refer to these symbols in the kernel code rather than hand-coded addresses.
-$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
-	$(call if_changed,so2s)
+$(obj)/vdso-syms.nm: $(obj)/vdso.so
+	$(call if_changed,nm_d)
+
+$(obj)/vdso-syms.S: $(obj)/vdso-syms.nm
+	$(call if_changed,nm2s)
 
 # strip rule for the .so file
 $(obj)/%.so: OBJCOPYFLAGS := -S
@@ -68,9 +71,13 @@ quiet_cmd_vdsold = VDSOLD  $@
                            $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp
 
-# Extracts
-quiet_cmd_so2s = SO2S    $@
-      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
+# Extracts symbol offsets from the VDSO, converting them into an assembly file
+# that contains the same symbols at the same offsets.
+quiet_cmd_nm_d = NM -D   $@
+      cmd_nm_d = $(NM) -D $< > $@
+
+quiet_cmd_nm2s = SYMS2S  $@
+      cmd_nm2s = cat $< | $(srctree)/$(src)/so2s.sh > $@
 
 # install commands for the unstripped file
 quiet_cmd_vdso_install = INSTALL $@

For reference, here's the output of nmo for me:

$ cat arch/riscv/kernel/vdso/vdso-syms.nm 
0000000000000000 A LINUX_4.15
00000000000009e0 T __vdso_clock_getres@@LINUX_4.15
000000000000080a T __vdso_clock_gettime@@LINUX_4.15
0000000000000a48 T __vdso_flush_icache@@LINUX_4.15
0000000000000a3c T __vdso_getcpu@@LINUX_4.15
0000000000000916 T __vdso_gettimeofday@@LINUX_4.15
0000000000000800 T __vdso_rt_sigreturn@@LINUX_4.15

>> ---
>>
>> Changes since v2 <20201019235630.762886-1-palmerdabbelt@google.com>:
>>
>> * Uses $(srctree)/$(src) to allow for out-of-tree builds.
>>
>> Changes since v1 <20201017002500.503011-1-palmerdabbelt@google.com>:
>>
>> * Uses $(NM) instead of $(CROSS_COMPILE)nm.  We use the $(CROSS_COMPILE) form
>>   elsewhere in this file, but we'll fix that later.
>> * Removed the unnecesary .map file creation.
>>
>> ---
>>  arch/riscv/kernel/vdso/.gitignore |  1 +
>>  arch/riscv/kernel/vdso/Makefile   | 17 ++++++++---------
>>  arch/riscv/kernel/vdso/so2s.sh    |  6 ++++++
>>  3 files changed, 15 insertions(+), 9 deletions(-)
>>  create mode 100755 arch/riscv/kernel/vdso/so2s.sh
>>
>> diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
>> index 11ebee9e4c1d..3a19def868ec 100644
>> --- a/arch/riscv/kernel/vdso/.gitignore
>> +++ b/arch/riscv/kernel/vdso/.gitignore
>> @@ -1,3 +1,4 @@
>>  # SPDX-License-Identifier: GPL-2.0-only
>>  vdso.lds
>>  *.tmp
>> +vdso-syms.S
>> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
>> index 478e7338ddc1..a8ecf102e09b 100644
>> --- a/arch/riscv/kernel/vdso/Makefile
>> +++ b/arch/riscv/kernel/vdso/Makefile
>> @@ -43,19 +43,14 @@ $(obj)/vdso.o: $(obj)/vdso.so
>>  SYSCFLAGS_vdso.so.dbg = $(c_flags)
>>  $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
>>         $(call if_changed,vdsold)
>> +SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
>> +       -Wl,--build-id -Wl,--hash-style=both
>>
>>  # We also create a special relocatable object that should mirror the symbol
>>  # table and layout of the linked DSO. With ld --just-symbols we can then
>>  # refer to these symbols in the kernel code rather than hand-coded addresses.
>> -
>> -SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
>> -       -Wl,--build-id -Wl,--hash-style=both
>> -$(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
>> -       $(call if_changed,vdsold)
>> -
>> -LDFLAGS_vdso-syms.o := -r --just-symbols
>> -$(obj)/vdso-syms.o: $(obj)/vdso-dummy.o FORCE
>> -       $(call if_changed,ld)
>> +$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
>> +       $(call if_changed,so2s)
>>
>>  # strip rule for the .so file
>>  $(obj)/%.so: OBJCOPYFLAGS := -S
>> @@ -73,6 +68,10 @@ quiet_cmd_vdsold = VDSOLD  $@
>>                             $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
>>                     rm $@.tmp
>>
>> +# Extracts
>> +quiet_cmd_so2s = SO2S    $@
>> +      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
>> +
>>  # install commands for the unstripped file
>>  quiet_cmd_vdso_install = INSTALL $@
>>        cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
>> diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
>> new file mode 100755
>> index 000000000000..3c5b43207658
>> --- /dev/null
>> +++ b/arch/riscv/kernel/vdso/so2s.sh
>> @@ -0,0 +1,6 @@
>> +#!/bin/sh
>> +# SPDX-License-Identifier: GPL-2.0+
>> +# Copyright 2020 Palmer Dabbelt <palmerdabbelt@google.com>
>> +
>> +sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)@@LINUX_4.15!.global \2\n.set \2,0x\1!' \
>> +| grep '^\.'
>> --
>> 2.29.0.rc1.297.gfa9743e501-goog
>>
>> --
>> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201024045046.3018271-1-palmerdabbelt%40google.com.
