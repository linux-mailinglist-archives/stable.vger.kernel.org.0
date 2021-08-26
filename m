Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB923F88E7
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242832AbhHZN15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242801AbhHZN1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:27:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F335610D1;
        Thu, 26 Aug 2021 13:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629984411;
        bh=wZdSSQUQoNY+GXMM7I6kD6WOrfQ7HpfMe7hc44k0TT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQrXGoTkKKYeBgDlMWSxGSU/cxhjr9aO550BwI1pNy8hkUcLS4Yaw9/BJB0LZlMYN
         zGUBsLQTZpJ0EynpgbXFdKcbPGP3AZecFjyQzm5+Xj+Ccidop73cy+CcFy4bMCxUnR
         lZS9GeVl/+4JVlk8EeE/EjbPgH1QMgRAs8/ZkcHrli8xdyRnomM677uKxC6WS0Mis1
         TnCzlC2cRsTN817QFyEsekiamwFFUoBgr/hyPodYw95Ai1JvB6vhMeOb731lUpM+9D
         cAB8RzksTz8AA+hMogNV72f3UTHvzZ4eaifqntlEYWPOeLYwAlPsBouAIrS8m/ooM8
         bzv53lLOFjcrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: Linux 4.14.245
Date:   Thu, 26 Aug 2021 09:26:48 -0400
Message-Id: <20210826132648.804900-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826132648.804900-1-sashal@kernel.org>
References: <20210826132648.804900-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/filesystems/mandatory-locking.txt b/Documentation/filesystems/mandatory-locking.txt
index 0979d1d2ca8b..a251ca33164a 100644
--- a/Documentation/filesystems/mandatory-locking.txt
+++ b/Documentation/filesystems/mandatory-locking.txt
@@ -169,3 +169,13 @@ havoc if they lock crucial files. The way around it is to change the file
 permissions (remove the setgid bit) before trying to read or write to it.
 Of course, that might be a bit tricky if the system is hung :-(
 
+7. The "mand" mount option
+--------------------------
+Mandatory locking is disabled on all filesystems by default, and must be
+administratively enabled by mounting with "-o mand". That mount option
+is only allowed if the mounting task has the CAP_SYS_ADMIN capability.
+
+Since kernel v4.5, it is possible to disable mandatory locking
+altogether by setting CONFIG_MANDATORY_FILE_LOCKING to "n". A kernel
+with this disabled will reject attempts to mount filesystems with the
+"mand" mount option with the error status EPERM.
diff --git a/Makefile b/Makefile
index ef77eb6d5d29..0c87def162ac 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 244
+SUBLEVEL = 245
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index c4279b0b9f12..437e8d2dcc70 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -411,7 +411,7 @@
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
-	clock-frequency = <400000>;
+	clock-frequency = <100000>;
 
 	tps65218: tps65218@24 {
 		reg = <0x24>;
diff --git a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index 733678b75b88..ad3cdf2ca7fb 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -756,14 +756,14 @@
 			status = "disabled";
 		};
 
-		vica: intc@10140000 {
+		vica: interrupt-controller@10140000 {
 			compatible = "arm,versatile-vic";
 			interrupt-controller;
 			#interrupt-cells = <1>;
 			reg = <0x10140000 0x20>;
 		};
 
-		vicb: intc@10140020 {
+		vicb: interrupt-controller@10140020 {
 			compatible = "arm,versatile-vic";
 			interrupt-controller;
 			#interrupt-cells = <1>;
diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 07d3f3b40246..b8b62df102f1 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -279,7 +279,8 @@ int kprobe_handler(struct pt_regs *regs)
 	if (user_mode(regs))
 		return 0;
 
-	if (!(regs->msr & MSR_IR) || !(regs->msr & MSR_DR))
+	if (!IS_ENABLED(CONFIG_BOOKE) &&
+	    (!(regs->msr & MSR_IR) || !(regs->msr & MSR_DR)))
 		return 0;
 
 	/*
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index b8c935033d21..4f274d851986 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -215,6 +215,14 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 	}
 }
 
+static inline void fxsave(struct fxregs_state *fx)
+{
+	if (IS_ENABLED(CONFIG_X86_32))
+		asm volatile( "fxsave %[fx]" : [fx] "=m" (*fx));
+	else
+		asm volatile("fxsaveq %[fx]" : [fx] "=m" (*fx));
+}
+
 /* These macros all use (%edi)/(%rdi) as the single memory argument. */
 #define XSAVE		".byte " REX_PREFIX "0x0f,0xae,0x27"
 #define XSAVEOPT	".byte " REX_PREFIX "0x0f,0xae,0x37"
@@ -283,28 +291,6 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
 		     : "memory")
 
-/*
- * This function is called only during boot time when x86 caps are not set
- * up and alternative can not be used yet.
- */
-static inline void copy_xregs_to_kernel_booting(struct xregs_state *xstate)
-{
-	u64 mask = -1;
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	WARN_ON(system_state != SYSTEM_BOOTING);
-
-	if (static_cpu_has(X86_FEATURE_XSAVES))
-		XSTATE_OP(XSAVES, xstate, lmask, hmask, err);
-	else
-		XSTATE_OP(XSAVE, xstate, lmask, hmask, err);
-
-	/* We should never fault when copying to a kernel buffer: */
-	WARN_ON_FPU(err);
-}
-
 /*
  * This function is called only during boot time when x86 caps are not set
  * up and alternative can not be used yet.
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 78dd9df88157..2a9e81e93aac 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -117,6 +117,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_IGN_TPR_SHIFT 20
 #define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
 
+#define V_IRQ_INJECTION_BITS_MASK (V_IRQ_MASK | V_INTR_PRIO_MASK | V_IGN_TPR_MASK)
+
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
diff --git a/arch/x86/kernel/cpu/intel_rdt_monitor.c b/arch/x86/kernel/cpu/intel_rdt_monitor.c
index 30827510094b..2d324cd1dea7 100644
--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -225,15 +225,14 @@ void free_rmid(u32 rmid)
 		list_add_tail(&entry->list, &rmid_free_lru);
 }
 
-static int __mon_event_count(u32 rmid, struct rmid_read *rr)
+static u64 __mon_event_count(u32 rmid, struct rmid_read *rr)
 {
 	u64 chunks, shift, tval;
 	struct mbm_state *m;
 
 	tval = __rmid_read(rmid, rr->evtid);
 	if (tval & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL)) {
-		rr->val = tval;
-		return -EINVAL;
+		return tval;
 	}
 	switch (rr->evtid) {
 	case QOS_L3_OCCUP_EVENT_ID:
@@ -245,12 +244,6 @@ static int __mon_event_count(u32 rmid, struct rmid_read *rr)
 	case QOS_L3_MBM_LOCAL_EVENT_ID:
 		m = &rr->d->mbm_local[rmid];
 		break;
-	default:
-		/*
-		 * Code would never reach here because
-		 * an invalid event id would fail the __rmid_read.
-		 */
-		return -EINVAL;
 	}
 
 	if (rr->first) {
@@ -278,23 +271,29 @@ void mon_event_count(void *info)
 	struct rdtgroup *rdtgrp, *entry;
 	struct rmid_read *rr = info;
 	struct list_head *head;
+	u64 ret_val;
 
 	rdtgrp = rr->rgrp;
 
-	if (__mon_event_count(rdtgrp->mon.rmid, rr))
-		return;
+	ret_val = __mon_event_count(rdtgrp->mon.rmid, rr);
 
 	/*
-	 * For Ctrl groups read data from child monitor groups.
+	 * For Ctrl groups read data from child monitor groups and
+	 * add them together. Count events which are read successfully.
+	 * Discard the rmid_read's reporting errors.
 	 */
 	head = &rdtgrp->mon.crdtgrp_list;
 
 	if (rdtgrp->type == RDTCTRL_GROUP) {
 		list_for_each_entry(entry, head, mon.crdtgrp_list) {
-			if (__mon_event_count(entry->mon.rmid, rr))
-				return;
+			if (__mon_event_count(entry->mon.rmid, rr) == 0)
+				ret_val = 0;
 		}
 	}
+
+	/* Report error if none of rmid_reads are successful */
+	if (ret_val)
+		rr->val = ret_val;
 }
 
 static void mbm_update(struct rdt_domain *d, int rmid)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 601a5da1d196..7d372db8bee1 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -404,6 +404,24 @@ static void __init print_xstate_offset_size(void)
 	}
 }
 
