Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA9C2B62ED
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732366AbgKQNdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732360AbgKQNdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 764A62078E;
        Tue, 17 Nov 2020 13:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619984;
        bh=VpdT9lKyqfpBIjmn8GlbyElO6RyekOFckXcwyTx1sQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcMovvYwYnQhHdRlckbt2Z8RzFKqOkFVOP2GfB/JBQc5FOGb4tCEIXrtEFOLL8OQC
         23rpXdGufdhiAz16jl6VLsmzha4mgHLX57bXMGcslkGmb4zNYJ9xbfgPsWqPfmN26x
         UiRomyCXzL6sgl2v+exz1MgN2D8OA+FJ5zHA6LA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 070/255] RISC-V: Fix the VDSO symbol generaton for binutils-2.35+
Date:   Tue, 17 Nov 2020 14:03:30 +0100
Message-Id: <20201117122142.358536689@linuxfoundation.org>
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

From: Palmer Dabbelt <palmerdabbelt@google.com>

[ Upstream commit c2c81bb2f69138f902e1a58d3bef6ad97fb8a92c ]

We were relying on GNU ld's ability to re-link executable files in order
to extract our VDSO symbols.  This behavior was deemed a bug as of
binutils-2.35 (specifically the binutils-gdb commit a87e1817a4 ("Have
the linker fail if any attempt to link in an executable is made."), but
as that has been backported to at least Debian's binutils-2.34 in may
manifest in other places.

The previous version of this was a bit of a mess: we were linking a
static executable version of the VDSO, containing only a subset of the
input symbols, which we then linked into the kernel.  This worked, but
certainly wasn't a supported path through the toolchain.  Instead this
new version parses the textual output of nm to produce a symbol table.
Both rely on near-zero addresses being linkable, but as we rely on weak
undefined symbols being linkable elsewhere I don't view this as a major
issue.

Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso/.gitignore |  1 +
 arch/riscv/kernel/vdso/Makefile   | 18 +++++++++---------
 arch/riscv/kernel/vdso/so2s.sh    |  6 ++++++
 3 files changed, 16 insertions(+), 9 deletions(-)
 create mode 100755 arch/riscv/kernel/vdso/so2s.sh

diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
index 11ebee9e4c1d6..3a19def868ecc 100644
--- a/arch/riscv/kernel/vdso/.gitignore
+++ b/arch/riscv/kernel/vdso/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 vdso.lds
 *.tmp
+vdso-syms.S
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 7d6a94d45ec94..cb8f9e4cfcbf8 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -43,19 +43,14 @@ $(obj)/vdso.o: $(obj)/vdso.so
 SYSCFLAGS_vdso.so.dbg = $(c_flags)
 $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
 	$(call if_changed,vdsold)
+SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
+	-Wl,--build-id -Wl,--hash-style=both
 
 # We also create a special relocatable object that should mirror the symbol
 # table and layout of the linked DSO. With ld --just-symbols we can then
 # refer to these symbols in the kernel code rather than hand-coded addresses.
-
-SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
-	-Wl,--build-id=sha1 -Wl,--hash-style=both
-$(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
-	$(call if_changed,vdsold)
-
-LDFLAGS_vdso-syms.o := -r --just-symbols
-$(obj)/vdso-syms.o: $(obj)/vdso-dummy.o FORCE
-	$(call if_changed,ld)
+$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
+	$(call if_changed,so2s)
 
 # strip rule for the .so file
 $(obj)/%.so: OBJCOPYFLAGS := -S
@@ -73,6 +68,11 @@ quiet_cmd_vdsold = VDSOLD  $@
                            $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp
 
+# Extracts symbol offsets from the VDSO, converting them into an assembly file
+# that contains the same symbols at the same offsets.
+quiet_cmd_so2s = SO2S    $@
+      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
+
 # install commands for the unstripped file
 quiet_cmd_vdso_install = INSTALL $@
       cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
new file mode 100755
index 0000000000000..e64cb6d9440e7
--- /dev/null
+++ b/arch/riscv/kernel/vdso/so2s.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright 2020 Palmer Dabbelt <palmerdabbelt@google.com>
+
+sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)\(@@LINUX_4.15\)*!.global \2\n.set \2,0x\1!' \
+| grep '^\.'
-- 
2.27.0



