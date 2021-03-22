Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6A934428D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCVMng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhCVMkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A182D619AE;
        Mon, 22 Mar 2021 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416744;
        bh=ZSNFFjQ2lb6OHIxzpfPtMWljieLkd0bz8Gxb6zLoyXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kolSR6SBmxv1uULCzo19AMKFf+UD/N/dJGIuATIVE8IrqddNe4chbJnXydIGAgpAb
         CAA21F+dWlJbrMV8ix5O4k98+7GAHBLW6XIbOnYaDymJU7u0/EY+/NWCwKqDgaismK
         5zeePNW9QRYzZDj6tEr4GAjIltIsgZdfqt6cG6+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Subject: [PATCH 5.10 103/157] MIPS: kernel: Reserve exception base early to prevent corruption
Date:   Mon, 22 Mar 2021 13:27:40 +0100
Message-Id: <20210322121937.040307268@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit bd67b711bfaa02cf19e88aa2d9edae5c1c1d2739 ]

BMIPS is one of the few platforms that do change the exception base.
After commit 2dcb39645441 ("memblock: do not start bottom-up allocations
with kernel_end") we started seeing BMIPS boards fail to boot with the
built-in FDT being corrupted.

Before the cited commit, early allocations would be in the [kernel_end,
RAM_END] range, but after commit they would be within [RAM_START +
PAGE_SIZE, RAM_END].

The custom exception base handler that is installed by
bmips_ebase_setup() done for BMIPS5000 CPUs ends-up trampling on the
memory region allocated by unflatten_and_copy_device_tree() thus
corrupting the FDT used by the kernel.

To fix this, we need to perform an early reservation of the custom
exception space. Additional we reserve the first 4k (1k for R3k) for
either normal exception vector space (legacy CPUs) or special vectors
like cache exceptions.

Huge thanks to Serge for analysing and proposing a solution to this
issue.

Fixes: 2dcb39645441 ("memblock: do not start bottom-up allocations with kernel_end")
Reported-by: Kamal Dasu <kdasu.kdev@gmail.com>
Debugged-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/traps.h    |  3 +++
 arch/mips/kernel/cpu-probe.c     |  6 ++++++
 arch/mips/kernel/cpu-r3k-probe.c |  3 +++
 arch/mips/kernel/traps.c         | 10 +++++-----
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/traps.h b/arch/mips/include/asm/traps.h
index 6a0864bb604d..9038b91e2d8c 100644
--- a/arch/mips/include/asm/traps.h
+++ b/arch/mips/include/asm/traps.h
@@ -24,6 +24,9 @@ extern void (*board_ebase_setup)(void);
 extern void (*board_cache_error_setup)(void);
 
 extern int register_nmi_notifier(struct notifier_block *nb);
+extern void reserve_exception_space(phys_addr_t addr, unsigned long size);
+
+#define VECTORSPACING 0x100	/* for EI/VI mode */
 
 #define nmi_notifier(fn, pri)						\
 ({									\
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 31cb9199197c..21794db53c05 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -26,6 +26,7 @@
 #include <asm/elf.h>
 #include <asm/pgtable-bits.h>
 #include <asm/spram.h>
+#include <asm/traps.h>
 #include <linux/uaccess.h>
 
 #include "fpu-probe.h"
@@ -1619,6 +1620,7 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 		c->cputype = CPU_BMIPS3300;
 		__cpu_name[cpu] = "Broadcom BMIPS3300";
 		set_elf_platform(cpu, "bmips3300");
+		reserve_exception_space(0x400, VECTORSPACING * 64);
 		break;
 	case PRID_IMP_BMIPS43XX: {
 		int rev = c->processor_id & PRID_REV_MASK;
@@ -1629,6 +1631,7 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "Broadcom BMIPS4380";
 			set_elf_platform(cpu, "bmips4380");
 			c->options |= MIPS_CPU_RIXI;
+			reserve_exception_space(0x400, VECTORSPACING * 64);
 		} else {
 			c->cputype = CPU_BMIPS4350;
 			__cpu_name[cpu] = "Broadcom BMIPS4350";
@@ -1645,6 +1648,7 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "Broadcom BMIPS5000";
 		set_elf_platform(cpu, "bmips5000");
 		c->options |= MIPS_CPU_ULRI | MIPS_CPU_RIXI;
+		reserve_exception_space(0x1000, VECTORSPACING * 64);
 		break;
 	}
 }
@@ -2124,6 +2128,8 @@ void cpu_probe(void)
 	if (cpu == 0)
 		__ua_limit = ~((1ull << cpu_vmbits) - 1);
 #endif
+
+	reserve_exception_space(0, 0x1000);
 }
 
 void cpu_report(void)
diff --git a/arch/mips/kernel/cpu-r3k-probe.c b/arch/mips/kernel/cpu-r3k-probe.c
index abdbbe8c5a43..af654771918c 100644
--- a/arch/mips/kernel/cpu-r3k-probe.c
+++ b/arch/mips/kernel/cpu-r3k-probe.c
@@ -21,6 +21,7 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/elf.h>
+#include <asm/traps.h>
 
 #include "fpu-probe.h"
 
@@ -158,6 +159,8 @@ void cpu_probe(void)
 		cpu_set_fpu_opts(c);
 	else
 		cpu_set_nofpu_opts(c);
+
+	reserve_exception_space(0, 0x400);
 }
 
 void cpu_report(void)
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index e0352958e2f7..808b8b61ded1 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2009,13 +2009,16 @@ void __noreturn nmi_exception_handler(struct pt_regs *regs)
 	nmi_exit();
 }
 
-#define VECTORSPACING 0x100	/* for EI/VI mode */
-
 unsigned long ebase;
 EXPORT_SYMBOL_GPL(ebase);
 unsigned long exception_handlers[32];
 unsigned long vi_handlers[64];
 
+void reserve_exception_space(phys_addr_t addr, unsigned long size)
+{
+	memblock_reserve(addr, size);
+}
+
 void __init *set_except_vector(int n, void *addr)
 {
 	unsigned long handler = (unsigned long) addr;
@@ -2367,10 +2370,7 @@ void __init trap_init(void)
 
 	if (!cpu_has_mips_r2_r6) {
 		ebase = CAC_BASE;
-		ebase_pa = virt_to_phys((void *)ebase);
 		vec_size = 0x400;
-
-		memblock_reserve(ebase_pa, vec_size);
 	} else {
 		if (cpu_has_veic || cpu_has_vint)
 			vec_size = 0x200 + VECTORSPACING*64;
-- 
2.30.1



