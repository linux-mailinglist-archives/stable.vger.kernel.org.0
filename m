Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C589AE32E1
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502108AbfJXMt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42586 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502107AbfJXMt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so16140804wrs.9
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Y6K0uTSXeLZVYAmbsn0/kpRELQPdThK3nwQp0KvBbI=;
        b=KQkMGGc/ALsiF2L3dwABK/EKAyH2buNembqkAegpQVf41CbaP7SVsdl6xIk+LiGdV0
         R+tPte/TcBIrTHPp+q6wMwGE/KihAkX4Anx6Er4ib/iVmrP8vg4Ab9qljemHPn1WV9Be
         bHJGJRUy5CMJOUXsNEGBVWxClIR5mGf11yjVlapZr3GH0YjGOiftkWY1mOwDYFZecCzZ
         LKRIEBdOeQaFKXibLO2oOkWEc5gvGx7FmBDqz0QFYxUCYxS2/IBBr9e3GgVHnADdxGIu
         Uq8zpXp/1vvz2nF8LdCvEXpO+VNcXsoOWveff/xoGHB92/HfpNm6mQL4s2nQThDuSTX3
         MLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Y6K0uTSXeLZVYAmbsn0/kpRELQPdThK3nwQp0KvBbI=;
        b=MR1+hlM3WdeqpY6w4SngHAkeikb9wz3Vtupht4nLVHKbkzSKrKqTI3BF03XeZzrlBo
         VqSp9kHEEnbKzNYmml7JUEPNx4JgaqZWm+j6QcSG/CxmF+D8JiLaSBBZmYwBeVMcq/0Z
         NQAqiaBOJJtwT4LUOICZAwzA9c7nyQT2keyeac9snL5sO8KnUcq/uAbg0pgBpT0FAoJn
         oUKWM+uj9RnBeoCE5fe2GwuwR+RfDuAvUVLXFdgZRDa/Yjc8wUmqQfyC8/vsqaJquTAY
         tGasY+JIVJoaMjYPrMD1GlPgyXdBIqwgnf7qGenp0dT1a66LqlbDIBGRcDftiBwrysJi
         mdNw==
X-Gm-Message-State: APjAAAWCV83JU0NtLsKwRDWiyQ/6ScOFiB/7l3vTfoRq+S5y6BbEXQYo
        77g+RXL93htvS1bNo6g5G3P4a2Rl3dJx+mc4
X-Google-Smtp-Source: APXvYqydqMhFbBdQHmfLwSAoLTJqbJEJyb9s5370kczY2HWYOMVJO60LcluM4mieK7WRqR2hTGh0ng==
X-Received: by 2002:a5d:66c6:: with SMTP id k6mr3703062wrw.152.1571921364921;
        Thu, 24 Oct 2019 05:49:24 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:23 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 23/48] arm64: capabilities: Add support for features enabled early
Date:   Thu, 24 Oct 2019 14:48:08 +0200
Message-Id: <20191024124833.4158-24-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
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
---
 arch/arm64/include/asm/cpufeature.h | 48 +++++++++++++----
 arch/arm64/kernel/cpufeature.c      | 57 +++++++++++++++-----
 2 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 96c99b201b2f..793e5fd4c583 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -104,7 +104,7 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
  *    value of a field in CPU ID feature register or checking the cpu
  *    model. The capability provides a call back ( @matches() ) to
  *    perform the check. Scope defines how the checks should be performed.
- *    There are two cases:
+ *    There are three cases:
  *
  *     a) SCOPE_LOCAL_CPU: check all the CPUs and "detect" if at least one
  *        matches. This implies, we have to run the check on all the
@@ -117,6 +117,11 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
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
@@ -136,6 +141,11 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
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
@@ -144,12 +154,21 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
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
@@ -198,15 +217,26 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
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
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b3ebbc56bebb..1a1eb3b85e82 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,7 +485,7 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
-static void update_cpu_capabilities(u16 scope_mask);
+static void __init setup_boot_cpu_capabilities(void);
 
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
@@ -525,10 +525,10 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
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
@@ -1219,13 +1219,24 @@ __enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 
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
@@ -1323,6 +1334,12 @@ static void check_early_cpu_features(void)
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
@@ -1348,7 +1365,12 @@ verify_local_elf_hwcaps(const struct arm64_cpu_capabilities *caps)
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
 
@@ -1397,10 +1427,11 @@ static void __init setup_system_capabilities(void)
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
-- 
2.20.1