+/*
+ * All supported features have either init state all zeros or are
+ * handled in setup_init_fpu() individually. This is an explicit
+ * feature list and does not use XFEATURE_MASK*SUPPORTED to catch
+ * newly added supported features at build time and make people
+ * actually look at the init state for the new feature.
+ */
+#define XFEATURES_INIT_FPSTATE_HANDLED		\
+	(XFEATURE_MASK_FP |			\
+	 XFEATURE_MASK_SSE |			\
+	 XFEATURE_MASK_YMM |			\
+	 XFEATURE_MASK_OPMASK |			\
+	 XFEATURE_MASK_ZMM_Hi256 |		\
+	 XFEATURE_MASK_Hi16_ZMM	 |		\
+	 XFEATURE_MASK_PKRU |			\
+	 XFEATURE_MASK_BNDREGS |		\
+	 XFEATURE_MASK_BNDCSR)
+
 /*
  * setup the xstate image representing the init state
  */
@@ -411,6 +429,8 @@ static void __init setup_init_fpu_buf(void)
 {
 	static int on_boot_cpu __initdata = 1;
 
+	BUILD_BUG_ON(XCNTXT_MASK != XFEATURES_INIT_FPSTATE_HANDLED);
+
 	WARN_ON_FPU(!on_boot_cpu);
 	on_boot_cpu = 0;
 
@@ -429,10 +449,22 @@ static void __init setup_init_fpu_buf(void)
 	copy_kernel_to_xregs_booting(&init_fpstate.xsave);
 
 	/*
-	 * Dump the init state again. This is to identify the init state
-	 * of any feature which is not represented by all zero's.
+	 * All components are now in init state. Read the state back so
+	 * that init_fpstate contains all non-zero init state. This only
+	 * works with XSAVE, but not with XSAVEOPT and XSAVES because
+	 * those use the init optimization which skips writing data for
+	 * components in init state.
+	 *
+	 * XSAVE could be used, but that would require to reshuffle the
+	 * data when XSAVES is available because XSAVES uses xstate
+	 * compaction. But doing so is a pointless exercise because most
+	 * components have an all zeros init state except for the legacy
+	 * ones (FP and SSE). Those can be saved with FXSAVE into the
+	 * legacy area. Adding new features requires to ensure that init
+	 * state is all zeroes or if not to add the necessary handling
+	 * here.
 	 */
-	copy_xregs_to_kernel_booting(&init_fpstate.xsave);
+	fxsave(&init_fpstate.fxsave);
 }
 
 static int xfeature_uncompacted_offset(int xfeature_nr)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3571253b8690..5ff6c145fdbb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -389,6 +389,9 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept_dr = h->intercept_dr | g->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
 	c->intercept = h->intercept | g->intercept;
+
+	c->intercept |= (1ULL << INTERCEPT_VMLOAD);
+	c->intercept |= (1ULL << INTERCEPT_VMSAVE);
 }
 
 static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
@@ -1208,12 +1211,7 @@ static __init int svm_hardware_setup(void)
 		}
 	}
 
-	if (vgif) {
-		if (!boot_cpu_has(X86_FEATURE_VGIF))
-			vgif = false;
-		else
-			pr_info("Virtual GIF supported\n");
-	}
+	vgif = false; /* Disabled for CVE-2021-3653 */
 
 	return 0;
 
@@ -3161,7 +3159,13 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
 	svm_flush_tlb(&svm->vcpu, true);
-	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
+
+	svm->vmcb->control.int_ctl &=
+			V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
+
+	svm->vmcb->control.int_ctl |= nested_vmcb->control.int_ctl &
+			(V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK);
+
 	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 	else
diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
index fd1ab80be0de..a4cf678cf5c8 100644
--- a/arch/x86/tools/chkobjdump.awk
+++ b/arch/x86/tools/chkobjdump.awk
@@ -10,6 +10,7 @@ BEGIN {
 
 /^GNU objdump/ {
 	verstr = ""
+	gsub(/\(.*\)/, "");
 	for (i = 3; i <= NF; i++)
 		if (match($(i), "^[0-9]")) {
 			verstr = $(i);
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 20fd197ef74c..bfa163e9d6c3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2454,6 +2454,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping_desc *mapping;
 
+		/* range index 0 == unmapped in SPA or invalid-SPA */
+		if (memdev->range_index == 0 || spa->range_index == 0)
+			continue;
 		if (memdev->range_index != spa->range_index)
 			continue;
 		if (count >= ND_MAX_MAPPINGS) {
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 92415a748ad2..e834087448a4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1445,6 +1445,7 @@ void device_initialize(struct device *dev)
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spin_lock_init(&dev->msi_lock);
 	INIT_LIST_HEAD(&dev->msi_list);
 #endif
 	INIT_LIST_HEAD(&dev->links.consumers);
diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 8344a60c2131..a9d3ab94749b 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -68,8 +68,12 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
 		return NULL;
 
 	ofdma_target = of_dma_find_controller(&dma_spec_target);
-	if (!ofdma_target)
-		return NULL;
+	if (!ofdma_target) {
+		ofdma->dma_router->route_free(ofdma->dma_router->dev,
+					      route_data);
+		chan = ERR_PTR(-EPROBE_DEFER);
+		goto err;
+	}
 
 	chan = ofdma_target->of_dma_xlate(&dma_spec_target, ofdma_target);
 	if (IS_ERR_OR_NULL(chan)) {
@@ -80,6 +84,7 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
 		chan->route_data = route_data;
 	}
 
+err:
 	/*
 	 * Need to put the node back since the ofdma->of_dma_route_allocate
 	 * has taken it for generating the new, translated dma_spec
diff --git a/drivers/dma/sh/usb-dmac.c b/drivers/dma/sh/usb-dmac.c
index 31a145154e9f..744fab9da918 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -858,8 +858,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
 error:
 	of_dma_controller_free(pdev->dev.of_node);
-	pm_runtime_put(&pdev->dev);
 error_pm:
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index c4066276eb7b..b7f9fb00f695 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -148,7 +148,7 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 	if (count > 8192)
 		count = 8192;
 
-	tmp = kmalloc(count, GFP_KERNEL);
+	tmp = kzalloc(count, GFP_KERNEL);
 	if (tmp == NULL)
 		return -ENOMEM;
 
@@ -157,7 +157,8 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 
 	ret = i2c_master_recv(client, tmp, count);
 	if (ret >= 0)
-		ret = copy_to_user(buf, tmp, count) ? -EFAULT : ret;
+		if (copy_to_user(buf, tmp, ret))
+			ret = -EFAULT;
 	kfree(tmp);
 	return ret;
 }
diff --git a/drivers/iio/adc/palmas_gpadc.c b/drivers/iio/adc/palmas_gpadc.c
index 7d61b566e148..f5218461ae25 100644
--- a/drivers/iio/adc/palmas_gpadc.c
+++ b/drivers/iio/adc/palmas_gpadc.c
@@ -660,8 +660,8 @@ static int palmas_adc_wakeup_configure(struct palmas_gpadc *adc)
 
 	adc_period = adc->auto_conversion_period;
 	for (i = 0; i < 16; ++i) {
-		if (((1000 * (1 << i)) / 32) < adc_period)
-			continue;
+		if (((1000 * (1 << i)) / 32) >= adc_period)
+			break;
 	}
 	if (i > 0)
 		i--;
diff --git a/drivers/iio/humidity/hdc100x.c b/drivers/iio/humidity/hdc100x.c
index 273eb0612a5d..344fbefa88ae 100644
--- a/drivers/iio/humidity/hdc100x.c
+++ b/drivers/iio/humidity/hdc100x.c
@@ -32,6 +32,8 @@
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 
+#include <linux/time.h>
+
 #define HDC100X_REG_TEMP			0x00
 #define HDC100X_REG_HUMIDITY			0x01
 
@@ -173,7 +175,7 @@ static int hdc100x_get_measurement(struct hdc100x_data *data,
 				   struct iio_chan_spec const *chan)
 {
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[chan->address];
+	int delay = data->adc_int_us[chan->address] + 1*USEC_PER_MSEC;
 	int ret;
 	__be16 val;
 
@@ -330,7 +332,7 @@ static irqreturn_t hdc100x_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct hdc100x_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[0] + data->adc_int_us[1];
+	int delay = data->adc_int_us[0] + data->adc_int_us[1] + 2*USEC_PER_MSEC;
 	int ret;
 
 	/* dual read starts at temp register */
diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 7ba1a94497f5..4294523bede5 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -94,16 +94,13 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 	free_irq(tpci200->info->pdev->irq, (void *) tpci200);
 
 	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
-	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
 
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
-	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
 
 	pci_disable_device(tpci200->info->pdev);
-	pci_dev_put(tpci200->info->pdev);
 }
 
 static void tpci200_enable_irq(struct tpci200_board *tpci200,
@@ -524,7 +521,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	tpci200->info = kzalloc(sizeof(struct tpci200_infos), GFP_KERNEL);
 	if (!tpci200->info) {
 		ret = -ENOMEM;
-		goto out_err_info;
+		goto err_tpci200;
 	}
 
 	pci_dev_get(pdev);
@@ -535,7 +532,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to allocate PCI Configuration Memory");
 		ret = -EBUSY;
-		goto out_err_pci_request;
+		goto err_tpci200_info;
 	}
 	tpci200->info->cfg_regs = ioremap_nocache(
 			pci_resource_start(pdev, TPCI200_CFG_MEM_BAR),
@@ -543,7 +540,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (!tpci200->info->cfg_regs) {
 		dev_err(&pdev->dev, "Failed to map PCI Configuration Memory");
 		ret = -EFAULT;
-		goto out_err_ioremap;
+		goto err_request_region;
 	}
 
 	/* Disable byte swapping for 16 bit IP module access. This will ensure
@@ -566,7 +563,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "error during tpci200 install\n");
 		ret = -ENODEV;
-		goto out_err_install;
+		goto err_cfg_regs;
 	}
 
 	/* Register the carrier in the industry pack bus driver */
@@ -578,7 +575,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev,
 			"error registering the carrier on ipack driver\n");
 		ret = -EFAULT;
-		goto out_err_bus_register;
+		goto err_tpci200_install;
 	}
 
 	/* save the bus number given by ipack to logging purpose */
@@ -589,19 +586,16 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 		tpci200_create_device(tpci200, i);
 	return 0;
 
-out_err_bus_register:
+err_tpci200_install:
 	tpci200_uninstall(tpci200);
-	/* tpci200->info->cfg_regs is unmapped in tpci200_uninstall */
-	tpci200->info->cfg_regs = NULL;
-out_err_install:
-	if (tpci200->info->cfg_regs)
-		iounmap(tpci200->info->cfg_regs);
-out_err_ioremap:
+err_cfg_regs:
+	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
+err_request_region:
 	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
-out_err_pci_request:
-	pci_dev_put(pdev);
+err_tpci200_info:
 	kfree(tpci200->info);
-out_err_info:
+	pci_dev_put(pdev);
+err_tpci200:
 	kfree(tpci200);
 	return ret;
 }
@@ -611,6 +605,12 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
 	ipack_bus_unregister(tpci200->info->ipack_bus);
 	tpci200_uninstall(tpci200);
 
+	pci_iounmap(tpci200->info->pdev, tpci200->info->cfg_regs);
+
+	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
+
+	pci_dev_put(tpci200->info->pdev);
+
 	kfree(tpci200->info);
 	kfree(tpci200);
 }
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 32001d43e453..bd994a8fce14 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2051,8 +2051,8 @@ static void dw_mci_tasklet_func(unsigned long priv)
 					continue;
 				}
 
