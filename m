Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBADE32ED
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502118AbfJXMtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44010 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502117AbfJXMtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so20707392wrr.10
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=55Rz4bW9KTwMBXnPNhNdX6voNdzTS83htUXPx1vPrj8=;
        b=qe+ROVQIpuik4iAGB0C8PtPFDKZiCAoDMLbzfJi/0hC57zGsyIILvnsWPh6jSG6ova
         dnLudnMyCPoSB/zGya1+EcygzHicte5rltPcuXJ1gIcngOGN0qMdqB4bitrJITUtbhO+
         HKIxr+XwFdezK6OS88qMpNCOor50F1NaQqiYTw/+K+lDMdXUSCx8xr6K20lIrPZAlrkt
         yXHca6mF+0QwX1f40tOnEaOrJuYIPS8yyozlWRvK43XDtJnzHBG45NdzLfnI/LiBg1wi
         brOy8X+fecU8ryL4OSrmOI3qGof8VH5ZPc8S+ujrPgF0TesvKeKOfgzERi2jYALYqfuz
         MJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=55Rz4bW9KTwMBXnPNhNdX6voNdzTS83htUXPx1vPrj8=;
        b=X+AnLh4XGFTNmXEfjGcUCmfZlWH6dC1b/WtlLXqoE+3J/yrxMv8z+gkxo9V2r5RUmd
         XOToMekmezSFAqm+ur1F28dUdYx72lFQIAeKB3sdMplEcpePc/4Djibez9BBS3yj5aZ4
         D9npxFwupSdytqOpSa0gZj94BHLlp5YU/X+JLYPOPm3omFdIWlWWInqw5FThLJwj5AT2
         6R2ATxqvwJgouJALqlgW3jNdCwpHiogPmm4E7VUq1+3sWUi6C3tbIM6MhX3rBqWsmyPV
         QOdxtj9Ttn9wdhkr8d4pr3zZ+tf22pu0g3frC9ba6t0qbTWgjYi3l/sEc/AJAUYV+D2Z
         kkwQ==
X-Gm-Message-State: APjAAAVK1wwX4fEm5AUioxdqEP2TXM3RIW0PGjqPo84WUnd+VA508pc4
        0WqV+x9FZiduaO/xLsJNwPBxneZSJyG9Rswy
X-Google-Smtp-Source: APXvYqx1KK+rscqSYCUQsLkkn6sKJ5O5af5clPkLzgavs4ZshkeGrJEAVDmOkc/3OYCcGY5eI9CpFg==
X-Received: by 2002:adf:f90d:: with SMTP id b13mr3616669wrr.316.1571921381087;
        Thu, 24 Oct 2019 05:49:41 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:40 -0700 (PDT)
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
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 33/48] arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3
Date:   Thu, 24 Oct 2019 14:48:18 +0200
Message-Id: <20191024124833.4158-34-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit 8f04e8e6e29c93421a95b61cad62e3918425eac7 ]

On CPUs with support for PSTATE.SSBS, the kernel can toggle the SSBD
state without needing to call into firmware.

This patch hooks into the existing SSBD infrastructure so that SSBS is
used on CPUs that support it, but it's all made horribly complicated by
the very real possibility of big/little systems that don't uniformly
provide the new capability.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ardb: add #include of asm/compat.h]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/processor.h   |  7 +++
 arch/arm64/include/asm/ptrace.h      |  1 +
 arch/arm64/include/asm/sysreg.h      |  3 ++
 arch/arm64/include/uapi/asm/ptrace.h |  1 +
 arch/arm64/kernel/cpu_errata.c       | 26 ++++++++++-
 arch/arm64/kernel/cpufeature.c       | 45 ++++++++++++++++++++
 arch/arm64/kernel/process.c          |  4 ++
 arch/arm64/kernel/ssbd.c             | 22 ++++++++++
 8 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 9b6ac522a71a..ec1725c6df21 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -153,6 +153,10 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 {
 	start_thread_common(regs, pc);
 	regs->pstate = PSR_MODE_EL0t;
+
+	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
+		regs->pstate |= PSR_SSBS_BIT;
+
 	regs->sp = sp;
 }
 
@@ -169,6 +173,9 @@ static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->pstate |= COMPAT_PSR_E_BIT;
 #endif
 
