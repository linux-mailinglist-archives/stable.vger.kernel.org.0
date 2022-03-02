Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789EB4CA288
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 11:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241206AbiCBKyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 05:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241180AbiCBKyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 05:54:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53E140E6D;
        Wed,  2 Mar 2022 02:53:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7EE6B81F8A;
        Wed,  2 Mar 2022 10:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD205C004E1;
        Wed,  2 Mar 2022 10:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646218383;
        bh=/WWRt2jvpdZWgYA9q+TD4oC9fvMLz+7jRbzLj0V/bdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BG0MFXUQpKDRgOtGfrW7Fcy4Bz8kh+ocP+5t5fZ3R3o1xEBltF9CxIByyq8SWvGP4
         dJELDpl0rTFwdO14S9n23dUp7PG4WaXweq0zt1OVT8/HmeaGQH4lP/OHelObIcOgq0
         x+1R8faBAV47GbcDZwh6ZTBxgYg49HTnkDD6Y1oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.26
Date:   Wed,  2 Mar 2022 11:52:53 +0100
Message-Id: <1646218373210103@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1646218373145222@kroah.com>
References: <1646218373145222@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c50d4ec83be8..9479b440d708 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 25
+SUBLEVEL = 26
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index 237d20dd5622..286cec4d86d7 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -340,7 +340,7 @@ static int emulate_stw(struct pt_regs *regs, int frreg, int flop)
 	: "r" (val), "r" (regs->ior), "r" (regs->isr)
 	: "r19", "r20", "r21", "r22", "r1", FIXUP_BRANCH_CLOBBER );
 
-	return 0;
+	return ret;
 }
 static int emulate_std(struct pt_regs *regs, int frreg, int flop)
 {
@@ -397,7 +397,7 @@ static int emulate_std(struct pt_regs *regs, int frreg, int flop)
 	__asm__ __volatile__ (
 "	mtsp	%4, %%sr1\n"
 "	zdep	%2, 29, 2, %%r19\n"
-"	dep	%%r0, 31, 2, %2\n"
+"	dep	%%r0, 31, 2, %3\n"
 "	mtsar	%%r19\n"
 "	zvdepi	-2, 32, %%r19\n"
 "1:	ldw	0(%%sr1,%3),%%r20\n"
@@ -409,7 +409,7 @@ static int emulate_std(struct pt_regs *regs, int frreg, int flop)
 "	andcm	%%r21, %%r19, %%r21\n"
 "	or	%1, %%r20, %1\n"
 "	or	%2, %%r21, %2\n"
-"3:	stw	%1,0(%%sr1,%1)\n"
+"3:	stw	%1,0(%%sr1,%3)\n"
 "4:	stw	%%r1,4(%%sr1,%3)\n"
 "5:	stw	%2,8(%%sr1,%3)\n"
 "	copy	%%r0, %0\n"
@@ -596,7 +596,6 @@ void handle_unaligned(struct pt_regs *regs)
 		ret = ERR_NOTHANDLED;	/* "undefined", but lets kill them. */
 		break;
 	}
-#ifdef CONFIG_PA20
 	switch (regs->iir & OPCODE2_MASK)
 	{
 	case OPCODE_FLDD_L:
@@ -607,22 +606,23 @@ void handle_unaligned(struct pt_regs *regs)
 		flop=1;
 		ret = emulate_std(regs, R2(regs->iir),1);
 		break;
+#ifdef CONFIG_PA20
 	case OPCODE_LDD_L:
 		ret = emulate_ldd(regs, R2(regs->iir),0);
 		break;
 	case OPCODE_STD_L:
 		ret = emulate_std(regs, R2(regs->iir),0);
 		break;
-	}
 #endif
+	}
 	switch (regs->iir & OPCODE3_MASK)
 	{
 	case OPCODE_FLDW_L:
 		flop=1;
-		ret = emulate_ldw(regs, R2(regs->iir),0);
+		ret = emulate_ldw(regs, R2(regs->iir), 1);
 		break;
 	case OPCODE_LDW_M:
-		ret = emulate_ldw(regs, R2(regs->iir),1);
+		ret = emulate_ldw(regs, R2(regs->iir), 0);
 		break;
 
 	case OPCODE_FSTW_L:
diff --git a/arch/riscv/configs/nommu_k210_sdcard_defconfig b/arch/riscv/configs/nommu_k210_sdcard_defconfig
index d68b743d580f..15d1fd0a7018 100644
--- a/arch/riscv/configs/nommu_k210_sdcard_defconfig
+++ b/arch/riscv/configs/nommu_k210_sdcard_defconfig
@@ -23,7 +23,7 @@ CONFIG_SLOB=y
 CONFIG_SOC_CANAAN=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
-CONFIG_CMDLINE="earlycon console=ttySIF0 rootdelay=2 root=/dev/mmcblk0p1 ro"
+CONFIG_CMDLINE="earlycon console=ttySIF0 root=/dev/mmcblk0p1 rootwait ro"
 CONFIG_CMDLINE_FORCE=y
 # CONFIG_SECCOMP is not set
 # CONFIG_STACKPROTECTOR is not set
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 3397ddac1a30..16308ef1e578 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -50,6 +50,8 @@ obj-$(CONFIG_MODULE_SECTIONS)	+= module-sections.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= mcount-dyn.o
 
+obj-$(CONFIG_TRACE_IRQFLAGS)	+= trace_irq.o
+
 obj-$(CONFIG_RISCV_BASE_PMU)	+= perf_event.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
 obj-$(CONFIG_HAVE_PERF_REGS)	+= perf_regs.o
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 98f502654edd..7e52ad5d61ad 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -108,7 +108,7 @@ _save_context:
 .option pop
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-	call trace_hardirqs_off
+	call __trace_hardirqs_off
 #endif
 
 #ifdef CONFIG_CONTEXT_TRACKING
@@ -144,7 +144,7 @@ skip_context_tracking:
 	li t0, EXC_BREAKPOINT
 	beq s4, t0, 1f
 #ifdef CONFIG_TRACE_IRQFLAGS
-	call trace_hardirqs_on
+	call __trace_hardirqs_on
 #endif
 	csrs CSR_STATUS, SR_IE
 
@@ -235,7 +235,7 @@ ret_from_exception:
 	REG_L s0, PT_STATUS(sp)
 	csrc CSR_STATUS, SR_IE
 #ifdef CONFIG_TRACE_IRQFLAGS
-	call trace_hardirqs_off
+	call __trace_hardirqs_off
 #endif
 #ifdef CONFIG_RISCV_M_MODE
 	/* the MPP value is too large to be used as an immediate arg for addi */
@@ -271,10 +271,10 @@ restore_all:
 	REG_L s1, PT_STATUS(sp)
 	andi t0, s1, SR_PIE
 	beqz t0, 1f
-	call trace_hardirqs_on
+	call __trace_hardirqs_on
 	j 2f
 1:
-	call trace_hardirqs_off
+	call __trace_hardirqs_off
 2:
 #endif
 	REG_L a0, PT_STATUS(sp)
diff --git a/arch/riscv/kernel/trace_irq.c b/arch/riscv/kernel/trace_irq.c
new file mode 100644
index 000000000000..095ac976d7da
--- /dev/null
+++ b/arch/riscv/kernel/trace_irq.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Changbin Du <changbin.du@gmail.com>
+ */
+
+#include <linux/irqflags.h>
+#include <linux/kprobes.h>
+#include "trace_irq.h"
+
+/*
+ * trace_hardirqs_on/off require the caller to setup frame pointer properly.
+ * Otherwise, CALLER_ADDR1 might trigger an pagging exception in kernel.
+ * Here we add one extra level so they can be safely called by low
+ * level entry code which $fp is used for other purpose.
+ */
+
+void __trace_hardirqs_on(void)
+{
+	trace_hardirqs_on();
+}
+NOKPROBE_SYMBOL(__trace_hardirqs_on);
+
+void __trace_hardirqs_off(void)
+{
+	trace_hardirqs_off();
+}
+NOKPROBE_SYMBOL(__trace_hardirqs_off);
diff --git a/arch/riscv/kernel/trace_irq.h b/arch/riscv/kernel/trace_irq.h
new file mode 100644
index 000000000000..99fe67377e5e
--- /dev/null
+++ b/arch/riscv/kernel/trace_irq.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Changbin Du <changbin.du@gmail.com>
+ */
+#ifndef __TRACE_IRQ_H
+#define __TRACE_IRQ_H
+
+void __trace_hardirqs_on(void);
+void __trace_hardirqs_off(void);
+
+#endif /* __TRACE_IRQ_H */
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 66ed317ebc0d..125cbbe10fef 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -87,11 +87,9 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 		const void *kbuf, const void __user *ubuf)
 {
 	struct fpu *fpu = &target->thread.fpu;
-	struct user32_fxsr_struct newstate;
+	struct fxregs_state newstate;
 	int ret;
 
-	BUILD_BUG_ON(sizeof(newstate) != sizeof(struct fxregs_state));
-
 	if (!cpu_feature_enabled(X86_FEATURE_FXSR))
 		return -ENODEV;
 
@@ -112,9 +110,10 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	/* Copy the state  */
 	memcpy(&fpu->state.fxsave, &newstate, sizeof(newstate));
 
-	/* Clear xmm8..15 */
+	/* Clear xmm8..15 for 32-bit callers */
 	BUILD_BUG_ON(sizeof(fpu->state.fxsave.xmm_space) != 16 * 16);
-	memset(&fpu->state.fxsave.xmm_space[8], 0, 8 * 16);
+	if (in_ia32_syscall())
+		memset(&fpu->state.fxsave.xmm_space[8*4], 0, 8 * 16);
 
 	/* Mark FP and SSE as in use when XSAVE is enabled */
 	if (use_xsave())
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 4c208ea3bd9f..033d9c6a9468 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1224,7 +1224,7 @@ static struct user_regset x86_64_regsets[] __ro_after_init = {
 	},
 	[REGSET_FP] = {
 		.core_note_type = NT_PRFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(long),
+		.n = sizeof(struct fxregs_state) / sizeof(long),
 		.size = sizeof(long), .align = sizeof(long),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},
@@ -1271,7 +1271,7 @@ static struct user_regset x86_32_regsets[] __ro_after_init = {
 	},
 	[REGSET_XFP] = {
 		.core_note_type = NT_PRXFPREG,
-		.n = sizeof(struct user32_fxsr_struct) / sizeof(u32),
+		.n = sizeof(struct fxregs_state) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = regset_xregset_fpregs_active, .regset_get = xfpregs_get, .set = xfpregs_set
 	},
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0a88cb4f731f..ccb9aa571b03 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3889,12 +3889,23 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	walk_shadow_page_lockless_end(vcpu);
 }
 
+static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
+{
+	/* make sure the token value is not 0 */
+	u32 id = vcpu->arch.apf.id;
+
+	if (id << 12 == 0)
+		vcpu->arch.apf.id = 1;
+
+	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
+}
+
 static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				    gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
 
-	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
+	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->direct_map;
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index f242157bc81b..ae8375e9d268 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -919,6 +919,20 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	irqmask &= ~0x10;
 	pci_write_config_byte(dev, 0x5a, irqmask);
 
+	/*
+	 * HPT371 chips physically have only one channel, the secondary one,
+	 * but the primary channel registers do exist!  Go figure...
+	 * So,  we manually disable the non-existing channel here
+	 * (if the BIOS hasn't done this already).
+	 */
+	if (dev->device == PCI_DEVICE_ID_TTI_HPT371) {
+		u8 mcr1;
+
+		pci_read_config_byte(dev, 0x50, &mcr1);
+		mcr1 &= ~0x04;
+		pci_write_config_byte(dev, 0x50, mcr1);
+	}
+
 	/*
 	 * default to pci clock. make sure MA15/16 are set to output
 	 * to prevent drives having problems with 40-pin cables. Needed
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 68ea1f949daa..6b6630693201 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -629,6 +629,9 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			drv->remove(dev);
 
 		devres_release_all(dev);
+		arch_teardown_dma_ops(dev);
+		kfree(dev->dma_range_map);
+		dev->dma_range_map = NULL;
 		driver_sysfs_remove(dev);
 		dev->driver = NULL;
 		dev_set_drvdata(dev, NULL);
@@ -1208,6 +1211,8 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 
 		devres_release_all(dev);
 		arch_teardown_dma_ops(dev);
+		kfree(dev->dma_range_map);
+		dev->dma_range_map = NULL;
 		dev->driver = NULL;
 		dev_set_drvdata(dev, NULL);
 		if (dev->pm_domain && dev->pm_domain->dismiss)
diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index d2656581a608..4a446259a184 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -189,11 +189,9 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 				ret = regmap_write(map, reg, d->mask_buf[i]);
 			if (d->chip->clear_ack) {
 				if (d->chip->ack_invert && !ret)
-					ret = regmap_write(map, reg,
-							   d->mask_buf[i]);
+					ret = regmap_write(map, reg, UINT_MAX);
 				else if (!ret)
-					ret = regmap_write(map, reg,
-							   ~d->mask_buf[i]);
+					ret = regmap_write(map, reg, 0);
 			}
 			if (ret != 0)
 				dev_err(d->map->dev, "Failed to ack 0x%x: %d\n",
@@ -556,11 +554,9 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 						data->status_buf[i]);
 			if (chip->clear_ack) {
 				if (chip->ack_invert && !ret)
-					ret = regmap_write(map, reg,
-							data->status_buf[i]);
+					ret = regmap_write(map, reg, UINT_MAX);
 				else if (!ret)
-					ret = regmap_write(map, reg,
-							~data->status_buf[i]);
+					ret = regmap_write(map, reg, 0);
 			}
 			if (ret != 0)
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
@@ -817,13 +813,9 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 					d->status_buf[i] & d->mask_buf[i]);
 			if (chip->clear_ack) {
 				if (chip->ack_invert && !ret)
-					ret = regmap_write(map, reg,
-						(d->status_buf[i] &
-						 d->mask_buf[i]));
+					ret = regmap_write(map, reg, UINT_MAX);
 				else if (!ret)
-					ret = regmap_write(map, reg,
-						~(d->status_buf[i] &
-						  d->mask_buf[i]));
+					ret = regmap_write(map, reg, 0);
 			}
 			if (ret != 0) {
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
diff --git a/drivers/clk/ingenic/jz4725b-cgu.c b/drivers/clk/ingenic/jz4725b-cgu.c
index 5154b0cf8ad6..66ff141da0a4 100644
--- a/drivers/clk/ingenic/jz4725b-cgu.c
+++ b/drivers/clk/ingenic/jz4725b-cgu.c
@@ -139,11 +139,10 @@ static const struct ingenic_cgu_clk_info jz4725b_cgu_clocks[] = {
 	},
 
 	[JZ4725B_CLK_I2S] = {
-		"i2s", CGU_CLK_MUX | CGU_CLK_DIV | CGU_CLK_GATE,
+		"i2s", CGU_CLK_MUX | CGU_CLK_DIV,
 		.parents = { JZ4725B_CLK_EXT, JZ4725B_CLK_PLL_HALF, -1, -1 },
 		.mux = { CGU_REG_CPCCR, 31, 1 },
 		.div = { CGU_REG_I2SCDR, 0, 1, 9, -1, -1, -1 },
-		.gate = { CGU_REG_CLKGR, 6 },
 	},
 
 	[JZ4725B_CLK_SPI] = {
diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index ce63cbd14d69..24155c038f6d 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -410,10 +410,8 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 	level = rockchip_gpio_readl(bank, bank->gpio_regs->int_type);
 	polarity = rockchip_gpio_readl(bank, bank->gpio_regs->int_polarity);
 
-	switch (type) {
-	case IRQ_TYPE_EDGE_BOTH:
+	if (type == IRQ_TYPE_EDGE_BOTH) {
 		if (bank->gpio_type == GPIO_TYPE_V2) {
-			bank->toggle_edge_mode &= ~mask;
 			rockchip_gpio_writel_bit(bank, d->hwirq, 1,
 						 bank->gpio_regs->int_bothedge);
 			goto out;
@@ -431,30 +429,34 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 			else
 				polarity |= mask;
 		}
-		break;
-	case IRQ_TYPE_EDGE_RISING:
-		bank->toggle_edge_mode &= ~mask;
-		level |= mask;
-		polarity |= mask;
-		break;
-	case IRQ_TYPE_EDGE_FALLING:
-		bank->toggle_edge_mode &= ~mask;
-		level |= mask;
-		polarity &= ~mask;
-		break;
-	case IRQ_TYPE_LEVEL_HIGH:
-		bank->toggle_edge_mode &= ~mask;
-		level &= ~mask;
-		polarity |= mask;
-		break;
-	case IRQ_TYPE_LEVEL_LOW:
-		bank->toggle_edge_mode &= ~mask;
-		level &= ~mask;
-		polarity &= ~mask;
-		break;
-	default:
-		ret = -EINVAL;
-		goto out;
+	} else {
+		if (bank->gpio_type == GPIO_TYPE_V2) {
+			rockchip_gpio_writel_bit(bank, d->hwirq, 0,
+						 bank->gpio_regs->int_bothedge);
+		} else {
+			bank->toggle_edge_mode &= ~mask;
+		}
+		switch (type) {
+		case IRQ_TYPE_EDGE_RISING:
+			level |= mask;
+			polarity |= mask;
+			break;
+		case IRQ_TYPE_EDGE_FALLING:
+			level |= mask;
+			polarity &= ~mask;
+			break;
+		case IRQ_TYPE_LEVEL_HIGH:
+			level &= ~mask;
+			polarity |= mask;
+			break;
+		case IRQ_TYPE_LEVEL_LOW:
+			level &= ~mask;
+			polarity &= ~mask;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	rockchip_gpio_writel(bank, level, bank->gpio_regs->int_type);
diff --git a/drivers/gpio/gpio-tegra186.c b/drivers/gpio/gpio-tegra186.c
index c99858f40a27..00762de3d409 100644
--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -337,9 +337,12 @@ static int tegra186_gpio_of_xlate(struct gpio_chip *chip,
 	return offset + pin;
 }
 
+#define to_tegra_gpio(x) container_of((x), struct tegra_gpio, gpio)
+
 static void tegra186_irq_ack(struct irq_data *data)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 
 	base = tegra186_gpio_get_base(gpio, data->hwirq);
@@ -351,7 +354,8 @@ static void tegra186_irq_ack(struct irq_data *data)
 
 static void tegra186_irq_mask(struct irq_data *data)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 	u32 value;
 
@@ -366,7 +370,8 @@ static void tegra186_irq_mask(struct irq_data *data)
 
 static void tegra186_irq_unmask(struct irq_data *data)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 	u32 value;
 
@@ -381,7 +386,8 @@ static void tegra186_irq_unmask(struct irq_data *data)
 
 static int tegra186_irq_set_type(struct irq_data *data, unsigned int type)
 {
-	struct tegra_gpio *gpio = irq_data_get_irq_chip_data(data);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct tegra_gpio *gpio = to_tegra_gpio(gc);
 	void __iomem *base;
 	u32 value;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index b7509d3f7c1c..a8465e3195a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1278,6 +1278,9 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	bool is_fw_fb;
 	resource_size_t base, size;
 
+	if (amdgpu_aspm == -1 && !pcie_aspm_enabled(pdev))
+		amdgpu_aspm = 0;
+
 	if (amdgpu_virtual_display ||
 	    amdgpu_device_asic_has_dc_support(flags & AMD_ASIC_MASK))
 		supports_atomic = true;
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 0fc97c364fd7..6439d5c3d8d8 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -607,8 +607,8 @@ soc15_asic_reset_method(struct amdgpu_device *adev)
 static int soc15_asic_reset(struct amdgpu_device *adev)
 {
 	/* original raven doesn't have full asic reset */
