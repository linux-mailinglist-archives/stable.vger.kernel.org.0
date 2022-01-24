Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B569A49952A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392346AbiAXUvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390183AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4D4C06138D;
        Mon, 24 Jan 2022 11:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F35AAB81247;
        Mon, 24 Jan 2022 19:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240FCC340E5;
        Mon, 24 Jan 2022 19:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054093;
        bh=XJFUSpOwGxLAKHdjHkI7nzTHoan357sgdNncSughnsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG2l7eBiKv7+MCY8UaDFqCVZWT01Qu2tl6dFPWaxbEGfKxoXJoa4WkEhP5Ju/R2/5
         KX42LozGsDOxlunGqLRvi1ayWE4ns2IDE9jkbbA/QUVcE0DjENzMOkcZCkM+350ow4
         C5ToPwHDSK2NQFR7OdnMME8LHBPa28o5JRE9CDtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/563] powerpc/64s: Convert some cpu_setup() and cpu_restore() functions to C
Date:   Mon, 24 Jan 2022 19:40:14 +0100
Message-Id: <20220124184033.028842917@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit 344fbab991a568dc33ad90711b489d870e18d26d ]

The only thing keeping the cpu_setup() and cpu_restore() functions
used in the cputable entries for Power7, Power8, Power9 and Power10 in
assembly was cpu_restore() being called before there was a stack in
generic_secondary_smp_init(). Commit ("powerpc/64: Set up a kernel
stack for secondaries before cpu_restore()") means that it is now
possible to use C.

Rewrite the functions in C so they are a little bit easier to read.
This is not changing their functionality.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
[mpe: Tweak copyright and authorship notes]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201014072837.24539-2-jniethe5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cpu_setup_power.h |  12 +
 arch/powerpc/kernel/cpu_setup_power.S      | 252 -------------------
 arch/powerpc/kernel/cpu_setup_power.c      | 271 +++++++++++++++++++++
 arch/powerpc/kernel/cputable.c             |  12 +-
 4 files changed, 287 insertions(+), 260 deletions(-)
 create mode 100644 arch/powerpc/include/asm/cpu_setup_power.h
 delete mode 100644 arch/powerpc/kernel/cpu_setup_power.S
 create mode 100644 arch/powerpc/kernel/cpu_setup_power.c

diff --git a/arch/powerpc/include/asm/cpu_setup_power.h b/arch/powerpc/include/asm/cpu_setup_power.h
new file mode 100644
index 0000000000000..24be9131f8032
--- /dev/null
+++ b/arch/powerpc/include/asm/cpu_setup_power.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2020 IBM Corporation
+ */
+void __setup_cpu_power7(unsigned long offset, struct cpu_spec *spec);
+void __restore_cpu_power7(void);
+void __setup_cpu_power8(unsigned long offset, struct cpu_spec *spec);
+void __restore_cpu_power8(void);
+void __setup_cpu_power9(unsigned long offset, struct cpu_spec *spec);
+void __restore_cpu_power9(void);
+void __setup_cpu_power10(unsigned long offset, struct cpu_spec *spec);
+void __restore_cpu_power10(void);
diff --git a/arch/powerpc/kernel/cpu_setup_power.S b/arch/powerpc/kernel/cpu_setup_power.S
deleted file mode 100644
index 704e8b9501eee..0000000000000
--- a/arch/powerpc/kernel/cpu_setup_power.S
+++ /dev/null
@@ -1,252 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * This file contains low level CPU setup functions.
- *    Copyright (C) 2003 Benjamin Herrenschmidt (benh@kernel.crashing.org)
- */
-
-#include <asm/processor.h>
-#include <asm/page.h>
-#include <asm/cputable.h>
-#include <asm/ppc_asm.h>
-#include <asm/asm-offsets.h>
-#include <asm/cache.h>
-#include <asm/book3s/64/mmu-hash.h>
-
-/* Entry: r3 = crap, r4 = ptr to cputable entry
- *
- * Note that we can be called twice for pseudo-PVRs
- */
-_GLOBAL(__setup_cpu_power7)
-	mflr	r11
-	bl	__init_hvmode_206
-	mtlr	r11
-	beqlr
-	li	r0,0
-	mtspr	SPRN_LPID,r0
-	LOAD_REG_IMMEDIATE(r0, PCR_MASK)
-	mtspr	SPRN_PCR,r0
-	mfspr	r3,SPRN_LPCR
-	li	r4,(LPCR_LPES1 >> LPCR_LPES_SH)
-	bl	__init_LPCR_ISA206
-	mtlr	r11
-	blr
-
-_GLOBAL(__restore_cpu_power7)
-	mflr	r11
-	mfmsr	r3
-	rldicl.	r0,r3,4,63
-	beqlr
-	li	r0,0
-	mtspr	SPRN_LPID,r0
-	LOAD_REG_IMMEDIATE(r0, PCR_MASK)
-	mtspr	SPRN_PCR,r0
-	mfspr	r3,SPRN_LPCR
-	li	r4,(LPCR_LPES1 >> LPCR_LPES_SH)
-	bl	__init_LPCR_ISA206
-	mtlr	r11
-	blr
-
-_GLOBAL(__setup_cpu_power8)
-	mflr	r11
-	bl	__init_FSCR
-	bl	__init_PMU
-	bl	__init_PMU_ISA207
-	bl	__init_hvmode_206
-	mtlr	r11
-	beqlr
-	li	r0,0
-	mtspr	SPRN_LPID,r0
-	LOAD_REG_IMMEDIATE(r0, PCR_MASK)
-	mtspr	SPRN_PCR,r0
-	mfspr	r3,SPRN_LPCR
-	ori	r3, r3, LPCR_PECEDH
-	li	r4,0 /* LPES = 0 */
-	bl	__init_LPCR_ISA206
-	bl	__init_HFSCR
-	bl	__init_PMU_HV
-	bl	__init_PMU_HV_ISA207
-	mtlr	r11
-	blr
-
-_GLOBAL(__restore_cpu_power8)
-	mflr	r11
-	bl	__init_FSCR
-	bl	__init_PMU
-	bl	__init_PMU_ISA207
-	mfmsr	r3
-	rldicl.	r0,r3,4,63
-	mtlr	r11
-	beqlr
-	li	r0,0
-	mtspr	SPRN_LPID,r0
-	LOAD_REG_IMMEDIATE(r0, PCR_MASK)
-	mtspr	SPRN_PCR,r0
-	mfspr   r3,SPRN_LPCR
-	ori	r3, r3, LPCR_PECEDH
-	li	r4,0 /* LPES = 0 */
-	bl	__init_LPCR_ISA206
-	bl	__init_HFSCR
-	bl	__init_PMU_HV
-	bl	__init_PMU_HV_ISA207
-	mtlr	r11
-	blr
-
-_GLOBAL(__setup_cpu_power10)
-	mflr	r11
-	bl	__init_FSCR_power10
-	bl	__init_PMU
-	bl	__init_PMU_ISA31
-	b	1f
-
-_GLOBAL(__setup_cpu_power9)
-	mflr	r11
-	bl	__init_FSCR_power9
-	bl	__init_PMU
-1:	bl	__init_hvmode_206
-	mtlr	r11
-	beqlr
-	li	r0,0
-	mtspr	SPRN_PSSCR,r0
-	mtspr	SPRN_LPID,r0
-	mtspr	SPRN_PID,r0
-	LOAD_REG_IMMEDIATE(r0, PCR_MASK)
-	mtspr	SPRN_PCR,r0
-	mfspr	r3,SPRN_LPCR
-	LOAD_REG_IMMEDIATE(r4, LPCR_PECEDH | LPCR_PECE_HVEE | LPCR_HVICE  | LPCR_HEIC)
-	or	r3, r3, r4
-	LOAD_REG_IMMEDIATE(r4, LPCR_UPRT | LPCR_HR)
-	andc	r3, r3, r4
-	li	r4,0 /* LPES = 0 */
-	bl	__init_LPCR_ISA300
-	bl	__init_HFSCR
-	bl	__init_PMU_HV
-	mtlr	r11
-	blr
-
-_GLOBAL(__restore_cpu_power10)
-	mflr	r11
-	bl	__init_FSCR_power10
-	bl	__init_PMU
-	bl	__init_PMU_ISA31
-	b	1f
-
-_GLOBAL(__restore_cpu_power9)
-	mflr	r11
-	bl	__init_FSCR_power9
-	bl	__init_PMU
-1:	mfmsr	r3
-	rldicl.	r0,r3,4,63
-	mtlr	r11
-	beqlr
-	li	r0,0
-	mtspr	SPRN_PSSCR,r0
-	mtspr	SPRN_LPID,r0
-	mtspr	SPRN_PID,r0
-	LOAD_REG_IMMEDIATE(r0, PCR_MASK)
-	mtspr	SPRN_PCR,r0
-	mfspr   r3,SPRN_LPCR
-	LOAD_REG_IMMEDIATE(r4, LPCR_PECEDH | LPCR_PECE_HVEE | LPCR_HVICE | LPCR_HEIC)
-	or	r3, r3, r4
-	LOAD_REG_IMMEDIATE(r4, LPCR_UPRT | LPCR_HR)
-	andc	r3, r3, r4
-	li	r4,0 /* LPES = 0 */
-	bl	__init_LPCR_ISA300
-	bl	__init_HFSCR
-	bl	__init_PMU_HV
-	mtlr	r11
-	blr
-
-__init_hvmode_206:
-	/* Disable CPU_FTR_HVMODE and exit if MSR:HV is not set */
-	mfmsr	r3
-	rldicl.	r0,r3,4,63
-	bnelr
-	ld	r5,CPU_SPEC_FEATURES(r4)
-	LOAD_REG_IMMEDIATE(r6,CPU_FTR_HVMODE | CPU_FTR_P9_TM_HV_ASSIST)
-	andc	r5,r5,r6
-	std	r5,CPU_SPEC_FEATURES(r4)
-	blr
-
-__init_LPCR_ISA206:
-	/* Setup a sane LPCR:
-	 *   Called with initial LPCR in R3 and desired LPES 2-bit value in R4
-	 *
-	 *   LPES = 0b01 (HSRR0/1 used for 0x500)
-	 *   PECE = 0b111
-	 *   DPFD = 4
-	 *   HDICE = 0
-	 *   VC = 0b100 (VPM0=1, VPM1=0, ISL=0)
-	 *   VRMASD = 0b10000 (L=1, LP=00)
-	 *
-	 * Other bits untouched for now
-	 */
-	li	r5,0x10
-	rldimi	r3,r5, LPCR_VRMASD_SH, 64-LPCR_VRMASD_SH-5
-
-	/* POWER9 has no VRMASD */
-__init_LPCR_ISA300:
-	rldimi	r3,r4, LPCR_LPES_SH, 64-LPCR_LPES_SH-2
-	ori	r3,r3,(LPCR_PECE0|LPCR_PECE1|LPCR_PECE2)
-	li	r5,4
-	rldimi	r3,r5, LPCR_DPFD_SH, 64-LPCR_DPFD_SH-3
-	clrrdi	r3,r3,1		/* clear HDICE */
-	li	r5,4
-	rldimi	r3,r5, LPCR_VC_SH, 0
-	mtspr	SPRN_LPCR,r3
-	isync
-	blr
-
-__init_FSCR_power10:
-	mfspr	r3, SPRN_FSCR
-	ori	r3, r3, FSCR_PREFIX
-	mtspr	SPRN_FSCR, r3
-	// fall through
-
-__init_FSCR_power9:
-	mfspr	r3, SPRN_FSCR
-	ori	r3, r3, FSCR_SCV
-	mtspr	SPRN_FSCR, r3
-	// fall through
-
-__init_FSCR:
-	mfspr	r3,SPRN_FSCR
-	ori	r3,r3,FSCR_TAR|FSCR_EBB
-	mtspr	SPRN_FSCR,r3
-	blr
-
-__init_HFSCR:
-	mfspr	r3,SPRN_HFSCR
-	ori	r3,r3,HFSCR_TAR|HFSCR_TM|HFSCR_BHRB|HFSCR_PM|\
-		      HFSCR_DSCR|HFSCR_VECVSX|HFSCR_FP|HFSCR_EBB|HFSCR_MSGP
-	mtspr	SPRN_HFSCR,r3
-	blr
-
-__init_PMU_HV:
-	li	r5,0
-	mtspr	SPRN_MMCRC,r5
-	blr
-
-__init_PMU_HV_ISA207:
-	li	r5,0
-	mtspr	SPRN_MMCRH,r5
-	blr
-
-__init_PMU:
-	li	r5,0
-	mtspr	SPRN_MMCRA,r5
-	mtspr	SPRN_MMCR0,r5
-	mtspr	SPRN_MMCR1,r5
-	mtspr	SPRN_MMCR2,r5
-	blr
-
-__init_PMU_ISA207:
-	li	r5,0
-	mtspr	SPRN_MMCRS,r5
-	blr
-
-__init_PMU_ISA31:
-	li	r5,0
-	mtspr	SPRN_MMCR3,r5
-	LOAD_REG_IMMEDIATE(r5, MMCRA_BHRB_DISABLE)
-	mtspr	SPRN_MMCRA,r5
-	blr
diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kernel/cpu_setup_power.c
new file mode 100644
index 0000000000000..0c2191ee139ec
--- /dev/null
+++ b/arch/powerpc/kernel/cpu_setup_power.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2020, Jordan Niethe, IBM Corporation.
+ *
+ * This file contains low level CPU setup functions.
+ * Originally written in assembly by Benjamin Herrenschmidt & various other
+ * authors.
+ */
+
+#include <asm/reg.h>
+#include <asm/synch.h>
+#include <linux/bitops.h>
+#include <asm/cputable.h>
+#include <asm/cpu_setup_power.h>
+
+/* Disable CPU_FTR_HVMODE and return false if MSR:HV is not set */
+static bool init_hvmode_206(struct cpu_spec *t)
+{
+	u64 msr;
+
+	msr = mfmsr();
+	if (msr & MSR_HV)
+		return true;
+
+	t->cpu_features &= ~(CPU_FTR_HVMODE | CPU_FTR_P9_TM_HV_ASSIST);
+	return false;
+}
+
+static void init_LPCR_ISA300(u64 lpcr, u64 lpes)
+{
+	/* POWER9 has no VRMASD */
+	lpcr |= (lpes << LPCR_LPES_SH) & LPCR_LPES;
+	lpcr |= LPCR_PECE0|LPCR_PECE1|LPCR_PECE2;
+	lpcr |= (4ull << LPCR_DPFD_SH) & LPCR_DPFD;
+	lpcr &= ~LPCR_HDICE;	/* clear HDICE */
+	lpcr |= (4ull << LPCR_VC_SH);
+	mtspr(SPRN_LPCR, lpcr);
+	isync();
+}
+
+/*
+ * Setup a sane LPCR:
+ *   Called with initial LPCR and desired LPES 2-bit value
+ *
+ *   LPES = 0b01 (HSRR0/1 used for 0x500)
+ *   PECE = 0b111
+ *   DPFD = 4
+ *   HDICE = 0
+ *   VC = 0b100 (VPM0=1, VPM1=0, ISL=0)
+ *   VRMASD = 0b10000 (L=1, LP=00)
+ *
+ * Other bits untouched for now
+ */
+static void init_LPCR_ISA206(u64 lpcr, u64 lpes)
+{
+	lpcr |= (0x10ull << LPCR_VRMASD_SH) & LPCR_VRMASD;
+	init_LPCR_ISA300(lpcr, lpes);
+}
+
+static void init_FSCR(void)
+{
+	u64 fscr;
+
+	fscr = mfspr(SPRN_FSCR);
+	fscr |= FSCR_TAR|FSCR_EBB;
+	mtspr(SPRN_FSCR, fscr);
+}
+
+static void init_FSCR_power9(void)
+{
+	u64 fscr;
+
+	fscr = mfspr(SPRN_FSCR);
+	fscr |= FSCR_SCV;
+	mtspr(SPRN_FSCR, fscr);
+	init_FSCR();
+}
+
+static void init_FSCR_power10(void)
+{
+	u64 fscr;
+
+	fscr = mfspr(SPRN_FSCR);
+	fscr |= FSCR_PREFIX;
+	mtspr(SPRN_FSCR, fscr);
+	init_FSCR_power9();
+}
+
+static void init_HFSCR(void)
+{
+	u64 hfscr;
+
+	hfscr = mfspr(SPRN_HFSCR);
+	hfscr |= HFSCR_TAR|HFSCR_TM|HFSCR_BHRB|HFSCR_PM|HFSCR_DSCR|\
+		 HFSCR_VECVSX|HFSCR_FP|HFSCR_EBB|HFSCR_MSGP;
+	mtspr(SPRN_HFSCR, hfscr);
+}
+
+static void init_PMU_HV(void)
+{
+	mtspr(SPRN_MMCRC, 0);
+}
+
+static void init_PMU_HV_ISA207(void)
+{
+	mtspr(SPRN_MMCRH, 0);
+}
+
+static void init_PMU(void)
+{
+	mtspr(SPRN_MMCRA, 0);
+	mtspr(SPRN_MMCR0, 0);
+	mtspr(SPRN_MMCR1, 0);
+	mtspr(SPRN_MMCR2, 0);
+}
+
+static void init_PMU_ISA207(void)
+{
+	mtspr(SPRN_MMCRS, 0);
+}
+
+static void init_PMU_ISA31(void)
+{
+	mtspr(SPRN_MMCR3, 0);
+	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
+}
+
+/*
+ * Note that we can be called twice of pseudo-PVRs.
+ * The parameter offset is not used.
+ */
+
+void __setup_cpu_power7(unsigned long offset, struct cpu_spec *t)
+{
+	if (!init_hvmode_206(t))
+		return;
+
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA206(mfspr(SPRN_LPCR), LPCR_LPES1 >> LPCR_LPES_SH);
+}
+
+void __restore_cpu_power7(void)
+{
+	u64 msr;
+
+	msr = mfmsr();
+	if (!(msr & MSR_HV))
+		return;
+
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA206(mfspr(SPRN_LPCR), LPCR_LPES1 >> LPCR_LPES_SH);
+}
+
+void __setup_cpu_power8(unsigned long offset, struct cpu_spec *t)
+{
+	init_FSCR();
+	init_PMU();
+	init_PMU_ISA207();
+
+	if (!init_hvmode_206(t))
+		return;
+
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA206(mfspr(SPRN_LPCR) | LPCR_PECEDH, 0); /* LPES = 0 */
+	init_HFSCR();
+	init_PMU_HV();
+	init_PMU_HV_ISA207();
+}
+
+void __restore_cpu_power8(void)
+{
+	u64 msr;
+
+	init_FSCR();
+	init_PMU();
+	init_PMU_ISA207();
+
+	msr = mfmsr();
+	if (!(msr & MSR_HV))
+		return;
+
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA206(mfspr(SPRN_LPCR) | LPCR_PECEDH, 0); /* LPES = 0 */
+	init_HFSCR();
+	init_PMU_HV();
+	init_PMU_HV_ISA207();
+}
+
+void __setup_cpu_power9(unsigned long offset, struct cpu_spec *t)
+{
+	init_FSCR_power9();
+	init_PMU();
+
+	if (!init_hvmode_206(t))
+		return;
+
+	mtspr(SPRN_PSSCR, 0);
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
+			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
+	init_HFSCR();
+	init_PMU_HV();
+}
+
+void __restore_cpu_power9(void)
+{
+	u64 msr;
+
+	init_FSCR_power9();
+	init_PMU();
+
+	msr = mfmsr();
+	if (!(msr & MSR_HV))
+		return;
+
+	mtspr(SPRN_PSSCR, 0);
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
+			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
+	init_HFSCR();
+	init_PMU_HV();
+}
+
+void __setup_cpu_power10(unsigned long offset, struct cpu_spec *t)
+{
+	init_FSCR_power10();
+	init_PMU();
+	init_PMU_ISA31();
+
+	if (!init_hvmode_206(t))
+		return;
+
+	mtspr(SPRN_PSSCR, 0);
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
+			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
+	init_HFSCR();
+	init_PMU_HV();
+}
+
+void __restore_cpu_power10(void)
+{
+	u64 msr;
+
+	init_FSCR_power10();
+	init_PMU();
+	init_PMU_ISA31();
+
+	msr = mfmsr();
+	if (!(msr & MSR_HV))
+		return;
+
+	mtspr(SPRN_PSSCR, 0);
+	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_PCR, PCR_MASK);
+	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
+			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
+	init_HFSCR();
+	init_PMU_HV();
+}
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 29de58d4dfb76..8fdb40ee86d11 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -60,19 +60,15 @@ extern void __setup_cpu_7410(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_745x(unsigned long offset, struct cpu_spec* spec);
 #endif /* CONFIG_PPC32 */
 #ifdef CONFIG_PPC64
+#include <asm/cpu_setup_power.h>
 extern void __setup_cpu_ppc970(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_ppc970MP(unsigned long offset, struct cpu_spec* spec);
 extern void __setup_cpu_pa6t(unsigned long offset, struct cpu_spec* spec);
 extern void __restore_cpu_pa6t(void);
 extern void __restore_cpu_ppc970(void);
-extern void __setup_cpu_power7(unsigned long offset, struct cpu_spec* spec);
-extern void __restore_cpu_power7(void);
-extern void __setup_cpu_power8(unsigned long offset, struct cpu_spec* spec);
-extern void __restore_cpu_power8(void);
-extern void __setup_cpu_power9(unsigned long offset, struct cpu_spec* spec);
-extern void __restore_cpu_power9(void);
-extern void __setup_cpu_power10(unsigned long offset, struct cpu_spec* spec);
-extern void __restore_cpu_power10(void);
+extern long __machine_check_early_realmode_p7(struct pt_regs *regs);
+extern long __machine_check_early_realmode_p8(struct pt_regs *regs);
+extern long __machine_check_early_realmode_p9(struct pt_regs *regs);
 #endif /* CONFIG_PPC64 */
 #if defined(CONFIG_E500)
 extern void __setup_cpu_e5500(unsigned long offset, struct cpu_spec* spec);
-- 
2.34.1