-				dw_mci_stop_dma(host);
 				send_stop_abort(host, data);
+				dw_mci_stop_dma(host);
 				state = STATE_SENDING_STOP;
 				break;
 			}
@@ -2076,10 +2076,10 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			 */
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
-				dw_mci_stop_dma(host);
 				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
+				dw_mci_stop_dma(host);
 				state = STATE_DATA_ERROR;
 				break;
 			}
@@ -2112,10 +2112,10 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			 */
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
-				dw_mci_stop_dma(host);
 				if (!(host->data_status & (SDMMC_INT_DRTO |
 							   SDMMC_INT_EBE)))
 					send_stop_abort(host, data);
+				dw_mci_stop_dma(host);
 				state = STATE_DATA_ERROR;
 				break;
 			}
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 58c16aa00a70..fdfef3a7c05a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -54,6 +54,7 @@ static const struct mt7530_mib_desc mt7530_mib[] = {
 	MIB_DESC(2, 0x48, "TxBytes"),
 	MIB_DESC(1, 0x60, "RxDrop"),
 	MIB_DESC(1, 0x64, "RxFiltering"),
+	MIB_DESC(1, 0x68, "RxUnicast"),
 	MIB_DESC(1, 0x6c, "RxMulticast"),
 	MIB_DESC(1, 0x70, "RxBroadcast"),
 	MIB_DESC(1, 0x74, "RxAlignErr"),
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9135c3eccb58..c4b0c35a270c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -266,6 +266,26 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
 	return md_dst->u.port_info.port_id;
 }
 
+static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
+					  struct bnxt_tx_ring_info *txr,
+					  struct netdev_queue *txq)
+{
+	netif_tx_stop_queue(txq);
+
+	/* netif_tx_stop_queue() must be done before checking
+	 * tx index in bnxt_tx_avail() below, because in
+	 * bnxt_tx_int(), we update tx index before checking for
+	 * netif_tx_queue_stopped().
+	 */
+	smp_mb();
+	if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh) {
+		netif_tx_wake_queue(txq);
+		return false;
+	}
+
+	return true;
+}
+
 static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -293,8 +313,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
-		netif_tx_stop_queue(txq);
-		return NETDEV_TX_BUSY;
+		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
+			return NETDEV_TX_BUSY;
 	}
 
 	length = skb->len;
@@ -505,16 +525,7 @@ tx_done:
 		if (skb->xmit_more && !tx_buf->is_push)
 			bnxt_db_write(bp, txr->tx_doorbell, DB_KEY_TX | prod);
 
-		netif_tx_stop_queue(txq);
-
-		/* netif_tx_stop_queue() must be done before checking
-		 * tx index in bnxt_tx_avail() below, because in
-		 * bnxt_tx_int(), we update tx index before checking for
-		 * netif_tx_queue_stopped().
-		 */
-		smp_mb();
-		if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)
-			netif_tx_wake_queue(txq);
+		bnxt_txr_netif_try_stop_queue(bp, txr, txq);
 	}
 	return NETDEV_TX_OK;
 
@@ -598,14 +609,9 @@ next_tx_int:
 	smp_mb();
 
 	if (unlikely(netif_tx_queue_stopped(txq)) &&
-	    (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)) {
-		__netif_tx_lock(txq, smp_processor_id());
-		if (netif_tx_queue_stopped(txq) &&
-		    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
-		    txr->dev_state != BNXT_DEV_STATE_CLOSING)
-			netif_tx_wake_queue(txq);
-		__netif_tx_unlock(txq);
-	}
+	    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
+	    READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)
+		netif_tx_wake_queue(txq);
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
@@ -5748,9 +5754,11 @@ void bnxt_tx_disable(struct bnxt *bp)
 	if (bp->tx_ring) {
 		for (i = 0; i < bp->tx_nr_rings; i++) {
 			txr = &bp->tx_ring[i];
-			txr->dev_state = BNXT_DEV_STATE_CLOSING;
+			WRITE_ONCE(txr->dev_state, BNXT_DEV_STATE_CLOSING);
 		}
 	}
+	/* Make sure napi polls see @dev_state change */
+	synchronize_net();
 	/* Drop carrier first to prevent TX timeout */
 	netif_carrier_off(bp->dev);
 	/* Stop all TX queues */
@@ -5764,8 +5772,10 @@ void bnxt_tx_enable(struct bnxt *bp)
 
 	for (i = 0; i < bp->tx_nr_rings; i++) {
 		txr = &bp->tx_ring[i];
-		txr->dev_state = 0;
+		WRITE_ONCE(txr->dev_state, 0);
 	}
+	/* Make sure napi polls see @dev_state change */
+	synchronize_net();
 	netif_tx_wake_all_queues(bp->dev);
 	if (bp->link_info.link_up)
 		netif_carrier_on(bp->dev);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index aae81226a0a4..4994599728dc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3157,8 +3157,10 @@ int qlcnic_83xx_flash_read32(struct qlcnic_adapter *adapter, u32 flash_addr,
 
 		indirect_addr = QLC_83XX_FLASH_DIRECT_DATA(addr);
 		ret = QLCRD32(adapter, indirect_addr, &err);
-		if (err == -EIO)
+		if (err == -EIO) {
+			qlcnic_83xx_unlock_flash(adapter);
 			return err;
+		}
 
 		word = ret;
 		*(u32 *)p_data  = word;
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 6d4742d10a78..231eaef29266 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -870,6 +870,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
 		return;
 	}
 
