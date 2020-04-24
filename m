Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC51B7BBF
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgDXQi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:38:29 -0400
Received: from foss.arm.com ([217.140.110.172]:39460 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXQi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 12:38:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB18131B;
        Fri, 24 Apr 2020 09:38:28 -0700 (PDT)
Received: from melchizedek.cambridge.arm.com (melchizedek.cambridge.arm.com [10.1.196.50])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C28F3F68F;
        Fri, 24 Apr 2020 09:38:28 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org
Subject: [stable:PATCH 1/4 v5.4] arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1 #1542419
Date:   Fri, 24 Apr 2020 17:38:02 +0100
Message-Id: <20200424163805.4087-2-james.morse@arm.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200424163805.4087-1-james.morse@arm.com>
References: <20200424163805.4087-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 05460849c3b51180d5ada3373d0449aea19075e4 ]

Cores affected by Neoverse-N1 #1542419 could execute a stale instruction
when a branch is updated to point to freshly generated instructions.

To workaround this issue we need user-space to issue unnecessary
icache maintenance that we can trap. Start by hiding CTR_EL0.DIC.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 16 +++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 32 +++++++++++++++++++++++++-
 arch/arm64/kernel/traps.c              |  3 +++
 5 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 5a09661330fc..59daa4c21816 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -88,6 +88,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-N1     | #1542419        | ARM64_ERRATUM_1542419       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6ccd2ed30963..a0bc9bbb92f3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -559,6 +559,22 @@ config ARM64_ERRATUM_1463225
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1542419
+	bool "Neoverse-N1: workaround mis-ordering of instruction fetches"
+	default y
+	help
+	  This option adds a workaround for ARM Neoverse-N1 erratum
+	  1542419.
+
+	  Affected Neoverse-N1 cores could execute a stale instruction when
+	  modified by another CPU. The workaround depends on a firmware
+	  counterpart.
+
+	  Workaround the issue by hiding the DIC feature from EL0. This
+	  forces user-space to perform cache maintenance.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index ac1dbca3d0cd..1dc3c762fdcb 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -54,7 +54,8 @@
 #define ARM64_WORKAROUND_1463225		44
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_TVM	45
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM	46
+#define ARM64_WORKAROUND_1542419		47
 
-#define ARM64_NCAPS				47
+#define ARM64_NCAPS				48
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 96f576e9ea46..0b2830379fe0 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -88,13 +88,21 @@ has_mismatched_cache_type(const struct arm64_cpu_capabilities *entry,
 }
 
 static void
-cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
+cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *cap)
 {
 	u64 mask = arm64_ftr_reg_ctrel0.strict_mask;
+	bool enable_uct_trap = false;
 
 	/* Trap CTR_EL0 access on this CPU, only if it has a mismatch */
 	if ((read_cpuid_cachetype() & mask) !=
 	    (arm64_ftr_reg_ctrel0.sys_val & mask))
+		enable_uct_trap = true;
+
+	/* ... or if the system is affected by an erratum */
+	if (cap->capability == ARM64_WORKAROUND_1542419)
+		enable_uct_trap = true;
+
+	if (enable_uct_trap)
 		sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCT, 0);
 }
 
@@ -651,6 +659,18 @@ needs_tx2_tvm_workaround(const struct arm64_cpu_capabilities *entry,
 	return false;
 }
 
+static bool __maybe_unused
+has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
+				int scope)
+{
+	u32 midr = read_cpuid_id();
+	bool has_dic = read_cpuid_cachetype() & BIT(CTR_DIC_SHIFT);
+	const struct midr_range range = MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1);
+
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return is_midr_in_range(midr, &range) && has_dic;
+}
+
 #ifdef CONFIG_HARDEN_EL2_VECTORS
 
 static const struct midr_range arm64_harden_el2_vectors[] = {
@@ -927,6 +947,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM,
 		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1542419
+	{
+		/* we depend on the firmware portion for correctness */
+		.desc = "ARM erratum 1542419 (kernel portion)",
+		.capability = ARM64_WORKAROUND_1542419,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = has_neoverse_n1_erratum_1542419,
+		.cpu_enable = cpu_enable_trap_ctr_access,
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 34739e80211b..465f0a0f8f0a 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -470,6 +470,9 @@ static void ctr_read_handler(unsigned int esr, struct pt_regs *regs)
 	int rt = ESR_ELx_SYS64_ISS_RT(esr);
 	unsigned long val = arm64_ftr_reg_user_value(&arm64_ftr_reg_ctrel0);
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1542419))
+		val &= ~BIT(CTR_DIC_SHIFT);
+
 	pt_regs_write_reg(regs, rt, val);
 
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
-- 
2.19.1

