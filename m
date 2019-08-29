Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72DA18D3
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfH2LgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:01 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38164 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfH2LgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id w11so1461095plp.5
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aq5CYdRuS/UmoYlN6mc3HUm+gg736Vr1UQoLJ4CFDoo=;
        b=k1jHCHwY558FN3yrbhnj0Tq/hOw435oDiAXesI4EbyOV7kGUPx1gboqunqzhuOkGjF
         XDVOkhx6pWWk9B8Kz2KS1fFlp0KRkEJuvjL952tgAyedroArxoWRuWQJ0yg3qRDBG8Sr
         sZ63GdKEaOlVYk1JFfJuKfgvbWTmsp5s7QW+ktWRA1RWfUXy3AVP+3kf4Vt2ZF/IIcle
         dvyAJdX/17/n9irsvCfyWnn1moQrgL32iAOg3vUP4kpiS5gFeq1bCVvt0PPYWki4eDXs
         W90uEfuDLJ0dZ04vkLPmdGNyXzZS1EwU87XQyygwJqS/kXA4vHnt8jf6B7AMxKfd6THF
         V4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aq5CYdRuS/UmoYlN6mc3HUm+gg736Vr1UQoLJ4CFDoo=;
        b=BZnERHYYUkdgbI8AaQeB5IIjQbbNb2hIZfameYsDwZfOYUiQNIznLSwp2RFg/lPvU6
         HCxu3NXZhnLGrhyAGr/hINfXPe7duYC5z6xsXH9tTmTnDbA0UHVKwOK0qz4Na81H7wYM
         dPw7UJehxCDLpRD6PHGBZylw1iQesI6qHPIbdzCxgK0etEgBXAeuGtPMlWPlM9/GD/ei
         4wWSu1/JcBCrhyLELGMCYRYt3yZtdhEv+WZ/nDJFQv72KCnMy7d7g7R5Vmr1HTQIvq9m
         EHTvFwdefn0fWUyNH768UtLO1OaiGEj68NfDzZtyxGHKQYaEM4olLA+IhcLLNdTqN2PR
         qMzg==
X-Gm-Message-State: APjAAAVoCKq3uCKTEHFOHeQqUabUwbK4m+P11x7wr9rQAd+qJ/DjxH/S
        +KQLzRXYvsG5qimm3J4xOvUi2nfhkA0=
X-Google-Smtp-Source: APXvYqxZiXIeVCxfiXNck/Q/2z4sAZka/wws1oywSNuBtEwJpF0196AxODZAe5ShsLwCnb3tRIQYhw==
X-Received: by 2002:a17:902:860b:: with SMTP id f11mr9295449plo.48.1567078559453;
        Thu, 29 Aug 2019 04:35:59 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id n128sm3976147pfn.46.2019.08.29.04.35.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:58 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 25/44] arm64: Add skeleton to harden the branch predictor against aliasing attacks
Date:   Thu, 29 Aug 2019 17:04:10 +0530
Message-Id: <4cab9c33e7a8e9959e7cc8b296740be72544d4d0.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 0f15adbb2861ce6f75ccfc5a92b19eae0ef327d0 upstream.

Aliasing attacks against CPU branch predictors can allow an attacker to
redirect speculative control flow on some CPUs and potentially divulge
information from one context to another.

This patch adds initial skeleton code behind a new Kconfig option to
enable implementation-specific mitigations against these attacks for
CPUs that are affected.

Co-developed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Changes made according to 4.4 codebase ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/Kconfig                  | 17 +++++++
 arch/arm64/include/asm/cpufeature.h |  3 +-
 arch/arm64/include/asm/mmu.h        | 39 +++++++++++++++
 arch/arm64/include/asm/sysreg.h     |  2 +
 arch/arm64/kernel/Makefile          |  5 ++
 arch/arm64/kernel/bpi.S             | 55 +++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c      | 74 +++++++++++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c      |  3 +-
 arch/arm64/kernel/entry.S           |  8 ++--
 arch/arm64/mm/context.c             |  2 +
 arch/arm64/mm/fault.c               | 16 +++++++
 11 files changed, 219 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/kernel/bpi.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f18b8c26a959..5fa01073566b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -624,6 +624,23 @@ config FORCE_MAX_ZONEORDER
 	  However for 4K, we choose a higher default value, 11 as opposed to 10, giving us
 	  4M allocations matching the default size used by generic code.
 
