Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D228292F99
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 22:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgJSUl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 16:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgJSUl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 16:41:26 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BA5C0613CE
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 13:41:25 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h2so401151pll.11
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 13:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JV8BCOR/JvIEgfAvAo8m2P/XD4M4pARgj8lS/n0TjIk=;
        b=uNbz+HXMdeKg8jx/VsmQdREfkupFzXXiUBqaLappY65JtKYFoPb02aQCNgYKytpnRa
         M396faW0CziT/V/gWsiPlV2oxg5+TCszht6nGulgvEzuzCjXGlWD/k1xiJYF/9gEY/98
         YAv7E+lfusXSm7++KVAdBsjvONGpbfWfrOAbPzodtlkW9LQeHluOXN9T8yuRJ/bVW7+a
         guDFG/jLk1fXusgiI8hfPZ+NBM7sW/Crnqo8yLhkIjfBYMLoADYBf/VRrJPJoFhhk1E+
         baqIydOxf+DxyjCXRyAMIMj4DUJ1BLK9CzW/vBSKkRzefBcUNgysgnsUnvmUdYIkzNgL
         rB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JV8BCOR/JvIEgfAvAo8m2P/XD4M4pARgj8lS/n0TjIk=;
        b=BIZKwOwGzYVQAOrim7BbO8oJk68sB4YjiNsc9OR9mhJABZ/beBoo7Xask8Mbi0PJx0
         PU4kvO9xlrqtfOZEoB17XD1DW9FiTyw+CI5jVLA90HSJ1F4GMZPaMqQezyciNvP1wFO6
         ElpJm/1lZOkEZ+jxLz+k7dnvV9lUIH3stxBqMwBVzJlAbwMTpYPgiGKxwmTMkR3uM79M
         8FfjdnKbzm910COmAyjWY+kJ5cXbQ6pgXMs7LvVmnkxePqVcVr9EWo+UtxK7tChC1WBE
         HiBz4hqyBKI8B59RsXumSpr0iUbcrzD/dq79uqqYGrJj55hiLWrxwV70bjhznwkTuMkH
         r54Q==
X-Gm-Message-State: AOAM530POujOse9Lxlbw57EcfidjIRTSNckojR6u7F6qtifexB5zCZ4Y
        SVmB7xNfCJCUbZHJBCPAnU6Ohw==
X-Google-Smtp-Source: ABdhPJwzigGcHkEMr7039MyLZ5jq7OIo2twqHHs2AypjQ9JDtzez1a+8+fTks+4Hc7xtn2V3terA0w==
X-Received: by 2002:a17:90a:ff92:: with SMTP id hf18mr1202895pjb.171.1603140084574;
        Mon, 19 Oct 2020 13:41:24 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id o4sm319396pjp.37.2020.10.19.13.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 13:41:23 -0700 (PDT)
Date:   Mon, 19 Oct 2020 13:41:21 -0700
From:   Fangrui Song <maskray@google.com>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-riscv@lists.infradead.org,
        kernel-team <kernel-team@android.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] RISC-V: Fix the VDSO symbol generaton for binutils-2.34+
Message-ID: <20201019204121.jaw7mqn4bkn2h6mx@google.com>
References: <20201017002500.503011-1-palmerdabbelt@google.com>
 <CAKwvOdnsRHA1WMb7OWi-jV662xLrBBBZ=zBbB1gvfpBqVFeSfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdnsRHA1WMb7OWi-jV662xLrBBBZ=zBbB1gvfpBqVFeSfQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-10-19, 'Nick Desaulniers' via Clang Built Linux wrote:
>On Fri, Oct 16, 2020 at 5:44 PM 'Palmer Dabbelt' via Clang Built Linux
><clang-built-linux@googlegroups.com> wrote:
>>
>> We were relying on GNU ld's ability to re-link executable files in order
>> to extract our VDSO symbols.  This behavior was deemed a bug as of
>> binutils-2.34 (specifically the binutils-gdb commit a87e1817a4 ("Have
>> the linker fail if any attempt to link in an executable is made."),
>> which IIUC landed in 2.34), which recently installed itself on my build
>> setup.

I filed the issue https://sourceware.org/bugzilla/show_bug.cgi?id=26047
The commit is in 2.35 but not in the released 2.34 branch.

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
>> Cc: stable@vger.kernel.org
>> Cc: clang-built-linux@googlegroups.com
>> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
>
>Ah, I do see a build failure to link the vdso with:
>$ riscv64-linux-gnu-ld --version
>GNU ld (GNU Binutils for Debian) 2.34.90.20200706
>
>riscv64-linux-gnu-ld: cannot use executable file
>'arch/riscv/kernel/vdso/vdso-dummy.o' as input to a link
>
>This patch fixes that for me, but there's a problem related to related
>to `nm` below.
>
>After this, there's two other things we might want to fix up related
>to the build of the vdso:
>1. it looks like $(CC) is being used to link the vdso, rather than
>$(LD).  While it's generally fine to use the compiler as the driver
>for building a linked object file, it does not respect the set $(LD).
>`-fuse-ld=` needs to be passed to invoke the linker the user
>specified.  See also:
>https://lore.kernel.org/linux-kbuild/20201013033947.2257501-1-natechancellor@gmail.com/T/#u
>(this has popped up in a few places when trying to do hermetic builds
>with LLD).
>2. I observe the warning when building with clang: `argument unused
>during compilation: '-no-pie' [-Wunused-command-line-argument]`. IIRC,
>the top level Makefile sets `-Qunused-arguments` for builds with
>clang.  `cmd_vdsold` may need that, but it's curious why it's unused
>and makes me wonder why/if `-no-pie` is necessary?  That also might be
>fixed by fixing 1.
>
>> ---
>>  arch/riscv/kernel/vdso/.gitignore |  1 +
>>  arch/riscv/kernel/vdso/Makefile   | 19 +++++++++----------
>>  arch/riscv/kernel/vdso/so2s.sh    |  7 +++++++
>>  3 files changed, 17 insertions(+), 10 deletions(-)
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
>> index 478e7338ddc1..2e02958f6224 100644
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
>> @@ -68,11 +63,15 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
>>  # Make sure only to export the intended __vdso_xxx symbol offsets.
>>  quiet_cmd_vdsold = VDSOLD  $@
>>        cmd_vdsold = $(CC) $(KBUILD_CFLAGS) $(call cc-option, -no-pie) -nostdlib -nostartfiles $(SYSCFLAGS_$(@F)) \
>> -                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp && \
>> +                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp -Wl,-Map,$@.map && \

Is -Wl,-Map,$@.map needed?

>>                     $(CROSS_COMPILE)objcopy \
>>                             $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
>>                     rm $@.tmp
>>
>> +# Extracts
>> +quiet_cmd_so2s = SO2S    $@
>> +      cmd_so2s = $(CROSS_COMPILE)nm -D $< | $(src)/so2s.sh > $@
>
>This should use `$(NM)` rather than `$(CROSS_COMPILE)nm` which
>hardcodes the use of GNU nm from GNU binutils.
>
>> +
>>  # install commands for the unstripped file
>>  quiet_cmd_vdso_install = INSTALL $@
>>        cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
>> diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
>> new file mode 100755
>> index 000000000000..7862866b5ebb
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
>
>-- 
>Thanks,
>~Nick Desaulniers
>
>-- 
>You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAKwvOdnsRHA1WMb7OWi-jV662xLrBBBZ%3DzBbB1gvfpBqVFeSfQ%40mail.gmail.com.
