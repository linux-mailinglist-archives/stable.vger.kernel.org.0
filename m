Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2908D38A0E5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhETJ0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231733AbhETJ0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7D1B61358;
        Thu, 20 May 2021 09:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502709;
        bh=ew4M8HlQkJCi7mRSE24rJFwi4BQphLpJSQz2xNFxnQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Um/Go0/tFY0HHdvhSQCrFNwb1LJJyNxLDK+iRUxm7BjE0jtFYkm7nG+ajnRm4ZM8c
         N02lo6l/iDQAGhjHW9lel8/pGhb9XK51L0ngV9HEHVz5wZ3+oW5NxjPA2/jF25GGUs
         Eqc7ip3HqJZ4tEHq8cGQxXsVA5mGJ8WbbrDeevlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 23/45] riscv: Use $(LD) instead of $(CC) to link vDSO
Date:   Thu, 20 May 2021 11:22:11 +0200
Message-Id: <20210520092054.270508163@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 7f3d349065d0c643f7f7013fbf9bc9f2c90b675f ]

Currently, the VDSO is being linked through $(CC). This does not match
how the rest of the kernel links objects, which is through the $(LD)
variable.

When linking with clang, there are a couple of warnings about flags that
will not be used during the link:

clang-12: warning: argument unused during compilation: '-no-pie' [-Wunused-command-line-argument]
clang-12: warning: argument unused during compilation: '-pg' [-Wunused-command-line-argument]

'-no-pie' was added in commit 85602bea297f ("RISC-V: build vdso-dummy.o
with -no-pie") to override '-pie' getting added to the ld command from
distribution versions of GCC that enable PIE by default. It is
technically no longer needed after commit c2c81bb2f691 ("RISC-V: Fix the
VDSO symbol generaton for binutils-2.35+"), which removed vdso-dummy.o
in favor of generating vdso-syms.S from vdso.so with $(NM) but this also
resolves the issue in case it ever comes back due to having full control
over the $(LD) command. '-pg' is for function tracing, it is not used
during linking as clang states.

These flags could be removed/filtered to fix the warnings but it is
easier to just match the rest of the kernel and use $(LD) directly for
linking. See commits

  fe00e50b2db8 ("ARM: 8858/1: vdso: use $(LD) instead of $(CC) to link VDSO")
  691efbedc60d ("arm64: vdso: use $(LD) instead of $(CC) to link VDSO")
  2ff906994b6c ("MIPS: VDSO: Use $(LD) instead of $(CC) to link VDSO")
  2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to link vDSO")

for more information.

The flags are converted to linker flags and '--eh-frame-hdr' is added to
match what is added by GCC implicitly, which can be seen by adding '-v'
to GCC's invocation.

Additionally, since this area is being modified, use the $(OBJCOPY)
variable instead of an open coded $(CROSS_COMPILE)objcopy so that the
user's choice of objcopy binary is respected.

Link: https://github.com/ClangBuiltLinux/linux/issues/803
Link: https://github.com/ClangBuiltLinux/linux/issues/970
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Fangrui Song <maskray@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/Makefile | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 71a315e73cbe..ca2b40dfd24b 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -41,11 +41,10 @@ KASAN_SANITIZE := n
 $(obj)/vdso.o: $(obj)/vdso.so
 
 # link rule for the .so file, .lds has to be first
-SYSCFLAGS_vdso.so.dbg = $(c_flags)
 $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
 	$(call if_changed,vdsold)
-SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
-	-Wl,--build-id=sha1 -Wl,--hash-style=both
+LDFLAGS_vdso.so.dbg = -shared -s -soname=linux-vdso.so.1 \
+	--build-id=sha1 --hash-style=both --eh-frame-hdr
 
 # We also create a special relocatable object that should mirror the symbol
 # table and layout of the linked DSO. With ld --just-symbols we can then
@@ -60,13 +59,10 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 
 # actual build commands
 # The DSO images are built using a special linker script
-# Add -lgcc so rv32 gets static muldi3 and lshrdi3 definitions.
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold = VDSOLD  $@
-      cmd_vdsold = $(CC) $(KBUILD_CFLAGS) $(call cc-option, -no-pie) -nostdlib -nostartfiles $(SYSCFLAGS_$(@F)) \
-                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp && \
-                   $(CROSS_COMPILE)objcopy \
-                           $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
+      cmd_vdsold = $(LD) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
+                   $(OBJCOPY) $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp
 
 # Extracts symbol offsets from the VDSO, converting them into an assembly file
-- 
2.30.2



