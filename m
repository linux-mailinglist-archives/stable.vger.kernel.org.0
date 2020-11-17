Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FEB2B62EC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbgKQNdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732355AbgKQNdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968292168B;
        Tue, 17 Nov 2020 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619981;
        bh=tRa10IYiYXWcjvwvF6rc8ISPqe7cNk+B1PEO0ZexQE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Om48ozs9Xb8yvVkgaIIDxpo58/cyYuQO8NaPa1tV0cit6iyvLNtT2n7BSGcRAT5+a
         k6D7f9GyPHTEbp/FGVJs+G4sQ6Gxtlb4Ejl27e7SaDCQhVTkxPeCotczM+Z7neFoMs
         Yfu2dG3A7WC9qS84kN566TDUcZ7YPTyRk0sWru/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bill Wendling <morbo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 069/255] kbuild: explicitly specify the build id style
Date:   Tue, 17 Nov 2020 14:03:29 +0100
Message-Id: <20201117122142.310456724@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bill Wendling <morbo@google.com>

[ Upstream commit a968433723310f35898b4a2f635a7991aeef66b1 ]

ld's --build-id defaults to "sha1" style, while lld defaults to "fast".
The build IDs are very different between the two, which may confuse
programs that reference them.

Signed-off-by: Bill Wendling <morbo@google.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile                             | 4 ++--
 arch/arm/vdso/Makefile               | 2 +-
 arch/arm64/kernel/vdso/Makefile      | 2 +-
 arch/arm64/kernel/vdso32/Makefile    | 2 +-
 arch/mips/vdso/Makefile              | 2 +-
 arch/riscv/kernel/vdso/Makefile      | 2 +-
 arch/s390/kernel/vdso64/Makefile     | 2 +-
 arch/sparc/vdso/Makefile             | 2 +-
 arch/x86/entry/vdso/Makefile         | 2 +-
 tools/testing/selftests/bpf/Makefile | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index 035d86a0d291d..245c66fa8be17 100644
--- a/Makefile
+++ b/Makefile
@@ -973,8 +973,8 @@ KBUILD_CPPFLAGS += $(KCPPFLAGS)
 KBUILD_AFLAGS   += $(KAFLAGS)
 KBUILD_CFLAGS   += $(KCFLAGS)
 
-KBUILD_LDFLAGS_MODULE += --build-id
-LDFLAGS_vmlinux += --build-id
+KBUILD_LDFLAGS_MODULE += --build-id=sha1
+LDFLAGS_vmlinux += --build-id=sha1
 
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
 LDFLAGS_vmlinux	+= $(call ld-option, -X,)
diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index a54f70731d9f1..150ce6e6a5d31 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -19,7 +19,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO32
 ldflags-$(CONFIG_CPU_ENDIAN_BE8) := --be8
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 	    -z max-page-size=4096 -nostdlib -shared $(ldflags-y) \
-	    --hash-style=sysv --build-id \
+	    --hash-style=sysv --build-id=sha1 \
 	    -T
 
 obj-$(CONFIG_VDSO) += vdso.o
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 45d5cfe464290..871915097f9d1 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -24,7 +24,7 @@ btildflags-$(CONFIG_ARM64_BTI_KERNEL) += -z force-bti
 # routines, as x86 does (see 6f121e548f83 ("x86, vdso: Reimplement vdso.so
 # preparation in build-time C")).
 ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv	\
-	     -Bsymbolic $(call ld-option, --no-eh-frame-hdr) --build-id -n	\
+	     -Bsymbolic $(call ld-option, --no-eh-frame-hdr) --build-id=sha1 -n	\
 	     $(btildflags-y) -T
 
 ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index d6adb4677c25f..4fa4b3fe8efb7 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -128,7 +128,7 @@ VDSO_LDFLAGS += -Wl,-Bsymbolic -Wl,--no-undefined -Wl,-soname=linux-vdso.so.1
 VDSO_LDFLAGS += -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
 VDSO_LDFLAGS += -nostdlib -shared -mfloat-abi=soft
 VDSO_LDFLAGS += -Wl,--hash-style=sysv
-VDSO_LDFLAGS += -Wl,--build-id
+VDSO_LDFLAGS += -Wl,--build-id=sha1
 VDSO_LDFLAGS += $(call cc32-ldoption,-fuse-ld=bfd)
 
 
diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 57fe832352819..5810cc12bc1d9 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -61,7 +61,7 @@ endif
 # VDSO linker flags.
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
 	$(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared \
-	-G 0 --eh-frame-hdr --hash-style=sysv --build-id -T
+	-G 0 --eh-frame-hdr --hash-style=sysv --build-id=sha1 -T
 
 CFLAGS_REMOVE_vdso.o = -pg
 
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 478e7338ddc10..7d6a94d45ec94 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -49,7 +49,7 @@ $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
 # refer to these symbols in the kernel code rather than hand-coded addresses.
 
 SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
-	-Wl,--build-id -Wl,--hash-style=both
+	-Wl,--build-id=sha1 -Wl,--hash-style=both
 $(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
 	$(call if_changed,vdsold)
 
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index 4a66a1cb919b1..edc473b32e420 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -19,7 +19,7 @@ KBUILD_AFLAGS_64 += -m64 -s
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_64 += -m64 -fPIC -shared -fno-common -fno-builtin
 ldflags-y := -fPIC -shared -nostdlib -soname=linux-vdso64.so.1 \
-	     --hash-style=both --build-id -T
+	     --hash-style=both --build-id=sha1 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_64)
 $(targets:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_64)
diff --git a/arch/sparc/vdso/Makefile b/arch/sparc/vdso/Makefile
index f44355e46f31f..469dd23887abb 100644
--- a/arch/sparc/vdso/Makefile
+++ b/arch/sparc/vdso/Makefile
@@ -115,7 +115,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -T $(filter %.lds,$^) $(filter %.o,$^) && \
 		sh $(srctree)/$(src)/checkundef.sh '$(OBJDUMP)' '$@'
 
-VDSO_LDFLAGS = -shared --hash-style=both --build-id -Bsymbolic
+VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 -Bsymbolic
 GCOV_PROFILE := n
 
 #
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 215376d975a29..ebba25ed9a386 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -176,7 +176,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -T $(filter %.lds,$^) $(filter %.o,$^) && \
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
-VDSO_LDFLAGS = -shared --hash-style=both --build-id \
+VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 \
 	$(call ld-option, --eh-frame-hdr) -Bsymbolic
 GCOV_PROFILE := n
 
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index fc946b7ac288d..daf186f88a636 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -133,7 +133,7 @@ $(OUTPUT)/%:%.c
 
 $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
-	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id
+	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id=sha1
 
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
-- 
2.27.0



