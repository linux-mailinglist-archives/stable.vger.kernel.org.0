Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121B52012A1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392047AbgFSPyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392930AbgFSPV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9E920B80;
        Fri, 19 Jun 2020 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580116;
        bh=xEbBIEsVZpgZRzeIw0W3nUmh8/Kv6ds/xYH3qeceVGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBlEkF8HHvan8EJovQv6crMiA1niTjM/3PHLLnkJE4UONVKybMGhMPnQudU1ogH1m
         GbC2BpkYzdEaEfhd2oMtat/EGViVtcBKSvm2Vv69lxstXQlQvxijyXHnlqxUdsyQkk
         /N2wYaXQ0/pYqc3RdaWTMnhm5iyGweXFNrK9mDyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 129/376] ARM: 8969/1: decompressor: simplify libfdt builds
Date:   Fri, 19 Jun 2020 16:30:47 +0200
Message-Id: <20200619141716.441573274@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 7ae4a78daacf240a8247cde73337dc4b26d253da ]

Copying source files during the build time may not end up with
as clean code as expected.

lib/fdt*.c simply wrap scripts/dtc/libfdt/fdt*.c, and it works
nicely. Let's follow this approach for the arm decompressor, too.

Add four wrappers, arch/arm/boot/compressed/fdt*.c and remove
the Makefile messes. Another nice thing is we no longer need to
maintain the own libfdt_env.h because the decompressor can include
<linux/libfdt_env.h>.

There is a subtle problem when generated files are turned into
check-in files.

When you are doing a rebuild of an existing object tree with O=
option, there exists stale "shipped" copies that the old Makefile
implementation created. The build system ends up with compiling the
stale generated files because Make searches for prerequisites in the
current directory, i.e. $(objtree) first, and then the directory
listed in VPATH, i.e. $(srctree).

To mend this issue, I added the following code:

  ifdef building_out_of_srctree
  $(shell rm -f $(addprefix $(obj)/, fdt_rw.c fdt_ro.c fdt_wip.c fdt.c))
  endif

This will need to stay for a while because "git bisect" crossing this
commit, otherwise, would result in a build error.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/.gitignore     |  9 ------
 arch/arm/boot/compressed/Makefile       | 38 ++++++++++---------------
 arch/arm/boot/compressed/atags_to_fdt.c |  1 +
 arch/arm/boot/compressed/fdt.c          |  2 ++
 arch/arm/boot/compressed/fdt_ro.c       |  2 ++
 arch/arm/boot/compressed/fdt_rw.c       |  2 ++
 arch/arm/boot/compressed/fdt_wip.c      |  2 ++
 arch/arm/boot/compressed/libfdt_env.h   | 24 ----------------
 8 files changed, 24 insertions(+), 56 deletions(-)
 create mode 100644 arch/arm/boot/compressed/fdt.c
 create mode 100644 arch/arm/boot/compressed/fdt_ro.c
 create mode 100644 arch/arm/boot/compressed/fdt_rw.c
 create mode 100644 arch/arm/boot/compressed/fdt_wip.c
 delete mode 100644 arch/arm/boot/compressed/libfdt_env.h

diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index db05c6ef3e31..60606b0f378d 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -7,12 +7,3 @@ hyp-stub.S
 piggy_data
 vmlinux
 vmlinux.lds
-
-# borrowed libfdt files
-fdt.c
-fdt.h
-fdt_ro.c
-fdt_rw.c
-fdt_wip.c
-libfdt.h
-libfdt_internal.h
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 9c11e7490292..00602a6fba04 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -76,29 +76,30 @@ compress-$(CONFIG_KERNEL_LZMA) = lzma
 compress-$(CONFIG_KERNEL_XZ)   = xzkern
 compress-$(CONFIG_KERNEL_LZ4)  = lz4
 
