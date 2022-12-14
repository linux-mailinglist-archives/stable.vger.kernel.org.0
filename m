Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E936E64CD4E
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbiLNPst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238662AbiLNPrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:47:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEABA286C1;
        Wed, 14 Dec 2022 07:47:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD699B818E8;
        Wed, 14 Dec 2022 15:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309F6C433D2;
        Wed, 14 Dec 2022 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032845;
        bh=eo0KwYEMLgD1wMvWHWKSGF0eaWJlHH0vNKYgF0XgWYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fL8ZLv/TDisfr9GK4Uclwd1gRojxhebu4EqIfVX8dIyoPEjNimHgdJ3ZHu9vsXeh+
         7d799oEZPG3HHrkmXnoLftd+yCDBUl9To/KzZN8ZufC3lb8cHPcltYgtCavh+XQ25S
         EuaG8tZN7JA0F6chO8heyfqP+KF72A3fnHaL0p1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.227
Date:   Wed, 14 Dec 2022 16:47:02 +0100
Message-Id: <167103282211939@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <16710328225916@kroah.com>
References: <16710328225916@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 78a64488b28c..111f7c91ed6f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 226
+SUBLEVEL = 227
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index 2a7e6624efb9..ea23ba98625e 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -31,7 +31,7 @@
 &i2c1 {
 	status = "okay";
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index c9a7f5409960..f8e51ca3ee00 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -67,7 +67,7 @@
 		#sound-dai-cells = <0>;
 	};
 
-	ir_recv: gpio-ir-receiver {
+	ir_recv: ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index ee8a24a0e3cb..5e8ba80d7b4f 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -404,7 +404,7 @@
 				rockchip,pins = <2 RK_PD3 1 &pcfg_pull_none>;
 			};
 
