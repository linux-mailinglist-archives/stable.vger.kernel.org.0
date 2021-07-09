Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC883C24D1
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhGINZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232424AbhGINZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11047613C5;
        Fri,  9 Jul 2021 13:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836941;
        bh=/fYOSpAULRZTRzccqUl3Ap7e++rcGAQeImS4kNSi6V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeUW1InnzK18/Mg2nckfcH67IRFY/PLNY0ZvwOMtKz5cJcDOphCJkDUW3IHi+ryJy
         232olL9wI5/VGK6vIoM9Ct+A5xNLLcjZuGnI62uK3aWLf7xhIXuF/FTsqq9igRtj4h
         M5S7G0ODrDiHpfNPru7kiSUOYwuqZtbUdJod+HX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sid Manning <sidneym@codeaurora.org>,
        Brian Cain <bcain@codeaurora.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.10 4/6] Hexagon: add target builtins to kernel
Date:   Fri,  9 Jul 2021 15:21:13 +0200
Message-Id: <20210709131542.303873118@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
References: <20210709131537.035851348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sid Manning <sidneym@codeaurora.org>

commit f1f99adf05f2138ff2646d756d4674e302e8d02d upstream.

Add the compiler-rt builtins like memcpy to the hexagon kernel.

Signed-off-by: Sid Manning <sidneym@codeaurora.org>
Add SYM_FUNC_START/END, ksyms exports
Signed-off-by: Brian Cain <bcain@codeaurora.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/hexagon/Makefile                    |    3 -
 arch/hexagon/kernel/hexagon_ksyms.c      |    8 +--
 arch/hexagon/lib/Makefile                |    3 -
 arch/hexagon/lib/divsi3.S                |   67 +++++++++++++++++++++++++++++++
 arch/hexagon/lib/memcpy_likely_aligned.S |   56 +++++++++++++++++++++++++
 arch/hexagon/lib/modsi3.S                |   46 +++++++++++++++++++++
 arch/hexagon/lib/udivsi3.S               |   38 +++++++++++++++++
 arch/hexagon/lib/umodsi3.S               |   36 ++++++++++++++++
 8 files changed, 249 insertions(+), 8 deletions(-)

--- a/arch/hexagon/Makefile
+++ b/arch/hexagon/Makefile
@@ -33,9 +33,6 @@ TIR_NAME := r19
 KBUILD_CFLAGS += -ffixed-$(TIR_NAME) -DTHREADINFO_REG=$(TIR_NAME) -D__linux__
 KBUILD_AFLAGS += -DTHREADINFO_REG=$(TIR_NAME)
 
-LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name 2>/dev/null)
-libs-y += $(LIBGCC)
-
 head-y := arch/hexagon/kernel/head.o
 
 core-y += arch/hexagon/kernel/ \
--- a/arch/hexagon/kernel/hexagon_ksyms.c
+++ b/arch/hexagon/kernel/hexagon_ksyms.c
@@ -35,8 +35,8 @@ EXPORT_SYMBOL(_dflt_cache_att);
 DECLARE_EXPORT(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes);
 
 /* Additional functions */
-DECLARE_EXPORT(__divsi3);
-DECLARE_EXPORT(__modsi3);
-DECLARE_EXPORT(__udivsi3);
-DECLARE_EXPORT(__umodsi3);
+DECLARE_EXPORT(__hexagon_divsi3);
+DECLARE_EXPORT(__hexagon_modsi3);
+DECLARE_EXPORT(__hexagon_udivsi3);
+DECLARE_EXPORT(__hexagon_umodsi3);
 DECLARE_EXPORT(csum_tcpudp_magic);
--- a/arch/hexagon/lib/Makefile
+++ b/arch/hexagon/lib/Makefile
@@ -2,4 +2,5 @@
 #
 # Makefile for hexagon-specific library files.
 #
