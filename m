Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DABD1BC804
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgD1S2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbgD1S2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E9620BED;
        Tue, 28 Apr 2020 18:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098521;
        bh=g7nDN8bMUX+TVyPmjey7LH7mE1g2N7A8qf3m/woDus8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEtdy/QzkRqQmEOcpUUD780nBEhhIP0gnxxhYeQpShuKslFjNXlEZ3CwWtY9Aiel5
         BTHTsELAph3TQaChQIlKkWgHwsXKDLsCIxBb/iAx1xOpq1cqpnsRFZ+bcCxJcnovk4
         6HxuE2YvZnQOcytY3fHNwyuZx+ibW4T1YWKYFZAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/131] arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1 #1542419
Date:   Tue, 28 Apr 2020 20:23:39 +0200
Message-Id: <20200428182226.169493108@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 05460849c3b51180d5ada3373d0449aea19075e4 ]

Cores affected by Neoverse-N1 #1542419 could execute a stale instruction
when a branch is updated to point to freshly generated instructions.

To workaround this issue we need user-space to issue unnecessary
icache maintenance that we can trap. Start by hiding CTR_EL0.DIC.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Removed cpu_enable_trap_ctr_access() hunk due to no 4afe8e79da92]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 16 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 22 ++++++++++++++++++++++
 arch/arm64/kernel/traps.c              |  3 +++
 5 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index eeb3fc9d777b8..667ea906266ed 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -59,6 +59,7 @@ stable kernels.
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
+| ARM            | Neoverse-N1     | #1542419        | ARM64_ERRATUM_1542419       |
 | ARM            | MMU-500         | #841119,#826419 | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 51fe21f5d0783..1fe3e5cb29278 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -499,6 +499,22 @@ config ARM64_ERRATUM_1463225
 
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
index c3de0bbf0e9a2..df8fe8ecc37e1 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -53,7 +53,8 @@
 #define ARM64_HAS_STAGE2_FWB			32
 #define ARM64_WORKAROUND_1463225		33
 #define ARM64_SSBS				34
+#define ARM64_WORKAROUND_1542419		35
 
-#define ARM64_NCAPS				35
+#define ARM64_NCAPS				36
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 71888808ded72..76490b0cefcee 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -643,6 +643,18 @@ needs_tx2_tvm_workaround(const struct arm64_cpu_capabilities *entry,
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
@@ -834,6 +846,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
 		.matches = needs_tx2_tvm_workaround,
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
index c8dc3a3640e7e..253b7f84a5a0d 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -481,6 +481,9 @@ static void ctr_read_handler(unsigned int esr, struct pt_regs *regs)
 	int rt = (esr & ESR_ELx_SYS64_ISS_RT_MASK) >> ESR_ELx_SYS64_ISS_RT_SHIFT;
 	unsigned long val = arm64_ftr_reg_user_value(&arm64_ftr_reg_ctrel0);
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1542419))
+		val &= ~BIT(CTR_DIC_SHIFT);
+
 	pt_regs_write_reg(regs, rt, val);
 
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
-- 
2.20.1



