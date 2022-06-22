Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA46D554A2F
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbiFVMho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 08:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243581AbiFVMhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 08:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F9939B81;
        Wed, 22 Jun 2022 05:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1840B61952;
        Wed, 22 Jun 2022 12:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB64C34114;
        Wed, 22 Jun 2022 12:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655901454;
        bh=oZHQSSQXfrOcby2nJcg9dQWHkxmQ0vM3cT2swQekP8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEYm1gf6+9AAxGv/9zPFmmKpgZGAWDsE6LdYTcpFO6C8jwlG1UcCk7gFJ1Q4j1ciO
         518/Ml9XqxfjSzOD/5kR0K1GKObUU1U/KeXYI93pfNCu46eECld0Sc/tMAgMg6w98e
         VCaWUtVRA1t76vr/vFI610uQDsxfemEhUvV/0jr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.49
Date:   Wed, 22 Jun 2022 14:37:22 +0200
Message-Id: <16559014424217@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1655901442158146@kroah.com>
References: <1655901442158146@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 8d7d65bd8efb..3e9782979b7c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 48
+SUBLEVEL = 49
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -811,6 +811,9 @@ endif
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
 
+# These result in bogus false positives
+KBUILD_CFLAGS += $(call cc-disable-warning, dangling-pointer)
+
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
index 6f5e63696ec0..94e5fa8ca957 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
@@ -166,6 +166,7 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>;
 	assigned-clocks = <&clk IMX8MM_CLK_UART3>;
 	assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
+	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -236,6 +237,8 @@ pinctrl_uart3: uart3grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI1_SCLK_UART3_DCE_RX	0x40
 			MX8MM_IOMUXC_ECSPI1_MOSI_UART3_DCE_TX	0x40
+			MX8MM_IOMUXC_ECSPI1_MISO_UART3_DCE_CTS_B	0x40
+			MX8MM_IOMUXC_ECSPI1_SS0_UART3_DCE_RTS_B	0x40
 		>;
 	};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
index 376ca8ff7213..e69fd41b46d0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
@@ -176,6 +176,7 @@ &uart3 {
 	pinctrl-0 = <&pinctrl_uart3>;
 	assigned-clocks = <&clk IMX8MN_CLK_UART3>;
 	assigned-clock-parents = <&clk IMX8MN_SYS_PLL1_80M>;
+	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -259,6 +260,8 @@ pinctrl_uart3: uart3grp {
 		fsl,pins = <
 			MX8MN_IOMUXC_ECSPI1_SCLK_UART3_DCE_RX	0x40
 			MX8MN_IOMUXC_ECSPI1_MOSI_UART3_DCE_TX	0x40
+			MX8MN_IOMUXC_ECSPI1_MISO_UART3_DCE_CTS_B	0x40
+			MX8MN_IOMUXC_ECSPI1_SS0_UART3_DCE_RTS_B	0x40
 		>;
 	};
 
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 7f467bd9db7a..ae0248154981 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -78,47 +78,76 @@ static struct plt_entry *get_ftrace_plt(struct module *mod, unsigned long addr)
 }
 
 /*
- * Turn on the call to ftrace_caller() in instrumented function
+ * Find the address the callsite must branch to in order to reach '*addr'.
+ *
+ * Due to the limited range of 'BL' instructions, modules may be placed too far
+ * away to branch directly and must use a PLT.
+ *
+ * Returns true when '*addr' contains a reachable target address, or has been
+ * modified to contain a PLT address. Returns false otherwise.
  */