+	if (sp->rx_count_cooked + 2 >= sizeof(sp->cooked_buf)) {
+		pr_err("6pack: cooked buffer overrun, data loss\n");
+		sp->rx_count = 0;
+		return;
+	}
+
 	buf = sp->raw_buf;
 	sp->cooked_buf[sp->rx_count_cooked++] =
 		buf[0] | ((buf[1] << 2) & 0xc0);
diff --git a/drivers/net/phy/mdio-mux.c b/drivers/net/phy/mdio-mux.c
index 0a86f1e4c02f..c16f875ed9ea 100644
--- a/drivers/net/phy/mdio-mux.c
+++ b/drivers/net/phy/mdio-mux.c
@@ -85,6 +85,17 @@ out:
 
 static int parent_count;
 
+static void mdio_mux_uninit_children(struct mdio_mux_parent_bus *pb)
+{
+	struct mdio_mux_child_bus *cb = pb->children;
+
+	while (cb) {
+		mdiobus_unregister(cb->mii_bus);
+		mdiobus_free(cb->mii_bus);
+		cb = cb->next;
+	}
+}
+
 int mdio_mux_init(struct device *dev,
 		  struct device_node *mux_node,
 		  int (*switch_fn)(int cur, int desired, void *data),
@@ -147,7 +158,7 @@ int mdio_mux_init(struct device *dev,
 		cb = devm_kzalloc(dev, sizeof(*cb), GFP_KERNEL);
 		if (!cb) {
 			ret_val = -ENOMEM;
-			continue;
+			goto err_loop;
 		}
 		cb->bus_number = v;
 		cb->parent = pb;
@@ -155,8 +166,7 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus = mdiobus_alloc();
 		if (!cb->mii_bus) {
 			ret_val = -ENOMEM;
-			devm_kfree(dev, cb);
-			continue;
+			goto err_loop;
 		}
 		cb->mii_bus->priv = cb;
 
@@ -168,11 +178,15 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus->write = mdio_mux_write;
 		r = of_mdiobus_register(cb->mii_bus, child_bus_node);
 		if (r) {
+			mdiobus_free(cb->mii_bus);
+			if (r == -EPROBE_DEFER) {
+				ret_val = r;
+				goto err_loop;
+			}
+			devm_kfree(dev, cb);
 			dev_err(dev,
 				"Error: Failed to register MDIO bus for child %pOF\n",
 				child_bus_node);
-			mdiobus_free(cb->mii_bus);
-			devm_kfree(dev, cb);
 		} else {
 			cb->next = pb->children;
 			pb->children = cb;
@@ -185,6 +199,10 @@ int mdio_mux_init(struct device *dev,
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
 	devm_kfree(dev, pb);
+
+err_loop:
+	mdio_mux_uninit_children(pb);
+	of_node_put(child_bus_node);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
@@ -196,14 +214,8 @@ EXPORT_SYMBOL_GPL(mdio_mux_init);
 void mdio_mux_uninit(void *mux_handle)
 {
 	struct mdio_mux_parent_bus *pb = mux_handle;
-	struct mdio_mux_child_bus *cb = pb->children;
-
-	while (cb) {
-		mdiobus_unregister(cb->mii_bus);
-		mdiobus_free(cb->mii_bus);
-		cb = cb->next;
-	}
 
+	mdio_mux_uninit_children(pb);
 	put_device(&pb->mii_bus->dev);
 }
 EXPORT_SYMBOL_GPL(mdio_mux_uninit);
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index f846c55f9df0..c6e067aae955 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1139,7 +1139,7 @@ static int ppp_nl_newlink(struct net *src_net, struct net_device *dev,
 	 * the PPP unit identifer as suffix (i.e. ppp<unit_id>). This allows
 	 * userspace to infer the device name using to the PPPIOCGUNIT ioctl.
 	 */
-	if (!tb[IFLA_IFNAME])
+	if (!tb[IFLA_IFNAME] || !nla_len(tb[IFLA_IFNAME]) || !*(char *)nla_data(tb[IFLA_IFNAME]))
 		conf.ifname_is_set = false;
 
 	err = ppp_dev_configure(src_net, dev, &conf);
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 120e99914fd6..ff108611c5e4 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1147,7 +1147,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
 	struct ethtool_link_ksettings ecmd;
-	int ladv, radv, ret;
+	int ladv, radv, ret, link;
 	u32 buf;
 
 	/* clear LAN78xx interrupt status */
@@ -1155,9 +1155,12 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 	if (unlikely(ret < 0))
 		return -EIO;
 
+	mutex_lock(&phydev->lock);
 	phy_read_status(phydev);
+	link = phydev->link;
+	mutex_unlock(&phydev->lock);
 
-	if (!phydev->link && dev->link_on) {
+	if (!link && dev->link_on) {
 		dev->link_on = false;
 
 		/* reset MAC */
@@ -1170,7 +1173,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 			return -EIO;
 
 		del_timer(&dev->stat_monitor);
-	} else if (phydev->link && !dev->link_on) {
+	} else if (link && !dev->link_on) {
 		dev->link_on = true;
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
@@ -1457,9 +1460,14 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
 static u32 lan78xx_get_link(struct net_device *net)
 {
+	u32 link;
+
+	mutex_lock(&net->phydev->lock);
 	phy_read_status(net->phydev);
+	link = net->phydev->link;
+	mutex_unlock(&net->phydev->lock);
 
-	return net->phydev->link;
+	return link;
 }
 
 static void lan78xx_get_drvinfo(struct net_device *net,
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index f3f2784f6ebd..28068544e2fe 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -199,12 +199,13 @@ struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr);
 
 void ath_hw_setbssidmask(struct ath_common *common);
-void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
+void ath_key_delete(struct ath_common *common, u8 hw_key_idx);
 int ath_key_config(struct ath_common *common,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
 			  struct ieee80211_key_conf *key);
 bool ath_hw_keyreset(struct ath_common *common, u16 entry);
+bool ath_hw_keysetmac(struct ath_common *common, u16 entry, const u8 *mac);
 void ath_hw_cycle_counters_update(struct ath_common *common);
 int32_t ath_hw_get_listen_time(struct ath_common *common);
 
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 16e052d02c94..0f4836fc3b7c 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -522,7 +522,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a553c91d41a1..7d670a71b7b8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1460,7 +1460,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		ath_key_delete(common, key->hw_key_idx);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4ac70827d142..ea008046c1f8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -816,6 +816,7 @@ struct ath_hw {
 	struct ath9k_pacal_info pacal_info;
 	struct ar5416Stats stats;
 	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
+	DECLARE_BITMAP(pending_del_keymap, ATH_KEYMAX);
 
 	enum ath9k_int imask;
 	u32 imrs2_reg;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a678dd8035f3..173960682ea0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -822,12 +822,80 @@ exit:
 	ieee80211_free_txskb(hw, skb);
 }
 
+static bool ath9k_txq_list_has_key(struct list_head *txq_list, u32 keyix)
+{
+	struct ath_buf *bf;
+	struct ieee80211_tx_info *txinfo;
+	struct ath_frame_info *fi;
+
+	list_for_each_entry(bf, txq_list, list) {
+		if (bf->bf_state.stale || !bf->bf_mpdu)
+			continue;
+
+		txinfo = IEEE80211_SKB_CB(bf->bf_mpdu);
+		fi = (struct ath_frame_info *)&txinfo->rate_driver_data[0];
+		if (fi->keyix == keyix)
+			return true;
+	}
+
+	return false;
+}
+
+static bool ath9k_txq_has_key(struct ath_softc *sc, u32 keyix)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	int i;
+	struct ath_txq *txq;
+	bool key_in_use = false;
+
+	for (i = 0; !key_in_use && i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+		txq = &sc->tx.txq[i];
+		if (!txq->axq_depth)
+			continue;
+		if (!ath9k_hw_numtxpending(ah, txq->axq_qnum))
+			continue;
+
+		ath_txq_lock(sc, txq);
+		key_in_use = ath9k_txq_list_has_key(&txq->axq_q, keyix);
+		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+			int idx = txq->txq_tailidx;
+
+			while (!key_in_use &&
+			       !list_empty(&txq->txq_fifo[idx])) {
+				key_in_use = ath9k_txq_list_has_key(
+					&txq->txq_fifo[idx], keyix);
+				INCR(idx, ATH_TXFIFO_DEPTH);
+			}
+		}
+		ath_txq_unlock(sc, txq);
+	}
+
+	return key_in_use;
+}
+
+static void ath9k_pending_key_del(struct ath_softc *sc, u8 keyix)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!test_bit(keyix, ah->pending_del_keymap) ||
+	    ath9k_txq_has_key(sc, keyix))
+		return;
+
+	/* No more TXQ frames point to this key cache entry, so delete it. */
+	clear_bit(keyix, ah->pending_del_keymap);
+	ath_key_delete(common, keyix);
+}
+
 static void ath9k_stop(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool prev_idle;
+	int i;
 
 	ath9k_deinit_channel_context(sc);
 
@@ -895,6 +963,14 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	for (i = 0; i < ATH_KEYMAX; i++)
+		ath9k_pending_key_del(sc, i);
+
+	/* Clear key cache entries explicitly to get rid of any potentially
+	 * remaining keys.
+	 */
+	ath9k_cmn_init_crypto(sc->sc_ah);
+
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = prev_idle;
@@ -1540,12 +1616,11 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
-	struct ieee80211_key_conf ps_key = { .hw_key_idx = an->ps_key };
 
 	if (!an->ps_key)
 	    return;
 
-	ath_key_delete(common, &ps_key);
+	ath_key_delete(common, an->ps_key);
 	an->ps_key = 0;
 	an->key_idx[0] = 0;
 }
@@ -1707,6 +1782,12 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	if (sta)
 		an = (struct ath_node *)sta->drv_priv;
 
+	/* Delete pending key cache entries if no more frames are pointing to
+	 * them in TXQs.
+	 */
+	for (i = 0; i < ATH_KEYMAX; i++)
+		ath9k_pending_key_del(sc, i);
+
 	switch (cmd) {
 	case SET_KEY:
 		if (sta)
@@ -1736,7 +1817,15 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		}
 		break;
 	case DISABLE_KEY:
-		ath_key_delete(common, key);
+		if (ath9k_txq_has_key(sc, key->hw_key_idx)) {
+			/* Delay key cache entry deletion until there are no
+			 * remaining TXQ frames pointing to this entry.
+			 */
+			set_bit(key->hw_key_idx, sc->sc_ah->pending_del_keymap);
+			ath_hw_keysetmac(common, key->hw_key_idx, NULL);
+		} else {
+			ath_key_delete(common, key->hw_key_idx);
+		}
 		if (an) {
 			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
 				if (an->key_idx[i] != key->hw_key_idx)
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 1816b4e7dc26..61b59a804e30 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -84,8 +84,7 @@ bool ath_hw_keyreset(struct ath_common *common, u16 entry)
 }
 EXPORT_SYMBOL(ath_hw_keyreset);
 
-static bool ath_hw_keysetmac(struct ath_common *common,
-			     u16 entry, const u8 *mac)
+bool ath_hw_keysetmac(struct ath_common *common, u16 entry, const u8 *mac)
 {
 	u32 macHi, macLo;
 	u32 unicast_flag = AR_KEYTABLE_VALID;
@@ -125,6 +124,7 @@ static bool ath_hw_keysetmac(struct ath_common *common,
 
 	return true;
 }
+EXPORT_SYMBOL(ath_hw_keysetmac);
 
 static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
 				      const struct ath_keyval *k,
@@ -581,29 +581,38 @@ EXPORT_SYMBOL(ath_key_config);
 /*
  * Delete Key.
  */
-void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
+void ath_key_delete(struct ath_common *common, u8 hw_key_idx)
 {
-	ath_hw_keyreset(common, key->hw_key_idx);
-	if (key->hw_key_idx < IEEE80211_WEP_NKID)
+	/* Leave CCMP and TKIP (main key) configured to avoid disabling
+	 * encryption for potentially pending frames already in a TXQ with the
+	 * keyix pointing to this key entry. Instead, only clear the MAC address
+	 * to prevent RX processing from using this key cache entry.
+	 */
+	if (test_bit(hw_key_idx, common->ccmp_keymap) ||
+	    test_bit(hw_key_idx, common->tkip_keymap))
+		ath_hw_keysetmac(common, hw_key_idx, NULL);
+	else
+		ath_hw_keyreset(common, hw_key_idx);
+	if (hw_key_idx < IEEE80211_WEP_NKID)
 		return;
 
-	clear_bit(key->hw_key_idx, common->keymap);
-	clear_bit(key->hw_key_idx, common->ccmp_keymap);
-	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
+	clear_bit(hw_key_idx, common->keymap);
+	clear_bit(hw_key_idx, common->ccmp_keymap);
+	if (!test_bit(hw_key_idx, common->tkip_keymap))
 		return;
 
-	clear_bit(key->hw_key_idx + 64, common->keymap);
+	clear_bit(hw_key_idx + 64, common->keymap);
 
-	clear_bit(key->hw_key_idx, common->tkip_keymap);
-	clear_bit(key->hw_key_idx + 64, common->tkip_keymap);
+	clear_bit(hw_key_idx, common->tkip_keymap);
+	clear_bit(hw_key_idx + 64, common->tkip_keymap);
 
 	if (!(common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)) {
-		ath_hw_keyreset(common, key->hw_key_idx + 32);
-		clear_bit(key->hw_key_idx + 32, common->keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, common->keymap);
+		ath_hw_keyreset(common, hw_key_idx + 32);
+		clear_bit(hw_key_idx + 32, common->keymap);
+		clear_bit(hw_key_idx + 64 + 32, common->keymap);
 
-		clear_bit(key->hw_key_idx + 32, common->tkip_keymap);
-		clear_bit(key->hw_key_idx + 64 + 32, common->tkip_keymap);
+		clear_bit(hw_key_idx + 32, common->tkip_keymap);
+		clear_bit(hw_key_idx + 64 + 32, common->tkip_keymap);
 	}
 }
 EXPORT_SYMBOL(ath_key_delete);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 2a203055b16e..147369773280 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -170,24 +170,25 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
  * reliably as devices without an INTx disable bit will then generate a
  * level IRQ which will never be cleared.
  */
-u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
-	u32 mask_bits = desc->masked;
+	raw_spinlock_t *lock = &desc->dev->msi_lock;
+	unsigned long flags;
 
 	if (pci_msi_ignore_mask || !desc->msi_attrib.maskbit)
-		return 0;
+		return;
 
-	mask_bits &= ~mask;
-	mask_bits |= flag;
+	raw_spin_lock_irqsave(lock, flags);
+	desc->masked &= ~mask;
+	desc->masked |= flag;
 	pci_write_config_dword(msi_desc_to_pci_dev(desc), desc->mask_pos,
-			       mask_bits);
-
-	return mask_bits;
+			       desc->masked);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 
 static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
-	desc->masked = __pci_msi_desc_mask_irq(desc, mask, flag);
+	__pci_msi_desc_mask_irq(desc, mask, flag);
 }
 
 static void __iomem *pci_msix_desc_addr(struct msi_desc *desc)
@@ -302,10 +303,28 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 		/* Don't touch the hardware now */
 	} else if (entry->msi_attrib.is_msix) {
 		void __iomem *base = pci_msix_desc_addr(entry);
+		bool unmasked = !(entry->masked & PCI_MSIX_ENTRY_CTRL_MASKBIT);
+
+		/*
+		 * The specification mandates that the entry is masked
+		 * when the message is modified:
+		 *
+		 * "If software changes the Address or Data value of an
+		 * entry while the entry is unmasked, the result is
+		 * undefined."
+		 */
+		if (unmasked)
+			__pci_msix_desc_mask_irq(entry, PCI_MSIX_ENTRY_CTRL_MASKBIT);
 
 		writel(msg->address_lo, base + PCI_MSIX_ENTRY_LOWER_ADDR);
 		writel(msg->address_hi, base + PCI_MSIX_ENTRY_UPPER_ADDR);
 		writel(msg->data, base + PCI_MSIX_ENTRY_DATA);
+
+		if (unmasked)
+			__pci_msix_desc_mask_irq(entry, 0);
+
+		/* Ensure that the writes are visible in the device */
+		readl(base + PCI_MSIX_ENTRY_DATA);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
@@ -326,6 +345,8 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 			pci_write_config_word(dev, pos + PCI_MSI_DATA_32,
 					      msg->data);
 		}
+		/* Ensure that the writes are visible in the device */
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
 	}
 	entry->msg = *msg;
 }
