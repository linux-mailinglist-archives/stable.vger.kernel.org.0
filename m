Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6FC64CD56
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbiLNPtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbiLNPsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:48:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A3A24F06;
        Wed, 14 Dec 2022 07:47:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 313B6B815FC;
        Wed, 14 Dec 2022 15:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ED1C433D2;
        Wed, 14 Dec 2022 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032872;
        bh=EK1Iazb0KIzvJrndYghg6avYWvod74BZ7sx85MpszOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2KmX6F0fMDFsQoVd54On/AWk4ndgaE/cOCECj+nCXRD6LMpTg1yiWJslUBeIP5Ss
         nFJdS10ivUbkiIn8KbVxeJ88aepKaSth8nyat7CLycUnmleELc/ovVada0d7oSR1DR
         go7cnyPMH4mb3S9y4p1fVym8lHP/Gu47m8cbE0Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.83
Date:   Wed, 14 Dec 2022 16:47:14 +0100
Message-Id: <167103283316736@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <16710328334016@kroah.com>
References: <16710328334016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index edc32575828b..1cf05aee91af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7244,9 +7244,6 @@ F:	include/linux/fs.h
 F:	include/linux/fs_types.h
 F:	include/uapi/linux/fs.h
 F:	include/uapi/linux/openat2.h
-X:	fs/io-wq.c
-X:	fs/io-wq.h
-X:	fs/io_uring.c
 
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 M:	Riku Voipio <riku.voipio@iki.fi>
@@ -9818,9 +9815,7 @@ L:	io-uring@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.dk/linux-block
 T:	git git://git.kernel.dk/liburing
-F:	fs/io-wq.c
-F:	fs/io-wq.h
-F:	fs/io_uring.c
+F:	io_uring/
 F:	include/linux/io_uring.h
 F:	include/uapi/linux/io_uring.h
 F:	tools/io_uring/
diff --git a/Makefile b/Makefile
index bc1cf1200b62..7825a96e9c36 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 82
+SUBLEVEL = 83
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -1150,7 +1150,9 @@ export MODORDER := $(extmod_prefix)modules.order
 export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y			+= kernel/ certs/ mm/ fs/ ipc/ security/ crypto/
+core-$(CONFIG_BLOCK)	+= block/
+core-$(CONFIG_IO_URING)	+= io_uring/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index c8206c636a01..95f22513a7c0 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1252,10 +1252,10 @@ dma_apbh: dma-apbh@33000000 {
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000 {
+		gpmi: nand-controller@33002000{
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <0>;
+			#size-cells = <1>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index 2a7e6624efb9..94216f870b57 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -31,11 +31,10 @@ phy0: ethernet-phy@0 {
 &i2c1 {
 	status = "okay";
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 	};
 };
diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 36c0945f43b2..3718fac62841 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -71,7 +71,7 @@ spdif_out: spdif-out {
 		#sound-dai-cells = <0>;
 	};
 
-	ir_recv: gpio-ir-receiver {
+	ir_recv: ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 2c606494b78c..e07b1d79c470 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -378,7 +378,7 @@ lcdc1_vsync: lcdc1-vsync {
 				rockchip,pins = <2 RK_PD3 1 &pcfg_pull_none>;
 			};
 
-			lcdc1_rgb24: ldcd1-rgb24 {
+			lcdc1_rgb24: lcdc1-rgb24 {
 				rockchip,pins = <2 RK_PA0 1 &pcfg_pull_none>,
 						<2 RK_PA1 1 &pcfg_pull_none>,
 						<2 RK_PA2 1 &pcfg_pull_none>,
@@ -606,7 +606,6 @@ &emac {
 
 &global_timer {
 	interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
-	status = "disabled";
 };
 
 &local_timer {
diff --git a/arch/arm/boot/dts/rk3288-evb-act8846.dts b/arch/arm/boot/dts/rk3288-evb-act8846.dts
index be695b8c1f67..8a635c243127 100644
--- a/arch/arm/boot/dts/rk3288-evb-act8846.dts
+++ b/arch/arm/boot/dts/rk3288-evb-act8846.dts
@@ -54,7 +54,7 @@ vdd_gpu: syr828@41 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563@51 {
+	rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 
diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi b/arch/arm/boot/dts/rk3288-firefly.dtsi
index 7fb582302b32..74ba7e21850a 100644
--- a/arch/arm/boot/dts/rk3288-firefly.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
@@ -233,11 +233,10 @@ vdd_gpu: syr828@41 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 		interrupt-parent = <&gpio7>;
 		interrupts = <RK_PA4 IRQ_TYPE_EDGE_FALLING>;
diff --git a/arch/arm/boot/dts/rk3288-miqi.dts b/arch/arm/boot/dts/rk3288-miqi.dts
index 713f55e143c6..db1eb648e0e1 100644
--- a/arch/arm/boot/dts/rk3288-miqi.dts
+++ b/arch/arm/boot/dts/rk3288-miqi.dts
@@ -162,11 +162,10 @@ vdd_gpu: syr828@41 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 	};
 
diff --git a/arch/arm/boot/dts/rk3288-rock2-square.dts b/arch/arm/boot/dts/rk3288-rock2-square.dts
index c4d1d142d8c6..bc44606ca05d 100644
--- a/arch/arm/boot/dts/rk3288-rock2-square.dts
+++ b/arch/arm/boot/dts/rk3288-rock2-square.dts
@@ -165,11 +165,10 @@ &hdmi {
 };
 
 &i2c0 {
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 		interrupt-parent = <&gpio0>;
 		interrupts = <RK_PA4 IRQ_TYPE_EDGE_FALLING>;
diff --git a/arch/arm/boot/dts/rk3288-vmarc-som.dtsi b/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
index 0ae2bd150e37..793951655b73 100644
--- a/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
+++ b/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
@@ -241,7 +241,6 @@ hym8563: rtc@51 {
 		interrupt-parent = <&gpio5>;
 		interrupts = <RK_PC3 IRQ_TYPE_LEVEL_LOW>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "hym8563";
 		pinctrl-names = "default";
 		pinctrl-0 = <&hym8563_int>;
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 616a828e0c6e..17e89d30de78 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -76,6 +76,13 @@ global_timer: global-timer@1013c200 {
 		reg = <0x1013c200 0x20>;
 		interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 		clocks = <&cru CORE_PERI>;
+		status = "disabled";
+		/* The clock source and the sched_clock provided by the arm_global_timer
+		 * on Rockchip rk3066a/rk3188 are quite unstable because their rates
+		 * depend on the CPU frequency.
+		 * Keep the arm_global_timer disabled in order to have the
+		 * DW_APB_TIMER (rk3066a) or ROCKCHIP_TIMER (rk3188) selected by default.
+		 */
 	};
 
 	local_timer: local-timer@1013c600 {
diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index fe87397c3d8c..bdbc1e590891 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -17,7 +17,7 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
-	(regs)->ARM_fp = (unsigned long) __builtin_frame_address(0); \
+	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
 	(regs)->ARM_sp = current_stack_pointer; \
 	(regs)->ARM_cpsr = SVC_MODE; \
 }
diff --git a/arch/arm/include/asm/pgtable-nommu.h b/arch/arm/include/asm/pgtable-nommu.h
index d16aba48fa0a..090011394477 100644
--- a/arch/arm/include/asm/pgtable-nommu.h
+++ b/arch/arm/include/asm/pgtable-nommu.h
@@ -44,12 +44,6 @@
 
 typedef pte_t *pte_addr_t;
 
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-#define ZERO_PAGE(vaddr)	(virt_to_page(0))
-
 /*
  * Mark the prot value as uncacheable and unbufferable.
  */
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index cd1f84bb40ae..a25c4303fc0e 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -10,6 +10,15 @@
 #include <linux/const.h>
 #include <asm/proc-fns.h>
 
+#ifndef __ASSEMBLY__
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern struct page *empty_zero_page;
+#define ZERO_PAGE(vaddr)	(empty_zero_page)
+#endif
+
 #ifndef CONFIG_MMU
 
 #include <asm-generic/pgtable-nopud.h>
@@ -156,13 +165,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 #define __S111  __PAGE_SHARED_EXEC
 
 #ifndef __ASSEMBLY__
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-extern struct page *empty_zero_page;
-#define ZERO_PAGE(vaddr)	(empty_zero_page)
-
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index 2658f52903da..88feffebae21 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -26,6 +26,13 @@
 
 unsigned long vectors_base;
 
+/*
+ * empty_zero_page is a special page that is used for
+ * zero-initialized data and COW.
+ */
+struct page *empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
+
 #ifdef CONFIG_ARM_MPU
 struct mpu_rgn_info mpu_rgn_info;
 #endif
@@ -148,9 +155,21 @@ void __init adjust_lowmem_bounds(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
+	void *zero_page;
+
 	early_trap_init((void *)vectors_base);
 	mpu_setup();
+
+	/* allocate the zero page. */
+	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	if (!zero_page)
+		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
+		      __func__, PAGE_SIZE, PAGE_SIZE);
+
 	bootmem_init();
+
+	empty_zero_page = virt_to_page(zero_page);
+	flush_dcache_page(empty_zero_page);
 }
 
 /*
diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index ea6820902ede..7ea48167747c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -19,7 +19,7 @@ chosen {
 		stdout-path = "serial2:1500000n8";
 	};
 
-	ir_rx {
+	ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PC0 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 100a769165ef..a7ec81657503 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -446,7 +446,6 @@ &i2s0 {
 &i2s1 {
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
-	status = "okay";
 };
 
 &i2s2 {
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index acda4b6fc851..2c0704f5eb3c 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -538,8 +538,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
 		scb_s->eca |= scb_o->eca & ECA_CEI;
 	/* Epoch Extension */
-	if (test_kvm_facility(vcpu->kvm, 139))
+	if (test_kvm_facility(vcpu->kvm, 139)) {
 		scb_s->ecd |= scb_o->ecd & ECD_MEF;
+		scb_s->epdx = scb_o->epdx;
+	}
 
 	/* etoken */
 	if (test_kvm_facility(vcpu->kvm, 156))
diff --git a/block/Makefile b/block/Makefile
index 41aa1ba69c90..74df168729ec 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the kernel block layer
 #
 
-obj-$(CONFIG_BLOCK) := bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
+obj-y		:= bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-flush.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-timeout.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 64d72ea0c310..69380cb03dd3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1901,6 +1901,11 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 
 	rp = (struct hci_rp_read_local_version *)skb->data;
 
+	bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x; LMP ver=%u subver=%04x; manufacturer=%u",
+		le16_to_cpu(rp->hci_ver), le16_to_cpu(rp->hci_rev),
+		le16_to_cpu(rp->lmp_ver), le16_to_cpu(rp->lmp_subver),
+		le16_to_cpu(rp->manufacturer));
+
 	/* Detect a wide host of Chinese controllers that aren't CSR.
 	 *
 	 * Known fake bcdDevices: 0x0100, 0x0134, 0x1915, 0x2520, 0x7558, 0x8891
diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index f9d5b7334341..4fb4fd4b06bd 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -4,42 +4,101 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 
+struct devm_clk_state {
+	struct clk *clk;
+	void (*exit)(struct clk *clk);
+};
+
 static void devm_clk_release(struct device *dev, void *res)
 {
-	clk_put(*(struct clk **)res);
+	struct devm_clk_state *state = res;
+
+	if (state->exit)
+		state->exit(state->clk);
+
+	clk_put(state->clk);
 }
 
-struct clk *devm_clk_get(struct device *dev, const char *id)
+static struct clk *__devm_clk_get(struct device *dev, const char *id,
+				  struct clk *(*get)(struct device *dev, const char *id),
+				  int (*init)(struct clk *clk),
+				  void (*exit)(struct clk *clk))
 {
-	struct clk **ptr, *clk;
+	struct devm_clk_state *state;
+	struct clk *clk;
+	int ret;
 
-	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
+	state = devres_alloc(devm_clk_release, sizeof(*state), GFP_KERNEL);
+	if (!state)
 		return ERR_PTR(-ENOMEM);
 
-	clk = clk_get(dev, id);
-	if (!IS_ERR(clk)) {
-		*ptr = clk;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
+	clk = get(dev, id);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto err_clk_get;
 	}
 
+	if (init) {
+		ret = init(clk);
+		if (ret)
+			goto err_clk_init;
+	}
+
+	state->clk = clk;
+	state->exit = exit;
+
+	devres_add(dev, state);
+
 	return clk;
+
+err_clk_init:
+
+	clk_put(clk);
+err_clk_get:
+
+	devres_free(state);
+	return ERR_PTR(ret);
+}
+
+struct clk *devm_clk_get(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get, NULL, NULL);
 }
 EXPORT_SYMBOL(devm_clk_get);
 
-struct clk *devm_clk_get_optional(struct device *dev, const char *id)
+struct clk *devm_clk_get_prepared(struct device *dev, const char *id)
 {
-	struct clk *clk = devm_clk_get(dev, id);
+	return __devm_clk_get(dev, id, clk_get, clk_prepare, clk_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_prepared);
 
-	if (clk == ERR_PTR(-ENOENT))
-		return NULL;
+struct clk *devm_clk_get_enabled(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get,
+			      clk_prepare_enable, clk_disable_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_enabled);
 
-	return clk;
+struct clk *devm_clk_get_optional(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get_optional, NULL, NULL);
 }
 EXPORT_SYMBOL(devm_clk_get_optional);
 
+struct clk *devm_clk_get_optional_prepared(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get_optional,
+			      clk_prepare, clk_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_optional_prepared);
+
+struct clk *devm_clk_get_optional_enabled(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get_optional,
+			      clk_prepare_enable, clk_disable_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_optional_enabled);
+
 struct clk_bulk_devres {
 	struct clk_bulk_data *clks;
 	int num_clks;
diff --git a/drivers/gpio/gpio-amd8111.c b/drivers/gpio/gpio-amd8111.c
index 14e6b3e64add..6f3ded619c8b 100644
--- a/drivers/gpio/gpio-amd8111.c
+++ b/drivers/gpio/gpio-amd8111.c
@@ -226,7 +226,10 @@ static int __init amd_gpio_init(void)
 		ioport_unmap(gp.pm);
 		goto out;
 	}
+	return 0;
+
 out:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -234,6 +237,7 @@ static void __exit amd_gpio_exit(void)
 {
 	gpiochip_remove(&gp.chip);
 	ioport_unmap(gp.pm);
+	pci_dev_put(gp.pdev);
 }
 
 module_init(amd_gpio_init);
diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index d32928c1efe0..a197f698efeb 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -605,6 +605,7 @@ static int rockchip_gpiolib_register(struct rockchip_pin_bank *bank)
 			return -ENODATA;
 
 		pctldev = of_pinctrl_get(pctlnp);
+		of_node_put(pctlnp);
 		if (!pctldev)
 			return -ENODEV;
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 320baed949ee..67bc96403a4e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -525,12 +525,13 @@ static int gpiochip_setup_dev(struct gpio_device *gdev)
 	if (ret)
 		return ret;
 
+	/* From this point, the .release() function cleans up gpio_device */
+	gdev->dev.release = gpiodevice_release;
+
 	ret = gpiochip_sysfs_register(gdev);
 	if (ret)
 		goto err_remove_device;
 
-	/* From this point, the .release() function cleans up gpio_device */
-	gdev->dev.release = gpiodevice_release;
 	dev_dbg(&gdev->dev, "registered GPIOs %d to %d on %s\n", gdev->base,
 		gdev->base + gdev->ngpio - 1, gdev->chip->label ? : "generic");
 
@@ -594,11 +595,12 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 			       struct lock_class_key *request_key)
 {
 	struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
-	unsigned long	flags;
-	int		ret = 0;
-	unsigned	i;
-	int		base = gc->base;
 	struct gpio_device *gdev;
+	unsigned long flags;
+	unsigned int i;
+	u32 ngpios = 0;
+	int base = 0;
+	int ret = 0;
 
 	/*
 	 * First: allocate and populate the internal stat container, and
@@ -640,22 +642,43 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	else
 		gdev->owner = THIS_MODULE;
 
-	gdev->descs = kcalloc(gc->ngpio, sizeof(gdev->descs[0]), GFP_KERNEL);
-	if (!gdev->descs) {
-		ret = -ENOMEM;
-		goto err_free_dev_name;
+	/*
+	 * Try the device properties if the driver didn't supply the number
+	 * of GPIO lines.
+	 */
+	ngpios = gc->ngpio;
+	if (ngpios == 0) {
+		ret = device_property_read_u32(&gdev->dev, "ngpios", &ngpios);
+		if (ret == -ENODATA)
+			/*
+			 * -ENODATA means that there is no property found and
+			 * we want to issue the error message to the user.
+			 * Besides that, we want to return different error code
+			 * to state that supplied value is not valid.
+			 */
+			ngpios = 0;
+		else if (ret)
+			goto err_free_dev_name;
+
+		gc->ngpio = ngpios;
 	}
 
 	if (gc->ngpio == 0) {
 		chip_err(gc, "tried to insert a GPIO chip with zero lines\n");
 		ret = -EINVAL;
-		goto err_free_descs;
+		goto err_free_dev_name;
 	}
 
 	if (gc->ngpio > FASTPATH_NGPIO)
 		chip_warn(gc, "line cnt %u is greater than fast path cnt %u\n",
 			  gc->ngpio, FASTPATH_NGPIO);
 
+	gdev->descs = kcalloc(gc->ngpio, sizeof(*gdev->descs), GFP_KERNEL);
+	if (!gdev->descs) {
+		ret = -ENOMEM;
+		goto err_free_dev_name;
+	}
+
 	gdev->label = kstrdup_const(gc->label ?: "unknown", GFP_KERNEL);
 	if (!gdev->label) {
 		ret = -ENOMEM;
@@ -674,11 +697,13 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	 * it may be a pipe dream. It will not happen before we get rid
 	 * of the sysfs interface anyways.
 	 */
+	base = gc->base;
 	if (base < 0) {
 		base = gpiochip_find_base(gc->ngpio);
 		if (base < 0) {
-			ret = base;
 			spin_unlock_irqrestore(&gpio_lock, flags);
+			ret = base;
+			base = 0;
 			goto err_free_label;
 		}
 		/*
@@ -786,6 +811,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 err_free_gpiochip_mask:
 	gpiochip_remove_pin_ranges(gc);
 	gpiochip_free_valid_mask(gc);
+	if (gdev->dev.release) {
+		/* release() has been registered by gpiochip_setup_dev() */
+		put_device(&gdev->dev);
+		goto err_print_message;
+	}
 err_remove_from_list:
 	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
@@ -799,13 +829,14 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 err_free_ida:
 	ida_free(&gpio_ida, gdev->id);
 err_free_gdev:
+	kfree(gdev);
+err_print_message:
 	/* failures here can mean systems won't boot... */
 	if (ret != -EPROBE_DEFER) {
 		pr_err("%s: GPIOs %d..%d (%s) failed to register, %d\n", __func__,
-		       gdev->base, gdev->base + gdev->ngpio - 1,
+		       base, base + (int)ngpios - 1,
 		       gc->label ? : "generic", ret);
 	}
-	kfree(gdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add_data_with_key);
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 9014f71d52dd..f14f7bb3cf0c 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -978,13 +978,13 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
 
 
 /**
- * sdma_v4_0_gfx_stop - stop the gfx async dma engines
+ * sdma_v4_0_gfx_enable - enable the gfx async dma engines
  *
  * @adev: amdgpu_device pointer
- *
- * Stop the gfx async dma ring buffers (VEGA10).
+ * @enable: enable SDMA RB/IB
+ * control the gfx async dma ring buffers (VEGA10).
  */
-static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
+static void sdma_v4_0_gfx_enable(struct amdgpu_device *adev, bool enable)
 {
 	struct amdgpu_ring *sdma[AMDGPU_MAX_SDMA_INSTANCES];
 	u32 rb_cntl, ib_cntl;
@@ -999,10 +999,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
 		}
 
 		rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
-		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
+		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
 		ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
-		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
+		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
 	}
 }
@@ -1129,7 +1129,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
 	int i;
 
 	if (!enable) {
-		sdma_v4_0_gfx_stop(adev);
+		sdma_v4_0_gfx_enable(adev, enable);
 		sdma_v4_0_rlc_stop(adev);
 		if (adev->sdma.has_page_queue)
 			sdma_v4_0_page_stop(adev);
@@ -2063,8 +2063,10 @@ static int sdma_v4_0_suspend(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU saves SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_gfx_enable(adev, false);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_fini(adev);
 }
@@ -2074,8 +2076,12 @@ static int sdma_v4_0_resume(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU restores SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_enable(adev, true);
+		sdma_v4_0_gfx_enable(adev, true);
+		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_init(adev);
 }
diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 392a9c56e9a0..f895ef1939fa 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -796,7 +796,7 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
 	int count, blocks_num;
 	u8 pblock_buf[MAX_DPCD_BUFFER_SIZE];
 	u8 i, j;
-	u8 g_edid_break = 0;
+	int g_edid_break = 0;
 	int ret;
 	struct device *dev = &ctx->client->dev;
 
@@ -827,7 +827,7 @@ static int sp_tx_edid_read(struct anx7625_data *ctx,
 				g_edid_break = edid_read(ctx, offset,
 							 pblock_buf);
 
-				if (g_edid_break)
+				if (g_edid_break < 0)
 					break;
 
 				memcpy(&pedid_blocks_buf[offset],
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index d3129a3e6ab7..8bb403bc712a 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -2594,6 +2594,9 @@ static u32 *dw_hdmi_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
 	 * if supported. In any case the default RGB888 format is added
 	 */
 
+	/* Default 8bit RGB fallback */
+	output_fmts[i++] = MEDIA_BUS_FMT_RGB888_1X24;
+
 	if (max_bpc >= 16 && info->bpc == 16) {
 		if (info->color_formats & DRM_COLOR_FORMAT_YCRCB444)
 			output_fmts[i++] = MEDIA_BUS_FMT_YUV16_1X48;
@@ -2627,9 +2630,6 @@ static u32 *dw_hdmi_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
 	if (info->color_formats & DRM_COLOR_FORMAT_YCRCB444)
 		output_fmts[i++] = MEDIA_BUS_FMT_YUV8_1X24;
 
-	/* Default 8bit RGB fallback */
-	output_fmts[i++] = MEDIA_BUS_FMT_RGB888_1X24;
-
 	*num_output_fmts = i;
 
 	return output_fmts;
diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 45a5f1e48f0e..bbedce0eedda 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -920,9 +920,9 @@ static void ti_sn_bridge_set_video_timings(struct ti_sn65dsi86 *pdata)
 		&pdata->bridge.encoder->crtc->state->adjusted_mode;
 	u8 hsync_polarity = 0, vsync_polarity = 0;
 
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
 		hsync_polarity = CHA_HSYNC_POLARITY;
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
 		vsync_polarity = CHA_VSYNC_POLARITY;
 
 	ti_sn65dsi86_write_u16(pdata, SN_CHA_ACTIVE_LINE_LENGTH_LOW_REG,
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index a30ffc07470c..15c3849e995b 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -541,12 +541,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	int ret;
 
 	WARN_ON(shmem->base.import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
-	WARN_ON_ONCE(ret != 0);
+	mutex_lock(&shmem->pages_lock);
+
+	/*
+	 * We should have already pinned the pages when the buffer was first
+	 * mmap'd, vm_open() just grabs an additional reference for the new
+	 * mm the vma is getting copied into (ie. on fork()).
+	 */
+	if (!WARN_ON_ONCE(!shmem->pages_use_count))
+		shmem->pages_use_count++;
+
+	mutex_unlock(&shmem->pages_lock);
 
 	drm_gem_vm_open(vma);
 }
@@ -591,10 +599,8 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 	}
 
 	ret = drm_gem_shmem_get_pages(shmem);
-	if (ret) {
-		drm_gem_vm_close(vma);
+	if (ret)
 		return ret;
-	}
 
 	vma->vm_flags |= VM_MIXEDMAP | VM_DONTEXPAND;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 47eb3a50dd08..8d2437fa6894 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -1085,21 +1085,21 @@ int vmw_mksstat_add_ioctl(struct drm_device *dev, void *data,
 	reset_ppn_array(pdesc->strsPPNs, ARRAY_SIZE(pdesc->strsPPNs));
 
 	/* Pin mksGuestStat user pages and store those in the instance descriptor */
-	nr_pinned_stat = pin_user_pages(arg->stat, num_pages_stat, FOLL_LONGTERM, pages_stat, NULL);
+	nr_pinned_stat = pin_user_pages_fast(arg->stat, num_pages_stat, FOLL_LONGTERM, pages_stat);
 	if (num_pages_stat != nr_pinned_stat)
 		goto err_pin_stat;
 
 	for (i = 0; i < num_pages_stat; ++i)
 		pdesc->statPPNs[i] = page_to_pfn(pages_stat[i]);
 
-	nr_pinned_info = pin_user_pages(arg->info, num_pages_info, FOLL_LONGTERM, pages_info, NULL);
+	nr_pinned_info = pin_user_pages_fast(arg->info, num_pages_info, FOLL_LONGTERM, pages_info);
 	if (num_pages_info != nr_pinned_info)
 		goto err_pin_info;
 
 	for (i = 0; i < num_pages_info; ++i)
 		pdesc->infoPPNs[i] = page_to_pfn(pages_info[i]);
 
-	nr_pinned_strs = pin_user_pages(arg->strs, num_pages_strs, FOLL_LONGTERM, pages_strs, NULL);
+	nr_pinned_strs = pin_user_pages_fast(arg->strs, num_pages_strs, FOLL_LONGTERM, pages_strs);
 	if (num_pages_strs != nr_pinned_strs)
 		goto err_pin_strs;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c b/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
index bd157fb21b45..605ff05d449f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
@@ -953,6 +953,10 @@ int vmw_kms_sou_init_display(struct vmw_private *dev_priv)
 	struct drm_device *dev = &dev_priv->drm;
 	int i, ret;
 
+	/* Screen objects won't work if GMR's aren't available */
+	if (!dev_priv->has_gmr)
+		return -ENOSYS;
+
 	if (!(dev_priv->capabilities & SVGA_CAP_SCREEN_OBJECT_2)) {
 		return -ENOSYS;
 	}
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index dbed2524fd47..ef9c799fa371 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1310,6 +1310,9 @@ static s32 snto32(__u32 value, unsigned n)
 	if (!value || !n)
 		return 0;
 
+	if (n > 32)
+		n = 32;
+
 	switch (n) {
 	case 8:  return ((__s8)value);
 	case 16: return ((__s16)value);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c8a313c84a57..78b55f845d2d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -261,6 +261,7 @@
 #define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
+#define USB_DEVICE_ID_CHERRY_MOUSE_000C	0x000c
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 #define USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR	0x0027
 
@@ -892,6 +893,7 @@
 #define USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER	0x02fd
 #define USB_DEVICE_ID_MS_PIXART_MOUSE    0x00cb
 #define USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS      0x02e0
+#define USB_DEVICE_ID_MS_MOUSE_0783      0x0783
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
@@ -1182,6 +1184,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K15A	0x6e21
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
+#define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017	0x73f6
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
@@ -1338,6 +1341,7 @@
 
 #define USB_VENDOR_ID_PRIMAX	0x0461
 #define USB_DEVICE_ID_PRIMAX_MOUSE_4D22	0x4d22
+#define USB_DEVICE_ID_PRIMAX_MOUSE_4E2A	0x4e2a
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 #define USB_DEVICE_ID_PRIMAX_REZEL	0x4e72
 #define USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F	0x4d0f
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 430fa4f52ed3..75ebfcf31889 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -121,6 +121,11 @@ static const struct hid_device_id ite_devices[] = {
 		     USB_VENDOR_ID_SYNAPTICS,
 		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003),
 	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 5e6a0cef2a06..e3fcf1353fb3 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -872,6 +872,12 @@ static ssize_t lg4ff_alternate_modes_store(struct device *dev, struct device_att
 		return -ENOMEM;
 
 	i = strlen(lbuf);
+
+	if (i == 0) {
+		kfree(lbuf);
+		return -EINVAL;
+	}
+
 	if (lbuf[i-1] == '\n') {
 		if (i == 1) {
 			kfree(lbuf);
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 8d36cb7551cf..fc1e061900bc 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -54,6 +54,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_MOUSE_000C), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB_RAPIDFIRE), HID_QUIRK_NO_INIT_REPORTS | HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K70RGB), HID_QUIRK_NO_INIT_REPORTS },
@@ -122,6 +123,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C05A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C06A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCS, USB_DEVICE_ID_MCS_GAMEPADBLOCK), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_MOUSE_0783), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PIXART_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_POWER_COVER), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_SURFACE3_COVER), HID_QUIRK_NO_INIT_REPORTS },
@@ -146,6 +148,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_MOUSE_4D22), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_MOUSE_4E2A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D65), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4E22), HID_QUIRK_ALWAYS_POLL },
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 033b0c83272f..30c8497f7c11 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -788,7 +788,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	num_buffers = max_t(unsigned int, *count, q->min_buffers_needed);
 	num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
 	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
+	/*
+	 * Set this now to ensure that drivers see the correct q->memory value
+	 * in the queue_setup op.
+	 */
+	mutex_lock(&q->mmap_lock);
 	q->memory = memory;
+	mutex_unlock(&q->mmap_lock);
 
 	/*
 	 * Ask the driver how many buffers and planes per buffer it requires.
@@ -797,22 +803,27 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
 		       plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* Check that driver has set sane values */
-	if (WARN_ON(!num_planes))
-		return -EINVAL;
+	if (WARN_ON(!num_planes)) {
+		ret = -EINVAL;
+		goto error;
+	}
 
 	for (i = 0; i < num_planes; i++)
-		if (WARN_ON(!plane_sizes[i]))
-			return -EINVAL;
+		if (WARN_ON(!plane_sizes[i])) {
+			ret = -EINVAL;
+			goto error;
+		}
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers =
 		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(q, 1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	/*
@@ -853,7 +864,8 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * from q->num_buffers and it will reset q->memory to
+		 * VB2_MEMORY_UNKNOWN.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
@@ -869,6 +881,12 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	q->waiting_for_buffers = !q->is_output;
 
 	return 0;
+
+error:
+	mutex_lock(&q->mmap_lock);
+	q->memory = VB2_MEMORY_UNKNOWN;
+	mutex_unlock(&q->mmap_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
@@ -879,6 +897,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	unsigned plane_sizes[VB2_MAX_PLANES] = { };
+	bool no_previous_buffers = !q->num_buffers;
 	int ret;
 
 	if (q->num_buffers == VB2_MAX_FRAME) {
@@ -886,13 +905,19 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -ENOBUFS;
 	}
 
-	if (!q->num_buffers) {
+	if (no_previous_buffers) {
 		if (q->waiting_in_dqbuf && *count) {
 			dprintk(q, 1, "another dup()ped fd is waiting for a buffer\n");
 			return -EBUSY;
 		}
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
+		/*
+		 * Set this now to ensure that drivers see the correct q->memory
+		 * value in the queue_setup op.
+		 */
+		mutex_lock(&q->mmap_lock);
 		q->memory = memory;
+		mutex_unlock(&q->mmap_lock);
 		q->waiting_for_buffers = !q->is_output;
 	} else {
 		if (q->memory != memory) {
@@ -915,14 +940,15 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers,
 		       &num_planes, plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
 				num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(q, 1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	/*
@@ -953,7 +979,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * from q->num_buffers and it will reset q->memory to
+		 * VB2_MEMORY_UNKNOWN.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
@@ -968,6 +995,14 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	*count = allocated_buffers;
 
 	return 0;
+
+error:
+	if (no_previous_buffers) {
+		mutex_lock(&q->mmap_lock);
+		q->memory = VB2_MEMORY_UNKNOWN;
+		mutex_unlock(&q->mmap_lock);
+	}
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
@@ -2124,6 +2159,22 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	struct vb2_buffer *vb;
 	unsigned int buffer, plane;
 
+	/*
+	 * Sanity checks to ensure the lock is held, MEMORY_MMAP is
+	 * used and fileio isn't active.
+	 */
+	lockdep_assert_held(&q->mmap_lock);
+
+	if (q->memory != VB2_MEMORY_MMAP) {
+		dprintk(q, 1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	if (vb2_fileio_is_active(q)) {
+		dprintk(q, 1, "file io in progress\n");
+		return -EBUSY;
+	}
+
 	/*
 	 * Go over all buffers and their planes, comparing the given offset
 	 * with an offset assigned to each plane. If a match is found,
@@ -2225,11 +2276,6 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	int ret;
 	unsigned long length;
 
-	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(q, 1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Check memory area access mode.
 	 */
@@ -2251,14 +2297,9 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 
 	mutex_lock(&q->mmap_lock);
 
-	if (vb2_fileio_is_active(q)) {
-		dprintk(q, 1, "mmap: file io in progress\n");
-		ret = -EBUSY;
-		goto unlock;
-	}
-
 	/*
-	 * Find the plane corresponding to the offset passed by userspace.
+	 * Find the plane corresponding to the offset passed by userspace. This
+	 * will return an error if not MEMORY_MMAP or file I/O is in progress.
 	 */
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
 	if (ret)
@@ -2311,22 +2352,25 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	void *vaddr;
 	int ret;
 
-	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(q, 1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
+	mutex_lock(&q->mmap_lock);
 
 	/*
-	 * Find the plane corresponding to the offset passed by userspace.
+	 * Find the plane corresponding to the offset passed by userspace. This
+	 * will return an error if not MEMORY_MMAP or file I/O is in progress.
 	 */
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	vb = q->bufs[buffer];
 
 	vaddr = vb2_plane_vaddr(vb, plane);
+	mutex_unlock(&q->mmap_lock);
 	return vaddr ? (unsigned long)vaddr : -EINVAL;
+
+unlock:
+	mutex_unlock(&q->mmap_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 003c32fed3f7..942d0005c55e 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -145,6 +145,8 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	const struct v4l2_bt_timings *bt = &t->bt;
 	const struct v4l2_bt_timings_cap *cap = &dvcap->bt;
 	u32 caps = cap->capabilities;
+	const u32 max_vert = 10240;
+	u32 max_hor = 3 * bt->width;
 
 	if (t->type != V4L2_DV_BT_656_1120)
 		return false;
@@ -166,14 +168,20 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	if (!bt->interlaced &&
 	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
 		return false;
-	if (bt->hfrontporch > 2 * bt->width ||
-	    bt->hsync > 1024 || bt->hbackporch > 1024)
+	/*
+	 * Some video receivers cannot properly separate the frontporch,
+	 * backporch and sync values, and instead they only have the total
+	 * blanking. That can be assigned to any of these three fields.
+	 * So just check that none of these are way out of range.
+	 */
+	if (bt->hfrontporch > max_hor ||
+	    bt->hsync > max_hor || bt->hbackporch > max_hor)
 		return false;
-	if (bt->vfrontporch > 4096 ||
-	    bt->vsync > 128 || bt->vbackporch > 4096)
+	if (bt->vfrontporch > max_vert ||
+	    bt->vsync > max_vert || bt->vbackporch > max_vert)
 		return false;
-	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
-	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+	if (bt->interlaced && (bt->il_vfrontporch > max_vert ||
+	    bt->il_vsync > max_vert || bt->il_vbackporch > max_vert))
 		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }
diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 99d8881a7d6c..9871c19d2b4e 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2455,13 +2455,11 @@ static int msdc_of_clock_parse(struct platform_device *pdev,
 	if (IS_ERR(host->src_clk_cg))
 		host->src_clk_cg = NULL;
 
-	host->sys_clk_cg = devm_clk_get_optional(&pdev->dev, "sys_cg");
+	/* If present, always enable for this clock gate */
+	host->sys_clk_cg = devm_clk_get_optional_enabled(&pdev->dev, "sys_cg");
 	if (IS_ERR(host->sys_clk_cg))
 		host->sys_clk_cg = NULL;
 
-	/* If present, always enable for this clock gate */
-	clk_prepare_enable(host->sys_clk_cg);
-
 	host->bulk_clks[0].id = "pclk_cg";
 	host->bulk_clks[1].id = "axi_cg";
 	host->bulk_clks[2].id = "ahb_cg";
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index c6068a251fbe..9ed048cb07e6 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -227,6 +227,10 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 		u8 rxerr = msg->msg.rx.data[2];
 		u8 txerr = msg->msg.rx.data[3];
 
+		netdev_dbg(priv->netdev,
+			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
+			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
 			stats->rx_dropped++;
@@ -253,6 +257,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				break;
 			default:
 				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				txerr = 0;
+				rxerr = 0;
 				break;
 			}
 		} else {
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 10c6fea1227f..bdbbff2a7909 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -95,6 +95,8 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 		if (IS_ERR(region)) {
 			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
+
+			kfree(priv->regions);
 			return PTR_ERR(region);
 		}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1a2a7536ff8a..ef4d8d6c2bd7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1025,7 +1025,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 
 		policing[bcast].sharindx = port;
 		/* Only SJA1110 has multicast policers */
-		if (mcast <= table->ops->max_entry_count)
+		if (mcast < table->ops->max_entry_count)
 			policing[mcast].sharindx = port;
 	}
 
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index c560ad06f0be..a95bac4e14f6 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -258,6 +258,7 @@ static int greth_init_rings(struct greth_private *greth)
 			if (dma_mapping_error(greth->dev, dma_addr)) {
 				if (netif_msg_ifup(greth))
 					dev_err(greth->dev, "Could not create initial DMA mapping\n");
+				dev_kfree_skb(skb);
 				goto cleanup;
 			}
 			greth->rx_skbuff[i] = skb;
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 1cd3c289f49b..cd1706909044 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -71,13 +71,14 @@ config BCM63XX_ENET
 config BCMGENET
 	tristate "Broadcom GENET internal MAC support"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
 	select MII
 	select PHYLIB
 	select FIXED_PHY
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
+	select BROADCOM_PHY if ARCH_BCM2835
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index a27227aeae88..b43b97e15a6f 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2250,7 +2250,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_unregister_interrupts;
+		goto err_destroy_workqueue;
 	}
 
 	nic->msg_enable = debug;
@@ -2259,6 +2259,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+err_destroy_workqueue:
+	destroy_workqueue(nic->nicvf_rx_mode_wq);
 err_unregister_interrupts:
 	nicvf_unregister_interrupts(nic);
 err_free_netdev:
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index cacd454ac696..c39b866e2582 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
@@ -172,6 +174,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -182,6 +185,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 22bf914f2dbd..ea3e67cf5ffa 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -283,7 +283,7 @@ static int hisi_femac_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = (pos + 1) % rxq->num;
 		if (rx_pkts_num >= limit)
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index c1aae0fca5e9..0a70fb979f0c 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -550,7 +550,7 @@ static int hix5hd2_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = dma_ring_incr(pos, RX_DESC_NUM);
 	}
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 407bbb4cc236..7e41ce188cc6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5941,9 +5941,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		e1000_tx_queue(tx_ring, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
 		e1000_maybe_stop_tx(tx_ring,
-				    (MAX_SKB_FRAGS *
+				    ((MAX_SKB_FRAGS + 1) *
 				     DIV_ROUND_UP(PAGE_SIZE,
-						  adapter->tx_fifo_limit) + 2));
+						  adapter->tx_fifo_limit) + 4));
 
 		if (!netdev_xmit_more() ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 4e3243287805..813889604ff8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4364,11 +4364,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 			return -EOPNOTSUPP;
 
 		/* First 4 bytes of L4 header */
-		if (usr_ip4_spec->l4_4_bytes == htonl(0xFFFFFFFF))
-			new_mask |= I40E_L4_SRC_MASK | I40E_L4_DST_MASK;
-		else if (!usr_ip4_spec->l4_4_bytes)
-			new_mask &= ~(I40E_L4_SRC_MASK | I40E_L4_DST_MASK);
-		else
+		if (usr_ip4_spec->l4_4_bytes)
 			return -EOPNOTSUPP;
 
 		/* Filtering on Type of Service is not supported. */
@@ -4407,11 +4403,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 		else
 			return -EOPNOTSUPP;
 
-		if (usr_ip6_spec->l4_4_bytes == htonl(0xFFFFFFFF))
-			new_mask |= I40E_L4_SRC_MASK | I40E_L4_DST_MASK;
-		else if (!usr_ip6_spec->l4_4_bytes)
-			new_mask &= ~(I40E_L4_SRC_MASK | I40E_L4_DST_MASK);
-		else
+		if (usr_ip6_spec->l4_4_bytes)
 			return -EOPNOTSUPP;
 
 		/* Filtering on Traffic class is not supported. */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 19b5c5677584..ed2c961902b6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10519,6 +10519,21 @@ static int i40e_rebuild_channels(struct i40e_vsi *vsi)
 	return 0;
 }
 
+/**
+ * i40e_clean_xps_state - clean xps state for every tx_ring
+ * @vsi: ptr to the VSI
+ **/
+static void i40e_clean_xps_state(struct i40e_vsi *vsi)
+{
+	int i;
+
+	if (vsi->tx_rings)
+		for (i = 0; i < vsi->num_queue_pairs; i++)
+			if (vsi->tx_rings[i])
+				clear_bit(__I40E_TX_XPS_INIT_DONE,
+					  vsi->tx_rings[i]->state);
+}
+
 /**
  * i40e_prep_for_reset - prep for the core to reset
  * @pf: board private structure
@@ -10543,8 +10558,10 @@ static void i40e_prep_for_reset(struct i40e_pf *pf)
 	i40e_pf_quiesce_all_vsi(pf);
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
-		if (pf->vsi[v])
+		if (pf->vsi[v]) {
+			i40e_clean_xps_state(pf->vsi[v]);
 			pf->vsi[v]->seid = 0;
+		}
 	}
 
 	i40e_shutdown_adminq(&pf->hw);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8f350792e823..7aedf20a1021 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1578,6 +1578,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(I40E_VF_STATE_RESETTING, &vf->vf_states);
 
 	return true;
@@ -1701,6 +1702,7 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 	}
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(__I40E_VF_DISABLE, pf->state);
 
 	return true;
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 3cbb5a89b336..e99e6e44b525 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1409,6 +1409,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
 			*data = 1;
 			return -1;
 		}
+		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
+		wr32(E1000_EIMS, BIT(0));
 	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
 		shared_int = false;
 		if (request_irq(irq,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 9d460a270601..5c431a369762 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4162,7 +4162,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
 	 */
-	if (cpu_online(pp->rxq_def))
+	if (pp->rxq_def < nr_cpu_ids && cpu_online(pp->rxq_def))
 		elected_cpu = pp->rxq_def;
 
 	max_cpu = num_present_cpus();
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 75388a65f349..a42373e6f259 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1090,7 +1090,12 @@ int otx2_init_tc(struct otx2_nic *nic)
 		return err;
 
 	tc->flow_ht_params = tc_flow_ht_params;
-	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	err = rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	if (err) {
+		kfree(tc->tc_entries_bitmap);
+		tc->tc_entries_bitmap = NULL;
+	}
+	return err;
 }
 
 void otx2_shutdown_tc(struct otx2_nic *nic)
diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 81a8ccca7e5e..5693784eec5b 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -359,7 +359,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -397,7 +397,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 435ac224e38e..0463f20da17b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -829,6 +829,8 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 cleanup_ports:
 	sparx5_cleanup_ports(sparx5);
+	if (sparx5->mact_queue)
+		destroy_workqueue(sparx5->mact_queue);
 cleanup_config:
 	kfree(configs);
 cleanup_pnode:
@@ -852,6 +854,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 	sparx5_cleanup_ports(sparx5);
 	/* Unregister netdevs */
 	sparx5_unregister_notifier_blocks(sparx5);
+	destroy_workqueue(sparx5->mact_queue);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 41ecd156e95f..1038bdf28ec0 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -488,7 +488,14 @@ enum {
 
 #define GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT BIT(0)
 
-#define GDMA_DRV_CAP_FLAGS1 GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT
+/* Advertise to the NIC firmware: the NAPI work_done variable race is fixed,
+ * so the driver is able to reliably support features like busy_poll.
+ */
+#define GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX BIT(2)
+
+#define GDMA_DRV_CAP_FLAGS1 \
+	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
+	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 18dc64d7f412..4b8c23993217 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1071,10 +1071,11 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 	}
 }
 
-static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
+static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
 	u8 arm_bit;
+	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
 
@@ -1083,26 +1084,31 @@ static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 	else
 		mana_poll_tx_cq(cq);
 
-	if (cq->work_done < cq->budget &&
-	    napi_complete_done(&cq->napi, cq->work_done)) {
+	w = cq->work_done;
+
+	if (w < cq->budget &&
+	    napi_complete_done(&cq->napi, w)) {
 		arm_bit = SET_ARM_BIT;
 	} else {
 		arm_bit = 0;
 	}
 
 	mana_gd_ring_cq(gdma_queue, arm_bit);
+
+	return w;
 }
 
 static int mana_poll(struct napi_struct *napi, int budget)
 {
 	struct mana_cq *cq = container_of(napi, struct mana_cq, napi);
+	int w;
 
 	cq->work_done = 0;
 	cq->budget = budget;
 
-	mana_cq_handler(cq, cq->gdma_cq);
+	w = mana_cq_handler(cq, cq->gdma_cq);
 
-	return min(cq->work_done, budget);
+	return min(w, budget);
 }
 
 static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 9f5cac4000da..5c234a8158c7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -108,10 +108,10 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 
 	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
 	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
-	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
-	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
-	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
-	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
+	axi->axi_kbbe = of_property_read_bool(np, "snps,kbbe");
+	axi->axi_fb = of_property_read_bool(np, "snps,fb");
+	axi->axi_mb = of_property_read_bool(np, "snps,mb");
+	axi->axi_rb =  of_property_read_bool(np, "snps,rb");
 
 	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
 		axi->axi_wr_osr_lmt = 1;
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 96592a20c61f..0362917fce7a 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -927,7 +927,7 @@ static int ca8210_spi_transfer(
 
 	dev_dbg(&spi->dev, "%s called\n", __func__);
 
-	cas_ctl = kmalloc(sizeof(*cas_ctl), GFP_ATOMIC);
+	cas_ctl = kzalloc(sizeof(*cas_ctl), GFP_ATOMIC);
 	if (!cas_ctl)
 		return -ENOMEM;
 
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 4517517215f2..a8369bfa4050 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -970,7 +970,7 @@ static int cc2520_hw_init(struct cc2520_private *priv)
 
 		if (timeout-- <= 0) {
 			dev_err(&priv->spi->dev, "oscillator start failed!\n");
-			return ret;
+			return -ETIMEDOUT;
 		}
 		udelay(1);
 	} while (!(status & CC2520_STATUS_XOSC32M_STABLE));
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index aa9d0dfeda5a..88e44eb39285 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3675,6 +3675,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
 	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_OFFLOAD] = { .type = NLA_U8 },
 };
 
 static void macsec_free_netdev(struct net_device *dev)
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 40e745a1d185..2c47efdae73b 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -77,6 +77,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	 */
 	rc = phy_device_register(phy);
 	if (rc) {
+		device_set_node(&phy->mdio.dev, NULL);
 		fwnode_handle_put(child);
 		return rc;
 	}
@@ -110,8 +111,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	else
 		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
 	if (IS_ERR(phy)) {
-		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
+		rc = PTR_ERR(phy);
+		goto clean_mii_ts;
 	}
 
 	if (is_acpi_node(child)) {
@@ -125,17 +126,14 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
 		if (rc) {
-			phy_device_free(phy);
-			fwnode_handle_put(phy->mdio.dev.fwnode);
-			return rc;
+			phy->mdio.dev.fwnode = NULL;
+			fwnode_handle_put(child);
+			goto clean_phy;
 		}
 	} else if (is_of_node(child)) {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
-		if (rc) {
-			unregister_mii_timestamper(mii_ts);
-			phy_device_free(phy);
-			return rc;
-		}
+		if (rc)
+			goto clean_phy;
 	}
 
 	/* phy->mii_ts may already be defined by the PHY driver. A
@@ -145,5 +143,12 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
 	return 0;
+
+clean_phy:
+	phy_device_free(phy);
+clean_mii_ts:
+	unregister_mii_timestamper(mii_ts);
+
+	return rc;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 796e9c7857d0..510822d6d0d9 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -68,8 +68,9 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	/* All data is now stored in the mdiodev struct; register it. */
 	rc = mdio_device_register(mdiodev);
 	if (rc) {
+		device_set_node(&mdiodev->dev, NULL);
+		fwnode_handle_put(fwnode);
 		mdio_device_free(mdiodev);
-		of_node_put(child);
 		return rc;
 	}
 
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 250742ffdfd9..044828d081d2 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/unistd.h>
+#include <linux/property.h>
 
 void mdio_device_free(struct mdio_device *mdiodev)
 {
@@ -30,6 +31,7 @@ EXPORT_SYMBOL(mdio_device_free);
 
 static void mdio_device_release(struct device *dev)
 {
+	fwnode_handle_put(dev->fwnode);
 	kfree(to_mdio_device(dev));
 }
 
diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5ce1bf03bbd7..f9c70476d7e8 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -96,6 +96,7 @@ static int gpy_config_init(struct phy_device *phydev)
 
 static int gpy_probe(struct phy_device *phydev)
 {
+	int fw_version;
 	int ret;
 
 	if (!phydev->is_c45) {
@@ -105,12 +106,12 @@ static int gpy_probe(struct phy_device *phydev)
 	}
 
 	/* Show GPY PHY FW version in dmesg */
-	ret = phy_read(phydev, PHY_FWV);
-	if (ret < 0)
-		return ret;
+	fw_version = phy_read(phydev, PHY_FWV);
+	if (fw_version < 0)
+		return fw_version;
 
-	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", ret,
-		    (ret & PHY_FWV_REL_MASK) ? "release" : "test");
+	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_version,
+		    (fw_version & PHY_FWV_REL_MASK) ? "release" : "test");
 
 	return 0;
 }
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 2a2cb9d453e8..b1776116f9f7 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -446,12 +446,12 @@ plip_bh_timeout_error(struct net_device *dev, struct net_local *nl,
 	}
 	rcv->state = PLIP_PK_DONE;
 	if (rcv->skb) {
-		kfree_skb(rcv->skb);
+		dev_kfree_skb_irq(rcv->skb);
 		rcv->skb = NULL;
 	}
 	snd->state = PLIP_PK_DONE;
 	if (snd->skb) {
-		dev_kfree_skb(snd->skb);
+		dev_consume_skb_irq(snd->skb);
 		snd->skb = NULL;
 	}
 	spin_unlock_irq(&nl->lock);
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 129149640225..3395dcb0b262 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -902,6 +902,7 @@ static int tbnet_open(struct net_device *dev)
 				tbnet_start_poll, net);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Rx ring\n");
+		tb_xdomain_release_out_hopid(xd, hopid);
 		tb_ring_free(net->tx_ring.ring);
 		net->tx_ring.ring = NULL;
 		return -ENOMEM;
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d886f903e428..7b358b896a6d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1413,6 +1413,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
 	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
 	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
+	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index bc3192cf48e3..21896e221300 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -75,8 +75,14 @@ vmxnet3_enable_all_intrs(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_enable_intr(adapter, i);
-	adapter->shared->devRead.intrConf.intrCtrl &=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl &=
+					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl &=
 					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	}
 }
 
 
@@ -85,8 +91,14 @@ vmxnet3_disable_all_intrs(struct vmxnet3_adapter *adapter)
 {
 	int i;
 
-	adapter->shared->devRead.intrConf.intrCtrl |=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl |=
+					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl |=
 					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	}
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_disable_intr(adapter, i);
 }
@@ -1350,6 +1362,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	};
 	u32 num_pkts = 0;
 	bool skip_page_frags = false;
+	bool encap_lro = false;
 	struct Vmxnet3_RxCompDesc *rcd;
 	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
 	u16 segCnt = 0, mss = 0;
@@ -1508,13 +1521,18 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (VMXNET3_VERSION_GE_2(adapter) &&
 			    rcd->type == VMXNET3_CDTYPE_RXCOMP_LRO) {
 				struct Vmxnet3_RxCompDescExt *rcdlro;
+				union Vmxnet3_GenericDesc *gdesc;
+
 				rcdlro = (struct Vmxnet3_RxCompDescExt *)rcd;
+				gdesc = (union Vmxnet3_GenericDesc *)rcd;
 
 				segCnt = rcdlro->segCnt;
 				WARN_ON_ONCE(segCnt == 0);
 				mss = rcdlro->mss;
 				if (unlikely(segCnt <= 1))
 					segCnt = 0;
+				encap_lro = (le32_to_cpu(gdesc->dword[0]) &
+					(1UL << VMXNET3_RCD_HDR_INNER_SHIFT));
 			} else {
 				segCnt = 0;
 			}
@@ -1582,7 +1600,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
-			if (!rcd->tcp ||
+			if ((!rcd->tcp && !encap_lro) ||
 			    !(adapter->netdev->features & NETIF_F_LRO))
 				goto not_lro;
 
@@ -1591,7 +1609,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
 				skb_shinfo(skb)->gso_size = mss;
 				skb_shinfo(skb)->gso_segs = segCnt;
-			} else if (segCnt != 0 || skb->len > mtu) {
+			} else if ((segCnt != 0 || skb->len > mtu) && !encap_lro) {
 				u32 hlen;
 
 				hlen = vmxnet3_get_hdr_len(adapter, skb,
@@ -1620,6 +1638,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				napi_gro_receive(&rq->napi, skb);
 
 			ctx->skb = NULL;
+			encap_lro = false;
 			num_pkts++;
 		}
 
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index d9dea4829c86..adfd21aa5b6a 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -48,7 +48,6 @@
 #include <linux/debugfs.h>
 
 typedef unsigned int pending_ring_idx_t;
-#define INVALID_PENDING_RING_IDX (~0U)
 
 struct pending_tx_info {
 	struct xen_netif_tx_request req; /* tx request */
@@ -82,8 +81,6 @@ struct xenvif_rx_meta {
 /* Discriminate from any valid pending_idx value. */
 #define INVALID_PENDING_IDX 0xFFFF
 
-#define MAX_BUFFER_OFFSET XEN_PAGE_SIZE
-
 #define MAX_PENDING_REQS XEN_NETIF_TX_RING_SIZE
 
 /* The maximum number of frags is derived from the size of a grant (same
@@ -367,11 +364,6 @@ void xenvif_free(struct xenvif *vif);
 int xenvif_xenbus_init(void);
 void xenvif_xenbus_fini(void);
 
-int xenvif_schedulable(struct xenvif *vif);
-
-int xenvif_queue_stopped(struct xenvif_queue *queue);
-void xenvif_wake_queue(struct xenvif_queue *queue);
-
 /* (Un)Map communication rings. */
 void xenvif_unmap_frontend_data_rings(struct xenvif_queue *queue);
 int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,
@@ -394,8 +386,7 @@ int xenvif_dealloc_kthread(void *data);
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
-void xenvif_rx_action(struct xenvif_queue *queue);
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
 
@@ -403,9 +394,6 @@ void xenvif_carrier_on(struct xenvif *vif);
 void xenvif_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *ubuf,
 			      bool zerocopy_success);
 
-/* Unmap a pending page and release it back to the guest */
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
-
 static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 {
 	return MAX_PENDING_REQS -
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index c58996c1e230..e1a5610b1747 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -70,7 +70,7 @@ void xenvif_skb_zerocopy_complete(struct xenvif_queue *queue)
 	wake_up(&queue->dealloc_wq);
 }
 
-int xenvif_schedulable(struct xenvif *vif)
+static int xenvif_schedulable(struct xenvif *vif)
 {
 	return netif_running(vif->dev) &&
 		test_bit(VIF_STATUS_CONNECTED, &vif->status) &&
@@ -178,20 +178,6 @@ irqreturn_t xenvif_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int xenvif_queue_stopped(struct xenvif_queue *queue)
-{
-	struct net_device *dev = queue->vif->dev;
-	unsigned int id = queue->id;
-	return netif_tx_queue_stopped(netdev_get_tx_queue(dev, id));
-}
-
-void xenvif_wake_queue(struct xenvif_queue *queue)
-{
-	struct net_device *dev = queue->vif->dev;
-	unsigned int id = queue->id;
-	netif_tx_wake_queue(netdev_get_tx_queue(dev, id));
-}
-
 static u16 xenvif_select_queue(struct net_device *dev, struct sk_buff *skb,
 			       struct net_device *sb_dev)
 {
@@ -269,14 +255,16 @@ xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (vif->hash.alg == XEN_NETIF_CTRL_HASH_ALGORITHM_NONE)
 		skb_clear_hash(skb);
 
-	xenvif_rx_queue_tail(queue, skb);
+	if (!xenvif_rx_queue_tail(queue, skb))
+		goto drop;
+
 	xenvif_kick_thread(queue);
 
 	return NETDEV_TX_OK;
 
  drop:
 	vif->dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 32d5bc4919d8..26428db845be 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -112,6 +112,8 @@ static void make_tx_response(struct xenvif_queue *queue,
 			     s8       st);
 static void push_tx_responses(struct xenvif_queue *queue);
 
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
+
 static inline int tx_work_todo(struct xenvif_queue *queue);
 
 static inline unsigned long idx_to_pfn(struct xenvif_queue *queue,
@@ -330,10 +332,13 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 
 
 struct xenvif_tx_cb {
-	u16 pending_idx;
+	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
+	u8 copy_count;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
+#define copy_pending_idx(skb, i) (XENVIF_TX_CB(skb)->copy_pending_idx[i])
+#define copy_count(skb) (XENVIF_TX_CB(skb)->copy_count)
 
 static inline void xenvif_tx_create_map_op(struct xenvif_queue *queue,
 					   u16 pending_idx,
@@ -368,31 +373,93 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
 	return skb;
 }
 
-static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif_queue *queue,
-							struct sk_buff *skb,
-							struct xen_netif_tx_request *txp,
-							struct gnttab_map_grant_ref *gop,
-							unsigned int frag_overflow,
-							struct sk_buff *nskb)
+static void xenvif_get_requests(struct xenvif_queue *queue,
+				struct sk_buff *skb,
+				struct xen_netif_tx_request *first,
+				struct xen_netif_tx_request *txfrags,
+			        unsigned *copy_ops,
+			        unsigned *map_ops,
+				unsigned int frag_overflow,
+				struct sk_buff *nskb,
+				unsigned int extra_count,
+				unsigned int data_len)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	skb_frag_t *frags = shinfo->frags;
-	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
-	int start;
+	u16 pending_idx;
 	pending_ring_idx_t index;
 	unsigned int nr_slots;
+	struct gnttab_copy *cop = queue->tx_copy_ops + *copy_ops;
+	struct gnttab_map_grant_ref *gop = queue->tx_map_ops + *map_ops;
+	struct xen_netif_tx_request *txp = first;
+
+	nr_slots = shinfo->nr_frags + 1;
+
+	copy_count(skb) = 0;
 
-	nr_slots = shinfo->nr_frags;
+	/* Create copy ops for exactly data_len bytes into the skb head. */
+	__skb_put(skb, data_len);
+	while (data_len > 0) {
+		int amount = data_len > txp->size ? txp->size : data_len;
 
-	/* Skip first skb fragment if it is on same page as header fragment. */
-	start = (frag_get_pending_idx(&shinfo->frags[0]) == pending_idx);
+		cop->source.u.ref = txp->gref;
+		cop->source.domid = queue->vif->domid;
+		cop->source.offset = txp->offset;
 
-	for (shinfo->nr_frags = start; shinfo->nr_frags < nr_slots;
-	     shinfo->nr_frags++, txp++, gop++) {
+		cop->dest.domid = DOMID_SELF;
+		cop->dest.offset = (offset_in_page(skb->data +
+						   skb_headlen(skb) -
+						   data_len)) & ~XEN_PAGE_MASK;
+		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
+				               - data_len);
+
+		cop->len = amount;
+		cop->flags = GNTCOPY_source_gref;
+
+		index = pending_index(queue->pending_cons);
+		pending_idx = queue->pending_ring[index];
+		callback_param(queue, pending_idx).ctx = NULL;
+		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
+		copy_count(skb)++;
+
+		cop++;
+		data_len -= amount;
+
+		if (amount == txp->size) {
+			/* The copy op covered the full tx_request */
+
+			memcpy(&queue->pending_tx_info[pending_idx].req,
+			       txp, sizeof(*txp));
+			queue->pending_tx_info[pending_idx].extra_count =
+				(txp == first) ? extra_count : 0;
+
+			if (txp == first)
+				txp = txfrags;
+			else
+				txp++;
+			queue->pending_cons++;
+			nr_slots--;
+		} else {
+			/* The copy op partially covered the tx_request.
+			 * The remainder will be mapped.
+			 */
+			txp->offset += amount;
+			txp->size -= amount;
+		}
+	}
+
+	for (shinfo->nr_frags = 0; shinfo->nr_frags < nr_slots;
+	     shinfo->nr_frags++, gop++) {
 		index = pending_index(queue->pending_cons++);
 		pending_idx = queue->pending_ring[index];
-		xenvif_tx_create_map_op(queue, pending_idx, txp, 0, gop);
+		xenvif_tx_create_map_op(queue, pending_idx, txp,
+				        txp == first ? extra_count : 0, gop);
 		frag_set_pending_idx(&frags[shinfo->nr_frags], pending_idx);
+
+		if (txp == first)
+			txp = txfrags;
+		else
+			txp++;
 	}
 
 	if (frag_overflow) {
@@ -413,7 +480,8 @@ static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif_queue *que
 		skb_shinfo(skb)->frag_list = nskb;
 	}
 
-	return gop;
+	(*copy_ops) = cop - queue->tx_copy_ops;
+	(*map_ops) = gop - queue->tx_map_ops;
 }
 
 static inline void xenvif_grant_handle_set(struct xenvif_queue *queue,
@@ -449,7 +517,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 			       struct gnttab_copy **gopp_copy)
 {
 	struct gnttab_map_grant_ref *gop_map = *gopp_map;
-	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+	u16 pending_idx;
 	/* This always points to the shinfo of the skb being checked, which
 	 * could be either the first or the one on the frag_list
 	 */
@@ -460,24 +528,37 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 	struct skb_shared_info *first_shinfo = NULL;
 	int nr_frags = shinfo->nr_frags;
 	const bool sharedslot = nr_frags &&
-				frag_get_pending_idx(&shinfo->frags[0]) == pending_idx;
-	int i, err;
+				frag_get_pending_idx(&shinfo->frags[0]) ==
+				    copy_pending_idx(skb, copy_count(skb) - 1);
+	int i, err = 0;
 
-	/* Check status of header. */
-	err = (*gopp_copy)->status;
-	if (unlikely(err)) {
-		if (net_ratelimit())
-			netdev_dbg(queue->vif->dev,
-				   "Grant copy of header failed! status: %d pending_idx: %u ref: %u\n",
-				   (*gopp_copy)->status,
-				   pending_idx,
-				   (*gopp_copy)->source.u.ref);
-		/* The first frag might still have this slot mapped */
-		if (!sharedslot)
-			xenvif_idx_release(queue, pending_idx,
-					   XEN_NETIF_RSP_ERROR);
+	for (i = 0; i < copy_count(skb); i++) {
+		int newerr;
+
+		/* Check status of header. */
+		pending_idx = copy_pending_idx(skb, i);
+
+		newerr = (*gopp_copy)->status;
+		if (likely(!newerr)) {
+			/* The first frag might still have this slot mapped */
+			if (i < copy_count(skb) - 1 || !sharedslot)
+				xenvif_idx_release(queue, pending_idx,
+						   XEN_NETIF_RSP_OKAY);
+		} else {
+			err = newerr;
+			if (net_ratelimit())
+				netdev_dbg(queue->vif->dev,
+					   "Grant copy of header failed! status: %d pending_idx: %u ref: %u\n",
+					   (*gopp_copy)->status,
+					   pending_idx,
+					   (*gopp_copy)->source.u.ref);
+			/* The first frag might still have this slot mapped */
+			if (i < copy_count(skb) - 1 || !sharedslot)
+				xenvif_idx_release(queue, pending_idx,
+						   XEN_NETIF_RSP_ERROR);
+		}
+		(*gopp_copy)++;
 	}
-	(*gopp_copy)++;
 
 check_frags:
 	for (i = 0; i < nr_frags; i++, gop_map++) {
@@ -524,14 +605,6 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 		if (err)
 			continue;
 
-		/* First error: if the header haven't shared a slot with the
-		 * first frag, release it as well.
-		 */
-		if (!sharedslot)
-			xenvif_idx_release(queue,
-					   XENVIF_TX_CB(skb)->pending_idx,
-					   XEN_NETIF_RSP_OKAY);
-
 		/* Invalidate preceding fragments of this skb. */
 		for (j = 0; j < i; j++) {
 			pending_idx = frag_get_pending_idx(&shinfo->frags[j]);
@@ -801,7 +874,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 				     unsigned *copy_ops,
 				     unsigned *map_ops)
 {
-	struct gnttab_map_grant_ref *gop = queue->tx_map_ops;
 	struct sk_buff *skb, *nskb;
 	int ret;
 	unsigned int frag_overflow;
@@ -883,8 +955,12 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 			continue;
 		}
 
+		data_len = (txreq.size > XEN_NETBACK_TX_COPY_LEN) ?
+			XEN_NETBACK_TX_COPY_LEN : txreq.size;
+
 		ret = xenvif_count_requests(queue, &txreq, extra_count,
 					    txfrags, work_to_do);
+
 		if (unlikely(ret < 0))
 			break;
 
@@ -910,9 +986,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		index = pending_index(queue->pending_cons);
 		pending_idx = queue->pending_ring[index];
 
-		data_len = (txreq.size > XEN_NETBACK_TX_COPY_LEN &&
-			    ret < XEN_NETBK_LEGACY_SLOTS_MAX) ?
-			XEN_NETBACK_TX_COPY_LEN : txreq.size;
+		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
+			data_len = txreq.size;
 
 		skb = xenvif_alloc_skb(data_len);
 		if (unlikely(skb == NULL)) {
@@ -923,8 +998,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		}
 
 		skb_shinfo(skb)->nr_frags = ret;
-		if (data_len < txreq.size)
-			skb_shinfo(skb)->nr_frags++;
 		/* At this point shinfo->nr_frags is in fact the number of
 		 * slots, which can be as large as XEN_NETBK_LEGACY_SLOTS_MAX.
 		 */
@@ -986,54 +1059,19 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 					     type);
 		}
 
-		XENVIF_TX_CB(skb)->pending_idx = pending_idx;
-
-		__skb_put(skb, data_len);
-		queue->tx_copy_ops[*copy_ops].source.u.ref = txreq.gref;
-		queue->tx_copy_ops[*copy_ops].source.domid = queue->vif->domid;
-		queue->tx_copy_ops[*copy_ops].source.offset = txreq.offset;
-
-		queue->tx_copy_ops[*copy_ops].dest.u.gmfn =
-			virt_to_gfn(skb->data);
-		queue->tx_copy_ops[*copy_ops].dest.domid = DOMID_SELF;
-		queue->tx_copy_ops[*copy_ops].dest.offset =
-			offset_in_page(skb->data) & ~XEN_PAGE_MASK;
-
-		queue->tx_copy_ops[*copy_ops].len = data_len;
-		queue->tx_copy_ops[*copy_ops].flags = GNTCOPY_source_gref;
-
-		(*copy_ops)++;
-
-		if (data_len < txreq.size) {
-			frag_set_pending_idx(&skb_shinfo(skb)->frags[0],
-					     pending_idx);
-			xenvif_tx_create_map_op(queue, pending_idx, &txreq,
-						extra_count, gop);
-			gop++;
-		} else {
-			frag_set_pending_idx(&skb_shinfo(skb)->frags[0],
-					     INVALID_PENDING_IDX);
-			memcpy(&queue->pending_tx_info[pending_idx].req,
-			       &txreq, sizeof(txreq));
-			queue->pending_tx_info[pending_idx].extra_count =
-				extra_count;
-		}
-
-		queue->pending_cons++;
-
-		gop = xenvif_get_requests(queue, skb, txfrags, gop,
-				          frag_overflow, nskb);
+		xenvif_get_requests(queue, skb, &txreq, txfrags, copy_ops,
+				    map_ops, frag_overflow, nskb, extra_count,
+				    data_len);
 
 		__skb_queue_tail(&queue->tx_queue, skb);
 
 		queue->tx.req_cons = idx;
 
-		if (((gop-queue->tx_map_ops) >= ARRAY_SIZE(queue->tx_map_ops)) ||
+		if ((*map_ops >= ARRAY_SIZE(queue->tx_map_ops)) ||
 		    (*copy_ops >= ARRAY_SIZE(queue->tx_copy_ops)))
 			break;
 	}
 
-	(*map_ops) = gop - queue->tx_map_ops;
 	return;
 }
 
@@ -1112,9 +1150,8 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 	while ((skb = __skb_dequeue(&queue->tx_queue)) != NULL) {
 		struct xen_netif_tx_request *txp;
 		u16 pending_idx;
-		unsigned data_len;
 
-		pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+		pending_idx = copy_pending_idx(skb, 0);
 		txp = &queue->pending_tx_info[pending_idx].req;
 
 		/* Check the remap error code. */
@@ -1133,18 +1170,6 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 			continue;
 		}
 
-		data_len = skb->len;
-		callback_param(queue, pending_idx).ctx = NULL;
-		if (data_len < txp->size) {
-			/* Append the packet payload as a fragment. */
-			txp->offset += data_len;
-			txp->size -= data_len;
-		} else {
-			/* Schedule a response immediately. */
-			xenvif_idx_release(queue, pending_idx,
-					   XEN_NETIF_RSP_OKAY);
-		}
-
 		if (txp->flags & XEN_NETTXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;
 		else if (txp->flags & XEN_NETTXF_data_validated)
@@ -1331,7 +1356,7 @@ static inline void xenvif_tx_dealloc_action(struct xenvif_queue *queue)
 /* Called after netfront has transmitted */
 int xenvif_tx_action(struct xenvif_queue *queue, int budget)
 {
-	unsigned nr_mops, nr_cops = 0;
+	unsigned nr_mops = 0, nr_cops = 0;
 	int work_done, ret;
 
 	if (unlikely(!tx_work_todo(queue)))
@@ -1418,7 +1443,7 @@ static void push_tx_responses(struct xenvif_queue *queue)
 		notify_remote_via_irq(queue->tx_irq);
 }
 
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
 {
 	int ret;
 	struct gnttab_unmap_grant_ref tx_unmap_op;
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index a0335407be42..0ba754ebc5ba 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -82,9 +82,10 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	return false;
 }
 
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 {
 	unsigned long flags;
+	bool ret = true;
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
@@ -92,8 +93,7 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 		struct net_device *dev = queue->vif->dev;
 
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
-		kfree_skb(skb);
-		queue->vif->dev->stats.rx_dropped++;
+		ret = false;
 	} else {
 		if (skb_queue_empty(&queue->rx_queue))
 			xenvif_update_needed_slots(queue, skb);
@@ -104,6 +104,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+
+	return ret;
 }
 
 static struct sk_buff *xenvif_rx_dequeue(struct xenvif_queue *queue)
@@ -486,7 +488,7 @@ static void xenvif_rx_skb(struct xenvif_queue *queue)
 
 #define RX_BATCH_SIZE 64
 
-void xenvif_rx_action(struct xenvif_queue *queue)
+static void xenvif_rx_action(struct xenvif_queue *queue)
 {
 	struct sk_buff_head completed_skbs;
 	unsigned int work_done = 0;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 074dceb1930b..6e73d3a00eec 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1866,6 +1866,12 @@ static int netfront_resume(struct xenbus_device *dev)
 	netif_tx_unlock_bh(info->netdev);
 
 	xennet_disconnect_backend(info);
+
+	rtnl_lock();
+	if (info->queues)
+		xennet_destroy_queues(info);
+	rtnl_unlock();
+
 	return 0;
 }
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 694373951b18..692ee0f4a1ec 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2921,10 +2921,6 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 	if (!ctrl->identified) {
 		unsigned int i;
 
-		ret = nvme_init_subsystem(ctrl, id);
-		if (ret)
-			goto out_free;
-
 		/*
 		 * Check for quirks.  Quirk can depend on firmware version,
 		 * so, in principle, the set of quirks present can change
@@ -2937,6 +2933,10 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 			if (quirk_matches(id, &core_quirks[i]))
 				ctrl->quirks |= core_quirks[i].quirks;
 		}
+
+		ret = nvme_init_subsystem(ctrl, id);
+		if (ret)
+			goto out_free;
 	}
 	memcpy(ctrl->subsys->firmware_rev, id->fr,
 	       sizeof(ctrl->subsys->firmware_rev));
diff --git a/drivers/regulator/slg51000-regulator.c b/drivers/regulator/slg51000-regulator.c
index 75a941fb3c2b..1b2eee95ad3f 100644
--- a/drivers/regulator/slg51000-regulator.c
+++ b/drivers/regulator/slg51000-regulator.c
@@ -457,6 +457,8 @@ static int slg51000_i2c_probe(struct i2c_client *client)
 		chip->cs_gpiod = cs_gpiod;
 	}
 
+	usleep_range(10000, 11000);
+
 	i2c_set_clientdata(client, chip);
 	chip->chip_irq = client->irq;
 	chip->dev = dev;
diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 7c7e3648ea4b..f3856750944f 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -67,6 +67,7 @@ struct twlreg_info {
 #define TWL6030_CFG_STATE_SLEEP	0x03
 #define TWL6030_CFG_STATE_GRP_SHIFT	5
 #define TWL6030_CFG_STATE_APP_SHIFT	2
+#define TWL6030_CFG_STATE_MASK		0x03
 #define TWL6030_CFG_STATE_APP_MASK	(0x03 << TWL6030_CFG_STATE_APP_SHIFT)
 #define TWL6030_CFG_STATE_APP(v)	(((v) & TWL6030_CFG_STATE_APP_MASK) >>\
 						TWL6030_CFG_STATE_APP_SHIFT)
@@ -128,13 +129,14 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
 		if (grp < 0)
 			return grp;
 		grp &= P1_GRP_6030;
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val = TWL6030_CFG_STATE_APP(val);
 	} else {
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val &= TWL6030_CFG_STATE_MASK;
 		grp = 1;
 	}
 
-	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
-	val = TWL6030_CFG_STATE_APP(val);
-
 	return grp && (val == TWL6030_CFG_STATE_ON);
 }
 
@@ -187,7 +189,12 @@ static int twl6030reg_get_status(struct regulator_dev *rdev)
 
 	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
 
-	switch (TWL6030_CFG_STATE_APP(val)) {
+	if (info->features & TWL6032_SUBCLASS)
+		val &= TWL6030_CFG_STATE_MASK;
+	else
+		val = TWL6030_CFG_STATE_APP(val);
+
+	switch (val) {
 	case TWL6030_CFG_STATE_ON:
 		return REGULATOR_STATUS_NORMAL;
 
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index b90a603d6b12..7c006c2b125f 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -249,10 +249,46 @@ static int cmos_set_time(struct device *dev, struct rtc_time *t)
 	return mc146818_set_time(t);
 }
 
+struct cmos_read_alarm_callback_param {
+	struct cmos_rtc *cmos;
+	struct rtc_time *time;
+	unsigned char	rtc_control;
+};
+
+static void cmos_read_alarm_callback(unsigned char __always_unused seconds,
+				     void *param_in)
+{
+	struct cmos_read_alarm_callback_param *p =
+		(struct cmos_read_alarm_callback_param *)param_in;
+	struct rtc_time *time = p->time;
+
+	time->tm_sec = CMOS_READ(RTC_SECONDS_ALARM);
+	time->tm_min = CMOS_READ(RTC_MINUTES_ALARM);
+	time->tm_hour = CMOS_READ(RTC_HOURS_ALARM);
+
+	if (p->cmos->day_alrm) {
+		/* ignore upper bits on readback per ACPI spec */
+		time->tm_mday = CMOS_READ(p->cmos->day_alrm) & 0x3f;
+		if (!time->tm_mday)
+			time->tm_mday = -1;
+
+		if (p->cmos->mon_alrm) {
+			time->tm_mon = CMOS_READ(p->cmos->mon_alrm);
+			if (!time->tm_mon)
+				time->tm_mon = -1;
+		}
+	}
+
+	p->rtc_control = CMOS_READ(RTC_CONTROL);
+}
+
 static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char	rtc_control;
+	struct cmos_read_alarm_callback_param p = {
+		.cmos = cmos,
+		.time = &t->time,
+	};
 
 	/* This not only a rtc_op, but also called directly */
 	if (!is_valid_irq(cmos->irq))
@@ -263,28 +299,18 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	 * the future.
 	 */
 
-	spin_lock_irq(&rtc_lock);
-	t->time.tm_sec = CMOS_READ(RTC_SECONDS_ALARM);
-	t->time.tm_min = CMOS_READ(RTC_MINUTES_ALARM);
-	t->time.tm_hour = CMOS_READ(RTC_HOURS_ALARM);
-
-	if (cmos->day_alrm) {
-		/* ignore upper bits on readback per ACPI spec */
-		t->time.tm_mday = CMOS_READ(cmos->day_alrm) & 0x3f;
-		if (!t->time.tm_mday)
-			t->time.tm_mday = -1;
-
-		if (cmos->mon_alrm) {
-			t->time.tm_mon = CMOS_READ(cmos->mon_alrm);
-			if (!t->time.tm_mon)
-				t->time.tm_mon = -1;
-		}
-	}
-
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	spin_unlock_irq(&rtc_lock);
+	/* Some Intel chipsets disconnect the alarm registers when the clock
+	 * update is in progress - during this time reads return bogus values
+	 * and writes may fail silently. See for example "7th Generation Intel®
+	 * Processor Family I/O for U/Y Platforms [...] Datasheet", section
+	 * 27.7.1
+	 *
+	 * Use the mc146818_avoid_UIP() function to avoid this.
+	 */
+	if (!mc146818_avoid_UIP(cmos_read_alarm_callback, &p))
+		return -EIO;
 
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
+	if (!(p.rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		if (((unsigned)t->time.tm_sec) < 0x60)
 			t->time.tm_sec = bcd2bin(t->time.tm_sec);
 		else
@@ -313,7 +339,7 @@ static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 		}
 	}
 
-	t->enabled = !!(rtc_control & RTC_AIE);
+	t->enabled = !!(p.rtc_control & RTC_AIE);
 	t->pending = 0;
 
 	return 0;
@@ -444,10 +470,57 @@ static int cmos_validate_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
+struct cmos_set_alarm_callback_param {
+	struct cmos_rtc *cmos;
+	unsigned char mon, mday, hrs, min, sec;
+	struct rtc_wkalrm *t;
+};
+
+/* Note: this function may be executed by mc146818_avoid_UIP() more then
+ *	 once
+ */
+static void cmos_set_alarm_callback(unsigned char __always_unused seconds,
+				    void *param_in)
+{
+	struct cmos_set_alarm_callback_param *p =
+		(struct cmos_set_alarm_callback_param *)param_in;
+
+	/* next rtc irq must not be from previous alarm setting */
+	cmos_irq_disable(p->cmos, RTC_AIE);
+
+	/* update alarm */
+	CMOS_WRITE(p->hrs, RTC_HOURS_ALARM);
+	CMOS_WRITE(p->min, RTC_MINUTES_ALARM);
+	CMOS_WRITE(p->sec, RTC_SECONDS_ALARM);
+
+	/* the system may support an "enhanced" alarm */
+	if (p->cmos->day_alrm) {
+		CMOS_WRITE(p->mday, p->cmos->day_alrm);
+		if (p->cmos->mon_alrm)
+			CMOS_WRITE(p->mon, p->cmos->mon_alrm);
+	}
+
+	if (use_hpet_alarm()) {
+		/*
+		 * FIXME the HPET alarm glue currently ignores day_alrm
+		 * and mon_alrm ...
+		 */
+		hpet_set_alarm_time(p->t->time.tm_hour, p->t->time.tm_min,
+				    p->t->time.tm_sec);
+	}
+
+	if (p->t->enabled)
+		cmos_irq_enable(p->cmos, RTC_AIE);
+}
+
 static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char mon, mday, hrs, min, sec, rtc_control;
+	struct cmos_set_alarm_callback_param p = {
+		.cmos = cmos,
+		.t = t
+	};
+	unsigned char rtc_control;
 	int ret;
 
 	/* This not only a rtc_op, but also called directly */
@@ -458,11 +531,11 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	mon = t->time.tm_mon + 1;
-	mday = t->time.tm_mday;
-	hrs = t->time.tm_hour;
-	min = t->time.tm_min;
-	sec = t->time.tm_sec;
+	p.mon = t->time.tm_mon + 1;
+	p.mday = t->time.tm_mday;
+	p.hrs = t->time.tm_hour;
+	p.min = t->time.tm_min;
+	p.sec = t->time.tm_sec;
 
 	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
@@ -470,43 +543,21 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		/* Writing 0xff means "don't care" or "match all".  */
-		mon = (mon <= 12) ? bin2bcd(mon) : 0xff;
-		mday = (mday >= 1 && mday <= 31) ? bin2bcd(mday) : 0xff;
-		hrs = (hrs < 24) ? bin2bcd(hrs) : 0xff;
-		min = (min < 60) ? bin2bcd(min) : 0xff;
-		sec = (sec < 60) ? bin2bcd(sec) : 0xff;
-	}
-
-	spin_lock_irq(&rtc_lock);
-
-	/* next rtc irq must not be from previous alarm setting */
-	cmos_irq_disable(cmos, RTC_AIE);
-
-	/* update alarm */
-	CMOS_WRITE(hrs, RTC_HOURS_ALARM);
-	CMOS_WRITE(min, RTC_MINUTES_ALARM);
-	CMOS_WRITE(sec, RTC_SECONDS_ALARM);
-
-	/* the system may support an "enhanced" alarm */
-	if (cmos->day_alrm) {
-		CMOS_WRITE(mday, cmos->day_alrm);
-		if (cmos->mon_alrm)
-			CMOS_WRITE(mon, cmos->mon_alrm);
-	}
-
-	if (use_hpet_alarm()) {
-		/*
-		 * FIXME the HPET alarm glue currently ignores day_alrm
-		 * and mon_alrm ...
-		 */
-		hpet_set_alarm_time(t->time.tm_hour, t->time.tm_min,
-				    t->time.tm_sec);
+		p.mon = (p.mon <= 12) ? bin2bcd(p.mon) : 0xff;
+		p.mday = (p.mday >= 1 && p.mday <= 31) ? bin2bcd(p.mday) : 0xff;
+		p.hrs = (p.hrs < 24) ? bin2bcd(p.hrs) : 0xff;
+		p.min = (p.min < 60) ? bin2bcd(p.min) : 0xff;
+		p.sec = (p.sec < 60) ? bin2bcd(p.sec) : 0xff;
 	}
 
-	if (t->enabled)
-		cmos_irq_enable(cmos, RTC_AIE);
-
-	spin_unlock_irq(&rtc_lock);
+	/*
+	 * Some Intel chipsets disconnect the alarm registers when the clock
+	 * update is in progress - during this time writes fail silently.
+	 *
+	 * Use mc146818_avoid_UIP() to avoid this.
+	 */
+	if (!mc146818_avoid_UIP(cmos_set_alarm_callback, &p))
+		return -EIO;
 
 	cmos->alarm_expires = rtc_tm_to_time64(&t->time);
 
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index f3f5a87fe376..347655d24b5d 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -8,6 +8,76 @@
 #include <linux/acpi.h>
 #endif
 
+/*
+ * Execute a function while the UIP (Update-in-progress) bit of the RTC is
+ * unset.
+ *
+ * Warning: callback may be executed more then once.
+ */
+bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
+			void *param)
+{
+	int i;
+	unsigned long flags;
+	unsigned char seconds;
+
+	for (i = 0; i < 10; i++) {
+		spin_lock_irqsave(&rtc_lock, flags);
+
+		/*
+		 * Check whether there is an update in progress during which the
+		 * readout is unspecified. The maximum update time is ~2ms. Poll
+		 * every msec for completion.
+		 *
+		 * Store the second value before checking UIP so a long lasting
+		 * NMI which happens to hit after the UIP check cannot make
+		 * an update cycle invisible.
+		 */
+		seconds = CMOS_READ(RTC_SECONDS);
+
+		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			mdelay(1);
+			continue;
+		}
+
+		/* Revalidate the above readout */
+		if (seconds != CMOS_READ(RTC_SECONDS)) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			continue;
+		}
+
+		if (callback)
+			callback(seconds, param);
+
+		/*
+		 * Check for the UIP bit again. If it is set now then
+		 * the above values may contain garbage.
+		 */
+		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			mdelay(1);
+			continue;
+		}
+
+		/*
+		 * A NMI might have interrupted the above sequence so check
+		 * whether the seconds value has changed which indicates that
+		 * the NMI took longer than the UIP bit was set. Unlikely, but
+		 * possible and there is also virt...
+		 */
+		if (seconds != CMOS_READ(RTC_SECONDS)) {
+			spin_unlock_irqrestore(&rtc_lock, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&rtc_lock, flags);
+
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(mc146818_avoid_UIP);
+
 /*
  * If the UIP (Update-in-progress) bit of the RTC is set for more then
  * 10ms, the RTC is apparently broken or not present.
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index dc6c00768d91..d694e3ff8086 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -661,13 +661,13 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "andelmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(ntfy_mac));
 	} else {
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
 					 card->dev, &info.info, NULL);
 		QETH_CARD_TEXT(card, 4, "anaddmac");
 		QETH_CARD_TEXT_(card, 4,
-				"mc%012lx", ether_addr_to_u64(ntfy_mac));
+				"mc%012llx", ether_addr_to_u64(ntfy_mac));
 	}
 }
 
@@ -764,9 +764,8 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	struct list_head *iter;
 	int err = 0;
 
-	kfree(br2dev_event_work);
-	QETH_CARD_TEXT_(card, 4, "b2dw%04x", event);
-	QETH_CARD_TEXT_(card, 4, "ma%012lx", ether_addr_to_u64(addr));
+	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
+	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
 
 	rcu_read_lock();
 	/* Verify preconditions are still valid: */
@@ -795,7 +794,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 				if (err) {
 					QETH_CARD_TEXT(card, 2, "b2derris");
 					QETH_CARD_TEXT_(card, 2,
-							"err%02x%03d", event,
+							"err%02lx%03d", event,
 							lowerdev->ifindex);
 				}
 			}
@@ -813,7 +812,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 			break;
 		}
 		if (err)
-			QETH_CARD_TEXT_(card, 2, "b2derr%02x", event);
+			QETH_CARD_TEXT_(card, 2, "b2derr%02lx", event);
 	}
 
 unlock:
@@ -821,6 +820,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	dev_put(brdev);
 	dev_put(lsyncdev);
 	dev_put(dstdev);
+	kfree(br2dev_event_work);
 }
 
 static int qeth_l2_br2dev_queue_work(struct net_device *brdev,
@@ -878,7 +878,7 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 	while (lowerdev) {
 		if (qeth_l2_must_learn(lowerdev, dstdev)) {
 			card = lowerdev->ml_priv;
-			QETH_CARD_TEXT_(card, 4, "b2dqw%03x", event);
+			QETH_CARD_TEXT_(card, 4, "b2dqw%03lx", event);
 			rc = qeth_l2_br2dev_queue_work(brdev, lowerdev,
 						       dstdev, event,
 						       fdb_info->addr);
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 89ee033f0c35..bbb57b9f6e01 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1285,6 +1285,7 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 	cdns->msg_count = 0;
 
 	bus->link_id = auxdev->id;
+	bus->clk_stop_timeout = 1;
 
 	sdw_cdns_probe(cdns);
 
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 2ca19b01948a..49acba1dea1e 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -912,14 +912,20 @@ static int mtk_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct mtk_spi *mdata = spi_master_get_devdata(master);
+	int ret;
 
-	pm_runtime_disable(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
+		return ret;
 
 	mtk_spi_reset(mdata);
 
 	if (mdata->dev_comp->no_need_unprepare)
 		clk_unprepare(mdata->spi_clk);
 
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dfa1d9eedde1..4812ba4bbedd 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -291,7 +291,8 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 	 *
 	 * DWC_usb3 3.30a and DWC_usb31 1.90a programming guide section 3.2.2
 	 */
-	if (dwc->gadget->speed <= USB_SPEED_HIGH) {
+	if (dwc->gadget->speed <= USB_SPEED_HIGH ||
+	    DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_ENDTRANSFER) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
 		if (unlikely(reg & DWC3_GUSB2PHYCFG_SUSPHY)) {
 			saved_config |= DWC3_GUSB2PHYCFG_SUSPHY;
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index e035a63bbe5b..1f37904b0405 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -601,7 +601,7 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		if (scr_readw(r) != vc->vc_video_erase_char)
 			break;
 	if (r != q && new_rows >= rows + logo_lines) {
-		save = kmalloc(array3_size(logo_lines, new_cols, 2),
+		save = kzalloc(array3_size(logo_lines, new_cols, 2),
 			       GFP_KERNEL);
 		if (save) {
 			int i = cols < new_cols ? cols : new_cols;
diff --git a/fs/Makefile b/fs/Makefile
index 84c5e4cdfee5..d504be65a210 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -32,8 +32,6 @@ obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
 obj-$(CONFIG_AIO)               += aio.o
-obj-$(CONFIG_IO_URING)		+= io_uring.o
-obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FS_VERITY)		+= verity/
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 4d2c6ce29fe5..9250a17731bd 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5398,6 +5398,7 @@ static int clone_range(struct send_ctx *sctx,
 		u64 ext_len;
 		u64 clone_len;
 		u64 clone_data_offset;
+		bool crossed_src_i_size = false;
 
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(clone_root->root, path);
@@ -5454,8 +5455,10 @@ static int clone_range(struct send_ctx *sctx,
 		if (key.offset >= clone_src_i_size)
 			break;
 
-		if (key.offset + ext_len > clone_src_i_size)
+		if (key.offset + ext_len > clone_src_i_size) {
 			ext_len = clone_src_i_size - key.offset;
+			crossed_src_i_size = true;
+		}
 
 		clone_data_offset = btrfs_file_extent_offset(leaf, ei);
 		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
@@ -5515,6 +5518,25 @@ static int clone_range(struct send_ctx *sctx,
 				ret = send_clone(sctx, offset, clone_len,
 						 clone_root);
 			}
+		} else if (crossed_src_i_size && clone_len < len) {
+			/*
+			 * If we are at i_size of the clone source inode and we
+			 * can not clone from it, terminate the loop. This is
+			 * to avoid sending two write operations, one with a
+			 * length matching clone_len and the final one after
+			 * this loop with a length of len - clone_len.
+			 *
+			 * When using encoded writes (BTRFS_SEND_FLAG_COMPRESSED
+			 * was passed to the send ioctl), this helps avoid
+			 * sending an encoded write for an offset that is not
+			 * sector size aligned, in case the i_size of the source
+			 * inode is not sector size aligned. That will make the
+			 * receiver fallback to decompression of the data and
+			 * writing it using regular buffered IO, therefore while
+			 * not incorrect, it's not optimal due decompression and
+			 * possible re-compression at the receiver.
+			 */
+			break;
 		} else {
 			ret = send_extent_data(sctx, offset, clone_len);
 		}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c6e2a0ff8f0c..a4284c4d7e03 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1392,6 +1392,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 	kfree(server->hostname);
+	server->hostname = NULL;
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
diff --git a/fs/file.c b/fs/file.c
index ee9317346702..214364e19d76 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1029,7 +1029,16 @@ static unsigned long __fget_light(unsigned int fd, fmode_t mask)
 	struct files_struct *files = current->files;
 	struct file *file;
 
-	if (atomic_read(&files->count) == 1) {
+	/*
+	 * If another thread is concurrently calling close_fd() followed
+	 * by put_files_struct(), we must not observe the old table
+	 * entry combined with the new refcount - otherwise we could
+	 * return a file that is concurrently being freed.
+	 *
+	 * atomic_read_acquire() pairs with atomic_dec_and_test() in
+	 * put_files_struct().
+	 */
+	if (atomic_read_acquire(&files->count) == 1) {
 		file = files_lookup_fd_raw(files, fd);
 		if (!file || unlikely(file->f_mode & mask))
 			return 0;
diff --git a/fs/io-wq.c b/fs/io-wq.c
deleted file mode 100644
index 6031fb319d87..000000000000
--- a/fs/io-wq.c
+++ /dev/null
@@ -1,1398 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Basic worker thread pool for io_uring
- *
- * Copyright (C) 2019 Jens Axboe
- *
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/sched/signal.h>
-#include <linux/percpu.h>
-#include <linux/slab.h>
-#include <linux/rculist_nulls.h>
-#include <linux/cpu.h>
-#include <linux/tracehook.h>
-#include <uapi/linux/io_uring.h>
-
-#include "io-wq.h"
-
-#define WORKER_IDLE_TIMEOUT	(5 * HZ)
-
-enum {
-	IO_WORKER_F_UP		= 1,	/* up and active */
-	IO_WORKER_F_RUNNING	= 2,	/* account as running */
-	IO_WORKER_F_FREE	= 4,	/* worker on free list */
-	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
-};
-
-enum {
-	IO_WQ_BIT_EXIT		= 0,	/* wq exiting */
-};
-
-enum {
-	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
-};
-
-/*
- * One for each thread in a wqe pool
- */
-struct io_worker {
-	refcount_t ref;
-	unsigned flags;
-	struct hlist_nulls_node nulls_node;
-	struct list_head all_list;
-	struct task_struct *task;
-	struct io_wqe *wqe;
-
-	struct io_wq_work *cur_work;
-	spinlock_t lock;
-
-	struct completion ref_done;
-
-	unsigned long create_state;
-	struct callback_head create_work;
-	int create_index;
-
-	union {
-		struct rcu_head rcu;
-		struct work_struct work;
-	};
-};
-
-#if BITS_PER_LONG == 64
-#define IO_WQ_HASH_ORDER	6
-#else
-#define IO_WQ_HASH_ORDER	5
-#endif
-
-#define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
-
-struct io_wqe_acct {
-	unsigned nr_workers;
-	unsigned max_workers;
-	int index;
-	atomic_t nr_running;
-	struct io_wq_work_list work_list;
-	unsigned long flags;
-};
-
-enum {
-	IO_WQ_ACCT_BOUND,
-	IO_WQ_ACCT_UNBOUND,
-	IO_WQ_ACCT_NR,
-};
-
-/*
- * Per-node worker thread pool
- */
-struct io_wqe {
-	raw_spinlock_t lock;
-	struct io_wqe_acct acct[2];
-
-	int node;
-
-	struct hlist_nulls_head free_list;
-	struct list_head all_list;
-
-	struct wait_queue_entry wait;
-
-	struct io_wq *wq;
-	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
-
-	cpumask_var_t cpu_mask;
-};
-
-/*
- * Per io_wq state
-  */
-struct io_wq {
-	unsigned long state;
-
-	free_work_fn *free_work;
-	io_wq_work_fn *do_work;
-
-	struct io_wq_hash *hash;
-
-	atomic_t worker_refs;
-	struct completion worker_done;
-
-	struct hlist_node cpuhp_node;
-
-	struct task_struct *task;
-
-	struct io_wqe *wqes[];
-};
-
-static enum cpuhp_state io_wq_online;
-
-struct io_cb_cancel_data {
-	work_cancel_fn *fn;
-	void *data;
-	int nr_running;
-	int nr_pending;
-	bool cancel_all;
-};
-
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
-static void io_wqe_dec_running(struct io_worker *worker);
-static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
-					struct io_wqe_acct *acct,
-					struct io_cb_cancel_data *match);
-static void create_worker_cb(struct callback_head *cb);
-static void io_wq_cancel_tw_create(struct io_wq *wq);
-
-static bool io_worker_get(struct io_worker *worker)
-{
-	return refcount_inc_not_zero(&worker->ref);
-}
-
-static void io_worker_release(struct io_worker *worker)
-{
-	if (refcount_dec_and_test(&worker->ref))
-		complete(&worker->ref_done);
-}
-
-static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
-{
-	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
-}
-
-static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
-						   struct io_wq_work *work)
-{
-	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
-}
-
-static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
-{
-	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
-}
-
-static void io_worker_ref_put(struct io_wq *wq)
-{
-	if (atomic_dec_and_test(&wq->worker_refs))
-		complete(&wq->worker_done);
-}
-
-static void io_worker_cancel_cb(struct io_worker *worker)
-{
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
-
-	atomic_dec(&acct->nr_running);
-	raw_spin_lock(&worker->wqe->lock);
-	acct->nr_workers--;
-	raw_spin_unlock(&worker->wqe->lock);
-	io_worker_ref_put(wq);
-	clear_bit_unlock(0, &worker->create_state);
-	io_worker_release(worker);
-}
-
-static bool io_task_worker_match(struct callback_head *cb, void *data)
-{
-	struct io_worker *worker;
-
-	if (cb->func != create_worker_cb)
-		return false;
-	worker = container_of(cb, struct io_worker, create_work);
-	return worker == data;
-}
-
-static void io_worker_exit(struct io_worker *worker)
-{
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
-
-	while (1) {
-		struct callback_head *cb = task_work_cancel_match(wq->task,
-						io_task_worker_match, worker);
-
-		if (!cb)
-			break;
-		io_worker_cancel_cb(worker);
-	}
-
-	if (refcount_dec_and_test(&worker->ref))
-		complete(&worker->ref_done);
-	wait_for_completion(&worker->ref_done);
-
-	raw_spin_lock(&wqe->lock);
-	if (worker->flags & IO_WORKER_F_FREE)
-		hlist_nulls_del_rcu(&worker->nulls_node);
-	list_del_rcu(&worker->all_list);
-	preempt_disable();
-	io_wqe_dec_running(worker);
-	worker->flags = 0;
-	current->flags &= ~PF_IO_WORKER;
-	preempt_enable();
-	raw_spin_unlock(&wqe->lock);
-
-	kfree_rcu(worker, rcu);
-	io_worker_ref_put(wqe->wq);
-	do_exit(0);
-}
-
-static inline bool io_acct_run_queue(struct io_wqe_acct *acct)
-{
-	if (!wq_list_empty(&acct->work_list) &&
-	    !test_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-		return true;
-	return false;
-}
-
-/*
- * Check head of free list for an available worker. If one isn't available,
- * caller must create one.
- */
-static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
-					struct io_wqe_acct *acct)
-	__must_hold(RCU)
-{
-	struct hlist_nulls_node *n;
-	struct io_worker *worker;
-
-	/*
-	 * Iterate free_list and see if we can find an idle worker to
-	 * activate. If a given worker is on the free_list but in the process
-	 * of exiting, keep trying.
-	 */
-	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
-		if (!io_worker_get(worker))
-			continue;
-		if (io_wqe_get_acct(worker) != acct) {
-			io_worker_release(worker);
-			continue;
-		}
-		if (wake_up_process(worker->task)) {
-			io_worker_release(worker);
-			return true;
-		}
-		io_worker_release(worker);
-	}
-
-	return false;
-}
-
-/*
- * We need a worker. If we find a free one, we're good. If not, and we're
- * below the max number of workers, create one.
- */
-static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
-{
-	/*
-	 * Most likely an attempt to queue unbounded work on an io_wq that
-	 * wasn't setup with any unbounded workers.
-	 */
-	if (unlikely(!acct->max_workers))
-		pr_warn_once("io-wq is not configured for unbound workers");
-
-	raw_spin_lock(&wqe->lock);
-	if (acct->nr_workers >= acct->max_workers) {
-		raw_spin_unlock(&wqe->lock);
-		return true;
-	}
-	acct->nr_workers++;
-	raw_spin_unlock(&wqe->lock);
-	atomic_inc(&acct->nr_running);
-	atomic_inc(&wqe->wq->worker_refs);
-	return create_io_worker(wqe->wq, wqe, acct->index);
-}
-
-static void io_wqe_inc_running(struct io_worker *worker)
-{
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-
-	atomic_inc(&acct->nr_running);
-}
-
-static void create_worker_cb(struct callback_head *cb)
-{
-	struct io_worker *worker;
-	struct io_wq *wq;
-	struct io_wqe *wqe;
-	struct io_wqe_acct *acct;
-	bool do_create = false;
-
-	worker = container_of(cb, struct io_worker, create_work);
-	wqe = worker->wqe;
-	wq = wqe->wq;
-	acct = &wqe->acct[worker->create_index];
-	raw_spin_lock(&wqe->lock);
-	if (acct->nr_workers < acct->max_workers) {
-		acct->nr_workers++;
-		do_create = true;
-	}
-	raw_spin_unlock(&wqe->lock);
-	if (do_create) {
-		create_io_worker(wq, wqe, worker->create_index);
-	} else {
-		atomic_dec(&acct->nr_running);
-		io_worker_ref_put(wq);
-	}
-	clear_bit_unlock(0, &worker->create_state);
-	io_worker_release(worker);
-}
-
-static bool io_queue_worker_create(struct io_worker *worker,
-				   struct io_wqe_acct *acct,
-				   task_work_func_t func)
-{
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
-
-	/* raced with exit, just ignore create call */
-	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
-		goto fail;
-	if (!io_worker_get(worker))
-		goto fail;
-	/*
-	 * create_state manages ownership of create_work/index. We should
-	 * only need one entry per worker, as the worker going to sleep
-	 * will trigger the condition, and waking will clear it once it
-	 * runs the task_work.
-	 */
-	if (test_bit(0, &worker->create_state) ||
-	    test_and_set_bit_lock(0, &worker->create_state))
-		goto fail_release;
-
-	atomic_inc(&wq->worker_refs);
-	init_task_work(&worker->create_work, func);
-	worker->create_index = acct->index;
-	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
-		/*
-		 * EXIT may have been set after checking it above, check after
-		 * adding the task_work and remove any creation item if it is
-		 * now set. wq exit does that too, but we can have added this
-		 * work item after we canceled in io_wq_exit_workers().
-		 */
-		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
-			io_wq_cancel_tw_create(wq);
-		io_worker_ref_put(wq);
-		return true;
-	}
-	io_worker_ref_put(wq);
-	clear_bit_unlock(0, &worker->create_state);
-fail_release:
-	io_worker_release(worker);
-fail:
-	atomic_dec(&acct->nr_running);
-	io_worker_ref_put(wq);
-	return false;
-}
-
-static void io_wqe_dec_running(struct io_worker *worker)
-	__must_hold(wqe->lock)
-{
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
-
-	if (!(worker->flags & IO_WORKER_F_UP))
-		return;
-
-	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
-		atomic_inc(&acct->nr_running);
-		atomic_inc(&wqe->wq->worker_refs);
-		raw_spin_unlock(&wqe->lock);
-		io_queue_worker_create(worker, acct, create_worker_cb);
-		raw_spin_lock(&wqe->lock);
-	}
-}
-
-/*
- * Worker will start processing some work. Move it to the busy list, if
- * it's currently on the freelist
- */
-static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
-			     struct io_wq_work *work)
-	__must_hold(wqe->lock)
-{
-	if (worker->flags & IO_WORKER_F_FREE) {
-		worker->flags &= ~IO_WORKER_F_FREE;
-		hlist_nulls_del_init_rcu(&worker->nulls_node);
-	}
-}
-
-/*
- * No work, worker going to sleep. Move to freelist, and unuse mm if we
- * have one attached. Dropping the mm may potentially sleep, so we drop
- * the lock in that case and return success. Since the caller has to
- * retry the loop in that case (we changed task state), we don't regrab
- * the lock if we return success.
- */
-static void __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
-	__must_hold(wqe->lock)
-{
-	if (!(worker->flags & IO_WORKER_F_FREE)) {
-		worker->flags |= IO_WORKER_F_FREE;
-		hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
-	}
-}
-
-static inline unsigned int io_get_work_hash(struct io_wq_work *work)
-{
-	return work->flags >> IO_WQ_HASH_SHIFT;
-}
-
-static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
-{
-	struct io_wq *wq = wqe->wq;
-	bool ret = false;
-
-	spin_lock_irq(&wq->hash->wait.lock);
-	if (list_empty(&wqe->wait.entry)) {
-		__add_wait_queue(&wq->hash->wait, &wqe->wait);
-		if (!test_bit(hash, &wq->hash->map)) {
-			__set_current_state(TASK_RUNNING);
-			list_del_init(&wqe->wait.entry);
-			ret = true;
-		}
-	}
-	spin_unlock_irq(&wq->hash->wait.lock);
-	return ret;
-}
-
-static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
-					   struct io_worker *worker)
-	__must_hold(wqe->lock)
-{
-	struct io_wq_work_node *node, *prev;
-	struct io_wq_work *work, *tail;
-	unsigned int stall_hash = -1U;
-	struct io_wqe *wqe = worker->wqe;
-
-	wq_list_for_each(node, prev, &acct->work_list) {
-		unsigned int hash;
-
-		work = container_of(node, struct io_wq_work, list);
-
-		/* not hashed, can run anytime */
-		if (!io_wq_is_hashed(work)) {
-			wq_list_del(&acct->work_list, node, prev);
-			return work;
-		}
-
-		hash = io_get_work_hash(work);
-		/* all items with this hash lie in [work, tail] */
-		tail = wqe->hash_tail[hash];
-
-		/* hashed, can run if not already running */
-		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
-			wqe->hash_tail[hash] = NULL;
-			wq_list_cut(&acct->work_list, &tail->list, prev);
-			return work;
-		}
-		if (stall_hash == -1U)
-			stall_hash = hash;
-		/* fast forward to a next hash, for-each will fix up @prev */
-		node = &tail->list;
-	}
-
-	if (stall_hash != -1U) {
-		bool unstalled;
-
-		/*
-		 * Set this before dropping the lock to avoid racing with new
-		 * work being added and clearing the stalled bit.
-		 */
-		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-		raw_spin_unlock(&wqe->lock);
-		unstalled = io_wait_on_hash(wqe, stall_hash);
-		raw_spin_lock(&wqe->lock);
-		if (unstalled) {
-			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-			if (wq_has_sleeper(&wqe->wq->hash->wait))
-				wake_up(&wqe->wq->hash->wait);
-		}
-	}
-
-	return NULL;
-}
-
-static bool io_flush_signals(void)
-{
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
-		__set_current_state(TASK_RUNNING);
-		tracehook_notify_signal();
-		return true;
-	}
-	return false;
-}
-
-static void io_assign_current_work(struct io_worker *worker,
-				   struct io_wq_work *work)
-{
-	if (work) {
-		io_flush_signals();
-		cond_resched();
-	}
-
-	spin_lock(&worker->lock);
-	worker->cur_work = work;
-	spin_unlock(&worker->lock);
-}
-
-static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
-
-static void io_worker_handle_work(struct io_worker *worker)
-	__releases(wqe->lock)
-{
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
-	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
-
-	do {
-		struct io_wq_work *work;
-get_next:
-		/*
-		 * If we got some work, mark us as busy. If we didn't, but
-		 * the list isn't empty, it means we stalled on hashed work.
-		 * Mark us stalled so we don't keep looking for work when we
-		 * can't make progress, any work completion or insertion will
-		 * clear the stalled flag.
-		 */
-		work = io_get_next_work(acct, worker);
-		if (work)
-			__io_worker_busy(wqe, worker, work);
-
-		raw_spin_unlock(&wqe->lock);
-		if (!work)
-			break;
-		io_assign_current_work(worker, work);
-		__set_current_state(TASK_RUNNING);
-
-		/* handle a whole dependent link */
-		do {
-			struct io_wq_work *next_hashed, *linked;
-			unsigned int hash = io_get_work_hash(work);
-
-			next_hashed = wq_next_work(work);
-
-			if (unlikely(do_kill) && (work->flags & IO_WQ_WORK_UNBOUND))
-				work->flags |= IO_WQ_WORK_CANCEL;
-			wq->do_work(work);
-			io_assign_current_work(worker, NULL);
-
-			linked = wq->free_work(work);
-			work = next_hashed;
-			if (!work && linked && !io_wq_is_hashed(linked)) {
-				work = linked;
-				linked = NULL;
-			}
-			io_assign_current_work(worker, work);
-			if (linked)
-				io_wqe_enqueue(wqe, linked);
-
-			if (hash != -1U && !next_hashed) {
-				/* serialize hash clear with wake_up() */
-				spin_lock_irq(&wq->hash->wait.lock);
-				clear_bit(hash, &wq->hash->map);
-				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-				spin_unlock_irq(&wq->hash->wait.lock);
-				if (wq_has_sleeper(&wq->hash->wait))
-					wake_up(&wq->hash->wait);
-				raw_spin_lock(&wqe->lock);
-				/* skip unnecessary unlock-lock wqe->lock */
-				if (!work)
-					goto get_next;
-				raw_spin_unlock(&wqe->lock);
-			}
-		} while (work);
-
-		raw_spin_lock(&wqe->lock);
-	} while (1);
-}
-
-static int io_wqe_worker(void *data)
-{
-	struct io_worker *worker = data;
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-	struct io_wqe *wqe = worker->wqe;
-	struct io_wq *wq = wqe->wq;
-	bool last_timeout = false;
-	char buf[TASK_COMM_LEN];
-
-	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
-
-	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
-	set_task_comm(current, buf);
-
-	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		long ret;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-loop:
-		raw_spin_lock(&wqe->lock);
-		if (io_acct_run_queue(acct)) {
-			io_worker_handle_work(worker);
-			goto loop;
-		}
-		/* timed out, exit unless we're the last worker */
-		if (last_timeout && acct->nr_workers > 1) {
-			acct->nr_workers--;
-			raw_spin_unlock(&wqe->lock);
-			__set_current_state(TASK_RUNNING);
-			break;
-		}
-		last_timeout = false;
-		__io_worker_idle(wqe, worker);
-		raw_spin_unlock(&wqe->lock);
-		if (io_flush_signals())
-			continue;
-		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
-		if (signal_pending(current)) {
-			struct ksignal ksig;
-
-			if (!get_signal(&ksig))
-				continue;
-			break;
-		}
-		last_timeout = !ret;
-	}
-
-	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		raw_spin_lock(&wqe->lock);
-		io_worker_handle_work(worker);
-	}
-
-	io_worker_exit(worker);
-	return 0;
-}
-
-/*
- * Called when a worker is scheduled in. Mark us as currently running.
- */
-void io_wq_worker_running(struct task_struct *tsk)
-{
-	struct io_worker *worker = tsk->pf_io_worker;
-
-	if (!worker)
-		return;
-	if (!(worker->flags & IO_WORKER_F_UP))
-		return;
-	if (worker->flags & IO_WORKER_F_RUNNING)
-		return;
-	worker->flags |= IO_WORKER_F_RUNNING;
-	io_wqe_inc_running(worker);
-}
-
-/*
- * Called when worker is going to sleep. If there are no workers currently
- * running and we have work pending, wake up a free one or create a new one.
- */
-void io_wq_worker_sleeping(struct task_struct *tsk)
-{
-	struct io_worker *worker = tsk->pf_io_worker;
-
-	if (!worker)
-		return;
-	if (!(worker->flags & IO_WORKER_F_UP))
-		return;
-	if (!(worker->flags & IO_WORKER_F_RUNNING))
-		return;
-
-	worker->flags &= ~IO_WORKER_F_RUNNING;
-
-	raw_spin_lock(&worker->wqe->lock);
-	io_wqe_dec_running(worker);
-	raw_spin_unlock(&worker->wqe->lock);
-}
-
-static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
-			       struct task_struct *tsk)
-{
-	tsk->pf_io_worker = worker;
-	worker->task = tsk;
-	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
-	tsk->flags |= PF_NO_SETAFFINITY;
-
-	raw_spin_lock(&wqe->lock);
-	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
-	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
-	worker->flags |= IO_WORKER_F_FREE;
-	raw_spin_unlock(&wqe->lock);
-	wake_up_new_task(tsk);
-}
-
-static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
-{
-	return true;
-}
-
-static inline bool io_should_retry_thread(long err)
-{
-	/*
-	 * Prevent perpetual task_work retry, if the task (or its group) is
-	 * exiting.
-	 */
-	if (fatal_signal_pending(current))
-		return false;
-
-	switch (err) {
-	case -EAGAIN:
-	case -ERESTARTSYS:
-	case -ERESTARTNOINTR:
-	case -ERESTARTNOHAND:
-		return true;
-	default:
-		return false;
-	}
-}
-
-static void create_worker_cont(struct callback_head *cb)
-{
-	struct io_worker *worker;
-	struct task_struct *tsk;
-	struct io_wqe *wqe;
-
-	worker = container_of(cb, struct io_worker, create_work);
-	clear_bit_unlock(0, &worker->create_state);
-	wqe = worker->wqe;
-	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
-	if (!IS_ERR(tsk)) {
-		io_init_new_worker(wqe, worker, tsk);
-		io_worker_release(worker);
-		return;
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
-		struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-
-		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&wqe->lock);
-		acct->nr_workers--;
-		if (!acct->nr_workers) {
-			struct io_cb_cancel_data match = {
-				.fn		= io_wq_work_match_all,
-				.cancel_all	= true,
-			};
-
-			while (io_acct_cancel_pending_work(wqe, acct, &match))
-				raw_spin_lock(&wqe->lock);
-		}
-		raw_spin_unlock(&wqe->lock);
-		io_worker_ref_put(wqe->wq);
-		kfree(worker);
-		return;
-	}
-
-	/* re-create attempts grab a new worker ref, drop the existing one */
-	io_worker_release(worker);
-	schedule_work(&worker->work);
-}
-
-static void io_workqueue_create(struct work_struct *work)
-{
-	struct io_worker *worker = container_of(work, struct io_worker, work);
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-
-	if (!io_queue_worker_create(worker, acct, create_worker_cont))
-		kfree(worker);
-}
-
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
-{
-	struct io_wqe_acct *acct = &wqe->acct[index];
-	struct io_worker *worker;
-	struct task_struct *tsk;
-
-	__set_current_state(TASK_RUNNING);
-
-	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
-	if (!worker) {
-fail:
-		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&wqe->lock);
-		acct->nr_workers--;
-		raw_spin_unlock(&wqe->lock);
-		io_worker_ref_put(wq);
-		return false;
-	}
-
-	refcount_set(&worker->ref, 1);
-	worker->wqe = wqe;
-	spin_lock_init(&worker->lock);
-	init_completion(&worker->ref_done);
-
-	if (index == IO_WQ_ACCT_BOUND)
-		worker->flags |= IO_WORKER_F_BOUND;
-
-	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
-	if (!IS_ERR(tsk)) {
-		io_init_new_worker(wqe, worker, tsk);
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
-		kfree(worker);
-		goto fail;
-	} else {
-		INIT_WORK(&worker->work, io_workqueue_create);
-		schedule_work(&worker->work);
-	}
-
-	return true;
-}
-
-/*
- * Iterate the passed in list and call the specific function for each
- * worker that isn't exiting
- */
-static bool io_wq_for_each_worker(struct io_wqe *wqe,
-				  bool (*func)(struct io_worker *, void *),
-				  void *data)
-{
-	struct io_worker *worker;
-	bool ret = false;
-
-	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
-		if (io_worker_get(worker)) {
-			/* no task if node is/was offline */
-			if (worker->task)
-				ret = func(worker, data);
-			io_worker_release(worker);
-			if (ret)
-				break;
-		}
-	}
-
-	return ret;
-}
-
-static bool io_wq_worker_wake(struct io_worker *worker, void *data)
-{
-	set_notify_signal(worker->task);
-	wake_up_process(worker->task);
-	return false;
-}
-
-static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
-{
-	struct io_wq *wq = wqe->wq;
-
-	do {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		wq->do_work(work);
-		work = wq->free_work(work);
-	} while (work);
-}
-
-static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
-{
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	unsigned int hash;
-	struct io_wq_work *tail;
-
-	if (!io_wq_is_hashed(work)) {
-append:
-		wq_list_add_tail(&work->list, &acct->work_list);
-		return;
-	}
-
-	hash = io_get_work_hash(work);
-	tail = wqe->hash_tail[hash];
-	wqe->hash_tail[hash] = work;
-	if (!tail)
-		goto append;
-
-	wq_list_add_after(&work->list, &tail->list, &acct->work_list);
-}
-
-static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
-{
-	return work == data;
-}
-
-static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
-{
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	unsigned work_flags = work->flags;
-	bool do_create;
-
-	/*
-	 * If io-wq is exiting for this task, or if the request has explicitly
-	 * been marked as one that should not get executed, cancel it here.
-	 */
-	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state) ||
-	    (work->flags & IO_WQ_WORK_CANCEL)) {
-		io_run_cancel(work, wqe);
-		return;
-	}
-
-	raw_spin_lock(&wqe->lock);
-	io_wqe_insert_work(wqe, work);
-	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-
-	rcu_read_lock();
-	do_create = !io_wqe_activate_free_worker(wqe, acct);
-	rcu_read_unlock();
-
-	raw_spin_unlock(&wqe->lock);
-
-	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))) {
-		bool did_create;
-
-		did_create = io_wqe_create_worker(wqe, acct);
-		if (likely(did_create))
-			return;
-
-		raw_spin_lock(&wqe->lock);
-		/* fatal condition, failed to create the first worker */
-		if (!acct->nr_workers) {
-			struct io_cb_cancel_data match = {
-				.fn		= io_wq_work_match_item,
-				.data		= work,
-				.cancel_all	= false,
-			};
-
-			if (io_acct_cancel_pending_work(wqe, acct, &match))
-				raw_spin_lock(&wqe->lock);
-		}
-		raw_spin_unlock(&wqe->lock);
-	}
-}
-
-void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
-{
-	struct io_wqe *wqe = wq->wqes[numa_node_id()];
-
-	io_wqe_enqueue(wqe, work);
-}
-
-/*
- * Work items that hash to the same value will not be done in parallel.
- * Used to limit concurrent writes, generally hashed by inode.
- */
-void io_wq_hash_work(struct io_wq_work *work, void *val)
-{
-	unsigned int bit;
-
-	bit = hash_ptr(val, IO_WQ_HASH_ORDER);
-	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
-}
-
-static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
-{
-	struct io_cb_cancel_data *match = data;
-
-	/*
-	 * Hold the lock to avoid ->cur_work going out of scope, caller
-	 * may dereference the passed in work.
-	 */
-	spin_lock(&worker->lock);
-	if (worker->cur_work &&
-	    match->fn(worker->cur_work, match->data)) {
-		set_notify_signal(worker->task);
-		match->nr_running++;
-	}
-	spin_unlock(&worker->lock);
-
-	return match->nr_running && !match->cancel_all;
-}
-
-static inline void io_wqe_remove_pending(struct io_wqe *wqe,
-					 struct io_wq_work *work,
-					 struct io_wq_work_node *prev)
-{
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	unsigned int hash = io_get_work_hash(work);
-	struct io_wq_work *prev_work = NULL;
-
-	if (io_wq_is_hashed(work) && work == wqe->hash_tail[hash]) {
-		if (prev)
-			prev_work = container_of(prev, struct io_wq_work, list);
-		if (prev_work && io_get_work_hash(prev_work) == hash)
-			wqe->hash_tail[hash] = prev_work;
-		else
-			wqe->hash_tail[hash] = NULL;
-	}
-	wq_list_del(&acct->work_list, &work->list, prev);
-}
-
-static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
-					struct io_wqe_acct *acct,
-					struct io_cb_cancel_data *match)
-	__releases(wqe->lock)
-{
-	struct io_wq_work_node *node, *prev;
-	struct io_wq_work *work;
-
-	wq_list_for_each(node, prev, &acct->work_list) {
-		work = container_of(node, struct io_wq_work, list);
-		if (!match->fn(work, match->data))
-			continue;
-		io_wqe_remove_pending(wqe, work, prev);
-		raw_spin_unlock(&wqe->lock);
-		io_run_cancel(work, wqe);
-		match->nr_pending++;
-		/* not safe to continue after unlock */
-		return true;
-	}
-
-	return false;
-}
-
-static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
-				       struct io_cb_cancel_data *match)
-{
-	int i;
-retry:
-	raw_spin_lock(&wqe->lock);
-	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
-
-		if (io_acct_cancel_pending_work(wqe, acct, match)) {
-			if (match->cancel_all)
-				goto retry;
-			return;
-		}
-	}
-	raw_spin_unlock(&wqe->lock);
-}
-
-static void io_wqe_cancel_running_work(struct io_wqe *wqe,
-				       struct io_cb_cancel_data *match)
-{
-	rcu_read_lock();
-	io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
-	rcu_read_unlock();
-}
-
-enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-				  void *data, bool cancel_all)
-{
-	struct io_cb_cancel_data match = {
-		.fn		= cancel,
-		.data		= data,
-		.cancel_all	= cancel_all,
-	};
-	int node;
-
-	/*
-	 * First check pending list, if we're lucky we can just remove it
-	 * from there. CANCEL_OK means that the work is returned as-new,
-	 * no completion will be posted for it.
-	 */
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		io_wqe_cancel_pending_work(wqe, &match);
-		if (match.nr_pending && !match.cancel_all)
-			return IO_WQ_CANCEL_OK;
-	}
-
-	/*
-	 * Now check if a free (going busy) or busy worker has the work
-	 * currently running. If we find it there, we'll return CANCEL_RUNNING
-	 * as an indication that we attempt to signal cancellation. The
-	 * completion will run normally in this case.
-	 */
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		io_wqe_cancel_running_work(wqe, &match);
-		if (match.nr_running && !match.cancel_all)
-			return IO_WQ_CANCEL_RUNNING;
-	}
-
-	if (match.nr_running)
-		return IO_WQ_CANCEL_RUNNING;
-	if (match.nr_pending)
-		return IO_WQ_CANCEL_OK;
-	return IO_WQ_CANCEL_NOTFOUND;
-}
-
-static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
-			    int sync, void *key)
-{
-	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
-	int i;
-
-	list_del_init(&wait->entry);
-
-	rcu_read_lock();
-	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = &wqe->acct[i];
-
-		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-			io_wqe_activate_free_worker(wqe, acct);
-	}
-	rcu_read_unlock();
-	return 1;
-}
-
-struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
-{
-	int ret, node, i;
-	struct io_wq *wq;
-
-	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
-		return ERR_PTR(-EINVAL);
-	if (WARN_ON_ONCE(!bounded))
-		return ERR_PTR(-EINVAL);
-
-	wq = kzalloc(struct_size(wq, wqes, nr_node_ids), GFP_KERNEL);
-	if (!wq)
-		return ERR_PTR(-ENOMEM);
-	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	if (ret)
-		goto err_wq;
-
-	refcount_inc(&data->hash->refs);
-	wq->hash = data->hash;
-	wq->free_work = data->free_work;
-	wq->do_work = data->do_work;
-
-	ret = -ENOMEM;
-	for_each_node(node) {
-		struct io_wqe *wqe;
-		int alloc_node = node;
-
-		if (!node_online(alloc_node))
-			alloc_node = NUMA_NO_NODE;
-		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
-		if (!wqe)
-			goto err;
-		wq->wqes[node] = wqe;
-		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
-			goto err;
-		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
-		wqe->node = alloc_node;
-		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
-		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
-					task_rlimit(current, RLIMIT_NPROC);
-		INIT_LIST_HEAD(&wqe->wait.entry);
-		wqe->wait.func = io_wqe_hash_wake;
-		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-			struct io_wqe_acct *acct = &wqe->acct[i];
-
-			acct->index = i;
-			atomic_set(&acct->nr_running, 0);
-			INIT_WQ_LIST(&acct->work_list);
-		}
-		wqe->wq = wq;
-		raw_spin_lock_init(&wqe->lock);
-		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
-		INIT_LIST_HEAD(&wqe->all_list);
-	}
-
-	wq->task = get_task_struct(data->task);
-	atomic_set(&wq->worker_refs, 1);
-	init_completion(&wq->worker_done);
-	return wq;
-err:
-	io_wq_put_hash(data->hash);
-	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	for_each_node(node) {
-		if (!wq->wqes[node])
-			continue;
-		free_cpumask_var(wq->wqes[node]->cpu_mask);
-		kfree(wq->wqes[node]);
-	}
-err_wq:
-	kfree(wq);
-	return ERR_PTR(ret);
-}
-
-static bool io_task_work_match(struct callback_head *cb, void *data)
-{
-	struct io_worker *worker;
-
-	if (cb->func != create_worker_cb && cb->func != create_worker_cont)
-		return false;
-	worker = container_of(cb, struct io_worker, create_work);
-	return worker->wqe->wq == data;
-}
-
-void io_wq_exit_start(struct io_wq *wq)
-{
-	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-}
-
-static void io_wq_cancel_tw_create(struct io_wq *wq)
-{
-	struct callback_head *cb;
-
-	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
-		struct io_worker *worker;
-
-		worker = container_of(cb, struct io_worker, create_work);
-		io_worker_cancel_cb(worker);
-	}
-}
-
-static void io_wq_exit_workers(struct io_wq *wq)
-{
-	int node;
-
-	if (!wq->task)
-		return;
-
-	io_wq_cancel_tw_create(wq);
-
-	rcu_read_lock();
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-
-		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
-	}
-	rcu_read_unlock();
-	io_worker_ref_put(wq);
-	wait_for_completion(&wq->worker_done);
-
-	for_each_node(node) {
-		spin_lock_irq(&wq->hash->wait.lock);
-		list_del_init(&wq->wqes[node]->wait.entry);
-		spin_unlock_irq(&wq->hash->wait.lock);
-	}
-	put_task_struct(wq->task);
-	wq->task = NULL;
-}
-
-static void io_wq_destroy(struct io_wq *wq)
-{
-	int node;
-
-	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-		struct io_cb_cancel_data match = {
-			.fn		= io_wq_work_match_all,
-			.cancel_all	= true,
-		};
-		io_wqe_cancel_pending_work(wqe, &match);
-		free_cpumask_var(wqe->cpu_mask);
-		kfree(wqe);
-	}
-	io_wq_put_hash(wq->hash);
-	kfree(wq);
-}
-
-void io_wq_put_and_exit(struct io_wq *wq)
-{
-	WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state));
-
-	io_wq_exit_workers(wq);
-	io_wq_destroy(wq);
-}
-
-struct online_data {
-	unsigned int cpu;
-	bool online;
-};
-
-static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
-{
-	struct online_data *od = data;
-
-	if (od->online)
-		cpumask_set_cpu(od->cpu, worker->wqe->cpu_mask);
-	else
-		cpumask_clear_cpu(od->cpu, worker->wqe->cpu_mask);
-	return false;
-}
-
-static int __io_wq_cpu_online(struct io_wq *wq, unsigned int cpu, bool online)
-{
-	struct online_data od = {
-		.cpu = cpu,
-		.online = online
-	};
-	int i;
-
-	rcu_read_lock();
-	for_each_node(i)
-		io_wq_for_each_worker(wq->wqes[i], io_wq_worker_affinity, &od);
-	rcu_read_unlock();
-	return 0;
-}
-
-static int io_wq_cpu_online(unsigned int cpu, struct hlist_node *node)
-{
-	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
-
-	return __io_wq_cpu_online(wq, cpu, true);
-}
-
-static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
-{
-	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
-
-	return __io_wq_cpu_online(wq, cpu, false);
-}
-
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
-{
-	int i;
-
-	rcu_read_lock();
-	for_each_node(i) {
-		struct io_wqe *wqe = wq->wqes[i];
-
-		if (mask)
-			cpumask_copy(wqe->cpu_mask, mask);
-		else
-			cpumask_copy(wqe->cpu_mask, cpumask_of_node(i));
-	}
-	rcu_read_unlock();
-	return 0;
-}
-
-/*
- * Set max number of unbounded workers, returns old value. If new_count is 0,
- * then just return the old value.
- */
-int io_wq_max_workers(struct io_wq *wq, int *new_count)
-{
-	int prev[IO_WQ_ACCT_NR];
-	bool first_node = true;
-	int i, node;
-
-	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
-	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
-	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
-
-	for (i = 0; i < 2; i++) {
-		if (new_count[i] > task_rlimit(current, RLIMIT_NPROC))
-			new_count[i] = task_rlimit(current, RLIMIT_NPROC);
-	}
-
-	for (i = 0; i < IO_WQ_ACCT_NR; i++)
-		prev[i] = 0;
-
-	rcu_read_lock();
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-		struct io_wqe_acct *acct;
-
-		raw_spin_lock(&wqe->lock);
-		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-			acct = &wqe->acct[i];
-			if (first_node)
-				prev[i] = max_t(int, acct->max_workers, prev[i]);
-			if (new_count[i])
-				acct->max_workers = new_count[i];
-		}
-		raw_spin_unlock(&wqe->lock);
-		first_node = false;
-	}
-	rcu_read_unlock();
-
-	for (i = 0; i < IO_WQ_ACCT_NR; i++)
-		new_count[i] = prev[i];
-
-	return 0;
-}
-
-static __init int io_wq_init(void)
-{
-	int ret;
-
-	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "io-wq/online",
-					io_wq_cpu_online, io_wq_cpu_offline);
-	if (ret < 0)
-		return ret;
-	io_wq_online = ret;
-	return 0;
-}
-subsys_initcall(io_wq_init);
diff --git a/fs/io-wq.h b/fs/io-wq.h
deleted file mode 100644
index bf5c4c533760..000000000000
--- a/fs/io-wq.h
+++ /dev/null
@@ -1,160 +0,0 @@
-#ifndef INTERNAL_IO_WQ_H
-#define INTERNAL_IO_WQ_H
-
-#include <linux/refcount.h>
-
-struct io_wq;
-
-enum {
-	IO_WQ_WORK_CANCEL	= 1,
-	IO_WQ_WORK_HASHED	= 2,
-	IO_WQ_WORK_UNBOUND	= 4,
-	IO_WQ_WORK_CONCURRENT	= 16,
-
-	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
-};
-
-enum io_wq_cancel {
-	IO_WQ_CANCEL_OK,	/* cancelled before started */
-	IO_WQ_CANCEL_RUNNING,	/* found, running, and attempted cancelled */
-	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
-};
-
-struct io_wq_work_node {
-	struct io_wq_work_node *next;
-};
-
-struct io_wq_work_list {
-	struct io_wq_work_node *first;
-	struct io_wq_work_node *last;
-};
-
-static inline void wq_list_add_after(struct io_wq_work_node *node,
-				     struct io_wq_work_node *pos,
-				     struct io_wq_work_list *list)
-{
-	struct io_wq_work_node *next = pos->next;
-
-	pos->next = node;
-	node->next = next;
-	if (!next)
-		list->last = node;
-}
-
-static inline void wq_list_add_tail(struct io_wq_work_node *node,
-				    struct io_wq_work_list *list)
-{
-	node->next = NULL;
-	if (!list->first) {
-		list->last = node;
-		WRITE_ONCE(list->first, node);
-	} else {
-		list->last->next = node;
-		list->last = node;
-	}
-}
-
-static inline void wq_list_cut(struct io_wq_work_list *list,
-			       struct io_wq_work_node *last,
-			       struct io_wq_work_node *prev)
-{
-	/* first in the list, if prev==NULL */
-	if (!prev)
-		WRITE_ONCE(list->first, last->next);
-	else
-		prev->next = last->next;
-
-	if (last == list->last)
-		list->last = prev;
-	last->next = NULL;
-}
-
-static inline void wq_list_del(struct io_wq_work_list *list,
-			       struct io_wq_work_node *node,
-			       struct io_wq_work_node *prev)
-{
-	wq_list_cut(list, node, prev);
-}
-
-#define wq_list_for_each(pos, prv, head)			\
-	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
-
-#define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
-#define INIT_WQ_LIST(list)	do {				\
-	(list)->first = NULL;					\
-	(list)->last = NULL;					\
-} while (0)
-
-struct io_wq_work {
-	struct io_wq_work_node list;
-	unsigned flags;
-};
-
-static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
-{
-	if (!work->list.next)
-		return NULL;
-
-	return container_of(work->list.next, struct io_wq_work, list);
-}
-
-typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
-typedef void (io_wq_work_fn)(struct io_wq_work *);
-
-struct io_wq_hash {
-	refcount_t refs;
-	unsigned long map;
-	struct wait_queue_head wait;
-};
-
-static inline void io_wq_put_hash(struct io_wq_hash *hash)
-{
-	if (refcount_dec_and_test(&hash->refs))
-		kfree(hash);
-}
-
-struct io_wq_data {
-	struct io_wq_hash *hash;
-	struct task_struct *task;
-	io_wq_work_fn *do_work;
-	free_work_fn *free_work;
-};
-
-struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
-void io_wq_exit_start(struct io_wq *wq);
-void io_wq_put_and_exit(struct io_wq *wq);
-
-void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
-void io_wq_hash_work(struct io_wq_work *work, void *val);
-
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
-int io_wq_max_workers(struct io_wq *wq, int *new_count);
-
-static inline bool io_wq_is_hashed(struct io_wq_work *work)
-{
-	return work->flags & IO_WQ_WORK_HASHED;
-}
-
-typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
-
-enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-					void *data, bool cancel_all);
-
-#if defined(CONFIG_IO_WQ)
-extern void io_wq_worker_sleeping(struct task_struct *);
-extern void io_wq_worker_running(struct task_struct *);
-#else
-static inline void io_wq_worker_sleeping(struct task_struct *tsk)
-{
-}
-static inline void io_wq_worker_running(struct task_struct *tsk)
-{
-}
-#endif
-
-static inline bool io_wq_current_is_worker(void)
-{
-	return in_task() && (current->flags & PF_IO_WORKER) &&
-		current->pf_io_worker;
-}
-#endif
diff --git a/fs/io_uring.c b/fs/io_uring.c
deleted file mode 100644
index c2fdde6fdda3..000000000000
--- a/fs/io_uring.c
+++ /dev/null
@@ -1,11110 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Shared application/kernel submission and completion ring pairs, for
- * supporting fast/efficient IO.
- *
- * A note on the read/write ordering memory barriers that are matched between
- * the application and kernel side.
- *
- * After the application reads the CQ ring tail, it must use an
- * appropriate smp_rmb() to pair with the smp_wmb() the kernel uses
- * before writing the tail (using smp_load_acquire to read the tail will
- * do). It also needs a smp_mb() before updating CQ head (ordering the
- * entry load(s) with the head store), pairing with an implicit barrier
- * through a control-dependency in io_get_cqe (smp_store_release to
- * store head will do). Failure to do so could lead to reading invalid
- * CQ entries.
- *
- * Likewise, the application must use an appropriate smp_wmb() before
- * writing the SQ tail (ordering SQ entry stores with the tail store),
- * which pairs with smp_load_acquire in io_get_sqring (smp_store_release
- * to store the tail will do). And it needs a barrier ordering the SQ
- * head load before writing new SQ entries (smp_load_acquire to read
- * head will do).
- *
- * When using the SQ poll thread (IORING_SETUP_SQPOLL), the application
- * needs to check the SQ flags for IORING_SQ_NEED_WAKEUP *after*
- * updating the SQ tail; a full memory barrier smp_mb() is needed
- * between.
- *
- * Also see the examples in the liburing library:
- *
- *	git://git.kernel.dk/liburing
- *
- * io_uring also uses READ/WRITE_ONCE() for _any_ store or load that happens
- * from data shared between the kernel and application. This is done both
- * for ordering purposes, but also to ensure that once a value is loaded from
- * data that the application could potentially modify, it remains stable.
- *
- * Copyright (C) 2018-2019 Jens Axboe
- * Copyright (c) 2018-2019 Christoph Hellwig
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/syscalls.h>
-#include <linux/compat.h>
-#include <net/compat.h>
-#include <linux/refcount.h>
-#include <linux/uio.h>
-#include <linux/bits.h>
-
-#include <linux/sched/signal.h>
-#include <linux/fs.h>
-#include <linux/file.h>
-#include <linux/fdtable.h>
-#include <linux/mm.h>
-#include <linux/mman.h>
-#include <linux/percpu.h>
-#include <linux/slab.h>
-#include <linux/blkdev.h>
-#include <linux/bvec.h>
-#include <linux/net.h>
-#include <net/sock.h>
-#include <net/af_unix.h>
-#include <net/scm.h>
-#include <linux/anon_inodes.h>
-#include <linux/sched/mm.h>
-#include <linux/uaccess.h>
-#include <linux/nospec.h>
-#include <linux/sizes.h>
-#include <linux/hugetlb.h>
-#include <linux/highmem.h>
-#include <linux/namei.h>
-#include <linux/fsnotify.h>
-#include <linux/fadvise.h>
-#include <linux/eventpoll.h>
-#include <linux/splice.h>
-#include <linux/task_work.h>
-#include <linux/pagemap.h>
-#include <linux/io_uring.h>
-#include <linux/tracehook.h>
-
-#define CREATE_TRACE_POINTS
-#include <trace/events/io_uring.h>
-
-#include <uapi/linux/io_uring.h>
-
-#include "internal.h"
-#include "io-wq.h"
-
-#define IORING_MAX_ENTRIES	32768
-#define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
-#define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
-
-/* only define max */
-#define IORING_MAX_FIXED_FILES	(1U << 15)
-#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
-				 IORING_REGISTER_LAST + IORING_OP_LAST)
-
-#define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
-#define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
-#define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
-
-#define IORING_MAX_REG_BUFFERS	(1U << 14)
-
-#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
-#define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
-
-#define IO_TCTX_REFS_CACHE_NR	(1U << 10)
-
-struct io_uring {
-	u32 head ____cacheline_aligned_in_smp;
-	u32 tail ____cacheline_aligned_in_smp;
-};
-
-/*
- * This data is shared with the application through the mmap at offsets
- * IORING_OFF_SQ_RING and IORING_OFF_CQ_RING.
- *
- * The offsets to the member fields are published through struct
- * io_sqring_offsets when calling io_uring_setup.
- */
-struct io_rings {
-	/*
-	 * Head and tail offsets into the ring; the offsets need to be
-	 * masked to get valid indices.
-	 *
-	 * The kernel controls head of the sq ring and the tail of the cq ring,
-	 * and the application controls tail of the sq ring and the head of the
-	 * cq ring.
-	 */
-	struct io_uring		sq, cq;
-	/*
-	 * Bitmasks to apply to head and tail offsets (constant, equals
-	 * ring_entries - 1)
-	 */
-	u32			sq_ring_mask, cq_ring_mask;
-	/* Ring sizes (constant, power of 2) */
-	u32			sq_ring_entries, cq_ring_entries;
-	/*
-	 * Number of invalid entries dropped by the kernel due to
-	 * invalid index stored in array
-	 *
-	 * Written by the kernel, shouldn't be modified by the
-	 * application (i.e. get number of "new events" by comparing to
-	 * cached value).
-	 *
-	 * After a new SQ head value was read by the application this
-	 * counter includes all submissions that were dropped reaching
-	 * the new SQ head (and possibly more).
-	 */
-	u32			sq_dropped;
-	/*
-	 * Runtime SQ flags
-	 *
-	 * Written by the kernel, shouldn't be modified by the
-	 * application.
-	 *
-	 * The application needs a full memory barrier before checking
-	 * for IORING_SQ_NEED_WAKEUP after updating the sq tail.
-	 */
-	u32			sq_flags;
-	/*
-	 * Runtime CQ flags
-	 *
-	 * Written by the application, shouldn't be modified by the
-	 * kernel.
-	 */
-	u32			cq_flags;
-	/*
-	 * Number of completion events lost because the queue was full;
-	 * this should be avoided by the application by making sure
-	 * there are not more requests pending than there is space in
-	 * the completion queue.
-	 *
-	 * Written by the kernel, shouldn't be modified by the
-	 * application (i.e. get number of "new events" by comparing to
-	 * cached value).
-	 *
-	 * As completion events come in out of order this counter is not
-	 * ordered with any other data.
-	 */
-	u32			cq_overflow;
-	/*
-	 * Ring buffer of completion events.
-	 *
-	 * The kernel writes completion events fresh every time they are
-	 * produced, so the application is allowed to modify pending
-	 * entries.
-	 */
-	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
-};
-
-enum io_uring_cmd_flags {
-	IO_URING_F_NONBLOCK		= 1,
-	IO_URING_F_COMPLETE_DEFER	= 2,
-};
-
-struct io_mapped_ubuf {
-	u64		ubuf;
-	u64		ubuf_end;
-	unsigned int	nr_bvecs;
-	unsigned long	acct_pages;
-	struct bio_vec	bvec[];
-};
-
-struct io_ring_ctx;
-
-struct io_overflow_cqe {
-	struct io_uring_cqe cqe;
-	struct list_head list;
-};
-
-struct io_fixed_file {
-	/* file * with additional FFS_* flags */
-	unsigned long file_ptr;
-};
-
-struct io_rsrc_put {
-	struct list_head list;
-	u64 tag;
-	union {
-		void *rsrc;
-		struct file *file;
-		struct io_mapped_ubuf *buf;
-	};
-};
-
-struct io_file_table {
-	struct io_fixed_file *files;
-};
-
-struct io_rsrc_node {
-	struct percpu_ref		refs;
-	struct list_head		node;
-	struct list_head		rsrc_list;
-	struct io_rsrc_data		*rsrc_data;
-	struct llist_node		llist;
-	bool				done;
-};
-
-typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
-
-struct io_rsrc_data {
-	struct io_ring_ctx		*ctx;
-
-	u64				**tags;
-	unsigned int			nr;
-	rsrc_put_fn			*do_put;
-	atomic_t			refs;
-	struct completion		done;
-	bool				quiesce;
-};
-
-struct io_buffer {
-	struct list_head list;
-	__u64 addr;
-	__u32 len;
-	__u16 bid;
-};
-
-struct io_restriction {
-	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
-	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
-	u8 sqe_flags_allowed;
-	u8 sqe_flags_required;
-	bool registered;
-};
-
-enum {
-	IO_SQ_THREAD_SHOULD_STOP = 0,
-	IO_SQ_THREAD_SHOULD_PARK,
-};
-
-struct io_sq_data {
-	refcount_t		refs;
-	atomic_t		park_pending;
-	struct mutex		lock;
-
-	/* ctx's that are using this sqd */
-	struct list_head	ctx_list;
-
-	struct task_struct	*thread;
-	struct wait_queue_head	wait;
-
-	unsigned		sq_thread_idle;
-	int			sq_cpu;
-	pid_t			task_pid;
-	pid_t			task_tgid;
-
-	unsigned long		state;
-	struct completion	exited;
-};
-
-#define IO_COMPL_BATCH			32
-#define IO_REQ_CACHE_SIZE		32
-#define IO_REQ_ALLOC_BATCH		8
-
-struct io_submit_link {
-	struct io_kiocb		*head;
-	struct io_kiocb		*last;
-};
-
-struct io_submit_state {
-	struct blk_plug		plug;
-	struct io_submit_link	link;
-
-	/*
-	 * io_kiocb alloc cache
-	 */
-	void			*reqs[IO_REQ_CACHE_SIZE];
-	unsigned int		free_reqs;
-
-	bool			plug_started;
-
-	/*
-	 * Batch completion logic
-	 */
-	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
-	unsigned int		compl_nr;
-	/* inline/task_work completion list, under ->uring_lock */
-	struct list_head	free_list;
-
-	unsigned int		ios_left;
-};
-
-struct io_ring_ctx {
-	/* const or read-mostly hot data */
-	struct {
-		struct percpu_ref	refs;
-
-		struct io_rings		*rings;
-		unsigned int		flags;
-		unsigned int		compat: 1;
-		unsigned int		drain_next: 1;
-		unsigned int		eventfd_async: 1;
-		unsigned int		restricted: 1;
-		unsigned int		off_timeout_used: 1;
-		unsigned int		drain_active: 1;
-	} ____cacheline_aligned_in_smp;
-
-	/* submission data */
-	struct {
-		struct mutex		uring_lock;
-
-		/*
-		 * Ring buffer of indices into array of io_uring_sqe, which is
-		 * mmapped by the application using the IORING_OFF_SQES offset.
-		 *
-		 * This indirection could e.g. be used to assign fixed
-		 * io_uring_sqe entries to operations and only submit them to
-		 * the queue when needed.
-		 *
-		 * The kernel modifies neither the indices array nor the entries
-		 * array.
-		 */
-		u32			*sq_array;
-		struct io_uring_sqe	*sq_sqes;
-		unsigned		cached_sq_head;
-		unsigned		sq_entries;
-		struct list_head	defer_list;
-
-		/*
-		 * Fixed resources fast path, should be accessed only under
-		 * uring_lock, and updated through io_uring_register(2)
-		 */
-		struct io_rsrc_node	*rsrc_node;
-		struct io_file_table	file_table;
-		unsigned		nr_user_files;
-		unsigned		nr_user_bufs;
-		struct io_mapped_ubuf	**user_bufs;
-
-		struct io_submit_state	submit_state;
-		struct list_head	timeout_list;
-		struct list_head	ltimeout_list;
-		struct list_head	cq_overflow_list;
-		struct xarray		io_buffers;
-		struct xarray		personalities;
-		u32			pers_next;
-		unsigned		sq_thread_idle;
-	} ____cacheline_aligned_in_smp;
-
-	/* IRQ completion list, under ->completion_lock */
-	struct list_head	locked_free_list;
-	unsigned int		locked_free_nr;
-
-	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
-	struct io_sq_data	*sq_data;	/* if using sq thread polling */
-
-	struct wait_queue_head	sqo_sq_wait;
-	struct list_head	sqd_list;
-
-	unsigned long		check_cq_overflow;
-
-	struct {
-		unsigned		cached_cq_tail;
-		unsigned		cq_entries;
-		struct eventfd_ctx	*cq_ev_fd;
-		struct wait_queue_head	poll_wait;
-		struct wait_queue_head	cq_wait;
-		unsigned		cq_extra;
-		atomic_t		cq_timeouts;
-		unsigned		cq_last_tm_flush;
-	} ____cacheline_aligned_in_smp;
-
-	struct {
-		spinlock_t		completion_lock;
-
-		spinlock_t		timeout_lock;
-
-		/*
-		 * ->iopoll_list is protected by the ctx->uring_lock for
-		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
-		 * For SQPOLL, only the single threaded io_sq_thread() will
-		 * manipulate the list, hence no extra locking is needed there.
-		 */
-		struct list_head	iopoll_list;
-		struct hlist_head	*cancel_hash;
-		unsigned		cancel_hash_bits;
-		bool			poll_multi_queue;
-	} ____cacheline_aligned_in_smp;
-
-	struct io_restriction		restrictions;
-
-	/* slow path rsrc auxilary data, used by update/register */
-	struct {
-		struct io_rsrc_node		*rsrc_backup_node;
-		struct io_mapped_ubuf		*dummy_ubuf;
-		struct io_rsrc_data		*file_data;
-		struct io_rsrc_data		*buf_data;
-
-		struct delayed_work		rsrc_put_work;
-		struct llist_head		rsrc_put_llist;
-		struct list_head		rsrc_ref_list;
-		spinlock_t			rsrc_ref_lock;
-	};
-
-	/* Keep this last, we don't need it for the fast path */
-	struct {
-		#if defined(CONFIG_UNIX)
-			struct socket		*ring_sock;
-		#endif
-		/* hashed buffered write serialization */
-		struct io_wq_hash		*hash_map;
-
-		/* Only used for accounting purposes */
-		struct user_struct		*user;
-		struct mm_struct		*mm_account;
-
-		/* ctx exit and cancelation */
-		struct llist_head		fallback_llist;
-		struct delayed_work		fallback_work;
-		struct work_struct		exit_work;
-		struct list_head		tctx_list;
-		struct completion		ref_comp;
-		u32				iowq_limits[2];
-		bool				iowq_limits_set;
-	};
-};
-
-struct io_uring_task {
-	/* submission side */
-	int			cached_refs;
-	struct xarray		xa;
-	struct wait_queue_head	wait;
-	const struct io_ring_ctx *last;
-	struct io_wq		*io_wq;
-	struct percpu_counter	inflight;
-	atomic_t		inflight_tracked;
-	atomic_t		in_idle;
-
-	spinlock_t		task_lock;
-	struct io_wq_work_list	task_list;
-	struct callback_head	task_work;
-	bool			task_running;
-};
-
-/*
- * First field must be the file pointer in all the
- * iocb unions! See also 'struct kiocb' in <linux/fs.h>
- */
-struct io_poll_iocb {
-	struct file			*file;
-	struct wait_queue_head		*head;
-	__poll_t			events;
-	struct wait_queue_entry		wait;
-};
-
-struct io_poll_update {
-	struct file			*file;
-	u64				old_user_data;
-	u64				new_user_data;
-	__poll_t			events;
-	bool				update_events;
-	bool				update_user_data;
-};
-
-struct io_close {
-	struct file			*file;
-	int				fd;
-	u32				file_slot;
-};
-
-struct io_timeout_data {
-	struct io_kiocb			*req;
-	struct hrtimer			timer;
-	struct timespec64		ts;
-	enum hrtimer_mode		mode;
-	u32				flags;
-};
-
-struct io_accept {
-	struct file			*file;
-	struct sockaddr __user		*addr;
-	int __user			*addr_len;
-	int				flags;
-	u32				file_slot;
-	unsigned long			nofile;
-};
-
-struct io_sync {
-	struct file			*file;
-	loff_t				len;
-	loff_t				off;
-	int				flags;
-	int				mode;
-};
-
-struct io_cancel {
-	struct file			*file;
-	u64				addr;
-};
-
-struct io_timeout {
-	struct file			*file;
-	u32				off;
-	u32				target_seq;
-	struct list_head		list;
-	/* head of the link, used by linked timeouts only */
-	struct io_kiocb			*head;
-	/* for linked completions */
-	struct io_kiocb			*prev;
-};
-
-struct io_timeout_rem {
-	struct file			*file;
-	u64				addr;
-
-	/* timeout update */
-	struct timespec64		ts;
-	u32				flags;
-	bool				ltimeout;
-};
-
-struct io_rw {
-	/* NOTE: kiocb has the file as the first member, so don't do it here */
-	struct kiocb			kiocb;
-	u64				addr;
-	u64				len;
-};
-
-struct io_connect {
-	struct file			*file;
-	struct sockaddr __user		*addr;
-	int				addr_len;
-};
-
-struct io_sr_msg {
-	struct file			*file;
-	union {
-		struct compat_msghdr __user	*umsg_compat;
-		struct user_msghdr __user	*umsg;
-		void __user			*buf;
-	};
-	int				msg_flags;
-	int				bgid;
-	size_t				len;
-	struct io_buffer		*kbuf;
-};
-
-struct io_open {
-	struct file			*file;
-	int				dfd;
-	u32				file_slot;
-	struct filename			*filename;
-	struct open_how			how;
-	unsigned long			nofile;
-};
-
-struct io_rsrc_update {
-	struct file			*file;
-	u64				arg;
-	u32				nr_args;
-	u32				offset;
-};
-
-struct io_fadvise {
-	struct file			*file;
-	u64				offset;
-	u32				len;
-	u32				advice;
-};
-
-struct io_madvise {
-	struct file			*file;
-	u64				addr;
-	u32				len;
-	u32				advice;
-};
-
-struct io_epoll {
-	struct file			*file;
-	int				epfd;
-	int				op;
-	int				fd;
-	struct epoll_event		event;
-};
-
-struct io_splice {
-	struct file			*file_out;
-	loff_t				off_out;
-	loff_t				off_in;
-	u64				len;
-	int				splice_fd_in;
-	unsigned int			flags;
-};
-
-struct io_provide_buf {
-	struct file			*file;
-	__u64				addr;
-	__u32				len;
-	__u32				bgid;
-	__u16				nbufs;
-	__u16				bid;
-};
-
-struct io_statx {
-	struct file			*file;
-	int				dfd;
-	unsigned int			mask;
-	unsigned int			flags;
-	const char __user		*filename;
-	struct statx __user		*buffer;
-};
-
-struct io_shutdown {
-	struct file			*file;
-	int				how;
-};
-
-struct io_rename {
-	struct file			*file;
-	int				old_dfd;
-	int				new_dfd;
-	struct filename			*oldpath;
-	struct filename			*newpath;
-	int				flags;
-};
-
-struct io_unlink {
-	struct file			*file;
-	int				dfd;
-	int				flags;
-	struct filename			*filename;
-};
-
-struct io_mkdir {
-	struct file			*file;
-	int				dfd;
-	umode_t				mode;
-	struct filename			*filename;
-};
-
-struct io_symlink {
-	struct file			*file;
-	int				new_dfd;
-	struct filename			*oldpath;
-	struct filename			*newpath;
-};
-
-struct io_hardlink {
-	struct file			*file;
-	int				old_dfd;
-	int				new_dfd;
-	struct filename			*oldpath;
-	struct filename			*newpath;
-	int				flags;
-};
-
-struct io_completion {
-	struct file			*file;
-	u32				cflags;
-};
-
-struct io_async_connect {
-	struct sockaddr_storage		address;
-};
-
-struct io_async_msghdr {
-	struct iovec			fast_iov[UIO_FASTIOV];
-	/* points to an allocated iov, if NULL we use fast_iov instead */
-	struct iovec			*free_iov;
-	struct sockaddr __user		*uaddr;
-	struct msghdr			msg;
-	struct sockaddr_storage		addr;
-};
-
-struct io_async_rw {
-	struct iovec			fast_iov[UIO_FASTIOV];
-	const struct iovec		*free_iovec;
-	struct iov_iter			iter;
-	struct iov_iter_state		iter_state;
-	size_t				bytes_done;
-	struct wait_page_queue		wpq;
-};
-
-enum {
-	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
-	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
-	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
-	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
-	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
-	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
-
-	/* first byte is taken by user flags, shift it to not overlap */
-	REQ_F_FAIL_BIT		= 8,
-	REQ_F_INFLIGHT_BIT,
-	REQ_F_CUR_POS_BIT,
-	REQ_F_NOWAIT_BIT,
-	REQ_F_LINK_TIMEOUT_BIT,
-	REQ_F_NEED_CLEANUP_BIT,
-	REQ_F_POLLED_BIT,
-	REQ_F_BUFFER_SELECTED_BIT,
-	REQ_F_COMPLETE_INLINE_BIT,
-	REQ_F_REISSUE_BIT,
-	REQ_F_CREDS_BIT,
-	REQ_F_REFCOUNT_BIT,
-	REQ_F_ARM_LTIMEOUT_BIT,
-	/* keep async read/write and isreg together and in order */
-	REQ_F_NOWAIT_READ_BIT,
-	REQ_F_NOWAIT_WRITE_BIT,
-	REQ_F_ISREG_BIT,
-
-	/* not a real bit, just to check we're not overflowing the space */
-	__REQ_F_LAST_BIT,
-};
-
-enum {
-	/* ctx owns file */
-	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),
-	/* drain existing IO first */
-	REQ_F_IO_DRAIN		= BIT(REQ_F_IO_DRAIN_BIT),
-	/* linked sqes */
-	REQ_F_LINK		= BIT(REQ_F_LINK_BIT),
-	/* doesn't sever on completion < 0 */
-	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
-	/* IOSQE_ASYNC */
-	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
-	/* IOSQE_BUFFER_SELECT */
-	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
-
-	/* fail rest of links */
-	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
-	/* on inflight list, should be cancelled and waited on exit reliably */
-	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
-	/* read/write uses file position */
-	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
-	/* must not punt to workers */
-	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
-	/* has or had linked timeout */
-	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
-	/* needs cleanup */
-	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
-	/* already went through poll handler */
-	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
-	/* buffer already selected */
-	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
-	/* completion is deferred through io_comp_state */
-	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
-	/* caller should reissue async */
-	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
-	/* supports async reads */
-	REQ_F_NOWAIT_READ	= BIT(REQ_F_NOWAIT_READ_BIT),
-	/* supports async writes */
-	REQ_F_NOWAIT_WRITE	= BIT(REQ_F_NOWAIT_WRITE_BIT),
-	/* regular file */
-	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
-	/* has creds assigned */
-	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
-	/* skip refcounting if not set */
-	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
-	/* there is a linked timeout that has to be armed */
-	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
-};
-
-struct async_poll {
-	struct io_poll_iocb	poll;
-	struct io_poll_iocb	*double_poll;
-};
-
-typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
-
-struct io_task_work {
-	union {
-		struct io_wq_work_node	node;
-		struct llist_node	fallback_node;
-	};
-	io_req_tw_func_t		func;
-};
-
-enum {
-	IORING_RSRC_FILE		= 0,
-	IORING_RSRC_BUFFER		= 1,
-};
-
-/*
- * NOTE! Each of the iocb union members has the file pointer
- * as the first entry in their struct definition. So you can
- * access the file pointer through any of the sub-structs,
- * or directly as just 'ki_filp' in this struct.
- */
-struct io_kiocb {
-	union {
-		struct file		*file;
-		struct io_rw		rw;
-		struct io_poll_iocb	poll;
-		struct io_poll_update	poll_update;
-		struct io_accept	accept;
-		struct io_sync		sync;
-		struct io_cancel	cancel;
-		struct io_timeout	timeout;
-		struct io_timeout_rem	timeout_rem;
-		struct io_connect	connect;
-		struct io_sr_msg	sr_msg;
-		struct io_open		open;
-		struct io_close		close;
-		struct io_rsrc_update	rsrc_update;
-		struct io_fadvise	fadvise;
-		struct io_madvise	madvise;
-		struct io_epoll		epoll;
-		struct io_splice	splice;
-		struct io_provide_buf	pbuf;
-		struct io_statx		statx;
-		struct io_shutdown	shutdown;
-		struct io_rename	rename;
-		struct io_unlink	unlink;
-		struct io_mkdir		mkdir;
-		struct io_symlink	symlink;
-		struct io_hardlink	hardlink;
-		/* use only after cleaning per-op data, see io_clean_op() */
-		struct io_completion	compl;
-	};
-
-	/* opcode allocated if it needs to store data for async defer */
-	void				*async_data;
-	u8				opcode;
-	/* polled IO has completed */
-	u8				iopoll_completed;
-
-	u16				buf_index;
-	u32				result;
-
-	struct io_ring_ctx		*ctx;
-	unsigned int			flags;
-	atomic_t			refs;
-	struct task_struct		*task;
-	u64				user_data;
-
-	struct io_kiocb			*link;
-	struct percpu_ref		*fixed_rsrc_refs;
-
-	/* used with ctx->iopoll_list with reads/writes */
-	struct list_head		inflight_entry;
-	struct io_task_work		io_task_work;
-	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-	struct hlist_node		hash_node;
-	struct async_poll		*apoll;
-	struct io_wq_work		work;
-	const struct cred		*creds;
-
-	/* store used ubuf, so we can prevent reloading */
-	struct io_mapped_ubuf		*imu;
-	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
-	struct io_buffer		*kbuf;
-	atomic_t			poll_refs;
-};
-
-struct io_tctx_node {
-	struct list_head	ctx_node;
-	struct task_struct	*task;
-	struct io_ring_ctx	*ctx;
-};
-
-struct io_defer_entry {
-	struct list_head	list;
-	struct io_kiocb		*req;
-	u32			seq;
-};
-
-struct io_op_def {
-	/* needs req->file assigned */
-	unsigned		needs_file : 1;
-	/* hash wq insertion if file is a regular file */
-	unsigned		hash_reg_file : 1;
-	/* unbound wq insertion if file is a non-regular file */
-	unsigned		unbound_nonreg_file : 1;
-	/* opcode is not supported by this kernel */
-	unsigned		not_supported : 1;
-	/* set if opcode supports polled "wait" */
-	unsigned		pollin : 1;
-	unsigned		pollout : 1;
-	/* op supports buffer selection */
-	unsigned		buffer_select : 1;
-	/* do prep async if is going to be punted */
-	unsigned		needs_async_setup : 1;
-	/* should block plug */
-	unsigned		plug : 1;
-	/* size of async data needed, if any */
-	unsigned short		async_size;
-};
-
-static const struct io_op_def io_op_defs[] = {
-	[IORING_OP_NOP] = {},
-	[IORING_OP_READV] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-		.needs_async_setup	= 1,
-		.plug			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_WRITEV] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.needs_async_setup	= 1,
-		.plug			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_FSYNC] = {
-		.needs_file		= 1,
-	},
-	[IORING_OP_READ_FIXED] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.plug			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_WRITE_FIXED] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.plug			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_POLL_ADD] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-	},
-	[IORING_OP_POLL_REMOVE] = {},
-	[IORING_OP_SYNC_FILE_RANGE] = {
-		.needs_file		= 1,
-	},
-	[IORING_OP_SENDMSG] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.needs_async_setup	= 1,
-		.async_size		= sizeof(struct io_async_msghdr),
-	},
-	[IORING_OP_RECVMSG] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-		.needs_async_setup	= 1,
-		.async_size		= sizeof(struct io_async_msghdr),
-	},
-	[IORING_OP_TIMEOUT] = {
-		.async_size		= sizeof(struct io_timeout_data),
-	},
-	[IORING_OP_TIMEOUT_REMOVE] = {
-		/* used by timeout updates' prep() */
-	},
-	[IORING_OP_ACCEPT] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-	},
-	[IORING_OP_ASYNC_CANCEL] = {},
-	[IORING_OP_LINK_TIMEOUT] = {
-		.async_size		= sizeof(struct io_timeout_data),
-	},
-	[IORING_OP_CONNECT] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.needs_async_setup	= 1,
-		.async_size		= sizeof(struct io_async_connect),
-	},
-	[IORING_OP_FALLOCATE] = {
-		.needs_file		= 1,
-	},
-	[IORING_OP_OPENAT] = {},
-	[IORING_OP_CLOSE] = {},
-	[IORING_OP_FILES_UPDATE] = {},
-	[IORING_OP_STATX] = {},
-	[IORING_OP_READ] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-		.plug			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_WRITE] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-		.plug			= 1,
-		.async_size		= sizeof(struct io_async_rw),
-	},
-	[IORING_OP_FADVISE] = {
-		.needs_file		= 1,
-	},
-	[IORING_OP_MADVISE] = {},
-	[IORING_OP_SEND] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollout		= 1,
-	},
-	[IORING_OP_RECV] = {
-		.needs_file		= 1,
-		.unbound_nonreg_file	= 1,
-		.pollin			= 1,
-		.buffer_select		= 1,
-	},
-	[IORING_OP_OPENAT2] = {
-	},
-	[IORING_OP_EPOLL_CTL] = {
-		.unbound_nonreg_file	= 1,
-	},
-	[IORING_OP_SPLICE] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-	},
-	[IORING_OP_PROVIDE_BUFFERS] = {},
-	[IORING_OP_REMOVE_BUFFERS] = {},
-	[IORING_OP_TEE] = {
-		.needs_file		= 1,
-		.hash_reg_file		= 1,
-		.unbound_nonreg_file	= 1,
-	},
-	[IORING_OP_SHUTDOWN] = {
-		.needs_file		= 1,
-	},
-	[IORING_OP_RENAMEAT] = {},
-	[IORING_OP_UNLINKAT] = {},
-	[IORING_OP_MKDIRAT] = {},
-	[IORING_OP_SYMLINKAT] = {},
-	[IORING_OP_LINKAT] = {},
-};
-
-/* requests with any of those set should undergo io_disarm_next() */
-#define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
-
-static bool io_disarm_next(struct io_kiocb *req);
-static void io_uring_del_tctx_node(unsigned long index);
-static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
-					 struct task_struct *task,
-					 bool cancel_all);
-static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
-
-static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
-
-static void io_put_req(struct io_kiocb *req);
-static void io_put_req_deferred(struct io_kiocb *req);
-static void io_dismantle_req(struct io_kiocb *req);
-static void io_queue_linked_timeout(struct io_kiocb *req);
-static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
-				     struct io_uring_rsrc_update2 *up,
-				     unsigned nr_args);
-static void io_clean_op(struct io_kiocb *req);
-static struct file *io_file_get(struct io_ring_ctx *ctx,
-				struct io_kiocb *req, int fd, bool fixed);
-static void __io_queue_sqe(struct io_kiocb *req);
-static void io_rsrc_put_work(struct work_struct *work);
-
-static void io_req_task_queue(struct io_kiocb *req);
-static void io_submit_flush_completions(struct io_ring_ctx *ctx);
-static int io_req_prep_async(struct io_kiocb *req);
-
-static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
-				 unsigned int issue_flags, u32 slot_index);
-static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
-
-static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
-
-static struct kmem_cache *req_cachep;
-
-static const struct file_operations io_uring_fops;
-
-struct sock *io_uring_get_socket(struct file *file)
-{
-#if defined(CONFIG_UNIX)
-	if (file->f_op == &io_uring_fops) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		return ctx->ring_sock->sk;
-	}
-#endif
-	return NULL;
-}
-EXPORT_SYMBOL(io_uring_get_socket);
-
-static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
-{
-	if (!*locked) {
-		mutex_lock(&ctx->uring_lock);
-		*locked = true;
-	}
-}
-
-#define io_for_each_link(pos, head) \
-	for (pos = (head); pos; pos = pos->link)
-
-/*
- * Shamelessly stolen from the mm implementation of page reference checking,
- * see commit f958d7b528b1 for details.
- */
-#define req_ref_zero_or_close_to_overflow(req)	\
-	((unsigned int) atomic_read(&(req->refs)) + 127u <= 127u)
-
-static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
-	return atomic_inc_not_zero(&req->refs);
-}
-
-static inline bool req_ref_put_and_test(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & REQ_F_REFCOUNT)))
-		return true;
-
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	return atomic_dec_and_test(&req->refs);
-}
-
-static inline void req_ref_get(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
-	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
-	atomic_inc(&req->refs);
-}
-
-static inline void __io_req_set_refcount(struct io_kiocb *req, int nr)
-{
-	if (!(req->flags & REQ_F_REFCOUNT)) {
-		req->flags |= REQ_F_REFCOUNT;
-		atomic_set(&req->refs, nr);
-	}
-}
-
-static inline void io_req_set_refcount(struct io_kiocb *req)
-{
-	__io_req_set_refcount(req, 1);
-}
-
-static inline void io_req_set_rsrc_node(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
-		percpu_ref_get(req->fixed_rsrc_refs);
-	}
-}
-
-static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
-{
-	bool got = percpu_ref_tryget(ref);
-
-	/* already at zero, wait for ->release() */
-	if (!got)
-		wait_for_completion(compl);
-	percpu_ref_resurrect(ref);
-	if (got)
-		percpu_ref_put(ref);
-}
-
-static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
-			  bool cancel_all)
-	__must_hold(&req->ctx->timeout_lock)
-{
-	struct io_kiocb *req;
-
-	if (task && head->task != task)
-		return false;
-	if (cancel_all)
-		return true;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
-}
-
-static bool io_match_linked(struct io_kiocb *head)
-{
-	struct io_kiocb *req;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
-}
-
-/*
- * As io_match_task() but protected against racing with linked timeouts.
- * User must not hold timeout_lock.
- */
-static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
-			       bool cancel_all)
-{
-	bool matched;
-
-	if (task && head->task != task)
-		return false;
-	if (cancel_all)
-		return true;
-
-	if (head->flags & REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = head->ctx;
-
-		/* protect against races with linked timeouts */
-		spin_lock_irq(&ctx->timeout_lock);
-		matched = io_match_linked(head);
-		spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		matched = io_match_linked(head);
-	}
-	return matched;
-}
-
-static inline void req_set_fail(struct io_kiocb *req)
-{
-	req->flags |= REQ_F_FAIL;
-}
-
-static inline void req_fail_link_node(struct io_kiocb *req, int res)
-{
-	req_set_fail(req);
-	req->result = res;
-}
-
-static void io_ring_ctx_ref_free(struct percpu_ref *ref)
-{
-	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
-
-	complete(&ctx->ref_comp);
-}
-
-static inline bool io_is_timeout_noseq(struct io_kiocb *req)
-{
-	return !req->timeout.off;
-}
-
-static void io_fallback_req_func(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-						fallback_work.work);
-	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
-	bool locked = false;
-
-	percpu_ref_get(&ctx->refs);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
-		req->io_task_work.func(req, &locked);
-
-	if (locked) {
-		if (ctx->submit_state.compl_nr)
-			io_submit_flush_completions(ctx);
-		mutex_unlock(&ctx->uring_lock);
-	}
-	percpu_ref_put(&ctx->refs);
-
-}
-
-static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
-{
-	struct io_ring_ctx *ctx;
-	int hash_bits;
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
-
-	/*
-	 * Use 5 bits less than the max cq entries, that should give us around
-	 * 32 entries per hash list if totally full and uniformly spread.
-	 */
-	hash_bits = ilog2(p->cq_entries);
-	hash_bits -= 5;
-	if (hash_bits <= 0)
-		hash_bits = 1;
-	ctx->cancel_hash_bits = hash_bits;
-	ctx->cancel_hash = kmalloc((1U << hash_bits) * sizeof(struct hlist_head),
-					GFP_KERNEL);
-	if (!ctx->cancel_hash)
-		goto err;
-	__hash_init(ctx->cancel_hash, 1U << hash_bits);
-
-	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
-	if (!ctx->dummy_ubuf)
-		goto err;
-	/* set invalid range, so io_import_fixed() fails meeting it */
-	ctx->dummy_ubuf->ubuf = -1UL;
-
-	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
-		goto err;
-
-	ctx->flags = p->flags;
-	init_waitqueue_head(&ctx->sqo_sq_wait);
-	INIT_LIST_HEAD(&ctx->sqd_list);
-	init_waitqueue_head(&ctx->poll_wait);
-	INIT_LIST_HEAD(&ctx->cq_overflow_list);
-	init_completion(&ctx->ref_comp);
-	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
-	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
-	mutex_init(&ctx->uring_lock);
-	init_waitqueue_head(&ctx->cq_wait);
-	spin_lock_init(&ctx->completion_lock);
-	spin_lock_init(&ctx->timeout_lock);
-	INIT_LIST_HEAD(&ctx->iopoll_list);
-	INIT_LIST_HEAD(&ctx->defer_list);
-	INIT_LIST_HEAD(&ctx->timeout_list);
-	INIT_LIST_HEAD(&ctx->ltimeout_list);
-	spin_lock_init(&ctx->rsrc_ref_lock);
-	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
-	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
-	init_llist_head(&ctx->rsrc_put_llist);
-	INIT_LIST_HEAD(&ctx->tctx_list);
-	INIT_LIST_HEAD(&ctx->submit_state.free_list);
-	INIT_LIST_HEAD(&ctx->locked_free_list);
-	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
-	return ctx;
-err:
-	kfree(ctx->dummy_ubuf);
-	kfree(ctx->cancel_hash);
-	kfree(ctx);
-	return NULL;
-}
-
-static void io_account_cq_overflow(struct io_ring_ctx *ctx)
-{
-	struct io_rings *r = ctx->rings;
-
-	WRITE_ONCE(r->cq_overflow, READ_ONCE(r->cq_overflow) + 1);
-	ctx->cq_extra--;
-}
-
-static bool req_need_defer(struct io_kiocb *req, u32 seq)
-{
-	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
-	}
-
-	return false;
-}
-
-#define FFS_ASYNC_READ		0x1UL
-#define FFS_ASYNC_WRITE		0x2UL
-#ifdef CONFIG_64BIT
-#define FFS_ISREG		0x4UL
-#else
-#define FFS_ISREG		0x0UL
-#endif
-#define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
-
-static inline bool io_req_ffs_set(struct io_kiocb *req)
-{
-	return IS_ENABLED(CONFIG_64BIT) && (req->flags & REQ_F_FIXED_FILE);
-}
-
-static void io_req_track_inflight(struct io_kiocb *req)
-{
-	if (!(req->flags & REQ_F_INFLIGHT)) {
-		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&req->task->io_uring->inflight_tracked);
-	}
-}
-
-static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
-{
-	if (WARN_ON_ONCE(!req->link))
-		return NULL;
-
-	req->flags &= ~REQ_F_ARM_LTIMEOUT;
-	req->flags |= REQ_F_LINK_TIMEOUT;
-
-	/* linked timeouts should have two refs once prep'ed */
-	io_req_set_refcount(req);
-	__io_req_set_refcount(req->link, 2);
-	return req->link;
-}
-
-static inline struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & REQ_F_ARM_LTIMEOUT)))
-		return NULL;
-	return __io_prep_linked_timeout(req);
-}
-
-static void io_prep_async_work(struct io_kiocb *req)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!(req->flags & REQ_F_CREDS)) {
-		req->flags |= REQ_F_CREDS;
-		req->creds = get_current_cred();
-	}
-
-	req->work.list.next = NULL;
-	req->work.flags = 0;
-	if (req->flags & REQ_F_FORCE_ASYNC)
-		req->work.flags |= IO_WQ_WORK_CONCURRENT;
-
-	if (req->flags & REQ_F_ISREG) {
-		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
-			io_wq_hash_work(&req->work, file_inode(req->file));
-	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
-		if (def->unbound_nonreg_file)
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
-	}
-}
-
-static void io_prep_async_link(struct io_kiocb *req)
-{
-	struct io_kiocb *cur;
-
-	if (req->flags & REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		spin_lock_irq(&ctx->timeout_lock);
-		io_for_each_link(cur, req)
-			io_prep_async_work(cur);
-		spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		io_for_each_link(cur, req)
-			io_prep_async_work(cur);
-	}
-}
-
-static void io_queue_async_work(struct io_kiocb *req, bool *locked)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *link = io_prep_linked_timeout(req);
-	struct io_uring_task *tctx = req->task->io_uring;
-
-	/* must not take the lock, NULL it as a precaution */
-	locked = NULL;
-
-	BUG_ON(!tctx);
-	BUG_ON(!tctx->io_wq);
-
-	/* init ->work of the whole link before punting */
-	io_prep_async_link(req);
-
-	/*
-	 * Not expected to happen, but if we do have a bug where this _can_
-	 * happen, catch it here and ensure the request is marked as
-	 * canceled. That will make io-wq go through the usual work cancel
-	 * procedure rather than attempt to run this request (or create a new
-	 * worker for it).
-	 */
-	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
-		req->work.flags |= IO_WQ_WORK_CANCEL;
-
-	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
-					&req->work, req->flags);
-	io_wq_enqueue(tctx->io_wq, &req->work);
-	if (link)
-		io_queue_linked_timeout(link);
-}
-
-static void io_kill_timeout(struct io_kiocb *req, int status)
-	__must_hold(&req->ctx->completion_lock)
-	__must_hold(&req->ctx->timeout_lock)
-{
-	struct io_timeout_data *io = req->async_data;
-
-	if (hrtimer_try_to_cancel(&io->timer) != -1) {
-		if (status)
-			req_set_fail(req);
-		atomic_set(&req->ctx->cq_timeouts,
-			atomic_read(&req->ctx->cq_timeouts) + 1);
-		list_del_init(&req->timeout.list);
-		io_fill_cqe_req(req, status, 0);
-		io_put_req_deferred(req);
-	}
-}
-
-static void io_queue_deferred(struct io_ring_ctx *ctx)
-{
-	while (!list_empty(&ctx->defer_list)) {
-		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
-						struct io_defer_entry, list);
-
-		if (req_need_defer(de->req, de->seq))
-			break;
-		list_del_init(&de->list);
-		io_req_task_queue(de->req);
-		kfree(de);
-	}
-}
-
-static void io_flush_timeouts(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->completion_lock)
-{
-	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
-	struct io_kiocb *req, *tmp;
-
-	spin_lock_irq(&ctx->timeout_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		u32 events_needed, events_got;
-
-		if (io_is_timeout_noseq(req))
-			break;
-
-		/*
-		 * Since seq can easily wrap around over time, subtract
-		 * the last seq at which timeouts were flushed before comparing.
-		 * Assuming not more than 2^31-1 events have happened since,
-		 * these subtractions won't have wrapped, so we can check if
-		 * target is in [last_seq, current_seq] by comparing the two.
-		 */
-		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
-		events_got = seq - ctx->cq_last_tm_flush;
-		if (events_got < events_needed)
-			break;
-
-		io_kill_timeout(req, 0);
-	}
-	ctx->cq_last_tm_flush = seq;
-	spin_unlock_irq(&ctx->timeout_lock);
-}
-
-static void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
-{
-	if (ctx->off_timeout_used)
-		io_flush_timeouts(ctx);
-	if (ctx->drain_active)
-		io_queue_deferred(ctx);
-}
-
-static inline void io_commit_cqring(struct io_ring_ctx *ctx)
-{
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
-		__io_commit_cqring_flush(ctx);
-	/* order cqe stores with ring update */
-	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
-}
-
-static inline bool io_sqring_full(struct io_ring_ctx *ctx)
-{
-	struct io_rings *r = ctx->rings;
-
-	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == ctx->sq_entries;
-}
-
-static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
-{
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
-}
-
-static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
-{
-	struct io_rings *rings = ctx->rings;
-	unsigned tail, mask = ctx->cq_entries - 1;
-
-	/*
-	 * writes to the cq entry need to come after reading head; the
-	 * control dependency is enough as we're using WRITE_ONCE to
-	 * fill the cq entry
-	 */
-	if (__io_cqring_events(ctx) == ctx->cq_entries)
-		return NULL;
-
-	tail = ctx->cached_cq_tail++;
-	return &rings->cqes[tail & mask];
-}
-
-static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
-{
-	if (likely(!ctx->cq_ev_fd))
-		return false;
-	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return false;
-	return !ctx->eventfd_async || io_wq_current_is_worker();
-}
-
-/*
- * This should only get called when at least one event has been posted.
- * Some applications rely on the eventfd notification count only changing
- * IFF a new CQE has been added to the CQ ring. There's no depedency on
- * 1:1 relationship between how many times this function is called (and
- * hence the eventfd count) and number of CQEs posted to the CQ ring.
- */
-static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
-{
-	/*
-	 * wake_up_all() may seem excessive, but io_wake_function() and
-	 * io_should_wake() handle the termination of the loop and only
-	 * wake as many waiters as we need to.
-	 */
-	if (wq_has_sleeper(&ctx->cq_wait))
-		wake_up_all(&ctx->cq_wait);
-	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
-		wake_up(&ctx->sq_data->wait);
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
-}
-
-static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
-{
-	/* see waitqueue_active() comment */
-	smp_mb();
-
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (waitqueue_active(&ctx->cq_wait))
-			wake_up_all(&ctx->cq_wait);
-	}
-	if (io_should_trigger_evfd(ctx))
-		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->poll_wait))
-		wake_up_interruptible(&ctx->poll_wait);
-}
-
-/* Returns true if there are no backlogged entries after the flush */
-static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
-{
-	bool all_flushed, posted;
-
-	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
-		return false;
-
-	posted = false;
-	spin_lock(&ctx->completion_lock);
-	while (!list_empty(&ctx->cq_overflow_list)) {
-		struct io_uring_cqe *cqe = io_get_cqe(ctx);
-		struct io_overflow_cqe *ocqe;
-
-		if (!cqe && !force)
-			break;
-		ocqe = list_first_entry(&ctx->cq_overflow_list,
-					struct io_overflow_cqe, list);
-		if (cqe)
-			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
-		else
-			io_account_cq_overflow(ctx);
-
-		posted = true;
-		list_del(&ocqe->list);
-		kfree(ocqe);
-	}
-
-	all_flushed = list_empty(&ctx->cq_overflow_list);
-	if (all_flushed) {
-		clear_bit(0, &ctx->check_cq_overflow);
-		WRITE_ONCE(ctx->rings->sq_flags,
-			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
-	}
-
-	if (posted)
-		io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	if (posted)
-		io_cqring_ev_posted(ctx);
-	return all_flushed;
-}
-
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
-{
-	bool ret = true;
-
-	if (test_bit(0, &ctx->check_cq_overflow)) {
-		/* iopoll syncs against uring_lock, not completion_lock */
-		if (ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx, false);
-		if (ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_unlock(&ctx->uring_lock);
-	}
-
-	return ret;
-}
-
-/* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
-{
-	struct io_uring_task *tctx = task->io_uring;
-
-	if (likely(task == current)) {
-		tctx->cached_refs += nr;
-	} else {
-		percpu_counter_sub(&tctx->inflight, nr);
-		if (unlikely(atomic_read(&tctx->in_idle)))
-			wake_up(&tctx->wait);
-		put_task_struct_many(task, nr);
-	}
-}
-
-static void io_task_refs_refill(struct io_uring_task *tctx)
-{
-	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
-
-	percpu_counter_add(&tctx->inflight, refill);
-	refcount_add(refill, &current->usage);
-	tctx->cached_refs += refill;
-}
-
-static inline void io_get_task_refs(int nr)
-{
-	struct io_uring_task *tctx = current->io_uring;
-
-	tctx->cached_refs -= nr;
-	if (unlikely(tctx->cached_refs < 0))
-		io_task_refs_refill(tctx);
-}
-
-static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
-{
-	struct io_uring_task *tctx = task->io_uring;
-	unsigned int refs = tctx->cached_refs;
-
-	if (refs) {
-		tctx->cached_refs = 0;
-		percpu_counter_sub(&tctx->inflight, refs);
-		put_task_struct_many(task, refs);
-	}
-}
-
-static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     s32 res, u32 cflags)
-{
-	struct io_overflow_cqe *ocqe;
-
-	ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
-	if (!ocqe) {
-		/*
-		 * If we're in ring overflow flush mode, or in task cancel mode,
-		 * or cannot allocate an overflow entry, then we need to drop it
-		 * on the floor.
-		 */
-		io_account_cq_overflow(ctx);
-		return false;
-	}
-	if (list_empty(&ctx->cq_overflow_list)) {
-		set_bit(0, &ctx->check_cq_overflow);
-		WRITE_ONCE(ctx->rings->sq_flags,
-			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
-
-	}
-	ocqe->cqe.user_data = user_data;
-	ocqe->cqe.res = res;
-	ocqe->cqe.flags = cflags;
-	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
-	return true;
-}
-
-static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
-				 s32 res, u32 cflags)
-{
-	struct io_uring_cqe *cqe;
-
-	trace_io_uring_complete(ctx, user_data, res, cflags);
-
-	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
-	 */
-	cqe = io_get_cqe(ctx);
-	if (likely(cqe)) {
-		WRITE_ONCE(cqe->user_data, user_data);
-		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, cflags);
-		return true;
-	}
-	return io_cqring_event_overflow(ctx, user_data, res, cflags);
-}
-
-static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
-{
-	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
-}
-
-static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
-				     s32 res, u32 cflags)
-{
-	ctx->cq_extra++;
-	return __io_fill_cqe(ctx, user_data, res, cflags);
-}
-
-static void io_req_complete_post(struct io_kiocb *req, s32 res,
-				 u32 cflags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock(&ctx->completion_lock);
-	__io_fill_cqe(ctx, req->user_data, res, cflags);
-	/*
-	 * If we're the last reference to this request, add to our locked
-	 * free_list cache.
-	 */
-	if (req_ref_put_and_test(req)) {
-		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			if (req->flags & IO_DISARM_MASK)
-				io_disarm_next(req);
-			if (req->link) {
-				io_req_task_queue(req->link);
-				req->link = NULL;
-			}
-		}
-		io_dismantle_req(req);
-		io_put_task(req->task, 1);
-		list_add(&req->inflight_entry, &ctx->locked_free_list);
-		ctx->locked_free_nr++;
-	} else {
-		if (!percpu_ref_tryget(&ctx->refs))
-			req = NULL;
-	}
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-
-	if (req) {
-		io_cqring_ev_posted(ctx);
-		percpu_ref_put(&ctx->refs);
-	}
-}
-
-static inline bool io_req_needs_clean(struct io_kiocb *req)
-{
-	return req->flags & IO_REQ_CLEAN_FLAGS;
-}
-
-static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
-					 u32 cflags)
-{
-	if (io_req_needs_clean(req))
-		io_clean_op(req);
-	req->result = res;
-	req->compl.cflags = cflags;
-	req->flags |= REQ_F_COMPLETE_INLINE;
-}
-
-static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
-				     s32 res, u32 cflags)
-{
-	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
-		io_req_complete_state(req, res, cflags);
-	else
-		io_req_complete_post(req, res, cflags);
-}
-
-static inline void io_req_complete(struct io_kiocb *req, s32 res)
-{
-	__io_req_complete(req, 0, res, 0);
-}
-
-static void io_req_complete_failed(struct io_kiocb *req, s32 res)
-{
-	req_set_fail(req);
-	io_req_complete_post(req, res, 0);
-}
-
-static void io_req_complete_fail_submit(struct io_kiocb *req)
-{
-	/*
-	 * We don't submit, fail them all, for that replace hardlinks with
-	 * normal links. Extra REQ_F_LINK is tolerated.
-	 */
-	req->flags &= ~REQ_F_HARDLINK;
-	req->flags |= REQ_F_LINK;
-	io_req_complete_failed(req, req->result);
-}
-
-/*
- * Don't initialise the fields below on every allocation, but do that in
- * advance and keep them valid across allocations.
- */
-static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
-{
-	req->ctx = ctx;
-	req->link = NULL;
-	req->async_data = NULL;
-	/* not necessary, but safer to zero */
-	req->result = 0;
-}
-
-static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
-					struct io_submit_state *state)
-{
-	spin_lock(&ctx->completion_lock);
-	list_splice_init(&ctx->locked_free_list, &state->free_list);
-	ctx->locked_free_nr = 0;
-	spin_unlock(&ctx->completion_lock);
-}
-
-/* Returns true IFF there are requests in the cache */
-static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
-{
-	struct io_submit_state *state = &ctx->submit_state;
-	int nr;
-
-	/*
-	 * If we have more than a batch's worth of requests in our IRQ side
-	 * locked cache, grab the lock and move them over to our submission
-	 * side cache.
-	 */
-	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
-		io_flush_cached_locked_reqs(ctx, state);
-
-	nr = state->free_reqs;
-	while (!list_empty(&state->free_list)) {
-		struct io_kiocb *req = list_first_entry(&state->free_list,
-					struct io_kiocb, inflight_entry);
-
-		list_del(&req->inflight_entry);
-		state->reqs[nr++] = req;
-		if (nr == ARRAY_SIZE(state->reqs))
-			break;
-	}
-
-	state->free_reqs = nr;
-	return nr != 0;
-}
-
-/*
- * A request might get retired back into the request caches even before opcode
- * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
- * Because of that, io_alloc_req() should be called only under ->uring_lock
- * and with extra caution to not get a request that is still worked on.
- */
-static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_submit_state *state = &ctx->submit_state;
-	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
-	int ret, i;
-
-	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
-
-	if (likely(state->free_reqs || io_flush_cached_reqs(ctx)))
-		goto got_req;
-
-	ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
-				    state->reqs);
-
-	/*
-	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
-	 * retry single alloc to be on the safe side.
-	 */
-	if (unlikely(ret <= 0)) {
-		state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
-		if (!state->reqs[0])
-			return NULL;
-		ret = 1;
-	}
-
-	for (i = 0; i < ret; i++)
-		io_preinit_req(state->reqs[i], ctx);
-	state->free_reqs = ret;
-got_req:
-	state->free_reqs--;
-	return state->reqs[state->free_reqs];
-}
-
-static inline void io_put_file(struct file *file)
-{
-	if (file)
-		fput(file);
-}
-
-static void io_dismantle_req(struct io_kiocb *req)
-{
-	unsigned int flags = req->flags;
-
-	if (io_req_needs_clean(req))
-		io_clean_op(req);
-	if (!(flags & REQ_F_FIXED_FILE))
-		io_put_file(req->file);
-	if (req->fixed_rsrc_refs)
-		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data) {
-		kfree(req->async_data);
-		req->async_data = NULL;
-	}
-}
-
-static void __io_free_req(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	io_dismantle_req(req);
-	io_put_task(req->task, 1);
-
-	spin_lock(&ctx->completion_lock);
-	list_add(&req->inflight_entry, &ctx->locked_free_list);
-	ctx->locked_free_nr++;
-	spin_unlock(&ctx->completion_lock);
-
-	percpu_ref_put(&ctx->refs);
-}
-
-static inline void io_remove_next_linked(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt = req->link;
-
-	req->link = nxt->link;
-	nxt->link = NULL;
-}
-
-static bool io_kill_linked_timeout(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-	__must_hold(&req->ctx->timeout_lock)
-{
-	struct io_kiocb *link = req->link;
-
-	if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
-		struct io_timeout_data *io = link->async_data;
-
-		io_remove_next_linked(req);
-		link->timeout.head = NULL;
-		if (hrtimer_try_to_cancel(&io->timer) != -1) {
-			list_del(&link->timeout.list);
-			io_fill_cqe_req(link, -ECANCELED, 0);
-			io_put_req_deferred(link);
-			return true;
-		}
-	}
-	return false;
-}
-
-static void io_fail_links(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	struct io_kiocb *nxt, *link = req->link;
-
-	req->link = NULL;
-	while (link) {
-		long res = -ECANCELED;
-
-		if (link->flags & REQ_F_FAIL)
-			res = link->result;
-
-		nxt = link->link;
-		link->link = NULL;
-
-		trace_io_uring_fail_link(req, link);
-		io_fill_cqe_req(link, res, 0);
-		io_put_req_deferred(link);
-		link = nxt;
-	}
-}
-
-static bool io_disarm_next(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool posted = false;
-
-	if (req->flags & REQ_F_ARM_LTIMEOUT) {
-		struct io_kiocb *link = req->link;
-
-		req->flags &= ~REQ_F_ARM_LTIMEOUT;
-		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
-			io_remove_next_linked(req);
-			io_fill_cqe_req(link, -ECANCELED, 0);
-			io_put_req_deferred(link);
-			posted = true;
-		}
-	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		spin_lock_irq(&ctx->timeout_lock);
-		posted = io_kill_linked_timeout(req);
-		spin_unlock_irq(&ctx->timeout_lock);
-	}
-	if (unlikely((req->flags & REQ_F_FAIL) &&
-		     !(req->flags & REQ_F_HARDLINK))) {
-		posted |= (req->link != NULL);
-		io_fail_links(req);
-	}
-	return posted;
-}
-
-static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt;
-
-	/*
-	 * If LINK is set, we have dependent requests in this chain. If we
-	 * didn't fail this request, queue the first one up, moving any other
-	 * dependencies to the next request. In case of failure, fail the rest
-	 * of the chain.
-	 */
-	if (req->flags & IO_DISARM_MASK) {
-		struct io_ring_ctx *ctx = req->ctx;
-		bool posted;
-
-		spin_lock(&ctx->completion_lock);
-		posted = io_disarm_next(req);
-		if (posted)
-			io_commit_cqring(req->ctx);
-		spin_unlock(&ctx->completion_lock);
-		if (posted)
-			io_cqring_ev_posted(ctx);
-	}
-	nxt = req->link;
-	req->link = NULL;
-	return nxt;
-}
-
-static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))))
-		return NULL;
-	return __io_req_find_next(req);
-}
-
-static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
-{
-	if (!ctx)
-		return;
-	if (*locked) {
-		if (ctx->submit_state.compl_nr)
-			io_submit_flush_completions(ctx);
-		mutex_unlock(&ctx->uring_lock);
-		*locked = false;
-	}
-	percpu_ref_put(&ctx->refs);
-}
-
-static void tctx_task_work(struct callback_head *cb)
-{
-	bool locked = false;
-	struct io_ring_ctx *ctx = NULL;
-	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
-						  task_work);
-
-	while (1) {
-		struct io_wq_work_node *node;
-
-		if (!tctx->task_list.first && locked && ctx->submit_state.compl_nr)
-			io_submit_flush_completions(ctx);
-
-		spin_lock_irq(&tctx->task_lock);
-		node = tctx->task_list.first;
-		INIT_WQ_LIST(&tctx->task_list);
-		if (!node)
-			tctx->task_running = false;
-		spin_unlock_irq(&tctx->task_lock);
-		if (!node)
-			break;
-
-		do {
-			struct io_wq_work_node *next = node->next;
-			struct io_kiocb *req = container_of(node, struct io_kiocb,
-							    io_task_work.node);
-
-			if (req->ctx != ctx) {
-				ctx_flush_and_put(ctx, &locked);
-				ctx = req->ctx;
-				/* if not contended, grab and improve batching */
-				locked = mutex_trylock(&ctx->uring_lock);
-				percpu_ref_get(&ctx->refs);
-			}
-			req->io_task_work.func(req, &locked);
-			node = next;
-		} while (node);
-
-		cond_resched();
-	}
-
-	ctx_flush_and_put(ctx, &locked);
-
-	/* relaxed read is enough as only the task itself sets ->in_idle */
-	if (unlikely(atomic_read(&tctx->in_idle)))
-		io_uring_drop_tctx_refs(current);
-}
-
-static void io_req_task_work_add(struct io_kiocb *req)
-{
-	struct task_struct *tsk = req->task;
-	struct io_uring_task *tctx = tsk->io_uring;
-	enum task_work_notify_mode notify;
-	struct io_wq_work_node *node;
-	unsigned long flags;
-	bool running;
-
-	WARN_ON_ONCE(!tctx);
-
-	spin_lock_irqsave(&tctx->task_lock, flags);
-	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
-	running = tctx->task_running;
-	if (!running)
-		tctx->task_running = true;
-	spin_unlock_irqrestore(&tctx->task_lock, flags);
-
-	/* task_work already pending, we're done */
-	if (running)
-		return;
-
-	/*
-	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
-	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
-	 * processing task_work. There's no reliable way to tell if TWA_RESUME
-	 * will do the job.
-	 */
-	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
-	if (!task_work_add(tsk, &tctx->task_work, notify)) {
-		wake_up_process(tsk);
-		return;
-	}
-
-	spin_lock_irqsave(&tctx->task_lock, flags);
-	tctx->task_running = false;
-	node = tctx->task_list.first;
-	INIT_WQ_LIST(&tctx->task_list);
-	spin_unlock_irqrestore(&tctx->task_lock, flags);
-
-	while (node) {
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		node = node->next;
-		if (llist_add(&req->io_task_work.fallback_node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
-	}
-}
-
-static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	/* not needed for normal modes, but SQPOLL depends on it */
-	io_tw_lock(ctx, locked);
-	io_req_complete_failed(req, req->result);
-}
-
-static void io_req_task_submit(struct io_kiocb *req, bool *locked)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	io_tw_lock(ctx, locked);
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (likely(!(req->task->flags & PF_EXITING)))
-		__io_queue_sqe(req);
-	else
-		io_req_complete_failed(req, -EFAULT);
-}
-
-static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
-{
-	req->result = ret;
-	req->io_task_work.func = io_req_task_cancel;
-	io_req_task_work_add(req);
-}
-
-static void io_req_task_queue(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_req_task_submit;
-	io_req_task_work_add(req);
-}
-
-static void io_req_task_queue_reissue(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_queue_async_work;
-	io_req_task_work_add(req);
-}
-
-static inline void io_queue_next(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt = io_req_find_next(req);
-
-	if (nxt)
-		io_req_task_queue(nxt);
-}
-
-static void io_free_req(struct io_kiocb *req)
-{
-	io_queue_next(req);
-	__io_free_req(req);
-}
-
-static void io_free_req_work(struct io_kiocb *req, bool *locked)
-{
-	io_free_req(req);
-}
-
-struct req_batch {
-	struct task_struct	*task;
-	int			task_refs;
-	int			ctx_refs;
-};
-
-static inline void io_init_req_batch(struct req_batch *rb)
-{
-	rb->task_refs = 0;
-	rb->ctx_refs = 0;
-	rb->task = NULL;
-}
-
-static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
-				     struct req_batch *rb)
-{
-	if (rb->ctx_refs)
-		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
-	if (rb->task)
-		io_put_task(rb->task, rb->task_refs);
-}
-
-static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
-			      struct io_submit_state *state)
-{
-	io_queue_next(req);
-	io_dismantle_req(req);
-
-	if (req->task != rb->task) {
-		if (rb->task)
-			io_put_task(rb->task, rb->task_refs);
-		rb->task = req->task;
-		rb->task_refs = 0;
-	}
-	rb->task_refs++;
-	rb->ctx_refs++;
-
-	if (state->free_reqs != ARRAY_SIZE(state->reqs))
-		state->reqs[state->free_reqs++] = req;
-	else
-		list_add(&req->inflight_entry, &state->free_list);
-}
-
-static void io_submit_flush_completions(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_submit_state *state = &ctx->submit_state;
-	int i, nr = state->compl_nr;
-	struct req_batch rb;
-
-	spin_lock(&ctx->completion_lock);
-	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = state->compl_reqs[i];
-
-		__io_fill_cqe(ctx, req->user_data, req->result,
-			      req->compl.cflags);
-	}
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
-
-	io_init_req_batch(&rb);
-	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = state->compl_reqs[i];
-
-		if (req_ref_put_and_test(req))
-			io_req_free_batch(&rb, req, &ctx->submit_state);
-	}
-
-	io_req_free_batch_finish(ctx, &rb);
-	state->compl_nr = 0;
-}
-
-/*
- * Drop reference to request, return next in chain (if there is one) if this
- * was the last reference to this request.
- */
-static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt = NULL;
-
-	if (req_ref_put_and_test(req)) {
-		nxt = io_req_find_next(req);
-		__io_free_req(req);
-	}
-	return nxt;
-}
-
-static inline void io_put_req(struct io_kiocb *req)
-{
-	if (req_ref_put_and_test(req))
-		io_free_req(req);
-}
-
-static inline void io_put_req_deferred(struct io_kiocb *req)
-{
-	if (req_ref_put_and_test(req)) {
-		req->io_task_work.func = io_free_req_work;
-		io_req_task_work_add(req);
-	}
-}
-
-static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-{
-	/* See comment at the top of this file */
-	smp_rmb();
-	return __io_cqring_events(ctx);
-}
-
-static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
-{
-	struct io_rings *rings = ctx->rings;
-
-	/* make sure SQ entry isn't read before tail */
-	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
-}
-
-static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
-{
-	unsigned int cflags;
-
-	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
-	cflags |= IORING_CQE_F_BUFFER;
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	kfree(kbuf);
-	return cflags;
-}
-
-static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
-{
-	struct io_buffer *kbuf;
-
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
-		return 0;
-	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
-	return io_put_kbuf(req, kbuf);
-}
-
-static inline bool io_run_task_work(void)
-{
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
-		__set_current_state(TASK_RUNNING);
-		tracehook_notify_signal();
-		return true;
-	}
-
-	return false;
-}
-
-/*
- * Find and free completed poll iocbs
- */
-static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done)
-{
-	struct req_batch rb;
-	struct io_kiocb *req;
-
-	/* order with ->result store in io_complete_rw_iopoll() */
-	smp_rmb();
-
-	io_init_req_batch(&rb);
-	while (!list_empty(done)) {
-		req = list_first_entry(done, struct io_kiocb, inflight_entry);
-		list_del(&req->inflight_entry);
-
-		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
-		(*nr_events)++;
-
-		if (req_ref_put_and_test(req))
-			io_req_free_batch(&rb, req, &ctx->submit_state);
-	}
-
-	io_commit_cqring(ctx);
-	io_cqring_ev_posted_iopoll(ctx);
-	io_req_free_batch_finish(ctx, &rb);
-}
-
-static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min)
-{
-	struct io_kiocb *req, *tmp;
-	LIST_HEAD(done);
-	bool spin;
-
-	/*
-	 * Only spin for completions if we don't have multiple devices hanging
-	 * off our complete list, and we're under the requested amount.
-	 */
-	spin = !ctx->poll_multi_queue && *nr_events < min;
-
-	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
-		struct kiocb *kiocb = &req->rw.kiocb;
-		int ret;
-
-		/*
-		 * Move completed and retryable entries to our local lists.
-		 * If we find a request that requires polling, break out
-		 * and complete those lists first, if we have entries there.
-		 */
-		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->inflight_entry, &done);
-			continue;
-		}
-		if (!list_empty(&done))
-			break;
-
-		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
-		if (unlikely(ret < 0))
-			return ret;
-		else if (ret)
-			spin = false;
-
-		/* iopoll may have completed current req */
-		if (READ_ONCE(req->iopoll_completed))
-			list_move_tail(&req->inflight_entry, &done);
-	}
-
-	if (!list_empty(&done))
-		io_iopoll_complete(ctx, nr_events, &done);
-
-	return 0;
-}
-
-/*
- * We can't just wait for polled events to come to us, we have to actively
- * find and complete them.
- */
-static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
-{
-	if (!(ctx->flags & IORING_SETUP_IOPOLL))
-		return;
-
-	mutex_lock(&ctx->uring_lock);
-	while (!list_empty(&ctx->iopoll_list)) {
-		unsigned int nr_events = 0;
-
-		io_do_iopoll(ctx, &nr_events, 0);
-
-		/* let it sleep and repeat later if can't complete a request */
-		if (nr_events == 0)
-			break;
-		/*
-		 * Ensure we allow local-to-the-cpu processing to take place,
-		 * in this case we need to ensure that we reap all events.
-		 * Also let task_work, etc. to progress by releasing the mutex
-		 */
-		if (need_resched()) {
-			mutex_unlock(&ctx->uring_lock);
-			cond_resched();
-			mutex_lock(&ctx->uring_lock);
-		}
-	}
-	mutex_unlock(&ctx->uring_lock);
-}
-
-static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
-{
-	unsigned int nr_events = 0;
-	int ret = 0;
-
-	/*
-	 * We disallow the app entering submit/complete with polling, but we
-	 * still need to lock the ring to prevent racing with polled issue
-	 * that got punted to a workqueue.
-	 */
-	mutex_lock(&ctx->uring_lock);
-	/*
-	 * Don't enter poll loop if we already have events pending.
-	 * If we do, we can potentially be spinning for commands that
-	 * already triggered a CQE (eg in error).
-	 */
-	if (test_bit(0, &ctx->check_cq_overflow))
-		__io_cqring_overflow_flush(ctx, false);
-	if (io_cqring_events(ctx))
-		goto out;
-	do {
-		/*
-		 * If a submit got punted to a workqueue, we can have the
-		 * application entering polling for a command before it gets
-		 * issued. That app will hold the uring_lock for the duration
-		 * of the poll right here, so we need to take a breather every
-		 * now and then to ensure that the issue has a chance to add
-		 * the poll to the issued list. Otherwise we can spin here
-		 * forever, while the workqueue is stuck trying to acquire the
-		 * very same mutex.
-		 */
-		if (list_empty(&ctx->iopoll_list)) {
-			u32 tail = ctx->cached_cq_tail;
-
-			mutex_unlock(&ctx->uring_lock);
-			io_run_task_work();
-			mutex_lock(&ctx->uring_lock);
-
-			/* some requests don't go through iopoll_list */
-			if (tail != ctx->cached_cq_tail ||
-			    list_empty(&ctx->iopoll_list))
-				break;
-		}
-		ret = io_do_iopoll(ctx, &nr_events, min);
-	} while (!ret && nr_events < min && !need_resched());
-out:
-	mutex_unlock(&ctx->uring_lock);
-	return ret;
-}
-
-static void kiocb_end_write(struct io_kiocb *req)
-{
-	/*
-	 * Tell lockdep we inherited freeze protection from submission
-	 * thread.
-	 */
-	if (req->flags & REQ_F_ISREG) {
-		struct super_block *sb = file_inode(req->file)->i_sb;
-
-		__sb_writers_acquired(sb, SB_FREEZE_WRITE);
-		sb_end_write(sb);
-	}
-}
-
-#ifdef CONFIG_BLOCK
-static bool io_resubmit_prep(struct io_kiocb *req)
-{
-	struct io_async_rw *rw = req->async_data;
-
-	if (!rw)
-		return !io_req_prep_async(req);
-	iov_iter_restore(&rw->iter, &rw->iter_state);
-	return true;
-}
-
-static bool io_rw_should_reissue(struct io_kiocb *req)
-{
-	umode_t mode = file_inode(req->file)->i_mode;
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!S_ISBLK(mode) && !S_ISREG(mode))
-		return false;
-	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
-	    !(ctx->flags & IORING_SETUP_IOPOLL)))
-		return false;
-	/*
-	 * If ref is dying, we might be running poll reap from the exit work.
-	 * Don't attempt to reissue from that path, just let it fail with
-	 * -EAGAIN.
-	 */
-	if (percpu_ref_is_dying(&ctx->refs))
-		return false;
-	/*
-	 * Play it safe and assume not safe to re-import and reissue if we're
-	 * not in the original thread group (or in task context).
-	 */
-	if (!same_thread_group(req->task, current) || !in_task())
-		return false;
-	return true;
-}
-#else
-static bool io_resubmit_prep(struct io_kiocb *req)
-{
-	return false;
-}
-static bool io_rw_should_reissue(struct io_kiocb *req)
-{
-	return false;
-}
-#endif
-
-static bool __io_complete_rw_common(struct io_kiocb *req, long res)
-{
-	if (req->rw.kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
-	if (res != req->result) {
-		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
-		    io_rw_should_reissue(req)) {
-			req->flags |= REQ_F_REISSUE;
-			return true;
-		}
-		req_set_fail(req);
-		req->result = res;
-	}
-	return false;
-}
-
-static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
-{
-	struct io_async_rw *io = req->async_data;
-
-	/* add previously done IO, if any */
-	if (io && io->bytes_done > 0) {
-		if (res < 0)
-			res = io->bytes_done;
-		else
-			res += io->bytes_done;
-	}
-	return res;
-}
-
-static void io_req_task_complete(struct io_kiocb *req, bool *locked)
-{
-	unsigned int cflags = io_put_rw_kbuf(req);
-	int res = req->result;
-
-	if (*locked) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_submit_state *state = &ctx->submit_state;
-
-		io_req_complete_state(req, res, cflags);
-		state->compl_reqs[state->compl_nr++] = req;
-		if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
-			io_submit_flush_completions(ctx);
-	} else {
-		io_req_complete_post(req, res, cflags);
-	}
-}
-
-static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-			     unsigned int issue_flags)
-{
-	if (__io_complete_rw_common(req, res))
-		return;
-	__io_req_complete(req, issue_flags, io_fixup_rw_res(req, res), io_put_rw_kbuf(req));
-}
-
-static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
-{
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
-
-	if (__io_complete_rw_common(req, res))
-		return;
-	req->result = io_fixup_rw_res(req, res);
-	req->io_task_work.func = io_req_task_complete;
-	io_req_task_work_add(req);
-}
-
-static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
-{
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
-
-	if (kiocb->ki_flags & IOCB_WRITE)
-		kiocb_end_write(req);
-	if (unlikely(res != req->result)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req)) {
-			req->flags |= REQ_F_REISSUE;
-			return;
-		}
-	}
-
-	WRITE_ONCE(req->result, res);
-	/* order with io_iopoll_complete() checking ->result */
-	smp_wmb();
-	WRITE_ONCE(req->iopoll_completed, 1);
-}
-
-/*
- * After the iocb has been issued, it's safe to be found on the poll list.
- * Adding the kiocb to the list AFTER submission ensures that we don't
- * find it from a io_do_iopoll() thread before the issuer is done
- * accessing the kiocb cookie.
- */
-static void io_iopoll_req_issued(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	const bool in_async = io_wq_current_is_worker();
-
-	/* workqueue context doesn't hold uring_lock, grab it now */
-	if (unlikely(in_async))
-		mutex_lock(&ctx->uring_lock);
-
-	/*
-	 * Track whether we have multiple files in our lists. This will impact
-	 * how we do polling eventually, not spinning if we're on potentially
-	 * different devices.
-	 */
-	if (list_empty(&ctx->iopoll_list)) {
-		ctx->poll_multi_queue = false;
-	} else if (!ctx->poll_multi_queue) {
-		struct io_kiocb *list_req;
-		unsigned int queue_num0, queue_num1;
-
-		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
-						inflight_entry);
-
-		if (list_req->file != req->file) {
-			ctx->poll_multi_queue = true;
-		} else {
-			queue_num0 = blk_qc_t_to_queue_num(list_req->rw.kiocb.ki_cookie);
-			queue_num1 = blk_qc_t_to_queue_num(req->rw.kiocb.ki_cookie);
-			if (queue_num0 != queue_num1)
-				ctx->poll_multi_queue = true;
-		}
-	}
-
-	/*
-	 * For fast devices, IO may have already completed. If it has, add
-	 * it to the front so we find it first.
-	 */
-	if (READ_ONCE(req->iopoll_completed))
-		list_add(&req->inflight_entry, &ctx->iopoll_list);
-	else
-		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
-
-	if (unlikely(in_async)) {
-		/*
-		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
-		 * in sq thread task context or in io worker task context. If
-		 * current task context is sq thread, we don't need to check
-		 * whether should wake up sq thread.
-		 */
-		if ((ctx->flags & IORING_SETUP_SQPOLL) &&
-		    wq_has_sleeper(&ctx->sq_data->wait))
-			wake_up(&ctx->sq_data->wait);
-
-		mutex_unlock(&ctx->uring_lock);
-	}
-}
-
-static bool io_bdev_nowait(struct block_device *bdev)
-{
-	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
-}
-
-/*
- * If we tracked the file through the SCM inflight mechanism, we could support
- * any file. For now, just ensure that anything potentially problematic is done
- * inline.
- */
-static bool __io_file_supports_nowait(struct file *file, int rw)
-{
-	umode_t mode = file_inode(file)->i_mode;
-
-	if (S_ISBLK(mode)) {
-		if (IS_ENABLED(CONFIG_BLOCK) &&
-		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
-			return true;
-		return false;
-	}
-	if (S_ISSOCK(mode))
-		return true;
-	if (S_ISREG(mode)) {
-		if (IS_ENABLED(CONFIG_BLOCK) &&
-		    io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
-		    file->f_op != &io_uring_fops)
-			return true;
-		return false;
-	}
-
-	/* any ->read/write should understand O_NONBLOCK */
-	if (file->f_flags & O_NONBLOCK)
-		return true;
-
-	if (!(file->f_mode & FMODE_NOWAIT))
-		return false;
-
-	if (rw == READ)
-		return file->f_op->read_iter != NULL;
-
-	return file->f_op->write_iter != NULL;
-}
-
-static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
-{
-	if (rw == READ && (req->flags & REQ_F_NOWAIT_READ))
-		return true;
-	else if (rw == WRITE && (req->flags & REQ_F_NOWAIT_WRITE))
-		return true;
-
-	return __io_file_supports_nowait(req->file, rw);
-}
-
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      int rw)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct kiocb *kiocb = &req->rw.kiocb;
-	struct file *file = req->file;
-	unsigned ioprio;
-	int ret;
-
-	if (!io_req_ffs_set(req) && S_ISREG(file_inode(file)->i_mode))
-		req->flags |= REQ_F_ISREG;
-
-	kiocb->ki_pos = READ_ONCE(sqe->off);
-	if (kiocb->ki_pos == -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = file->f_pos;
-		} else {
-			kiocb->ki_pos = 0;
-		}
-	}
-	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
-	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * If the file is marked O_NONBLOCK, still allow retry for it if it
-	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
-	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
-	 */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
-		req->flags |= REQ_F_NOWAIT;
-
-	ioprio = READ_ONCE(sqe->ioprio);
-	if (ioprio) {
-		ret = ioprio_check_cap(ioprio);
-		if (ret)
-			return ret;
-
-		kiocb->ki_ioprio = ioprio;
-	} else
-		kiocb->ki_ioprio = get_current_ioprio();
-
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!(kiocb->ki_flags & IOCB_DIRECT) ||
-		    !kiocb->ki_filp->f_op->iopoll)
-			return -EOPNOTSUPP;
-
-		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
-		kiocb->ki_complete = io_complete_rw_iopoll;
-		req->iopoll_completed = 0;
-	} else {
-		if (kiocb->ki_flags & IOCB_HIPRI)
-			return -EINVAL;
-		kiocb->ki_complete = io_complete_rw;
-	}
-
-	/* used for fixed read/write too - just read unconditionally */
-	req->buf_index = READ_ONCE(sqe->buf_index);
-	req->imu = NULL;
-
-	if (req->opcode == IORING_OP_READ_FIXED ||
-	    req->opcode == IORING_OP_WRITE_FIXED) {
-		struct io_ring_ctx *ctx = req->ctx;
-		u16 index;
-
-		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
-			return -EFAULT;
-		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-		req->imu = ctx->user_bufs[index];
-		io_req_set_rsrc_node(req);
-	}
-
-	req->rw.addr = READ_ONCE(sqe->addr);
-	req->rw.len = READ_ONCE(sqe->len);
-	return 0;
-}
-
-static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
-{
-	switch (ret) {
-	case -EIOCBQUEUED:
-		break;
-	case -ERESTARTSYS:
-	case -ERESTARTNOINTR:
-	case -ERESTARTNOHAND:
-	case -ERESTART_RESTARTBLOCK:
-		/*
-		 * We can't just restart the syscall, since previously
-		 * submitted sqes may already be in progress. Just fail this
-		 * IO with EINTR.
-		 */
-		ret = -EINTR;
-		fallthrough;
-	default:
-		kiocb->ki_complete(kiocb, ret, 0);
-	}
-}
-
-static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
-		       unsigned int issue_flags)
-{
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
-
-	if (req->flags & REQ_F_CUR_POS)
-		req->file->f_pos = kiocb->ki_pos;
-	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
-		__io_complete_rw(req, ret, 0, issue_flags);
-	else
-		io_rw_done(kiocb, ret);
-
-	if (req->flags & REQ_F_REISSUE) {
-		req->flags &= ~REQ_F_REISSUE;
-		if (io_resubmit_prep(req)) {
-			io_req_task_queue_reissue(req);
-		} else {
-			unsigned int cflags = io_put_rw_kbuf(req);
-			struct io_ring_ctx *ctx = req->ctx;
-
-			ret = io_fixup_rw_res(req, ret);
-			req_set_fail(req);
-			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
-				mutex_lock(&ctx->uring_lock);
-				__io_req_complete(req, issue_flags, ret, cflags);
-				mutex_unlock(&ctx->uring_lock);
-			} else {
-				__io_req_complete(req, issue_flags, ret, cflags);
-			}
-		}
-	}
-}
-
-static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
-			     struct io_mapped_ubuf *imu)
-{
-	size_t len = req->rw.len;
-	u64 buf_end, buf_addr = req->rw.addr;
-	size_t offset;
-
-	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
-		return -EFAULT;
-	/* not inside the mapped region */
-	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
-		return -EFAULT;
-
-	/*
-	 * May not be a start of buffer, set size appropriately
-	 * and advance us to the beginning.
-	 */
-	offset = buf_addr - imu->ubuf;
-	iov_iter_bvec(iter, rw, imu->bvec, imu->nr_bvecs, offset + len);
-
-	if (offset) {
-		/*
-		 * Don't use iov_iter_advance() here, as it's really slow for
-		 * using the latter parts of a big fixed buffer - it iterates
-		 * over each segment manually. We can cheat a bit here, because
-		 * we know that:
-		 *
-		 * 1) it's a BVEC iter, we set it up
-		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
-		 *    first and last bvec
-		 *
-		 * So just find our index, and adjust the iterator afterwards.
-		 * If the offset is within the first bvec (or the whole first
-		 * bvec, just use iov_iter_advance(). This makes it easier
-		 * since we can just skip the first segment, which may not
-		 * be PAGE_SIZE aligned.
-		 */
-		const struct bio_vec *bvec = imu->bvec;
-
-		if (offset <= bvec->bv_len) {
-			iov_iter_advance(iter, offset);
-		} else {
-			unsigned long seg_skip;
-
-			/* skip first vec */
-			offset -= bvec->bv_len;
-			seg_skip = 1 + (offset >> PAGE_SHIFT);
-
-			iter->bvec = bvec + seg_skip;
-			iter->nr_segs -= seg_skip;
-			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ~PAGE_MASK;
-		}
-	}
-
-	return 0;
-}
-
-static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
-{
-	if (WARN_ON_ONCE(!req->imu))
-		return -EFAULT;
-	return __io_import_fixed(req, rw, iter, req->imu);
-}
-
-static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
-{
-	if (needs_lock)
-		mutex_unlock(&ctx->uring_lock);
-}
-
-static void io_ring_submit_lock(struct io_ring_ctx *ctx, bool needs_lock)
-{
-	/*
-	 * "Normal" inline submissions always hold the uring_lock, since we
-	 * grab it from the system call. Same is true for the SQPOLL offload.
-	 * The only exception is when we've detached the request and issue it
-	 * from an async worker thread, grab the lock for that case.
-	 */
-	if (needs_lock)
-		mutex_lock(&ctx->uring_lock);
-}
-
-static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
-					  int bgid, struct io_buffer *kbuf,
-					  bool needs_lock)
-{
-	struct io_buffer *head;
-
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return kbuf;
-
-	io_ring_submit_lock(req->ctx, needs_lock);
-
-	lockdep_assert_held(&req->ctx->uring_lock);
-
-	head = xa_load(&req->ctx->io_buffers, bgid);
-	if (head) {
-		if (!list_empty(&head->list)) {
-			kbuf = list_last_entry(&head->list, struct io_buffer,
-							list);
-			list_del(&kbuf->list);
-		} else {
-			kbuf = head;
-			xa_erase(&req->ctx->io_buffers, bgid);
-		}
-		if (*len > kbuf->len)
-			*len = kbuf->len;
-	} else {
-		kbuf = ERR_PTR(-ENOBUFS);
-	}
-
-	io_ring_submit_unlock(req->ctx, needs_lock);
-
-	return kbuf;
-}
-
-static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
-					bool needs_lock)
-{
-	struct io_buffer *kbuf;
-	u16 bgid;
-
-	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
-	bgid = req->buf_index;
-	kbuf = io_buffer_select(req, len, bgid, kbuf, needs_lock);
-	if (IS_ERR(kbuf))
-		return kbuf;
-	req->rw.addr = (u64) (unsigned long) kbuf;
-	req->flags |= REQ_F_BUFFER_SELECTED;
-	return u64_to_user_ptr(kbuf->addr);
-}
-
-#ifdef CONFIG_COMPAT
-static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
-				bool needs_lock)
-{
-	struct compat_iovec __user *uiov;
-	compat_ssize_t clen;
-	void __user *buf;
-	ssize_t len;
-
-	uiov = u64_to_user_ptr(req->rw.addr);
-	if (!access_ok(uiov, sizeof(*uiov)))
-		return -EFAULT;
-	if (__get_user(clen, &uiov->iov_len))
-		return -EFAULT;
-	if (clen < 0)
-		return -EINVAL;
-
-	len = clen;
-	buf = io_rw_buffer_select(req, &len, needs_lock);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
-	iov[0].iov_base = buf;
-	iov[0].iov_len = (compat_size_t) len;
-	return 0;
-}
-#endif
-
-static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
-				      bool needs_lock)
-{
-	struct iovec __user *uiov = u64_to_user_ptr(req->rw.addr);
-	void __user *buf;
-	ssize_t len;
-
-	if (copy_from_user(iov, uiov, sizeof(*uiov)))
-		return -EFAULT;
-
-	len = iov[0].iov_len;
-	if (len < 0)
-		return -EINVAL;
-	buf = io_rw_buffer_select(req, &len, needs_lock);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
-	iov[0].iov_base = buf;
-	iov[0].iov_len = len;
-	return 0;
-}
-
-static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
-				    bool needs_lock)
-{
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		struct io_buffer *kbuf;
-
-		kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
-		iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		iov[0].iov_len = kbuf->len;
-		return 0;
-	}
-	if (req->rw.len != 1)
-		return -EINVAL;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return io_compat_import(req, iov, needs_lock);
-#endif
-
-	return __io_iov_buffer_select(req, iov, needs_lock);
-}
-
-static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
-			   struct iov_iter *iter, bool needs_lock)
-{
-	void __user *buf = u64_to_user_ptr(req->rw.addr);
-	size_t sqe_len = req->rw.len;
-	u8 opcode = req->opcode;
-	ssize_t ret;
-
-	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
-		*iovec = NULL;
-		return io_import_fixed(req, rw, iter);
-	}
-
-	/* buffer index only valid with fixed read/write, or buffer select  */
-	if (req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT))
-		return -EINVAL;
-
-	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
-		if (req->flags & REQ_F_BUFFER_SELECT) {
-			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
-			if (IS_ERR(buf))
-				return PTR_ERR(buf);
-			req->rw.len = sqe_len;
-		}
-
-		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
-		*iovec = NULL;
-		return ret;
-	}
-
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		ret = io_iov_buffer_select(req, *iovec, needs_lock);
-		if (!ret)
-			iov_iter_init(iter, rw, *iovec, 1, (*iovec)->iov_len);
-		*iovec = NULL;
-		return ret;
-	}
-
-	return __import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter,
-			      req->ctx->compat);
-}
-
-static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
-{
-	return (kiocb->ki_filp->f_mode & FMODE_STREAM) ? NULL : &kiocb->ki_pos;
-}
-
-/*
- * For files that don't have ->read_iter() and ->write_iter(), handle them
- * by looping over ->read() or ->write() manually.
- */
-static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
-{
-	struct kiocb *kiocb = &req->rw.kiocb;
-	struct file *file = req->file;
-	ssize_t ret = 0;
-
-	/*
-	 * Don't support polled IO through this interface, and we can't
-	 * support non-blocking either. For the latter, this just causes
-	 * the kiocb to be handled from an async context.
-	 */
-	if (kiocb->ki_flags & IOCB_HIPRI)
-		return -EOPNOTSUPP;
-	if (kiocb->ki_flags & IOCB_NOWAIT)
-		return -EAGAIN;
-
-	while (iov_iter_count(iter)) {
-		struct iovec iovec;
-		ssize_t nr;
-
-		if (!iov_iter_is_bvec(iter)) {
-			iovec = iov_iter_iovec(iter);
-		} else {
-			iovec.iov_base = u64_to_user_ptr(req->rw.addr);
-			iovec.iov_len = req->rw.len;
-		}
-
-		if (rw == READ) {
-			nr = file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, io_kiocb_ppos(kiocb));
-		} else {
-			nr = file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, io_kiocb_ppos(kiocb));
-		}
-
-		if (nr < 0) {
-			if (!ret)
-				ret = nr;
-			break;
-		}
-		ret += nr;
-		if (!iov_iter_is_bvec(iter)) {
-			iov_iter_advance(iter, nr);
-		} else {
-			req->rw.addr += nr;
-			req->rw.len -= nr;
-			if (!req->rw.len)
-				break;
-		}
-		if (nr != iovec.iov_len)
-			break;
-	}
-
-	return ret;
-}
-
-static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
-			  const struct iovec *fast_iov, struct iov_iter *iter)
-{
-	struct io_async_rw *rw = req->async_data;
-
-	memcpy(&rw->iter, iter, sizeof(*iter));
-	rw->free_iovec = iovec;
-	rw->bytes_done = 0;
-	/* can only be fixed buffers, no need to do anything */
-	if (iov_iter_is_bvec(iter))
-		return;
-	if (!iovec) {
-		unsigned iov_off = 0;
-
-		rw->iter.iov = rw->fast_iov;
-		if (iter->iov != fast_iov) {
-			iov_off = iter->iov - fast_iov;
-			rw->iter.iov += iov_off;
-		}
-		if (rw->fast_iov != fast_iov)
-			memcpy(rw->fast_iov + iov_off, fast_iov + iov_off,
-			       sizeof(struct iovec) * iter->nr_segs);
-	} else {
-		req->flags |= REQ_F_NEED_CLEANUP;
-	}
-}
-
-static inline int io_alloc_async_data(struct io_kiocb *req)
-{
-	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
-	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
-	return req->async_data == NULL;
-}
-
-static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
-			     const struct iovec *fast_iov,
-			     struct iov_iter *iter, bool force)
-{
-	if (!force && !io_op_defs[req->opcode].needs_async_setup)
-		return 0;
-	if (!req->async_data) {
-		struct io_async_rw *iorw;
-
-		if (io_alloc_async_data(req)) {
-			kfree(iovec);
-			return -ENOMEM;
-		}
-
-		io_req_map_rw(req, iovec, fast_iov, iter);
-		iorw = req->async_data;
-		/* we've copied and mapped the iter, ensure state is saved */
-		iov_iter_save_state(&iorw->iter, &iorw->iter_state);
-	}
-	return 0;
-}
-
-static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
-{
-	struct io_async_rw *iorw = req->async_data;
-	struct iovec *iov = iorw->fast_iov;
-	int ret;
-
-	ret = io_import_iovec(rw, req, &iov, &iorw->iter, false);
-	if (unlikely(ret < 0))
-		return ret;
-
-	iorw->bytes_done = 0;
-	iorw->free_iovec = iov;
-	if (iov)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	iov_iter_save_state(&iorw->iter, &iorw->iter_state);
-	return 0;
-}
-
-static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(!(req->file->f_mode & FMODE_READ)))
-		return -EBADF;
-	return io_prep_rw(req, sqe, READ);
-}
-
-/*
- * This is our waitqueue callback handler, registered through lock_page_async()
- * when we initially tried to do the IO with the iocb armed our waitqueue.
- * This gets called when the page is unlocked, and we generally expect that to
- * happen when the page IO is completed and the page is now uptodate. This will
- * queue a task_work based retry of the operation, attempting to copy the data
- * again. If the latter fails because the page was NOT uptodate, then we will
- * do a thread based blocking retry of the operation. That's the unexpected
- * slow path.
- */
-static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
-			     int sync, void *arg)
-{
-	struct wait_page_queue *wpq;
-	struct io_kiocb *req = wait->private;
-	struct wait_page_key *key = arg;
-
-	wpq = container_of(wait, struct wait_page_queue, wait);
-
-	if (!wake_page_match(wpq, key))
-		return 0;
-
-	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
-	list_del_init(&wait->entry);
-	io_req_task_queue(req);
-	return 1;
-}
-
-/*
- * This controls whether a given IO request should be armed for async page
- * based retry. If we return false here, the request is handed to the async
- * worker threads for retry. If we're doing buffered reads on a regular file,
- * we prepare a private wait_page_queue entry and retry the operation. This
- * will either succeed because the page is now uptodate and unlocked, or it
- * will register a callback when the page is unlocked at IO completion. Through
- * that callback, io_uring uses task_work to setup a retry of the operation.
- * That retry will attempt the buffered read again. The retry will generally
- * succeed, or in rare cases where it fails, we then fall back to using the
- * async worker threads for a blocking retry.
- */
-static bool io_rw_should_retry(struct io_kiocb *req)
-{
-	struct io_async_rw *rw = req->async_data;
-	struct wait_page_queue *wait = &rw->wpq;
-	struct kiocb *kiocb = &req->rw.kiocb;
-
-	/* never retry for NOWAIT, we just complete with -EAGAIN */
-	if (req->flags & REQ_F_NOWAIT)
-		return false;
-
-	/* Only for buffered IO */
-	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_HIPRI))
-		return false;
-
-	/*
-	 * just use poll if we can, and don't attempt if the fs doesn't
-	 * support callback based unlocks
-	 */
-	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
-		return false;
-
-	wait->wait.func = io_async_buf_func;
-	wait->wait.private = req;
-	wait->wait.flags = 0;
-	INIT_LIST_HEAD(&wait->wait.entry);
-	kiocb->ki_flags |= IOCB_WAITQ;
-	kiocb->ki_flags &= ~IOCB_NOWAIT;
-	kiocb->ki_waitq = wait;
-	return true;
-}
-
-static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
-{
-	if (req->file->f_op->read_iter)
-		return call_read_iter(req->file, &req->rw.kiocb, iter);
-	else if (req->file->f_op->read)
-		return loop_rw_iter(READ, req, iter);
-	else
-		return -EINVAL;
-}
-
-static bool need_read_all(struct io_kiocb *req)
-{
-	return req->flags & REQ_F_ISREG ||
-		S_ISBLK(file_inode(req->file)->i_mode);
-}
-
-static int io_read(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter __iter, *iter = &__iter;
-	struct io_async_rw *rw = req->async_data;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	struct iov_iter_state __state, *state;
-	ssize_t ret, ret2;
-
-	if (rw) {
-		iter = &rw->iter;
-		state = &rw->iter_state;
-		/*
-		 * We come here from an earlier attempt, restore our state to
-		 * match in case it doesn't. It's cheap enough that we don't
-		 * need to make this conditional.
-		 */
-		iov_iter_restore(iter, state);
-		iovec = NULL;
-	} else {
-		ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
-		if (ret < 0)
-			return ret;
-		state = &__state;
-		iov_iter_save_state(iter, state);
-	}
-	req->result = iov_iter_count(iter);
-
-	/* Ensure we clear previously set non-block flag */
-	if (!force_nonblock)
-		kiocb->ki_flags &= ~IOCB_NOWAIT;
-	else
-		kiocb->ki_flags |= IOCB_NOWAIT;
-
-	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_nowait(req, READ)) {
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
-		return ret ?: -EAGAIN;
-	}
-
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
-	if (unlikely(ret)) {
-		kfree(iovec);
-		return ret;
-	}
-
-	ret = io_iter_do_read(req, iter);
-
-	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
-		req->flags &= ~REQ_F_REISSUE;
-		/* IOPOLL retry should happen for io-wq threads */
-		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
-			goto done;
-		/* no retry on NONBLOCK nor RWF_NOWAIT */
-		if (req->flags & REQ_F_NOWAIT)
-			goto done;
-		ret = 0;
-	} else if (ret == -EIOCBQUEUED) {
-		goto out_free;
-	} else if (ret <= 0 || ret == req->result || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
-		/* read all, failed, already did sync or don't want to retry */
-		goto done;
-	}
-
-	/*
-	 * Don't depend on the iter state matching what was consumed, or being
-	 * untouched in case of error. Restore it and we'll advance it
-	 * manually if we need to.
-	 */
-	iov_iter_restore(iter, state);
-
-	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
-	if (ret2)
-		return ret2;
-
-	iovec = NULL;
-	rw = req->async_data;
-	/*
-	 * Now use our persistent iterator and state, if we aren't already.
-	 * We've restored and mapped the iter to match.
-	 */
-	if (iter != &rw->iter) {
-		iter = &rw->iter;
-		state = &rw->iter_state;
-	}
-
-	do {
-		/*
-		 * We end up here because of a partial read, either from
-		 * above or inside this loop. Advance the iter by the bytes
-		 * that were consumed.
-		 */
-		iov_iter_advance(iter, ret);
-		if (!iov_iter_count(iter))
-			break;
-		rw->bytes_done += ret;
-		iov_iter_save_state(iter, state);
-
-		/* if we can retry, do so with the callbacks armed */
-		if (!io_rw_should_retry(req)) {
-			kiocb->ki_flags &= ~IOCB_WAITQ;
-			return -EAGAIN;
-		}
-
-		req->result = iov_iter_count(iter);
-		/*
-		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
-		 * we get -EIOCBQUEUED, then we'll get a notification when the
-		 * desired page gets unlocked. We can also get a partial read
-		 * here, and if we do, then just retry at the new offset.
-		 */
-		ret = io_iter_do_read(req, iter);
-		if (ret == -EIOCBQUEUED)
-			return 0;
-		/* we got some bytes, but not all. retry. */
-		kiocb->ki_flags &= ~IOCB_WAITQ;
-		iov_iter_restore(iter, state);
-	} while (ret > 0);
-done:
-	kiocb_done(kiocb, ret, issue_flags);
-out_free:
-	/* it's faster to check here then delegate to kfree */
-	if (iovec)
-		kfree(iovec);
-	return 0;
-}
-
-static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
-		return -EBADF;
-	return io_prep_rw(req, sqe, WRITE);
-}
-
-static int io_write(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter __iter, *iter = &__iter;
-	struct io_async_rw *rw = req->async_data;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	struct iov_iter_state __state, *state;
-	ssize_t ret, ret2;
-
-	if (rw) {
-		iter = &rw->iter;
-		state = &rw->iter_state;
-		iov_iter_restore(iter, state);
-		iovec = NULL;
-	} else {
-		ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
-		if (ret < 0)
-			return ret;
-		state = &__state;
-		iov_iter_save_state(iter, state);
-	}
-	req->result = iov_iter_count(iter);
-
-	/* Ensure we clear previously set non-block flag */
-	if (!force_nonblock)
-		kiocb->ki_flags &= ~IOCB_NOWAIT;
-	else
-		kiocb->ki_flags |= IOCB_NOWAIT;
-
-	/* If the file doesn't support async, just async punt */
-	if (force_nonblock && !io_file_supports_nowait(req, WRITE))
-		goto copy_iov;
-
-	/* file path doesn't support NOWAIT for non-direct_IO */
-	if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
-	    (req->flags & REQ_F_ISREG))
-		goto copy_iov;
-
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
-	if (unlikely(ret))
-		goto out_free;
-
-	/*
-	 * Open-code file_start_write here to grab freeze protection,
-	 * which will be released by another thread in
-	 * io_complete_rw().  Fool lockdep by telling it the lock got
-	 * released so that it doesn't complain about the held lock when
-	 * we return to userspace.
-	 */
-	if (req->flags & REQ_F_ISREG) {
-		sb_start_write(file_inode(req->file)->i_sb);
-		__sb_writers_release(file_inode(req->file)->i_sb,
-					SB_FREEZE_WRITE);
-	}
-	kiocb->ki_flags |= IOCB_WRITE;
-
-	if (req->file->f_op->write_iter)
-		ret2 = call_write_iter(req->file, kiocb, iter);
-	else if (req->file->f_op->write)
-		ret2 = loop_rw_iter(WRITE, req, iter);
-	else
-		ret2 = -EINVAL;
-
-	if (req->flags & REQ_F_REISSUE) {
-		req->flags &= ~REQ_F_REISSUE;
-		ret2 = -EAGAIN;
-	}
-
-	/*
-	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
-	 * retry them without IOCB_NOWAIT.
-	 */
-	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
-		ret2 = -EAGAIN;
-	/* no retry on NONBLOCK nor RWF_NOWAIT */
-	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
-		goto done;
-	if (!force_nonblock || ret2 != -EAGAIN) {
-		/* IOPOLL retry should happen for io-wq threads */
-		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
-			goto copy_iov;
-done:
-		kiocb_done(kiocb, ret2, issue_flags);
-	} else {
-copy_iov:
-		iov_iter_restore(iter, state);
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-		if (!ret) {
-			if (kiocb->ki_flags & IOCB_WRITE)
-				kiocb_end_write(req);
-			return -EAGAIN;
-		}
-		return ret;
-	}
-out_free:
-	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
-	return ret;
-}
-
-static int io_renameat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-	struct io_rename *ren = &req->rename;
-	const char __user *oldf, *newf;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
-	ren->old_dfd = READ_ONCE(sqe->fd);
-	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	ren->new_dfd = READ_ONCE(sqe->len);
-	ren->flags = READ_ONCE(sqe->rename_flags);
-
-	ren->oldpath = getname(oldf);
-	if (IS_ERR(ren->oldpath))
-		return PTR_ERR(ren->oldpath);
-
-	ren->newpath = getname(newf);
-	if (IS_ERR(ren->newpath)) {
-		putname(ren->oldpath);
-		return PTR_ERR(ren->newpath);
-	}
-
-	req->flags |= REQ_F_NEED_CLEANUP;
-	return 0;
-}
-
-static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_rename *ren = &req->rename;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = do_renameat2(ren->old_dfd, ren->oldpath, ren->new_dfd,
-				ren->newpath, ren->flags);
-
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_unlinkat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-	struct io_unlink *un = &req->unlink;
-	const char __user *fname;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
-	un->dfd = READ_ONCE(sqe->fd);
-
-	un->flags = READ_ONCE(sqe->unlink_flags);
-	if (un->flags & ~AT_REMOVEDIR)
-		return -EINVAL;
-
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	un->filename = getname(fname);
-	if (IS_ERR(un->filename))
-		return PTR_ERR(un->filename);
-
-	req->flags |= REQ_F_NEED_CLEANUP;
-	return 0;
-}
-
-static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_unlink *un = &req->unlink;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	if (un->flags & AT_REMOVEDIR)
-		ret = do_rmdir(un->dfd, un->filename);
-	else
-		ret = do_unlinkat(un->dfd, un->filename);
-
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_mkdirat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-	struct io_mkdir *mkd = &req->mkdir;
-	const char __user *fname;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->rw_flags || sqe->buf_index ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
-	mkd->dfd = READ_ONCE(sqe->fd);
-	mkd->mode = READ_ONCE(sqe->len);
-
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	mkd->filename = getname(fname);
-	if (IS_ERR(mkd->filename))
-		return PTR_ERR(mkd->filename);
-
-	req->flags |= REQ_F_NEED_CLEANUP;
-	return 0;
-}
-
-static int io_mkdirat(struct io_kiocb *req, int issue_flags)
-{
-	struct io_mkdir *mkd = &req->mkdir;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
-
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_symlinkat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-	struct io_symlink *sl = &req->symlink;
-	const char __user *oldpath, *newpath;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->rw_flags || sqe->buf_index ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
-	sl->new_dfd = READ_ONCE(sqe->fd);
-	oldpath = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	newpath = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-
-	sl->oldpath = getname(oldpath);
-	if (IS_ERR(sl->oldpath))
-		return PTR_ERR(sl->oldpath);
-
-	sl->newpath = getname(newpath);
-	if (IS_ERR(sl->newpath)) {
-		putname(sl->oldpath);
-		return PTR_ERR(sl->newpath);
-	}
-
-	req->flags |= REQ_F_NEED_CLEANUP;
-	return 0;
-}
-
-static int io_symlinkat(struct io_kiocb *req, int issue_flags)
-{
-	struct io_symlink *sl = &req->symlink;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
-
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_linkat_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-	struct io_hardlink *lnk = &req->hardlink;
-	const char __user *oldf, *newf;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
-	lnk->old_dfd = READ_ONCE(sqe->fd);
-	lnk->new_dfd = READ_ONCE(sqe->len);
-	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	lnk->flags = READ_ONCE(sqe->hardlink_flags);
-
-	lnk->oldpath = getname(oldf);
-	if (IS_ERR(lnk->oldpath))
-		return PTR_ERR(lnk->oldpath);
-
-	lnk->newpath = getname(newf);
-	if (IS_ERR(lnk->newpath)) {
-		putname(lnk->oldpath);
-		return PTR_ERR(lnk->newpath);
-	}
-
-	req->flags |= REQ_F_NEED_CLEANUP;
-	return 0;
-}
-
-static int io_linkat(struct io_kiocb *req, int issue_flags)
-{
-	struct io_hardlink *lnk = &req->hardlink;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
-				lnk->newpath, lnk->flags);
-
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_shutdown_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-#if defined(CONFIG_NET)
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
-		     sqe->buf_index || sqe->splice_fd_in))
-		return -EINVAL;
-
-	req->shutdown.how = READ_ONCE(sqe->len);
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
-{
-#if defined(CONFIG_NET)
-	struct socket *sock;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
-	ret = __sys_shutdown_sock(sock, req->shutdown.how);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static int __io_splice_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-	struct io_splice *sp = &req->splice;
-	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
-	sp->len = READ_ONCE(sqe->len);
-	sp->flags = READ_ONCE(sqe->splice_flags);
-	if (unlikely(sp->flags & ~valid_flags))
-		return -EINVAL;
-	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
-	return 0;
-}
-
-static int io_tee_prep(struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
-{
-	if (READ_ONCE(sqe->splice_off_in) || READ_ONCE(sqe->off))
-		return -EINVAL;
-	return __io_splice_prep(req, sqe);
-}
-
-static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_splice *sp = &req->splice;
-	struct file *out = sp->file_out;
-	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
-	struct file *in;
-	long ret = 0;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	in = io_file_get(req->ctx, req, sp->splice_fd_in,
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
-	if (!in) {
-		ret = -EBADF;
-		goto done;
-	}
-
-	if (sp->len)
-		ret = do_tee(in, out, sp->len, flags);
-
-	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
-		io_put_file(in);
-done:
-	if (ret != sp->len)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_splice *sp = &req->splice;
-
-	sp->off_in = READ_ONCE(sqe->splice_off_in);
-	sp->off_out = READ_ONCE(sqe->off);
-	return __io_splice_prep(req, sqe);
-}
-
-static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_splice *sp = &req->splice;
-	struct file *out = sp->file_out;
-	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
-	loff_t *poff_in, *poff_out;
-	struct file *in;
-	long ret = 0;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	in = io_file_get(req->ctx, req, sp->splice_fd_in,
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
-	if (!in) {
-		ret = -EBADF;
-		goto done;
-	}
-
-	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
-	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
-
-	if (sp->len)
-		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
-
-	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
-		io_put_file(in);
-done:
-	if (ret != sp->len)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-/*
- * IORING_OP_NOP just posts a completion event, nothing else.
- */
-static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
-	__io_req_complete(req, issue_flags, 0, 0);
-	return 0;
-}
-
-static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
-		     sqe->splice_fd_in))
-		return -EINVAL;
-
-	req->sync.flags = READ_ONCE(sqe->fsync_flags);
-	if (unlikely(req->sync.flags & ~IORING_FSYNC_DATASYNC))
-		return -EINVAL;
-
-	req->sync.off = READ_ONCE(sqe->off);
-	req->sync.len = READ_ONCE(sqe->len);
-	return 0;
-}
-
-static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
-{
-	loff_t end = req->sync.off + req->sync.len;
-	int ret;
-
-	/* fsync always requires a blocking context */
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = vfs_fsync_range(req->file, req->sync.off,
-				end > 0 ? end : LLONG_MAX,
-				req->sync.flags & IORING_FSYNC_DATASYNC);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_fallocate_prep(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe)
-{
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
-	req->sync.off = READ_ONCE(sqe->off);
-	req->sync.len = READ_ONCE(sqe->addr);
-	req->sync.mode = READ_ONCE(sqe->len);
-	return 0;
-}
-
-static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
-{
-	int ret;
-
-	/* fallocate always requiring blocking context */
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
-				req->sync.len);
-	if (ret < 0)
-		req_set_fail(req);
-	else
-		fsnotify_modify(req->file);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	const char __user *fname;
-	int ret;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->ioprio || sqe->buf_index))
-		return -EINVAL;
-	if (unlikely(req->flags & REQ_F_FIXED_FILE))
-		return -EBADF;
-
-	/* open.how should be already initialised */
-	if (!(req->open.how.flags & O_PATH) && force_o_largefile())
-		req->open.how.flags |= O_LARGEFILE;
-
-	req->open.dfd = READ_ONCE(sqe->fd);
-	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	req->open.filename = getname(fname);
-	if (IS_ERR(req->open.filename)) {
-		ret = PTR_ERR(req->open.filename);
-		req->open.filename = NULL;
-		return ret;
-	}
-
-	req->open.file_slot = READ_ONCE(sqe->file_index);
-	if (req->open.file_slot && (req->open.how.flags & O_CLOEXEC))
-		return -EINVAL;
-
-	req->open.nofile = rlimit(RLIMIT_NOFILE);
-	req->flags |= REQ_F_NEED_CLEANUP;
-	return 0;
-}
-
-static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	u64 mode = READ_ONCE(sqe->len);
-	u64 flags = READ_ONCE(sqe->open_flags);
-
-	req->open.how = build_open_how(flags, mode);
-	return __io_openat_prep(req, sqe);
-}
-
-static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct open_how __user *how;
-	size_t len;
-	int ret;
-
-	how = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	len = READ_ONCE(sqe->len);
-	if (len < OPEN_HOW_SIZE_VER0)
-		return -EINVAL;
-
-	ret = copy_struct_from_user(&req->open.how, sizeof(req->open.how), how,
-					len);
-	if (ret)
-		return ret;
-
-	return __io_openat_prep(req, sqe);
-}
-
-static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct open_flags op;
-	struct file *file;
-	bool resolve_nonblock, nonblock_set;
-	bool fixed = !!req->open.file_slot;
-	int ret;
-
-	ret = build_open_flags(&req->open.how, &op);
-	if (ret)
-		goto err;
-	nonblock_set = op.open_flag & O_NONBLOCK;
-	resolve_nonblock = req->open.how.resolve & RESOLVE_CACHED;
-	if (issue_flags & IO_URING_F_NONBLOCK) {
-		/*
-		 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
-		 * it'll always -EAGAIN
-		 */
-		if (req->open.how.flags & (O_TRUNC | O_CREAT | O_TMPFILE))
-			return -EAGAIN;
-		op.lookup_flags |= LOOKUP_CACHED;
-		op.open_flag |= O_NONBLOCK;
-	}
-
-	if (!fixed) {
-		ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
-		if (ret < 0)
-			goto err;
-	}
-
-	file = do_filp_open(req->open.dfd, req->open.filename, &op);
-	if (IS_ERR(file)) {
-		/*
-		 * We could hang on to this 'fd' on retrying, but seems like
-		 * marginal gain for something that is now known to be a slower
-		 * path. So just put it, and we'll get a new one when we retry.
-		 */
-		if (!fixed)
-			put_unused_fd(ret);
-
-		ret = PTR_ERR(file);
-		/* only retry if RESOLVE_CACHED wasn't already set by application */
-		if (ret == -EAGAIN &&
-		    (!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK)))
-			return -EAGAIN;
-		goto err;
-	}
-
-	if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
-		file->f_flags &= ~O_NONBLOCK;
-	fsnotify_open(file);
-
-	if (!fixed)
-		fd_install(ret, file);
-	else
-		ret = io_install_fixed_file(req, file, issue_flags,
-					    req->open.file_slot - 1);
-err:
-	putname(req->open.filename);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int io_openat(struct io_kiocb *req, unsigned int issue_flags)
-{
-	return io_openat2(req, issue_flags);
-}
-
-static int io_remove_buffers_prep(struct io_kiocb *req,
-				  const struct io_uring_sqe *sqe)
-{
-	struct io_provide_buf *p = &req->pbuf;
-	u64 tmp;
-
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-
-	tmp = READ_ONCE(sqe->fd);
-	if (!tmp || tmp > USHRT_MAX)
-		return -EINVAL;
-
-	memset(p, 0, sizeof(*p));
-	p->nbufs = tmp;
-	p->bgid = READ_ONCE(sqe->buf_group);
-	return 0;
-}
-
-static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
-			       int bgid, unsigned nbufs)
-{
-	unsigned i = 0;
-
-	/* shouldn't happen */
-	if (!nbufs)
-		return 0;
-
-	/* the head kbuf is the list itself */
-	while (!list_empty(&buf->list)) {
-		struct io_buffer *nxt;
-
-		nxt = list_first_entry(&buf->list, struct io_buffer, list);
-		list_del(&nxt->list);
-		kfree(nxt);
-		if (++i == nbufs)
-			return i;
-		cond_resched();
-	}
-	i++;
-	kfree(buf);
-	xa_erase(&ctx->io_buffers, bgid);
-
-	return i;
-}
-
-static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_provide_buf *p = &req->pbuf;
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer *head;
-	int ret = 0;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-
-	io_ring_submit_lock(ctx, !force_nonblock);
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	ret = -ENOENT;
-	head = xa_load(&ctx->io_buffers, p->bgid);
-	if (head)
-		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
-	if (ret < 0)
-		req_set_fail(req);
-
-	/* complete before unlock, IOPOLL may need the lock */
-	__io_req_complete(req, issue_flags, ret, 0);
-	io_ring_submit_unlock(ctx, !force_nonblock);
-	return 0;
-}
-
-static int io_provide_buffers_prep(struct io_kiocb *req,
-				   const struct io_uring_sqe *sqe)
-{
-	unsigned long size, tmp_check;
-	struct io_provide_buf *p = &req->pbuf;
-	u64 tmp;
-
-	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
-		return -EINVAL;
-
-	tmp = READ_ONCE(sqe->fd);
-	if (!tmp || tmp > USHRT_MAX)
-		return -E2BIG;
-	p->nbufs = tmp;
-	p->addr = READ_ONCE(sqe->addr);
-	p->len = READ_ONCE(sqe->len);
-
-	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
-				&size))
-		return -EOVERFLOW;
-	if (check_add_overflow((unsigned long)p->addr, size, &tmp_check))
-		return -EOVERFLOW;
-
-	size = (unsigned long)p->len * p->nbufs;
-	if (!access_ok(u64_to_user_ptr(p->addr), size))
-		return -EFAULT;
-
-	p->bgid = READ_ONCE(sqe->buf_group);
-	tmp = READ_ONCE(sqe->off);
-	if (tmp > USHRT_MAX)
-		return -E2BIG;
-	p->bid = tmp;
-	return 0;
-}
-
-static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
-{
-	struct io_buffer *buf;
-	u64 addr = pbuf->addr;
-	int i, bid = pbuf->bid;
-
-	for (i = 0; i < pbuf->nbufs; i++) {
-		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
-		if (!buf)
-			break;
-
-		buf->addr = addr;
-		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
-		buf->bid = bid;
-		addr += pbuf->len;
-		bid++;
-		if (!*head) {
-			INIT_LIST_HEAD(&buf->list);
-			*head = buf;
-		} else {
-			list_add_tail(&buf->list, &(*head)->list);
-		}
-		cond_resched();
-	}
-
-	return i ? i : -ENOMEM;
-}
-
-static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_provide_buf *p = &req->pbuf;
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer *head, *list;
-	int ret = 0;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-
-	io_ring_submit_lock(ctx, !force_nonblock);
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	list = head = xa_load(&ctx->io_buffers, p->bgid);
-
-	ret = io_add_buffers(p, &head);
-	if (ret >= 0 && !list) {
-		ret = xa_insert(&ctx->io_buffers, p->bgid, head,
-				GFP_KERNEL_ACCOUNT);
-		if (ret < 0)
-			__io_remove_buffers(ctx, head, p->bgid, -1U);
-	}
-	if (ret < 0)
-		req_set_fail(req);
-	/* complete before unlock, IOPOLL may need the lock */
-	__io_req_complete(req, issue_flags, ret, 0);
-	io_ring_submit_unlock(ctx, !force_nonblock);
-	return 0;
-}
-
-static int io_epoll_ctl_prep(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe)
-{
-#if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
-	req->epoll.epfd = READ_ONCE(sqe->fd);
-	req->epoll.op = READ_ONCE(sqe->len);
-	req->epoll.fd = READ_ONCE(sqe->off);
-
-	if (ep_op_has_event(req->epoll.op)) {
-		struct epoll_event __user *ev;
-
-		ev = u64_to_user_ptr(READ_ONCE(sqe->addr));
-		if (copy_from_user(&req->epoll.event, ev, sizeof(*ev)))
-			return -EFAULT;
-	}
-
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
-{
-#if defined(CONFIG_EPOLL)
-	struct io_epoll *ie = &req->epoll;
-	int ret;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-
-	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
-
-	if (ret < 0)
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
-	req->madvise.addr = READ_ONCE(sqe->addr);
-	req->madvise.len = READ_ONCE(sqe->len);
-	req->madvise.advice = READ_ONCE(sqe->fadvise_advice);
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
-{
-#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	struct io_madvise *ma = &req->madvise;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
-	req->fadvise.offset = READ_ONCE(sqe->off);
-	req->fadvise.len = READ_ONCE(sqe->len);
-	req->fadvise.advice = READ_ONCE(sqe->fadvise_advice);
-	return 0;
-}
-
-static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_fadvise *fa = &req->fadvise;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK) {
-		switch (fa->advice) {
-		case POSIX_FADV_NORMAL:
-		case POSIX_FADV_RANDOM:
-		case POSIX_FADV_SEQUENTIAL:
-			break;
-		default:
-			return -EAGAIN;
-		}
-	}
-
-	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
-	if (ret < 0)
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
-		return -EINVAL;
-	if (req->flags & REQ_F_FIXED_FILE)
-		return -EBADF;
-
-	req->statx.dfd = READ_ONCE(sqe->fd);
-	req->statx.mask = READ_ONCE(sqe->len);
-	req->statx.filename = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	req->statx.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	req->statx.flags = READ_ONCE(sqe->statx_flags);
-
-	return 0;
-}
-
-static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_statx *ctx = &req->statx;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
-		       ctx->buffer);
-
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index)
-		return -EINVAL;
-	if (req->flags & REQ_F_FIXED_FILE)
-		return -EBADF;
-
-	req->close.fd = READ_ONCE(sqe->fd);
-	req->close.file_slot = READ_ONCE(sqe->file_index);
-	if (req->close.file_slot && req->close.fd)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int io_close(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct files_struct *files = current->files;
-	struct io_close *close = &req->close;
-	struct fdtable *fdt;
-	struct file *file = NULL;
-	int ret = -EBADF;
-
-	if (req->close.file_slot) {
-		ret = io_close_fixed(req, issue_flags);
-		goto err;
-	}
-
-	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
-	if (close->fd >= fdt->max_fds) {
-		spin_unlock(&files->file_lock);
-		goto err;
-	}
-	file = fdt->fd[close->fd];
-	if (!file || file->f_op == &io_uring_fops) {
-		spin_unlock(&files->file_lock);
-		file = NULL;
-		goto err;
-	}
-
-	/* if the file has a flush method, be safe and punt to async */
-	if (file->f_op->flush && (issue_flags & IO_URING_F_NONBLOCK)) {
-		spin_unlock(&files->file_lock);
-		return -EAGAIN;
-	}
-
-	ret = __close_fd_get_file(close->fd, &file);
-	spin_unlock(&files->file_lock);
-	if (ret < 0) {
-		if (ret == -ENOENT)
-			ret = -EBADF;
-		goto err;
-	}
-
-	/* No ->flush() or already async, safely close from here */
-	ret = filp_close(file, current->files);
-err:
-	if (ret < 0)
-		req_set_fail(req);
-	if (file)
-		fput(file);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
-		     sqe->splice_fd_in))
-		return -EINVAL;
-
-	req->sync.off = READ_ONCE(sqe->off);
-	req->sync.len = READ_ONCE(sqe->len);
-	req->sync.flags = READ_ONCE(sqe->sync_range_flags);
-	return 0;
-}
-
-static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
-{
-	int ret;
-
-	/* sync_file_range always requires a blocking context */
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
-				req->sync.flags);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete(req, ret);
-	return 0;
-}
-
-#if defined(CONFIG_NET)
-static int io_setup_async_msg(struct io_kiocb *req,
-			      struct io_async_msghdr *kmsg)
-{
-	struct io_async_msghdr *async_msg = req->async_data;
-
-	if (async_msg)
-		return -EAGAIN;
-	if (io_alloc_async_data(req)) {
-		kfree(kmsg->free_iov);
-		return -ENOMEM;
-	}
-	async_msg = req->async_data;
-	req->flags |= REQ_F_NEED_CLEANUP;
-	memcpy(async_msg, kmsg, sizeof(*kmsg));
-	if (async_msg->msg.msg_name)
-		async_msg->msg.msg_name = &async_msg->addr;
-	/* if were using fast_iov, set it to the new one */
-	if (!async_msg->free_iov)
-		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
-
-	return -EAGAIN;
-}
-
-static int io_sendmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->free_iov = iomsg->fast_iov;
-	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
-				   req->sr_msg.msg_flags, &iomsg->free_iov);
-}
-
-static int io_sendmsg_prep_async(struct io_kiocb *req)
-{
-	int ret;
-
-	ret = io_sendmsg_copy_hdr(req, req->async_data);
-	if (!ret)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	return ret;
-}
-
-static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
-		return -EINVAL;
-
-	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	sr->len = READ_ONCE(sqe->len);
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
-	if (sr->msg_flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		sr->msg_flags |= MSG_CMSG_COMPAT;
-#endif
-	return 0;
-}
-
-static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_async_msghdr iomsg, *kmsg;
-	struct socket *sock;
-	unsigned flags;
-	int min_ret = 0;
-	int ret;
-
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
-	kmsg = req->async_data;
-	if (!kmsg) {
-		ret = io_sendmsg_copy_hdr(req, &iomsg);
-		if (ret)
-			return ret;
-		kmsg = &iomsg;
-	}
-
-	flags = req->sr_msg.msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
-
-	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret)
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int io_send(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-	struct msghdr msg;
-	struct iovec iov;
-	struct socket *sock;
-	unsigned flags;
-	int min_ret = 0;
-	int ret;
-
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
-	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
-
-	msg.msg_name = NULL;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_namelen = 0;
-
-	flags = req->sr_msg.msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&msg.msg_iter);
-
-	msg.msg_flags = flags;
-	ret = sock_sendmsg(sock, &msg);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	if (ret < min_ret)
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
-				 struct io_async_msghdr *iomsg)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-	struct iovec __user *uiov;
-	size_t iov_len;
-	int ret;
-
-	ret = __copy_msghdr_from_user(&iomsg->msg, sr->umsg,
-					&iomsg->uaddr, &uiov, &iov_len);
-	if (ret)
-		return ret;
-
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		if (iov_len > 1)
-			return -EINVAL;
-		if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
-			return -EFAULT;
-		sr->len = iomsg->fast_iov[0].iov_len;
-		iomsg->free_iov = NULL;
-	} else {
-		iomsg->free_iov = iomsg->fast_iov;
-		ret = __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
-				     &iomsg->free_iov, &iomsg->msg.msg_iter,
-				     false);
-		if (ret > 0)
-			ret = 0;
-	}
-
-	return ret;
-}
-
-#ifdef CONFIG_COMPAT
-static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
-					struct io_async_msghdr *iomsg)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-	struct compat_iovec __user *uiov;
-	compat_uptr_t ptr;
-	compat_size_t len;
-	int ret;
-
-	ret = __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr,
-				  &ptr, &len);
-	if (ret)
-		return ret;
-
-	uiov = compat_ptr(ptr);
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		compat_ssize_t clen;
-
-		if (len > 1)
-			return -EINVAL;
-		if (!access_ok(uiov, sizeof(*uiov)))
-			return -EFAULT;
-		if (__get_user(clen, &uiov->iov_len))
-			return -EFAULT;
-		if (clen < 0)
-			return -EINVAL;
-		sr->len = clen;
-		iomsg->free_iov = NULL;
-	} else {
-		iomsg->free_iov = iomsg->fast_iov;
-		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
-				   UIO_FASTIOV, &iomsg->free_iov,
-				   &iomsg->msg.msg_iter, true);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-#endif
-
-static int io_recvmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	iomsg->msg.msg_name = &iomsg->addr;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return __io_compat_recvmsg_copy_hdr(req, iomsg);
-#endif
-
-	return __io_recvmsg_copy_hdr(req, iomsg);
-}
-
-static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
-					       bool needs_lock)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-	struct io_buffer *kbuf;
-
-	kbuf = io_buffer_select(req, &sr->len, sr->bgid, sr->kbuf, needs_lock);
-	if (IS_ERR(kbuf))
-		return kbuf;
-
-	sr->kbuf = kbuf;
-	req->flags |= REQ_F_BUFFER_SELECTED;
-	return kbuf;
-}
-
-static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
-{
-	return io_put_kbuf(req, req->sr_msg.kbuf);
-}
-
-static int io_recvmsg_prep_async(struct io_kiocb *req)
-{
-	int ret;
-
-	ret = io_recvmsg_copy_hdr(req, req->async_data);
-	if (!ret)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	return ret;
-}
-
-static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
-		return -EINVAL;
-
-	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	sr->len = READ_ONCE(sqe->len);
-	sr->bgid = READ_ONCE(sqe->buf_group);
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
-	if (sr->msg_flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		sr->msg_flags |= MSG_CMSG_COMPAT;
-#endif
-	return 0;
-}
-
-static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_async_msghdr iomsg, *kmsg;
-	struct socket *sock;
-	struct io_buffer *kbuf;
-	unsigned flags;
-	int min_ret = 0;
-	int ret, cflags = 0;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
-	kmsg = req->async_data;
-	if (!kmsg) {
-		ret = io_recvmsg_copy_hdr(req, &iomsg);
-		if (ret)
-			return ret;
-		kmsg = &iomsg;
-	}
-
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, !force_nonblock);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		kmsg->fast_iov[0].iov_len = req->sr_msg.len;
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
-				1, req->sr_msg.len);
-	}
-
-	flags = req->sr_msg.msg_flags;
-	if (force_nonblock)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
-
-	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
-					kmsg->uaddr, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		cflags = io_put_recv_kbuf(req);
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, cflags);
-	return 0;
-}
-
-static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_buffer *kbuf;
-	struct io_sr_msg *sr = &req->sr_msg;
-	struct msghdr msg;
-	void __user *buf = sr->buf;
-	struct socket *sock;
-	struct iovec iov;
-	unsigned flags;
-	int min_ret = 0;
-	int ret, cflags = 0;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, !force_nonblock);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		buf = u64_to_user_ptr(kbuf->addr);
-	}
-
-	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
-		goto out_free;
-
-	msg.msg_name = NULL;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_namelen = 0;
-	msg.msg_iocb = NULL;
-	msg.msg_flags = 0;
-
-	flags = req->sr_msg.msg_flags;
-	if (force_nonblock)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&msg.msg_iter);
-
-	ret = sock_recvmsg(sock, &msg, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-out_free:
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		cflags = io_put_recv_kbuf(req);
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, cflags);
-	return 0;
-}
-
-static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_accept *accept = &req->accept;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
-		return -EINVAL;
-
-	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	accept->flags = READ_ONCE(sqe->accept_flags);
-	accept->nofile = rlimit(RLIMIT_NOFILE);
-
-	accept->file_slot = READ_ONCE(sqe->file_index);
-	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
-		return -EINVAL;
-	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
-		return -EINVAL;
-	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
-		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
-	return 0;
-}
-
-static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_accept *accept = &req->accept;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
-	bool fixed = !!accept->file_slot;
-	struct file *file;
-	int ret, fd;
-
-	if (req->file->f_flags & O_NONBLOCK)
-		req->flags |= REQ_F_NOWAIT;
-
-	if (!fixed) {
-		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
-		if (unlikely(fd < 0))
-			return fd;
-	}
-	file = do_accept(req->file, file_flags, accept->addr, accept->addr_len,
-			 accept->flags);
-	if (IS_ERR(file)) {
-		if (!fixed)
-			put_unused_fd(fd);
-		ret = PTR_ERR(file);
-		if (ret == -EAGAIN && force_nonblock)
-			return -EAGAIN;
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
-		req_set_fail(req);
-	} else if (!fixed) {
-		fd_install(fd, file);
-		ret = fd;
-	} else {
-		ret = io_install_fixed_file(req, file, issue_flags,
-					    accept->file_slot - 1);
-	}
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int io_connect_prep_async(struct io_kiocb *req)
-{
-	struct io_async_connect *io = req->async_data;
-	struct io_connect *conn = &req->connect;
-
-	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->address);
-}
-
-static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_connect *conn = &req->connect;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-
-	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	conn->addr_len =  READ_ONCE(sqe->addr2);
-	return 0;
-}
-
-static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_async_connect __io, *io;
-	unsigned file_flags;
-	int ret;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-
-	if (req->async_data) {
-		io = req->async_data;
-	} else {
-		ret = move_addr_to_kernel(req->connect.addr,
-						req->connect.addr_len,
-						&__io.address);
-		if (ret)
-			goto out;
-		io = &__io;
-	}
-
-	file_flags = force_nonblock ? O_NONBLOCK : 0;
-
-	ret = __sys_connect_file(req->file, &io->address,
-					req->connect.addr_len, file_flags);
-	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		if (req->async_data)
-			return -EAGAIN;
-		if (io_alloc_async_data(req)) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		memcpy(req->async_data, &__io, sizeof(__io));
-		return -EAGAIN;
-	}
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-out:
-	if (ret < 0)
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-#else /* !CONFIG_NET */
-#define IO_NETOP_FN(op)							\
-static int io_##op(struct io_kiocb *req, unsigned int issue_flags)	\
-{									\
-	return -EOPNOTSUPP;						\
-}
-
-#define IO_NETOP_PREP(op)						\
-IO_NETOP_FN(op)								\
-static int io_##op##_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe) \
-{									\
-	return -EOPNOTSUPP;						\
-}									\
-
-#define IO_NETOP_PREP_ASYNC(op)						\
-IO_NETOP_PREP(op)							\
-static int io_##op##_prep_async(struct io_kiocb *req)			\
-{									\
-	return -EOPNOTSUPP;						\
-}
-
-IO_NETOP_PREP_ASYNC(sendmsg);
-IO_NETOP_PREP_ASYNC(recvmsg);
-IO_NETOP_PREP_ASYNC(connect);
-IO_NETOP_PREP(accept);
-IO_NETOP_FN(send);
-IO_NETOP_FN(recv);
-#endif /* CONFIG_NET */
-
-struct io_poll_table {
-	struct poll_table_struct pt;
-	struct io_kiocb *req;
-	int nr_entries;
-	int error;
-};
-
-#define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_RETRY_FLAG	BIT(30)
-#define IO_POLL_REF_MASK	GENMASK(29, 0)
-
-/*
- * We usually have 1-2 refs taken, 128 is more than enough and we want to
- * maximise the margin between this amount and the moment when it overflows.
- */
-#define IO_POLL_REF_BIAS       128
-
-static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
-{
-	int v;
-
-	/*
-	 * poll_refs are already elevated and we don't have much hope for
-	 * grabbing the ownership. Instead of incrementing set a retry flag
-	 * to notify the loop that there might have been some change.
-	 */
-	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
-	if (v & IO_POLL_REF_MASK)
-		return false;
-	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
-}
-
-/*
- * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
- * bump it and acquire ownership. It's disallowed to modify requests while not
- * owning it, that prevents from races for enqueueing task_work's and b/w
- * arming poll and wakeups.
- */
-static inline bool io_poll_get_ownership(struct io_kiocb *req)
-{
-	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
-		return io_poll_get_ownership_slowpath(req);
-	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
-}
-
-static void io_poll_mark_cancelled(struct io_kiocb *req)
-{
-	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
-}
-
-static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
-{
-	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
-	if (req->opcode == IORING_OP_POLL_ADD)
-		return req->async_data;
-	return req->apoll->double_poll;
-}
-
-static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
-{
-	if (req->opcode == IORING_OP_POLL_ADD)
-		return &req->poll;
-	return &req->apoll->poll;
-}
-
-static void io_poll_req_insert(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
-
-	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
-	hlist_add_head(&req->hash_node, list);
-}
-
-static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
-			      wait_queue_func_t wake_func)
-{
-	poll->head = NULL;
-#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
-	/* mask in events that we always want/need */
-	poll->events = events | IO_POLL_UNMASK;
-	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, wake_func);
-}
-
-static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
-{
-	struct wait_queue_head *head = smp_load_acquire(&poll->head);
-
-	if (head) {
-		spin_lock_irq(&head->lock);
-		list_del_init(&poll->wait.entry);
-		poll->head = NULL;
-		spin_unlock_irq(&head->lock);
-	}
-}
-
-static void io_poll_remove_entries(struct io_kiocb *req)
-{
-	struct io_poll_iocb *poll = io_poll_get_single(req);
-	struct io_poll_iocb *poll_double = io_poll_get_double(req);
-
-	/*
-	 * While we hold the waitqueue lock and the waitqueue is nonempty,
-	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
-	 * lock in the first place can race with the waitqueue being freed.
-	 *
-	 * We solve this as eventpoll does: by taking advantage of the fact that
-	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
-	 * we enter rcu_read_lock() and see that the pointer to the queue is
-	 * non-NULL, we can then lock it without the memory being freed out from
-	 * under us.
-	 *
-	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
-	 * case the caller deletes the entry from the queue, leaving it empty.
-	 * In that case, only RCU prevents the queue memory from being freed.
-	 */
-	rcu_read_lock();
-	io_poll_remove_entry(poll);
-	if (poll_double)
-		io_poll_remove_entry(poll_double);
-	rcu_read_unlock();
-}
-
-/*
- * All poll tw should go through this. Checks for poll events, manages
- * references, does rewait, etc.
- *
- * Returns a negative error on failure. >0 when no action require, which is
- * either spurious wakeup or multishot CQE is served. 0 when it's done with
- * the request, then the mask is stored in req->result.
- */
-static int io_poll_check_events(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_poll_iocb *poll = io_poll_get_single(req);
-	int v;
-
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
-		io_poll_mark_cancelled(req);
-
-	do {
-		v = atomic_read(&req->poll_refs);
-
-		/* tw handler should be the owner, and so have some references */
-		if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
-			return 0;
-		if (v & IO_POLL_CANCEL_FLAG)
-			return -ECANCELED;
-		/*
-		 * cqe.res contains only events of the first wake up
-		 * and all others are be lost. Redo vfs_poll() to get
-		 * up to date state.
-		 */
-		if ((v & IO_POLL_REF_MASK) != 1)
-			req->result = 0;
-		if (v & IO_POLL_RETRY_FLAG) {
-			req->result = 0;
-			/*
-			 * We won't find new events that came in between
-			 * vfs_poll and the ref put unless we clear the
-			 * flag in advance.
-			 */
-			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
-			v &= ~IO_POLL_RETRY_FLAG;
-		}
-
-		if (!req->result) {
-			struct poll_table_struct pt = { ._key = poll->events };
-
-			req->result = vfs_poll(req->file, &pt) & poll->events;
-		}
-
-		/* multishot, just fill an CQE and proceed */
-		if (req->result && !(poll->events & EPOLLONESHOT)) {
-			__poll_t mask = mangle_poll(req->result & poll->events);
-			bool filled;
-
-			spin_lock(&ctx->completion_lock);
-			filled = io_fill_cqe_aux(ctx, req->user_data, mask,
-						 IORING_CQE_F_MORE);
-			io_commit_cqring(ctx);
-			spin_unlock(&ctx->completion_lock);
-			if (unlikely(!filled))
-				return -ECANCELED;
-			io_cqring_ev_posted(ctx);
-		} else if (req->result) {
-			return 0;
-		}
-
-		/* force the next iteration to vfs_poll() */
-		req->result = 0;
-
-		/*
-		 * Release all references, retry if someone tried to restart
-		 * task_work while we were executing it.
-		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
-					IO_POLL_REF_MASK);
-
-	return 1;
-}
-
-static void io_poll_task_func(struct io_kiocb *req, bool *locked)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
-
-	ret = io_poll_check_events(req);
-	if (ret > 0)
-		return;
-
-	if (!ret) {
-		req->result = mangle_poll(req->result & req->poll.events);
-	} else {
-		req->result = ret;
-		req_set_fail(req);
-	}
-
-	io_poll_remove_entries(req);
-	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
-	spin_unlock(&ctx->completion_lock);
-	io_req_complete_post(req, req->result, 0);
-}
-
-static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
-
-	ret = io_poll_check_events(req);
-	if (ret > 0)
-		return;
-
-	io_poll_remove_entries(req);
-	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
-	spin_unlock(&ctx->completion_lock);
-
-	if (!ret)
-		io_req_task_submit(req, locked);
-	else
-		io_req_complete_failed(req, ret);
-}
-
-static void __io_poll_execute(struct io_kiocb *req, int mask)
-{
-	req->result = mask;
-	if (req->opcode == IORING_OP_POLL_ADD)
-		req->io_task_work.func = io_poll_task_func;
-	else
-		req->io_task_work.func = io_apoll_task_func;
-
-	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
-	io_req_task_work_add(req);
-}
-
-static inline void io_poll_execute(struct io_kiocb *req, int res)
-{
-	if (io_poll_get_ownership(req))
-		__io_poll_execute(req, res);
-}
-
-static void io_poll_cancel_req(struct io_kiocb *req)
-{
-	io_poll_mark_cancelled(req);
-	/* kick tw, which should complete the request */
-	io_poll_execute(req, 0);
-}
-
-static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-			void *key)
-{
-	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = container_of(wait, struct io_poll_iocb,
-						 wait);
-	__poll_t mask = key_to_poll(key);
-
-	if (unlikely(mask & POLLFREE)) {
-		io_poll_mark_cancelled(req);
-		/* we have to kick tw in case it's not already */
-		io_poll_execute(req, 0);
-
-		/*
-		 * If the waitqueue is being freed early but someone is already
-		 * holds ownership over it, we have to tear down the request as
-		 * best we can. That means immediately removing the request from
-		 * its waitqueue and preventing all further accesses to the
-		 * waitqueue via the request.
-		 */
-		list_del_init(&poll->wait.entry);
-
-		/*
-		 * Careful: this *must* be the last step, since as soon
-		 * as req->head is NULL'ed out, the request can be
-		 * completed and freed, since aio_poll_complete_work()
-		 * will no longer need to take the waitqueue lock.
-		 */
-		smp_store_release(&poll->head, NULL);
-		return 1;
-	}
-
-	/* for instances that support it check for an event match first */
-	if (mask && !(mask & poll->events))
-		return 0;
-
-	if (io_poll_get_ownership(req))
-		__io_poll_execute(req, mask);
-	return 1;
-}
-
-static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
-			    struct wait_queue_head *head,
-			    struct io_poll_iocb **poll_ptr)
-{
-	struct io_kiocb *req = pt->req;
-
-	/*
-	 * The file being polled uses multiple waitqueues for poll handling
-	 * (e.g. one for read, one for write). Setup a separate io_poll_iocb
-	 * if this happens.
-	 */
-	if (unlikely(pt->nr_entries)) {
-		struct io_poll_iocb *first = poll;
-
-		/* double add on the same waitqueue head, ignore */
-		if (first->head == head)
-			return;
-		/* already have a 2nd entry, fail a third attempt */
-		if (*poll_ptr) {
-			if ((*poll_ptr)->head == head)
-				return;
-			pt->error = -EINVAL;
-			return;
-		}
-
-		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
-		if (!poll) {
-			pt->error = -ENOMEM;
-			return;
-		}
-		io_init_poll_iocb(poll, first->events, first->wait.func);
-		*poll_ptr = poll;
-	}
-
-	pt->nr_entries++;
-	poll->head = head;
-	poll->wait.private = req;
-
-	if (poll->events & EPOLLEXCLUSIVE)
-		add_wait_queue_exclusive(head, &poll->wait);
-	else
-		add_wait_queue(head, &poll->wait);
-}
-
-static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
-			       struct poll_table_struct *p)
-{
-	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-
-	__io_queue_proc(&pt->req->poll, pt, head,
-			(struct io_poll_iocb **) &pt->req->async_data);
-}
-
-static int __io_arm_poll_handler(struct io_kiocb *req,
-				 struct io_poll_iocb *poll,
-				 struct io_poll_table *ipt, __poll_t mask)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	INIT_HLIST_NODE(&req->hash_node);
-	io_init_poll_iocb(poll, mask, io_poll_wake);
-	poll->file = req->file;
-	poll->wait.private = req;
-
-	ipt->pt._key = mask;
-	ipt->req = req;
-	ipt->error = 0;
-	ipt->nr_entries = 0;
-
-	/*
-	 * Take the ownership to delay any tw execution up until we're done
-	 * with poll arming. see io_poll_get_ownership().
-	 */
-	atomic_set(&req->poll_refs, 1);
-	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
-
-	if (mask && (poll->events & EPOLLONESHOT)) {
-		io_poll_remove_entries(req);
-		/* no one else has access to the req, forget about the ref */
-		return mask;
-	}
-	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
-		io_poll_remove_entries(req);
-		if (!ipt->error)
-			ipt->error = -EINVAL;
-		return 0;
-	}
-
-	spin_lock(&ctx->completion_lock);
-	io_poll_req_insert(req);
-	spin_unlock(&ctx->completion_lock);
-
-	if (mask) {
-		/* can't multishot if failed, just queue the event we've got */
-		if (unlikely(ipt->error || !ipt->nr_entries)) {
-			poll->events |= EPOLLONESHOT;
-			ipt->error = 0;
-		}
-		__io_poll_execute(req, mask);
-		return 0;
-	}
-
-	/*
-	 * Try to release ownership. If we see a change of state, e.g.
-	 * poll was waken up, queue up a tw, it'll deal with it.
-	 */
-	if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
-		__io_poll_execute(req, 0);
-	return 0;
-}
-
-static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
-			       struct poll_table_struct *p)
-{
-	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-	struct async_poll *apoll = pt->req->apoll;
-
-	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
-}
-
-enum {
-	IO_APOLL_OK,
-	IO_APOLL_ABORTED,
-	IO_APOLL_READY
-};
-
-static int io_arm_poll_handler(struct io_kiocb *req)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-	struct io_ring_ctx *ctx = req->ctx;
-	struct async_poll *apoll;
-	struct io_poll_table ipt;
-	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
-	int ret;
-
-	if (!req->file || !file_can_poll(req->file))
-		return IO_APOLL_ABORTED;
-	if (req->flags & REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
-	if (!def->pollin && !def->pollout)
-		return IO_APOLL_ABORTED;
-
-	if (def->pollin) {
-		mask |= POLLIN | POLLRDNORM;
-
-		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
-		if ((req->opcode == IORING_OP_RECVMSG) &&
-		    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
-			mask &= ~POLLIN;
-	} else {
-		mask |= POLLOUT | POLLWRNORM;
-	}
-
-	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
-	if (unlikely(!apoll))
-		return IO_APOLL_ABORTED;
-	apoll->double_poll = NULL;
-	req->apoll = apoll;
-	req->flags |= REQ_F_POLLED;
-	ipt.pt._qproc = io_async_queue_proc;
-
-	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
-	if (ret || ipt.error)
-		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
-
-	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
-				mask, apoll->poll.events);
-	return IO_APOLL_OK;
-}
-
-/*
- * Returns true if we found and killed one or more poll requests
- */
-static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			       bool cancel_all)
-{
-	struct hlist_node *tmp;
-	struct io_kiocb *req;
-	bool found = false;
-	int i;
-
-	spin_lock(&ctx->completion_lock);
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list;
-
-		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_match_task_safe(req, tsk, cancel_all)) {
-				hlist_del_init(&req->hash_node);
-				io_poll_cancel_req(req);
-				found = true;
-			}
-		}
-	}
-	spin_unlock(&ctx->completion_lock);
-	return found;
-}
-
-static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
-				     bool poll_only)
-	__must_hold(&ctx->completion_lock)
-{
-	struct hlist_head *list;
-	struct io_kiocb *req;
-
-	list = &ctx->cancel_hash[hash_long(sqe_addr, ctx->cancel_hash_bits)];
-	hlist_for_each_entry(req, list, hash_node) {
-		if (sqe_addr != req->user_data)
-			continue;
-		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
-			continue;
-		return req;
-	}
-	return NULL;
-}
-
-static bool io_poll_disarm(struct io_kiocb *req)
-	__must_hold(&ctx->completion_lock)
-{
-	if (!io_poll_get_ownership(req))
-		return false;
-	io_poll_remove_entries(req);
-	hash_del(&req->hash_node);
-	return true;
-}
-
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
-			  bool poll_only)
-	__must_hold(&ctx->completion_lock)
-{
-	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, poll_only);
-
-	if (!req)
-		return -ENOENT;
-	io_poll_cancel_req(req);
-	return 0;
-}
-
-static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
-				     unsigned int flags)
-{
-	u32 events;
-
-	events = READ_ONCE(sqe->poll32_events);
-#ifdef __BIG_ENDIAN
-	events = swahw32(events);
-#endif
-	if (!(flags & IORING_POLL_ADD_MULTI))
-		events |= EPOLLONESHOT;
-	return demangle_poll(events) | (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
-}
-
-static int io_poll_update_prep(struct io_kiocb *req,
-			       const struct io_uring_sqe *sqe)
-{
-	struct io_poll_update *upd = &req->poll_update;
-	u32 flags;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
-		return -EINVAL;
-	flags = READ_ONCE(sqe->len);
-	if (flags & ~(IORING_POLL_UPDATE_EVENTS | IORING_POLL_UPDATE_USER_DATA |
-		      IORING_POLL_ADD_MULTI))
-		return -EINVAL;
-	/* meaningless without update */
-	if (flags == IORING_POLL_ADD_MULTI)
-		return -EINVAL;
-
-	upd->old_user_data = READ_ONCE(sqe->addr);
-	upd->update_events = flags & IORING_POLL_UPDATE_EVENTS;
-	upd->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
-
-	upd->new_user_data = READ_ONCE(sqe->off);
-	if (!upd->update_user_data && upd->new_user_data)
-		return -EINVAL;
-	if (upd->update_events)
-		upd->events = io_poll_parse_events(sqe, flags);
-	else if (sqe->poll32_events)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_poll_iocb *poll = &req->poll;
-	u32 flags;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->addr)
-		return -EINVAL;
-	flags = READ_ONCE(sqe->len);
-	if (flags & ~IORING_POLL_ADD_MULTI)
-		return -EINVAL;
-
-	io_req_set_refcount(req);
-	poll->events = io_poll_parse_events(sqe, flags);
-	return 0;
-}
-
-static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_poll_iocb *poll = &req->poll;
-	struct io_poll_table ipt;
-	int ret;
-
-	ipt.pt._qproc = io_poll_queue_proc;
-
-	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
-	if (!ret && ipt.error)
-		req_set_fail(req);
-	ret = ret ?: ipt.error;
-	if (ret)
-		__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *preq;
-	int ret2, ret = 0;
-
-	spin_lock(&ctx->completion_lock);
-	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
-	if (!preq || !io_poll_disarm(preq)) {
-		spin_unlock(&ctx->completion_lock);
-		ret = preq ? -EALREADY : -ENOENT;
-		goto out;
-	}
-	spin_unlock(&ctx->completion_lock);
-
-	if (req->poll_update.update_events || req->poll_update.update_user_data) {
-		/* only mask one event flags, keep behavior flags */
-		if (req->poll_update.update_events) {
-			preq->poll.events &= ~0xffff;
-			preq->poll.events |= req->poll_update.events & 0xffff;
-			preq->poll.events |= IO_POLL_UNMASK;
-		}
-		if (req->poll_update.update_user_data)
-			preq->user_data = req->poll_update.new_user_data;
-
-		ret2 = io_poll_add(preq, issue_flags);
-		/* successfully updated, don't complete poll request */
-		if (!ret2)
-			goto out;
-	}
-	req_set_fail(preq);
-	io_req_complete(preq, -ECANCELED);
-out:
-	if (ret < 0)
-		req_set_fail(req);
-	/* complete update request, we're done with it */
-	io_req_complete(req, ret);
-	return 0;
-}
-
-static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
-{
-	req_set_fail(req);
-	io_req_complete_post(req, -ETIME, 0);
-}
-
-static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
-{
-	struct io_timeout_data *data = container_of(timer,
-						struct io_timeout_data, timer);
-	struct io_kiocb *req = data->req;
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->timeout_lock, flags);
-	list_del_init(&req->timeout.list);
-	atomic_set(&req->ctx->cq_timeouts,
-		atomic_read(&req->ctx->cq_timeouts) + 1);
-	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
-
-	req->io_task_work.func = io_req_task_timeout;
-	io_req_task_work_add(req);
-	return HRTIMER_NORESTART;
-}
-
-static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
-					   __u64 user_data)
-	__must_hold(&ctx->timeout_lock)
-{
-	struct io_timeout_data *io;
-	struct io_kiocb *req;
-	bool found = false;
-
-	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
-		found = user_data == req->user_data;
-		if (found)
-			break;
-	}
-	if (!found)
-		return ERR_PTR(-ENOENT);
-
-	io = req->async_data;
-	if (hrtimer_try_to_cancel(&io->timer) == -1)
-		return ERR_PTR(-EALREADY);
-	list_del_init(&req->timeout.list);
-	return req;
-}
-
-static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
-	__must_hold(&ctx->completion_lock)
-	__must_hold(&ctx->timeout_lock)
-{
-	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
-
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	req_set_fail(req);
-	io_fill_cqe_req(req, -ECANCELED, 0);
-	io_put_req_deferred(req);
-	return 0;
-}
-
-static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
-{
-	switch (data->flags & IORING_TIMEOUT_CLOCK_MASK) {
-	case IORING_TIMEOUT_BOOTTIME:
-		return CLOCK_BOOTTIME;
-	case IORING_TIMEOUT_REALTIME:
-		return CLOCK_REALTIME;
-	default:
-		/* can't happen, vetted at prep time */
-		WARN_ON_ONCE(1);
-		fallthrough;
-	case 0:
-		return CLOCK_MONOTONIC;
-	}
-}
-
-static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
-				    struct timespec64 *ts, enum hrtimer_mode mode)
-	__must_hold(&ctx->timeout_lock)
-{
-	struct io_timeout_data *io;
-	struct io_kiocb *req;
-	bool found = false;
-
-	list_for_each_entry(req, &ctx->ltimeout_list, timeout.list) {
-		found = user_data == req->user_data;
-		if (found)
-			break;
-	}
-	if (!found)
-		return -ENOENT;
-
-	io = req->async_data;
-	if (hrtimer_try_to_cancel(&io->timer) == -1)
-		return -EALREADY;
-	hrtimer_init(&io->timer, io_timeout_get_clock(io), mode);
-	io->timer.function = io_link_timeout_fn;
-	hrtimer_start(&io->timer, timespec64_to_ktime(*ts), mode);
-	return 0;
-}
-
-static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
-			     struct timespec64 *ts, enum hrtimer_mode mode)
-	__must_hold(&ctx->timeout_lock)
-{
-	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
-	struct io_timeout_data *data;
-
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	req->timeout.off = 0; /* noseq */
-	data = req->async_data;
-	list_add_tail(&req->timeout.list, &ctx->timeout_list);
-	hrtimer_init(&data->timer, io_timeout_get_clock(data), mode);
-	data->timer.function = io_timeout_fn;
-	hrtimer_start(&data->timer, timespec64_to_ktime(*ts), mode);
-	return 0;
-}
-
-static int io_timeout_remove_prep(struct io_kiocb *req,
-				  const struct io_uring_sqe *sqe)
-{
-	struct io_timeout_rem *tr = &req->timeout_rem;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->splice_fd_in)
-		return -EINVAL;
-
-	tr->ltimeout = false;
-	tr->addr = READ_ONCE(sqe->addr);
-	tr->flags = READ_ONCE(sqe->timeout_flags);
-	if (tr->flags & IORING_TIMEOUT_UPDATE_MASK) {
-		if (hweight32(tr->flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
-			return -EINVAL;
-		if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
-			tr->ltimeout = true;
-		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
-			return -EINVAL;
-		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
-			return -EFAULT;
-	} else if (tr->flags) {
-		/* timeout removal doesn't support flags */
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static inline enum hrtimer_mode io_translate_timeout_mode(unsigned int flags)
-{
-	return (flags & IORING_TIMEOUT_ABS) ? HRTIMER_MODE_ABS
-					    : HRTIMER_MODE_REL;
-}
-
-/*
- * Remove or update an existing timeout command
- */
-static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_timeout_rem *tr = &req->timeout_rem;
-	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
-
-	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE)) {
-		spin_lock(&ctx->completion_lock);
-		spin_lock_irq(&ctx->timeout_lock);
-		ret = io_timeout_cancel(ctx, tr->addr);
-		spin_unlock_irq(&ctx->timeout_lock);
-		spin_unlock(&ctx->completion_lock);
-	} else {
-		enum hrtimer_mode mode = io_translate_timeout_mode(tr->flags);
-
-		spin_lock_irq(&ctx->timeout_lock);
-		if (tr->ltimeout)
-			ret = io_linked_timeout_update(ctx, tr->addr, &tr->ts, mode);
-		else
-			ret = io_timeout_update(ctx, tr->addr, &tr->ts, mode);
-		spin_unlock_irq(&ctx->timeout_lock);
-	}
-
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete_post(req, ret, 0);
-	return 0;
-}
-
-static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			   bool is_timeout_link)
-{
-	struct io_timeout_data *data;
-	unsigned flags;
-	u32 off = READ_ONCE(sqe->off);
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-	if (off && is_timeout_link)
-		return -EINVAL;
-	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK))
-		return -EINVAL;
-	/* more than one clock specified is invalid, obviously */
-	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
-		return -EINVAL;
-
-	INIT_LIST_HEAD(&req->timeout.list);
-	req->timeout.off = off;
-	if (unlikely(off && !req->ctx->off_timeout_used))
-		req->ctx->off_timeout_used = true;
-
-	if (!req->async_data && io_alloc_async_data(req))
-		return -ENOMEM;
-
-	data = req->async_data;
-	data->req = req;
-	data->flags = flags;
-
-	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
-		return -EFAULT;
-
-	INIT_LIST_HEAD(&req->timeout.list);
-	data->mode = io_translate_timeout_mode(flags);
-	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
-
-	if (is_timeout_link) {
-		struct io_submit_link *link = &req->ctx->submit_state.link;
-
-		if (!link->head)
-			return -EINVAL;
-		if (link->last->opcode == IORING_OP_LINK_TIMEOUT)
-			return -EINVAL;
-		req->timeout.head = link->last;
-		link->last->flags |= REQ_F_ARM_LTIMEOUT;
-	}
-	return 0;
-}
-
-static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_timeout_data *data = req->async_data;
-	struct list_head *entry;
-	u32 tail, off = req->timeout.off;
-
-	spin_lock_irq(&ctx->timeout_lock);
-
-	/*
-	 * sqe->off holds how many events that need to occur for this
-	 * timeout event to be satisfied. If it isn't set, then this is
-	 * a pure timeout request, sequence isn't used.
-	 */
-	if (io_is_timeout_noseq(req)) {
-		entry = ctx->timeout_list.prev;
-		goto add;
-	}
-
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
-	req->timeout.target_seq = tail + off;
-
-	/* Update the last seq here in case io_flush_timeouts() hasn't.
-	 * This is safe because ->completion_lock is held, and submissions
-	 * and completions are never mixed in the same ->completion_lock section.
-	 */
-	ctx->cq_last_tm_flush = tail;
-
-	/*
-	 * Insertion sort, ensuring the first entry in the list is always
-	 * the one we need first.
-	 */
-	list_for_each_prev(entry, &ctx->timeout_list) {
-		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb,
-						  timeout.list);
-
-		if (io_is_timeout_noseq(nxt))
-			continue;
-		/* nxt.seq is behind @tail, otherwise would've been completed */
-		if (off >= nxt->timeout.target_seq - tail)
-			break;
-	}
-add:
-	list_add(&req->timeout.list, entry);
-	data->timer.function = io_timeout_fn;
-	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
-	spin_unlock_irq(&ctx->timeout_lock);
-	return 0;
-}
-
-struct io_cancel_data {
-	struct io_ring_ctx *ctx;
-	u64 user_data;
-};
-
-static bool io_cancel_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_cancel_data *cd = data;
-
-	return req->ctx == cd->ctx && req->user_data == cd->user_data;
-}
-
-static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
-			       struct io_ring_ctx *ctx)
-{
-	struct io_cancel_data data = { .ctx = ctx, .user_data = user_data, };
-	enum io_wq_cancel cancel_ret;
-	int ret = 0;
-
-	if (!tctx || !tctx->io_wq)
-		return -ENOENT;
-
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, &data, false);
-	switch (cancel_ret) {
-	case IO_WQ_CANCEL_OK:
-		ret = 0;
-		break;
-	case IO_WQ_CANCEL_RUNNING:
-		ret = -EALREADY;
-		break;
-	case IO_WQ_CANCEL_NOTFOUND:
-		ret = -ENOENT;
-		break;
-	}
-
-	return ret;
-}
-
-static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
-
-	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
-
-	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	if (ret != -ENOENT)
-		return ret;
-
-	spin_lock(&ctx->completion_lock);
-	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, sqe_addr);
-	spin_unlock_irq(&ctx->timeout_lock);
-	if (ret != -ENOENT)
-		goto out;
-	ret = io_poll_cancel(ctx, sqe_addr, false);
-out:
-	spin_unlock(&ctx->completion_lock);
-	return ret;
-}
-
-static int io_async_cancel_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
-{
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-
-	req->cancel.addr = READ_ONCE(sqe->addr);
-	return 0;
-}
-
-static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	u64 sqe_addr = req->cancel.addr;
-	struct io_tctx_node *node;
-	int ret;
-
-	ret = io_try_cancel_userdata(req, sqe_addr);
-	if (ret != -ENOENT)
-		goto done;
-
-	/* slow path, try all io-wq's */
-	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
-	ret = -ENOENT;
-	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
-		struct io_uring_task *tctx = node->task->io_uring;
-
-		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
-		if (ret != -ENOENT)
-			break;
-	}
-	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
-done:
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_complete_post(req, ret, 0);
-	return 0;
-}
-
-static int io_rsrc_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
-{
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
-		return -EINVAL;
-
-	req->rsrc_update.offset = READ_ONCE(sqe->off);
-	req->rsrc_update.nr_args = READ_ONCE(sqe->len);
-	if (!req->rsrc_update.nr_args)
-		return -EINVAL;
-	req->rsrc_update.arg = READ_ONCE(sqe->addr);
-	return 0;
-}
-
-static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_rsrc_update2 up;
-	int ret;
-
-	up.offset = req->rsrc_update.offset;
-	up.data = req->rsrc_update.arg;
-	up.nr = 0;
-	up.tags = 0;
-	up.resv = 0;
-	up.resv2 = 0;
-
-	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
-	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
-					&up, req->rsrc_update.nr_args);
-	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
-
-	if (ret < 0)
-		req_set_fail(req);
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
-}
-
-static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	switch (req->opcode) {
-	case IORING_OP_NOP:
-		return 0;
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
-		return io_read_prep(req, sqe);
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		return io_write_prep(req, sqe);
-	case IORING_OP_POLL_ADD:
-		return io_poll_add_prep(req, sqe);
-	case IORING_OP_POLL_REMOVE:
-		return io_poll_update_prep(req, sqe);
-	case IORING_OP_FSYNC:
-		return io_fsync_prep(req, sqe);
-	case IORING_OP_SYNC_FILE_RANGE:
-		return io_sfr_prep(req, sqe);
-	case IORING_OP_SENDMSG:
-	case IORING_OP_SEND:
-		return io_sendmsg_prep(req, sqe);
-	case IORING_OP_RECVMSG:
-	case IORING_OP_RECV:
-		return io_recvmsg_prep(req, sqe);
-	case IORING_OP_CONNECT:
-		return io_connect_prep(req, sqe);
-	case IORING_OP_TIMEOUT:
-		return io_timeout_prep(req, sqe, false);
-	case IORING_OP_TIMEOUT_REMOVE:
-		return io_timeout_remove_prep(req, sqe);
-	case IORING_OP_ASYNC_CANCEL:
-		return io_async_cancel_prep(req, sqe);
-	case IORING_OP_LINK_TIMEOUT:
-		return io_timeout_prep(req, sqe, true);
-	case IORING_OP_ACCEPT:
-		return io_accept_prep(req, sqe);
-	case IORING_OP_FALLOCATE:
-		return io_fallocate_prep(req, sqe);
-	case IORING_OP_OPENAT:
-		return io_openat_prep(req, sqe);
-	case IORING_OP_CLOSE:
-		return io_close_prep(req, sqe);
-	case IORING_OP_FILES_UPDATE:
-		return io_rsrc_update_prep(req, sqe);
-	case IORING_OP_STATX:
-		return io_statx_prep(req, sqe);
-	case IORING_OP_FADVISE:
-		return io_fadvise_prep(req, sqe);
-	case IORING_OP_MADVISE:
-		return io_madvise_prep(req, sqe);
-	case IORING_OP_OPENAT2:
-		return io_openat2_prep(req, sqe);
-	case IORING_OP_EPOLL_CTL:
-		return io_epoll_ctl_prep(req, sqe);
-	case IORING_OP_SPLICE:
-		return io_splice_prep(req, sqe);
-	case IORING_OP_PROVIDE_BUFFERS:
-		return io_provide_buffers_prep(req, sqe);
-	case IORING_OP_REMOVE_BUFFERS:
-		return io_remove_buffers_prep(req, sqe);
-	case IORING_OP_TEE:
-		return io_tee_prep(req, sqe);
-	case IORING_OP_SHUTDOWN:
-		return io_shutdown_prep(req, sqe);
-	case IORING_OP_RENAMEAT:
-		return io_renameat_prep(req, sqe);
-	case IORING_OP_UNLINKAT:
-		return io_unlinkat_prep(req, sqe);
-	case IORING_OP_MKDIRAT:
-		return io_mkdirat_prep(req, sqe);
-	case IORING_OP_SYMLINKAT:
-		return io_symlinkat_prep(req, sqe);
-	case IORING_OP_LINKAT:
-		return io_linkat_prep(req, sqe);
-	}
-
-	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
-			req->opcode);
-	return -EINVAL;
-}
-
-static int io_req_prep_async(struct io_kiocb *req)
-{
-	if (!io_op_defs[req->opcode].needs_async_setup)
-		return 0;
-	if (WARN_ON_ONCE(req->async_data))
-		return -EFAULT;
-	if (io_alloc_async_data(req))
-		return -EAGAIN;
-
-	switch (req->opcode) {
-	case IORING_OP_READV:
-		return io_rw_prep_async(req, READ);
-	case IORING_OP_WRITEV:
-		return io_rw_prep_async(req, WRITE);
-	case IORING_OP_SENDMSG:
-		return io_sendmsg_prep_async(req);
-	case IORING_OP_RECVMSG:
-		return io_recvmsg_prep_async(req);
-	case IORING_OP_CONNECT:
-		return io_connect_prep_async(req);
-	}
-	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
-		    req->opcode);
-	return -EFAULT;
-}
-
-static u32 io_get_sequence(struct io_kiocb *req)
-{
-	u32 seq = req->ctx->cached_sq_head;
-
-	/* need original cached_sq_head, but it was increased for each req */
-	io_for_each_link(req, req)
-		seq--;
-	return seq;
-}
-
-static bool io_drain_req(struct io_kiocb *req)
-{
-	struct io_kiocb *pos;
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_defer_entry *de;
-	int ret;
-	u32 seq;
-
-	if (req->flags & REQ_F_FAIL) {
-		io_req_complete_fail_submit(req);
-		return true;
-	}
-
-	/*
-	 * If we need to drain a request in the middle of a link, drain the
-	 * head request and the next request/link after the current link.
-	 * Considering sequential execution of links, IOSQE_IO_DRAIN will be
-	 * maintained for every request of our link.
-	 */
-	if (ctx->drain_next) {
-		req->flags |= REQ_F_IO_DRAIN;
-		ctx->drain_next = false;
-	}
-	/* not interested in head, start from the first linked */
-	io_for_each_link(pos, req->link) {
-		if (pos->flags & REQ_F_IO_DRAIN) {
-			ctx->drain_next = true;
-			req->flags |= REQ_F_IO_DRAIN;
-			break;
-		}
-	}
-
-	/* Still need defer if there is pending req in defer list. */
-	spin_lock(&ctx->completion_lock);
-	if (likely(list_empty_careful(&ctx->defer_list) &&
-		!(req->flags & REQ_F_IO_DRAIN))) {
-		spin_unlock(&ctx->completion_lock);
-		ctx->drain_active = false;
-		return false;
-	}
-	spin_unlock(&ctx->completion_lock);
-
-	seq = io_get_sequence(req);
-	/* Still a chance to pass the sequence check */
-	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
-		return false;
-
-	ret = io_req_prep_async(req);
-	if (ret)
-		goto fail;
-	io_prep_async_link(req);
-	de = kmalloc(sizeof(*de), GFP_KERNEL);
-	if (!de) {
-		ret = -ENOMEM;
-fail:
-		io_req_complete_failed(req, ret);
-		return true;
-	}
-
-	spin_lock(&ctx->completion_lock);
-	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
-		spin_unlock(&ctx->completion_lock);
-		kfree(de);
-		io_queue_async_work(req, NULL);
-		return true;
-	}
-
-	trace_io_uring_defer(ctx, req, req->user_data);
-	de->req = req;
-	de->seq = seq;
-	list_add_tail(&de->list, &ctx->defer_list);
-	spin_unlock(&ctx->completion_lock);
-	return true;
-}
-
-static void io_clean_op(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		switch (req->opcode) {
-		case IORING_OP_READV:
-		case IORING_OP_READ_FIXED:
-		case IORING_OP_READ:
-			kfree((void *)(unsigned long)req->rw.addr);
-			break;
-		case IORING_OP_RECVMSG:
-		case IORING_OP_RECV:
-			kfree(req->sr_msg.kbuf);
-			break;
-		}
-	}
-
-	if (req->flags & REQ_F_NEED_CLEANUP) {
-		switch (req->opcode) {
-		case IORING_OP_READV:
-		case IORING_OP_READ_FIXED:
-		case IORING_OP_READ:
-		case IORING_OP_WRITEV:
-		case IORING_OP_WRITE_FIXED:
-		case IORING_OP_WRITE: {
-			struct io_async_rw *io = req->async_data;
-
-			kfree(io->free_iovec);
-			break;
-			}
-		case IORING_OP_RECVMSG:
-		case IORING_OP_SENDMSG: {
-			struct io_async_msghdr *io = req->async_data;
-
-			kfree(io->free_iov);
-			break;
-			}
-		case IORING_OP_OPENAT:
-		case IORING_OP_OPENAT2:
-			if (req->open.filename)
-				putname(req->open.filename);
-			break;
-		case IORING_OP_RENAMEAT:
-			putname(req->rename.oldpath);
-			putname(req->rename.newpath);
-			break;
-		case IORING_OP_UNLINKAT:
-			putname(req->unlink.filename);
-			break;
-		case IORING_OP_MKDIRAT:
-			putname(req->mkdir.filename);
-			break;
-		case IORING_OP_SYMLINKAT:
-			putname(req->symlink.oldpath);
-			putname(req->symlink.newpath);
-			break;
-		case IORING_OP_LINKAT:
-			putname(req->hardlink.oldpath);
-			putname(req->hardlink.newpath);
-			break;
-		}
-	}
-	if ((req->flags & REQ_F_POLLED) && req->apoll) {
-		kfree(req->apoll->double_poll);
-		kfree(req->apoll);
-		req->apoll = NULL;
-	}
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_uring_task *tctx = req->task->io_uring;
-
-		atomic_dec(&tctx->inflight_tracked);
-	}
-	if (req->flags & REQ_F_CREDS)
-		put_cred(req->creds);
-
-	req->flags &= ~IO_REQ_CLEAN_FLAGS;
-}
-
-static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	const struct cred *creds = NULL;
-	int ret;
-
-	if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
-		creds = override_creds(req->creds);
-
-	switch (req->opcode) {
-	case IORING_OP_NOP:
-		ret = io_nop(req, issue_flags);
-		break;
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
-		ret = io_read(req, issue_flags);
-		break;
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		ret = io_write(req, issue_flags);
-		break;
-	case IORING_OP_FSYNC:
-		ret = io_fsync(req, issue_flags);
-		break;
-	case IORING_OP_POLL_ADD:
-		ret = io_poll_add(req, issue_flags);
-		break;
-	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_update(req, issue_flags);
-		break;
-	case IORING_OP_SYNC_FILE_RANGE:
-		ret = io_sync_file_range(req, issue_flags);
-		break;
-	case IORING_OP_SENDMSG:
-		ret = io_sendmsg(req, issue_flags);
-		break;
-	case IORING_OP_SEND:
-		ret = io_send(req, issue_flags);
-		break;
-	case IORING_OP_RECVMSG:
-		ret = io_recvmsg(req, issue_flags);
-		break;
-	case IORING_OP_RECV:
-		ret = io_recv(req, issue_flags);
-		break;
-	case IORING_OP_TIMEOUT:
-		ret = io_timeout(req, issue_flags);
-		break;
-	case IORING_OP_TIMEOUT_REMOVE:
-		ret = io_timeout_remove(req, issue_flags);
-		break;
-	case IORING_OP_ACCEPT:
-		ret = io_accept(req, issue_flags);
-		break;
-	case IORING_OP_CONNECT:
-		ret = io_connect(req, issue_flags);
-		break;
-	case IORING_OP_ASYNC_CANCEL:
-		ret = io_async_cancel(req, issue_flags);
-		break;
-	case IORING_OP_FALLOCATE:
-		ret = io_fallocate(req, issue_flags);
-		break;
-	case IORING_OP_OPENAT:
-		ret = io_openat(req, issue_flags);
-		break;
-	case IORING_OP_CLOSE:
-		ret = io_close(req, issue_flags);
-		break;
-	case IORING_OP_FILES_UPDATE:
-		ret = io_files_update(req, issue_flags);
-		break;
-	case IORING_OP_STATX:
-		ret = io_statx(req, issue_flags);
-		break;
-	case IORING_OP_FADVISE:
-		ret = io_fadvise(req, issue_flags);
-		break;
-	case IORING_OP_MADVISE:
-		ret = io_madvise(req, issue_flags);
-		break;
-	case IORING_OP_OPENAT2:
-		ret = io_openat2(req, issue_flags);
-		break;
-	case IORING_OP_EPOLL_CTL:
-		ret = io_epoll_ctl(req, issue_flags);
-		break;
-	case IORING_OP_SPLICE:
-		ret = io_splice(req, issue_flags);
-		break;
-	case IORING_OP_PROVIDE_BUFFERS:
-		ret = io_provide_buffers(req, issue_flags);
-		break;
-	case IORING_OP_REMOVE_BUFFERS:
-		ret = io_remove_buffers(req, issue_flags);
-		break;
-	case IORING_OP_TEE:
-		ret = io_tee(req, issue_flags);
-		break;
-	case IORING_OP_SHUTDOWN:
-		ret = io_shutdown(req, issue_flags);
-		break;
-	case IORING_OP_RENAMEAT:
-		ret = io_renameat(req, issue_flags);
-		break;
-	case IORING_OP_UNLINKAT:
-		ret = io_unlinkat(req, issue_flags);
-		break;
-	case IORING_OP_MKDIRAT:
-		ret = io_mkdirat(req, issue_flags);
-		break;
-	case IORING_OP_SYMLINKAT:
-		ret = io_symlinkat(req, issue_flags);
-		break;
-	case IORING_OP_LINKAT:
-		ret = io_linkat(req, issue_flags);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	if (creds)
-		revert_creds(creds);
-	if (ret)
-		return ret;
-	/* If the op doesn't have a file, we're not polling for it */
-	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file)
-		io_iopoll_req_issued(req);
-
-	return 0;
-}
-
-static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	req = io_put_req_find_next(req);
-	return req ? &req->work : NULL;
-}
-
-static void io_wq_submit_work(struct io_wq_work *work)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_kiocb *timeout;
-	int ret = 0;
-
-	/* one will be dropped by ->io_free_work() after returning to io-wq */
-	if (!(req->flags & REQ_F_REFCOUNT))
-		__io_req_set_refcount(req, 2);
-	else
-		req_ref_get(req);
-
-	timeout = io_prep_linked_timeout(req);
-	if (timeout)
-		io_queue_linked_timeout(timeout);
-
-	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
-	if (work->flags & IO_WQ_WORK_CANCEL)
-		ret = -ECANCELED;
-
-	if (!ret) {
-		do {
-			ret = io_issue_sqe(req, 0);
-			/*
-			 * We can get EAGAIN for polled IO even though we're
-			 * forcing a sync submission from here, since we can't
-			 * wait for request slots on the block side.
-			 */
-			if (ret != -EAGAIN || !(req->ctx->flags & IORING_SETUP_IOPOLL))
-				break;
-			cond_resched();
-		} while (1);
-	}
-
-	/* avoid locking problems by failing it from a clean context */
-	if (ret)
-		io_req_task_queue_fail(req, ret);
-}
-
-static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
-						       unsigned i)
-{
-	return &table->files[i];
-}
-
-static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
-					      int index)
-{
-	struct io_fixed_file *slot = io_fixed_file_slot(&ctx->file_table, index);
-
-	return (struct file *) (slot->file_ptr & FFS_MASK);
-}
-
-static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file)
-{
-	unsigned long file_ptr = (unsigned long) file;
-
-	if (__io_file_supports_nowait(file, READ))
-		file_ptr |= FFS_ASYNC_READ;
-	if (__io_file_supports_nowait(file, WRITE))
-		file_ptr |= FFS_ASYNC_WRITE;
-	if (S_ISREG(file_inode(file)->i_mode))
-		file_ptr |= FFS_ISREG;
-	file_slot->file_ptr = file_ptr;
-}
-
-static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
-					     struct io_kiocb *req, int fd)
-{
-	struct file *file;
-	unsigned long file_ptr;
-
-	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
-		return NULL;
-	fd = array_index_nospec(fd, ctx->nr_user_files);
-	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
-	file = (struct file *) (file_ptr & FFS_MASK);
-	file_ptr &= ~FFS_MASK;
-	/* mask in overlapping REQ_F and FFS bits */
-	req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
-	io_req_set_rsrc_node(req);
-	return file;
-}
-
-static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
-				       struct io_kiocb *req, int fd)
-{
-	struct file *file = fget(fd);
-
-	trace_io_uring_file_get(ctx, fd);
-
-	/* we don't allow fixed io_uring files */
-	if (file && unlikely(file->f_op == &io_uring_fops))
-		io_req_track_inflight(req);
-	return file;
-}
-
-static inline struct file *io_file_get(struct io_ring_ctx *ctx,
-				       struct io_kiocb *req, int fd, bool fixed)
-{
-	if (fixed)
-		return io_file_get_fixed(ctx, req, fd);
-	else
-		return io_file_get_normal(ctx, req, fd);
-}
-
-static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
-{
-	struct io_kiocb *prev = req->timeout.prev;
-	int ret = -ENOENT;
-
-	if (prev) {
-		if (!(req->task->flags & PF_EXITING))
-			ret = io_try_cancel_userdata(req, prev->user_data);
-		io_req_complete_post(req, ret ?: -ETIME, 0);
-		io_put_req(prev);
-	} else {
-		io_req_complete_post(req, -ETIME, 0);
-	}
-}
-
-static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
-{
-	struct io_timeout_data *data = container_of(timer,
-						struct io_timeout_data, timer);
-	struct io_kiocb *prev, *req = data->req;
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->timeout_lock, flags);
-	prev = req->timeout.head;
-	req->timeout.head = NULL;
-
-	/*
-	 * We don't expect the list to be empty, that will only happen if we
-	 * race with the completion of the linked work.
-	 */
-	if (prev) {
-		io_remove_next_linked(prev);
-		if (!req_ref_inc_not_zero(prev))
-			prev = NULL;
-	}
-	list_del(&req->timeout.list);
-	req->timeout.prev = prev;
-	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
-
-	req->io_task_work.func = io_req_task_link_timeout;
-	io_req_task_work_add(req);
-	return HRTIMER_NORESTART;
-}
-
-static void io_queue_linked_timeout(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock_irq(&ctx->timeout_lock);
-	/*
-	 * If the back reference is NULL, then our linked request finished
-	 * before we got a chance to setup the timer
-	 */
-	if (req->timeout.head) {
-		struct io_timeout_data *data = req->async_data;
-
-		data->timer.function = io_link_timeout_fn;
-		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
-				data->mode);
-		list_add_tail(&req->timeout.list, &ctx->ltimeout_list);
-	}
-	spin_unlock_irq(&ctx->timeout_lock);
-	/* drop submission reference */
-	io_put_req(req);
-}
-
-static void __io_queue_sqe(struct io_kiocb *req)
-	__must_hold(&req->ctx->uring_lock)
-{
-	struct io_kiocb *linked_timeout;
-	int ret;
-
-issue_sqe:
-	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
-
-	/*
-	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-	 * doesn't support non-blocking read/write attempts
-	 */
-	if (likely(!ret)) {
-		if (req->flags & REQ_F_COMPLETE_INLINE) {
-			struct io_ring_ctx *ctx = req->ctx;
-			struct io_submit_state *state = &ctx->submit_state;
-
-			state->compl_reqs[state->compl_nr++] = req;
-			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
-				io_submit_flush_completions(ctx);
-			return;
-		}
-
-		linked_timeout = io_prep_linked_timeout(req);
-		if (linked_timeout)
-			io_queue_linked_timeout(linked_timeout);
-	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		linked_timeout = io_prep_linked_timeout(req);
-
-		switch (io_arm_poll_handler(req)) {
-		case IO_APOLL_READY:
-			if (linked_timeout)
-				io_queue_linked_timeout(linked_timeout);
-			goto issue_sqe;
-		case IO_APOLL_ABORTED:
-			/*
-			 * Queued up for async execution, worker will release
-			 * submit reference when the iocb is actually submitted.
-			 */
-			io_queue_async_work(req, NULL);
-			break;
-		}
-
-		if (linked_timeout)
-			io_queue_linked_timeout(linked_timeout);
-	} else {
-		io_req_complete_failed(req, ret);
-	}
-}
-
-static inline void io_queue_sqe(struct io_kiocb *req)
-	__must_hold(&req->ctx->uring_lock)
-{
-	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
-		return;
-
-	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
-		__io_queue_sqe(req);
-	} else if (req->flags & REQ_F_FAIL) {
-		io_req_complete_fail_submit(req);
-	} else {
-		int ret = io_req_prep_async(req);
-
-		if (unlikely(ret))
-			io_req_complete_failed(req, ret);
-		else
-			io_queue_async_work(req, NULL);
-	}
-}
-
-/*
- * Check SQE restrictions (opcode and flags).
- *
- * Returns 'true' if SQE is allowed, 'false' otherwise.
- */
-static inline bool io_check_restriction(struct io_ring_ctx *ctx,
-					struct io_kiocb *req,
-					unsigned int sqe_flags)
-{
-	if (likely(!ctx->restricted))
-		return true;
-
-	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
-		return false;
-
-	if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
-	    ctx->restrictions.sqe_flags_required)
-		return false;
-
-	if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
-			  ctx->restrictions.sqe_flags_required))
-		return false;
-
-	return true;
-}
-
-static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_submit_state *state;
-	unsigned int sqe_flags;
-	int personality, ret = 0;
-
-	/* req is partially pre-initialised, see io_preinit_req() */
-	req->opcode = READ_ONCE(sqe->opcode);
-	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags = sqe_flags = READ_ONCE(sqe->flags);
-	req->user_data = READ_ONCE(sqe->user_data);
-	req->file = NULL;
-	req->fixed_rsrc_refs = NULL;
-	req->task = current;
-
-	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
-		return -EINVAL;
-	if (unlikely(req->opcode >= IORING_OP_LAST))
-		return -EINVAL;
-	if (!io_check_restriction(ctx, req, sqe_flags))
-		return -EACCES;
-
-	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-	    !io_op_defs[req->opcode].buffer_select)
-		return -EOPNOTSUPP;
-	if (unlikely(sqe_flags & IOSQE_IO_DRAIN))
-		ctx->drain_active = true;
-
-	personality = READ_ONCE(sqe->personality);
-	if (personality) {
-		req->creds = xa_load(&ctx->personalities, personality);
-		if (!req->creds)
-			return -EINVAL;
-		get_cred(req->creds);
-		req->flags |= REQ_F_CREDS;
-	}
-	state = &ctx->submit_state;
-
-	/*
-	 * Plug now if we have more than 1 IO left after this, and the target
-	 * is potentially a read/write to block based storage.
-	 */
-	if (!state->plug_started && state->ios_left > 1 &&
-	    io_op_defs[req->opcode].plug) {
-		blk_start_plug(&state->plug);
-		state->plug_started = true;
-	}
-
-	if (io_op_defs[req->opcode].needs_file) {
-		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
-					(sqe_flags & IOSQE_FIXED_FILE));
-		if (unlikely(!req->file))
-			ret = -EBADF;
-	}
-
-	state->ios_left--;
-	return ret;
-}
-
-static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 const struct io_uring_sqe *sqe)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_submit_link *link = &ctx->submit_state.link;
-	int ret;
-
-	ret = io_init_req(ctx, req, sqe);
-	if (unlikely(ret)) {
-fail_req:
-		/* fail even hard links since we don't submit */
-		if (link->head) {
-			/*
-			 * we can judge a link req is failed or cancelled by if
-			 * REQ_F_FAIL is set, but the head is an exception since
-			 * it may be set REQ_F_FAIL because of other req's failure
-			 * so let's leverage req->result to distinguish if a head
-			 * is set REQ_F_FAIL because of its failure or other req's
-			 * failure so that we can set the correct ret code for it.
-			 * init result here to avoid affecting the normal path.
-			 */
-			if (!(link->head->flags & REQ_F_FAIL))
-				req_fail_link_node(link->head, -ECANCELED);
-		} else if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			/*
-			 * the current req is a normal req, we should return
-			 * error and thus break the submittion loop.
-			 */
-			io_req_complete_failed(req, ret);
-			return ret;
-		}
-		req_fail_link_node(req, ret);
-	} else {
-		ret = io_req_prep(req, sqe);
-		if (unlikely(ret))
-			goto fail_req;
-	}
-
-	/* don't need @sqe from now on */
-	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
-				  req->flags, true,
-				  ctx->flags & IORING_SETUP_SQPOLL);
-
-	/*
-	 * If we already have a head request, queue this one for async
-	 * submittal once the head completes. If we don't have a head but
-	 * IOSQE_IO_LINK is set in the sqe, start a new head. This one will be
-	 * submitted sync once the chain is complete. If none of those
-	 * conditions are true (normal request), then just queue it.
-	 */
-	if (link->head) {
-		struct io_kiocb *head = link->head;
-
-		if (!(req->flags & REQ_F_FAIL)) {
-			ret = io_req_prep_async(req);
-			if (unlikely(ret)) {
-				req_fail_link_node(req, ret);
-				if (!(head->flags & REQ_F_FAIL))
-					req_fail_link_node(head, -ECANCELED);
-			}
-		}
-		trace_io_uring_link(ctx, req, head);
-		link->last->link = req;
-		link->last = req;
-
-		/* last request of a link, enqueue the link */
-		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			link->head = NULL;
-			io_queue_sqe(head);
-		}
-	} else {
-		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			link->head = req;
-			link->last = req;
-		} else {
-			io_queue_sqe(req);
-		}
-	}
-
-	return 0;
-}
-
-/*
- * Batched submission is done, ensure local IO is flushed out.
- */
-static void io_submit_state_end(struct io_submit_state *state,
-				struct io_ring_ctx *ctx)
-{
-	if (state->link.head)
-		io_queue_sqe(state->link.head);
-	if (state->compl_nr)
-		io_submit_flush_completions(ctx);
-	if (state->plug_started)
-		blk_finish_plug(&state->plug);
-}
-
-/*
- * Start submission side cache.
- */
-static void io_submit_state_start(struct io_submit_state *state,
-				  unsigned int max_ios)
-{
-	state->plug_started = false;
-	state->ios_left = max_ios;
-	/* set only head, no need to init link_last in advance */
-	state->link.head = NULL;
-}
-
-static void io_commit_sqring(struct io_ring_ctx *ctx)
-{
-	struct io_rings *rings = ctx->rings;
-
-	/*
-	 * Ensure any loads from the SQEs are done at this point,
-	 * since once we write the new head, the application could
-	 * write new data to them.
-	 */
-	smp_store_release(&rings->sq.head, ctx->cached_sq_head);
-}
-
-/*
- * Fetch an sqe, if one is available. Note this returns a pointer to memory
- * that is mapped by userspace. This means that care needs to be taken to
- * ensure that reads are stable, as we cannot rely on userspace always
- * being a good citizen. If members of the sqe are validated and then later
- * used, it's important that those reads are done through READ_ONCE() to
- * prevent a re-load down the line.
- */
-static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
-{
-	unsigned head, mask = ctx->sq_entries - 1;
-	unsigned sq_idx = ctx->cached_sq_head++ & mask;
-
-	/*
-	 * The cached sq head (or cq tail) serves two purposes:
-	 *
-	 * 1) allows us to batch the cost of updating the user visible
-	 *    head updates.
-	 * 2) allows the kernel side to track the head on its own, even
-	 *    though the application is the one updating it.
-	 */
-	head = READ_ONCE(ctx->sq_array[sq_idx]);
-	if (likely(head < ctx->sq_entries))
-		return &ctx->sq_sqes[head];
-
-	/* drop invalid entries */
-	ctx->cq_extra--;
-	WRITE_ONCE(ctx->rings->sq_dropped,
-		   READ_ONCE(ctx->rings->sq_dropped) + 1);
-	return NULL;
-}
-
-static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
-	__must_hold(&ctx->uring_lock)
-{
-	int submitted = 0;
-
-	/* make sure SQ entry isn't read before tail */
-	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
-	if (!percpu_ref_tryget_many(&ctx->refs, nr))
-		return -EAGAIN;
-	io_get_task_refs(nr);
-
-	io_submit_state_start(&ctx->submit_state, nr);
-	while (submitted < nr) {
-		const struct io_uring_sqe *sqe;
-		struct io_kiocb *req;
-
-		req = io_alloc_req(ctx);
-		if (unlikely(!req)) {
-			if (!submitted)
-				submitted = -EAGAIN;
-			break;
-		}
-		sqe = io_get_sqe(ctx);
-		if (unlikely(!sqe)) {
-			list_add(&req->inflight_entry, &ctx->submit_state.free_list);
-			break;
-		}
-		/* will complete beyond this point, count as submitted */
-		submitted++;
-		if (io_submit_sqe(ctx, req, sqe))
-			break;
-	}
-
-	if (unlikely(submitted != nr)) {
-		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
-		int unused = nr - ref_used;
-
-		current->io_uring->cached_refs += unused;
-		percpu_ref_put_many(&ctx->refs, unused);
-	}
-
-	io_submit_state_end(&ctx->submit_state, ctx);
-	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
-	io_commit_sqring(ctx);
-
-	return submitted;
-}
-
-static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
-{
-	return READ_ONCE(sqd->state);
-}
-
-static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
-{
-	/* Tell userspace we may need a wakeup call */
-	spin_lock(&ctx->completion_lock);
-	WRITE_ONCE(ctx->rings->sq_flags,
-		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
-	spin_unlock(&ctx->completion_lock);
-}
-
-static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
-{
-	spin_lock(&ctx->completion_lock);
-	WRITE_ONCE(ctx->rings->sq_flags,
-		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
-	spin_unlock(&ctx->completion_lock);
-}
-
-static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
-{
-	unsigned int to_submit;
-	int ret = 0;
-
-	to_submit = io_sqring_entries(ctx);
-	/* if we're handling multiple rings, cap submit size for fairness */
-	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
-		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
-
-	if (!list_empty(&ctx->iopoll_list) || to_submit) {
-		unsigned nr_events = 0;
-		const struct cred *creds = NULL;
-
-		if (ctx->sq_creds != current_cred())
-			creds = override_creds(ctx->sq_creds);
-
-		mutex_lock(&ctx->uring_lock);
-		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0);
-
-		/*
-		 * Don't submit if refs are dying, good for io_uring_register(),
-		 * but also it is relied upon by io_ring_exit_work()
-		 */
-		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
-		    !(ctx->flags & IORING_SETUP_R_DISABLED))
-			ret = io_submit_sqes(ctx, to_submit);
-		mutex_unlock(&ctx->uring_lock);
-
-		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
-			wake_up(&ctx->sqo_sq_wait);
-		if (creds)
-			revert_creds(creds);
-	}
-
-	return ret;
-}
-
-static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
-{
-	struct io_ring_ctx *ctx;
-	unsigned sq_thread_idle = 0;
-
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		sq_thread_idle = max(sq_thread_idle, ctx->sq_thread_idle);
-	sqd->sq_thread_idle = sq_thread_idle;
-}
-
-static bool io_sqd_handle_event(struct io_sq_data *sqd)
-{
-	bool did_sig = false;
-	struct ksignal ksig;
-
-	if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) ||
-	    signal_pending(current)) {
-		mutex_unlock(&sqd->lock);
-		if (signal_pending(current))
-			did_sig = get_signal(&ksig);
-		cond_resched();
-		mutex_lock(&sqd->lock);
-	}
-	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-}
-
-static int io_sq_thread(void *data)
-{
-	struct io_sq_data *sqd = data;
-	struct io_ring_ctx *ctx;
-	unsigned long timeout = 0;
-	char buf[TASK_COMM_LEN];
-	DEFINE_WAIT(wait);
-
-	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
-	set_task_comm(current, buf);
-
-	if (sqd->sq_cpu != -1)
-		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
-		set_cpus_allowed_ptr(current, cpu_online_mask);
-	current->flags |= PF_NO_SETAFFINITY;
-
-	mutex_lock(&sqd->lock);
-	while (1) {
-		bool cap_entries, sqt_spin = false;
-
-		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
-			if (io_sqd_handle_event(sqd))
-				break;
-			timeout = jiffies + sqd->sq_thread_idle;
-		}
-
-		cap_entries = !list_is_singular(&sqd->ctx_list);
-		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-			int ret = __io_sq_thread(ctx, cap_entries);
-
-			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
-				sqt_spin = true;
-		}
-		if (io_run_task_work())
-			sqt_spin = true;
-
-		if (sqt_spin || !time_after(jiffies, timeout)) {
-			cond_resched();
-			if (sqt_spin)
-				timeout = jiffies + sqd->sq_thread_idle;
-			continue;
-		}
-
-		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd) && !current->task_works) {
-			bool needs_sched = true;
-
-			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-				io_ring_set_wakeup_flag(ctx);
-
-				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-				    !list_empty_careful(&ctx->iopoll_list)) {
-					needs_sched = false;
-					break;
-				}
-				if (io_sqring_entries(ctx)) {
-					needs_sched = false;
-					break;
-				}
-			}
-
-			if (needs_sched) {
-				mutex_unlock(&sqd->lock);
-				schedule();
-				mutex_lock(&sqd->lock);
-			}
-			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_ring_clear_wakeup_flag(ctx);
-		}
-
-		finish_wait(&sqd->wait, &wait);
-		timeout = jiffies + sqd->sq_thread_idle;
-	}
-
-	io_uring_cancel_generic(true, sqd);
-	sqd->thread = NULL;
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		io_ring_set_wakeup_flag(ctx);
-	io_run_task_work();
-	mutex_unlock(&sqd->lock);
-
-	complete(&sqd->exited);
-	do_exit(0);
-}
-
-struct io_wait_queue {
-	struct wait_queue_entry wq;
-	struct io_ring_ctx *ctx;
-	unsigned cq_tail;
-	unsigned nr_timeouts;
-};
-
-static inline bool io_should_wake(struct io_wait_queue *iowq)
-{
-	struct io_ring_ctx *ctx = iowq->ctx;
-	int dist = ctx->cached_cq_tail - (int) iowq->cq_tail;
-
-	/*
-	 * Wake up if we have enough events, or if a timeout occurred since we
-	 * started waiting. For timeouts, we always want to return to userspace,
-	 * regardless of event count.
-	 */
-	return dist >= 0 || atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
-}
-
-static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
-			    int wake_flags, void *key)
-{
-	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue,
-							wq);
-
-	/*
-	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
-	 * the task, and the next invocation will do it.
-	 */
-	if (io_should_wake(iowq) || test_bit(0, &iowq->ctx->check_cq_overflow))
-		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
-}
-
-static int io_run_task_work_sig(void)
-{
-	if (io_run_task_work())
-		return 1;
-	if (!signal_pending(current))
-		return 0;
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
-		return -ERESTARTSYS;
-	return -EINTR;
-}
-
-/* when returns >0, the caller should retry */
-static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
-{
-	int ret;
-
-	/* make sure we run task_work before checking for signals */
-	ret = io_run_task_work_sig();
-	if (ret || io_should_wake(iowq))
-		return ret;
-	/* let the caller flush overflows, retry */
-	if (test_bit(0, &ctx->check_cq_overflow))
-		return 1;
-
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
-		return -ETIME;
-	return 1;
-}
-
-/*
- * Wait until events become available, if we don't already have some. The
- * application must reap them itself, as they reside on the shared cq ring.
- */
-static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
-			  const sigset_t __user *sig, size_t sigsz,
-			  struct __kernel_timespec __user *uts)
-{
-	struct io_wait_queue iowq;
-	struct io_rings *rings = ctx->rings;
-	ktime_t timeout = KTIME_MAX;
-	int ret;
-
-	do {
-		io_cqring_overflow_flush(ctx);
-		if (io_cqring_events(ctx) >= min_events)
-			return 0;
-		if (!io_run_task_work())
-			break;
-	} while (1);
-
-	if (uts) {
-		struct timespec64 ts;
-
-		if (get_timespec64(&ts, uts))
-			return -EFAULT;
-		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
-	}
-
-	if (sig) {
-#ifdef CONFIG_COMPAT
-		if (in_compat_syscall())
-			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
-						      sigsz);
-		else
-#endif
-			ret = set_user_sigmask(sig, sigsz);
-
-		if (ret)
-			return ret;
-	}
-
-	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
-	iowq.wq.private = current;
-	INIT_LIST_HEAD(&iowq.wq.entry);
-	iowq.ctx = ctx;
-	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
-	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-
-	trace_io_uring_cqring_wait(ctx, min_events);
-	do {
-		/* if we can't even flush overflow, don't wait for more */
-		if (!io_cqring_overflow_flush(ctx)) {
-			ret = -EBUSY;
-			break;
-		}
-		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
-						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
-		finish_wait(&ctx->cq_wait, &iowq.wq);
-		cond_resched();
-	} while (ret > 0);
-
-	restore_saved_sigmask_unless(ret == -EINTR);
-
-	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
-}
-
-static void io_free_page_table(void **table, size_t size)
-{
-	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
-
-	for (i = 0; i < nr_tables; i++)
-		kfree(table[i]);
-	kfree(table);
-}
-
-static void **io_alloc_page_table(size_t size)
-{
-	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
-	size_t init_size = size;
-	void **table;
-
-	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL_ACCOUNT);
-	if (!table)
-		return NULL;
-
-	for (i = 0; i < nr_tables; i++) {
-		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
-
-		table[i] = kzalloc(this_size, GFP_KERNEL_ACCOUNT);
-		if (!table[i]) {
-			io_free_page_table(table, init_size);
-			return NULL;
-		}
-		size -= this_size;
-	}
-	return table;
-}
-
-static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
-{
-	percpu_ref_exit(&ref_node->refs);
-	kfree(ref_node);
-}
-
-static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
-{
-	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
-	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
-	unsigned long flags;
-	bool first_add = false;
-	unsigned long delay = HZ;
-
-	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
-	node->done = true;
-
-	/* if we are mid-quiesce then do not delay */
-	if (node->rsrc_data->quiesce)
-		delay = 0;
-
-	while (!list_empty(&ctx->rsrc_ref_list)) {
-		node = list_first_entry(&ctx->rsrc_ref_list,
-					    struct io_rsrc_node, node);
-		/* recycle ref nodes in order */
-		if (!node->done)
-			break;
-		list_del(&node->node);
-		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
-	}
-	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
-
-	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
-}
-
-static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-{
-	struct io_rsrc_node *ref_node;
-
-	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
-	if (!ref_node)
-		return NULL;
-
-	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
-			    0, GFP_KERNEL)) {
-		kfree(ref_node);
-		return NULL;
-	}
-	INIT_LIST_HEAD(&ref_node->node);
-	INIT_LIST_HEAD(&ref_node->rsrc_list);
-	ref_node->done = false;
-	return ref_node;
-}
-
-static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
-				struct io_rsrc_data *data_to_kill)
-{
-	WARN_ON_ONCE(!ctx->rsrc_backup_node);
-	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
-
-	if (data_to_kill) {
-		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
-
-		rsrc_node->rsrc_data = data_to_kill;
-		spin_lock_irq(&ctx->rsrc_ref_lock);
-		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-		spin_unlock_irq(&ctx->rsrc_ref_lock);
-
-		atomic_inc(&data_to_kill->refs);
-		percpu_ref_kill(&rsrc_node->refs);
-		ctx->rsrc_node = NULL;
-	}
-
-	if (!ctx->rsrc_node) {
-		ctx->rsrc_node = ctx->rsrc_backup_node;
-		ctx->rsrc_backup_node = NULL;
-	}
-}
-
-static int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
-{
-	if (ctx->rsrc_backup_node)
-		return 0;
-	ctx->rsrc_backup_node = io_rsrc_node_alloc(ctx);
-	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
-}
-
-static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ctx)
-{
-	int ret;
-
-	/* As we may drop ->uring_lock, other task may have started quiesce */
-	if (data->quiesce)
-		return -ENXIO;
-
-	data->quiesce = true;
-	do {
-		ret = io_rsrc_node_switch_start(ctx);
-		if (ret)
-			break;
-		io_rsrc_node_switch(ctx, data);
-
-		/* kill initial ref, already quiesced if zero */
-		if (atomic_dec_and_test(&data->refs))
-			break;
-		mutex_unlock(&ctx->uring_lock);
-		flush_delayed_work(&ctx->rsrc_put_work);
-		ret = wait_for_completion_interruptible(&data->done);
-		if (!ret) {
-			mutex_lock(&ctx->uring_lock);
-			if (atomic_read(&data->refs) > 0) {
-				/*
-				 * it has been revived by another thread while
-				 * we were unlocked
-				 */
-				mutex_unlock(&ctx->uring_lock);
-			} else {
-				break;
-			}
-		}
-
-		atomic_inc(&data->refs);
-		/* wait for all works potentially completing data->done */
-		flush_delayed_work(&ctx->rsrc_put_work);
-		reinit_completion(&data->done);
-
-		ret = io_run_task_work_sig();
-		mutex_lock(&ctx->uring_lock);
-	} while (ret >= 0);
-	data->quiesce = false;
-
-	return ret;
-}
-
-static u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
-{
-	unsigned int off = idx & IO_RSRC_TAG_TABLE_MASK;
-	unsigned int table_idx = idx >> IO_RSRC_TAG_TABLE_SHIFT;
-
-	return &data->tags[table_idx][off];
-}
-
-static void io_rsrc_data_free(struct io_rsrc_data *data)
-{
-	size_t size = data->nr * sizeof(data->tags[0][0]);
-
-	if (data->tags)
-		io_free_page_table((void **)data->tags, size);
-	kfree(data);
-}
-
-static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
-			      u64 __user *utags, unsigned nr,
-			      struct io_rsrc_data **pdata)
-{
-	struct io_rsrc_data *data;
-	int ret = -ENOMEM;
-	unsigned i;
-
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-	data->tags = (u64 **)io_alloc_page_table(nr * sizeof(data->tags[0][0]));
-	if (!data->tags) {
-		kfree(data);
-		return -ENOMEM;
-	}
-
-	data->nr = nr;
-	data->ctx = ctx;
-	data->do_put = do_put;
-	if (utags) {
-		ret = -EFAULT;
-		for (i = 0; i < nr; i++) {
-			u64 *tag_slot = io_get_tag_slot(data, i);
-
-			if (copy_from_user(tag_slot, &utags[i],
-					   sizeof(*tag_slot)))
-				goto fail;
-		}
-	}
-
-	atomic_set(&data->refs, 1);
-	init_completion(&data->done);
-	*pdata = data;
-	return 0;
-fail:
-	io_rsrc_data_free(data);
-	return ret;
-}
-
-static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
-{
-	table->files = kvcalloc(nr_files, sizeof(table->files[0]),
-				GFP_KERNEL_ACCOUNT);
-	return !!table->files;
-}
-
-static void io_free_file_tables(struct io_file_table *table)
-{
-	kvfree(table->files);
-	table->files = NULL;
-}
-
-static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-{
-#if defined(CONFIG_UNIX)
-	if (ctx->ring_sock) {
-		struct sock *sock = ctx->ring_sock->sk;
-		struct sk_buff *skb;
-
-		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
-			kfree_skb(skb);
-	}
-#else
-	int i;
-
-	for (i = 0; i < ctx->nr_user_files; i++) {
-		struct file *file;
-
-		file = io_file_from_index(ctx, i);
-		if (file)
-			fput(file);
-	}
-#endif
-	io_free_file_tables(&ctx->file_table);
-	io_rsrc_data_free(ctx->file_data);
-	ctx->file_data = NULL;
-	ctx->nr_user_files = 0;
-}
-
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
-{
-	unsigned nr = ctx->nr_user_files;
-	int ret;
-
-	if (!ctx->file_data)
-		return -ENXIO;
-
-	/*
-	 * Quiesce may unlock ->uring_lock, and while it's not held
-	 * prevent new requests using the table.
-	 */
-	ctx->nr_user_files = 0;
-	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
-	ctx->nr_user_files = nr;
-	if (!ret)
-		__io_sqe_files_unregister(ctx);
-	return ret;
-}
-
-static void io_sq_thread_unpark(struct io_sq_data *sqd)
-	__releases(&sqd->lock)
-{
-	WARN_ON_ONCE(sqd->thread == current);
-
-	/*
-	 * Do the dance but not conditional clear_bit() because it'd race with
-	 * other threads incrementing park_pending and setting the bit.
-	 */
-	clear_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-	if (atomic_dec_return(&sqd->park_pending))
-		set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-	mutex_unlock(&sqd->lock);
-}
-
-static void io_sq_thread_park(struct io_sq_data *sqd)
-	__acquires(&sqd->lock)
-{
-	WARN_ON_ONCE(sqd->thread == current);
-
-	atomic_inc(&sqd->park_pending);
-	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-	mutex_lock(&sqd->lock);
-	if (sqd->thread)
-		wake_up_process(sqd->thread);
-}
-
-static void io_sq_thread_stop(struct io_sq_data *sqd)
-{
-	WARN_ON_ONCE(sqd->thread == current);
-	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state));
-
-	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-	mutex_lock(&sqd->lock);
-	if (sqd->thread)
-		wake_up_process(sqd->thread);
-	mutex_unlock(&sqd->lock);
-	wait_for_completion(&sqd->exited);
-}
-
-static void io_put_sq_data(struct io_sq_data *sqd)
-{
-	if (refcount_dec_and_test(&sqd->refs)) {
-		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
-
-		io_sq_thread_stop(sqd);
-		kfree(sqd);
-	}
-}
-
-static void io_sq_thread_finish(struct io_ring_ctx *ctx)
-{
-	struct io_sq_data *sqd = ctx->sq_data;
-
-	if (sqd) {
-		io_sq_thread_park(sqd);
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(sqd);
-		io_sq_thread_unpark(sqd);
-
-		io_put_sq_data(sqd);
-		ctx->sq_data = NULL;
-	}
-}
-
-static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
-{
-	struct io_ring_ctx *ctx_attach;
-	struct io_sq_data *sqd;
-	struct fd f;
-
-	f = fdget(p->wq_fd);
-	if (!f.file)
-		return ERR_PTR(-ENXIO);
-	if (f.file->f_op != &io_uring_fops) {
-		fdput(f);
-		return ERR_PTR(-EINVAL);
-	}
-
-	ctx_attach = f.file->private_data;
-	sqd = ctx_attach->sq_data;
-	if (!sqd) {
-		fdput(f);
-		return ERR_PTR(-EINVAL);
-	}
-	if (sqd->task_tgid != current->tgid) {
-		fdput(f);
-		return ERR_PTR(-EPERM);
-	}
-
-	refcount_inc(&sqd->refs);
-	fdput(f);
-	return sqd;
-}
-
-static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
-					 bool *attached)
-{
-	struct io_sq_data *sqd;
-
-	*attached = false;
-	if (p->flags & IORING_SETUP_ATTACH_WQ) {
-		sqd = io_attach_sq_data(p);
-		if (!IS_ERR(sqd)) {
-			*attached = true;
-			return sqd;
-		}
-		/* fall through for EPERM case, setup new sqd/task */
-		if (PTR_ERR(sqd) != -EPERM)
-			return sqd;
-	}
-
-	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
-	if (!sqd)
-		return ERR_PTR(-ENOMEM);
-
-	atomic_set(&sqd->park_pending, 0);
-	refcount_set(&sqd->refs, 1);
-	INIT_LIST_HEAD(&sqd->ctx_list);
-	mutex_init(&sqd->lock);
-	init_waitqueue_head(&sqd->wait);
-	init_completion(&sqd->exited);
-	return sqd;
-}
-
-#if defined(CONFIG_UNIX)
-/*
- * Ensure the UNIX gc is aware of our file set, so we are certain that
- * the io_uring can be safely unregistered on process exit, even if we have
- * loops in the file referencing.
- */
-static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
-{
-	struct sock *sk = ctx->ring_sock->sk;
-	struct scm_fp_list *fpl;
-	struct sk_buff *skb;
-	int i, nr_files;
-
-	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
-	if (!fpl)
-		return -ENOMEM;
-
-	skb = alloc_skb(0, GFP_KERNEL);
-	if (!skb) {
-		kfree(fpl);
-		return -ENOMEM;
-	}
-
-	skb->sk = sk;
-	skb->scm_io_uring = 1;
-
-	nr_files = 0;
-	fpl->user = get_uid(current_user());
-	for (i = 0; i < nr; i++) {
-		struct file *file = io_file_from_index(ctx, i + offset);
-
-		if (!file)
-			continue;
-		fpl->fp[nr_files] = get_file(file);
-		unix_inflight(fpl->user, fpl->fp[nr_files]);
-		nr_files++;
-	}
-
-	if (nr_files) {
-		fpl->max = SCM_MAX_FD;
-		fpl->count = nr_files;
-		UNIXCB(skb).fp = fpl;
-		skb->destructor = unix_destruct_scm;
-		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
-		skb_queue_head(&sk->sk_receive_queue, skb);
-
-		for (i = 0; i < nr; i++) {
-			struct file *file = io_file_from_index(ctx, i + offset);
-
-			if (file)
-				fput(file);
-		}
-	} else {
-		kfree_skb(skb);
-		free_uid(fpl->user);
-		kfree(fpl);
-	}
-
-	return 0;
-}
-
-/*
- * If UNIX sockets are enabled, fd passing can cause a reference cycle which
- * causes regular reference counting to break down. We rely on the UNIX
- * garbage collection to take care of this problem for us.
- */
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	unsigned left, total;
-	int ret = 0;
-
-	total = 0;
-	left = ctx->nr_user_files;
-	while (left) {
-		unsigned this_files = min_t(unsigned, left, SCM_MAX_FD);
-
-		ret = __io_sqe_files_scm(ctx, this_files, total);
-		if (ret)
-			break;
-		left -= this_files;
-		total += this_files;
-	}
-
-	if (!ret)
-		return 0;
-
-	while (total < ctx->nr_user_files) {
-		struct file *file = io_file_from_index(ctx, total);
-
-		if (file)
-			fput(file);
-		total++;
-	}
-
-	return ret;
-}
-#else
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	return 0;
-}
-#endif
-
-static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
-{
-	struct file *file = prsrc->file;
-#if defined(CONFIG_UNIX)
-	struct sock *sock = ctx->ring_sock->sk;
-	struct sk_buff_head list, *head = &sock->sk_receive_queue;
-	struct sk_buff *skb;
-	int i;
-
-	__skb_queue_head_init(&list);
-
-	/*
-	 * Find the skb that holds this file in its SCM_RIGHTS. When found,
-	 * remove this entry and rearrange the file array.
-	 */
-	skb = skb_dequeue(head);
-	while (skb) {
-		struct scm_fp_list *fp;
-
-		fp = UNIXCB(skb).fp;
-		for (i = 0; i < fp->count; i++) {
-			int left;
-
-			if (fp->fp[i] != file)
-				continue;
-
-			unix_notinflight(fp->user, fp->fp[i]);
-			left = fp->count - 1 - i;
-			if (left) {
-				memmove(&fp->fp[i], &fp->fp[i + 1],
-						left * sizeof(struct file *));
-			}
-			fp->count--;
-			if (!fp->count) {
-				kfree_skb(skb);
-				skb = NULL;
-			} else {
-				__skb_queue_tail(&list, skb);
-			}
-			fput(file);
-			file = NULL;
-			break;
-		}
-
-		if (!file)
-			break;
-
-		__skb_queue_tail(&list, skb);
-
-		skb = skb_dequeue(head);
-	}
-
-	if (skb_peek(&list)) {
-		spin_lock_irq(&head->lock);
-		while ((skb = __skb_dequeue(&list)) != NULL)
-			__skb_queue_tail(head, skb);
-		spin_unlock_irq(&head->lock);
-	}
-#else
-	fput(file);
-#endif
-}
-
-static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
-{
-	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
-	struct io_ring_ctx *ctx = rsrc_data->ctx;
-	struct io_rsrc_put *prsrc, *tmp;
-
-	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
-		list_del(&prsrc->list);
-
-		if (prsrc->tag) {
-			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
-
-			io_ring_submit_lock(ctx, lock_ring);
-			spin_lock(&ctx->completion_lock);
-			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
-			io_commit_cqring(ctx);
-			spin_unlock(&ctx->completion_lock);
-			io_cqring_ev_posted(ctx);
-			io_ring_submit_unlock(ctx, lock_ring);
-		}
-
-		rsrc_data->do_put(ctx, prsrc);
-		kfree(prsrc);
-	}
-
-	io_rsrc_node_destroy(ref_node);
-	if (atomic_dec_and_test(&rsrc_data->refs))
-		complete(&rsrc_data->done);
-}
-
-static void io_rsrc_put_work(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx;
-	struct llist_node *node;
-
-	ctx = container_of(work, struct io_ring_ctx, rsrc_put_work.work);
-	node = llist_del_all(&ctx->rsrc_put_llist);
-
-	while (node) {
-		struct io_rsrc_node *ref_node;
-		struct llist_node *next = node->next;
-
-		ref_node = llist_entry(node, struct io_rsrc_node, llist);
-		__io_rsrc_put_work(ref_node);
-		node = next;
-	}
-}
-
-static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
-				 unsigned nr_args, u64 __user *tags)
-{
-	__s32 __user *fds = (__s32 __user *) arg;
-	struct file *file;
-	int fd, ret;
-	unsigned i;
-
-	if (ctx->file_data)
-		return -EBUSY;
-	if (!nr_args)
-		return -EINVAL;
-	if (nr_args > IORING_MAX_FIXED_FILES)
-		return -EMFILE;
-	if (nr_args > rlimit(RLIMIT_NOFILE))
-		return -EMFILE;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		return ret;
-	ret = io_rsrc_data_alloc(ctx, io_rsrc_file_put, tags, nr_args,
-				 &ctx->file_data);
-	if (ret)
-		return ret;
-
-	ret = -ENOMEM;
-	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
-		goto out_free;
-
-	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
-			ret = -EFAULT;
-			goto out_fput;
-		}
-		/* allow sparse sets */
-		if (fd == -1) {
-			ret = -EINVAL;
-			if (unlikely(*io_get_tag_slot(ctx->file_data, i)))
-				goto out_fput;
-			continue;
-		}
-
-		file = fget(fd);
-		ret = -EBADF;
-		if (unlikely(!file))
-			goto out_fput;
-
-		/*
-		 * Don't allow io_uring instances to be registered. If UNIX
-		 * isn't enabled, then this causes a reference cycle and this
-		 * instance can never get freed. If UNIX is enabled we'll
-		 * handle it just fine, but there's still no point in allowing
-		 * a ring fd as it doesn't support regular read/write anyway.
-		 */
-		if (file->f_op == &io_uring_fops) {
-			fput(file);
-			goto out_fput;
-		}
-		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
-	}
-
-	ret = io_sqe_files_scm(ctx);
-	if (ret) {
-		__io_sqe_files_unregister(ctx);
-		return ret;
-	}
-
-	io_rsrc_node_switch(ctx, NULL);
-	return ret;
-out_fput:
-	for (i = 0; i < ctx->nr_user_files; i++) {
-		file = io_file_from_index(ctx, i);
-		if (file)
-			fput(file);
-	}
-	io_free_file_tables(&ctx->file_table);
-	ctx->nr_user_files = 0;
-out_free:
-	io_rsrc_data_free(ctx->file_data);
-	ctx->file_data = NULL;
-	return ret;
-}
-
-static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
-				int index)
-{
-#if defined(CONFIG_UNIX)
-	struct sock *sock = ctx->ring_sock->sk;
-	struct sk_buff_head *head = &sock->sk_receive_queue;
-	struct sk_buff *skb;
-
-	/*
-	 * See if we can merge this file into an existing skb SCM_RIGHTS
-	 * file set. If there's no room, fall back to allocating a new skb
-	 * and filling it in.
-	 */
-	spin_lock_irq(&head->lock);
-	skb = skb_peek(head);
-	if (skb) {
-		struct scm_fp_list *fpl = UNIXCB(skb).fp;
-
-		if (fpl->count < SCM_MAX_FD) {
-			__skb_unlink(skb, head);
-			spin_unlock_irq(&head->lock);
-			fpl->fp[fpl->count] = get_file(file);
-			unix_inflight(fpl->user, fpl->fp[fpl->count]);
-			fpl->count++;
-			spin_lock_irq(&head->lock);
-			__skb_queue_head(head, skb);
-		} else {
-			skb = NULL;
-		}
-	}
-	spin_unlock_irq(&head->lock);
-
-	if (skb) {
-		fput(file);
-		return 0;
-	}
-
-	return __io_sqe_files_scm(ctx, 1, index);
-#else
-	return 0;
-#endif
-}
-
-static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
-				 struct io_rsrc_node *node, void *rsrc)
-{
-	u64 *tag_slot = io_get_tag_slot(data, idx);
-	struct io_rsrc_put *prsrc;
-
-	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
-	if (!prsrc)
-		return -ENOMEM;
-
-	prsrc->tag = *tag_slot;
-	*tag_slot = 0;
-	prsrc->rsrc = rsrc;
-	list_add(&prsrc->list, &node->rsrc_list);
-	return 0;
-}
-
-static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
-				 unsigned int issue_flags, u32 slot_index)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	bool needs_switch = false;
-	struct io_fixed_file *file_slot;
-	int ret = -EBADF;
-
-	io_ring_submit_lock(ctx, !force_nonblock);
-	if (file->f_op == &io_uring_fops)
-		goto err;
-	ret = -ENXIO;
-	if (!ctx->file_data)
-		goto err;
-	ret = -EINVAL;
-	if (slot_index >= ctx->nr_user_files)
-		goto err;
-
-	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
-
-	if (file_slot->file_ptr) {
-		struct file *old_file;
-
-		ret = io_rsrc_node_switch_start(ctx);
-		if (ret)
-			goto err;
-
-		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
-					    ctx->rsrc_node, old_file);
-		if (ret)
-			goto err;
-		file_slot->file_ptr = 0;
-		needs_switch = true;
-	}
-
-	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
-	io_fixed_file_set(file_slot, file);
-	ret = io_sqe_file_register(ctx, file, slot_index);
-	if (ret) {
-		file_slot->file_ptr = 0;
-		goto err;
-	}
-
-	ret = 0;
-err:
-	if (needs_switch)
-		io_rsrc_node_switch(ctx, ctx->file_data);
-	io_ring_submit_unlock(ctx, !force_nonblock);
-	if (ret)
-		fput(file);
-	return ret;
-}
-
-static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
-{
-	unsigned int offset = req->close.file_slot - 1;
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_fixed_file *file_slot;
-	struct file *file;
-	int ret;
-
-	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
-	ret = -ENXIO;
-	if (unlikely(!ctx->file_data))
-		goto out;
-	ret = -EINVAL;
-	if (offset >= ctx->nr_user_files)
-		goto out;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		goto out;
-
-	offset = array_index_nospec(offset, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
-	ret = -EBADF;
-	if (!file_slot->file_ptr)
-		goto out;
-
-	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
-	if (ret)
-		goto out;
-
-	file_slot->file_ptr = 0;
-	io_rsrc_node_switch(ctx, ctx->file_data);
-	ret = 0;
-out:
-	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
-	return ret;
-}
-
-static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_rsrc_update2 *up,
-				 unsigned nr_args)
-{
-	u64 __user *tags = u64_to_user_ptr(up->tags);
-	__s32 __user *fds = u64_to_user_ptr(up->data);
-	struct io_rsrc_data *data = ctx->file_data;
-	struct io_fixed_file *file_slot;
-	struct file *file;
-	int fd, i, err = 0;
-	unsigned int done;
-	bool needs_switch = false;
-
-	if (!ctx->file_data)
-		return -ENXIO;
-	if (up->offset + nr_args > ctx->nr_user_files)
-		return -EINVAL;
-
-	for (done = 0; done < nr_args; done++) {
-		u64 tag = 0;
-
-		if ((tags && copy_from_user(&tag, &tags[done], sizeof(tag))) ||
-		    copy_from_user(&fd, &fds[done], sizeof(fd))) {
-			err = -EFAULT;
-			break;
-		}
-		if ((fd == IORING_REGISTER_FILES_SKIP || fd == -1) && tag) {
-			err = -EINVAL;
-			break;
-		}
-		if (fd == IORING_REGISTER_FILES_SKIP)
-			continue;
-
-		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
-		file_slot = io_fixed_file_slot(&ctx->file_table, i);
-
-		if (file_slot->file_ptr) {
-			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, i, ctx->rsrc_node, file);
-			if (err)
-				break;
-			file_slot->file_ptr = 0;
-			needs_switch = true;
-		}
-		if (fd != -1) {
-			file = fget(fd);
-			if (!file) {
-				err = -EBADF;
-				break;
-			}
-			/*
-			 * Don't allow io_uring instances to be registered. If
-			 * UNIX isn't enabled, then this causes a reference
-			 * cycle and this instance can never get freed. If UNIX
-			 * is enabled we'll handle it just fine, but there's
-			 * still no point in allowing a ring fd as it doesn't
-			 * support regular read/write anyway.
-			 */
-			if (file->f_op == &io_uring_fops) {
-				fput(file);
-				err = -EBADF;
-				break;
-			}
-			*io_get_tag_slot(data, i) = tag;
-			io_fixed_file_set(file_slot, file);
-			err = io_sqe_file_register(ctx, file, i);
-			if (err) {
-				file_slot->file_ptr = 0;
-				fput(file);
-				break;
-			}
-		}
-	}
-
-	if (needs_switch)
-		io_rsrc_node_switch(ctx, data);
-	return done ? done : err;
-}
-
-static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
-					struct task_struct *task)
-{
-	struct io_wq_hash *hash;
-	struct io_wq_data data;
-	unsigned int concurrency;
-
-	mutex_lock(&ctx->uring_lock);
-	hash = ctx->hash_map;
-	if (!hash) {
-		hash = kzalloc(sizeof(*hash), GFP_KERNEL);
-		if (!hash) {
-			mutex_unlock(&ctx->uring_lock);
-			return ERR_PTR(-ENOMEM);
-		}
-		refcount_set(&hash->refs, 1);
-		init_waitqueue_head(&hash->wait);
-		ctx->hash_map = hash;
-	}
-	mutex_unlock(&ctx->uring_lock);
-
-	data.hash = hash;
-	data.task = task;
-	data.free_work = io_wq_free_work;
-	data.do_work = io_wq_submit_work;
-
-	/* Do QD, or 4 * CPUS, whatever is smallest */
-	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
-
-	return io_wq_create(concurrency, &data);
-}
-
-static int io_uring_alloc_task_context(struct task_struct *task,
-				       struct io_ring_ctx *ctx)
-{
-	struct io_uring_task *tctx;
-	int ret;
-
-	tctx = kzalloc(sizeof(*tctx), GFP_KERNEL);
-	if (unlikely(!tctx))
-		return -ENOMEM;
-
-	ret = percpu_counter_init(&tctx->inflight, 0, GFP_KERNEL);
-	if (unlikely(ret)) {
-		kfree(tctx);
-		return ret;
-	}
-
-	tctx->io_wq = io_init_wq_offload(ctx, task);
-	if (IS_ERR(tctx->io_wq)) {
-		ret = PTR_ERR(tctx->io_wq);
-		percpu_counter_destroy(&tctx->inflight);
-		kfree(tctx);
-		return ret;
-	}
-
-	xa_init(&tctx->xa);
-	init_waitqueue_head(&tctx->wait);
-	atomic_set(&tctx->in_idle, 0);
-	atomic_set(&tctx->inflight_tracked, 0);
-	task->io_uring = tctx;
-	spin_lock_init(&tctx->task_lock);
-	INIT_WQ_LIST(&tctx->task_list);
-	init_task_work(&tctx->task_work, tctx_task_work);
-	return 0;
-}
-
-void __io_uring_free(struct task_struct *tsk)
-{
-	struct io_uring_task *tctx = tsk->io_uring;
-
-	WARN_ON_ONCE(!xa_empty(&tctx->xa));
-	WARN_ON_ONCE(tctx->io_wq);
-	WARN_ON_ONCE(tctx->cached_refs);
-
-	percpu_counter_destroy(&tctx->inflight);
-	kfree(tctx);
-	tsk->io_uring = NULL;
-}
-
-static int io_sq_offload_create(struct io_ring_ctx *ctx,
-				struct io_uring_params *p)
-{
-	int ret;
-
-	/* Retain compatibility with failing for an invalid attach attempt */
-	if ((ctx->flags & (IORING_SETUP_ATTACH_WQ | IORING_SETUP_SQPOLL)) ==
-				IORING_SETUP_ATTACH_WQ) {
-		struct fd f;
-
-		f = fdget(p->wq_fd);
-		if (!f.file)
-			return -ENXIO;
-		if (f.file->f_op != &io_uring_fops) {
-			fdput(f);
-			return -EINVAL;
-		}
-		fdput(f);
-	}
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		struct task_struct *tsk;
-		struct io_sq_data *sqd;
-		bool attached;
-
-		sqd = io_get_sq_data(p, &attached);
-		if (IS_ERR(sqd)) {
-			ret = PTR_ERR(sqd);
-			goto err;
-		}
-
-		ctx->sq_creds = get_current_cred();
-		ctx->sq_data = sqd;
-		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
-		if (!ctx->sq_thread_idle)
-			ctx->sq_thread_idle = HZ;
-
-		io_sq_thread_park(sqd);
-		list_add(&ctx->sqd_list, &sqd->ctx_list);
-		io_sqd_update_thread_idle(sqd);
-		/* don't attach to a dying SQPOLL thread, would be racy */
-		ret = (attached && !sqd->thread) ? -ENXIO : 0;
-		io_sq_thread_unpark(sqd);
-
-		if (ret < 0)
-			goto err;
-		if (attached)
-			return 0;
-
-		if (p->flags & IORING_SETUP_SQ_AFF) {
-			int cpu = p->sq_thread_cpu;
-
-			ret = -EINVAL;
-			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
-				goto err_sqpoll;
-			sqd->sq_cpu = cpu;
-		} else {
-			sqd->sq_cpu = -1;
-		}
-
-		sqd->task_pid = current->pid;
-		sqd->task_tgid = current->tgid;
-		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
-		if (IS_ERR(tsk)) {
-			ret = PTR_ERR(tsk);
-			goto err_sqpoll;
-		}
-
-		sqd->thread = tsk;
-		ret = io_uring_alloc_task_context(tsk, ctx);
-		wake_up_new_task(tsk);
-		if (ret)
-			goto err;
-	} else if (p->flags & IORING_SETUP_SQ_AFF) {
-		/* Can't have SQ_AFF without SQPOLL */
-		ret = -EINVAL;
-		goto err;
-	}
-
-	return 0;
-err_sqpoll:
-	complete(&ctx->sq_data->exited);
-err:
-	io_sq_thread_finish(ctx);
-	return ret;
-}
-
-static inline void __io_unaccount_mem(struct user_struct *user,
-				      unsigned long nr_pages)
-{
-	atomic_long_sub(nr_pages, &user->locked_vm);
-}
-
-static inline int __io_account_mem(struct user_struct *user,
-				   unsigned long nr_pages)
-{
-	unsigned long page_limit, cur_pages, new_pages;
-
-	/* Don't allow more pages than we can safely lock */
-	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-	do {
-		cur_pages = atomic_long_read(&user->locked_vm);
-		new_pages = cur_pages + nr_pages;
-		if (new_pages > page_limit)
-			return -ENOMEM;
-	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
-					new_pages) != cur_pages);
-
-	return 0;
-}
-
-static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
-{
-	if (ctx->user)
-		__io_unaccount_mem(ctx->user, nr_pages);
-
-	if (ctx->mm_account)
-		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
-}
-
-static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
-{
-	int ret;
-
-	if (ctx->user) {
-		ret = __io_account_mem(ctx->user, nr_pages);
-		if (ret)
-			return ret;
-	}
-
-	if (ctx->mm_account)
-		atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
-
-	return 0;
-}
-
-static void io_mem_free(void *ptr)
-{
-	struct page *page;
-
-	if (!ptr)
-		return;
-
-	page = virt_to_head_page(ptr);
-	if (put_page_testzero(page))
-		free_compound_page(page);
-}
-
-static void *io_mem_alloc(size_t size)
-{
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
-
-	return (void *) __get_free_pages(gfp, get_order(size));
-}
-
-static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
-				size_t *sq_offset)
-{
-	struct io_rings *rings;
-	size_t off, sq_array_size;
-
-	off = struct_size(rings, cqes, cq_entries);
-	if (off == SIZE_MAX)
-		return SIZE_MAX;
-
-#ifdef CONFIG_SMP
-	off = ALIGN(off, SMP_CACHE_BYTES);
-	if (off == 0)
-		return SIZE_MAX;
-#endif
-
-	if (sq_offset)
-		*sq_offset = off;
-
-	sq_array_size = array_size(sizeof(u32), sq_entries);
-	if (sq_array_size == SIZE_MAX)
-		return SIZE_MAX;
-
-	if (check_add_overflow(off, sq_array_size, &off))
-		return SIZE_MAX;
-
-	return off;
-}
-
-static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slot)
-{
-	struct io_mapped_ubuf *imu = *slot;
-	unsigned int i;
-
-	if (imu != ctx->dummy_ubuf) {
-		for (i = 0; i < imu->nr_bvecs; i++)
-			unpin_user_page(imu->bvec[i].bv_page);
-		if (imu->acct_pages)
-			io_unaccount_mem(ctx, imu->acct_pages);
-		kvfree(imu);
-	}
-	*slot = NULL;
-}
-
-static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
-{
-	io_buffer_unmap(ctx, &prsrc->buf);
-	prsrc->buf = NULL;
-}
-
-static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
-{
-	unsigned int i;
-
-	for (i = 0; i < ctx->nr_user_bufs; i++)
-		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
-	kfree(ctx->user_bufs);
-	io_rsrc_data_free(ctx->buf_data);
-	ctx->user_bufs = NULL;
-	ctx->buf_data = NULL;
-	ctx->nr_user_bufs = 0;
-}
-
-static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
-{
-	unsigned nr = ctx->nr_user_bufs;
-	int ret;
-
-	if (!ctx->buf_data)
-		return -ENXIO;
-
-	/*
-	 * Quiesce may unlock ->uring_lock, and while it's not held
-	 * prevent new requests using the table.
-	 */
-	ctx->nr_user_bufs = 0;
-	ret = io_rsrc_ref_quiesce(ctx->buf_data, ctx);
-	ctx->nr_user_bufs = nr;
-	if (!ret)
-		__io_sqe_buffers_unregister(ctx);
-	return ret;
-}
-
-static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
-		       void __user *arg, unsigned index)
-{
-	struct iovec __user *src;
-
-#ifdef CONFIG_COMPAT
-	if (ctx->compat) {
-		struct compat_iovec __user *ciovs;
-		struct compat_iovec ciov;
-
-		ciovs = (struct compat_iovec __user *) arg;
-		if (copy_from_user(&ciov, &ciovs[index], sizeof(ciov)))
-			return -EFAULT;
-
-		dst->iov_base = u64_to_user_ptr((u64)ciov.iov_base);
-		dst->iov_len = ciov.iov_len;
-		return 0;
-	}
-#endif
-	src = (struct iovec __user *) arg;
-	if (copy_from_user(dst, &src[index], sizeof(*dst)))
-		return -EFAULT;
-	return 0;
-}
-
-/*
- * Not super efficient, but this is just a registration time. And we do cache
- * the last compound head, so generally we'll only do a full search if we don't
- * match that one.
- *
- * We check if the given compound head page has already been accounted, to
- * avoid double accounting it. This allows us to account the full size of the
- * page, not just the constituent pages of a huge page.
- */
-static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
-				  int nr_pages, struct page *hpage)
-{
-	int i, j;
-
-	/* check current page array */
-	for (i = 0; i < nr_pages; i++) {
-		if (!PageCompound(pages[i]))
-			continue;
-		if (compound_head(pages[i]) == hpage)
-			return true;
-	}
-
-	/* check previously registered pages */
-	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
-
-		for (j = 0; j < imu->nr_bvecs; j++) {
-			if (!PageCompound(imu->bvec[j].bv_page))
-				continue;
-			if (compound_head(imu->bvec[j].bv_page) == hpage)
-				return true;
-		}
-	}
-
-	return false;
-}
-
-static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
-				 int nr_pages, struct io_mapped_ubuf *imu,
-				 struct page **last_hpage)
-{
-	int i, ret;
-
-	imu->acct_pages = 0;
-	for (i = 0; i < nr_pages; i++) {
-		if (!PageCompound(pages[i])) {
-			imu->acct_pages++;
-		} else {
-			struct page *hpage;
-
-			hpage = compound_head(pages[i]);
-			if (hpage == *last_hpage)
-				continue;
-			*last_hpage = hpage;
-			if (headpage_already_acct(ctx, pages, i, hpage))
-				continue;
-			imu->acct_pages += page_size(hpage) >> PAGE_SHIFT;
-		}
-	}
-
-	if (!imu->acct_pages)
-		return 0;
-
-	ret = io_account_mem(ctx, imu->acct_pages);
-	if (ret)
-		imu->acct_pages = 0;
-	return ret;
-}
-
-static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
-				  struct io_mapped_ubuf **pimu,
-				  struct page **last_hpage)
-{
-	struct io_mapped_ubuf *imu = NULL;
-	struct vm_area_struct **vmas = NULL;
-	struct page **pages = NULL;
-	unsigned long off, start, end, ubuf;
-	size_t size;
-	int ret, pret, nr_pages, i;
-
-	if (!iov->iov_base) {
-		*pimu = ctx->dummy_ubuf;
-		return 0;
-	}
-
-	ubuf = (unsigned long) iov->iov_base;
-	end = (ubuf + iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	start = ubuf >> PAGE_SHIFT;
-	nr_pages = end - start;
-
-	*pimu = NULL;
-	ret = -ENOMEM;
-
-	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		goto done;
-
-	vmas = kvmalloc_array(nr_pages, sizeof(struct vm_area_struct *),
-			      GFP_KERNEL);
-	if (!vmas)
-		goto done;
-
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu)
-		goto done;
-
-	ret = 0;
-	mmap_read_lock(current->mm);
-	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages, vmas);
-	if (pret == nr_pages) {
-		/* don't support file backed memory */
-		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
-				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
-				ret = -EOPNOTSUPP;
-				break;
-			}
-		}
-	} else {
-		ret = pret < 0 ? pret : -EFAULT;
-	}
-	mmap_read_unlock(current->mm);
-	if (ret) {
-		/*
-		 * if we did partial map, or found file backed vmas,
-		 * release any pages we did get
-		 */
-		if (pret > 0)
-			unpin_user_pages(pages, pret);
-		goto done;
-	}
-
-	ret = io_buffer_account_pin(ctx, pages, pret, imu, last_hpage);
-	if (ret) {
-		unpin_user_pages(pages, pret);
-		goto done;
-	}
-
-	off = ubuf & ~PAGE_MASK;
-	size = iov->iov_len;
-	for (i = 0; i < nr_pages; i++) {
-		size_t vec_len;
-
-		vec_len = min_t(size_t, size, PAGE_SIZE - off);
-		imu->bvec[i].bv_page = pages[i];
-		imu->bvec[i].bv_len = vec_len;
-		imu->bvec[i].bv_offset = off;
-		off = 0;
-		size -= vec_len;
-	}
-	/* store original address for later verification */
-	imu->ubuf = ubuf;
-	imu->ubuf_end = ubuf + iov->iov_len;
-	imu->nr_bvecs = nr_pages;
-	*pimu = imu;
-	ret = 0;
-done:
-	if (ret)
-		kvfree(imu);
-	kvfree(pages);
-	kvfree(vmas);
-	return ret;
-}
-
-static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
-{
-	ctx->user_bufs = kcalloc(nr_args, sizeof(*ctx->user_bufs), GFP_KERNEL);
-	return ctx->user_bufs ? 0 : -ENOMEM;
-}
-
-static int io_buffer_validate(struct iovec *iov)
-{
-	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
-
-	/*
-	 * Don't impose further limits on the size and buffer
-	 * constraints here, we'll -EINVAL later when IO is
-	 * submitted if they are wrong.
-	 */
-	if (!iov->iov_base)
-		return iov->iov_len ? -EFAULT : 0;
-	if (!iov->iov_len)
-		return -EFAULT;
-
-	/* arbitrary limit, but we need something */
-	if (iov->iov_len > SZ_1G)
-		return -EFAULT;
-
-	if (check_add_overflow((unsigned long)iov->iov_base, acct_len, &tmp))
-		return -EOVERFLOW;
-
-	return 0;
-}
-
-static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
-				   unsigned int nr_args, u64 __user *tags)
-{
-	struct page *last_hpage = NULL;
-	struct io_rsrc_data *data;
-	int i, ret;
-	struct iovec iov;
-
-	if (ctx->user_bufs)
-		return -EBUSY;
-	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
-		return -EINVAL;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		return ret;
-	ret = io_rsrc_data_alloc(ctx, io_rsrc_buf_put, tags, nr_args, &data);
-	if (ret)
-		return ret;
-	ret = io_buffers_map_alloc(ctx, nr_args);
-	if (ret) {
-		io_rsrc_data_free(data);
-		return ret;
-	}
-
-	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
-		ret = io_copy_iov(ctx, &iov, arg, i);
-		if (ret)
-			break;
-		ret = io_buffer_validate(&iov);
-		if (ret)
-			break;
-		if (!iov.iov_base && *io_get_tag_slot(data, i)) {
-			ret = -EINVAL;
-			break;
-		}
-
-		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
-					     &last_hpage);
-		if (ret)
-			break;
-	}
-
-	WARN_ON_ONCE(ctx->buf_data);
-
-	ctx->buf_data = data;
-	if (ret)
-		__io_sqe_buffers_unregister(ctx);
-	else
-		io_rsrc_node_switch(ctx, NULL);
-	return ret;
-}
-
-static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
-				   struct io_uring_rsrc_update2 *up,
-				   unsigned int nr_args)
-{
-	u64 __user *tags = u64_to_user_ptr(up->tags);
-	struct iovec iov, __user *iovs = u64_to_user_ptr(up->data);
-	struct page *last_hpage = NULL;
-	bool needs_switch = false;
-	__u32 done;
-	int i, err;
-
-	if (!ctx->buf_data)
-		return -ENXIO;
-	if (up->offset + nr_args > ctx->nr_user_bufs)
-		return -EINVAL;
-
-	for (done = 0; done < nr_args; done++) {
-		struct io_mapped_ubuf *imu;
-		int offset = up->offset + done;
-		u64 tag = 0;
-
-		err = io_copy_iov(ctx, &iov, iovs, done);
-		if (err)
-			break;
-		if (tags && copy_from_user(&tag, &tags[done], sizeof(tag))) {
-			err = -EFAULT;
-			break;
-		}
-		err = io_buffer_validate(&iov);
-		if (err)
-			break;
-		if (!iov.iov_base && tag) {
-			err = -EINVAL;
-			break;
-		}
-		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
-		if (err)
-			break;
-
-		i = array_index_nospec(offset, ctx->nr_user_bufs);
-		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
-			err = io_queue_rsrc_removal(ctx->buf_data, i,
-						    ctx->rsrc_node, ctx->user_bufs[i]);
-			if (unlikely(err)) {
-				io_buffer_unmap(ctx, &imu);
-				break;
-			}
-			ctx->user_bufs[i] = NULL;
-			needs_switch = true;
-		}
-
-		ctx->user_bufs[i] = imu;
-		*io_get_tag_slot(ctx->buf_data, offset) = tag;
-	}
-
-	if (needs_switch)
-		io_rsrc_node_switch(ctx, ctx->buf_data);
-	return done ? done : err;
-}
-
-static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
-{
-	__s32 __user *fds = arg;
-	int fd;
-
-	if (ctx->cq_ev_fd)
-		return -EBUSY;
-
-	if (copy_from_user(&fd, fds, sizeof(*fds)))
-		return -EFAULT;
-
-	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
-	if (IS_ERR(ctx->cq_ev_fd)) {
-		int ret = PTR_ERR(ctx->cq_ev_fd);
-
-		ctx->cq_ev_fd = NULL;
-		return ret;
-	}
-
-	return 0;
-}
-
-static int io_eventfd_unregister(struct io_ring_ctx *ctx)
-{
-	if (ctx->cq_ev_fd) {
-		eventfd_ctx_put(ctx->cq_ev_fd);
-		ctx->cq_ev_fd = NULL;
-		return 0;
-	}
-
-	return -ENXIO;
-}
-
-static void io_destroy_buffers(struct io_ring_ctx *ctx)
-{
-	struct io_buffer *buf;
-	unsigned long index;
-
-	xa_for_each(&ctx->io_buffers, index, buf)
-		__io_remove_buffers(ctx, buf, index, -1U);
-}
-
-static void io_req_cache_free(struct list_head *list)
-{
-	struct io_kiocb *req, *nxt;
-
-	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
-		list_del(&req->inflight_entry);
-		kmem_cache_free(req_cachep, req);
-	}
-}
-
-static void io_req_caches_free(struct io_ring_ctx *ctx)
-{
-	struct io_submit_state *state = &ctx->submit_state;
-
-	mutex_lock(&ctx->uring_lock);
-
-	if (state->free_reqs) {
-		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
-		state->free_reqs = 0;
-	}
-
-	io_flush_cached_locked_reqs(ctx, state);
-	io_req_cache_free(&state->free_list);
-	mutex_unlock(&ctx->uring_lock);
-}
-
-static void io_wait_rsrc_data(struct io_rsrc_data *data)
-{
-	if (data && !atomic_dec_and_test(&data->refs))
-		wait_for_completion(&data->done);
-}
-
-static void io_ring_ctx_free(struct io_ring_ctx *ctx)
-{
-	io_sq_thread_finish(ctx);
-
-	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
-	io_wait_rsrc_data(ctx->buf_data);
-	io_wait_rsrc_data(ctx->file_data);
-
-	mutex_lock(&ctx->uring_lock);
-	if (ctx->buf_data)
-		__io_sqe_buffers_unregister(ctx);
-	if (ctx->file_data)
-		__io_sqe_files_unregister(ctx);
-	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true);
-	mutex_unlock(&ctx->uring_lock);
-	io_eventfd_unregister(ctx);
-	io_destroy_buffers(ctx);
-	if (ctx->sq_creds)
-		put_cred(ctx->sq_creds);
-
-	/* there are no registered resources left, nobody uses it */
-	if (ctx->rsrc_node)
-		io_rsrc_node_destroy(ctx->rsrc_node);
-	if (ctx->rsrc_backup_node)
-		io_rsrc_node_destroy(ctx->rsrc_backup_node);
-	flush_delayed_work(&ctx->rsrc_put_work);
-
-	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
-	WARN_ON_ONCE(!llist_empty(&ctx->rsrc_put_llist));
-
-#if defined(CONFIG_UNIX)
-	if (ctx->ring_sock) {
-		ctx->ring_sock->file = NULL; /* so that iput() is called */
-		sock_release(ctx->ring_sock);
-	}
-#endif
-	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
-
-	if (ctx->mm_account) {
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
-	}
-
-	io_mem_free(ctx->rings);
-	io_mem_free(ctx->sq_sqes);
-
-	percpu_ref_exit(&ctx->refs);
-	free_uid(ctx->user);
-	io_req_caches_free(ctx);
-	if (ctx->hash_map)
-		io_wq_put_hash(ctx->hash_map);
-	kfree(ctx->cancel_hash);
-	kfree(ctx->dummy_ubuf);
-	kfree(ctx);
-}
-
-static __poll_t io_uring_poll(struct file *file, poll_table *wait)
-{
-	struct io_ring_ctx *ctx = file->private_data;
-	__poll_t mask = 0;
-
-	poll_wait(file, &ctx->poll_wait, wait);
-	/*
-	 * synchronizes with barrier from wq_has_sleeper call in
-	 * io_commit_cqring
-	 */
-	smp_rmb();
-	if (!io_sqring_full(ctx))
-		mask |= EPOLLOUT | EPOLLWRNORM;
-
-	/*
-	 * Don't flush cqring overflow list here, just do a simple check.
-	 * Otherwise there could possible be ABBA deadlock:
-	 *      CPU0                    CPU1
-	 *      ----                    ----
-	 * lock(&ctx->uring_lock);
-	 *                              lock(&ep->mtx);
-	 *                              lock(&ctx->uring_lock);
-	 * lock(&ep->mtx);
-	 *
-	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
-	 * pushs them to do the flush.
-	 */
-	if (io_cqring_events(ctx) || test_bit(0, &ctx->check_cq_overflow))
-		mask |= EPOLLIN | EPOLLRDNORM;
-
-	return mask;
-}
-
-static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
-{
-	const struct cred *creds;
-
-	creds = xa_erase(&ctx->personalities, id);
-	if (creds) {
-		put_cred(creds);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-struct io_tctx_exit {
-	struct callback_head		task_work;
-	struct completion		completion;
-	struct io_ring_ctx		*ctx;
-};
-
-static void io_tctx_exit_cb(struct callback_head *cb)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_tctx_exit *work;
-
-	work = container_of(cb, struct io_tctx_exit, task_work);
-	/*
-	 * When @in_idle, we're in cancellation and it's racy to remove the
-	 * node. It'll be removed by the end of cancellation, just ignore it.
-	 */
-	if (!atomic_read(&tctx->in_idle))
-		io_uring_del_tctx_node((unsigned long)work->ctx);
-	complete(&work->completion);
-}
-
-static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	return req->ctx == data;
-}
-
-static void io_ring_exit_work(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
-	unsigned long timeout = jiffies + HZ * 60 * 5;
-	unsigned long interval = HZ / 20;
-	struct io_tctx_exit exit;
-	struct io_tctx_node *node;
-	int ret;
-
-	/*
-	 * If we're doing polled IO and end up having requests being
-	 * submitted async (out-of-line), then completions can come in while
-	 * we're waiting for refs to drop. We need to reap these manually,
-	 * as nobody else will be looking for them.
-	 */
-	do {
-		io_uring_try_cancel_requests(ctx, NULL, true);
-		if (ctx->sq_data) {
-			struct io_sq_data *sqd = ctx->sq_data;
-			struct task_struct *tsk;
-
-			io_sq_thread_park(sqd);
-			tsk = sqd->thread;
-			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
-				io_wq_cancel_cb(tsk->io_uring->io_wq,
-						io_cancel_ctx_cb, ctx, true);
-			io_sq_thread_unpark(sqd);
-		}
-
-		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
-			/* there is little hope left, don't run it too often */
-			interval = HZ * 60;
-		}
-	} while (!wait_for_completion_timeout(&ctx->ref_comp, interval));
-
-	init_completion(&exit.completion);
-	init_task_work(&exit.task_work, io_tctx_exit_cb);
-	exit.ctx = ctx;
-	/*
-	 * Some may use context even when all refs and requests have been put,
-	 * and they are free to do so while still holding uring_lock or
-	 * completion_lock, see io_req_task_submit(). Apart from other work,
-	 * this lock/unlock section also waits them to finish.
-	 */
-	mutex_lock(&ctx->uring_lock);
-	while (!list_empty(&ctx->tctx_list)) {
-		WARN_ON_ONCE(time_after(jiffies, timeout));
-
-		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
-					ctx_node);
-		/* don't spin on a single task if cancellation failed */
-		list_rotate_left(&ctx->tctx_list);
-		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
-		if (WARN_ON_ONCE(ret))
-			continue;
-		wake_up_process(node->task);
-
-		mutex_unlock(&ctx->uring_lock);
-		wait_for_completion(&exit.completion);
-		mutex_lock(&ctx->uring_lock);
-	}
-	mutex_unlock(&ctx->uring_lock);
-	spin_lock(&ctx->completion_lock);
-	spin_unlock(&ctx->completion_lock);
-
-	io_ring_ctx_free(ctx);
-}
-
-/* Returns true if we found and killed one or more timeouts */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			     bool cancel_all)
-{
-	struct io_kiocb *req, *tmp;
-	int canceled = 0;
-
-	spin_lock(&ctx->completion_lock);
-	spin_lock_irq(&ctx->timeout_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_match_task(req, tsk, cancel_all)) {
-			io_kill_timeout(req, -ECANCELED);
-			canceled++;
-		}
-	}
-	spin_unlock_irq(&ctx->timeout_lock);
-	if (canceled != 0)
-		io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	if (canceled != 0)
-		io_cqring_ev_posted(ctx);
-	return canceled != 0;
-}
-
-static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
-{
-	unsigned long index;
-	struct creds *creds;
-
-	mutex_lock(&ctx->uring_lock);
-	percpu_ref_kill(&ctx->refs);
-	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true);
-	xa_for_each(&ctx->personalities, index, creds)
-		io_unregister_personality(ctx, index);
-	mutex_unlock(&ctx->uring_lock);
-
-	io_kill_timeouts(ctx, NULL, true);
-	io_poll_remove_all(ctx, NULL, true);
-
-	/* if we failed setting up the ctx, we might not have any rings */
-	io_iopoll_try_reap_events(ctx);
-
-	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
-	/*
-	 * Use system_unbound_wq to avoid spawning tons of event kworkers
-	 * if we're exiting a ton of rings at the same time. It just adds
-	 * noise and overhead, there's no discernable change in runtime
-	 * over using system_wq.
-	 */
-	queue_work(system_unbound_wq, &ctx->exit_work);
-}
-
-static int io_uring_release(struct inode *inode, struct file *file)
-{
-	struct io_ring_ctx *ctx = file->private_data;
-
-	file->private_data = NULL;
-	io_ring_ctx_wait_and_kill(ctx);
-	return 0;
-}
-
-struct io_task_cancel {
-	struct task_struct *task;
-	bool all;
-};
-
-static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_task_cancel *cancel = data;
-
-	return io_match_task_safe(req, cancel->task, cancel->all);
-}
-
-static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task, bool cancel_all)
-{
-	struct io_defer_entry *de;
-	LIST_HEAD(list);
-
-	spin_lock(&ctx->completion_lock);
-	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task_safe(de->req, task, cancel_all)) {
-			list_cut_position(&list, &ctx->defer_list, &de->list);
-			break;
-		}
-	}
-	spin_unlock(&ctx->completion_lock);
-	if (list_empty(&list))
-		return false;
-
-	while (!list_empty(&list)) {
-		de = list_first_entry(&list, struct io_defer_entry, list);
-		list_del_init(&de->list);
-		io_req_complete_failed(de->req, -ECANCELED);
-		kfree(de);
-	}
-	return true;
-}
-
-static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
-{
-	struct io_tctx_node *node;
-	enum io_wq_cancel cret;
-	bool ret = false;
-
-	mutex_lock(&ctx->uring_lock);
-	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
-		struct io_uring_task *tctx = node->task->io_uring;
-
-		/*
-		 * io_wq will stay alive while we hold uring_lock, because it's
-		 * killed after ctx nodes, which requires to take the lock.
-		 */
-		if (!tctx || !tctx->io_wq)
-			continue;
-		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
-		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-	}
-	mutex_unlock(&ctx->uring_lock);
-
-	return ret;
-}
-
-static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
-					 struct task_struct *task,
-					 bool cancel_all)
-{
-	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
-	struct io_uring_task *tctx = task ? task->io_uring : NULL;
-
-	while (1) {
-		enum io_wq_cancel cret;
-		bool ret = false;
-
-		if (!task) {
-			ret |= io_uring_try_cancel_iowq(ctx);
-		} else if (tctx && tctx->io_wq) {
-			/*
-			 * Cancels requests of all rings, not only @ctx, but
-			 * it's fine as the task is in exit/exec.
-			 */
-			cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
-					       &cancel, true);
-			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-		}
-
-		/* SQPOLL thread does its own polling */
-		if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
-		    (ctx->sq_data && ctx->sq_data->thread == current)) {
-			while (!list_empty_careful(&ctx->iopoll_list)) {
-				io_iopoll_try_reap_events(ctx);
-				ret = true;
-			}
-		}
-
-		ret |= io_cancel_defer_files(ctx, task, cancel_all);
-		ret |= io_poll_remove_all(ctx, task, cancel_all);
-		ret |= io_kill_timeouts(ctx, task, cancel_all);
-		if (task)
-			ret |= io_run_task_work();
-		if (!ret)
-			break;
-		cond_resched();
-	}
-}
-
-static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_tctx_node *node;
-	int ret;
-
-	if (unlikely(!tctx)) {
-		ret = io_uring_alloc_task_context(current, ctx);
-		if (unlikely(ret))
-			return ret;
-
-		tctx = current->io_uring;
-		if (ctx->iowq_limits_set) {
-			unsigned int limits[2] = { ctx->iowq_limits[0],
-						   ctx->iowq_limits[1], };
-
-			ret = io_wq_max_workers(tctx->io_wq, limits);
-			if (ret)
-				return ret;
-		}
-	}
-	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
-		node = kmalloc(sizeof(*node), GFP_KERNEL);
-		if (!node)
-			return -ENOMEM;
-		node->ctx = ctx;
-		node->task = current;
-
-		ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
-					node, GFP_KERNEL));
-		if (ret) {
-			kfree(node);
-			return ret;
-		}
-
-		mutex_lock(&ctx->uring_lock);
-		list_add(&node->ctx_node, &ctx->tctx_list);
-		mutex_unlock(&ctx->uring_lock);
-	}
-	tctx->last = ctx;
-	return 0;
-}
-
-/*
- * Note that this task has used io_uring. We use it for cancelation purposes.
- */
-static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
-{
-	struct io_uring_task *tctx = current->io_uring;
-
-	if (likely(tctx && tctx->last == ctx))
-		return 0;
-	return __io_uring_add_tctx_node(ctx);
-}
-
-/*
- * Remove this io_uring_file -> task mapping.
- */
-static void io_uring_del_tctx_node(unsigned long index)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_tctx_node *node;
-
-	if (!tctx)
-		return;
-	node = xa_erase(&tctx->xa, index);
-	if (!node)
-		return;
-
-	WARN_ON_ONCE(current != node->task);
-	WARN_ON_ONCE(list_empty(&node->ctx_node));
-
-	mutex_lock(&node->ctx->uring_lock);
-	list_del(&node->ctx_node);
-	mutex_unlock(&node->ctx->uring_lock);
-
-	if (tctx->last == node->ctx)
-		tctx->last = NULL;
-	kfree(node);
-}
-
-static void io_uring_clean_tctx(struct io_uring_task *tctx)
-{
-	struct io_wq *wq = tctx->io_wq;
-	struct io_tctx_node *node;
-	unsigned long index;
-
-	xa_for_each(&tctx->xa, index, node) {
-		io_uring_del_tctx_node(index);
-		cond_resched();
-	}
-	if (wq) {
-		/*
-		 * Must be after io_uring_del_task_file() (removes nodes under
-		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
-		 */
-		io_wq_put_and_exit(wq);
-		tctx->io_wq = NULL;
-	}
-}
-
-static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
-{
-	if (tracked)
-		return atomic_read(&tctx->inflight_tracked);
-	return percpu_counter_sum(&tctx->inflight);
-}
-
-/*
- * Find any io_uring ctx that this task has registered or done IO on, and cancel
- * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
- */
-static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_ring_ctx *ctx;
-	s64 inflight;
-	DEFINE_WAIT(wait);
-
-	WARN_ON_ONCE(sqd && sqd->thread != current);
-
-	if (!current->io_uring)
-		return;
-	if (tctx->io_wq)
-		io_wq_exit_start(tctx->io_wq);
-
-	atomic_inc(&tctx->in_idle);
-	do {
-		io_uring_drop_tctx_refs(current);
-		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, !cancel_all);
-		if (!inflight)
-			break;
-
-		if (!sqd) {
-			struct io_tctx_node *node;
-			unsigned long index;
-
-			xa_for_each(&tctx->xa, index, node) {
-				/* sqpoll task will cancel all its requests */
-				if (node->ctx->sq_data)
-					continue;
-				io_uring_try_cancel_requests(node->ctx, current,
-							     cancel_all);
-			}
-		} else {
-			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_uring_try_cancel_requests(ctx, current,
-							     cancel_all);
-		}
-
-		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
-		io_run_task_work();
-		io_uring_drop_tctx_refs(current);
-
-		/*
-		 * If we've seen completions, retry without waiting. This
-		 * avoids a race where a completion comes in before we did
-		 * prepare_to_wait().
-		 */
-		if (inflight == tctx_inflight(tctx, !cancel_all))
-			schedule();
-		finish_wait(&tctx->wait, &wait);
-	} while (1);
-
-	io_uring_clean_tctx(tctx);
-	if (cancel_all) {
-		/*
-		 * We shouldn't run task_works after cancel, so just leave
-		 * ->in_idle set for normal exit.
-		 */
-		atomic_dec(&tctx->in_idle);
-		/* for exec all current's requests should be gone, kill tctx */
-		__io_uring_free(current);
-	}
-}
-
-void __io_uring_cancel(bool cancel_all)
-{
-	io_uring_cancel_generic(cancel_all, NULL);
-}
-
-static void *io_uring_validate_mmap_request(struct file *file,
-					    loff_t pgoff, size_t sz)
-{
-	struct io_ring_ctx *ctx = file->private_data;
-	loff_t offset = pgoff << PAGE_SHIFT;
-	struct page *page;
-	void *ptr;
-
-	switch (offset) {
-	case IORING_OFF_SQ_RING:
-	case IORING_OFF_CQ_RING:
-		ptr = ctx->rings;
-		break;
-	case IORING_OFF_SQES:
-		ptr = ctx->sq_sqes;
-		break;
-	default:
-		return ERR_PTR(-EINVAL);
-	}
-
-	page = virt_to_head_page(ptr);
-	if (sz > page_size(page))
-		return ERR_PTR(-EINVAL);
-
-	return ptr;
-}
-
-#ifdef CONFIG_MMU
-
-static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	size_t sz = vma->vm_end - vma->vm_start;
-	unsigned long pfn;
-	void *ptr;
-
-	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-
-	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
-	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
-}
-
-#else /* !CONFIG_MMU */
-
-static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -EINVAL;
-}
-
-static unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
-{
-	return NOMMU_MAP_DIRECT | NOMMU_MAP_READ | NOMMU_MAP_WRITE;
-}
-
-static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
-	unsigned long addr, unsigned long len,
-	unsigned long pgoff, unsigned long flags)
-{
-	void *ptr;
-
-	ptr = io_uring_validate_mmap_request(file, pgoff, len);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-
-	return (unsigned long) ptr;
-}
-
-#endif /* !CONFIG_MMU */
-
-static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
-{
-	DEFINE_WAIT(wait);
-
-	do {
-		if (!io_sqring_full(ctx))
-			break;
-		prepare_to_wait(&ctx->sqo_sq_wait, &wait, TASK_INTERRUPTIBLE);
-
-		if (!io_sqring_full(ctx))
-			break;
-		schedule();
-	} while (!signal_pending(current));
-
-	finish_wait(&ctx->sqo_sq_wait, &wait);
-	return 0;
-}
-
-static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
-			  struct __kernel_timespec __user **ts,
-			  const sigset_t __user **sig)
-{
-	struct io_uring_getevents_arg arg;
-
-	/*
-	 * If EXT_ARG isn't set, then we have no timespec and the argp pointer
-	 * is just a pointer to the sigset_t.
-	 */
-	if (!(flags & IORING_ENTER_EXT_ARG)) {
-		*sig = (const sigset_t __user *) argp;
-		*ts = NULL;
-		return 0;
-	}
-
-	/*
-	 * EXT_ARG is set - ensure we agree on the size of it and copy in our
-	 * timespec and sigset_t pointers if good.
-	 */
-	if (*argsz != sizeof(arg))
-		return -EINVAL;
-	if (copy_from_user(&arg, argp, sizeof(arg)))
-		return -EFAULT;
-	if (arg.pad)
-		return -EINVAL;
-	*sig = u64_to_user_ptr(arg.sigmask);
-	*argsz = arg.sigmask_sz;
-	*ts = u64_to_user_ptr(arg.ts);
-	return 0;
-}
-
-SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
-		u32, min_complete, u32, flags, const void __user *, argp,
-		size_t, argsz)
-{
-	struct io_ring_ctx *ctx;
-	int submitted = 0;
-	struct fd f;
-	long ret;
-
-	io_run_task_work();
-
-	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
-		return -EINVAL;
-
-	f = fdget(fd);
-	if (unlikely(!f.file))
-		return -EBADF;
-
-	ret = -EOPNOTSUPP;
-	if (unlikely(f.file->f_op != &io_uring_fops))
-		goto out_fput;
-
-	ret = -ENXIO;
-	ctx = f.file->private_data;
-	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
-		goto out_fput;
-
-	ret = -EBADFD;
-	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
-		goto out;
-
-	/*
-	 * For SQ polling, the thread will do all submissions and completions.
-	 * Just return the requested submit count, and wake the thread if
-	 * we were asked to.
-	 */
-	ret = 0;
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx);
-
-		if (unlikely(ctx->sq_data->thread == NULL)) {
-			ret = -EOWNERDEAD;
-			goto out;
-		}
-		if (flags & IORING_ENTER_SQ_WAKEUP)
-			wake_up(&ctx->sq_data->wait);
-		if (flags & IORING_ENTER_SQ_WAIT) {
-			ret = io_sqpoll_wait_sq(ctx);
-			if (ret)
-				goto out;
-		}
-		submitted = to_submit;
-	} else if (to_submit) {
-		ret = io_uring_add_tctx_node(ctx);
-		if (unlikely(ret))
-			goto out;
-		mutex_lock(&ctx->uring_lock);
-		submitted = io_submit_sqes(ctx, to_submit);
-		mutex_unlock(&ctx->uring_lock);
-
-		if (submitted != to_submit)
-			goto out;
-	}
-	if (flags & IORING_ENTER_GETEVENTS) {
-		const sigset_t __user *sig;
-		struct __kernel_timespec __user *ts;
-
-		ret = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
-		if (unlikely(ret))
-			goto out;
-
-		min_complete = min(min_complete, ctx->cq_entries);
-
-		/*
-		 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
-		 * space applications don't need to do io completion events
-		 * polling again, they can rely on io_sq_thread to do polling
-		 * work, which can reduce cpu usage and uring_lock contention.
-		 */
-		if (ctx->flags & IORING_SETUP_IOPOLL &&
-		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
-			ret = io_iopoll_check(ctx, min_complete);
-		} else {
-			ret = io_cqring_wait(ctx, min_complete, sig, argsz, ts);
-		}
-	}
-
-out:
-	percpu_ref_put(&ctx->refs);
-out_fput:
-	fdput(f);
-	return submitted ? submitted : ret;
-}
-
-#ifdef CONFIG_PROC_FS
-static int io_uring_show_cred(struct seq_file *m, unsigned int id,
-		const struct cred *cred)
-{
-	struct user_namespace *uns = seq_user_ns(m);
-	struct group_info *gi;
-	kernel_cap_t cap;
-	unsigned __capi;
-	int g;
-
-	seq_printf(m, "%5d\n", id);
-	seq_put_decimal_ull(m, "\tUid:\t", from_kuid_munged(uns, cred->uid));
-	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->euid));
-	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->suid));
-	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->fsuid));
-	seq_put_decimal_ull(m, "\n\tGid:\t", from_kgid_munged(uns, cred->gid));
-	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->egid));
-	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->sgid));
-	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->fsgid));
-	seq_puts(m, "\n\tGroups:\t");
-	gi = cred->group_info;
-	for (g = 0; g < gi->ngroups; g++) {
-		seq_put_decimal_ull(m, g ? " " : "",
-					from_kgid_munged(uns, gi->gid[g]));
-	}
-	seq_puts(m, "\n\tCapEff:\t");
-	cap = cred->cap_effective;
-	CAP_FOR_EACH_U32(__capi)
-		seq_put_hex_ll(m, NULL, cap.cap[CAP_LAST_U32 - __capi], 8);
-	seq_putc(m, '\n');
-	return 0;
-}
-
-static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
-{
-	struct io_sq_data *sq = NULL;
-	bool has_lock;
-	int i;
-
-	/*
-	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
-	 * since fdinfo case grabs it in the opposite direction of normal use
-	 * cases. If we fail to get the lock, we just don't iterate any
-	 * structures that could be going away outside the io_uring mutex.
-	 */
-	has_lock = mutex_trylock(&ctx->uring_lock);
-
-	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
-		sq = ctx->sq_data;
-		if (!sq->thread)
-			sq = NULL;
-	}
-
-	seq_printf(m, "SqThread:\t%d\n", sq ? task_pid_nr(sq->thread) : -1);
-	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
-	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
-	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
-		struct file *f = io_file_from_index(ctx, i);
-
-		if (f)
-			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
-		else
-			seq_printf(m, "%5u: <none>\n", i);
-	}
-	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
-	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = ctx->user_bufs[i];
-		unsigned int len = buf->ubuf_end - buf->ubuf;
-
-		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, len);
-	}
-	if (has_lock && !xa_empty(&ctx->personalities)) {
-		unsigned long index;
-		const struct cred *cred;
-
-		seq_printf(m, "Personalities:\n");
-		xa_for_each(&ctx->personalities, index, cred)
-			io_uring_show_cred(m, index, cred);
-	}
-	seq_printf(m, "PollList:\n");
-	spin_lock(&ctx->completion_lock);
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list = &ctx->cancel_hash[i];
-		struct io_kiocb *req;
-
-		hlist_for_each_entry(req, list, hash_node)
-			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
-					req->task->task_works != NULL);
-	}
-	spin_unlock(&ctx->completion_lock);
-	if (has_lock)
-		mutex_unlock(&ctx->uring_lock);
-}
-
-static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
-{
-	struct io_ring_ctx *ctx = f->private_data;
-
-	if (percpu_ref_tryget(&ctx->refs)) {
-		__io_uring_show_fdinfo(ctx, m);
-		percpu_ref_put(&ctx->refs);
-	}
-}
-#endif
-
-static const struct file_operations io_uring_fops = {
-	.release	= io_uring_release,
-	.mmap		= io_uring_mmap,
-#ifndef CONFIG_MMU
-	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
-	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
-#endif
-	.poll		= io_uring_poll,
-#ifdef CONFIG_PROC_FS
-	.show_fdinfo	= io_uring_show_fdinfo,
-#endif
-};
-
-static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
-				  struct io_uring_params *p)
-{
-	struct io_rings *rings;
-	size_t size, sq_array_offset;
-
-	/* make sure these are sane, as we already accounted them */
-	ctx->sq_entries = p->sq_entries;
-	ctx->cq_entries = p->cq_entries;
-
-	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
-
-	rings = io_mem_alloc(size);
-	if (!rings)
-		return -ENOMEM;
-
-	ctx->rings = rings;
-	ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
-	rings->sq_ring_mask = p->sq_entries - 1;
-	rings->cq_ring_mask = p->cq_entries - 1;
-	rings->sq_ring_entries = p->sq_entries;
-	rings->cq_ring_entries = p->cq_entries;
-
-	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
-	if (size == SIZE_MAX) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
-		return -EOVERFLOW;
-	}
-
-	ctx->sq_sqes = io_mem_alloc(size);
-	if (!ctx->sq_sqes) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
-{
-	int ret, fd;
-
-	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
-	if (fd < 0)
-		return fd;
-
-	ret = io_uring_add_tctx_node(ctx);
-	if (ret) {
-		put_unused_fd(fd);
-		return ret;
-	}
-	fd_install(fd, file);
-	return fd;
-}
-
-/*
- * Allocate an anonymous fd, this is what constitutes the application
- * visible backing of an io_uring instance. The application mmaps this
- * fd to gain access to the SQ/CQ ring details. If UNIX sockets are enabled,
- * we have to tie this fd to a socket for file garbage collection purposes.
- */
-static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
-{
-	struct file *file;
-#if defined(CONFIG_UNIX)
-	int ret;
-
-	ret = sock_create_kern(&init_net, PF_UNIX, SOCK_RAW, IPPROTO_IP,
-				&ctx->ring_sock);
-	if (ret)
-		return ERR_PTR(ret);
-#endif
-
-	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
-					O_RDWR | O_CLOEXEC);
-#if defined(CONFIG_UNIX)
-	if (IS_ERR(file)) {
-		sock_release(ctx->ring_sock);
-		ctx->ring_sock = NULL;
-	} else {
-		ctx->ring_sock->file = file;
-	}
-#endif
-	return file;
-}
-
-static int io_uring_create(unsigned entries, struct io_uring_params *p,
-			   struct io_uring_params __user *params)
-{
-	struct io_ring_ctx *ctx;
-	struct file *file;
-	int ret;
-
-	if (!entries)
-		return -EINVAL;
-	if (entries > IORING_MAX_ENTRIES) {
-		if (!(p->flags & IORING_SETUP_CLAMP))
-			return -EINVAL;
-		entries = IORING_MAX_ENTRIES;
-	}
-
-	/*
-	 * Use twice as many entries for the CQ ring. It's possible for the
-	 * application to drive a higher depth than the size of the SQ ring,
-	 * since the sqes are only used at submission time. This allows for
-	 * some flexibility in overcommitting a bit. If the application has
-	 * set IORING_SETUP_CQSIZE, it will have passed in the desired number
-	 * of CQ ring entries manually.
-	 */
-	p->sq_entries = roundup_pow_of_two(entries);
-	if (p->flags & IORING_SETUP_CQSIZE) {
-		/*
-		 * If IORING_SETUP_CQSIZE is set, we do the same roundup
-		 * to a power-of-two, if it isn't already. We do NOT impose
-		 * any cq vs sq ring sizing.
-		 */
-		if (!p->cq_entries)
-			return -EINVAL;
-		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
-			if (!(p->flags & IORING_SETUP_CLAMP))
-				return -EINVAL;
-			p->cq_entries = IORING_MAX_CQ_ENTRIES;
-		}
-		p->cq_entries = roundup_pow_of_two(p->cq_entries);
-		if (p->cq_entries < p->sq_entries)
-			return -EINVAL;
-	} else {
-		p->cq_entries = 2 * p->sq_entries;
-	}
-
-	ctx = io_ring_ctx_alloc(p);
-	if (!ctx)
-		return -ENOMEM;
-	ctx->compat = in_compat_syscall();
-	if (!capable(CAP_IPC_LOCK))
-		ctx->user = get_uid(current_user());
-
-	/*
-	 * This is just grabbed for accounting purposes. When a process exits,
-	 * the mm is exited and dropped before the files, hence we need to hang
-	 * on to this mm purely for the purposes of being able to unaccount
-	 * memory (locked/pinned vm). It's not used for anything else.
-	 */
-	mmgrab(current->mm);
-	ctx->mm_account = current->mm;
-
-	ret = io_allocate_scq_urings(ctx, p);
-	if (ret)
-		goto err;
-
-	ret = io_sq_offload_create(ctx, p);
-	if (ret)
-		goto err;
-	/* always set a rsrc node */
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		goto err;
-	io_rsrc_node_switch(ctx, NULL);
-
-	memset(&p->sq_off, 0, sizeof(p->sq_off));
-	p->sq_off.head = offsetof(struct io_rings, sq.head);
-	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
-	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
-	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
-	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
-	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
-	p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
-
-	memset(&p->cq_off, 0, sizeof(p->cq_off));
-	p->cq_off.head = offsetof(struct io_rings, cq.head);
-	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
-	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
-	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
-	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
-	p->cq_off.cqes = offsetof(struct io_rings, cqes);
-	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
-
-	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
-			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
-			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
-			IORING_FEAT_RSRC_TAGS;
-
-	if (copy_to_user(params, p, sizeof(*p))) {
-		ret = -EFAULT;
-		goto err;
-	}
-
-	file = io_uring_get_file(ctx);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
-		goto err;
-	}
-
-	/*
-	 * Install ring fd as the very last thing, so we don't risk someone
-	 * having closed it before we finish setup
-	 */
-	ret = io_uring_install_fd(ctx, file);
-	if (ret < 0) {
-		/* fput will clean it up */
-		fput(file);
-		return ret;
-	}
-
-	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-	return ret;
-err:
-	io_ring_ctx_wait_and_kill(ctx);
-	return ret;
-}
-
-/*
- * Sets up an aio uring context, and returns the fd. Applications asks for a
- * ring size, we return the actual sq/cq ring sizes (among other things) in the
- * params structure passed in.
- */
-static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
-{
-	struct io_uring_params p;
-	int i;
-
-	if (copy_from_user(&p, params, sizeof(p)))
-		return -EFAULT;
-	for (i = 0; i < ARRAY_SIZE(p.resv); i++) {
-		if (p.resv[i])
-			return -EINVAL;
-	}
-
-	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
-			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
-		return -EINVAL;
-
-	return  io_uring_create(entries, &p, params);
-}
-
-SYSCALL_DEFINE2(io_uring_setup, u32, entries,
-		struct io_uring_params __user *, params)
-{
-	return io_uring_setup(entries, params);
-}
-
-static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
-{
-	struct io_uring_probe *p;
-	size_t size;
-	int i, ret;
-
-	size = struct_size(p, ops, nr_args);
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
-	p = kzalloc(size, GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	ret = -EFAULT;
-	if (copy_from_user(p, arg, size))
-		goto out;
-	ret = -EINVAL;
-	if (memchr_inv(p, 0, size))
-		goto out;
-
-	p->last_op = IORING_OP_LAST - 1;
-	if (nr_args > IORING_OP_LAST)
-		nr_args = IORING_OP_LAST;
-
-	for (i = 0; i < nr_args; i++) {
-		p->ops[i].op = i;
-		if (!io_op_defs[i].not_supported)
-			p->ops[i].flags = IO_URING_OP_SUPPORTED;
-	}
-	p->ops_len = i;
-
-	ret = 0;
-	if (copy_to_user(arg, p, size))
-		ret = -EFAULT;
-out:
-	kfree(p);
-	return ret;
-}
-
-static int io_register_personality(struct io_ring_ctx *ctx)
-{
-	const struct cred *creds;
-	u32 id;
-	int ret;
-
-	creds = get_current_cred();
-
-	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
-			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (ret < 0) {
-		put_cred(creds);
-		return ret;
-	}
-	return id;
-}
-
-static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
-				    unsigned int nr_args)
-{
-	struct io_uring_restriction *res;
-	size_t size;
-	int i, ret;
-
-	/* Restrictions allowed only if rings started disabled */
-	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
-		return -EBADFD;
-
-	/* We allow only a single restrictions registration */
-	if (ctx->restrictions.registered)
-		return -EBUSY;
-
-	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
-		return -EINVAL;
-
-	size = array_size(nr_args, sizeof(*res));
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
-
-	res = memdup_user(arg, size);
-	if (IS_ERR(res))
-		return PTR_ERR(res);
-
-	ret = 0;
-
-	for (i = 0; i < nr_args; i++) {
-		switch (res[i].opcode) {
-		case IORING_RESTRICTION_REGISTER_OP:
-			if (res[i].register_op >= IORING_REGISTER_LAST) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			__set_bit(res[i].register_op,
-				  ctx->restrictions.register_op);
-			break;
-		case IORING_RESTRICTION_SQE_OP:
-			if (res[i].sqe_op >= IORING_OP_LAST) {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
-			break;
-		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
-			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
-			break;
-		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
-			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
-			break;
-		default:
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-out:
-	/* Reset all restrictions if an error happened */
-	if (ret != 0)
-		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
-	else
-		ctx->restrictions.registered = true;
-
-	kfree(res);
-	return ret;
-}
-
-static int io_register_enable_rings(struct io_ring_ctx *ctx)
-{
-	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
-		return -EBADFD;
-
-	if (ctx->restrictions.registered)
-		ctx->restricted = 1;
-
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
-	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
-		wake_up(&ctx->sq_data->wait);
-	return 0;
-}
-
-static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
-				     struct io_uring_rsrc_update2 *up,
-				     unsigned nr_args)
-{
-	__u32 tmp;
-	int err;
-
-	if (check_add_overflow(up->offset, nr_args, &tmp))
-		return -EOVERFLOW;
-	err = io_rsrc_node_switch_start(ctx);
-	if (err)
-		return err;
-
-	switch (type) {
-	case IORING_RSRC_FILE:
-		return __io_sqe_files_update(ctx, up, nr_args);
-	case IORING_RSRC_BUFFER:
-		return __io_sqe_buffers_update(ctx, up, nr_args);
-	}
-	return -EINVAL;
-}
-
-static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
-				    unsigned nr_args)
-{
-	struct io_uring_rsrc_update2 up;
-
-	if (!nr_args)
-		return -EINVAL;
-	memset(&up, 0, sizeof(up));
-	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
-		return -EFAULT;
-	if (up.resv || up.resv2)
-		return -EINVAL;
-	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
-}
-
-static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
-				   unsigned size, unsigned type)
-{
-	struct io_uring_rsrc_update2 up;
-
-	if (size != sizeof(up))
-		return -EINVAL;
-	if (copy_from_user(&up, arg, sizeof(up)))
-		return -EFAULT;
-	if (!up.nr || up.resv || up.resv2)
-		return -EINVAL;
-	return __io_register_rsrc_update(ctx, type, &up, up.nr);
-}
-
-static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
-			    unsigned int size, unsigned int type)
-{
-	struct io_uring_rsrc_register rr;
-
-	/* keep it extendible */
-	if (size != sizeof(rr))
-		return -EINVAL;
-
-	memset(&rr, 0, sizeof(rr));
-	if (copy_from_user(&rr, arg, size))
-		return -EFAULT;
-	if (!rr.nr || rr.resv || rr.resv2)
-		return -EINVAL;
-
-	switch (type) {
-	case IORING_RSRC_FILE:
-		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
-					     rr.nr, u64_to_user_ptr(rr.tags));
-	case IORING_RSRC_BUFFER:
-		return io_sqe_buffers_register(ctx, u64_to_user_ptr(rr.data),
-					       rr.nr, u64_to_user_ptr(rr.tags));
-	}
-	return -EINVAL;
-}
-
-static int io_register_iowq_aff(struct io_ring_ctx *ctx, void __user *arg,
-				unsigned len)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	cpumask_var_t new_mask;
-	int ret;
-
-	if (!tctx || !tctx->io_wq)
-		return -EINVAL;
-
-	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_clear(new_mask);
-	if (len > cpumask_size())
-		len = cpumask_size();
-
-	if (in_compat_syscall()) {
-		ret = compat_get_bitmap(cpumask_bits(new_mask),
-					(const compat_ulong_t __user *)arg,
-					len * 8 /* CHAR_BIT */);
-	} else {
-		ret = copy_from_user(new_mask, arg, len);
-	}
-
-	if (ret) {
-		free_cpumask_var(new_mask);
-		return -EFAULT;
-	}
-
-	ret = io_wq_cpu_affinity(tctx->io_wq, new_mask);
-	free_cpumask_var(new_mask);
-	return ret;
-}
-
-static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
-{
-	struct io_uring_task *tctx = current->io_uring;
-
-	if (!tctx || !tctx->io_wq)
-		return -EINVAL;
-
-	return io_wq_cpu_affinity(tctx->io_wq, NULL);
-}
-
-static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
-					void __user *arg)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_tctx_node *node;
-	struct io_uring_task *tctx = NULL;
-	struct io_sq_data *sqd = NULL;
-	__u32 new_count[2];
-	int i, ret;
-
-	if (copy_from_user(new_count, arg, sizeof(new_count)))
-		return -EFAULT;
-	for (i = 0; i < ARRAY_SIZE(new_count); i++)
-		if (new_count[i] > INT_MAX)
-			return -EINVAL;
-
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		sqd = ctx->sq_data;
-		if (sqd) {
-			/*
-			 * Observe the correct sqd->lock -> ctx->uring_lock
-			 * ordering. Fine to drop uring_lock here, we hold
-			 * a ref to the ctx.
-			 */
-			refcount_inc(&sqd->refs);
-			mutex_unlock(&ctx->uring_lock);
-			mutex_lock(&sqd->lock);
-			mutex_lock(&ctx->uring_lock);
-			if (sqd->thread)
-				tctx = sqd->thread->io_uring;
-		}
-	} else {
-		tctx = current->io_uring;
-	}
-
-	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
-
-	for (i = 0; i < ARRAY_SIZE(new_count); i++)
-		if (new_count[i])
-			ctx->iowq_limits[i] = new_count[i];
-	ctx->iowq_limits_set = true;
-
-	ret = -EINVAL;
-	if (tctx && tctx->io_wq) {
-		ret = io_wq_max_workers(tctx->io_wq, new_count);
-		if (ret)
-			goto err;
-	} else {
-		memset(new_count, 0, sizeof(new_count));
-	}
-
-	if (sqd) {
-		mutex_unlock(&sqd->lock);
-		io_put_sq_data(sqd);
-	}
-
-	if (copy_to_user(arg, new_count, sizeof(new_count)))
-		return -EFAULT;
-
-	/* that's it for SQPOLL, only the SQPOLL task creates requests */
-	if (sqd)
-		return 0;
-
-	/* now propagate the restriction to all registered users */
-	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
-		struct io_uring_task *tctx = node->task->io_uring;
-
-		if (WARN_ON_ONCE(!tctx->io_wq))
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(new_count); i++)
-			new_count[i] = ctx->iowq_limits[i];
-		/* ignore errors, it always returns zero anyway */
-		(void)io_wq_max_workers(tctx->io_wq, new_count);
-	}
-	return 0;
-err:
-	if (sqd) {
-		mutex_unlock(&sqd->lock);
-		io_put_sq_data(sqd);
-	}
-	return ret;
-}
-
-static bool io_register_op_must_quiesce(int op)
-{
-	switch (op) {
-	case IORING_REGISTER_BUFFERS:
-	case IORING_UNREGISTER_BUFFERS:
-	case IORING_REGISTER_FILES:
-	case IORING_UNREGISTER_FILES:
-	case IORING_REGISTER_FILES_UPDATE:
-	case IORING_REGISTER_PROBE:
-	case IORING_REGISTER_PERSONALITY:
-	case IORING_UNREGISTER_PERSONALITY:
-	case IORING_REGISTER_FILES2:
-	case IORING_REGISTER_FILES_UPDATE2:
-	case IORING_REGISTER_BUFFERS2:
-	case IORING_REGISTER_BUFFERS_UPDATE:
-	case IORING_REGISTER_IOWQ_AFF:
-	case IORING_UNREGISTER_IOWQ_AFF:
-	case IORING_REGISTER_IOWQ_MAX_WORKERS:
-		return false;
-	default:
-		return true;
-	}
-}
-
-static int io_ctx_quiesce(struct io_ring_ctx *ctx)
-{
-	long ret;
-
-	percpu_ref_kill(&ctx->refs);
-
-	/*
-	 * Drop uring mutex before waiting for references to exit. If another
-	 * thread is currently inside io_uring_enter() it might need to grab the
-	 * uring_lock to make progress. If we hold it here across the drain
-	 * wait, then we can deadlock. It's safe to drop the mutex here, since
-	 * no new references will come in after we've killed the percpu ref.
-	 */
-	mutex_unlock(&ctx->uring_lock);
-	do {
-		ret = wait_for_completion_interruptible(&ctx->ref_comp);
-		if (!ret)
-			break;
-		ret = io_run_task_work_sig();
-	} while (ret >= 0);
-	mutex_lock(&ctx->uring_lock);
-
-	if (ret)
-		io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
-	return ret;
-}
-
-static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
-			       void __user *arg, unsigned nr_args)
-	__releases(ctx->uring_lock)
-	__acquires(ctx->uring_lock)
-{
-	int ret;
-
-	/*
-	 * We're inside the ring mutex, if the ref is already dying, then
-	 * someone else killed the ctx or is already going through
-	 * io_uring_register().
-	 */
-	if (percpu_ref_is_dying(&ctx->refs))
-		return -ENXIO;
-
-	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST)
-			return -EINVAL;
-		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
-		if (!test_bit(opcode, ctx->restrictions.register_op))
-			return -EACCES;
-	}
-
-	if (io_register_op_must_quiesce(opcode)) {
-		ret = io_ctx_quiesce(ctx);
-		if (ret)
-			return ret;
-	}
-
-	switch (opcode) {
-	case IORING_REGISTER_BUFFERS:
-		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
-		break;
-	case IORING_UNREGISTER_BUFFERS:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_sqe_buffers_unregister(ctx);
-		break;
-	case IORING_REGISTER_FILES:
-		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
-		break;
-	case IORING_UNREGISTER_FILES:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_sqe_files_unregister(ctx);
-		break;
-	case IORING_REGISTER_FILES_UPDATE:
-		ret = io_register_files_update(ctx, arg, nr_args);
-		break;
-	case IORING_REGISTER_EVENTFD:
-	case IORING_REGISTER_EVENTFD_ASYNC:
-		ret = -EINVAL;
-		if (nr_args != 1)
-			break;
-		ret = io_eventfd_register(ctx, arg);
-		if (ret)
-			break;
-		if (opcode == IORING_REGISTER_EVENTFD_ASYNC)
-			ctx->eventfd_async = 1;
-		else
-			ctx->eventfd_async = 0;
-		break;
-	case IORING_UNREGISTER_EVENTFD:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_eventfd_unregister(ctx);
-		break;
-	case IORING_REGISTER_PROBE:
-		ret = -EINVAL;
-		if (!arg || nr_args > 256)
-			break;
-		ret = io_probe(ctx, arg, nr_args);
-		break;
-	case IORING_REGISTER_PERSONALITY:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_register_personality(ctx);
-		break;
-	case IORING_UNREGISTER_PERSONALITY:
-		ret = -EINVAL;
-		if (arg)
-			break;
-		ret = io_unregister_personality(ctx, nr_args);
-		break;
-	case IORING_REGISTER_ENABLE_RINGS:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_register_enable_rings(ctx);
-		break;
-	case IORING_REGISTER_RESTRICTIONS:
-		ret = io_register_restrictions(ctx, arg, nr_args);
-		break;
-	case IORING_REGISTER_FILES2:
-		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_FILE);
-		break;
-	case IORING_REGISTER_FILES_UPDATE2:
-		ret = io_register_rsrc_update(ctx, arg, nr_args,
-					      IORING_RSRC_FILE);
-		break;
-	case IORING_REGISTER_BUFFERS2:
-		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_BUFFER);
-		break;
-	case IORING_REGISTER_BUFFERS_UPDATE:
-		ret = io_register_rsrc_update(ctx, arg, nr_args,
-					      IORING_RSRC_BUFFER);
-		break;
-	case IORING_REGISTER_IOWQ_AFF:
-		ret = -EINVAL;
-		if (!arg || !nr_args)
-			break;
-		ret = io_register_iowq_aff(ctx, arg, nr_args);
-		break;
-	case IORING_UNREGISTER_IOWQ_AFF:
-		ret = -EINVAL;
-		if (arg || nr_args)
-			break;
-		ret = io_unregister_iowq_aff(ctx);
-		break;
-	case IORING_REGISTER_IOWQ_MAX_WORKERS:
-		ret = -EINVAL;
-		if (!arg || nr_args != 2)
-			break;
-		ret = io_register_iowq_max_workers(ctx, arg);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	if (io_register_op_must_quiesce(opcode)) {
-		/* bring the ctx back to life */
-		percpu_ref_reinit(&ctx->refs);
-		reinit_completion(&ctx->ref_comp);
-	}
-	return ret;
-}
-
-SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
-		void __user *, arg, unsigned int, nr_args)
-{
-	struct io_ring_ctx *ctx;
-	long ret = -EBADF;
-	struct fd f;
-
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
-
-	ret = -EOPNOTSUPP;
-	if (f.file->f_op != &io_uring_fops)
-		goto out_fput;
-
-	ctx = f.file->private_data;
-
-	io_run_task_work();
-
-	mutex_lock(&ctx->uring_lock);
-	ret = __io_uring_register(ctx, opcode, arg, nr_args);
-	mutex_unlock(&ctx->uring_lock);
-	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs,
-							ctx->cq_ev_fd != NULL, ret);
-out_fput:
-	fdput(f);
-	return ret;
-}
-
-static int __init io_uring_init(void)
-{
-#define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
-	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
-	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
-} while (0)
-
-#define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
-	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
-	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
-	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
-	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
-	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
-	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
-	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
-	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
-	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
-	BUILD_BUG_SQE_ELEM(16, __u64,  splice_off_in);
-	BUILD_BUG_SQE_ELEM(24, __u32,  len);
-	BUILD_BUG_SQE_ELEM(28,     __kernel_rwf_t, rw_flags);
-	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
-	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
-	BUILD_BUG_SQE_ELEM(28, /* compat */ __u16,  poll_events);
-	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
-	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  accept_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  cancel_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  open_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
-	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
-	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
-	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
-	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
-	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
-	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
-	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
-
-	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
-		     sizeof(struct io_uring_rsrc_update));
-	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
-		     sizeof(struct io_uring_rsrc_update2));
-
-	/* ->buf_index is u16 */
-	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
-
-	/* should fit into one byte */
-	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
-
-	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
-	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
-
-	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT);
-	return 0;
-};
-__initcall(io_uring_init);
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 71942a1c642d..c99710b3027a 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -207,12 +207,16 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+void tlb_remove_table_sync_one(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
 #error tlb_needs_table_invalidate() requires MMU_GATHER_RCU_TABLE_FREE
 #endif
 
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 75c151413fda..45cdb12243e3 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -68,6 +68,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 266e8de3cb51..e280e0acb55c 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -458,6 +458,47 @@ int __must_check devm_clk_bulk_get_all(struct device *dev,
  */
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
+/**
+ * devm_clk_get_prepared - devm_clk_get() + clk_prepare()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  (IOW, @id may be identical strings, but
+ * clk_get may return different clock producers depending on @dev.)
+ *
+ * The returned clk (if valid) is prepared. Drivers must however assume
+ * that the clock is not enabled.
+ *
+ * The clock will automatically be unprepared and freed when the device
+ * is unbound from the bus.
+ */
+struct clk *devm_clk_get_prepared(struct device *dev, const char *id);
+
+/**
+ * devm_clk_get_enabled - devm_clk_get() + clk_prepare_enable()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  (IOW, @id may be identical strings, but
+ * clk_get may return different clock producers depending on @dev.)
+ *
+ * The returned clk (if valid) is prepared and enabled.
+ *
+ * The clock will automatically be disabled, unprepared and freed
+ * when the device is unbound from the bus.
+ */
+struct clk *devm_clk_get_enabled(struct device *dev, const char *id);
+
 /**
  * devm_clk_get_optional - lookup and obtain a managed reference to an optional
  *			   clock producer.
@@ -469,6 +510,50 @@ struct clk *devm_clk_get(struct device *dev, const char *id);
  */
 struct clk *devm_clk_get_optional(struct device *dev, const char *id);
 
+/**
+ * devm_clk_get_optional_prepared - devm_clk_get_optional() + clk_prepare()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  If no such clk is found, it returns NULL
+ * which serves as a dummy clk.  That's the only difference compared
+ * to devm_clk_get_prepared().
+ *
+ * The returned clk (if valid) is prepared. Drivers must however
+ * assume that the clock is not enabled.
+ *
+ * The clock will automatically be unprepared and freed when the
+ * device is unbound from the bus.
+ */
+struct clk *devm_clk_get_optional_prepared(struct device *dev, const char *id);
+
+/**
+ * devm_clk_get_optional_enabled - devm_clk_get_optional() +
+ *                                 clk_prepare_enable()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  If no such clk is found, it returns NULL
+ * which serves as a dummy clk.  That's the only difference compared
+ * to devm_clk_get_enabled().
+ *
+ * The returned clk (if valid) is prepared and enabled.
+ *
+ * The clock will automatically be disabled, unprepared and freed
+ * when the device is unbound from the bus.
+ */
+struct clk *devm_clk_get_optional_enabled(struct device *dev, const char *id);
+
 /**
  * devm_get_clk_from_child - lookup and obtain a managed reference to a
  *			     clock producer from child node.
@@ -813,12 +898,36 @@ static inline struct clk *devm_clk_get(struct device *dev, const char *id)
 	return NULL;
 }
 
+static inline struct clk *devm_clk_get_prepared(struct device *dev,
+						const char *id)
+{
+	return NULL;
+}
+
+static inline struct clk *devm_clk_get_enabled(struct device *dev,
+					       const char *id)
+{
+	return NULL;
+}
+
 static inline struct clk *devm_clk_get_optional(struct device *dev,
 						const char *id)
 {
 	return NULL;
 }
 
+static inline struct clk *devm_clk_get_optional_prepared(struct device *dev,
+							 const char *id)
+{
+	return NULL;
+}
+
+static inline struct clk *devm_clk_get_optional_enabled(struct device *dev,
+							const char *id)
+{
+	return NULL;
+}
+
 static inline int __must_check devm_clk_bulk_get(struct device *dev, int num_clks,
 						 struct clk_bulk_data *clks)
 {
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index 3038124c6115..b0da04fe087b 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -129,4 +129,7 @@ bool mc146818_does_rtc_work(void);
 int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
+bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
+			void *param);
+
 #endif /* _MC146818RTC_H */
diff --git a/io_uring/Makefile b/io_uring/Makefile
new file mode 100644
index 000000000000..3680425df947
--- /dev/null
+++ b/io_uring/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for io_uring
+
+obj-$(CONFIG_IO_URING)		+= io_uring.o
+obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
new file mode 100644
index 000000000000..6031fb319d87
--- /dev/null
+++ b/io_uring/io-wq.c
@@ -0,0 +1,1398 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Basic worker thread pool for io_uring
+ *
+ * Copyright (C) 2019 Jens Axboe
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/sched/signal.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+#include <linux/rculist_nulls.h>
+#include <linux/cpu.h>
+#include <linux/tracehook.h>
+#include <uapi/linux/io_uring.h>
+
+#include "io-wq.h"
+
+#define WORKER_IDLE_TIMEOUT	(5 * HZ)
+
+enum {
+	IO_WORKER_F_UP		= 1,	/* up and active */
+	IO_WORKER_F_RUNNING	= 2,	/* account as running */
+	IO_WORKER_F_FREE	= 4,	/* worker on free list */
+	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+};
+
+enum {
+	IO_WQ_BIT_EXIT		= 0,	/* wq exiting */
+};
+
+enum {
+	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
+};
+
+/*
+ * One for each thread in a wqe pool
+ */
+struct io_worker {
+	refcount_t ref;
+	unsigned flags;
+	struct hlist_nulls_node nulls_node;
+	struct list_head all_list;
+	struct task_struct *task;
+	struct io_wqe *wqe;
+
+	struct io_wq_work *cur_work;
+	spinlock_t lock;
+
+	struct completion ref_done;
+
+	unsigned long create_state;
+	struct callback_head create_work;
+	int create_index;
+
+	union {
+		struct rcu_head rcu;
+		struct work_struct work;
+	};
+};
+
+#if BITS_PER_LONG == 64
+#define IO_WQ_HASH_ORDER	6
+#else
+#define IO_WQ_HASH_ORDER	5
+#endif
+
+#define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
+
+struct io_wqe_acct {
+	unsigned nr_workers;
+	unsigned max_workers;
+	int index;
+	atomic_t nr_running;
+	struct io_wq_work_list work_list;
+	unsigned long flags;
+};
+
+enum {
+	IO_WQ_ACCT_BOUND,
+	IO_WQ_ACCT_UNBOUND,
+	IO_WQ_ACCT_NR,
+};
+
+/*
+ * Per-node worker thread pool
+ */
+struct io_wqe {
+	raw_spinlock_t lock;
+	struct io_wqe_acct acct[2];
+
+	int node;
+
+	struct hlist_nulls_head free_list;
+	struct list_head all_list;
+
+	struct wait_queue_entry wait;
+
+	struct io_wq *wq;
+	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
+
+	cpumask_var_t cpu_mask;
+};
+
+/*
+ * Per io_wq state
+  */
+struct io_wq {
+	unsigned long state;
+
+	free_work_fn *free_work;
+	io_wq_work_fn *do_work;
+
+	struct io_wq_hash *hash;
+
+	atomic_t worker_refs;
+	struct completion worker_done;
+
+	struct hlist_node cpuhp_node;
+
+	struct task_struct *task;
+
+	struct io_wqe *wqes[];
+};
+
+static enum cpuhp_state io_wq_online;
+
+struct io_cb_cancel_data {
+	work_cancel_fn *fn;
+	void *data;
+	int nr_running;
+	int nr_pending;
+	bool cancel_all;
+};
+
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static void io_wqe_dec_running(struct io_worker *worker);
+static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
+					struct io_wqe_acct *acct,
+					struct io_cb_cancel_data *match);
+static void create_worker_cb(struct callback_head *cb);
+static void io_wq_cancel_tw_create(struct io_wq *wq);
+
+static bool io_worker_get(struct io_worker *worker)
+{
+	return refcount_inc_not_zero(&worker->ref);
+}
+
+static void io_worker_release(struct io_worker *worker)
+{
+	if (refcount_dec_and_test(&worker->ref))
+		complete(&worker->ref_done);
+}
+
+static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
+{
+	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
+}
+
+static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
+						   struct io_wq_work *work)
+{
+	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
+}
+
+static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
+{
+	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
+}
+
+static void io_worker_ref_put(struct io_wq *wq)
+{
+	if (atomic_dec_and_test(&wq->worker_refs))
+		complete(&wq->worker_done);
+}
+
+static void io_worker_cancel_cb(struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	atomic_dec(&acct->nr_running);
+	raw_spin_lock(&worker->wqe->lock);
+	acct->nr_workers--;
+	raw_spin_unlock(&worker->wqe->lock);
+	io_worker_ref_put(wq);
+	clear_bit_unlock(0, &worker->create_state);
+	io_worker_release(worker);
+}
+
+static bool io_task_worker_match(struct callback_head *cb, void *data)
+{
+	struct io_worker *worker;
+
+	if (cb->func != create_worker_cb)
+		return false;
+	worker = container_of(cb, struct io_worker, create_work);
+	return worker == data;
+}
+
+static void io_worker_exit(struct io_worker *worker)
+{
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	while (1) {
+		struct callback_head *cb = task_work_cancel_match(wq->task,
+						io_task_worker_match, worker);
+
+		if (!cb)
+			break;
+		io_worker_cancel_cb(worker);
+	}
+
+	if (refcount_dec_and_test(&worker->ref))
+		complete(&worker->ref_done);
+	wait_for_completion(&worker->ref_done);
+
+	raw_spin_lock(&wqe->lock);
+	if (worker->flags & IO_WORKER_F_FREE)
+		hlist_nulls_del_rcu(&worker->nulls_node);
+	list_del_rcu(&worker->all_list);
+	preempt_disable();
+	io_wqe_dec_running(worker);
+	worker->flags = 0;
+	current->flags &= ~PF_IO_WORKER;
+	preempt_enable();
+	raw_spin_unlock(&wqe->lock);
+
+	kfree_rcu(worker, rcu);
+	io_worker_ref_put(wqe->wq);
+	do_exit(0);
+}
+
+static inline bool io_acct_run_queue(struct io_wqe_acct *acct)
+{
+	if (!wq_list_empty(&acct->work_list) &&
+	    !test_bit(IO_ACCT_STALLED_BIT, &acct->flags))
+		return true;
+	return false;
+}
+
+/*
+ * Check head of free list for an available worker. If one isn't available,
+ * caller must create one.
+ */
+static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
+					struct io_wqe_acct *acct)
+	__must_hold(RCU)
+{
+	struct hlist_nulls_node *n;
+	struct io_worker *worker;
+
+	/*
+	 * Iterate free_list and see if we can find an idle worker to
+	 * activate. If a given worker is on the free_list but in the process
+	 * of exiting, keep trying.
+	 */
+	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
+		if (!io_worker_get(worker))
+			continue;
+		if (io_wqe_get_acct(worker) != acct) {
+			io_worker_release(worker);
+			continue;
+		}
+		if (wake_up_process(worker->task)) {
+			io_worker_release(worker);
+			return true;
+		}
+		io_worker_release(worker);
+	}
+
+	return false;
+}
+
+/*
+ * We need a worker. If we find a free one, we're good. If not, and we're
+ * below the max number of workers, create one.
+ */
+static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+{
+	/*
+	 * Most likely an attempt to queue unbounded work on an io_wq that
+	 * wasn't setup with any unbounded workers.
+	 */
+	if (unlikely(!acct->max_workers))
+		pr_warn_once("io-wq is not configured for unbound workers");
+
+	raw_spin_lock(&wqe->lock);
+	if (acct->nr_workers >= acct->max_workers) {
+		raw_spin_unlock(&wqe->lock);
+		return true;
+	}
+	acct->nr_workers++;
+	raw_spin_unlock(&wqe->lock);
+	atomic_inc(&acct->nr_running);
+	atomic_inc(&wqe->wq->worker_refs);
+	return create_io_worker(wqe->wq, wqe, acct->index);
+}
+
+static void io_wqe_inc_running(struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+
+	atomic_inc(&acct->nr_running);
+}
+
+static void create_worker_cb(struct callback_head *cb)
+{
+	struct io_worker *worker;
+	struct io_wq *wq;
+	struct io_wqe *wqe;
+	struct io_wqe_acct *acct;
+	bool do_create = false;
+
+	worker = container_of(cb, struct io_worker, create_work);
+	wqe = worker->wqe;
+	wq = wqe->wq;
+	acct = &wqe->acct[worker->create_index];
+	raw_spin_lock(&wqe->lock);
+	if (acct->nr_workers < acct->max_workers) {
+		acct->nr_workers++;
+		do_create = true;
+	}
+	raw_spin_unlock(&wqe->lock);
+	if (do_create) {
+		create_io_worker(wq, wqe, worker->create_index);
+	} else {
+		atomic_dec(&acct->nr_running);
+		io_worker_ref_put(wq);
+	}
+	clear_bit_unlock(0, &worker->create_state);
+	io_worker_release(worker);
+}
+
+static bool io_queue_worker_create(struct io_worker *worker,
+				   struct io_wqe_acct *acct,
+				   task_work_func_t func)
+{
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	/* raced with exit, just ignore create call */
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
+		goto fail;
+	if (!io_worker_get(worker))
+		goto fail;
+	/*
+	 * create_state manages ownership of create_work/index. We should
+	 * only need one entry per worker, as the worker going to sleep
+	 * will trigger the condition, and waking will clear it once it
+	 * runs the task_work.
+	 */
+	if (test_bit(0, &worker->create_state) ||
+	    test_and_set_bit_lock(0, &worker->create_state))
+		goto fail_release;
+
+	atomic_inc(&wq->worker_refs);
+	init_task_work(&worker->create_work, func);
+	worker->create_index = acct->index;
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
+		/*
+		 * EXIT may have been set after checking it above, check after
+		 * adding the task_work and remove any creation item if it is
+		 * now set. wq exit does that too, but we can have added this
+		 * work item after we canceled in io_wq_exit_workers().
+		 */
+		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
+			io_wq_cancel_tw_create(wq);
+		io_worker_ref_put(wq);
+		return true;
+	}
+	io_worker_ref_put(wq);
+	clear_bit_unlock(0, &worker->create_state);
+fail_release:
+	io_worker_release(worker);
+fail:
+	atomic_dec(&acct->nr_running);
+	io_worker_ref_put(wq);
+	return false;
+}
+
+static void io_wqe_dec_running(struct io_worker *worker)
+	__must_hold(wqe->lock)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe *wqe = worker->wqe;
+
+	if (!(worker->flags & IO_WORKER_F_UP))
+		return;
+
+	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
+		atomic_inc(&acct->nr_running);
+		atomic_inc(&wqe->wq->worker_refs);
+		raw_spin_unlock(&wqe->lock);
+		io_queue_worker_create(worker, acct, create_worker_cb);
+		raw_spin_lock(&wqe->lock);
+	}
+}
+
+/*
+ * Worker will start processing some work. Move it to the busy list, if
+ * it's currently on the freelist
+ */
+static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
+			     struct io_wq_work *work)
+	__must_hold(wqe->lock)
+{
+	if (worker->flags & IO_WORKER_F_FREE) {
+		worker->flags &= ~IO_WORKER_F_FREE;
+		hlist_nulls_del_init_rcu(&worker->nulls_node);
+	}
+}
+
+/*
+ * No work, worker going to sleep. Move to freelist, and unuse mm if we
+ * have one attached. Dropping the mm may potentially sleep, so we drop
+ * the lock in that case and return success. Since the caller has to
+ * retry the loop in that case (we changed task state), we don't regrab
+ * the lock if we return success.
+ */
+static void __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
+	__must_hold(wqe->lock)
+{
+	if (!(worker->flags & IO_WORKER_F_FREE)) {
+		worker->flags |= IO_WORKER_F_FREE;
+		hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
+	}
+}
+
+static inline unsigned int io_get_work_hash(struct io_wq_work *work)
+{
+	return work->flags >> IO_WQ_HASH_SHIFT;
+}
+
+static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
+{
+	struct io_wq *wq = wqe->wq;
+	bool ret = false;
+
+	spin_lock_irq(&wq->hash->wait.lock);
+	if (list_empty(&wqe->wait.entry)) {
+		__add_wait_queue(&wq->hash->wait, &wqe->wait);
+		if (!test_bit(hash, &wq->hash->map)) {
+			__set_current_state(TASK_RUNNING);
+			list_del_init(&wqe->wait.entry);
+			ret = true;
+		}
+	}
+	spin_unlock_irq(&wq->hash->wait.lock);
+	return ret;
+}
+
+static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
+					   struct io_worker *worker)
+	__must_hold(wqe->lock)
+{
+	struct io_wq_work_node *node, *prev;
+	struct io_wq_work *work, *tail;
+	unsigned int stall_hash = -1U;
+	struct io_wqe *wqe = worker->wqe;
+
+	wq_list_for_each(node, prev, &acct->work_list) {
+		unsigned int hash;
+
+		work = container_of(node, struct io_wq_work, list);
+
+		/* not hashed, can run anytime */
+		if (!io_wq_is_hashed(work)) {
+			wq_list_del(&acct->work_list, node, prev);
+			return work;
+		}
+
+		hash = io_get_work_hash(work);
+		/* all items with this hash lie in [work, tail] */
+		tail = wqe->hash_tail[hash];
+
+		/* hashed, can run if not already running */
+		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
+			wqe->hash_tail[hash] = NULL;
+			wq_list_cut(&acct->work_list, &tail->list, prev);
+			return work;
+		}
+		if (stall_hash == -1U)
+			stall_hash = hash;
+		/* fast forward to a next hash, for-each will fix up @prev */
+		node = &tail->list;
+	}
+
+	if (stall_hash != -1U) {
+		bool unstalled;
+
+		/*
+		 * Set this before dropping the lock to avoid racing with new
+		 * work being added and clearing the stalled bit.
+		 */
+		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+		raw_spin_unlock(&wqe->lock);
+		unstalled = io_wait_on_hash(wqe, stall_hash);
+		raw_spin_lock(&wqe->lock);
+		if (unstalled) {
+			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+			if (wq_has_sleeper(&wqe->wq->hash->wait))
+				wake_up(&wqe->wq->hash->wait);
+		}
+	}
+
+	return NULL;
+}
+
+static bool io_flush_signals(void)
+{
+	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
+		__set_current_state(TASK_RUNNING);
+		tracehook_notify_signal();
+		return true;
+	}
+	return false;
+}
+
+static void io_assign_current_work(struct io_worker *worker,
+				   struct io_wq_work *work)
+{
+	if (work) {
+		io_flush_signals();
+		cond_resched();
+	}
+
+	spin_lock(&worker->lock);
+	worker->cur_work = work;
+	spin_unlock(&worker->lock);
+}
+
+static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
+
+static void io_worker_handle_work(struct io_worker *worker)
+	__releases(wqe->lock)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
+
+	do {
+		struct io_wq_work *work;
+get_next:
+		/*
+		 * If we got some work, mark us as busy. If we didn't, but
+		 * the list isn't empty, it means we stalled on hashed work.
+		 * Mark us stalled so we don't keep looking for work when we
+		 * can't make progress, any work completion or insertion will
+		 * clear the stalled flag.
+		 */
+		work = io_get_next_work(acct, worker);
+		if (work)
+			__io_worker_busy(wqe, worker, work);
+
+		raw_spin_unlock(&wqe->lock);
+		if (!work)
+			break;
+		io_assign_current_work(worker, work);
+		__set_current_state(TASK_RUNNING);
+
+		/* handle a whole dependent link */
+		do {
+			struct io_wq_work *next_hashed, *linked;
+			unsigned int hash = io_get_work_hash(work);
+
+			next_hashed = wq_next_work(work);
+
+			if (unlikely(do_kill) && (work->flags & IO_WQ_WORK_UNBOUND))
+				work->flags |= IO_WQ_WORK_CANCEL;
+			wq->do_work(work);
+			io_assign_current_work(worker, NULL);
+
+			linked = wq->free_work(work);
+			work = next_hashed;
+			if (!work && linked && !io_wq_is_hashed(linked)) {
+				work = linked;
+				linked = NULL;
+			}
+			io_assign_current_work(worker, work);
+			if (linked)
+				io_wqe_enqueue(wqe, linked);
+
+			if (hash != -1U && !next_hashed) {
+				/* serialize hash clear with wake_up() */
+				spin_lock_irq(&wq->hash->wait.lock);
+				clear_bit(hash, &wq->hash->map);
+				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+				spin_unlock_irq(&wq->hash->wait.lock);
+				if (wq_has_sleeper(&wq->hash->wait))
+					wake_up(&wq->hash->wait);
+				raw_spin_lock(&wqe->lock);
+				/* skip unnecessary unlock-lock wqe->lock */
+				if (!work)
+					goto get_next;
+				raw_spin_unlock(&wqe->lock);
+			}
+		} while (work);
+
+		raw_spin_lock(&wqe->lock);
+	} while (1);
+}
+
+static int io_wqe_worker(void *data)
+{
+	struct io_worker *worker = data;
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+	bool last_timeout = false;
+	char buf[TASK_COMM_LEN];
+
+	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+
+	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
+	set_task_comm(current, buf);
+
+	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
+		long ret;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+loop:
+		raw_spin_lock(&wqe->lock);
+		if (io_acct_run_queue(acct)) {
+			io_worker_handle_work(worker);
+			goto loop;
+		}
+		/* timed out, exit unless we're the last worker */
+		if (last_timeout && acct->nr_workers > 1) {
+			acct->nr_workers--;
+			raw_spin_unlock(&wqe->lock);
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
+		last_timeout = false;
+		__io_worker_idle(wqe, worker);
+		raw_spin_unlock(&wqe->lock);
+		if (io_flush_signals())
+			continue;
+		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (!get_signal(&ksig))
+				continue;
+			break;
+		}
+		last_timeout = !ret;
+	}
+
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
+		raw_spin_lock(&wqe->lock);
+		io_worker_handle_work(worker);
+	}
+
+	io_worker_exit(worker);
+	return 0;
+}
+
+/*
+ * Called when a worker is scheduled in. Mark us as currently running.
+ */
+void io_wq_worker_running(struct task_struct *tsk)
+{
+	struct io_worker *worker = tsk->pf_io_worker;
+
+	if (!worker)
+		return;
+	if (!(worker->flags & IO_WORKER_F_UP))
+		return;
+	if (worker->flags & IO_WORKER_F_RUNNING)
+		return;
+	worker->flags |= IO_WORKER_F_RUNNING;
+	io_wqe_inc_running(worker);
+}
+
+/*
+ * Called when worker is going to sleep. If there are no workers currently
+ * running and we have work pending, wake up a free one or create a new one.
+ */
+void io_wq_worker_sleeping(struct task_struct *tsk)
+{
+	struct io_worker *worker = tsk->pf_io_worker;
+
+	if (!worker)
+		return;
+	if (!(worker->flags & IO_WORKER_F_UP))
+		return;
+	if (!(worker->flags & IO_WORKER_F_RUNNING))
+		return;
+
+	worker->flags &= ~IO_WORKER_F_RUNNING;
+
+	raw_spin_lock(&worker->wqe->lock);
+	io_wqe_dec_running(worker);
+	raw_spin_unlock(&worker->wqe->lock);
+}
+
+static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
+			       struct task_struct *tsk)
+{
+	tsk->pf_io_worker = worker;
+	worker->task = tsk;
+	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
+	tsk->flags |= PF_NO_SETAFFINITY;
+
+	raw_spin_lock(&wqe->lock);
+	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
+	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
+	worker->flags |= IO_WORKER_F_FREE;
+	raw_spin_unlock(&wqe->lock);
+	wake_up_new_task(tsk);
+}
+
+static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
+{
+	return true;
+}
+
+static inline bool io_should_retry_thread(long err)
+{
+	/*
+	 * Prevent perpetual task_work retry, if the task (or its group) is
+	 * exiting.
+	 */
+	if (fatal_signal_pending(current))
+		return false;
+
+	switch (err) {
+	case -EAGAIN:
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static void create_worker_cont(struct callback_head *cb)
+{
+	struct io_worker *worker;
+	struct task_struct *tsk;
+	struct io_wqe *wqe;
+
+	worker = container_of(cb, struct io_worker, create_work);
+	clear_bit_unlock(0, &worker->create_state);
+	wqe = worker->wqe;
+	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
+	if (!IS_ERR(tsk)) {
+		io_init_new_worker(wqe, worker, tsk);
+		io_worker_release(worker);
+		return;
+	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+
+		atomic_dec(&acct->nr_running);
+		raw_spin_lock(&wqe->lock);
+		acct->nr_workers--;
+		if (!acct->nr_workers) {
+			struct io_cb_cancel_data match = {
+				.fn		= io_wq_work_match_all,
+				.cancel_all	= true,
+			};
+
+			while (io_acct_cancel_pending_work(wqe, acct, &match))
+				raw_spin_lock(&wqe->lock);
+		}
+		raw_spin_unlock(&wqe->lock);
+		io_worker_ref_put(wqe->wq);
+		kfree(worker);
+		return;
+	}
+
+	/* re-create attempts grab a new worker ref, drop the existing one */
+	io_worker_release(worker);
+	schedule_work(&worker->work);
+}
+
+static void io_workqueue_create(struct work_struct *work)
+{
+	struct io_worker *worker = container_of(work, struct io_worker, work);
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+
+	if (!io_queue_worker_create(worker, acct, create_worker_cont))
+		kfree(worker);
+}
+
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+{
+	struct io_wqe_acct *acct = &wqe->acct[index];
+	struct io_worker *worker;
+	struct task_struct *tsk;
+
+	__set_current_state(TASK_RUNNING);
+
+	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
+	if (!worker) {
+fail:
+		atomic_dec(&acct->nr_running);
+		raw_spin_lock(&wqe->lock);
+		acct->nr_workers--;
+		raw_spin_unlock(&wqe->lock);
+		io_worker_ref_put(wq);
+		return false;
+	}
+
+	refcount_set(&worker->ref, 1);
+	worker->wqe = wqe;
+	spin_lock_init(&worker->lock);
+	init_completion(&worker->ref_done);
+
+	if (index == IO_WQ_ACCT_BOUND)
+		worker->flags |= IO_WORKER_F_BOUND;
+
+	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
+	if (!IS_ERR(tsk)) {
+		io_init_new_worker(wqe, worker, tsk);
+	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		kfree(worker);
+		goto fail;
+	} else {
+		INIT_WORK(&worker->work, io_workqueue_create);
+		schedule_work(&worker->work);
+	}
+
+	return true;
+}
+
+/*
+ * Iterate the passed in list and call the specific function for each
+ * worker that isn't exiting
+ */
+static bool io_wq_for_each_worker(struct io_wqe *wqe,
+				  bool (*func)(struct io_worker *, void *),
+				  void *data)
+{
+	struct io_worker *worker;
+	bool ret = false;
+
+	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
+		if (io_worker_get(worker)) {
+			/* no task if node is/was offline */
+			if (worker->task)
+				ret = func(worker, data);
+			io_worker_release(worker);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static bool io_wq_worker_wake(struct io_worker *worker, void *data)
+{
+	set_notify_signal(worker->task);
+	wake_up_process(worker->task);
+	return false;
+}
+
+static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
+{
+	struct io_wq *wq = wqe->wq;
+
+	do {
+		work->flags |= IO_WQ_WORK_CANCEL;
+		wq->do_work(work);
+		work = wq->free_work(work);
+	} while (work);
+}
+
+static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
+{
+	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	unsigned int hash;
+	struct io_wq_work *tail;
+
+	if (!io_wq_is_hashed(work)) {
+append:
+		wq_list_add_tail(&work->list, &acct->work_list);
+		return;
+	}
+
+	hash = io_get_work_hash(work);
+	tail = wqe->hash_tail[hash];
+	wqe->hash_tail[hash] = work;
+	if (!tail)
+		goto append;
+
+	wq_list_add_after(&work->list, &tail->list, &acct->work_list);
+}
+
+static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
+{
+	return work == data;
+}
+
+static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
+{
+	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	unsigned work_flags = work->flags;
+	bool do_create;
+
+	/*
+	 * If io-wq is exiting for this task, or if the request has explicitly
+	 * been marked as one that should not get executed, cancel it here.
+	 */
+	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state) ||
+	    (work->flags & IO_WQ_WORK_CANCEL)) {
+		io_run_cancel(work, wqe);
+		return;
+	}
+
+	raw_spin_lock(&wqe->lock);
+	io_wqe_insert_work(wqe, work);
+	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+
+	rcu_read_lock();
+	do_create = !io_wqe_activate_free_worker(wqe, acct);
+	rcu_read_unlock();
+
+	raw_spin_unlock(&wqe->lock);
+
+	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
+	    !atomic_read(&acct->nr_running))) {
+		bool did_create;
+
+		did_create = io_wqe_create_worker(wqe, acct);
+		if (likely(did_create))
+			return;
+
+		raw_spin_lock(&wqe->lock);
+		/* fatal condition, failed to create the first worker */
+		if (!acct->nr_workers) {
+			struct io_cb_cancel_data match = {
+				.fn		= io_wq_work_match_item,
+				.data		= work,
+				.cancel_all	= false,
+			};
+
+			if (io_acct_cancel_pending_work(wqe, acct, &match))
+				raw_spin_lock(&wqe->lock);
+		}
+		raw_spin_unlock(&wqe->lock);
+	}
+}
+
+void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
+{
+	struct io_wqe *wqe = wq->wqes[numa_node_id()];
+
+	io_wqe_enqueue(wqe, work);
+}
+
+/*
+ * Work items that hash to the same value will not be done in parallel.
+ * Used to limit concurrent writes, generally hashed by inode.
+ */
+void io_wq_hash_work(struct io_wq_work *work, void *val)
+{
+	unsigned int bit;
+
+	bit = hash_ptr(val, IO_WQ_HASH_ORDER);
+	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
+}
+
+static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
+{
+	struct io_cb_cancel_data *match = data;
+
+	/*
+	 * Hold the lock to avoid ->cur_work going out of scope, caller
+	 * may dereference the passed in work.
+	 */
+	spin_lock(&worker->lock);
+	if (worker->cur_work &&
+	    match->fn(worker->cur_work, match->data)) {
+		set_notify_signal(worker->task);
+		match->nr_running++;
+	}
+	spin_unlock(&worker->lock);
+
+	return match->nr_running && !match->cancel_all;
+}
+
+static inline void io_wqe_remove_pending(struct io_wqe *wqe,
+					 struct io_wq_work *work,
+					 struct io_wq_work_node *prev)
+{
+	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	unsigned int hash = io_get_work_hash(work);
+	struct io_wq_work *prev_work = NULL;
+
+	if (io_wq_is_hashed(work) && work == wqe->hash_tail[hash]) {
+		if (prev)
+			prev_work = container_of(prev, struct io_wq_work, list);
+		if (prev_work && io_get_work_hash(prev_work) == hash)
+			wqe->hash_tail[hash] = prev_work;
+		else
+			wqe->hash_tail[hash] = NULL;
+	}
+	wq_list_del(&acct->work_list, &work->list, prev);
+}
+
+static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
+					struct io_wqe_acct *acct,
+					struct io_cb_cancel_data *match)
+	__releases(wqe->lock)
+{
+	struct io_wq_work_node *node, *prev;
+	struct io_wq_work *work;
+
+	wq_list_for_each(node, prev, &acct->work_list) {
+		work = container_of(node, struct io_wq_work, list);
+		if (!match->fn(work, match->data))
+			continue;
+		io_wqe_remove_pending(wqe, work, prev);
+		raw_spin_unlock(&wqe->lock);
+		io_run_cancel(work, wqe);
+		match->nr_pending++;
+		/* not safe to continue after unlock */
+		return true;
+	}
+
+	return false;
+}
+
+static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
+{
+	int i;
+retry:
+	raw_spin_lock(&wqe->lock);
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
+
+		if (io_acct_cancel_pending_work(wqe, acct, match)) {
+			if (match->cancel_all)
+				goto retry;
+			return;
+		}
+	}
+	raw_spin_unlock(&wqe->lock);
+}
+
+static void io_wqe_cancel_running_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
+{
+	rcu_read_lock();
+	io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
+	rcu_read_unlock();
+}
+
+enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
+				  void *data, bool cancel_all)
+{
+	struct io_cb_cancel_data match = {
+		.fn		= cancel,
+		.data		= data,
+		.cancel_all	= cancel_all,
+	};
+	int node;
+
+	/*
+	 * First check pending list, if we're lucky we can just remove it
+	 * from there. CANCEL_OK means that the work is returned as-new,
+	 * no completion will be posted for it.
+	 */
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		io_wqe_cancel_pending_work(wqe, &match);
+		if (match.nr_pending && !match.cancel_all)
+			return IO_WQ_CANCEL_OK;
+	}
+
+	/*
+	 * Now check if a free (going busy) or busy worker has the work
+	 * currently running. If we find it there, we'll return CANCEL_RUNNING
+	 * as an indication that we attempt to signal cancellation. The
+	 * completion will run normally in this case.
+	 */
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		io_wqe_cancel_running_work(wqe, &match);
+		if (match.nr_running && !match.cancel_all)
+			return IO_WQ_CANCEL_RUNNING;
+	}
+
+	if (match.nr_running)
+		return IO_WQ_CANCEL_RUNNING;
+	if (match.nr_pending)
+		return IO_WQ_CANCEL_OK;
+	return IO_WQ_CANCEL_NOTFOUND;
+}
+
+static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
+			    int sync, void *key)
+{
+	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
+	int i;
+
+	list_del_init(&wait->entry);
+
+	rcu_read_lock();
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wqe_acct *acct = &wqe->acct[i];
+
+		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
+			io_wqe_activate_free_worker(wqe, acct);
+	}
+	rcu_read_unlock();
+	return 1;
+}
+
+struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
+{
+	int ret, node, i;
+	struct io_wq *wq;
+
+	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
+		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(!bounded))
+		return ERR_PTR(-EINVAL);
+
+	wq = kzalloc(struct_size(wq, wqes, nr_node_ids), GFP_KERNEL);
+	if (!wq)
+		return ERR_PTR(-ENOMEM);
+	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
+	if (ret)
+		goto err_wq;
+
+	refcount_inc(&data->hash->refs);
+	wq->hash = data->hash;
+	wq->free_work = data->free_work;
+	wq->do_work = data->do_work;
+
+	ret = -ENOMEM;
+	for_each_node(node) {
+		struct io_wqe *wqe;
+		int alloc_node = node;
+
+		if (!node_online(alloc_node))
+			alloc_node = NUMA_NO_NODE;
+		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
+		if (!wqe)
+			goto err;
+		wq->wqes[node] = wqe;
+		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
+			goto err;
+		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
+		wqe->node = alloc_node;
+		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
+		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
+					task_rlimit(current, RLIMIT_NPROC);
+		INIT_LIST_HEAD(&wqe->wait.entry);
+		wqe->wait.func = io_wqe_hash_wake;
+		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+			struct io_wqe_acct *acct = &wqe->acct[i];
+
+			acct->index = i;
+			atomic_set(&acct->nr_running, 0);
+			INIT_WQ_LIST(&acct->work_list);
+		}
+		wqe->wq = wq;
+		raw_spin_lock_init(&wqe->lock);
+		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
+		INIT_LIST_HEAD(&wqe->all_list);
+	}
+
+	wq->task = get_task_struct(data->task);
+	atomic_set(&wq->worker_refs, 1);
+	init_completion(&wq->worker_done);
+	return wq;
+err:
+	io_wq_put_hash(data->hash);
+	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
+	for_each_node(node) {
+		if (!wq->wqes[node])
+			continue;
+		free_cpumask_var(wq->wqes[node]->cpu_mask);
+		kfree(wq->wqes[node]);
+	}
+err_wq:
+	kfree(wq);
+	return ERR_PTR(ret);
+}
+
+static bool io_task_work_match(struct callback_head *cb, void *data)
+{
+	struct io_worker *worker;
+
+	if (cb->func != create_worker_cb && cb->func != create_worker_cont)
+		return false;
+	worker = container_of(cb, struct io_worker, create_work);
+	return worker->wqe->wq == data;
+}
+
+void io_wq_exit_start(struct io_wq *wq)
+{
+	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+}
+
+static void io_wq_cancel_tw_create(struct io_wq *wq)
+{
+	struct callback_head *cb;
+
+	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
+		struct io_worker *worker;
+
+		worker = container_of(cb, struct io_worker, create_work);
+		io_worker_cancel_cb(worker);
+	}
+}
+
+static void io_wq_exit_workers(struct io_wq *wq)
+{
+	int node;
+
+	if (!wq->task)
+		return;
+
+	io_wq_cancel_tw_create(wq);
+
+	rcu_read_lock();
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
+	}
+	rcu_read_unlock();
+	io_worker_ref_put(wq);
+	wait_for_completion(&wq->worker_done);
+
+	for_each_node(node) {
+		spin_lock_irq(&wq->hash->wait.lock);
+		list_del_init(&wq->wqes[node]->wait.entry);
+		spin_unlock_irq(&wq->hash->wait.lock);
+	}
+	put_task_struct(wq->task);
+	wq->task = NULL;
+}
+
+static void io_wq_destroy(struct io_wq *wq)
+{
+	int node;
+
+	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
+
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+		struct io_cb_cancel_data match = {
+			.fn		= io_wq_work_match_all,
+			.cancel_all	= true,
+		};
+		io_wqe_cancel_pending_work(wqe, &match);
+		free_cpumask_var(wqe->cpu_mask);
+		kfree(wqe);
+	}
+	io_wq_put_hash(wq->hash);
+	kfree(wq);
+}
+
+void io_wq_put_and_exit(struct io_wq *wq)
+{
+	WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state));
+
+	io_wq_exit_workers(wq);
+	io_wq_destroy(wq);
+}
+
+struct online_data {
+	unsigned int cpu;
+	bool online;
+};
+
+static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
+{
+	struct online_data *od = data;
+
+	if (od->online)
+		cpumask_set_cpu(od->cpu, worker->wqe->cpu_mask);
+	else
+		cpumask_clear_cpu(od->cpu, worker->wqe->cpu_mask);
+	return false;
+}
+
+static int __io_wq_cpu_online(struct io_wq *wq, unsigned int cpu, bool online)
+{
+	struct online_data od = {
+		.cpu = cpu,
+		.online = online
+	};
+	int i;
+
+	rcu_read_lock();
+	for_each_node(i)
+		io_wq_for_each_worker(wq->wqes[i], io_wq_worker_affinity, &od);
+	rcu_read_unlock();
+	return 0;
+}
+
+static int io_wq_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
+
+	return __io_wq_cpu_online(wq, cpu, true);
+}
+
+static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
+{
+	struct io_wq *wq = hlist_entry_safe(node, struct io_wq, cpuhp_node);
+
+	return __io_wq_cpu_online(wq, cpu, false);
+}
+
+int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
+{
+	int i;
+
+	rcu_read_lock();
+	for_each_node(i) {
+		struct io_wqe *wqe = wq->wqes[i];
+
+		if (mask)
+			cpumask_copy(wqe->cpu_mask, mask);
+		else
+			cpumask_copy(wqe->cpu_mask, cpumask_of_node(i));
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+/*
+ * Set max number of unbounded workers, returns old value. If new_count is 0,
+ * then just return the old value.
+ */
+int io_wq_max_workers(struct io_wq *wq, int *new_count)
+{
+	int prev[IO_WQ_ACCT_NR];
+	bool first_node = true;
+	int i, node;
+
+	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
+
+	for (i = 0; i < 2; i++) {
+		if (new_count[i] > task_rlimit(current, RLIMIT_NPROC))
+			new_count[i] = task_rlimit(current, RLIMIT_NPROC);
+	}
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++)
+		prev[i] = 0;
+
+	rcu_read_lock();
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+		struct io_wqe_acct *acct;
+
+		raw_spin_lock(&wqe->lock);
+		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+			acct = &wqe->acct[i];
+			if (first_node)
+				prev[i] = max_t(int, acct->max_workers, prev[i]);
+			if (new_count[i])
+				acct->max_workers = new_count[i];
+		}
+		raw_spin_unlock(&wqe->lock);
+		first_node = false;
+	}
+	rcu_read_unlock();
+
+	for (i = 0; i < IO_WQ_ACCT_NR; i++)
+		new_count[i] = prev[i];
+
+	return 0;
+}
+
+static __init int io_wq_init(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "io-wq/online",
+					io_wq_cpu_online, io_wq_cpu_offline);
+	if (ret < 0)
+		return ret;
+	io_wq_online = ret;
+	return 0;
+}
+subsys_initcall(io_wq_init);
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
new file mode 100644
index 000000000000..bf5c4c533760
--- /dev/null
+++ b/io_uring/io-wq.h
@@ -0,0 +1,160 @@
+#ifndef INTERNAL_IO_WQ_H
+#define INTERNAL_IO_WQ_H
+
+#include <linux/refcount.h>
+
+struct io_wq;
+
+enum {
+	IO_WQ_WORK_CANCEL	= 1,
+	IO_WQ_WORK_HASHED	= 2,
+	IO_WQ_WORK_UNBOUND	= 4,
+	IO_WQ_WORK_CONCURRENT	= 16,
+
+	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
+};
+
+enum io_wq_cancel {
+	IO_WQ_CANCEL_OK,	/* cancelled before started */
+	IO_WQ_CANCEL_RUNNING,	/* found, running, and attempted cancelled */
+	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
+};
+
+struct io_wq_work_node {
+	struct io_wq_work_node *next;
+};
+
+struct io_wq_work_list {
+	struct io_wq_work_node *first;
+	struct io_wq_work_node *last;
+};
+
+static inline void wq_list_add_after(struct io_wq_work_node *node,
+				     struct io_wq_work_node *pos,
+				     struct io_wq_work_list *list)
+{
+	struct io_wq_work_node *next = pos->next;
+
+	pos->next = node;
+	node->next = next;
+	if (!next)
+		list->last = node;
+}
+
+static inline void wq_list_add_tail(struct io_wq_work_node *node,
+				    struct io_wq_work_list *list)
+{
+	node->next = NULL;
+	if (!list->first) {
+		list->last = node;
+		WRITE_ONCE(list->first, node);
+	} else {
+		list->last->next = node;
+		list->last = node;
+	}
+}
+
+static inline void wq_list_cut(struct io_wq_work_list *list,
+			       struct io_wq_work_node *last,
+			       struct io_wq_work_node *prev)
+{
+	/* first in the list, if prev==NULL */
+	if (!prev)
+		WRITE_ONCE(list->first, last->next);
+	else
+		prev->next = last->next;
+
+	if (last == list->last)
+		list->last = prev;
+	last->next = NULL;
+}
+
+static inline void wq_list_del(struct io_wq_work_list *list,
+			       struct io_wq_work_node *node,
+			       struct io_wq_work_node *prev)
+{
+	wq_list_cut(list, node, prev);
+}
+
+#define wq_list_for_each(pos, prv, head)			\
+	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
+
+#define wq_list_empty(list)	(READ_ONCE((list)->first) == NULL)
+#define INIT_WQ_LIST(list)	do {				\
+	(list)->first = NULL;					\
+	(list)->last = NULL;					\
+} while (0)
+
+struct io_wq_work {
+	struct io_wq_work_node list;
+	unsigned flags;
+};
+
+static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
+{
+	if (!work->list.next)
+		return NULL;
+
+	return container_of(work->list.next, struct io_wq_work, list);
+}
+
+typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
+typedef void (io_wq_work_fn)(struct io_wq_work *);
+
+struct io_wq_hash {
+	refcount_t refs;
+	unsigned long map;
+	struct wait_queue_head wait;
+};
+
+static inline void io_wq_put_hash(struct io_wq_hash *hash)
+{
+	if (refcount_dec_and_test(&hash->refs))
+		kfree(hash);
+}
+
+struct io_wq_data {
+	struct io_wq_hash *hash;
+	struct task_struct *task;
+	io_wq_work_fn *do_work;
+	free_work_fn *free_work;
+};
+
+struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
+void io_wq_exit_start(struct io_wq *wq);
+void io_wq_put_and_exit(struct io_wq *wq);
+
+void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
+void io_wq_hash_work(struct io_wq_work *work, void *val);
+
+int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
+int io_wq_max_workers(struct io_wq *wq, int *new_count);
+
+static inline bool io_wq_is_hashed(struct io_wq_work *work)
+{
+	return work->flags & IO_WQ_WORK_HASHED;
+}
+
+typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
+
+enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
+					void *data, bool cancel_all);
+
+#if defined(CONFIG_IO_WQ)
+extern void io_wq_worker_sleeping(struct task_struct *);
+extern void io_wq_worker_running(struct task_struct *);
+#else
+static inline void io_wq_worker_sleeping(struct task_struct *tsk)
+{
+}
+static inline void io_wq_worker_running(struct task_struct *tsk)
+{
+}
+#endif
+
+static inline bool io_wq_current_is_worker(void)
+{
+	return in_task() && (current->flags & PF_IO_WORKER) &&
+		current->pf_io_worker;
+}
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
new file mode 100644
index 000000000000..eebbe8a6da0c
--- /dev/null
+++ b/io_uring/io_uring.c
@@ -0,0 +1,11112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Shared application/kernel submission and completion ring pairs, for
+ * supporting fast/efficient IO.
+ *
+ * A note on the read/write ordering memory barriers that are matched between
+ * the application and kernel side.
+ *
+ * After the application reads the CQ ring tail, it must use an
+ * appropriate smp_rmb() to pair with the smp_wmb() the kernel uses
+ * before writing the tail (using smp_load_acquire to read the tail will
+ * do). It also needs a smp_mb() before updating CQ head (ordering the
+ * entry load(s) with the head store), pairing with an implicit barrier
+ * through a control-dependency in io_get_cqe (smp_store_release to
+ * store head will do). Failure to do so could lead to reading invalid
+ * CQ entries.
+ *
+ * Likewise, the application must use an appropriate smp_wmb() before
+ * writing the SQ tail (ordering SQ entry stores with the tail store),
+ * which pairs with smp_load_acquire in io_get_sqring (smp_store_release
+ * to store the tail will do). And it needs a barrier ordering the SQ
+ * head load before writing new SQ entries (smp_load_acquire to read
+ * head will do).
+ *
+ * When using the SQ poll thread (IORING_SETUP_SQPOLL), the application
+ * needs to check the SQ flags for IORING_SQ_NEED_WAKEUP *after*
+ * updating the SQ tail; a full memory barrier smp_mb() is needed
+ * between.
+ *
+ * Also see the examples in the liburing library:
+ *
+ *	git://git.kernel.dk/liburing
+ *
+ * io_uring also uses READ/WRITE_ONCE() for _any_ store or load that happens
+ * from data shared between the kernel and application. This is done both
+ * for ordering purposes, but also to ensure that once a value is loaded from
+ * data that the application could potentially modify, it remains stable.
+ *
+ * Copyright (C) 2018-2019 Jens Axboe
+ * Copyright (c) 2018-2019 Christoph Hellwig
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/syscalls.h>
+#include <linux/compat.h>
+#include <net/compat.h>
+#include <linux/refcount.h>
+#include <linux/uio.h>
+#include <linux/bits.h>
+
+#include <linux/sched/signal.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/bvec.h>
+#include <linux/net.h>
+#include <net/sock.h>
+#include <net/af_unix.h>
+#include <net/scm.h>
+#include <linux/anon_inodes.h>
+#include <linux/sched/mm.h>
+#include <linux/uaccess.h>
+#include <linux/nospec.h>
+#include <linux/sizes.h>
+#include <linux/hugetlb.h>
+#include <linux/highmem.h>
+#include <linux/namei.h>
+#include <linux/fsnotify.h>
+#include <linux/fadvise.h>
+#include <linux/eventpoll.h>
+#include <linux/splice.h>
+#include <linux/task_work.h>
+#include <linux/pagemap.h>
+#include <linux/io_uring.h>
+#include <linux/tracehook.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "../fs/internal.h"
+#include "io-wq.h"
+
+#define IORING_MAX_ENTRIES	32768
+#define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
+#define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
+
+/* only define max */
+#define IORING_MAX_FIXED_FILES	(1U << 15)
+#define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
+				 IORING_REGISTER_LAST + IORING_OP_LAST)
+
+#define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
+#define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
+#define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
+
+#define IORING_MAX_REG_BUFFERS	(1U << 14)
+
+#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
+				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+				IOSQE_BUFFER_SELECT)
+#define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
+
+#define IO_TCTX_REFS_CACHE_NR	(1U << 10)
+
+struct io_uring {
+	u32 head ____cacheline_aligned_in_smp;
+	u32 tail ____cacheline_aligned_in_smp;
+};
+
+/*
+ * This data is shared with the application through the mmap at offsets
+ * IORING_OFF_SQ_RING and IORING_OFF_CQ_RING.
+ *
+ * The offsets to the member fields are published through struct
+ * io_sqring_offsets when calling io_uring_setup.
+ */
+struct io_rings {
+	/*
+	 * Head and tail offsets into the ring; the offsets need to be
+	 * masked to get valid indices.
+	 *
+	 * The kernel controls head of the sq ring and the tail of the cq ring,
+	 * and the application controls tail of the sq ring and the head of the
+	 * cq ring.
+	 */
+	struct io_uring		sq, cq;
+	/*
+	 * Bitmasks to apply to head and tail offsets (constant, equals
+	 * ring_entries - 1)
+	 */
+	u32			sq_ring_mask, cq_ring_mask;
+	/* Ring sizes (constant, power of 2) */
+	u32			sq_ring_entries, cq_ring_entries;
+	/*
+	 * Number of invalid entries dropped by the kernel due to
+	 * invalid index stored in array
+	 *
+	 * Written by the kernel, shouldn't be modified by the
+	 * application (i.e. get number of "new events" by comparing to
+	 * cached value).
+	 *
+	 * After a new SQ head value was read by the application this
+	 * counter includes all submissions that were dropped reaching
+	 * the new SQ head (and possibly more).
+	 */
+	u32			sq_dropped;
+	/*
+	 * Runtime SQ flags
+	 *
+	 * Written by the kernel, shouldn't be modified by the
+	 * application.
+	 *
+	 * The application needs a full memory barrier before checking
+	 * for IORING_SQ_NEED_WAKEUP after updating the sq tail.
+	 */
+	u32			sq_flags;
+	/*
+	 * Runtime CQ flags
+	 *
+	 * Written by the application, shouldn't be modified by the
+	 * kernel.
+	 */
+	u32			cq_flags;
+	/*
+	 * Number of completion events lost because the queue was full;
+	 * this should be avoided by the application by making sure
+	 * there are not more requests pending than there is space in
+	 * the completion queue.
+	 *
+	 * Written by the kernel, shouldn't be modified by the
+	 * application (i.e. get number of "new events" by comparing to
+	 * cached value).
+	 *
+	 * As completion events come in out of order this counter is not
+	 * ordered with any other data.
+	 */
+	u32			cq_overflow;
+	/*
+	 * Ring buffer of completion events.
+	 *
+	 * The kernel writes completion events fresh every time they are
+	 * produced, so the application is allowed to modify pending
+	 * entries.
+	 */
+	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
+};
+
+enum io_uring_cmd_flags {
+	IO_URING_F_NONBLOCK		= 1,
+	IO_URING_F_COMPLETE_DEFER	= 2,
+};
+
+struct io_mapped_ubuf {
+	u64		ubuf;
+	u64		ubuf_end;
+	unsigned int	nr_bvecs;
+	unsigned long	acct_pages;
+	struct bio_vec	bvec[];
+};
+
+struct io_ring_ctx;
+
+struct io_overflow_cqe {
+	struct io_uring_cqe cqe;
+	struct list_head list;
+};
+
+struct io_fixed_file {
+	/* file * with additional FFS_* flags */
+	unsigned long file_ptr;
+};
+
+struct io_rsrc_put {
+	struct list_head list;
+	u64 tag;
+	union {
+		void *rsrc;
+		struct file *file;
+		struct io_mapped_ubuf *buf;
+	};
+};
+
+struct io_file_table {
+	struct io_fixed_file *files;
+};
+
+struct io_rsrc_node {
+	struct percpu_ref		refs;
+	struct list_head		node;
+	struct list_head		rsrc_list;
+	struct io_rsrc_data		*rsrc_data;
+	struct llist_node		llist;
+	bool				done;
+};
+
+typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
+
+struct io_rsrc_data {
+	struct io_ring_ctx		*ctx;
+
+	u64				**tags;
+	unsigned int			nr;
+	rsrc_put_fn			*do_put;
+	atomic_t			refs;
+	struct completion		done;
+	bool				quiesce;
+};
+
+struct io_buffer {
+	struct list_head list;
+	__u64 addr;
+	__u32 len;
+	__u16 bid;
+};
+
+struct io_restriction {
+	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
+	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	u8 sqe_flags_allowed;
+	u8 sqe_flags_required;
+	bool registered;
+};
+
+enum {
+	IO_SQ_THREAD_SHOULD_STOP = 0,
+	IO_SQ_THREAD_SHOULD_PARK,
+};
+
+struct io_sq_data {
+	refcount_t		refs;
+	atomic_t		park_pending;
+	struct mutex		lock;
+
+	/* ctx's that are using this sqd */
+	struct list_head	ctx_list;
+
+	struct task_struct	*thread;
+	struct wait_queue_head	wait;
+
+	unsigned		sq_thread_idle;
+	int			sq_cpu;
+	pid_t			task_pid;
+	pid_t			task_tgid;
+
+	unsigned long		state;
+	struct completion	exited;
+};
+
+#define IO_COMPL_BATCH			32
+#define IO_REQ_CACHE_SIZE		32
+#define IO_REQ_ALLOC_BATCH		8
+
+struct io_submit_link {
+	struct io_kiocb		*head;
+	struct io_kiocb		*last;
+};
+
+struct io_submit_state {
+	struct blk_plug		plug;
+	struct io_submit_link	link;
+
+	/*
+	 * io_kiocb alloc cache
+	 */
+	void			*reqs[IO_REQ_CACHE_SIZE];
+	unsigned int		free_reqs;
+
+	bool			plug_started;
+
+	/*
+	 * Batch completion logic
+	 */
+	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
+	unsigned int		compl_nr;
+	/* inline/task_work completion list, under ->uring_lock */
+	struct list_head	free_list;
+
+	unsigned int		ios_left;
+};
+
+struct io_ring_ctx {
+	/* const or read-mostly hot data */
+	struct {
+		struct percpu_ref	refs;
+
+		struct io_rings		*rings;
+		unsigned int		flags;
+		unsigned int		compat: 1;
+		unsigned int		drain_next: 1;
+		unsigned int		eventfd_async: 1;
+		unsigned int		restricted: 1;
+		unsigned int		off_timeout_used: 1;
+		unsigned int		drain_active: 1;
+	} ____cacheline_aligned_in_smp;
+
+	/* submission data */
+	struct {
+		struct mutex		uring_lock;
+
+		/*
+		 * Ring buffer of indices into array of io_uring_sqe, which is
+		 * mmapped by the application using the IORING_OFF_SQES offset.
+		 *
+		 * This indirection could e.g. be used to assign fixed
+		 * io_uring_sqe entries to operations and only submit them to
+		 * the queue when needed.
+		 *
+		 * The kernel modifies neither the indices array nor the entries
+		 * array.
+		 */
+		u32			*sq_array;
+		struct io_uring_sqe	*sq_sqes;
+		unsigned		cached_sq_head;
+		unsigned		sq_entries;
+		struct list_head	defer_list;
+
+		/*
+		 * Fixed resources fast path, should be accessed only under
+		 * uring_lock, and updated through io_uring_register(2)
+		 */
+		struct io_rsrc_node	*rsrc_node;
+		struct io_file_table	file_table;
+		unsigned		nr_user_files;
+		unsigned		nr_user_bufs;
+		struct io_mapped_ubuf	**user_bufs;
+
+		struct io_submit_state	submit_state;
+		struct list_head	timeout_list;
+		struct list_head	ltimeout_list;
+		struct list_head	cq_overflow_list;
+		struct xarray		io_buffers;
+		struct xarray		personalities;
+		u32			pers_next;
+		unsigned		sq_thread_idle;
+	} ____cacheline_aligned_in_smp;
+
+	/* IRQ completion list, under ->completion_lock */
+	struct list_head	locked_free_list;
+	unsigned int		locked_free_nr;
+
+	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
+	struct io_sq_data	*sq_data;	/* if using sq thread polling */
+
+	struct wait_queue_head	sqo_sq_wait;
+	struct list_head	sqd_list;
+
+	unsigned long		check_cq_overflow;
+
+	struct {
+		unsigned		cached_cq_tail;
+		unsigned		cq_entries;
+		struct eventfd_ctx	*cq_ev_fd;
+		struct wait_queue_head	poll_wait;
+		struct wait_queue_head	cq_wait;
+		unsigned		cq_extra;
+		atomic_t		cq_timeouts;
+		unsigned		cq_last_tm_flush;
+	} ____cacheline_aligned_in_smp;
+
+	struct {
+		spinlock_t		completion_lock;
+
+		spinlock_t		timeout_lock;
+
+		/*
+		 * ->iopoll_list is protected by the ctx->uring_lock for
+		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
+		 * For SQPOLL, only the single threaded io_sq_thread() will
+		 * manipulate the list, hence no extra locking is needed there.
+		 */
+		struct list_head	iopoll_list;
+		struct hlist_head	*cancel_hash;
+		unsigned		cancel_hash_bits;
+		bool			poll_multi_queue;
+	} ____cacheline_aligned_in_smp;
+
+	struct io_restriction		restrictions;
+
+	/* slow path rsrc auxilary data, used by update/register */
+	struct {
+		struct io_rsrc_node		*rsrc_backup_node;
+		struct io_mapped_ubuf		*dummy_ubuf;
+		struct io_rsrc_data		*file_data;
+		struct io_rsrc_data		*buf_data;
+
+		struct delayed_work		rsrc_put_work;
+		struct llist_head		rsrc_put_llist;
+		struct list_head		rsrc_ref_list;
+		spinlock_t			rsrc_ref_lock;
+	};
+
+	/* Keep this last, we don't need it for the fast path */
+	struct {
+		#if defined(CONFIG_UNIX)
+			struct socket		*ring_sock;
+		#endif
+		/* hashed buffered write serialization */
+		struct io_wq_hash		*hash_map;
+
+		/* Only used for accounting purposes */
+		struct user_struct		*user;
+		struct mm_struct		*mm_account;
+
+		/* ctx exit and cancelation */
+		struct llist_head		fallback_llist;
+		struct delayed_work		fallback_work;
+		struct work_struct		exit_work;
+		struct list_head		tctx_list;
+		struct completion		ref_comp;
+		u32				iowq_limits[2];
+		bool				iowq_limits_set;
+	};
+};
+
+struct io_uring_task {
+	/* submission side */
+	int			cached_refs;
+	struct xarray		xa;
+	struct wait_queue_head	wait;
+	const struct io_ring_ctx *last;
+	struct io_wq		*io_wq;
+	struct percpu_counter	inflight;
+	atomic_t		inflight_tracked;
+	atomic_t		in_idle;
+
+	spinlock_t		task_lock;
+	struct io_wq_work_list	task_list;
+	struct callback_head	task_work;
+	bool			task_running;
+};
+
+/*
+ * First field must be the file pointer in all the
+ * iocb unions! See also 'struct kiocb' in <linux/fs.h>
+ */
+struct io_poll_iocb {
+	struct file			*file;
+	struct wait_queue_head		*head;
+	__poll_t			events;
+	struct wait_queue_entry		wait;
+};
+
+struct io_poll_update {
+	struct file			*file;
+	u64				old_user_data;
+	u64				new_user_data;
+	__poll_t			events;
+	bool				update_events;
+	bool				update_user_data;
+};
+
+struct io_close {
+	struct file			*file;
+	int				fd;
+	u32				file_slot;
+};
+
+struct io_timeout_data {
+	struct io_kiocb			*req;
+	struct hrtimer			timer;
+	struct timespec64		ts;
+	enum hrtimer_mode		mode;
+	u32				flags;
+};
+
+struct io_accept {
+	struct file			*file;
+	struct sockaddr __user		*addr;
+	int __user			*addr_len;
+	int				flags;
+	u32				file_slot;
+	unsigned long			nofile;
+};
+
+struct io_sync {
+	struct file			*file;
+	loff_t				len;
+	loff_t				off;
+	int				flags;
+	int				mode;
+};
+
+struct io_cancel {
+	struct file			*file;
+	u64				addr;
+};
+
+struct io_timeout {
+	struct file			*file;
+	u32				off;
+	u32				target_seq;
+	struct list_head		list;
+	/* head of the link, used by linked timeouts only */
+	struct io_kiocb			*head;
+	/* for linked completions */
+	struct io_kiocb			*prev;
+};
+
+struct io_timeout_rem {
+	struct file			*file;
+	u64				addr;
+
+	/* timeout update */
+	struct timespec64		ts;
+	u32				flags;
+	bool				ltimeout;
+};
+
+struct io_rw {
+	/* NOTE: kiocb has the file as the first member, so don't do it here */
+	struct kiocb			kiocb;
+	u64				addr;
+	u64				len;
+};
+
+struct io_connect {
+	struct file			*file;
+	struct sockaddr __user		*addr;
+	int				addr_len;
+};
+
+struct io_sr_msg {
+	struct file			*file;
+	union {
+		struct compat_msghdr __user	*umsg_compat;
+		struct user_msghdr __user	*umsg;
+		void __user			*buf;
+	};
+	int				msg_flags;
+	int				bgid;
+	size_t				len;
+	struct io_buffer		*kbuf;
+};
+
+struct io_open {
+	struct file			*file;
+	int				dfd;
+	u32				file_slot;
+	struct filename			*filename;
+	struct open_how			how;
+	unsigned long			nofile;
+};
+
+struct io_rsrc_update {
+	struct file			*file;
+	u64				arg;
+	u32				nr_args;
+	u32				offset;
+};
+
+struct io_fadvise {
+	struct file			*file;
+	u64				offset;
+	u32				len;
+	u32				advice;
+};
+
+struct io_madvise {
+	struct file			*file;
+	u64				addr;
+	u32				len;
+	u32				advice;
+};
+
+struct io_epoll {
+	struct file			*file;
+	int				epfd;
+	int				op;
+	int				fd;
+	struct epoll_event		event;
+};
+
+struct io_splice {
+	struct file			*file_out;
+	loff_t				off_out;
+	loff_t				off_in;
+	u64				len;
+	int				splice_fd_in;
+	unsigned int			flags;
+};
+
+struct io_provide_buf {
+	struct file			*file;
+	__u64				addr;
+	__u32				len;
+	__u32				bgid;
+	__u16				nbufs;
+	__u16				bid;
+};
+
+struct io_statx {
+	struct file			*file;
+	int				dfd;
+	unsigned int			mask;
+	unsigned int			flags;
+	const char __user		*filename;
+	struct statx __user		*buffer;
+};
+
+struct io_shutdown {
+	struct file			*file;
+	int				how;
+};
+
+struct io_rename {
+	struct file			*file;
+	int				old_dfd;
+	int				new_dfd;
+	struct filename			*oldpath;
+	struct filename			*newpath;
+	int				flags;
+};
+
+struct io_unlink {
+	struct file			*file;
+	int				dfd;
+	int				flags;
+	struct filename			*filename;
+};
+
+struct io_mkdir {
+	struct file			*file;
+	int				dfd;
+	umode_t				mode;
+	struct filename			*filename;
+};
+
+struct io_symlink {
+	struct file			*file;
+	int				new_dfd;
+	struct filename			*oldpath;
+	struct filename			*newpath;
+};
+
+struct io_hardlink {
+	struct file			*file;
+	int				old_dfd;
+	int				new_dfd;
+	struct filename			*oldpath;
+	struct filename			*newpath;
+	int				flags;
+};
+
+struct io_completion {
+	struct file			*file;
+	u32				cflags;
+};
+
+struct io_async_connect {
+	struct sockaddr_storage		address;
+};
+
+struct io_async_msghdr {
+	struct iovec			fast_iov[UIO_FASTIOV];
+	/* points to an allocated iov, if NULL we use fast_iov instead */
+	struct iovec			*free_iov;
+	struct sockaddr __user		*uaddr;
+	struct msghdr			msg;
+	struct sockaddr_storage		addr;
+};
+
+struct io_async_rw {
+	struct iovec			fast_iov[UIO_FASTIOV];
+	const struct iovec		*free_iovec;
+	struct iov_iter			iter;
+	struct iov_iter_state		iter_state;
+	size_t				bytes_done;
+	struct wait_page_queue		wpq;
+};
+
+enum {
+	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
+	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
+	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
+	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
+	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
+	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+
+	/* first byte is taken by user flags, shift it to not overlap */
+	REQ_F_FAIL_BIT		= 8,
+	REQ_F_INFLIGHT_BIT,
+	REQ_F_CUR_POS_BIT,
+	REQ_F_NOWAIT_BIT,
+	REQ_F_LINK_TIMEOUT_BIT,
+	REQ_F_NEED_CLEANUP_BIT,
+	REQ_F_POLLED_BIT,
+	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_COMPLETE_INLINE_BIT,
+	REQ_F_REISSUE_BIT,
+	REQ_F_CREDS_BIT,
+	REQ_F_REFCOUNT_BIT,
+	REQ_F_ARM_LTIMEOUT_BIT,
+	/* keep async read/write and isreg together and in order */
+	REQ_F_NOWAIT_READ_BIT,
+	REQ_F_NOWAIT_WRITE_BIT,
+	REQ_F_ISREG_BIT,
+
+	/* not a real bit, just to check we're not overflowing the space */
+	__REQ_F_LAST_BIT,
+};
+
+enum {
+	/* ctx owns file */
+	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),
+	/* drain existing IO first */
+	REQ_F_IO_DRAIN		= BIT(REQ_F_IO_DRAIN_BIT),
+	/* linked sqes */
+	REQ_F_LINK		= BIT(REQ_F_LINK_BIT),
+	/* doesn't sever on completion < 0 */
+	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
+	/* IOSQE_ASYNC */
+	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
+	/* IOSQE_BUFFER_SELECT */
+	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
+
+	/* fail rest of links */
+	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
+	/* on inflight list, should be cancelled and waited on exit reliably */
+	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
+	/* read/write uses file position */
+	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
+	/* must not punt to workers */
+	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
+	/* has or had linked timeout */
+	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
+	/* needs cleanup */
+	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
+	/* already went through poll handler */
+	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	/* buffer already selected */
+	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* completion is deferred through io_comp_state */
+	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
+	/* caller should reissue async */
+	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
+	/* supports async reads */
+	REQ_F_NOWAIT_READ	= BIT(REQ_F_NOWAIT_READ_BIT),
+	/* supports async writes */
+	REQ_F_NOWAIT_WRITE	= BIT(REQ_F_NOWAIT_WRITE_BIT),
+	/* regular file */
+	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
+	/* has creds assigned */
+	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
+	/* skip refcounting if not set */
+	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
+	/* there is a linked timeout that has to be armed */
+	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+};
+
+struct async_poll {
+	struct io_poll_iocb	poll;
+	struct io_poll_iocb	*double_poll;
+};
+
+typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
+
+struct io_task_work {
+	union {
+		struct io_wq_work_node	node;
+		struct llist_node	fallback_node;
+	};
+	io_req_tw_func_t		func;
+};
+
+enum {
+	IORING_RSRC_FILE		= 0,
+	IORING_RSRC_BUFFER		= 1,
+};
+
+/*
+ * NOTE! Each of the iocb union members has the file pointer
+ * as the first entry in their struct definition. So you can
+ * access the file pointer through any of the sub-structs,
+ * or directly as just 'ki_filp' in this struct.
+ */
+struct io_kiocb {
+	union {
+		struct file		*file;
+		struct io_rw		rw;
+		struct io_poll_iocb	poll;
+		struct io_poll_update	poll_update;
+		struct io_accept	accept;
+		struct io_sync		sync;
+		struct io_cancel	cancel;
+		struct io_timeout	timeout;
+		struct io_timeout_rem	timeout_rem;
+		struct io_connect	connect;
+		struct io_sr_msg	sr_msg;
+		struct io_open		open;
+		struct io_close		close;
+		struct io_rsrc_update	rsrc_update;
+		struct io_fadvise	fadvise;
+		struct io_madvise	madvise;
+		struct io_epoll		epoll;
+		struct io_splice	splice;
+		struct io_provide_buf	pbuf;
+		struct io_statx		statx;
+		struct io_shutdown	shutdown;
+		struct io_rename	rename;
+		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
+		struct io_symlink	symlink;
+		struct io_hardlink	hardlink;
+		/* use only after cleaning per-op data, see io_clean_op() */
+		struct io_completion	compl;
+	};
+
+	/* opcode allocated if it needs to store data for async defer */
+	void				*async_data;
+	u8				opcode;
+	/* polled IO has completed */
+	u8				iopoll_completed;
+
+	u16				buf_index;
+	u32				result;
+
+	struct io_ring_ctx		*ctx;
+	unsigned int			flags;
+	atomic_t			refs;
+	struct task_struct		*task;
+	u64				user_data;
+
+	struct io_kiocb			*link;
+	struct percpu_ref		*fixed_rsrc_refs;
+
+	/* used with ctx->iopoll_list with reads/writes */
+	struct list_head		inflight_entry;
+	struct io_task_work		io_task_work;
+	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
+	struct hlist_node		hash_node;
+	struct async_poll		*apoll;
+	struct io_wq_work		work;
+	const struct cred		*creds;
+
+	/* store used ubuf, so we can prevent reloading */
+	struct io_mapped_ubuf		*imu;
+	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
+	struct io_buffer		*kbuf;
+	atomic_t			poll_refs;
+};
+
+struct io_tctx_node {
+	struct list_head	ctx_node;
+	struct task_struct	*task;
+	struct io_ring_ctx	*ctx;
+};
+
+struct io_defer_entry {
+	struct list_head	list;
+	struct io_kiocb		*req;
+	u32			seq;
+};
+
+struct io_op_def {
+	/* needs req->file assigned */
+	unsigned		needs_file : 1;
+	/* hash wq insertion if file is a regular file */
+	unsigned		hash_reg_file : 1;
+	/* unbound wq insertion if file is a non-regular file */
+	unsigned		unbound_nonreg_file : 1;
+	/* opcode is not supported by this kernel */
+	unsigned		not_supported : 1;
+	/* set if opcode supports polled "wait" */
+	unsigned		pollin : 1;
+	unsigned		pollout : 1;
+	/* op supports buffer selection */
+	unsigned		buffer_select : 1;
+	/* do prep async if is going to be punted */
+	unsigned		needs_async_setup : 1;
+	/* should block plug */
+	unsigned		plug : 1;
+	/* size of async data needed, if any */
+	unsigned short		async_size;
+};
+
+static const struct io_op_def io_op_defs[] = {
+	[IORING_OP_NOP] = {},
+	[IORING_OP_READV] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.needs_async_setup	= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+	},
+	[IORING_OP_WRITEV] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.needs_async_setup	= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+	},
+	[IORING_OP_FSYNC] = {
+		.needs_file		= 1,
+	},
+	[IORING_OP_READ_FIXED] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+	},
+	[IORING_OP_WRITE_FIXED] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+	},
+	[IORING_OP_POLL_ADD] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	[IORING_OP_POLL_REMOVE] = {},
+	[IORING_OP_SYNC_FILE_RANGE] = {
+		.needs_file		= 1,
+	},
+	[IORING_OP_SENDMSG] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.needs_async_setup	= 1,
+		.async_size		= sizeof(struct io_async_msghdr),
+	},
+	[IORING_OP_RECVMSG] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.needs_async_setup	= 1,
+		.async_size		= sizeof(struct io_async_msghdr),
+	},
+	[IORING_OP_TIMEOUT] = {
+		.async_size		= sizeof(struct io_timeout_data),
+	},
+	[IORING_OP_TIMEOUT_REMOVE] = {
+		/* used by timeout updates' prep() */
+	},
+	[IORING_OP_ACCEPT] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+	},
+	[IORING_OP_ASYNC_CANCEL] = {},
+	[IORING_OP_LINK_TIMEOUT] = {
+		.async_size		= sizeof(struct io_timeout_data),
+	},
+	[IORING_OP_CONNECT] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.needs_async_setup	= 1,
+		.async_size		= sizeof(struct io_async_connect),
+	},
+	[IORING_OP_FALLOCATE] = {
+		.needs_file		= 1,
+	},
+	[IORING_OP_OPENAT] = {},
+	[IORING_OP_CLOSE] = {},
+	[IORING_OP_FILES_UPDATE] = {},
+	[IORING_OP_STATX] = {},
+	[IORING_OP_READ] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+	},
+	[IORING_OP_WRITE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.plug			= 1,
+		.async_size		= sizeof(struct io_async_rw),
+	},
+	[IORING_OP_FADVISE] = {
+		.needs_file		= 1,
+	},
+	[IORING_OP_MADVISE] = {},
+	[IORING_OP_SEND] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+	},
+	[IORING_OP_RECV] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+	},
+	[IORING_OP_OPENAT2] = {
+	},
+	[IORING_OP_EPOLL_CTL] = {
+		.unbound_nonreg_file	= 1,
+	},
+	[IORING_OP_SPLICE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	[IORING_OP_PROVIDE_BUFFERS] = {},
+	[IORING_OP_REMOVE_BUFFERS] = {},
+	[IORING_OP_TEE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	[IORING_OP_SHUTDOWN] = {
+		.needs_file		= 1,
+	},
+	[IORING_OP_RENAMEAT] = {},
+	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_MKDIRAT] = {},
+	[IORING_OP_SYMLINKAT] = {},
+	[IORING_OP_LINKAT] = {},
+};
+
+/* requests with any of those set should undergo io_disarm_next() */
+#define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
+
+static bool io_disarm_next(struct io_kiocb *req);
+static void io_uring_del_tctx_node(unsigned long index);
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 bool cancel_all);
+static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
+
+static void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags);
+
+static void io_put_req(struct io_kiocb *req);
+static void io_put_req_deferred(struct io_kiocb *req);
+static void io_dismantle_req(struct io_kiocb *req);
+static void io_queue_linked_timeout(struct io_kiocb *req);
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
+				     struct io_uring_rsrc_update2 *up,
+				     unsigned nr_args);
+static void io_clean_op(struct io_kiocb *req);
+static struct file *io_file_get(struct io_ring_ctx *ctx,
+				struct io_kiocb *req, int fd, bool fixed);
+static void __io_queue_sqe(struct io_kiocb *req);
+static void io_rsrc_put_work(struct work_struct *work);
+
+static void io_req_task_queue(struct io_kiocb *req);
+static void io_submit_flush_completions(struct io_ring_ctx *ctx);
+static int io_req_prep_async(struct io_kiocb *req);
+
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags, u32 slot_index);
+static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
+
+static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
+
+static struct kmem_cache *req_cachep;
+
+static const struct file_operations io_uring_fops;
+
+struct sock *io_uring_get_socket(struct file *file)
+{
+#if defined(CONFIG_UNIX)
+	if (file->f_op == &io_uring_fops) {
+		struct io_ring_ctx *ctx = file->private_data;
+
+		return ctx->ring_sock->sk;
+	}
+#endif
+	return NULL;
+}
+EXPORT_SYMBOL(io_uring_get_socket);
+
+static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
+{
+	if (!*locked) {
+		mutex_lock(&ctx->uring_lock);
+		*locked = true;
+	}
+}
+
+#define io_for_each_link(pos, head) \
+	for (pos = (head); pos; pos = pos->link)
+
+/*
+ * Shamelessly stolen from the mm implementation of page reference checking,
+ * see commit f958d7b528b1 for details.
+ */
+#define req_ref_zero_or_close_to_overflow(req)	\
+	((unsigned int) atomic_read(&(req->refs)) + 127u <= 127u)
+
+static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
+	return atomic_inc_not_zero(&req->refs);
+}
+
+static inline bool req_ref_put_and_test(struct io_kiocb *req)
+{
+	if (likely(!(req->flags & REQ_F_REFCOUNT)))
+		return true;
+
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	return atomic_dec_and_test(&req->refs);
+}
+
+static inline void req_ref_get(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	atomic_inc(&req->refs);
+}
+
+static inline void __io_req_set_refcount(struct io_kiocb *req, int nr)
+{
+	if (!(req->flags & REQ_F_REFCOUNT)) {
+		req->flags |= REQ_F_REFCOUNT;
+		atomic_set(&req->refs, nr);
+	}
+}
+
+static inline void io_req_set_refcount(struct io_kiocb *req)
+{
+	__io_req_set_refcount(req, 1);
+}
+
+static inline void io_req_set_rsrc_node(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!req->fixed_rsrc_refs) {
+		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
+		percpu_ref_get(req->fixed_rsrc_refs);
+	}
+}
+
+static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
+{
+	bool got = percpu_ref_tryget(ref);
+
+	/* already at zero, wait for ->release() */
+	if (!got)
+		wait_for_completion(compl);
+	percpu_ref_resurrect(ref);
+	if (got)
+		percpu_ref_put(ref);
+}
+
+static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
+			  bool cancel_all)
+	__must_hold(&req->ctx->timeout_lock)
+{
+	struct io_kiocb *req;
+
+	if (task && head->task != task)
+		return false;
+	if (cancel_all)
+		return true;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * As io_match_task() but protected against racing with linked timeouts.
+ * User must not hold timeout_lock.
+ */
+static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
+			       bool cancel_all)
+{
+	bool matched;
+
+	if (task && head->task != task)
+		return false;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
+}
+
+static inline void req_set_fail(struct io_kiocb *req)
+{
+	req->flags |= REQ_F_FAIL;
+}
+
+static inline void req_fail_link_node(struct io_kiocb *req, int res)
+{
+	req_set_fail(req);
+	req->result = res;
+}
+
+static void io_ring_ctx_ref_free(struct percpu_ref *ref)
+{
+	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
+
+	complete(&ctx->ref_comp);
+}
+
+static inline bool io_is_timeout_noseq(struct io_kiocb *req)
+{
+	return !req->timeout.off;
+}
+
+static void io_fallback_req_func(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
+						fallback_work.work);
+	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
+	struct io_kiocb *req, *tmp;
+	bool locked = false;
+
+	percpu_ref_get(&ctx->refs);
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
+		req->io_task_work.func(req, &locked);
+
+	if (locked) {
+		if (ctx->submit_state.compl_nr)
+			io_submit_flush_completions(ctx);
+		mutex_unlock(&ctx->uring_lock);
+	}
+	percpu_ref_put(&ctx->refs);
+
+}
+
+static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
+{
+	struct io_ring_ctx *ctx;
+	int hash_bits;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	/*
+	 * Use 5 bits less than the max cq entries, that should give us around
+	 * 32 entries per hash list if totally full and uniformly spread.
+	 */
+	hash_bits = ilog2(p->cq_entries);
+	hash_bits -= 5;
+	if (hash_bits <= 0)
+		hash_bits = 1;
+	ctx->cancel_hash_bits = hash_bits;
+	ctx->cancel_hash = kmalloc((1U << hash_bits) * sizeof(struct hlist_head),
+					GFP_KERNEL);
+	if (!ctx->cancel_hash)
+		goto err;
+	__hash_init(ctx->cancel_hash, 1U << hash_bits);
+
+	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
+	if (!ctx->dummy_ubuf)
+		goto err;
+	/* set invalid range, so io_import_fixed() fails meeting it */
+	ctx->dummy_ubuf->ubuf = -1UL;
+
+	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+		goto err;
+
+	ctx->flags = p->flags;
+	init_waitqueue_head(&ctx->sqo_sq_wait);
+	INIT_LIST_HEAD(&ctx->sqd_list);
+	init_waitqueue_head(&ctx->poll_wait);
+	INIT_LIST_HEAD(&ctx->cq_overflow_list);
+	init_completion(&ctx->ref_comp);
+	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
+	mutex_init(&ctx->uring_lock);
+	init_waitqueue_head(&ctx->cq_wait);
+	spin_lock_init(&ctx->completion_lock);
+	spin_lock_init(&ctx->timeout_lock);
+	INIT_LIST_HEAD(&ctx->iopoll_list);
+	INIT_LIST_HEAD(&ctx->defer_list);
+	INIT_LIST_HEAD(&ctx->timeout_list);
+	INIT_LIST_HEAD(&ctx->ltimeout_list);
+	spin_lock_init(&ctx->rsrc_ref_lock);
+	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
+	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
+	init_llist_head(&ctx->rsrc_put_llist);
+	INIT_LIST_HEAD(&ctx->tctx_list);
+	INIT_LIST_HEAD(&ctx->submit_state.free_list);
+	INIT_LIST_HEAD(&ctx->locked_free_list);
+	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
+	return ctx;
+err:
+	kfree(ctx->dummy_ubuf);
+	kfree(ctx->cancel_hash);
+	kfree(ctx);
+	return NULL;
+}
+
+static void io_account_cq_overflow(struct io_ring_ctx *ctx)
+{
+	struct io_rings *r = ctx->rings;
+
+	WRITE_ONCE(r->cq_overflow, READ_ONCE(r->cq_overflow) + 1);
+	ctx->cq_extra--;
+}
+
+static bool req_need_defer(struct io_kiocb *req, u32 seq)
+{
+	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
+	}
+
+	return false;
+}
+
+#define FFS_ASYNC_READ		0x1UL
+#define FFS_ASYNC_WRITE		0x2UL
+#ifdef CONFIG_64BIT
+#define FFS_ISREG		0x4UL
+#else
+#define FFS_ISREG		0x0UL
+#endif
+#define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
+
+static inline bool io_req_ffs_set(struct io_kiocb *req)
+{
+	return IS_ENABLED(CONFIG_64BIT) && (req->flags & REQ_F_FIXED_FILE);
+}
+
+static void io_req_track_inflight(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_INFLIGHT)) {
+		req->flags |= REQ_F_INFLIGHT;
+		atomic_inc(&req->task->io_uring->inflight_tracked);
+	}
+}
+
+static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
+{
+	if (WARN_ON_ONCE(!req->link))
+		return NULL;
+
+	req->flags &= ~REQ_F_ARM_LTIMEOUT;
+	req->flags |= REQ_F_LINK_TIMEOUT;
+
+	/* linked timeouts should have two refs once prep'ed */
+	io_req_set_refcount(req);
+	__io_req_set_refcount(req->link, 2);
+	return req->link;
+}
+
+static inline struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
+{
+	if (likely(!(req->flags & REQ_F_ARM_LTIMEOUT)))
+		return NULL;
+	return __io_prep_linked_timeout(req);
+}
+
+static void io_prep_async_work(struct io_kiocb *req)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!(req->flags & REQ_F_CREDS)) {
+		req->flags |= REQ_F_CREDS;
+		req->creds = get_current_cred();
+	}
+
+	req->work.list.next = NULL;
+	req->work.flags = 0;
+	if (req->flags & REQ_F_FORCE_ASYNC)
+		req->work.flags |= IO_WQ_WORK_CONCURRENT;
+
+	if (req->flags & REQ_F_ISREG) {
+		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
+			io_wq_hash_work(&req->work, file_inode(req->file));
+	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
+		if (def->unbound_nonreg_file)
+			req->work.flags |= IO_WQ_WORK_UNBOUND;
+	}
+}
+
+static void io_prep_async_link(struct io_kiocb *req)
+{
+	struct io_kiocb *cur;
+
+	if (req->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->timeout_lock);
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+	}
+}
+
+static void io_queue_async_work(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *link = io_prep_linked_timeout(req);
+	struct io_uring_task *tctx = req->task->io_uring;
+
+	/* must not take the lock, NULL it as a precaution */
+	locked = NULL;
+
+	BUG_ON(!tctx);
+	BUG_ON(!tctx->io_wq);
+
+	/* init ->work of the whole link before punting */
+	io_prep_async_link(req);
+
+	/*
+	 * Not expected to happen, but if we do have a bug where this _can_
+	 * happen, catch it here and ensure the request is marked as
+	 * canceled. That will make io-wq go through the usual work cancel
+	 * procedure rather than attempt to run this request (or create a new
+	 * worker for it).
+	 */
+	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
+		req->work.flags |= IO_WQ_WORK_CANCEL;
+
+	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
+					&req->work, req->flags);
+	io_wq_enqueue(tctx->io_wq, &req->work);
+	if (link)
+		io_queue_linked_timeout(link);
+}
+
+static void io_kill_timeout(struct io_kiocb *req, int status)
+	__must_hold(&req->ctx->completion_lock)
+	__must_hold(&req->ctx->timeout_lock)
+{
+	struct io_timeout_data *io = req->async_data;
+
+	if (hrtimer_try_to_cancel(&io->timer) != -1) {
+		if (status)
+			req_set_fail(req);
+		atomic_set(&req->ctx->cq_timeouts,
+			atomic_read(&req->ctx->cq_timeouts) + 1);
+		list_del_init(&req->timeout.list);
+		io_fill_cqe_req(req, status, 0);
+		io_put_req_deferred(req);
+	}
+}
+
+static void io_queue_deferred(struct io_ring_ctx *ctx)
+{
+	while (!list_empty(&ctx->defer_list)) {
+		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
+						struct io_defer_entry, list);
+
+		if (req_need_defer(de->req, de->seq))
+			break;
+		list_del_init(&de->list);
+		io_req_task_queue(de->req);
+		kfree(de);
+	}
+}
+
+static void io_flush_timeouts(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->completion_lock)
+{
+	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	struct io_kiocb *req, *tmp;
+
+	spin_lock_irq(&ctx->timeout_lock);
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
+		u32 events_needed, events_got;
+
+		if (io_is_timeout_noseq(req))
+			break;
+
+		/*
+		 * Since seq can easily wrap around over time, subtract
+		 * the last seq at which timeouts were flushed before comparing.
+		 * Assuming not more than 2^31-1 events have happened since,
+		 * these subtractions won't have wrapped, so we can check if
+		 * target is in [last_seq, current_seq] by comparing the two.
+		 */
+		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
+		events_got = seq - ctx->cq_last_tm_flush;
+		if (events_got < events_needed)
+			break;
+
+		io_kill_timeout(req, 0);
+	}
+	ctx->cq_last_tm_flush = seq;
+	spin_unlock_irq(&ctx->timeout_lock);
+}
+
+static void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
+{
+	if (ctx->off_timeout_used)
+		io_flush_timeouts(ctx);
+	if (ctx->drain_active)
+		io_queue_deferred(ctx);
+}
+
+static inline void io_commit_cqring(struct io_ring_ctx *ctx)
+{
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
+		__io_commit_cqring_flush(ctx);
+	/* order cqe stores with ring update */
+	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
+}
+
+static inline bool io_sqring_full(struct io_ring_ctx *ctx)
+{
+	struct io_rings *r = ctx->rings;
+
+	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == ctx->sq_entries;
+}
+
+static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
+{
+	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+}
+
+static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = ctx->rings;
+	unsigned tail, mask = ctx->cq_entries - 1;
+
+	/*
+	 * writes to the cq entry need to come after reading head; the
+	 * control dependency is enough as we're using WRITE_ONCE to
+	 * fill the cq entry
+	 */
+	if (__io_cqring_events(ctx) == ctx->cq_entries)
+		return NULL;
+
+	tail = ctx->cached_cq_tail++;
+	return &rings->cqes[tail & mask];
+}
+
+static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
+{
+	if (likely(!ctx->cq_ev_fd))
+		return false;
+	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return false;
+	return !ctx->eventfd_async || io_wq_current_is_worker();
+}
+
+/*
+ * This should only get called when at least one event has been posted.
+ * Some applications rely on the eventfd notification count only changing
+ * IFF a new CQE has been added to the CQ ring. There's no depedency on
+ * 1:1 relationship between how many times this function is called (and
+ * hence the eventfd count) and number of CQEs posted to the CQ ring.
+ */
+static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+{
+	/*
+	 * wake_up_all() may seem excessive, but io_wake_function() and
+	 * io_should_wake() handle the termination of the loop and only
+	 * wake as many waiters as we need to.
+	 */
+	if (wq_has_sleeper(&ctx->cq_wait))
+		wake_up_all(&ctx->cq_wait);
+	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
+		wake_up(&ctx->sq_data->wait);
+	if (io_should_trigger_evfd(ctx))
+		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (waitqueue_active(&ctx->poll_wait))
+		wake_up_interruptible(&ctx->poll_wait);
+}
+
+static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
+{
+	/* see waitqueue_active() comment */
+	smp_mb();
+
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		if (waitqueue_active(&ctx->cq_wait))
+			wake_up_all(&ctx->cq_wait);
+	}
+	if (io_should_trigger_evfd(ctx))
+		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (waitqueue_active(&ctx->poll_wait))
+		wake_up_interruptible(&ctx->poll_wait);
+}
+
+/* Returns true if there are no backlogged entries after the flush */
+static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
+{
+	bool all_flushed, posted;
+
+	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
+		return false;
+
+	posted = false;
+	spin_lock(&ctx->completion_lock);
+	while (!list_empty(&ctx->cq_overflow_list)) {
+		struct io_uring_cqe *cqe = io_get_cqe(ctx);
+		struct io_overflow_cqe *ocqe;
+
+		if (!cqe && !force)
+			break;
+		ocqe = list_first_entry(&ctx->cq_overflow_list,
+					struct io_overflow_cqe, list);
+		if (cqe)
+			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
+		else
+			io_account_cq_overflow(ctx);
+
+		posted = true;
+		list_del(&ocqe->list);
+		kfree(ocqe);
+	}
+
+	all_flushed = list_empty(&ctx->cq_overflow_list);
+	if (all_flushed) {
+		clear_bit(0, &ctx->check_cq_overflow);
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
+	}
+
+	if (posted)
+		io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	if (posted)
+		io_cqring_ev_posted(ctx);
+	return all_flushed;
+}
+
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
+{
+	bool ret = true;
+
+	if (test_bit(0, &ctx->check_cq_overflow)) {
+		/* iopoll syncs against uring_lock, not completion_lock */
+		if (ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_lock(&ctx->uring_lock);
+		ret = __io_cqring_overflow_flush(ctx, false);
+		if (ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_unlock(&ctx->uring_lock);
+	}
+
+	return ret;
+}
+
+/* must to be called somewhat shortly after putting a request */
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	struct io_uring_task *tctx = task->io_uring;
+
+	if (likely(task == current)) {
+		tctx->cached_refs += nr;
+	} else {
+		percpu_counter_sub(&tctx->inflight, nr);
+		if (unlikely(atomic_read(&tctx->in_idle)))
+			wake_up(&tctx->wait);
+		put_task_struct_many(task, nr);
+	}
+}
+
+static void io_task_refs_refill(struct io_uring_task *tctx)
+{
+	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
+
+	percpu_counter_add(&tctx->inflight, refill);
+	refcount_add(refill, &current->usage);
+	tctx->cached_refs += refill;
+}
+
+static inline void io_get_task_refs(int nr)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	tctx->cached_refs -= nr;
+	if (unlikely(tctx->cached_refs < 0))
+		io_task_refs_refill(tctx);
+}
+
+static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
+{
+	struct io_uring_task *tctx = task->io_uring;
+	unsigned int refs = tctx->cached_refs;
+
+	if (refs) {
+		tctx->cached_refs = 0;
+		percpu_counter_sub(&tctx->inflight, refs);
+		put_task_struct_many(task, refs);
+	}
+}
+
+static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
+				     s32 res, u32 cflags)
+{
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
+	if (!ocqe) {
+		/*
+		 * If we're in ring overflow flush mode, or in task cancel mode,
+		 * or cannot allocate an overflow entry, then we need to drop it
+		 * on the floor.
+		 */
+		io_account_cq_overflow(ctx);
+		return false;
+	}
+	if (list_empty(&ctx->cq_overflow_list)) {
+		set_bit(0, &ctx->check_cq_overflow);
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
+
+	}
+	ocqe->cqe.user_data = user_data;
+	ocqe->cqe.res = res;
+	ocqe->cqe.flags = cflags;
+	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
+	return true;
+}
+
+static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+				 s32 res, u32 cflags)
+{
+	struct io_uring_cqe *cqe;
+
+	trace_io_uring_complete(ctx, user_data, res, cflags);
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe = io_get_cqe(ctx);
+	if (likely(cqe)) {
+		WRITE_ONCE(cqe->user_data, user_data);
+		WRITE_ONCE(cqe->res, res);
+		WRITE_ONCE(cqe->flags, cflags);
+		return true;
+	}
+	return io_cqring_event_overflow(ctx, user_data, res, cflags);
+}
+
+static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
+{
+	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
+}
+
+static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
+				     s32 res, u32 cflags)
+{
+	ctx->cq_extra++;
+	return __io_fill_cqe(ctx, user_data, res, cflags);
+}
+
+static void io_req_complete_post(struct io_kiocb *req, s32 res,
+				 u32 cflags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock(&ctx->completion_lock);
+	__io_fill_cqe(ctx, req->user_data, res, cflags);
+	/*
+	 * If we're the last reference to this request, add to our locked
+	 * free_list cache.
+	 */
+	if (req_ref_put_and_test(req)) {
+		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+			if (req->flags & IO_DISARM_MASK)
+				io_disarm_next(req);
+			if (req->link) {
+				io_req_task_queue(req->link);
+				req->link = NULL;
+			}
+		}
+		io_dismantle_req(req);
+		io_put_task(req->task, 1);
+		list_add(&req->inflight_entry, &ctx->locked_free_list);
+		ctx->locked_free_nr++;
+	} else {
+		if (!percpu_ref_tryget(&ctx->refs))
+			req = NULL;
+	}
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+
+	if (req) {
+		io_cqring_ev_posted(ctx);
+		percpu_ref_put(&ctx->refs);
+	}
+}
+
+static inline bool io_req_needs_clean(struct io_kiocb *req)
+{
+	return req->flags & IO_REQ_CLEAN_FLAGS;
+}
+
+static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
+					 u32 cflags)
+{
+	if (io_req_needs_clean(req))
+		io_clean_op(req);
+	req->result = res;
+	req->compl.cflags = cflags;
+	req->flags |= REQ_F_COMPLETE_INLINE;
+}
+
+static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
+				     s32 res, u32 cflags)
+{
+	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
+		io_req_complete_state(req, res, cflags);
+	else
+		io_req_complete_post(req, res, cflags);
+}
+
+static inline void io_req_complete(struct io_kiocb *req, s32 res)
+{
+	__io_req_complete(req, 0, res, 0);
+}
+
+static void io_req_complete_failed(struct io_kiocb *req, s32 res)
+{
+	req_set_fail(req);
+	io_req_complete_post(req, res, 0);
+}
+
+static void io_req_complete_fail_submit(struct io_kiocb *req)
+{
+	/*
+	 * We don't submit, fail them all, for that replace hardlinks with
+	 * normal links. Extra REQ_F_LINK is tolerated.
+	 */
+	req->flags &= ~REQ_F_HARDLINK;
+	req->flags |= REQ_F_LINK;
+	io_req_complete_failed(req, req->result);
+}
+
+/*
+ * Don't initialise the fields below on every allocation, but do that in
+ * advance and keep them valid across allocations.
+ */
+static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
+{
+	req->ctx = ctx;
+	req->link = NULL;
+	req->async_data = NULL;
+	/* not necessary, but safer to zero */
+	req->result = 0;
+}
+
+static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
+					struct io_submit_state *state)
+{
+	spin_lock(&ctx->completion_lock);
+	list_splice_init(&ctx->locked_free_list, &state->free_list);
+	ctx->locked_free_nr = 0;
+	spin_unlock(&ctx->completion_lock);
+}
+
+/* Returns true IFF there are requests in the cache */
+static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+	int nr;
+
+	/*
+	 * If we have more than a batch's worth of requests in our IRQ side
+	 * locked cache, grab the lock and move them over to our submission
+	 * side cache.
+	 */
+	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
+		io_flush_cached_locked_reqs(ctx, state);
+
+	nr = state->free_reqs;
+	while (!list_empty(&state->free_list)) {
+		struct io_kiocb *req = list_first_entry(&state->free_list,
+					struct io_kiocb, inflight_entry);
+
+		list_del(&req->inflight_entry);
+		state->reqs[nr++] = req;
+		if (nr == ARRAY_SIZE(state->reqs))
+			break;
+	}
+
+	state->free_reqs = nr;
+	return nr != 0;
+}
+
+/*
+ * A request might get retired back into the request caches even before opcode
+ * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
+ * Because of that, io_alloc_req() should be called only under ->uring_lock
+ * and with extra caution to not get a request that is still worked on.
+ */
+static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	int ret, i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
+
+	if (likely(state->free_reqs || io_flush_cached_reqs(ctx)))
+		goto got_req;
+
+	ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
+				    state->reqs);
+
+	/*
+	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
+	 * retry single alloc to be on the safe side.
+	 */
+	if (unlikely(ret <= 0)) {
+		state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
+		if (!state->reqs[0])
+			return NULL;
+		ret = 1;
+	}
+
+	for (i = 0; i < ret; i++)
+		io_preinit_req(state->reqs[i], ctx);
+	state->free_reqs = ret;
+got_req:
+	state->free_reqs--;
+	return state->reqs[state->free_reqs];
+}
+
+static inline void io_put_file(struct file *file)
+{
+	if (file)
+		fput(file);
+}
+
+static void io_dismantle_req(struct io_kiocb *req)
+{
+	unsigned int flags = req->flags;
+
+	if (io_req_needs_clean(req))
+		io_clean_op(req);
+	if (!(flags & REQ_F_FIXED_FILE))
+		io_put_file(req->file);
+	if (req->fixed_rsrc_refs)
+		percpu_ref_put(req->fixed_rsrc_refs);
+	if (req->async_data) {
+		kfree(req->async_data);
+		req->async_data = NULL;
+	}
+}
+
+static void __io_free_req(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_dismantle_req(req);
+	io_put_task(req->task, 1);
+
+	spin_lock(&ctx->completion_lock);
+	list_add(&req->inflight_entry, &ctx->locked_free_list);
+	ctx->locked_free_nr++;
+	spin_unlock(&ctx->completion_lock);
+
+	percpu_ref_put(&ctx->refs);
+}
+
+static inline void io_remove_next_linked(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt = req->link;
+
+	req->link = nxt->link;
+	nxt->link = NULL;
+}
+
+static bool io_kill_linked_timeout(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
+	__must_hold(&req->ctx->timeout_lock)
+{
+	struct io_kiocb *link = req->link;
+
+	if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
+		struct io_timeout_data *io = link->async_data;
+
+		io_remove_next_linked(req);
+		link->timeout.head = NULL;
+		if (hrtimer_try_to_cancel(&io->timer) != -1) {
+			list_del(&link->timeout.list);
+			io_fill_cqe_req(link, -ECANCELED, 0);
+			io_put_req_deferred(link);
+			return true;
+		}
+	}
+	return false;
+}
+
+static void io_fail_links(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
+{
+	struct io_kiocb *nxt, *link = req->link;
+
+	req->link = NULL;
+	while (link) {
+		long res = -ECANCELED;
+
+		if (link->flags & REQ_F_FAIL)
+			res = link->result;
+
+		nxt = link->link;
+		link->link = NULL;
+
+		trace_io_uring_fail_link(req, link);
+		io_fill_cqe_req(link, res, 0);
+		io_put_req_deferred(link);
+		link = nxt;
+	}
+}
+
+static bool io_disarm_next(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
+{
+	bool posted = false;
+
+	if (req->flags & REQ_F_ARM_LTIMEOUT) {
+		struct io_kiocb *link = req->link;
+
+		req->flags &= ~REQ_F_ARM_LTIMEOUT;
+		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
+			io_remove_next_linked(req);
+			io_fill_cqe_req(link, -ECANCELED, 0);
+			io_put_req_deferred(link);
+			posted = true;
+		}
+	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->timeout_lock);
+		posted = io_kill_linked_timeout(req);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
+	if (unlikely((req->flags & REQ_F_FAIL) &&
+		     !(req->flags & REQ_F_HARDLINK))) {
+		posted |= (req->link != NULL);
+		io_fail_links(req);
+	}
+	return posted;
+}
+
+static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt;
+
+	/*
+	 * If LINK is set, we have dependent requests in this chain. If we
+	 * didn't fail this request, queue the first one up, moving any other
+	 * dependencies to the next request. In case of failure, fail the rest
+	 * of the chain.
+	 */
+	if (req->flags & IO_DISARM_MASK) {
+		struct io_ring_ctx *ctx = req->ctx;
+		bool posted;
+
+		spin_lock(&ctx->completion_lock);
+		posted = io_disarm_next(req);
+		if (posted)
+			io_commit_cqring(req->ctx);
+		spin_unlock(&ctx->completion_lock);
+		if (posted)
+			io_cqring_ev_posted(ctx);
+	}
+	nxt = req->link;
+	req->link = NULL;
+	return nxt;
+}
+
+static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
+{
+	if (likely(!(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))))
+		return NULL;
+	return __io_req_find_next(req);
+}
+
+static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
+{
+	if (!ctx)
+		return;
+	if (*locked) {
+		if (ctx->submit_state.compl_nr)
+			io_submit_flush_completions(ctx);
+		mutex_unlock(&ctx->uring_lock);
+		*locked = false;
+	}
+	percpu_ref_put(&ctx->refs);
+}
+
+static void tctx_task_work(struct callback_head *cb)
+{
+	bool locked = false;
+	struct io_ring_ctx *ctx = NULL;
+	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
+						  task_work);
+
+	while (1) {
+		struct io_wq_work_node *node;
+
+		if (!tctx->task_list.first && locked && ctx->submit_state.compl_nr)
+			io_submit_flush_completions(ctx);
+
+		spin_lock_irq(&tctx->task_lock);
+		node = tctx->task_list.first;
+		INIT_WQ_LIST(&tctx->task_list);
+		if (!node)
+			tctx->task_running = false;
+		spin_unlock_irq(&tctx->task_lock);
+		if (!node)
+			break;
+
+		do {
+			struct io_wq_work_node *next = node->next;
+			struct io_kiocb *req = container_of(node, struct io_kiocb,
+							    io_task_work.node);
+
+			if (req->ctx != ctx) {
+				ctx_flush_and_put(ctx, &locked);
+				ctx = req->ctx;
+				/* if not contended, grab and improve batching */
+				locked = mutex_trylock(&ctx->uring_lock);
+				percpu_ref_get(&ctx->refs);
+			}
+			req->io_task_work.func(req, &locked);
+			node = next;
+		} while (node);
+
+		cond_resched();
+	}
+
+	ctx_flush_and_put(ctx, &locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
+}
+
+static void io_req_task_work_add(struct io_kiocb *req)
+{
+	struct task_struct *tsk = req->task;
+	struct io_uring_task *tctx = tsk->io_uring;
+	enum task_work_notify_mode notify;
+	struct io_wq_work_node *node;
+	unsigned long flags;
+	bool running;
+
+	WARN_ON_ONCE(!tctx);
+
+	spin_lock_irqsave(&tctx->task_lock, flags);
+	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	running = tctx->task_running;
+	if (!running)
+		tctx->task_running = true;
+	spin_unlock_irqrestore(&tctx->task_lock, flags);
+
+	/* task_work already pending, we're done */
+	if (running)
+		return;
+
+	/*
+	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
+	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
+	 * processing task_work. There's no reliable way to tell if TWA_RESUME
+	 * will do the job.
+	 */
+	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
+	if (!task_work_add(tsk, &tctx->task_work, notify)) {
+		wake_up_process(tsk);
+		return;
+	}
+
+	spin_lock_irqsave(&tctx->task_lock, flags);
+	tctx->task_running = false;
+	node = tctx->task_list.first;
+	INIT_WQ_LIST(&tctx->task_list);
+	spin_unlock_irqrestore(&tctx->task_lock, flags);
+
+	while (node) {
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		node = node->next;
+		if (llist_add(&req->io_task_work.fallback_node,
+			      &req->ctx->fallback_llist))
+			schedule_delayed_work(&req->ctx->fallback_work, 1);
+	}
+}
+
+static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	/* not needed for normal modes, but SQPOLL depends on it */
+	io_tw_lock(ctx, locked);
+	io_req_complete_failed(req, req->result);
+}
+
+static void io_req_task_submit(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_tw_lock(ctx, locked);
+	/* req->task == current here, checking PF_EXITING is safe */
+	if (likely(!(req->task->flags & PF_EXITING)))
+		__io_queue_sqe(req);
+	else
+		io_req_complete_failed(req, -EFAULT);
+}
+
+static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
+{
+	req->result = ret;
+	req->io_task_work.func = io_req_task_cancel;
+	io_req_task_work_add(req);
+}
+
+static void io_req_task_queue(struct io_kiocb *req)
+{
+	req->io_task_work.func = io_req_task_submit;
+	io_req_task_work_add(req);
+}
+
+static void io_req_task_queue_reissue(struct io_kiocb *req)
+{
+	req->io_task_work.func = io_queue_async_work;
+	io_req_task_work_add(req);
+}
+
+static inline void io_queue_next(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt = io_req_find_next(req);
+
+	if (nxt)
+		io_req_task_queue(nxt);
+}
+
+static void io_free_req(struct io_kiocb *req)
+{
+	io_queue_next(req);
+	__io_free_req(req);
+}
+
+static void io_free_req_work(struct io_kiocb *req, bool *locked)
+{
+	io_free_req(req);
+}
+
+struct req_batch {
+	struct task_struct	*task;
+	int			task_refs;
+	int			ctx_refs;
+};
+
+static inline void io_init_req_batch(struct req_batch *rb)
+{
+	rb->task_refs = 0;
+	rb->ctx_refs = 0;
+	rb->task = NULL;
+}
+
+static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
+				     struct req_batch *rb)
+{
+	if (rb->ctx_refs)
+		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
+	if (rb->task)
+		io_put_task(rb->task, rb->task_refs);
+}
+
+static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
+			      struct io_submit_state *state)
+{
+	io_queue_next(req);
+	io_dismantle_req(req);
+
+	if (req->task != rb->task) {
+		if (rb->task)
+			io_put_task(rb->task, rb->task_refs);
+		rb->task = req->task;
+		rb->task_refs = 0;
+	}
+	rb->task_refs++;
+	rb->ctx_refs++;
+
+	if (state->free_reqs != ARRAY_SIZE(state->reqs))
+		state->reqs[state->free_reqs++] = req;
+	else
+		list_add(&req->inflight_entry, &state->free_list);
+}
+
+static void io_submit_flush_completions(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+	int i, nr = state->compl_nr;
+	struct req_batch rb;
+
+	spin_lock(&ctx->completion_lock);
+	for (i = 0; i < nr; i++) {
+		struct io_kiocb *req = state->compl_reqs[i];
+
+		__io_fill_cqe(ctx, req->user_data, req->result,
+			      req->compl.cflags);
+	}
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+
+	io_init_req_batch(&rb);
+	for (i = 0; i < nr; i++) {
+		struct io_kiocb *req = state->compl_reqs[i];
+
+		if (req_ref_put_and_test(req))
+			io_req_free_batch(&rb, req, &ctx->submit_state);
+	}
+
+	io_req_free_batch_finish(ctx, &rb);
+	state->compl_nr = 0;
+}
+
+/*
+ * Drop reference to request, return next in chain (if there is one) if this
+ * was the last reference to this request.
+ */
+static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt = NULL;
+
+	if (req_ref_put_and_test(req)) {
+		nxt = io_req_find_next(req);
+		__io_free_req(req);
+	}
+	return nxt;
+}
+
+static inline void io_put_req(struct io_kiocb *req)
+{
+	if (req_ref_put_and_test(req))
+		io_free_req(req);
+}
+
+static inline void io_put_req_deferred(struct io_kiocb *req)
+{
+	if (req_ref_put_and_test(req)) {
+		req->io_task_work.func = io_free_req_work;
+		io_req_task_work_add(req);
+	}
+}
+
+static unsigned io_cqring_events(struct io_ring_ctx *ctx)
+{
+	/* See comment at the top of this file */
+	smp_rmb();
+	return __io_cqring_events(ctx);
+}
+
+static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = ctx->rings;
+
+	/* make sure SQ entry isn't read before tail */
+	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
+}
+
+static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
+{
+	unsigned int cflags;
+
+	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+	cflags |= IORING_CQE_F_BUFFER;
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	kfree(kbuf);
+	return cflags;
+}
+
+static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
+{
+	struct io_buffer *kbuf;
+
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return 0;
+	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+	return io_put_kbuf(req, kbuf);
+}
+
+static inline bool io_run_task_work(void)
+{
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
+		__set_current_state(TASK_RUNNING);
+		tracehook_notify_signal();
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Find and free completed poll iocbs
+ */
+static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
+			       struct list_head *done)
+{
+	struct req_batch rb;
+	struct io_kiocb *req;
+
+	/* order with ->result store in io_complete_rw_iopoll() */
+	smp_rmb();
+
+	io_init_req_batch(&rb);
+	while (!list_empty(done)) {
+		req = list_first_entry(done, struct io_kiocb, inflight_entry);
+		list_del(&req->inflight_entry);
+
+		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
+		(*nr_events)++;
+
+		if (req_ref_put_and_test(req))
+			io_req_free_batch(&rb, req, &ctx->submit_state);
+	}
+
+	io_commit_cqring(ctx);
+	io_cqring_ev_posted_iopoll(ctx);
+	io_req_free_batch_finish(ctx, &rb);
+}
+
+static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
+			long min)
+{
+	struct io_kiocb *req, *tmp;
+	LIST_HEAD(done);
+	bool spin;
+
+	/*
+	 * Only spin for completions if we don't have multiple devices hanging
+	 * off our complete list, and we're under the requested amount.
+	 */
+	spin = !ctx->poll_multi_queue && *nr_events < min;
+
+	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
+		struct kiocb *kiocb = &req->rw.kiocb;
+		int ret;
+
+		/*
+		 * Move completed and retryable entries to our local lists.
+		 * If we find a request that requires polling, break out
+		 * and complete those lists first, if we have entries there.
+		 */
+		if (READ_ONCE(req->iopoll_completed)) {
+			list_move_tail(&req->inflight_entry, &done);
+			continue;
+		}
+		if (!list_empty(&done))
+			break;
+
+		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
+		if (unlikely(ret < 0))
+			return ret;
+		else if (ret)
+			spin = false;
+
+		/* iopoll may have completed current req */
+		if (READ_ONCE(req->iopoll_completed))
+			list_move_tail(&req->inflight_entry, &done);
+	}
+
+	if (!list_empty(&done))
+		io_iopoll_complete(ctx, nr_events, &done);
+
+	return 0;
+}
+
+/*
+ * We can't just wait for polled events to come to us, we have to actively
+ * find and complete them.
+ */
+static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_IOPOLL))
+		return;
+
+	mutex_lock(&ctx->uring_lock);
+	while (!list_empty(&ctx->iopoll_list)) {
+		unsigned int nr_events = 0;
+
+		io_do_iopoll(ctx, &nr_events, 0);
+
+		/* let it sleep and repeat later if can't complete a request */
+		if (nr_events == 0)
+			break;
+		/*
+		 * Ensure we allow local-to-the-cpu processing to take place,
+		 * in this case we need to ensure that we reap all events.
+		 * Also let task_work, etc. to progress by releasing the mutex
+		 */
+		if (need_resched()) {
+			mutex_unlock(&ctx->uring_lock);
+			cond_resched();
+			mutex_lock(&ctx->uring_lock);
+		}
+	}
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
+{
+	unsigned int nr_events = 0;
+	int ret = 0;
+
+	/*
+	 * We disallow the app entering submit/complete with polling, but we
+	 * still need to lock the ring to prevent racing with polled issue
+	 * that got punted to a workqueue.
+	 */
+	mutex_lock(&ctx->uring_lock);
+	/*
+	 * Don't enter poll loop if we already have events pending.
+	 * If we do, we can potentially be spinning for commands that
+	 * already triggered a CQE (eg in error).
+	 */
+	if (test_bit(0, &ctx->check_cq_overflow))
+		__io_cqring_overflow_flush(ctx, false);
+	if (io_cqring_events(ctx))
+		goto out;
+	do {
+		/*
+		 * If a submit got punted to a workqueue, we can have the
+		 * application entering polling for a command before it gets
+		 * issued. That app will hold the uring_lock for the duration
+		 * of the poll right here, so we need to take a breather every
+		 * now and then to ensure that the issue has a chance to add
+		 * the poll to the issued list. Otherwise we can spin here
+		 * forever, while the workqueue is stuck trying to acquire the
+		 * very same mutex.
+		 */
+		if (list_empty(&ctx->iopoll_list)) {
+			u32 tail = ctx->cached_cq_tail;
+
+			mutex_unlock(&ctx->uring_lock);
+			io_run_task_work();
+			mutex_lock(&ctx->uring_lock);
+
+			/* some requests don't go through iopoll_list */
+			if (tail != ctx->cached_cq_tail ||
+			    list_empty(&ctx->iopoll_list))
+				break;
+		}
+		ret = io_do_iopoll(ctx, &nr_events, min);
+	} while (!ret && nr_events < min && !need_resched());
+out:
+	mutex_unlock(&ctx->uring_lock);
+	return ret;
+}
+
+static void kiocb_end_write(struct io_kiocb *req)
+{
+	/*
+	 * Tell lockdep we inherited freeze protection from submission
+	 * thread.
+	 */
+	if (req->flags & REQ_F_ISREG) {
+		struct super_block *sb = file_inode(req->file)->i_sb;
+
+		__sb_writers_acquired(sb, SB_FREEZE_WRITE);
+		sb_end_write(sb);
+	}
+}
+
+#ifdef CONFIG_BLOCK
+static bool io_resubmit_prep(struct io_kiocb *req)
+{
+	struct io_async_rw *rw = req->async_data;
+
+	if (!rw)
+		return !io_req_prep_async(req);
+	iov_iter_restore(&rw->iter, &rw->iter_state);
+	return true;
+}
+
+static bool io_rw_should_reissue(struct io_kiocb *req)
+{
+	umode_t mode = file_inode(req->file)->i_mode;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!S_ISBLK(mode) && !S_ISREG(mode))
+		return false;
+	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
+	    !(ctx->flags & IORING_SETUP_IOPOLL)))
+		return false;
+	/*
+	 * If ref is dying, we might be running poll reap from the exit work.
+	 * Don't attempt to reissue from that path, just let it fail with
+	 * -EAGAIN.
+	 */
+	if (percpu_ref_is_dying(&ctx->refs))
+		return false;
+	/*
+	 * Play it safe and assume not safe to re-import and reissue if we're
+	 * not in the original thread group (or in task context).
+	 */
+	if (!same_thread_group(req->task, current) || !in_task())
+		return false;
+	return true;
+}
+#else
+static bool io_resubmit_prep(struct io_kiocb *req)
+{
+	return false;
+}
+static bool io_rw_should_reissue(struct io_kiocb *req)
+{
+	return false;
+}
+#endif
+
+static bool __io_complete_rw_common(struct io_kiocb *req, long res)
+{
+	if (req->rw.kiocb.ki_flags & IOCB_WRITE) {
+		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
+	if (res != req->result) {
+		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
+		    io_rw_should_reissue(req)) {
+			req->flags |= REQ_F_REISSUE;
+			return true;
+		}
+		req_set_fail(req);
+		req->result = res;
+	}
+	return false;
+}
+
+static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+{
+	struct io_async_rw *io = req->async_data;
+
+	/* add previously done IO, if any */
+	if (io && io->bytes_done > 0) {
+		if (res < 0)
+			res = io->bytes_done;
+		else
+			res += io->bytes_done;
+	}
+	return res;
+}
+
+static void io_req_task_complete(struct io_kiocb *req, bool *locked)
+{
+	unsigned int cflags = io_put_rw_kbuf(req);
+	int res = req->result;
+
+	if (*locked) {
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_submit_state *state = &ctx->submit_state;
+
+		io_req_complete_state(req, res, cflags);
+		state->compl_reqs[state->compl_nr++] = req;
+		if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
+			io_submit_flush_completions(ctx);
+	} else {
+		io_req_complete_post(req, res, cflags);
+	}
+}
+
+static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
+			     unsigned int issue_flags)
+{
+	if (__io_complete_rw_common(req, res))
+		return;
+	__io_req_complete(req, issue_flags, io_fixup_rw_res(req, res), io_put_rw_kbuf(req));
+}
+
+static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
+{
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+
+	if (__io_complete_rw_common(req, res))
+		return;
+	req->result = io_fixup_rw_res(req, res);
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
+}
+
+static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
+{
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+
+	if (kiocb->ki_flags & IOCB_WRITE)
+		kiocb_end_write(req);
+	if (unlikely(res != req->result)) {
+		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+			req->flags |= REQ_F_REISSUE;
+			return;
+		}
+	}
+
+	WRITE_ONCE(req->result, res);
+	/* order with io_iopoll_complete() checking ->result */
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
+}
+
+/*
+ * After the iocb has been issued, it's safe to be found on the poll list.
+ * Adding the kiocb to the list AFTER submission ensures that we don't
+ * find it from a io_do_iopoll() thread before the issuer is done
+ * accessing the kiocb cookie.
+ */
+static void io_iopoll_req_issued(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	const bool in_async = io_wq_current_is_worker();
+
+	/* workqueue context doesn't hold uring_lock, grab it now */
+	if (unlikely(in_async))
+		mutex_lock(&ctx->uring_lock);
+
+	/*
+	 * Track whether we have multiple files in our lists. This will impact
+	 * how we do polling eventually, not spinning if we're on potentially
+	 * different devices.
+	 */
+	if (list_empty(&ctx->iopoll_list)) {
+		ctx->poll_multi_queue = false;
+	} else if (!ctx->poll_multi_queue) {
+		struct io_kiocb *list_req;
+		unsigned int queue_num0, queue_num1;
+
+		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
+						inflight_entry);
+
+		if (list_req->file != req->file) {
+			ctx->poll_multi_queue = true;
+		} else {
+			queue_num0 = blk_qc_t_to_queue_num(list_req->rw.kiocb.ki_cookie);
+			queue_num1 = blk_qc_t_to_queue_num(req->rw.kiocb.ki_cookie);
+			if (queue_num0 != queue_num1)
+				ctx->poll_multi_queue = true;
+		}
+	}
+
+	/*
+	 * For fast devices, IO may have already completed. If it has, add
+	 * it to the front so we find it first.
+	 */
+	if (READ_ONCE(req->iopoll_completed))
+		list_add(&req->inflight_entry, &ctx->iopoll_list);
+	else
+		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
+
+	if (unlikely(in_async)) {
+		/*
+		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
+		 * in sq thread task context or in io worker task context. If
+		 * current task context is sq thread, we don't need to check
+		 * whether should wake up sq thread.
+		 */
+		if ((ctx->flags & IORING_SETUP_SQPOLL) &&
+		    wq_has_sleeper(&ctx->sq_data->wait))
+			wake_up(&ctx->sq_data->wait);
+
+		mutex_unlock(&ctx->uring_lock);
+	}
+}
+
+static bool io_bdev_nowait(struct block_device *bdev)
+{
+	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
+}
+
+/*
+ * If we tracked the file through the SCM inflight mechanism, we could support
+ * any file. For now, just ensure that anything potentially problematic is done
+ * inline.
+ */
+static bool __io_file_supports_nowait(struct file *file, int rw)
+{
+	umode_t mode = file_inode(file)->i_mode;
+
+	if (S_ISBLK(mode)) {
+		if (IS_ENABLED(CONFIG_BLOCK) &&
+		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
+			return true;
+		return false;
+	}
+	if (S_ISSOCK(mode))
+		return true;
+	if (S_ISREG(mode)) {
+		if (IS_ENABLED(CONFIG_BLOCK) &&
+		    io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
+		    file->f_op != &io_uring_fops)
+			return true;
+		return false;
+	}
+
+	/* any ->read/write should understand O_NONBLOCK */
+	if (file->f_flags & O_NONBLOCK)
+		return true;
+
+	if (!(file->f_mode & FMODE_NOWAIT))
+		return false;
+
+	if (rw == READ)
+		return file->f_op->read_iter != NULL;
+
+	return file->f_op->write_iter != NULL;
+}
+
+static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
+{
+	if (rw == READ && (req->flags & REQ_F_NOWAIT_READ))
+		return true;
+	else if (rw == WRITE && (req->flags & REQ_F_NOWAIT_WRITE))
+		return true;
+
+	return __io_file_supports_nowait(req->file, rw);
+}
+
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int rw)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct file *file = req->file;
+	unsigned ioprio;
+	int ret;
+
+	if (!io_req_ffs_set(req) && S_ISREG(file_inode(file)->i_mode))
+		req->flags |= REQ_F_ISREG;
+
+	kiocb->ki_pos = READ_ONCE(sqe->off);
+	if (kiocb->ki_pos == -1) {
+		if (!(file->f_mode & FMODE_STREAM)) {
+			req->flags |= REQ_F_CUR_POS;
+			kiocb->ki_pos = file->f_pos;
+		} else {
+			kiocb->ki_pos = 0;
+		}
+	}
+	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
+	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
+	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * If the file is marked O_NONBLOCK, still allow retry for it if it
+	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
+	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+	 */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
+		req->flags |= REQ_F_NOWAIT;
+
+	ioprio = READ_ONCE(sqe->ioprio);
+	if (ioprio) {
+		ret = ioprio_check_cap(ioprio);
+		if (ret)
+			return ret;
+
+		kiocb->ki_ioprio = ioprio;
+	} else
+		kiocb->ki_ioprio = get_current_ioprio();
+
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!(kiocb->ki_flags & IOCB_DIRECT) ||
+		    !kiocb->ki_filp->f_op->iopoll)
+			return -EOPNOTSUPP;
+
+		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
+		kiocb->ki_complete = io_complete_rw_iopoll;
+		req->iopoll_completed = 0;
+	} else {
+		if (kiocb->ki_flags & IOCB_HIPRI)
+			return -EINVAL;
+		kiocb->ki_complete = io_complete_rw;
+	}
+
+	/* used for fixed read/write too - just read unconditionally */
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	req->imu = NULL;
+
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req);
+	}
+
+	req->rw.addr = READ_ONCE(sqe->addr);
+	req->rw.len = READ_ONCE(sqe->len);
+	return 0;
+}
+
+static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+{
+	switch (ret) {
+	case -EIOCBQUEUED:
+		break;
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+	case -ERESTART_RESTARTBLOCK:
+		/*
+		 * We can't just restart the syscall, since previously
+		 * submitted sqes may already be in progress. Just fail this
+		 * IO with EINTR.
+		 */
+		ret = -EINTR;
+		fallthrough;
+	default:
+		kiocb->ki_complete(kiocb, ret, 0);
+	}
+}
+
+static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
+		       unsigned int issue_flags)
+{
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+
+	if (req->flags & REQ_F_CUR_POS)
+		req->file->f_pos = kiocb->ki_pos;
+	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
+		__io_complete_rw(req, ret, 0, issue_flags);
+	else
+		io_rw_done(kiocb, ret);
+
+	if (req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		if (io_resubmit_prep(req)) {
+			io_req_task_queue_reissue(req);
+		} else {
+			unsigned int cflags = io_put_rw_kbuf(req);
+			struct io_ring_ctx *ctx = req->ctx;
+
+			ret = io_fixup_rw_res(req, ret);
+			req_set_fail(req);
+			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
+				mutex_lock(&ctx->uring_lock);
+				__io_req_complete(req, issue_flags, ret, cflags);
+				mutex_unlock(&ctx->uring_lock);
+			} else {
+				__io_req_complete(req, issue_flags, ret, cflags);
+			}
+		}
+	}
+}
+
+static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
+			     struct io_mapped_ubuf *imu)
+{
+	size_t len = req->rw.len;
+	u64 buf_end, buf_addr = req->rw.addr;
+	size_t offset;
+
+	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
+		return -EFAULT;
+	/* not inside the mapped region */
+	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
+		return -EFAULT;
+
+	/*
+	 * May not be a start of buffer, set size appropriately
+	 * and advance us to the beginning.
+	 */
+	offset = buf_addr - imu->ubuf;
+	iov_iter_bvec(iter, rw, imu->bvec, imu->nr_bvecs, offset + len);
+
+	if (offset) {
+		/*
+		 * Don't use iov_iter_advance() here, as it's really slow for
+		 * using the latter parts of a big fixed buffer - it iterates
+		 * over each segment manually. We can cheat a bit here, because
+		 * we know that:
+		 *
+		 * 1) it's a BVEC iter, we set it up
+		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
+		 *    first and last bvec
+		 *
+		 * So just find our index, and adjust the iterator afterwards.
+		 * If the offset is within the first bvec (or the whole first
+		 * bvec, just use iov_iter_advance(). This makes it easier
+		 * since we can just skip the first segment, which may not
+		 * be PAGE_SIZE aligned.
+		 */
+		const struct bio_vec *bvec = imu->bvec;
+
+		if (offset <= bvec->bv_len) {
+			iov_iter_advance(iter, offset);
+		} else {
+			unsigned long seg_skip;
+
+			/* skip first vec */
+			offset -= bvec->bv_len;
+			seg_skip = 1 + (offset >> PAGE_SHIFT);
+
+			iter->bvec = bvec + seg_skip;
+			iter->nr_segs -= seg_skip;
+			iter->count -= bvec->bv_len + offset;
+			iter->iov_offset = offset & ~PAGE_MASK;
+		}
+	}
+
+	return 0;
+}
+
+static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
+{
+	if (WARN_ON_ONCE(!req->imu))
+		return -EFAULT;
+	return __io_import_fixed(req, rw, iter, req->imu);
+}
+
+static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
+{
+	if (needs_lock)
+		mutex_unlock(&ctx->uring_lock);
+}
+
+static void io_ring_submit_lock(struct io_ring_ctx *ctx, bool needs_lock)
+{
+	/*
+	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * grab it from the system call. Same is true for the SQPOLL offload.
+	 * The only exception is when we've detached the request and issue it
+	 * from an async worker thread, grab the lock for that case.
+	 */
+	if (needs_lock)
+		mutex_lock(&ctx->uring_lock);
+}
+
+static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
+					  int bgid, struct io_buffer *kbuf,
+					  bool needs_lock)
+{
+	struct io_buffer *head;
+
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		return kbuf;
+
+	io_ring_submit_lock(req->ctx, needs_lock);
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	head = xa_load(&req->ctx->io_buffers, bgid);
+	if (head) {
+		if (!list_empty(&head->list)) {
+			kbuf = list_last_entry(&head->list, struct io_buffer,
+							list);
+			list_del(&kbuf->list);
+		} else {
+			kbuf = head;
+			xa_erase(&req->ctx->io_buffers, bgid);
+		}
+		if (*len > kbuf->len)
+			*len = kbuf->len;
+	} else {
+		kbuf = ERR_PTR(-ENOBUFS);
+	}
+
+	io_ring_submit_unlock(req->ctx, needs_lock);
+
+	return kbuf;
+}
+
+static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
+					bool needs_lock)
+{
+	struct io_buffer *kbuf;
+	u16 bgid;
+
+	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+	bgid = req->buf_index;
+	kbuf = io_buffer_select(req, len, bgid, kbuf, needs_lock);
+	if (IS_ERR(kbuf))
+		return kbuf;
+	req->rw.addr = (u64) (unsigned long) kbuf;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+	return u64_to_user_ptr(kbuf->addr);
+}
+
+#ifdef CONFIG_COMPAT
+static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
+				bool needs_lock)
+{
+	struct compat_iovec __user *uiov;
+	compat_ssize_t clen;
+	void __user *buf;
+	ssize_t len;
+
+	uiov = u64_to_user_ptr(req->rw.addr);
+	if (!access_ok(uiov, sizeof(*uiov)))
+		return -EFAULT;
+	if (__get_user(clen, &uiov->iov_len))
+		return -EFAULT;
+	if (clen < 0)
+		return -EINVAL;
+
+	len = clen;
+	buf = io_rw_buffer_select(req, &len, needs_lock);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+	iov[0].iov_base = buf;
+	iov[0].iov_len = (compat_size_t) len;
+	return 0;
+}
+#endif
+
+static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
+				      bool needs_lock)
+{
+	struct iovec __user *uiov = u64_to_user_ptr(req->rw.addr);
+	void __user *buf;
+	ssize_t len;
+
+	if (copy_from_user(iov, uiov, sizeof(*uiov)))
+		return -EFAULT;
+
+	len = iov[0].iov_len;
+	if (len < 0)
+		return -EINVAL;
+	buf = io_rw_buffer_select(req, &len, needs_lock);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+	iov[0].iov_base = buf;
+	iov[0].iov_len = len;
+	return 0;
+}
+
+static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
+				    bool needs_lock)
+{
+	if (req->flags & REQ_F_BUFFER_SELECTED) {
+		struct io_buffer *kbuf;
+
+		kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+		iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		iov[0].iov_len = kbuf->len;
+		return 0;
+	}
+	if (req->rw.len != 1)
+		return -EINVAL;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		return io_compat_import(req, iov, needs_lock);
+#endif
+
+	return __io_iov_buffer_select(req, iov, needs_lock);
+}
+
+static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
+			   struct iov_iter *iter, bool needs_lock)
+{
+	void __user *buf = u64_to_user_ptr(req->rw.addr);
+	size_t sqe_len = req->rw.len;
+	u8 opcode = req->opcode;
+	ssize_t ret;
+
+	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
+		*iovec = NULL;
+		return io_import_fixed(req, rw, iter);
+	}
+
+	/* buffer index only valid with fixed read/write, or buffer select  */
+	if (req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT))
+		return -EINVAL;
+
+	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
+		if (req->flags & REQ_F_BUFFER_SELECT) {
+			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
+			if (IS_ERR(buf))
+				return PTR_ERR(buf);
+			req->rw.len = sqe_len;
+		}
+
+		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
+		*iovec = NULL;
+		return ret;
+	}
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		ret = io_iov_buffer_select(req, *iovec, needs_lock);
+		if (!ret)
+			iov_iter_init(iter, rw, *iovec, 1, (*iovec)->iov_len);
+		*iovec = NULL;
+		return ret;
+	}
+
+	return __import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter,
+			      req->ctx->compat);
+}
+
+static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
+{
+	return (kiocb->ki_filp->f_mode & FMODE_STREAM) ? NULL : &kiocb->ki_pos;
+}
+
+/*
+ * For files that don't have ->read_iter() and ->write_iter(), handle them
+ * by looping over ->read() or ->write() manually.
+ */
+static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct file *file = req->file;
+	ssize_t ret = 0;
+
+	/*
+	 * Don't support polled IO through this interface, and we can't
+	 * support non-blocking either. For the latter, this just causes
+	 * the kiocb to be handled from an async context.
+	 */
+	if (kiocb->ki_flags & IOCB_HIPRI)
+		return -EOPNOTSUPP;
+	if (kiocb->ki_flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
+	while (iov_iter_count(iter)) {
+		struct iovec iovec;
+		ssize_t nr;
+
+		if (!iov_iter_is_bvec(iter)) {
+			iovec = iov_iter_iovec(iter);
+		} else {
+			iovec.iov_base = u64_to_user_ptr(req->rw.addr);
+			iovec.iov_len = req->rw.len;
+		}
+
+		if (rw == READ) {
+			nr = file->f_op->read(file, iovec.iov_base,
+					      iovec.iov_len, io_kiocb_ppos(kiocb));
+		} else {
+			nr = file->f_op->write(file, iovec.iov_base,
+					       iovec.iov_len, io_kiocb_ppos(kiocb));
+		}
+
+		if (nr < 0) {
+			if (!ret)
+				ret = nr;
+			break;
+		}
+		ret += nr;
+		if (!iov_iter_is_bvec(iter)) {
+			iov_iter_advance(iter, nr);
+		} else {
+			req->rw.addr += nr;
+			req->rw.len -= nr;
+			if (!req->rw.len)
+				break;
+		}
+		if (nr != iovec.iov_len)
+			break;
+	}
+
+	return ret;
+}
+
+static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
+			  const struct iovec *fast_iov, struct iov_iter *iter)
+{
+	struct io_async_rw *rw = req->async_data;
+
+	memcpy(&rw->iter, iter, sizeof(*iter));
+	rw->free_iovec = iovec;
+	rw->bytes_done = 0;
+	/* can only be fixed buffers, no need to do anything */
+	if (iov_iter_is_bvec(iter))
+		return;
+	if (!iovec) {
+		unsigned iov_off = 0;
+
+		rw->iter.iov = rw->fast_iov;
+		if (iter->iov != fast_iov) {
+			iov_off = iter->iov - fast_iov;
+			rw->iter.iov += iov_off;
+		}
+		if (rw->fast_iov != fast_iov)
+			memcpy(rw->fast_iov + iov_off, fast_iov + iov_off,
+			       sizeof(struct iovec) * iter->nr_segs);
+	} else {
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+}
+
+static inline int io_alloc_async_data(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
+	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
+	return req->async_data == NULL;
+}
+
+static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
+			     const struct iovec *fast_iov,
+			     struct iov_iter *iter, bool force)
+{
+	if (!force && !io_op_defs[req->opcode].needs_async_setup)
+		return 0;
+	if (!req->async_data) {
+		struct io_async_rw *iorw;
+
+		if (io_alloc_async_data(req)) {
+			kfree(iovec);
+			return -ENOMEM;
+		}
+
+		io_req_map_rw(req, iovec, fast_iov, iter);
+		iorw = req->async_data;
+		/* we've copied and mapped the iter, ensure state is saved */
+		iov_iter_save_state(&iorw->iter, &iorw->iter_state);
+	}
+	return 0;
+}
+
+static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
+{
+	struct io_async_rw *iorw = req->async_data;
+	struct iovec *iov = iorw->fast_iov;
+	int ret;
+
+	ret = io_import_iovec(rw, req, &iov, &iorw->iter, false);
+	if (unlikely(ret < 0))
+		return ret;
+
+	iorw->bytes_done = 0;
+	iorw->free_iovec = iov;
+	if (iov)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	iov_iter_save_state(&iorw->iter, &iorw->iter_state);
+	return 0;
+}
+
+static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	if (unlikely(!(req->file->f_mode & FMODE_READ)))
+		return -EBADF;
+	return io_prep_rw(req, sqe, READ);
+}
+
+/*
+ * This is our waitqueue callback handler, registered through lock_page_async()
+ * when we initially tried to do the IO with the iocb armed our waitqueue.
+ * This gets called when the page is unlocked, and we generally expect that to
+ * happen when the page IO is completed and the page is now uptodate. This will
+ * queue a task_work based retry of the operation, attempting to copy the data
+ * again. If the latter fails because the page was NOT uptodate, then we will
+ * do a thread based blocking retry of the operation. That's the unexpected
+ * slow path.
+ */
+static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
+			     int sync, void *arg)
+{
+	struct wait_page_queue *wpq;
+	struct io_kiocb *req = wait->private;
+	struct wait_page_key *key = arg;
+
+	wpq = container_of(wait, struct wait_page_queue, wait);
+
+	if (!wake_page_match(wpq, key))
+		return 0;
+
+	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
+	list_del_init(&wait->entry);
+	io_req_task_queue(req);
+	return 1;
+}
+
+/*
+ * This controls whether a given IO request should be armed for async page
+ * based retry. If we return false here, the request is handed to the async
+ * worker threads for retry. If we're doing buffered reads on a regular file,
+ * we prepare a private wait_page_queue entry and retry the operation. This
+ * will either succeed because the page is now uptodate and unlocked, or it
+ * will register a callback when the page is unlocked at IO completion. Through
+ * that callback, io_uring uses task_work to setup a retry of the operation.
+ * That retry will attempt the buffered read again. The retry will generally
+ * succeed, or in rare cases where it fails, we then fall back to using the
+ * async worker threads for a blocking retry.
+ */
+static bool io_rw_should_retry(struct io_kiocb *req)
+{
+	struct io_async_rw *rw = req->async_data;
+	struct wait_page_queue *wait = &rw->wpq;
+	struct kiocb *kiocb = &req->rw.kiocb;
+
+	/* never retry for NOWAIT, we just complete with -EAGAIN */
+	if (req->flags & REQ_F_NOWAIT)
+		return false;
+
+	/* Only for buffered IO */
+	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_HIPRI))
+		return false;
+
+	/*
+	 * just use poll if we can, and don't attempt if the fs doesn't
+	 * support callback based unlocks
+	 */
+	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
+		return false;
+
+	wait->wait.func = io_async_buf_func;
+	wait->wait.private = req;
+	wait->wait.flags = 0;
+	INIT_LIST_HEAD(&wait->wait.entry);
+	kiocb->ki_flags |= IOCB_WAITQ;
+	kiocb->ki_flags &= ~IOCB_NOWAIT;
+	kiocb->ki_waitq = wait;
+	return true;
+}
+
+static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
+{
+	if (req->file->f_op->read_iter)
+		return call_read_iter(req->file, &req->rw.kiocb, iter);
+	else if (req->file->f_op->read)
+		return loop_rw_iter(READ, req, iter);
+	else
+		return -EINVAL;
+}
+
+static bool need_read_all(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_ISREG ||
+		S_ISBLK(file_inode(req->file)->i_mode);
+}
+
+static int io_read(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct iov_iter __iter, *iter = &__iter;
+	struct io_async_rw *rw = req->async_data;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct iov_iter_state __state, *state;
+	ssize_t ret, ret2;
+
+	if (rw) {
+		iter = &rw->iter;
+		state = &rw->iter_state;
+		/*
+		 * We come here from an earlier attempt, restore our state to
+		 * match in case it doesn't. It's cheap enough that we don't
+		 * need to make this conditional.
+		 */
+		iov_iter_restore(iter, state);
+		iovec = NULL;
+	} else {
+		ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
+		if (ret < 0)
+			return ret;
+		state = &__state;
+		iov_iter_save_state(iter, state);
+	}
+	req->result = iov_iter_count(iter);
+
+	/* Ensure we clear previously set non-block flag */
+	if (!force_nonblock)
+		kiocb->ki_flags &= ~IOCB_NOWAIT;
+	else
+		kiocb->ki_flags |= IOCB_NOWAIT;
+
+	/* If the file doesn't support async, just async punt */
+	if (force_nonblock && !io_file_supports_nowait(req, READ)) {
+		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
+		return ret ?: -EAGAIN;
+	}
+
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
+	if (unlikely(ret)) {
+		kfree(iovec);
+		return ret;
+	}
+
+	ret = io_iter_do_read(req, iter);
+
+	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
+		req->flags &= ~REQ_F_REISSUE;
+		/* IOPOLL retry should happen for io-wq threads */
+		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
+			goto done;
+		/* no retry on NONBLOCK nor RWF_NOWAIT */
+		if (req->flags & REQ_F_NOWAIT)
+			goto done;
+		ret = 0;
+	} else if (ret == -EIOCBQUEUED) {
+		goto out_free;
+	} else if (ret <= 0 || ret == req->result || !force_nonblock ||
+		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
+		/* read all, failed, already did sync or don't want to retry */
+		goto done;
+	}
+
+	/*
+	 * Don't depend on the iter state matching what was consumed, or being
+	 * untouched in case of error. Restore it and we'll advance it
+	 * manually if we need to.
+	 */
+	iov_iter_restore(iter, state);
+
+	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
+	if (ret2)
+		return ret2;
+
+	iovec = NULL;
+	rw = req->async_data;
+	/*
+	 * Now use our persistent iterator and state, if we aren't already.
+	 * We've restored and mapped the iter to match.
+	 */
+	if (iter != &rw->iter) {
+		iter = &rw->iter;
+		state = &rw->iter_state;
+	}
+
+	do {
+		/*
+		 * We end up here because of a partial read, either from
+		 * above or inside this loop. Advance the iter by the bytes
+		 * that were consumed.
+		 */
+		iov_iter_advance(iter, ret);
+		if (!iov_iter_count(iter))
+			break;
+		rw->bytes_done += ret;
+		iov_iter_save_state(iter, state);
+
+		/* if we can retry, do so with the callbacks armed */
+		if (!io_rw_should_retry(req)) {
+			kiocb->ki_flags &= ~IOCB_WAITQ;
+			return -EAGAIN;
+		}
+
+		req->result = iov_iter_count(iter);
+		/*
+		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
+		 * we get -EIOCBQUEUED, then we'll get a notification when the
+		 * desired page gets unlocked. We can also get a partial read
+		 * here, and if we do, then just retry at the new offset.
+		 */
+		ret = io_iter_do_read(req, iter);
+		if (ret == -EIOCBQUEUED)
+			return 0;
+		/* we got some bytes, but not all. retry. */
+		kiocb->ki_flags &= ~IOCB_WAITQ;
+		iov_iter_restore(iter, state);
+	} while (ret > 0);
+done:
+	kiocb_done(kiocb, ret, issue_flags);
+out_free:
+	/* it's faster to check here then delegate to kfree */
+	if (iovec)
+		kfree(iovec);
+	return 0;
+}
+
+static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
+		return -EBADF;
+	return io_prep_rw(req, sqe, WRITE);
+}
+
+static int io_write(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct iov_iter __iter, *iter = &__iter;
+	struct io_async_rw *rw = req->async_data;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct iov_iter_state __state, *state;
+	ssize_t ret, ret2;
+
+	if (rw) {
+		iter = &rw->iter;
+		state = &rw->iter_state;
+		iov_iter_restore(iter, state);
+		iovec = NULL;
+	} else {
+		ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
+		if (ret < 0)
+			return ret;
+		state = &__state;
+		iov_iter_save_state(iter, state);
+	}
+	req->result = iov_iter_count(iter);
+
+	/* Ensure we clear previously set non-block flag */
+	if (!force_nonblock)
+		kiocb->ki_flags &= ~IOCB_NOWAIT;
+	else
+		kiocb->ki_flags |= IOCB_NOWAIT;
+
+	/* If the file doesn't support async, just async punt */
+	if (force_nonblock && !io_file_supports_nowait(req, WRITE))
+		goto copy_iov;
+
+	/* file path doesn't support NOWAIT for non-direct_IO */
+	if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
+	    (req->flags & REQ_F_ISREG))
+		goto copy_iov;
+
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
+	if (unlikely(ret))
+		goto out_free;
+
+	/*
+	 * Open-code file_start_write here to grab freeze protection,
+	 * which will be released by another thread in
+	 * io_complete_rw().  Fool lockdep by telling it the lock got
+	 * released so that it doesn't complain about the held lock when
+	 * we return to userspace.
+	 */
+	if (req->flags & REQ_F_ISREG) {
+		sb_start_write(file_inode(req->file)->i_sb);
+		__sb_writers_release(file_inode(req->file)->i_sb,
+					SB_FREEZE_WRITE);
+	}
+	kiocb->ki_flags |= IOCB_WRITE;
+
+	if (req->file->f_op->write_iter)
+		ret2 = call_write_iter(req->file, kiocb, iter);
+	else if (req->file->f_op->write)
+		ret2 = loop_rw_iter(WRITE, req, iter);
+	else
+		ret2 = -EINVAL;
+
+	if (req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		ret2 = -EAGAIN;
+	}
+
+	/*
+	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
+	 * retry them without IOCB_NOWAIT.
+	 */
+	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
+		ret2 = -EAGAIN;
+	/* no retry on NONBLOCK nor RWF_NOWAIT */
+	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
+		goto done;
+	if (!force_nonblock || ret2 != -EAGAIN) {
+		/* IOPOLL retry should happen for io-wq threads */
+		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
+			goto copy_iov;
+done:
+		kiocb_done(kiocb, ret2, issue_flags);
+	} else {
+copy_iov:
+		iov_iter_restore(iter, state);
+		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
+		if (!ret) {
+			if (kiocb->ki_flags & IOCB_WRITE)
+				kiocb_end_write(req);
+			return -EAGAIN;
+		}
+		return ret;
+	}
+out_free:
+	/* it's reportedly faster than delegating the null check to kfree() */
+	if (iovec)
+		kfree(iovec);
+	return ret;
+}
+
+static int io_renameat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_rename *ren = &req->rename;
+	const char __user *oldf, *newf;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	ren->old_dfd = READ_ONCE(sqe->fd);
+	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	ren->new_dfd = READ_ONCE(sqe->len);
+	ren->flags = READ_ONCE(sqe->rename_flags);
+
+	ren->oldpath = getname(oldf);
+	if (IS_ERR(ren->oldpath))
+		return PTR_ERR(ren->oldpath);
+
+	ren->newpath = getname(newf);
+	if (IS_ERR(ren->newpath)) {
+		putname(ren->oldpath);
+		return PTR_ERR(ren->newpath);
+	}
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rename *ren = &req->rename;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_renameat2(ren->old_dfd, ren->oldpath, ren->new_dfd,
+				ren->newpath, ren->flags);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_unlinkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_unlink *un = &req->unlink;
+	const char __user *fname;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	un->dfd = READ_ONCE(sqe->fd);
+
+	un->flags = READ_ONCE(sqe->unlink_flags);
+	if (un->flags & ~AT_REMOVEDIR)
+		return -EINVAL;
+
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	un->filename = getname(fname);
+	if (IS_ERR(un->filename))
+		return PTR_ERR(un->filename);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_unlink *un = &req->unlink;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	if (un->flags & AT_REMOVEDIR)
+		ret = do_rmdir(un->dfd, un->filename);
+	else
+		ret = do_unlinkat(un->dfd, un->filename);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_mkdirat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	const char __user *fname;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->rw_flags || sqe->buf_index ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	mkd->dfd = READ_ONCE(sqe->fd);
+	mkd->mode = READ_ONCE(sqe->len);
+
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	mkd->filename = getname(fname);
+	if (IS_ERR(mkd->filename))
+		return PTR_ERR(mkd->filename);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_mkdirat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_symlinkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_symlink *sl = &req->symlink;
+	const char __user *oldpath, *newpath;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->rw_flags || sqe->buf_index ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	sl->new_dfd = READ_ONCE(sqe->fd);
+	oldpath = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	newpath = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+
+	sl->oldpath = getname(oldpath);
+	if (IS_ERR(sl->oldpath))
+		return PTR_ERR(sl->oldpath);
+
+	sl->newpath = getname(newpath);
+	if (IS_ERR(sl->newpath)) {
+		putname(sl->oldpath);
+		return PTR_ERR(sl->newpath);
+	}
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_symlinkat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_symlink *sl = &req->symlink;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_linkat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_hardlink *lnk = &req->hardlink;
+	const char __user *oldf, *newf;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	lnk->old_dfd = READ_ONCE(sqe->fd);
+	lnk->new_dfd = READ_ONCE(sqe->len);
+	oldf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	lnk->flags = READ_ONCE(sqe->hardlink_flags);
+
+	lnk->oldpath = getname(oldf);
+	if (IS_ERR(lnk->oldpath))
+		return PTR_ERR(lnk->oldpath);
+
+	lnk->newpath = getname(newf);
+	if (IS_ERR(lnk->newpath)) {
+		putname(lnk->oldpath);
+		return PTR_ERR(lnk->newpath);
+	}
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_linkat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_hardlink *lnk = &req->hardlink;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
+				lnk->newpath, lnk->flags);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_shutdown_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_NET)
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
+		     sqe->buf_index || sqe->splice_fd_in))
+		return -EINVAL;
+
+	req->shutdown.how = READ_ONCE(sqe->len);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
+{
+#if defined(CONFIG_NET)
+	struct socket *sock;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	ret = __sys_shutdown_sock(sock, req->shutdown.how);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int __io_splice_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_splice *sp = &req->splice;
+	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	sp->len = READ_ONCE(sqe->len);
+	sp->flags = READ_ONCE(sqe->splice_flags);
+	if (unlikely(sp->flags & ~valid_flags))
+		return -EINVAL;
+	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
+	return 0;
+}
+
+static int io_tee_prep(struct io_kiocb *req,
+		       const struct io_uring_sqe *sqe)
+{
+	if (READ_ONCE(sqe->splice_off_in) || READ_ONCE(sqe->off))
+		return -EINVAL;
+	return __io_splice_prep(req, sqe);
+}
+
+static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_splice *sp = &req->splice;
+	struct file *out = sp->file_out;
+	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	struct file *in;
+	long ret = 0;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
+	if (sp->len)
+		ret = do_tee(in, out, sp->len, flags);
+
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		io_put_file(in);
+done:
+	if (ret != sp->len)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_splice *sp = &req->splice;
+
+	sp->off_in = READ_ONCE(sqe->splice_off_in);
+	sp->off_out = READ_ONCE(sqe->off);
+	return __io_splice_prep(req, sqe);
+}
+
+static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_splice *sp = &req->splice;
+	struct file *out = sp->file_out;
+	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	loff_t *poff_in, *poff_out;
+	struct file *in;
+	long ret = 0;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
+	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
+	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
+
+	if (sp->len)
+		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
+
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		io_put_file(in);
+done:
+	if (ret != sp->len)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+/*
+ * IORING_OP_NOP just posts a completion event, nothing else.
+ */
+static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	__io_req_complete(req, issue_flags, 0, 0);
+	return 0;
+}
+
+static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
+		return -EINVAL;
+
+	req->sync.flags = READ_ONCE(sqe->fsync_flags);
+	if (unlikely(req->sync.flags & ~IORING_FSYNC_DATASYNC))
+		return -EINVAL;
+
+	req->sync.off = READ_ONCE(sqe->off);
+	req->sync.len = READ_ONCE(sqe->len);
+	return 0;
+}
+
+static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
+{
+	loff_t end = req->sync.off + req->sync.len;
+	int ret;
+
+	/* fsync always requires a blocking context */
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = vfs_fsync_range(req->file, req->sync.off,
+				end > 0 ? end : LLONG_MAX,
+				req->sync.flags & IORING_FSYNC_DATASYNC);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_fallocate_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	req->sync.off = READ_ONCE(sqe->off);
+	req->sync.len = READ_ONCE(sqe->addr);
+	req->sync.mode = READ_ONCE(sqe->len);
+	return 0;
+}
+
+static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	/* fallocate always requiring blocking context */
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
+				req->sync.len);
+	if (ret < 0)
+		req_set_fail(req);
+	else
+		fsnotify_modify(req->file);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	const char __user *fname;
+	int ret;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->ioprio || sqe->buf_index))
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	/* open.how should be already initialised */
+	if (!(req->open.how.flags & O_PATH) && force_o_largefile())
+		req->open.how.flags |= O_LARGEFILE;
+
+	req->open.dfd = READ_ONCE(sqe->fd);
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	req->open.filename = getname(fname);
+	if (IS_ERR(req->open.filename)) {
+		ret = PTR_ERR(req->open.filename);
+		req->open.filename = NULL;
+		return ret;
+	}
+
+	req->open.file_slot = READ_ONCE(sqe->file_index);
+	if (req->open.file_slot && (req->open.how.flags & O_CLOEXEC))
+		return -EINVAL;
+
+	req->open.nofile = rlimit(RLIMIT_NOFILE);
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	u64 mode = READ_ONCE(sqe->len);
+	u64 flags = READ_ONCE(sqe->open_flags);
+
+	req->open.how = build_open_how(flags, mode);
+	return __io_openat_prep(req, sqe);
+}
+
+static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct open_how __user *how;
+	size_t len;
+	int ret;
+
+	how = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	len = READ_ONCE(sqe->len);
+	if (len < OPEN_HOW_SIZE_VER0)
+		return -EINVAL;
+
+	ret = copy_struct_from_user(&req->open.how, sizeof(req->open.how), how,
+					len);
+	if (ret)
+		return ret;
+
+	return __io_openat_prep(req, sqe);
+}
+
+static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct open_flags op;
+	struct file *file;
+	bool resolve_nonblock, nonblock_set;
+	bool fixed = !!req->open.file_slot;
+	int ret;
+
+	ret = build_open_flags(&req->open.how, &op);
+	if (ret)
+		goto err;
+	nonblock_set = op.open_flag & O_NONBLOCK;
+	resolve_nonblock = req->open.how.resolve & RESOLVE_CACHED;
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		/*
+		 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
+		 * it'll always -EAGAIN
+		 */
+		if (req->open.how.flags & (O_TRUNC | O_CREAT | O_TMPFILE))
+			return -EAGAIN;
+		op.lookup_flags |= LOOKUP_CACHED;
+		op.open_flag |= O_NONBLOCK;
+	}
+
+	if (!fixed) {
+		ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
+		if (ret < 0)
+			goto err;
+	}
+
+	file = do_filp_open(req->open.dfd, req->open.filename, &op);
+	if (IS_ERR(file)) {
+		/*
+		 * We could hang on to this 'fd' on retrying, but seems like
+		 * marginal gain for something that is now known to be a slower
+		 * path. So just put it, and we'll get a new one when we retry.
+		 */
+		if (!fixed)
+			put_unused_fd(ret);
+
+		ret = PTR_ERR(file);
+		/* only retry if RESOLVE_CACHED wasn't already set by application */
+		if (ret == -EAGAIN &&
+		    (!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK)))
+			return -EAGAIN;
+		goto err;
+	}
+
+	if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
+		file->f_flags &= ~O_NONBLOCK;
+	fsnotify_open(file);
+
+	if (!fixed)
+		fd_install(ret, file);
+	else
+		ret = io_install_fixed_file(req, file, issue_flags,
+					    req->open.file_slot - 1);
+err:
+	putname(req->open.filename);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int io_openat(struct io_kiocb *req, unsigned int issue_flags)
+{
+	return io_openat2(req, issue_flags);
+}
+
+static int io_remove_buffers_prep(struct io_kiocb *req,
+				  const struct io_uring_sqe *sqe)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	u64 tmp;
+
+	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+
+	tmp = READ_ONCE(sqe->fd);
+	if (!tmp || tmp > USHRT_MAX)
+		return -EINVAL;
+
+	memset(p, 0, sizeof(*p));
+	p->nbufs = tmp;
+	p->bgid = READ_ONCE(sqe->buf_group);
+	return 0;
+}
+
+static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
+			       int bgid, unsigned nbufs)
+{
+	unsigned i = 0;
+
+	/* shouldn't happen */
+	if (!nbufs)
+		return 0;
+
+	/* the head kbuf is the list itself */
+	while (!list_empty(&buf->list)) {
+		struct io_buffer *nxt;
+
+		nxt = list_first_entry(&buf->list, struct io_buffer, list);
+		list_del(&nxt->list);
+		kfree(nxt);
+		if (++i == nbufs)
+			return i;
+		cond_resched();
+	}
+	i++;
+	kfree(buf);
+	xa_erase(&ctx->io_buffers, bgid);
+
+	return i;
+}
+
+static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer *head;
+	int ret = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	io_ring_submit_lock(ctx, !force_nonblock);
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	ret = -ENOENT;
+	head = xa_load(&ctx->io_buffers, p->bgid);
+	if (head)
+		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
+	if (ret < 0)
+		req_set_fail(req);
+
+	/* complete before unlock, IOPOLL may need the lock */
+	__io_req_complete(req, issue_flags, ret, 0);
+	io_ring_submit_unlock(ctx, !force_nonblock);
+	return 0;
+}
+
+static int io_provide_buffers_prep(struct io_kiocb *req,
+				   const struct io_uring_sqe *sqe)
+{
+	unsigned long size, tmp_check;
+	struct io_provide_buf *p = &req->pbuf;
+	u64 tmp;
+
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
+		return -EINVAL;
+
+	tmp = READ_ONCE(sqe->fd);
+	if (!tmp || tmp > USHRT_MAX)
+		return -E2BIG;
+	p->nbufs = tmp;
+	p->addr = READ_ONCE(sqe->addr);
+	p->len = READ_ONCE(sqe->len);
+
+	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
+				&size))
+		return -EOVERFLOW;
+	if (check_add_overflow((unsigned long)p->addr, size, &tmp_check))
+		return -EOVERFLOW;
+
+	size = (unsigned long)p->len * p->nbufs;
+	if (!access_ok(u64_to_user_ptr(p->addr), size))
+		return -EFAULT;
+
+	p->bgid = READ_ONCE(sqe->buf_group);
+	tmp = READ_ONCE(sqe->off);
+	if (tmp > USHRT_MAX)
+		return -E2BIG;
+	p->bid = tmp;
+	return 0;
+}
+
+static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
+{
+	struct io_buffer *buf;
+	u64 addr = pbuf->addr;
+	int i, bid = pbuf->bid;
+
+	for (i = 0; i < pbuf->nbufs; i++) {
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
+		if (!buf)
+			break;
+
+		buf->addr = addr;
+		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
+		buf->bid = bid;
+		addr += pbuf->len;
+		bid++;
+		if (!*head) {
+			INIT_LIST_HEAD(&buf->list);
+			*head = buf;
+		} else {
+			list_add_tail(&buf->list, &(*head)->list);
+		}
+		cond_resched();
+	}
+
+	return i ? i : -ENOMEM;
+}
+
+static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer *head, *list;
+	int ret = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	io_ring_submit_lock(ctx, !force_nonblock);
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	list = head = xa_load(&ctx->io_buffers, p->bgid);
+
+	ret = io_add_buffers(p, &head);
+	if (ret >= 0 && !list) {
+		ret = xa_insert(&ctx->io_buffers, p->bgid, head,
+				GFP_KERNEL_ACCOUNT);
+		if (ret < 0)
+			__io_remove_buffers(ctx, head, p->bgid, -1U);
+	}
+	if (ret < 0)
+		req_set_fail(req);
+	/* complete before unlock, IOPOLL may need the lock */
+	__io_req_complete(req, issue_flags, ret, 0);
+	io_ring_submit_unlock(ctx, !force_nonblock);
+	return 0;
+}
+
+static int io_epoll_ctl_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_EPOLL)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	req->epoll.epfd = READ_ONCE(sqe->fd);
+	req->epoll.op = READ_ONCE(sqe->len);
+	req->epoll.fd = READ_ONCE(sqe->off);
+
+	if (ep_op_has_event(req->epoll.op)) {
+		struct epoll_event __user *ev;
+
+		ev = u64_to_user_ptr(READ_ONCE(sqe->addr));
+		if (copy_from_user(&req->epoll.event, ev, sizeof(*ev)))
+			return -EFAULT;
+	}
+
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
+{
+#if defined(CONFIG_EPOLL)
+	struct io_epoll *ie = &req->epoll;
+	int ret;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	req->madvise.addr = READ_ONCE(sqe->addr);
+	req->madvise.len = READ_ONCE(sqe->len);
+	req->madvise.advice = READ_ONCE(sqe->fadvise_advice);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
+	struct io_madvise *ma = &req->madvise;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	req->fadvise.offset = READ_ONCE(sqe->off);
+	req->fadvise.len = READ_ONCE(sqe->len);
+	req->fadvise.advice = READ_ONCE(sqe->fadvise_advice);
+	return 0;
+}
+
+static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_fadvise *fa = &req->fadvise;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		switch (fa->advice) {
+		case POSIX_FADV_NORMAL:
+		case POSIX_FADV_RANDOM:
+		case POSIX_FADV_SEQUENTIAL:
+			break;
+		default:
+			return -EAGAIN;
+		}
+	}
+
+	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+	if (req->flags & REQ_F_FIXED_FILE)
+		return -EBADF;
+
+	req->statx.dfd = READ_ONCE(sqe->fd);
+	req->statx.mask = READ_ONCE(sqe->len);
+	req->statx.filename = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	req->statx.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	req->statx.flags = READ_ONCE(sqe->statx_flags);
+
+	return 0;
+}
+
+static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_statx *ctx = &req->statx;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
+		       ctx->buffer);
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
+	    sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+	if (req->flags & REQ_F_FIXED_FILE)
+		return -EBADF;
+
+	req->close.fd = READ_ONCE(sqe->fd);
+	req->close.file_slot = READ_ONCE(sqe->file_index);
+	if (req->close.file_slot && req->close.fd)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int io_close(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct files_struct *files = current->files;
+	struct io_close *close = &req->close;
+	struct fdtable *fdt;
+	struct file *file = NULL;
+	int ret = -EBADF;
+
+	if (req->close.file_slot) {
+		ret = io_close_fixed(req, issue_flags);
+		goto err;
+	}
+
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	if (close->fd >= fdt->max_fds) {
+		spin_unlock(&files->file_lock);
+		goto err;
+	}
+	file = fdt->fd[close->fd];
+	if (!file || file->f_op == &io_uring_fops) {
+		spin_unlock(&files->file_lock);
+		file = NULL;
+		goto err;
+	}
+
+	/* if the file has a flush method, be safe and punt to async */
+	if (file->f_op->flush && (issue_flags & IO_URING_F_NONBLOCK)) {
+		spin_unlock(&files->file_lock);
+		return -EAGAIN;
+	}
+
+	ret = __close_fd_get_file(close->fd, &file);
+	spin_unlock(&files->file_lock);
+	if (ret < 0) {
+		if (ret == -ENOENT)
+			ret = -EBADF;
+		goto err;
+	}
+
+	/* No ->flush() or already async, safely close from here */
+	ret = filp_close(file, current->files);
+err:
+	if (ret < 0)
+		req_set_fail(req);
+	if (file)
+		fput(file);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
+		return -EINVAL;
+
+	req->sync.off = READ_ONCE(sqe->off);
+	req->sync.len = READ_ONCE(sqe->len);
+	req->sync.flags = READ_ONCE(sqe->sync_range_flags);
+	return 0;
+}
+
+static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	/* sync_file_range always requires a blocking context */
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
+				req->sync.flags);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
+#if defined(CONFIG_NET)
+static int io_setup_async_msg(struct io_kiocb *req,
+			      struct io_async_msghdr *kmsg)
+{
+	struct io_async_msghdr *async_msg = req->async_data;
+
+	if (async_msg)
+		return -EAGAIN;
+	if (io_alloc_async_data(req)) {
+		kfree(kmsg->free_iov);
+		return -ENOMEM;
+	}
+	async_msg = req->async_data;
+	req->flags |= REQ_F_NEED_CLEANUP;
+	memcpy(async_msg, kmsg, sizeof(*kmsg));
+	if (async_msg->msg.msg_name)
+		async_msg->msg.msg_name = &async_msg->addr;
+	/* if were using fast_iov, set it to the new one */
+	if (!async_msg->free_iov)
+		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
+
+	return -EAGAIN;
+}
+
+static int io_sendmsg_copy_hdr(struct io_kiocb *req,
+			       struct io_async_msghdr *iomsg)
+{
+	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->free_iov = iomsg->fast_iov;
+	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
+				   req->sr_msg.msg_flags, &iomsg->free_iov);
+}
+
+static int io_sendmsg_prep_async(struct io_kiocb *req)
+{
+	int ret;
+
+	ret = io_sendmsg_copy_hdr(req, req->async_data);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
+}
+
+static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
+		return -EINVAL;
+
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->len = READ_ONCE(sqe->len);
+	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	if (sr->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+	return 0;
+}
+
+static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_async_msghdr iomsg, *kmsg;
+	struct socket *sock;
+	unsigned flags;
+	int min_ret = 0;
+	int ret;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	kmsg = req->async_data;
+	if (!kmsg) {
+		ret = io_sendmsg_copy_hdr(req, &iomsg);
+		if (ret)
+			return ret;
+		kmsg = &iomsg;
+	}
+
+	flags = req->sr_msg.msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
+	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
+	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg);
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+
+	/* fast path, check for non-NULL to avoid function call */
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < min_ret)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int io_send(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct msghdr msg;
+	struct iovec iov;
+	struct socket *sock;
+	unsigned flags;
+	int min_ret = 0;
+	int ret;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+
+	flags = req->sr_msg.msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
+	msg.msg_flags = flags;
+	ret = sock_sendmsg(sock, &msg);
+	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
+		return -EAGAIN;
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+
+	if (ret < min_ret)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
+				 struct io_async_msghdr *iomsg)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct iovec __user *uiov;
+	size_t iov_len;
+	int ret;
+
+	ret = __copy_msghdr_from_user(&iomsg->msg, sr->umsg,
+					&iomsg->uaddr, &uiov, &iov_len);
+	if (ret)
+		return ret;
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (iov_len > 1)
+			return -EINVAL;
+		if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
+			return -EFAULT;
+		sr->len = iomsg->fast_iov[0].iov_len;
+		iomsg->free_iov = NULL;
+	} else {
+		iomsg->free_iov = iomsg->fast_iov;
+		ret = __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
+				     &iomsg->free_iov, &iomsg->msg.msg_iter,
+				     false);
+		if (ret > 0)
+			ret = 0;
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
+					struct io_async_msghdr *iomsg)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct compat_iovec __user *uiov;
+	compat_uptr_t ptr;
+	compat_size_t len;
+	int ret;
+
+	ret = __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr,
+				  &ptr, &len);
+	if (ret)
+		return ret;
+
+	uiov = compat_ptr(ptr);
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		compat_ssize_t clen;
+
+		if (len > 1)
+			return -EINVAL;
+		if (!access_ok(uiov, sizeof(*uiov)))
+			return -EFAULT;
+		if (__get_user(clen, &uiov->iov_len))
+			return -EFAULT;
+		if (clen < 0)
+			return -EINVAL;
+		sr->len = clen;
+		iomsg->free_iov = NULL;
+	} else {
+		iomsg->free_iov = iomsg->fast_iov;
+		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
+				   UIO_FASTIOV, &iomsg->free_iov,
+				   &iomsg->msg.msg_iter, true);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+#endif
+
+static int io_recvmsg_copy_hdr(struct io_kiocb *req,
+			       struct io_async_msghdr *iomsg)
+{
+	iomsg->msg.msg_name = &iomsg->addr;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		return __io_compat_recvmsg_copy_hdr(req, iomsg);
+#endif
+
+	return __io_recvmsg_copy_hdr(req, iomsg);
+}
+
+static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
+					       bool needs_lock)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct io_buffer *kbuf;
+
+	kbuf = io_buffer_select(req, &sr->len, sr->bgid, sr->kbuf, needs_lock);
+	if (IS_ERR(kbuf))
+		return kbuf;
+
+	sr->kbuf = kbuf;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+	return kbuf;
+}
+
+static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
+{
+	return io_put_kbuf(req, req->sr_msg.kbuf);
+}
+
+static int io_recvmsg_prep_async(struct io_kiocb *req)
+{
+	int ret;
+
+	ret = io_recvmsg_copy_hdr(req, req->async_data);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
+}
+
+static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
+		return -EINVAL;
+
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->len = READ_ONCE(sqe->len);
+	sr->bgid = READ_ONCE(sqe->buf_group);
+	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	if (sr->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+	return 0;
+}
+
+static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_async_msghdr iomsg, *kmsg;
+	struct socket *sock;
+	struct io_buffer *kbuf;
+	unsigned flags;
+	int min_ret = 0;
+	int ret, cflags = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	kmsg = req->async_data;
+	if (!kmsg) {
+		ret = io_recvmsg_copy_hdr(req, &iomsg);
+		if (ret)
+			return ret;
+		kmsg = &iomsg;
+	}
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		kbuf = io_recv_buffer_select(req, !force_nonblock);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
+		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		kmsg->fast_iov[0].iov_len = req->sr_msg.len;
+		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
+				1, req->sr_msg.len);
+	}
+
+	flags = req->sr_msg.msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
+	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
+					kmsg->uaddr, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg);
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		cflags = io_put_recv_kbuf(req);
+	/* fast path, check for non-NULL to avoid function call */
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, cflags);
+	return 0;
+}
+
+static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_buffer *kbuf;
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct msghdr msg;
+	void __user *buf = sr->buf;
+	struct socket *sock;
+	struct iovec iov;
+	unsigned flags;
+	int min_ret = 0;
+	int ret, cflags = 0;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		kbuf = io_recv_buffer_select(req, !force_nonblock);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
+		buf = u64_to_user_ptr(kbuf->addr);
+	}
+
+	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		goto out_free;
+
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+	msg.msg_iocb = NULL;
+	msg.msg_flags = 0;
+
+	flags = req->sr_msg.msg_flags;
+	if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
+	ret = sock_recvmsg(sock, &msg, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+out_free:
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		cflags = io_put_recv_kbuf(req);
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, cflags);
+	return 0;
+}
+
+static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_accept *accept = &req->accept;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->buf_index)
+		return -EINVAL;
+
+	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	accept->flags = READ_ONCE(sqe->accept_flags);
+	accept->nofile = rlimit(RLIMIT_NOFILE);
+
+	accept->file_slot = READ_ONCE(sqe->file_index);
+	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
+		return -EINVAL;
+	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+		return -EINVAL;
+	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
+		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+	return 0;
+}
+
+static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_accept *accept = &req->accept;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
+	bool fixed = !!accept->file_slot;
+	struct file *file;
+	int ret, fd;
+
+	if (req->file->f_flags & O_NONBLOCK)
+		req->flags |= REQ_F_NOWAIT;
+
+	if (!fixed) {
+		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
+		if (unlikely(fd < 0))
+			return fd;
+	}
+	file = do_accept(req->file, file_flags, accept->addr, accept->addr_len,
+			 accept->flags);
+	if (IS_ERR(file)) {
+		if (!fixed)
+			put_unused_fd(fd);
+		ret = PTR_ERR(file);
+		if (ret == -EAGAIN && force_nonblock)
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	} else if (!fixed) {
+		fd_install(fd, file);
+		ret = fd;
+	} else {
+		ret = io_install_fixed_file(req, file, issue_flags,
+					    accept->file_slot - 1);
+	}
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int io_connect_prep_async(struct io_kiocb *req)
+{
+	struct io_async_connect *io = req->async_data;
+	struct io_connect *conn = &req->connect;
+
+	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->address);
+}
+
+static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_connect *conn = &req->connect;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+
+	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	conn->addr_len =  READ_ONCE(sqe->addr2);
+	return 0;
+}
+
+static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_async_connect __io, *io;
+	unsigned file_flags;
+	int ret;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+
+	if (req->async_data) {
+		io = req->async_data;
+	} else {
+		ret = move_addr_to_kernel(req->connect.addr,
+						req->connect.addr_len,
+						&__io.address);
+		if (ret)
+			goto out;
+		io = &__io;
+	}
+
+	file_flags = force_nonblock ? O_NONBLOCK : 0;
+
+	ret = __sys_connect_file(req->file, &io->address,
+					req->connect.addr_len, file_flags);
+	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+		if (req->async_data)
+			return -EAGAIN;
+		if (io_alloc_async_data(req)) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		memcpy(req->async_data, &__io, sizeof(__io));
+		return -EAGAIN;
+	}
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+out:
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+#else /* !CONFIG_NET */
+#define IO_NETOP_FN(op)							\
+static int io_##op(struct io_kiocb *req, unsigned int issue_flags)	\
+{									\
+	return -EOPNOTSUPP;						\
+}
+
+#define IO_NETOP_PREP(op)						\
+IO_NETOP_FN(op)								\
+static int io_##op##_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe) \
+{									\
+	return -EOPNOTSUPP;						\
+}									\
+
+#define IO_NETOP_PREP_ASYNC(op)						\
+IO_NETOP_PREP(op)							\
+static int io_##op##_prep_async(struct io_kiocb *req)			\
+{									\
+	return -EOPNOTSUPP;						\
+}
+
+IO_NETOP_PREP_ASYNC(sendmsg);
+IO_NETOP_PREP_ASYNC(recvmsg);
+IO_NETOP_PREP_ASYNC(connect);
+IO_NETOP_PREP(accept);
+IO_NETOP_FN(send);
+IO_NETOP_FN(recv);
+#endif /* CONFIG_NET */
+
+struct io_poll_table {
+	struct poll_table_struct pt;
+	struct io_kiocb *req;
+	int nr_entries;
+	int error;
+};
+
+#define IO_POLL_CANCEL_FLAG	BIT(31)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS       128
+
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (v & IO_POLL_REF_MASK)
+		return false;
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
+
+/*
+ * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
+ * bump it and acquire ownership. It's disallowed to modify requests while not
+ * owning it, that prevents from races for enqueueing task_work's and b/w
+ * arming poll and wakeups.
+ */
+static inline bool io_poll_get_ownership(struct io_kiocb *req)
+{
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
+
+static void io_poll_mark_cancelled(struct io_kiocb *req)
+{
+	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
+}
+
+static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
+{
+	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return req->async_data;
+	return req->apoll->double_poll;
+}
+
+static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return &req->poll;
+	return &req->apoll->poll;
+}
+
+static void io_poll_req_insert(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct hlist_head *list;
+
+	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
+	hlist_add_head(&req->hash_node, list);
+}
+
+static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
+			      wait_queue_func_t wake_func)
+{
+	poll->head = NULL;
+#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
+	/* mask in events that we always want/need */
+	poll->events = events | IO_POLL_UNMASK;
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, wake_func);
+}
+
+static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
+{
+	struct wait_queue_head *head = smp_load_acquire(&poll->head);
+
+	if (head) {
+		spin_lock_irq(&head->lock);
+		list_del_init(&poll->wait.entry);
+		poll->head = NULL;
+		spin_unlock_irq(&head->lock);
+	}
+}
+
+static void io_poll_remove_entries(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = io_poll_get_single(req);
+	struct io_poll_iocb *poll_double = io_poll_get_double(req);
+
+	/*
+	 * While we hold the waitqueue lock and the waitqueue is nonempty,
+	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
+	 * lock in the first place can race with the waitqueue being freed.
+	 *
+	 * We solve this as eventpoll does: by taking advantage of the fact that
+	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
+	 * we enter rcu_read_lock() and see that the pointer to the queue is
+	 * non-NULL, we can then lock it without the memory being freed out from
+	 * under us.
+	 *
+	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
+	 * case the caller deletes the entry from the queue, leaving it empty.
+	 * In that case, only RCU prevents the queue memory from being freed.
+	 */
+	rcu_read_lock();
+	io_poll_remove_entry(poll);
+	if (poll_double)
+		io_poll_remove_entry(poll_double);
+	rcu_read_unlock();
+}
+
+/*
+ * All poll tw should go through this. Checks for poll events, manages
+ * references, does rewait, etc.
+ *
+ * Returns a negative error on failure. >0 when no action require, which is
+ * either spurious wakeup or multishot CQE is served. 0 when it's done with
+ * the request, then the mask is stored in req->result.
+ */
+static int io_poll_check_events(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_poll_iocb *poll = io_poll_get_single(req);
+	int v;
+
+	/* req->task == current here, checking PF_EXITING is safe */
+	if (unlikely(req->task->flags & PF_EXITING))
+		io_poll_mark_cancelled(req);
+
+	do {
+		v = atomic_read(&req->poll_refs);
+
+		/* tw handler should be the owner, and so have some references */
+		if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
+			return 0;
+		if (v & IO_POLL_CANCEL_FLAG)
+			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->result = 0;
+		if (v & IO_POLL_RETRY_FLAG) {
+			req->result = 0;
+			/*
+			 * We won't find new events that came in between
+			 * vfs_poll and the ref put unless we clear the
+			 * flag in advance.
+			 */
+			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+			v &= ~IO_POLL_RETRY_FLAG;
+		}
+
+		if (!req->result) {
+			struct poll_table_struct pt = { ._key = poll->events };
+
+			req->result = vfs_poll(req->file, &pt) & poll->events;
+		}
+
+		/* multishot, just fill an CQE and proceed */
+		if (req->result && !(poll->events & EPOLLONESHOT)) {
+			__poll_t mask = mangle_poll(req->result & poll->events);
+			bool filled;
+
+			spin_lock(&ctx->completion_lock);
+			filled = io_fill_cqe_aux(ctx, req->user_data, mask,
+						 IORING_CQE_F_MORE);
+			io_commit_cqring(ctx);
+			spin_unlock(&ctx->completion_lock);
+			if (unlikely(!filled))
+				return -ECANCELED;
+			io_cqring_ev_posted(ctx);
+		} else if (req->result) {
+			return 0;
+		}
+
+		/* force the next iteration to vfs_poll() */
+		req->result = 0;
+
+		/*
+		 * Release all references, retry if someone tried to restart
+		 * task_work while we were executing it.
+		 */
+	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
+					IO_POLL_REF_MASK);
+
+	return 1;
+}
+
+static void io_poll_task_func(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	ret = io_poll_check_events(req);
+	if (ret > 0)
+		return;
+
+	if (!ret) {
+		req->result = mangle_poll(req->result & req->poll.events);
+	} else {
+		req->result = ret;
+		req_set_fail(req);
+	}
+
+	io_poll_remove_entries(req);
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	spin_unlock(&ctx->completion_lock);
+	io_req_complete_post(req, req->result, 0);
+}
+
+static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	ret = io_poll_check_events(req);
+	if (ret > 0)
+		return;
+
+	io_poll_remove_entries(req);
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	spin_unlock(&ctx->completion_lock);
+
+	if (!ret)
+		io_req_task_submit(req, locked);
+	else
+		io_req_complete_failed(req, ret);
+}
+
+static void __io_poll_execute(struct io_kiocb *req, int mask)
+{
+	req->result = mask;
+	if (req->opcode == IORING_OP_POLL_ADD)
+		req->io_task_work.func = io_poll_task_func;
+	else
+		req->io_task_work.func = io_apoll_task_func;
+
+	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+	io_req_task_work_add(req);
+}
+
+static inline void io_poll_execute(struct io_kiocb *req, int res)
+{
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, res);
+}
+
+static void io_poll_cancel_req(struct io_kiocb *req)
+{
+	io_poll_mark_cancelled(req);
+	/* kick tw, which should complete the request */
+	io_poll_execute(req, 0);
+}
+
+static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+			void *key)
+{
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = container_of(wait, struct io_poll_iocb,
+						 wait);
+	__poll_t mask = key_to_poll(key);
+
+	if (unlikely(mask & POLLFREE)) {
+		io_poll_mark_cancelled(req);
+		/* we have to kick tw in case it's not already */
+		io_poll_execute(req, 0);
+
+		/*
+		 * If the waitqueue is being freed early but someone is already
+		 * holds ownership over it, we have to tear down the request as
+		 * best we can. That means immediately removing the request from
+		 * its waitqueue and preventing all further accesses to the
+		 * waitqueue via the request.
+		 */
+		list_del_init(&poll->wait.entry);
+
+		/*
+		 * Careful: this *must* be the last step, since as soon
+		 * as req->head is NULL'ed out, the request can be
+		 * completed and freed, since aio_poll_complete_work()
+		 * will no longer need to take the waitqueue lock.
+		 */
+		smp_store_release(&poll->head, NULL);
+		return 1;
+	}
+
+	/* for instances that support it check for an event match first */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, mask);
+	return 1;
+}
+
+static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
+			    struct wait_queue_head *head,
+			    struct io_poll_iocb **poll_ptr)
+{
+	struct io_kiocb *req = pt->req;
+
+	/*
+	 * The file being polled uses multiple waitqueues for poll handling
+	 * (e.g. one for read, one for write). Setup a separate io_poll_iocb
+	 * if this happens.
+	 */
+	if (unlikely(pt->nr_entries)) {
+		struct io_poll_iocb *first = poll;
+
+		/* double add on the same waitqueue head, ignore */
+		if (first->head == head)
+			return;
+		/* already have a 2nd entry, fail a third attempt */
+		if (*poll_ptr) {
+			if ((*poll_ptr)->head == head)
+				return;
+			pt->error = -EINVAL;
+			return;
+		}
+
+		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
+		if (!poll) {
+			pt->error = -ENOMEM;
+			return;
+		}
+		io_init_poll_iocb(poll, first->events, first->wait.func);
+		*poll_ptr = poll;
+	}
+
+	pt->nr_entries++;
+	poll->head = head;
+	poll->wait.private = req;
+
+	if (poll->events & EPOLLEXCLUSIVE)
+		add_wait_queue_exclusive(head, &poll->wait);
+	else
+		add_wait_queue(head, &poll->wait);
+}
+
+static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
+			       struct poll_table_struct *p)
+{
+	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+
+	__io_queue_proc(&pt->req->poll, pt, head,
+			(struct io_poll_iocb **) &pt->req->async_data);
+}
+
+static int __io_arm_poll_handler(struct io_kiocb *req,
+				 struct io_poll_iocb *poll,
+				 struct io_poll_table *ipt, __poll_t mask)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	INIT_HLIST_NODE(&req->hash_node);
+	io_init_poll_iocb(poll, mask, io_poll_wake);
+	poll->file = req->file;
+	poll->wait.private = req;
+
+	ipt->pt._key = mask;
+	ipt->req = req;
+	ipt->error = 0;
+	ipt->nr_entries = 0;
+
+	/*
+	 * Take the ownership to delay any tw execution up until we're done
+	 * with poll arming. see io_poll_get_ownership().
+	 */
+	atomic_set(&req->poll_refs, 1);
+	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
+
+	if (mask && (poll->events & EPOLLONESHOT)) {
+		io_poll_remove_entries(req);
+		/* no one else has access to the req, forget about the ref */
+		return mask;
+	}
+	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
+		io_poll_remove_entries(req);
+		if (!ipt->error)
+			ipt->error = -EINVAL;
+		return 0;
+	}
+
+	spin_lock(&ctx->completion_lock);
+	io_poll_req_insert(req);
+	spin_unlock(&ctx->completion_lock);
+
+	if (mask) {
+		/* can't multishot if failed, just queue the event we've got */
+		if (unlikely(ipt->error || !ipt->nr_entries)) {
+			poll->events |= EPOLLONESHOT;
+			ipt->error = 0;
+		}
+		__io_poll_execute(req, mask);
+		return 0;
+	}
+
+	/*
+	 * Try to release ownership. If we see a change of state, e.g.
+	 * poll was waken up, queue up a tw, it'll deal with it.
+	 */
+	if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
+		__io_poll_execute(req, 0);
+	return 0;
+}
+
+static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+			       struct poll_table_struct *p)
+{
+	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+	struct async_poll *apoll = pt->req->apoll;
+
+	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
+}
+
+enum {
+	IO_APOLL_OK,
+	IO_APOLL_ABORTED,
+	IO_APOLL_READY
+};
+
+static int io_arm_poll_handler(struct io_kiocb *req)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_ring_ctx *ctx = req->ctx;
+	struct async_poll *apoll;
+	struct io_poll_table ipt;
+	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	int ret;
+
+	if (!req->file || !file_can_poll(req->file))
+		return IO_APOLL_ABORTED;
+	if (req->flags & REQ_F_POLLED)
+		return IO_APOLL_ABORTED;
+	if (!def->pollin && !def->pollout)
+		return IO_APOLL_ABORTED;
+
+	if (def->pollin) {
+		mask |= POLLIN | POLLRDNORM;
+
+		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
+		if ((req->opcode == IORING_OP_RECVMSG) &&
+		    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
+			mask &= ~POLLIN;
+	} else {
+		mask |= POLLOUT | POLLWRNORM;
+	}
+
+	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+	if (unlikely(!apoll))
+		return IO_APOLL_ABORTED;
+	apoll->double_poll = NULL;
+	req->apoll = apoll;
+	req->flags |= REQ_F_POLLED;
+	ipt.pt._qproc = io_async_queue_proc;
+
+	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
+	if (ret || ipt.error)
+		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
+
+	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
+				mask, apoll->poll.events);
+	return IO_APOLL_OK;
+}
+
+/*
+ * Returns true if we found and killed one or more poll requests
+ */
+static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			       bool cancel_all)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	bool found = false;
+	int i;
+
+	spin_lock(&ctx->completion_lock);
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list;
+
+		list = &ctx->cancel_hash[i];
+		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+			if (io_match_task_safe(req, tsk, cancel_all)) {
+				hlist_del_init(&req->hash_node);
+				io_poll_cancel_req(req);
+				found = true;
+			}
+		}
+	}
+	spin_unlock(&ctx->completion_lock);
+	return found;
+}
+
+static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
+				     bool poll_only)
+	__must_hold(&ctx->completion_lock)
+{
+	struct hlist_head *list;
+	struct io_kiocb *req;
+
+	list = &ctx->cancel_hash[hash_long(sqe_addr, ctx->cancel_hash_bits)];
+	hlist_for_each_entry(req, list, hash_node) {
+		if (sqe_addr != req->user_data)
+			continue;
+		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
+			continue;
+		return req;
+	}
+	return NULL;
+}
+
+static bool io_poll_disarm(struct io_kiocb *req)
+	__must_hold(&ctx->completion_lock)
+{
+	if (!io_poll_get_ownership(req))
+		return false;
+	io_poll_remove_entries(req);
+	hash_del(&req->hash_node);
+	return true;
+}
+
+static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
+			  bool poll_only)
+	__must_hold(&ctx->completion_lock)
+{
+	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, poll_only);
+
+	if (!req)
+		return -ENOENT;
+	io_poll_cancel_req(req);
+	return 0;
+}
+
+static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
+				     unsigned int flags)
+{
+	u32 events;
+
+	events = READ_ONCE(sqe->poll32_events);
+#ifdef __BIG_ENDIAN
+	events = swahw32(events);
+#endif
+	if (!(flags & IORING_POLL_ADD_MULTI))
+		events |= EPOLLONESHOT;
+	return demangle_poll(events) | (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
+}
+
+static int io_poll_update_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
+{
+	struct io_poll_update *upd = &req->poll_update;
+	u32 flags;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+	flags = READ_ONCE(sqe->len);
+	if (flags & ~(IORING_POLL_UPDATE_EVENTS | IORING_POLL_UPDATE_USER_DATA |
+		      IORING_POLL_ADD_MULTI))
+		return -EINVAL;
+	/* meaningless without update */
+	if (flags == IORING_POLL_ADD_MULTI)
+		return -EINVAL;
+
+	upd->old_user_data = READ_ONCE(sqe->addr);
+	upd->update_events = flags & IORING_POLL_UPDATE_EVENTS;
+	upd->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
+
+	upd->new_user_data = READ_ONCE(sqe->off);
+	if (!upd->update_user_data && upd->new_user_data)
+		return -EINVAL;
+	if (upd->update_events)
+		upd->events = io_poll_parse_events(sqe, flags);
+	else if (sqe->poll32_events)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_poll_iocb *poll = &req->poll;
+	u32 flags;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->addr)
+		return -EINVAL;
+	flags = READ_ONCE(sqe->len);
+	if (flags & ~IORING_POLL_ADD_MULTI)
+		return -EINVAL;
+
+	io_req_set_refcount(req);
+	poll->events = io_poll_parse_events(sqe, flags);
+	return 0;
+}
+
+static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_poll_iocb *poll = &req->poll;
+	struct io_poll_table ipt;
+	int ret;
+
+	ipt.pt._qproc = io_poll_queue_proc;
+
+	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	if (!ret && ipt.error)
+		req_set_fail(req);
+	ret = ret ?: ipt.error;
+	if (ret)
+		__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *preq;
+	int ret2, ret = 0;
+
+	spin_lock(&ctx->completion_lock);
+	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
+	if (!preq || !io_poll_disarm(preq)) {
+		spin_unlock(&ctx->completion_lock);
+		ret = preq ? -EALREADY : -ENOENT;
+		goto out;
+	}
+	spin_unlock(&ctx->completion_lock);
+
+	if (req->poll_update.update_events || req->poll_update.update_user_data) {
+		/* only mask one event flags, keep behavior flags */
+		if (req->poll_update.update_events) {
+			preq->poll.events &= ~0xffff;
+			preq->poll.events |= req->poll_update.events & 0xffff;
+			preq->poll.events |= IO_POLL_UNMASK;
+		}
+		if (req->poll_update.update_user_data)
+			preq->user_data = req->poll_update.new_user_data;
+
+		ret2 = io_poll_add(preq, issue_flags);
+		/* successfully updated, don't complete poll request */
+		if (!ret2)
+			goto out;
+	}
+	req_set_fail(preq);
+	io_req_complete(preq, -ECANCELED);
+out:
+	if (ret < 0)
+		req_set_fail(req);
+	/* complete update request, we're done with it */
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
+{
+	req_set_fail(req);
+	io_req_complete_post(req, -ETIME, 0);
+}
+
+static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
+{
+	struct io_timeout_data *data = container_of(timer,
+						struct io_timeout_data, timer);
+	struct io_kiocb *req = data->req;
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->timeout_lock, flags);
+	list_del_init(&req->timeout.list);
+	atomic_set(&req->ctx->cq_timeouts,
+		atomic_read(&req->ctx->cq_timeouts) + 1);
+	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
+
+	req->io_task_work.func = io_req_task_timeout;
+	io_req_task_work_add(req);
+	return HRTIMER_NORESTART;
+}
+
+static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
+					   __u64 user_data)
+	__must_hold(&ctx->timeout_lock)
+{
+	struct io_timeout_data *io;
+	struct io_kiocb *req;
+	bool found = false;
+
+	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
+		found = user_data == req->user_data;
+		if (found)
+			break;
+	}
+	if (!found)
+		return ERR_PTR(-ENOENT);
+
+	io = req->async_data;
+	if (hrtimer_try_to_cancel(&io->timer) == -1)
+		return ERR_PTR(-EALREADY);
+	list_del_init(&req->timeout.list);
+	return req;
+}
+
+static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
+	__must_hold(&ctx->completion_lock)
+	__must_hold(&ctx->timeout_lock)
+{
+	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	req_set_fail(req);
+	io_fill_cqe_req(req, -ECANCELED, 0);
+	io_put_req_deferred(req);
+	return 0;
+}
+
+static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
+{
+	switch (data->flags & IORING_TIMEOUT_CLOCK_MASK) {
+	case IORING_TIMEOUT_BOOTTIME:
+		return CLOCK_BOOTTIME;
+	case IORING_TIMEOUT_REALTIME:
+		return CLOCK_REALTIME;
+	default:
+		/* can't happen, vetted at prep time */
+		WARN_ON_ONCE(1);
+		fallthrough;
+	case 0:
+		return CLOCK_MONOTONIC;
+	}
+}
+
+static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
+				    struct timespec64 *ts, enum hrtimer_mode mode)
+	__must_hold(&ctx->timeout_lock)
+{
+	struct io_timeout_data *io;
+	struct io_kiocb *req;
+	bool found = false;
+
+	list_for_each_entry(req, &ctx->ltimeout_list, timeout.list) {
+		found = user_data == req->user_data;
+		if (found)
+			break;
+	}
+	if (!found)
+		return -ENOENT;
+
+	io = req->async_data;
+	if (hrtimer_try_to_cancel(&io->timer) == -1)
+		return -EALREADY;
+	hrtimer_init(&io->timer, io_timeout_get_clock(io), mode);
+	io->timer.function = io_link_timeout_fn;
+	hrtimer_start(&io->timer, timespec64_to_ktime(*ts), mode);
+	return 0;
+}
+
+static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
+			     struct timespec64 *ts, enum hrtimer_mode mode)
+	__must_hold(&ctx->timeout_lock)
+{
+	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+	struct io_timeout_data *data;
+
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	req->timeout.off = 0; /* noseq */
+	data = req->async_data;
+	list_add_tail(&req->timeout.list, &ctx->timeout_list);
+	hrtimer_init(&data->timer, io_timeout_get_clock(data), mode);
+	data->timer.function = io_timeout_fn;
+	hrtimer_start(&data->timer, timespec64_to_ktime(*ts), mode);
+	return 0;
+}
+
+static int io_timeout_remove_prep(struct io_kiocb *req,
+				  const struct io_uring_sqe *sqe)
+{
+	struct io_timeout_rem *tr = &req->timeout_rem;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->splice_fd_in)
+		return -EINVAL;
+
+	tr->ltimeout = false;
+	tr->addr = READ_ONCE(sqe->addr);
+	tr->flags = READ_ONCE(sqe->timeout_flags);
+	if (tr->flags & IORING_TIMEOUT_UPDATE_MASK) {
+		if (hweight32(tr->flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
+			return -EINVAL;
+		if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
+			tr->ltimeout = true;
+		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
+			return -EINVAL;
+		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
+			return -EFAULT;
+	} else if (tr->flags) {
+		/* timeout removal doesn't support flags */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline enum hrtimer_mode io_translate_timeout_mode(unsigned int flags)
+{
+	return (flags & IORING_TIMEOUT_ABS) ? HRTIMER_MODE_ABS
+					    : HRTIMER_MODE_REL;
+}
+
+/*
+ * Remove or update an existing timeout command
+ */
+static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_timeout_rem *tr = &req->timeout_rem;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE)) {
+		spin_lock(&ctx->completion_lock);
+		spin_lock_irq(&ctx->timeout_lock);
+		ret = io_timeout_cancel(ctx, tr->addr);
+		spin_unlock_irq(&ctx->timeout_lock);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		enum hrtimer_mode mode = io_translate_timeout_mode(tr->flags);
+
+		spin_lock_irq(&ctx->timeout_lock);
+		if (tr->ltimeout)
+			ret = io_linked_timeout_update(ctx, tr->addr, &tr->ts, mode);
+		else
+			ret = io_timeout_update(ctx, tr->addr, &tr->ts, mode);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete_post(req, ret, 0);
+	return 0;
+}
+
+static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   bool is_timeout_link)
+{
+	struct io_timeout_data *data;
+	unsigned flags;
+	u32 off = READ_ONCE(sqe->off);
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+	if (off && is_timeout_link)
+		return -EINVAL;
+	flags = READ_ONCE(sqe->timeout_flags);
+	if (flags & ~(IORING_TIMEOUT_ABS | IORING_TIMEOUT_CLOCK_MASK))
+		return -EINVAL;
+	/* more than one clock specified is invalid, obviously */
+	if (hweight32(flags & IORING_TIMEOUT_CLOCK_MASK) > 1)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&req->timeout.list);
+	req->timeout.off = off;
+	if (unlikely(off && !req->ctx->off_timeout_used))
+		req->ctx->off_timeout_used = true;
+
+	if (!req->async_data && io_alloc_async_data(req))
+		return -ENOMEM;
+
+	data = req->async_data;
+	data->req = req;
+	data->flags = flags;
+
+	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
+		return -EFAULT;
+
+	INIT_LIST_HEAD(&req->timeout.list);
+	data->mode = io_translate_timeout_mode(flags);
+	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
+
+	if (is_timeout_link) {
+		struct io_submit_link *link = &req->ctx->submit_state.link;
+
+		if (!link->head)
+			return -EINVAL;
+		if (link->last->opcode == IORING_OP_LINK_TIMEOUT)
+			return -EINVAL;
+		req->timeout.head = link->last;
+		link->last->flags |= REQ_F_ARM_LTIMEOUT;
+	}
+	return 0;
+}
+
+static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_timeout_data *data = req->async_data;
+	struct list_head *entry;
+	u32 tail, off = req->timeout.off;
+
+	spin_lock_irq(&ctx->timeout_lock);
+
+	/*
+	 * sqe->off holds how many events that need to occur for this
+	 * timeout event to be satisfied. If it isn't set, then this is
+	 * a pure timeout request, sequence isn't used.
+	 */
+	if (io_is_timeout_noseq(req)) {
+		entry = ctx->timeout_list.prev;
+		goto add;
+	}
+
+	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	req->timeout.target_seq = tail + off;
+
+	/* Update the last seq here in case io_flush_timeouts() hasn't.
+	 * This is safe because ->completion_lock is held, and submissions
+	 * and completions are never mixed in the same ->completion_lock section.
+	 */
+	ctx->cq_last_tm_flush = tail;
+
+	/*
+	 * Insertion sort, ensuring the first entry in the list is always
+	 * the one we need first.
+	 */
+	list_for_each_prev(entry, &ctx->timeout_list) {
+		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb,
+						  timeout.list);
+
+		if (io_is_timeout_noseq(nxt))
+			continue;
+		/* nxt.seq is behind @tail, otherwise would've been completed */
+		if (off >= nxt->timeout.target_seq - tail)
+			break;
+	}
+add:
+	list_add(&req->timeout.list, entry);
+	data->timer.function = io_timeout_fn;
+	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
+	spin_unlock_irq(&ctx->timeout_lock);
+	return 0;
+}
+
+struct io_cancel_data {
+	struct io_ring_ctx *ctx;
+	u64 user_data;
+};
+
+static bool io_cancel_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_cancel_data *cd = data;
+
+	return req->ctx == cd->ctx && req->user_data == cd->user_data;
+}
+
+static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
+			       struct io_ring_ctx *ctx)
+{
+	struct io_cancel_data data = { .ctx = ctx, .user_data = user_data, };
+	enum io_wq_cancel cancel_ret;
+	int ret = 0;
+
+	if (!tctx || !tctx->io_wq)
+		return -ENOENT;
+
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, &data, false);
+	switch (cancel_ret) {
+	case IO_WQ_CANCEL_OK:
+		ret = 0;
+		break;
+	case IO_WQ_CANCEL_RUNNING:
+		ret = -EALREADY;
+		break;
+	case IO_WQ_CANCEL_NOTFOUND:
+		ret = -ENOENT;
+		break;
+	}
+
+	return ret;
+}
+
+static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
+
+	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
+	if (ret != -ENOENT)
+		return ret;
+
+	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
+	ret = io_timeout_cancel(ctx, sqe_addr);
+	spin_unlock_irq(&ctx->timeout_lock);
+	if (ret != -ENOENT)
+		goto out;
+	ret = io_poll_cancel(ctx, sqe_addr, false);
+out:
+	spin_unlock(&ctx->completion_lock);
+	return ret;
+}
+
+static int io_async_cancel_prep(struct io_kiocb *req,
+				const struct io_uring_sqe *sqe)
+{
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
+	    sqe->splice_fd_in)
+		return -EINVAL;
+
+	req->cancel.addr = READ_ONCE(sqe->addr);
+	return 0;
+}
+
+static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	u64 sqe_addr = req->cancel.addr;
+	struct io_tctx_node *node;
+	int ret;
+
+	ret = io_try_cancel_userdata(req, sqe_addr);
+	if (ret != -ENOENT)
+		goto done;
+
+	/* slow path, try all io-wq's */
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	ret = -ENOENT;
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
+		if (ret != -ENOENT)
+			break;
+	}
+	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+done:
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete_post(req, ret, 0);
+	return 0;
+}
+
+static int io_rsrc_update_prep(struct io_kiocb *req,
+				const struct io_uring_sqe *sqe)
+{
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
+		return -EINVAL;
+
+	req->rsrc_update.offset = READ_ONCE(sqe->off);
+	req->rsrc_update.nr_args = READ_ONCE(sqe->len);
+	if (!req->rsrc_update.nr_args)
+		return -EINVAL;
+	req->rsrc_update.arg = READ_ONCE(sqe->addr);
+	return 0;
+}
+
+static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_rsrc_update2 up;
+	int ret;
+
+	up.offset = req->rsrc_update.offset;
+	up.data = req->rsrc_update.arg;
+	up.nr = 0;
+	up.tags = 0;
+	up.resv = 0;
+	up.resv2 = 0;
+
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
+					&up, req->rsrc_update.nr_args);
+	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+
+	if (ret < 0)
+		req_set_fail(req);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
+static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	switch (req->opcode) {
+	case IORING_OP_NOP:
+		return 0;
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
+		return io_read_prep(req, sqe);
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		return io_write_prep(req, sqe);
+	case IORING_OP_POLL_ADD:
+		return io_poll_add_prep(req, sqe);
+	case IORING_OP_POLL_REMOVE:
+		return io_poll_update_prep(req, sqe);
+	case IORING_OP_FSYNC:
+		return io_fsync_prep(req, sqe);
+	case IORING_OP_SYNC_FILE_RANGE:
+		return io_sfr_prep(req, sqe);
+	case IORING_OP_SENDMSG:
+	case IORING_OP_SEND:
+		return io_sendmsg_prep(req, sqe);
+	case IORING_OP_RECVMSG:
+	case IORING_OP_RECV:
+		return io_recvmsg_prep(req, sqe);
+	case IORING_OP_CONNECT:
+		return io_connect_prep(req, sqe);
+	case IORING_OP_TIMEOUT:
+		return io_timeout_prep(req, sqe, false);
+	case IORING_OP_TIMEOUT_REMOVE:
+		return io_timeout_remove_prep(req, sqe);
+	case IORING_OP_ASYNC_CANCEL:
+		return io_async_cancel_prep(req, sqe);
+	case IORING_OP_LINK_TIMEOUT:
+		return io_timeout_prep(req, sqe, true);
+	case IORING_OP_ACCEPT:
+		return io_accept_prep(req, sqe);
+	case IORING_OP_FALLOCATE:
+		return io_fallocate_prep(req, sqe);
+	case IORING_OP_OPENAT:
+		return io_openat_prep(req, sqe);
+	case IORING_OP_CLOSE:
+		return io_close_prep(req, sqe);
+	case IORING_OP_FILES_UPDATE:
+		return io_rsrc_update_prep(req, sqe);
+	case IORING_OP_STATX:
+		return io_statx_prep(req, sqe);
+	case IORING_OP_FADVISE:
+		return io_fadvise_prep(req, sqe);
+	case IORING_OP_MADVISE:
+		return io_madvise_prep(req, sqe);
+	case IORING_OP_OPENAT2:
+		return io_openat2_prep(req, sqe);
+	case IORING_OP_EPOLL_CTL:
+		return io_epoll_ctl_prep(req, sqe);
+	case IORING_OP_SPLICE:
+		return io_splice_prep(req, sqe);
+	case IORING_OP_PROVIDE_BUFFERS:
+		return io_provide_buffers_prep(req, sqe);
+	case IORING_OP_REMOVE_BUFFERS:
+		return io_remove_buffers_prep(req, sqe);
+	case IORING_OP_TEE:
+		return io_tee_prep(req, sqe);
+	case IORING_OP_SHUTDOWN:
+		return io_shutdown_prep(req, sqe);
+	case IORING_OP_RENAMEAT:
+		return io_renameat_prep(req, sqe);
+	case IORING_OP_UNLINKAT:
+		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
+	case IORING_OP_SYMLINKAT:
+		return io_symlinkat_prep(req, sqe);
+	case IORING_OP_LINKAT:
+		return io_linkat_prep(req, sqe);
+	}
+
+	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
+			req->opcode);
+	return -EINVAL;
+}
+
+static int io_req_prep_async(struct io_kiocb *req)
+{
+	if (!io_op_defs[req->opcode].needs_async_setup)
+		return 0;
+	if (WARN_ON_ONCE(req->async_data))
+		return -EFAULT;
+	if (io_alloc_async_data(req))
+		return -EAGAIN;
+
+	switch (req->opcode) {
+	case IORING_OP_READV:
+		return io_rw_prep_async(req, READ);
+	case IORING_OP_WRITEV:
+		return io_rw_prep_async(req, WRITE);
+	case IORING_OP_SENDMSG:
+		return io_sendmsg_prep_async(req);
+	case IORING_OP_RECVMSG:
+		return io_recvmsg_prep_async(req);
+	case IORING_OP_CONNECT:
+		return io_connect_prep_async(req);
+	}
+	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
+		    req->opcode);
+	return -EFAULT;
+}
+
+static u32 io_get_sequence(struct io_kiocb *req)
+{
+	u32 seq = req->ctx->cached_sq_head;
+
+	/* need original cached_sq_head, but it was increased for each req */
+	io_for_each_link(req, req)
+		seq--;
+	return seq;
+}
+
+static bool io_drain_req(struct io_kiocb *req)
+{
+	struct io_kiocb *pos;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_defer_entry *de;
+	int ret;
+	u32 seq;
+
+	if (req->flags & REQ_F_FAIL) {
+		io_req_complete_fail_submit(req);
+		return true;
+	}
+
+	/*
+	 * If we need to drain a request in the middle of a link, drain the
+	 * head request and the next request/link after the current link.
+	 * Considering sequential execution of links, IOSQE_IO_DRAIN will be
+	 * maintained for every request of our link.
+	 */
+	if (ctx->drain_next) {
+		req->flags |= REQ_F_IO_DRAIN;
+		ctx->drain_next = false;
+	}
+	/* not interested in head, start from the first linked */
+	io_for_each_link(pos, req->link) {
+		if (pos->flags & REQ_F_IO_DRAIN) {
+			ctx->drain_next = true;
+			req->flags |= REQ_F_IO_DRAIN;
+			break;
+		}
+	}
+
+	/* Still need defer if there is pending req in defer list. */
+	spin_lock(&ctx->completion_lock);
+	if (likely(list_empty_careful(&ctx->defer_list) &&
+		!(req->flags & REQ_F_IO_DRAIN))) {
+		spin_unlock(&ctx->completion_lock);
+		ctx->drain_active = false;
+		return false;
+	}
+	spin_unlock(&ctx->completion_lock);
+
+	seq = io_get_sequence(req);
+	/* Still a chance to pass the sequence check */
+	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
+		return false;
+
+	ret = io_req_prep_async(req);
+	if (ret)
+		goto fail;
+	io_prep_async_link(req);
+	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	if (!de) {
+		ret = -ENOMEM;
+fail:
+		io_req_complete_failed(req, ret);
+		return true;
+	}
+
+	spin_lock(&ctx->completion_lock);
+	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
+		spin_unlock(&ctx->completion_lock);
+		kfree(de);
+		io_queue_async_work(req, NULL);
+		return true;
+	}
+
+	trace_io_uring_defer(ctx, req, req->user_data);
+	de->req = req;
+	de->seq = seq;
+	list_add_tail(&de->list, &ctx->defer_list);
+	spin_unlock(&ctx->completion_lock);
+	return true;
+}
+
+static void io_clean_op(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_BUFFER_SELECTED) {
+		switch (req->opcode) {
+		case IORING_OP_READV:
+		case IORING_OP_READ_FIXED:
+		case IORING_OP_READ:
+			kfree((void *)(unsigned long)req->rw.addr);
+			break;
+		case IORING_OP_RECVMSG:
+		case IORING_OP_RECV:
+			kfree(req->sr_msg.kbuf);
+			break;
+		}
+	}
+
+	if (req->flags & REQ_F_NEED_CLEANUP) {
+		switch (req->opcode) {
+		case IORING_OP_READV:
+		case IORING_OP_READ_FIXED:
+		case IORING_OP_READ:
+		case IORING_OP_WRITEV:
+		case IORING_OP_WRITE_FIXED:
+		case IORING_OP_WRITE: {
+			struct io_async_rw *io = req->async_data;
+
+			kfree(io->free_iovec);
+			break;
+			}
+		case IORING_OP_RECVMSG:
+		case IORING_OP_SENDMSG: {
+			struct io_async_msghdr *io = req->async_data;
+
+			kfree(io->free_iov);
+			break;
+			}
+		case IORING_OP_OPENAT:
+		case IORING_OP_OPENAT2:
+			if (req->open.filename)
+				putname(req->open.filename);
+			break;
+		case IORING_OP_RENAMEAT:
+			putname(req->rename.oldpath);
+			putname(req->rename.newpath);
+			break;
+		case IORING_OP_UNLINKAT:
+			putname(req->unlink.filename);
+			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
+		case IORING_OP_SYMLINKAT:
+			putname(req->symlink.oldpath);
+			putname(req->symlink.newpath);
+			break;
+		case IORING_OP_LINKAT:
+			putname(req->hardlink.oldpath);
+			putname(req->hardlink.newpath);
+			break;
+		}
+	}
+	if ((req->flags & REQ_F_POLLED) && req->apoll) {
+		kfree(req->apoll->double_poll);
+		kfree(req->apoll);
+		req->apoll = NULL;
+	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
+
+		atomic_dec(&tctx->inflight_tracked);
+	}
+	if (req->flags & REQ_F_CREDS)
+		put_cred(req->creds);
+
+	req->flags &= ~IO_REQ_CLEAN_FLAGS;
+}
+
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	const struct cred *creds = NULL;
+	int ret;
+
+	if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
+		creds = override_creds(req->creds);
+
+	switch (req->opcode) {
+	case IORING_OP_NOP:
+		ret = io_nop(req, issue_flags);
+		break;
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
+		ret = io_read(req, issue_flags);
+		break;
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		ret = io_write(req, issue_flags);
+		break;
+	case IORING_OP_FSYNC:
+		ret = io_fsync(req, issue_flags);
+		break;
+	case IORING_OP_POLL_ADD:
+		ret = io_poll_add(req, issue_flags);
+		break;
+	case IORING_OP_POLL_REMOVE:
+		ret = io_poll_update(req, issue_flags);
+		break;
+	case IORING_OP_SYNC_FILE_RANGE:
+		ret = io_sync_file_range(req, issue_flags);
+		break;
+	case IORING_OP_SENDMSG:
+		ret = io_sendmsg(req, issue_flags);
+		break;
+	case IORING_OP_SEND:
+		ret = io_send(req, issue_flags);
+		break;
+	case IORING_OP_RECVMSG:
+		ret = io_recvmsg(req, issue_flags);
+		break;
+	case IORING_OP_RECV:
+		ret = io_recv(req, issue_flags);
+		break;
+	case IORING_OP_TIMEOUT:
+		ret = io_timeout(req, issue_flags);
+		break;
+	case IORING_OP_TIMEOUT_REMOVE:
+		ret = io_timeout_remove(req, issue_flags);
+		break;
+	case IORING_OP_ACCEPT:
+		ret = io_accept(req, issue_flags);
+		break;
+	case IORING_OP_CONNECT:
+		ret = io_connect(req, issue_flags);
+		break;
+	case IORING_OP_ASYNC_CANCEL:
+		ret = io_async_cancel(req, issue_flags);
+		break;
+	case IORING_OP_FALLOCATE:
+		ret = io_fallocate(req, issue_flags);
+		break;
+	case IORING_OP_OPENAT:
+		ret = io_openat(req, issue_flags);
+		break;
+	case IORING_OP_CLOSE:
+		ret = io_close(req, issue_flags);
+		break;
+	case IORING_OP_FILES_UPDATE:
+		ret = io_files_update(req, issue_flags);
+		break;
+	case IORING_OP_STATX:
+		ret = io_statx(req, issue_flags);
+		break;
+	case IORING_OP_FADVISE:
+		ret = io_fadvise(req, issue_flags);
+		break;
+	case IORING_OP_MADVISE:
+		ret = io_madvise(req, issue_flags);
+		break;
+	case IORING_OP_OPENAT2:
+		ret = io_openat2(req, issue_flags);
+		break;
+	case IORING_OP_EPOLL_CTL:
+		ret = io_epoll_ctl(req, issue_flags);
+		break;
+	case IORING_OP_SPLICE:
+		ret = io_splice(req, issue_flags);
+		break;
+	case IORING_OP_PROVIDE_BUFFERS:
+		ret = io_provide_buffers(req, issue_flags);
+		break;
+	case IORING_OP_REMOVE_BUFFERS:
+		ret = io_remove_buffers(req, issue_flags);
+		break;
+	case IORING_OP_TEE:
+		ret = io_tee(req, issue_flags);
+		break;
+	case IORING_OP_SHUTDOWN:
+		ret = io_shutdown(req, issue_flags);
+		break;
+	case IORING_OP_RENAMEAT:
+		ret = io_renameat(req, issue_flags);
+		break;
+	case IORING_OP_UNLINKAT:
+		ret = io_unlinkat(req, issue_flags);
+		break;
+	case IORING_OP_MKDIRAT:
+		ret = io_mkdirat(req, issue_flags);
+		break;
+	case IORING_OP_SYMLINKAT:
+		ret = io_symlinkat(req, issue_flags);
+		break;
+	case IORING_OP_LINKAT:
+		ret = io_linkat(req, issue_flags);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (creds)
+		revert_creds(creds);
+	if (ret)
+		return ret;
+	/* If the op doesn't have a file, we're not polling for it */
+	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+		io_iopoll_req_issued(req);
+
+	return 0;
+}
+
+static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	req = io_put_req_find_next(req);
+	return req ? &req->work : NULL;
+}
+
+static void io_wq_submit_work(struct io_wq_work *work)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *timeout;
+	int ret = 0;
+
+	/* one will be dropped by ->io_free_work() after returning to io-wq */
+	if (!(req->flags & REQ_F_REFCOUNT))
+		__io_req_set_refcount(req, 2);
+	else
+		req_ref_get(req);
+
+	timeout = io_prep_linked_timeout(req);
+	if (timeout)
+		io_queue_linked_timeout(timeout);
+
+	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
+	if (work->flags & IO_WQ_WORK_CANCEL)
+		ret = -ECANCELED;
+
+	if (!ret) {
+		do {
+			ret = io_issue_sqe(req, 0);
+			/*
+			 * We can get EAGAIN for polled IO even though we're
+			 * forcing a sync submission from here, since we can't
+			 * wait for request slots on the block side.
+			 */
+			if (ret != -EAGAIN || !(req->ctx->flags & IORING_SETUP_IOPOLL))
+				break;
+			cond_resched();
+		} while (1);
+	}
+
+	/* avoid locking problems by failing it from a clean context */
+	if (ret)
+		io_req_task_queue_fail(req, ret);
+}
+
+static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
+						       unsigned i)
+{
+	return &table->files[i];
+}
+
+static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
+					      int index)
+{
+	struct io_fixed_file *slot = io_fixed_file_slot(&ctx->file_table, index);
+
+	return (struct file *) (slot->file_ptr & FFS_MASK);
+}
+
+static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file)
+{
+	unsigned long file_ptr = (unsigned long) file;
+
+	if (__io_file_supports_nowait(file, READ))
+		file_ptr |= FFS_ASYNC_READ;
+	if (__io_file_supports_nowait(file, WRITE))
+		file_ptr |= FFS_ASYNC_WRITE;
+	if (S_ISREG(file_inode(file)->i_mode))
+		file_ptr |= FFS_ISREG;
+	file_slot->file_ptr = file_ptr;
+}
+
+static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
+					     struct io_kiocb *req, int fd)
+{
+	struct file *file;
+	unsigned long file_ptr;
+
+	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
+		return NULL;
+	fd = array_index_nospec(fd, ctx->nr_user_files);
+	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
+	file = (struct file *) (file_ptr & FFS_MASK);
+	file_ptr &= ~FFS_MASK;
+	/* mask in overlapping REQ_F and FFS bits */
+	req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
+	io_req_set_rsrc_node(req);
+	return file;
+}
+
+static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
+				       struct io_kiocb *req, int fd)
+{
+	struct file *file = fget(fd);
+
+	trace_io_uring_file_get(ctx, fd);
+
+	/* we don't allow fixed io_uring files */
+	if (file && unlikely(file->f_op == &io_uring_fops))
+		io_req_track_inflight(req);
+	return file;
+}
+
+static inline struct file *io_file_get(struct io_ring_ctx *ctx,
+				       struct io_kiocb *req, int fd, bool fixed)
+{
+	if (fixed)
+		return io_file_get_fixed(ctx, req, fd);
+	else
+		return io_file_get_normal(ctx, req, fd);
+}
+
+static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
+{
+	struct io_kiocb *prev = req->timeout.prev;
+	int ret = -ENOENT;
+
+	if (prev) {
+		if (!(req->task->flags & PF_EXITING))
+			ret = io_try_cancel_userdata(req, prev->user_data);
+		io_req_complete_post(req, ret ?: -ETIME, 0);
+		io_put_req(prev);
+	} else {
+		io_req_complete_post(req, -ETIME, 0);
+	}
+}
+
+static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
+{
+	struct io_timeout_data *data = container_of(timer,
+						struct io_timeout_data, timer);
+	struct io_kiocb *prev, *req = data->req;
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->timeout_lock, flags);
+	prev = req->timeout.head;
+	req->timeout.head = NULL;
+
+	/*
+	 * We don't expect the list to be empty, that will only happen if we
+	 * race with the completion of the linked work.
+	 */
+	if (prev) {
+		io_remove_next_linked(prev);
+		if (!req_ref_inc_not_zero(prev))
+			prev = NULL;
+	}
+	list_del(&req->timeout.list);
+	req->timeout.prev = prev;
+	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
+
+	req->io_task_work.func = io_req_task_link_timeout;
+	io_req_task_work_add(req);
+	return HRTIMER_NORESTART;
+}
+
+static void io_queue_linked_timeout(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->timeout_lock);
+	/*
+	 * If the back reference is NULL, then our linked request finished
+	 * before we got a chance to setup the timer
+	 */
+	if (req->timeout.head) {
+		struct io_timeout_data *data = req->async_data;
+
+		data->timer.function = io_link_timeout_fn;
+		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
+				data->mode);
+		list_add_tail(&req->timeout.list, &ctx->ltimeout_list);
+	}
+	spin_unlock_irq(&ctx->timeout_lock);
+	/* drop submission reference */
+	io_put_req(req);
+}
+
+static void __io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
+{
+	struct io_kiocb *linked_timeout;
+	int ret;
+
+issue_sqe:
+	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+
+	/*
+	 * We async punt it if the file wasn't marked NOWAIT, or if the file
+	 * doesn't support non-blocking read/write attempts
+	 */
+	if (likely(!ret)) {
+		if (req->flags & REQ_F_COMPLETE_INLINE) {
+			struct io_ring_ctx *ctx = req->ctx;
+			struct io_submit_state *state = &ctx->submit_state;
+
+			state->compl_reqs[state->compl_nr++] = req;
+			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
+				io_submit_flush_completions(ctx);
+			return;
+		}
+
+		linked_timeout = io_prep_linked_timeout(req);
+		if (linked_timeout)
+			io_queue_linked_timeout(linked_timeout);
+	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
+		linked_timeout = io_prep_linked_timeout(req);
+
+		switch (io_arm_poll_handler(req)) {
+		case IO_APOLL_READY:
+			if (linked_timeout)
+				io_queue_linked_timeout(linked_timeout);
+			goto issue_sqe;
+		case IO_APOLL_ABORTED:
+			/*
+			 * Queued up for async execution, worker will release
+			 * submit reference when the iocb is actually submitted.
+			 */
+			io_queue_async_work(req, NULL);
+			break;
+		}
+
+		if (linked_timeout)
+			io_queue_linked_timeout(linked_timeout);
+	} else {
+		io_req_complete_failed(req, ret);
+	}
+}
+
+static inline void io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
+{
+	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
+		return;
+
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
+		__io_queue_sqe(req);
+	} else if (req->flags & REQ_F_FAIL) {
+		io_req_complete_fail_submit(req);
+	} else {
+		int ret = io_req_prep_async(req);
+
+		if (unlikely(ret))
+			io_req_complete_failed(req, ret);
+		else
+			io_queue_async_work(req, NULL);
+	}
+}
+
+/*
+ * Check SQE restrictions (opcode and flags).
+ *
+ * Returns 'true' if SQE is allowed, 'false' otherwise.
+ */
+static inline bool io_check_restriction(struct io_ring_ctx *ctx,
+					struct io_kiocb *req,
+					unsigned int sqe_flags)
+{
+	if (likely(!ctx->restricted))
+		return true;
+
+	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
+		return false;
+
+	if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
+	    ctx->restrictions.sqe_flags_required)
+		return false;
+
+	if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
+			  ctx->restrictions.sqe_flags_required))
+		return false;
+
+	return true;
+}
+
+static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		       const struct io_uring_sqe *sqe)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_submit_state *state;
+	unsigned int sqe_flags;
+	int personality, ret = 0;
+
+	/* req is partially pre-initialised, see io_preinit_req() */
+	req->opcode = READ_ONCE(sqe->opcode);
+	/* same numerical values with corresponding REQ_F_*, safe to copy */
+	req->flags = sqe_flags = READ_ONCE(sqe->flags);
+	req->user_data = READ_ONCE(sqe->user_data);
+	req->file = NULL;
+	req->fixed_rsrc_refs = NULL;
+	req->task = current;
+
+	/* enforce forwards compatibility on users */
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
+		return -EINVAL;
+	if (unlikely(req->opcode >= IORING_OP_LAST))
+		return -EINVAL;
+	if (!io_check_restriction(ctx, req, sqe_flags))
+		return -EACCES;
+
+	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
+	    !io_op_defs[req->opcode].buffer_select)
+		return -EOPNOTSUPP;
+	if (unlikely(sqe_flags & IOSQE_IO_DRAIN))
+		ctx->drain_active = true;
+
+	personality = READ_ONCE(sqe->personality);
+	if (personality) {
+		req->creds = xa_load(&ctx->personalities, personality);
+		if (!req->creds)
+			return -EINVAL;
+		get_cred(req->creds);
+		req->flags |= REQ_F_CREDS;
+	}
+	state = &ctx->submit_state;
+
+	/*
+	 * Plug now if we have more than 1 IO left after this, and the target
+	 * is potentially a read/write to block based storage.
+	 */
+	if (!state->plug_started && state->ios_left > 1 &&
+	    io_op_defs[req->opcode].plug) {
+		blk_start_plug(&state->plug);
+		state->plug_started = true;
+	}
+
+	if (io_op_defs[req->opcode].needs_file) {
+		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
+					(sqe_flags & IOSQE_FIXED_FILE));
+		if (unlikely(!req->file))
+			ret = -EBADF;
+	}
+
+	state->ios_left--;
+	return ret;
+}
+
+static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			 const struct io_uring_sqe *sqe)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_submit_link *link = &ctx->submit_state.link;
+	int ret;
+
+	ret = io_init_req(ctx, req, sqe);
+	if (unlikely(ret)) {
+fail_req:
+		/* fail even hard links since we don't submit */
+		if (link->head) {
+			/*
+			 * we can judge a link req is failed or cancelled by if
+			 * REQ_F_FAIL is set, but the head is an exception since
+			 * it may be set REQ_F_FAIL because of other req's failure
+			 * so let's leverage req->result to distinguish if a head
+			 * is set REQ_F_FAIL because of its failure or other req's
+			 * failure so that we can set the correct ret code for it.
+			 * init result here to avoid affecting the normal path.
+			 */
+			if (!(link->head->flags & REQ_F_FAIL))
+				req_fail_link_node(link->head, -ECANCELED);
+		} else if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
+			/*
+			 * the current req is a normal req, we should return
+			 * error and thus break the submittion loop.
+			 */
+			io_req_complete_failed(req, ret);
+			return ret;
+		}
+		req_fail_link_node(req, ret);
+	} else {
+		ret = io_req_prep(req, sqe);
+		if (unlikely(ret))
+			goto fail_req;
+	}
+
+	/* don't need @sqe from now on */
+	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
+				  req->flags, true,
+				  ctx->flags & IORING_SETUP_SQPOLL);
+
+	/*
+	 * If we already have a head request, queue this one for async
+	 * submittal once the head completes. If we don't have a head but
+	 * IOSQE_IO_LINK is set in the sqe, start a new head. This one will be
+	 * submitted sync once the chain is complete. If none of those
+	 * conditions are true (normal request), then just queue it.
+	 */
+	if (link->head) {
+		struct io_kiocb *head = link->head;
+
+		if (!(req->flags & REQ_F_FAIL)) {
+			ret = io_req_prep_async(req);
+			if (unlikely(ret)) {
+				req_fail_link_node(req, ret);
+				if (!(head->flags & REQ_F_FAIL))
+					req_fail_link_node(head, -ECANCELED);
+			}
+		}
+		trace_io_uring_link(ctx, req, head);
+		link->last->link = req;
+		link->last = req;
+
+		/* last request of a link, enqueue the link */
+		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
+			link->head = NULL;
+			io_queue_sqe(head);
+		}
+	} else {
+		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+			link->head = req;
+			link->last = req;
+		} else {
+			io_queue_sqe(req);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Batched submission is done, ensure local IO is flushed out.
+ */
+static void io_submit_state_end(struct io_submit_state *state,
+				struct io_ring_ctx *ctx)
+{
+	if (state->link.head)
+		io_queue_sqe(state->link.head);
+	if (state->compl_nr)
+		io_submit_flush_completions(ctx);
+	if (state->plug_started)
+		blk_finish_plug(&state->plug);
+}
+
+/*
+ * Start submission side cache.
+ */
+static void io_submit_state_start(struct io_submit_state *state,
+				  unsigned int max_ios)
+{
+	state->plug_started = false;
+	state->ios_left = max_ios;
+	/* set only head, no need to init link_last in advance */
+	state->link.head = NULL;
+}
+
+static void io_commit_sqring(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = ctx->rings;
+
+	/*
+	 * Ensure any loads from the SQEs are done at this point,
+	 * since once we write the new head, the application could
+	 * write new data to them.
+	 */
+	smp_store_release(&rings->sq.head, ctx->cached_sq_head);
+}
+
+/*
+ * Fetch an sqe, if one is available. Note this returns a pointer to memory
+ * that is mapped by userspace. This means that care needs to be taken to
+ * ensure that reads are stable, as we cannot rely on userspace always
+ * being a good citizen. If members of the sqe are validated and then later
+ * used, it's important that those reads are done through READ_ONCE() to
+ * prevent a re-load down the line.
+ */
+static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
+{
+	unsigned head, mask = ctx->sq_entries - 1;
+	unsigned sq_idx = ctx->cached_sq_head++ & mask;
+
+	/*
+	 * The cached sq head (or cq tail) serves two purposes:
+	 *
+	 * 1) allows us to batch the cost of updating the user visible
+	 *    head updates.
+	 * 2) allows the kernel side to track the head on its own, even
+	 *    though the application is the one updating it.
+	 */
+	head = READ_ONCE(ctx->sq_array[sq_idx]);
+	if (likely(head < ctx->sq_entries))
+		return &ctx->sq_sqes[head];
+
+	/* drop invalid entries */
+	ctx->cq_extra--;
+	WRITE_ONCE(ctx->rings->sq_dropped,
+		   READ_ONCE(ctx->rings->sq_dropped) + 1);
+	return NULL;
+}
+
+static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
+	__must_hold(&ctx->uring_lock)
+{
+	int submitted = 0;
+
+	/* make sure SQ entry isn't read before tail */
+	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
+	if (!percpu_ref_tryget_many(&ctx->refs, nr))
+		return -EAGAIN;
+	io_get_task_refs(nr);
+
+	io_submit_state_start(&ctx->submit_state, nr);
+	while (submitted < nr) {
+		const struct io_uring_sqe *sqe;
+		struct io_kiocb *req;
+
+		req = io_alloc_req(ctx);
+		if (unlikely(!req)) {
+			if (!submitted)
+				submitted = -EAGAIN;
+			break;
+		}
+		sqe = io_get_sqe(ctx);
+		if (unlikely(!sqe)) {
+			list_add(&req->inflight_entry, &ctx->submit_state.free_list);
+			break;
+		}
+		/* will complete beyond this point, count as submitted */
+		submitted++;
+		if (io_submit_sqe(ctx, req, sqe))
+			break;
+	}
+
+	if (unlikely(submitted != nr)) {
+		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
+		int unused = nr - ref_used;
+
+		current->io_uring->cached_refs += unused;
+		percpu_ref_put_many(&ctx->refs, unused);
+	}
+
+	io_submit_state_end(&ctx->submit_state, ctx);
+	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
+	io_commit_sqring(ctx);
+
+	return submitted;
+}
+
+static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
+{
+	return READ_ONCE(sqd->state);
+}
+
+static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
+{
+	/* Tell userspace we may need a wakeup call */
+	spin_lock(&ctx->completion_lock);
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
+	spin_unlock(&ctx->completion_lock);
+}
+
+static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
+{
+	spin_lock(&ctx->completion_lock);
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
+	spin_unlock(&ctx->completion_lock);
+}
+
+static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
+{
+	unsigned int to_submit;
+	int ret = 0;
+
+	to_submit = io_sqring_entries(ctx);
+	/* if we're handling multiple rings, cap submit size for fairness */
+	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
+		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
+
+	if (!list_empty(&ctx->iopoll_list) || to_submit) {
+		unsigned nr_events = 0;
+		const struct cred *creds = NULL;
+
+		if (ctx->sq_creds != current_cred())
+			creds = override_creds(ctx->sq_creds);
+
+		mutex_lock(&ctx->uring_lock);
+		if (!list_empty(&ctx->iopoll_list))
+			io_do_iopoll(ctx, &nr_events, 0);
+
+		/*
+		 * Don't submit if refs are dying, good for io_uring_register(),
+		 * but also it is relied upon by io_ring_exit_work()
+		 */
+		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
+		    !(ctx->flags & IORING_SETUP_R_DISABLED))
+			ret = io_submit_sqes(ctx, to_submit);
+		mutex_unlock(&ctx->uring_lock);
+
+		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
+			wake_up(&ctx->sqo_sq_wait);
+		if (creds)
+			revert_creds(creds);
+	}
+
+	return ret;
+}
+
+static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
+{
+	struct io_ring_ctx *ctx;
+	unsigned sq_thread_idle = 0;
+
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+		sq_thread_idle = max(sq_thread_idle, ctx->sq_thread_idle);
+	sqd->sq_thread_idle = sq_thread_idle;
+}
+
+static bool io_sqd_handle_event(struct io_sq_data *sqd)
+{
+	bool did_sig = false;
+	struct ksignal ksig;
+
+	if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state) ||
+	    signal_pending(current)) {
+		mutex_unlock(&sqd->lock);
+		if (signal_pending(current))
+			did_sig = get_signal(&ksig);
+		cond_resched();
+		mutex_lock(&sqd->lock);
+	}
+	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+}
+
+static int io_sq_thread(void *data)
+{
+	struct io_sq_data *sqd = data;
+	struct io_ring_ctx *ctx;
+	unsigned long timeout = 0;
+	char buf[TASK_COMM_LEN];
+	DEFINE_WAIT(wait);
+
+	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
+	set_task_comm(current, buf);
+
+	if (sqd->sq_cpu != -1)
+		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
+	else
+		set_cpus_allowed_ptr(current, cpu_online_mask);
+	current->flags |= PF_NO_SETAFFINITY;
+
+	mutex_lock(&sqd->lock);
+	while (1) {
+		bool cap_entries, sqt_spin = false;
+
+		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
+			if (io_sqd_handle_event(sqd))
+				break;
+			timeout = jiffies + sqd->sq_thread_idle;
+		}
+
+		cap_entries = !list_is_singular(&sqd->ctx_list);
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			int ret = __io_sq_thread(ctx, cap_entries);
+
+			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
+				sqt_spin = true;
+		}
+		if (io_run_task_work())
+			sqt_spin = true;
+
+		if (sqt_spin || !time_after(jiffies, timeout)) {
+			cond_resched();
+			if (sqt_spin)
+				timeout = jiffies + sqd->sq_thread_idle;
+			continue;
+		}
+
+		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
+		if (!io_sqd_events_pending(sqd) && !current->task_works) {
+			bool needs_sched = true;
+
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+				io_ring_set_wakeup_flag(ctx);
+
+				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
+				    !list_empty_careful(&ctx->iopoll_list)) {
+					needs_sched = false;
+					break;
+				}
+				if (io_sqring_entries(ctx)) {
+					needs_sched = false;
+					break;
+				}
+			}
+
+			if (needs_sched) {
+				mutex_unlock(&sqd->lock);
+				schedule();
+				mutex_lock(&sqd->lock);
+			}
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				io_ring_clear_wakeup_flag(ctx);
+		}
+
+		finish_wait(&sqd->wait, &wait);
+		timeout = jiffies + sqd->sq_thread_idle;
+	}
+
+	io_uring_cancel_generic(true, sqd);
+	sqd->thread = NULL;
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+		io_ring_set_wakeup_flag(ctx);
+	io_run_task_work();
+	mutex_unlock(&sqd->lock);
+
+	complete(&sqd->exited);
+	do_exit(0);
+}
+
+struct io_wait_queue {
+	struct wait_queue_entry wq;
+	struct io_ring_ctx *ctx;
+	unsigned cq_tail;
+	unsigned nr_timeouts;
+};
+
+static inline bool io_should_wake(struct io_wait_queue *iowq)
+{
+	struct io_ring_ctx *ctx = iowq->ctx;
+	int dist = ctx->cached_cq_tail - (int) iowq->cq_tail;
+
+	/*
+	 * Wake up if we have enough events, or if a timeout occurred since we
+	 * started waiting. For timeouts, we always want to return to userspace,
+	 * regardless of event count.
+	 */
+	return dist >= 0 || atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
+}
+
+static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
+			    int wake_flags, void *key)
+{
+	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue,
+							wq);
+
+	/*
+	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
+	 * the task, and the next invocation will do it.
+	 */
+	if (io_should_wake(iowq) || test_bit(0, &iowq->ctx->check_cq_overflow))
+		return autoremove_wake_function(curr, mode, wake_flags, key);
+	return -1;
+}
+
+static int io_run_task_work_sig(void)
+{
+	if (io_run_task_work())
+		return 1;
+	if (!signal_pending(current))
+		return 0;
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		return -ERESTARTSYS;
+	return -EINTR;
+}
+
+/* when returns >0, the caller should retry */
+static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  ktime_t timeout)
+{
+	int ret;
+
+	/* make sure we run task_work before checking for signals */
+	ret = io_run_task_work_sig();
+	if (ret || io_should_wake(iowq))
+		return ret;
+	/* let the caller flush overflows, retry */
+	if (test_bit(0, &ctx->check_cq_overflow))
+		return 1;
+
+	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+		return -ETIME;
+	return 1;
+}
+
+/*
+ * Wait until events become available, if we don't already have some. The
+ * application must reap them itself, as they reside on the shared cq ring.
+ */
+static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
+			  const sigset_t __user *sig, size_t sigsz,
+			  struct __kernel_timespec __user *uts)
+{
+	struct io_wait_queue iowq;
+	struct io_rings *rings = ctx->rings;
+	ktime_t timeout = KTIME_MAX;
+	int ret;
+
+	do {
+		io_cqring_overflow_flush(ctx);
+		if (io_cqring_events(ctx) >= min_events)
+			return 0;
+		if (!io_run_task_work())
+			break;
+	} while (1);
+
+	if (uts) {
+		struct timespec64 ts;
+
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+	}
+
+	if (sig) {
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = set_compat_user_sigmask((const compat_sigset_t __user *)sig,
+						      sigsz);
+		else
+#endif
+			ret = set_user_sigmask(sig, sigsz);
+
+		if (ret)
+			return ret;
+	}
+
+	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
+	iowq.wq.private = current;
+	INIT_LIST_HEAD(&iowq.wq.entry);
+	iowq.ctx = ctx;
+	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
+	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+
+	trace_io_uring_cqring_wait(ctx, min_events);
+	do {
+		/* if we can't even flush overflow, don't wait for more */
+		if (!io_cqring_overflow_flush(ctx)) {
+			ret = -EBUSY;
+			break;
+		}
+		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
+						TASK_INTERRUPTIBLE);
+		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		finish_wait(&ctx->cq_wait, &iowq.wq);
+		cond_resched();
+	} while (ret > 0);
+
+	restore_saved_sigmask_unless(ret == -EINTR);
+
+	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
+}
+
+static void io_free_page_table(void **table, size_t size)
+{
+	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
+
+	for (i = 0; i < nr_tables; i++)
+		kfree(table[i]);
+	kfree(table);
+}
+
+static void **io_alloc_page_table(size_t size)
+{
+	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
+	size_t init_size = size;
+	void **table;
+
+	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL_ACCOUNT);
+	if (!table)
+		return NULL;
+
+	for (i = 0; i < nr_tables; i++) {
+		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
+
+		table[i] = kzalloc(this_size, GFP_KERNEL_ACCOUNT);
+		if (!table[i]) {
+			io_free_page_table(table, init_size);
+			return NULL;
+		}
+		size -= this_size;
+	}
+	return table;
+}
+
+static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
+{
+	percpu_ref_exit(&ref_node->refs);
+	kfree(ref_node);
+}
+
+static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
+{
+	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
+	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	unsigned long flags;
+	bool first_add = false;
+	unsigned long delay = HZ;
+
+	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
+	node->done = true;
+
+	/* if we are mid-quiesce then do not delay */
+	if (node->rsrc_data->quiesce)
+		delay = 0;
+
+	while (!list_empty(&ctx->rsrc_ref_list)) {
+		node = list_first_entry(&ctx->rsrc_ref_list,
+					    struct io_rsrc_node, node);
+		/* recycle ref nodes in order */
+		if (!node->done)
+			break;
+		list_del(&node->node);
+		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
+	}
+	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
+
+	if (first_add)
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
+}
+
+static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
+{
+	struct io_rsrc_node *ref_node;
+
+	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+	if (!ref_node)
+		return NULL;
+
+	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
+			    0, GFP_KERNEL)) {
+		kfree(ref_node);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ref_node->node);
+	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->done = false;
+	return ref_node;
+}
+
+static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
+				struct io_rsrc_data *data_to_kill)
+{
+	WARN_ON_ONCE(!ctx->rsrc_backup_node);
+	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
+
+	if (data_to_kill) {
+		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
+
+		rsrc_node->rsrc_data = data_to_kill;
+		spin_lock_irq(&ctx->rsrc_ref_lock);
+		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
+		spin_unlock_irq(&ctx->rsrc_ref_lock);
+
+		atomic_inc(&data_to_kill->refs);
+		percpu_ref_kill(&rsrc_node->refs);
+		ctx->rsrc_node = NULL;
+	}
+
+	if (!ctx->rsrc_node) {
+		ctx->rsrc_node = ctx->rsrc_backup_node;
+		ctx->rsrc_backup_node = NULL;
+	}
+}
+
+static int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
+{
+	if (ctx->rsrc_backup_node)
+		return 0;
+	ctx->rsrc_backup_node = io_rsrc_node_alloc(ctx);
+	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
+}
+
+static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ctx)
+{
+	int ret;
+
+	/* As we may drop ->uring_lock, other task may have started quiesce */
+	if (data->quiesce)
+		return -ENXIO;
+
+	data->quiesce = true;
+	do {
+		ret = io_rsrc_node_switch_start(ctx);
+		if (ret)
+			break;
+		io_rsrc_node_switch(ctx, data);
+
+		/* kill initial ref, already quiesced if zero */
+		if (atomic_dec_and_test(&data->refs))
+			break;
+		mutex_unlock(&ctx->uring_lock);
+		flush_delayed_work(&ctx->rsrc_put_work);
+		ret = wait_for_completion_interruptible(&data->done);
+		if (!ret) {
+			mutex_lock(&ctx->uring_lock);
+			if (atomic_read(&data->refs) > 0) {
+				/*
+				 * it has been revived by another thread while
+				 * we were unlocked
+				 */
+				mutex_unlock(&ctx->uring_lock);
+			} else {
+				break;
+			}
+		}
+
+		atomic_inc(&data->refs);
+		/* wait for all works potentially completing data->done */
+		flush_delayed_work(&ctx->rsrc_put_work);
+		reinit_completion(&data->done);
+
+		ret = io_run_task_work_sig();
+		mutex_lock(&ctx->uring_lock);
+	} while (ret >= 0);
+	data->quiesce = false;
+
+	return ret;
+}
+
+static u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
+{
+	unsigned int off = idx & IO_RSRC_TAG_TABLE_MASK;
+	unsigned int table_idx = idx >> IO_RSRC_TAG_TABLE_SHIFT;
+
+	return &data->tags[table_idx][off];
+}
+
+static void io_rsrc_data_free(struct io_rsrc_data *data)
+{
+	size_t size = data->nr * sizeof(data->tags[0][0]);
+
+	if (data->tags)
+		io_free_page_table((void **)data->tags, size);
+	kfree(data);
+}
+
+static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
+			      u64 __user *utags, unsigned nr,
+			      struct io_rsrc_data **pdata)
+{
+	struct io_rsrc_data *data;
+	int ret = -ENOMEM;
+	unsigned i;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	data->tags = (u64 **)io_alloc_page_table(nr * sizeof(data->tags[0][0]));
+	if (!data->tags) {
+		kfree(data);
+		return -ENOMEM;
+	}
+
+	data->nr = nr;
+	data->ctx = ctx;
+	data->do_put = do_put;
+	if (utags) {
+		ret = -EFAULT;
+		for (i = 0; i < nr; i++) {
+			u64 *tag_slot = io_get_tag_slot(data, i);
+
+			if (copy_from_user(tag_slot, &utags[i],
+					   sizeof(*tag_slot)))
+				goto fail;
+		}
+	}
+
+	atomic_set(&data->refs, 1);
+	init_completion(&data->done);
+	*pdata = data;
+	return 0;
+fail:
+	io_rsrc_data_free(data);
+	return ret;
+}
+
+static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
+{
+	table->files = kvcalloc(nr_files, sizeof(table->files[0]),
+				GFP_KERNEL_ACCOUNT);
+	return !!table->files;
+}
+
+static void io_free_file_tables(struct io_file_table *table)
+{
+	kvfree(table->files);
+	table->files = NULL;
+}
+
+static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+#if defined(CONFIG_UNIX)
+	if (ctx->ring_sock) {
+		struct sock *sock = ctx->ring_sock->sk;
+		struct sk_buff *skb;
+
+		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
+			kfree_skb(skb);
+	}
+#else
+	int i;
+
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		struct file *file;
+
+		file = io_file_from_index(ctx, i);
+		if (file)
+			fput(file);
+	}
+#endif
+	io_free_file_tables(&ctx->file_table);
+	io_rsrc_data_free(ctx->file_data);
+	ctx->file_data = NULL;
+	ctx->nr_user_files = 0;
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	unsigned nr = ctx->nr_user_files;
+	int ret;
+
+	if (!ctx->file_data)
+		return -ENXIO;
+
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_files = 0;
+	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
+	ctx->nr_user_files = nr;
+	if (!ret)
+		__io_sqe_files_unregister(ctx);
+	return ret;
+}
+
+static void io_sq_thread_unpark(struct io_sq_data *sqd)
+	__releases(&sqd->lock)
+{
+	WARN_ON_ONCE(sqd->thread == current);
+
+	/*
+	 * Do the dance but not conditional clear_bit() because it'd race with
+	 * other threads incrementing park_pending and setting the bit.
+	 */
+	clear_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+	if (atomic_dec_return(&sqd->park_pending))
+		set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+	mutex_unlock(&sqd->lock);
+}
+
+static void io_sq_thread_park(struct io_sq_data *sqd)
+	__acquires(&sqd->lock)
+{
+	WARN_ON_ONCE(sqd->thread == current);
+
+	atomic_inc(&sqd->park_pending);
+	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+	mutex_lock(&sqd->lock);
+	if (sqd->thread)
+		wake_up_process(sqd->thread);
+}
+
+static void io_sq_thread_stop(struct io_sq_data *sqd)
+{
+	WARN_ON_ONCE(sqd->thread == current);
+	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state));
+
+	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	mutex_lock(&sqd->lock);
+	if (sqd->thread)
+		wake_up_process(sqd->thread);
+	mutex_unlock(&sqd->lock);
+	wait_for_completion(&sqd->exited);
+}
+
+static void io_put_sq_data(struct io_sq_data *sqd)
+{
+	if (refcount_dec_and_test(&sqd->refs)) {
+		WARN_ON_ONCE(atomic_read(&sqd->park_pending));
+
+		io_sq_thread_stop(sqd);
+		kfree(sqd);
+	}
+}
+
+static void io_sq_thread_finish(struct io_ring_ctx *ctx)
+{
+	struct io_sq_data *sqd = ctx->sq_data;
+
+	if (sqd) {
+		io_sq_thread_park(sqd);
+		list_del_init(&ctx->sqd_list);
+		io_sqd_update_thread_idle(sqd);
+		io_sq_thread_unpark(sqd);
+
+		io_put_sq_data(sqd);
+		ctx->sq_data = NULL;
+	}
+}
+
+static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
+{
+	struct io_ring_ctx *ctx_attach;
+	struct io_sq_data *sqd;
+	struct fd f;
+
+	f = fdget(p->wq_fd);
+	if (!f.file)
+		return ERR_PTR(-ENXIO);
+	if (f.file->f_op != &io_uring_fops) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+
+	ctx_attach = f.file->private_data;
+	sqd = ctx_attach->sq_data;
+	if (!sqd) {
+		fdput(f);
+		return ERR_PTR(-EINVAL);
+	}
+	if (sqd->task_tgid != current->tgid) {
+		fdput(f);
+		return ERR_PTR(-EPERM);
+	}
+
+	refcount_inc(&sqd->refs);
+	fdput(f);
+	return sqd;
+}
+
+static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
+					 bool *attached)
+{
+	struct io_sq_data *sqd;
+
+	*attached = false;
+	if (p->flags & IORING_SETUP_ATTACH_WQ) {
+		sqd = io_attach_sq_data(p);
+		if (!IS_ERR(sqd)) {
+			*attached = true;
+			return sqd;
+		}
+		/* fall through for EPERM case, setup new sqd/task */
+		if (PTR_ERR(sqd) != -EPERM)
+			return sqd;
+	}
+
+	sqd = kzalloc(sizeof(*sqd), GFP_KERNEL);
+	if (!sqd)
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&sqd->park_pending, 0);
+	refcount_set(&sqd->refs, 1);
+	INIT_LIST_HEAD(&sqd->ctx_list);
+	mutex_init(&sqd->lock);
+	init_waitqueue_head(&sqd->wait);
+	init_completion(&sqd->exited);
+	return sqd;
+}
+
+#if defined(CONFIG_UNIX)
+/*
+ * Ensure the UNIX gc is aware of our file set, so we are certain that
+ * the io_uring can be safely unregistered on process exit, even if we have
+ * loops in the file referencing.
+ */
+static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
+{
+	struct sock *sk = ctx->ring_sock->sk;
+	struct scm_fp_list *fpl;
+	struct sk_buff *skb;
+	int i, nr_files;
+
+	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
+	if (!fpl)
+		return -ENOMEM;
+
+	skb = alloc_skb(0, GFP_KERNEL);
+	if (!skb) {
+		kfree(fpl);
+		return -ENOMEM;
+	}
+
+	skb->sk = sk;
+	skb->scm_io_uring = 1;
+
+	nr_files = 0;
+	fpl->user = get_uid(current_user());
+	for (i = 0; i < nr; i++) {
+		struct file *file = io_file_from_index(ctx, i + offset);
+
+		if (!file)
+			continue;
+		fpl->fp[nr_files] = get_file(file);
+		unix_inflight(fpl->user, fpl->fp[nr_files]);
+		nr_files++;
+	}
+
+	if (nr_files) {
+		fpl->max = SCM_MAX_FD;
+		fpl->count = nr_files;
+		UNIXCB(skb).fp = fpl;
+		skb->destructor = unix_destruct_scm;
+		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
+		skb_queue_head(&sk->sk_receive_queue, skb);
+
+		for (i = 0; i < nr; i++) {
+			struct file *file = io_file_from_index(ctx, i + offset);
+
+			if (file)
+				fput(file);
+		}
+	} else {
+		kfree_skb(skb);
+		free_uid(fpl->user);
+		kfree(fpl);
+	}
+
+	return 0;
+}
+
+/*
+ * If UNIX sockets are enabled, fd passing can cause a reference cycle which
+ * causes regular reference counting to break down. We rely on the UNIX
+ * garbage collection to take care of this problem for us.
+ */
+static int io_sqe_files_scm(struct io_ring_ctx *ctx)
+{
+	unsigned left, total;
+	int ret = 0;
+
+	total = 0;
+	left = ctx->nr_user_files;
+	while (left) {
+		unsigned this_files = min_t(unsigned, left, SCM_MAX_FD);
+
+		ret = __io_sqe_files_scm(ctx, this_files, total);
+		if (ret)
+			break;
+		left -= this_files;
+		total += this_files;
+	}
+
+	if (!ret)
+		return 0;
+
+	while (total < ctx->nr_user_files) {
+		struct file *file = io_file_from_index(ctx, total);
+
+		if (file)
+			fput(file);
+		total++;
+	}
+
+	return ret;
+}
+#else
+static int io_sqe_files_scm(struct io_ring_ctx *ctx)
+{
+	return 0;
+}
+#endif
+
+static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+{
+	struct file *file = prsrc->file;
+#if defined(CONFIG_UNIX)
+	struct sock *sock = ctx->ring_sock->sk;
+	struct sk_buff_head list, *head = &sock->sk_receive_queue;
+	struct sk_buff *skb;
+	int i;
+
+	__skb_queue_head_init(&list);
+
+	/*
+	 * Find the skb that holds this file in its SCM_RIGHTS. When found,
+	 * remove this entry and rearrange the file array.
+	 */
+	skb = skb_dequeue(head);
+	while (skb) {
+		struct scm_fp_list *fp;
+
+		fp = UNIXCB(skb).fp;
+		for (i = 0; i < fp->count; i++) {
+			int left;
+
+			if (fp->fp[i] != file)
+				continue;
+
+			unix_notinflight(fp->user, fp->fp[i]);
+			left = fp->count - 1 - i;
+			if (left) {
+				memmove(&fp->fp[i], &fp->fp[i + 1],
+						left * sizeof(struct file *));
+			}
+			fp->count--;
+			if (!fp->count) {
+				kfree_skb(skb);
+				skb = NULL;
+			} else {
+				__skb_queue_tail(&list, skb);
+			}
+			fput(file);
+			file = NULL;
+			break;
+		}
+
+		if (!file)
+			break;
+
+		__skb_queue_tail(&list, skb);
+
+		skb = skb_dequeue(head);
+	}
+
+	if (skb_peek(&list)) {
+		spin_lock_irq(&head->lock);
+		while ((skb = __skb_dequeue(&list)) != NULL)
+			__skb_queue_tail(head, skb);
+		spin_unlock_irq(&head->lock);
+	}
+#else
+	fput(file);
+#endif
+}
+
+static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
+{
+	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
+	struct io_ring_ctx *ctx = rsrc_data->ctx;
+	struct io_rsrc_put *prsrc, *tmp;
+
+	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
+		list_del(&prsrc->list);
+
+		if (prsrc->tag) {
+			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
+
+			io_ring_submit_lock(ctx, lock_ring);
+			spin_lock(&ctx->completion_lock);
+			io_fill_cqe_aux(ctx, prsrc->tag, 0, 0);
+			io_commit_cqring(ctx);
+			spin_unlock(&ctx->completion_lock);
+			io_cqring_ev_posted(ctx);
+			io_ring_submit_unlock(ctx, lock_ring);
+		}
+
+		rsrc_data->do_put(ctx, prsrc);
+		kfree(prsrc);
+	}
+
+	io_rsrc_node_destroy(ref_node);
+	if (atomic_dec_and_test(&rsrc_data->refs))
+		complete(&rsrc_data->done);
+}
+
+static void io_rsrc_put_work(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx;
+	struct llist_node *node;
+
+	ctx = container_of(work, struct io_ring_ctx, rsrc_put_work.work);
+	node = llist_del_all(&ctx->rsrc_put_llist);
+
+	while (node) {
+		struct io_rsrc_node *ref_node;
+		struct llist_node *next = node->next;
+
+		ref_node = llist_entry(node, struct io_rsrc_node, llist);
+		__io_rsrc_put_work(ref_node);
+		node = next;
+	}
+}
+
+static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
+				 unsigned nr_args, u64 __user *tags)
+{
+	__s32 __user *fds = (__s32 __user *) arg;
+	struct file *file;
+	int fd, ret;
+	unsigned i;
+
+	if (ctx->file_data)
+		return -EBUSY;
+	if (!nr_args)
+		return -EINVAL;
+	if (nr_args > IORING_MAX_FIXED_FILES)
+		return -EMFILE;
+	if (nr_args > rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		return ret;
+	ret = io_rsrc_data_alloc(ctx, io_rsrc_file_put, tags, nr_args,
+				 &ctx->file_data);
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
+	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
+		goto out_free;
+
+	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
+		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
+			ret = -EFAULT;
+			goto out_fput;
+		}
+		/* allow sparse sets */
+		if (fd == -1) {
+			ret = -EINVAL;
+			if (unlikely(*io_get_tag_slot(ctx->file_data, i)))
+				goto out_fput;
+			continue;
+		}
+
+		file = fget(fd);
+		ret = -EBADF;
+		if (unlikely(!file))
+			goto out_fput;
+
+		/*
+		 * Don't allow io_uring instances to be registered. If UNIX
+		 * isn't enabled, then this causes a reference cycle and this
+		 * instance can never get freed. If UNIX is enabled we'll
+		 * handle it just fine, but there's still no point in allowing
+		 * a ring fd as it doesn't support regular read/write anyway.
+		 */
+		if (file->f_op == &io_uring_fops) {
+			fput(file);
+			goto out_fput;
+		}
+		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
+	}
+
+	ret = io_sqe_files_scm(ctx);
+	if (ret) {
+		__io_sqe_files_unregister(ctx);
+		return ret;
+	}
+
+	io_rsrc_node_switch(ctx, NULL);
+	return ret;
+out_fput:
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		file = io_file_from_index(ctx, i);
+		if (file)
+			fput(file);
+	}
+	io_free_file_tables(&ctx->file_table);
+	ctx->nr_user_files = 0;
+out_free:
+	io_rsrc_data_free(ctx->file_data);
+	ctx->file_data = NULL;
+	return ret;
+}
+
+static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
+				int index)
+{
+#if defined(CONFIG_UNIX)
+	struct sock *sock = ctx->ring_sock->sk;
+	struct sk_buff_head *head = &sock->sk_receive_queue;
+	struct sk_buff *skb;
+
+	/*
+	 * See if we can merge this file into an existing skb SCM_RIGHTS
+	 * file set. If there's no room, fall back to allocating a new skb
+	 * and filling it in.
+	 */
+	spin_lock_irq(&head->lock);
+	skb = skb_peek(head);
+	if (skb) {
+		struct scm_fp_list *fpl = UNIXCB(skb).fp;
+
+		if (fpl->count < SCM_MAX_FD) {
+			__skb_unlink(skb, head);
+			spin_unlock_irq(&head->lock);
+			fpl->fp[fpl->count] = get_file(file);
+			unix_inflight(fpl->user, fpl->fp[fpl->count]);
+			fpl->count++;
+			spin_lock_irq(&head->lock);
+			__skb_queue_head(head, skb);
+		} else {
+			skb = NULL;
+		}
+	}
+	spin_unlock_irq(&head->lock);
+
+	if (skb) {
+		fput(file);
+		return 0;
+	}
+
+	return __io_sqe_files_scm(ctx, 1, index);
+#else
+	return 0;
+#endif
+}
+
+static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
+				 struct io_rsrc_node *node, void *rsrc)
+{
+	u64 *tag_slot = io_get_tag_slot(data, idx);
+	struct io_rsrc_put *prsrc;
+
+	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
+	if (!prsrc)
+		return -ENOMEM;
+
+	prsrc->tag = *tag_slot;
+	*tag_slot = 0;
+	prsrc->rsrc = rsrc;
+	list_add(&prsrc->list, &node->rsrc_list);
+	return 0;
+}
+
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags, u32 slot_index)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	bool needs_switch = false;
+	struct io_fixed_file *file_slot;
+	int ret = -EBADF;
+
+	io_ring_submit_lock(ctx, !force_nonblock);
+	if (file->f_op == &io_uring_fops)
+		goto err;
+	ret = -ENXIO;
+	if (!ctx->file_data)
+		goto err;
+	ret = -EINVAL;
+	if (slot_index >= ctx->nr_user_files)
+		goto err;
+
+	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
+
+	if (file_slot->file_ptr) {
+		struct file *old_file;
+
+		ret = io_rsrc_node_switch_start(ctx);
+		if (ret)
+			goto err;
+
+		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
+					    ctx->rsrc_node, old_file);
+		if (ret)
+			goto err;
+		file_slot->file_ptr = 0;
+		needs_switch = true;
+	}
+
+	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
+	io_fixed_file_set(file_slot, file);
+	ret = io_sqe_file_register(ctx, file, slot_index);
+	if (ret) {
+		file_slot->file_ptr = 0;
+		goto err;
+	}
+
+	ret = 0;
+err:
+	if (needs_switch)
+		io_rsrc_node_switch(ctx, ctx->file_data);
+	io_ring_submit_unlock(ctx, !force_nonblock);
+	if (ret)
+		fput(file);
+	return ret;
+}
+
+static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
+{
+	unsigned int offset = req->close.file_slot - 1;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_fixed_file *file_slot;
+	struct file *file;
+	int ret;
+
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	ret = -ENXIO;
+	if (unlikely(!ctx->file_data))
+		goto out;
+	ret = -EINVAL;
+	if (offset >= ctx->nr_user_files)
+		goto out;
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		goto out;
+
+	offset = array_index_nospec(offset, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
+	ret = -EBADF;
+	if (!file_slot->file_ptr)
+		goto out;
+
+	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+	ret = io_queue_rsrc_removal(ctx->file_data, offset, ctx->rsrc_node, file);
+	if (ret)
+		goto out;
+
+	file_slot->file_ptr = 0;
+	io_rsrc_node_switch(ctx, ctx->file_data);
+	ret = 0;
+out:
+	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+	return ret;
+}
+
+static int __io_sqe_files_update(struct io_ring_ctx *ctx,
+				 struct io_uring_rsrc_update2 *up,
+				 unsigned nr_args)
+{
+	u64 __user *tags = u64_to_user_ptr(up->tags);
+	__s32 __user *fds = u64_to_user_ptr(up->data);
+	struct io_rsrc_data *data = ctx->file_data;
+	struct io_fixed_file *file_slot;
+	struct file *file;
+	int fd, i, err = 0;
+	unsigned int done;
+	bool needs_switch = false;
+
+	if (!ctx->file_data)
+		return -ENXIO;
+	if (up->offset + nr_args > ctx->nr_user_files)
+		return -EINVAL;
+
+	for (done = 0; done < nr_args; done++) {
+		u64 tag = 0;
+
+		if ((tags && copy_from_user(&tag, &tags[done], sizeof(tag))) ||
+		    copy_from_user(&fd, &fds[done], sizeof(fd))) {
+			err = -EFAULT;
+			break;
+		}
+		if ((fd == IORING_REGISTER_FILES_SKIP || fd == -1) && tag) {
+			err = -EINVAL;
+			break;
+		}
+		if (fd == IORING_REGISTER_FILES_SKIP)
+			continue;
+
+		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
+		file_slot = io_fixed_file_slot(&ctx->file_table, i);
+
+		if (file_slot->file_ptr) {
+			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+			err = io_queue_rsrc_removal(data, i, ctx->rsrc_node, file);
+			if (err)
+				break;
+			file_slot->file_ptr = 0;
+			needs_switch = true;
+		}
+		if (fd != -1) {
+			file = fget(fd);
+			if (!file) {
+				err = -EBADF;
+				break;
+			}
+			/*
+			 * Don't allow io_uring instances to be registered. If
+			 * UNIX isn't enabled, then this causes a reference
+			 * cycle and this instance can never get freed. If UNIX
+			 * is enabled we'll handle it just fine, but there's
+			 * still no point in allowing a ring fd as it doesn't
+			 * support regular read/write anyway.
+			 */
+			if (file->f_op == &io_uring_fops) {
+				fput(file);
+				err = -EBADF;
+				break;
+			}
+			*io_get_tag_slot(data, i) = tag;
+			io_fixed_file_set(file_slot, file);
+			err = io_sqe_file_register(ctx, file, i);
+			if (err) {
+				file_slot->file_ptr = 0;
+				fput(file);
+				break;
+			}
+		}
+	}
+
+	if (needs_switch)
+		io_rsrc_node_switch(ctx, data);
+	return done ? done : err;
+}
+
+static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
+					struct task_struct *task)
+{
+	struct io_wq_hash *hash;
+	struct io_wq_data data;
+	unsigned int concurrency;
+
+	mutex_lock(&ctx->uring_lock);
+	hash = ctx->hash_map;
+	if (!hash) {
+		hash = kzalloc(sizeof(*hash), GFP_KERNEL);
+		if (!hash) {
+			mutex_unlock(&ctx->uring_lock);
+			return ERR_PTR(-ENOMEM);
+		}
+		refcount_set(&hash->refs, 1);
+		init_waitqueue_head(&hash->wait);
+		ctx->hash_map = hash;
+	}
+	mutex_unlock(&ctx->uring_lock);
+
+	data.hash = hash;
+	data.task = task;
+	data.free_work = io_wq_free_work;
+	data.do_work = io_wq_submit_work;
+
+	/* Do QD, or 4 * CPUS, whatever is smallest */
+	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
+
+	return io_wq_create(concurrency, &data);
+}
+
+static int io_uring_alloc_task_context(struct task_struct *task,
+				       struct io_ring_ctx *ctx)
+{
+	struct io_uring_task *tctx;
+	int ret;
+
+	tctx = kzalloc(sizeof(*tctx), GFP_KERNEL);
+	if (unlikely(!tctx))
+		return -ENOMEM;
+
+	ret = percpu_counter_init(&tctx->inflight, 0, GFP_KERNEL);
+	if (unlikely(ret)) {
+		kfree(tctx);
+		return ret;
+	}
+
+	tctx->io_wq = io_init_wq_offload(ctx, task);
+	if (IS_ERR(tctx->io_wq)) {
+		ret = PTR_ERR(tctx->io_wq);
+		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx);
+		return ret;
+	}
+
+	xa_init(&tctx->xa);
+	init_waitqueue_head(&tctx->wait);
+	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_tracked, 0);
+	task->io_uring = tctx;
+	spin_lock_init(&tctx->task_lock);
+	INIT_WQ_LIST(&tctx->task_list);
+	init_task_work(&tctx->task_work, tctx_task_work);
+	return 0;
+}
+
+void __io_uring_free(struct task_struct *tsk)
+{
+	struct io_uring_task *tctx = tsk->io_uring;
+
+	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	WARN_ON_ONCE(tctx->io_wq);
+	WARN_ON_ONCE(tctx->cached_refs);
+
+	percpu_counter_destroy(&tctx->inflight);
+	kfree(tctx);
+	tsk->io_uring = NULL;
+}
+
+static int io_sq_offload_create(struct io_ring_ctx *ctx,
+				struct io_uring_params *p)
+{
+	int ret;
+
+	/* Retain compatibility with failing for an invalid attach attempt */
+	if ((ctx->flags & (IORING_SETUP_ATTACH_WQ | IORING_SETUP_SQPOLL)) ==
+				IORING_SETUP_ATTACH_WQ) {
+		struct fd f;
+
+		f = fdget(p->wq_fd);
+		if (!f.file)
+			return -ENXIO;
+		if (f.file->f_op != &io_uring_fops) {
+			fdput(f);
+			return -EINVAL;
+		}
+		fdput(f);
+	}
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		struct task_struct *tsk;
+		struct io_sq_data *sqd;
+		bool attached;
+
+		sqd = io_get_sq_data(p, &attached);
+		if (IS_ERR(sqd)) {
+			ret = PTR_ERR(sqd);
+			goto err;
+		}
+
+		ctx->sq_creds = get_current_cred();
+		ctx->sq_data = sqd;
+		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
+		if (!ctx->sq_thread_idle)
+			ctx->sq_thread_idle = HZ;
+
+		io_sq_thread_park(sqd);
+		list_add(&ctx->sqd_list, &sqd->ctx_list);
+		io_sqd_update_thread_idle(sqd);
+		/* don't attach to a dying SQPOLL thread, would be racy */
+		ret = (attached && !sqd->thread) ? -ENXIO : 0;
+		io_sq_thread_unpark(sqd);
+
+		if (ret < 0)
+			goto err;
+		if (attached)
+			return 0;
+
+		if (p->flags & IORING_SETUP_SQ_AFF) {
+			int cpu = p->sq_thread_cpu;
+
+			ret = -EINVAL;
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+				goto err_sqpoll;
+			sqd->sq_cpu = cpu;
+		} else {
+			sqd->sq_cpu = -1;
+		}
+
+		sqd->task_pid = current->pid;
+		sqd->task_tgid = current->tgid;
+		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
+		if (IS_ERR(tsk)) {
+			ret = PTR_ERR(tsk);
+			goto err_sqpoll;
+		}
+
+		sqd->thread = tsk;
+		ret = io_uring_alloc_task_context(tsk, ctx);
+		wake_up_new_task(tsk);
+		if (ret)
+			goto err;
+	} else if (p->flags & IORING_SETUP_SQ_AFF) {
+		/* Can't have SQ_AFF without SQPOLL */
+		ret = -EINVAL;
+		goto err;
+	}
+
+	return 0;
+err_sqpoll:
+	complete(&ctx->sq_data->exited);
+err:
+	io_sq_thread_finish(ctx);
+	return ret;
+}
+
+static inline void __io_unaccount_mem(struct user_struct *user,
+				      unsigned long nr_pages)
+{
+	atomic_long_sub(nr_pages, &user->locked_vm);
+}
+
+static inline int __io_account_mem(struct user_struct *user,
+				   unsigned long nr_pages)
+{
+	unsigned long page_limit, cur_pages, new_pages;
+
+	/* Don't allow more pages than we can safely lock */
+	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	do {
+		cur_pages = atomic_long_read(&user->locked_vm);
+		new_pages = cur_pages + nr_pages;
+		if (new_pages > page_limit)
+			return -ENOMEM;
+	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
+					new_pages) != cur_pages);
+
+	return 0;
+}
+
+static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+{
+	if (ctx->user)
+		__io_unaccount_mem(ctx->user, nr_pages);
+
+	if (ctx->mm_account)
+		atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
+}
+
+static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+{
+	int ret;
+
+	if (ctx->user) {
+		ret = __io_account_mem(ctx->user, nr_pages);
+		if (ret)
+			return ret;
+	}
+
+	if (ctx->mm_account)
+		atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
+
+	return 0;
+}
+
+static void io_mem_free(void *ptr)
+{
+	struct page *page;
+
+	if (!ptr)
+		return;
+
+	page = virt_to_head_page(ptr);
+	if (put_page_testzero(page))
+		free_compound_page(page);
+}
+
+static void *io_mem_alloc(size_t size)
+{
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
+
+	return (void *) __get_free_pages(gfp, get_order(size));
+}
+
+static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
+				size_t *sq_offset)
+{
+	struct io_rings *rings;
+	size_t off, sq_array_size;
+
+	off = struct_size(rings, cqes, cq_entries);
+	if (off == SIZE_MAX)
+		return SIZE_MAX;
+
+#ifdef CONFIG_SMP
+	off = ALIGN(off, SMP_CACHE_BYTES);
+	if (off == 0)
+		return SIZE_MAX;
+#endif
+
+	if (sq_offset)
+		*sq_offset = off;
+
+	sq_array_size = array_size(sizeof(u32), sq_entries);
+	if (sq_array_size == SIZE_MAX)
+		return SIZE_MAX;
+
+	if (check_add_overflow(off, sq_array_size, &off))
+		return SIZE_MAX;
+
+	return off;
+}
+
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slot)
+{
+	struct io_mapped_ubuf *imu = *slot;
+	unsigned int i;
+
+	if (imu != ctx->dummy_ubuf) {
+		for (i = 0; i < imu->nr_bvecs; i++)
+			unpin_user_page(imu->bvec[i].bv_page);
+		if (imu->acct_pages)
+			io_unaccount_mem(ctx, imu->acct_pages);
+		kvfree(imu);
+	}
+	*slot = NULL;
+}
+
+static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+{
+	io_buffer_unmap(ctx, &prsrc->buf);
+	prsrc->buf = NULL;
+}
+
+static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+{
+	unsigned int i;
+
+	for (i = 0; i < ctx->nr_user_bufs; i++)
+		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
+	kfree(ctx->user_bufs);
+	io_rsrc_data_free(ctx->buf_data);
+	ctx->user_bufs = NULL;
+	ctx->buf_data = NULL;
+	ctx->nr_user_bufs = 0;
+}
+
+static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+{
+	unsigned nr = ctx->nr_user_bufs;
+	int ret;
+
+	if (!ctx->buf_data)
+		return -ENXIO;
+
+	/*
+	 * Quiesce may unlock ->uring_lock, and while it's not held
+	 * prevent new requests using the table.
+	 */
+	ctx->nr_user_bufs = 0;
+	ret = io_rsrc_ref_quiesce(ctx->buf_data, ctx);
+	ctx->nr_user_bufs = nr;
+	if (!ret)
+		__io_sqe_buffers_unregister(ctx);
+	return ret;
+}
+
+static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
+		       void __user *arg, unsigned index)
+{
+	struct iovec __user *src;
+
+#ifdef CONFIG_COMPAT
+	if (ctx->compat) {
+		struct compat_iovec __user *ciovs;
+		struct compat_iovec ciov;
+
+		ciovs = (struct compat_iovec __user *) arg;
+		if (copy_from_user(&ciov, &ciovs[index], sizeof(ciov)))
+			return -EFAULT;
+
+		dst->iov_base = u64_to_user_ptr((u64)ciov.iov_base);
+		dst->iov_len = ciov.iov_len;
+		return 0;
+	}
+#endif
+	src = (struct iovec __user *) arg;
+	if (copy_from_user(dst, &src[index], sizeof(*dst)))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * Not super efficient, but this is just a registration time. And we do cache
+ * the last compound head, so generally we'll only do a full search if we don't
+ * match that one.
+ *
+ * We check if the given compound head page has already been accounted, to
+ * avoid double accounting it. This allows us to account the full size of the
+ * page, not just the constituent pages of a huge page.
+ */
+static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
+				  int nr_pages, struct page *hpage)
+{
+	int i, j;
+
+	/* check current page array */
+	for (i = 0; i < nr_pages; i++) {
+		if (!PageCompound(pages[i]))
+			continue;
+		if (compound_head(pages[i]) == hpage)
+			return true;
+	}
+
+	/* check previously registered pages */
+	for (i = 0; i < ctx->nr_user_bufs; i++) {
+		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
+
+		for (j = 0; j < imu->nr_bvecs; j++) {
+			if (!PageCompound(imu->bvec[j].bv_page))
+				continue;
+			if (compound_head(imu->bvec[j].bv_page) == hpage)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
+				 int nr_pages, struct io_mapped_ubuf *imu,
+				 struct page **last_hpage)
+{
+	int i, ret;
+
+	imu->acct_pages = 0;
+	for (i = 0; i < nr_pages; i++) {
+		if (!PageCompound(pages[i])) {
+			imu->acct_pages++;
+		} else {
+			struct page *hpage;
+
+			hpage = compound_head(pages[i]);
+			if (hpage == *last_hpage)
+				continue;
+			*last_hpage = hpage;
+			if (headpage_already_acct(ctx, pages, i, hpage))
+				continue;
+			imu->acct_pages += page_size(hpage) >> PAGE_SHIFT;
+		}
+	}
+
+	if (!imu->acct_pages)
+		return 0;
+
+	ret = io_account_mem(ctx, imu->acct_pages);
+	if (ret)
+		imu->acct_pages = 0;
+	return ret;
+}
+
+static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
+				  struct io_mapped_ubuf **pimu,
+				  struct page **last_hpage)
+{
+	struct io_mapped_ubuf *imu = NULL;
+	struct vm_area_struct **vmas = NULL;
+	struct page **pages = NULL;
+	unsigned long off, start, end, ubuf;
+	size_t size;
+	int ret, pret, nr_pages, i;
+
+	if (!iov->iov_base) {
+		*pimu = ctx->dummy_ubuf;
+		return 0;
+	}
+
+	ubuf = (unsigned long) iov->iov_base;
+	end = (ubuf + iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = ubuf >> PAGE_SHIFT;
+	nr_pages = end - start;
+
+	*pimu = NULL;
+	ret = -ENOMEM;
+
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		goto done;
+
+	vmas = kvmalloc_array(nr_pages, sizeof(struct vm_area_struct *),
+			      GFP_KERNEL);
+	if (!vmas)
+		goto done;
+
+	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	if (!imu)
+		goto done;
+
+	ret = 0;
+	mmap_read_lock(current->mm);
+	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+			      pages, vmas);
+	if (pret == nr_pages) {
+		/* don't support file backed memory */
+		for (i = 0; i < nr_pages; i++) {
+			struct vm_area_struct *vma = vmas[i];
+
+			if (vma_is_shmem(vma))
+				continue;
+			if (vma->vm_file &&
+			    !is_file_hugepages(vma->vm_file)) {
+				ret = -EOPNOTSUPP;
+				break;
+			}
+		}
+	} else {
+		ret = pret < 0 ? pret : -EFAULT;
+	}
+	mmap_read_unlock(current->mm);
+	if (ret) {
+		/*
+		 * if we did partial map, or found file backed vmas,
+		 * release any pages we did get
+		 */
+		if (pret > 0)
+			unpin_user_pages(pages, pret);
+		goto done;
+	}
+
+	ret = io_buffer_account_pin(ctx, pages, pret, imu, last_hpage);
+	if (ret) {
+		unpin_user_pages(pages, pret);
+		goto done;
+	}
+
+	off = ubuf & ~PAGE_MASK;
+	size = iov->iov_len;
+	for (i = 0; i < nr_pages; i++) {
+		size_t vec_len;
+
+		vec_len = min_t(size_t, size, PAGE_SIZE - off);
+		imu->bvec[i].bv_page = pages[i];
+		imu->bvec[i].bv_len = vec_len;
+		imu->bvec[i].bv_offset = off;
+		off = 0;
+		size -= vec_len;
+	}
+	/* store original address for later verification */
+	imu->ubuf = ubuf;
+	imu->ubuf_end = ubuf + iov->iov_len;
+	imu->nr_bvecs = nr_pages;
+	*pimu = imu;
+	ret = 0;
+done:
+	if (ret)
+		kvfree(imu);
+	kvfree(pages);
+	kvfree(vmas);
+	return ret;
+}
+
+static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
+{
+	ctx->user_bufs = kcalloc(nr_args, sizeof(*ctx->user_bufs), GFP_KERNEL);
+	return ctx->user_bufs ? 0 : -ENOMEM;
+}
+
+static int io_buffer_validate(struct iovec *iov)
+{
+	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
+
+	/*
+	 * Don't impose further limits on the size and buffer
+	 * constraints here, we'll -EINVAL later when IO is
+	 * submitted if they are wrong.
+	 */
+	if (!iov->iov_base)
+		return iov->iov_len ? -EFAULT : 0;
+	if (!iov->iov_len)
+		return -EFAULT;
+
+	/* arbitrary limit, but we need something */
+	if (iov->iov_len > SZ_1G)
+		return -EFAULT;
+
+	if (check_add_overflow((unsigned long)iov->iov_base, acct_len, &tmp))
+		return -EOVERFLOW;
+
+	return 0;
+}
+
+static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
+				   unsigned int nr_args, u64 __user *tags)
+{
+	struct page *last_hpage = NULL;
+	struct io_rsrc_data *data;
+	int i, ret;
+	struct iovec iov;
+
+	if (ctx->user_bufs)
+		return -EBUSY;
+	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
+		return -EINVAL;
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		return ret;
+	ret = io_rsrc_data_alloc(ctx, io_rsrc_buf_put, tags, nr_args, &data);
+	if (ret)
+		return ret;
+	ret = io_buffers_map_alloc(ctx, nr_args);
+	if (ret) {
+		io_rsrc_data_free(data);
+		return ret;
+	}
+
+	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
+		ret = io_copy_iov(ctx, &iov, arg, i);
+		if (ret)
+			break;
+		ret = io_buffer_validate(&iov);
+		if (ret)
+			break;
+		if (!iov.iov_base && *io_get_tag_slot(data, i)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
+					     &last_hpage);
+		if (ret)
+			break;
+	}
+
+	WARN_ON_ONCE(ctx->buf_data);
+
+	ctx->buf_data = data;
+	if (ret)
+		__io_sqe_buffers_unregister(ctx);
+	else
+		io_rsrc_node_switch(ctx, NULL);
+	return ret;
+}
+
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update2 *up,
+				   unsigned int nr_args)
+{
+	u64 __user *tags = u64_to_user_ptr(up->tags);
+	struct iovec iov, __user *iovs = u64_to_user_ptr(up->data);
+	struct page *last_hpage = NULL;
+	bool needs_switch = false;
+	__u32 done;
+	int i, err;
+
+	if (!ctx->buf_data)
+		return -ENXIO;
+	if (up->offset + nr_args > ctx->nr_user_bufs)
+		return -EINVAL;
+
+	for (done = 0; done < nr_args; done++) {
+		struct io_mapped_ubuf *imu;
+		int offset = up->offset + done;
+		u64 tag = 0;
+
+		err = io_copy_iov(ctx, &iov, iovs, done);
+		if (err)
+			break;
+		if (tags && copy_from_user(&tag, &tags[done], sizeof(tag))) {
+			err = -EFAULT;
+			break;
+		}
+		err = io_buffer_validate(&iov);
+		if (err)
+			break;
+		if (!iov.iov_base && tag) {
+			err = -EINVAL;
+			break;
+		}
+		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
+		if (err)
+			break;
+
+		i = array_index_nospec(offset, ctx->nr_user_bufs);
+		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
+			err = io_queue_rsrc_removal(ctx->buf_data, i,
+						    ctx->rsrc_node, ctx->user_bufs[i]);
+			if (unlikely(err)) {
+				io_buffer_unmap(ctx, &imu);
+				break;
+			}
+			ctx->user_bufs[i] = NULL;
+			needs_switch = true;
+		}
+
+		ctx->user_bufs[i] = imu;
+		*io_get_tag_slot(ctx->buf_data, offset) = tag;
+	}
+
+	if (needs_switch)
+		io_rsrc_node_switch(ctx, ctx->buf_data);
+	return done ? done : err;
+}
+
+static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
+{
+	__s32 __user *fds = arg;
+	int fd;
+
+	if (ctx->cq_ev_fd)
+		return -EBUSY;
+
+	if (copy_from_user(&fd, fds, sizeof(*fds)))
+		return -EFAULT;
+
+	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(ctx->cq_ev_fd)) {
+		int ret = PTR_ERR(ctx->cq_ev_fd);
+
+		ctx->cq_ev_fd = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static int io_eventfd_unregister(struct io_ring_ctx *ctx)
+{
+	if (ctx->cq_ev_fd) {
+		eventfd_ctx_put(ctx->cq_ev_fd);
+		ctx->cq_ev_fd = NULL;
+		return 0;
+	}
+
+	return -ENXIO;
+}
+
+static void io_destroy_buffers(struct io_ring_ctx *ctx)
+{
+	struct io_buffer *buf;
+	unsigned long index;
+
+	xa_for_each(&ctx->io_buffers, index, buf)
+		__io_remove_buffers(ctx, buf, index, -1U);
+}
+
+static void io_req_cache_free(struct list_head *list)
+{
+	struct io_kiocb *req, *nxt;
+
+	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
+		list_del(&req->inflight_entry);
+		kmem_cache_free(req_cachep, req);
+	}
+}
+
+static void io_req_caches_free(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	mutex_lock(&ctx->uring_lock);
+
+	if (state->free_reqs) {
+		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
+		state->free_reqs = 0;
+	}
+
+	io_flush_cached_locked_reqs(ctx, state);
+	io_req_cache_free(&state->free_list);
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static void io_wait_rsrc_data(struct io_rsrc_data *data)
+{
+	if (data && !atomic_dec_and_test(&data->refs))
+		wait_for_completion(&data->done);
+}
+
+static void io_ring_ctx_free(struct io_ring_ctx *ctx)
+{
+	io_sq_thread_finish(ctx);
+
+	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
+	io_wait_rsrc_data(ctx->buf_data);
+	io_wait_rsrc_data(ctx->file_data);
+
+	mutex_lock(&ctx->uring_lock);
+	if (ctx->buf_data)
+		__io_sqe_buffers_unregister(ctx);
+	if (ctx->file_data)
+		__io_sqe_files_unregister(ctx);
+	if (ctx->rings)
+		__io_cqring_overflow_flush(ctx, true);
+	mutex_unlock(&ctx->uring_lock);
+	io_eventfd_unregister(ctx);
+	io_destroy_buffers(ctx);
+	if (ctx->sq_creds)
+		put_cred(ctx->sq_creds);
+
+	/* there are no registered resources left, nobody uses it */
+	if (ctx->rsrc_node)
+		io_rsrc_node_destroy(ctx->rsrc_node);
+	if (ctx->rsrc_backup_node)
+		io_rsrc_node_destroy(ctx->rsrc_backup_node);
+	flush_delayed_work(&ctx->rsrc_put_work);
+
+	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
+	WARN_ON_ONCE(!llist_empty(&ctx->rsrc_put_llist));
+
+#if defined(CONFIG_UNIX)
+	if (ctx->ring_sock) {
+		ctx->ring_sock->file = NULL; /* so that iput() is called */
+		sock_release(ctx->ring_sock);
+	}
+#endif
+	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
+
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
+
+	io_mem_free(ctx->rings);
+	io_mem_free(ctx->sq_sqes);
+
+	percpu_ref_exit(&ctx->refs);
+	free_uid(ctx->user);
+	io_req_caches_free(ctx);
+	if (ctx->hash_map)
+		io_wq_put_hash(ctx->hash_map);
+	kfree(ctx->cancel_hash);
+	kfree(ctx->dummy_ubuf);
+	kfree(ctx);
+}
+
+static __poll_t io_uring_poll(struct file *file, poll_table *wait)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &ctx->poll_wait, wait);
+	/*
+	 * synchronizes with barrier from wq_has_sleeper call in
+	 * io_commit_cqring
+	 */
+	smp_rmb();
+	if (!io_sqring_full(ctx))
+		mask |= EPOLLOUT | EPOLLWRNORM;
+
+	/*
+	 * Don't flush cqring overflow list here, just do a simple check.
+	 * Otherwise there could possible be ABBA deadlock:
+	 *      CPU0                    CPU1
+	 *      ----                    ----
+	 * lock(&ctx->uring_lock);
+	 *                              lock(&ep->mtx);
+	 *                              lock(&ctx->uring_lock);
+	 * lock(&ep->mtx);
+	 *
+	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
+	 * pushs them to do the flush.
+	 */
+	if (io_cqring_events(ctx) || test_bit(0, &ctx->check_cq_overflow))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	return mask;
+}
+
+static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
+{
+	const struct cred *creds;
+
+	creds = xa_erase(&ctx->personalities, id);
+	if (creds) {
+		put_cred(creds);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+struct io_tctx_exit {
+	struct callback_head		task_work;
+	struct completion		completion;
+	struct io_ring_ctx		*ctx;
+};
+
+static void io_tctx_exit_cb(struct callback_head *cb)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_exit *work;
+
+	work = container_of(cb, struct io_tctx_exit, task_work);
+	/*
+	 * When @in_idle, we're in cancellation and it's racy to remove the
+	 * node. It'll be removed by the end of cancellation, just ignore it.
+	 * tctx can be NULL if the queueing of this task_work raced with
+	 * work cancelation off the exec path.
+	 */
+	if (tctx && !atomic_read(&tctx->in_idle))
+		io_uring_del_tctx_node((unsigned long)work->ctx);
+	complete(&work->completion);
+}
+
+static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
+static void io_ring_exit_work(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+	unsigned long timeout = jiffies + HZ * 60 * 5;
+	unsigned long interval = HZ / 20;
+	struct io_tctx_exit exit;
+	struct io_tctx_node *node;
+	int ret;
+
+	/*
+	 * If we're doing polled IO and end up having requests being
+	 * submitted async (out-of-line), then completions can come in while
+	 * we're waiting for refs to drop. We need to reap these manually,
+	 * as nobody else will be looking for them.
+	 */
+	do {
+		io_uring_try_cancel_requests(ctx, NULL, true);
+		if (ctx->sq_data) {
+			struct io_sq_data *sqd = ctx->sq_data;
+			struct task_struct *tsk;
+
+			io_sq_thread_park(sqd);
+			tsk = sqd->thread;
+			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
+				io_wq_cancel_cb(tsk->io_uring->io_wq,
+						io_cancel_ctx_cb, ctx, true);
+			io_sq_thread_unpark(sqd);
+		}
+
+		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
+			/* there is little hope left, don't run it too often */
+			interval = HZ * 60;
+		}
+	} while (!wait_for_completion_timeout(&ctx->ref_comp, interval));
+
+	init_completion(&exit.completion);
+	init_task_work(&exit.task_work, io_tctx_exit_cb);
+	exit.ctx = ctx;
+	/*
+	 * Some may use context even when all refs and requests have been put,
+	 * and they are free to do so while still holding uring_lock or
+	 * completion_lock, see io_req_task_submit(). Apart from other work,
+	 * this lock/unlock section also waits them to finish.
+	 */
+	mutex_lock(&ctx->uring_lock);
+	while (!list_empty(&ctx->tctx_list)) {
+		WARN_ON_ONCE(time_after(jiffies, timeout));
+
+		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
+					ctx_node);
+		/* don't spin on a single task if cancellation failed */
+		list_rotate_left(&ctx->tctx_list);
+		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
+		if (WARN_ON_ONCE(ret))
+			continue;
+		wake_up_process(node->task);
+
+		mutex_unlock(&ctx->uring_lock);
+		wait_for_completion(&exit.completion);
+		mutex_lock(&ctx->uring_lock);
+	}
+	mutex_unlock(&ctx->uring_lock);
+	spin_lock(&ctx->completion_lock);
+	spin_unlock(&ctx->completion_lock);
+
+	io_ring_ctx_free(ctx);
+}
+
+/* Returns true if we found and killed one or more timeouts */
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			     bool cancel_all)
+{
+	struct io_kiocb *req, *tmp;
+	int canceled = 0;
+
+	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
+		if (io_match_task(req, tsk, cancel_all)) {
+			io_kill_timeout(req, -ECANCELED);
+			canceled++;
+		}
+	}
+	spin_unlock_irq(&ctx->timeout_lock);
+	if (canceled != 0)
+		io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	if (canceled != 0)
+		io_cqring_ev_posted(ctx);
+	return canceled != 0;
+}
+
+static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
+{
+	unsigned long index;
+	struct creds *creds;
+
+	mutex_lock(&ctx->uring_lock);
+	percpu_ref_kill(&ctx->refs);
+	if (ctx->rings)
+		__io_cqring_overflow_flush(ctx, true);
+	xa_for_each(&ctx->personalities, index, creds)
+		io_unregister_personality(ctx, index);
+	mutex_unlock(&ctx->uring_lock);
+
+	io_kill_timeouts(ctx, NULL, true);
+	io_poll_remove_all(ctx, NULL, true);
+
+	/* if we failed setting up the ctx, we might not have any rings */
+	io_iopoll_try_reap_events(ctx);
+
+	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
+	/*
+	 * Use system_unbound_wq to avoid spawning tons of event kworkers
+	 * if we're exiting a ton of rings at the same time. It just adds
+	 * noise and overhead, there's no discernable change in runtime
+	 * over using system_wq.
+	 */
+	queue_work(system_unbound_wq, &ctx->exit_work);
+}
+
+static int io_uring_release(struct inode *inode, struct file *file)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	file->private_data = NULL;
+	io_ring_ctx_wait_and_kill(ctx);
+	return 0;
+}
+
+struct io_task_cancel {
+	struct task_struct *task;
+	bool all;
+};
+
+static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_task_cancel *cancel = data;
+
+	return io_match_task_safe(req, cancel->task, cancel->all);
+}
+
+static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
+				  struct task_struct *task, bool cancel_all)
+{
+	struct io_defer_entry *de;
+	LIST_HEAD(list);
+
+	spin_lock(&ctx->completion_lock);
+	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
+		if (io_match_task_safe(de->req, task, cancel_all)) {
+			list_cut_position(&list, &ctx->defer_list, &de->list);
+			break;
+		}
+	}
+	spin_unlock(&ctx->completion_lock);
+	if (list_empty(&list))
+		return false;
+
+	while (!list_empty(&list)) {
+		de = list_first_entry(&list, struct io_defer_entry, list);
+		list_del_init(&de->list);
+		io_req_complete_failed(de->req, -ECANCELED);
+		kfree(de);
+	}
+	return true;
+}
+
+static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
+{
+	struct io_tctx_node *node;
+	enum io_wq_cancel cret;
+	bool ret = false;
+
+	mutex_lock(&ctx->uring_lock);
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		/*
+		 * io_wq will stay alive while we hold uring_lock, because it's
+		 * killed after ctx nodes, which requires to take the lock.
+		 */
+		if (!tctx || !tctx->io_wq)
+			continue;
+		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
+		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+	}
+	mutex_unlock(&ctx->uring_lock);
+
+	return ret;
+}
+
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 bool cancel_all)
+{
+	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
+	struct io_uring_task *tctx = task ? task->io_uring : NULL;
+
+	while (1) {
+		enum io_wq_cancel cret;
+		bool ret = false;
+
+		if (!task) {
+			ret |= io_uring_try_cancel_iowq(ctx);
+		} else if (tctx && tctx->io_wq) {
+			/*
+			 * Cancels requests of all rings, not only @ctx, but
+			 * it's fine as the task is in exit/exec.
+			 */
+			cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
+					       &cancel, true);
+			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+		}
+
+		/* SQPOLL thread does its own polling */
+		if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
+		    (ctx->sq_data && ctx->sq_data->thread == current)) {
+			while (!list_empty_careful(&ctx->iopoll_list)) {
+				io_iopoll_try_reap_events(ctx);
+				ret = true;
+			}
+		}
+
+		ret |= io_cancel_defer_files(ctx, task, cancel_all);
+		ret |= io_poll_remove_all(ctx, task, cancel_all);
+		ret |= io_kill_timeouts(ctx, task, cancel_all);
+		if (task)
+			ret |= io_run_task_work();
+		if (!ret)
+			break;
+		cond_resched();
+	}
+}
+
+static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_node *node;
+	int ret;
+
+	if (unlikely(!tctx)) {
+		ret = io_uring_alloc_task_context(current, ctx);
+		if (unlikely(ret))
+			return ret;
+
+		tctx = current->io_uring;
+		if (ctx->iowq_limits_set) {
+			unsigned int limits[2] = { ctx->iowq_limits[0],
+						   ctx->iowq_limits[1], };
+
+			ret = io_wq_max_workers(tctx->io_wq, limits);
+			if (ret)
+				return ret;
+		}
+	}
+	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
+		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
+			return -ENOMEM;
+		node->ctx = ctx;
+		node->task = current;
+
+		ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
+					node, GFP_KERNEL));
+		if (ret) {
+			kfree(node);
+			return ret;
+		}
+
+		mutex_lock(&ctx->uring_lock);
+		list_add(&node->ctx_node, &ctx->tctx_list);
+		mutex_unlock(&ctx->uring_lock);
+	}
+	tctx->last = ctx;
+	return 0;
+}
+
+/*
+ * Note that this task has used io_uring. We use it for cancelation purposes.
+ */
+static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (likely(tctx && tctx->last == ctx))
+		return 0;
+	return __io_uring_add_tctx_node(ctx);
+}
+
+/*
+ * Remove this io_uring_file -> task mapping.
+ */
+static void io_uring_del_tctx_node(unsigned long index)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_node *node;
+
+	if (!tctx)
+		return;
+	node = xa_erase(&tctx->xa, index);
+	if (!node)
+		return;
+
+	WARN_ON_ONCE(current != node->task);
+	WARN_ON_ONCE(list_empty(&node->ctx_node));
+
+	mutex_lock(&node->ctx->uring_lock);
+	list_del(&node->ctx_node);
+	mutex_unlock(&node->ctx->uring_lock);
+
+	if (tctx->last == node->ctx)
+		tctx->last = NULL;
+	kfree(node);
+}
+
+static void io_uring_clean_tctx(struct io_uring_task *tctx)
+{
+	struct io_wq *wq = tctx->io_wq;
+	struct io_tctx_node *node;
+	unsigned long index;
+
+	xa_for_each(&tctx->xa, index, node) {
+		io_uring_del_tctx_node(index);
+		cond_resched();
+	}
+	if (wq) {
+		/*
+		 * Must be after io_uring_del_task_file() (removes nodes under
+		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
+		 */
+		io_wq_put_and_exit(wq);
+		tctx->io_wq = NULL;
+	}
+}
+
+static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
+{
+	if (tracked)
+		return atomic_read(&tctx->inflight_tracked);
+	return percpu_counter_sum(&tctx->inflight);
+}
+
+/*
+ * Find any io_uring ctx that this task has registered or done IO on, and cancel
+ * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
+ */
+static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_ring_ctx *ctx;
+	s64 inflight;
+	DEFINE_WAIT(wait);
+
+	WARN_ON_ONCE(sqd && sqd->thread != current);
+
+	if (!current->io_uring)
+		return;
+	if (tctx->io_wq)
+		io_wq_exit_start(tctx->io_wq);
+
+	atomic_inc(&tctx->in_idle);
+	do {
+		io_uring_drop_tctx_refs(current);
+		/* read completions before cancelations */
+		inflight = tctx_inflight(tctx, !cancel_all);
+		if (!inflight)
+			break;
+
+		if (!sqd) {
+			struct io_tctx_node *node;
+			unsigned long index;
+
+			xa_for_each(&tctx->xa, index, node) {
+				/* sqpoll task will cancel all its requests */
+				if (node->ctx->sq_data)
+					continue;
+				io_uring_try_cancel_requests(node->ctx, current,
+							     cancel_all);
+			}
+		} else {
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				io_uring_try_cancel_requests(ctx, current,
+							     cancel_all);
+		}
+
+		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
+		io_run_task_work();
+		io_uring_drop_tctx_refs(current);
+
+		/*
+		 * If we've seen completions, retry without waiting. This
+		 * avoids a race where a completion comes in before we did
+		 * prepare_to_wait().
+		 */
+		if (inflight == tctx_inflight(tctx, !cancel_all))
+			schedule();
+		finish_wait(&tctx->wait, &wait);
+	} while (1);
+
+	io_uring_clean_tctx(tctx);
+	if (cancel_all) {
+		/*
+		 * We shouldn't run task_works after cancel, so just leave
+		 * ->in_idle set for normal exit.
+		 */
+		atomic_dec(&tctx->in_idle);
+		/* for exec all current's requests should be gone, kill tctx */
+		__io_uring_free(current);
+	}
+}
+
+void __io_uring_cancel(bool cancel_all)
+{
+	io_uring_cancel_generic(cancel_all, NULL);
+}
+
+static void *io_uring_validate_mmap_request(struct file *file,
+					    loff_t pgoff, size_t sz)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+	loff_t offset = pgoff << PAGE_SHIFT;
+	struct page *page;
+	void *ptr;
+
+	switch (offset) {
+	case IORING_OFF_SQ_RING:
+	case IORING_OFF_CQ_RING:
+		ptr = ctx->rings;
+		break;
+	case IORING_OFF_SQES:
+		ptr = ctx->sq_sqes;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	page = virt_to_head_page(ptr);
+	if (sz > page_size(page))
+		return ERR_PTR(-EINVAL);
+
+	return ptr;
+}
+
+#ifdef CONFIG_MMU
+
+static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	size_t sz = vma->vm_end - vma->vm_start;
+	unsigned long pfn;
+	void *ptr;
+
+	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
+	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
+}
+
+#else /* !CONFIG_MMU */
+
+static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -EINVAL;
+}
+
+static unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
+{
+	return NOMMU_MAP_DIRECT | NOMMU_MAP_READ | NOMMU_MAP_WRITE;
+}
+
+static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
+	unsigned long addr, unsigned long len,
+	unsigned long pgoff, unsigned long flags)
+{
+	void *ptr;
+
+	ptr = io_uring_validate_mmap_request(file, pgoff, len);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	return (unsigned long) ptr;
+}
+
+#endif /* !CONFIG_MMU */
+
+static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
+{
+	DEFINE_WAIT(wait);
+
+	do {
+		if (!io_sqring_full(ctx))
+			break;
+		prepare_to_wait(&ctx->sqo_sq_wait, &wait, TASK_INTERRUPTIBLE);
+
+		if (!io_sqring_full(ctx))
+			break;
+		schedule();
+	} while (!signal_pending(current));
+
+	finish_wait(&ctx->sqo_sq_wait, &wait);
+	return 0;
+}
+
+static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
+			  struct __kernel_timespec __user **ts,
+			  const sigset_t __user **sig)
+{
+	struct io_uring_getevents_arg arg;
+
+	/*
+	 * If EXT_ARG isn't set, then we have no timespec and the argp pointer
+	 * is just a pointer to the sigset_t.
+	 */
+	if (!(flags & IORING_ENTER_EXT_ARG)) {
+		*sig = (const sigset_t __user *) argp;
+		*ts = NULL;
+		return 0;
+	}
+
+	/*
+	 * EXT_ARG is set - ensure we agree on the size of it and copy in our
+	 * timespec and sigset_t pointers if good.
+	 */
+	if (*argsz != sizeof(arg))
+		return -EINVAL;
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+	if (arg.pad)
+		return -EINVAL;
+	*sig = u64_to_user_ptr(arg.sigmask);
+	*argsz = arg.sigmask_sz;
+	*ts = u64_to_user_ptr(arg.ts);
+	return 0;
+}
+
+SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
+		u32, min_complete, u32, flags, const void __user *, argp,
+		size_t, argsz)
+{
+	struct io_ring_ctx *ctx;
+	int submitted = 0;
+	struct fd f;
+	long ret;
+
+	io_run_task_work();
+
+	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
+			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
+		return -EINVAL;
+
+	f = fdget(fd);
+	if (unlikely(!f.file))
+		return -EBADF;
+
+	ret = -EOPNOTSUPP;
+	if (unlikely(f.file->f_op != &io_uring_fops))
+		goto out_fput;
+
+	ret = -ENXIO;
+	ctx = f.file->private_data;
+	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
+		goto out_fput;
+
+	ret = -EBADFD;
+	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
+		goto out;
+
+	/*
+	 * For SQ polling, the thread will do all submissions and completions.
+	 * Just return the requested submit count, and wake the thread if
+	 * we were asked to.
+	 */
+	ret = 0;
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		io_cqring_overflow_flush(ctx);
+
+		if (unlikely(ctx->sq_data->thread == NULL)) {
+			ret = -EOWNERDEAD;
+			goto out;
+		}
+		if (flags & IORING_ENTER_SQ_WAKEUP)
+			wake_up(&ctx->sq_data->wait);
+		if (flags & IORING_ENTER_SQ_WAIT) {
+			ret = io_sqpoll_wait_sq(ctx);
+			if (ret)
+				goto out;
+		}
+		submitted = to_submit;
+	} else if (to_submit) {
+		ret = io_uring_add_tctx_node(ctx);
+		if (unlikely(ret))
+			goto out;
+		mutex_lock(&ctx->uring_lock);
+		submitted = io_submit_sqes(ctx, to_submit);
+		mutex_unlock(&ctx->uring_lock);
+
+		if (submitted != to_submit)
+			goto out;
+	}
+	if (flags & IORING_ENTER_GETEVENTS) {
+		const sigset_t __user *sig;
+		struct __kernel_timespec __user *ts;
+
+		ret = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
+		if (unlikely(ret))
+			goto out;
+
+		min_complete = min(min_complete, ctx->cq_entries);
+
+		/*
+		 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
+		 * space applications don't need to do io completion events
+		 * polling again, they can rely on io_sq_thread to do polling
+		 * work, which can reduce cpu usage and uring_lock contention.
+		 */
+		if (ctx->flags & IORING_SETUP_IOPOLL &&
+		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
+			ret = io_iopoll_check(ctx, min_complete);
+		} else {
+			ret = io_cqring_wait(ctx, min_complete, sig, argsz, ts);
+		}
+	}
+
+out:
+	percpu_ref_put(&ctx->refs);
+out_fput:
+	fdput(f);
+	return submitted ? submitted : ret;
+}
+
+#ifdef CONFIG_PROC_FS
+static int io_uring_show_cred(struct seq_file *m, unsigned int id,
+		const struct cred *cred)
+{
+	struct user_namespace *uns = seq_user_ns(m);
+	struct group_info *gi;
+	kernel_cap_t cap;
+	unsigned __capi;
+	int g;
+
+	seq_printf(m, "%5d\n", id);
+	seq_put_decimal_ull(m, "\tUid:\t", from_kuid_munged(uns, cred->uid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->euid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->suid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->fsuid));
+	seq_put_decimal_ull(m, "\n\tGid:\t", from_kgid_munged(uns, cred->gid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->egid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->sgid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->fsgid));
+	seq_puts(m, "\n\tGroups:\t");
+	gi = cred->group_info;
+	for (g = 0; g < gi->ngroups; g++) {
+		seq_put_decimal_ull(m, g ? " " : "",
+					from_kgid_munged(uns, gi->gid[g]));
+	}
+	seq_puts(m, "\n\tCapEff:\t");
+	cap = cred->cap_effective;
+	CAP_FOR_EACH_U32(__capi)
+		seq_put_hex_ll(m, NULL, cap.cap[CAP_LAST_U32 - __capi], 8);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
+{
+	struct io_sq_data *sq = NULL;
+	bool has_lock;
+	int i;
+
+	/*
+	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
+	 * since fdinfo case grabs it in the opposite direction of normal use
+	 * cases. If we fail to get the lock, we just don't iterate any
+	 * structures that could be going away outside the io_uring mutex.
+	 */
+	has_lock = mutex_trylock(&ctx->uring_lock);
+
+	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
+		sq = ctx->sq_data;
+		if (!sq->thread)
+			sq = NULL;
+	}
+
+	seq_printf(m, "SqThread:\t%d\n", sq ? task_pid_nr(sq->thread) : -1);
+	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
+	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
+	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
+		struct file *f = io_file_from_index(ctx, i);
+
+		if (f)
+			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
+		else
+			seq_printf(m, "%5u: <none>\n", i);
+	}
+	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
+	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
+		struct io_mapped_ubuf *buf = ctx->user_bufs[i];
+		unsigned int len = buf->ubuf_end - buf->ubuf;
+
+		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, len);
+	}
+	if (has_lock && !xa_empty(&ctx->personalities)) {
+		unsigned long index;
+		const struct cred *cred;
+
+		seq_printf(m, "Personalities:\n");
+		xa_for_each(&ctx->personalities, index, cred)
+			io_uring_show_cred(m, index, cred);
+	}
+	seq_printf(m, "PollList:\n");
+	spin_lock(&ctx->completion_lock);
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list = &ctx->cancel_hash[i];
+		struct io_kiocb *req;
+
+		hlist_for_each_entry(req, list, hash_node)
+			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
+					req->task->task_works != NULL);
+	}
+	spin_unlock(&ctx->completion_lock);
+	if (has_lock)
+		mutex_unlock(&ctx->uring_lock);
+}
+
+static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct io_ring_ctx *ctx = f->private_data;
+
+	if (percpu_ref_tryget(&ctx->refs)) {
+		__io_uring_show_fdinfo(ctx, m);
+		percpu_ref_put(&ctx->refs);
+	}
+}
+#endif
+
+static const struct file_operations io_uring_fops = {
+	.release	= io_uring_release,
+	.mmap		= io_uring_mmap,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
+	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
+#endif
+	.poll		= io_uring_poll,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= io_uring_show_fdinfo,
+#endif
+};
+
+static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
+				  struct io_uring_params *p)
+{
+	struct io_rings *rings;
+	size_t size, sq_array_offset;
+
+	/* make sure these are sane, as we already accounted them */
+	ctx->sq_entries = p->sq_entries;
+	ctx->cq_entries = p->cq_entries;
+
+	size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	rings = io_mem_alloc(size);
+	if (!rings)
+		return -ENOMEM;
+
+	ctx->rings = rings;
+	ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
+	rings->sq_ring_mask = p->sq_entries - 1;
+	rings->cq_ring_mask = p->cq_entries - 1;
+	rings->sq_ring_entries = p->sq_entries;
+	rings->cq_ring_entries = p->cq_entries;
+
+	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
+	if (size == SIZE_MAX) {
+		io_mem_free(ctx->rings);
+		ctx->rings = NULL;
+		return -EOVERFLOW;
+	}
+
+	ctx->sq_sqes = io_mem_alloc(size);
+	if (!ctx->sq_sqes) {
+		io_mem_free(ctx->rings);
+		ctx->rings = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
+{
+	int ret, fd;
+
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	ret = io_uring_add_tctx_node(ctx);
+	if (ret) {
+		put_unused_fd(fd);
+		return ret;
+	}
+	fd_install(fd, file);
+	return fd;
+}
+
+/*
+ * Allocate an anonymous fd, this is what constitutes the application
+ * visible backing of an io_uring instance. The application mmaps this
+ * fd to gain access to the SQ/CQ ring details. If UNIX sockets are enabled,
+ * we have to tie this fd to a socket for file garbage collection purposes.
+ */
+static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
+{
+	struct file *file;
+#if defined(CONFIG_UNIX)
+	int ret;
+
+	ret = sock_create_kern(&init_net, PF_UNIX, SOCK_RAW, IPPROTO_IP,
+				&ctx->ring_sock);
+	if (ret)
+		return ERR_PTR(ret);
+#endif
+
+	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
+					O_RDWR | O_CLOEXEC);
+#if defined(CONFIG_UNIX)
+	if (IS_ERR(file)) {
+		sock_release(ctx->ring_sock);
+		ctx->ring_sock = NULL;
+	} else {
+		ctx->ring_sock->file = file;
+	}
+#endif
+	return file;
+}
+
+static int io_uring_create(unsigned entries, struct io_uring_params *p,
+			   struct io_uring_params __user *params)
+{
+	struct io_ring_ctx *ctx;
+	struct file *file;
+	int ret;
+
+	if (!entries)
+		return -EINVAL;
+	if (entries > IORING_MAX_ENTRIES) {
+		if (!(p->flags & IORING_SETUP_CLAMP))
+			return -EINVAL;
+		entries = IORING_MAX_ENTRIES;
+	}
+
+	/*
+	 * Use twice as many entries for the CQ ring. It's possible for the
+	 * application to drive a higher depth than the size of the SQ ring,
+	 * since the sqes are only used at submission time. This allows for
+	 * some flexibility in overcommitting a bit. If the application has
+	 * set IORING_SETUP_CQSIZE, it will have passed in the desired number
+	 * of CQ ring entries manually.
+	 */
+	p->sq_entries = roundup_pow_of_two(entries);
+	if (p->flags & IORING_SETUP_CQSIZE) {
+		/*
+		 * If IORING_SETUP_CQSIZE is set, we do the same roundup
+		 * to a power-of-two, if it isn't already. We do NOT impose
+		 * any cq vs sq ring sizing.
+		 */
+		if (!p->cq_entries)
+			return -EINVAL;
+		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
+			if (!(p->flags & IORING_SETUP_CLAMP))
+				return -EINVAL;
+			p->cq_entries = IORING_MAX_CQ_ENTRIES;
+		}
+		p->cq_entries = roundup_pow_of_two(p->cq_entries);
+		if (p->cq_entries < p->sq_entries)
+			return -EINVAL;
+	} else {
+		p->cq_entries = 2 * p->sq_entries;
+	}
+
+	ctx = io_ring_ctx_alloc(p);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->compat = in_compat_syscall();
+	if (!capable(CAP_IPC_LOCK))
+		ctx->user = get_uid(current_user());
+
+	/*
+	 * This is just grabbed for accounting purposes. When a process exits,
+	 * the mm is exited and dropped before the files, hence we need to hang
+	 * on to this mm purely for the purposes of being able to unaccount
+	 * memory (locked/pinned vm). It's not used for anything else.
+	 */
+	mmgrab(current->mm);
+	ctx->mm_account = current->mm;
+
+	ret = io_allocate_scq_urings(ctx, p);
+	if (ret)
+		goto err;
+
+	ret = io_sq_offload_create(ctx, p);
+	if (ret)
+		goto err;
+	/* always set a rsrc node */
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		goto err;
+	io_rsrc_node_switch(ctx, NULL);
+
+	memset(&p->sq_off, 0, sizeof(p->sq_off));
+	p->sq_off.head = offsetof(struct io_rings, sq.head);
+	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
+	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
+	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
+	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
+	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
+	p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
+
+	memset(&p->cq_off, 0, sizeof(p->cq_off));
+	p->cq_off.head = offsetof(struct io_rings, cq.head);
+	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
+	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
+	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
+	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
+	p->cq_off.cqes = offsetof(struct io_rings, cqes);
+	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+
+	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
+			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
+			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
+			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
+			IORING_FEAT_RSRC_TAGS;
+
+	if (copy_to_user(params, p, sizeof(*p))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	file = io_uring_get_file(ctx);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto err;
+	}
+
+	/*
+	 * Install ring fd as the very last thing, so we don't risk someone
+	 * having closed it before we finish setup
+	 */
+	ret = io_uring_install_fd(ctx, file);
+	if (ret < 0) {
+		/* fput will clean it up */
+		fput(file);
+		return ret;
+	}
+
+	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
+	return ret;
+err:
+	io_ring_ctx_wait_and_kill(ctx);
+	return ret;
+}
+
+/*
+ * Sets up an aio uring context, and returns the fd. Applications asks for a
+ * ring size, we return the actual sq/cq ring sizes (among other things) in the
+ * params structure passed in.
+ */
+static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
+{
+	struct io_uring_params p;
+	int i;
+
+	if (copy_from_user(&p, params, sizeof(p)))
+		return -EFAULT;
+	for (i = 0; i < ARRAY_SIZE(p.resv); i++) {
+		if (p.resv[i])
+			return -EINVAL;
+	}
+
+	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
+			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
+			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_R_DISABLED))
+		return -EINVAL;
+
+	return  io_uring_create(entries, &p, params);
+}
+
+SYSCALL_DEFINE2(io_uring_setup, u32, entries,
+		struct io_uring_params __user *, params)
+{
+	return io_uring_setup(entries, params);
+}
+
+static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+{
+	struct io_uring_probe *p;
+	size_t size;
+	int i, ret;
+
+	size = struct_size(p, ops, nr_args);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+	p = kzalloc(size, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(p, arg, size))
+		goto out;
+	ret = -EINVAL;
+	if (memchr_inv(p, 0, size))
+		goto out;
+
+	p->last_op = IORING_OP_LAST - 1;
+	if (nr_args > IORING_OP_LAST)
+		nr_args = IORING_OP_LAST;
+
+	for (i = 0; i < nr_args; i++) {
+		p->ops[i].op = i;
+		if (!io_op_defs[i].not_supported)
+			p->ops[i].flags = IO_URING_OP_SUPPORTED;
+	}
+	p->ops_len = i;
+
+	ret = 0;
+	if (copy_to_user(arg, p, size))
+		ret = -EFAULT;
+out:
+	kfree(p);
+	return ret;
+}
+
+static int io_register_personality(struct io_ring_ctx *ctx)
+{
+	const struct cred *creds;
+	u32 id;
+	int ret;
+
+	creds = get_current_cred();
+
+	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
+			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
+	if (ret < 0) {
+		put_cred(creds);
+		return ret;
+	}
+	return id;
+}
+
+static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
+				    unsigned int nr_args)
+{
+	struct io_uring_restriction *res;
+	size_t size;
+	int i, ret;
+
+	/* Restrictions allowed only if rings started disabled */
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EBADFD;
+
+	/* We allow only a single restrictions registration */
+	if (ctx->restrictions.registered)
+		return -EBUSY;
+
+	if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
+		return -EINVAL;
+
+	size = array_size(nr_args, sizeof(*res));
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	res = memdup_user(arg, size);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	ret = 0;
+
+	for (i = 0; i < nr_args; i++) {
+		switch (res[i].opcode) {
+		case IORING_RESTRICTION_REGISTER_OP:
+			if (res[i].register_op >= IORING_REGISTER_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].register_op,
+				  ctx->restrictions.register_op);
+			break;
+		case IORING_RESTRICTION_SQE_OP:
+			if (res[i].sqe_op >= IORING_OP_LAST) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			__set_bit(res[i].sqe_op, ctx->restrictions.sqe_op);
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
+			ctx->restrictions.sqe_flags_allowed = res[i].sqe_flags;
+			break;
+		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
+			ctx->restrictions.sqe_flags_required = res[i].sqe_flags;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	/* Reset all restrictions if an error happened */
+	if (ret != 0)
+		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+	else
+		ctx->restrictions.registered = true;
+
+	kfree(res);
+	return ret;
+}
+
+static int io_register_enable_rings(struct io_ring_ctx *ctx)
+{
+	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
+		return -EBADFD;
+
+	if (ctx->restrictions.registered)
+		ctx->restricted = 1;
+
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
+		wake_up(&ctx->sq_data->wait);
+	return 0;
+}
+
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
+				     struct io_uring_rsrc_update2 *up,
+				     unsigned nr_args)
+{
+	__u32 tmp;
+	int err;
+
+	if (check_add_overflow(up->offset, nr_args, &tmp))
+		return -EOVERFLOW;
+	err = io_rsrc_node_switch_start(ctx);
+	if (err)
+		return err;
+
+	switch (type) {
+	case IORING_RSRC_FILE:
+		return __io_sqe_files_update(ctx, up, nr_args);
+	case IORING_RSRC_BUFFER:
+		return __io_sqe_buffers_update(ctx, up, nr_args);
+	}
+	return -EINVAL;
+}
+
+static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
+				    unsigned nr_args)
+{
+	struct io_uring_rsrc_update2 up;
+
+	if (!nr_args)
+		return -EINVAL;
+	memset(&up, 0, sizeof(up));
+	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
+		return -EFAULT;
+	if (up.resv || up.resv2)
+		return -EINVAL;
+	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
+}
+
+static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
+				   unsigned size, unsigned type)
+{
+	struct io_uring_rsrc_update2 up;
+
+	if (size != sizeof(up))
+		return -EINVAL;
+	if (copy_from_user(&up, arg, sizeof(up)))
+		return -EFAULT;
+	if (!up.nr || up.resv || up.resv2)
+		return -EINVAL;
+	return __io_register_rsrc_update(ctx, type, &up, up.nr);
+}
+
+static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
+			    unsigned int size, unsigned int type)
+{
+	struct io_uring_rsrc_register rr;
+
+	/* keep it extendible */
+	if (size != sizeof(rr))
+		return -EINVAL;
+
+	memset(&rr, 0, sizeof(rr));
+	if (copy_from_user(&rr, arg, size))
+		return -EFAULT;
+	if (!rr.nr || rr.resv || rr.resv2)
+		return -EINVAL;
+
+	switch (type) {
+	case IORING_RSRC_FILE:
+		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
+					     rr.nr, u64_to_user_ptr(rr.tags));
+	case IORING_RSRC_BUFFER:
+		return io_sqe_buffers_register(ctx, u64_to_user_ptr(rr.data),
+					       rr.nr, u64_to_user_ptr(rr.tags));
+	}
+	return -EINVAL;
+}
+
+static int io_register_iowq_aff(struct io_ring_ctx *ctx, void __user *arg,
+				unsigned len)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	cpumask_var_t new_mask;
+	int ret;
+
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_clear(new_mask);
+	if (len > cpumask_size())
+		len = cpumask_size();
+
+	if (in_compat_syscall()) {
+		ret = compat_get_bitmap(cpumask_bits(new_mask),
+					(const compat_ulong_t __user *)arg,
+					len * 8 /* CHAR_BIT */);
+	} else {
+		ret = copy_from_user(new_mask, arg, len);
+	}
+
+	if (ret) {
+		free_cpumask_var(new_mask);
+		return -EFAULT;
+	}
+
+	ret = io_wq_cpu_affinity(tctx->io_wq, new_mask);
+	free_cpumask_var(new_mask);
+	return ret;
+}
+
+static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+
+	return io_wq_cpu_affinity(tctx->io_wq, NULL);
+}
+
+static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
+					void __user *arg)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_tctx_node *node;
+	struct io_uring_task *tctx = NULL;
+	struct io_sq_data *sqd = NULL;
+	__u32 new_count[2];
+	int i, ret;
+
+	if (copy_from_user(new_count, arg, sizeof(new_count)))
+		return -EFAULT;
+	for (i = 0; i < ARRAY_SIZE(new_count); i++)
+		if (new_count[i] > INT_MAX)
+			return -EINVAL;
+
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		sqd = ctx->sq_data;
+		if (sqd) {
+			/*
+			 * Observe the correct sqd->lock -> ctx->uring_lock
+			 * ordering. Fine to drop uring_lock here, we hold
+			 * a ref to the ctx.
+			 */
+			refcount_inc(&sqd->refs);
+			mutex_unlock(&ctx->uring_lock);
+			mutex_lock(&sqd->lock);
+			mutex_lock(&ctx->uring_lock);
+			if (sqd->thread)
+				tctx = sqd->thread->io_uring;
+		}
+	} else {
+		tctx = current->io_uring;
+	}
+
+	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
+
+	for (i = 0; i < ARRAY_SIZE(new_count); i++)
+		if (new_count[i])
+			ctx->iowq_limits[i] = new_count[i];
+	ctx->iowq_limits_set = true;
+
+	ret = -EINVAL;
+	if (tctx && tctx->io_wq) {
+		ret = io_wq_max_workers(tctx->io_wq, new_count);
+		if (ret)
+			goto err;
+	} else {
+		memset(new_count, 0, sizeof(new_count));
+	}
+
+	if (sqd) {
+		mutex_unlock(&sqd->lock);
+		io_put_sq_data(sqd);
+	}
+
+	if (copy_to_user(arg, new_count, sizeof(new_count)))
+		return -EFAULT;
+
+	/* that's it for SQPOLL, only the SQPOLL task creates requests */
+	if (sqd)
+		return 0;
+
+	/* now propagate the restriction to all registered users */
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		if (WARN_ON_ONCE(!tctx->io_wq))
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(new_count); i++)
+			new_count[i] = ctx->iowq_limits[i];
+		/* ignore errors, it always returns zero anyway */
+		(void)io_wq_max_workers(tctx->io_wq, new_count);
+	}
+	return 0;
+err:
+	if (sqd) {
+		mutex_unlock(&sqd->lock);
+		io_put_sq_data(sqd);
+	}
+	return ret;
+}
+
+static bool io_register_op_must_quiesce(int op)
+{
+	switch (op) {
+	case IORING_REGISTER_BUFFERS:
+	case IORING_UNREGISTER_BUFFERS:
+	case IORING_REGISTER_FILES:
+	case IORING_UNREGISTER_FILES:
+	case IORING_REGISTER_FILES_UPDATE:
+	case IORING_REGISTER_PROBE:
+	case IORING_REGISTER_PERSONALITY:
+	case IORING_UNREGISTER_PERSONALITY:
+	case IORING_REGISTER_FILES2:
+	case IORING_REGISTER_FILES_UPDATE2:
+	case IORING_REGISTER_BUFFERS2:
+	case IORING_REGISTER_BUFFERS_UPDATE:
+	case IORING_REGISTER_IOWQ_AFF:
+	case IORING_UNREGISTER_IOWQ_AFF:
+	case IORING_REGISTER_IOWQ_MAX_WORKERS:
+		return false;
+	default:
+		return true;
+	}
+}
+
+static int io_ctx_quiesce(struct io_ring_ctx *ctx)
+{
+	long ret;
+
+	percpu_ref_kill(&ctx->refs);
+
+	/*
+	 * Drop uring mutex before waiting for references to exit. If another
+	 * thread is currently inside io_uring_enter() it might need to grab the
+	 * uring_lock to make progress. If we hold it here across the drain
+	 * wait, then we can deadlock. It's safe to drop the mutex here, since
+	 * no new references will come in after we've killed the percpu ref.
+	 */
+	mutex_unlock(&ctx->uring_lock);
+	do {
+		ret = wait_for_completion_interruptible(&ctx->ref_comp);
+		if (!ret)
+			break;
+		ret = io_run_task_work_sig();
+	} while (ret >= 0);
+	mutex_lock(&ctx->uring_lock);
+
+	if (ret)
+		io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
+	return ret;
+}
+
+static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
+			       void __user *arg, unsigned nr_args)
+	__releases(ctx->uring_lock)
+	__acquires(ctx->uring_lock)
+{
+	int ret;
+
+	/*
+	 * We're inside the ring mutex, if the ref is already dying, then
+	 * someone else killed the ctx or is already going through
+	 * io_uring_register().
+	 */
+	if (percpu_ref_is_dying(&ctx->refs))
+		return -ENXIO;
+
+	if (ctx->restricted) {
+		if (opcode >= IORING_REGISTER_LAST)
+			return -EINVAL;
+		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
+		if (!test_bit(opcode, ctx->restrictions.register_op))
+			return -EACCES;
+	}
+
+	if (io_register_op_must_quiesce(opcode)) {
+		ret = io_ctx_quiesce(ctx);
+		if (ret)
+			return ret;
+	}
+
+	switch (opcode) {
+	case IORING_REGISTER_BUFFERS:
+		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
+		break;
+	case IORING_UNREGISTER_BUFFERS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_sqe_buffers_unregister(ctx);
+		break;
+	case IORING_REGISTER_FILES:
+		ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
+		break;
+	case IORING_UNREGISTER_FILES:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_sqe_files_unregister(ctx);
+		break;
+	case IORING_REGISTER_FILES_UPDATE:
+		ret = io_register_files_update(ctx, arg, nr_args);
+		break;
+	case IORING_REGISTER_EVENTFD:
+	case IORING_REGISTER_EVENTFD_ASYNC:
+		ret = -EINVAL;
+		if (nr_args != 1)
+			break;
+		ret = io_eventfd_register(ctx, arg);
+		if (ret)
+			break;
+		if (opcode == IORING_REGISTER_EVENTFD_ASYNC)
+			ctx->eventfd_async = 1;
+		else
+			ctx->eventfd_async = 0;
+		break;
+	case IORING_UNREGISTER_EVENTFD:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_eventfd_unregister(ctx);
+		break;
+	case IORING_REGISTER_PROBE:
+		ret = -EINVAL;
+		if (!arg || nr_args > 256)
+			break;
+		ret = io_probe(ctx, arg, nr_args);
+		break;
+	case IORING_REGISTER_PERSONALITY:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_register_personality(ctx);
+		break;
+	case IORING_UNREGISTER_PERSONALITY:
+		ret = -EINVAL;
+		if (arg)
+			break;
+		ret = io_unregister_personality(ctx, nr_args);
+		break;
+	case IORING_REGISTER_ENABLE_RINGS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_register_enable_rings(ctx);
+		break;
+	case IORING_REGISTER_RESTRICTIONS:
+		ret = io_register_restrictions(ctx, arg, nr_args);
+		break;
+	case IORING_REGISTER_FILES2:
+		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_FILE);
+		break;
+	case IORING_REGISTER_FILES_UPDATE2:
+		ret = io_register_rsrc_update(ctx, arg, nr_args,
+					      IORING_RSRC_FILE);
+		break;
+	case IORING_REGISTER_BUFFERS2:
+		ret = io_register_rsrc(ctx, arg, nr_args, IORING_RSRC_BUFFER);
+		break;
+	case IORING_REGISTER_BUFFERS_UPDATE:
+		ret = io_register_rsrc_update(ctx, arg, nr_args,
+					      IORING_RSRC_BUFFER);
+		break;
+	case IORING_REGISTER_IOWQ_AFF:
+		ret = -EINVAL;
+		if (!arg || !nr_args)
+			break;
+		ret = io_register_iowq_aff(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_IOWQ_AFF:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_unregister_iowq_aff(ctx);
+		break;
+	case IORING_REGISTER_IOWQ_MAX_WORKERS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 2)
+			break;
+		ret = io_register_iowq_max_workers(ctx, arg);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (io_register_op_must_quiesce(opcode)) {
+		/* bring the ctx back to life */
+		percpu_ref_reinit(&ctx->refs);
+		reinit_completion(&ctx->ref_comp);
+	}
+	return ret;
+}
+
+SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
+		void __user *, arg, unsigned int, nr_args)
+{
+	struct io_ring_ctx *ctx;
+	long ret = -EBADF;
+	struct fd f;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	ret = -EOPNOTSUPP;
+	if (f.file->f_op != &io_uring_fops)
+		goto out_fput;
+
+	ctx = f.file->private_data;
+
+	io_run_task_work();
+
+	mutex_lock(&ctx->uring_lock);
+	ret = __io_uring_register(ctx, opcode, arg, nr_args);
+	mutex_unlock(&ctx->uring_lock);
+	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs,
+							ctx->cq_ev_fd != NULL, ret);
+out_fput:
+	fdput(f);
+	return ret;
+}
+
+static int __init io_uring_init(void)
+{
+#define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
+	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
+	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
+} while (0)
+
+#define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
+	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
+	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
+	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
+	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
+	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
+	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
+	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
+	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
+	BUILD_BUG_SQE_ELEM(16, __u64,  splice_off_in);
+	BUILD_BUG_SQE_ELEM(24, __u32,  len);
+	BUILD_BUG_SQE_ELEM(28,     __kernel_rwf_t, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */ __u16,  poll_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  accept_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  cancel_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  open_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
+	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
+	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
+	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
+	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
+	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
+	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
+
+	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
+		     sizeof(struct io_uring_rsrc_update));
+	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
+		     sizeof(struct io_uring_rsrc_update2));
+
+	/* ->buf_index is u16 */
+	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
+
+	/* should fit into one byte */
+	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
+
+	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
+
+	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				SLAB_ACCOUNT);
+	return 0;
+};
+__initcall(io_uring_init);
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 6e36e854b512..d8fcc139ac05 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -169,7 +169,6 @@ extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 85be684687b0..bb684fe1b96e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -21,7 +21,7 @@
 #include <asm/tlb.h>
 
 #include "../workqueue_internal.h"
-#include "../../fs/io-wq.h"
+#include "../../io_uring/io-wq.h"
 #include "../smpboot.h"
 
 #include "pelt.h"
diff --git a/mm/gup.c b/mm/gup.c
index 69e45cbe58f8..2370565a81dc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2721,7 +2721,7 @@ static int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr, unsigned lo
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
 			return 0;
-		if (unlikely(pud_huge(pud))) {
+		if (unlikely(pud_huge(pud) || pud_devmap(pud))) {
 			if (!gup_huge_pud(pud, pudp, addr, next, flags,
 					  pages, nr))
 				return 0;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index dd069afd9cb9..fd25d12e85b3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1156,6 +1156,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte,
@@ -1442,6 +1443,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	spinlock_t *ptl;
 	int count = 0;
 	int i;
+	struct mmu_notifier_range range;
 
 	if (!vma || !vma->vm_file ||
 	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
@@ -1456,6 +1458,14 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
 		return;
 
+	/*
+	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
+	 * that got written to. Without this, we'd have to also lock the
+	 * anon_vma if one exists.
+	 */
+	if (vma->anon_vma)
+		return;
+
 	hpage = find_lock_page(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (!hpage)
@@ -1468,6 +1478,19 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		goto drop_hpage;
 
+	/*
+	 * We need to lock the mapping so that from here on, only GUP-fast and
+	 * hardware page walks can access the parts of the page tables that
+	 * we're operating on.
+	 */
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+
+	/*
+	 * This spinlock should be unnecessary: Nobody else should be accessing
+	 * the page tables under spinlock protection here, only
+	 * lockless_pages_from_mm() and the hardware page walker can access page
+	 * tables while all the high-level locks are held in write mode.
+	 */
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 
 	/* step 1: check all mapped PTEs are to the right huge page */
@@ -1514,12 +1537,17 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	}
 
 	/* step 4: collapse pmd */
-	ptl = pmd_lock(vma->vm_mm, pmd);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, haddr,
+				haddr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
 	_pmd = pmdp_collapse_flush(vma, haddr, pmd);
-	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
+	tlb_remove_table_sync_one();
+	mmu_notifier_invalidate_range_end(&range);
 	pte_free(mm, pmd_pgtable(_pmd));
 
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+
 drop_hpage:
 	unlock_page(hpage);
 	put_page(hpage);
@@ -1527,6 +1555,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1575,7 +1604,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma)
 			continue;
@@ -1597,12 +1627,19 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (mmap_write_trylock(mm)) {
 			if (!khugepaged_test_exit(mm)) {
-				spinlock_t *ptl = pmd_lock(mm, pmd);
+				struct mmu_notifier_range range;
+
+				mmu_notifier_range_init(&range,
+							MMU_NOTIFY_CLEAR, 0,
+							NULL, mm, addr,
+							addr + HPAGE_PMD_SIZE);
+				mmu_notifier_invalidate_range_start(&range);
 				/* assume page table is clear */
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
-				spin_unlock(ptl);
 				mm_dec_nr_ptes(mm);
+				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
+				mmu_notifier_invalidate_range_end(&range);
 			}
 			mmap_write_unlock(mm);
 		} else {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 971546bb99e0..3d3364cd4ff1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4789,6 +4789,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -4839,6 +4840,16 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	if (ret < 0)
 		goto out_put_cfile;
 
+	/*
+	 * The control file must be a regular cgroup1 file. As a regular cgroup
+	 * file can't be renamed, it's safe to access its name afterwards.
+	 */
+	cdentry = cfile.file->f_path.dentry;
+	if (cdentry->d_sb->s_type != &cgroup_fs_type || !d_is_reg(cdentry)) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
 	/*
 	 * Determine the event callbacks and set them in @event.  This used
 	 * to be done via struct cftype but cgroup core no longer knows
@@ -4847,7 +4858,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -4871,7 +4882,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 1b9837419bf9..8be26c7ddb47 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -139,7 +139,7 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
-static void tlb_remove_table_sync_one(void)
+void tlb_remove_table_sync_one(void)
 {
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
@@ -163,8 +163,6 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
-static void tlb_remove_table_sync_one(void) { }
-
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
 {
 	__tlb_remove_table_free(batch);
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e1c2c9242ce2..f359cfdc1858 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -122,7 +122,7 @@ struct p9_conn {
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
-	char tmp_buf[7];
+	char tmp_buf[P9_HDRSZ];
 	struct p9_fcall rc;
 	int wpos;
 	int wsize;
@@ -295,7 +295,7 @@ static void p9_read_work(struct work_struct *work)
 	if (!m->rc.sdata) {
 		m->rc.sdata = m->tmp_buf;
 		m->rc.offset = 0;
-		m->rc.capacity = 7; /* start by reading header */
+		m->rc.capacity = P9_HDRSZ; /* start by reading header */
 	}
 
 	clear_bit(Rpending, &m->wsched);
@@ -318,7 +318,7 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
-		m->rc.size = 7;
+		m->rc.size = P9_HDRSZ;
 		err = p9_parse_header(&m->rc, &m->rc.size, NULL, NULL, 0);
 		if (err) {
 			p9_debug(P9_DEBUG_ERROR,
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 427f6caefa29..4255f2a3bea4 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -231,6 +231,14 @@ static void p9_xen_response(struct work_struct *work)
 			continue;
 		}
 
+		if (h.size > req->rc.capacity) {
+			dev_warn(&priv->dev->dev,
+				 "requested packet size too big: %d for tag %d with capacity %zd\n",
+				 h.size, h.tag, req->rc.capacity);
+			req->status = REQ_STATUS_ERROR;
+			goto recv_error;
+		}
+
 		memcpy(&req->rc, &h, sizeof(h));
 		req->rc.offset = 0;
 
@@ -240,6 +248,7 @@ static void p9_xen_response(struct work_struct *work)
 				     masked_prod, &masked_cons,
 				     XEN_9PFS_RING_SIZE(ring));
 
+recv_error:
 		virt_mb();
 		cons += h.size;
 		ring->intf->in_cons = cons;
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index fd164a248569..580b0940f067 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -971,6 +971,7 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, *addr_type);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	if (!hcon)
 		return -ENOENT;
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 1661979b6a6e..ce744b14d1a9 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -736,7 +736,7 @@ static int __init bt_init(void)
 
 	err = bt_sysfs_init();
 	if (err < 0)
-		return err;
+		goto cleanup_led;
 
 	err = sock_register(&bt_sock_family_ops);
 	if (err)
@@ -772,6 +772,8 @@ static int __init bt_init(void)
 	sock_unregister(PF_BLUETOOTH);
 cleanup_sysfs:
 	bt_sysfs_cleanup();
+cleanup_led:
+	bt_leds_cleanup();
 	return err;
 }
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 396696241d17..bb84ff5fb98a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3985,7 +3985,8 @@ int hci_register_dev(struct hci_dev *hdev)
 	hci_sock_dev_event(hdev, HCI_DEV_REG);
 	hci_dev_hold(hdev);
 
-	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+	if (!hdev->suspend_notifier.notifier_call &&
+	    !test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
 		hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
 		error = register_pm_notifier(&hdev->suspend_notifier);
 		if (error)
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 4ddefa6a3e05..20d2dcb7c97a 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -680,7 +680,7 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
@@ -706,7 +706,7 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 846588c0070a..53a206d11685 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -49,7 +49,8 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
+	if (pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index fa1d60d13ad9..6795dd017499 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -22,7 +22,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	pskb_trim_rcsum(skb, skb->len - len);
+	if (pskb_trim_rcsum(skb, skb->len - len))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 2edede9ddac9..d43feadd5fa6 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -644,7 +644,8 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 		 * padding and trailer we need to account for the fact that
 		 * skb->data points to skb_mac_header(skb) + ETH_HLEN.
 		 */
-		pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN);
+		if (pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN))
+			return NULL;
 	/* Trap-to-host frame, no timestamp trailer */
 	} else {
 		*source_port = SJA1110_RX_HEADER_SRC_PORT(rx_header);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 1452bb72b7d9..75c88d486327 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -830,6 +830,9 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	return 0;
 errout:
 	return err;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index af64ae689b13..250af6e5a892 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -421,6 +421,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    nfi->fib_type == fi->fib_type &&
+		    nfi->fib_tb_id == fi->fib_tb_id &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index fc74a3e3b3e1..454c4357a297 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1498,24 +1498,6 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if (t->erspan_ver <= 2) {
-		if (t->erspan_ver != 0 && !t->collect_md)
-			o_flags |= TUNNEL_KEY;
-
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
-			goto nla_put_failure;
-
-		if (t->erspan_ver == 1) {
-			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
-				goto nla_put_failure;
-		} else if (t->erspan_ver == 2) {
-			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
-				goto nla_put_failure;
-			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-				goto nla_put_failure;
-		}
-	}
-
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
 			 gre_tnl_flags_to_gre_flags(p->i_flags)) ||
@@ -1556,6 +1538,34 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	return -EMSGSIZE;
 }
 
+static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+
+	if (t->erspan_ver <= 2) {
+		if (t->erspan_ver != 0 && !t->collect_md)
+			t->parms.o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
+			goto nla_put_failure;
+
+		if (t->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
+				goto nla_put_failure;
+		} else if (t->erspan_ver == 2) {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
+				goto nla_put_failure;
+		}
+	}
+
+	return ipgre_fill_info(skb, dev);
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void erspan_setup(struct net_device *dev)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
@@ -1634,7 +1644,7 @@ static struct rtnl_link_ops erspan_link_ops __read_mostly = {
 	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
-	.fill_info	= ipgre_fill_info,
+	.fill_info	= erspan_fill_info,
 	.get_link_net	= ip_tunnel_get_link_net,
 };
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 7951ade74d14..675a80dd78ba 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -897,6 +897,9 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		if (err < 0)
 			goto fail;
 
+		/* We prevent @rt from being freed. */
+		rcu_read_lock();
+
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
@@ -920,6 +923,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		if (err == 0) {
 			IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 				      IPSTATS_MIB_FRAGOKS);
+			rcu_read_unlock();
 			return 0;
 		}
 
@@ -927,6 +931,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 			      IPSTATS_MIB_FRAGFAILS);
+		rcu_read_unlock();
 		return err;
 
 slow_path_clean:
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 323d3d2d986f..3e510664fc89 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -661,6 +661,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	sdata->dev = ndev;
 	sdata->wpan_dev.wpan_phy = local->hw.phy;
 	sdata->local = local;
+	INIT_LIST_HEAD(&sdata->wpan_dev.list);
 
 	/* setup type-dependent data */
 	ret = ieee802154_setup_sdata(sdata, type);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1727a4c4764f..2cc6092b4f86 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -322,8 +322,13 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
+	u32 mark = READ_ONCE(ct->mark);
+
+	if (!mark)
+		return 0;
+
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
@@ -537,7 +542,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -716,7 +721,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
-	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -821,9 +825,8 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if ((events & (1 << IPCT_MARK) || mark) &&
-	    ctnetlink_dump_mark(skb, mark) < 0)
+	if (events & (1 << IPCT_MARK) &&
+	    ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2692,7 +2695,6 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
-	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2754,8 +2756,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
+	if (ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4f9299b9dcdd..06d46d182634 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1162,6 +1162,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_field *f;
+	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
@@ -1202,9 +1203,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	/* Validate */
+	start_p = start;
+	end_p = end;
 	nft_pipapo_for_each_field(f, i, m) {
-		const u8 *start_p = start, *end_p = end;
-
 		if (f->rules >= (unsigned long)NFT_PIPAPO_RULE0_MAX)
 			return -ENOSPC;
 
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index c5eacaac41ae..8f48b1061944 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -240,6 +240,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sens_res = nfca_poll->sens_res;
 		target->sel_res = nfca_poll->sel_res;
 		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > ARRAY_SIZE(target->nfcid1))
+			return -EPROTO;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
 			       target->nfcid1_len);
@@ -248,6 +250,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
 
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > ARRAY_SIZE(target->sensb_res))
+			return -EPROTO;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
 			       target->sensb_res_len);
@@ -256,6 +260,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
 
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > ARRAY_SIZE(target->sensf_res))
+			return -EPROTO;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
 			       target->sensf_res_len);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 115a4a7950f5..8fdd3b23bd12 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2223,7 +2223,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	if (tipc_own_addr(l->net) > msg_prevnode(hdr))
 		l->net_plane = msg_net_plane(hdr);
 
-	skb_linearize(skb);
+	if (skb_linearize(skb))
+		goto exit;
+
 	hdr = buf_msg(skb);
 	data = msg_data(hdr);
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index b48d97cbbe29..49ddc484c4fe 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1689,6 +1689,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	struct tipc_node *n;
 	struct sk_buff_head xmitq;
 	bool node_up = false;
+	struct net *peer_net;
 	int bearer_id;
 	int rc;
 
@@ -1705,18 +1706,23 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 		return -EHOSTUNREACH;
 	}
 
+	rcu_read_lock();
 	tipc_node_read_lock(n);
 	node_up = node_is_up(n);
-	if (node_up && n->peer_net && check_net(n->peer_net)) {
+	peer_net = n->peer_net;
+	tipc_node_read_unlock(n);
+	if (node_up && peer_net && check_net(peer_net)) {
 		/* xmit inner linux container */
-		tipc_lxc_xmit(n->peer_net, list);
+		tipc_lxc_xmit(peer_net, list);
 		if (likely(skb_queue_empty(list))) {
-			tipc_node_read_unlock(n);
+			rcu_read_unlock();
 			tipc_node_put(n);
 			return 0;
 		}
 	}
+	rcu_read_unlock();
 
+	tipc_node_read_lock(n);
 	bearer_id = n->active_links[selector & 1];
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 7e7d7f45685a..e534e327a6a5 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -113,14 +113,16 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
 }
 
-static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
+static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb,
+			    struct user_namespace *user_ns)
 {
-	uid_t uid = from_kuid_munged(sk_user_ns(nlskb->sk), sock_i_uid(sk));
+	uid_t uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);
 }
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
-		u32 portid, u32 seq, u32 flags, int sk_ino)
+			struct user_namespace *user_ns,
+			u32 portid, u32 seq, u32 flags, int sk_ino)
 {
 	struct nlmsghdr *nlh;
 	struct unix_diag_msg *rep;
@@ -166,7 +168,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&
-	    sk_diag_dump_uid(sk, skb))
+	    sk_diag_dump_uid(sk, skb, user_ns))
 		goto out_nlmsg_trim;
 
 	nlmsg_end(skb, nlh);
@@ -178,7 +180,8 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 }
 
 static int sk_diag_dump(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
-		u32 portid, u32 seq, u32 flags)
+			struct user_namespace *user_ns,
+			u32 portid, u32 seq, u32 flags)
 {
 	int sk_ino;
 
@@ -189,7 +192,7 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	if (!sk_ino)
 		return 0;
 
-	return sk_diag_fill(sk, skb, req, portid, seq, flags, sk_ino);
+	return sk_diag_fill(sk, skb, req, user_ns, portid, seq, flags, sk_ino);
 }
 
 static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
@@ -217,7 +220,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 				goto next;
 			if (!(req->udiag_states & (1 << sk->sk_state)))
 				goto next;
-			if (sk_diag_dump(sk, skb, req,
+			if (sk_diag_dump(sk, skb, req, sk_user_ns(skb->sk),
 					 NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq,
 					 NLM_F_MULTI) < 0)
@@ -285,7 +288,8 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 	if (!rep)
 		goto out;
 
-	err = sk_diag_fill(sk, rep, req, NETLINK_CB(in_skb).portid,
+	err = sk_diag_fill(sk, rep, req, sk_user_ns(NETLINK_CB(in_skb).sk),
+			   NETLINK_CB(in_skb).portid,
 			   nlh->nlmsg_seq, 0, req->udiag_ino);
 	if (err < 0) {
 		nlmsg_free(rep);
diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index b7aee23fc387..47ef6bc30c0e 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -113,15 +113,19 @@ EXPORT_SYMBOL(snd_seq_dump_var_event);
  * expand the variable length event to linear buffer space.
  */
 
-static int seq_copy_in_kernel(char **bufptr, const void *src, int size)
+static int seq_copy_in_kernel(void *ptr, void *src, int size)
 {
+	char **bufptr = ptr;
+
 	memcpy(*bufptr, src, size);
 	*bufptr += size;
 	return 0;
 }
 
-static int seq_copy_in_user(char __user **bufptr, const void *src, int size)
+static int seq_copy_in_user(void *ptr, void *src, int size)
 {
+	char __user **bufptr = ptr;
+
 	if (copy_to_user(*bufptr, src, size))
 		return -EFAULT;
 	*bufptr += size;
@@ -151,8 +155,7 @@ int snd_seq_expand_var_event(const struct snd_seq_event *event, int count, char
 		return newlen;
 	}
 	err = snd_seq_dump_var_event(event,
-				     in_kernel ? (snd_seq_dump_func_t)seq_copy_in_kernel :
-				     (snd_seq_dump_func_t)seq_copy_in_user,
+				     in_kernel ? seq_copy_in_kernel : seq_copy_in_user,
 				     &buf);
 	return err < 0 ? err : newlen;
 }
diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index a085b2f530aa..31e77d462ef3 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -230,7 +230,7 @@ static int rt711_sdca_read_prop(struct sdw_slave *slave)
 	}
 
 	/* set the timeout values */
-	prop->clk_stop_timeout = 20;
+	prop->clk_stop_timeout = 700;
 
 	/* wake-up event */
 	prop->wake_capable = 1;
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 09a73b854964..779f7097d336 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2490,6 +2490,14 @@ static void wm8962_configure_bclk(struct snd_soc_component *component)
 		snd_soc_component_update_bits(component, WM8962_CLOCKING2,
 				WM8962_SYSCLK_ENA_MASK, WM8962_SYSCLK_ENA);
 
+	/* DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
+	 * correct frequency of LRCLK and BCLK. Sometimes the read-only value
+	 * can't be updated timely after enabling SYSCLK. This results in wrong
+	 * calculation values. Delay is introduced here to wait for newest
+	 * value from register. The time of the delay should be at least
+	 * 500~1000us according to test.
+	 */
+	usleep_range(500, 1000);
 	dspclk = snd_soc_component_read(component, WM8962_CLOCKING1);
 
 	if (snd_soc_component_get_bias_level(component) != SND_SOC_BIAS_ON)
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index f6dc71e8ea87..3b673477f621 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1166,6 +1166,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	for_each_dpcm_fe(be, stream, dpcm) {
 		if (dpcm->fe == fe)
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 91f54112167f..364c82b797c1 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4072,10 +4072,13 @@ elif [ "$TESTS" = "ipv6" ]; then
 	TESTS="$TESTS_IPV6"
 fi
 
-which nettest >/dev/null
-if [ $? -ne 0 ]; then
-	echo "'nettest' command not found; skipping tests"
-	exit $ksft_skip
+# nettest can be run from PATH or from same directory as this selftest
+if ! which nettest >/dev/null; then
+	PATH=$PWD:$PATH
+	if ! which nettest >/dev/null; then
+		echo "'nettest' command not found; skipping tests"
+		exit $ksft_skip
+	fi
 fi
 
 declare -i nfail=0
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 996af1ae3d3d..7df066bf74b8 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1622,13 +1622,21 @@ ipv4_del_addr_test()
 
 	$IP addr add dev dummy1 172.16.104.1/24
 	$IP addr add dev dummy1 172.16.104.11/24
+	$IP addr add dev dummy1 172.16.104.12/24
+	$IP addr add dev dummy1 172.16.104.13/24
 	$IP addr add dev dummy2 172.16.104.1/24
 	$IP addr add dev dummy2 172.16.104.11/24
+	$IP addr add dev dummy2 172.16.104.12/24
 	$IP route add 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add 172.16.106.0/24 dev lo src 172.16.104.12
+	$IP route add table 0 172.16.107.0/24 via 172.16.104.2 src 172.16.104.13
 	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
 	set +e
 
 	# removing address from device in vrf should only remove route from vrf table
+	echo "    Regular FIB info"
+
 	$IP addr del dev dummy2 172.16.104.11/24
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 1 "Route removed from VRF when source address deleted"
@@ -1646,6 +1654,35 @@ ipv4_del_addr_test()
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 0 "Route in VRF is not removed by address delete"
 
+	# removing address from device in vrf should only remove route from vrf
+	# table even when the associated fib info only differs in table ID
+	echo "    Identical FIB info with different table ID"
+
+	$IP addr del dev dummy2 172.16.104.12/24
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed from VRF when source address deleted"
+
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in default VRF not removed"
+
+	$IP addr add dev dummy2 172.16.104.12/24
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
+
+	$IP addr del dev dummy1 172.16.104.12/24
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in VRF is not removed by address delete"
+
+	# removing address from device in default vrf should remove route from
+	# the default vrf even when route was inserted with a table ID of 0.
+	echo "    Table ID 0"
+
+	$IP addr del dev dummy1 172.16.104.13/24
+	$IP ro ls | grep -q 172.16.107.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 694732e4b344..da6ab300207c 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -671,10 +671,12 @@ setup_xfrm() {
 }
 
 setup_nettest_xfrm() {
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		echo "'nettest' command not found; skipping tests"
-	        return 1
+	if ! which nettest >/dev/null; then
+		PATH=$PWD:$PATH
+		if ! which nettest >/dev/null; then
+			echo "'nettest' command not found; skipping tests"
+			return 1
+		fi
 	fi
 
 	[ ${1} -eq 6 ] && proto="-6" || proto=""
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index c9ce3dfa42ee..c3a905923ef2 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -782,7 +782,7 @@ kci_test_ipsec_offload()
 	    tmpl proto esp src $srcip dst $dstip spi 9 \
 	    mode transport reqid 42
 	check_err $?
-	ip x p add dir out src $dstip/24 dst $srcip/24 \
+	ip x p add dir in src $dstip/24 dst $srcip/24 \
 	    tmpl proto esp src $dstip dst $srcip spi 9 \
 	    mode transport reqid 42
 	check_err $?
