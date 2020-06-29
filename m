Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3772320D0B3
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726153AbgF2SfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbgF2SfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C2D24779;
        Mon, 29 Jun 2020 15:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444088;
        bh=/yIniaPFKZ11CTcjGIIKnnQplSH1xgEGXA3jO9oQshA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQ/1xmDIRwhsQKmFdQNqzyW2BzHioBimgrTq7eDBlQ6S5td0E/i9AGaGoMHS8v9jv
         M37JOgG6kdG7oKvu8T4xKS5DBskr2kFk8I0bTjp3Jj+WZ8yco6BWOk+yOE+ShWCKdt
         bfllvPrfLhVywEVKLn4Oky+Kej/0raFeHTOrFWR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 198/265] s390/vdso: Use $(LD) instead of $(CC) to link vDSO
Date:   Mon, 29 Jun 2020 11:17:11 -0400
Message-Id: <20200629151818.2493727-199-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 2b2a25845d534ac6d55086e35c033961fdd83a26 ]

Currently, the VDSO is being linked through $(CC). This does not match
how the rest of the kernel links objects, which is through the $(LD)
variable.

When clang is built in a default configuration, it first attempts to use
the target triple's default linker, which is just ld. However, the user
can override this through the CLANG_DEFAULT_LINKER cmake define so that
clang uses another linker by default, such as LLVM's own linker, ld.lld.
This can be useful to get more optimized links across various different
projects.

However, this is problematic for the s390 vDSO because ld.lld does not
have any s390 emulatiom support:

https://github.com/llvm/llvm-project/blob/llvmorg-10.0.1-rc1/lld/ELF/Driver.cpp#L132-L150

Thus, if a user is using a toolchain with ld.lld as the default, they
will see an error, even if they have specified ld.bfd through the LD
make variable:

$ make -j"$(nproc)" -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- LLVM=1 \
                       LD=s390x-linux-gnu-ld \
                       defconfig arch/s390/kernel/vdso64/
ld.lld: error: unknown emulation: elf64_s390
clang-11: error: linker command failed with exit code 1 (use -v to see invocation)

Normally, '-fuse-ld=bfd' could be used to get around this; however, this
can be fragile, depending on paths and variable naming. The cleaner
solution for the kernel is to take advantage of the fact that $(LD) can
be invoked directly, which bypasses the heuristics of $(CC) and respects
the user's choice. Similar changes have been done for ARM, ARM64, and
MIPS.

Link: https://lkml.kernel.org/r/20200602192523.32758-1-natechancellor@gmail.com
Link: https://github.com/ClangBuiltLinux/linux/issues/1041
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
[heiko.carstens@de.ibm.com: add --build-id flag]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso64/Makefile | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index bec19e7e6e1cf..4a66a1cb919b1 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -18,8 +18,8 @@ KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_64 += -m64 -fPIC -shared -fno-common -fno-builtin
-KBUILD_CFLAGS_64 += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
-		    -Wl,--hash-style=both
+ldflags-y := -fPIC -shared -nostdlib -soname=linux-vdso64.so.1 \
+	     --hash-style=both --build-id -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_64)
 $(targets:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_64)
@@ -37,8 +37,8 @@ KASAN_SANITIZE := n
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso64.so.dbg: $(src)/vdso64.lds $(obj-vdso64) FORCE
-	$(call if_changed,vdso64ld)
+$(obj)/vdso64.so.dbg: $(obj)/vdso64.lds $(obj-vdso64) FORCE
+	$(call if_changed,ld)
 
 # strip rule for the .so file
 $(obj)/%.so: OBJCOPYFLAGS := -S
@@ -50,8 +50,6 @@ $(obj-vdso64): %.o: %.S FORCE
 	$(call if_changed_dep,vdso64as)
 
 # actual build commands
-quiet_cmd_vdso64ld = VDSO64L $@
-      cmd_vdso64ld = $(CC) $(c_flags) -Wl,-T $(filter %.lds %.o,$^) -o $@
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(CC) $(a_flags) -c -o $@ $<
 
-- 
2.25.1