@@ -619,21 +640,21 @@ static int msi_capability_init(struct pci_dev *dev, int nvec,
 	/* Configure MSI capability structure */
 	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
+		msi_mask_irq(entry, mask, 0);
 		free_msi_irqs(dev);
 		return ret;
 	}
 
 	ret = msi_verify_entries(dev);
 	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
+		msi_mask_irq(entry, mask, 0);
 		free_msi_irqs(dev);
 		return ret;
 	}
 
 	ret = populate_msi_sysfs(dev);
 	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
+		msi_mask_irq(entry, mask, 0);
 		free_msi_irqs(dev);
 		return ret;
 	}
@@ -674,6 +695,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 {
 	struct cpumask *curmsk, *masks = NULL;
 	struct msi_desc *entry;
+	void __iomem *addr;
 	int ret, i;
 
 	if (affd)
@@ -693,6 +715,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 
 		entry->msi_attrib.is_msix	= 1;
 		entry->msi_attrib.is_64		= 1;
+
 		if (entries)
 			entry->msi_attrib.entry_nr = entries[i].entry;
 		else
@@ -700,6 +723,10 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
 
+		addr = pci_msix_desc_addr(entry);
+		if (addr)
+			entry->masked = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
+
 		list_add_tail(&entry->list, dev_to_msi_list(&dev->dev));
 		if (masks)
 			curmsk++;
@@ -710,21 +737,27 @@ out:
 	return ret;
 }
 