-			lcdc1_rgb24: ldcd1-rgb24 {
+			lcdc1_rgb24: lcdc1-rgb24 {
 				rockchip,pins = <2 RK_PA0 1 &pcfg_pull_none>,
 						<2 RK_PA1 1 &pcfg_pull_none>,
 						<2 RK_PA2 1 &pcfg_pull_none>,
@@ -632,7 +632,6 @@
 
 &global_timer {
 	interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
-	status = "disabled";
 };
 
 &local_timer {
diff --git a/arch/arm/boot/dts/rk3288-evb-act8846.dts b/arch/arm/boot/dts/rk3288-evb-act8846.dts
index 80080767c365..9ac40c100e3f 100644
--- a/arch/arm/boot/dts/rk3288-evb-act8846.dts
+++ b/arch/arm/boot/dts/rk3288-evb-act8846.dts
@@ -53,7 +53,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563@51 {
+	rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 
diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi b/arch/arm/boot/dts/rk3288-firefly.dtsi
index 5e0a19004e46..8d418881166f 100644
--- a/arch/arm/boot/dts/rk3288-firefly.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
@@ -233,7 +233,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3288-miqi.dts b/arch/arm/boot/dts/rk3288-miqi.dts
index c41d012c8850..bf8f3f9bb4d5 100644
--- a/arch/arm/boot/dts/rk3288-miqi.dts
+++ b/arch/arm/boot/dts/rk3288-miqi.dts
@@ -145,7 +145,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3288-rock2-square.dts b/arch/arm/boot/dts/rk3288-rock2-square.dts
index cdcdc921ee09..7220de126635 100644
--- a/arch/arm/boot/dts/rk3288-rock2-square.dts
+++ b/arch/arm/boot/dts/rk3288-rock2-square.dts
@@ -165,7 +165,7 @@
 };
 
 &i2c0 {
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index bce0b05ef7bf..0580eea90fbc 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -108,6 +108,13 @@
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
index 010fa1a35a68..e8ac2f95fb37 100644
--- a/arch/arm/include/asm/pgtable-nommu.h
+++ b/arch/arm/include/asm/pgtable-nommu.h
@@ -51,12 +51,6 @@
 
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
index 3ae120cd1715..ecfd6e7e128f 100644
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
 
 #include <asm-generic/4level-fixup.h>
@@ -166,13 +175,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
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
index 24ecf8d30a1e..a3ad8a1b0e07 100644
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
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
index da3b031d4bef..79d04a664b82 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts
@@ -441,7 +441,6 @@
 &i2s1 {
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
-	status = "okay";
 };
 
 &i2s2 {
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 4f6c22d72072..2021946176de 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -540,8 +540,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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
diff --git a/drivers/gpio/gpio-amd8111.c b/drivers/gpio/gpio-amd8111.c
index fdcebe59510d..68d95051dd0e 100644
--- a/drivers/gpio/gpio-amd8111.c
+++ b/drivers/gpio/gpio-amd8111.c
@@ -231,7 +231,10 @@ static int __init amd_gpio_init(void)
 		ioport_unmap(gp.pm);
 		goto out;
 	}
+	return 0;
+
 out:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -239,6 +242,7 @@ static void __exit amd_gpio_exit(void)
 {
 	gpiochip_remove(&gp.chip);
 	ioport_unmap(gp.pm);
+	pci_dev_put(gp.pdev);
 }
 
 module_init(amd_gpio_init);
diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index dbb4a374cb64..20ea1c6bc8bb 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -460,9 +460,9 @@ static void ti_sn_bridge_set_video_timings(struct ti_sn_bridge *pdata)
 		&pdata->bridge.encoder->crtc->state->adjusted_mode;
 	u8 hsync_polarity = 0, vsync_polarity = 0;
 
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
 		hsync_polarity = CHA_HSYNC_POLARITY;
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
 		vsync_polarity = CHA_VSYNC_POLARITY;
 
 	ti_sn_bridge_write_u16(pdata, SN_CHA_ACTIVE_LINE_LENGTH_LOW_REG,
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index d88f4230c221..d266fbb37319 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -554,10 +554,8 @@ int drm_gem_shmem_mmap(struct file *filp, struct vm_area_struct *vma)
 	shmem = to_drm_gem_shmem_obj(vma->vm_private_data);
 
 	ret = drm_gem_shmem_get_pages(shmem);
-	if (ret) {
-		drm_gem_vm_close(vma);
+	if (ret)
 		return ret;
-	}
 
 	/* VM_PFNMAP was set by drm_gem_mmap() */
 	vma->vm_flags &= ~VM_PFNMAP;
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index b6740ad773ee..eda96c92977b 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1303,6 +1303,9 @@ static s32 snto32(__u32 value, unsigned n)
 	if (!value || !n)
 		return 0;
 
+	if (n > 32)
+		n = 32;
+
 	switch (n) {
 	case 8:  return ((__s8)value);
 	case 16: return ((__s16)value);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d6cd94cad571..0d4479f478aa 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -259,6 +259,7 @@
 #define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
+#define USB_DEVICE_ID_CHERRY_MOUSE_000C	0x000c
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 #define USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR	0x0027
 
@@ -864,6 +865,7 @@
 #define USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER	0x02fd
 #define USB_DEVICE_ID_MS_PIXART_MOUSE    0x00cb
 #define USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS      0x02e0
+#define USB_DEVICE_ID_MS_MOUSE_0783      0x0783
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
@@ -1292,6 +1294,7 @@
 
 #define USB_VENDOR_ID_PRIMAX	0x0461
 #define USB_DEVICE_ID_PRIMAX_MOUSE_4D22	0x4d22
+#define USB_DEVICE_ID_PRIMAX_MOUSE_4E2A	0x4e2a
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 #define USB_DEVICE_ID_PRIMAX_REZEL	0x4e72
 #define USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F	0x4d0f
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
index 89e236b71ddf..baad65fcdff7 100644
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
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 6d0775678f43..845ef4b2a4bf 100644
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
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 8847942a8d97..73c5343e609b 100644
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
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 825d840cdb8c..1458416f4f91 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1551,6 +1551,7 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 
 	memset(&ent, 0, sizeof(ent));
 	ent.port = port;
+	ent.is_valid = is_valid;
 	ent.vid = vid;
 	ent.is_static = true;
 	memcpy(ent.mac, addr, ETH_ALEN);
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 907904c0a288..19e2b838750c 100644
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
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 27ea528ef448..e861567b2c49 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2268,7 +2268,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_unregister_interrupts;
+		goto err_destroy_workqueue;
 	}
 
 	nic->msg_enable = debug;
@@ -2277,6 +2277,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+err_destroy_workqueue:
+	destroy_workqueue(nic->nicvf_rx_mode_wq);
 err_unregister_interrupts:
 	nicvf_unregister_interrupts(nic);
 err_free_netdev:
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 90ab7ade44c4..2ee6265228d1 100644
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
index c41b19c760f8..645cae590dc4 100644
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
index cbd83bb5c1ac..b0d43985724d 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5916,9 +5916,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
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
index 7059ced24739..95a6f8689b6f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4233,11 +4233,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
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
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 15f177185d71..d612b23c2e3f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9953,6 +9953,21 @@ static int i40e_rebuild_channels(struct i40e_vsi *vsi)
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
@@ -9984,8 +9999,10 @@ static void i40e_prep_for_reset(struct i40e_pf *pf, bool lock_acquired)
 		rtnl_unlock();
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
-		if (pf->vsi[v])
+		if (pf->vsi[v]) {
+			i40e_clean_xps_state(pf->vsi[v]);
 			pf->vsi[v]->seid = 0;
+		}
 	}
 
 	i40e_shutdown_adminq(&pf->hw);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index fb060e3253d9..be07148a7b29 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1394,6 +1394,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(I40E_VF_STATE_RESETTING, &vf->vf_states);
 
 	return true;
@@ -1517,6 +1518,7 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 	}
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(__I40E_VF_DISABLE, pf->state);
 
 	return true;
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index f80933320fd3..6196f9bbd67d 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1402,6 +1402,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
 			*data = 1;
 			return -1;
 		}
+		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
+		wr32(E1000_EIMS, BIT(0));
 	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
 		shared_int = false;
 		if (request_irq(irq,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 64aa5510e61a..2c1ee3268498 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3717,7 +3717,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
 	 */
-	if (cpu_online(pp->rxq_def))
+	if (pp->rxq_def < nr_cpu_ids && cpu_online(pp->rxq_def))
 		elected_cpu = pp->rxq_def;
 
 	max_cpu = num_present_cpus();
diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index e2528633c09a..8c6c5c706992 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -364,7 +364,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -402,7 +402,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 70cbf48c2c03..a2ff9b4727ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -107,10 +107,10 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 
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
index 47959aadbc50..66cf09e637e4 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -926,7 +926,7 @@ static int ca8210_spi_transfer(
 
 	dev_dbg(&spi->dev, "%s called\n", __func__);
 
-	cas_ctl = kmalloc(sizeof(*cas_ctl), GFP_ATOMIC);
+	cas_ctl = kzalloc(sizeof(*cas_ctl), GFP_ATOMIC);
 	if (!cas_ctl)
 		return -ENOMEM;
 
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 0432a4f829a9..9739a6ed91ad 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -973,7 +973,7 @@ static int cc2520_hw_init(struct cc2520_private *priv)
 
 		if (timeout-- <= 0) {
 			dev_err(&priv->spi->dev, "oscillator start failed!\n");
-			return ret;
+			return -ETIMEDOUT;
 		}
 		udelay(1);
 	} while (!(status & CC2520_STATUS_XOSC32M_STABLE));
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index e8b7d596d749..4b50c28f01a7 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -444,12 +444,12 @@ plip_bh_timeout_error(struct net_device *dev, struct net_local *nl,
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
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 7f0e3b09f776..c310cdbfd583 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1374,6 +1374,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
 	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
 	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
+	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index f7e746f1c9fb..ced413d394cd 100644
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
@@ -364,11 +361,6 @@ void xenvif_free(struct xenvif *vif);
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
@@ -391,17 +383,13 @@ int xenvif_dealloc_kthread(void *data);
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
-void xenvif_rx_action(struct xenvif_queue *queue);
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
 
 /* Callback from stack when TX packet can be released */
 void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success);
 
-/* Unmap a pending page and release it back to the guest */
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
-
 static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 {
 	return MAX_PENDING_REQS -
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 809089587301..6432f6e7fd54 100644
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
index 995566a2785f..036459670fc3 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -105,6 +105,8 @@ static void make_tx_response(struct xenvif_queue *queue,
 			     s8       st);
 static void push_tx_responses(struct xenvif_queue *queue);
 
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
+
 static inline int tx_work_todo(struct xenvif_queue *queue);
 
 static inline unsigned long idx_to_pfn(struct xenvif_queue *queue,
@@ -323,10 +325,13 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 
 
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
@@ -361,31 +366,93 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
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
@@ -406,7 +473,8 @@ static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif_queue *que
 		skb_shinfo(skb)->frag_list = nskb;
 	}
 
-	return gop;
+	(*copy_ops) = cop - queue->tx_copy_ops;
+	(*map_ops) = gop - queue->tx_map_ops;
 }
 
 static inline void xenvif_grant_handle_set(struct xenvif_queue *queue,
@@ -442,7 +510,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 			       struct gnttab_copy **gopp_copy)
 {
 	struct gnttab_map_grant_ref *gop_map = *gopp_map;
-	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+	u16 pending_idx;
 	/* This always points to the shinfo of the skb being checked, which
 	 * could be either the first or the one on the frag_list
 	 */
@@ -453,24 +521,37 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
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
@@ -517,14 +598,6 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
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
@@ -794,7 +867,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 				     unsigned *copy_ops,
 				     unsigned *map_ops)
 {
-	struct gnttab_map_grant_ref *gop = queue->tx_map_ops;
 	struct sk_buff *skb, *nskb;
 	int ret;
 	unsigned int frag_overflow;
@@ -876,8 +948,12 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
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
 
@@ -903,9 +979,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		index = pending_index(queue->pending_cons);
 		pending_idx = queue->pending_ring[index];
 
-		data_len = (txreq.size > XEN_NETBACK_TX_COPY_LEN &&
-			    ret < XEN_NETBK_LEGACY_SLOTS_MAX) ?
-			XEN_NETBACK_TX_COPY_LEN : txreq.size;
+		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
+			data_len = txreq.size;
 
 		skb = xenvif_alloc_skb(data_len);
 		if (unlikely(skb == NULL)) {
@@ -916,8 +991,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		}
 
 		skb_shinfo(skb)->nr_frags = ret;
-		if (data_len < txreq.size)
-			skb_shinfo(skb)->nr_frags++;
 		/* At this point shinfo->nr_frags is in fact the number of
 		 * slots, which can be as large as XEN_NETBK_LEGACY_SLOTS_MAX.
 		 */
@@ -979,54 +1052,19 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
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
 
@@ -1105,9 +1143,8 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 	while ((skb = __skb_dequeue(&queue->tx_queue)) != NULL) {
 		struct xen_netif_tx_request *txp;
 		u16 pending_idx;
-		unsigned data_len;
 
-		pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+		pending_idx = copy_pending_idx(skb, 0);
 		txp = &queue->pending_tx_info[pending_idx].req;
 
 		/* Check the remap error code. */
@@ -1126,18 +1163,6 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
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
@@ -1323,7 +1348,7 @@ static inline void xenvif_tx_dealloc_action(struct xenvif_queue *queue)
 /* Called after netfront has transmitted */
 int xenvif_tx_action(struct xenvif_queue *queue, int budget)
 {
-	unsigned nr_mops, nr_cops = 0;
+	unsigned nr_mops = 0, nr_cops = 0;
 	int work_done, ret;
 
 	if (unlikely(!tx_work_todo(queue)))
@@ -1410,7 +1435,7 @@ static void push_tx_responses(struct xenvif_queue *queue)
 		notify_remote_via_irq(queue->tx_irq);
 }
 
-void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
+static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)
 {
 	int ret;
 	struct gnttab_unmap_grant_ref tx_unmap_op;
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 85a5a622ec18..ab216970137c 100644
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
@@ -473,7 +475,7 @@ static void xenvif_rx_skb(struct xenvif_queue *queue)
 
 #define RX_BATCH_SIZE 64
 
-void xenvif_rx_action(struct xenvif_queue *queue)
+static void xenvif_rx_action(struct xenvif_queue *queue)
 {
 	struct sk_buff_head completed_skbs;
 	unsigned int work_done = 0;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 810fa9968be7..9ae0903bc225 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1621,6 +1621,12 @@ static int netfront_resume(struct xenbus_device *dev)
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
index 3b5e5fb158be..029a89aead53 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2806,10 +2806,6 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 	if (!ctrl->identified) {
 		int i;
 
-		ret = nvme_init_subsystem(ctrl, id);
-		if (ret)
-			goto out_free;
-
 		/*
 		 * Check for quirks.  Quirk can depend on firmware version,
 		 * so, in principle, the set of quirks present can change
@@ -2822,6 +2818,10 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
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
index a0565daecace..5a18d7e620a5 100644
--- a/drivers/regulator/slg51000-regulator.c
+++ b/drivers/regulator/slg51000-regulator.c
@@ -465,6 +465,8 @@ static int slg51000_i2c_probe(struct i2c_client *client,
 		chip->cs_gpiod = cs_gpiod;
 	}
 
+	usleep_range(10000, 11000);
+
 	i2c_set_clientdata(client, chip);
 	chip->chip_irq = client->irq;
 	chip->dev = dev;
diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 4ffb32ffec35..71625db3a6f1 100644
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
 
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 4a544e1e2038..673af5937489 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -604,7 +604,7 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		if (scr_readw(r) != vc->vc_video_erase_char)
 			break;
 	if (r != q && new_rows >= rows + logo_lines) {
-		save = kmalloc(array3_size(logo_lines, new_cols, 2),
+		save = kzalloc(array3_size(logo_lines, new_cols, 2),
 			       GFP_KERNEL);
 		if (save) {
 			int i = cols < new_cols ? cols : new_cols;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e258fc484cea..fb1996980d26 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5405,6 +5405,7 @@ static int clone_range(struct send_ctx *sctx,
 		u64 ext_len;
 		u64 clone_len;
 		u64 clone_data_offset;
+		bool crossed_src_i_size = false;
 
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(clone_root->root, path);
@@ -5461,8 +5462,10 @@ static int clone_range(struct send_ctx *sctx,
 		if (key.offset >= clone_src_i_size)
 			break;
 
-		if (key.offset + ext_len > clone_src_i_size)
+		if (key.offset + ext_len > clone_src_i_size) {
 			ext_len = clone_src_i_size - key.offset;
+			crossed_src_i_size = true;
+		}
 
 		clone_data_offset = btrfs_file_extent_offset(leaf, ei);
 		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
@@ -5522,6 +5525,25 @@ static int clone_range(struct send_ctx *sctx,
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
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 268674c1d568..b06240b67199 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -190,12 +190,16 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+void tlb_remove_table_sync_one(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
 #error tlb_needs_table_invalidate() requires HAVE_RCU_TABLE_FREE
 #endif
 
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 202852383ae9..522aa6b6d9b0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -69,6 +69,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 8dfb2526b3aa..803989eae99e 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -169,7 +169,6 @@ extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
diff --git a/mm/gup.c b/mm/gup.c
index 3ef769529548..7ec083fe1c50 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2240,7 +2240,7 @@ static int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr, unsigned lo
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
 			return 0;
-		if (unlikely(pud_huge(pud))) {
+		if (unlikely(pud_huge(pud) || pud_devmap(pud))) {
 			if (!gup_huge_pud(pud, pudp, addr, next, flags,
 					  pages, nr))
 				return 0;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3c2326568193..8e67d2e5ff39 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1060,6 +1060,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1312,6 +1313,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	spinlock_t *ptl;
 	int count = 0;
 	int i;
+	struct mmu_notifier_range range;
 
 	if (!vma || !vma->vm_file ||
 	    vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE)
@@ -1326,6 +1328,14 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1338,6 +1348,19 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1384,12 +1407,17 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
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
@@ -1397,6 +1425,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1446,7 +1475,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma)
 			continue;
@@ -1468,12 +1498,19 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (down_write_trylock(&mm->mmap_sem)) {
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
 			up_write(&mm->mmap_sem);
 		} else {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8fc663545498..62861daf3589 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4709,6 +4709,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -4759,6 +4760,16 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
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
@@ -4767,7 +4778,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -4791,7 +4802,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7c1b8f67af7b..341aa036b03c 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -117,6 +117,11 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
+void tlb_remove_table_sync_one(void)
+{
+	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+}
+
 static void tlb_remove_table_one(void *table)
 {
 	/*
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 23c1d78ab1e4..872568cca926 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -118,7 +118,7 @@ struct p9_conn {
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
-	char tmp_buf[7];
+	char tmp_buf[P9_HDRSZ];
 	struct p9_fcall rc;
 	int wpos;
 	int wsize;
@@ -291,7 +291,7 @@ static void p9_read_work(struct work_struct *work)
 	if (!m->rc.sdata) {
 		m->rc.sdata = m->tmp_buf;
 		m->rc.offset = 0;
-		m->rc.capacity = 7; /* start by reading header */
+		m->rc.capacity = P9_HDRSZ; /* start by reading header */
 	}
 
 	clear_bit(Rpending, &m->wsched);
@@ -314,7 +314,7 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
-		m->rc.size = 7;
+		m->rc.size = P9_HDRSZ;
 		err = p9_parse_header(&m->rc, &m->rc.size, NULL, NULL, 0);
 		if (err) {
 			p9_debug(P9_DEBUG_ERROR,
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 2779ec1053a0..f043938ae782 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -230,6 +230,14 @@ static void p9_xen_response(struct work_struct *work)
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
 
@@ -239,6 +247,7 @@ static void p9_xen_response(struct work_struct *work)
 				     masked_prod, &masked_cons,
 				     XEN_9PFS_RING_SIZE);
 
+recv_error:
 		virt_mb();
 		cons += h.size;
 		ring->intf->in_cons = cons;
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 52fb6d6d6d58..bccad8c048da 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1002,6 +1002,7 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, *addr_type);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	if (!hcon)
 		return -ENOENT;
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 5f508c50649d..8031526eeeee 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -735,7 +735,7 @@ static int __init bt_init(void)
 
 	err = bt_sysfs_init();
 	if (err < 0)
-		return err;
+		goto cleanup_led;
 
 	err = sock_register(&bt_sock_family_ops);
 	if (err)
@@ -771,6 +771,8 @@ static int __init bt_init(void)
 	sock_unregister(PF_BLUETOOTH);
 cleanup_sysfs:
 	bt_sysfs_cleanup();
+cleanup_led:
+	bt_leds_cleanup();
 	return err;
 }
 
diff --git a/net/can/af_can.c b/net/can/af_can.c
index f7dc68cd86e4..b396c23561d6 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -678,7 +678,7 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
@@ -704,7 +704,7 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 73605bcbb385..7354c5db3a14 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -62,7 +62,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	pskb_trim_rcsum(skb, skb->len - len);
+	if (pskb_trim_rcsum(skb, skb->len - len))
+		return NULL;
 
 	skb->offload_fwd_mark = true;
 
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index d38c8ca93ba0..be31eeacb0be 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -840,6 +840,9 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	return 0;
 errout:
 	return err;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 908913d75847..f45b9daf62cf 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -420,6 +420,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    nfi->fib_type == fi->fib_type &&
+		    nfi->fib_tb_id == fi->fib_tb_id &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 5585e3a94f3c..457eb07be482 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -919,6 +919,9 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		if (err < 0)
 			goto fail;
 
+		/* We prevent @rt from being freed. */
+		rcu_read_lock();
+
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
@@ -942,6 +945,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		if (err == 0) {
 			IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 				      IPSTATS_MIB_FRAGOKS);
+			rcu_read_unlock();
 			return 0;
 		}
 
@@ -949,6 +953,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 			      IPSTATS_MIB_FRAGFAILS);
+		rcu_read_unlock();
 		return err;
 
 slow_path_clean:
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 1cf5ac09edcb..a08240fe68a7 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -661,6 +661,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	sdata->dev = ndev;
 	sdata->wpan_dev.wpan_phy = local->hw.phy;
 	sdata->local = local;
+	INIT_LIST_HEAD(&sdata->wpan_dev.list);
 
 	/* setup type-dependent data */
 	ret = ieee802154_setup_sdata(sdata, type);
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 33e1170817f0..f8b20cddd5c9 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -218,6 +218,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sens_res = nfca_poll->sens_res;
 		target->sel_res = nfca_poll->sel_res;
 		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > ARRAY_SIZE(target->nfcid1))
+			return -EPROTO;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
 			       target->nfcid1_len);
@@ -226,6 +228,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
 
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > ARRAY_SIZE(target->sensb_res))
+			return -EPROTO;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
 			       target->sensb_res_len);
