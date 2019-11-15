Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA3FFD645
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKOGXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:23:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfKOGWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:38 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F9320740;
        Fri, 15 Nov 2019 06:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798958;
        bh=PC0i2dm05Tp+rF6rCa1xvO2mtdEaagnnSK+vEBB51tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5ZqjJvHkuc9IBbZyV75ZaMD1TuH1cRsdJMuj4QHU0/YIrOEjdxD+Y39XDWL5eIbm
         Rwp07IzD58LvWADUjUyUxBWOFupPlsg9W7XxK4JDlBOQ1FdPpWoIZ0C1qpzfKQV1mZ
         6AnbGzuVC0CvFZVbQ09ffbGvcaQLeis4/uvJzroo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 08/31] x86/cpu: Add a "tsx=" cmdline option with TSX disabled by default
Date:   Fri, 15 Nov 2019 14:20:37 +0800
Message-Id: <20191115062012.772393499@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 95c5824f75f3ba4c9e8e5a4b1a623c95390ac266 upstream.

Add a kernel cmdline parameter "tsx" to control the Transactional
Synchronization Extensions (TSX) feature. On CPUs that support TSX
control, use "tsx=on|off" to enable or disable TSX. Not specifying this
option is equivalent to "tsx=off". This is because on certain processors
TSX may be used as a part of a speculative side channel attack.