-static void msix_program_entries(struct pci_dev *dev,
-				 struct msix_entry *entries)
+static void msix_update_entries(struct pci_dev *dev, struct msix_entry *entries)
 {
 	struct msi_desc *entry;
-	int i = 0;
 
 	for_each_pci_msi_entry(entry, dev) {
-		if (entries)
-			entries[i++].vector = entry->irq;
-		entry->masked = readl(pci_msix_desc_addr(entry) +
-				PCI_MSIX_ENTRY_VECTOR_CTRL);
-		msix_mask_irq(entry, 1);
+		if (entries) {
+			entries->vector = entry->irq;
+			entries++;
+		}
 	}
 }
 
+static void msix_mask_all(void __iomem *base, int tsize)
+{
+	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
+	int i;
+
+	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
+		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
+}
+
 /**
  * msix_capability_init - configure device's MSI-X capability
  * @dev: pointer to the pci_dev data structure of MSI-X device function
@@ -739,22 +772,33 @@ static void msix_program_entries(struct pci_dev *dev,
 static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 				int nvec, const struct irq_affinity *affd)
 {
-	int ret;
-	u16 control;
 	void __iomem *base;
+	int ret, tsize;
+	u16 control;
 
-	/* Ensure MSI-X is disabled while it is set up */
-	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+	/*
+	 * Some devices require MSI-X to be enabled before the MSI-X
+	 * registers can be accessed.  Mask all the vectors to prevent
+	 * interrupts coming in before they're fully set up.
+	 */
+	pci_msix_clear_and_set_ctrl(dev, 0, PCI_MSIX_FLAGS_MASKALL |
+				    PCI_MSIX_FLAGS_ENABLE);
 
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
 	/* Request & Map MSI-X table region */
-	base = msix_map_region(dev, msix_table_size(control));
-	if (!base)
-		return -ENOMEM;
+	tsize = msix_table_size(control);
+	base = msix_map_region(dev, tsize);
+	if (!base) {
+		ret = -ENOMEM;
+		goto out_disable;
+	}
+
+	/* Ensure that all table entries are masked. */
+	msix_mask_all(base, tsize);
 
 	ret = msix_setup_entries(dev, base, entries, nvec, affd);
 	if (ret)
-		return ret;
+		goto out_disable;
 
 	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
@@ -765,15 +809,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	if (ret)
 		goto out_free;
 
-	/*
-	 * Some devices require MSI-X to be enabled before we can touch the
-	 * MSI-X registers.  We need to mask all the vectors to prevent
-	 * interrupts coming in before they're fully set up.
-	 */
-	pci_msix_clear_and_set_ctrl(dev, 0,
-				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE);
-
-	msix_program_entries(dev, entries);
+	msix_update_entries(dev, entries);
 
 	ret = populate_msi_sysfs(dev);
 	if (ret)
@@ -807,6 +843,9 @@ out_avail:
 out_free:
 	free_msi_irqs(dev);
 
+out_disable:
+	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+
 	return ret;
 }
 
@@ -894,8 +933,7 @@ static void pci_msi_shutdown(struct pci_dev *dev)
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	/* Keep cached state to be restored */
-	__pci_msi_desc_mask_irq(desc, mask, ~mask);
+	msi_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = desc->msi_attrib.default_irq;
@@ -980,10 +1018,8 @@ static void pci_msix_shutdown(struct pci_dev *dev)
 	}
 
 	/* Return the device with MSI-X masked as initial states */
-	for_each_pci_msi_entry(entry, dev) {
-		/* Keep cached states to be restored */
+	for_each_pci_msi_entry(entry, dev)
 		__pci_msix_desc_mask_irq(entry, 1);
-	}
 
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
 	pci_intx_for_msi(dev, 1);
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index a21ad10d613c..a8b4ca17208d 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -91,7 +91,8 @@ config DP83640_PHY
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
 	depends on X86_32 || COMPILE_TEST