-obj-y = checksum.o io.o memcpy.o memset.o
+obj-y = checksum.o io.o memcpy.o memset.o memcpy_likely_aligned.o \
+         divsi3.o modsi3.o udivsi3.o  umodsi3.o
--- /dev/null
+++ b/arch/hexagon/lib/divsi3.S
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_divsi3)
+        {
+                p0 = cmp.gt(r0,#-1)
+                p1 = cmp.gt(r1,#-1)
+                r3:2 = vabsw(r1:0)
+        }
+        {
+                p3 = xor(p0,p1)
+                r4 = sub(r2,r3)
+                r6 = cl0(r2)
+                p0 = cmp.gtu(r3,r2)
+        }
+        {
+                r0 = mux(p3,#-1,#1)
+                r7 = cl0(r3)
+                p1 = cmp.gtu(r3,r4)
+        }
+        {
+                r0 = mux(p0,#0,r0)
+                p0 = or(p0,p1)
+                if (p0.new) jumpr:nt r31
+                r6 = sub(r7,r6)
+        }
+        {
+                r7 = r6
+                r5:4 = combine(#1,r3)
+                r6 = add(#1,lsr(r6,#1))
+                p0 = cmp.gtu(r6,#4)
+        }
+        {
+                r5:4 = vaslw(r5:4,r7)
+                if (!p0) r6 = #3
+        }
+        {
+                loop0(1f,r6)
+                r7:6 = vlsrw(r5:4,#1)
+                r1:0 = #0
+        }
+        .falign
+1:
+        {
+                r5:4 = vlsrw(r5:4,#2)
+                if (!p0.new) r0 = add(r0,r5)
+                if (!p0.new) r2 = sub(r2,r4)
+                p0 = cmp.gtu(r4,r2)
+        }
+        {
+                r7:6 = vlsrw(r7:6,#2)
+                if (!p0.new) r0 = add(r0,r7)
+                if (!p0.new) r2 = sub(r2,r6)
+                p0 = cmp.gtu(r6,r2)
+        }:endloop0
+        {
+                if (!p0) r0 = add(r0,r7)
+        }
+        {
+                if (p3) r0 = sub(r1,r0)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_divsi3)
--- /dev/null
+++ b/arch/hexagon/lib/memcpy_likely_aligned.S
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes)
+        {
+                p0 = bitsclr(r1,#7)
+                p0 = bitsclr(r0,#7)
+                if (p0.new) r5:4 = memd(r1)
+                if (p0.new) r7:6 = memd(r1+#8)
+        }
+        {
+                if (!p0) jump:nt .Lmemcpy_call
+                if (p0) r9:8 = memd(r1+#16)
+                if (p0) r11:10 = memd(r1+#24)
+                p0 = cmp.gtu(r2,#64)
+        }
+        {
+                if (p0) jump:nt .Lmemcpy_call
+                if (!p0) memd(r0) = r5:4
+                if (!p0) memd(r0+#8) = r7:6
+                p0 = cmp.gtu(r2,#32)
+        }
+        {
+                p1 = cmp.gtu(r2,#40)
+                p2 = cmp.gtu(r2,#48)
+                if (p0) r13:12 = memd(r1+#32)
+                if (p1.new) r15:14 = memd(r1+#40)
+        }
+        {
+                memd(r0+#16) = r9:8
+                memd(r0+#24) = r11:10
+        }
+        {
+                if (p0) memd(r0+#32) = r13:12
+                if (p1) memd(r0+#40) = r15:14
+                if (!p2) jumpr:t r31
+        }
+        {
+                p0 = cmp.gtu(r2,#56)
+                r5:4 = memd(r1+#48)
+                if (p0.new) r7:6 = memd(r1+#56)
+        }
+        {
+                memd(r0+#48) = r5:4
+                if (p0) memd(r0+#56) = r7:6
+                jumpr r31
+        }
+
+.Lmemcpy_call:
+        jump memcpy
+
+SYM_FUNC_END(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes)
--- /dev/null
+++ b/arch/hexagon/lib/modsi3.S
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_modsi3)
+        {
+                p2 = cmp.ge(r0,#0)
+                r2 = abs(r0)
+                r1 = abs(r1)
+        }
+        {
+                r3 = cl0(r2)
+                r4 = cl0(r1)
+                p0 = cmp.gtu(r1,r2)
+        }
+        {
+                r3 = sub(r4,r3)
+                if (p0) jumpr r31
+        }
+        {
+                p1 = cmp.eq(r3,#0)
+                loop0(1f,r3)
+                r0 = r2
+                r2 = lsl(r1,r3)
+        }
+        .falign
+1:
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r2)
+                r2 = lsr(r2,#1)
+                if (p1) r1 = #0
+        }:endloop0
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r1)
+                if (p2) jumpr r31
+        }
+        {
+                r0 = neg(r0)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_modsi3)
--- /dev/null
+++ b/arch/hexagon/lib/udivsi3.S
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_udivsi3)
+        {
+                r2 = cl0(r0)
+                r3 = cl0(r1)
+                r5:4 = combine(#1,#0)
+                p0 = cmp.gtu(r1,r0)
+        }
+        {
+                r6 = sub(r3,r2)
+                r4 = r1
+                r1:0 = combine(r0,r4)
+                if (p0) jumpr r31
+        }
+        {
+                r3:2 = vlslw(r5:4,r6)
+                loop0(1f,r6)
+        }
+        .falign
+1:
+        {
+                p0 = cmp.gtu(r2,r1)
+                if (!p0.new) r1 = sub(r1,r2)
+                if (!p0.new) r0 = add(r0,r3)
+                r3:2 = vlsrw(r3:2,#1)
+        }:endloop0
+        {
+                p0 = cmp.gtu(r2,r1)
+                if (!p0.new) r0 = add(r0,r3)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_udivsi3)
--- /dev/null
+++ b/arch/hexagon/lib/umodsi3.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/linkage.h>
+
+SYM_FUNC_START(__hexagon_umodsi3)
+        {
+                r2 = cl0(r0)
+                r3 = cl0(r1)
+                p0 = cmp.gtu(r1,r0)
+        }
+        {
+                r2 = sub(r3,r2)
+                if (p0) jumpr r31
+        }
+        {
+                loop0(1f,r2)
+                p1 = cmp.eq(r2,#0)
+                r2 = lsl(r1,r2)
+        }
+        .falign
+1:
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r2)
+                r2 = lsr(r2,#1)
+                if (p1) r1 = #0
+        }:endloop0
+        {
+                p0 = cmp.gtu(r2,r0)
+                if (!p0.new) r0 = sub(r0,r1)
+                jumpr r31
+        }
+SYM_FUNC_END(__hexagon_umodsi3)