-	if ((adev->apu_flags & AMD_APU_IS_RAVEN) &&
-	    !(adev->apu_flags & AMD_APU_IS_RAVEN2))
+	if ((adev->apu_flags & AMD_APU_IS_RAVEN) ||
+	    (adev->apu_flags & AMD_APU_IS_RAVEN2))
 		return 0;
 
 	switch (soc15_asic_reset_method(adev)) {
@@ -1273,8 +1273,11 @@ static int soc15_common_early_init(void *handle)
 				AMD_CG_SUPPORT_SDMA_LS |
 				AMD_CG_SUPPORT_VCN_MGCG;
 
+			/*
+			 * MMHUB PG needs to be disabled for Picasso for
+			 * stability reasons.
+			 */
 			adev->pg_flags = AMD_PG_SUPPORT_SDMA |
-				AMD_PG_SUPPORT_MMHUB |
 				AMD_PG_SUPPORT_VCN;
 		} else {
 			adev->cg_flags = AMD_CG_SUPPORT_GFX_MGCG |
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
index 1861a147a7fa..5c5cbeb59c4d 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
@@ -437,8 +437,10 @@ static void dcn3_get_memclk_states_from_smu(struct clk_mgr *clk_mgr_base)
 	clk_mgr_base->bw_params->clk_table.num_entries = num_levels ? num_levels : 1;
 
 	/* Refresh bounding box */
+	DC_FP_START();
 	clk_mgr_base->ctx->dc->res_pool->funcs->update_bw_bounding_box(
 			clk_mgr->base.ctx->dc, clk_mgr_base->bw_params);
+	DC_FP_END();
 }
 
 static bool dcn3_is_smu_present(struct clk_mgr *clk_mgr_base)
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 4fae73478840..b37c4d2e7a1e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -891,10 +891,13 @@ static bool dc_construct(struct dc *dc,
 		goto fail;
 #ifdef CONFIG_DRM_AMD_DC_DCN
 	dc->clk_mgr->force_smu_not_present = init_params->force_smu_not_present;
-#endif
 
-	if (dc->res_pool->funcs->update_bw_bounding_box)
+	if (dc->res_pool->funcs->update_bw_bounding_box) {
+		DC_FP_START();
 		dc->res_pool->funcs->update_bw_bounding_box(dc, dc->clk_mgr->bw_params);
+		DC_FP_END();
+	}
+#endif
 
 	/* Creation of current_state must occur after dc->dml
 	 * is initialized in dc_create_resource_pool because
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index f89bf49965fc..b8896882b6f0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -418,6 +418,36 @@ static int sienna_cichlid_store_powerplay_table(struct smu_context *smu)
 	return 0;
 }
 
+static int sienna_cichlid_patch_pptable_quirk(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t *board_reserved;
+	uint16_t *freq_table_gfx;
+	uint32_t i;
+
+	/* Fix some OEM SKU specific stability issues */
+	GET_PPTABLE_MEMBER(BoardReserved, &board_reserved);
+	if ((adev->pdev->device == 0x73DF) &&
+	    (adev->pdev->revision == 0XC3) &&
+	    (adev->pdev->subsystem_device == 0x16C2) &&
+	    (adev->pdev->subsystem_vendor == 0x1043))
+		board_reserved[0] = 1387;
+
+	GET_PPTABLE_MEMBER(FreqTableGfx, &freq_table_gfx);
+	if ((adev->pdev->device == 0x73DF) &&
+	    (adev->pdev->revision == 0XC3) &&
+	    ((adev->pdev->subsystem_device == 0x16C2) ||
+	    (adev->pdev->subsystem_device == 0x133C)) &&
+	    (adev->pdev->subsystem_vendor == 0x1043)) {
+		for (i = 0; i < NUM_GFXCLK_DPM_LEVELS; i++) {
+			if (freq_table_gfx[i] > 2500)
+				freq_table_gfx[i] = 2500;
+		}
+	}
+
+	return 0;
+}
+
 static int sienna_cichlid_setup_pptable(struct smu_context *smu)
 {
 	int ret = 0;
@@ -438,7 +468,7 @@ static int sienna_cichlid_setup_pptable(struct smu_context *smu)
 	if (ret)
 		return ret;
 
-	return ret;
+	return sienna_cichlid_patch_pptable_quirk(smu);
 }
 
 static int sienna_cichlid_tables_init(struct smu_context *smu)
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index ea9a79bc9583..6ad4361a5cbc 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5205,6 +5205,7 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
 	if (!(edid->input & DRM_EDID_INPUT_DIGITAL))
 		return quirks;
 
+	info->color_formats |= DRM_COLOR_FORMAT_RGB444;
 	drm_parse_cea_ext(connector, edid);
 
 	/*
@@ -5253,7 +5254,6 @@ u32 drm_add_display_info(struct drm_connector *connector, const struct edid *edi
 	DRM_DEBUG("%s: Assigning EDID-1.4 digital sink color depth as %d bpc.\n",
 			  connector->name, info->bpc);
 
-	info->color_formats |= DRM_COLOR_FORMAT_RGB444;
 	if (edid->features & DRM_EDID_FEATURE_RGB_YCRCB444)
 		info->color_formats |= DRM_COLOR_FORMAT_YCRCB444;
 	if (edid->features & DRM_EDID_FEATURE_RGB_YCRCB422)
diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
index 4b94256d7319..7144c76ac970 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -681,6 +681,7 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	unsigned int max_bw_point = 0, max_bw = 0;
 	unsigned int num_qgv_points = dev_priv->max_bw[0].num_qgv_points;
 	unsigned int num_psf_gv_points = dev_priv->max_bw[0].num_psf_gv_points;
+	bool changed = false;
 	u32 mask = 0;
 
 	/* FIXME earlier gens need some checks too */
@@ -724,6 +725,8 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 		new_bw_state->data_rate[crtc->pipe] = new_data_rate;
 		new_bw_state->num_active_planes[crtc->pipe] = new_active_planes;
 
+		changed = true;
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "pipe %c data rate %u num active planes %u\n",
 			    pipe_name(crtc->pipe),
@@ -731,7 +734,19 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 			    new_bw_state->num_active_planes[crtc->pipe]);
 	}
 
-	if (!new_bw_state)
+	old_bw_state = intel_atomic_get_old_bw_state(state);
+	new_bw_state = intel_atomic_get_new_bw_state(state);
+
+	if (new_bw_state &&
+	    intel_can_enable_sagv(dev_priv, old_bw_state) !=
+	    intel_can_enable_sagv(dev_priv, new_bw_state))
+		changed = true;
+
+	/*
+	 * If none of our inputs (data rates, number of active
+	 * planes, SAGV yes/no) changed then nothing to do here.
+	 */
+	if (!changed)
 		return 0;
 
 	ret = intel_atomic_lock_global_state(&new_bw_state->base);
@@ -814,7 +829,6 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
 	 */
 	new_bw_state->qgv_points_mask = ~allowed_points & mask;
 
-	old_bw_state = intel_atomic_get_old_bw_state(state);
 	/*
 	 * If the actual mask had changed we need to make sure that
 	 * the commits are serialized(in case this is a nomodeset, nonblocking)
diff --git a/drivers/gpu/drm/i915/display/intel_bw.h b/drivers/gpu/drm/i915/display/intel_bw.h
index 46c6eecbd917..0ceaed1c9656 100644
--- a/drivers/gpu/drm/i915/display/intel_bw.h
+++ b/drivers/gpu/drm/i915/display/intel_bw.h
@@ -30,19 +30,19 @@ struct intel_bw_state {
 	 */
 	u8 pipe_sagv_reject;
 
+	/* bitmask of active pipes */
+	u8 active_pipes;
+
 	/*
 	 * Current QGV points mask, which restricts
 	 * some particular SAGV states, not to confuse
 	 * with pipe_sagv_mask.
 	 */
-	u8 qgv_points_mask;
+	u16 qgv_points_mask;
 
 	unsigned int data_rate[I915_MAX_PIPES];
 	u8 num_active_planes[I915_MAX_PIPES];
 
-	/* bitmask of active pipes */
-	u8 active_pipes;
-
 	int min_cdclk;
 };
 
diff --git a/drivers/gpu/drm/i915/display/intel_snps_phy.c b/drivers/gpu/drm/i915/display/intel_snps_phy.c
index 18b52b64af95..536b319ffe5b 100644
--- a/drivers/gpu/drm/i915/display/intel_snps_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_phy.c
@@ -32,7 +32,7 @@ void intel_snps_phy_wait_for_calibration(struct drm_i915_private *dev_priv)
 		if (intel_de_wait_for_clear(dev_priv, ICL_PHY_MISC(phy),
 					    DG2_PHY_DP_TX_ACK_MASK, 25))
 			DRM_ERROR("SNPS PHY %c failed to calibrate after 25ms.\n",
-				  phy);
+				  phy_name(phy));
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 8937bc8985d6..9c5e4758947b 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4020,6 +4020,17 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
 			return ret;
 	}
 
+	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
+	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
+		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
+		if (ret)
+			return ret;
+	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
+		ret = intel_atomic_lock_global_state(&new_bw_state->base);
+		if (ret)
+			return ret;
+	}
+
 	for_each_new_intel_crtc_in_state(state, crtc,
 					 new_crtc_state, i) {
 		struct skl_pipe_wm *pipe_wm = &new_crtc_state->wm.skl.optimal;
@@ -4035,17 +4046,6 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
 			intel_can_enable_sagv(dev_priv, new_bw_state);
 	}
 
-	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
-	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
-		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
-		if (ret)
-			return ret;
-	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
-		ret = intel_atomic_lock_global_state(&new_bw_state->base);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index e3ed52d96f42..3e61184e194c 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -538,9 +538,11 @@ int vc4_crtc_disable_at_boot(struct drm_crtc *crtc)
 	if (ret)
 		return ret;
 
-	ret = pm_runtime_put(&vc4_hdmi->pdev->dev);
-	if (ret)
-		return ret;
+	/*
+	 * post_crtc_powerdown will have called pm_runtime_put, so we
+	 * don't need it here otherwise we'll get the reference counting
+	 * wrong.
+	 */
 
 	return 0;
 }
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index d198a10848c6..a89a408182e6 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -225,27 +225,12 @@ int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh, long timeout,
 	void *ref;
 	struct host1x_waitlist *waiter;
 	int err = 0, check_count = 0;
-	u32 val;
 
 	if (value)
-		*value = 0;
-
-	/* first check cache */
-	if (host1x_syncpt_is_expired(sp, thresh)) {
-		if (value)
-			*value = host1x_syncpt_load(sp);
+		*value = host1x_syncpt_load(sp);
 
+	if (host1x_syncpt_is_expired(sp, thresh))
 		return 0;
-	}
-
-	/* try to read from register */
-	val = host1x_hw_syncpt_load(sp->host, sp);
-	if (host1x_syncpt_is_expired(sp, thresh)) {
-		if (value)
-			*value = val;
-
-		goto done;
-	}
 
 	if (!timeout) {
 		err = -EAGAIN;
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 3501a3ead4ba..3ae961986fc3 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -214,12 +214,14 @@ static int hwmon_thermal_add_sensor(struct device *dev, int index)
 
 	tzd = devm_thermal_zone_of_sensor_register(dev, index, tdata,
 						   &hwmon_thermal_ops);
-	/*
-	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
-	 * so ignore that error but forward any other error.
-	 */
-	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV))
-		return PTR_ERR(tzd);
+	if (IS_ERR(tzd)) {
+		if (PTR_ERR(tzd) != -ENODEV)
+			return PTR_ERR(tzd);
+		dev_info(dev, "temp%d_input not attached to any thermal zone\n",
+			 index + 1);
+		devm_kfree(dev, tdata);
+		return 0;
+	}
 
 	err = devm_add_action(dev, hwmon_thermal_remove_sensor, &tdata->node);
 	if (err)
diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index e8693a42ad46..3af763b4a973 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1782,11 +1782,14 @@ int bmc150_accel_core_probe(struct device *dev, struct regmap *regmap, int irq,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(dev, "Unable to register iio device\n");
-		goto err_trigger_unregister;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_disable(dev);
 err_trigger_unregister:
 	bmc150_accel_unregister_triggers(data, BMC150_ACCEL_TRIGGERS - 1);
 err_buffer_cleanup:
diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index f41db9e0249a..a2d29cabb389 100644
--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -154,12 +154,20 @@ struct fxls8962af_data {
 	u8 watermark;
 };
 
-const struct regmap_config fxls8962af_regmap_conf = {
+const struct regmap_config fxls8962af_i2c_regmap_conf = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = FXLS8962AF_MAX_REG,
 };
-EXPORT_SYMBOL_GPL(fxls8962af_regmap_conf);
+EXPORT_SYMBOL_GPL(fxls8962af_i2c_regmap_conf);
+
+const struct regmap_config fxls8962af_spi_regmap_conf = {
+	.reg_bits = 8,
+	.pad_bits = 8,
+	.val_bits = 8,
+	.max_register = FXLS8962AF_MAX_REG,
+};
+EXPORT_SYMBOL_GPL(fxls8962af_spi_regmap_conf);
 
 enum {
 	fxls8962af_idx_x,
diff --git a/drivers/iio/accel/fxls8962af-i2c.c b/drivers/iio/accel/fxls8962af-i2c.c
index cfb004b20455..6bde9891effb 100644
--- a/drivers/iio/accel/fxls8962af-i2c.c
+++ b/drivers/iio/accel/fxls8962af-i2c.c
@@ -18,7 +18,7 @@ static int fxls8962af_probe(struct i2c_client *client)
 {
 	struct regmap *regmap;
 
-	regmap = devm_regmap_init_i2c(client, &fxls8962af_regmap_conf);
+	regmap = devm_regmap_init_i2c(client, &fxls8962af_i2c_regmap_conf);
 	if (IS_ERR(regmap)) {
 		dev_err(&client->dev, "Failed to initialize i2c regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/iio/accel/fxls8962af-spi.c b/drivers/iio/accel/fxls8962af-spi.c
index 57108d3d480b..6f4dff3238d3 100644
--- a/drivers/iio/accel/fxls8962af-spi.c
+++ b/drivers/iio/accel/fxls8962af-spi.c
@@ -18,7 +18,7 @@ static int fxls8962af_probe(struct spi_device *spi)
 {
 	struct regmap *regmap;
 
-	regmap = devm_regmap_init_spi(spi, &fxls8962af_regmap_conf);
+	regmap = devm_regmap_init_spi(spi, &fxls8962af_spi_regmap_conf);
 	if (IS_ERR(regmap)) {
 		dev_err(&spi->dev, "Failed to initialize spi regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/iio/accel/fxls8962af.h b/drivers/iio/accel/fxls8962af.h
index b67572c3ef06..9cbe98c3ba9a 100644
--- a/drivers/iio/accel/fxls8962af.h
+++ b/drivers/iio/accel/fxls8962af.h
@@ -17,6 +17,7 @@ int fxls8962af_core_probe(struct device *dev, struct regmap *regmap, int irq);
 int fxls8962af_core_remove(struct device *dev);
 
 extern const struct dev_pm_ops fxls8962af_pm_ops;
-extern const struct regmap_config fxls8962af_regmap_conf;
+extern const struct regmap_config fxls8962af_i2c_regmap_conf;
+extern const struct regmap_config fxls8962af_spi_regmap_conf;
 
 #endif				/* _FXLS8962AF_H_ */
diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 24c9387c2968..ba6c8ca488b1 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1589,11 +1589,14 @@ static int kxcjk1013_probe(struct i2c_client *client,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "unable to register iio device\n");
-		goto err_buffer_cleanup;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 err_buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 err_trigger_unregister:
diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
index 4c359fb05480..c53a3398b14c 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -495,11 +495,14 @@ static int mma9551_probe(struct i2c_client *client,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "unable to register iio device\n");
-		goto out_poweroff;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 out_poweroff:
 	mma9551_set_device_state(client, false);
 
diff --git a/drivers/iio/accel/mma9553.c b/drivers/iio/accel/mma9553.c
index ba3ecb3b57dc..1599b75724d4 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1134,12 +1134,15 @@ static int mma9553_probe(struct i2c_client *client,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "unable to register iio device\n");
-		goto out_poweroff;
+		goto err_pm_cleanup;
 	}
 
 	dev_dbg(&indio_dev->dev, "Registered device %s\n", name);
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 out_poweroff:
 	mma9551_set_device_state(client, false);
 	return ret;
diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index e45c600fccc0..18c154afbd7a 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -76,7 +76,7 @@
 #define AD7124_CONFIG_REF_SEL(x)	FIELD_PREP(AD7124_CONFIG_REF_SEL_MSK, x)
 #define AD7124_CONFIG_PGA_MSK		GENMASK(2, 0)
 #define AD7124_CONFIG_PGA(x)		FIELD_PREP(AD7124_CONFIG_PGA_MSK, x)
-#define AD7124_CONFIG_IN_BUFF_MSK	GENMASK(7, 6)
+#define AD7124_CONFIG_IN_BUFF_MSK	GENMASK(6, 5)
 #define AD7124_CONFIG_IN_BUFF(x)	FIELD_PREP(AD7124_CONFIG_IN_BUFF_MSK, x)
 
 /* AD7124_FILTER_X */
diff --git a/drivers/iio/adc/men_z188_adc.c b/drivers/iio/adc/men_z188_adc.c
index 42ea8bc7e780..adc5ceaef8c9 100644
--- a/drivers/iio/adc/men_z188_adc.c
+++ b/drivers/iio/adc/men_z188_adc.c
@@ -103,6 +103,7 @@ static int men_z188_probe(struct mcb_device *dev,
 	struct z188_adc *adc;
 	struct iio_dev *indio_dev;
 	struct resource *mem;
+	int ret;
 
 	indio_dev = devm_iio_device_alloc(&dev->dev, sizeof(struct z188_adc));
 	if (!indio_dev)
@@ -128,8 +129,14 @@ static int men_z188_probe(struct mcb_device *dev,
 	adc->mem = mem;
 	mcb_set_drvdata(dev, indio_dev);
 
-	return iio_device_register(indio_dev);
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_unmap;
+
+	return 0;
 
+err_unmap:
+	iounmap(adc->base);
 err:
 	mcb_release_mem(mem);
 	return -ENXIO;
diff --git a/drivers/iio/adc/ti-tsc2046.c b/drivers/iio/adc/ti-tsc2046.c
index d84ae6b008c1..e8fc4d01f30b 100644
--- a/drivers/iio/adc/ti-tsc2046.c
+++ b/drivers/iio/adc/ti-tsc2046.c
@@ -388,7 +388,7 @@ static int tsc2046_adc_update_scan_mode(struct iio_dev *indio_dev,
 	mutex_lock(&priv->slock);
 
 	size = 0;
-	for_each_set_bit(ch_idx, active_scan_mask, indio_dev->num_channels) {
+	for_each_set_bit(ch_idx, active_scan_mask, ARRAY_SIZE(priv->l)) {
 		size += tsc2046_adc_group_set_layout(priv, group, ch_idx);
 		tsc2046_adc_group_set_cmd(priv, group, ch_idx);
 		group++;
@@ -548,7 +548,7 @@ static int tsc2046_adc_setup_spi_msg(struct tsc2046_adc_priv *priv)
 	 * enabled.
 	 */
 	size = 0;
-	for (ch_idx = 0; ch_idx < priv->dcfg->num_channels; ch_idx++)
+	for (ch_idx = 0; ch_idx < ARRAY_SIZE(priv->l); ch_idx++)
 		size += tsc2046_adc_group_set_layout(priv, ch_idx, ch_idx);
 
 	priv->tx = devm_kzalloc(&priv->spi->dev, size, GFP_KERNEL);
diff --git a/drivers/iio/gyro/bmg160_core.c b/drivers/iio/gyro/bmg160_core.c
index 17b939a367ad..81a6d09788bd 100644
--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -1188,11 +1188,14 @@ int bmg160_core_probe(struct device *dev, struct regmap *regmap, int irq,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(dev, "unable to register iio device\n");
-		goto err_buffer_cleanup;
+		goto err_pm_cleanup;
 	}
 
 	return 0;
 
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_disable(dev);
 err_buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 err_trigger_unregister:
diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index ed129321a14d..f9b4540db1f4 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -1403,6 +1403,7 @@ static int adis16480_probe(struct spi_device *spi)
 {
 	const struct spi_device_id *id = spi_get_device_id(spi);
 	const struct adis_data *adis16480_data;
+	irq_handler_t trigger_handler = NULL;
 	struct iio_dev *indio_dev;
 	struct adis16480 *st;
 	int ret;
@@ -1474,8 +1475,12 @@ static int adis16480_probe(struct spi_device *spi)
 		st->clk_freq = st->chip_info->int_clk;
 	}
 
+	/* Only use our trigger handler if burst mode is supported */
+	if (adis16480_data->burst_len)
+		trigger_handler = adis16480_trigger_handler;
+
 	ret = devm_adis_setup_buffer_and_trigger(&st->adis, indio_dev,
-						 adis16480_trigger_handler);
+						 trigger_handler);
 	if (ret)
 		return ret;
 
diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index 1dabfd615dab..f89724481df9 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -1385,7 +1385,7 @@ static int kmx61_probe(struct i2c_client *client,
 	ret = iio_device_register(data->acc_indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to register acc iio device\n");
-		goto err_buffer_cleanup_mag;
+		goto err_pm_cleanup;
 	}
 
 	ret = iio_device_register(data->mag_indio_dev);
@@ -1398,6 +1398,9 @@ static int kmx61_probe(struct i2c_client *client,
 
 err_iio_unregister_acc:
 	iio_device_unregister(data->acc_indio_dev);
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(&client->dev);
+	pm_runtime_disable(&client->dev);
 err_buffer_cleanup_mag:
 	if (client->irq > 0)
 		iio_triggered_buffer_cleanup(data->mag_indio_dev);
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 8dbf744c5651..a778aceba3b1 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1372,8 +1372,12 @@ static int st_lsm6dsx_read_oneshot(struct st_lsm6dsx_sensor *sensor,
 	if (err < 0)
 		return err;
 
+	/*
+	 * we need to wait for sensor settling time before
+	 * reading data in order to avoid corrupted samples
+	 */
 	delay = 1000000000 / sensor->odr;
-	usleep_range(delay, 2 * delay);
+	usleep_range(3 * delay, 4 * delay);
 
 	err = st_lsm6dsx_read_locked(hw, addr, &data, sizeof(data));
 	if (err < 0)
diff --git a/drivers/iio/magnetometer/bmc150_magn.c b/drivers/iio/magnetometer/bmc150_magn.c
index f96f53175349..3d4d21f979fa 100644
--- a/drivers/iio/magnetometer/bmc150_magn.c
+++ b/drivers/iio/magnetometer/bmc150_magn.c
@@ -962,13 +962,14 @@ int bmc150_magn_probe(struct device *dev, struct regmap *regmap,
 	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(dev, "unable to register iio device\n");
-		goto err_disable_runtime_pm;
+		goto err_pm_cleanup;
 	}
 
 	dev_dbg(dev, "Registered device %s\n", name);
 	return 0;
 
-err_disable_runtime_pm:
+err_pm_cleanup:
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 err_buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 13679c7b6577..db7b5de3bc76 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3368,22 +3368,30 @@ static int cma_resolve_ib_addr(struct rdma_id_private *id_priv)
 static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 			 const struct sockaddr *dst_addr)
 {
-	if (!src_addr || !src_addr->sa_family) {
-		src_addr = (struct sockaddr *) &id->route.addr.src_addr;
-		src_addr->sa_family = dst_addr->sa_family;
-		if (IS_ENABLED(CONFIG_IPV6) &&
-		    dst_addr->sa_family == AF_INET6) {
-			struct sockaddr_in6 *src_addr6 = (struct sockaddr_in6 *) src_addr;
-			struct sockaddr_in6 *dst_addr6 = (struct sockaddr_in6 *) dst_addr;
-			src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
-			if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
-				id->route.addr.dev_addr.bound_dev_if = dst_addr6->sin6_scope_id;
-		} else if (dst_addr->sa_family == AF_IB) {
-			((struct sockaddr_ib *) src_addr)->sib_pkey =
-				((struct sockaddr_ib *) dst_addr)->sib_pkey;
-		}
-	}
-	return rdma_bind_addr(id, src_addr);
+	struct sockaddr_storage zero_sock = {};
+
+	if (src_addr && src_addr->sa_family)
+		return rdma_bind_addr(id, src_addr);
+
+	/*
+	 * When the src_addr is not specified, automatically supply an any addr
+	 */
+	zero_sock.ss_family = dst_addr->sa_family;
+	if (IS_ENABLED(CONFIG_IPV6) && dst_addr->sa_family == AF_INET6) {
+		struct sockaddr_in6 *src_addr6 =
+			(struct sockaddr_in6 *)&zero_sock;
+		struct sockaddr_in6 *dst_addr6 =
+			(struct sockaddr_in6 *)dst_addr;
+
+		src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
+		if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
+			id->route.addr.dev_addr.bound_dev_if =
+				dst_addr6->sin6_scope_id;
+	} else if (dst_addr->sa_family == AF_IB) {
+		((struct sockaddr_ib *)&zero_sock)->sib_pkey =
+			((struct sockaddr_ib *)dst_addr)->sib_pkey;
+	}
+	return rdma_bind_addr(id, (struct sockaddr *)&zero_sock);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 0a3b28142c05..41c272980f91 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -541,7 +541,7 @@ static struct attribute *port_diagc_attributes[] = {
 };
 
 static const struct attribute_group port_diagc_group = {
-	.name = "linkcontrol",
+	.name = "diag_counters",
 	.attrs = port_diagc_attributes,
 };
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 55ebe01ec995..a23438bacf12 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2664,6 +2664,8 @@ static void rtrs_clt_dev_release(struct device *dev)
 {
 	struct rtrs_clt *clt = container_of(dev, struct rtrs_clt, dev);
 
+	mutex_destroy(&clt->paths_ev_mutex);
+	mutex_destroy(&clt->paths_mutex);
 	kfree(clt);
 }
 
@@ -2693,6 +2695,8 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	clt->dev.class = rtrs_clt_dev_class;
+	clt->dev.release = rtrs_clt_dev_release;
 	uuid_gen(&clt->paths_uuid);
 	INIT_LIST_HEAD_RCU(&clt->paths_list);
 	clt->paths_num = paths_num;
@@ -2709,53 +2713,51 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 	init_waitqueue_head(&clt->permits_wait);
 	mutex_init(&clt->paths_ev_mutex);
 	mutex_init(&clt->paths_mutex);
+	device_initialize(&clt->dev);
 
-	clt->dev.class = rtrs_clt_dev_class;
-	clt->dev.release = rtrs_clt_dev_release;
 	err = dev_set_name(&clt->dev, "%s", sessname);
 	if (err)
-		goto err;
+		goto err_put;
+
 	/*
 	 * Suppress user space notification until
 	 * sysfs files are created
 	 */
 	dev_set_uevent_suppress(&clt->dev, true);
-	err = device_register(&clt->dev);
-	if (err) {
-		put_device(&clt->dev);
-		goto err;
-	}
+	err = device_add(&clt->dev);
+	if (err)
+		goto err_put;
 
 	clt->kobj_paths = kobject_create_and_add("paths", &clt->dev.kobj);
 	if (!clt->kobj_paths) {
 		err = -ENOMEM;
-		goto err_dev;
+		goto err_del;
 	}
 	err = rtrs_clt_create_sysfs_root_files(clt);
 	if (err) {
 		kobject_del(clt->kobj_paths);
 		kobject_put(clt->kobj_paths);
-		goto err_dev;
+		goto err_del;
 	}
 	dev_set_uevent_suppress(&clt->dev, false);
 	kobject_uevent(&clt->dev.kobj, KOBJ_ADD);
 
 	return clt;
-err_dev:
-	device_unregister(&clt->dev);
-err:
+err_del:
+	device_del(&clt->dev);
+err_put:
 	free_percpu(clt->pcpu_path);
-	kfree(clt);
+	put_device(&clt->dev);
 	return ERR_PTR(err);
 }
 
 static void free_clt(struct rtrs_clt *clt)
 {
-	free_permits(clt);
 	free_percpu(clt->pcpu_path);
-	mutex_destroy(&clt->paths_ev_mutex);
-	mutex_destroy(&clt->paths_mutex);
-	/* release callback will free clt in last put */
+
+	/*
+	 * release callback will free clt and destroy mutexes in last put
+	 */
 	device_unregister(&clt->dev);
 }
 
@@ -2866,6 +2868,7 @@ void rtrs_clt_close(struct rtrs_clt *clt)
 		rtrs_clt_destroy_sess_files(sess, NULL);
 		kobject_put(&sess->kobj);
 	}
+	free_permits(clt);
 	free_clt(clt);
 }
 EXPORT_SYMBOL(rtrs_clt_close);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 71eda91e810c..5d416ec22871 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -4038,9 +4038,11 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
 		spin_unlock(&host->target_lock);
 
 		/*
-		 * Wait for tl_err and target port removal tasks.
+		 * srp_queue_remove_work() queues a call to
+		 * srp_remove_target(). The latter function cancels
+		 * target->tl_err_work so waiting for the remove works to
+		 * finish is sufficient.
 		 */
-		flush_workqueue(system_long_wq);
 		flush_workqueue(srp_remove_wq);
 
 		kfree(host);
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 54df9cfd588e..61f236e0378a 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -546,6 +546,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
 	config.stride = 1;
 	config.read_only = true;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.no_of_node = !of_device_is_compatible(node, "nvmem-cells");
 	config.priv = mtd;
 
@@ -830,6 +831,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
+	config.ignore_wp = true;
 	config.reg_read = reg_read;
 	config.size = size;
 	config.of_node = np;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 10a5b43976d2..dc70f6f96d02 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -100,6 +100,9 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FW_FILE_NAME_E1);
 MODULE_FIRMWARE(FW_FILE_NAME_E1H);
 MODULE_FIRMWARE(FW_FILE_NAME_E2);
+MODULE_FIRMWARE(FW_FILE_NAME_E1_V15);
+MODULE_FIRMWARE(FW_FILE_NAME_E1H_V15);
+MODULE_FIRMWARE(FW_FILE_NAME_E2_V15);
 
 int bnx2x_num_queues;
 module_param_named(num_queues, bnx2x_num_queues, int, 0444);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a8855a200a3c..f92bea4faa01 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4757,8 +4757,10 @@ static int bnxt_hwrm_cfa_l2_set_rx_mask(struct bnxt *bp, u16 vnic_id)
 		return rc;
 
 	req->vnic_id = cpu_to_le32(vnic->fw_vnic_id);
-	req->num_mc_entries = cpu_to_le32(vnic->mc_list_count);
-	req->mc_tbl_addr = cpu_to_le64(vnic->mc_list_mapping);
+	if (vnic->rx_mask & CFA_L2_SET_RX_MASK_REQ_MASK_MCAST) {
+		req->num_mc_entries = cpu_to_le32(vnic->mc_list_count);
+		req->mc_tbl_addr = cpu_to_le64(vnic->mc_list_mapping);
+	}
 	req->mask = cpu_to_le32(vnic->rx_mask);
 	return hwrm_req_send_silent(bp, req);
 }
@@ -8624,7 +8626,7 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 	if (bp->dev->flags & IFF_ALLMULTI) {
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
-	} else {
+	} else if (bp->dev->flags & IFF_MULTICAST) {
 		u32 mask = 0;
 
 		bnxt_mc_list_updated(bp, &mask);
@@ -10295,12 +10297,12 @@ int bnxt_half_open_nic(struct bnxt *bp)
 		goto half_open_err;
 	}
 
-	rc = bnxt_alloc_mem(bp, false);
+	rc = bnxt_alloc_mem(bp, true);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
 		goto half_open_err;
 	}
-	rc = bnxt_init_nic(bp, false);
+	rc = bnxt_init_nic(bp, true);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
 		goto half_open_err;
@@ -10309,7 +10311,7 @@ int bnxt_half_open_nic(struct bnxt *bp)
 
 half_open_err:
 	bnxt_free_skbs(bp);
-	bnxt_free_mem(bp, false);
+	bnxt_free_mem(bp, true);
 	dev_close(bp->dev);
 	return rc;
 }
@@ -10319,9 +10321,9 @@ int bnxt_half_open_nic(struct bnxt *bp)
  */
 void bnxt_half_close_nic(struct bnxt *bp)
 {
-	bnxt_hwrm_resource_free(bp, false, false);
+	bnxt_hwrm_resource_free(bp, false, true);
 	bnxt_free_skbs(bp);
-	bnxt_free_mem(bp, false);
+	bnxt_free_mem(bp, true);
 }
 
 static void bnxt_reenable_sriov(struct bnxt *bp)
@@ -10737,7 +10739,7 @@ static void bnxt_set_rx_mode(struct net_device *dev)
 	if (dev->flags & IFF_ALLMULTI) {
 		mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
-	} else {
+	} else if (dev->flags & IFF_MULTICAST) {
 		mc_update = bnxt_mc_list_updated(bp, &mask);
 	}
 
@@ -10805,9 +10807,10 @@ static int bnxt_cfg_rx_mode(struct bnxt *bp)
 	    !bnxt_promisc_ok(bp))
 		vnic->rx_mask &= ~CFA_L2_SET_RX_MASK_REQ_MASK_PROMISCUOUS;
 	rc = bnxt_hwrm_cfa_l2_set_rx_mask(bp, 0);
-	if (rc && vnic->mc_list_count) {
+	if (rc && (vnic->rx_mask & CFA_L2_SET_RX_MASK_REQ_MASK_MCAST)) {
 		netdev_info(bp->dev, "Failed setting MC filters rc: %d, turning on ALL_MCAST mode\n",
 			    rc);
+		vnic->rx_mask &= ~CFA_L2_SET_RX_MASK_REQ_MASK_MCAST;
 		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
 		vnic->mc_list_count = 0;
 		rc = bnxt_hwrm_cfa_l2_set_rx_mask(bp, 0);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 249792510521..da3ee22e8a16 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -25,6 +25,7 @@
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
+#include "bnxt_ulp.h"
 #include "bnxt_xdp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_ethtool.h"
@@ -1942,6 +1943,9 @@ static int bnxt_get_fecparam(struct net_device *dev,
 	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_IEEE_ACTIVE:
 		fec->active_fec |= ETHTOOL_FEC_LLRS;
 		break;
+	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_NONE_ACTIVE:
+		fec->active_fec |= ETHTOOL_FEC_OFF;
+		break;
 	}
 	return 0;
 }
@@ -3499,9 +3503,12 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 	if (!offline) {
 		bnxt_run_fw_tests(bp, test_mask, &test_results);
 	} else {
-		rc = bnxt_close_nic(bp, false, false);
-		if (rc)
+		bnxt_ulp_stop(bp);
+		rc = bnxt_close_nic(bp, true, false);
+		if (rc) {
+			bnxt_ulp_start(bp, rc);
 			return;
+		}
 		bnxt_run_fw_tests(bp, test_mask, &test_results);
 
 		buf[BNXT_MACLPBK_TEST_IDX] = 1;
@@ -3511,6 +3518,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		if (rc) {
 			bnxt_hwrm_mac_loopback(bp, false);
 			etest->flags |= ETH_TEST_FL_FAILED;
+			bnxt_ulp_start(bp, rc);
 			return;
 		}
 		if (bnxt_run_loopback(bp))
@@ -3536,7 +3544,8 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		}
 		bnxt_hwrm_phy_loopback(bp, false, false);
 		bnxt_half_close_nic(bp);
-		rc = bnxt_open_nic(bp, false, true);
+		rc = bnxt_open_nic(bp, true, true);
+		bnxt_ulp_start(bp, rc);
 	}
 	if (rc || bnxt_test_irq(bp)) {
 		buf[BNXT_IRQ_TEST_IDX] = 1;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 8171f4912fa0..3a0eeb373776 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -595,18 +595,24 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 
 		/* Last byte of resp contains valid bit */
 		valid = ((u8 *)ctx->resp) + len - 1;
-		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
+		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; ) {
 			/* make sure we read from updated DMA memory */
 			dma_rmb();
 			if (*valid)
 				break;
-			usleep_range(1, 5);
+			if (j < 10) {
+				udelay(1);
+				j++;
+			} else {
+				usleep_range(20, 30);
+				j += 20;
+			}
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
 			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
 				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
-					   hwrm_total_timeout(i),
+					   hwrm_total_timeout(i) + j,
 					   le16_to_cpu(ctx->req->req_type),
 					   le16_to_cpu(ctx->req->seq_id), len,
 					   *valid);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 9a9fc4e8041b..380ef69afb51 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -94,7 +94,7 @@ static inline unsigned int hwrm_total_timeout(unsigned int n)
 }
 
 
-#define HWRM_VALID_BIT_DELAY_USEC	150
+#define HWRM_VALID_BIT_DELAY_USEC	50000
 
 static inline bool bnxt_cfa_hwrm_message(u16 req_type)
 {
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5c7371dc8384..14a729ba737a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5733,10 +5733,14 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 		   be64_to_cpu(session_token));
 	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
 				H_SESSION_ERR_DETECTED, session_token, 0, 0);
-	if (rc)
+	if (rc) {
 		netdev_err(netdev,
 			   "H_VIOCTL initiated failover failed, rc %ld\n",
 			   rc);
+		goto last_resort;
+	}
+
+	return count;
 
 last_resort:
 	netdev_dbg(netdev, "Trying to send CRQ_CMD, the last resort\n");
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 063ded36b902..ad73dd2540e7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5372,15 +5372,7 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	/* There is no need to reset BW when mqprio mode is on.  */
 	if (pf->flags & I40E_FLAG_TC_MQPRIO)
 		return 0;
-
-	if (!vsi->mqprio_qopt.qopt.hw) {
-		if (pf->flags & I40E_FLAG_DCB_ENABLED)
-			goto skip_reset;
-
-		if (IS_ENABLED(CONFIG_I40E_DCB) &&
-		    i40e_dcb_hw_get_num_tc(&pf->hw) == 1)
-			goto skip_reset;
-
+	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
 		if (ret)
 			dev_info(&pf->pdev->dev,
@@ -5388,8 +5380,6 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 				 vsi->seid);
 		return ret;
 	}
-
-skip_reset:
 	memset(&bw_data, 0, sizeof(bw_data));
 	bw_data.tc_valid_bits = enabled_tc;
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index d119812755b7..387322615e08 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -231,7 +231,6 @@ enum ice_pf_state {
 	ICE_VFLR_EVENT_PENDING,
 	ICE_FLTR_OVERFLOW_PROMISC,
 	ICE_VF_DIS,
-	ICE_VF_DEINIT_IN_PROGRESS,
 	ICE_CFG_BUSY,
 	ICE_SERVICE_SCHED,
 	ICE_SERVICE_DIS,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index f4463e962d52..3de6f16f985a 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3270,7 +3270,7 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 
 	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(hw) &&
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
-		struct ice_link_default_override_tlv tlv;
+		struct ice_link_default_override_tlv tlv = { 0 };
 
 		status = ice_get_link_default_override(&tlv, pi);
 		if (status)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ab2dea0d2c1a..8a0c928853e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1679,7 +1679,9 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 				 * reset, so print the event prior to reset.
 				 */
 				ice_print_vf_rx_mdd_event(vf);
+				mutex_lock(&pf->vf[i].cfg_lock);
 				ice_reset_vf(&pf->vf[i], false);
+				mutex_unlock(&pf->vf[i].cfg_lock);
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ac27a4fe8b94..eb9193682579 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -846,9 +846,12 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 static int ice_ptp_adjtime_nonatomic(struct ptp_clock_info *info, s64 delta)
 {
 	struct timespec64 now, then;
+	int ret;
 
 	then = ns_to_timespec64(delta);
-	ice_ptp_gettimex64(info, &now, NULL);
+	ret = ice_ptp_gettimex64(info, &now, NULL);
+	if (ret)
+		return ret;
 	now = timespec64_add(now, then);
 
 	return ice_ptp_settime64(info, (const struct timespec64 *)&now);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a78e8f00cf71..4054adb5279c 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -615,8 +615,6 @@ void ice_free_vfs(struct ice_pf *pf)
 	struct ice_hw *hw = &pf->hw;
 	unsigned int tmp, i;
 
-	set_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
-
 	if (!pf->vf)
 		return;
 
@@ -632,20 +630,26 @@ void ice_free_vfs(struct ice_pf *pf)
 	else
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
-	/* Avoid wait time by stopping all VFs at the same time */
-	ice_for_each_vf(pf, i)
-		ice_dis_vf_qs(&pf->vf[i]);
-
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
 	pf->num_alloc_vfs = 0;
 	for (i = 0; i < tmp; i++) {
-		if (test_bit(ICE_VF_STATE_INIT, pf->vf[i].vf_states)) {
+		struct ice_vf *vf = &pf->vf[i];
+
+		mutex_lock(&vf->cfg_lock);
+
+		ice_dis_vf_qs(vf);
+
+		if (test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
 			/* disable VF qp mappings and set VF disable state */
-			ice_dis_vf_mappings(&pf->vf[i]);
-			set_bit(ICE_VF_STATE_DIS, pf->vf[i].vf_states);
-			ice_free_vf_res(&pf->vf[i]);
+			ice_dis_vf_mappings(vf);
+			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
+			ice_free_vf_res(vf);
 		}
+
+		mutex_unlock(&vf->cfg_lock);
+
+		mutex_destroy(&vf->cfg_lock);
 	}
 
 	if (ice_sriov_free_msix_res(pf))
@@ -681,7 +685,6 @@ void ice_free_vfs(struct ice_pf *pf)
 				i);
 
 	clear_bit(ICE_VF_DIS, pf->state);
-	clear_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
 
@@ -1565,6 +1568,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	ice_for_each_vf(pf, v) {
 		vf = &pf->vf[v];
 
+		mutex_lock(&vf->cfg_lock);
+
 		vf->driver_caps = 0;
 		ice_vc_set_default_allowlist(vf);
 
@@ -1579,6 +1584,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		ice_vf_pre_vsi_rebuild(vf);
 		ice_vf_rebuild_vsi(vf);
 		ice_vf_post_vsi_rebuild(vf);
+
+		mutex_unlock(&vf->cfg_lock);
 	}
 
 	ice_flush(hw);
@@ -1625,6 +1632,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	u32 reg;
 	int i;
 
+	lockdep_assert_held(&vf->cfg_lock);
+
 	dev = ice_pf_to_dev(pf);
 
 	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
@@ -1894,6 +1903,8 @@ static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
 		 */
 		ice_vf_ctrl_invalidate_vsi(vf);
 		ice_vf_fdir_init(vf);
+
+		mutex_init(&vf->cfg_lock);
 	}
 }
 
@@ -2109,9 +2120,12 @@ void ice_process_vflr_event(struct ice_pf *pf)
 		bit_idx = (hw->func_caps.vf_base_id + vf_id) % 32;
 		/* read GLGEN_VFLRSTAT register to find out the flr VFs */
 		reg = rd32(hw, GLGEN_VFLRSTAT(reg_idx));
-		if (reg & BIT(bit_idx))
+		if (reg & BIT(bit_idx)) {
 			/* GLGEN_VFLRSTAT bit will be cleared in ice_reset_vf */
+			mutex_lock(&vf->cfg_lock);
 			ice_reset_vf(vf, true);
+			mutex_unlock(&vf->cfg_lock);
+		}
 	}
 }
 
@@ -2188,7 +2202,9 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
 	if (!vf)
 		return;
 
+	mutex_lock(&vf->cfg_lock);
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 }
 
 /**
@@ -4082,6 +4098,8 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return 0;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	vf->port_vlan_info = vlanprio;
 
 	if (vf->port_vlan_info)
@@ -4091,6 +4109,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
 
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 
 	return 0;
 }
@@ -4422,10 +4441,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	struct device *dev;
 	int err = 0;
 
-	/* if de-init is underway, don't process messages from VF */
-	if (test_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state))
-		return;
-
 	dev = ice_pf_to_dev(pf);
 	if (ice_validate_vf_id(pf, vf_id)) {
 		err = -EINVAL;
@@ -4465,6 +4480,15 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
+	/* VF is being configured in another context that triggers a VFR, so no
+	 * need to process this message
+	 */
+	if (!mutex_trylock(&vf->cfg_lock)) {
+		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
+			 vf->vf_id);
+		return;
+	}
+
 	switch (v_opcode) {
 	case VIRTCHNL_OP_VERSION:
 		err = ice_vc_get_ver_msg(vf, msg);
@@ -4553,6 +4577,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		dev_info(dev, "PF failed to honor VF %d, opcode %d, error %d\n",
 			 vf_id, v_opcode, err);
 	}
