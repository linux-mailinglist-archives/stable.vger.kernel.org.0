Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7120BE6926
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfJ0VJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbfJ0VJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:23 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF2020873;
        Sun, 27 Oct 2019 21:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210562;
        bh=LRNt8C59paF+yY2qKZcmuJ31RDbGPdeElTfRwd2X1Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6OrxnBw32Io7mQc6dB6oKc5u7j3L69cgAc+Ez5NF1lTYU/+Jsv4bTfh6uxoVjD2s
         d2rURpMX6dbVzHReT2wmVzDMRizfxLmMH9bjCmrJrZ70GwZ/43zl+i+vpsdLhWANkj
         IU06zKxBc8NQZp3z21V+PeBpOCN55MNm81zEQZNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Thierry <julien.thierry@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 059/119] arm64: capabilities: Add support for features enabled early
Date:   Sun, 27 Oct 2019 22:00:36 +0100
Message-Id: <20191027203326.041958544@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit fd9d63da17daf09c0099e3d5e3f0c0f03d9b251b ]

The kernel detects and uses some of the features based on the boot
CPU and expects that all the following CPUs conform to it. e.g,
with VHE and the boot CPU running at EL2, the kernel decides to
keep the kernel running at EL2. If another CPU is brought up without
this capability, we use custom hooks (via check_early_cpu_features())
to handle it. To handle such capabilities add support for detecting
and enabling capabilities based on the boot CPU.

A bit is added to indicate if the capability should be detected
early on the boot CPU. The infrastructure then ensures that such
capabilities are probed and "enabled" early on in the boot CPU
and, enabled on the subsequent CPUs.

Cc: Julien Thierry <julien.thierry@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |   48 ++++++++++++++++++++++++------
 arch/arm64/kernel/cpufeature.c      |   57 +++++++++++++++++++++++++++---------
 2 files changed, 83 insertions(+), 22 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -104,7 +104,7 @@ extern struct arm64_ftr_reg arm64_ftr_re
  *    value of a field in CPU ID feature register or checking the cpu
  *    model. The capability provides a call back ( @matches() ) to
  *    perform the check. Scope defines how the checks should be performed.
- *    There are two cases:
+ *    There are three cases:
  *
  *     a) SCOPE_LOCAL_CPU: check all the CPUs and "detect" if at least one
  *        matches. This implies, we have to run the check on all the
@@ -117,6 +117,11 @@ extern struct arm64_ftr_reg arm64_ftr_re
  *        capability relies on a field in one of the CPU ID feature
  *        registers, we use the sanitised value of the register from the
  *        CPU feature infrastructure to make the decision.
+ *		Or
+ *     c) SCOPE_BOOT_CPU: Check only on the primary boot CPU to detect the
+ *        feature. This category is for features that are "finalised"
+ *        (or used) by the kernel very early even before the SMP cpus
+ *        are brought up.
  *
  *    The process of detection is usually denoted by "update" capability
  *    state in the code.
@@ -136,6 +141,11 @@ extern struct arm64_ftr_reg arm64_ftr_re
  *    CPUs are treated "late CPUs" for capabilities determined by the boot
  *    CPU.
  *
+ *    At the moment there are two passes of finalising the capabilities.
+ *      a) Boot CPU scope capabilities - Finalised by primary boot CPU via
+ *         setup_boot_cpu_capabilities().
+ *      b) Everything except (a) - Run via setup_system_capabilities().
+ *
  * 3) Verification: When a CPU is brought online (e.g, by user or by the
  *    kernel), the kernel should make sure that it is safe to use the CPU,
  *    by verifying that the CPU is compliant with the state of the
@@ -144,12 +154,21 @@ extern struct arm64_ftr_reg arm64_ftr_re
  *	secondary_start_kernel()-> check_local_cpu_capabilities()
  *
  *    As explained in (2) above, capabilities could be finalised at
- *    different points in the execution. Each CPU is verified against the
- *    "finalised" capabilities and if there is a conflict, the kernel takes
- *    an action, based on the severity (e.g, a CPU could be prevented from
- *    booting or cause a kernel panic). The CPU is allowed to "affect" the
- *    state of the capability, if it has not been finalised already.
- *    See section 5 for more details on conflicts.
+ *    different points in the execution. Each newly booted CPU is verified
+ *    against the capabilities that have been finalised by the time it
+ *    boots.
+ *
+ *	a) SCOPE_BOOT_CPU : All CPUs are verified against the capability
+ *	except for the primary boot CPU.
+ *
+ *	b) SCOPE_LOCAL_CPU, SCOPE_SYSTEM: All CPUs hotplugged on by the
+ *	user after the kernel boot are verified against the capability.
+ *
+ *    If there is a conflict, the kernel takes an action, based on the
+ *    severity (e.g, a CPU could be prevented from booting or cause a
+ *    kernel panic). The CPU is allowed to "affect" the state of the
+ *    capability, if it has not been finalised already. See section 5
+ *    for more details on conflicts.
  *
  * 4) Action: As mentioned in (2), the kernel can take an action for each
  *    detected capability, on all CPUs on the system. Appropriate actions
@@ -198,15 +217,26 @@ extern struct arm64_ftr_reg arm64_ftr_re
  */
 
 
-/* Decide how the capability is detected. On a local CPU vs System wide */
+/*
+ * Decide how the capability is detected.
+ * On any local CPU vs System wide vs the primary boot CPU
+ */
 #define ARM64_CPUCAP_SCOPE_LOCAL_CPU		((u16)BIT(0))
 #define ARM64_CPUCAP_SCOPE_SYSTEM		((u16)BIT(1))
