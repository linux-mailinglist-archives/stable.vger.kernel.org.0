Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32347290F55
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 07:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411785AbgJQFe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 01:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411745AbgJQFen (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 01:34:43 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9D3C0613E8
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 17:44:54 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id p21so2249886pju.0
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 17:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=BpVjr56bc2eZQztVfeg5TISaF4L8R2aKn65CiAfaVf8=;
        b=wHQ2iNs1LhleNkBlRA8uaPMfl+64Pkal9YqGeEP59Aozp8AOg3XuUa/KZ63tdNiXWc
         4fsJEBtLk1v0DtA9yTyxSzo3E/g0LBMoVdNjs6Fd9HRTs5GJ10rYU5hLzV702d4D1j/V
         IjqeW5szlOyw1B2PDHF6CC38AFe1cwr9oS2z0F+rRzrhj5sF1KmP8gLLSA6Gy5ON/v7b
         clCGVSS4teYRLohBb9msXgdBVYb66Co3QRr3XK2MpE+Nabo14jqMxZVGw9QRVbJu5Cuc
         qy5f2wdl8duTX+DEQxlY/QS12CXBB3T1kYVwfsByOHJkOd/KD81kZN+4/vJpsBR0itFS
         /7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=BpVjr56bc2eZQztVfeg5TISaF4L8R2aKn65CiAfaVf8=;
        b=aeUBYycs+35gKmdfY+gECGjyv2vl/ayH/BTvmscGGD+bjcAk0+IrS3kuYllrUNb7NZ
         iTAKrREFe/CD+X5yeG/EXo4Uvog4CTr4h2u8XnA2thjldY6Rig8IgUX5WKpiqciyyHfX
         7HCiSf+vG3dRuN3XWnvY2kXIR26SF6jSZYKE8zB67L1AqZixNnyO2MoxQhNaxLD7YWCq
         LgH/itdeAJrcpSx44xDMjbLVTxspez95JexOyZ7sOboWvcrcb0gB08KzRR+z0eRtruyI
         +7Iv/d1oJuvm4GnOwLYrIqAzq/FlnqqRcP9F2bskjLij4wFIOYYiTXP1rrmFxk+dq2XL
         O5cQ==
X-Gm-Message-State: AOAM5318OxFRFKKP9WNqKFXrb+y+QUzhRIkrQ1KgEOFvFMg9oWL0HHCd
        JsgUkx1Wlt2Ufyw4zFf+tAzvKQ==
X-Google-Smtp-Source: ABdhPJzWsBwKhGUJdUUJ4kxHgDBcaR6EmCn+93uOzDLkQ0ulBmNG+4bCUL8ro2hiIU36MkJpacA8JQ==
X-Received: by 2002:a17:90b:383:: with SMTP id ga3mr6919579pjb.2.1602895493712;
        Fri, 16 Oct 2020 17:44:53 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id b21sm3816739pfb.97.2020.10.16.17.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 17:44:53 -0700 (PDT)
Subject: [PATCH] RISC-V: Fix the VDSO symbol generaton for binutils-2.34+
Date:   Fri, 16 Oct 2020 17:25:00 -0700
Message-Id: <20201017002500.503011-1-palmerdabbelt@google.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     kernel-team@android.com, Palmer Dabbelt <palmerdabbelt@google.com>,
        stable@vger.kernel.org, clang-built-linux@googlegroups.com
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:         linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We were relying on GNU ld's ability to re-link executable files in order
to extract our VDSO symbols.  This behavior was deemed a bug as of
binutils-2.34 (specifically the binutils-gdb commit a87e1817a4 ("Have
the linker fail if any attempt to link in an executable is made."),
which IIUC landed in 2.34), which recently installed itself on my build
setup.

The previous version of this was a bit of a mess: we were linking a
static executable version of the VDSO, containing only a subset of the
input symbols, which we then linked into the kernel.  This worked, but
certainly wasn't a supported path through the toolchain.  Instead this
new version parses the textual output of nm to produce a symbol table.
Both rely on near-zero addresses being linkable, but as we rely on weak
undefined symbols being linkable elsewhere I don't view this as a major
issue.

Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
Cc: stable@vger.kernel.org
Cc: clang-built-linux@googlegroups.com
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/riscv/kernel/vdso/.gitignore |  1 +
 arch/riscv/kernel/vdso/Makefile   | 19 +++++++++----------
 arch/riscv/kernel/vdso/so2s.sh    |  7 +++++++
 3 files changed, 17 insertions(+), 10 deletions(-)
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
index 478e7338ddc1..2e02958f6224 100644
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
@@ -68,11 +63,15 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold = VDSOLD  $@
       cmd_vdsold = $(CC) $(KBUILD_CFLAGS) $(call cc-option, -no-pie) -nostdlib -nostartfiles $(SYSCFLAGS_$(@F)) \
-                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp && \
+                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp -Wl,-Map,$@.map && \
                    $(CROSS_COMPILE)objcopy \
                            $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp
 
+# Extracts
+quiet_cmd_so2s = SO2S    $@
+      cmd_so2s = $(CROSS_COMPILE)nm -D $< | $(src)/so2s.sh > $@
+
 # install commands for the unstripped file
 quiet_cmd_vdso_install = INSTALL $@
       cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
new file mode 100755
index 000000000000..7862866b5ebb
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

