Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76473297ADD
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 07:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759533AbgJXFDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 01:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759532AbgJXFDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 01:03:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0522FC0613CE
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 22:03:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v22so2076633ply.12
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 22:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=fSG6cPQ/PyomxWc/r6YhnXh3q/R6HLUA/aYpEpKSBuo=;
        b=Ck8l79uKHhH5d1R9eiDBXANxD5n+Z3S1QMYyjI/kWssbthf2tFadAq+YDK0ai8qzy6
         1mxjmBKDNNq6hex7mwrbHJVIPC7mWu1/vk5yBORbG+92kdAHXTex2w94HTEaohwfgR8d
         uxgp6HsO+uLU5p+z65lCPXsFEBR/cmFIf7k6Was9dAqh/fv+KXHB8/fvg6ofP0AihiBk
         22HKjXeSzk+sGIy3GptSK02d2mVaY9UrKfexw6c9sfeCq779CJumtbs5gfFxsga/C/PQ
         rDcxj3J1O3TloaU6ntgRuN9TEYxdODyVPbpnHaDj1pYe69MgLoUC4vUcjUHnK71cRE92
         peew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=fSG6cPQ/PyomxWc/r6YhnXh3q/R6HLUA/aYpEpKSBuo=;
        b=GLsXYbYc3FmRQ9/1REn0Er99dKBcCWNYC50KVhfhs33Rs/ZTQ/FVA1/XsB7s2QcQos
         NlTtQRMm04YGrSFm56mZFRgo/Kf9bXrKJqYjbJuS4PWskn6f7lPuaeKKF1RXzMaUn9Az
         j9wiq3KDQhi1WHm1ftZbz3KO+NwXr9+LlQRJRJmajMJeEENNgoYcpYGWd8C1hMN1Kku6
         OsipBI6Ud5Pv3kdXjyMtTR49i4niStErFp2IEOA4cMkBCohqT8pPFG0ZLvJqsRKv2K0w
         DyQN9ddNQPmWYoXtf9AxjG9fUNtAuqUVDoH9OxUWbUQZkDZYKQp+BUIDKBWjyFb+UNRX
         yJLg==
X-Gm-Message-State: AOAM532ZhkHe/rGSIwUe9u4At32E3B2JcMFjGUw5GOBrPmG9pCw1e+lN
        YLM1zy71mi0E/DCwTl5S2xGiCAqQTdhJEUo5
X-Google-Smtp-Source: ABdhPJxzEW3qBE2dkwpqCq7TWlywllpMxDCNVcvmeC0gCKtBgUJQ54A7hsOy6xsSkJfdnTgOSoz/Yw==
X-Received: by 2002:a17:90a:f187:: with SMTP id bv7mr6886050pjb.198.1603515814166;
        Fri, 23 Oct 2020 22:03:34 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id w19sm3899261pfn.174.2020.10.23.22.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 22:03:33 -0700 (PDT)
Subject: [PATCH v3] RISC-V: Fix the VDSO symbol generaton for binutils-2.35+
Date:   Fri, 23 Oct 2020 21:50:47 -0700
Message-Id: <20201024045046.3018271-1-palmerdabbelt@google.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     kernel-team@android.com, Palmer Dabbelt <palmerdabbelt@google.com>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:         linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We were relying on GNU ld's ability to re-link executable files in order
to extract our VDSO symbols.  This behavior was deemed a bug as of
binutils-2.35 (specifically the binutils-gdb commit a87e1817a4 ("Have
the linker fail if any attempt to link in an executable is made."), but as that
has been backported to at least Debian's binutils-2.34 in may manifest in other
places.

The previous version of this was a bit of a mess: we were linking a
static executable version of the VDSO, containing only a subset of the
input symbols, which we then linked into the kernel.  This worked, but
certainly wasn't a supported path through the toolchain.  Instead this
new version parses the textual output of nm to produce a symbol table.
Both rely on near-zero addresses being linkable, but as we rely on weak
undefined symbols being linkable elsewhere I don't view this as a major
issue.

Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
Cc: clang-built-linux@googlegroups.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

---

Changes since v2 <20201019235630.762886-1-palmerdabbelt@google.com>:

* Uses $(srctree)/$(src) to allow for out-of-tree builds.

Changes since v1 <20201017002500.503011-1-palmerdabbelt@google.com>:

* Uses $(NM) instead of $(CROSS_COMPILE)nm.  We use the $(CROSS_COMPILE) form
  elsewhere in this file, but we'll fix that later.
* Removed the unnecesary .map file creation.

---
 arch/riscv/kernel/vdso/.gitignore |  1 +
 arch/riscv/kernel/vdso/Makefile   | 17 ++++++++---------
 arch/riscv/kernel/vdso/so2s.sh    |  6 ++++++
 3 files changed, 15 insertions(+), 9 deletions(-)
 create mode 100755 arch/riscv/kernel/vdso/so2s.sh

diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
index 11ebee9e4c1d..3a19def868ec 100644
--- a/arch/riscv/kernel/vdso/.gitignore
+++ b/arch/riscv/kernel/vdso/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 vdso.lds
 *.tmp
+vdso-syms.S
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 478e7338ddc1..a8ecf102e09b 100644
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
-	-Wl,--build-id -Wl,--hash-style=both
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
@@ -73,6 +68,10 @@ quiet_cmd_vdsold = VDSOLD  $@
                            $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp
 
+# Extracts
+quiet_cmd_so2s = SO2S    $@
+      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
+
 # install commands for the unstripped file
 quiet_cmd_vdso_install = INSTALL $@
       cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
new file mode 100755
index 000000000000..3c5b43207658
--- /dev/null
+++ b/arch/riscv/kernel/vdso/so2s.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright 2020 Palmer Dabbelt <palmerdabbelt@google.com>
+
+sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)@@LINUX_4.15!.global \2\n.set \2,0x\1!' \
+| grep '^\.'
-- 
2.29.0.rc1.297.gfa9743e501-goog

