Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07E3CFDD1
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfJHPkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36550 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHPkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so3632917wmc.1
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vlkvgAe6OU2SyP/lheTB8VxvmIpD5b5cXJef0MiMX6o=;
        b=zpvFE5a2NFSDbMYsqOpKPMN35GbqVUTCAraS8sL5Uq/qf0d0Qt4mupK+Hy8Yrh1qAK
         +V+9nWWbSsGn2fFn5rizGP86Uryprd1JO0lrwYTW/M3/V4uUx5NkjSqxJLXzp6y9PpdR
         m/2G5hNtKlmR52nJ4fu80wISO15saJ4Zf9GrYhgXvZJ3Fhnbwjzzj3fgEUn7+QC2RJrE
         bFsM9QFX6qVqOduiL1fphIisJEgmB02S74Z3GtEdSBO3UFoAcIeEy2gAYNHG3+lT5UZf
         WMI6hEZkYeFscgMPCjOsE02XtWT7CEgyHvXwfOPGlvBwElDQF6zWXXpYtBOf5sjsSt3x
         Ceug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vlkvgAe6OU2SyP/lheTB8VxvmIpD5b5cXJef0MiMX6o=;
        b=YwcJKgAbSBaauWw5D+LjdGNiWzw+Q7iEPeX09IJAUIsVQT1ofc0tkOawFWECVDrClR
         vuu5ih5OSn+wzWn5wT/4TUhkwnDjbPH0ylbVoRwW8N2aYan9kArQUWcUc/7B/VFw2wmq
         vHK9PuhQ19e6+pZxh8dxSSIy9fbMFPvDdjFNv4HTBceb5vrVDveX7JcYmMelzboEarDA
         W0Mw85Q0/xvlLUjKiv9bcDw+lPxZ1p0ybtSziwfdcnq8j47gCYe6NqH0LaGCu/TaIimJ
         LYiNsqYY4NpfOUjucwW1z0l99AopFV0FLlFYFHLDfDZ2mQWKJixH7FJrrI4x40E0mP0O
         ypvQ==
X-Gm-Message-State: APjAAAX6CL4AFL/HgPz92+LABQnTnp6JcT9xi8NRWIj3S5nEEcjKzbA/
        G+PivNmgTjK5FhnXaPHFRso0Tw==
X-Google-Smtp-Source: APXvYqyIoYw3dXgCYkz1oYvIgDKmr3yn197OFUAZ4mMzUH1q8m3V/O2x+PVHgPpnYc6oF7fdlMnDEA==
X-Received: by 2002:a1c:7902:: with SMTP id l2mr4278694wme.55.1570549210703;
        Tue, 08 Oct 2019 08:40:10 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 02/16] arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3
Date:   Tue,  8 Oct 2019 17:39:16 +0200
Message-Id: <20191008153930.15386-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
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
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/processor.h   |  7 +++
 arch/arm64/include/asm/ptrace.h      |  1 +
 arch/arm64/include/asm/sysreg.h      |  3 ++
 arch/arm64/include/uapi/asm/ptrace.h |  1 +
 arch/arm64/kernel/cpu_errata.c       | 26 ++++++++++-
 arch/arm64/kernel/cpufeature.c       | 45 ++++++++++++++++++++
 arch/arm64/kernel/process.c          |  4 ++
 arch/arm64/kernel/ssbd.c             | 21 +++++++++
 8 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index def5a5e807f0..ad208bd402f7 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -182,6 +182,10 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 {
 	start_thread_common(regs, pc);
 	regs->pstate = PSR_MODE_EL0t;
+
+	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
+		regs->pstate |= PSR_SSBS_BIT;
+
 	regs->sp = sp;
 }
 
@@ -198,6 +202,9 @@ static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->pstate |= PSR_AA32_E_BIT;
 #endif
 
+	if (arm64_get_ssbd_state() != ARM64_SSBD_FORCE_ENABLE)
+		regs->pstate |= PSR_AA32_SSBS_BIT;
+
 	regs->compat_sp = sp;
 }
 #endif
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 177b851ca6d9..6bc43889d11e 100644
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
index 2fc6242baf11..3091ae5975a3 100644
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
index 5dff8eccd17d..b0fd1d300154 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -46,6 +46,7 @@
 #define PSR_I_BIT	0x00000080
 #define PSR_A_BIT	0x00000100
 #define PSR_D_BIT	0x00000200
+#define PSR_SSBS_BIT	0x00001000
 #define PSR_PAN_BIT	0x00400000
 #define PSR_UAO_BIT	0x00800000
 #define PSR_V_BIT	0x10000000
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index dc6c535cbd13..7fe3a60d1086 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -312,6 +312,14 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 
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
@@ -336,6 +344,11 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
+	if (this_cpu_has_cap(ARM64_SSBS)) {
+		required = false;
+		goto out_printmsg;
+	}
+
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0) {
 		ssbd_state = ARM64_SSBD_UNKNOWN;
 		return false;
@@ -384,7 +397,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	switch (ssbd_state) {
 	case ARM64_SSBD_FORCE_DISABLE:
-		pr_info_once("%s disabled from command-line\n", entry->desc);
 		arm64_set_ssbd_mitigation(false);
 		required = false;
 		break;
@@ -397,7 +409,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 		break;
 
 	case ARM64_SSBD_FORCE_ENABLE:
-		pr_info_once("%s forced from command-line\n", entry->desc);
 		arm64_set_ssbd_mitigation(true);
 		required = true;
 		break;
@@ -407,6 +418,17 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
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
index d7552bbdf963..9c756a1657aa 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1071,6 +1071,48 @@ static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
 	WARN_ON(val & (7 << 27 | 7 << 21));
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
@@ -1258,6 +1300,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_hw_dbm,
 	},
 #endif
+#ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypassing Safe (SSBS)",
 		.capability = ARM64_SSBS,
@@ -1267,7 +1310,9 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR1_SSBS_SHIFT,
 		.sign = FTR_UNSIGNED,
 		.min_field_value = ID_AA64PFR1_SSBS_PSTATE_ONLY,
+		.cpu_enable = cpu_enable_ssbs,
 	},
+#endif
 	{},
 };
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 7f1628effe6d..ce99c58cd1f1 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -358,6 +358,10 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
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
index 388f8fc13080..f496fb2f7122 100644
--- a/arch/arm64/kernel/ssbd.c
+++ b/arch/arm64/kernel/ssbd.c
@@ -3,13 +3,31 @@
  * Copyright (C) 2018 ARM Ltd, All Rights Reserved.
  */
 
+#include <linux/compat.h>
 #include <linux/errno.h>
 #include <linux/prctl.h>
 #include <linux/sched.h>
+#include <linux/sched/task_stack.h>
 #include <linux/thread_info.h>
 
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
  * FIXME: Drop the below ifdefery once merged in 4.18.
@@ -47,12 +65,14 @@ static int ssbd_prctl_set(struct task_struct *task, unsigned long ctrl)
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
@@ -60,6 +80,7 @@ static int ssbd_prctl_set(struct task_struct *task, unsigned long ctrl)
 		task_set_spec_ssb_disable(task);
 		task_set_spec_ssb_force_disable(task);
 		set_tsk_thread_flag(task, TIF_SSBD);
+		ssbd_ssbs_disable(task);
 		break;
 	default:
 		return -ERANGE;
-- 
2.20.1