-	depends on HAS_IOMEM && NET
+	depends on HAS_IOMEM && PCI
+	depends on NET
 	imply PTP_1588_CLOCK
 	help
 	  This driver adds support for using the PCH EG20T as a PTP
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b92e06f75756..897449deab62 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -453,8 +453,8 @@ static int initialize_controller(struct scsi_device *sdev,
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 		else {
-			list_add_rcu(&h->node, &h->ctlr->dh_list);
 			h->sdev = sdev;
+			list_add_rcu(&h->node, &h->ctlr->dh_list);
 		}
 		spin_unlock(&list_lock);
 		err = SCSI_DH_OK;
@@ -779,11 +779,11 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 	spin_lock(&list_lock);
 	if (h->ctlr) {
 		list_del_rcu(&h->node);
-		h->sdev = NULL;
 		kref_put(&h->ctlr->kref, release_controller);
 	}
 	spin_unlock(&list_lock);
 	sdev->handler_data = NULL;
+	synchronize_rcu();
 	kfree(h);
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 65b6f6ace3a5..8ec308c5970f 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -250,7 +250,7 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 	mimd_t		mimd;
 	uint32_t	adapno;
 	int		iterator;
-
+	bool		is_found;
 
 	if (copy_from_user(&mimd, umimd, sizeof(mimd_t))) {
 		*rval = -EFAULT;
@@ -266,12 +266,16 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 
 	adapter = NULL;
 	iterator = 0;
+	is_found = false;
 
 	list_for_each_entry(adapter, &adapters_list_g, list) {
-		if (iterator++ == adapno) break;
+		if (iterator++ == adapno) {
+			is_found = true;
+			break;
+		}
 	}
 
-	if (!adapter) {
+	if (!is_found) {
 		*rval = -ENODEV;
 		return NULL;
 	}
@@ -739,6 +743,7 @@ ioctl_done(uioc_t *kioc)
 	uint32_t	adapno;
 	int		iterator;
 	mraid_mmadp_t*	adapter;
+	bool		is_found;
 
 	/*
 	 * When the kioc returns from driver, make sure it still doesn't
@@ -761,19 +766,23 @@ ioctl_done(uioc_t *kioc)
 		iterator	= 0;
 		adapter		= NULL;
 		adapno		= kioc->adapno;
+		is_found	= false;
 
 		con_log(CL_ANN, ( KERN_WARNING "megaraid cmm: completed "
 					"ioctl that was timedout before\n"));
 
 		list_for_each_entry(adapter, &adapters_list_g, list) {
-			if (iterator++ == adapno) break;
+			if (iterator++ == adapno) {
+				is_found = true;
+				break;
+			}
 		}
 
 		kioc->timedout = 0;
 
-		if (adapter) {
+		if (is_found)
 			mraid_mm_dealloc_kioc( adapter, kioc );
-		}
+
 	}
 	else {
 		wake_up(&wait_q);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 40acc060b655..95ca7039f493 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -462,7 +462,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			if (error != -ENXIO)
+				dev_err(dev, "target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 4b5590f4e98b..93cdeb516594 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -685,10 +685,16 @@ static int log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
 			 (sz + VHOST_PAGE_SIZE * 8 - 1) / VHOST_PAGE_SIZE / 8);
 }
 
+/* Make sure 64 bit math will not overflow. */
 static bool vhost_overflow(u64 uaddr, u64 size)
 {
-	/* Make sure 64 bit math will not overflow. */
-	return uaddr > ULONG_MAX || size > ULONG_MAX || uaddr > ULONG_MAX - size;
+	if (uaddr > ULONG_MAX || size > ULONG_MAX)
+		return true;
+
+	if (!size)
+		return false;
+
+	return uaddr > ULONG_MAX - size + 1;
 }
 
 /* Caller should have vq mutex and device mutex. */
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index a2f8130e18fe..d138027034fd 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -133,12 +133,12 @@ static void disable_dynirq(struct irq_data *data);
 
 static DEFINE_PER_CPU(unsigned int, irq_epoch);
 
-static void clear_evtchn_to_irq_row(unsigned row)
+static void clear_evtchn_to_irq_row(int *evtchn_row)
 {
 	unsigned col;
 
 	for (col = 0; col < EVTCHN_PER_ROW; col++)
-		WRITE_ONCE(evtchn_to_irq[row][col], -1);
+		WRITE_ONCE(evtchn_row[col], -1);
 }
 
 static void clear_evtchn_to_irq_all(void)
@@ -148,7 +148,7 @@ static void clear_evtchn_to_irq_all(void)
 	for (row = 0; row < EVTCHN_ROW(xen_evtchn_max_channels()); row++) {
 		if (evtchn_to_irq[row] == NULL)
 			continue;
-		clear_evtchn_to_irq_row(row);
+		clear_evtchn_to_irq_row(evtchn_to_irq[row]);
 	}
 }
 
@@ -156,6 +156,7 @@ static int set_evtchn_to_irq(unsigned evtchn, unsigned irq)
 {
 	unsigned row;
 	unsigned col;
+	int *evtchn_row;
 
 	if (evtchn >= xen_evtchn_max_channels())
 		return -EINVAL;
@@ -168,11 +169,18 @@ static int set_evtchn_to_irq(unsigned evtchn, unsigned irq)
 		if (irq == -1)
 			return 0;
 
-		evtchn_to_irq[row] = (int *)get_zeroed_page(GFP_KERNEL);
-		if (evtchn_to_irq[row] == NULL)
+		evtchn_row = (int *) __get_free_pages(GFP_KERNEL, 0);
+		if (evtchn_row == NULL)
 			return -ENOMEM;
 
-		clear_evtchn_to_irq_row(row);
+		clear_evtchn_to_irq_row(evtchn_row);
+
+		/*
+		 * We've prepared an empty row for the mapping. If a different
+		 * thread was faster inserting it, we can drop ours.
+		 */
+		if (cmpxchg(&evtchn_to_irq[row], NULL, evtchn_row) != NULL)
+			free_page((unsigned long) evtchn_row);
 	}
 
 	WRITE_ONCE(evtchn_to_irq[row][col], irq);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7ca0fafcd5a6..275a89b8e4b8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9833,8 +9833,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	bool root_log_pinned = false;
 	bool dest_log_pinned = false;
 
-	/* we only allow rename subvolume link between subvolumes */
-	if (old_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
+	/*
+	 * For non-subvolumes allow exchange only within one subvolume, in the
+	 * same inode namespace. Two subvolumes (represented as directory) can
+	 * be exchanged as they're a logical link and have a fixed inode number.
+	 */
+	if (root != dest &&
+	    (old_ino != BTRFS_FIRST_FREE_OBJECTID ||
+	     new_ino != BTRFS_FIRST_FREE_OBJECTID))
 		return -EXDEV;
 
 	/* close the race window with snapshot create/destroy ioctl */
diff --git a/fs/namespace.c b/fs/namespace.c
index 473446ae9e9b..683668a20bed 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1695,13 +1695,22 @@ static inline bool may_mount(void)
 	return ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN);
 }
 
+#ifdef	CONFIG_MANDATORY_FILE_LOCKING
+static bool may_mandlock(void)
+{
+	pr_warn_once("======================================================\n"
+		     "WARNING: the mand mount option is being deprecated and\n"
+		     "         will be removed in v5.15!\n"
+		     "======================================================\n");
+	return capable(CAP_SYS_ADMIN);
+}
+#else
 static inline bool may_mandlock(void)
 {
-#ifndef	CONFIG_MANDATORY_FILE_LOCKING
+	pr_warn("VFS: \"mand\" mount option not supported");
 	return false;
-#endif
-	return capable(CAP_SYS_ADMIN);
 }
+#endif
 
 /*
  * Now umount can handle mount points as well as block devices.
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c9790b2cdf34..45fe7295051f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -465,6 +465,7 @@
 		*(.text.unknown .text.unknown.*)			\
 		*(.text..refcount)					\
 		*(.ref.text)						\
+		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 0b2e67014a83..fab5798a47fd 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -917,6 +917,7 @@ struct device {
 	struct dev_pin_info	*pins;
 #endif
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spinlock_t		msi_lock;
 	struct list_head	msi_list;
 #endif
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index a89cdea8795a..3440ec051ebb 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -144,7 +144,7 @@ void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 
 u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag);
-u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 void pci_msi_mask_irq(struct irq_data *data);
 void pci_msi_unmask_irq(struct irq_data *data);
 
diff --git a/include/net/psample.h b/include/net/psample.h
index 94cb37a7bf75..796f01e5635d 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -18,6 +18,8 @@ struct psample_group {
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
 void psample_group_put(struct psample_group *group);
 
+struct sk_buff;
+
 #if IS_ENABLED(CONFIG_PSAMPLE)
 
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index b21fcc838784..acebcf605bb5 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -1283,7 +1283,7 @@ static int hidp_session_thread(void *arg)
 
 	/* cleanup runtime environment */
 	remove_wait_queue(sk_sleep(session->intr_sock->sk), &intr_wait);
-	remove_wait_queue(sk_sleep(session->intr_sock->sk), &ctrl_wait);
+	remove_wait_queue(sk_sleep(session->ctrl_sock->sk), &ctrl_wait);
 	wake_up_interruptible(&session->report_queue);
 	hidp_del_timer(session);
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 9a36592cf20f..c8bf044ab534 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -519,6 +519,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 
 	err = dev_set_allmulti(dev, 1);
 	if (err) {
+		br_multicast_del_port(p);
 		kfree(p);	/* kobject not yet init'd, manually free */
 		goto err1;
 	}
@@ -623,6 +624,7 @@ err4:
 err3:
 	sysfs_remove_link(br->ifobj, p->dev->name);
 err2:
+	br_multicast_del_port(p);
 	kobject_put(&p->kobj);
 	dev_set_allmulti(dev, -1);
 err1:
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 0c55ffb859bf..121aa71fcb5c 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -44,9 +44,9 @@ extern bool dccp_debug;
 #define dccp_pr_debug_cat(format, a...)   DCCP_PRINTK(dccp_debug, format, ##a)
 #define dccp_debug(fmt, a...)		  dccp_pr_debug_cat(KERN_DEBUG fmt, ##a)
 #else
-#define dccp_pr_debug(format, a...)
-#define dccp_pr_debug_cat(format, a...)
-#define dccp_debug(format, a...)
+#define dccp_pr_debug(format, a...)	  do {} while (0)
+#define dccp_pr_debug_cat(format, a...)	  do {} while (0)
+#define dccp_debug(format, a...)	  do {} while (0)
 #endif
 
 extern struct inet_hashinfo dccp_hashinfo;
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index e95004b507d3..9d46d9462129 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -985,6 +985,11 @@ static const struct proto_ops ieee802154_dgram_ops = {
 #endif
 };
 
+static void ieee802154_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 /* Create a socket. Initialise the socket, blank the addresses
  * set the state.
  */
@@ -1025,7 +1030,7 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 	sock->ops = ops;
 
 	sock_init_data(sock, sk);
-	/* FIXME: sk->sk_destruct */
+	sk->sk_destruct = ieee802154_sock_destruct;
 	sk->sk_family = PF_IEEE802154;
 
 	/* Checksums on by default */
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index bda10f7aea32..76a9652d90f2 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -840,7 +840,7 @@ static void bbr_init(struct sock *sk)
 	bbr->prior_cwnd = 0;
 	bbr->tso_segs_goal = 0;	 /* default segs per skb until first ACK */
 	bbr->rtt_cnt = 0;
-	bbr->next_rtt_delivered = 0;
+	bbr->next_rtt_delivered = tp->delivered;
 	bbr->prev_ca_state = TCP_CA_Open;
 	bbr->packet_conservation = 0;
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index b15412c21ac9..d0fed5ceb2b7 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -80,6 +80,7 @@ static const char * const sta_flag_names[] = {
 	FLAG(MPSP_OWNER),
 	FLAG(MPSP_RECIPIENT),
 	FLAG(PS_DELIVER),
+	FLAG(USES_ENCRYPTION),
 #undef FLAG
 };
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d122031e389a..87ed1210295f 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -335,6 +335,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
+			set_sta_flag(sta, WLAN_STA_USES_ENCRYPTION);
 			sta->ptk_idx = idx;
 			ieee80211_check_fast_xmit(sta);
 		} else {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f1d293f5678f..154c26d473a8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -101,6 +101,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
 	WLAN_STA_PS_DELIVER,
+	WLAN_STA_USES_ENCRYPTION,
 
 	NUM_WLAN_STA_FLAGS,
 };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0ab710576673..c7e8935224c0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -589,10 +589,13 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
 		tx->key = NULL;
