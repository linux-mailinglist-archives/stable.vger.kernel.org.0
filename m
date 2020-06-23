Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5825B2059A9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbgFWRfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733287AbgFWRfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0334620706;
        Tue, 23 Jun 2020 17:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933747;
        bh=/yIniaPFKZ11CTcjGIIKnnQplSH1xgEGXA3jO9oQshA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCLGyQzulP+rba8iBPtCzR8hBnaW4BT8iFTyZ8R4xxZypeAzGPKweLD4LhnrLjx0o
         c3wRE171kX5YMr1+n2D0j2FxDx+leggM8BL1z5q3msOpm3fez4gwcgwSN60ITzAfy8
         Xypu6YI7zoa2qT2wnsg55AlsUu/P25CzaKAeR90s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.7 19/28] s390/vdso: Use $(LD) instead of $(CC) to link vDSO
Date:   Tue, 23 Jun 2020 13:35:14 -0400
Message-Id: <20200623173523.1355411-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
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

