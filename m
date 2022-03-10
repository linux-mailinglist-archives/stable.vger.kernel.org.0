Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890FF4D49D4
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242977AbiCJOVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243745AbiCJOSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:18:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F225D1662C0;
        Thu, 10 Mar 2022 06:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92B461C7B;
        Thu, 10 Mar 2022 14:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C43C340E8;
        Thu, 10 Mar 2022 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921677;
        bh=hUAio2j7eMsQbTwI5mHPWJIU4Rc0iNayJZ8io4YTexw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmHb790szhpQjz6cCj95bmkd9D28Bt6vwCZps11GXT1cyRNFm4GQgGyhkxcTv75T9
         rQwhwEqS5c9WhKQWB1rU4puKxXnZugxDR4FCC+EeIPq7yLO4qS/lUy+Ki0PzUspY91
         gZIi8x4AxHpEJrAdCtl6w7JN9sPngLN8DQ2bievI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.9 19/38] ARM: report Spectre v2 status through sysfs
Date:   Thu, 10 Mar 2022 15:13:32 +0100
Message-Id: <20220310140808.699465325@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

commit 9dd78194a3722fa6712192cdd4f7032d45112a9a upstream.

As per other architectures, add support for reporting the Spectre
vulnerability status via sysfs CPU.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[ preserve res variable and add SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/spectre.h |   28 ++++++++
 arch/arm/kernel/Makefile       |    2 
 arch/arm/kernel/spectre.c      |   54 +++++++++++++++++
 arch/arm/mm/Kconfig            |    1 
 arch/arm/mm/proc-v7-bugs.c     |  130 +++++++++++++++++++++++++++++++----------
 5 files changed, 184 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm/include/asm/spectre.h
 create mode 100644 arch/arm/kernel/spectre.c

--- /dev/null
+++ b/arch/arm/include/asm/spectre.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_SPECTRE_H
+#define __ASM_SPECTRE_H
+
+enum {
+	SPECTRE_UNAFFECTED,
+	SPECTRE_MITIGATED,
+	SPECTRE_VULNERABLE,
+};
+
+enum {
+	__SPECTRE_V2_METHOD_BPIALL,
+	__SPECTRE_V2_METHOD_ICIALLU,
+	__SPECTRE_V2_METHOD_SMC,
+	__SPECTRE_V2_METHOD_HVC,
+};
+
+enum {
+	SPECTRE_V2_METHOD_BPIALL = BIT(__SPECTRE_V2_METHOD_BPIALL),
+	SPECTRE_V2_METHOD_ICIALLU = BIT(__SPECTRE_V2_METHOD_ICIALLU),
+	SPECTRE_V2_METHOD_SMC = BIT(__SPECTRE_V2_METHOD_SMC),
+	SPECTRE_V2_METHOD_HVC = BIT(__SPECTRE_V2_METHOD_HVC),
+};
+
+void spectre_v2_update_state(unsigned int state, unsigned int methods);
+
+#endif
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -100,4 +100,6 @@ endif
 
 obj-$(CONFIG_HAVE_ARM_SMCCC)	+= smccc-call.o
 
+obj-$(CONFIG_GENERIC_CPU_VULNERABILITIES) += spectre.o
+
 extra-y := $(head-y) vmlinux.lds
--- /dev/null
+++ b/arch/arm/kernel/spectre.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/cpu.h>
+#include <linux/device.h>
+
+#include <asm/spectre.h>
+
+ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
+}
+
+static unsigned int spectre_v2_state;
+static unsigned int spectre_v2_methods;
+
+void spectre_v2_update_state(unsigned int state, unsigned int method)
+{
+	if (state > spectre_v2_state)
+		spectre_v2_state = state;
+	spectre_v2_methods |= method;
+}
+
+ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	const char *method;
+
+	if (spectre_v2_state == SPECTRE_UNAFFECTED)
+		return sprintf(buf, "%s\n", "Not affected");
+
+	if (spectre_v2_state != SPECTRE_MITIGATED)
+		return sprintf(buf, "%s\n", "Vulnerable");
+
+	switch (spectre_v2_methods) {
+	case SPECTRE_V2_METHOD_BPIALL:
+		method = "Branch predictor hardening";
+		break;
+
+	case SPECTRE_V2_METHOD_ICIALLU:
+		method = "I-cache invalidation";
+		break;
+
+	case SPECTRE_V2_METHOD_SMC:
+	case SPECTRE_V2_METHOD_HVC:
+		method = "Firmware call";
+		break;
+
+	default:
+		method = "Multiple mitigations";
+		break;
+	}
+
+	return sprintf(buf, "Mitigation: %s\n", method);
+}
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -803,6 +803,7 @@ config CPU_BPREDICT_DISABLE
 
 config CPU_SPECTRE
 	bool
