Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A474E1ED0D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfEOLEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbfEOLEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:04:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7648520644;
        Wed, 15 May 2019 11:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918281;
        bh=8bRBB0jgKPhGhKmechbQkP4XbKc74refvzJaTt8w4Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJXhwlxz2Rt1B6YRwp6TSEqy0D9xlZkbqYT3LoJEPadP4togBrXlMleVWJ/31rkQi
         2RSINxavzoaqfwFNpWIsDDbbcP/NEeJLkswJAaLtC19XRiCpwKEMXLIGzWl5Haqa+i
         L8DQmd+1UyM9zk5Y3U8Fza+xa2Ppr785Mm39orME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 023/266] powerpc: Add security feature flags for Spectre/Meltdown
Date:   Wed, 15 May 2019 12:52:10 +0200
Message-Id: <20190515090723.366759612@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 9a868f634349e62922c226834aa23e3d1329ae7f upstream.

This commit adds security feature flags to reflect the settings we
receive from firmware regarding Spectre/Meltdown mitigations.

The feature names reflect the names we are given by firmware on bare
metal machines. See the hostboot source for details.

Arguably these could be firmware features, but that then requires them
to be read early in boot so they're available prior to asm feature
patching, but we don't actually want to use them for patching. We may
also want to dynamically update them in future, which would be
incompatible with the way firmware features work (at the moment at
least). So for now just make them separate flags.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/security_features.h |   65 +++++++++++++++++++++++++++
 arch/powerpc/kernel/Makefile                 |    2 
 arch/powerpc/kernel/security.c               |   15 ++++++
 3 files changed, 81 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/security_features.h
 create mode 100644 arch/powerpc/kernel/security.c

--- /dev/null
+++ b/arch/powerpc/include/asm/security_features.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Security related feature bit definitions.
+ *
+ * Copyright 2018, Michael Ellerman, IBM Corporation.
+ */
+
+#ifndef _ASM_POWERPC_SECURITY_FEATURES_H
+#define _ASM_POWERPC_SECURITY_FEATURES_H
+
+
+extern unsigned long powerpc_security_features;
+
+static inline void security_ftr_set(unsigned long feature)
+{
+	powerpc_security_features |= feature;
+}
+
+static inline void security_ftr_clear(unsigned long feature)
+{
+	powerpc_security_features &= ~feature;
+}
+
+static inline bool security_ftr_enabled(unsigned long feature)
+{
+	return !!(powerpc_security_features & feature);
+}
+
+
+// Features indicating support for Spectre/Meltdown mitigations
+
+// The L1-D cache can be flushed with ori r30,r30,0
+#define SEC_FTR_L1D_FLUSH_ORI30		0x0000000000000001ull
+
+// The L1-D cache can be flushed with mtspr 882,r0 (aka SPRN_TRIG2)
+#define SEC_FTR_L1D_FLUSH_TRIG2		0x0000000000000002ull
+
+// ori r31,r31,0 acts as a speculation barrier
+#define SEC_FTR_SPEC_BAR_ORI31		0x0000000000000004ull
+
+// Speculation past bctr is disabled
+#define SEC_FTR_BCCTRL_SERIALISED	0x0000000000000008ull
+
+// Entries in L1-D are private to a SMT thread
+#define SEC_FTR_L1D_THREAD_PRIV		0x0000000000000010ull
+
+// Indirect branch prediction cache disabled
+#define SEC_FTR_COUNT_CACHE_DISABLED	0x0000000000000020ull
+
+
+// Features indicating need for Spectre/Meltdown mitigations
+
+// The L1-D cache should be flushed on MSR[HV] 1->0 transition (hypervisor to guest)
+#define SEC_FTR_L1D_FLUSH_HV		0x0000000000000040ull
+
+// The L1-D cache should be flushed on MSR[PR] 0->1 transition (kernel to userspace)
+#define SEC_FTR_L1D_FLUSH_PR		0x0000000000000080ull
+
+// A speculation barrier should be used for bounds checks (Spectre variant 1)
+#define SEC_FTR_BNDS_CHK_SPEC_BAR	0x0000000000000100ull
+
+// Firmware configuration indicates user favours security over performance
+#define SEC_FTR_FAVOUR_SECURITY		0x0000000000000200ull
+
+#endif /* _ASM_POWERPC_SECURITY_FEATURES_H */
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -40,7 +40,7 @@ obj-$(CONFIG_PPC64)		+= setup_64.o sys_p
 obj-$(CONFIG_VDSO32)		+= vdso32/
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
 obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_ppc970.o cpu_setup_pa6t.o
-obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_power.o
+obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_power.o security.o
 obj-$(CONFIG_PPC_BOOK3S_64)	+= mce.o mce_power.o
 obj64-$(CONFIG_RELOCATABLE)	+= reloc_64.o
 obj-$(CONFIG_PPC_BOOK3E_64)	+= exceptions-64e.o idle_book3e.o
--- /dev/null
+++ b/arch/powerpc/kernel/security.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Security related flags and so on.
+//
+// Copyright 2018, Michael Ellerman, IBM Corporation.
+
+#include <linux/kernel.h>
+#include <asm/security_features.h>
+
+
+unsigned long powerpc_security_features __read_mostly = \
+	SEC_FTR_L1D_FLUSH_HV | \
+	SEC_FTR_L1D_FLUSH_PR | \
+	SEC_FTR_BNDS_CHK_SPEC_BAR | \
+	SEC_FTR_FAVOUR_SECURITY;