@@ -234,6 +238,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
 
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > ARRAY_SIZE(target->sensf_res))
+			return -EPROTO;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
 			       target->sensf_res_len);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 8f2ee71c63c6..b653d16ab21f 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1971,7 +1971,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	if (tipc_own_addr(l->net) > msg_prevnode(hdr))
 		l->net_plane = msg_net_plane(hdr);
 
-	skb_linearize(skb);
+	if (skb_linearize(skb))
+		goto exit;
+
 	hdr = buf_msg(skb);
 	data = msg_data(hdr);
 
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 9ff64f9df1f3..951b33fa8f5c 100644
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
index 65db1a7c77b7..bb76a2dd0a2f 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -112,15 +112,19 @@ EXPORT_SYMBOL(snd_seq_dump_var_event);
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
@@ -149,8 +153,7 @@ int snd_seq_expand_var_event(const struct snd_seq_event *event, int count, char
 		return newlen;
 	}
 	err = snd_seq_dump_var_event(event,
-				     in_kernel ? (snd_seq_dump_func_t)seq_copy_in_kernel :
-				     (snd_seq_dump_func_t)seq_copy_in_user,
+				     in_kernel ? seq_copy_in_kernel : seq_copy_in_user,
 				     &buf);
 	return err < 0 ? err : newlen;
 }
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 1196167364d4..2f1ab70a68fc 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1201,6 +1201,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	for_each_dpcm_fe(be, stream, dpcm) {
 		if (dpcm->fe == fe)
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
deleted file mode 100755
index 6986086035d6..000000000000
--- a/tools/testing/selftests/net/fib_tests.sh
+++ /dev/null
@@ -1,1727 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-# This test is for checking IPv4 and IPv6 FIB behavior in response to
-# different events.
-
-ret=0
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-# all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter"
-
-VERBOSE=0
-PAUSE_ON_FAIL=no
-PAUSE=no
-IP="ip -netns ns1"
-NS_EXEC="ip netns exec ns1"
-
-which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
-
-log_test()
-{
-	local rc=$1
-	local expected=$2
-	local msg="$3"
-
-	if [ ${rc} -eq ${expected} ]; then
-		printf "    TEST: %-60s  [ OK ]\n" "${msg}"
-		nsuccess=$((nsuccess+1))
-	else
-		ret=1
-		nfail=$((nfail+1))
-		printf "    TEST: %-60s  [FAIL]\n" "${msg}"
-		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
-		echo
-			echo "hit enter to continue, 'q' to quit"
-			read a
-			[ "$a" = "q" ] && exit 1
-		fi
-	fi
-
-	if [ "${PAUSE}" = "yes" ]; then
-		echo
-		echo "hit enter to continue, 'q' to quit"
-		read a
-		[ "$a" = "q" ] && exit 1
-	fi
-}
-
-setup()
-{
-	set -e
-	ip netns add ns1
-	ip netns set ns1 auto
-	$IP link set dev lo up
-	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=1
-	ip netns exec ns1 sysctl -qw net.ipv6.conf.all.forwarding=1
-
-	$IP link add dummy0 type dummy
-	$IP link set dev dummy0 up
-	$IP address add 198.51.100.1/24 dev dummy0
-	$IP -6 address add 2001:db8:1::1/64 dev dummy0
-	set +e
-
-}
-
-cleanup()
-{
-	$IP link del dev dummy0 &> /dev/null
-	ip netns del ns1
-	ip netns del ns2 &> /dev/null
-}
-
-get_linklocal()
-{
-	local dev=$1
-	local addr
-
-	addr=$($IP -6 -br addr show dev ${dev} | \
-	awk '{
-		for (i = 3; i <= NF; ++i) {
-			if ($i ~ /^fe80/)
-				print $i
-		}
-	}'
-	)
-	addr=${addr/\/*}
-
-	[ -z "$addr" ] && return 1
-
-	echo $addr
-
-	return 0
-}
-
-fib_unreg_unicast_test()
-{
-	echo
-	echo "Single path route test"
-
-	setup
-
-	echo "    Start point"
-	$IP route get fibmatch 198.51.100.2 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:1::2 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	set -e
-	$IP link del dev dummy0
-	set +e
-
-	echo "    Nexthop device deleted"
-	$IP route get fibmatch 198.51.100.2 &> /dev/null
-	log_test $? 2 "IPv4 fibmatch - no route"
-	$IP -6 route get fibmatch 2001:db8:1::2 &> /dev/null
-	log_test $? 2 "IPv6 fibmatch - no route"
-
-	cleanup
-}
-
-fib_unreg_multipath_test()
-{
-
-	echo
-	echo "Multipath route test"
-
-	setup
-
-	set -e
-	$IP link add dummy1 type dummy
-	$IP link set dev dummy1 up
-	$IP address add 192.0.2.1/24 dev dummy1
-	$IP -6 address add 2001:db8:2::1/64 dev dummy1
-
-	$IP route add 203.0.113.0/24 \
-		nexthop via 198.51.100.2 dev dummy0 \
-		nexthop via 192.0.2.2 dev dummy1
-	$IP -6 route add 2001:db8:3::/64 \
-		nexthop via 2001:db8:1::2 dev dummy0 \
-		nexthop via 2001:db8:2::2 dev dummy1
-	set +e
-
-	echo "    Start point"
-	$IP route get fibmatch 203.0.113.1 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:3::1 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	set -e
-	$IP link del dev dummy0
-	set +e
-
-	echo "    One nexthop device deleted"
-	$IP route get fibmatch 203.0.113.1 &> /dev/null
-	log_test $? 2 "IPv4 - multipath route removed on delete"
-
-	$IP -6 route get fibmatch 2001:db8:3::1 &> /dev/null
-	# In IPv6 we do not flush the entire multipath route.
-	log_test $? 0 "IPv6 - multipath down to single path"
-
-	set -e
-	$IP link del dev dummy1
-	set +e
-
-	echo "    Second nexthop device deleted"
-	$IP -6 route get fibmatch 2001:db8:3::1 &> /dev/null
-	log_test $? 2 "IPv6 - no route"
-
-	cleanup
-}
-
-fib_unreg_test()
-{
-	fib_unreg_unicast_test
-	fib_unreg_multipath_test
-}
-
-fib_down_unicast_test()
-{
-	echo
-	echo "Single path, admin down"
-
-	setup
-
-	echo "    Start point"
-	$IP route get fibmatch 198.51.100.2 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:1::2 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	set -e
-	$IP link set dev dummy0 down
-	set +e
-
-	echo "    Route deleted on down"
-	$IP route get fibmatch 198.51.100.2 &> /dev/null
-	log_test $? 2 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:1::2 &> /dev/null
-	log_test $? 2 "IPv6 fibmatch"
-
-	cleanup
-}
-
-fib_down_multipath_test_do()
-{
-	local down_dev=$1
-	local up_dev=$2
-
-	$IP route get fibmatch 203.0.113.1 \
-		oif $down_dev &> /dev/null
-	log_test $? 2 "IPv4 fibmatch on down device"
-	$IP -6 route get fibmatch 2001:db8:3::1 \
-		oif $down_dev &> /dev/null
-	log_test $? 2 "IPv6 fibmatch on down device"
-
-	$IP route get fibmatch 203.0.113.1 \
-		oif $up_dev &> /dev/null
-	log_test $? 0 "IPv4 fibmatch on up device"
-	$IP -6 route get fibmatch 2001:db8:3::1 \
-		oif $up_dev &> /dev/null
-	log_test $? 0 "IPv6 fibmatch on up device"
-
-	$IP route get fibmatch 203.0.113.1 | \
-		grep $down_dev | grep -q "dead linkdown"
-	log_test $? 0 "IPv4 flags on down device"
-	$IP -6 route get fibmatch 2001:db8:3::1 | \
-		grep $down_dev | grep -q "dead linkdown"
-	log_test $? 0 "IPv6 flags on down device"
-
-	$IP route get fibmatch 203.0.113.1 | \
-		grep $up_dev | grep -q "dead linkdown"
-	log_test $? 1 "IPv4 flags on up device"
-	$IP -6 route get fibmatch 2001:db8:3::1 | \
-		grep $up_dev | grep -q "dead linkdown"
-	log_test $? 1 "IPv6 flags on up device"
-}
-
-fib_down_multipath_test()
-{
-	echo
-	echo "Admin down multipath"
-
-	setup
-
-	set -e
-	$IP link add dummy1 type dummy
-	$IP link set dev dummy1 up
-
-	$IP address add 192.0.2.1/24 dev dummy1
-	$IP -6 address add 2001:db8:2::1/64 dev dummy1
-
-	$IP route add 203.0.113.0/24 \
-		nexthop via 198.51.100.2 dev dummy0 \
-		nexthop via 192.0.2.2 dev dummy1
-	$IP -6 route add 2001:db8:3::/64 \
-		nexthop via 2001:db8:1::2 dev dummy0 \
-		nexthop via 2001:db8:2::2 dev dummy1
-	set +e
-
-	echo "    Verify start point"
-	$IP route get fibmatch 203.0.113.1 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-
-	$IP -6 route get fibmatch 2001:db8:3::1 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	set -e
-	$IP link set dev dummy0 down
-	set +e
-
-	echo "    One device down, one up"
-	fib_down_multipath_test_do "dummy0" "dummy1"
-
-	set -e
-	$IP link set dev dummy0 up
-	$IP link set dev dummy1 down
-	set +e
-
-	echo "    Other device down and up"
-	fib_down_multipath_test_do "dummy1" "dummy0"
-
-	set -e
-	$IP link set dev dummy0 down
-	set +e
-
-	echo "    Both devices down"
-	$IP route get fibmatch 203.0.113.1 &> /dev/null
-	log_test $? 2 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:3::1 &> /dev/null
-	log_test $? 2 "IPv6 fibmatch"
-
-	$IP link del dev dummy1
-	cleanup
-}
-
-fib_down_test()
-{
-	fib_down_unicast_test
-	fib_down_multipath_test
-}
-
-# Local routes should not be affected when carrier changes.
-fib_carrier_local_test()
-{
-	echo
-	echo "Local carrier tests - single path"
-
-	setup
-
-	set -e
-	$IP link set dev dummy0 carrier on
-	set +e
-
-	echo "    Start point"
-	$IP route get fibmatch 198.51.100.1 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:1::1 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	$IP route get fibmatch 198.51.100.1 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv4 - no linkdown flag"
-	$IP -6 route get fibmatch 2001:db8:1::1 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv6 - no linkdown flag"
-
-	set -e
-	$IP link set dev dummy0 carrier off
-	sleep 1
-	set +e
-
-	echo "    Carrier off on nexthop"
-	$IP route get fibmatch 198.51.100.1 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:1::1 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	$IP route get fibmatch 198.51.100.1 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv4 - linkdown flag set"
-	$IP -6 route get fibmatch 2001:db8:1::1 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv6 - linkdown flag set"
-
-	set -e
-	$IP address add 192.0.2.1/24 dev dummy0
-	$IP -6 address add 2001:db8:2::1/64 dev dummy0
-	set +e
-
-	echo "    Route to local address with carrier down"
-	$IP route get fibmatch 192.0.2.1 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:2::1 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	$IP route get fibmatch 192.0.2.1 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv4 linkdown flag set"
-	$IP -6 route get fibmatch 2001:db8:2::1 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv6 linkdown flag set"
-
-	cleanup
-}
-
-fib_carrier_unicast_test()
-{
-	ret=0
-
-	echo
-	echo "Single path route carrier test"
-
-	setup
-
-	set -e
-	$IP link set dev dummy0 carrier on
-	set +e
-
-	echo "    Start point"
-	$IP route get fibmatch 198.51.100.2 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:1::2 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	$IP route get fibmatch 198.51.100.2 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv4 no linkdown flag"
-	$IP -6 route get fibmatch 2001:db8:1::2 | \
-		grep -q "linkdown"
-	log_test $? 1 "IPv6 no linkdown flag"
-
-	set -e
-	$IP link set dev dummy0 carrier off
-	sleep 1
-	set +e
-
-	echo "    Carrier down"
-	$IP route get fibmatch 198.51.100.2 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:1::2 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	$IP route get fibmatch 198.51.100.2 | \
-		grep -q "linkdown"
-	log_test $? 0 "IPv4 linkdown flag set"
-	$IP -6 route get fibmatch 2001:db8:1::2 | \
-		grep -q "linkdown"
-	log_test $? 0 "IPv6 linkdown flag set"
-
-	set -e
-	$IP address add 192.0.2.1/24 dev dummy0
-	$IP -6 address add 2001:db8:2::1/64 dev dummy0
-	set +e
-
-	echo "    Second address added with carrier down"
-	$IP route get fibmatch 192.0.2.2 &> /dev/null
-	log_test $? 0 "IPv4 fibmatch"
-	$IP -6 route get fibmatch 2001:db8:2::2 &> /dev/null
-	log_test $? 0 "IPv6 fibmatch"
-
-	$IP route get fibmatch 192.0.2.2 | \
-		grep -q "linkdown"
-	log_test $? 0 "IPv4 linkdown flag set"
-	$IP -6 route get fibmatch 2001:db8:2::2 | \
-		grep -q "linkdown"
-	log_test $? 0 "IPv6 linkdown flag set"
-
-	cleanup
-}
-
-fib_carrier_test()
-{
-	fib_carrier_local_test
-	fib_carrier_unicast_test
-}
-
-fib_rp_filter_test()
-{
-	echo
-	echo "IPv4 rp_filter tests"
-
-	setup
-
-	set -e
-	ip netns add ns2
-	ip netns set ns2 auto
-
-	ip -netns ns2 link set dev lo up
-
-	$IP link add name veth1 type veth peer name veth2
-	$IP link set dev veth2 netns ns2
-	$IP address add 192.0.2.1/24 dev veth1
-	ip -netns ns2 address add 192.0.2.1/24 dev veth2
-	$IP link set dev veth1 up
-	ip -netns ns2 link set dev veth2 up
-
-	$IP link set dev lo address 52:54:00:6a:c7:5e
-	$IP link set dev veth1 address 52:54:00:6a:c7:5e
-	ip -netns ns2 link set dev lo address 52:54:00:6a:c7:5e
-	ip -netns ns2 link set dev veth2 address 52:54:00:6a:c7:5e
-
-	# 1. (ns2) redirect lo's egress to veth2's egress
-	ip netns exec ns2 tc qdisc add dev lo parent root handle 1: fq_codel
-	ip netns exec ns2 tc filter add dev lo parent 1: protocol arp basic \
-		action mirred egress redirect dev veth2
-	ip netns exec ns2 tc filter add dev lo parent 1: protocol ip basic \
-		action mirred egress redirect dev veth2
-
-	# 2. (ns1) redirect veth1's ingress to lo's ingress
-	$NS_EXEC tc qdisc add dev veth1 ingress
-	$NS_EXEC tc filter add dev veth1 ingress protocol arp basic \
-		action mirred ingress redirect dev lo
-	$NS_EXEC tc filter add dev veth1 ingress protocol ip basic \
-		action mirred ingress redirect dev lo
-
-	# 3. (ns1) redirect lo's egress to veth1's egress
-	$NS_EXEC tc qdisc add dev lo parent root handle 1: fq_codel
-	$NS_EXEC tc filter add dev lo parent 1: protocol arp basic \
-		action mirred egress redirect dev veth1
-	$NS_EXEC tc filter add dev lo parent 1: protocol ip basic \
-		action mirred egress redirect dev veth1
-
-	# 4. (ns2) redirect veth2's ingress to lo's ingress
-	ip netns exec ns2 tc qdisc add dev veth2 ingress
-	ip netns exec ns2 tc filter add dev veth2 ingress protocol arp basic \
-		action mirred ingress redirect dev lo
-	ip netns exec ns2 tc filter add dev veth2 ingress protocol ip basic \
-		action mirred ingress redirect dev lo
-
-	$NS_EXEC sysctl -qw net.ipv4.conf.all.rp_filter=1
-	$NS_EXEC sysctl -qw net.ipv4.conf.all.accept_local=1
-	$NS_EXEC sysctl -qw net.ipv4.conf.all.route_localnet=1
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.rp_filter=1
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.accept_local=1
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.route_localnet=1
-	set +e
-
-	run_cmd "ip netns exec ns2 ping -w1 -c1 192.0.2.1"
-	log_test $? 0 "rp_filter passes local packets"
-
-	run_cmd "ip netns exec ns2 ping -w1 -c1 127.0.0.1"
-	log_test $? 0 "rp_filter passes loopback packets"
-
-	cleanup
-}
-
-################################################################################
-# Tests on nexthop spec
-
-# run 'ip route add' with given spec
-add_rt()
-{
-	local desc="$1"
-	local erc=$2
-	local vrf=$3
-	local pfx=$4
-	local gw=$5
-	local dev=$6
-	local cmd out rc
-
-	[ "$vrf" = "-" ] && vrf="default"
-	[ -n "$gw" ] && gw="via $gw"
-	[ -n "$dev" ] && dev="dev $dev"
-
-	cmd="$IP route add vrf $vrf $pfx $gw $dev"
-	if [ "$VERBOSE" = "1" ]; then
-		printf "\n    COMMAND: $cmd\n"
-	fi
-
-	out=$(eval $cmd 2>&1)
-	rc=$?
-	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
-		echo "    $out"
-	fi
-	log_test $rc $erc "$desc"
-}
-
-fib4_nexthop()
-{
-	echo
-	echo "IPv4 nexthop tests"
-
-	echo "<<< write me >>>"
-}
-
-fib6_nexthop()
-{
-	local lldummy=$(get_linklocal dummy0)
-	local llv1=$(get_linklocal dummy0)
-
-	if [ -z "$lldummy" ]; then
-		echo "Failed to get linklocal address for dummy0"
-		return 1
-	fi
-	if [ -z "$llv1" ]; then
-		echo "Failed to get linklocal address for veth1"
-		return 1
-	fi
-
-	echo
-	echo "IPv6 nexthop tests"
-
-	add_rt "Directly connected nexthop, unicast address" 0 \
-		- 2001:db8:101::/64 2001:db8:1::2
-	add_rt "Directly connected nexthop, unicast address with device" 0 \
-		- 2001:db8:102::/64 2001:db8:1::2 "dummy0"
-	add_rt "Gateway is linklocal address" 0 \
-		- 2001:db8:103::1/64 $llv1 "veth0"
-
-	# fails because LL address requires a device
-	add_rt "Gateway is linklocal address, no device" 2 \
-		- 2001:db8:104::1/64 $llv1
-
-	# local address can not be a gateway
-	add_rt "Gateway can not be local unicast address" 2 \
-		- 2001:db8:105::/64 2001:db8:1::1
-	add_rt "Gateway can not be local unicast address, with device" 2 \
-		- 2001:db8:106::/64 2001:db8:1::1 "dummy0"
-	add_rt "Gateway can not be a local linklocal address" 2 \
-		- 2001:db8:107::1/64 $lldummy "dummy0"
-
-	# VRF tests
-	add_rt "Gateway can be local address in a VRF" 0 \
-		- 2001:db8:108::/64 2001:db8:51::2
-	add_rt "Gateway can be local address in a VRF, with device" 0 \
-		- 2001:db8:109::/64 2001:db8:51::2 "veth0"
-	add_rt "Gateway can be local linklocal address in a VRF" 0 \
-		- 2001:db8:110::1/64 $llv1 "veth0"
-
-	add_rt "Redirect to VRF lookup" 0 \
-		- 2001:db8:111::/64 "" "red"
-
-	add_rt "VRF route, gateway can be local address in default VRF" 0 \
-		red 2001:db8:112::/64 2001:db8:51::1
-
-	# local address in same VRF fails
-	add_rt "VRF route, gateway can not be a local address" 2 \
-		red 2001:db8:113::1/64 2001:db8:2::1
-	add_rt "VRF route, gateway can not be a local addr with device" 2 \
-		red 2001:db8:114::1/64 2001:db8:2::1 "dummy1"
-}
-
-# Default VRF:
-#   dummy0 - 198.51.100.1/24 2001:db8:1::1/64
-#   veth0  - 192.0.2.1/24    2001:db8:51::1/64
-#
-# VRF red:
-#   dummy1 - 192.168.2.1/24 2001:db8:2::1/64
-#   veth1  - 192.0.2.2/24   2001:db8:51::2/64
-#
-#  [ dummy0   veth0 ]--[ veth1   dummy1 ]
-
-fib_nexthop_test()
-{
-	setup
-
-	set -e
-
-	$IP -4 rule add pref 32765 table local
-	$IP -4 rule del pref 0
-	$IP -6 rule add pref 32765 table local
-	$IP -6 rule del pref 0
-
-	$IP link add red type vrf table 1
-	$IP link set red up
-	$IP -4 route add vrf red unreachable default metric 4278198272
-	$IP -6 route add vrf red unreachable default metric 4278198272
-
-	$IP link add veth0 type veth peer name veth1
-	$IP link set dev veth0 up
-	$IP address add 192.0.2.1/24 dev veth0
-	$IP -6 address add 2001:db8:51::1/64 dev veth0
-
-	$IP link set dev veth1 vrf red up
-	$IP address add 192.0.2.2/24 dev veth1
-	$IP -6 address add 2001:db8:51::2/64 dev veth1
-
-	$IP link add dummy1 type dummy
-	$IP link set dev dummy1 vrf red up
-	$IP address add 192.168.2.1/24 dev dummy1
-	$IP -6 address add 2001:db8:2::1/64 dev dummy1
-	set +e
-
-	sleep 1
-	fib4_nexthop
-	fib6_nexthop
-
-	(
-	$IP link del dev dummy1
-	$IP link del veth0
-	$IP link del red
-	) 2>/dev/null
-	cleanup
-}
-
-fib_suppress_test()
-{
-	echo
-	echo "FIB rule with suppress_prefixlength"
-	setup
-
-	$IP link add dummy1 type dummy
-	$IP link set dummy1 up
-	$IP -6 route add default dev dummy1
-	$IP -6 rule add table main suppress_prefixlength 0
-	ping -f -c 1000 -W 1 1234::1 >/dev/null 2>&1
-	$IP -6 rule del table main suppress_prefixlength 0
-	$IP link del dummy1
-
-	# If we got here without crashing, we're good.
-	log_test 0 0 "FIB rule suppress test"
-
-	cleanup
-}
-
-################################################################################
-# Tests on route add and replace
-
-run_cmd()
-{
-	local cmd="$1"
-	local out
-	local stderr="2>/dev/null"
-
-	if [ "$VERBOSE" = "1" ]; then
-		printf "    COMMAND: $cmd\n"
-		stderr=
-	fi
-
-	out=$(eval $cmd $stderr)
-	rc=$?
-	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
-		echo "    $out"
-	fi
-
-	[ "$VERBOSE" = "1" ] && echo
-
-	return $rc
-}
-
-check_expected()
-{
-	local out="$1"
-	local expected="$2"
-	local rc=0
-
-	[ "${out}" = "${expected}" ] && return 0
-
-	if [ -z "${out}" ]; then
-		if [ "$VERBOSE" = "1" ]; then
-			printf "\nNo route entry found\n"
-			printf "Expected:\n"
-			printf "    ${expected}\n"
-		fi
-		return 1
-	fi
-
-	# tricky way to convert output to 1-line without ip's
-	# messy '\'; this drops all extra white space
-	out=$(echo ${out})
-	if [ "${out}" != "${expected}" ]; then
-		rc=1
-		if [ "${VERBOSE}" = "1" ]; then
-			printf "    Unexpected route entry. Have:\n"
-			printf "        ${out}\n"
-			printf "    Expected:\n"
-			printf "        ${expected}\n\n"
-		fi
-	fi
-
-	return $rc
-}
-
-# add route for a prefix, flushing any existing routes first
-# expected to be the first step of a test
-add_route6()
-{
-	local pfx="$1"
-	local nh="$2"
-	local out
-
-	if [ "$VERBOSE" = "1" ]; then
-		echo
-		echo "    ##################################################"
-		echo
-	fi
-
-	run_cmd "$IP -6 ro flush ${pfx}"
-	[ $? -ne 0 ] && exit 1
-
-	out=$($IP -6 ro ls match ${pfx})
-	if [ -n "$out" ]; then
-		echo "Failed to flush routes for prefix used for tests."
-		exit 1
-	fi
-
-	run_cmd "$IP -6 ro add ${pfx} ${nh}"
-	if [ $? -ne 0 ]; then
-		echo "Failed to add initial route for test."
-		exit 1
-	fi
-}
-
-# add initial route - used in replace route tests
-add_initial_route6()
-{
-	add_route6 "2001:db8:104::/64" "$1"
-}
-
-check_route6()
-{
-	local pfx
-	local expected="$1"
-	local out
-	local rc=0
-
-	set -- $expected
-	pfx=$1
-
-	out=$($IP -6 ro ls match ${pfx} | sed -e 's/ pref medium//')
-	check_expected "${out}" "${expected}"
-}
-
-route_cleanup()
-{
-	$IP li del red 2>/dev/null
-	$IP li del dummy1 2>/dev/null
-	$IP li del veth1 2>/dev/null
-	$IP li del veth3 2>/dev/null
-
-	cleanup &> /dev/null
-}
-
-route_setup()
-{
-	route_cleanup
-	setup
-
-	[ "${VERBOSE}" = "1" ] && set -x
-	set -e
-
-	ip netns add ns2
-	ip netns set ns2 auto
-	ip -netns ns2 link set dev lo up
-	ip netns exec ns2 sysctl -qw net.ipv4.ip_forward=1
-	ip netns exec ns2 sysctl -qw net.ipv6.conf.all.forwarding=1
-
-	$IP li add veth1 type veth peer name veth2
-	$IP li add veth3 type veth peer name veth4
-
-	$IP li set veth1 up
-	$IP li set veth3 up
-	$IP li set veth2 netns ns2 up
-	$IP li set veth4 netns ns2 up
-	ip -netns ns2 li add dummy1 type dummy
-	ip -netns ns2 li set dummy1 up
-
-	$IP -6 addr add 2001:db8:101::1/64 dev veth1 nodad
-	$IP -6 addr add 2001:db8:103::1/64 dev veth3 nodad
-	$IP addr add 172.16.101.1/24 dev veth1
-	$IP addr add 172.16.103.1/24 dev veth3
-
-	ip -netns ns2 -6 addr add 2001:db8:101::2/64 dev veth2 nodad
-	ip -netns ns2 -6 addr add 2001:db8:103::2/64 dev veth4 nodad
-	ip -netns ns2 -6 addr add 2001:db8:104::1/64 dev dummy1 nodad
-
-	ip -netns ns2 addr add 172.16.101.2/24 dev veth2
-	ip -netns ns2 addr add 172.16.103.2/24 dev veth4
-	ip -netns ns2 addr add 172.16.104.1/24 dev dummy1
-
-	set +e
-}
-
-# assumption is that basic add of a single path route works
-# otherwise just adding an address on an interface is broken
-ipv6_rt_add()
-{
-	local rc
-
-	echo
-	echo "IPv6 route add / append tests"
-
-	# route add same prefix - fails with EEXISTS b/c ip adds NLM_F_EXCL
-	add_route6 "2001:db8:104::/64" "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro add 2001:db8:104::/64 via 2001:db8:103::2"
-	log_test $? 2 "Attempt to add duplicate route - gw"
-
-	# route add same prefix - fails with EEXISTS b/c ip adds NLM_F_EXCL
-	add_route6 "2001:db8:104::/64" "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro add 2001:db8:104::/64 dev veth3"
-	log_test $? 2 "Attempt to add duplicate route - dev only"
-
-	# route add same prefix - fails with EEXISTS b/c ip adds NLM_F_EXCL
-	add_route6 "2001:db8:104::/64" "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro add unreachable 2001:db8:104::/64"
-	log_test $? 2 "Attempt to add duplicate route - reject route"
-
-	# route append with same prefix adds a new route
-	# - iproute2 sets NLM_F_CREATE | NLM_F_APPEND
-	add_route6 "2001:db8:104::/64" "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro append 2001:db8:104::/64 via 2001:db8:103::2"
-	check_route6 "2001:db8:104::/64 metric 1024 nexthop via 2001:db8:101::2 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-	log_test $? 0 "Append nexthop to existing route - gw"
-
-	# insert mpath directly
-	add_route6 "2001:db8:104::/64" "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	check_route6  "2001:db8:104::/64 metric 1024 nexthop via 2001:db8:101::2 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-	log_test $? 0 "Add multipath route"
-
-	add_route6 "2001:db8:104::/64" "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro add 2001:db8:104::/64 nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	log_test $? 2 "Attempt to add duplicate multipath route"
-
-	# insert of a second route without append but different metric
-	add_route6 "2001:db8:104::/64" "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro add 2001:db8:104::/64 via 2001:db8:103::2 metric 512"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		run_cmd "$IP -6 ro add 2001:db8:104::/64 via 2001:db8:103::3 metric 256"
-		rc=$?
-	fi
-	log_test $rc 0 "Route add with different metrics"
-
-	run_cmd "$IP -6 ro del 2001:db8:104::/64 metric 512"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6 "2001:db8:104::/64 via 2001:db8:103::3 dev veth3 metric 256 2001:db8:104::/64 via 2001:db8:101::2 dev veth1 metric 1024"
-		rc=$?
-	fi
-	log_test $rc 0 "Route delete with metric"
-}
-
-ipv6_rt_replace_single()
-{
-	# single path with single path
-	#
-	add_initial_route6 "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 via 2001:db8:103::2"
-	check_route6 "2001:db8:104::/64 via 2001:db8:103::2 dev veth3 metric 1024"
-	log_test $? 0 "Single path with single path"
-
-	# single path with multipath
-	#
-	add_initial_route6 "nexthop via 2001:db8:101::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:101::3 nexthop via 2001:db8:103::2"
-	check_route6 "2001:db8:104::/64 metric 1024 nexthop via 2001:db8:101::3 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-	log_test $? 0 "Single path with multipath"
-
-	# single path with single path using MULTIPATH attribute
-	#
-	add_initial_route6 "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:103::2"
-	check_route6 "2001:db8:104::/64 via 2001:db8:103::2 dev veth3 metric 1024"
-	log_test $? 0 "Single path with single path via multipath attribute"
-
-	# route replace fails - invalid nexthop
-	add_initial_route6 "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 via 2001:db8:104::2"
-	if [ $? -eq 0 ]; then
-		# previous command is expected to fail so if it returns 0
-		# that means the test failed.
-		log_test 0 1 "Invalid nexthop"
-	else
-		check_route6 "2001:db8:104::/64 via 2001:db8:101::2 dev veth1 metric 1024"
-		log_test $? 0 "Invalid nexthop"
-	fi
-
-	# replace non-existent route
-	# - note use of change versus replace since ip adds NLM_F_CREATE
-	#   for replace
-	add_initial_route6 "via 2001:db8:101::2"
-	run_cmd "$IP -6 ro change 2001:db8:105::/64 via 2001:db8:101::2"
-	log_test $? 2 "Single path - replace of non-existent route"
-}
-
-ipv6_rt_replace_mpath()
-{
-	# multipath with multipath
-	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:101::3 nexthop via 2001:db8:103::3"
-	check_route6  "2001:db8:104::/64 metric 1024 nexthop via 2001:db8:101::3 dev veth1 weight 1 nexthop via 2001:db8:103::3 dev veth3 weight 1"
-	log_test $? 0 "Multipath with multipath"
-
-	# multipath with single
-	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 via 2001:db8:101::3"
-	check_route6  "2001:db8:104::/64 via 2001:db8:101::3 dev veth1 metric 1024"
-	log_test $? 0 "Multipath with single path"
-
-	# multipath with single
-	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:101::3"
-	check_route6 "2001:db8:104::/64 via 2001:db8:101::3 dev veth1 metric 1024"
-	log_test $? 0 "Multipath with single path via multipath attribute"
-
-	# multipath with dev-only
-	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 dev veth1"
-	check_route6 "2001:db8:104::/64 dev veth1 metric 1024"
-	log_test $? 0 "Multipath with dev-only"
-
-	# route replace fails - invalid nexthop 1
-	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:111::3 nexthop via 2001:db8:103::3"
-	check_route6  "2001:db8:104::/64 metric 1024 nexthop via 2001:db8:101::2 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-	log_test $? 0 "Multipath - invalid first nexthop"
-
-	# route replace fails - invalid nexthop 2
-	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro replace 2001:db8:104::/64 nexthop via 2001:db8:101::3 nexthop via 2001:db8:113::3"
-	check_route6  "2001:db8:104::/64 metric 1024 nexthop via 2001:db8:101::2 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-	log_test $? 0 "Multipath - invalid second nexthop"
-
-	# multipath non-existent route
-	add_initial_route6 "nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	run_cmd "$IP -6 ro change 2001:db8:105::/64 nexthop via 2001:db8:101::3 nexthop via 2001:db8:103::3"
-	log_test $? 2 "Multipath - replace of non-existent route"
-}
-
-ipv6_rt_replace()
-{
-	echo
-	echo "IPv6 route replace tests"
-
-	ipv6_rt_replace_single
-	ipv6_rt_replace_mpath
-}
-
-ipv6_route_test()
-{
-	route_setup
-
-	ipv6_rt_add
-	ipv6_rt_replace
-
-	route_cleanup
-}
-
-ip_addr_metric_check()
-{
-	ip addr help 2>&1 | grep -q metric
-	if [ $? -ne 0 ]; then
-		echo "iproute2 command does not support metric for addresses. Skipping test"
-		return 1
-	fi
-
-	return 0
-}
-
-ipv6_addr_metric_test()
-{
-	local rc
-
-	echo
-	echo "IPv6 prefix route tests"
-
-	ip_addr_metric_check || return 1
-
-	setup
-
-	set -e
-	$IP li add dummy1 type dummy
-	$IP li add dummy2 type dummy
-	$IP li set dummy1 up
-	$IP li set dummy2 up
-
-	# default entry is metric 256
-	run_cmd "$IP -6 addr add dev dummy1 2001:db8:104::1/64"
-	run_cmd "$IP -6 addr add dev dummy2 2001:db8:104::2/64"
-	set +e
-
-	check_route6 "2001:db8:104::/64 dev dummy1 proto kernel metric 256 2001:db8:104::/64 dev dummy2 proto kernel metric 256"
-	log_test $? 0 "Default metric"
-
-	set -e
-	run_cmd "$IP -6 addr flush dev dummy1"
-	run_cmd "$IP -6 addr add dev dummy1 2001:db8:104::1/64 metric 257"
-	set +e
-
-	check_route6 "2001:db8:104::/64 dev dummy2 proto kernel metric 256 2001:db8:104::/64 dev dummy1 proto kernel metric 257"
-	log_test $? 0 "User specified metric on first device"
-
-	set -e
-	run_cmd "$IP -6 addr flush dev dummy2"
-	run_cmd "$IP -6 addr add dev dummy2 2001:db8:104::2/64 metric 258"
-	set +e
-
-	check_route6 "2001:db8:104::/64 dev dummy1 proto kernel metric 257 2001:db8:104::/64 dev dummy2 proto kernel metric 258"
-	log_test $? 0 "User specified metric on second device"
-
-	run_cmd "$IP -6 addr del dev dummy1 2001:db8:104::1/64 metric 257"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6 "2001:db8:104::/64 dev dummy2 proto kernel metric 258"
-		rc=$?
-	fi
-	log_test $rc 0 "Delete of address on first device"
-
-	run_cmd "$IP -6 addr change dev dummy2 2001:db8:104::2/64 metric 259"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6 "2001:db8:104::/64 dev dummy2 proto kernel metric 259"
-		rc=$?
-	fi
-	log_test $rc 0 "Modify metric of address"
-
-	# verify prefix route removed on down
-	run_cmd "ip netns exec ns1 sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1"
-	run_cmd "$IP li set dev dummy2 down"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		out=$($IP -6 ro ls match 2001:db8:104::/64)
-		check_expected "${out}" ""
-		rc=$?
-	fi
-	log_test $rc 0 "Prefix route removed on link down"
-
-	# verify prefix route re-inserted with assigned metric
-	run_cmd "$IP li set dev dummy2 up"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6 "2001:db8:104::/64 dev dummy2 proto kernel metric 259"
-		rc=$?
-	fi
-	log_test $rc 0 "Prefix route with metric on link up"
-
-	# verify peer metric added correctly
-	set -e
-	run_cmd "$IP -6 addr flush dev dummy2"
-	run_cmd "$IP -6 addr add dev dummy2 2001:db8:104::1 peer 2001:db8:104::2 metric 260"
-	set +e
-
-	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 260"
-	log_test $? 0 "Set metric with peer route on local side"
-	check_route6 "2001:db8:104::2 dev dummy2 proto kernel metric 260"
-	log_test $? 0 "Set metric with peer route on peer side"
-
-	set -e
-	run_cmd "$IP -6 addr change dev dummy2 2001:db8:104::1 peer 2001:db8:104::3 metric 261"
-	set +e
-
-	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 261"
-	log_test $? 0 "Modify metric and peer address on local side"
-	check_route6 "2001:db8:104::3 dev dummy2 proto kernel metric 261"
-	log_test $? 0 "Modify metric and peer address on peer side"
-
-	$IP li del dummy1
-	$IP li del dummy2
-	cleanup
-}
-
-ipv6_route_metrics_test()
-{
-	local rc
-
-	echo
-	echo "IPv6 routes with metrics"
-
-	route_setup
-
-	#
-	# single path with metrics
-	#
-	run_cmd "$IP -6 ro add 2001:db8:111::/64 via 2001:db8:101::2 mtu 1400"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6  "2001:db8:111::/64 via 2001:db8:101::2 dev veth1 metric 1024 mtu 1400"
-		rc=$?
-	fi
-	log_test $rc 0 "Single path route with mtu metric"
-
-
-	#
-	# multipath via separate routes with metrics
-	#
-	run_cmd "$IP -6 ro add 2001:db8:112::/64 via 2001:db8:101::2 mtu 1400"
-	run_cmd "$IP -6 ro append 2001:db8:112::/64 via 2001:db8:103::2"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6 "2001:db8:112::/64 metric 1024 mtu 1400 nexthop via 2001:db8:101::2 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-		rc=$?
-	fi
-	log_test $rc 0 "Multipath route via 2 single routes with mtu metric on first"
-
-	# second route is coalesced to first to make a multipath route.
-	# MTU of the second path is hidden from display!
-	run_cmd "$IP -6 ro add 2001:db8:113::/64 via 2001:db8:101::2"
-	run_cmd "$IP -6 ro append 2001:db8:113::/64 via 2001:db8:103::2 mtu 1400"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6 "2001:db8:113::/64 metric 1024 nexthop via 2001:db8:101::2 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-		rc=$?
-	fi
-	log_test $rc 0 "Multipath route via 2 single routes with mtu metric on 2nd"
-
-	run_cmd "$IP -6 ro del 2001:db8:113::/64 via 2001:db8:101::2"
-	if [ $? -eq 0 ]; then
-		check_route6 "2001:db8:113::/64 via 2001:db8:103::2 dev veth3 metric 1024 mtu 1400"
-		log_test $? 0 "    MTU of second leg"
-	fi
-
-	#
-	# multipath with metrics
-	#
-	run_cmd "$IP -6 ro add 2001:db8:115::/64 mtu 1400 nexthop via 2001:db8:101::2 nexthop via 2001:db8:103::2"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route6  "2001:db8:115::/64 metric 1024 mtu 1400 nexthop via 2001:db8:101::2 dev veth1 weight 1 nexthop via 2001:db8:103::2 dev veth3 weight 1"
-		rc=$?
-	fi
-	log_test $rc 0 "Multipath route with mtu metric"
-
-	$IP -6 ro add 2001:db8:104::/64 via 2001:db8:101::2 mtu 1300
-	run_cmd "ip netns exec ns1 ${ping6} -w1 -c1 -s 1500 2001:db8:104::1"
-	log_test $? 0 "Using route with mtu metric"
-
-	run_cmd "$IP -6 ro add 2001:db8:114::/64 via  2001:db8:101::2  congctl lock foo"
-	log_test $? 2 "Invalid metric (fails metric_convert)"
-
-	route_cleanup
-}
-
-# add route for a prefix, flushing any existing routes first
-# expected to be the first step of a test
-add_route()
-{
-	local pfx="$1"
-	local nh="$2"
-	local out
-
-	if [ "$VERBOSE" = "1" ]; then
-		echo
-		echo "    ##################################################"
-		echo
-	fi
-
-	run_cmd "$IP ro flush ${pfx}"
-	[ $? -ne 0 ] && exit 1
-
-	out=$($IP ro ls match ${pfx})
-	if [ -n "$out" ]; then
-		echo "Failed to flush routes for prefix used for tests."
-		exit 1
-	fi
-
-	run_cmd "$IP ro add ${pfx} ${nh}"
-	if [ $? -ne 0 ]; then
-		echo "Failed to add initial route for test."
-		exit 1
-	fi
-}
-
-# add initial route - used in replace route tests
-add_initial_route()
-{
-	add_route "172.16.104.0/24" "$1"
-}
-
-check_route()
-{
-	local pfx
-	local expected="$1"
-	local out
-
-	set -- $expected
-	pfx=$1
-	[ "${pfx}" = "unreachable" ] && pfx=$2
-
-	out=$($IP ro ls match ${pfx})
-	check_expected "${out}" "${expected}"
-}
-
-# assumption is that basic add of a single path route works
-# otherwise just adding an address on an interface is broken
-ipv4_rt_add()
-{
-	local rc
-
-	echo
-	echo "IPv4 route add / append tests"
-
-	# route add same prefix - fails with EEXISTS b/c ip adds NLM_F_EXCL
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro add 172.16.104.0/24 via 172.16.103.2"
-	log_test $? 2 "Attempt to add duplicate route - gw"
-
-	# route add same prefix - fails with EEXISTS b/c ip adds NLM_F_EXCL
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro add 172.16.104.0/24 dev veth3"
-	log_test $? 2 "Attempt to add duplicate route - dev only"
-
-	# route add same prefix - fails with EEXISTS b/c ip adds NLM_F_EXCL
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro add unreachable 172.16.104.0/24"
-	log_test $? 2 "Attempt to add duplicate route - reject route"
-
-	# iproute2 prepend only sets NLM_F_CREATE
-	# - adds a new route; does NOT convert existing route to ECMP
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro prepend 172.16.104.0/24 via 172.16.103.2"
-	check_route "172.16.104.0/24 via 172.16.103.2 dev veth3 172.16.104.0/24 via 172.16.101.2 dev veth1"
-	log_test $? 0 "Add new nexthop for existing prefix"
-
-	# route append with same prefix adds a new route
-	# - iproute2 sets NLM_F_CREATE | NLM_F_APPEND
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro append 172.16.104.0/24 via 172.16.103.2"
-	check_route "172.16.104.0/24 via 172.16.101.2 dev veth1 172.16.104.0/24 via 172.16.103.2 dev veth3"
-	log_test $? 0 "Append nexthop to existing route - gw"
-
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro append 172.16.104.0/24 dev veth3"
-	check_route "172.16.104.0/24 via 172.16.101.2 dev veth1 172.16.104.0/24 dev veth3 scope link"
-	log_test $? 0 "Append nexthop to existing route - dev only"
-
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro append unreachable 172.16.104.0/24"
-	check_route "172.16.104.0/24 via 172.16.101.2 dev veth1 unreachable 172.16.104.0/24"
-	log_test $? 0 "Append nexthop to existing route - reject route"
-
-	run_cmd "$IP ro flush 172.16.104.0/24"
-	run_cmd "$IP ro add unreachable 172.16.104.0/24"
-	run_cmd "$IP ro append 172.16.104.0/24 via 172.16.103.2"
-	check_route "unreachable 172.16.104.0/24 172.16.104.0/24 via 172.16.103.2 dev veth3"
-	log_test $? 0 "Append nexthop to existing reject route - gw"
-
-	run_cmd "$IP ro flush 172.16.104.0/24"
-	run_cmd "$IP ro add unreachable 172.16.104.0/24"
-	run_cmd "$IP ro append 172.16.104.0/24 dev veth3"
-	check_route "unreachable 172.16.104.0/24 172.16.104.0/24 dev veth3 scope link"
-	log_test $? 0 "Append nexthop to existing reject route - dev only"
-
-	# insert mpath directly
-	add_route "172.16.104.0/24" "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	check_route  "172.16.104.0/24 nexthop via 172.16.101.2 dev veth1 weight 1 nexthop via 172.16.103.2 dev veth3 weight 1"
-	log_test $? 0 "add multipath route"
-
-	add_route "172.16.104.0/24" "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro add 172.16.104.0/24 nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	log_test $? 2 "Attempt to add duplicate multipath route"
-
-	# insert of a second route without append but different metric
-	add_route "172.16.104.0/24" "via 172.16.101.2"
-	run_cmd "$IP ro add 172.16.104.0/24 via 172.16.103.2 metric 512"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		run_cmd "$IP ro add 172.16.104.0/24 via 172.16.103.3 metric 256"
-		rc=$?
-	fi
-	log_test $rc 0 "Route add with different metrics"
-
-	run_cmd "$IP ro del 172.16.104.0/24 metric 512"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 via 172.16.101.2 dev veth1 172.16.104.0/24 via 172.16.103.3 dev veth3 metric 256"
-		rc=$?
-	fi
-	log_test $rc 0 "Route delete with metric"
-}
-
-ipv4_rt_replace_single()
-{
-	# single path with single path
-	#
-	add_initial_route "via 172.16.101.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 via 172.16.103.2"
-	check_route "172.16.104.0/24 via 172.16.103.2 dev veth3"
-	log_test $? 0 "Single path with single path"
-
-	# single path with multipath
-	#
-	add_initial_route "nexthop via 172.16.101.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 nexthop via 172.16.101.3 nexthop via 172.16.103.2"
-	check_route "172.16.104.0/24 nexthop via 172.16.101.3 dev veth1 weight 1 nexthop via 172.16.103.2 dev veth3 weight 1"
-	log_test $? 0 "Single path with multipath"
-
-	# single path with reject
-	#
-	add_initial_route "nexthop via 172.16.101.2"
-	run_cmd "$IP ro replace unreachable 172.16.104.0/24"
-	check_route "unreachable 172.16.104.0/24"
-	log_test $? 0 "Single path with reject route"
-
-	# single path with single path using MULTIPATH attribute
-	#
-	add_initial_route "via 172.16.101.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 nexthop via 172.16.103.2"
-	check_route "172.16.104.0/24 via 172.16.103.2 dev veth3"
-	log_test $? 0 "Single path with single path via multipath attribute"
-
-	# route replace fails - invalid nexthop
-	add_initial_route "via 172.16.101.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 via 2001:db8:104::2"
-	if [ $? -eq 0 ]; then
-		# previous command is expected to fail so if it returns 0
-		# that means the test failed.
-		log_test 0 1 "Invalid nexthop"
-	else
-		check_route "172.16.104.0/24 via 172.16.101.2 dev veth1"
-		log_test $? 0 "Invalid nexthop"
-	fi
-
-	# replace non-existent route
-	# - note use of change versus replace since ip adds NLM_F_CREATE
-	#   for replace
-	add_initial_route "via 172.16.101.2"
-	run_cmd "$IP ro change 172.16.105.0/24 via 172.16.101.2"
-	log_test $? 2 "Single path - replace of non-existent route"
-}
-
-ipv4_rt_replace_mpath()
-{
-	# multipath with multipath
-	add_initial_route "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 nexthop via 172.16.101.3 nexthop via 172.16.103.3"
-	check_route  "172.16.104.0/24 nexthop via 172.16.101.3 dev veth1 weight 1 nexthop via 172.16.103.3 dev veth3 weight 1"
-	log_test $? 0 "Multipath with multipath"
-
-	# multipath with single
-	add_initial_route "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 via 172.16.101.3"
-	check_route  "172.16.104.0/24 via 172.16.101.3 dev veth1"
-	log_test $? 0 "Multipath with single path"
-
-	# multipath with single
-	add_initial_route "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 nexthop via 172.16.101.3"
-	check_route "172.16.104.0/24 via 172.16.101.3 dev veth1"
-	log_test $? 0 "Multipath with single path via multipath attribute"
-
-	# multipath with reject
-	add_initial_route "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro replace unreachable 172.16.104.0/24"
-	check_route "unreachable 172.16.104.0/24"
-	log_test $? 0 "Multipath with reject route"
-
-	# route replace fails - invalid nexthop 1
-	add_initial_route "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 nexthop via 172.16.111.3 nexthop via 172.16.103.3"
-	check_route  "172.16.104.0/24 nexthop via 172.16.101.2 dev veth1 weight 1 nexthop via 172.16.103.2 dev veth3 weight 1"
-	log_test $? 0 "Multipath - invalid first nexthop"
-
-	# route replace fails - invalid nexthop 2
-	add_initial_route "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro replace 172.16.104.0/24 nexthop via 172.16.101.3 nexthop via 172.16.113.3"
-	check_route  "172.16.104.0/24 nexthop via 172.16.101.2 dev veth1 weight 1 nexthop via 172.16.103.2 dev veth3 weight 1"
-	log_test $? 0 "Multipath - invalid second nexthop"
-
-	# multipath non-existent route
-	add_initial_route "nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	run_cmd "$IP ro change 172.16.105.0/24 nexthop via 172.16.101.3 nexthop via 172.16.103.3"
-	log_test $? 2 "Multipath - replace of non-existent route"
-}
-
-ipv4_rt_replace()
-{
-	echo
-	echo "IPv4 route replace tests"
-
-	ipv4_rt_replace_single
-	ipv4_rt_replace_mpath
-}
-
-ipv4_route_test()
-{
-	route_setup
-
-	ipv4_rt_add
-	ipv4_rt_replace
-
-	route_cleanup
-}
-
-ipv4_addr_metric_test()
-{
-	local rc
-
-	echo
-	echo "IPv4 prefix route tests"
-
-	ip_addr_metric_check || return 1
-
-	setup
-
-	set -e
-	$IP li add dummy1 type dummy
-	$IP li add dummy2 type dummy
-	$IP li set dummy1 up
-	$IP li set dummy2 up
-
-	# default entry is metric 256
-	run_cmd "$IP addr add dev dummy1 172.16.104.1/24"
-	run_cmd "$IP addr add dev dummy2 172.16.104.2/24"
-	set +e
-
-	check_route "172.16.104.0/24 dev dummy1 proto kernel scope link src 172.16.104.1 172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.2"
-	log_test $? 0 "Default metric"
-
-	set -e
-	run_cmd "$IP addr flush dev dummy1"
-	run_cmd "$IP addr add dev dummy1 172.16.104.1/24 metric 257"
-	set +e
-
-	check_route "172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.2 172.16.104.0/24 dev dummy1 proto kernel scope link src 172.16.104.1 metric 257"
-	log_test $? 0 "User specified metric on first device"
-
-	set -e
-	run_cmd "$IP addr flush dev dummy2"
-	run_cmd "$IP addr add dev dummy2 172.16.104.2/24 metric 258"
-	set +e
-
-	check_route "172.16.104.0/24 dev dummy1 proto kernel scope link src 172.16.104.1 metric 257 172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.2 metric 258"
-	log_test $? 0 "User specified metric on second device"
-
-	run_cmd "$IP addr del dev dummy1 172.16.104.1/24 metric 257"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.2 metric 258"
-		rc=$?
-	fi
-	log_test $rc 0 "Delete of address on first device"
-
-	run_cmd "$IP addr change dev dummy2 172.16.104.2/24 metric 259"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.2 metric 259"
-		rc=$?
-	fi
-	log_test $rc 0 "Modify metric of address"
-
-	# verify prefix route removed on down
-	run_cmd "$IP li set dev dummy2 down"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		out=$($IP ro ls match 172.16.104.0/24)
-		check_expected "${out}" ""
-		rc=$?
-	fi
-	log_test $rc 0 "Prefix route removed on link down"
-
-	# verify prefix route re-inserted with assigned metric
-	run_cmd "$IP li set dev dummy2 up"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.2 metric 259"
-		rc=$?
-	fi
-	log_test $rc 0 "Prefix route with metric on link up"
-
-	# explicitly check for metric changes on edge scenarios
-	run_cmd "$IP addr flush dev dummy2"
-	run_cmd "$IP addr add dev dummy2 172.16.104.0/24 metric 259"
-	run_cmd "$IP addr change dev dummy2 172.16.104.0/24 metric 260"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 dev dummy2 proto kernel scope link src 172.16.104.0 metric 260"
-		rc=$?
-	fi
-	log_test $rc 0 "Modify metric of .0/24 address"
-
-	run_cmd "$IP addr flush dev dummy2"
-	run_cmd "$IP addr add dev dummy2 172.16.104.1/32 peer 172.16.104.2 metric 260"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.2 dev dummy2 proto kernel scope link src 172.16.104.1 metric 260"
-		rc=$?
-	fi
-	log_test $rc 0 "Set metric of address with peer route"
-
-	run_cmd "$IP addr change dev dummy2 172.16.104.1/32 peer 172.16.104.3 metric 261"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.3 dev dummy2 proto kernel scope link src 172.16.104.1 metric 261"
-		rc=$?
-	fi
-	log_test $rc 0 "Modify metric and peer address for peer route"
-
-	$IP li del dummy1
-	$IP li del dummy2
-	cleanup
-}
-
-ipv4_route_metrics_test()
-{
-	local rc
-
-	echo
-	echo "IPv4 route add / append tests"
-
-	route_setup
-
-	run_cmd "$IP ro add 172.16.111.0/24 via 172.16.101.2 mtu 1400"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.111.0/24 via 172.16.101.2 dev veth1 mtu 1400"
-		rc=$?
-	fi
-	log_test $rc 0 "Single path route with mtu metric"
-
-
-	run_cmd "$IP ro add 172.16.112.0/24 mtu 1400 nexthop via 172.16.101.2 nexthop via 172.16.103.2"
-	rc=$?
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.112.0/24 mtu 1400 nexthop via 172.16.101.2 dev veth1 weight 1 nexthop via 172.16.103.2 dev veth3 weight 1"
-		rc=$?
-	fi
-	log_test $rc 0 "Multipath route with mtu metric"
-
-	$IP ro add 172.16.104.0/24 via 172.16.101.2 mtu 1300
-	run_cmd "ip netns exec ns1 ping -w1 -c1 -s 1500 172.16.104.1"
-	log_test $? 0 "Using route with mtu metric"
-
-	run_cmd "$IP ro add 172.16.111.0/24 via 172.16.101.2 congctl lock foo"
-	log_test $? 2 "Invalid metric (fails metric_convert)"
-
-	route_cleanup
-}
-
-ipv4_route_v6_gw_test()
-{
-	local rc
-
-	echo
-	echo "IPv4 route with IPv6 gateway tests"
-
-	route_setup
-	sleep 2
-
-	#
-	# single path route
-	#
-	run_cmd "$IP ro add 172.16.104.0/24 via inet6 2001:db8:101::2"
-	rc=$?
-	log_test $rc 0 "Single path route with IPv6 gateway"
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 via inet6 2001:db8:101::2 dev veth1"
-	fi
-
-	run_cmd "ip netns exec ns1 ping -w1 -c1 172.16.104.1"
-	log_test $rc 0 "Single path route with IPv6 gateway - ping"
-
-	run_cmd "$IP ro del 172.16.104.0/24 via inet6 2001:db8:101::2"
-	rc=$?
-	log_test $rc 0 "Single path route delete"
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.112.0/24"
-	fi
-
-	#
-	# multipath - v6 then v4
-	#
-	run_cmd "$IP ro add 172.16.104.0/24 nexthop via inet6 2001:db8:101::2 dev veth1 nexthop via 172.16.103.2 dev veth3"
-	rc=$?
-	log_test $rc 0 "Multipath route add - v6 nexthop then v4"
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 nexthop via inet6 2001:db8:101::2 dev veth1 weight 1 nexthop via 172.16.103.2 dev veth3 weight 1"
-	fi
-
-	run_cmd "$IP ro del 172.16.104.0/24 nexthop via 172.16.103.2 dev veth3 nexthop via inet6 2001:db8:101::2 dev veth1"
-	log_test $? 2 "    Multipath route delete - nexthops in wrong order"
-
-	run_cmd "$IP ro del 172.16.104.0/24 nexthop via inet6 2001:db8:101::2 dev veth1 nexthop via 172.16.103.2 dev veth3"
-	log_test $? 0 "    Multipath route delete exact match"
-
-	#
-	# multipath - v4 then v6
-	#
-	run_cmd "$IP ro add 172.16.104.0/24 nexthop via 172.16.103.2 dev veth3 nexthop via inet6 2001:db8:101::2 dev veth1"
-	rc=$?
-	log_test $rc 0 "Multipath route add - v4 nexthop then v6"
-	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.0/24 nexthop via 172.16.103.2 dev veth3 weight 1 nexthop via inet6 2001:db8:101::2 dev veth1 weight 1"
-	fi
-
-	run_cmd "$IP ro del 172.16.104.0/24 nexthop via inet6 2001:db8:101::2 dev veth1 nexthop via 172.16.103.2 dev veth3"
-	log_test $? 2 "    Multipath route delete - nexthops in wrong order"
-
-	run_cmd "$IP ro del 172.16.104.0/24 nexthop via 172.16.103.2 dev veth3 nexthop via inet6 2001:db8:101::2 dev veth1"
-	log_test $? 0 "    Multipath route delete exact match"
-
-	route_cleanup
-}
-
-################################################################################
-# usage
-
-usage()
-{
-	cat <<EOF
-usage: ${0##*/} OPTS
-
-        -t <test>   Test(s) to run (default: all)
-                    (options: $TESTS)
-        -p          Pause on fail
-        -P          Pause after each test before cleanup
-        -v          verbose mode (show commands and output)
-EOF
-}
-
-################################################################################
-# main
-
-while getopts :t:pPhv o
-do
-	case $o in
-		t) TESTS=$OPTARG;;
-		p) PAUSE_ON_FAIL=yes;;
-		P) PAUSE=yes;;
-		v) VERBOSE=$(($VERBOSE + 1));;
-		h) usage; exit 0;;
-		*) usage; exit 1;;
-	esac
-done
-
-PEER_CMD="ip netns exec ${PEER_NS}"
-
-# make sure we don't pause twice
-[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no
-
-if [ "$(id -u)" -ne 0 ];then
-	echo "SKIP: Need root privileges"
-	exit $ksft_skip;
-fi
-
-if [ ! -x "$(command -v ip)" ]; then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-ip route help 2>&1 | grep -q fibmatch
-if [ $? -ne 0 ]; then
-	echo "SKIP: iproute2 too old, missing fibmatch"
-	exit $ksft_skip
-fi
-
-# start clean
-cleanup &> /dev/null
-
-for t in $TESTS
-do
-	case $t in
-	fib_unreg_test|unregister)	fib_unreg_test;;
-	fib_down_test|down)		fib_down_test;;
-	fib_carrier_test|carrier)	fib_carrier_test;;
-	fib_rp_filter_test|rp_filter)	fib_rp_filter_test;;
-	fib_nexthop_test|nexthop)	fib_nexthop_test;;
-	fib_suppress_test|suppress)	fib_suppress_test;;
-	ipv6_route_test|ipv6_rt)	ipv6_route_test;;
-	ipv4_route_test|ipv4_rt)	ipv4_route_test;;
-	ipv6_addr_metric)		ipv6_addr_metric_test;;
-	ipv4_addr_metric)		ipv4_addr_metric_test;;
-	ipv6_route_metrics)		ipv6_route_metrics_test;;
-	ipv4_route_metrics)		ipv4_route_metrics_test;;
-	ipv4_route_v6_gw)		ipv4_route_v6_gw_test;;
-
-	help) echo "Test names: $TESTS"; exit 0;;
-	esac
-done
-
-if [ "$TESTS" != "none" ]; then
-	printf "\nTests passed: %3d\n" ${nsuccess}
-	printf "Tests failed: %3d\n"   ${nfail}
-fi
-
-exit $ret
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 28ea3753da20..911c549f186f 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -780,7 +780,7 @@ kci_test_ipsec_offload()
 	    tmpl proto esp src $srcip dst $dstip spi 9 \
 	    mode transport reqid 42
 	check_err $?
-	ip x p add dir out src $dstip/24 dst $srcip/24 \
+	ip x p add dir in src $dstip/24 dst $srcip/24 \
 	    tmpl proto esp src $dstip dst $srcip spi 9 \
 	    mode transport reqid 42
 	check_err $?