-	else if (tx->sta &&
-		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
+		return TX_CONTINUE;
+	}
+
+	if (tx->sta &&
+	    (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
 		tx->key = key;
 	else if (ieee80211_is_group_privacy_action(tx->skb) &&
 		(key = rcu_dereference(tx->sdata->default_multicast_key)))
@@ -653,6 +656,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		if (!skip_hw && tx->key &&
 		    tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 			info->control.hw_key = &tx->key->conf;
+	} else if (!ieee80211_is_mgmt(hdr->frame_control) && tx->sta &&
+		   test_sta_flag(tx->sta, WLAN_STA_USES_ENCRYPTION)) {
+		return TX_DROP;
 	}
 
 	return TX_CONTINUE;
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a301d3bbd3fa..e73a1503e8d7 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -138,7 +138,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	unsigned int i, optl, tcphdr_len, offset;
 	struct tcphdr *tcph;
 	u8 *opt;
-	u32 src;
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
@@ -147,7 +146,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		union {
-			u8 octet;
 			__be16 v16;
 			__be32 v32;
 		} old, new;
@@ -168,13 +166,13 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 		if (!tcph)
 			return;
 
-		src = regs->data[priv->sreg];
 		offset = i + priv->offset;
 
 		switch (priv->len) {
 		case 2:
 			old.v16 = get_unaligned((u16 *)(opt + offset));
-			new.v16 = src;
+			new.v16 = (__force __be16)nft_reg_load16(
+				&regs->data[priv->sreg]);
 
 			switch (priv->type) {
 			case TCPOPT_MSS:
@@ -192,7 +190,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 						 old.v16, new.v16, false);
 			break;
 		case 4:
-			new.v32 = src;
+			new.v32 = regs->data[priv->sreg];
 			old.v32 = get_unaligned((u32 *)(opt + offset));
 
 			if (old.v32 == new.v32)
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index cc70d651d13e..e34979fcefd2 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -373,11 +373,14 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 
 static void virtio_vsock_reset_sock(struct sock *sk)
 {
-	lock_sock(sk);
+	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
+	 * under vsock_table_lock so the sock cannot disappear while we're
+	 * executing.
+	 */
+
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
 	sk->sk_error_report(sk);
-	release_sock(sk);
 }
 
 static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 1833deefe1af..cf406f22f406 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -3468,7 +3468,7 @@ static int cap_put_caller(struct snd_kcontrol *kcontrol,
 	struct hda_gen_spec *spec = codec->spec;
 	const struct hda_input_mux *imux;
 	struct nid_path *path;
-	int i, adc_idx, err = 0;
+	int i, adc_idx, ret, err = 0;
 
 	imux = &spec->input_mux;
 	adc_idx = kcontrol->id.index;
@@ -3478,9 +3478,13 @@ static int cap_put_caller(struct snd_kcontrol *kcontrol,
 		if (!path || !path->ctls[type])
 			continue;
 		kcontrol->private_value = path->ctls[type];
-		err = func(kcontrol, ucontrol);
-		if (err < 0)
+		ret = func(kcontrol, ucontrol);
+		if (ret < 0) {
+			err = ret;
 			break;
+		}
+		if (ret > 0)
+			err = 1;
 	}
 	mutex_unlock(&codec->control_mutex);
 	if (err >= 0 && spec->cap_sync_hook)
diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 39adb2fdd003..e6eeecc5446e 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -404,7 +404,7 @@ static const struct regmap_config cs42l42_regmap = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static DECLARE_TLV_DB_SCALE(adc_tlv, -9600, 100, false);
+static DECLARE_TLV_DB_SCALE(adc_tlv, -9700, 100, true);
 static DECLARE_TLV_DB_SCALE(mixer_tlv, -6300, 100, true);
 
 static const char * const cs42l42_hpf_freq_text[] = {
@@ -424,34 +424,23 @@ static SOC_ENUM_SINGLE_DECL(cs42l42_wnf3_freq_enum, CS42L42_ADC_WNF_HPF_CTL,
 			    CS42L42_ADC_WNF_CF_SHIFT,
 			    cs42l42_wnf3_freq_text);
 
-static const char * const cs42l42_wnf05_freq_text[] = {
-	"280Hz", "315Hz", "350Hz", "385Hz",
-	"420Hz", "455Hz", "490Hz", "525Hz"
-};
-
-static SOC_ENUM_SINGLE_DECL(cs42l42_wnf05_freq_enum, CS42L42_ADC_WNF_HPF_CTL,
-			    CS42L42_ADC_WNF_CF_SHIFT,
-			    cs42l42_wnf05_freq_text);
-
 static const struct snd_kcontrol_new cs42l42_snd_controls[] = {
 	/* ADC Volume and Filter Controls */
 	SOC_SINGLE("ADC Notch Switch", CS42L42_ADC_CTL,
-				CS42L42_ADC_NOTCH_DIS_SHIFT, true, false),
+				CS42L42_ADC_NOTCH_DIS_SHIFT, true, true),
 	SOC_SINGLE("ADC Weak Force Switch", CS42L42_ADC_CTL,
 				CS42L42_ADC_FORCE_WEAK_VCM_SHIFT, true, false),
 	SOC_SINGLE("ADC Invert Switch", CS42L42_ADC_CTL,
 				CS42L42_ADC_INV_SHIFT, true, false),
 	SOC_SINGLE("ADC Boost Switch", CS42L42_ADC_CTL,
 				CS42L42_ADC_DIG_BOOST_SHIFT, true, false),
-	SOC_SINGLE_SX_TLV("ADC Volume", CS42L42_ADC_VOLUME,
-				CS42L42_ADC_VOL_SHIFT, 0xA0, 0x6C, adc_tlv),
+	SOC_SINGLE_S8_TLV("ADC Volume", CS42L42_ADC_VOLUME, -97, 12, adc_tlv),
 	SOC_SINGLE("ADC WNF Switch", CS42L42_ADC_WNF_HPF_CTL,
 				CS42L42_ADC_WNF_EN_SHIFT, true, false),
 	SOC_SINGLE("ADC HPF Switch", CS42L42_ADC_WNF_HPF_CTL,
 				CS42L42_ADC_HPF_EN_SHIFT, true, false),
 	SOC_ENUM("HPF Corner Freq", cs42l42_hpf_freq_enum),
 	SOC_ENUM("WNF 3dB Freq", cs42l42_wnf3_freq_enum),
-	SOC_ENUM("WNF 05dB Freq", cs42l42_wnf05_freq_enum),
 
 	/* DAC Volume and Filter Controls */
 	SOC_SINGLE("DACA Invert Switch", CS42L42_DAC_CTL1,
@@ -794,7 +783,6 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-	case SND_SOC_DAIFMT_LEFT_J:
 		break;
 	default:
 		return -EINVAL;
diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index cdc0f22a57ee..96f7facd0fa0 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -135,7 +135,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = virt_to_phys(substream->dma_buffer.area);
+	u32 buffer_addr = virt_to_phys(substream->runtime->dma_area);
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
@@ -241,7 +241,6 @@ static int sst_platform_alloc_stream(struct snd_pcm_substream *substream,
 	/* set codec params and inform SST driver the same */
 	sst_fill_pcm_params(substream, &param);
 	sst_fill_alloc_params(substream, &alloc_params);
-	substream->runtime->dma_area = substream->dma_buffer.area;
 	str_params.sparams = param;
 	str_params.aparams = alloc_params;
 	str_params.codec = SST_CODEC_TYPE_PCM;
