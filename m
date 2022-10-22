Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C318660893A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiJVIby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiJVIah (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC88981EA;
        Sat, 22 Oct 2022 01:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2371760B94;
        Sat, 22 Oct 2022 08:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18036C43148;
        Sat, 22 Oct 2022 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425638;
        bh=p9/uPrBC7Lu8bZsaakjZjm9RpK1vd5dI6sAFxr8FY58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hq2/sC/is684GzHF1BmEEoYtsEPiygjIU3UtKDlCKHaNWlEO2rtaNanQPTWOvARR9
         8E0sXVMOsFetraizS1v47AqDQP+x8K3wOdVnpB/GBWXPiurXHAXTGL9LpjuUpPOkXy
         +MpT4OQhmk653xvgmPE+YcZgCzE60Tkm6LZCPv2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 567/717] x86/apic: Dont disable x2APIC if locked
Date:   Sat, 22 Oct 2022 09:27:26 +0200
Message-Id: <20221022072523.463125265@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

[ Upstream commit b8d1d163604bd1e600b062fb00de5dc42baa355f ]

The APIC supports two modes, legacy APIC (or xAPIC), and Extended APIC
(or x2APIC).  X2APIC mode is mostly compatible with legacy APIC, but
it disables the memory-mapped APIC interface in favor of one that uses
MSRs.  The APIC mode is controlled by the EXT bit in the APIC MSR.

The MMIO/xAPIC interface has some problems, most notably the APIC LEAK
[1].  This bug allows an attacker to use the APIC MMIO interface to
extract data from the SGX enclave.

Introduce support for a new feature that will allow the BIOS to lock
the APIC in x2APIC mode.  If the APIC is locked in x2APIC mode and the
kernel tries to disable the APIC or revert to legacy APIC mode a GP
fault will occur.

Introduce support for a new MSR (IA32_XAPIC_DISABLE_STATUS) and handle
the new locked mode when the LEGACY_XAPIC_DISABLED bit is set by
preventing the kernel from trying to disable the x2APIC.

On platforms with the IA32_XAPIC_DISABLE_STATUS MSR, if SGX or TDX are
enabled the LEGACY_XAPIC_DISABLED will be set by the BIOS.  If
legacy APIC is required, then it SGX and TDX need to be disabled in the
BIOS.

[1]: https://aepicleak.com/aepicleak.pdf

Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Link: https://lkml.kernel.org/r/20220816231943.1152579-1-daniel.sneddon@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  4 ++
 arch/x86/Kconfig                              |  7 ++-
 arch/x86/include/asm/cpu.h                    |  2 +
 arch/x86/include/asm/msr-index.h              | 13 ++++++
 arch/x86/kernel/apic/apic.c                   | 44 +++++++++++++++++--
 5 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1b38d0f70677..5ef5d727ca34 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3765,6 +3765,10 @@
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
+			NOTE: this parameter will be ignored on systems with the
+			LEGACY_XAPIC_DISABLED bit set in the
+			IA32_XAPIC_DISABLE_STATUS MSR.
+
 	nps_mtm_hs_ctr=	[KNL,ARC]
 			This parameter sets the maximum duration, in
 			cycles, each HW thread of the CTOP can run
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25e2b8b75e40..1cccedfc2a48 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -450,6 +450,11 @@ config X86_X2APIC
 	  This allows 32-bit apic IDs (so it can support very large systems),
 	  and accesses the local apic via MSRs not via mmio.
 
+	  Some Intel systems circa 2022 and later are locked into x2APIC mode
+	  and can not fall back to the legacy APIC modes if SGX or TDX are
+	  enabled in the BIOS.  They will be unable to boot without enabling
+	  this option.
+
 	  If you don't know what to do here, say N.
 
 config X86_MPPARSE
@@ -1930,7 +1935,7 @@ endchoice
 
 config X86_SGX
 	bool "Software Guard eXtensions (SGX)"
-	depends on X86_64 && CPU_SUP_INTEL
+	depends on X86_64 && CPU_SUP_INTEL && X86_X2APIC
 	depends on CRYPTO=y
 	depends on CRYPTO_SHA256=y
 	select SRCU
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 8cbf623f0ecf..b472ef76826a 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -94,4 +94,6 @@ static inline bool intel_cpu_signatures_match(unsigned int s1, unsigned int p1,
 	return p1 & p2;
 }
 