+config HARDEN_BRANCH_PREDICTOR
+	bool "Harden the branch predictor against aliasing attacks" if EXPERT
+	default y
+	help
+	  Speculation attacks against some high-performance processors rely on
+	  being able to manipulate the branch predictor for a victim context by
+	  executing aliasing branches in the attacker context.  Such attacks
+	  can be partially mitigated against by clearing internal branch
+	  predictor state and limiting the prediction logic in some situations.
+
+	  This config option will take CPU-specific actions to harden the
+	  branch predictor against aliasing attacks and may rely on specific
+	  instruction sequences or control bits being set by the system
+	  firmware.
+
+	  If unsure, say Y.
+
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 1bc51f8835e5..93fb24d14d95 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -32,8 +32,9 @@
 #define ARM64_WORKAROUND_834220			7
 #define ARM64_WORKAROUND_CAVIUM_27456		8
 #define ARM64_HAS_32BIT_EL0			9
+#define ARM64_HARDEN_BRANCH_PREDICTOR		10
 
-#define ARM64_NCAPS				10
+#define ARM64_NCAPS				11
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 990124a67eeb..8d0129210416 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -16,6 +16,8 @@
 #ifndef __ASM_MMU_H
 #define __ASM_MMU_H
 
+#include <linux/percpu.h>
+
 typedef struct {
 	atomic64_t	id;
 	void		*vdso;
@@ -28,6 +30,43 @@ typedef struct {
  */
 #define ASID(mm)	((mm)->context.id.counter & 0xffff)
 
+typedef void (*bp_hardening_cb_t)(void);
+
+struct bp_hardening_data {
+	int			hyp_vectors_slot;
+	bp_hardening_cb_t	fn;
+};
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+extern char __bp_harden_hyp_vecs_start[], __bp_harden_hyp_vecs_end[];
+
+DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
+
+static inline struct bp_hardening_data *arm64_get_bp_hardening_data(void)
+{
+	return this_cpu_ptr(&bp_hardening_data);
+}
+
+static inline void arm64_apply_bp_hardening(void)
+{
+	struct bp_hardening_data *d;
+
+	if (!cpus_have_cap(ARM64_HARDEN_BRANCH_PREDICTOR))
+		return;
+
+	d = arm64_get_bp_hardening_data();
+	if (d->fn)
+		d->fn();
+}
+#else
+static inline struct bp_hardening_data *arm64_get_bp_hardening_data(void)
+{
+	return NULL;
+}
+
+static inline void arm64_apply_bp_hardening(void)	{ }
+#endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
+
 extern void paging_init(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 50150320f80d..523b089fb408 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -95,6 +95,8 @@
 #define ID_AA64ISAR0_AES_SHIFT		4
 
 /* id_aa64pfr0 */
+#define ID_AA64PFR0_CSV2_SHIFT		56
+#define ID_AA64PFR0_SVE_SHIFT		32
 #define ID_AA64PFR0_GIC_SHIFT		24
 #define ID_AA64PFR0_ASIMD_SHIFT		20
 #define ID_AA64PFR0_FP_SHIFT		16
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 474691f8b13a..aa8f28210219 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -42,7 +42,12 @@ arm64-obj-$(CONFIG_PCI)			+= pci.o
 arm64-obj-$(CONFIG_ARMV8_DEPRECATED)	+= armv8_deprecated.o
 arm64-obj-$(CONFIG_ACPI)		+= acpi.o
 
+ifeq ($(CONFIG_KVM),y)
+arm64-obj-$(CONFIG_HARDEN_BRANCH_PREDICTOR)	+= bpi.o
+endif
+
 obj-y					+= $(arm64-obj-y) vdso/
+
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
 extra-y					+= $(head-y) vmlinux.lds
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
new file mode 100644
index 000000000000..06a931eb2673
--- /dev/null
+++ b/arch/arm64/kernel/bpi.S
@@ -0,0 +1,55 @@
+/*
+ * Contains CPU specific branch predictor invalidation sequences
+ *
+ * Copyright (C) 2018 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+
+.macro ventry target
+	.rept 31
+	nop
+	.endr
+	b	\target
+.endm
+
+.macro vectors target
+	ventry \target + 0x000
+	ventry \target + 0x080
+	ventry \target + 0x100
+	ventry \target + 0x180
+
+	ventry \target + 0x200
+	ventry \target + 0x280
+	ventry \target + 0x300
+	ventry \target + 0x380
+
+	ventry \target + 0x400
+	ventry \target + 0x480
+	ventry \target + 0x500
+	ventry \target + 0x580
+
+	ventry \target + 0x600
+	ventry \target + 0x680
+	ventry \target + 0x700
+	ventry \target + 0x780
+.endm
+
+	.align	11
+ENTRY(__bp_harden_hyp_vecs_start)
+	.rept 4
+	vectors __kvm_hyp_vector
+	.endr
+ENTRY(__bp_harden_hyp_vecs_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 047f1da59cb1..19c51d1cd302 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -43,6 +43,80 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 	return (midr >= entry->midr_range_min && midr <= entry->midr_range_max);
 }
 
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+#include <asm/mmu_context.h>
+#include <asm/cacheflush.h>
+
+DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
+
+#ifdef CONFIG_KVM
+static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
+				const char *hyp_vecs_end)
+{
+	void *dst = __bp_harden_hyp_vecs_start + slot * SZ_2K;
+	int i;
+
+	for (i = 0; i < SZ_2K; i += 0x80)
+		memcpy(dst + i, hyp_vecs_start, hyp_vecs_end - hyp_vecs_start);
+
+	flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
+}
+
+static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
+				      const char *hyp_vecs_start,
+				      const char *hyp_vecs_end)
+{
+	static int last_slot = -1;
+	static DEFINE_SPINLOCK(bp_lock);
+	int cpu, slot = -1;
+
+	spin_lock(&bp_lock);
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(bp_hardening_data.fn, cpu) == fn) {
+			slot = per_cpu(bp_hardening_data.hyp_vectors_slot, cpu);
+			break;
+		}
+	}
+
+	if (slot == -1) {
+		last_slot++;
+		BUG_ON(((__bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start)
+			/ SZ_2K) <= last_slot);
+		slot = last_slot;
+		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
+	}
+
+	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+	__this_cpu_write(bp_hardening_data.fn, fn);
+	spin_unlock(&bp_lock);
+}
+#else
+static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
+				      const char *hyp_vecs_start,
+				      const char *hyp_vecs_end)
+{
+	__this_cpu_write(bp_hardening_data.fn, fn);
+}
+#endif	/* CONFIG_KVM */
+
+static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
+				     bp_hardening_cb_t fn,
+				     const char *hyp_vecs_start,
+				     const char *hyp_vecs_end)
+{
+	u64 pfr0;
+
+	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
+		return;
+
+	pfr0 = read_cpuid(ID_AA64PFR0_EL1);
+	if (cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_CSV2_SHIFT))
+		return;
+
+	__install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
+}
+#endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
+
 #define MIDR_RANGE(model, min, max) \
 	.def_scope = SCOPE_LOCAL_CPU, \
 	.matches = is_affected_midr_range, \
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 474b34243521..07c39d1f4479 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -83,7 +83,8 @@ static struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
-	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 32, 0),
+	ARM64_FTR_BITS(FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 24, 0),
 	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 28, 4, 0),
 	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e6aec982dea9..05bfc71639fc 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -495,13 +495,15 @@ ENDPROC(el1_irq)
 	 * Instruction abort handling
 	 */
 	mrs	x26, far_el1
