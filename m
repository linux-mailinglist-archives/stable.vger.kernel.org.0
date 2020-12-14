Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF42DA2D9
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 22:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441098AbgLNVpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 16:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441037AbgLNVo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 16:44:58 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DC0C0613D3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 13:44:18 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so13625236pga.7
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 13:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6EWmrppepC6CHcBZOqhjNztvHasoofk8FBuQ7CK72Yo=;
        b=mlBDwaeR5EuT6thidly4obxEYWArXsfs8EmBKFKvYaUpY1DmcjmF+VaqtG4iTHINT7
         FCF4QnHO0zFmQGeRNsOnf9aLmv0PgPgM62Yiq5xdZxNZ55Oo4kUVltzD7qWaf3M3O/L4
         D0JItD3kQic9c8ZP/u2MlOvD+RaeHKs8561wd3mGt1txmrGnkQCy12wzgpOqqd2kxDw+
         +T4eRRkuhC4NJbRoLJq7alsoh+TwbAVMbKSPRMWVX28HMsXdeFKXUyJwNXnrqGDvAS0p
         oJFC5Tq8Q64l74jlOjiJWeTDfSYUHNDbT/uG7iZqCZ4COqrasq0kWFLb7//kPGEK7DNN
         tvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6EWmrppepC6CHcBZOqhjNztvHasoofk8FBuQ7CK72Yo=;
        b=DQgczINrfpxtjz1LBEmoUQk3GkE5miZ4atq1AiFEITyihKaIeu/0ksOTFf0P4b9oCe
         QVorC0sG7oiq/uJYM0EQy0a/ZnsaPPOmGteaKuCK/eaGWMFWxyw7bI3C3ZnSFX+Wqgqx
         VXtp/2yqd8AB1FisiyLMyF/KNoHM+Q13lygySpgh68YVfQA81eZQ5NvWx18Ti2Btky19
         PpWal9t/qASQl+bxYnkn4aby5zUExIvN4DxDI/YqjRBKRTPVx+RH64X9+9BqZtGOpM+L
         qohmeue1SzgpzYiqkzLAzXVSgEuC4hZ2m82DNnTXvZE1m9mYQicf064870608WOP/Nh/
         z/5A==
X-Gm-Message-State: AOAM5330wnj3pOZG6cVgzvJAvlZ/r3/cSmTMjnBPTmnPveftfoPhNeZ9
        xC4TmKUOOBko4lrBqeDCX19CbHMiqKU8yXmZwf50Vg==
X-Google-Smtp-Source: ABdhPJz0JzYkf4G+e7/8YeB0Xj41+fXETTPGT4aAt+KsRx0P/0WfwpiHwW5NxVnrsiyY7ZkKS7H3cI1Y6xqq+O4xRgY=
X-Received: by 2002:a62:7c4a:0:b029:19d:b7bc:2c51 with SMTP id
 x71-20020a627c4a0000b029019db7bc2c51mr26329699pfc.30.1607982257943; Mon, 14
 Dec 2020 13:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20201016175339.2429280-1-ndesaulniers@google.com> <160319373854.2175971.17968938488121846972.b4-ty@kernel.org>
In-Reply-To: <160319373854.2175971.17968938488121846972.b4-ty@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 14 Dec 2020 13:44:06 -0800
Message-ID: <CAKwvOdnYcff_bcWZYkUC5qKso6EPRWrDgMAdn1KE1_YMCTy__A@mail.gmail.com>
Subject: Re: [PATCH] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
To:     Alan Modra <amodra@gmail.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team <kernel-team@android.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 20, 2020 at 10:57 AM Will Deacon <will@kernel.org> wrote:
>
> On Fri, 16 Oct 2020 10:53:39 -0700, Nick Desaulniers wrote:
> > With CONFIG_EXPERT=y, CONFIG_KASAN=y, CONFIG_RANDOMIZE_BASE=n,
> > CONFIG_RELOCATABLE=n, we observe the following failure when trying to
> > link the kernel image with LD=ld.lld:
> >
> > error: section: .exit.data is not contiguous with other relro sections
> >
> > ld.lld defaults to -z relro while ld.bfd defaults to -z norelro. This
> > was previously fixed, but only for CONFIG_RELOCATABLE=y.
>
> Applied to arm64 (for-next/core), thanks!
>
> [1/1] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
>       https://git.kernel.org/arm64/c/3b92fa7485eb