+extern u64 x86_read_arch_cap_msr(void);
+
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e057e039173c..9267bfe3c33f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -155,6 +155,11 @@
 						 * Return Stack Buffer Predictions.
 						 */
 
+#define ARCH_CAP_XAPIC_DISABLE		BIT(21)	/*
+						 * IA32_XAPIC_DISABLE_STATUS MSR
+						 * supported
+						 */
+
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
 						 * Writeback and invalidate the
@@ -1046,4 +1051,12 @@
 #define MSR_IA32_HW_FEEDBACK_PTR        0x17d0
 #define MSR_IA32_HW_FEEDBACK_CONFIG     0x17d1
 
+/* x2APIC locked status */
+#define MSR_IA32_XAPIC_DISABLE_STATUS	0xBD
+#define LEGACY_XAPIC_DISABLED		BIT(0) /*
+						* x2APIC mode is locked and
+						* disabling x2APIC will cause
+						* a #GP
+						*/
+
 #endif /* _ASM_X86_MSR_INDEX_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 189d3a5e471a..665993b2e80d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -61,6 +61,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/irq_regs.h>
+#include <asm/cpu.h>
 
 unsigned int num_processors;
 
@@ -1756,11 +1757,26 @@ EXPORT_SYMBOL_GPL(x2apic_mode);
 
 enum {
 	X2APIC_OFF,
-	X2APIC_ON,
 	X2APIC_DISABLED,
+	/* All states below here have X2APIC enabled */
+	X2APIC_ON,
+	X2APIC_ON_LOCKED
 };
 static int x2apic_state;
 
+static bool x2apic_hw_locked(void)
+{
+	u64 ia32_cap;
+	u64 msr;
+
+	ia32_cap = x86_read_arch_cap_msr();
+	if (ia32_cap & ARCH_CAP_XAPIC_DISABLE) {
+		rdmsrl(MSR_IA32_XAPIC_DISABLE_STATUS, msr);
+		return (msr & LEGACY_XAPIC_DISABLED);
+	}
+	return false;
+}
+
 static void __x2apic_disable(void)
 {
 	u64 msr;
@@ -1798,6 +1814,10 @@ static int __init setup_nox2apic(char *str)
 				apicid);
 			return 0;
 		}
+		if (x2apic_hw_locked()) {
+			pr_warn("APIC locked in x2apic mode, can't disable\n");
+			return 0;
+		}
 		pr_warn("x2apic already enabled.\n");
 		__x2apic_disable();
 	}
@@ -1812,10 +1832,18 @@ early_param("nox2apic", setup_nox2apic);
 void x2apic_setup(void)
 {
 	/*
-	 * If x2apic is not in ON state, disable it if already enabled
+	 * Try to make the AP's APIC state match that of the BSP,  but if the
+	 * BSP is unlocked and the AP is locked then there is a state mismatch.
+	 * Warn about the mismatch in case a GP fault occurs due to a locked AP
+	 * trying to be turned off.
+	 */
+	if (x2apic_state != X2APIC_ON_LOCKED && x2apic_hw_locked())
+		pr_warn("x2apic lock mismatch between BSP and AP.\n");
+	/*
+	 * If x2apic is not in ON or LOCKED state, disable it if already enabled
 	 * from BIOS.
 	 */
-	if (x2apic_state != X2APIC_ON) {
+	if (x2apic_state < X2APIC_ON) {
 		__x2apic_disable();
 		return;
 	}
@@ -1836,6 +1864,11 @@ static __init void x2apic_disable(void)
 	if (x2apic_id >= 255)
 		panic("Cannot disable x2apic, id: %08x\n", x2apic_id);
 
+	if (x2apic_hw_locked()) {
+		pr_warn("Cannot disable locked x2apic, id: %08x\n", x2apic_id);
+		return;
+	}
+
 	__x2apic_disable();
 	register_lapic_address(mp_lapic_addr);
 }
@@ -1894,7 +1927,10 @@ void __init check_x2apic(void)
 	if (x2apic_enabled()) {
 		pr_info("x2apic: enabled by BIOS, switching to x2apic ops\n");
 		x2apic_mode = 1;
-		x2apic_state = X2APIC_ON;
+		if (x2apic_hw_locked())
+			x2apic_state = X2APIC_ON_LOCKED;
+		else
+			x2apic_state = X2APIC_ON;
 	} else if (!boot_cpu_has(X86_FEATURE_X2APIC)) {
 		x2apic_state = X2APIC_DISABLED;
 	}
-- 
2.35.1