Carve out the TSX controlling functionality into a separate compilation
unit because TSX is a CPU feature while the TSX async abort control
machinery will go to cpu/bugs.c.

 [ bp: - Massage, shorten and clear the arg buffer.
       - Clarifications of the tsx= possible options - Josh.
       - Expand on TSX_CTRL availability - Pawan. ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 4.9: adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |   26 +++++++
 arch/x86/kernel/cpu/Makefile        |    2 
 arch/x86/kernel/cpu/common.c        |    2 
 arch/x86/kernel/cpu/cpu.h           |   16 ++++
 arch/x86/kernel/cpu/intel.c         |    5 +
 arch/x86/kernel/cpu/tsx.c           |  125 ++++++++++++++++++++++++++++++++++++
 6 files changed, 175 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/tsx.c

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -4516,6 +4516,32 @@ bytes respectively. Such letter suffixes
 			platforms where RDTSC is slow and this accounting
 			can add overhead.
 
+	tsx=		[X86] Control Transactional Synchronization
+			Extensions (TSX) feature in Intel processors that
+			support TSX control.
+
+			This parameter controls the TSX feature. The options are:
+
+			on	- Enable TSX on the system. Although there are
+				mitigations for all known security vulnerabilities,
+				TSX has been known to be an accelerator for
+				several previous speculation-related CVEs, and
+				so there may be unknown	security risks associated
+				with leaving it enabled.
+
+			off	- Disable TSX on the system. (Note that this
+				option takes effect only on newer CPUs which are
+				not vulnerable to MDS, i.e., have
+				MSR_IA32_ARCH_CAPABILITIES.MDS_NO=1 and which get
+				the new IA32_TSX_CTRL MSR through a microcode
+				update. This new MSR allows for the reliable
+				deactivation of the TSX functionality.)
+
+			Not specifying this option is equivalent to tsx=off.
+
+			See Documentation/hw-vuln/tsx_async_abort.rst
+			for more details.
+
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
 			Format:
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -25,7 +25,7 @@ obj-y			+= bugs.o
 obj-$(CONFIG_PROC_FS)	+= proc.o
 obj-$(CONFIG_X86_FEATURE_NAMES) += capflags.o powerflags.o
 
-obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o tsx.o
 obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1416,6 +1416,8 @@ void __init identify_boot_cpu(void)
 	enable_sep_cpu();
 #endif
 	cpu_detect_tlb(&boot_cpu_data);
+
+	tsx_init();
 }
 
 void identify_secondary_cpu(struct cpuinfo_x86 *c)
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -44,6 +44,22 @@ struct _tlb_table {
 extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
+#ifdef CONFIG_CPU_SUP_INTEL
+enum tsx_ctrl_states {
+	TSX_CTRL_ENABLE,
+	TSX_CTRL_DISABLE,
+	TSX_CTRL_NOT_SUPPORTED,
+};
+
+extern __ro_after_init enum tsx_ctrl_states tsx_ctrl_state;
+
+extern void __init tsx_init(void);
+extern void tsx_enable(void);
+extern void tsx_disable(void);
+#else
+static inline void tsx_init(void) { }
+#endif /* CONFIG_CPU_SUP_INTEL */
+
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 extern int detect_extended_topology_early(struct cpuinfo_x86 *c);
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -642,6 +642,11 @@ static void init_intel(struct cpuinfo_x8
 		detect_vmx_virtcap(c);
 
 	init_intel_energy_perf(c);
+
+	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
+		tsx_enable();
+	if (tsx_ctrl_state == TSX_CTRL_DISABLE)
+		tsx_disable();
 }
 
 #ifdef CONFIG_X86_32
--- /dev/null
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Intel Transactional Synchronization Extensions (TSX) control.
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * Author:
+ *	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
+ */
+
+#include <linux/cpufeature.h>
+
+#include <asm/cmdline.h>
+
+#include "cpu.h"
+
+enum tsx_ctrl_states tsx_ctrl_state __ro_after_init = TSX_CTRL_NOT_SUPPORTED;
+
+void tsx_disable(void)
+{
+	u64 tsx;
+
+	rdmsrl(MSR_IA32_TSX_CTRL, tsx);
+
+	/* Force all transactions to immediately abort */
+	tsx |= TSX_CTRL_RTM_DISABLE;
+
+	/*
+	 * Ensure TSX support is not enumerated in CPUID.
+	 * This is visible to userspace and will ensure they
+	 * do not waste resources trying TSX transactions that
+	 * will always abort.
+	 */
+	tsx |= TSX_CTRL_CPUID_CLEAR;
+
+	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
+}
+
+void tsx_enable(void)
+{
+	u64 tsx;
+
+	rdmsrl(MSR_IA32_TSX_CTRL, tsx);
+
+	/* Enable the RTM feature in the cpu */
+	tsx &= ~TSX_CTRL_RTM_DISABLE;
+
+	/*
+	 * Ensure TSX support is enumerated in CPUID.
+	 * This is visible to userspace and will ensure they
+	 * can enumerate and use the TSX feature.
+	 */
+	tsx &= ~TSX_CTRL_CPUID_CLEAR;
+
+	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
+}
+
+static bool __init tsx_ctrl_is_supported(void)
+{
+	u64 ia32_cap = x86_read_arch_cap_msr();
+
+	/*
+	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
+	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
+	 *
+	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
+	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
+	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
+	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
+	 * tsx= cmdline requests will do nothing on CPUs without
+	 * MSR_IA32_TSX_CTRL support.
+	 */
+	return !!(ia32_cap & ARCH_CAP_TSX_CTRL_MSR);
+}
+
+void __init tsx_init(void)
+{
+	char arg[4] = {};
+	int ret;
+
+	if (!tsx_ctrl_is_supported())
+		return;
+
+	ret = cmdline_find_option(boot_command_line, "tsx", arg, sizeof(arg));
+	if (ret >= 0) {
+		if (!strcmp(arg, "on")) {
+			tsx_ctrl_state = TSX_CTRL_ENABLE;
+		} else if (!strcmp(arg, "off")) {
+			tsx_ctrl_state = TSX_CTRL_DISABLE;
+		} else {
+			tsx_ctrl_state = TSX_CTRL_DISABLE;
+			pr_err("tsx: invalid option, defaulting to off\n");
+		}
+	} else {
+		/* tsx= not provided, defaulting to off */
+		tsx_ctrl_state = TSX_CTRL_DISABLE;
+	}
+
+	if (tsx_ctrl_state == TSX_CTRL_DISABLE) {
+		tsx_disable();
+
+		/*
+		 * tsx_disable() will change the state of the
+		 * RTM CPUID bit.  Clear it here since it is now
+		 * expected to be not set.
+		 */
+		setup_clear_cpu_cap(X86_FEATURE_RTM);
+	} else if (tsx_ctrl_state == TSX_CTRL_ENABLE) {
+
+		/*
+		 * HW defaults TSX to be enabled at bootup.
+		 * We may still need the TSX enable support
+		 * during init for special cases like
+		 * kexec after TSX is disabled.
+		 */
+		tsx_enable();
+
+		/*
+		 * tsx_enable() will change the state of the
+		 * RTM CPUID bit.  Force it here since it is now
+		 * expected to be set.
+		 */
+		setup_force_cpu_cap(X86_FEATURE_RTM);
+	}
+}


