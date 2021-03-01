Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5EF32840C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhCAQ2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237917AbhCAQYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B8E564EC8;
        Mon,  1 Mar 2021 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614615680;
        bh=Ip7Mp1DMbhDkrGODLPGVBAf4OkM1dkK3fFgja7Pk9vY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=taYJ+cBHSl8Qgp4OrMmBlMDtUiU2syumTqq7jWeU9F94woa+8FQVzPC2iSREXX23q
         uu+aF5079WJEfsFf0RdR/mUviMvV8REUqdTjzlKQa8W0XISguFNby2NuJDl9n5Ef9X
         pkm4sXcfSo9uF6NcZPN00D6n/7T+YSgvp6lKUARfv8sqDdbdKSpPNVVIpzdkP8o9z6
         dYOKyaPpWGlf3vaFJ3F+gUuQGK0GDYvkKH/HLmvD4D1VFgGnolo13YsABU+D+Jhl+/
         byvZgeGGsX/IFWd656LJU4jydttFFzREoO4706Suxgefs8XuaE48g7jbQc+/puasJ0
         ZvmwRpHgmrhYg==
Date:   Mon, 1 Mar 2021 09:21:16 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     anders.roxell@linaro.org, natechancellor@gmail.com,
        tsbogend@alpha.franken.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of
 filtering out" failed to apply to 5.4-stable tree
Message-ID: <20210301162116.hx5vjaeldfvgtieq@24bbad8f3778>
References: <1614592687119110@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="s5n34356g5w5nvq6"
Content-Disposition: inline
In-Reply-To: <1614592687119110@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--s5n34356g5w5nvq6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 01, 2021 at 10:58:07AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 76d7fff22be3e4185ee5f9da2eecbd8188e76b2c Mon Sep 17 00:00:00 2001
> From: Nathan Chancellor <nathan@kernel.org>
> Date: Fri, 15 Jan 2021 12:26:22 -0700
> Subject: [PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out
>  '--target='
> 
> Commit ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO
> cflags") allowed the '--target=' flag from the main Makefile to filter
> through to the vDSO. However, it did not bring any of the other clang
> specific flags for controlling the integrated assembler and the GNU
> tools locations (--prefix=, --gcc-toolchain=, and -no-integrated-as).
> Without these, we will get a warning (visible with tinyconfig):
> 
> arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per
> compilation unit
> .pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long
> 4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
> ^
> arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per
> compilation unit
>  .section .mips_abiflags, "a"
>  ^
> 
> All of these flags are bundled up under CLANG_FLAGS in the main Makefile
> and exported so that they can be added to Makefiles that set their own
> CFLAGS. Use this value instead of filtering out '--target=' so there is
> no warning and all of the tools are properly used.
> 
> Cc: stable@vger.kernel.org
> Fixes: ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1256
> Reported-by: Anders Roxell <anders.roxell@linaro.org>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Anders Roxell <anders.roxell@linaro.org>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> 
> diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
> index 5810cc12bc1d..2131d3fd7333 100644
> --- a/arch/mips/vdso/Makefile
> +++ b/arch/mips/vdso/Makefile
> @@ -16,16 +16,13 @@ ccflags-vdso := \
>  	$(filter -march=%,$(KBUILD_CFLAGS)) \
>  	$(filter -m%-float,$(KBUILD_CFLAGS)) \
>  	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
> +	$(CLANG_FLAGS) \
>  	-D__VDSO__
>  
>  ifndef CONFIG_64BIT
>  ccflags-vdso += -DBUILD_VDSO32
>  endif
>  
> -ifdef CONFIG_CC_IS_CLANG
> -ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
> -endif
> -
>  #
>  # The -fno-jump-tables flag only prevents the compiler from generating
>  # jump tables but does not prevent the compiler from emitting absolute
> 

Attached are the 4.19 and 5.4 backports.

Cheers,
Nathan

--s5n34356g5w5nvq6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="76d7fff22be3-5.4.patch"

From 7cf7b4c222c24d9b6b38c35e465f4eb43648a135 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <natechancellor@gmail.com>
Date: Fri, 15 Jan 2021 12:26:22 -0700
Subject: [PATCH 5.4] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out
 '--target='

commit 76d7fff22be3e4185ee5f9da2eecbd8188e76b2c upstream.

Commit ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO
cflags") allowed the '--target=' flag from the main Makefile to filter
through to the vDSO. However, it did not bring any of the other clang
specific flags for controlling the integrated assembler and the GNU
tools locations (--prefix=, --gcc-toolchain=, and -no-integrated-as).
Without these, we will get a warning (visible with tinyconfig):

arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per
compilation unit
.pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long
4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
^
arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per
compilation unit
 .section .mips_abiflags, "a"
 ^

All of these flags are bundled up under CLANG_FLAGS in the main Makefile
and exported so that they can be added to Makefiles that set their own
CFLAGS. Use this value instead of filtering out '--target=' so there is
no warning and all of the tools are properly used.

Cc: stable@vger.kernel.org
Fixes: ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
Link: https://github.com/ClangBuiltLinux/linux/issues/1256
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
[nc: Fix conflict due to lack of 99570c3da96a in 5.4]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/vdso/Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 996a934ece7d..d3cd9c4cadc2 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -16,12 +16,9 @@ ccflags-vdso := \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
 	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
+	$(CLANG_FLAGS) \
 	-D__VDSO__
 
-ifdef CONFIG_CC_IS_CLANG
-ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
-endif
-
 #
 # The -fno-jump-tables flag only prevents the compiler from generating
 # jump tables but does not prevent the compiler from emitting absolute

base-commit: ef1fcccf6e5fe3aabe7c3590964efac6d5220c43
-- 
2.31.0.rc0


--s5n34356g5w5nvq6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="76d7fff22be3-4.19.patch"

From 64b4ec3fb30cb7fd9a17fe2b46e4e7ce498c8c19 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <natechancellor@gmail.com>
Date: Fri, 15 Jan 2021 12:26:22 -0700
Subject: [PATCH 4.19] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out
 '--target='

commit 76d7fff22be3e4185ee5f9da2eecbd8188e76b2c upstream.

Commit ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO
cflags") allowed the '--target=' flag from the main Makefile to filter
through to the vDSO. However, it did not bring any of the other clang
specific flags for controlling the integrated assembler and the GNU
tools locations (--prefix=, --gcc-toolchain=, and -no-integrated-as).
Without these, we will get a warning (visible with tinyconfig):

arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per
compilation unit
.pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long
4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
^
arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per
compilation unit
 .section .mips_abiflags, "a"
 ^

All of these flags are bundled up under CLANG_FLAGS in the main Makefile
and exported so that they can be added to Makefiles that set their own
CFLAGS. Use this value instead of filtering out '--target=' so there is
no warning and all of the tools are properly used.

Cc: stable@vger.kernel.org
Fixes: ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
Link: https://github.com/ClangBuiltLinux/linux/issues/1256
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
[nc: Fix conflict due to lack of 99570c3da96a and 076f421da5d4 in 4.19]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/mips/vdso/Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index c99fa1c1bd9c..a876b1657bf4 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -10,12 +10,9 @@ ccflags-vdso := \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
 	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
+	$(CLANG_FLAGS) \
 	-D__VDSO__
 
-ifeq ($(cc-name),clang)
-ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
-endif
-
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
 	-O2 -g -fPIC -fno-strict-aliasing -fno-common -fno-builtin -G 0 \

base-commit: 2d19be4653f5e74ed95560b69f94eb6791d49af3
-- 
2.31.0.rc0


--s5n34356g5w5nvq6--