+
+	mutex_unlock(&vf->cfg_lock);
 }
 
 /**
@@ -4668,6 +4694,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		return -EINVAL;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	/* VF is notified of its new MAC via the PF's response to the
 	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
 	 */
@@ -4686,6 +4714,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	}
 
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 	return 0;
 }
 
@@ -4715,11 +4744,15 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	if (trusted == vf->trusted)
 		return 0;
 
+	mutex_lock(&vf->cfg_lock);
+
 	vf->trusted = trusted;
 	ice_vc_reset_vf(vf);
 	dev_info(ice_pf_to_dev(pf), "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
+	mutex_unlock(&vf->cfg_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 38b4dc82c5c1..a750e9a9d712 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -74,6 +74,11 @@ struct ice_mdd_vf_events {
 struct ice_vf {
 	struct ice_pf *pf;
 
+	/* Used during virtchnl message handling and NDO ops against the VF
+	 * that will trigger a VFR
+	 */
+	struct mutex cfg_lock;
+
 	u16 vf_id;			/* VF ID in the PF space */
 	u16 lan_vsi_idx;		/* index into PF struct */
 	u16 ctrl_vsi_idx;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 28d5ad296646..1b61fe2e9b4d 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2700,6 +2700,16 @@ MODULE_DEVICE_TABLE(of, mv643xx_eth_shared_ids);
 
 static struct platform_device *port_platdev[3];
 
+static void mv643xx_eth_shared_of_remove(void)
+{
+	int n;
+
+	for (n = 0; n < 3; n++) {
+		platform_device_del(port_platdev[n]);
+		port_platdev[n] = NULL;
+	}
+}
+
 static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 					  struct device_node *pnp)
 {
@@ -2736,7 +2746,9 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	of_get_mac_address(pnp, ppd.mac_addr);
+	ret = of_get_mac_address(pnp, ppd.mac_addr);
+	if (ret)
+		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
 	mv643xx_eth_property(pnp, "tx-sram-addr", ppd.tx_sram_addr);
@@ -2800,21 +2812,13 @@ static int mv643xx_eth_shared_of_probe(struct platform_device *pdev)
 		ret = mv643xx_eth_shared_of_add_port(pdev, pnp);
 		if (ret) {
 			of_node_put(pnp);
+			mv643xx_eth_shared_of_remove();
 			return ret;
 		}
 	}
 	return 0;
 }
 
-static void mv643xx_eth_shared_of_remove(void)
-{
-	int n;
-
-	for (n = 0; n < 3; n++) {
-		platform_device_del(port_platdev[n]);
-		port_platdev[n] = NULL;
-	}
-}
 #else
 static inline int mv643xx_eth_shared_of_probe(struct platform_device *pdev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
index 60952b33b568..d2333310b56f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -60,37 +60,31 @@ static int parse_tunnel(struct mlx5e_priv *priv,
 			void *headers_v)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-	struct flow_match_enc_keyid enc_keyid;
 	struct flow_match_mpls match;
 	void *misc2_c;
 	void *misc2_v;
 
-	misc2_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			       misc_parameters_2);
-	misc2_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			       misc_parameters_2);
-
-	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS))
-		return 0;
-
-	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
-		return 0;
-
-	flow_rule_match_enc_keyid(rule, &enc_keyid);
-
-	if (!enc_keyid.mask->keyid)
-		return 0;
-
 	if (!MLX5_CAP_ETH(priv->mdev, tunnel_stateless_mpls_over_udp) &&
 	    !(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) & MLX5_FLEX_PROTO_CW_MPLS_UDP))
 		return -EOPNOTSUPP;
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
+		return -EOPNOTSUPP;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS))
+		return 0;
+
 	flow_rule_match_mpls(rule, &match);
 
 	/* Only support matching the first LSE */
 	if (match.mask->used_lses != 1)
 		return -EOPNOTSUPP;
 
+	misc2_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			       misc_parameters_2);
+	misc2_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			       misc_parameters_2);
+
 	MLX5_SET(fte_match_set_misc2, misc2_c,
 		 outer_first_mpls_over_udp.mpls_label,
 		 match.mask->ls[0].mpls_label);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index dc9b8718c3c1..2d3cd237355a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1754,7 +1754,7 @@ static int mlx5e_get_module_eeprom(struct net_device *netdev,
 		if (size_read < 0) {
 			netdev_err(priv->netdev, "%s: mlx5_query_eeprom failed:0x%x\n",
 				   __func__, size_read);
-			return 0;
+			return size_read;
 		}
 
 		i += size_read;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 0015545d5235..d2de1e6c514c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -987,7 +987,8 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 	}
 
 	/* True when explicitly set via priv flag, or XDP prog is loaded */
-	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state))
+	if (test_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &rq->state) ||
+	    get_cqe_tls_offload(cqe))
 		goto csum_unnecessary;
 
 	/* CQE csum doesn't cover padding octets in short ethernet
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f3f23fdc2022..3194cdcd2f63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2784,10 +2784,6 @@ bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
 		return false;
 
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev) ||
-	    mlx5_ecpf_vport_exists(esw->dev))
-		return false;
-
 	return true;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fe501ba88bea..00834c914dc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2041,6 +2041,8 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 		fte->node.del_hw_func = NULL;
 		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
+	} else {
+		up_write_ref_node(&fte->node, false);
 	}
 	kfree(handle);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index df58cba37930..1e8ec4f236b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,6 +121,9 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
+	if (!mlx5_chains_prios_supported(chains))
+		return 1;
+
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 29b7297a836a..097ab6fe371c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -516,7 +516,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 
 	/* Check log_max_qp from HCA caps to set in current profile */
 	if (prof->log_max_qp == LOG_MAX_SUPPORTED_QPS) {
-		prof->log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
+		prof->log_max_qp = min_t(u8, 17, MLX5_CAP_GEN_MAX(dev, log_max_qp));
 	} else if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
 			       prof->log_max_qp,
@@ -1762,10 +1762,12 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family mlx5Gen Virtual Function */
 	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
+	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2dc) },			/* BlueField-3 integrated ConnectX-7 network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2df) },			/* BlueField-4 integrated ConnectX-8 network controller */
 	{ 0, }
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 66c24767e3b0..8ad8d73e17f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -4,7 +4,6 @@
 #include "dr_types.h"
 
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
-#define DR_ICM_SYNC_THRESHOLD_POOL (64 * 1024 * 1024)
 
 struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
@@ -136,37 +135,35 @@ static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_mr *icm_mr)
 	kvfree(icm_mr);
 }
 
-static int dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk)
+static int dr_icm_buddy_get_ste_size(struct mlx5dr_icm_buddy_mem *buddy)
 {
-	chunk->ste_arr = kvzalloc(chunk->num_of_entries *
-				  sizeof(chunk->ste_arr[0]), GFP_KERNEL);
-	if (!chunk->ste_arr)
-		return -ENOMEM;
-
-	chunk->hw_ste_arr = kvzalloc(chunk->num_of_entries *
-				     DR_STE_SIZE_REDUCED, GFP_KERNEL);
-	if (!chunk->hw_ste_arr)
-		goto out_free_ste_arr;
-
-	chunk->miss_list = kvmalloc(chunk->num_of_entries *
-				    sizeof(chunk->miss_list[0]), GFP_KERNEL);
-	if (!chunk->miss_list)
-		goto out_free_hw_ste_arr;
+	/* We support only one type of STE size, both for ConnectX-5 and later
+	 * devices. Once the support for match STE which has a larger tag is
+	 * added (32B instead of 16B), the STE size for devices later than
+	 * ConnectX-5 needs to account for that.
+	 */
+	return DR_STE_SIZE_REDUCED;
+}
 
-	return 0;
+static void dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk, int offset)
+{
+	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
+	int index = offset / DR_STE_SIZE;
 
-out_free_hw_ste_arr:
-	kvfree(chunk->hw_ste_arr);
-out_free_ste_arr:
-	kvfree(chunk->ste_arr);
-	return -ENOMEM;
+	chunk->ste_arr = &buddy->ste_arr[index];
+	chunk->miss_list = &buddy->miss_list[index];
+	chunk->hw_ste_arr = buddy->hw_ste_arr +
+			    index * dr_icm_buddy_get_ste_size(buddy);
 }
 
 static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
 {
-	kvfree(chunk->miss_list);
-	kvfree(chunk->hw_ste_arr);
-	kvfree(chunk->ste_arr);
+	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
+
+	memset(chunk->hw_ste_arr, 0,
+	       chunk->num_of_entries * dr_icm_buddy_get_ste_size(buddy));
+	memset(chunk->ste_arr, 0,
+	       chunk->num_of_entries * sizeof(chunk->ste_arr[0]));
 }
 
 static enum mlx5dr_icm_type
@@ -189,6 +186,44 @@ static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk,
 	kvfree(chunk);
 }
 
+static int dr_icm_buddy_init_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
+{
+	int num_of_entries =
+		mlx5dr_icm_pool_chunk_size_to_entries(buddy->pool->max_log_chunk_sz);
+
+	buddy->ste_arr = kvcalloc(num_of_entries,
+				  sizeof(struct mlx5dr_ste), GFP_KERNEL);
+	if (!buddy->ste_arr)
+		return -ENOMEM;
+
+	/* Preallocate full STE size on non-ConnectX-5 devices since
+	 * we need to support both full and reduced with the same cache.
+	 */
+	buddy->hw_ste_arr = kvcalloc(num_of_entries,
+				     dr_icm_buddy_get_ste_size(buddy), GFP_KERNEL);
+	if (!buddy->hw_ste_arr)
+		goto free_ste_arr;
+
+	buddy->miss_list = kvmalloc(num_of_entries * sizeof(struct list_head), GFP_KERNEL);
+	if (!buddy->miss_list)
+		goto free_hw_ste_arr;
+
+	return 0;
+
+free_hw_ste_arr:
+	kvfree(buddy->hw_ste_arr);
+free_ste_arr:
+	kvfree(buddy->ste_arr);
+	return -ENOMEM;
+}
+
+static void dr_icm_buddy_cleanup_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
+{
+	kvfree(buddy->ste_arr);
+	kvfree(buddy->hw_ste_arr);
+	kvfree(buddy->miss_list);
+}
+
 static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 {
 	struct mlx5dr_icm_buddy_mem *buddy;
@@ -208,11 +243,19 @@ static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 	buddy->icm_mr = icm_mr;
 	buddy->pool = pool;
 
+	if (pool->icm_type == DR_ICM_TYPE_STE) {
+		/* Reduce allocations by preallocating and reusing the STE structures */
+		if (dr_icm_buddy_init_ste_cache(buddy))
+			goto err_cleanup_buddy;
+	}
+
 	/* add it to the -start- of the list in order to search in it first */
 	list_add(&buddy->list_node, &pool->buddy_mem_list);
 
 	return 0;
 
+err_cleanup_buddy:
+	mlx5dr_buddy_cleanup(buddy);
 err_free_buddy:
 	kvfree(buddy);
 free_mr:
@@ -234,6 +277,9 @@ static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 
 	mlx5dr_buddy_cleanup(buddy);
 
+	if (buddy->pool->icm_type == DR_ICM_TYPE_STE)
+		dr_icm_buddy_cleanup_ste_cache(buddy);
+
 	kvfree(buddy);
 }
 
@@ -261,34 +307,30 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 	chunk->byte_size =
 		mlx5dr_icm_pool_chunk_size_to_byte(chunk_size, pool->icm_type);
 	chunk->seg = seg;
+	chunk->buddy_mem = buddy_mem_pool;
 
-	if (pool->icm_type == DR_ICM_TYPE_STE && dr_icm_chunk_ste_init(chunk)) {
-		mlx5dr_err(pool->dmn,
-			   "Failed to init ste arrays (order: %d)\n",
-			   chunk_size);
-		goto out_free_chunk;
-	}
+	if (pool->icm_type == DR_ICM_TYPE_STE)
+		dr_icm_chunk_ste_init(chunk, offset);
 
 	buddy_mem_pool->used_memory += chunk->byte_size;
-	chunk->buddy_mem = buddy_mem_pool;
 	INIT_LIST_HEAD(&chunk->chunk_list);
 
 	/* chunk now is part of the used_list */
 	list_add_tail(&chunk->chunk_list, &buddy_mem_pool->used_list);
 
 	return chunk;
-
-out_free_chunk:
-	kvfree(chunk);
-	return NULL;
 }
 
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	if (pool->hot_memory_size > DR_ICM_SYNC_THRESHOLD_POOL)
-		return true;
+	int allow_hot_size;
+
+	/* sync when hot memory reaches half of the pool size */
+	allow_hot_size =
+		mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
+						   pool->icm_type) / 2;
 
-	return false;
+	return pool->hot_memory_size > allow_hot_size;
 }
 
 static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index b5409cc021d3..a19e8157c100 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -13,18 +13,6 @@ static bool dr_mask_is_dmac_set(struct mlx5dr_match_spec *spec)
 	return (spec->dmac_47_16 || spec->dmac_15_0);
 }
 