It looks like this is now producing warnings when linking with BFD.
$ make ...
...
  LD      .tmp_vmlinux.kallsyms1
aarch64-linux-gnu-ld: warning: -z norelro ignored
  KSYMS   .tmp_vmlinux.kallsyms1.S
  AS      .tmp_vmlinux.kallsyms1.S
  LD      .tmp_vmlinux.kallsyms2
aarch64-linux-gnu-ld: warning: -z norelro ignored
  KSYMS   .tmp_vmlinux.kallsyms2.S
  AS      .tmp_vmlinux.kallsyms2.S
  LD      vmlinux
aarch64-linux-gnu-ld: warning: -z norelro ignored

Alan, looking at binutils-gdb commit 5fd104addfddb ("Emit a warning
when -z relro is unsupported") mentions targets lacking relro support
will produce this warning.  I thought aarch64 supports relro
though...?
Looks like we're invoking:
+ aarch64-linux-gnu-ld -EL -maarch64elf --no-undefined -X -z norelro
-shared -Bsymbolic -z notext --no-apply-dynamic-relocs
--fix-cortex-a53-843419 --build-id=sha1 --orphan-handling=warn
--strip-debug -o .tmp_vmlinux.kallsyms1 -T
./arch/arm64/kernel/vmlinux.lds --whole-archive
arch/arm64/kernel/head.o init/built-in.a usr/built-in.a
arch/arm64/built-in.a kernel/built-in.a certs/built-in.a mm/built-in.a
fs/built-in.a ipc/built-in.a security/built-in.a crypto/built-in.a
block/built-in.a arch/arm64/lib/built-in.a lib/built-in.a
arch/arm64/lib/lib.a lib/lib.a drivers/built-in.a sound/built-in.a
net/built-in.a virt/built-in.a --no-whole-archive --start-group
./drivers/firmware/efi/libstub/lib.a --end-group
aarch64-linux-gnu-ld: warning: -z norelro ignored

So we set the emulation mode via -maarch64elf, and our preprocessed
linker script has `OUTPUT_ARCH(aarch64)`. From that commit, there's a
linked mailing list discussion:
https://sourceware.org/legacy-ml/binutils/2017-01/msg00441.html

Is there something more we need to do to our linker script
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kernel/vmlinux.lds.S)
for BFD not to warn when passing `-z norelro`?  It looks like common
page size might need to be specified?  I tried:

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 1bda604f4c70..ae8cce140fdf 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -121,7 +121,7 @@ SECTIONS
                _text = .;
                HEAD_TEXT
        }
-       .text : {                       /* Real text segment            */
+       .text ALIGN (CONSTANT (COMMONPAGESIZE)): {      /* Real text
segment    */

and passing `-z common-page-size=4096` but neither seemed to do the
trick. (https://docs.adacore.com/live/wave/binutils-stable/html/ld/ld.html#index-COMMONPAGESIZE-553

Worst case, we add `-z norelro` just for LLD:

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 6a87d592bd00..6a6235e1e8a9 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King

-LDFLAGS_vmlinux        :=--no-undefined -X -z norelro
+LDFLAGS_vmlinux        :=--no-undefined -X

 ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
@@ -28,6 +28,10 @@ LDFLAGS_vmlinux      += --fix-cortex-a53-843419
   endif
 endif

+ifeq ($(CONFIG_LD_IS_LLD), y)
+LDFLAGS_vmlinux        += -z norelro
+endif
+
 ifeq ($(CONFIG_ARM64_USE_LSE_ATOMICS), y)
   ifneq ($(CONFIG_ARM64_LSE_ATOMICS), y)
 $(warning LSE atomics not supported by binutils)

-- 
Thanks,
~Nick Desaulniers