-int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+static bool ftrace_find_callable_addr(struct dyn_ftrace *rec,
+				      struct module *mod,
+				      unsigned long *addr)
 {
 	unsigned long pc = rec->ip;
-	u32 old, new;
-	long offset = (long)pc - (long)addr;
+	long offset = (long)*addr - (long)pc;
+	struct plt_entry *plt;
 
-	if (offset < -SZ_128M || offset >= SZ_128M) {
-		struct module *mod;
-		struct plt_entry *plt;
+	/*
+	 * When the target is within range of the 'BL' instruction, use 'addr'
+	 * as-is and branch to that directly.
+	 */
+	if (offset >= -SZ_128M && offset < SZ_128M)
+		return true;
 
-		if (!IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
-			return -EINVAL;
+	/*
+	 * When the target is outside of the range of a 'BL' instruction, we
+	 * must use a PLT to reach it. We can only place PLTs for modules, and
+	 * only when module PLT support is built-in.
+	 */
+	if (!IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
+		return false;
 
-		/*
-		 * On kernels that support module PLTs, the offset between the
-		 * branch instruction and its target may legally exceed the
-		 * range of an ordinary relative 'bl' opcode. In this case, we
-		 * need to branch via a trampoline in the module.
-		 *
-		 * NOTE: __module_text_address() must be called with preemption
-		 * disabled, but we can rely on ftrace_lock to ensure that 'mod'
-		 * retains its validity throughout the remainder of this code.
-		 */
+	/*
+	 * 'mod' is only set at module load time, but if we end up
+	 * dealing with an out-of-range condition, we can assume it
+	 * is due to a module being loaded far away from the kernel.
+	 *
+	 * NOTE: __module_text_address() must be called with preemption
+	 * disabled, but we can rely on ftrace_lock to ensure that 'mod'
+	 * retains its validity throughout the remainder of this code.
+	 */
+	if (!mod) {
 		preempt_disable();
 		mod = __module_text_address(pc);
 		preempt_enable();
+	}
 
-		if (WARN_ON(!mod))
-			return -EINVAL;
+	if (WARN_ON(!mod))
+		return false;
 
-		plt = get_ftrace_plt(mod, addr);
-		if (!plt) {
-			pr_err("ftrace: no module PLT for %ps\n", (void *)addr);
-			return -EINVAL;
-		}
-
-		addr = (unsigned long)plt;
+	plt = get_ftrace_plt(mod, *addr);
+	if (!plt) {
+		pr_err("ftrace: no module PLT for %ps\n", (void *)*addr);
+		return false;
 	}
 
+	*addr = (unsigned long)plt;
+	return true;
+}
+
+/*
+ * Turn on the call to ftrace_caller() in instrumented function
+ */
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long pc = rec->ip;
+	u32 old, new;
+
+	if (!ftrace_find_callable_addr(rec, NULL, &addr))
+		return -EINVAL;
+
 	old = aarch64_insn_gen_nop();
 	new = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
 
@@ -132,6 +161,11 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	unsigned long pc = rec->ip;
 	u32 old, new;
 
+	if (!ftrace_find_callable_addr(rec, NULL, &old_addr))
+		return -EINVAL;
+	if (!ftrace_find_callable_addr(rec, NULL, &addr))
+		return -EINVAL;
+
 	old = aarch64_insn_gen_branch_imm(pc, old_addr,
 					  AARCH64_INSN_BRANCH_LINK);
 	new = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
@@ -181,54 +215,15 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 		    unsigned long addr)
 {
 	unsigned long pc = rec->ip;
-	bool validate = true;
 	u32 old = 0, new;
-	long offset = (long)pc - (long)addr;
 
-	if (offset < -SZ_128M || offset >= SZ_128M) {
-		u32 replaced;
-
-		if (!IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
-			return -EINVAL;
-
-		/*
-		 * 'mod' is only set at module load time, but if we end up
-		 * dealing with an out-of-range condition, we can assume it
-		 * is due to a module being loaded far away from the kernel.
-		 */
-		if (!mod) {
-			preempt_disable();
-			mod = __module_text_address(pc);
-			preempt_enable();
-
-			if (WARN_ON(!mod))
-				return -EINVAL;
-		}
-
-		/*
-		 * The instruction we are about to patch may be a branch and
-		 * link instruction that was redirected via a PLT entry. In
-		 * this case, the normal validation will fail, but we can at
-		 * least check that we are dealing with a branch and link
-		 * instruction that points into the right module.
-		 */
-		if (aarch64_insn_read((void *)pc, &replaced))
-			return -EFAULT;
-
-		if (!aarch64_insn_is_bl(replaced) ||
-		    !within_module(pc + aarch64_get_branch_offset(replaced),
-				   mod))
-			return -EINVAL;
-
-		validate = false;
-	} else {
-		old = aarch64_insn_gen_branch_imm(pc, addr,
-						  AARCH64_INSN_BRANCH_LINK);
-	}
+	if (!ftrace_find_callable_addr(rec, mod, &addr))
+		return -EINVAL;
 
+	old = aarch64_insn_gen_branch_imm(pc, addr, AARCH64_INSN_BRANCH_LINK);
 	new = aarch64_insn_gen_nop();
 
-	return ftrace_modify_code(pc, old, new, validate);
+	return ftrace_modify_code(pc, old, new, true);
 }
 
 void arch_ftrace_update_code(int command)
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 5f9014ae595b..508aee9f8853 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -418,11 +418,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
-		NULL, vgic_uaccess_write_spending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_spending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
-		NULL, vgic_uaccess_write_cpending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_cpending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index f97299268274..55630ca2c325 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -226,8 +226,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len)
+static unsigned long __read_pending(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    bool is_user)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 value = 0;
@@ -248,7 +249,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
-		} else if (vgic_irq_is_mapped_level(irq)) {
+		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
 			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
@@ -263,6 +264,18 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, false);
+}
+
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, true);
+}
+
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	return (vgic_irq_is_sgi(irq->intid) &&
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index fefcca2b14dc..dcea44015985 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -149,6 +149,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len);
 
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len);
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 50436b52c213..39a0a13a3a27 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -2124,12 +2124,12 @@ static unsigned long __get_wchan(struct task_struct *p)
 		return 0;
 
 	do {
-		sp = *(unsigned long *)sp;
+		sp = READ_ONCE_NOCHECK(*(unsigned long *)sp);
 		if (!validate_sp(sp, p, STACK_FRAME_OVERHEAD) ||
 		    task_is_running(p))
 			return 0;
 		if (count > 0) {
-			ip = ((unsigned long *)sp)[STACK_FRAME_LR_SAVE];
+			ip = READ_ONCE_NOCHECK(((unsigned long *)sp)[STACK_FRAME_LR_SAVE]);
 			if (!in_sched_functions(ip))
 				return ip;
 		}
diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 4c74e8a5482b..c555ad9fa00b 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/kdump.h>
 #include <mm/mmu_decl.h>
-#include <generated/compile.h>
 #include <generated/utsrelease.h>
 
 struct regions {
@@ -36,10 +35,6 @@ struct regions {
 	int reserved_mem_size_cells;
 };
 
-/* Simplified build-specific string for starting entropy. */
-static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
-
 struct regions __initdata regions;
 
 static __init void kaslr_get_cmdline(void *fdt)
@@ -72,7 +67,8 @@ static unsigned long __init get_boot_seed(void *fdt)
 {
 	unsigned long hash = 0;
 
-	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	/* build-specific string for starting entropy. */
+	hash = rotate_xor(hash, linux_banner, strlen(linux_banner));
 	hash = rotate_xor(hash, fdt, fdt_totalsize(fdt));
 
 	return hash;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b70488e4db94..95993c4efa49 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -476,6 +476,8 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	if (!blk_mq_hw_queue_mapped(data.hctx))
 		goto out_queue_exit;
 	cpu = cpumask_first_and(data.hctx->cpumask, cpu_online_mask);
+	if (cpu >= nr_cpu_ids)
+		goto out_queue_exit;
 	data.ctx = __blk_mq_get_ctx(q, cpu);
 
 	if (!q->elevator)
diff --git a/certs/blacklist_hashes.c b/certs/blacklist_hashes.c
index 344892337be0..d5961aa3d338 100644
--- a/certs/blacklist_hashes.c
+++ b/certs/blacklist_hashes.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "blacklist.h"
 
-const char __initdata *const blacklist_hashes[] = {
+const char __initconst *const blacklist_hashes[] = {
 #include CONFIG_SYSTEM_BLACKLIST_HASH_LIST
 	, NULL
 };
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a346b6f74bb3..f0743ac4e820 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -15,6 +15,7 @@ source "crypto/async_tx/Kconfig"
 #
 menuconfig CRYPTO
 	tristate "Cryptographic API"
+	select LIB_MEMNEQ
 	help
 	  This option provides the core Cryptographic API.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index c633f15a0481..78b5ab05d6ed 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-y := api.o cipher.o compress.o memneq.o
+crypto-y := api.o cipher.o compress.o
 
 obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
diff --git a/crypto/memneq.c b/crypto/memneq.c
deleted file mode 100644
index afed1bd16aee..000000000000
--- a/crypto/memneq.c
+++ /dev/null
@@ -1,168 +0,0 @@
-/*
- * Constant-time equality testing of memory regions.
- *
- * Authors:
- *
- *   James Yonan <james@openvpn.net>
- *   Daniel Borkmann <dborkman@redhat.com>
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of OpenVPN Technologies nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <crypto/algapi.h>
-
-#ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
-
-/* Generic path for arbitrary size */
-static inline unsigned long
-__crypto_memneq_generic(const void *a, const void *b, size_t size)
-{
-	unsigned long neq = 0;
-
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-	while (size >= sizeof(unsigned long)) {
-		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
-		OPTIMIZER_HIDE_VAR(neq);
-		a += sizeof(unsigned long);
-		b += sizeof(unsigned long);
-		size -= sizeof(unsigned long);
-	}
-#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-	while (size > 0) {
-		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
-		OPTIMIZER_HIDE_VAR(neq);
-		a += 1;
-		b += 1;
-		size -= 1;
-	}
-	return neq;
-}
-
-/* Loop-free fast-path for frequently used 16-byte size */
-static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
-{
-	unsigned long neq = 0;
-
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (sizeof(unsigned long) == 8) {
-		neq |= *(unsigned long *)(a)   ^ *(unsigned long *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
-	} else if (sizeof(unsigned int) == 4) {
-		neq |= *(unsigned int *)(a)    ^ *(unsigned int *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
-		OPTIMIZER_HIDE_VAR(neq);
-	} else
-#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-	{
-		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
-		OPTIMIZER_HIDE_VAR(neq);
-	}
-
-	return neq;
-}
-
-/* Compare two areas of memory without leaking timing information,
- * and with special optimizations for common sizes.  Users should
- * not call this function directly, but should instead use
- * crypto_memneq defined in crypto/algapi.h.
- */
-noinline unsigned long __crypto_memneq(const void *a, const void *b,
-				       size_t size)
-{
-	switch (size) {
-	case 16:
-		return __crypto_memneq_16(a, b);
-	default:
-		return __crypto_memneq_generic(a, b, size);
-	}
-}
-EXPORT_SYMBOL(__crypto_memneq);
-
-#endif /* __HAVE_ARCH_CRYPTO_MEMNEQ */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a0343b7c9add..413faa9330b2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5500,7 +5500,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 				      const struct ata_port_info * const * ppi,
 				      int n_ports)
 {
-	const struct ata_port_info *pi;
+	const struct ata_port_info *pi = &ata_dummy_port_info;
 	struct ata_host *host;
 	int i, j;
 
@@ -5508,7 +5508,7 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	if (!host)
 		return NULL;
 
-	for (i = 0, j = 0, pi = NULL; i < host->n_ports; i++) {
+	for (i = 0, j = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
 		if (ppi[j])
diff --git a/drivers/base/init.c b/drivers/base/init.c
index a9f57c22fb9e..dab8aa5d2888 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/memory.h>
 #include <linux/of.h>
+#include <linux/backing-dev.h>
 
 #include "base.h"
 
@@ -20,6 +21,7 @@
 void __init driver_init(void)
 {
 	/* These are the core pieces */
+	bdi_init(&noop_backing_dev_info);
 	devtmpfs_init();
 	devices_init();
 	buses_init();
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 8fd4a356a86e..74593a1722fe 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -1236,14 +1236,14 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 static int fsl_mc_bus_remove(struct platform_device *pdev)
 {
 	struct fsl_mc *mc = platform_get_drvdata(pdev);
+	struct fsl_mc_io *mc_io;
 
 	if (!fsl_mc_is_root_dprc(&mc->root_mc_bus_dev->dev))
 		return -EINVAL;
 
+	mc_io = mc->root_mc_bus_dev->mc_io;
 	fsl_mc_device_remove(mc->root_mc_bus_dev);
-
-	fsl_destroy_mc_io(mc->root_mc_bus_dev->mc_io);
-	mc->root_mc_bus_dev->mc_io = NULL;
+	fsl_destroy_mc_io(mc_io);
 
 	bus_unregister_notifier(&fsl_mc_bus_type, &fsl_mc_nb);
 
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 55f48375e3fe..d454428f4981 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -428,28 +428,40 @@ config ADI
 	  driver include crash and makedumpfile.
 
 config RANDOM_TRUST_CPU
-	bool "Trust the CPU manufacturer to initialize Linux's CRNG"
+	bool "Initialize RNG using CPU RNG instructions"
+	default y
 	depends on ARCH_RANDOM
-	default n
 	help
-	Assume that CPU manufacturer (e.g., Intel or AMD for RDSEED or
-	RDRAND, IBM for the S390 and Power PC architectures) is trustworthy
-	for the purposes of initializing Linux's CRNG.  Since this is not
-	something that can be independently audited, this amounts to trusting
-	that CPU manufacturer (perhaps with the insistence or mandate
-	of a Nation State's intelligence or law enforcement agencies)
-	has not installed a hidden back door to compromise the CPU's
-	random number generation facilities. This can also be configured
-	at boot with "random.trust_cpu=on/off".
+	  Initialize the RNG using random numbers supplied by the CPU's
+	  RNG instructions (e.g. RDRAND), if supported and available. These
+	  random numbers are never used directly, but are rather hashed into
+	  the main input pool, and this happens regardless of whether or not
+	  this option is enabled. Instead, this option controls whether the
+	  they are credited and hence can initialize the RNG. Additionally,
+	  other sources of randomness are always used, regardless of this
+	  setting.  Enabling this implies trusting that the CPU can supply high
+	  quality and non-backdoored random numbers.
+
+	  Say Y here unless you have reason to mistrust your CPU or believe
+	  its RNG facilities may be faulty. This may also be configured at
+	  boot time with "random.trust_cpu=on/off".
 
 config RANDOM_TRUST_BOOTLOADER
-	bool "Trust the bootloader to initialize Linux's CRNG"
-	help
-	Some bootloaders can provide entropy to increase the kernel's initial
-	device randomness. Say Y here to assume the entropy provided by the
-	booloader is trustworthy so it will be added to the kernel's entropy
-	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool. This can also be configured at boot with
-	"random.trust_bootloader=on/off".
+	bool "Initialize RNG using bootloader-supplied seed"
+	default y
+	help
+	  Initialize the RNG using a seed supplied by the bootloader or boot
+	  environment (e.g. EFI or a bootloader-generated device tree). This
+	  seed is not used directly, but is rather hashed into the main input
+	  pool, and this happens regardless of whether or not this option is
+	  enabled. Instead, this option controls whether the seed is credited
+	  and hence can initialize the RNG. Additionally, other sources of
+	  randomness are always used, regardless of this setting. Enabling
+	  this implies trusting that the bootloader can supply high quality and
+	  non-backdoored seeds.
+
+	  Say Y here unless you have reason to mistrust your bootloader or
+	  believe its RNG facilities may be faulty. This may also be configured
+	  at boot time with "random.trust_bootloader=on/off".
 
 endmenu
diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 12837304545d..b173c3009394 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -675,7 +675,7 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_UART2_ROOT] = imx_clk_hw_gate4("uart2_root_clk", "uart2", ccm_base + 0x44a0, 0);
 	hws[IMX8MP_CLK_UART3_ROOT] = imx_clk_hw_gate4("uart3_root_clk", "uart3", ccm_base + 0x44b0, 0);
 	hws[IMX8MP_CLK_UART4_ROOT] = imx_clk_hw_gate4("uart4_root_clk", "uart4", ccm_base + 0x44c0, 0);
-	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate4("usb_root_clk", "osc_32k", ccm_base + 0x44d0, 0);
+	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate4("usb_root_clk", "hsio_axi", ccm_base + 0x44d0, 0);
 	hws[IMX8MP_CLK_USB_PHY_ROOT] = imx_clk_hw_gate4("usb_phy_root_clk", "usb_phy_ref", ccm_base + 0x44f0, 0);
 	hws[IMX8MP_CLK_USDHC1_ROOT] = imx_clk_hw_gate4("usdhc1_root_clk", "usdhc1", ccm_base + 0x4510, 0);
 	hws[IMX8MP_CLK_USDHC2_ROOT] = imx_clk_hw_gate4("usdhc2_root_clk", "usdhc2", ccm_base + 0x4520, 0);
diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index ff188ab68496..bb47610bbd1c 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -565,4 +565,3 @@ void __init hv_init_clocksource(void)
 	hv_sched_clock_offset = hv_read_reference_counter();
 	hv_setup_sched_clock(read_hv_sched_clock_msr);
 }
-EXPORT_SYMBOL_GPL(hv_init_clocksource);
diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
index 4b00a9ea611a..9a1d146b7ebb 100644
--- a/drivers/comedi/drivers/vmk80xx.c
+++ b/drivers/comedi/drivers/vmk80xx.c
@@ -685,7 +685,7 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
+	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index f98fa33e1679..e981e7a46fc1 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -653,10 +653,9 @@ static int dwapb_get_clks(struct dwapb_gpio *gpio)
 	gpio->clks[1].id = "db";
 	err = devm_clk_bulk_get_optional(gpio->dev, DWAPB_NR_CLOCKS,
 					 gpio->clks);
-	if (err) {
-		dev_err(gpio->dev, "Cannot get APB/Debounce clocks\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(gpio->dev, err,
+				     "Cannot get APB/Debounce clocks\n");
 
 	err = clk_bulk_prepare_enable(DWAPB_NR_CLOCKS, gpio->clks);
 	if (err) {
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index ab36cce59d2e..21c02f817a84 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1828,9 +1828,6 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_dev *kgd,
 		return -EINVAL;
 	}
 
-	/* delete kgd_mem from kfd_bo_list to avoid re-validating
-	 * this BO in BO's restoring after eviction.
-	 */
 	mutex_lock(&mem->process_info->lock);
 
 	ret = amdgpu_bo_reserve(bo, true);
@@ -1853,7 +1850,6 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_dev *kgd,
 
 	amdgpu_amdkfd_remove_eviction_fence(
 		bo, mem->process_info->eviction_fence);
-	list_del_init(&mem->validate_list.head);
 
 	if (size)
 		*size = amdgpu_bo_size(bo);
@@ -2399,12 +2395,15 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence **ef)
 	process_info->eviction_fence = new_fence;
 	*ef = dma_fence_get(&new_fence->base);
 
-	/* Attach new eviction fence to all BOs */
+	/* Attach new eviction fence to all BOs except pinned ones */
 	list_for_each_entry(mem, &process_info->kfd_bo_list,
-		validate_list.head)
+		validate_list.head) {
+		if (mem->bo->tbo.pin_count)
+			continue;
+
 		amdgpu_bo_fence(mem->bo,
 			&process_info->eviction_fence->base, true);
-
+	}
 	/* Attach eviction fence to PD / PT BOs */
 	list_for_each_entry(peer_vm, &process_info->vm_list_head,
 			    vm_list_node) {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 830809b694dd..74e6f613be02 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2181,6 +2181,8 @@ svm_range_cpu_invalidate_pagetables(struct mmu_interval_notifier *mni,
 
 	if (range->event == MMU_NOTIFY_RELEASE)
 		return true;
+	if (!mmget_not_zero(mni->mm))
+		return true;
 
 	start = mni->interval_tree.start;
 	last = mni->interval_tree.last;
@@ -2207,6 +2209,7 @@ svm_range_cpu_invalidate_pagetables(struct mmu_interval_notifier *mni,
 	}
 
 	svm_range_unlock(prange);
+	mmput(mni->mm);
 
 	return true;
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ec75613618b1..dff6238ca9ad 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2417,7 +2417,7 @@ static struct drm_mode_config_helper_funcs amdgpu_dm_mode_config_helperfuncs = {
 
 static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 {
-	u32 max_cll, min_cll, max, min, q, r;
+	u32 max_avg, min_cll, max, min, q, r;
 	struct amdgpu_dm_backlight_caps *caps;
 	struct amdgpu_display_manager *dm;
 	struct drm_connector *conn_base;
@@ -2447,7 +2447,7 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	caps = &dm->backlight_caps[i];
 	caps->ext_caps = &aconnector->dc_link->dpcd_sink_ext_caps;
 	caps->aux_support = false;
-	max_cll = conn_base->hdr_sink_metadata.hdmi_type1.max_cll;
+	max_avg = conn_base->hdr_sink_metadata.hdmi_type1.max_fall;
 	min_cll = conn_base->hdr_sink_metadata.hdmi_type1.min_cll;
 
 	if (caps->ext_caps->bits.oled == 1 /*||
@@ -2475,8 +2475,8 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	 * The results of the above expressions can be verified at
 	 * pre_computed_values.
 	 */
-	q = max_cll >> 5;
-	r = max_cll % 32;
+	q = max_avg >> 5;
+	r = max_avg % 32;
 	max = (1 << q) * pre_computed_values[r];
 
 	// min luminance: maxLum * (CV/255)^2 / 100
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
index b0892443fbd5..c7c27a605f15 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
@@ -168,9 +168,7 @@ void enc31_hw_init(struct link_encoder *enc)
 	AUX_RX_PHASE_DETECT_LEN,  [21,20] = 0x3 default is 3
 	AUX_RX_DETECTION_THRESHOLD [30:28] = 1
 */
-	AUX_REG_WRITE(AUX_DPHY_RX_CONTROL0, 0x103d1110);
-
-	AUX_REG_WRITE(AUX_DPHY_TX_CONTROL, 0x21c7a);
+	// dmub will read AUX_DPHY_RX_CONTROL0/AUX_DPHY_TX_CONTROL from vbios table in dp_aux_init
 
 	//AUX_DPHY_TX_REF_CONTROL'AUX_TX_REF_DIV HW default is 0x32;
 	// Set AUX_TX_REF_DIV Divider to generate 2 MHz reference from refclk
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index 310ced5058c4..b60ab3cc0f11 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1294,12 +1294,6 @@ static struct stream_encoder *dcn31_stream_encoder_create(
 	if (!enc1 || !vpg || !afmt)
 		return NULL;
 
-	if (ctx->asic_id.chip_family == FAMILY_YELLOW_CARP &&
-			ctx->asic_id.hw_internal_rev == YELLOW_CARP_B0) {
-		if ((eng_id == ENGINE_ID_DIGC) || (eng_id == ENGINE_ID_DIGD))
-			eng_id = eng_id + 3; // For B0 only. C->F, D->G.
-	}
-
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
 					eng_id, vpg, afmt,
 					&stream_enc_regs[eng_id],
diff --git a/drivers/gpu/drm/i915/i915_sysfs.c b/drivers/gpu/drm/i915/i915_sysfs.c
index cdf0e9c6fd73..313c0000a814 100644
--- a/drivers/gpu/drm/i915/i915_sysfs.c
+++ b/drivers/gpu/drm/i915/i915_sysfs.c
@@ -445,7 +445,14 @@ static ssize_t error_state_read(struct file *filp, struct kobject *kobj,
 	struct device *kdev = kobj_to_dev(kobj);
 	struct drm_i915_private *i915 = kdev_minor_to_i915(kdev);
 	struct i915_gpu_coredump *gpu;
-	ssize_t ret;
+	ssize_t ret = 0;
+
+	/*
+	 * FIXME: Concurrent clients triggering resets and reading + clearing
+	 * dumps can cause inconsistent sysfs reads when a user calls in with a
+	 * non-zero offset to complete a prior partial read but the
+	 * gpu_coredump has been cleared or replaced.
+	 */
 
 	gpu = i915_first_error_state(i915);
 	if (IS_ERR(gpu)) {
@@ -457,8 +464,10 @@ static ssize_t error_state_read(struct file *filp, struct kobject *kobj,
 		const char *str = "No error state collected\n";
 		size_t len = strlen(str);
 
-		ret = min_t(size_t, count, len - off);
-		memcpy(buf, str + off, ret);
+		if (off < len) {
+			ret = min_t(size_t, count, len - off);
+			memcpy(buf, str + off, ret);
+		}
 	}
 
 	return ret;
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index ce76fc382799..07003019263a 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -637,6 +637,7 @@ static void vmbus_process_offer(struct vmbus_channel *newchannel)
 		 */
 		if (newchannel->offermsg.offer.sub_channel_index == 0) {
 			mutex_unlock(&vmbus_connection.channel_mutex);
+			cpus_read_unlock();
 			/*
 			 * Don't call free_channel(), because newchannel->kobj
 			 * is not initialized yet.
diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index bf2a4920638a..a1100e37626e 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -477,9 +477,6 @@ int i2c_dw_prepare_clk(struct dw_i2c_dev *dev, bool prepare)
 {
 	int ret;
 
-	if (IS_ERR(dev->clk))
-		return PTR_ERR(dev->clk);
-
 	if (prepare) {
 		/* Optional interface clock */
 		ret = clk_prepare_enable(dev->pclk);
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 21113665ddea..718bebe4fb87 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -262,8 +262,17 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 		goto exit_reset;
 	}
 
-	dev->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!i2c_dw_prepare_clk(dev, true)) {
+	dev->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(dev->clk)) {
+		ret = PTR_ERR(dev->clk);
+		goto exit_reset;
+	}
+
+	ret = i2c_dw_prepare_clk(dev, true);
+	if (ret)
+		goto exit_reset;
+
+	if (dev->clk) {
 		u64 clk_khz;
 
 		dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 20a2f903b7f6..d9ac62c1ac25 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2369,8 +2369,7 @@ static struct platform_driver npcm_i2c_bus_driver = {
 static int __init npcm_i2c_init(void)
 {
 	npcm_i2c_debugfs_dir = debugfs_create_dir("npcm_i2c", NULL);
-	platform_driver_register(&npcm_i2c_bus_driver);
-	return 0;
+	return platform_driver_register(&npcm_i2c_bus_driver);
 }
 module_init(npcm_i2c_init);
 
diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index cb6ec59a045d..efffcf0ebd3b 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -85,13 +85,13 @@ static const struct dmi_system_id dmi_use_low_level_irq[] = {
 	},
 	{
 		/*
-		 * Lenovo Yoga Tab2 1051L, something messes with the home-button
+		 * Lenovo Yoga Tab2 1051F/1051L, something messes with the home-button
 		 * IRQ settings, leading to a non working home-button.
 		 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "60073"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1051L"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1051"),
 		},
 	},
 	{} /* Terminating entry */
diff --git a/drivers/irqchip/irq-gic-realview.c b/drivers/irqchip/irq-gic-realview.c
index b4c1924f0255..38fab02ffe9d 100644
--- a/drivers/irqchip/irq-gic-realview.c
+++ b/drivers/irqchip/irq-gic-realview.c
@@ -57,6 +57,7 @@ realview_gic_of_init(struct device_node *node, struct device_node *parent)
 
 	/* The PB11MPCore GIC needs to be configured in the syscon */
 	map = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (!IS_ERR(map)) {
 		/* new irq mode with no DCC */
 		regmap_write(map, REALVIEW_SYS_LOCK_OFFSET,
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 1269284461da..fd4fb1b35787 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1864,7 +1864,7 @@ static void __init gic_populate_ppi_partitions(struct device_node *gic_node)
 
 	gic_data.ppi_descs = kcalloc(gic_data.ppi_nr, sizeof(*gic_data.ppi_descs), GFP_KERNEL);
 	if (!gic_data.ppi_descs)
-		return;
+		goto out_put_node;
 
 	nr_parts = of_get_child_count(parts_node);
 
@@ -1905,12 +1905,15 @@ static void __init gic_populate_ppi_partitions(struct device_node *gic_node)
 				continue;
 
 			cpu = of_cpu_node_to_id(cpu_node);
-			if (WARN_ON(cpu < 0))
+			if (WARN_ON(cpu < 0)) {
+				of_node_put(cpu_node);
 				continue;
+			}
 
 			pr_cont("%pOF[%d] ", cpu_node, cpu);
 
 			cpumask_set_cpu(cpu, &part->mask);
+			of_node_put(cpu_node);
 		}
 
 		pr_cont("}\n");
diff --git a/drivers/irqchip/irq-realtek-rtl.c b/drivers/irqchip/irq-realtek-rtl.c
index 50a56820c99b..56bf502d9c67 100644
--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -134,9 +134,9 @@ static int __init map_interrupts(struct device_node *node, struct irq_domain *do
 		if (!cpu_ictl)
 			return -EINVAL;
 		ret = of_property_read_u32(cpu_ictl, "#interrupt-cells", &tmp);
+		of_node_put(cpu_ictl);
 		if (ret || tmp != 1)
 			return -EINVAL;
-		of_node_put(cpu_ictl);
 
 		cpu_int = be32_to_cpup(imap + 2);
 		if (cpu_int > 7 || cpu_int < 2)
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 1ecf75ef276a..ccdd65148498 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -415,8 +415,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	/*
 	 * Work out how many "unsigned long"s we need to hold the bitset.
 	 */
-	bitset_size = dm_round_up(region_count,
-				  sizeof(*lc->clean_bits) << BYTE_SHIFT);
+	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
 	bitset_size >>= BYTE_SHIFT;
 
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index d6cd5537126c..69f9b0336410 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -232,9 +232,9 @@ static int ssc_probe(struct platform_device *pdev)
 	clk_disable_unprepare(ssc->clk);
 
 	ssc->irq = platform_get_irq(pdev, 0);
-	if (!ssc->irq) {
+	if (ssc->irq < 0) {
 		dev_dbg(&pdev->dev, "could not get irq\n");
-		return -ENXIO;
+		return ssc->irq;
 	}
 
 	mutex_lock(&user_lock);
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index cebcca6d6d3e..cf2b8261da14 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -1351,7 +1351,8 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 		if (dev->dev_state != MEI_DEV_INIT_CLIENTS ||
 		    dev->hbm_state != MEI_HBM_CAP_SETUP) {
-			if (dev->dev_state == MEI_DEV_POWER_DOWN) {
+			if (dev->dev_state == MEI_DEV_POWER_DOWN ||
+			    dev->dev_state == MEI_DEV_POWERING_DOWN) {
 				dev_dbg(dev->dev, "hbm: capabilities response: on shutdown, ignoring\n");
 				return 0;
 			}
diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 64ce3f830262..15e8e2b322b1 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -109,6 +109,8 @@
 #define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 #define MEI_DEV_ID_ADP_N      0x54E0  /* Alder Lake Point N */
 
+#define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
+
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a738253dbd05..5324b65d0d29 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -115,6 +115,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 9513cfb5ba58..0ce28bc955a4 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -323,7 +323,6 @@ static void bgmac_remove(struct bcma_device *core)
 	bcma_mdio_mii_unregister(bgmac->mii_bus);
 	bgmac_enet_remove(bgmac);
 	bcma_set_drvdata(core, NULL);
-	kfree(bgmac);
 }
 
 static struct bcma_driver bgmac_bcma_driver = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 892f2f12c54c..15d10775a757 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3194,7 +3194,7 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
 static int hclge_update_port_info(struct hclge_dev *hdev)
 {
 	struct hclge_mac *mac = &hdev->hw.mac;
-	int speed = HCLGE_MAC_SPEED_UNKNOWN;
+	int speed;
 	int ret;
 
 	/* get the port info from SFP cmd if not copper port */
@@ -3205,10 +3205,13 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (!hdev->support_sfp_query)
 		return 0;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		speed = mac->speed;
 		ret = hclge_get_sfp_info(hdev, mac);
-	else
+	} else {
+		speed = HCLGE_MAC_SPEED_UNKNOWN;
 		ret = hclge_get_sfp_speed(hdev, &speed);
+	}
 
 	if (ret == -EOPNOTSUPP) {
 		hdev->support_sfp_query = false;
@@ -3220,6 +3223,8 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		if (mac->speed_type == QUERY_ACTIVE_SPEED) {
 			hclge_update_port_capability(hdev, mac);
+			if (mac->speed != speed)
+				(void)hclge_tm_port_shaper_cfg(hdev);
 			return 0;
 		}
 		return hclge_cfg_mac_speed_dup(hdev, mac->speed,
@@ -3302,6 +3307,12 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
 	link_state_old = vport->vf_info.link_state;
 	vport->vf_info.link_state = link_state;
 
+	/* return success directly if the VF is unalive, VF will
+	 * query link state itself when it starts work.
+	 */
+	if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+		return 0;
+
 	ret = hclge_push_vf_link_status(vport);
 	if (ret) {
 		vport->vf_info.link_state = link_state_old;
@@ -10397,12 +10408,42 @@ static bool hclge_need_update_vlan_filter(const struct hclge_vlan_info *new_cfg,
 	return false;
 }
 
+static int hclge_modify_port_base_vlan_tag(struct hclge_vport *vport,
+					   struct hclge_vlan_info *new_info,
+					   struct hclge_vlan_info *old_info)
+{
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	/* add new VLAN tag */
+	ret = hclge_set_vlan_filter_hw(hdev, htons(new_info->vlan_proto),
+				       vport->vport_id, new_info->vlan_tag,
+				       false);
+	if (ret)
+		return ret;
+
+	vport->port_base_vlan_cfg.tbl_sta = false;
+	/* remove old VLAN tag */
+	if (old_info->vlan_tag == 0)
+		ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
+					       true, 0);
+	else
+		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+					       vport->vport_id,
+					       old_info->vlan_tag, true);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clear vport%u port base vlan %u, ret = %d.\n",
+			vport->vport_id, old_info->vlan_tag, ret);
+
+	return ret;
+}
+
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info)
 {
 	struct hnae3_handle *nic = &vport->nic;
 	struct hclge_vlan_info *old_vlan_info;
-	struct hclge_dev *hdev = vport->back;
 	int ret;
 
 	old_vlan_info = &vport->port_base_vlan_cfg.vlan_info;
@@ -10415,38 +10456,12 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	if (!hclge_need_update_vlan_filter(vlan_info, old_vlan_info))
 		goto out;
 
-	if (state == HNAE3_PORT_BASE_VLAN_MODIFY) {
-		/* add new VLAN tag */
-		ret = hclge_set_vlan_filter_hw(hdev,
-					       htons(vlan_info->vlan_proto),
-					       vport->vport_id,
-					       vlan_info->vlan_tag,
-					       false);
-		if (ret)
-			return ret;
-
-		/* remove old VLAN tag */
-		if (old_vlan_info->vlan_tag == 0)
-			ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
-						       true, 0);
-		else
-			ret = hclge_set_vlan_filter_hw(hdev,
-						       htons(ETH_P_8021Q),
-						       vport->vport_id,
-						       old_vlan_info->vlan_tag,
-						       true);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"failed to clear vport%u port base vlan %u, ret = %d.\n",
-				vport->vport_id, old_vlan_info->vlan_tag, ret);
-			return ret;
-		}
-
-		goto out;
-	}
-
-	ret = hclge_update_vlan_filter_entries(vport, state, vlan_info,
-					       old_vlan_info);
+	if (state == HNAE3_PORT_BASE_VLAN_MODIFY)
+		ret = hclge_modify_port_base_vlan_tag(vport, vlan_info,
+						      old_vlan_info);
+	else
+		ret = hclge_update_vlan_filter_entries(vport, state, vlan_info,
+						       old_vlan_info);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 429652a8cde1..afc47c9b5ec4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -420,7 +420,7 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 {
 	struct hclge_port_shapping_cmd *shap_cfg_cmd;
 	struct hclge_shaper_ir_para ir_para;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 1db7f40b4525..5df18cc3ee55 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -231,6 +231,7 @@ int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
 void hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
+int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev);
 int hclge_tm_get_qset_num(struct hclge_dev *hdev, u16 *qset_num);
 int hclge_tm_get_pri_num(struct hclge_dev *hdev, u8 *pri_num);
 int hclge_tm_get_qset_map_pri(struct hclge_dev *hdev, u16 qset_id, u8 *priority,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 513ba6974355..0e13ce9b4d00 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2576,15 +2576,16 @@ static void i40e_diag_test(struct net_device *netdev,
 
 		set_bit(__I40E_TESTING, pf->state);
 
+		if (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state) ||
+		    test_bit(__I40E_RESET_INTR_RECEIVED, pf->state)) {
+			dev_warn(&pf->pdev->dev,
+				 "Cannot start offline testing when PF is in reset state.\n");
+			goto skip_ol_tests;
+		}
+
 		if (i40e_active_vfs(pf) || i40e_active_vmdqs(pf)) {
 			dev_warn(&pf->pdev->dev,
 				 "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
-			data[I40E_ETH_TEST_REG]		= 1;
-			data[I40E_ETH_TEST_EEPROM]	= 1;
-			data[I40E_ETH_TEST_INTR]	= 1;
-			data[I40E_ETH_TEST_LINK]	= 1;
-			eth_test->flags |= ETH_TEST_FL_FAILED;
-			clear_bit(__I40E_TESTING, pf->state);
 			goto skip_ol_tests;
 		}
 
@@ -2631,9 +2632,17 @@ static void i40e_diag_test(struct net_device *netdev,
 		data[I40E_ETH_TEST_INTR] = 0;
 	}
 
-skip_ol_tests:
-
 	netif_info(pf, drv, netdev, "testing finished\n");
+	return;
+
+skip_ol_tests:
+	data[I40E_ETH_TEST_REG]		= 1;
+	data[I40E_ETH_TEST_EEPROM]	= 1;
+	data[I40E_ETH_TEST_INTR]	= 1;
+	data[I40E_ETH_TEST_LINK]	= 1;
+	eth_test->flags |= ETH_TEST_FL_FAILED;
+	clear_bit(__I40E_TESTING, pf->state);
+	netif_info(pf, drv, netdev, "testing failed\n");
 }
 
 static void i40e_get_wol(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 29387f0814e9..9bc05d671ad5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8523,6 +8523,11 @@ static int i40e_configure_clsflower(struct i40e_vsi *vsi,
 		return -EOPNOTSUPP;
 	}
 
+	if (!tc) {
+		dev_err(&pf->pdev->dev, "Unable to add filter because of invalid destination");
+		return -EINVAL;
+	}
+
 	if (test_bit(__I40E_RESET_RECOVERY_PENDING, pf->state) ||
 	    test_bit(__I40E_RESET_INTR_RECEIVED, pf->state))
 		return -EBUSY;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index babf8b7fa767..6c1e668f4ebf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2282,7 +2282,7 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	if (vf->adq_enabled) {
-		for (i = 0; i < I40E_MAX_VF_VSI; i++)
+		for (i = 0; i < vf->num_tc; i++)
 			num_qps_all += vf->ch[i].num_qps;
 		if (num_qps_all != qci->num_queue_pairs) {
 			aq_ret = I40E_ERR_PARAM;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d2d7160b789c..8601ef26c260 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -820,6 +820,17 @@ static inline bool mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 	return true;
 }
 
+static void *mtk_max_lro_buf_alloc(gfp_t gfp_mask)
+{
+	unsigned int size = mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH);
+	unsigned long data;
+
+	data = __get_free_pages(gfp_mask | __GFP_COMP | __GFP_NOWARN,
+				get_order(size));
+
+	return (void *)data;
+}
+
 /* the qdma core needs scratch memory to be setup */
 static int mtk_init_fq_dma(struct mtk_eth *eth)
 {
@@ -1311,7 +1322,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		new_data = napi_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			new_data = napi_alloc_frag(ring->frag_size);
+		else
+			new_data = mtk_max_lro_buf_alloc(GFP_ATOMIC);
 		if (unlikely(!new_data)) {
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1725,7 +1739,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		else
+			ring->data[i] = mtk_max_lro_buf_alloc(GFP_KERNEL);
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 57d86d47ec2a..0fbb239559f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -435,7 +435,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
-	struct lag_tracker tracker;
+	struct lag_tracker tracker = { };
 	bool do_bond, roce_lag;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
index a68d931090dd..15c8d4de8350 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
@@ -8,8 +8,8 @@
 #include "spectrum.h"
 
 enum mlxsw_sp_counter_sub_pool_id {
-	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 	MLXSW_SP_COUNTER_SUB_POOL_RIF,
+	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 };
 
 int mlxsw_sp_counter_alloc(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index a99aedff795d..ea7309453096 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -388,13 +388,25 @@ static void nfcmrvl_play_deferred(struct nfcmrvl_usb_drv_data *drv_data)
 	int err;
 
 	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		usb_anchor_urb(urb, &drv_data->tx_anchor);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err)
+		if (err) {
+			kfree(urb->setup_packet);
+			usb_unanchor_urb(urb);
+			usb_free_urb(urb);
 			break;
+		}
 
 		drv_data->tx_in_flight++;
+		usb_free_urb(urb);
+	}
+
+	/* Cleanup the rest deferred urbs. */
+	while ((urb = usb_get_from_anchor(&drv_data->deferred))) {
+		kfree(urb->setup_packet);
+		usb_free_urb(urb);
 	}
-	usb_scuttle_anchored_urbs(&drv_data->deferred);
 }
 
 static int nfcmrvl_resume(struct usb_interface *intf)
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af355b9ee5ea..9bc9f6d225bd 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3182,8 +3182,8 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
 	 * we have no UUID set
 	 */
 	if (uuid_is_null(&ids->uuid)) {
-		printk_ratelimited(KERN_WARNING
-				   "No UUID available providing old NGUID\n");
+		dev_warn_ratelimited(dev,
+			"No UUID available providing old NGUID\n");
 		return sysfs_emit(buf, "%pU\n", ids->nguid);
 	}
 	return sysfs_emit(buf, "%pU\n", &ids->uuid);
diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index 8ac149173c64..495da331ca2d 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -17,7 +17,7 @@ menuconfig MIPS_PLATFORM_DEVICES
 if MIPS_PLATFORM_DEVICES
 
 config CPU_HWMON
-	tristate "Loongson-3 CPU HWMon Driver"
+	bool "Loongson-3 CPU HWMon Driver"
 	depends on MACH_LOONGSON64
 	select HWMON
 	default y
diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 658bab4b7964..ebd15c1d13ec 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
@@ -153,6 +154,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z690M AORUS ELITE AX DDR4"),
 	{ }
 };
 
diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index e9e8554147e0..d7d6782c40c2 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -129,6 +129,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x360 Convertible 15-df0xxx"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go"),
+		},
+	},
 	{ }
 };
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..56b8a2d6ffe4 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9791,7 +9791,7 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 					GFP_KERNEL);
 
 		if (!ioa_cfg->hrrq[i].host_rrq)  {
-			while (--i > 0)
+			while (--i >= 0)
 				dma_free_coherent(&pdev->dev,
 					sizeof(u32) * ioa_cfg->hrrq[i].size,
 					ioa_cfg->hrrq[i].host_rrq,
@@ -10064,7 +10064,7 @@ static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
 			ioa_cfg->vectors_info[i].desc,
 			&ioa_cfg->hrrq[i]);
 		if (rc) {
-			while (--i >= 0)
+			while (--i > 0)
 				free_irq(pci_irq_vector(pdev, i),
 					&ioa_cfg->hrrq[i]);
 			return rc;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ce28c4a30460..5f44a0763f37 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2955,18 +2955,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		spin_unlock_irq(&ndlp->lock);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
-		lpfc_els_free_iocb(phba, cmdiocb);
-		lpfc_nlp_put(ndlp);
-
-		/* Presume the node was released. */
-		return;
+		goto out_rsrc_free;
 	}
 
 out:
-	/* Driver is done with the IO.  */
-	lpfc_els_free_iocb(phba, cmdiocb);
-	lpfc_nlp_put(ndlp);
-
 	/* At this point, the LOGO processing is complete. NOTE: For a
 	 * pt2pt topology, we are assuming the NPortID will only change
 	 * on link up processing. For a LOGO / PLOGI initiated by the
@@ -2993,6 +2985,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4], irsp->ulpTimeout,
 				 vport->num_disc_nodes);
+
+		lpfc_els_free_iocb(phba, cmdiocb);
+		lpfc_nlp_put(ndlp);
+
 		lpfc_disc_start(vport);
 		return;
 	}
@@ -3009,6 +3005,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
 	}
+out_rsrc_free:
+	/* Driver is done with the I/O. */
+	lpfc_els_free_iocb(phba, cmdiocb);
+	lpfc_nlp_put(ndlp);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 7359505e6041..824fc8c08840 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4448,6 +4448,9 @@ struct wqe_common {
 #define wqe_sup_SHIFT         6
 #define wqe_sup_MASK          0x00000001
 #define wqe_sup_WORD          word11
+#define wqe_ffrq_SHIFT         6
+#define wqe_ffrq_MASK          0x00000001
+#define wqe_ffrq_WORD          word11
 #define wqe_wqec_SHIFT        7
 #define wqe_wqec_MASK         0x00000001
 #define wqe_wqec_WORD         word11
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index fdf5e777bf11..2bd35a7424c2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -810,7 +810,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_nvmet_invalidate_host(phba, ndlp);
 
 	if (ndlp->nlp_DID == Fabric_DID) {
-		if (vport->port_state <= LPFC_FDISC)
+		if (vport->port_state <= LPFC_FDISC ||
+		    vport->fc_flag & FC_PT2PT)
 			goto out;
 		lpfc_linkdown_port(vport);
 		spin_lock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 66cb66aea2cf..4fb3dc5092f5 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1182,7 +1182,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
-	struct lpfc_iocbq *pwqeq = &(lpfc_ncmd->cur_iocbq);
+	struct nvme_common_command *sqe;
+	struct lpfc_iocbq *pwqeq = &lpfc_ncmd->cur_iocbq;
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t req_len;
 
@@ -1239,8 +1240,14 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		cstat->control_requests++;
 	}
 
-	if (pnode->nlp_nvme_info & NLP_NVME_NSLER)
+	if (pnode->nlp_nvme_info & NLP_NVME_NSLER) {
 		bf_set(wqe_erp, &wqe->generic.wqe_com, 1);
+		sqe = &((struct nvme_fc_cmd_iu *)
+			nCmd->cmdaddr)->sqe.common;
+		if (sqe->opcode == nvme_admin_async_event)
+			bf_set(wqe_ffrq, &wqe->generic.wqe_com, 1);
+	}
+
 	/*
 	 * Finish initializing those WQE fields that are independent
 	 * of the nvme_cmnd request_buffer
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c38e68943205..fafa9fbf3b10 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5381,6 +5381,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
 	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
+	u16 depth;
 	int sz;
 	int rc = 0;
 
@@ -5392,7 +5393,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 		goto out;
 	/* sas iounit page 1 */
 	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData);
-	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
+	sas_iounit_pg1 = kzalloc(sizeof(Mpi2SasIOUnitPage1_t), GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		pr_err("%s: failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -5405,16 +5406,16 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out;
 	}
-	ioc->max_wideport_qd =
-	    (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_narrowport_qd =
-	    (le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_sata_qd = (sas_iounit_pg1->SATAMaxQDepth) ?
-	    sas_iounit_pg1->SATAMaxQDepth : MPT3SAS_SATA_QUEUE_DEPTH;
+
+	depth = le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth);
+	ioc->max_wideport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth = le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth);
+	ioc->max_narrowport_qd = (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth = sas_iounit_pg1->SATAMaxQDepth;
+	ioc->max_sata_qd = (depth ? depth : MPT3SAS_SATA_QUEUE_DEPTH);
+
 	/* pcie iounit page 1 */
 	rc = mpt3sas_config_get_pcie_iounit_pg1(ioc, &mpi_reply,
 	    &pcie_iounit_pg1, sizeof(Mpi26PCIeIOUnitPage1_t));
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bffd9a9349e7..9660c4f4de40 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4526,7 +4526,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	return 0;
 
 out_unwind:
-	while (--i > 0)
+	while (--i >= 0)
 		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 	pci_free_irq_vectors(pdev);
 	return rc;
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 51a82f7803d3..9d16cf925483 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -331,8 +331,8 @@ struct PVSCSIRingReqDesc {
 	u8	tag;
 	u8	bus;
 	u8	target;
-	u8	vcpuHint;
-	u8	unused[59];
+	u16	vcpuHint;
+	u8	unused[58];
 } __packed;
 
 /*
diff --git a/drivers/staging/r8188eu/core/rtw_xmit.c b/drivers/staging/r8188eu/core/rtw_xmit.c
index 0ee4f88a60d4..af13079a6d2c 100644
--- a/drivers/staging/r8188eu/core/rtw_xmit.c
+++ b/drivers/staging/r8188eu/core/rtw_xmit.c
@@ -179,8 +179,7 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 
 	pxmitpriv->free_xmit_extbuf_cnt = num_xmit_extbuf;
 
-	res = rtw_alloc_hwxmits(padapter);
-	if (res) {
+	if (rtw_alloc_hwxmits(padapter)) {
 		res = _FAIL;
 		goto exit;
 	}
@@ -1534,19 +1533,10 @@ int rtw_alloc_hwxmits(struct adapter *padapter)
 
 	hwxmits = pxmitpriv->hwxmits;
 
-	if (pxmitpriv->hwxmit_entry == 5) {
-		hwxmits[0] .sta_queue = &pxmitpriv->bm_pending;
-		hwxmits[1] .sta_queue = &pxmitpriv->vo_pending;
-		hwxmits[2] .sta_queue = &pxmitpriv->vi_pending;
-		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
-		hwxmits[4] .sta_queue = &pxmitpriv->be_pending;
-	} else if (pxmitpriv->hwxmit_entry == 4) {
-		hwxmits[0] .sta_queue = &pxmitpriv->vo_pending;
-		hwxmits[1] .sta_queue = &pxmitpriv->vi_pending;
-		hwxmits[2] .sta_queue = &pxmitpriv->be_pending;
-		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
-	} else {
-	}
+	hwxmits[0].sta_queue = &pxmitpriv->vo_pending;
+	hwxmits[1].sta_queue = &pxmitpriv->vi_pending;
+	hwxmits[2].sta_queue = &pxmitpriv->be_pending;
+	hwxmits[3].sta_queue = &pxmitpriv->bk_pending;
 
 	return 0;
 }
diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
index fbfce4481ffe..ca376f7efd42 100644
--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -465,12 +465,11 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 
 		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, KeyMaterial);
-			pwep = kmalloc(wep_total_len, GFP_KERNEL);
+			wep_total_len = wep_key_len + sizeof(*pwep);
+			pwep = kzalloc(wep_total_len, GFP_KERNEL);
 			if (!pwep)
 				goto exit;
 
-			memset(pwep, 0, wep_total_len);
 			pwep->KeyLength = wep_key_len;
 			pwep->Length = wep_total_len;
 			if (wep_key_len == 13) {
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 0dc9a6a36ce0..0e32920af10d 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -428,7 +428,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 	tty_unregister_device(goldfish_tty_driver, qtty->console.index);
 	iounmap(qtty->base);
 	qtty->base = NULL;
-	free_irq(qtty->irq, pdev);
+	free_irq(qtty->irq, qtty);
 	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index a246f429ffb7..6734ef22c304 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -454,7 +454,7 @@ static void gsm_hex_dump_bytes(const char *fname, const u8 *data,
 		return;
 	}
 
-	prefix = kasprintf(GFP_KERNEL, "%s: ", fname);
+	prefix = kasprintf(GFP_ATOMIC, "%s: ", fname);
 	if (!prefix)
 		return;
 	print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_OFFSET, 16, 1, data, len,
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 2285ef947755..df9731f73746 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1535,6 +1535,8 @@ static inline void __stop_tx(struct uart_8250_port *p)
 
 	if (em485) {
 		unsigned char lsr = serial_in(p, UART_LSR);
+		p->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+
 		/*
 		 * To provide required timeing and allow FIFO transfer,
 		 * __stop_tx_rs485() must be called only when both FIFO and
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index e45c3d6e1536..794e413800ae 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1941,13 +1941,16 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		}
 
 		if (enqd_len + trb_buff_len >= full_len) {
-			if (need_zero_pkt)
-				zero_len_trb = !zero_len_trb;
-
-			field &= ~TRB_CHAIN;
-			field |= TRB_IOC;
-			more_trbs_coming = false;
-			preq->td.last_trb = ring->enqueue;
+			if (need_zero_pkt && !zero_len_trb) {
+				zero_len_trb = true;
+			} else {
+				zero_len_trb = false;
+				field &= ~TRB_CHAIN;
+				field |= TRB_IOC;
+				more_trbs_coming = false;
+				need_zero_pkt = false;
+				preq->td.last_trb = ring->enqueue;
+			}
 		}
 
 		/* Only set interrupt on short packet for OUT endpoints. */
@@ -1962,7 +1965,7 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
 
-		cdnsp_queue_trb(pdev, ring, more_trbs_coming | zero_len_trb,
+		cdnsp_queue_trb(pdev, ring, more_trbs_coming,
 				lower_32_bits(send_addr),
 				upper_32_bits(send_addr),
 				length_field,
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 657dbd50faf1..82322696b903 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5194,7 +5194,7 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		retval = -EINVAL;
-		goto error1;
+		goto error2;
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 02f70c5c65fc..adc44a2685b5 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -122,8 +122,6 @@ struct ffs_ep {
 	struct usb_endpoint_descriptor	*descs[3];
 
 	u8				num;
-
-	int				status;	/* P: epfile->mutex */
 };
 
 struct ffs_epfile {
@@ -227,6 +225,9 @@ struct ffs_io_data {
 	bool use_sg;
 
 	struct ffs_data *ffs;
+
+	int status;
+	struct completion done;
 };
 
 struct ffs_desc_helper {
@@ -707,12 +708,15 @@ static const struct file_operations ffs_ep0_operations = {
 
 static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
 {
+	struct ffs_io_data *io_data = req->context;
+
 	ENTER();
-	if (req->context) {
-		struct ffs_ep *ep = _ep->driver_data;
-		ep->status = req->status ? req->status : req->actual;
-		complete(req->context);
-	}
+	if (req->status)
+		io_data->status = req->status;
+	else
+		io_data->status = req->actual;
+
+	complete(&io_data->done);
 }
 
 static ssize_t ffs_copy_to_iter(void *data, int data_len, struct iov_iter *iter)
@@ -1050,7 +1054,6 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		WARN(1, "%s: data_len == -EINVAL\n", __func__);
 		ret = -EINVAL;
 	} else if (!io_data->aio) {
-		DECLARE_COMPLETION_ONSTACK(done);
 		bool interrupted = false;
 
 		req = ep->req;
@@ -1066,7 +1069,8 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 		io_data->buf = data;
 
-		req->context  = &done;
+		init_completion(&io_data->done);
+		req->context  = io_data;
 		req->complete = ffs_epfile_io_complete;
 
 		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
@@ -1075,7 +1079,12 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 		spin_unlock_irq(&epfile->ffs->eps_lock);
 
-		if (wait_for_completion_interruptible(&done)) {
+		if (wait_for_completion_interruptible(&io_data->done)) {
+			spin_lock_irq(&epfile->ffs->eps_lock);
+			if (epfile->ep != ep) {
+				ret = -ESHUTDOWN;
+				goto error_lock;
+			}
 			/*
 			 * To avoid race condition with ffs_epfile_io_complete,
 			 * dequeue the request first then check
@@ -1083,17 +1092,18 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			 * condition with req->complete callback.
 			 */
 			usb_ep_dequeue(ep->ep, req);
-			wait_for_completion(&done);
-			interrupted = ep->status < 0;
+			spin_unlock_irq(&epfile->ffs->eps_lock);
+			wait_for_completion(&io_data->done);
+			interrupted = io_data->status < 0;
 		}
 
 		if (interrupted)
 			ret = -EINTR;
-		else if (io_data->read && ep->status > 0)
-			ret = __ffs_epfile_read_data(epfile, data, ep->status,
+		else if (io_data->read && io_data->status > 0)
+			ret = __ffs_epfile_read_data(epfile, data, io_data->status,
 						     &io_data->data);
 		else
-			ret = ep->status;
+			ret = io_data->status;
 		goto error_mutex;
 	} else if (!(req = usb_ep_alloc_request(ep->ep, GFP_ATOMIC))) {
 		ret = -ENOMEM;
diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index a25d01c89564..865de8db998a 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3014,6 +3014,7 @@ static int lpc32xx_udc_probe(struct platform_device *pdev)
 	}
 
 	udc->isp1301_i2c_client = isp1301_get_client(isp1301_node);
+	of_node_put(isp1301_node);
 	if (!udc->isp1301_i2c_client) {
 		return -EPROBE_DEFER;
 	}
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index a7b3c15957ba..feba2a8d1233 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -166,6 +166,7 @@ static const struct usb_device_id edgeport_2port_id_table[] = {
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_8S) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416B) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_E5805A) },
 	{ }
 };
 
@@ -204,6 +205,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_8S) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416B) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_E5805A) },
 	{ }
 };
 
diff --git a/drivers/usb/serial/io_usbvend.h b/drivers/usb/serial/io_usbvend.h
index 52cbc353051f..9a6f742ad3ab 100644
--- a/drivers/usb/serial/io_usbvend.h
+++ b/drivers/usb/serial/io_usbvend.h
@@ -212,6 +212,7 @@
 //
 // Definitions for other product IDs
 #define ION_DEVICE_ID_MT4X56USB			0x1403	// OEM device
+#define ION_DEVICE_ID_E5805A			0x1A01  // OEM device (rebranded Edgeport/4)
 
 
 #define	GENERATION_ID_FROM_USB_PRODUCT_ID(ProductId)				\
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e60425bbf537..ed1e50d83cca 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -432,6 +432,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_CLS8			0x00b0
 #define CINTERION_PRODUCT_MV31_MBIM		0x00b3
 #define CINTERION_PRODUCT_MV31_RMNET		0x00b7
+#define CINTERION_PRODUCT_MV31_2_MBIM		0x00b8
+#define CINTERION_PRODUCT_MV31_2_RMNET		0x00b9
 #define CINTERION_PRODUCT_MV32_WA		0x00f1
 #define CINTERION_PRODUCT_MV32_WB		0x00f2
 
@@ -1979,6 +1981,10 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(3)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_RMNET, 0xff),
 	  .driver_info = RSVD(0)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_2_MBIM, 0xff),
+	  .driver_info = RSVD(3)},
+	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV31_2_RMNET, 0xff),
+	  .driver_info = RSVD(0)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WA, 0xff),
 	  .driver_info = RSVD(3)},
 	{ USB_DEVICE_INTERFACE_CLASS(CINTERION_VENDOR_ID, CINTERION_PRODUCT_MV32_WB, 0xff),
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 56128b9c46eb..1dd396d4bebb 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -688,6 +688,7 @@ static int vm_cmdline_set(const char *device,
 	if (!vm_cmdline_parent_registered) {
 		err = device_register(&vm_cmdline_parent);
 		if (err) {
+			put_device(&vm_cmdline_parent);
 			pr_err("Failed to register parent device!\n");
 			return err;
 		}
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index b35bb2d57f62..1e890ef17687 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -254,8 +254,7 @@ void vp_del_vqs(struct virtio_device *vdev)
 
 	if (vp_dev->msix_affinity_masks) {
 		for (i = 0; i < vp_dev->msix_vectors; i++)
-			if (vp_dev->msix_affinity_masks[i])
-				free_cpumask_var(vp_dev->msix_affinity_masks[i]);
+			free_cpumask_var(vp_dev->msix_affinity_masks[i]);
 	}
 
 	if (vp_dev->msix_enabled) {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 20ac3c74b51d..ad78bddfb637 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4099,6 +4099,15 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	size = size >> bsbits;
 	start = start_off >> bsbits;
 
+	/*
+	 * For tiny groups (smaller than 8MB) the chosen allocation
+	 * alignment may be larger than group size. Make sure the
+	 * alignment does not move allocation to a different group which
+	 * makes mballoc fail assertions later.
+	 */
+	start = max(start, rounddown(ac->ac_o_ex.fe_logical,
+			(ext4_lblk_t)EXT4_BLOCKS_PER_GROUP(ac->ac_sb)));
+
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
 		size -= ar->lleft + 1 - start;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 7c286cd9fe03..871eebf12bf4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1929,7 +1929,8 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
-	unsigned count, continued;
+	unsigned continued;
+	int count;
 	struct buffer_head *bh2;
 	ext4_lblk_t newblock;
 	u32 hash2;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index b63cb88ccdae..56c9ef0687fc 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -52,6 +52,16 @@ int ext4_resize_begin(struct super_block *sb)
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	/*
+	 * If the reserved GDT blocks is non-zero, the resize_inode feature
+	 * should always be set.
+	 */
+	if (EXT4_SB(sb)->s_es->s_reserved_gdt_blocks &&
+	    !ext4_has_feature_resize_inode(sb)) {
+		ext4_error(sb, "resize_inode disabled but reserved GDT blocks non-zero");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * If we are not using the primary superblock/GDT copy don't resize,
          * because the user tools have no way of handling this.  Probably a
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 91b83749ee11..3c39c88582f5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4909,14 +4909,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
-	/*
-	 * Update the checksum after updating free space/inode
-	 * counters.  Otherwise the superblock can have an incorrect
-	 * checksum in the buffer cache until it is written out and
-	 * e2fsprogs programs trying to open a file system immediately
-	 * after it is mounted can fail.
-	 */
-	ext4_superblock_csum_set(sb);
 	if (!err)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 					  ext4_count_dirs(sb), GFP_KERNEL);
@@ -4974,6 +4966,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
+	/*
+	 * Update the checksum after updating free space/inode counters and
+	 * ext4_orphan_cleanup. Otherwise the superblock can have an incorrect
+	 * checksum in the buffer cache until it is written out and
+	 * e2fsprogs programs trying to open a file system immediately
+	 * after it is mounted can fail.
+	 */
+	ext4_superblock_csum_set(sb);
 	if (needs_recovery) {
 		ext4_msg(sb, KERN_INFO, "recovery complete");
 		err = ext4_mark_recovery_complete(sb, es);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index b8e6398d9430..be2176575353 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7933,11 +7933,19 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
+	unsigned nr = ctx->nr_user_files;
 	int ret;
 
 	if (!ctx->file_data)
 		return -ENXIO;
+
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_files = 0;
 	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
+	ctx->nr_user_files = nr;
 	if (!ret)
 		__io_sqe_files_unregister(ctx);
 	return ret;
@@ -8897,12 +8905,19 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
+	unsigned nr = ctx->nr_user_bufs;
 	int ret;
 
 	if (!ctx->buf_data)
 		return -ENXIO;
 
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_bufs = 0;
 	ret = io_rsrc_ref_quiesce(ctx->buf_data, ctx);
+	ctx->nr_user_bufs = nr;
 	if (!ret)
 		__io_sqe_buffers_unregister(ctx);
 	return ret;
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index a30dd35ec1c2..ccf313238441 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -288,6 +288,7 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 		rv = NFS4_OK;
 		break;
 	case -ENOENT:
+		set_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags);
 		/* Embrace your forgetfulness! */
 		rv = NFS4ERR_NOMATCHING_LAYOUT;
 
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 1b4dd8b828de..7217f3eeb069 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -469,6 +469,7 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 		pnfs_clear_lseg_state(lseg, lseg_list);
 	pnfs_clear_layoutreturn_info(lo);
 	pnfs_free_returned_lsegs(lo, lseg_list, &range, 0);
+	set_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags);
 	if (test_bit(NFS_LAYOUT_RETURN, &lo->plh_flags) &&
 	    !test_and_set_bit(NFS_LAYOUT_RETURN_LOCK, &lo->plh_flags))
 		pnfs_clear_layoutreturn_waitbit(lo);
@@ -1917,8 +1918,9 @@ static void nfs_layoutget_begin(struct pnfs_layout_hdr *lo)
 
 static void nfs_layoutget_end(struct pnfs_layout_hdr *lo)
 {
-	if (atomic_dec_and_test(&lo->plh_outstanding))
-		wake_up_var(&lo->plh_outstanding);
+	if (atomic_dec_and_test(&lo->plh_outstanding) &&
+	    test_and_clear_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags))
+		wake_up_bit(&lo->plh_flags, NFS_LAYOUT_DRAIN);
 }
 
 static bool pnfs_is_first_layoutget(struct pnfs_layout_hdr *lo)
@@ -2025,11 +2027,11 @@ pnfs_update_layout(struct inode *ino,
 	 * If the layout segment list is empty, but there are outstanding
 	 * layoutget calls, then they might be subject to a layoutrecall.
 	 */
-	if ((list_empty(&lo->plh_segs) || !pnfs_layout_is_valid(lo)) &&
+	if (test_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags) &&
 	    atomic_read(&lo->plh_outstanding) != 0) {
 		spin_unlock(&ino->i_lock);
-		lseg = ERR_PTR(wait_var_event_killable(&lo->plh_outstanding,
-					!atomic_read(&lo->plh_outstanding)));
+		lseg = ERR_PTR(wait_on_bit(&lo->plh_flags, NFS_LAYOUT_DRAIN,
+					   TASK_KILLABLE));
 		if (IS_ERR(lseg))
 			goto out_put_layout_hdr;
 		pnfs_put_layout_hdr(lo);
@@ -2152,6 +2154,12 @@ pnfs_update_layout(struct inode *ino,
 		case -ERECALLCONFLICT:
 		case -EAGAIN:
 			break;
+		case -ENODATA:
+			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+			pnfs_layout_set_fail_bit(
+				lo, pnfs_iomode_to_fail_bit(iomode));
+			lseg = NULL;
+			goto out_put_layout_hdr;
 		default:
 			if (!nfs_error_is_fatal(PTR_ERR(lseg))) {
 				pnfs_layout_clear_fail_bit(lo, pnfs_iomode_to_fail_bit(iomode));
@@ -2407,7 +2415,8 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 		goto out_forget;
 	}
 
-	if (!pnfs_layout_is_valid(lo) && !pnfs_is_first_layoutget(lo))
+	if (test_bit(NFS_LAYOUT_DRAIN, &lo->plh_flags) &&
+	    !pnfs_is_first_layoutget(lo))
 		goto out_forget;
 
 	if (nfs4_stateid_match_other(&lo->plh_stateid, &res->stateid)) {
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 5a54cf8ac6f3..3307361c7956 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -109,6 +109,7 @@ enum {
 	NFS_LAYOUT_FIRST_LAYOUTGET,	/* Serialize first layoutget */
 	NFS_LAYOUT_INODE_FREEING,	/* The inode is being freed */
 	NFS_LAYOUT_HASHED,		/* The layout visible */
+	NFS_LAYOUT_DRAIN,
 };
 
 enum layoutdriver_policy_flags {
diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7e23c588f484..87d984e0cdc0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -194,7 +194,6 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 				__set_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
 		}
 		nf->nf_mark = NULL;
-		init_rwsem(&nf->nf_rwsem);
 		trace_nfsd_file_alloc(nf);
 	}
 	return nf;
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 7872df5a0fe3..435ceab27897 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -46,7 +46,6 @@ struct nfsd_file {
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
-	struct rw_semaphore	nf_rwsem;
 };
 
 int nfsd_file_cache_init(void);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 65200910107f..f7584787dab2 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1515,6 +1515,9 @@ static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
 
 static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 {
+	struct file *dst = copy->nf_dst->nf_file;
+	struct file *src = copy->nf_src->nf_file;
+	errseq_t since;
 	ssize_t bytes_copied = 0;
 	u64 bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
@@ -1527,9 +1530,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	do {
 		if (kthread_should_stop())
 			break;
-		bytes_copied = nfsd_copy_file_range(copy->nf_src->nf_file,
-				src_pos, copy->nf_dst->nf_file, dst_pos,
-				bytes_total);
+		bytes_copied = nfsd_copy_file_range(src, src_pos, dst, dst_pos,
+						    bytes_total);
 		if (bytes_copied <= 0)
 			break;
 		bytes_total -= bytes_copied;
@@ -1539,11 +1541,11 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	} while (bytes_total > 0 && !copy->cp_synchronous);
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (!copy->cp_synchronous && copy->cp_res.wr_bytes_written > 0) {
-		down_write(&copy->nf_dst->nf_rwsem);
-		status = vfs_fsync_range(copy->nf_dst->nf_file,
-					 copy->cp_dst_pos,
+		since = READ_ONCE(dst->f_wb_err);
+		status = vfs_fsync_range(dst, copy->cp_dst_pos,
 					 copy->cp_res.wr_bytes_written, 0);
-		up_write(&copy->nf_dst->nf_rwsem);
+		if (!status)
+			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
 			copy->committed = true;
 	}
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 271f7c15d6e5..7bfb68583154 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -525,10 +525,11 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 {
 	struct file *src = nf_src->nf_file;
 	struct file *dst = nf_dst->nf_file;
+	errseq_t since;
 	loff_t cloned;
 	__be32 ret = 0;
 
-	down_write(&nf_dst->nf_rwsem);
+	since = READ_ONCE(dst->f_wb_err);
 	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count, 0);
 	if (cloned < 0) {
 		ret = nfserrno(cloned);
@@ -542,6 +543,8 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 		loff_t dst_end = count ? dst_pos + count - 1 : LLONG_MAX;
 		int status = vfs_fsync_range(dst, dst_pos, dst_end, 0);
 
+		if (!status)
+			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
 			status = commit_inode_metadata(file_inode(src));
 		if (status < 0) {
@@ -551,7 +554,6 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 		}
 	}
 out_err:
-	up_write(&nf_dst->nf_rwsem);
 	return ret;
 }
 
@@ -954,6 +956,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	struct super_block	*sb = file_inode(file)->i_sb;
 	struct svc_export	*exp;
 	struct iov_iter		iter;
+	errseq_t		since;
 	__be32			nfserr;
 	int			host_err;
 	int			use_wgather;
@@ -991,8 +994,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 		flags |= RWF_SYNC;
 
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
+	since = READ_ONCE(file->f_wb_err);
 	if (flags & RWF_SYNC) {
-		down_write(&nf->nf_rwsem);
 		if (verf)
 			nfsd_copy_boot_verifier(verf,
 					net_generic(SVC_NET(rqstp),
@@ -1001,15 +1004,12 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 		if (host_err < 0)
 			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
 						 nfsd_net_id));
-		up_write(&nf->nf_rwsem);
 	} else {
-		down_read(&nf->nf_rwsem);
 		if (verf)
 			nfsd_copy_boot_verifier(verf,
 					net_generic(SVC_NET(rqstp),
 					nfsd_net_id));
 		host_err = vfs_iter_write(file, &iter, &pos, flags);
-		up_read(&nf->nf_rwsem);
 	}
 	if (host_err < 0) {
 		nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
@@ -1019,6 +1019,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	*cnt = host_err;
 	nfsd_stats_io_write_add(exp, *cnt);
 	fsnotify_modify(file);
+	host_err = filemap_check_wb_err(file->f_mapping, since);
+	if (host_err < 0)
+		goto out_nfserr;
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
@@ -1099,19 +1102,6 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
 }
 
 #ifdef CONFIG_NFSD_V3
-static int
-nfsd_filemap_write_and_wait_range(struct nfsd_file *nf, loff_t offset,
-				  loff_t end)
-{
-	struct address_space *mapping = nf->nf_file->f_mapping;
-	int ret = filemap_fdatawrite_range(mapping, offset, end);
-
-	if (ret)
-		return ret;
-	filemap_fdatawait_range_keep_errors(mapping, offset, end);
-	return 0;
-}
-
 /*
  * Commit all pending writes to stable storage.
  *
@@ -1142,25 +1132,25 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (err)
 		goto out;
 	if (EX_ISSYNC(fhp->fh_export)) {
-		int err2 = nfsd_filemap_write_and_wait_range(nf, offset, end);
+		errseq_t since = READ_ONCE(nf->nf_file->f_wb_err);
+		int err2;
 
-		down_write(&nf->nf_rwsem);
-		if (!err2)
-			err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
+		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
 		switch (err2) {
 		case 0:
 			nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
 						nfsd_net_id));
+			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
+						    since);
 			break;
 		case -EINVAL:
 			err = nfserr_notsupp;
 			break;
 		default:
-			err = nfserrno(err2);
 			nfsd_reset_boot_verifier(net_generic(nf->nf_net,
 						 nfsd_net_id));
 		}
-		up_write(&nf->nf_rwsem);
+		err = nfserrno(err2);
 	} else
 		nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
 					nfsd_net_id));
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a74aef99bd3d..09d1307959d0 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -79,6 +79,7 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
+#include <linux/sched/mm.h>
 #include "../internal.h" /* ugh */
 
 #include <linux/uaccess.h>
@@ -425,9 +426,11 @@ EXPORT_SYMBOL(mark_info_dirty);
 int dquot_acquire(struct dquot *dquot)
 {
 	int ret = 0, ret2 = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
 		ret = dqopt->ops[dquot->dq_id.type]->read_dqblk(dquot);
 		if (ret < 0)
@@ -458,6 +461,7 @@ int dquot_acquire(struct dquot *dquot)
 	smp_mb__before_atomic();
 	set_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_iolock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
@@ -469,9 +473,11 @@ EXPORT_SYMBOL(dquot_acquire);
 int dquot_commit(struct dquot *dquot)
 {
 	int ret = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	if (!clear_dquot_dirty(dquot))
 		goto out_lock;
 	/* Inactive dquot can be only if there was error during read/init
@@ -481,6 +487,7 @@ int dquot_commit(struct dquot *dquot)
 	else
 		ret = -EIO;
 out_lock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
@@ -492,9 +499,11 @@ EXPORT_SYMBOL(dquot_commit);
 int dquot_release(struct dquot *dquot)
 {
 	int ret = 0, ret2 = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	/* Check whether we are not racing with some other dqget() */
 	if (dquot_is_busy(dquot))
 		goto out_dqlock;
@@ -510,6 +519,7 @@ int dquot_release(struct dquot *dquot)
 	}
 	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_dqlock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index ac7f231b8825..eed9a98eae0d 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -121,6 +121,8 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 
 extern struct backing_dev_info noop_backing_dev_info;
 
+int bdi_init(struct backing_dev_info *bdi);
+
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @wb: bdi_writeback of interest
diff --git a/kernel/cfi.c b/kernel/cfi.c
index 9594cfd1cf2c..08102d19ec15 100644
--- a/kernel/cfi.c
+++ b/kernel/cfi.c
@@ -281,6 +281,8 @@ static inline cfi_check_fn find_module_check_fn(unsigned long ptr)
 static inline cfi_check_fn find_check_fn(unsigned long ptr)
 {
 	cfi_check_fn fn = NULL;
+	unsigned long flags;
+	bool rcu_idle;
 
 	if (is_kernel_text(ptr))
 		return __cfi_check;
@@ -290,13 +292,21 @@ static inline cfi_check_fn find_check_fn(unsigned long ptr)
 	 * the shadow and __module_address use RCU, so we need to wake it
 	 * up if necessary.
 	 */
-	RCU_NONIDLE({
-		if (IS_ENABLED(CONFIG_CFI_CLANG_SHADOW))
-			fn = find_shadow_check_fn(ptr);
+	rcu_idle = !rcu_is_watching();
+	if (rcu_idle) {
+		local_irq_save(flags);
+		rcu_irq_enter();
+	}
+
+	if (IS_ENABLED(CONFIG_CFI_CLANG_SHADOW))
+		fn = find_shadow_check_fn(ptr);
+	if (!fn)
+		fn = find_module_check_fn(ptr);
 
-		if (!fn)
-			fn = find_module_check_fn(ptr);
-	});
+	if (rcu_idle) {
+		rcu_irq_exit();
+		local_irq_restore(flags);
+	}
 
 	return fn;
 }
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index ac740630c79c..2caafd13f8aa 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -564,7 +564,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 
 	rc = active_cacheline_insert(entry);
 	if (rc == -ENOMEM) {
-		pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
+		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
 		err_printk(entry->dev, entry,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 838623b68031..b89ca5c83143 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4630,25 +4630,55 @@ static void do_balance_callbacks(struct rq *rq, struct callback_head *head)
 
 static void balance_push(struct rq *rq);
 
+/*
+ * balance_push_callback is a right abuse of the callback interface and plays
+ * by significantly different rules.
+ *
+ * Where the normal balance_callback's purpose is to be ran in the same context
+ * that queued it (only later, when it's safe to drop rq->lock again),
+ * balance_push_callback is specifically targeted at __schedule().
+ *
+ * This abuse is tolerated because it places all the unlikely/odd cases behind
+ * a single test, namely: rq->balance_callback == NULL.
+ */
 struct callback_head balance_push_callback = {
 	.next = NULL,
 	.func = (void (*)(struct callback_head *))balance_push,
 };
 
-static inline struct callback_head *splice_balance_callbacks(struct rq *rq)
+static inline struct callback_head *
+__splice_balance_callbacks(struct rq *rq, bool split)
 {
 	struct callback_head *head = rq->balance_callback;
 
+	if (likely(!head))
+		return NULL;
+
 	lockdep_assert_rq_held(rq);
-	if (head)
+	/*
+	 * Must not take balance_push_callback off the list when
+	 * splice_balance_callbacks() and balance_callbacks() are not
+	 * in the same rq->lock section.
+	 *
+	 * In that case it would be possible for __schedule() to interleave
+	 * and observe the list empty.
+	 */
+	if (split && head == &balance_push_callback)
+		head = NULL;
+	else
 		rq->balance_callback = NULL;
 
 	return head;
 }
 
+static inline struct callback_head *splice_balance_callbacks(struct rq *rq)
+{
+	return __splice_balance_callbacks(rq, true);
+}
+
 static void __balance_callbacks(struct rq *rq)
 {
-	do_balance_callbacks(rq, splice_balance_callbacks(rq));
+	do_balance_callbacks(rq, __splice_balance_callbacks(rq, false));
 }
 
 static inline void balance_callbacks(struct rq *rq, struct callback_head *head)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f386c6c2b198..fe8be2f8a47d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1718,6 +1718,11 @@ queue_balance_callback(struct rq *rq,
 {
 	lockdep_assert_rq_held(rq);
 
+	/*
+	 * Don't (re)queue an already queued item; nor queue anything when
+	 * balance_push() is active, see the comment with
+	 * balance_push_callback.
+	 */
 	if (unlikely(head->next || rq->balance_callback == &balance_push_callback))
 		return;
 
diff --git a/lib/Kconfig b/lib/Kconfig
index e052f843afed..baa977e003b7 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -123,6 +123,9 @@ config INDIRECT_IOMEM_FALLBACK
 
 source "lib/crypto/Kconfig"
 
+config LIB_MEMNEQ
+	bool
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 6cf97c60b00b..0868cb67e5b0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -249,6 +249,7 @@ obj-$(CONFIG_DIMLIB) += dim/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
 lib-$(CONFIG_CLZ_TAB) += clz_tab.o
+lib-$(CONFIG_LIB_MEMNEQ) += memneq.o
 
 obj-$(CONFIG_GENERIC_STRNCPY_FROM_USER) += strncpy_from_user.o
 obj-$(CONFIG_GENERIC_STRNLEN_USER) += strnlen_user.o
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index e8e525650cf2..5056663c2aff 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -71,6 +71,7 @@ config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
+	select LIB_MEMNEQ
 	help
 	  Enable the Curve25519 library interface. This interface may be
 	  fulfilled by either the generic implementation or an arch-specific
diff --git a/lib/memneq.c b/lib/memneq.c
new file mode 100644
index 000000000000..afed1bd16aee
--- /dev/null
+++ b/lib/memneq.c
@@ -0,0 +1,168 @@
+/*
+ * Constant-time equality testing of memory regions.
+ *
+ * Authors:
+ *
+ *   James Yonan <james@openvpn.net>
+ *   Daniel Borkmann <dborkman@redhat.com>
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of OpenVPN Technologies nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <crypto/algapi.h>
+
+#ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
+
+/* Generic path for arbitrary size */
+static inline unsigned long
+__crypto_memneq_generic(const void *a, const void *b, size_t size)
+{
+	unsigned long neq = 0;
+
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	while (size >= sizeof(unsigned long)) {
+		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
+		OPTIMIZER_HIDE_VAR(neq);
+		a += sizeof(unsigned long);
+		b += sizeof(unsigned long);
+		size -= sizeof(unsigned long);
+	}
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	while (size > 0) {
+		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
+		OPTIMIZER_HIDE_VAR(neq);
+		a += 1;
+		b += 1;
+		size -= 1;
+	}
+	return neq;
+}
+
+/* Loop-free fast-path for frequently used 16-byte size */
+static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
+{
+	unsigned long neq = 0;
+
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (sizeof(unsigned long) == 8) {
+		neq |= *(unsigned long *)(a)   ^ *(unsigned long *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+	} else if (sizeof(unsigned int) == 4) {
+		neq |= *(unsigned int *)(a)    ^ *(unsigned int *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
+		OPTIMIZER_HIDE_VAR(neq);
+	} else
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	{
+		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
+		OPTIMIZER_HIDE_VAR(neq);
+	}
+
+	return neq;
+}
+
+/* Compare two areas of memory without leaking timing information,
+ * and with special optimizations for common sizes.  Users should
+ * not call this function directly, but should instead use
+ * crypto_memneq defined in crypto/algapi.h.
+ */
+noinline unsigned long __crypto_memneq(const void *a, const void *b,
+				       size_t size)
+{
+	switch (size) {
+	case 16:
+		return __crypto_memneq_16(a, b);
+	default:
+		return __crypto_memneq_generic(a, b, size);
+	}
+}
+EXPORT_SYMBOL(__crypto_memneq);
+
+#endif /* __HAVE_ARCH_CRYPTO_MEMNEQ */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 02ff66f86358..02c9d5c7276e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -229,20 +229,13 @@ static __init int bdi_class_init(void)
 }
 postcore_initcall(bdi_class_init);
 
-static int bdi_init(struct backing_dev_info *bdi);
-
 static int __init default_bdi_init(void)
 {
-	int err;
-
 	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_UNBOUND |
 				 WQ_SYSFS, 0);
 	if (!bdi_wq)
 		return -ENOMEM;
-
-	err = bdi_init(&noop_backing_dev_info);
-
-	return err;
+	return 0;
 }
 subsys_initcall(default_bdi_init);
 
@@ -784,7 +777,7 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-static int bdi_init(struct backing_dev_info *bdi)
+int bdi_init(struct backing_dev_info *bdi)
 {
 	int ret;
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 7b69503dc46a..f99ed1eddf5e 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1654,9 +1654,12 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			int flags)
 {
 	struct sock *sk = sock->sk;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *last;
+	struct sk_buff_head *sk_queue;
 	int copied;
 	int err = 0;
+	int off = 0;
+	long timeo;
 
 	lock_sock(sk);
 	/*
@@ -1668,11 +1671,29 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		goto out;
 	}
 
-	/* Now we can treat all alike */
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &err);
-	if (skb == NULL)
-		goto out;
+	/*  We need support for non-blocking reads. */
+	sk_queue = &sk->sk_receive_queue;
+	skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off, &err, &last);
+	/* If no packet is available, release_sock(sk) and try again. */
+	if (!skb) {
+		if (err != -EAGAIN)
+			goto out;
+		release_sock(sk);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+		while (timeo && !__skb_wait_for_more_packets(sk, sk_queue, &err,
+							     &timeo, last)) {
+			skb = __skb_try_recv_datagram(sk, sk_queue, flags, &off,
+						      &err, &last);
+			if (skb)
+				break;
+
+			if (err != -EAGAIN)
+				goto done;
+		}
+		if (!skb)
+			goto done;
+		lock_sock(sk);
+	}
 
 	if (!sk_to_ax25(sk)->pidincl)
 		skb_pull(skb, 1);		/* Remove PID */
@@ -1719,6 +1740,7 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 out:
 	release_sock(sk);
 
+done:
 	return err;
 }
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 96f975777438..d54dbd01d86f 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -502,14 +502,15 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	int transhdrlen = 4; /* zero session-id */
-	int ulen = len + transhdrlen;
+	int ulen;
 	int err;
 
 	/* Rough check on arithmetic overflow,
 	 * better check is made in ip6_append_data().
 	 */
-	if (len > INT_MAX)
+	if (len > INT_MAX - transhdrlen)
 		return -EMSGSIZE;
+	ulen = len + transhdrlen;
 
 	/* Mirror BSD error message compatibility */
 	if (msg->msg_flags & MSG_OOB)
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 0a0818e55879..6a035e9339d2 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -651,6 +651,7 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	new->cl_discrtry = clnt->cl_discrtry;
 	new->cl_chatty = clnt->cl_chatty;
 	new->cl_principal = clnt->cl_principal;
+	new->cl_max_connect = clnt->cl_max_connect;
 	return new;
 
 out_err:
diff --git a/scripts/faddr2line b/scripts/faddr2line
index 0e6268d59883..94ed98dd899f 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -95,17 +95,25 @@ __faddr2line() {
 	local print_warnings=$4
 
 	local sym_name=${func_addr%+*}
-	local offset=${func_addr#*+}
-	offset=${offset%/*}
+	local func_offset=${func_addr#*+}
+	func_offset=${func_offset%/*}
 	local user_size=
+	local file_type
+	local is_vmlinux=0
 	[[ $func_addr =~ "/" ]] && user_size=${func_addr#*/}
 
-	if [[ -z $sym_name ]] || [[ -z $offset ]] || [[ $sym_name = $func_addr ]]; then
+	if [[ -z $sym_name ]] || [[ -z $func_offset ]] || [[ $sym_name = $func_addr ]]; then
 		warn "bad func+offset $func_addr"
 		DONE=1
 		return
 	fi
 
+	# vmlinux uses absolute addresses in the section table rather than
+	# section offsets.
+	local file_type=$(${READELF} --file-header $objfile |
+		${AWK} '$1 == "Type:" { print $2; exit }')
+	[[ $file_type = "EXEC" ]] && is_vmlinux=1
+
 	# Go through each of the object's symbols which match the func name.
 	# In rare cases there might be duplicates, in which case we print all
 	# matches.
@@ -114,9 +122,11 @@ __faddr2line() {
 		local sym_addr=0x${fields[1]}
 		local sym_elf_size=${fields[2]}
 		local sym_sec=${fields[6]}
+		local sec_size
+		local sec_name
 
 		# Get the section size:
-		local sec_size=$(${READELF} --section-headers --wide $objfile |
+		sec_size=$(${READELF} --section-headers --wide $objfile |
 			sed 's/\[ /\[/' |
 			${AWK} -v sec=$sym_sec '$1 == "[" sec "]" { print "0x" $6; exit }')
 
@@ -126,6 +136,17 @@ __faddr2line() {
 			return
 		fi
 
+		# Get the section name:
+		sec_name=$(${READELF} --section-headers --wide $objfile |
+			sed 's/\[ /\[/' |
+			${AWK} -v sec=$sym_sec '$1 == "[" sec "]" { print $2; exit }')
+
+		if [[ -z $sec_name ]]; then
+			warn "bad section name: section: $sym_sec"
+			DONE=1
+			return
+		fi
+
 		# Calculate the symbol size.
 		#
 		# Unfortunately we can't use the ELF size, because kallsyms
@@ -174,10 +195,10 @@ __faddr2line() {
 
 		sym_size=0x$(printf %x $sym_size)
 
-		# Calculate the section address from user-supplied offset:
-		local addr=$(($sym_addr + $offset))
+		# Calculate the address from user-supplied offset:
+		local addr=$(($sym_addr + $func_offset))
 		if [[ -z $addr ]] || [[ $addr = 0 ]]; then
-			warn "bad address: $sym_addr + $offset"
+			warn "bad address: $sym_addr + $func_offset"
 			DONE=1
 			return
 		fi
@@ -191,9 +212,9 @@ __faddr2line() {
 		fi
 
 		# Make sure the provided offset is within the symbol's range:
-		if [[ $offset -gt $sym_size ]]; then
+		if [[ $func_offset -gt $sym_size ]]; then
 			[[ $print_warnings = 1 ]] &&
-				echo "skipping $sym_name address at $addr due to size mismatch ($offset > $sym_size)"
+				echo "skipping $sym_name address at $addr due to size mismatch ($func_offset > $sym_size)"
 			continue
 		fi
 
@@ -202,11 +223,13 @@ __faddr2line() {
 		[[ $FIRST = 0 ]] && echo
 		FIRST=0
 
-		echo "$sym_name+$offset/$sym_size:"
+		echo "$sym_name+$func_offset/$sym_size:"
 
 		# Pass section address to addr2line and strip absolute paths
 		# from the output:
-		local output=$(${ADDR2LINE} -fpie $objfile $addr | sed "s; $dir_prefix\(\./\)*; ;")
+		local args="--functions --pretty-print --inlines --exe=$objfile"
+		[[ $is_vmlinux = 0 ]] && args="$args --section=$sec_name"
+		local output=$(${ADDR2LINE} $args $addr | sed "s; $dir_prefix\(\./\)*; ;")
 		[[ -z $output ]] && continue
 
 		# Default output (non --list):
diff --git a/sound/hda/hdac_device.c b/sound/hda/hdac_device.c
index 3e9e9ac804f6..b7e5032b61c9 100644
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -660,6 +660,7 @@ static const struct hda_vendor_id hda_vendor_ids[] = {
 	{ 0x14f1, "Conexant" },
 	{ 0x17e8, "Chrontel" },
 	{ 0x1854, "LG" },
+	{ 0x19e5, "Huawei" },
 	{ 0x1aec, "Wolfson Microelectronics" },
 	{ 0x1af4, "QEMU" },
 	{ 0x434d, "C-Media" },
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0ff43964a986..4903a857f8f6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -438,6 +438,7 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0245:
 	case 0x10ec0255:
 	case 0x10ec0256:
+	case 0x19e58326:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -575,6 +576,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
@@ -3242,6 +3244,7 @@ static void alc_disable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0x0);
 		alc_update_coef_idx(codec, 0x49, 0x0045, 0x0);
 		break;
@@ -3270,6 +3273,7 @@ static void alc_enable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x48, 0xd011);
 		alc_update_coef_idx(codec, 0x49, 0x007f, 0x0045);
 		break;
@@ -4905,6 +4909,7 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5020,6 +5025,7 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
 		alc_process_coef_fw(codec, coef0256);
@@ -5170,6 +5176,7 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x45, 0xc089);
 		msleep(50);
@@ -5269,6 +5276,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5383,6 +5391,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, coef0256);
 		break;
 	case 0x10ec0234:
@@ -5484,6 +5493,7 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_write_coef_idx(codec, 0x1b, 0x0e4b);
 		alc_write_coef_idx(codec, 0x06, 0x6104);
 		alc_write_coefex_idx(codec, 0x57, 0x3, 0x09a3);
@@ -5778,6 +5788,7 @@ static void alc255_set_default_jack_type(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_process_coef_fw(codec, alc256fw);
 		break;
 	}
@@ -6380,6 +6391,7 @@ static void alc_combo_jack_hp_jd_restart(struct hda_codec *codec)
 	case 0x10ec0236:
 	case 0x10ec0255:
 	case 0x10ec0256:
+	case 0x19e58326:
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
 		alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
 		break;
@@ -8845,6 +8857,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c3, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
@@ -9880,6 +9893,7 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x19e58326:
 		spec->codec_variant = ALC269_TYPE_ALC256;
 		spec->shutup = alc256_shutup;
 		spec->init_hook = alc256_init;
@@ -11330,6 +11344,7 @@ static const struct hda_device_id snd_hda_id_realtek[] = {
 	HDA_CODEC_ENTRY(0x10ec0b00, "ALCS1200A", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1168, "ALC1220", patch_alc882),
 	HDA_CODEC_ENTRY(0x10ec1220, "ALC1220", patch_alc882),
+	HDA_CODEC_ENTRY(0x19e58326, "HW8326", patch_alc269),
 	{} /* terminator */
 };
 MODULE_DEVICE_TABLE(hdaudio, snd_hda_id_realtek);
diff --git a/sound/soc/codecs/cs35l36.c b/sound/soc/codecs/cs35l36.c
index d83c1b318c1c..0accdb45ed72 100644
--- a/sound/soc/codecs/cs35l36.c
+++ b/sound/soc/codecs/cs35l36.c
@@ -444,7 +444,8 @@ static bool cs35l36_volatile_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static DECLARE_TLV_DB_SCALE(dig_vol_tlv, -10200, 25, 0);
+static const DECLARE_TLV_DB_RANGE(dig_vol_tlv, 0, 912,
+				  TLV_DB_MINMAX_ITEM(-10200, 1200));
 static DECLARE_TLV_DB_SCALE(amp_gain_tlv, 0, 1, 1);
 
 static const char * const cs35l36_pcm_sftramp_text[] =  {
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index c61b17dc2af8..fc6a2bc311b4 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -146,7 +146,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x1A, 30, pga_tlv),
+			0, 0x19, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 80161151b3f2..c19ad3c24702 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -137,7 +137,9 @@ static DECLARE_TLV_DB_SCALE(mic_tlv, 1600, 100, 0);
 
 static DECLARE_TLV_DB_SCALE(pga_tlv, -600, 50, 0);
 
-static DECLARE_TLV_DB_SCALE(mix_tlv, -50, 50, 0);
+static DECLARE_TLV_DB_SCALE(pass_tlv, -6000, 50, 0);
+
+static DECLARE_TLV_DB_SCALE(mix_tlv, -5150, 50, 0);
 
 static DECLARE_TLV_DB_SCALE(beep_tlv, -56, 200, 0);
 
@@ -351,7 +353,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 			      CS42L52_SPKB_VOL, 0, 0x40, 0xC0, hl_tlv),
 
 	SOC_DOUBLE_R_SX_TLV("Bypass Volume", CS42L52_PASSTHRUA_VOL,
-			      CS42L52_PASSTHRUB_VOL, 0, 0x88, 0x90, pga_tlv),
+			      CS42L52_PASSTHRUB_VOL, 0, 0x88, 0x90, pass_tlv),
 
 	SOC_DOUBLE("Bypass Mute", CS42L52_MISC_CTL, 4, 5, 1, 0),
 
@@ -364,7 +366,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 			      CS42L52_ADCB_VOL, 0, 0xA0, 0x78, ipd_tlv),
 	SOC_DOUBLE_R_SX_TLV("ADC Mixer Volume",
 			     CS42L52_ADCA_MIXER_VOL, CS42L52_ADCB_MIXER_VOL,
-				0, 0x19, 0x7F, ipd_tlv),
+				0, 0x19, 0x7F, mix_tlv),
 
 	SOC_DOUBLE("ADC Switch", CS42L52_ADC_MISC_CTL, 0, 1, 1, 0),
 
diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 3cf8a0b4478c..b39c25409c23 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -391,9 +391,9 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 	SOC_DOUBLE("ADC Boost Switch", CS42L56_GAIN_BIAS_CTL, 3, 2, 1, 1),
 
 	SOC_DOUBLE_R_SX_TLV("Headphone Volume", CS42L56_HPA_VOLUME,
-			      CS42L56_HPB_VOLUME, 0, 0x84, 0x48, hl_tlv),
+			      CS42L56_HPB_VOLUME, 0, 0x44, 0x48, hl_tlv),
 	SOC_DOUBLE_R_SX_TLV("LineOut Volume", CS42L56_LOA_VOLUME,
-			      CS42L56_LOB_VOLUME, 0, 0x84, 0x48, hl_tlv),
+			      CS42L56_LOB_VOLUME, 0, 0x44, 0x48, hl_tlv),
 
 	SOC_SINGLE_TLV("Bass Shelving Volume", CS42L56_TONE_CTL,
 			0, 0x00, 1, tone_tlv),
diff --git a/sound/soc/codecs/cs53l30.c b/sound/soc/codecs/cs53l30.c
index f2087bd38dbc..c2912ad3851b 100644
--- a/sound/soc/codecs/cs53l30.c
+++ b/sound/soc/codecs/cs53l30.c
@@ -348,22 +348,22 @@ static const struct snd_kcontrol_new cs53l30_snd_controls[] = {
 	SOC_ENUM("ADC2 NG Delay", adc2_ng_delay_enum),
 
 	SOC_SINGLE_SX_TLV("ADC1A PGA Volume",
-		    CS53L30_ADC1A_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC1A_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC1B PGA Volume",
-		    CS53L30_ADC1B_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC1B_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC2A PGA Volume",
-		    CS53L30_ADC2A_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC2A_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 	SOC_SINGLE_SX_TLV("ADC2B PGA Volume",
-		    CS53L30_ADC2B_AFE_CTL, 0, 0x34, 0x18, pga_tlv),
+		    CS53L30_ADC2B_AFE_CTL, 0, 0x34, 0x24, pga_tlv),
 
 	SOC_SINGLE_SX_TLV("ADC1A Digital Volume",
-		    CS53L30_ADC1A_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC1A_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC1B Digital Volume",
-		    CS53L30_ADC1B_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC1B_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC2A Digital Volume",
-		    CS53L30_ADC2A_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC2A_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 	SOC_SINGLE_SX_TLV("ADC2B Digital Volume",
-		    CS53L30_ADC2B_DIG_VOL, 0, 0xA0, 0x0C, dig_tlv),
+		    CS53L30_ADC2B_DIG_VOL, 0, 0xA0, 0x6C, dig_tlv),
 };
 
 static const struct snd_soc_dapm_widget cs53l30_dapm_widgets[] = {
diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index 9632afc2d4d6..ca3b1c00fa78 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -161,13 +161,16 @@ static int es8328_put_deemph(struct snd_kcontrol *kcontrol,
 	if (deemph > 1)
 		return -EINVAL;
 
+	if (es8328->deemph == deemph)
+		return 0;
+
 	ret = es8328_set_deemph(component);
 	if (ret < 0)
 		return ret;
 
 	es8328->deemph = deemph;
 
-	return 0;
+	return 1;
 }
 
 
diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 58123390c7a3..b436e532993d 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -740,6 +740,8 @@ static int nau8822_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
 		pll_param->pll_int, pll_param->pll_frac,
 		pll_param->mclk_scaler, pll_param->pre_factor);
 
+	snd_soc_component_update_bits(component,
+		NAU8822_REG_POWER_MANAGEMENT_1, NAU8822_PLL_EN_MASK, NAU8822_PLL_OFF);
 	snd_soc_component_update_bits(component,
 		NAU8822_REG_PLL_N, NAU8822_PLLMCLK_DIV2 | NAU8822_PLLN_MASK,
 		(pll_param->pre_factor ? NAU8822_PLLMCLK_DIV2 : 0) |
@@ -757,6 +759,8 @@ static int nau8822_set_pll(struct snd_soc_dai *dai, int pll_id, int source,
 		pll_param->mclk_scaler << NAU8822_MCLKSEL_SFT);
 	snd_soc_component_update_bits(component,
 		NAU8822_REG_CLOCKING, NAU8822_CLKM_MASK, NAU8822_CLKM_PLL);
+	snd_soc_component_update_bits(component,
+		NAU8822_REG_POWER_MANAGEMENT_1, NAU8822_PLL_EN_MASK, NAU8822_PLL_ON);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/nau8822.h b/sound/soc/codecs/nau8822.h
index 489191ff187e..b45d42c15de6 100644
--- a/sound/soc/codecs/nau8822.h
+++ b/sound/soc/codecs/nau8822.h
@@ -90,6 +90,9 @@
 #define NAU8822_REFIMP_3K			0x3
 #define NAU8822_IOBUF_EN			(0x1 << 2)
 #define NAU8822_ABIAS_EN			(0x1 << 3)
+#define NAU8822_PLL_EN_MASK			(0x1 << 5)
+#define NAU8822_PLL_ON				(0x1 << 5)
+#define NAU8822_PLL_OFF				(0x0 << 5)
 
 /* NAU8822_REG_AUDIO_INTERFACE (0x4) */
 #define NAU8822_AIFMT_MASK			(0x3 << 3)
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index ba16bdf9e478..a5a4ae4440cc 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3867,6 +3867,7 @@ static int wm8962_runtime_suspend(struct device *dev)
 #endif
 
 static const struct dev_pm_ops wm8962_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(wm8962_runtime_suspend, wm8962_runtime_resume, NULL)
 };
 
diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index f7c800927cb2..08fc1a025b1a 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -794,7 +794,7 @@ int wm_adsp_fw_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct wm_adsp *dsp = snd_soc_component_get_drvdata(component);
-	int ret = 0;
+	int ret = 1;
 
 	if (ucontrol->value.enumerated.item[0] == dsp[e->shift_l].fw)
 		return 0;