+	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
+		regs->pstate |= PSR_AA32_SSBS_BIT;
+
 	regs->compat_sp = sp;
 }
 #endif
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 1b2a253de6a1..b466d763a90d 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -50,6 +50,7 @@
 #define PSR_AA32_I_BIT		0x00000080
 #define PSR_AA32_A_BIT		0x00000100
 #define PSR_AA32_E_BIT		0x00000200
+#define PSR_AA32_SSBS_BIT	0x00800000
 #define PSR_AA32_DIT_BIT	0x01000000
 #define PSR_AA32_Q_BIT		0x08000000
 #define PSR_AA32_V_BIT		0x10000000
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4724909642e7..50a89bcf9072 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -86,11 +86,14 @@
 
 #define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
 #define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
+#define REG_PSTATE_SSBS_IMM		sys_reg(0, 3, 4, 0, 1)
 
 #define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |	\
 				      (!!x)<<8 | 0x1f)
 #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
 				      (!!x)<<8 | 0x1f)
+#define SET_PSTATE_SSBS(x) __emit_inst(0xd5000000 | REG_PSTATE_SSBS_IMM | \
+				       (!!x)<<8 | 0x1f)
 
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
 #define SYS_DC_CSW			sys_insn(1, 0, 7, 10, 2)
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 67d4c33974e8..eea58f8ec355 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -45,6 +45,7 @@
 #define PSR_I_BIT	0x00000080
 #define PSR_A_BIT	0x00000100
 #define PSR_D_BIT	0x00000200
+#define PSR_SSBS_BIT	0x00001000
 #define PSR_PAN_BIT	0x00400000
 #define PSR_UAO_BIT	0x00800000
 #define PSR_Q_BIT	0x08000000
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 6e565d8d4f71..105741487a86 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -304,6 +304,14 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 
 void arm64_set_ssbd_mitigation(bool state)
 {
+	if (this_cpu_has_cap(ARM64_SSBS)) {
+		if (state)
+			asm volatile(SET_PSTATE_SSBS(0));
+		else
+			asm volatile(SET_PSTATE_SSBS(1));
+		return;
+	}
+
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
 		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
@@ -328,6 +336,11 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
+	if (this_cpu_has_cap(ARM64_SSBS)) {
+		required = false;
+		goto out_printmsg;
+	}
+
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0) {
 		ssbd_state = ARM64_SSBD_UNKNOWN;
 		return false;
@@ -376,7 +389,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	switch (ssbd_state) {
 	case ARM64_SSBD_FORCE_DISABLE:
-		pr_info_once("%s disabled from command-line\n", entry->desc);
 		arm64_set_ssbd_mitigation(false);
 		required = false;
 		break;
@@ -389,7 +401,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 		break;
 
 	case ARM64_SSBD_FORCE_ENABLE:
-		pr_info_once("%s forced from command-line\n", entry->desc);
 		arm64_set_ssbd_mitigation(true);
 		required = true;
 		break;
@@ -399,6 +410,17 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 		break;
 	}
 
+out_printmsg:
+	switch (ssbd_state) {
+	case ARM64_SSBD_FORCE_DISABLE:
+		pr_info_once("%s disabled from command-line\n", entry->desc);
+		break;
+
+	case ARM64_SSBD_FORCE_ENABLE:
+		pr_info_once("%s forced from command-line\n", entry->desc);
+		break;
+	}
+
 	return required;
 }
 #endif	/* CONFIG_ARM64_SSBD */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2a0d76698f34..d8e89b5d99ee 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -925,6 +925,48 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
 }
 