+	select GENERIC_CPU_VULNERABILITIES
 
 config HARDEN_BRANCH_PREDICTOR
 	bool "Harden the branch predictor against aliasing attacks" if EXPERT
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -7,8 +7,36 @@
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 #include <asm/proc-fns.h>
+#include <asm/spectre.h>
 #include <asm/system_misc.h>
 
+#ifdef CONFIG_ARM_PSCI
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+static int __maybe_unused spectre_v2_get_cpu_fw_mitigation_state(void)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+
+	switch ((int)res.a0) {
+	case SMCCC_RET_SUCCESS:
+		return SPECTRE_MITIGATED;
+
+	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+		return SPECTRE_UNAFFECTED;
+
+	default:
+		return SPECTRE_VULNERABLE;
+	}
+}
+#else
+static int __maybe_unused spectre_v2_get_cpu_fw_mitigation_state(void)
+{
+	return SPECTRE_VULNERABLE;
+}
+#endif
+
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DEFINE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
 
@@ -37,13 +65,60 @@ static void __maybe_unused call_hvc_arch
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
-static void cpu_v7_spectre_init(void)
+static unsigned int spectre_v2_install_workaround(unsigned int method)
 {
 	const char *spectre_v2_method = NULL;
 	int cpu = smp_processor_id();
 
 	if (per_cpu(harden_branch_predictor_fn, cpu))
-		return;
+		return SPECTRE_MITIGATED;
+
+	switch (method) {
+	case SPECTRE_V2_METHOD_BPIALL:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_bpiall;
+		spectre_v2_method = "BPIALL";
+		break;
+
+	case SPECTRE_V2_METHOD_ICIALLU:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_iciallu;
+		spectre_v2_method = "ICIALLU";
+		break;
+
+	case SPECTRE_V2_METHOD_HVC:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			call_hvc_arch_workaround_1;
+		cpu_do_switch_mm = cpu_v7_hvc_switch_mm;
+		spectre_v2_method = "hypervisor";
+		break;
+
+	case SPECTRE_V2_METHOD_SMC:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			call_smc_arch_workaround_1;
+		cpu_do_switch_mm = cpu_v7_smc_switch_mm;
+		spectre_v2_method = "firmware";
+		break;
+	}
+
+	if (spectre_v2_method)
+		pr_info("CPU%u: Spectre v2: using %s workaround\n",
+			smp_processor_id(), spectre_v2_method);
+
+	return SPECTRE_MITIGATED;
+}
+#else
+static unsigned int spectre_v2_install_workaround(unsigned int method)
+{
+	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n");
+
+	return SPECTRE_VULNERABLE;
+}
+#endif
+
+static void cpu_v7_spectre_v2_init(void)
+{
+	unsigned int state, method = 0;
 
 	switch (read_cpuid_part()) {
 	case ARM_CPU_PART_CORTEX_A8:
@@ -52,29 +127,32 @@ static void cpu_v7_spectre_init(void)
 	case ARM_CPU_PART_CORTEX_A17:
 	case ARM_CPU_PART_CORTEX_A73:
 	case ARM_CPU_PART_CORTEX_A75:
-		per_cpu(harden_branch_predictor_fn, cpu) =
-			harden_branch_predictor_bpiall;
-		spectre_v2_method = "BPIALL";
+		state = SPECTRE_MITIGATED;
+		method = SPECTRE_V2_METHOD_BPIALL;
 		break;
 
 	case ARM_CPU_PART_CORTEX_A15:
 	case ARM_CPU_PART_BRAHMA_B15:
-		per_cpu(harden_branch_predictor_fn, cpu) =
-			harden_branch_predictor_iciallu;
-		spectre_v2_method = "ICIALLU";
+		state = SPECTRE_MITIGATED;
+		method = SPECTRE_V2_METHOD_ICIALLU;
 		break;
 
-#ifdef CONFIG_ARM_PSCI
 	default:
 		/* Other ARM CPUs require no workaround */
-		if (read_cpuid_implementor() == ARM_CPU_IMP_ARM)
+		if (read_cpuid_implementor() == ARM_CPU_IMP_ARM) {
+			state = SPECTRE_UNAFFECTED;
 			break;
+		}
 		/* fallthrough */
-		/* Cortex A57/A72 require firmware workaround */
+	/* Cortex A57/A72 require firmware workaround */
 	case ARM_CPU_PART_CORTEX_A57:
 	case ARM_CPU_PART_CORTEX_A72: {
 		struct arm_smccc_res res;
 
+		state = spectre_v2_get_cpu_fw_mitigation_state();
+		if (state != SPECTRE_MITIGATED)
+			break;
+
 		if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
 			break;
 
@@ -84,10 +162,7 @@ static void cpu_v7_spectre_init(void)
 					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 			if ((int)res.a0 != 0)
 				break;
-			per_cpu(harden_branch_predictor_fn, cpu) =
-				call_hvc_arch_workaround_1;
-			cpu_do_switch_mm = cpu_v7_hvc_switch_mm;
-			spectre_v2_method = "hypervisor";
+			method = SPECTRE_V2_METHOD_HVC;
 			break;
 
 		case PSCI_CONDUIT_SMC:
@@ -95,28 +170,21 @@ static void cpu_v7_spectre_init(void)
 					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 			if ((int)res.a0 != 0)
 				break;
-			per_cpu(harden_branch_predictor_fn, cpu) =
-				call_smc_arch_workaround_1;
-			cpu_do_switch_mm = cpu_v7_smc_switch_mm;
-			spectre_v2_method = "firmware";
+			method = SPECTRE_V2_METHOD_SMC;
 			break;
 
 		default:
+			state = SPECTRE_VULNERABLE;
 			break;
 		}
 	}
-#endif
 	}
 
-	if (spectre_v2_method)
-		pr_info("CPU%u: Spectre v2: using %s workaround\n",
-			smp_processor_id(), spectre_v2_method);
-}
-#else
-static void cpu_v7_spectre_init(void)
-{
+	if (state == SPECTRE_MITIGATED)
+		state = spectre_v2_install_workaround(method);
+
+	spectre_v2_update_state(state, method);
 }
-#endif
 
 static __maybe_unused bool cpu_v7_check_auxcr_set(bool *warned,
 						  u32 mask, const char *msg)
@@ -146,16 +214,16 @@ static bool check_spectre_auxcr(bool *wa
 void cpu_v7_ca8_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(6)))
-		cpu_v7_spectre_init();
+		cpu_v7_spectre_v2_init();
 }
 
 void cpu_v7_ca15_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0)))
-		cpu_v7_spectre_init();
+		cpu_v7_spectre_v2_init();
 }
 
 void cpu_v7_bugs_init(void)
 {
-	cpu_v7_spectre_init();
+	cpu_v7_spectre_v2_init();
 }