-static bool dr_mask_is_src_addr_set(struct mlx5dr_match_spec *spec)
-{
-	return (spec->src_ip_127_96 || spec->src_ip_95_64 ||
-		spec->src_ip_63_32 || spec->src_ip_31_0);
-}
-
-static bool dr_mask_is_dst_addr_set(struct mlx5dr_match_spec *spec)
-{
-	return (spec->dst_ip_127_96 || spec->dst_ip_95_64 ||
-		spec->dst_ip_63_32 || spec->dst_ip_31_0);
-}
-
 static bool dr_mask_is_l3_base_set(struct mlx5dr_match_spec *spec)
 {
 	return (spec->ip_protocol || spec->frag || spec->tcp_flags ||
@@ -480,11 +468,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 						    &mask, inner, rx);
 
 		if (outer_ipv == DR_RULE_IPV6) {
-			if (dr_mask_is_dst_addr_set(&mask.outer))
+			if (DR_MASK_IS_DST_IP_SET(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
-			if (dr_mask_is_src_addr_set(&mask.outer))
+			if (DR_MASK_IS_SRC_IP_SET(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
@@ -580,11 +568,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 						    &mask, inner, rx);
 
 		if (inner_ipv == DR_RULE_IPV6) {
-			if (dr_mask_is_dst_addr_set(&mask.inner))
+			if (DR_MASK_IS_DST_IP_SET(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
-			if (dr_mask_is_src_addr_set(&mask.inner))
+			if (DR_MASK_IS_SRC_IP_SET(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
 								 &mask, inner, rx);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 1cdfe4fccc7a..01246a1ae7d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -602,12 +602,34 @@ int mlx5dr_ste_set_action_decap_l3_list(struct mlx5dr_ste_ctx *ste_ctx,
 						 used_hw_action_num);
 }
 
+static int dr_ste_build_pre_check_spec(struct mlx5dr_domain *dmn,
+				       struct mlx5dr_match_spec *spec)
+{
+	if (spec->ip_version) {
+		if (spec->ip_version != 0xf) {
+			mlx5dr_err(dmn,
+				   "Partial ip_version mask with src/dst IP is not supported\n");
+			return -EINVAL;
+		}
+	} else if (spec->ethertype != 0xffff &&
+		   (DR_MASK_IS_SRC_IP_SET(spec) || DR_MASK_IS_DST_IP_SET(spec))) {
+		mlx5dr_err(dmn,
+			   "Partial/no ethertype mask with src/dst IP is not supported\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 			       u8 match_criteria,
 			       struct mlx5dr_match_param *mask,
 			       struct mlx5dr_match_param *value)
 {
-	if (!value && (match_criteria & DR_MATCHER_CRITERIA_MISC)) {
+	if (value)
+		return 0;
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC) {
 		if (mask->misc.source_port && mask->misc.source_port != 0xffff) {
 			mlx5dr_err(dmn,
 				   "Partial mask source_port is not supported\n");
@@ -621,6 +643,14 @@ int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 		}
 	}
 
+	if ((match_criteria & DR_MATCHER_CRITERIA_OUTER) &&
+	    dr_ste_build_pre_check_spec(dmn, &mask->outer))
+		return -EINVAL;
+
+	if ((match_criteria & DR_MATCHER_CRITERIA_INNER) &&
+	    dr_ste_build_pre_check_spec(dmn, &mask->inner))
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index b20e8aabb861..3d4e035698dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -740,6 +740,16 @@ struct mlx5dr_match_param {
 				       (_misc3)->icmpv4_code || \
 				       (_misc3)->icmpv4_header_data)
 
+#define DR_MASK_IS_SRC_IP_SET(_spec) ((_spec)->src_ip_127_96 || \
+				      (_spec)->src_ip_95_64  || \
+				      (_spec)->src_ip_63_32  || \
+				      (_spec)->src_ip_31_0)
+
+#define DR_MASK_IS_DST_IP_SET(_spec) ((_spec)->dst_ip_127_96 || \
+				      (_spec)->dst_ip_95_64  || \
+				      (_spec)->dst_ip_63_32  || \
+				      (_spec)->dst_ip_31_0)
+
 struct mlx5dr_esw_caps {
 	u64 drop_icm_address_rx;
 	u64 drop_icm_address_tx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index c5a8b1601999..5ef199543479 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -160,6 +160,11 @@ struct mlx5dr_icm_buddy_mem {
 	 * sync_ste command sets them free.
 	 */
 	struct list_head	hot_list;
+
+	/* Memory optimisation */
+	struct mlx5dr_ste	*ste_arr;
+	struct list_head	*miss_list;
+	u8			*hw_ste_arr;
 };
 
 int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 6521675be85c..babd374333f3 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -922,8 +922,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 			  int port, bool mod)
 {
 	struct nfp_flower_priv *priv = app->priv;
-	int ida_idx = NFP_MAX_MAC_INDEX, err;
 	struct nfp_tun_offloaded_mac *entry;
+	int ida_idx = -1, err;
 	u16 nfp_mac_idx = 0;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
@@ -997,7 +997,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 err_free_entry:
 	kfree(entry);
 err_free_ida:
-	if (ida_idx != NFP_MAX_MAC_INDEX)
+	if (ida_idx != -1)
 		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
 
 	return err;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 463094ced104..2ab29efa6b6e 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1427,6 +1427,8 @@ static int temac_probe(struct platform_device *pdev)
 		lp->indirect_lock = devm_kmalloc(&pdev->dev,
 						 sizeof(*lp->indirect_lock),
 						 GFP_KERNEL);
+		if (!lp->indirect_lock)
+			return -ENOMEM;
 		spin_lock_init(lp->indirect_lock);
 	}
 
diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 5f4cd24a0241..4eba5a91075c 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -200,7 +200,11 @@ static int ipq_mdio_reset(struct mii_bus *bus)
 	if (ret)
 		return ret;
 
-	return clk_prepare_enable(priv->mdio_clk);
+	ret = clk_prepare_enable(priv->mdio_clk);
+	if (ret == 0)
+		mdelay(10);
+
+	return ret;
 }
 
 static int ipq4019_mdio_probe(struct platform_device *pdev)
diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index eb3817d70f2b..9b4dfa3001d6 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -583,6 +583,11 @@ static const struct usb_device_id	products[] = {
 	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
 
+#define ZAURUS_FAKE_INTERFACE \
+	.bInterfaceClass	= USB_CLASS_COMM, \
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
+
 /* SA-1100 based Sharp Zaurus ("collie"), or compatible;
  * wire-incompatible with true CDC Ethernet implementations.
  * (And, it seems, needlessly so...)
@@ -636,6 +641,13 @@ static const struct usb_device_id	products[] = {
 	.idProduct              = 0x9032,	/* SL-6000 */
 	ZAURUS_MASTER_INTERFACE,
 	.driver_info		= 0,
+}, {
+	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
+		 | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor               = 0x04DD,
+	.idProduct              = 0x9032,	/* SL-6000 */
+	ZAURUS_FAKE_INTERFACE,
+	.driver_info		= 0,
 }, {
 	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
 		 | USB_DEVICE_ID_MATCH_DEVICE,
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e303b522efb5..15f91d691bba 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1715,10 +1715,10 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
 {
 	struct sk_buff *skb;
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
-	int len;
+	unsigned int len;
 	int nframes;
 	int x;
-	int offset;
+	unsigned int offset;
 	union {
 		struct usb_cdc_ncm_ndp16 *ndp16;
 		struct usb_cdc_ncm_ndp32 *ndp32;
@@ -1790,8 +1790,8 @@ int cdc_ncm_rx_fixup(struct usbnet *dev, struct sk_buff *skb_in)
 			break;
 		}
 
-		/* sanity checking */
-		if (((offset + len) > skb_in->len) ||
+		/* sanity checking - watch out for integer wrap*/
+		if ((offset > skb_in->len) || (len > skb_in->len - offset) ||
 				(len > ctx->rx_max) || (len < ETH_HLEN)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "invalid frame detected (ignored) offset[%u]=%u, length=%u, skb=%p\n",
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 6516a37893e2..0c50f24671da 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN)
+		if (len > ETH_FRAME_LEN || len > skb->len)
 			return 0;
 
 		/* the last packet of current skb */
diff --git a/drivers/net/usb/zaurus.c b/drivers/net/usb/zaurus.c
index 8e717a0b559b..7984f2157d22 100644
--- a/drivers/net/usb/zaurus.c
+++ b/drivers/net/usb/zaurus.c
@@ -256,6 +256,11 @@ static const struct usb_device_id	products [] = {
 	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
 	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
 
+#define ZAURUS_FAKE_INTERFACE \
+	.bInterfaceClass	= USB_CLASS_COMM, \
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
+
 /* SA-1100 based Sharp Zaurus ("collie"), or compatible. */
 {
 	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
@@ -313,6 +318,13 @@ static const struct usb_device_id	products [] = {
 	.idProduct              = 0x9032,	/* SL-6000 */
 	ZAURUS_MASTER_INTERFACE,
 	.driver_info = ZAURUS_PXA_INFO,
+}, {
+	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
+			    | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x04DD,
+	.idProduct		= 0x9032,	/* SL-6000 */
+	ZAURUS_FAKE_INTERFACE,
+	.driver_info = (unsigned long)&bogus_mdlm_info,
 }, {
 	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
 		 | USB_DEVICE_ID_MATCH_DEVICE,
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a480e1af48e8..d5d5d035d677 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1914,7 +1914,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 	if (blk_queue_is_zoned(ns->queue)) {
 		ret = nvme_revalidate_zones(ns);
 		if (ret && !nvme_first_scan(ns->disk))
-			goto out;
+			return ret;
 	}
 
 	if (nvme_ns_head_multipath(ns->head)) {
@@ -1929,16 +1929,16 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 	return 0;
 
 out_unfreeze:
-	blk_mq_unfreeze_queue(ns->disk->queue);
-out:
 	/*
 	 * If probing fails due an unsupported feature, hide the block device,
 	 * but still allow other access.
 	 */
 	if (ret == -ENODEV) {
 		ns->disk->flags |= GENHD_FL_HIDDEN;
+		set_bit(NVME_NS_READY, &ns->flags);
 		ret = 0;
 	}
+	blk_mq_unfreeze_queue(ns->disk->queue);
 	return ret;
 }
 
diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 9aecb83021a2..fb7840c73765 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -768,7 +768,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
-	else
+	else if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
diff --git a/drivers/pinctrl/pinctrl-k210.c b/drivers/pinctrl/pinctrl-k210.c
index 49e32684dbb2..ecab6bf63dc6 100644
--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -482,7 +482,7 @@ static int k210_pinconf_get_drive(unsigned int max_strength_ua)
 {
 	int i;
 
-	for (i = K210_PC_DRIVE_MAX; i; i--) {
+	for (i = K210_PC_DRIVE_MAX; i >= 0; i--) {
 		if (k210_pinconf_drive_strength[i] <= max_strength_ua)
 			return i;
 	}
@@ -527,7 +527,7 @@ static int k210_pinconf_set_param(struct pinctrl_dev *pctldev,
 	case PIN_CONFIG_BIAS_PULL_UP:
 		if (!arg)
 			return -EINVAL;
-		val |= K210_PC_PD;
+		val |= K210_PC_PU;
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		arg *= 1000;
diff --git a/drivers/platform/surface/surface3_power.c b/drivers/platform/surface/surface3_power.c
index 90c1568ea4e0..3cc004c68bdb 100644
--- a/drivers/platform/surface/surface3_power.c
+++ b/drivers/platform/surface/surface3_power.c
@@ -233,14 +233,21 @@ static int mshw0011_bix(struct mshw0011_data *cdata, struct bix *bix)
 	}
 	bix->last_full_charg_capacity = ret;
 
-	/* get serial number */
+	/*
+	 * Get serial number, on some devices (with unofficial replacement
+	 * battery?) reading any of the serial number range addresses gets
+	 * nacked in this case just leave the serial number empty.
+	 */
 	ret = i2c_smbus_read_i2c_block_data(client, MSHW0011_BAT0_REG_SERIAL_NO,
 					    sizeof(buf), buf);
-	if (ret != sizeof(buf)) {
+	if (ret == -EREMOTEIO) {
+		/* no serial number available */
+	} else if (ret != sizeof(buf)) {
 		dev_err(&client->dev, "Error reading serial no: %d\n", ret);
 		return ret;
+	} else {
+		snprintf(bix->serial, ARRAY_SIZE(bix->serial), "%3pE%6pE", buf + 7, buf);
 	}
-	snprintf(bix->serial, ARRAY_SIZE(bix->serial), "%3pE%6pE", buf + 7, buf);
 
 	/* get cycle count */
 	ret = i2c_smbus_read_word_data(client, MSHW0011_BAT0_REG_CYCLE_CNT);
diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index cfa222c9bd5e..78f31b61a2aa 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -570,6 +570,9 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 
 	if (op->dummy.nbytes) {
 		tmpbuf = kzalloc(op->dummy.nbytes, GFP_KERNEL);
+		if (!tmpbuf)
+			return -ENOMEM;
+
 		memset(tmpbuf, 0xff, op->dummy.nbytes);
 		reinit_completion(&xqspi->data_completion);
 		xqspi->txbuf = tmpbuf;
diff --git a/drivers/staging/fbtft/fb_st7789v.c b/drivers/staging/fbtft/fb_st7789v.c
index abe9395a0aef..861a154144e6 100644
--- a/drivers/staging/fbtft/fb_st7789v.c
+++ b/drivers/staging/fbtft/fb_st7789v.c
@@ -144,6 +144,8 @@ static int init_display(struct fbtft_par *par)
 {
 	int rc;
 
+	par->fbtftops.reset(par);
+
 	rc = init_tearing_effect_line(par);
 	if (rc)
 		return rc;
diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 5363ebebfc35..50c0d839fe75 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -588,6 +588,7 @@ static int optee_remove(struct platform_device *pdev)
 	/* Unregister OP-TEE specific client devices on TEE bus */
 	optee_unregister_devices();
 
+	teedev_close_context(optee->ctx);
 	/*
 	 * Ask OP-TEE to free all cached shared memory objects to decrease
 	 * reference counters and also avoid wild pointers in secure world
@@ -633,6 +634,7 @@ static int optee_probe(struct platform_device *pdev)
 	struct optee *optee = NULL;
 	void *memremaped_shm = NULL;
 	struct tee_device *teedev;
+	struct tee_context *ctx;
 	u32 sec_caps;
 	int rc;
 
@@ -719,6 +721,12 @@ static int optee_probe(struct platform_device *pdev)
 	optee_supp_init(&optee->supp);
 	optee->memremaped_shm = memremaped_shm;
 	optee->pool = pool;
+	ctx = teedev_open(optee->teedev);
+	if (IS_ERR(ctx)) {
+		rc = PTR_ERR(ctx);
+		goto err;
+	}
+	optee->ctx = ctx;
 
 	/*
 	 * Ensure that there are no pre-existing shm objects before enabling
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index f6bb4a763ba9..ea09533e30cd 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -70,6 +70,7 @@ struct optee_supp {
  * struct optee - main service struct
  * @supp_teedev:	supplicant device
  * @teedev:		client device
+ * @ctx:		driver internal TEE context
  * @invoke_fn:		function to issue smc or hvc
  * @call_queue:		queue of threads waiting to call @invoke_fn
  * @wait_queue:		queue of threads from secure world waiting for a
@@ -87,6 +88,7 @@ struct optee {
 	struct tee_device *supp_teedev;
 	struct tee_device *teedev;
 	optee_invoke_fn *invoke_fn;
+	struct tee_context *ctx;
 	struct optee_call_queue call_queue;
 	struct optee_wait_queue wait_queue;
 	struct optee_supp supp;
diff --git a/drivers/tee/optee/rpc.c b/drivers/tee/optee/rpc.c
index efbaff7ad7e5..456833d82007 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -285,6 +285,7 @@ static struct tee_shm *cmd_alloc_suppl(struct tee_context *ctx, size_t sz)
 }
 
 static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					  struct optee *optee,
 					  struct optee_msg_arg *arg,
 					  struct optee_call_ctx *call_ctx)
 {
@@ -314,7 +315,8 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
+		shm = tee_shm_alloc(optee->ctx, sz,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -471,7 +473,7 @@ static void handle_rpc_func_cmd(struct tee_context *ctx, struct optee *optee,
 		break;
 	case OPTEE_RPC_CMD_SHM_ALLOC:
 		free_pages_list(call_ctx);
-		handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
+		handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
 		break;
 	case OPTEE_RPC_CMD_SHM_FREE:
 		handle_rpc_func_cmd_shm_free(ctx, arg);
@@ -502,7 +504,7 @@ void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1,
+		shm = tee_shm_alloc(optee->ctx, param->a1,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);
diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 85102d12d716..3fc426dad2df 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -43,7 +43,7 @@ static DEFINE_SPINLOCK(driver_lock);
 static struct class *tee_class;
 static dev_t tee_devt;
 
-static struct tee_context *teedev_open(struct tee_device *teedev)
+struct tee_context *teedev_open(struct tee_device *teedev)
 {
 	int rc;
 	struct tee_context *ctx;
@@ -70,6 +70,7 @@ static struct tee_context *teedev_open(struct tee_device *teedev)
 	return ERR_PTR(rc);
 
 }
+EXPORT_SYMBOL_GPL(teedev_open);
 
 void teedev_ctx_get(struct tee_context *ctx)
 {
@@ -96,13 +97,14 @@ void teedev_ctx_put(struct tee_context *ctx)
 	kref_put(&ctx->refcount, teedev_ctx_release);
 }
 
-static void teedev_close_context(struct tee_context *ctx)
+void teedev_close_context(struct tee_context *ctx)
 {
 	struct tee_device *teedev = ctx->teedev;
 
 	teedev_ctx_put(ctx);
 	tee_device_put(teedev);
 }
+EXPORT_SYMBOL_GPL(teedev_close_context);
 
 static int tee_open(struct inode *inode, struct file *filp)
 {
diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 19926beeb3b7..176b8e5d2124 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -405,6 +405,10 @@ static void int3400_notify(acpi_handle handle,
 	thermal_prop[3] = kasprintf(GFP_KERNEL, "EVENT=%d", therm_event);
 	thermal_prop[4] = NULL;
 	kobject_uevent_env(&priv->thermal->device.kobj, KOBJ_CHANGE, thermal_prop);
+	kfree(thermal_prop[0]);
+	kfree(thermal_prop[1]);
+	kfree(thermal_prop[2]);
+	kfree(thermal_prop[3]);
 }
 
 static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 09a14f7c79f4..8643b143c408 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -435,7 +435,7 @@ static u8 gsm_encode_modem(const struct gsm_dlci *dlci)
 		modembits |= MDM_RTR;
 	if (dlci->modem_tx & TIOCM_RI)
 		modembits |= MDM_IC;
-	if (dlci->modem_tx & TIOCM_CD)
+	if (dlci->modem_tx & TIOCM_CD || dlci->gsm->initiator)
 		modembits |= MDM_DV;
 	return modembits;
 }
@@ -1009,25 +1009,25 @@ static void gsm_control_reply(struct gsm_mux *gsm, int cmd, const u8 *data,
  *	@tty: virtual tty bound to the DLCI
  *	@dlci: DLCI to affect
  *	@modem: modem bits (full EA)
- *	@clen: command length
+ *	@slen: number of signal octets
  *
  *	Used when a modem control message or line state inline in adaption
  *	layer 2 is processed. Sort out the local modem state and throttles
  */
 
 static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
-							u32 modem, int clen)
+							u32 modem, int slen)
 {
 	int  mlines = 0;
 	u8 brk = 0;
 	int fc;
 
-	/* The modem status command can either contain one octet (v.24 signals)
-	   or two octets (v.24 signals + break signals). The length field will
-	   either be 2 or 3 respectively. This is specified in section
-	   5.4.6.3.7 of the  27.010 mux spec. */
+	/* The modem status command can either contain one octet (V.24 signals)
+	 * or two octets (V.24 signals + break signals). This is specified in
+	 * section 5.4.6.3.7 of the 07.10 mux spec.
+	 */
 
-	if (clen == 2)
+	if (slen == 1)
 		modem = modem & 0x7f;
 	else {
 		brk = modem & 0x7f;
@@ -1084,6 +1084,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
+	int slen;
 	const u8 *dp = data;
 	struct tty_struct *tty;
 
@@ -1103,6 +1104,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 		return;
 	dlci = gsm->dlci[addr];
 
+	slen = len;
 	while (gsm_read_ea(&modem, *dp++) == 0) {
 		len--;
 		if (len == 0)
@@ -1119,7 +1121,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, const u8 *data, int clen)
 		modem |= (brk & 0x7f);
 	}
 	tty = tty_port_tty_get(&dlci->port);
-	gsm_process_modem(tty, dlci, modem, clen);
+	gsm_process_modem(tty, dlci, modem, slen);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
@@ -1429,6 +1431,9 @@ static void gsm_dlci_close(struct gsm_dlci *dlci)
 	if (dlci->addr != 0) {
 		tty_port_tty_hangup(&dlci->port, false);
 		kfifo_reset(&dlci->fifo);
+		/* Ensure that gsmtty_open() can return. */
+		tty_port_set_initialized(&dlci->port, 0);
+		wake_up_interruptible(&dlci->port.open_wait);
 	} else
 		dlci->gsm->dead = true;
 	wake_up(&dlci->gsm->event);
@@ -1488,7 +1493,7 @@ static void gsm_dlci_t1(struct timer_list *t)
 			dlci->mode = DLCI_MODE_ADM;
 			gsm_dlci_open(dlci);
 		} else {
-			gsm_dlci_close(dlci);
+			gsm_dlci_begin_close(dlci); /* prevent half open link */
 		}
 
 		break;
@@ -1567,6 +1572,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 	struct tty_struct *tty;
 	unsigned int modem = 0;
 	int len = clen;
+	int slen = 0;
 
 	if (debug & 16)
 		pr_debug("%d bytes for tty\n", len);
@@ -1579,12 +1585,14 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 	case 2:		/* Asynchronous serial with line state in each frame */
 		while (gsm_read_ea(&modem, *data++) == 0) {
 			len--;
+			slen++;
 			if (len == 0)
 				return;
 		}
+		slen++;
 		tty = tty_port_tty_get(port);
 		if (tty) {
-			gsm_process_modem(tty, dlci, modem, clen);
+			gsm_process_modem(tty, dlci, modem, slen);
 			tty_kref_put(tty);
 		}
 		fallthrough;
@@ -1722,7 +1730,12 @@ static void gsm_dlci_release(struct gsm_dlci *dlci)
 		gsm_destroy_network(dlci);
 		mutex_unlock(&dlci->mutex);
 
-		tty_hangup(tty);
+		/* We cannot use tty_hangup() because in tty_kref_put() the tty
+		 * driver assumes that the hangup queue is free and reuses it to
+		 * queue release_one_tty() -> NULL pointer panic in
+		 * process_one_work().
+		 */
+		tty_vhangup(tty);
 
 		tty_port_tty_set(&dlci->port, NULL);
 		tty_kref_put(tty);
@@ -3175,9 +3188,9 @@ static void gsmtty_throttle(struct tty_struct *tty)
 	if (dlci->state == DLCI_CLOSED)
 		return;
 	if (C_CRTSCTS(tty))
-		dlci->modem_tx &= ~TIOCM_DTR;
+		dlci->modem_tx &= ~TIOCM_RTS;
 	dlci->throttled = true;
-	/* Send an MSC with DTR cleared */
+	/* Send an MSC with RTS cleared */
 	gsmtty_modem_update(dlci, 0);
 }
 
@@ -3187,9 +3200,9 @@ static void gsmtty_unthrottle(struct tty_struct *tty)
 	if (dlci->state == DLCI_CLOSED)
 		return;
 	if (C_CRTSCTS(tty))
-		dlci->modem_tx |= TIOCM_DTR;
+		dlci->modem_tx |= TIOCM_RTS;
 	dlci->throttled = false;
-	/* Send an MSC with DTR set */
+	/* Send an MSC with RTS set */
 	gsmtty_modem_update(dlci, 0);
 }
 
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index acbb615dd28f..0ab788058fa2 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -734,12 +734,15 @@ static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
 static void sc16is7xx_tx_proc(struct kthread_work *ws)
 {
 	struct uart_port *port = &(to_sc16is7xx_one(ws, tx_work)->port);
+	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 
 	if ((port->rs485.flags & SER_RS485_ENABLED) &&
 	    (port->rs485.delay_rts_before_send > 0))
 		msleep(port->rs485.delay_rts_before_send);
 
+	mutex_lock(&s->efr_lock);
 	sc16is7xx_handle_tx(port);
+	mutex_unlock(&s->efr_lock);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index cb9059a8444b..71e62b3081db 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -1417,6 +1417,7 @@ void dwc2_hsotg_core_connect(struct dwc2_hsotg *hsotg);
 void dwc2_hsotg_disconnect(struct dwc2_hsotg *dwc2);
 int dwc2_hsotg_set_test_mode(struct dwc2_hsotg *hsotg, int testmode);
 #define dwc2_is_device_connected(hsotg) (hsotg->connected)
+#define dwc2_is_device_enabled(hsotg) (hsotg->enabled)
 int dwc2_backup_device_registers(struct dwc2_hsotg *hsotg);
 int dwc2_restore_device_registers(struct dwc2_hsotg *hsotg, int remote_wakeup);
 int dwc2_gadget_enter_hibernation(struct dwc2_hsotg *hsotg);
@@ -1453,6 +1454,7 @@ static inline int dwc2_hsotg_set_test_mode(struct dwc2_hsotg *hsotg,
 					   int testmode)
 { return 0; }
 #define dwc2_is_device_connected(hsotg) (0)
+#define dwc2_is_device_enabled(hsotg) (0)
 static inline int dwc2_backup_device_registers(struct dwc2_hsotg *hsotg)
 { return 0; }
 static inline int dwc2_restore_device_registers(struct dwc2_hsotg *hsotg,
diff --git a/drivers/usb/dwc2/drd.c b/drivers/usb/dwc2/drd.c
index aa6eb76f64dd..36f2c38416e5 100644
--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -109,8 +109,10 @@ static int dwc2_drd_role_sw_set(struct usb_role_switch *sw, enum usb_role role)
 		already = dwc2_ovr_avalid(hsotg, true);
 	} else if (role == USB_ROLE_DEVICE) {
 		already = dwc2_ovr_bvalid(hsotg, true);
-		/* This clear DCTL.SFTDISCON bit */
-		dwc2_hsotg_core_connect(hsotg);
+		if (dwc2_is_device_enabled(hsotg)) {
+			/* This clear DCTL.SFTDISCON bit */
+			dwc2_hsotg_core_connect(hsotg);
+		}
 	} else {
 		if (dwc2_is_device_mode(hsotg)) {
 			if (!dwc2_ovr_bvalid(hsotg, false))
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 7ff8fc8f79a9..1ecedbb1684c 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -85,8 +85,8 @@ static const struct acpi_gpio_mapping acpi_dwc3_byt_gpios[] = {
 static struct gpiod_lookup_table platform_bytcr_gpios = {
 	.dev_id		= "0000:00:16.0",
 	.table		= {
-		GPIO_LOOKUP("INT33FC:00", 54, "reset", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("INT33FC:02", 14, "cs", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("INT33FC:00", 54, "cs", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("INT33FC:02", 14, "reset", GPIO_ACTIVE_HIGH),
 		{}
 	},
 };
@@ -119,6 +119,13 @@ static const struct property_entry dwc3_pci_intel_properties[] = {
 	{}
 };
 
+static const struct property_entry dwc3_pci_intel_byt_properties[] = {
+	PROPERTY_ENTRY_STRING("dr_mode", "peripheral"),
+	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
+	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
+	{}
+};
+
 static const struct property_entry dwc3_pci_mrfld_properties[] = {
 	PROPERTY_ENTRY_STRING("dr_mode", "otg"),
 	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
@@ -161,6 +168,10 @@ static const struct software_node dwc3_pci_intel_swnode = {
 	.properties = dwc3_pci_intel_properties,
 };
 
+static const struct software_node dwc3_pci_intel_byt_swnode = {
+	.properties = dwc3_pci_intel_byt_properties,
+};
+
 static const struct software_node dwc3_pci_intel_mrfld_swnode = {
 	.properties = dwc3_pci_mrfld_properties,
 };
@@ -344,7 +355,7 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BYT),
-	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+	  (kernel_ulong_t) &dwc3_pci_intel_byt_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
 	  (kernel_ulong_t) &dwc3_pci_intel_mrfld_swnode, },
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 146cebde33b8..00cf8ebcb338 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4131,9 +4131,11 @@ static irqreturn_t dwc3_thread_interrupt(int irq, void *_evt)
 	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
 
+	local_bh_disable();
 	spin_lock_irqsave(&dwc->lock, flags);
 	ret = dwc3_process_event_buf(evt);
 	spin_unlock_irqrestore(&dwc->lock, flags);
+	local_bh_enable();
 
 	return ret;
 }
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index d9ed651f06ac..0f14c5291af0 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -922,6 +922,7 @@ struct rndis_params *rndis_register(void (*resp_avail)(void *v), void *v)
 	params->resp_avail = resp_avail;
 	params->v = v;
 	INIT_LIST_HEAD(&params->resp_queue);
+	spin_lock_init(&params->resp_lock);
 	pr_debug("%s: configNr = %d\n", __func__, i);
 
 	return params;
@@ -1015,12 +1016,14 @@ void rndis_free_response(struct rndis_params *params, u8 *buf)
 {
 	rndis_resp_t *r, *n;
 
+	spin_lock(&params->resp_lock);
 	list_for_each_entry_safe(r, n, &params->resp_queue, list) {
 		if (r->buf == buf) {
 			list_del(&r->list);
 			kfree(r);
 		}
 	}
+	spin_unlock(&params->resp_lock);
 }
 EXPORT_SYMBOL_GPL(rndis_free_response);
 
@@ -1030,14 +1033,17 @@ u8 *rndis_get_next_response(struct rndis_params *params, u32 *length)
 
 	if (!length) return NULL;
 
+	spin_lock(&params->resp_lock);
 	list_for_each_entry_safe(r, n, &params->resp_queue, list) {
 		if (!r->send) {
 			r->send = 1;
 			*length = r->length;
+			spin_unlock(&params->resp_lock);
 			return r->buf;
 		}
 	}
 
+	spin_unlock(&params->resp_lock);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(rndis_get_next_response);
@@ -1054,7 +1060,9 @@ static rndis_resp_t *rndis_add_response(struct rndis_params *params, u32 length)
 	r->length = length;
 	r->send = 0;
 
+	spin_lock(&params->resp_lock);
 	list_add_tail(&r->list, &params->resp_queue);
+	spin_unlock(&params->resp_lock);
 	return r;
 }
 
diff --git a/drivers/usb/gadget/function/rndis.h b/drivers/usb/gadget/function/rndis.h
index f6167f7fea82..6206b8b7490f 100644
--- a/drivers/usb/gadget/function/rndis.h
+++ b/drivers/usb/gadget/function/rndis.h
@@ -174,6 +174,7 @@ typedef struct rndis_params {
 	void			(*resp_avail)(void *v);
 	void			*v;
 	struct list_head	resp_queue;
+	spinlock_t		resp_lock;
 } rndis_params;
 
 /* RNDIS Message parser and other useless functions */
diff --git a/drivers/usb/gadget/udc/udc-xilinx.c b/drivers/usb/gadget/udc/udc-xilinx.c
index fb4ffedd6f0d..9cf43731bcd1 100644
--- a/drivers/usb/gadget/udc/udc-xilinx.c
+++ b/drivers/usb/gadget/udc/udc-xilinx.c
@@ -1612,6 +1612,8 @@ static void xudc_getstatus(struct xusb_udc *udc)
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = udc->setup.wIndex & USB_ENDPOINT_NUMBER_MASK;
+		if (epnum >= XUSB_MAX_ENDPOINTS)
+			goto stall;
 		target_ep = &udc->ep[epnum];
 		epcfgreg = udc->read_fn(udc->addr + target_ep->offset);
 		halt = epcfgreg & XUSB_EP_CFG_STALL_MASK;
@@ -1679,6 +1681,10 @@ static void xudc_set_clear_feature(struct xusb_udc *udc)
 	case USB_RECIP_ENDPOINT:
 		if (!udc->setup.wValue) {
 			endpoint = udc->setup.wIndex & USB_ENDPOINT_NUMBER_MASK;
+			if (endpoint >= XUSB_MAX_ENDPOINTS) {
+				xudc_ep0_stall(udc);
+				return;
+			}
 			target_ep = &udc->ep[endpoint];
 			outinbit = udc->setup.wIndex & USB_ENDPOINT_DIR_MASK;
 			outinbit = outinbit >> 7;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f5b1bcc875de..d7c0bf494d93 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1091,6 +1091,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	int			retval = 0;
 	bool			comp_timer_running = false;
 	bool			pending_portevent = false;
+	bool			reinit_xhc = false;
 
 	if (!hcd->state)
 		return 0;
@@ -1107,10 +1108,11 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	set_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
 
 	spin_lock_irq(&xhci->lock);
-	if ((xhci->quirks & XHCI_RESET_ON_RESUME) || xhci->broken_suspend)
-		hibernated = true;
 
-	if (!hibernated) {
+	if (hibernated || xhci->quirks & XHCI_RESET_ON_RESUME || xhci->broken_suspend)
+		reinit_xhc = true;
+
+	if (!reinit_xhc) {
 		/*
 		 * Some controllers might lose power during suspend, so wait
 		 * for controller not ready bit to clear, just as in xHC init.
@@ -1143,12 +1145,17 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 			spin_unlock_irq(&xhci->lock);
 			return -ETIMEDOUT;
 		}
-		temp = readl(&xhci->op_regs->status);
 	}
 
-	/* If restore operation fails, re-initialize the HC during resume */
-	if ((temp & STS_SRE) || hibernated) {
+	temp = readl(&xhci->op_regs->status);
 
+	/* re-initialize the HC on Restore Error, or Host Controller Error */
+	if (temp & (STS_SRE | STS_HCE)) {
+		reinit_xhc = true;
+		xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
+	}
+
+	if (reinit_xhc) {
 		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
 				!(xhci_all_ports_seen_u0(xhci))) {
 			del_timer_sync(&xhci->comp_mode_recovery_timer);
@@ -1604,9 +1611,12 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 	struct urb_priv	*urb_priv;
 	int num_tds;
 
-	if (!urb || xhci_check_args(hcd, urb->dev, urb->ep,
-					true, true, __func__) <= 0)
+	if (!urb)
 		return -EINVAL;
+	ret = xhci_check_args(hcd, urb->dev, urb->ep,
+					true, true, __func__);
+	if (ret <= 0)
+		return ret ? ret : -EINVAL;
 
 	slot_id = urb->dev->slot_id;
 	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
@@ -3323,7 +3333,7 @@ static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
 		return -EINVAL;
 	ret = xhci_check_args(xhci_to_hcd(xhci), udev, ep, 1, true, __func__);
 	if (ret <= 0)
-		return -EINVAL;
+		return ret ? ret : -EINVAL;
 	if (usb_ss_max_streams(&ep->ss_ep_comp) == 0) {
 		xhci_warn(xhci, "WARN: SuperSpeed Endpoint Companion"
 				" descriptor for ep 0x%x does not support streams\n",
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 4b65e6904499..b5a1864e9cfd 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -81,7 +81,6 @@
 #define CH341_QUIRK_SIMULATE_BREAK	BIT(1)
 
 static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x1a86, 0x5512) },
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 962e9943fc20..e7755d9cfc61 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -198,6 +198,8 @@ static void option_instat_callback(struct urb *urb);
 
 #define DELL_PRODUCT_5821E			0x81d7
 #define DELL_PRODUCT_5821E_ESIM			0x81e0
+#define DELL_PRODUCT_5829E_ESIM			0x81e4
+#define DELL_PRODUCT_5829E			0x81e6
 
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
@@ -1063,6 +1065,10 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5821E_ESIM),
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5829E),
+	  .driver_info = RSVD(0) | RSVD(6) },
+	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5829E_ESIM),
+	  .driver_info = RSVD(0) | RSVD(6) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
@@ -1273,10 +1279,16 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x7011, 0xff),	/* Telit LE910-S1 (ECM) */
 	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x701a, 0xff),	/* Telit LE910R1 (RNDIS) */
+	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x701b, 0xff),	/* Telit LE910R1 (ECM) */
+	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9200),				/* Telit LE910S1 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
+	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9201),				/* Telit LE910R1 flashing device */
+	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },
diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 97f50f301f13..d229d2db44ff 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -618,12 +618,12 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	ret = tps6598x_read32(tps, TPS_REG_STATUS, &status);
 	if (ret < 0)
-		return ret;
+		goto err_clear_mask;
 	trace_tps6598x_status(status);
 
 	ret = tps6598x_read32(tps, TPS_REG_SYSTEM_CONF, &conf);
 	if (ret < 0)
-		return ret;
+		goto err_clear_mask;
 
 	/*
 	 * This fwnode has a "compatible" property, but is never populated as a
@@ -712,7 +712,8 @@ static int tps6598x_probe(struct i2c_client *client)
 	usb_role_switch_put(tps->role_sw);
 err_fwnode_put:
 	fwnode_handle_put(fwnode);
-
+err_clear_mask:
+	tps6598x_write64(tps, TPS_REG_INT_MASK1, 0);
 	return ret;
 }
 
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 4e3b95af7ee4..d07a20bbc07b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -633,16 +633,18 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
 	return ret;
 }
 
-static int vhost_vsock_stop(struct vhost_vsock *vsock)
+static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
 {
 	size_t i;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&vsock->dev.mutex);
 
-	ret = vhost_dev_check_owner(&vsock->dev);
-	if (ret)
-		goto err;
+	if (check_owner) {
+		ret = vhost_dev_check_owner(&vsock->dev);
+		if (ret)
+			goto err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		struct vhost_virtqueue *vq = &vsock->vqs[i];
@@ -757,7 +759,12 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	 * inefficient.  Room for improvement here. */
 	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
 
-	vhost_vsock_stop(vsock);
+	/* Don't check the owner, because we are in the release path, so we
+	 * need to stop the vsock device in any case.
+	 * vhost_vsock_stop() can not fail in this case, so we don't need to
+	 * check the return code.
+	 */
+	vhost_vsock_stop(vsock, false);
 	vhost_vsock_flush(vsock);
 	vhost_dev_stop(&vsock->dev);
 
@@ -872,7 +879,7 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
 		if (start)
 			return vhost_vsock_start(vsock);
 		else
-			return vhost_vsock_stop(vsock);
+			return vhost_vsock_stop(vsock, true);
 	case VHOST_GET_FEATURES:
 		features = VHOST_VSOCK_FEATURES;
 		if (copy_to_user(argp, &features, sizeof(features)))
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 295bbc13ace6..fcd7eb496478 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -363,6 +363,17 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 		kunmap(cur_page);
 		cur_in += LZO_LEN;
 
+		if (seg_len > lzo1x_worst_compress(PAGE_SIZE)) {
+			/*
+			 * seg_len shouldn't be larger than we have allocated
+			 * for workspace->cbuf
+			 */
+			btrfs_err(fs_info, "unexpectedly large lzo segment len %u",
+					seg_len);
+			ret = -EIO;
+			goto out;
+		}
+
 		/* Copy the compressed segment payload into workspace */
 		copy_compressed_segment(cb, workspace->cbuf, seg_len, &cur_in);
 
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 7733e8ac0a69..51382d2be3d4 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -965,6 +965,7 @@ static int check_dev_item(struct extent_buffer *leaf,
 			  struct btrfs_key *key, int slot)
 {
 	struct btrfs_dev_item *ditem;
+	const u32 item_size = btrfs_item_size_nr(leaf, slot);
 
 	if (unlikely(key->objectid != BTRFS_DEV_ITEMS_OBJECTID)) {
 		dev_item_err(leaf, slot,
@@ -972,6 +973,13 @@ static int check_dev_item(struct extent_buffer *leaf,
 			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
 		return -EUCLEAN;
 	}
+
+	if (unlikely(item_size != sizeof(*ditem))) {
+		dev_item_err(leaf, slot, "invalid item size: has %u expect %zu",
+			     item_size, sizeof(*ditem));
+		return -EUCLEAN;
+	}
+
 	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
 	if (unlikely(btrfs_device_id(leaf, ditem) != key->offset)) {
 		dev_item_err(leaf, slot,
@@ -1007,6 +1015,7 @@ static int check_inode_item(struct extent_buffer *leaf,
 	struct btrfs_inode_item *iitem;
 	u64 super_gen = btrfs_super_generation(fs_info->super_copy);
 	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
+	const u32 item_size = btrfs_item_size_nr(leaf, slot);
 	u32 mode;
 	int ret;
 	u32 flags;
@@ -1016,6 +1025,12 @@ static int check_inode_item(struct extent_buffer *leaf,
 	if (unlikely(ret < 0))
 		return ret;
 
+	if (unlikely(item_size != sizeof(*iitem))) {
+		generic_err(leaf, slot, "invalid item size: has %u expect %zu",
+			    item_size, sizeof(*iitem));
+		return -EUCLEAN;
+	}
+
 	iitem = btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
 
 	/* Here we use super block generation + 1 to handle log tree */
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index d3cd2a94d1e8..d1f9d2632202 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -34,6 +34,14 @@
  */
 DEFINE_SPINLOCK(configfs_dirent_lock);
 
+/*
+ * All of link_obj/unlink_obj/link_group/unlink_group require that
+ * subsys->su_mutex is held.
+ * But parent configfs_subsystem is NULL when config_item is root.
+ * Use this mutex when config_item is root.
+ */
+static DEFINE_MUTEX(configfs_subsystem_mutex);
+
 static void configfs_d_iput(struct dentry * dentry,
 			    struct inode * inode)
 {
@@ -1859,7 +1867,9 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 		group->cg_item.ci_name = group->cg_item.ci_namebuf;
 
 	sd = root->d_fsdata;
+	mutex_lock(&configfs_subsystem_mutex);
 	link_group(to_config_group(sd->s_element), group);
+	mutex_unlock(&configfs_subsystem_mutex);
 
 	inode_lock_nested(d_inode(root), I_MUTEX_PARENT);
 
@@ -1884,7 +1894,9 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 	inode_unlock(d_inode(root));
 
 	if (err) {
+		mutex_lock(&configfs_subsystem_mutex);
 		unlink_group(group);
+		mutex_unlock(&configfs_subsystem_mutex);
 		configfs_release_fs();
 	}
 	put_fragment(frag);
@@ -1931,7 +1943,9 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 
 	dput(dentry);
 
+	mutex_lock(&configfs_subsystem_mutex);
 	unlink_group(group);
+	mutex_unlock(&configfs_subsystem_mutex);
 	configfs_release_fs();
 }
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 21fc8ce9405d..d7e49e87b49b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4454,6 +4454,7 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 		} else {
 			list_add_tail(&buf->list, &(*head)->list);
 		}
+		cond_resched();
 	}
 
 	return i ? i : -ENOMEM;
@@ -7590,7 +7591,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  signed long *timeout)
+					  ktime_t timeout)
 {
 	int ret;
 
@@ -7602,8 +7603,9 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	*timeout = schedule_timeout(*timeout);
-	return !*timeout ? -ETIME : 1;
+	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+		return -ETIME;
+	return 1;
 }
 
 /*
@@ -7616,7 +7618,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
-	signed long timeout = MAX_SCHEDULE_TIMEOUT;
+	ktime_t timeout = KTIME_MAX;
 	int ret;
 
 	do {
@@ -7632,7 +7634,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
-		timeout = timespec64_to_jiffies(&ts);
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
 	}
 
 	if (sig) {
@@ -7664,7 +7666,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);
@@ -7817,7 +7819,15 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret) {
 			mutex_lock(&ctx->uring_lock);
-			break;
+			if (atomic_read(&data->refs) > 0) {
+				/*
+				 * it has been revived by another thread while
+				 * we were unlocked
+				 */
+				mutex_unlock(&ctx->uring_lock);
+			} else {
+				break;
+			}
 		}
 
 		atomic_inc(&data->refs);
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 3616839c5c4b..f2625a372a3a 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -264,7 +264,6 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 			if (!gid_valid(gid))
 				return -EINVAL;
 			opts->gid = gid;
-			set_gid(tracefs_mount->mnt_root, gid);
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
@@ -291,7 +290,9 @@ static int tracefs_apply_options(struct super_block *sb)
 	inode->i_mode |= opts->mode;
 
 	inode->i_uid = opts->uid;
-	inode->i_gid = opts->gid;
+
+	/* Set all the group ids to the mount option */
+	set_gid(sb->s_root, opts->gid);
 
 	return 0;
 }
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6c4640526f74..d9049f2a78ca 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -206,11 +206,9 @@ static inline bool map_value_has_timer(const struct bpf_map *map)
 static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
 {
 	if (unlikely(map_value_has_spin_lock(map)))
-		*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
-			(struct bpf_spin_lock){};
+		memset(dst + map->spin_lock_off, 0, sizeof(struct bpf_spin_lock));
 	if (unlikely(map_value_has_timer(map)))
-		*(struct bpf_timer *)(dst + map->timer_off) =
-			(struct bpf_timer){};
+		memset(dst + map->timer_off, 0, sizeof(struct bpf_timer));
 }
 
 /* copy everything but bpf_spin_lock and bpf_timer. There could be one of each. */
@@ -221,7 +219,8 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 	if (unlikely(map_value_has_spin_lock(map))) {
 		s_off = map->spin_lock_off;
 		s_sz = sizeof(struct bpf_spin_lock);
-	} else if (unlikely(map_value_has_timer(map))) {
+	}
+	if (unlikely(map_value_has_timer(map))) {
 		t_off = map->timer_off;
 		t_sz = sizeof(struct bpf_timer);
 	}
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index 104505e9028f..87932bdb25d7 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -66,7 +66,8 @@ struct nvmem_keepout {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:   Write protect pin
+ * @wp-gpio:	Write protect pin
+ * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
  * no name is specified in its configuration. In such case "<id>" is
@@ -88,6 +89,7 @@ struct nvmem_config {
 	enum nvmem_type		type;
 	bool			read_only;
 	bool			root_only;
+	bool			ignore_wp;
 	struct device_node	*of_node;
 	bool			no_of_node;
 	nvmem_reg_read_t	reg_read;
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index feda1dc7f98e..38b701b7af4c 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -582,4 +582,18 @@ struct tee_client_driver {
 #define to_tee_client_driver(d) \
 		container_of(d, struct tee_client_driver, driver)
 
+/**
+ * teedev_open() - Open a struct tee_device
+ * @teedev:	Device to open
+ *
+ * @return a pointer to struct tee_context on success or an ERR_PTR on failure.
+ */
+struct tee_context *teedev_open(struct tee_device *teedev);
+
+/**
+ * teedev_close_context() - closes a struct tee_context
+ * @ctx:	The struct tee_context to close
+ */
+void teedev_close_context(struct tee_context *ctx);
+
 #endif /*__TEE_DRV_H*/
diff --git a/include/net/checksum.h b/include/net/checksum.h
index 5b96d5bd6e54..d3b5d368a0ca 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -22,7 +22,7 @@
 #include <asm/checksum.h>
 
 #ifndef _HAVE_ARCH_COPY_AND_CSUM_FROM_USER
-static inline
+static __always_inline
 __wsum csum_and_copy_from_user (const void __user *src, void *dst,
 				      int len)
 {
@@ -33,7 +33,7 @@ __wsum csum_and_copy_from_user (const void __user *src, void *dst,
 #endif
 
 #ifndef HAVE_CSUM_COPY_USER
-static __inline__ __wsum csum_and_copy_to_user
+static __always_inline __wsum csum_and_copy_to_user
 (const void *src, void __user *dst, int len)
 {
 	__wsum sum = csum_partial(src, len, ~0U);
@@ -45,7 +45,7 @@ static __inline__ __wsum csum_and_copy_to_user
 #endif
 
 #ifndef _HAVE_ARCH_CSUM_AND_COPY
-static inline __wsum
+static __always_inline __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len)
 {
 	memcpy(dst, src, len);
@@ -54,7 +54,7 @@ csum_partial_copy_nocheck(const void *src, void *dst, int len)
 #endif
 
 #ifndef HAVE_ARCH_CSUM_ADD
-static inline __wsum csum_add(__wsum csum, __wsum addend)
+static __always_inline __wsum csum_add(__wsum csum, __wsum addend)
 {
 	u32 res = (__force u32)csum;
 	res += (__force u32)addend;
@@ -62,12 +62,12 @@ static inline __wsum csum_add(__wsum csum, __wsum addend)
 }
 #endif
 
-static inline __wsum csum_sub(__wsum csum, __wsum addend)
+static __always_inline __wsum csum_sub(__wsum csum, __wsum addend)
 {
 	return csum_add(csum, ~addend);
 }
 
-static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
+static __always_inline __sum16 csum16_add(__sum16 csum, __be16 addend)
 {
 	u16 res = (__force u16)csum;
 
@@ -75,12 +75,12 @@ static inline __sum16 csum16_add(__sum16 csum, __be16 addend)
 	return (__force __sum16)(res + (res < (__force u16)addend));
 }
 
-static inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
+static __always_inline __sum16 csum16_sub(__sum16 csum, __be16 addend)
 {
 	return csum16_add(csum, ~addend);
 }
 
-static inline __wsum csum_shift(__wsum sum, int offset)
+static __always_inline __wsum csum_shift(__wsum sum, int offset)
 {
 	/* rotate sum to align it with a 16b boundary */
 	if (offset & 1)
@@ -88,42 +88,43 @@ static inline __wsum csum_shift(__wsum sum, int offset)
 	return sum;
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_add(__wsum csum, __wsum csum2, int offset)
 {
 	return csum_add(csum, csum_shift(csum2, offset));
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_add_ext(__wsum csum, __wsum csum2, int offset, int len)
 {
 	return csum_block_add(csum, csum2, offset);
 }
 
-static inline __wsum
+static __always_inline __wsum
 csum_block_sub(__wsum csum, __wsum csum2, int offset)
 {
 	return csum_block_add(csum, ~csum2, offset);
 }
 
-static inline __wsum csum_unfold(__sum16 n)
+static __always_inline __wsum csum_unfold(__sum16 n)
 {
 	return (__force __wsum)n;
 }
 
-static inline __wsum csum_partial_ext(const void *buff, int len, __wsum sum)
+static __always_inline
+__wsum csum_partial_ext(const void *buff, int len, __wsum sum)
 {
 	return csum_partial(buff, len, sum);
 }
 
 #define CSUM_MANGLED_0 ((__force __sum16)0xffff)
 
-static inline void csum_replace_by_diff(__sum16 *sum, __wsum diff)
+static __always_inline void csum_replace_by_diff(__sum16 *sum, __wsum diff)
 {
 	*sum = csum_fold(csum_add(diff, ~csum_unfold(*sum)));
 }
 
-static inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
+static __always_inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
 {
 	__wsum tmp = csum_sub(~csum_unfold(*sum), (__force __wsum)from);
 
@@ -136,11 +137,16 @@ static inline void csum_replace4(__sum16 *sum, __be32 from, __be32 to)
  *  m : old value of a 16bit field
  *  m' : new value of a 16bit field
  */
-static inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
+static __always_inline void csum_replace2(__sum16 *sum, __be16 old, __be16 new)
 {
 	*sum = ~csum16_add(csum16_sub(~(*sum), old), new);
 }
 
+static inline void csum_replace(__wsum *csum, __wsum old, __wsum new)
+{
+	*csum = csum_add(csum_sub(*csum, old), new);
+}
+
 struct sk_buff;
 void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 			      __be32 from, __be32 to, bool pseudohdr);
@@ -150,16 +156,16 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
 				     __wsum diff, bool pseudohdr);
 
-static inline void inet_proto_csum_replace2(__sum16 *sum, struct sk_buff *skb,
-					    __be16 from, __be16 to,
-					    bool pseudohdr)
+static __always_inline
+void inet_proto_csum_replace2(__sum16 *sum, struct sk_buff *skb,
+			      __be16 from, __be16 to, bool pseudohdr)
 {
 	inet_proto_csum_replace4(sum, skb, (__force __be32)from,
 				 (__force __be32)to, pseudohdr);
 }
 
-static inline __wsum remcsum_adjust(void *ptr, __wsum csum,
-				    int start, int offset)
+static __always_inline __wsum remcsum_adjust(void *ptr, __wsum csum,
+					     int start, int offset)
 {
 	__sum16 *psum = (__sum16 *)(ptr + offset);
 	__wsum delta;
@@ -175,7 +181,7 @@ static inline __wsum remcsum_adjust(void *ptr, __wsum csum,
 	return delta;
 }
 
-static inline void remcsum_unadjust(__sum16 *psum, __wsum delta)
+static __always_inline void remcsum_unadjust(__sum16 *psum, __wsum delta)
 {
 	*psum = csum_fold(csum_sub(delta, (__force __wsum)*psum));
 }
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a16171c5fd9e..d52a5d776e76 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -883,9 +883,9 @@ struct nft_expr_ops {
 	int				(*offload)(struct nft_offload_ctx *ctx,
 						   struct nft_flow_rule *flow,
 						   const struct nft_expr *expr);
+	bool				(*offload_action)(const struct nft_expr *expr);
 	void				(*offload_stats)(struct nft_expr *expr,
 							 const struct flow_stats *stats);
-	u32				offload_flags;
 	const struct nft_expr_type	*type;
 	void				*data;
 };
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index f9d95ff82df8..797147843958 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -67,8 +67,6 @@ struct nft_flow_rule {
 	struct flow_rule	*rule;
 };
 
-#define NFT_OFFLOAD_F_ACTION	(1 << 0)
-
 void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 				 enum flow_dissector_key_id addr_type);
 
diff --git a/include/net/sock.h b/include/net/sock.h
index dfb92f91d5be..7d49196a3880 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -506,7 +506,7 @@ struct sock {
 	u16			sk_tsflags;
 	int			sk_bind_phc;
 	u8			sk_shutdown;
-	u32			sk_tskey;
+	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
 
 	u8			sk_clockid;
@@ -2598,7 +2598,7 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
 		__sock_tx_timestamp(tsflags, tx_flags);
 		if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
 		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
-			*tskey = sk->sk_tskey++;
+			*tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 	}
 	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
 		*tx_flags |= SKBTX_WIFI_STATUS;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ecd51a8a8680..53384622e8da 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1337,6 +1337,7 @@ int generic_map_delete_batch(struct bpf_map *map,
 		maybe_wait_bpf_programs(map);
 		if (err)
 			break;
+		cond_resched();
 	}
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
@@ -1394,6 +1395,7 @@ int generic_map_update_batch(struct bpf_map *map,
 
 		if (err)
 			break;
+		cond_resched();
 	}
 
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
@@ -1491,6 +1493,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
 		swap(prev_key, key);
 		retry = MAP_LOOKUP_RETRIES;
 		cp++;
+		cond_resched();
 	}
 
 	if (err == -EFAULT)
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index c59aa2c7749b..58900dc92ac9 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -549,6 +549,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 					  char *buf, size_t nbytes, loff_t off)
 {
 	struct cgroup *cgrp;
+	struct cgroup_file_ctx *ctx;
 
 	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
 
@@ -556,8 +557,9 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 	 * Release agent gets called with all capabilities,
 	 * require capabilities to set release agent.
 	 */
-	if ((of->file->f_cred->user_ns != &init_user_ns) ||
-	    !capable(CAP_SYS_ADMIN))
+	ctx = of->priv;
+	if ((ctx->ns->user_ns != &init_user_ns) ||
+	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 67eae4a4b724..f6794602ab10 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2249,6 +2249,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
+	cpus_read_lock();
 	percpu_down_write(&cpuset_rwsem);
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
@@ -2302,6 +2303,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
+	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 3d5c07239a2a..67c7979c40c0 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -955,6 +955,16 @@ traceon_trigger(struct event_trigger_data *data,
 		struct trace_buffer *buffer, void *rec,
 		struct ring_buffer_event *event)
 {
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (tracer_tracing_is_on(file->tr))
+			return;
+
+		tracer_tracing_on(file->tr);
+		return;
+	}
+
 	if (tracing_is_on())
 		return;
 
@@ -966,8 +976,15 @@ traceon_count_trigger(struct event_trigger_data *data,
 		      struct trace_buffer *buffer, void *rec,
 		      struct ring_buffer_event *event)
 {
-	if (tracing_is_on())
-		return;
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (tracer_tracing_is_on(file->tr))
+			return;
+	} else {
+		if (tracing_is_on())
+			return;
+	}
 
 	if (!data->count)
 		return;
@@ -975,7 +992,10 @@ traceon_count_trigger(struct event_trigger_data *data,
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_on();
+	if (file)
+		tracer_tracing_on(file->tr);
+	else
+		tracing_on();
 }
 
 static void
@@ -983,6 +1003,16 @@ traceoff_trigger(struct event_trigger_data *data,
 		 struct trace_buffer *buffer, void *rec,
 		 struct ring_buffer_event *event)
 {
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (!tracer_tracing_is_on(file->tr))
+			return;
+
+		tracer_tracing_off(file->tr);
+		return;
+	}
+
 	if (!tracing_is_on())
 		return;
 
@@ -994,8 +1024,15 @@ traceoff_count_trigger(struct event_trigger_data *data,
 		       struct trace_buffer *buffer, void *rec,
 		       struct ring_buffer_event *event)
 {
-	if (!tracing_is_on())
-		return;
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (!tracer_tracing_is_on(file->tr))
+			return;
+	} else {
+		if (!tracing_is_on())
+			return;
+	}
 
 	if (!data->count)
 		return;
@@ -1003,7 +1040,10 @@ traceoff_count_trigger(struct event_trigger_data *data,
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_off();
+	if (file)
+		tracer_tracing_off(file->tr);
+	else
+		tracing_off();
 }
 
 static int
@@ -1200,7 +1240,12 @@ stacktrace_trigger(struct event_trigger_data *data,
 		   struct trace_buffer *buffer,  void *rec,
 		   struct ring_buffer_event *event)
 {
-	trace_dump_stack(STACK_SKIP);
+	struct trace_event_file *file = data->private_data;
+
+	if (file)
+		__trace_stack(file->tr, tracing_gen_ctx(), STACK_SKIP);
+	else
+		trace_dump_stack(STACK_SKIP);
 }
 
 static void
diff --git a/mm/filemap.c b/mm/filemap.c
index 82a17c35eb96..1293c3409e42 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2354,8 +2354,12 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			break;
 		if (PageReadahead(head))
 			break;
-		xas.xa_index = head->index + thp_nr_pages(head) - 1;
-		xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
+		if (PageHead(head)) {
+			xas_set(&xas, head->index + thp_nr_pages(head));
+			/* Handle wrap correctly */
+			if (xas.xa_index - 1 >= max)
+				break;
+		}
 		continue;
 put_page:
 		put_page(head);
diff --git a/mm/memblock.c b/mm/memblock.c
index 5096500b2647..2b7397781c99 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -366,14 +366,20 @@ void __init memblock_discard(void)
 		addr = __pa(memblock.reserved.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.reserved.max);
-		__memblock_free_late(addr, size);
+		if (memblock_reserved_in_slab)
+			kfree(memblock.reserved.regions);
+		else
+			__memblock_free_late(addr, size);
 	}
 
 	if (memblock.memory.regions != memblock_memory_init_regions) {
 		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
-		__memblock_free_late(addr, size);
+		if (memblock_memory_in_slab)
+			kfree(memblock.memory.regions);
+		else
+			__memblock_free_late(addr, size);
 	}
 
 	memblock_memory = NULL;
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index a271688780a2..307ee1174a6e 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2006,7 +2006,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		/* set the end-packet for broadcast */
 		session->pkt.last = session->pkt.total;
 
-	skcb->tskey = session->sk->sk_tskey++;
+	skcb->tskey = atomic_inc_return(&session->sk->sk_tskey) - 1;
 	session->tskey = skcb->tskey;
 
 	return session;
diff --git a/net/core/filter.c b/net/core/filter.c
index f207e4782bd0..76e406965b6f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2711,6 +2711,9 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	if (unlikely(flags))
 		return -EINVAL;
 
+	if (unlikely(len == 0))
+		return 0;
+
 	/* First find the starting scatterlist element */
 	i = msg->sg.start;
 	do {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f7e003571a35..449a96e358ad 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2254,7 +2254,7 @@ void *__pskb_pull_tail(struct sk_buff *skb, int delta)
 		/* Free pulled out fragments. */
 		while ((list = skb_shinfo(skb)->frag_list) != insp) {
 			skb_shinfo(skb)->frag_list = list->next;
-			kfree_skb(list);
+			consume_skb(list);
 		}
 		/* And insert new clone at head. */
 		if (clone) {
@@ -4844,7 +4844,7 @@ static void __skb_complete_tx_timestamp(struct sk_buff *skb,
 		serr->ee.ee_data = skb_shinfo(skb)->tskey;
 		if (sk->sk_protocol == IPPROTO_TCP &&
 		    sk->sk_type == SOCK_STREAM)
-			serr->ee.ee_data -= sk->sk_tskey;
+			serr->ee.ee_data -= atomic_read(&sk->sk_tskey);
 	}
 
 	err = sock_queue_err_skb(sk, skb);
@@ -6220,7 +6220,7 @@ static int pskb_carve_frag_list(struct sk_buff *skb,
 	/* Free pulled out fragments. */
 	while ((list = shinfo->frag_list) != insp) {
 		shinfo->frag_list = list->next;
-		kfree_skb(list);
+		consume_skb(list);
 	}
 	/* And insert new clone at head. */
 	if (clone) {
diff --git a/net/core/sock.c b/net/core/sock.c
index 6ea317f84edd..deaed1b20682 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -866,9 +866,9 @@ int sock_set_timestamping(struct sock *sk, int optname,
 			if ((1 << sk->sk_state) &
 			    (TCPF_CLOSE | TCPF_LISTEN))
 				return -EINVAL;
-			sk->sk_tskey = tcp_sk(sk)->snd_una;
+			atomic_set(&sk->sk_tskey, tcp_sk(sk)->snd_una);
 		} else {
-			sk->sk_tskey = 0;
+			atomic_set(&sk->sk_tskey, 0);
 		}
 	}
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index dcea653a5204..77534b44b8c7 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1380,8 +1380,11 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 	}
 
 	ops = rcu_dereference(inet_offloads[proto]);
-	if (likely(ops && ops->callbacks.gso_segment))
+	if (likely(ops && ops->callbacks.gso_segment)) {
 		segs = ops->callbacks.gso_segment(skb, features);
+		if (!segs)
+			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
+	}
 
 	if (IS_ERR_OR_NULL(segs))
 		goto out;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a4d2eb691cbc..131066d0319a 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -992,7 +992,7 @@ static int __ip_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index e3a159c8f231..36e89b687387 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -187,7 +187,6 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 			 (int)ident, &ipv6_hdr(skb)->daddr, dif);
 #endif
 	} else {
-		pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
 		return NULL;
 	}
 
diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index b91003538d87..bc3a043a5d5c 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -846,7 +846,7 @@ udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
 		list_for_each_entry(node, &info->shared->devices, list)
 			if (node->dev == dev)
 				break;
-		if (node->dev != dev)
+		if (list_entry_is_head(node, &info->shared->devices, list))
 			return;
 
 		list_del(&node->list);
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 1b9827ff8ccf..172565d12570 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -114,6 +114,8 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	if (likely(ops && ops->callbacks.gso_segment)) {
 		skb_reset_transport_header(skb);
 		segs = ops->callbacks.gso_segment(skb, features);
+		if (!segs)
+			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
 	}
 
 	if (IS_ERR_OR_NULL(segs))
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4e83e2a506..22bf8fb61716 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1465,7 +1465,7 @@ static int __ip6_append_data(struct sock *sk,
 
 	if (cork->tx_flags & SKBTX_ANY_SW_TSTAMP &&
 	    sk->sk_tsflags & SOF_TIMESTAMPING_OPT_ID)
-		tskey = sk->sk_tskey++;
+		tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index b21ff9be04c6..8d1c67b93591 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -35,12 +35,14 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("AddAddr", MPTCP_MIB_ADDADDR),
 	SNMP_MIB_ITEM("EchoAdd", MPTCP_MIB_ECHOADD),
 	SNMP_MIB_ITEM("PortAdd", MPTCP_MIB_PORTADD),
+	SNMP_MIB_ITEM("AddAddrDrop", MPTCP_MIB_ADDADDRDROP),
 	SNMP_MIB_ITEM("MPJoinPortSynRx", MPTCP_MIB_JOINPORTSYNRX),
 	SNMP_MIB_ITEM("MPJoinPortSynAckRx", MPTCP_MIB_JOINPORTSYNACKRX),
 	SNMP_MIB_ITEM("MPJoinPortAckRx", MPTCP_MIB_JOINPORTACKRX),
 	SNMP_MIB_ITEM("MismatchPortSynRx", MPTCP_MIB_MISMATCHPORTSYNRX),
 	SNMP_MIB_ITEM("MismatchPortAckRx", MPTCP_MIB_MISMATCHPORTACKRX),
 	SNMP_MIB_ITEM("RmAddr", MPTCP_MIB_RMADDR),
+	SNMP_MIB_ITEM("RmAddrDrop", MPTCP_MIB_RMADDRDROP),
 	SNMP_MIB_ITEM("RmSubflow", MPTCP_MIB_RMSUBFLOW),
 	SNMP_MIB_ITEM("MPPrioTx", MPTCP_MIB_MPPRIOTX),
 	SNMP_MIB_ITEM("MPPrioRx", MPTCP_MIB_MPPRIORX),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index ecd3d8b117e0..2966fcb6548b 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -28,12 +28,14 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_ADDADDR,		/* Received ADD_ADDR with echo-flag=0 */
 	MPTCP_MIB_ECHOADD,		/* Received ADD_ADDR with echo-flag=1 */
 	MPTCP_MIB_PORTADD,		/* Received ADD_ADDR with a port-number */
+	MPTCP_MIB_ADDADDRDROP,		/* Dropped incoming ADD_ADDR */
 	MPTCP_MIB_JOINPORTSYNRX,	/* Received a SYN MP_JOIN with a different port-number */
 	MPTCP_MIB_JOINPORTSYNACKRX,	/* Received a SYNACK MP_JOIN with a different port-number */
 	MPTCP_MIB_JOINPORTACKRX,	/* Received an ACK MP_JOIN with a different port-number */
 	MPTCP_MIB_MISMATCHPORTSYNRX,	/* Received a SYN MP_JOIN with a mismatched port-number */
 	MPTCP_MIB_MISMATCHPORTACKRX,	/* Received an ACK MP_JOIN with a mismatched port-number */
 	MPTCP_MIB_RMADDR,		/* Received RM_ADDR */
+	MPTCP_MIB_RMADDRDROP,		/* Dropped incoming RM_ADDR */
 	MPTCP_MIB_RMSUBFLOW,		/* Remove a subflow */
 	MPTCP_MIB_MPPRIOTX,		/* Transmit a MP_PRIO */
 	MPTCP_MIB_MPPRIORX,		/* Received a MP_PRIO */
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 6ab386ff3294..d9790d6fbce9 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -194,6 +194,8 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
 		pm->remote = *addr;
+	} else {
+		__MPTCP_INC_STATS(sock_net((struct sock *)msk), MPTCP_MIB_ADDADDRDROP);
 	}
 
 	spin_unlock_bh(&pm->lock);
@@ -234,8 +236,10 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 		mptcp_event_addr_removed(msk, rm_list->ids[i]);
 
 	spin_lock_bh(&pm->lock);
-	mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED);
-	pm->rm_list_rx = *rm_list;
+	if (mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED))
+		pm->rm_list_rx = *rm_list;
+	else
+		__MPTCP_INC_STATS(sock_net((struct sock *)msk), MPTCP_MIB_RMADDRDROP);
 	spin_unlock_bh(&pm->lock);
 }
 
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 320f89b5c59d..cf0f700f46dd 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -606,6 +606,7 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	unsigned int add_addr_accept_max;
 	struct mptcp_addr_info remote;
 	unsigned int subflows_max;
+	bool reset_port = false;
 	int i, nr;
 
 	add_addr_accept_max = mptcp_pm_get_add_addr_accept_max(msk);
@@ -615,15 +616,19 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 		 msk->pm.add_addr_accepted, add_addr_accept_max,
 		 msk->pm.remote.family);
 
-	if (lookup_subflow_by_daddr(&msk->conn_list, &msk->pm.remote))
+	remote = msk->pm.remote;
+	if (lookup_subflow_by_daddr(&msk->conn_list, &remote))
 		goto add_addr_echo;
 
+	/* pick id 0 port, if none is provided the remote address */
+	if (!remote.port) {
+		reset_port = true;
+		remote.port = sk->sk_dport;
+	}
+
 	/* connect to the specified remote address, using whatever
 	 * local address the routing configuration will pick.
 	 */
-	remote = msk->pm.remote;
-	if (!remote.port)
-		remote.port = sk->sk_dport;
 	nr = fill_local_addresses_vec(msk, addrs);
 
 	msk->pm.add_addr_accepted++;
@@ -636,8 +641,12 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 		__mptcp_subflow_connect(sk, &addrs[i], &remote);
 	spin_lock_bh(&msk->pm.lock);
 
+	/* be sure to echo exactly the received address */
+	if (reset_port)
+		remote.port = 0;
+
 add_addr_echo:
-	mptcp_pm_announce_addr(msk, &msk->pm.remote, true);
+	mptcp_pm_announce_addr(msk, &remote, true);
 	mptcp_pm_nl_addr_send_ack(msk);
 }
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c20772822637..a65b530975f5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6535,12 +6535,15 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 {
 	struct nft_object *newobj;
 	struct nft_trans *trans;
-	int err;
+	int err = -ENOMEM;
+
+	if (!try_module_get(type->owner))
+		return -ENOENT;
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
 	if (!trans)
-		return -ENOMEM;
+		goto err_trans;
 
 	newobj = nft_obj_init(ctx, type, attr);
 	if (IS_ERR(newobj)) {
@@ -6557,6 +6560,8 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 
 err_free_trans:
 	kfree(trans);
+err_trans:
+	module_put(type->owner);
 	return err;
 }
 
@@ -8169,7 +8174,7 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	if (obj->ops->update)
 		obj->ops->update(obj, newobj);
 
-	kfree(newobj);
+	nft_obj_destroy(&trans->ctx, newobj);
 }
 
 static void nft_commit_release(struct nft_trans *trans)
@@ -8914,7 +8919,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
-				kfree(nft_trans_obj_newobj(trans));
+				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
 				nft_trans_destroy(trans);
 			} else {
 				trans->ctx.table->use--;
@@ -9574,10 +9579,13 @@ EXPORT_SYMBOL_GPL(__nft_release_basechain);
 
 static void __nft_release_hook(struct net *net, struct nft_table *table)
 {
+	struct nft_flowtable *flowtable;
 	struct nft_chain *chain;
 
 	list_for_each_entry(chain, &table->chains, list)
 		nf_tables_unregister_hook(net, table, chain);
+	list_for_each_entry(flowtable, &table->flowtables, list)
+		nft_unregister_flowtable_net_hooks(net, &flowtable->hook_list);
 }
 
 static void __nft_release_hooks(struct net *net)
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9656c1646222..2d36952b1392 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -94,7 +94,8 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 
 	expr = nft_expr_first(rule);
 	while (nft_expr_more(rule, expr)) {
-		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
+		if (expr->ops->offload_action &&
+		    expr->ops->offload_action(expr))
 			num_actions++;
 
 		expr = nft_expr_next(expr);
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index bbf3fcba3df4..5b5c607fbf83 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -67,6 +67,11 @@ static int nft_dup_netdev_offload(struct nft_offload_ctx *ctx,
 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_MIRRED, oif);
 }
 
+static bool nft_dup_netdev_offload_action(const struct nft_expr *expr)
+{
+	return true;
+}
+
 static struct nft_expr_type nft_dup_netdev_type;
 static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.type		= &nft_dup_netdev_type,
@@ -75,6 +80,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
 	.offload	= nft_dup_netdev_offload,
+	.offload_action	= nft_dup_netdev_offload_action,
 };
 
 static struct nft_expr_type nft_dup_netdev_type __read_mostly = {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index cd59afde5b2f..7730409f6f09 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -77,6 +77,11 @@ static int nft_fwd_netdev_offload(struct nft_offload_ctx *ctx,
 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_REDIRECT, oif);
 }
 
+static bool nft_fwd_netdev_offload_action(const struct nft_expr *expr)
+{
+	return true;
+}
+
 struct nft_fwd_neigh {
 	u8			sreg_dev;
 	u8			sreg_addr;
@@ -219,6 +224,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.dump		= nft_fwd_netdev_dump,
 	.validate	= nft_fwd_validate,
 	.offload	= nft_fwd_netdev_offload,
+	.offload_action	= nft_fwd_netdev_offload_action,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 90c64d27ae53..d0f67d325bdf 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -213,6 +213,16 @@ static int nft_immediate_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static bool nft_immediate_offload_action(const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	if (priv->dreg == NFT_REG_VERDICT)
+		return true;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -224,7 +234,7 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
 	.offload	= nft_immediate_offload,
-	.offload_flags	= NFT_OFFLOAD_F_ACTION,
+	.offload_action	= nft_immediate_offload_action,
 };
 
 struct nft_expr_type nft_imm_type __read_mostly = {
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 5e6459e11605..7013f55f05d1 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	if (par->family == NFPROTO_IPV4)
 		nf_defrag_ipv4_disable(par->net);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	else if (par->family == NFPROTO_IPV6)
-		nf_defrag_ipv4_disable(par->net);
+		nf_defrag_ipv6_disable(par->net);
+#endif
 }
 
 static struct xt_match socket_mt_reg[] __read_mostly = {
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 076774034bb9..780d9e2246f3 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -423,12 +423,43 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
-static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
+static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, u8 ipv6_tclass, u8 mask)
 {
+	u8 old_ipv6_tclass = ipv6_get_dsfield(nh);
+
+	ipv6_tclass = OVS_MASKED(old_ipv6_tclass, ipv6_tclass, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)(old_ipv6_tclass << 12),
+			     (__force __wsum)(ipv6_tclass << 12));
+
+	ipv6_change_dsfield(nh, ~mask, ipv6_tclass);
+}
+
+static void set_ipv6_fl(struct sk_buff *skb, struct ipv6hdr *nh, u32 fl, u32 mask)
+{
+	u32 ofl;
+
+	ofl = nh->flow_lbl[0] << 16 |  nh->flow_lbl[1] << 8 |  nh->flow_lbl[2];
+	fl = OVS_MASKED(ofl, fl, mask);
+
 	/* Bits 21-24 are always unmasked, so this retains their values. */
-	OVS_SET_MASKED(nh->flow_lbl[0], (u8)(fl >> 16), (u8)(mask >> 16));
-	OVS_SET_MASKED(nh->flow_lbl[1], (u8)(fl >> 8), (u8)(mask >> 8));
-	OVS_SET_MASKED(nh->flow_lbl[2], (u8)fl, (u8)mask);
+	nh->flow_lbl[0] = (u8)(fl >> 16);
+	nh->flow_lbl[1] = (u8)(fl >> 8);
+	nh->flow_lbl[2] = (u8)fl;
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)htonl(ofl), (__force __wsum)htonl(fl));
+}
+
+static void set_ipv6_ttl(struct sk_buff *skb, struct ipv6hdr *nh, u8 new_ttl, u8 mask)
+{
+	new_ttl = OVS_MASKED(nh->hop_limit, new_ttl, mask);
+
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		csum_replace(&skb->csum, (__force __wsum)(nh->hop_limit << 8),
+			     (__force __wsum)(new_ttl << 8));
+	nh->hop_limit = new_ttl;
 }
 
 static void set_ip_ttl(struct sk_buff *skb, struct iphdr *nh, u8 new_ttl,
@@ -546,18 +577,17 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
 		}
 	}
 	if (mask->ipv6_tclass) {
-		ipv6_change_dsfield(nh, ~mask->ipv6_tclass, key->ipv6_tclass);
+		set_ipv6_dsfield(skb, nh, key->ipv6_tclass, mask->ipv6_tclass);
 		flow_key->ip.tos = ipv6_get_dsfield(nh);
 	}
 	if (mask->ipv6_label) {
-		set_ipv6_fl(nh, ntohl(key->ipv6_label),
+		set_ipv6_fl(skb, nh, ntohl(key->ipv6_label),
 			    ntohl(mask->ipv6_label));
 		flow_key->ipv6.label =
 		    *(__be32 *)nh & htonl(IPV6_FLOWINFO_FLOWLABEL);
 	}
 	if (mask->ipv6_hlimit) {
-		OVS_SET_MASKED(nh->hop_limit, key->ipv6_hlimit,
-			       mask->ipv6_hlimit);
+		set_ipv6_ttl(skb, nh, key->ipv6_hlimit, mask->ipv6_hlimit);
 		flow_key->ip.ttl = nh->hop_limit;
 	}
 	return 0;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2a17eb77c904..4ffea1290ce1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -516,11 +516,6 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	struct nf_conn *ct;
 	u8 dir;
 
-	/* Previously seen or loopback */
-	ct = nf_ct_get(skb, &ctinfo);
-	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
-		return false;
-
 	switch (family) {
 	case NFPROTO_IPV4:
 		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple, &tcph))
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 4a964e9190b0..707615809e5a 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -112,7 +112,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	pnettable = &sn->pnettable;
 
 	/* remove table entry */
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist,
 				 list) {
 		if (!pnet_name ||
@@ -130,7 +130,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 			rc = 0;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	/* if this is not the initial namespace, stop here */
 	if (net != &init_net)
@@ -191,7 +191,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && !pnetelem->ndev &&
 		    !strncmp(pnetelem->eth_name, ndev->name, IFNAMSIZ)) {
@@ -205,7 +205,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -223,7 +223,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev == ndev) {
 			dev_put(pnetelem->ndev);
@@ -236,7 +236,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -371,7 +371,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 
 	rc = -EEXIST;
 	new_netdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_ETH &&
 		    !strncmp(tmp_pe->eth_name, eth_name, IFNAMSIZ)) {
@@ -381,9 +381,9 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	}
 	if (new_netdev) {
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 		goto out_put;
 	}
@@ -444,7 +444,7 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	new_pe->ib_port = ib_port;
 
 	new_ibdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -454,9 +454,9 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	}
 	if (new_ibdev) {
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 	}
 	return (new_ibdev) ? 0 : -EEXIST;
@@ -601,7 +601,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 	pnettable = &sn->pnettable;
 
 	/* dump pnettable entries */
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetid && !smc_pnet_match(pnetelem->pnet_name, pnetid))
 			continue;
@@ -616,7 +616,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return idx;
 }
 
@@ -860,7 +860,7 @@ int smc_pnet_net_init(struct net *net)
 	struct smc_pnetids_ndev *pnetids_ndev = &sn->pnetids_ndev;
 
 	INIT_LIST_HEAD(&pnettable->pnetlist);
-	rwlock_init(&pnettable->lock);
+	mutex_init(&pnettable->lock);
 	INIT_LIST_HEAD(&pnetids_ndev->list);
 	rwlock_init(&pnetids_ndev->lock);
 
@@ -940,7 +940,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && ndev == pnetelem->ndev) {
 			/* get pnetid of netdev device */
@@ -949,7 +949,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -1130,7 +1130,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX) &&
@@ -1140,7 +1140,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
@@ -1159,7 +1159,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -1168,7 +1168,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index 14039272f7e4..80a88eea4949 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -29,7 +29,7 @@ struct smc_link_group;
  * @pnetlist: List of PNETIDs
  */
 struct smc_pnettable {
-	rwlock_t lock;
+	struct mutex lock;
 	struct list_head pnetlist;
 };
 
diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 01396dd1c899..1d8ba233d047 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -967,7 +967,7 @@ static int __tipc_nl_add_nametable_publ(struct tipc_nl_msg *msg,
 		list_for_each_entry(p, &sr->all_publ, all_publ)
 			if (p->key == *last_key)
 				break;
-		if (p->key != *last_key)
+		if (list_entry_is_head(p, &sr->all_publ, all_publ))
 			return -EPIPE;
 	} else {
 		p = list_first_entry(&sr->all_publ,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 3e63c83e641c..7545321c3440 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3749,7 +3749,7 @@ static int __tipc_nl_list_sk_publ(struct sk_buff *skb,
 			if (p->key == *last_publ)
 				break;
 		}
-		if (p->key != *last_publ) {
+		if (list_entry_is_head(p, &tsk->publications, binding_sock)) {
 			/* We never set seq or call nl_dump_check_consistent()
 			 * this means that setting prev_seq here will cause the
 			 * consistence check to fail in the netlink callback
diff --git a/security/selinux/ima.c b/security/selinux/ima.c
index 727c4e43219d..ff7aea6b3774 100644
--- a/security/selinux/ima.c
+++ b/security/selinux/ima.c
@@ -77,7 +77,7 @@ void selinux_ima_measure_state_locked(struct selinux_state *state)
 	size_t policy_len;
 	int rc = 0;
 
-	WARN_ON(!mutex_is_locked(&state->policy_mutex));
+	lockdep_assert_held(&state->policy_mutex);
 
 	state_str = selinux_ima_collect_state(state);
 	if (!state_str) {
@@ -117,7 +117,7 @@ void selinux_ima_measure_state_locked(struct selinux_state *state)
  */
 void selinux_ima_measure_state(struct selinux_state *state)
 {
-	WARN_ON(mutex_is_locked(&state->policy_mutex));
+	lockdep_assert_not_held(&state->policy_mutex);
 
 	mutex_lock(&state->policy_mutex);
 	selinux_ima_measure_state_locked(state);
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index f5d260b1df4d..15a4547d608e 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -44,10 +44,6 @@ int perf_data__create_dir(struct perf_data *data, int nr)
 	if (!files)
 		return -ENOMEM;
 
-	data->dir.version = PERF_DIR_VERSION;
-	data->dir.files   = files;
-	data->dir.nr      = nr;
-
 	for (i = 0; i < nr; i++) {
 		struct perf_data_file *file = &files[i];
 
@@ -62,6 +58,9 @@ int perf_data__create_dir(struct perf_data *data, int nr)
 		file->fd = ret;
 	}
 
+	data->dir.version = PERF_DIR_VERSION;
+	data->dir.files   = files;
+	data->dir.nr      = nr;
 	return 0;
 
 out_err:
diff --git a/tools/perf/util/evlist-hybrid.c b/tools/perf/util/evlist-hybrid.c
index 7c554234b43d..f39c8ffc5a11 100644
--- a/tools/perf/util/evlist-hybrid.c
+++ b/tools/perf/util/evlist-hybrid.c
@@ -153,8 +153,8 @@ int evlist__fix_hybrid_cpus(struct evlist *evlist, const char *cpu_list)
 		perf_cpu_map__put(matched_cpus);
 		perf_cpu_map__put(unmatched_cpus);
 	}
-
-	ret = (unmatched_count == events_nr) ? -1 : 0;
+	if (events_nr)
+		ret = (unmatched_count == events_nr) ? -1 : 0;
 out:
 	perf_cpu_map__put(cpus);
 	return ret;
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
index 1858435de7aa..5cb90ca29218 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -235,7 +235,7 @@ SEC("sk_msg1")
 int bpf_prog4(struct sk_msg_md *msg)
 {
 	int *bytes, zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
-	int *start, *end, *start_push, *end_push, *start_pop, *pop;
+	int *start, *end, *start_push, *end_push, *start_pop, *pop, err = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
 	if (bytes)
@@ -249,8 +249,11 @@ int bpf_prog4(struct sk_msg_md *msg)
 		bpf_msg_pull_data(msg, *start, *end, 0);
 	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
 	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	if (start_push && end_push) {
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			return SK_DROP;
+	}
 	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
 	pop = bpf_map_lookup_elem(&sock_bytes, &five);
 	if (start_pop && pop)
@@ -263,6 +266,7 @@ int bpf_prog6(struct sk_msg_md *msg)
 {
 	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, key = 0;
 	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop, *f;
+	int err = 0;
 	__u64 flags = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
@@ -279,8 +283,11 @@ int bpf_prog6(struct sk_msg_md *msg)
 
 	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
 	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	if (start_push && end_push) {
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			return SK_DROP;
+	}
 
 	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
 	pop = bpf_map_lookup_elem(&sock_bytes, &five);
@@ -338,7 +345,7 @@ SEC("sk_msg5")
 int bpf_prog10(struct sk_msg_md *msg)
 {
 	int *bytes, *start, *end, *start_push, *end_push, *start_pop, *pop;
-	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5;
+	int zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5, err = 0;
 
 	bytes = bpf_map_lookup_elem(&sock_apply_bytes, &zero);
 	if (bytes)
@@ -352,8 +359,11 @@ int bpf_prog10(struct sk_msg_md *msg)
 		bpf_msg_pull_data(msg, *start, *end, 0);
 	start_push = bpf_map_lookup_elem(&sock_bytes, &two);
 	end_push = bpf_map_lookup_elem(&sock_bytes, &three);
-	if (start_push && end_push)
-		bpf_msg_push_data(msg, *start_push, *end_push, 0);
+	if (start_push && end_push) {
+		err = bpf_msg_push_data(msg, *start_push, *end_push, 0);
+		if (err)
+			return SK_PASS;
+	}
 	start_pop = bpf_map_lookup_elem(&sock_bytes, &four);
 	pop = bpf_map_lookup_elem(&sock_bytes, &five);
 	if (start_pop && pop)
diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index 2674ba20d524..ff821025d309 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -71,6 +71,36 @@ chk_msk_remote_key_nr()
 		__chk_nr "grep -c remote_key" $*
 }
 
+# $1: ns, $2: port
+wait_local_port_listen()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+
+	local port_hex i
+
+	port_hex="$(printf "%04X" "${port}")"
+	for i in $(seq 10); do
+		ip netns exec "${listener_ns}" cat /proc/net/tcp | \
+			awk "BEGIN {rc=1} {if (\$2 ~ /:${port_hex}\$/ && \$4 ~ /0A/) {rc=0; exit}} END {exit rc}" &&
+			break
+		sleep 0.1
+	done
+}
+
+wait_connected()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+
+	local port_hex i
+
+	port_hex="$(printf "%04X" "${port}")"
+	for i in $(seq 10); do
+		ip netns exec ${listener_ns} grep -q " 0100007F:${port_hex} " /proc/net/tcp && break
+		sleep 0.1
+	done
+}
 
 trap cleanup EXIT
 ip netns add $ns
@@ -81,15 +111,15 @@ echo "a" | \
 		ip netns exec $ns \
 			./mptcp_connect -p 10000 -l -t ${timeout_poll} \
 				0.0.0.0 >/dev/null &
-sleep 0.1
+wait_local_port_listen $ns 10000
 chk_msk_nr 0 "no msk on netns creation"
 
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -j -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} \
 				127.0.0.1 >/dev/null &
-sleep 0.1
+wait_connected $ns 10000
 chk_msk_nr 2 "after MPC handshake "
 chk_msk_remote_key_nr 2 "....chk remote_key"
 chk_msk_fallback_nr 0 "....chk no fallback"
@@ -101,13 +131,13 @@ echo "a" | \
 		ip netns exec $ns \
 			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} \
 				0.0.0.0 >/dev/null &
-sleep 0.1
+wait_local_port_listen $ns 10001
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10001 -j -t ${timeout_poll} \
+			./mptcp_connect -p 10001 -r 0 -t ${timeout_poll} \
 				127.0.0.1 >/dev/null &
-sleep 0.1
+wait_connected $ns 10001
 chk_msk_fallback_nr 1 "check fallback"
 flush_pids
 
@@ -119,7 +149,7 @@ for I in `seq 1 $NR_CLIENTS`; do
 				./mptcp_connect -p $((I+10001)) -l -w 10 \
 					-t ${timeout_poll} 0.0.0.0 >/dev/null &
 done
-sleep 0.1
+wait_local_port_listen $ns $((NR_CLIENTS + 10001))
 
 for I in `seq 1 $NR_CLIENTS`; do
 	echo "b" | \
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 3e9d3df9c45c..3be615ab1588 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -624,6 +624,7 @@ chk_join_nr()
 	local ack_nr=$4
 	local count
 	local dump_stats
+	local with_cookie
 
 	printf "%02u %-36s %s" "$TEST_COUNT" "$msg" "syn"
 	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinSynRx | awk '{print $2}'`
@@ -637,12 +638,20 @@ chk_join_nr()
 	fi
 
 	echo -n " - synack"
+	with_cookie=`ip netns exec $ns2 sysctl -n net.ipv4.tcp_syncookies`
 	count=`ip netns exec $ns2 nstat -as | grep MPTcpExtMPJoinSynAckRx | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$syn_ack_nr" ]; then
-		echo "[fail] got $count JOIN[s] synack expected $syn_ack_nr"
-		ret=1
-		dump_stats=1
+		# simult connections exceeding the limit with cookie enabled could go up to
+		# synack validation as the conn limit can be enforced reliably only after
+		# the subflow creation
+		if [ "$with_cookie" = 2 ] && [ "$count" -gt "$syn_ack_nr" ] && [ "$count" -le "$syn_nr" ]; then
+			echo -n "[ ok ]"
+		else
+			echo "[fail] got $count JOIN[s] synack expected $syn_ack_nr"
+			ret=1
+			dump_stats=1
+		fi
 	else
 		echo -n "[ ok ]"
 	fi