-	// enable interrupts before calling the main handler
-	enable_dbg_and_irq
+	msr     daifclr, #(8 | 4 | 1)
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bl	trace_hardirqs_off
+#endif
 	ct_user_exit
 	mov	x0, x26
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
-	bl	do_mem_abort
+	bl	do_el0_ia_bp_hardening
 	b	ret_to_user
 el0_fpsimd_acc:
 	/*
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 492d2968fa8f..be42bd3dca5c 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -193,6 +193,8 @@ asmlinkage void post_ttbr_update_workaround(void)
 			"ic iallu; dsb nsh; isb",
 			ARM64_WORKAROUND_CAVIUM_27456,
 			CONFIG_CAVIUM_ERRATUM_27456));
+
+	arm64_apply_bp_hardening();
 }
 
 static int asids_init(void)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 89abdf9af4e6..1878c881a247 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -535,6 +535,22 @@ asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
 	arm64_notify_die("", regs, &info, esr);
 }
 
+asmlinkage void __exception do_el0_ia_bp_hardening(unsigned long addr,
+						   unsigned int esr,
+						   struct pt_regs *regs)
+{
+	/*
+	 * We've taken an instruction abort from userspace and not yet
+	 * re-enabled IRQs. If the address is a kernel address, apply
+	 * BP hardening prior to enabling IRQs and pre-emption.
+	 */
+	if (addr > TASK_SIZE)
+		arm64_apply_bp_hardening();
+
+	local_irq_enable();
+	do_mem_abort(addr, esr, regs);
+}
+
 /*
  * Handle stack alignment exceptions.
  */
-- 
2.21.0.rc0.269.g1a574e7a288b