-# Borrowed libfdt files for the ATAG compatibility mode
-
-libfdt		:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c
-libfdt_hdrs	:= fdt.h libfdt.h libfdt_internal.h
-
-libfdt_objs	:= $(addsuffix .o, $(basename $(libfdt)))
-
-$(addprefix $(obj)/,$(libfdt) $(libfdt_hdrs)): $(obj)/%: $(srctree)/scripts/dtc/libfdt/%
-	$(call cmd,shipped)
-
-$(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
-	$(addprefix $(obj)/,$(libfdt_hdrs))
+libfdt_objs := fdt_rw.o fdt_ro.o fdt_wip.o fdt.o
 
 ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
 OBJS	+= $(libfdt_objs) atags_to_fdt.o
 endif
 
+# -fstack-protector-strong triggers protection checks in this code,
+# but it is being used too early to link to meaningful stack_chk logic.
+nossp-flags-$(CONFIG_CC_HAS_STACKPROTECTOR_NONE) := -fno-stack-protector
+$(foreach o, $(libfdt_objs) atags_to_fdt.o, \
+	$(eval CFLAGS_$(o) := -I $(srctree)/scripts/dtc/libfdt $(nossp-flags-y)))
+
+# These were previously generated C files. When you are building the kernel
+# with O=, make sure to remove the stale files in the output tree. Otherwise,
+# the build system wrongly compiles the stale ones.
+ifdef building_out_of_srctree
+$(shell rm -f $(addprefix $(obj)/, fdt_rw.c fdt_ro.c fdt_wip.c fdt.c))
+endif
+
 targets       := vmlinux vmlinux.lds piggy_data piggy.o \
 		 lib1funcs.o ashldi3.o bswapsdi2.o \
 		 head.o $(OBJS)
 
-clean-files += piggy_data lib1funcs.S ashldi3.S bswapsdi2.S \
-		$(libfdt) $(libfdt_hdrs) hyp-stub.S
+clean-files += piggy_data lib1funcs.S ashldi3.S bswapsdi2.S hyp-stub.S
 
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 
@@ -107,15 +108,6 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
-# -fstack-protector-strong triggers protection checks in this code,
-# but it is being used too early to link to meaningful stack_chk logic.
-nossp-flags-$(CONFIG_CC_HAS_STACKPROTECTOR_NONE) := -fno-stack-protector
-CFLAGS_atags_to_fdt.o := $(nossp-flags-y)
-CFLAGS_fdt.o := $(nossp-flags-y)
-CFLAGS_fdt_ro.o := $(nossp-flags-y)
-CFLAGS_fdt_rw.o := $(nossp-flags-y)
-CFLAGS_fdt_wip.o := $(nossp-flags-y)
-
 ccflags-y := -fpic $(call cc-option,-mno-single-pic-base,) -fno-builtin \
 	     -I$(obj) $(DISABLE_ARM_SSP_PER_TASK_PLUGIN)
 asflags-y := -DZIMAGE
diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
index 64c49747f8a3..8452753efebe 100644
--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/libfdt_env.h>
 #include <asm/setup.h>
 #include <libfdt.h>
 
diff --git a/arch/arm/boot/compressed/fdt.c b/arch/arm/boot/compressed/fdt.c
new file mode 100644
index 000000000000..f8ea7a201ab1
--- /dev/null
+++ b/arch/arm/boot/compressed/fdt.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "../../../../lib/fdt.c"
diff --git a/arch/arm/boot/compressed/fdt_ro.c b/arch/arm/boot/compressed/fdt_ro.c
new file mode 100644
index 000000000000..93970a4ad5ae
--- /dev/null
+++ b/arch/arm/boot/compressed/fdt_ro.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "../../../../lib/fdt_ro.c"
diff --git a/arch/arm/boot/compressed/fdt_rw.c b/arch/arm/boot/compressed/fdt_rw.c
new file mode 100644
index 000000000000..f7c6b8b7e01c
--- /dev/null
+++ b/arch/arm/boot/compressed/fdt_rw.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "../../../../lib/fdt_rw.c"
diff --git a/arch/arm/boot/compressed/fdt_wip.c b/arch/arm/boot/compressed/fdt_wip.c
new file mode 100644
index 000000000000..048d2c7a088d
--- /dev/null
+++ b/arch/arm/boot/compressed/fdt_wip.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "../../../../lib/fdt_wip.c"
diff --git a/arch/arm/boot/compressed/libfdt_env.h b/arch/arm/boot/compressed/libfdt_env.h
deleted file mode 100644
index 6a0f1f524466..000000000000
--- a/arch/arm/boot/compressed/libfdt_env.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ARM_LIBFDT_ENV_H
-#define _ARM_LIBFDT_ENV_H
-
-#include <linux/limits.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <asm/byteorder.h>
-
-#define INT32_MAX	S32_MAX
-#define UINT32_MAX	U32_MAX
-
-typedef __be16 fdt16_t;
-typedef __be32 fdt32_t;
-typedef __be64 fdt64_t;
-
-#define fdt16_to_cpu(x)		be16_to_cpu(x)
-#define cpu_to_fdt16(x)		cpu_to_be16(x)
-#define fdt32_to_cpu(x)		be32_to_cpu(x)
-#define cpu_to_fdt32(x)		cpu_to_be32(x)
-#define fdt64_to_cpu(x)		be64_to_cpu(x)
-#define cpu_to_fdt64(x)		cpu_to_be64(x)
-
-#endif
-- 
2.25.1