+/*
+ * The capabilitiy is detected on the Boot CPU and is used by kernel
+ * during early boot. i.e, the capability should be "detected" and
+ * "enabled" as early as possibly on all booting CPUs.
+ */
+#define ARM64_CPUCAP_SCOPE_BOOT_CPU		((u16)BIT(2))
 #define ARM64_CPUCAP_SCOPE_MASK			\
 	(ARM64_CPUCAP_SCOPE_SYSTEM	|	\
-	 ARM64_CPUCAP_SCOPE_LOCAL_CPU)
+	 ARM64_CPUCAP_SCOPE_LOCAL_CPU	|	\
+	 ARM64_CPUCAP_SCOPE_BOOT_CPU)
 
 #define SCOPE_SYSTEM				ARM64_CPUCAP_SCOPE_SYSTEM
 #define SCOPE_LOCAL_CPU				ARM64_CPUCAP_SCOPE_LOCAL_CPU
+#define SCOPE_BOOT_CPU				ARM64_CPUCAP_SCOPE_BOOT_CPU
 #define SCOPE_ALL				ARM64_CPUCAP_SCOPE_MASK
 
 /*
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,7 +485,7 @@ static void __init init_cpu_ftr_reg(u32
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
-static void update_cpu_capabilities(u16 scope_mask);
+static void __init setup_boot_cpu_capabilities(void);
 
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
@@ -525,10 +525,10 @@ void __init init_cpu_features(struct cpu
 	}
 
 	/*
-	 * Run the errata work around and local feature checks on the
-	 * boot CPU, once we have initialised the cpu feature infrastructure.
+	 * Detect and enable early CPU capabilities based on the boot CPU,
+	 * after we have initialised the CPU feature infrastructure.
 	 */
-	update_cpu_capabilities(SCOPE_LOCAL_CPU);
+	setup_boot_cpu_capabilities();
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1219,13 +1219,24 @@ __enable_cpu_capabilities(const struct a
 
 		if (caps->cpu_enable) {
 			/*
-			 * Use stop_machine() as it schedules the work allowing
-			 * us to modify PSTATE, instead of on_each_cpu() which
-			 * uses an IPI, giving us a PSTATE that disappears when
-			 * we return.
+			 * Capabilities with SCOPE_BOOT_CPU scope are finalised
+			 * before any secondary CPU boots. Thus, each secondary
+			 * will enable the capability as appropriate via
+			 * check_local_cpu_capabilities(). The only exception is
+			 * the boot CPU, for which the capability must be
+			 * enabled here. This approach avoids costly
+			 * stop_machine() calls for this case.
+			 *
+			 * Otherwise, use stop_machine() as it schedules the
+			 * work allowing us to modify PSTATE, instead of
+			 * on_each_cpu() which uses an IPI, giving us a PSTATE
+			 * that disappears when we return.
 			 */
-			stop_machine(__enable_cpu_capability, (void *)caps,
-				     cpu_online_mask);
+			if (scope_mask & SCOPE_BOOT_CPU)
+				caps->cpu_enable(caps);
+			else
+				stop_machine(__enable_cpu_capability,
+					     (void *)caps, cpu_online_mask);
 		}
 	}
 }
@@ -1323,6 +1334,12 @@ static void check_early_cpu_features(voi
 {
 	verify_cpu_run_el();
 	verify_cpu_asid_bits();
+	/*
+	 * Early features are used by the kernel already. If there
+	 * is a conflict, we cannot proceed further.
+	 */
+	if (!verify_local_cpu_caps(SCOPE_BOOT_CPU))
+		cpu_panic_kernel();
 }
 
 static void
@@ -1348,7 +1365,12 @@ verify_local_elf_hwcaps(const struct arm
  */
 static void verify_local_cpu_capabilities(void)
 {
-	if (!verify_local_cpu_caps(SCOPE_ALL))
+	/*
+	 * The capabilities with SCOPE_BOOT_CPU are checked from
+	 * check_early_cpu_features(), as they need to be verified
+	 * on all secondary CPUs.
+	 */
+	if (!verify_local_cpu_caps(SCOPE_ALL & ~SCOPE_BOOT_CPU))
 		cpu_die_early();
 
 	verify_local_elf_hwcaps(arm64_elf_hwcaps);
@@ -1376,6 +1398,14 @@ void check_local_cpu_capabilities(void)
 		verify_local_cpu_capabilities();
 }
 
+static void __init setup_boot_cpu_capabilities(void)
+{
+	/* Detect capabilities with either SCOPE_BOOT_CPU or SCOPE_LOCAL_CPU */
+	update_cpu_capabilities(SCOPE_BOOT_CPU | SCOPE_LOCAL_CPU);
+	/* Enable the SCOPE_BOOT_CPU capabilities alone right away */
+	enable_cpu_capabilities(SCOPE_BOOT_CPU);
+}
+
 DEFINE_STATIC_KEY_FALSE(arm64_const_caps_ready);
 EXPORT_SYMBOL(arm64_const_caps_ready);
 
@@ -1397,10 +1427,11 @@ static void __init setup_system_capabili
 	/*
 	 * We have finalised the system-wide safe feature
 	 * registers, finalise the capabilities that depend
-	 * on it. Also enable all the available capabilities.
+	 * on it. Also enable all the available capabilities,
+	 * that are not enabled already.
 	 */
 	update_cpu_capabilities(SCOPE_SYSTEM);
-	enable_cpu_capabilities(SCOPE_ALL);
+	enable_cpu_capabilities(SCOPE_ALL & ~SCOPE_BOOT_CPU);
 }
 
 void __init setup_cpu_features(void)


