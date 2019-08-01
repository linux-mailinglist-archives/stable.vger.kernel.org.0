Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC657D733
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbfHAIUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:21 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40484 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbfHAIUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:21 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so31807784pla.7
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T4YEDbPBCBlX8lcfFrAFFzcqkBiIDW1BWpR/22wpzUw=;
        b=j+wIxaf24e0CpzIKK/5HFWFDaO9nWV4kFtijIqRGeIL2oUs1CUsdiqkS5A/yCZlznp
         FBWXMrdDWPL9t6x5kGS+637YjSCJIFmH2M72EazCBWjyx8chTwT7jj3ddbDQ8xoytiap
         Xyixz9QuVGvPDPLbaW1FkXwVDuJntjk6ZKja8N9BLyW//7ds0FSvKwUU8GrlQod9JtCd
         V2FPQDGImA2xcsiMbnY+qvK98JbLFurgS2qomwRcBgbnvyeKNObnco6sauHu+jDF9KWs
         ZkVqY0ZwfH9K9Rlt+sWgf2ri0qT3m+PebuXwU8wXimcvBHKDa8+C8rfE0c3IxdVXmjk2
         vADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4YEDbPBCBlX8lcfFrAFFzcqkBiIDW1BWpR/22wpzUw=;
        b=F0zHGwkoRhhAgZMTP/xOQrrOuSr3zJlBnG9oSTZlX6jgRteJUw0iOCvqzcUQmIBTuK
         7MdLQRJat4wtxB38lTCaP/aU7zYzA4xHDhVWJAfvnBtMjIssVLKtPMNFqYJCPN56gnnV
         kAj2ByaMYAwbxaPXNMJ+hBuOFFotkZWsDl+RPXg8SF/i+HSfwZ6cdUUxerumDPIKwvK+
         VG4o4b+6D3QkuvrhrsWT322rx0DdfmFRulePrsaPIoPDNy+6KlH4vptFOCQCmU7N/ATQ
         7g8Wocia54gfQG1QNnnBn8FFzj9zDJqOQxkmJNy01aR0YKlImqYXsWtbUKuNqF866UoA
         j/xw==
X-Gm-Message-State: APjAAAXNxmuI4eD0bj6NhSoHbuKQ6EkZNqUNOsm78qoZTz5xMZWasA01
        PQ7FjooICFdp6wnh0dgpB1XivqwpieI=
X-Google-Smtp-Source: APXvYqyaDMWnJL02FD2X1zz40Bno2tCIMohJgbzKMFoWBZQF5MuGor1DLTLPD9pXq/pUZnEilZYUyQ==
X-Received: by 2002:a17:902:4222:: with SMTP id g31mr50424956pld.41.1564647620067;
        Thu, 01 Aug 2019 01:20:20 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 135sm73497554pfb.137.2019.08.01.01.20.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:19 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 17/47] ARM: spectre-v2: add firmware based hardening
Date:   Thu,  1 Aug 2019 13:46:01 +0530
Message-Id: <b5f0eee5d3e81f75f7c4f71b3126f18884aaa55a.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 10115105cb3aa17b5da1cb726ae8dd5f6854bd93 upstream.

Add firmware based hardening for cores that require more complex
handling in firmware.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/proc-v7-bugs.c | 60 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S      | 21 +++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 85a2e3d6263c..da25a38e1897 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -1,14 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/arm-smccc.h>
 #include <linux/kernel.h>
+#include <linux/psci.h>
 #include <linux/smp.h>
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
+#include <asm/proc-fns.h>
 #include <asm/system_misc.h>
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DEFINE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
 
+extern void cpu_v7_smc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
+extern void cpu_v7_hvc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
+
 static void harden_branch_predictor_bpiall(void)
 {
 	write_sysreg(0, BPIALL);
@@ -19,6 +25,16 @@ static void harden_branch_predictor_iciallu(void)
 	write_sysreg(0, ICIALLU);
 }
 
+static void __maybe_unused call_smc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+
+static void __maybe_unused call_hvc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+
 static void cpu_v7_spectre_init(void)
 {
 	const char *spectre_v2_method = NULL;
@@ -45,7 +61,51 @@ static void cpu_v7_spectre_init(void)
 			harden_branch_predictor_iciallu;
 		spectre_v2_method = "ICIALLU";
 		break;
+
+#ifdef CONFIG_ARM_PSCI
+	default:
+		/* Other ARM CPUs require no workaround */
+		if (read_cpuid_implementor() == ARM_CPU_IMP_ARM)
+			break;
+		/* fallthrough */
+		/* Cortex A57/A72 require firmware workaround */
+	case ARM_CPU_PART_CORTEX_A57:
+	case ARM_CPU_PART_CORTEX_A72: {
+		struct arm_smccc_res res;
+
+		if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
+			break;
+
+		switch (psci_ops.conduit) {
+		case PSCI_CONDUIT_HVC:
+			arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+			if ((int)res.a0 != 0)
+				break;
+			per_cpu(harden_branch_predictor_fn, cpu) =
+				call_hvc_arch_workaround_1;
+			processor.switch_mm = cpu_v7_hvc_switch_mm;
+			spectre_v2_method = "hypervisor";
+			break;
+
+		case PSCI_CONDUIT_SMC:
+			arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+			if ((int)res.a0 != 0)
+				break;
+			per_cpu(harden_branch_predictor_fn, cpu) =
+				call_smc_arch_workaround_1;
+			processor.switch_mm = cpu_v7_smc_switch_mm;
+			spectre_v2_method = "firmware";
+			break;
+
+		default:
+			break;
+		}
 	}
+#endif
+	}
+
 	if (spectre_v2_method)
 		pr_info("CPU%u: Spectre v2: using %s workaround\n",
 			smp_processor_id(), spectre_v2_method);
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index f6a4589b4fd2..b6359ce39fa7 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -9,6 +9,7 @@
  *
  *  This is the "shell" of the ARMv7 processor support.
  */
+#include <linux/arm-smccc.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
@@ -87,6 +88,26 @@ ENTRY(cpu_v7_dcache_clean_area)
 	ret	lr
 ENDPROC(cpu_v7_dcache_clean_area)
 
+#ifdef CONFIG_ARM_PSCI
+	.arch_extension sec
+ENTRY(cpu_v7_smc_switch_mm)
+	stmfd	sp!, {r0 - r3}
+	movw	r0, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
+	movt	r0, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1
+	smc	#0
+	ldmfd	sp!, {r0 - r3}
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_smc_switch_mm)
+	.arch_extension virt
+ENTRY(cpu_v7_hvc_switch_mm)
+	stmfd	sp!, {r0 - r3}
+	movw	r0, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
+	movt	r0, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1
+	hvc	#0
+	ldmfd	sp!, {r0 - r3}
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_smc_switch_mm)
+#endif
 ENTRY(cpu_v7_iciallu_switch_mm)
 	mov	r3, #0
 	mcr	p15, 0, r3, c7, c5, 0		@ ICIALLU
-- 
2.21.0.rc0.269.g1a574e7a288b