+#ifdef CONFIG_ARM64_SSBD
+static int ssbs_emulation_handler(struct pt_regs *regs, u32 instr)
+{
+	if (user_mode(regs))
+		return 1;
+
+	if (instr & BIT(CRm_shift))
+		regs->pstate |= PSR_SSBS_BIT;
+	else
+		regs->pstate &= ~PSR_SSBS_BIT;
+
+	arm64_skip_faulting_instruction(regs, 4);
+	return 0;
+}
+
+static struct undef_hook ssbs_emulation_hook = {
+	.instr_mask	= ~(1U << CRm_shift),
+	.instr_val	= 0xd500001f | REG_PSTATE_SSBS_IMM,
+	.fn		= ssbs_emulation_handler,
+};
+
+static void cpu_enable_ssbs(const struct arm64_cpu_capabilities *__unused)
+{
+	static bool undef_hook_registered = false;
+	static DEFINE_SPINLOCK(hook_lock);
+
+	spin_lock(&hook_lock);
+	if (!undef_hook_registered) {
+		register_undef_hook(&ssbs_emulation_hook);
+		undef_hook_registered = true;
+	}
+	spin_unlock(&hook_lock);
+
+	if (arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE) {
+		sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_DSSBS);
+		arm64_set_ssbd_mitigation(false);
+	} else {
+		arm64_set_ssbd_mitigation(true);
+	}
+}
+#endif /* CONFIG_ARM64_SSBD */
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -1049,6 +1091,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 1,
 	},
 #endif
+#ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypassing Safe (SSBS)",
 		.capability = ARM64_SSBS,
@@ -1058,7 +1101,9 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR1_SSBS_SHIFT,
 		.sign = FTR_UNSIGNED,
 		.min_field_value = ID_AA64PFR1_SSBS_PSTATE_ONLY,
+		.cpu_enable = cpu_enable_ssbs,
 	},
+#endif
 	{},
 };
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 9e773732520c..532ad6be9c2b 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -296,6 +296,10 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 		if (IS_ENABLED(CONFIG_ARM64_UAO) &&
 		    cpus_have_const_cap(ARM64_HAS_UAO))
 			childregs->pstate |= PSR_UAO_BIT;
+
+		if (arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE)
+			childregs->pstate |= PSR_SSBS_BIT;
+
 		p->thread.cpu_context.x19 = stack_start;
 		p->thread.cpu_context.x20 = stk_sz;
 	}
diff --git a/arch/arm64/kernel/ssbd.c b/arch/arm64/kernel/ssbd.c
index 0560738c1d5c..58de005cd756 100644
--- a/arch/arm64/kernel/ssbd.c
+++ b/arch/arm64/kernel/ssbd.c
@@ -3,13 +3,32 @@
  * Copyright (C) 2018 ARM Ltd, All Rights Reserved.
  */
 
+#include <linux/compat.h>
 #include <linux/errno.h>
 #include <linux/prctl.h>
 #include <linux/sched.h>
+#include <linux/sched/task_stack.h>
 #include <linux/thread_info.h>
 
+#include <asm/compat.h>
 #include <asm/cpufeature.h>
 
+static void ssbd_ssbs_enable(struct task_struct *task)
+{
+	u64 val = is_compat_thread(task_thread_info(task)) ?
+		  PSR_AA32_SSBS_BIT : PSR_SSBS_BIT;
+
+	task_pt_regs(task)->pstate |= val;
+}
+
+static void ssbd_ssbs_disable(struct task_struct *task)
+{
+	u64 val = is_compat_thread(task_thread_info(task)) ?
+		  PSR_AA32_SSBS_BIT : PSR_SSBS_BIT;
+
+	task_pt_regs(task)->pstate &= ~val;
+}
+
 /*
  * prctl interface for SSBD
  */
@@ -45,12 +64,14 @@ static int ssbd_prctl_set(struct task_struct *task, unsigned long ctrl)
 			return -EPERM;
 		task_clear_spec_ssb_disable(task);
 		clear_tsk_thread_flag(task, TIF_SSBD);
+		ssbd_ssbs_enable(task);
 		break;
 	case PR_SPEC_DISABLE:
 		if (state == ARM64_SSBD_FORCE_DISABLE)
 			return -EPERM;
 		task_set_spec_ssb_disable(task);
 		set_tsk_thread_flag(task, TIF_SSBD);
+		ssbd_ssbs_disable(task);
 		break;
 	case PR_SPEC_FORCE_DISABLE:
 		if (state == ARM64_SSBD_FORCE_DISABLE)
@@ -58,6 +79,7 @@ static int ssbd_prctl_set(struct task_struct *task, unsigned long ctrl)
 		task_set_spec_ssb_disable(task);
 		task_set_spec_ssb_force_disable(task);
 		set_tsk_thread_flag(task, TIF_SSBD);
+		ssbd_ssbs_disable(task);
 		break;
 	default:
 		return -ERANGE;
-- 
2.20.1

