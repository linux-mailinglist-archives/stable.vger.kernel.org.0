Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A202B55F8B2
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 09:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiF2HRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 03:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiF2HRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 03:17:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6E5338A4;
        Wed, 29 Jun 2022 00:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A962CB821D6;
        Wed, 29 Jun 2022 07:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD6AC34114;
        Wed, 29 Jun 2022 07:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656487033;
        bh=JeCOU6Chffku/XoSlpPfphdbgcKyuLS20OUpxFBD8qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5FbyVnOahaJ2rL+2nYGS/JmcJ8mFRAsz/a/WcQ6LrfWD4DLTr7FwDk6TfDO791M4
         35y7vtlcI1ie/xBe70UZHslN7w5Ag3+RR0CHNRYSyJAFPxgnwV7oMCIWyOyUPGfDuK
         Or4ljRVFi/XpwcHCY5ZqJ5TKrbjDGboJ5q6AsJ8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.51
Date:   Wed, 29 Jun 2022 09:17:03 +0200
Message-Id: <165648702317653@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <1656487023112211@kroah.com>
References: <1656487023112211@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-vf610 b/Documentation/ABI/testing/sysfs-bus-iio-vf610
index 308a6756d3bf..491ead804488 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-vf610
+++ b/Documentation/ABI/testing/sysfs-bus-iio-vf610
@@ -1,4 +1,4 @@
-What:		/sys/bus/iio/devices/iio:deviceX/conversion_mode
+What:		/sys/bus/iio/devices/iio:deviceX/in_conversion_mode
 KernelVersion:	4.2
 Contact:	linux-iio@vger.kernel.org
 Description:
diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
index 8913497624de..cb5da1df8d40 100644
--- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
+++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
@@ -135,7 +135,8 @@ properties:
       Phandle of a companion.
 
   phys:
-    maxItems: 1
+    minItems: 1
+    maxItems: 3
 
   phy-names:
     const: usb
diff --git a/Documentation/devicetree/bindings/usb/generic-ohci.yaml b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
index acbf94fa5f74..d5fd3aa53ed2 100644
--- a/Documentation/devicetree/bindings/usb/generic-ohci.yaml
+++ b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
@@ -102,7 +102,8 @@ properties:
       Overrides the detected port count
 
   phys:
-    maxItems: 1
+    minItems: 1
+    maxItems: 3
 
   phy-names:
     const: usb
diff --git a/MAINTAINERS b/MAINTAINERS
index 942e0b173f2c..393706e85ba2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -434,6 +434,7 @@ ACPI VIOT DRIVER
 M:	Jean-Philippe Brucker <jean-philippe@linaro.org>
 L:	linux-acpi@vger.kernel.org
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/acpi/viot.c
 F:	include/linux/acpi_viot.h
@@ -941,6 +942,7 @@ AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joro@8bytes.org>
 R:	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	drivers/iommu/amd/
@@ -5602,6 +5604,7 @@ M:	Christoph Hellwig <hch@lst.de>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 R:	Robin Murphy <robin.murphy@arm.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
 T:	git git://git.infradead.org/users/hch/dma-mapping.git
@@ -5614,6 +5617,7 @@ F:	kernel/dma/
 DMA MAPPING BENCHMARK
 M:	Barry Song <song.bao.hua@hisilicon.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 F:	kernel/dma/map_benchmark.c
 F:	tools/testing/selftests/dma/
 
@@ -7115,6 +7119,7 @@ F:	drivers/gpu/drm/exynos/exynos_dp*
 EXYNOS SYSMMU (IOMMU) driver
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/iommu/exynos-iommu.c
 
@@ -9457,6 +9462,7 @@ INTEL IOMMU (VT-d)
 M:	David Woodhouse <dwmw2@infradead.org>
 M:	Lu Baolu <baolu.lu@linux.intel.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	drivers/iommu/intel/
@@ -9793,6 +9799,7 @@ IOMMU DRIVERS
 M:	Joerg Roedel <joro@8bytes.org>
 M:	Will Deacon <will@kernel.org>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	Documentation/devicetree/bindings/iommu/
@@ -11795,6 +11802,7 @@ F:	drivers/i2c/busses/i2c-mt65xx.c
 MEDIATEK IOMMU DRIVER
 M:	Yong Wu <yong.wu@mediatek.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	Documentation/devicetree/bindings/iommu/mediatek*
@@ -15554,6 +15562,7 @@ F:	drivers/i2c/busses/i2c-qcom-cci.c
 QUALCOMM IOMMU
 M:	Rob Clark <robdclark@gmail.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
 F:	drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -17982,6 +17991,7 @@ F:	arch/x86/boot/video*
 SWIOTLB SUBSYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
 T:	git git://git.infradead.org/users/hch/dma-mapping.git
@@ -20562,6 +20572,7 @@ M:	Juergen Gross <jgross@suse.com>
 M:	Stefano Stabellini <sstabellini@kernel.org>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
diff --git a/Makefile b/Makefile
index 03b3a493fcca..b3bc9d907bed 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 50
+SUBLEVEL = 51
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -1163,7 +1163,7 @@ KBUILD_MODULES := 1
 
 autoksyms_recursive: descend modules.order
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/adjust_autoksyms.sh \
-	  "$(MAKE) -f $(srctree)/Makefile vmlinux"
+	  "$(MAKE) -f $(srctree)/Makefile autoksyms_recursive"
 endif
 
 autoksyms_h := $(if $(CONFIG_TRIM_UNUSED_KSYMS), include/generated/autoksyms.h)
diff --git a/arch/arm/boot/dts/bcm2711-rpi-400.dts b/arch/arm/boot/dts/bcm2711-rpi-400.dts
index f4d2fc20397c..c53d9eb0b802 100644
--- a/arch/arm/boot/dts/bcm2711-rpi-400.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-400.dts
@@ -28,12 +28,12 @@ gpio-poweroff {
 &expgpio {
 	gpio-line-names = "BT_ON",
 			  "WL_ON",
-			  "",
+			  "PWR_LED_OFF",
 			  "GLOBAL_RESET",
 			  "VDD_SD_IO_SEL",
-			  "CAM_GPIO",
+			  "GLOBAL_SHUTDOWN",
 			  "SD_PWR_ON",
-			  "SD_OC_N";
+			  "SHUTDOWN_REQUEST";
 };
 
 &genet_mdio {
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 89c342f3a7c2..8520ffc1779b 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -763,7 +763,7 @@ reg_pu: regulator-vddpu {
 					regulator-name = "vddpu";
 					regulator-min-microvolt = <725000>;
 					regulator-max-microvolt = <1450000>;
-					regulator-enable-ramp-delay = <150>;
+					regulator-enable-ramp-delay = <380>;
 					anatop-reg-offset = <0x140>;
 					anatop-vol-bit-shift = <9>;
 					anatop-vol-bit-width = <5>;
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 1843fc053870..95f22513a7c0 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -104,6 +104,7 @@ usbphynop3: usbphynop3 {
 		compatible = "usb-nop-xceiv";
 		clocks = <&clks IMX7D_USB_HSIC_ROOT_CLK>;
 		clock-names = "main_clk";
+		power-domains = <&pgc_hsic_phy>;
 		#phy-cells = <0>;
 	};
 
@@ -1135,7 +1136,6 @@ usbh: usb@30b30000 {
 				compatible = "fsl,imx7d-usb", "fsl,imx27-usb";
 				reg = <0x30b30000 0x200>;
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
-				power-domains = <&pgc_hsic_phy>;
 				clocks = <&clks IMX7D_USB_CTRL_CLK>;
 				fsl,usbphy = <&usbphynop3>;
 				fsl,usbmisc = <&usbmisc3 0>;
diff --git a/arch/arm/mach-axxia/platsmp.c b/arch/arm/mach-axxia/platsmp.c
index 512943eae30a..2e203626eda5 100644
--- a/arch/arm/mach-axxia/platsmp.c
+++ b/arch/arm/mach-axxia/platsmp.c
@@ -39,6 +39,7 @@ static int axxia_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		return -ENOENT;
 
 	syscon = of_iomap(syscon_np, 0);
+	of_node_put(syscon_np);
 	if (!syscon)
 		return -ENOMEM;
 
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index e4f4b20b83a2..3fc4ec830e3a 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -372,6 +372,7 @@ static void __init cns3xxx_init(void)
 		/* De-Asscer SATA Reset */
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SATA));
 	}
+	of_node_put(dn);
 
 	dn = of_find_compatible_node(NULL, NULL, "cavium,cns3420-sdhci");
 	if (of_device_is_available(dn)) {
@@ -385,6 +386,7 @@ static void __init cns3xxx_init(void)
 		cns3xxx_pwr_clk_en(CNS3XXX_PWR_CLK_EN(SDIO));
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SDIO));
 	}
+	of_node_put(dn);
 
 	pm_power_off = cns3xxx_power_off;
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 8b48326be9fd..51a247ca4da8 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -149,6 +149,7 @@ static void exynos_map_pmu(void)
 	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
 	if (np)
 		pmu_base_addr = of_iomap(np, 0);
+	of_node_put(np);
 }
 
 static void __init exynos_init_irq(void)
diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index 86291f3469f1..d195b97ab2ee 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -456,13 +456,11 @@ sdhci0: mmc@fa10000 {
 		clock-names = "clk_ahb", "clk_xin";
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
-		mmc-hs400-1_8v;
 		ti,trm-icp = <0x2>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-ddr52 = <0x6>;
 		ti,otap-del-sel-hs200 = <0x7>;
-		ti,otap-del-sel-hs400 = <0x4>;
 	};
 
 	sdhci1: mmc@fa00000 {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a30c036577a3..f181527f9d43 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2011,11 +2011,11 @@ static int finalize_hyp_mode(void)
 		return 0;
 
 	/*
-	 * Exclude HYP BSS from kmemleak so that it doesn't get peeked
-	 * at, which would end badly once the section is inaccessible.
-	 * None of other sections should ever be introspected.
+	 * Exclude HYP sections from kmemleak so that they don't get peeked
+	 * at, which would end badly once inaccessible.
 	 */
 	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
+	kmemleak_free_part(__va(hyp_mem_base), hyp_mem_size);
 	return pkvm_drop_host_privileges();
 }
 
diff --git a/arch/mips/vr41xx/common/icu.c b/arch/mips/vr41xx/common/icu.c
index 7b7f25b4b057..9240bcdbe74e 100644
--- a/arch/mips/vr41xx/common/icu.c
+++ b/arch/mips/vr41xx/common/icu.c
@@ -640,8 +640,6 @@ static int icu_get_irq(unsigned int irq)
 
 	printk(KERN_ERR "spurious ICU interrupt: %04x,%04x\n", pend1, pend2);
 
-	atomic_inc(&irq_err_count);
-
 	return -1;
 }
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 27a8b49af11f..5dccf01a9e17 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -9,6 +9,7 @@ config PARISC
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_STRICT_KERNEL_RWX
+	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_NO_SG_CHAIN
 	select ARCH_SUPPORTS_HUGETLBFS if PA20
diff --git a/arch/parisc/include/asm/fb.h b/arch/parisc/include/asm/fb.h
index d63a2acb91f2..55d29c4f716e 100644
--- a/arch/parisc/include/asm/fb.h
+++ b/arch/parisc/include/asm/fb.h
@@ -12,7 +12,7 @@ static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
 }
 
-#if defined(CONFIG_STI_CONSOLE) || defined(CONFIG_FB_STI)
+#if defined(CONFIG_FB_STI)
 int fb_is_primary_device(struct fb_info *info);
 #else
 static inline int fb_is_primary_device(struct fb_info *info)
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 39a0a13a3a27..c590e1219913 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1818,7 +1818,7 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 		tm_reclaim_current(0);
 #endif
 
-	memset(regs->gpr, 0, sizeof(regs->gpr));
+	memset(&regs->gpr[1], 0, sizeof(regs->gpr) - sizeof(regs->gpr[0]));
 	regs->ctr = 0;
 	regs->link = 0;
 	regs->xer = 0;
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 3f5814037035..e8f44084d251 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -983,7 +983,7 @@ static struct rtas_filter rtas_filters[] __ro_after_init = {
 	{ "get-time-of-day", -1, -1, -1, -1, -1 },
 	{ "ibm,get-vpd", -1, 0, -1, 1, 2 },
 	{ "ibm,lpar-perftools", -1, 2, 3, -1, -1 },
-	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },
+	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },		/* Special cased */
 	{ "ibm,read-slot-reset-state", -1, -1, -1, -1, -1 },
 	{ "ibm,scan-log-dump", -1, 0, 1, -1, -1 },
 	{ "ibm,set-dynamic-indicator", -1, 2, -1, -1, -1 },
@@ -1032,6 +1032,15 @@ static bool block_rtas_call(int token, int nargs,
 				size = 1;
 
 			end = base + size - 1;
+
+			/*
+			 * Special case for ibm,platform-dump - NULL buffer
+			 * address is used to indicate end of dump processing
+			 */
+			if (!strcmp(f->name, "ibm,platform-dump") &&
+			    base == 0)
+				return false;
+
 			if (!in_rmo_buf(base, end))
 				goto err;
 		}
diff --git a/arch/powerpc/platforms/microwatt/microwatt.h b/arch/powerpc/platforms/microwatt/microwatt.h
new file mode 100644
index 000000000000..335417e95e66
--- /dev/null
+++ b/arch/powerpc/platforms/microwatt/microwatt.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MICROWATT_H
+#define _MICROWATT_H
+
+void microwatt_rng_init(void);
+
+#endif /* _MICROWATT_H */
diff --git a/arch/powerpc/platforms/microwatt/rng.c b/arch/powerpc/platforms/microwatt/rng.c
index 3d8ee6eb7dad..8cb161533e6a 100644
--- a/arch/powerpc/platforms/microwatt/rng.c
+++ b/arch/powerpc/platforms/microwatt/rng.c
@@ -11,6 +11,7 @@
 #include <asm/archrandom.h>
 #include <asm/cputable.h>
 #include <asm/machdep.h>
+#include "microwatt.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -29,7 +30,7 @@ int microwatt_get_random_darn(unsigned long *v)
 	return 1;
 }
 
-static __init int rng_init(void)
+void __init microwatt_rng_init(void)
 {
 	unsigned long val;
 	int i;
@@ -37,12 +38,7 @@ static __init int rng_init(void)
 	for (i = 0; i < 10; i++) {
 		if (microwatt_get_random_darn(&val)) {
 			ppc_md.get_random_seed = microwatt_get_random_darn;
-			return 0;
+			return;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
-	return -EIO;
 }
-machine_subsys_initcall(, rng_init);
diff --git a/arch/powerpc/platforms/microwatt/setup.c b/arch/powerpc/platforms/microwatt/setup.c
index 0b02603bdb74..6b32539395a4 100644
--- a/arch/powerpc/platforms/microwatt/setup.c
+++ b/arch/powerpc/platforms/microwatt/setup.c
@@ -16,6 +16,8 @@
 #include <asm/xics.h>
 #include <asm/udbg.h>
 
+#include "microwatt.h"
+
 static void __init microwatt_init_IRQ(void)
 {
 	xics_init();
@@ -32,10 +34,16 @@ static int __init microwatt_populate(void)
 }
 machine_arch_initcall(microwatt, microwatt_populate);
 
+static void __init microwatt_setup_arch(void)
+{
+	microwatt_rng_init();
+}
+
 define_machine(microwatt) {
 	.name			= "microwatt",
 	.probe			= microwatt_probe,
 	.init_IRQ		= microwatt_init_IRQ,
+	.setup_arch		= microwatt_setup_arch,
 	.progress		= udbg_progress,
 	.calibrate_decr		= generic_calibrate_decr,
 };
diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index 11df4e16a1cc..528946ee7a77 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -42,4 +42,6 @@ ssize_t memcons_copy(struct memcons *mc, char *to, loff_t pos, size_t count);
 u32 memcons_get_size(struct memcons *mc);
 struct memcons *memcons_init(struct device_node *node, const char *mc_prop_name);
 
+void pnv_rng_init(void);
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 69c344c8884f..2b5a1a41234c 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -17,6 +17,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/smp.h>
+#include "powernv.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -28,7 +29,6 @@ struct powernv_rng {
 
 static DEFINE_PER_CPU(struct powernv_rng *, powernv_rng);
 
-
 int powernv_hwrng_present(void)
 {
 	struct powernv_rng *rng;
@@ -98,9 +98,6 @@ static int initialise_darn(void)
 			return 0;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
 	return -EIO;
 }
 
@@ -163,32 +160,55 @@ static __init int rng_create(struct device_node *dn)
 
 	rng_init_per_cpu(rng, dn);
 
-	pr_info_once("Registering arch random hook.\n");
-
 	ppc_md.get_random_seed = powernv_get_random_long;
 
 	return 0;
 }
 
-static __init int rng_init(void)
+static int __init pnv_get_random_long_early(unsigned long *v)
 {
 	struct device_node *dn;
-	int rc;
+
+	if (!slab_is_available())
+		return 0;
+
+	if (cmpxchg(&ppc_md.get_random_seed, pnv_get_random_long_early,
+		    NULL) != pnv_get_random_long_early)
+		return 0;
 
 	for_each_compatible_node(dn, NULL, "ibm,power-rng") {
-		rc = rng_create(dn);
-		if (rc) {
-			pr_err("Failed creating rng for %pOF (%d).\n",
-				dn, rc);
+		if (rng_create(dn))
 			continue;
-		}
-
 		/* Create devices for hwrng driver */
 		of_platform_device_create(dn, NULL, NULL);
 	}
 
-	initialise_darn();
+	if (!ppc_md.get_random_seed)
+		return 0;
+	return ppc_md.get_random_seed(v);
+}
+
+void __init pnv_rng_init(void)
+{
+	struct device_node *dn;
 
+	/* Prefer darn over the rest. */
+	if (!initialise_darn())
+		return;
+
+	dn = of_find_compatible_node(NULL, NULL, "ibm,power-rng");
+	if (dn)
+		ppc_md.get_random_seed = pnv_get_random_long_early;
+
+	of_node_put(dn);
+}
+
+static int __init pnv_rng_late_init(void)
+{
+	unsigned long v;
+	/* In case it wasn't called during init for some other reason. */
+	if (ppc_md.get_random_seed == pnv_get_random_long_early)
+		pnv_get_random_long_early(&v);
 	return 0;
 }
-machine_subsys_initcall(powernv, rng_init);
+machine_subsys_initcall(powernv, pnv_rng_late_init);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index a8db3f153063..1b3c7e04a7af 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -190,6 +190,8 @@ static void __init pnv_setup_arch(void)
 	pnv_check_guarded_cores();
 
 	/* XXX PMCS */
+
+	pnv_rng_init();
 }
 
 static void __init pnv_init(void)
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index 3544778e06d0..2a97cc20fe8f 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -115,4 +115,6 @@ extern u32 pseries_security_flavor;
 void pseries_setup_security_mitigations(void);
 void pseries_lpar_read_hblkrm_characteristics(void);
 
+void pseries_rng_init(void);
+
 #endif /* _PSERIES_PSERIES_H */
diff --git a/arch/powerpc/platforms/pseries/rng.c b/arch/powerpc/platforms/pseries/rng.c
index 6268545947b8..6ddfdeaace9e 100644
--- a/arch/powerpc/platforms/pseries/rng.c
+++ b/arch/powerpc/platforms/pseries/rng.c
@@ -10,6 +10,7 @@
 #include <asm/archrandom.h>
 #include <asm/machdep.h>
 #include <asm/plpar_wrappers.h>
+#include "pseries.h"
 
 
 static int pseries_get_random_long(unsigned long *v)
@@ -24,19 +25,13 @@ static int pseries_get_random_long(unsigned long *v)
 	return 0;
 }
 
-static __init int rng_init(void)
+void __init pseries_rng_init(void)
 {
 	struct device_node *dn;
 
 	dn = of_find_compatible_node(NULL, NULL, "ibm,random");
 	if (!dn)
-		return -ENODEV;
-
-	pr_info("Registering arch random hook.\n");
-
+		return;
 	ppc_md.get_random_seed = pseries_get_random_long;
-
 	of_node_put(dn);
-	return 0;
 }
-machine_subsys_initcall(pseries, rng_init);
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index f79126f16258..c2b3752684b5 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -840,6 +840,8 @@ static void __init pSeries_setup_arch(void)
 
 	if (swiotlb_force == SWIOTLB_FORCE)
 		ppc_swiotlb_enable = 1;
+
+	pseries_rng_init();
 }
 
 static void pseries_panic(char *str)
diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index cceb8ec707e4..d2a2a18b5580 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -516,6 +516,26 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 	return err;
 }
 
+/* Events CPU_CYLCES and INSTRUCTIONS can be submitted with two different
+ * attribute::type values:
+ * - PERF_TYPE_HARDWARE:
+ * - pmu->type:
+ * Handle both type of invocations identical. They address the same hardware.
+ * The result is different when event modifiers exclude_kernel and/or
+ * exclude_user are also set.
+ */
+static int cpumf_pmu_event_type(struct perf_event *event)
+{
+	u64 ev = event->attr.config;
+
+	if (cpumf_generic_events_basic[PERF_COUNT_HW_CPU_CYCLES] == ev ||
+	    cpumf_generic_events_basic[PERF_COUNT_HW_INSTRUCTIONS] == ev ||
+	    cpumf_generic_events_user[PERF_COUNT_HW_CPU_CYCLES] == ev ||
+	    cpumf_generic_events_user[PERF_COUNT_HW_INSTRUCTIONS] == ev)
+		return PERF_TYPE_HARDWARE;
+	return PERF_TYPE_RAW;
+}
+
 static int cpumf_pmu_event_init(struct perf_event *event)
 {
 	unsigned int type = event->attr.type;
@@ -525,7 +545,7 @@ static int cpumf_pmu_event_init(struct perf_event *event)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
 		/* Registered as unknown PMU */
-		err = __hw_perf_event_init(event, PERF_TYPE_RAW);
+		err = __hw_perf_event_init(event, cpumf_pmu_event_type(event));
 	else
 		return -ENOENT;
 
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index d99434dc215c..8dca2bcbb0ea 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1440,8 +1440,9 @@ st:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_CALL:
 			func = (u8 *) __bpf_call_base + imm32;
 			if (tail_call_reachable) {
+				/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
 				EMIT3_off32(0x48, 0x8B, 0x85,
-					    -(bpf_prog->aux->stack_depth + 8));
+					    -round_up(bpf_prog->aux->stack_depth, 8) - 8);
 				if (!imm32 || emit_call(&prog, func, image + addrs[i - 1] + 7))
 					return -EINVAL;
 			} else {
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index e8ceb1528608..16b8a6273772 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -154,6 +154,7 @@ static void __init calibrate_ccount(void)
 	cpu = of_find_compatible_node(NULL, NULL, "cdns,xtensa-cpu");
 	if (cpu) {
 		clk = of_clk_get(cpu, 0);
+		of_node_put(cpu);
 		if (!IS_ERR(clk)) {
 			ccount_freq = clk_get_rate(clk);
 			return;
diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index 538e6748e85a..c79c1d09ea86 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -133,6 +133,7 @@ static int __init machine_setup(void)
 
 	if ((eth = of_find_compatible_node(eth, NULL, "opencores,ethoc")))
 		update_local_mac(eth);
+	of_node_put(eth);
 	return 0;
 }
 arch_initcall(machine_setup);
diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 4a446259a184..3aac960ae30a 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -252,6 +252,7 @@ static void regmap_irq_enable(struct irq_data *data)
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
+	unsigned int reg = irq_data->reg_offset / map->reg_stride;
 	unsigned int mask, type;
 
 	type = irq_data->type.type_falling_val | irq_data->type.type_rising_val;
@@ -268,14 +269,14 @@ static void regmap_irq_enable(struct irq_data *data)
 	 * at the corresponding offset in regmap_irq_set_type().
 	 */
 	if (d->chip->type_in_mask && type)
-		mask = d->type_buf[irq_data->reg_offset / map->reg_stride];
+		mask = d->type_buf[reg] & irq_data->mask;
 	else
 		mask = irq_data->mask;
 
 	if (d->chip->clear_on_unmask)
 		d->clear_status = true;
 
-	d->mask_buf[irq_data->reg_offset / map->reg_stride] &= ~mask;
+	d->mask_buf[reg] &= ~mask;
 }
 
 static void regmap_irq_disable(struct irq_data *data)
@@ -386,6 +387,7 @@ static inline int read_sub_irq_data(struct regmap_irq_chip_data *data,
 		subreg = &chip->sub_reg_offsets[b];
 		for (i = 0; i < subreg->num_regs; i++) {
 			unsigned int offset = subreg->offset[i];
+			unsigned int index = offset / map->reg_stride;
 
 			if (chip->not_fixed_stride)
 				ret = regmap_read(map,
@@ -394,7 +396,7 @@ static inline int read_sub_irq_data(struct regmap_irq_chip_data *data,
 			else
 				ret = regmap_read(map,
 						chip->status_base + offset,
-						&data->status_buf[offset]);
+						&data->status_buf[index]);
 
 			if (ret)
 				break;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 390817cf1221..d7a9bf43fb32 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2140,9 +2140,11 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	blk_mq_stop_hw_queues(info->rq);
-	blk_mark_disk_dead(info->gd);
-	set_capacity(info->gd, 0);
+	if (info->rq && info->gd) {
+		blk_mq_stop_hw_queues(info->rq);
+		blk_mark_disk_dead(info->gd);
+		set_capacity(info->gd, 0);
+	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
@@ -2478,16 +2480,19 @@ static int blkfront_remove(struct xenbus_device *xbdev)
 
 	dev_dbg(&xbdev->dev, "%s removed", xbdev->nodename);
 
-	del_gendisk(info->gd);
+	if (info->gd)
+		del_gendisk(info->gd);
 
 	mutex_lock(&blkfront_mutex);
 	list_del(&info->info_list);
 	mutex_unlock(&blkfront_mutex);
 
 	blkif_free(info, 0);
-	xlbd_release_minors(info->gd->first_minor, info->gd->minors);
-	blk_cleanup_disk(info->gd);
-	blk_mq_free_tag_set(&info->tag_set);
+	if (info->gd) {
+		xlbd_release_minors(info->gd->first_minor, info->gd->minors);
+		blk_cleanup_disk(info->gd);
+		blk_mq_free_tag_set(&info->tag_set);
+	}
 
 	kfree(info);
 	return 0;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7f6585c49380..7bd6eb15d432 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -88,7 +88,7 @@ static RAW_NOTIFIER_HEAD(random_ready_chain);
 
 /* Control how we warn userspace. */
 static struct ratelimit_state urandom_warning =
-	RATELIMIT_STATE_INIT("warn_urandom_randomness", HZ, 3);
+	RATELIMIT_STATE_INIT_FLAGS("urandom_warning", HZ, 3, RATELIMIT_MSG_ON_RELEASE);
 static int ratelimit_disable __read_mostly =
 	IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM);
 module_param_named(ratelimit_disable, ratelimit_disable, int, 0644);
@@ -452,7 +452,7 @@ static ssize_t get_random_bytes_user(struct iov_iter *iter)
 
 	/*
 	 * Immediately overwrite the ChaCha key at index 4 with random
-	 * bytes, in case userspace causes copy_to_user() below to sleep
+	 * bytes, in case userspace causes copy_to_iter() below to sleep
 	 * forever, so that we still retain forward secrecy in that case.
 	 */
 	crng_make_state(chacha_state, (u8 *)&chacha_state[4], CHACHA_KEY_SIZE);
@@ -1000,7 +1000,7 @@ void add_interrupt_randomness(int irq)
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
+	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index e7330684d3b8..9631f2fd2faf 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -32,8 +32,11 @@ static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct udmabuf *ubuf = vma->vm_private_data;
+	pgoff_t pgoff = vmf->pgoff;
 
-	vmf->page = ubuf->pages[vmf->pgoff];
+	if (pgoff >= ubuf->pagecount)
+		return VM_FAULT_SIGBUS;
+	vmf->page = ubuf->pages[pgoff];
 	get_page(vmf->page);
 	return 0;
 }
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index 98cd715ccc33..8d09b619c166 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -217,8 +217,6 @@ static int giu_get_irq(unsigned int irq)
 	printk(KERN_ERR "spurious GIU interrupt: %04x(%04x),%04x(%04x)\n",
 	       maskl, pendl, maskh, pendh);
 
-	atomic_inc(&irq_err_count);
-
 	return -EINVAL;
 }
 
diff --git a/drivers/gpio/gpio-winbond.c b/drivers/gpio/gpio-winbond.c
index 7f8f5b02e31d..4b61d975cc0e 100644
--- a/drivers/gpio/gpio-winbond.c
+++ b/drivers/gpio/gpio-winbond.c
@@ -385,12 +385,13 @@ static int winbond_gpio_get(struct gpio_chip *gc, unsigned int offset)
 	unsigned long *base = gpiochip_get_data(gc);
 	const struct winbond_gpio_info *info;
 	bool val;
+	int ret;
 
 	winbond_gpio_get_info(&offset, &info);
 
-	val = winbond_sio_enter(*base);
-	if (val)
-		return val;
+	ret = winbond_sio_enter(*base);
+	if (ret)
+		return ret;
 
 	winbond_sio_select_logical(*base, info->dev);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
index 5c91d125a337..3dfa600fb86d 100644
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -2434,7 +2434,7 @@ static void icl_wrpll_params_populate(struct skl_wrpll_params *params,
 }
 
 /*
- * Display WA #22010492432: ehl, tgl, adl-p
+ * Display WA #22010492432: ehl, tgl, adl-s, adl-p
  * Program half of the nominal DCO divider fraction value.
  */
 static bool
@@ -2442,7 +2442,7 @@ ehl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
 {
 	return ((IS_PLATFORM(i915, INTEL_ELKHARTLAKE) &&
 		 IS_JSL_EHL_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
-		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_P(i915)) &&
+		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
 		 i915->dpll.ref_clks.nssc == 38400;
 }
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 748665232d29..bba68776cb25 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -958,7 +958,8 @@ void adreno_gpu_cleanup(struct adreno_gpu *adreno_gpu)
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
-	pm_runtime_disable(&priv->gpu_pdev->dev);
+	if (pm_runtime_enabled(&priv->gpu_pdev->dev))
+		pm_runtime_disable(&priv->gpu_pdev->dev);
 
 	msm_gpu_cleanup(&adreno_gpu->base);
 }
diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index cdcaf470f148..97ae68182f3e 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -223,6 +223,7 @@ static int mdp4_modeset_init_intf(struct mdp4_kms *mdp4_kms,
 		encoder = mdp4_lcdc_encoder_init(dev, panel_node);
 		if (IS_ERR(encoder)) {
 			DRM_DEV_ERROR(dev->dev, "failed to construct LCDC encoder\n");
+			of_node_put(panel_node);
 			return PTR_ERR(encoder);
 		}
 
@@ -232,6 +233,7 @@ static int mdp4_modeset_init_intf(struct mdp4_kms *mdp4_kms,
 		connector = mdp4_lvds_connector_init(dev, panel_node, encoder);
 		if (IS_ERR(connector)) {
 			DRM_DEV_ERROR(dev->dev, "failed to initialize LVDS connector\n");
+			of_node_put(panel_node);
 			return PTR_ERR(connector);
 		}
 
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 1992347537e6..b6f4ce2a48af 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1348,60 +1348,49 @@ static int dp_ctrl_enable_stream_clocks(struct dp_ctrl_private *ctrl)
 	return ret;
 }
 
-int dp_ctrl_host_init(struct dp_ctrl *dp_ctrl, bool flip, bool reset)
+void dp_ctrl_reset_irq_ctrl(struct dp_ctrl *dp_ctrl, bool enable)
+{
+	struct dp_ctrl_private *ctrl;
+
+	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
+
+	dp_catalog_ctrl_reset(ctrl->catalog);
+
+	/*
+	 * all dp controller programmable registers will not
+	 * be reset to default value after DP_SW_RESET
+	 * therefore interrupt mask bits have to be updated
+	 * to enable/disable interrupts
+	 */
+	dp_catalog_ctrl_enable_irq(ctrl->catalog, enable);
+}
+
+void dp_ctrl_phy_init(struct dp_ctrl *dp_ctrl)
 {
 	struct dp_ctrl_private *ctrl;
 	struct dp_io *dp_io;
 	struct phy *phy;
 
-	if (!dp_ctrl) {
-		DRM_ERROR("Invalid input data\n");
-		return -EINVAL;
-	}
-
 	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
 	dp_io = &ctrl->parser->io;
 	phy = dp_io->phy;
 
-	ctrl->dp_ctrl.orientation = flip;
-
-	if (reset)
-		dp_catalog_ctrl_reset(ctrl->catalog);
-
-	DRM_DEBUG_DP("flip=%d\n", flip);
 	dp_catalog_ctrl_phy_reset(ctrl->catalog);
 	phy_init(phy);
-	dp_catalog_ctrl_enable_irq(ctrl->catalog, true);
-
-	return 0;
 }
 
-/**
- * dp_ctrl_host_deinit() - Uninitialize DP controller
- * @dp_ctrl: Display Port Driver data
- *
- * Perform required steps to uninitialize DP controller
- * and its resources.
- */
-void dp_ctrl_host_deinit(struct dp_ctrl *dp_ctrl)
+void dp_ctrl_phy_exit(struct dp_ctrl *dp_ctrl)
 {
 	struct dp_ctrl_private *ctrl;
 	struct dp_io *dp_io;
 	struct phy *phy;
 
-	if (!dp_ctrl) {
-		DRM_ERROR("Invalid input data\n");
-		return;
-	}
-
 	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
 	dp_io = &ctrl->parser->io;
 	phy = dp_io->phy;
 
-	dp_catalog_ctrl_enable_irq(ctrl->catalog, false);
+	dp_catalog_ctrl_phy_reset(ctrl->catalog);
 	phy_exit(phy);
-
-	DRM_DEBUG_DP("Host deinitialized successfully\n");
 }
 
 static bool dp_ctrl_use_fixed_nvid(struct dp_ctrl_private *ctrl)
@@ -1471,7 +1460,10 @@ static int dp_ctrl_deinitialize_mainlink(struct dp_ctrl_private *ctrl)
 	}
 
 	phy_power_off(phy);
+
+	/* aux channel down, reinit phy */
 	phy_exit(phy);
+	phy_init(phy);
 
 	return 0;
 }
@@ -1501,6 +1493,8 @@ static int dp_ctrl_link_maintenance(struct dp_ctrl_private *ctrl)
 	return ret;
 }
 
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl);
+
 static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 {
 	int ret = 0;
@@ -1523,7 +1517,7 @@ static int dp_ctrl_process_phy_test_request(struct dp_ctrl_private *ctrl)
 
 	ret = dp_ctrl_on_link(&ctrl->dp_ctrl);
 	if (!ret)
-		ret = dp_ctrl_on_stream(&ctrl->dp_ctrl);
+		ret = dp_ctrl_on_stream_phy_test_report(&ctrl->dp_ctrl);
 	else
 		DRM_ERROR("failed to enable DP link controller\n");
 
@@ -1778,7 +1772,27 @@ static int dp_ctrl_link_retrain(struct dp_ctrl_private *ctrl)
 	return dp_ctrl_setup_main_link(ctrl, &training_step);
 }
 
-int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
+static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl)
+{
+	int ret;
+	struct dp_ctrl_private *ctrl;
+
+	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
+
+	ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
+
+	ret = dp_ctrl_enable_stream_clocks(ctrl);
+	if (ret) {
+		DRM_ERROR("Failed to start pixel clocks. ret=%d\n", ret);
+		return ret;
+	}
+
+	dp_ctrl_send_phy_test_pattern(ctrl);
+
+	return 0;
+}
+
+int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train)
 {
 	int ret = 0;
 	bool mainlink_ready = false;
@@ -1809,12 +1823,7 @@ int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl)
 		goto end;
 	}
 
-	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN) {
-		dp_ctrl_send_phy_test_pattern(ctrl);
-		return 0;
-	}
-
-	if (!dp_ctrl_channel_eq_ok(ctrl))
+	if (force_link_train || !dp_ctrl_channel_eq_ok(ctrl))
 		dp_ctrl_link_retrain(ctrl);
 
 	/* stop txing train pattern to end link training */
@@ -1877,8 +1886,14 @@ int dp_ctrl_off_link_stream(struct dp_ctrl *dp_ctrl)
 		return ret;
 	}
 
+	DRM_DEBUG_DP("Before, phy=%x init_count=%d power_on=%d\n",
+		(u32)(uintptr_t)phy, phy->init_count, phy->power_count);
+
 	phy_power_off(phy);
 
+	DRM_DEBUG_DP("After, phy=%x init_count=%d power_on=%d\n",
+		(u32)(uintptr_t)phy, phy->init_count, phy->power_count);
+
 	/* aux channel down, reinit phy */
 	phy_exit(phy);
 	phy_init(phy);
@@ -1887,23 +1902,6 @@ int dp_ctrl_off_link_stream(struct dp_ctrl *dp_ctrl)
 	return ret;
 }
 
-void dp_ctrl_off_phy(struct dp_ctrl *dp_ctrl)
-{
-	struct dp_ctrl_private *ctrl;
-	struct dp_io *dp_io;
-	struct phy *phy;
-
-	ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
-	dp_io = &ctrl->parser->io;
-	phy = dp_io->phy;
-
-	dp_catalog_ctrl_reset(ctrl->catalog);
-
-	phy_exit(phy);
-
-	DRM_DEBUG_DP("DP off phy done\n");
-}
-
 int dp_ctrl_off(struct dp_ctrl *dp_ctrl)
 {
 	struct dp_ctrl_private *ctrl;
@@ -1931,10 +1929,14 @@ int dp_ctrl_off(struct dp_ctrl *dp_ctrl)
 		DRM_ERROR("Failed to disable link clocks. ret=%d\n", ret);
 	}
 
+	DRM_DEBUG_DP("Before, phy=%x init_count=%d power_on=%d\n",
+		(u32)(uintptr_t)phy, phy->init_count, phy->power_count);
+
 	phy_power_off(phy);
-	phy_exit(phy);
 
-	DRM_DEBUG_DP("DP off done\n");
+	DRM_DEBUG_DP("After, phy=%x init_count=%d power_on=%d\n",
+		(u32)(uintptr_t)phy, phy->init_count, phy->power_count);
+
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.h b/drivers/gpu/drm/msm/dp/dp_ctrl.h
index 2363a2df9597..dcc7af21a5f0 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.h
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.h
@@ -19,12 +19,9 @@ struct dp_ctrl {
 	u32 pixel_rate;
 };
 
-int dp_ctrl_host_init(struct dp_ctrl *dp_ctrl, bool flip, bool reset);
-void dp_ctrl_host_deinit(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl);
-int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl);
+int dp_ctrl_on_stream(struct dp_ctrl *dp_ctrl, bool force_link_train);
 int dp_ctrl_off_link_stream(struct dp_ctrl *dp_ctrl);
-void dp_ctrl_off_phy(struct dp_ctrl *dp_ctrl);
 int dp_ctrl_off(struct dp_ctrl *dp_ctrl);
 void dp_ctrl_push_idle(struct dp_ctrl *dp_ctrl);
 void dp_ctrl_isr(struct dp_ctrl *dp_ctrl);
@@ -34,4 +31,9 @@ struct dp_ctrl *dp_ctrl_get(struct device *dev, struct dp_link *link,
 			struct dp_power *power, struct dp_catalog *catalog,
 			struct dp_parser *parser);
 
+void dp_ctrl_reset_irq_ctrl(struct dp_ctrl *dp_ctrl, bool enable);
+void dp_ctrl_phy_init(struct dp_ctrl *dp_ctrl);
+void dp_ctrl_phy_exit(struct dp_ctrl *dp_ctrl);
+void dp_ctrl_irq_phy_exit(struct dp_ctrl *dp_ctrl);
+
 #endif /* _DP_CTRL_H_ */
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 7b624191abf1..b141ccb527b0 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -81,6 +81,7 @@ struct dp_display_private {
 
 	/* state variables */
 	bool core_initialized;
+	bool phy_initialized;
 	bool hpd_irq_on;
 	bool audio_supported;
 
@@ -260,7 +261,8 @@ static void dp_display_unbind(struct device *dev, struct device *master,
 			struct dp_display_private, dp_display);
 
 	/* disable all HPD interrupts */
-	dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_INT_MASK, false);
+	if (dp->core_initialized)
+		dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_INT_MASK, false);
 
 	kthread_stop(dp->ev_tsk);
 
@@ -361,36 +363,45 @@ static int dp_display_process_hpd_high(struct dp_display_private *dp)
 	return rc;
 }
 
-static void dp_display_host_init(struct dp_display_private *dp, int reset)
+static void dp_display_host_phy_init(struct dp_display_private *dp)
 {
-	bool flip = false;
+	DRM_DEBUG_DP("core_init=%d phy_init=%d\n",
+			dp->core_initialized, dp->phy_initialized);
 
-	DRM_DEBUG_DP("core_initialized=%d\n", dp->core_initialized);
-	if (dp->core_initialized) {
-		DRM_DEBUG_DP("DP core already initialized\n");
-		return;
+	if (!dp->phy_initialized) {
+		dp_ctrl_phy_init(dp->ctrl);
+		dp->phy_initialized = true;
+	}
+}
+
+static void dp_display_host_phy_exit(struct dp_display_private *dp)
+{
+	DRM_DEBUG_DP("core_init=%d phy_init=%d\n",
+			dp->core_initialized, dp->phy_initialized);
+
+	if (dp->phy_initialized) {
+		dp_ctrl_phy_exit(dp->ctrl);
+		dp->phy_initialized = false;
 	}
+}
 
-	if (dp->usbpd->orientation == ORIENTATION_CC2)
-		flip = true;
+static void dp_display_host_init(struct dp_display_private *dp)
+{
+	DRM_DEBUG_DP("core_initialized=%d\n", dp->core_initialized);
 
-	dp_power_init(dp->power, flip);
-	dp_ctrl_host_init(dp->ctrl, flip, reset);
+	dp_power_init(dp->power, false);
+	dp_ctrl_reset_irq_ctrl(dp->ctrl, true);
 	dp_aux_init(dp->aux);
 	dp->core_initialized = true;
 }
 
 static void dp_display_host_deinit(struct dp_display_private *dp)
 {
-	if (!dp->core_initialized) {
-		DRM_DEBUG_DP("DP core not initialized\n");
-		return;
-	}
+	DRM_DEBUG_DP("core_initialized=%d\n", dp->core_initialized);
 
-	dp_ctrl_host_deinit(dp->ctrl);
+	dp_ctrl_reset_irq_ctrl(dp->ctrl, false);
 	dp_aux_deinit(dp->aux);
 	dp_power_deinit(dp->power);
-
 	dp->core_initialized = false;
 }
 
@@ -408,7 +419,7 @@ static int dp_display_usbpd_configure_cb(struct device *dev)
 	dp = container_of(g_dp_display,
 			struct dp_display_private, dp_display);
 
-	dp_display_host_init(dp, false);
+	dp_display_host_phy_init(dp);
 
 	rc = dp_display_process_hpd_high(dp);
 end:
@@ -546,17 +557,9 @@ static int dp_hpd_plug_handle(struct dp_display_private *dp, u32 data)
 
 	dp->hpd_state = ST_CONNECT_PENDING;
 
-	hpd->hpd_high = 1;
-
 	ret = dp_display_usbpd_configure_cb(&dp->pdev->dev);
 	if (ret) {	/* link train failed */
-		hpd->hpd_high = 0;
 		dp->hpd_state = ST_DISCONNECTED;
-
-		if (ret == -ECONNRESET) { /* cable unplugged */
-			dp->core_initialized = false;
-		}
-
 	} else {
 		/* start sentinel checking in case of missing uevent */
 		dp_add_event(dp, EV_CONNECT_PENDING_TIMEOUT, 0, tout);
@@ -626,9 +629,7 @@ static int dp_hpd_unplug_handle(struct dp_display_private *dp, u32 data)
 	if (state == ST_DISCONNECTED) {
 		/* triggered by irq_hdp with sink_count = 0 */
 		if (dp->link->sink_count == 0) {
-			dp_ctrl_off_phy(dp->ctrl);
-			hpd->hpd_high = 0;
-			dp->core_initialized = false;
+			dp_display_host_phy_exit(dp);
 		}
 		mutex_unlock(&dp->event_mutex);
 		return 0;
@@ -651,8 +652,6 @@ static int dp_hpd_unplug_handle(struct dp_display_private *dp, u32 data)
 	/* disable HPD plug interrupts */
 	dp_catalog_hpd_config_intr(dp->catalog, DP_DP_HPD_PLUG_INT_MASK, false);
 
-	hpd->hpd_high = 0;
-
 	/*
 	 * We don't need separate work for disconnect as
 	 * connect/attention interrupts are disabled
@@ -692,7 +691,6 @@ static int dp_disconnect_pending_timeout(struct dp_display_private *dp, u32 data
 static int dp_irq_hpd_handle(struct dp_display_private *dp, u32 data)
 {
 	u32 state;
-	int ret;
 
 	mutex_lock(&dp->event_mutex);
 
@@ -717,10 +715,8 @@ static int dp_irq_hpd_handle(struct dp_display_private *dp, u32 data)
 		return 0;
 	}
 
-	ret = dp_display_usbpd_attention_cb(&dp->pdev->dev);
-	if (ret == -ECONNRESET) { /* cable unplugged */
-		dp->core_initialized = false;
-	}
+	dp_display_usbpd_attention_cb(&dp->pdev->dev);
+
 	DRM_DEBUG_DP("hpd_state=%d\n", state);
 
 	mutex_unlock(&dp->event_mutex);
@@ -869,7 +865,7 @@ static int dp_display_enable(struct dp_display_private *dp, u32 data)
 		return 0;
 	}
 
-	rc = dp_ctrl_on_stream(dp->ctrl);
+	rc = dp_ctrl_on_stream(dp->ctrl, data);
 	if (!rc)
 		dp_display->power_on = true;
 
@@ -915,12 +911,19 @@ static int dp_display_disable(struct dp_display_private *dp, u32 data)
 
 	dp_display->audio_enabled = false;
 
-	/* triggered by irq_hpd with sink_count = 0 */
 	if (dp->link->sink_count == 0) {
+		/*
+		 * irq_hpd with sink_count = 0
+		 * hdmi unplugged out of dongle
+		 */
 		dp_ctrl_off_link_stream(dp->ctrl);
 	} else {
+		/*
+		 * unplugged interrupt
+		 * dongle unplugged out of DUT
+		 */
 		dp_ctrl_off(dp->ctrl);
-		dp->core_initialized = false;
+		dp_display_host_phy_exit(dp);
 	}
 
 	dp_display->power_on = false;
@@ -1050,7 +1053,7 @@ void msm_dp_snapshot(struct msm_disp_state *disp_state, struct msm_dp *dp)
 static void dp_display_config_hpd(struct dp_display_private *dp)
 {
 
-	dp_display_host_init(dp, true);
+	dp_display_host_init(dp);
 	dp_catalog_ctrl_hpd_config(dp->catalog);
 
 	/* Enable interrupt first time
@@ -1317,20 +1320,23 @@ static int dp_pm_resume(struct device *dev)
 	dp->hpd_state = ST_DISCONNECTED;
 
 	/* turn on dp ctrl/phy */
-	dp_display_host_init(dp, true);
+	dp_display_host_init(dp);
 
 	dp_catalog_ctrl_hpd_config(dp->catalog);
 
-	/*
-	 * set sink to normal operation mode -- D0
-	 * before dpcd read
-	 */
-	dp_link_psm_config(dp->link, &dp->panel->link_info, false);
 
 	if (dp_catalog_link_is_connected(dp->catalog)) {
+		/*
+		 * set sink to normal operation mode -- D0
+		 * before dpcd read
+		 */
+		dp_display_host_phy_init(dp);
+		dp_link_psm_config(dp->link, &dp->panel->link_info, false);
 		sink_count = drm_dp_read_sink_count(dp->aux);
 		if (sink_count < 0)
 			sink_count = 0;
+
+		dp_display_host_phy_exit(dp);
 	}
 
 	dp->link->sink_count = sink_count;
@@ -1369,18 +1375,16 @@ static int dp_pm_suspend(struct device *dev)
 	DRM_DEBUG_DP("Before, core_inited=%d power_on=%d\n",
 			dp->core_initialized, dp_display->power_on);
 
-	if (dp->core_initialized == true) {
-		/* mainlink enabled */
-		if (dp_power_clk_status(dp->power, DP_CTRL_PM))
-			dp_ctrl_off_link_stream(dp->ctrl);
+	/* mainlink enabled */
+	if (dp_power_clk_status(dp->power, DP_CTRL_PM))
+		dp_ctrl_off_link_stream(dp->ctrl);
 
-		dp_display_host_deinit(dp);
-	}
-
-	dp->hpd_state = ST_SUSPENDED;
+	dp_display_host_phy_exit(dp);
 
 	/* host_init will be called at pm_resume */
-	dp->core_initialized = false;
+	dp_display_host_deinit(dp);
+
+	dp->hpd_state = ST_SUSPENDED;
 
 	DRM_DEBUG_DP("After, core_inited=%d power_on=%d\n",
 			dp->core_initialized, dp_display->power_on);
@@ -1508,6 +1512,7 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 	int rc = 0;
 	struct dp_display_private *dp_display;
 	u32 state;
+	bool force_link_train = false;
 
 	dp_display = container_of(dp, struct dp_display_private, dp_display);
 	if (!dp_display->dp_mode.drm_mode.clock) {
@@ -1536,10 +1541,12 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 
 	state =  dp_display->hpd_state;
 
-	if (state == ST_DISPLAY_OFF)
-		dp_display_host_init(dp_display, true);
+	if (state == ST_DISPLAY_OFF) {
+		dp_display_host_phy_init(dp_display);
+		force_link_train = true;
+	}
 
-	dp_display_enable(dp_display, 0);
+	dp_display_enable(dp_display, force_link_train);
 
 	rc = dp_display_post_enable(dp);
 	if (rc) {
@@ -1548,10 +1555,6 @@ int msm_dp_display_enable(struct msm_dp *dp, struct drm_encoder *encoder)
 		dp_display_unprepare(dp);
 	}
 
-	/* manual kick off plug event to train link */
-	if (state == ST_DISPLAY_OFF)
-		dp_add_event(dp_display, EV_IRQ_HPD_INT, 0, 0);
-
 	/* completed connection */
 	dp_display->hpd_state = ST_CONNECTED;
 
diff --git a/drivers/gpu/drm/msm/dp/dp_hpd.c b/drivers/gpu/drm/msm/dp/dp_hpd.c
index e1c90fa47411..db98a1d431eb 100644
--- a/drivers/gpu/drm/msm/dp/dp_hpd.c
+++ b/drivers/gpu/drm/msm/dp/dp_hpd.c
@@ -32,8 +32,6 @@ int dp_hpd_connect(struct dp_usbpd *dp_usbpd, bool hpd)
 	hpd_priv = container_of(dp_usbpd, struct dp_hpd_private,
 					dp_usbpd);
 
-	dp_usbpd->hpd_high = hpd;
-
 	if (!hpd_priv->dp_cb || !hpd_priv->dp_cb->configure
 				|| !hpd_priv->dp_cb->disconnect) {
 		pr_err("hpd dp_cb not initialized\n");
diff --git a/drivers/gpu/drm/msm/dp/dp_hpd.h b/drivers/gpu/drm/msm/dp/dp_hpd.h
index 5bc5bb64680f..8feec5aa5027 100644
--- a/drivers/gpu/drm/msm/dp/dp_hpd.h
+++ b/drivers/gpu/drm/msm/dp/dp_hpd.h
@@ -26,7 +26,6 @@ enum plug_orientation {
  * @multi_func: multi-function preferred
  * @usb_config_req: request to switch to usb
  * @exit_dp_mode: request exit from displayport mode
- * @hpd_high: Hot Plug Detect signal is high.
  * @hpd_irq: Change in the status since last message
  * @alt_mode_cfg_done: bool to specify alt mode status
  * @debug_en: bool to specify debug mode
@@ -39,7 +38,6 @@ struct dp_usbpd {
 	bool multi_func;
 	bool usb_config_req;
 	bool exit_dp_mode;
-	bool hpd_high;
 	bool hpd_irq;
 	bool alt_mode_cfg_done;
 	bool debug_en;
diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index a5bdfc5029de..d4d31e5bda07 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -737,18 +737,25 @@ static int dp_link_parse_sink_count(struct dp_link *dp_link)
 	return 0;
 }
 
-static void dp_link_parse_sink_status_field(struct dp_link_private *link)
+static int dp_link_parse_sink_status_field(struct dp_link_private *link)
 {
 	int len = 0;
 
 	link->prev_sink_count = link->dp_link.sink_count;
-	dp_link_parse_sink_count(&link->dp_link);
+	len = dp_link_parse_sink_count(&link->dp_link);
+	if (len < 0) {
+		DRM_ERROR("DP parse sink count failed\n");
+		return len;
+	}
 
 	len = drm_dp_dpcd_read_link_status(link->aux,
 		link->link_status);
-	if (len < DP_LINK_STATUS_SIZE)
+	if (len < DP_LINK_STATUS_SIZE) {
 		DRM_ERROR("DP link status read failed\n");
-	dp_link_parse_request(link);
+		return len;
+	}
+
+	return dp_link_parse_request(link);
 }
 
 /**
@@ -1023,7 +1030,9 @@ int dp_link_process_request(struct dp_link *dp_link)
 
 	dp_link_reset_data(link);
 
-	dp_link_parse_sink_status_field(link);
+	ret = dp_link_parse_sink_status_field(link);
+	if (ret)
+		return ret;
 
 	if (link->request.test_requested == DP_TEST_LINK_EDID_READ) {
 		dp_link->sink_request |= DP_TEST_LINK_EDID_READ;
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 9712582886aa..916361c30d77 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1102,7 +1102,7 @@ static const struct drm_driver msm_driver = {
 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
 	.gem_prime_import_sg_table = msm_gem_prime_import_sg_table,
-	.gem_prime_mmap     = drm_gem_prime_mmap,
+	.gem_prime_mmap     = msm_gem_prime_mmap,
 #ifdef CONFIG_DEBUG_FS
 	.debugfs_init       = msm_debugfs_init,
 #endif
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index c552f0c3890c..bd5132bb9bde 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -298,6 +298,7 @@ unsigned long msm_gem_shrinker_shrink(struct drm_device *dev, unsigned long nr_t
 void msm_gem_shrinker_init(struct drm_device *dev);
 void msm_gem_shrinker_cleanup(struct drm_device *dev);
 
+int msm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma);
 struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj);
 int msm_gem_prime_vmap(struct drm_gem_object *obj, struct dma_buf_map *map);
 void msm_gem_prime_vunmap(struct drm_gem_object *obj, struct dma_buf_map *map);
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index 8a2d94bd5df2..02c70a0b2a03 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -11,6 +11,21 @@
 #include "msm_drv.h"
 #include "msm_gem.h"
 
+int msm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
+{
+	int ret;
+
+	/* Ensure the mmap offset is initialized.  We lazily initialize it,
+	 * so if it has not been first mmap'd directly as a GEM object, the
+	 * mmap offset will not be already initialized.
+	 */
+	ret = drm_gem_create_mmap_offset(obj);
+	if (ret)
+		return ret;
+
+	return drm_gem_prime_mmap(obj, vma);
+}
+
 struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj)
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 2c46cd968ac4..b01d0a521c90 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -658,7 +658,6 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 	msm_submit_retire(submit);
 
 	pm_runtime_mark_last_busy(&gpu->pdev->dev);
-	pm_runtime_put_autosuspend(&gpu->pdev->dev);
 
 	spin_lock_irqsave(&ring->submit_lock, flags);
 	list_del(&submit->node);
@@ -672,6 +671,8 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 		msm_devfreq_idle(gpu);
 	mutex_unlock(&gpu->active_lock);
 
+	pm_runtime_put_autosuspend(&gpu->pdev->dev);
+
 	msm_gem_submit_put(submit);
 }
 
diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index bcaddbba564d..a54ed354578b 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -58,7 +58,7 @@ static int msm_iommu_pagetable_map(struct msm_mmu *mmu, u64 iova,
 	u64 addr = iova;
 	unsigned int i;
 
-	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+	for_each_sgtable_sg(sgt, sg, i) {
 		size_t size = sg->length;
 		phys_addr_t phys = sg_phys(sg);
 
diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 54dd562e294c..5b7061e2bca4 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -72,7 +72,6 @@ static int sun4i_drv_bind(struct device *dev)
 		goto free_drm;
 	}
 
-	dev_set_drvdata(dev, drm);
 	drm->dev_private = drv;
 	INIT_LIST_HEAD(&drv->frontend_list);
 	INIT_LIST_HEAD(&drv->engine_list);
@@ -113,6 +112,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 	drm_fbdev_generic_setup(drm, 32);
 
+	dev_set_drvdata(dev, drm);
+
 	return 0;
 
 finish_poll:
@@ -129,6 +130,7 @@ static void sun4i_drv_unbind(struct device *dev)
 {
 	struct drm_device *drm = dev_get_drvdata(dev);
 
+	dev_set_drvdata(dev, NULL);
 	drm_dev_unregister(drm);
 	drm_kms_helper_poll_fini(drm);
 	drm_atomic_helper_shutdown(drm);
diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 2edfcb4819b7..3a1f47c7288f 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -1006,11 +1006,12 @@ static int bma180_probe(struct i2c_client *client,
 
 		data->trig->ops = &bma180_trigger_ops;
 		iio_trigger_set_drvdata(data->trig, indio_dev);
-		indio_dev->trig = iio_trigger_get(data->trig);
 
 		ret = iio_trigger_register(data->trig);
 		if (ret)
 			goto err_trigger_free;
+
+		indio_dev->trig = iio_trigger_get(data->trig);
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index ba6c8ca488b1..594a383169c7 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1553,12 +1553,12 @@ static int kxcjk1013_probe(struct i2c_client *client,
 
 		data->dready_trig->ops = &kxcjk1013_trigger_ops;
 		iio_trigger_set_drvdata(data->dready_trig, indio_dev);
-		indio_dev->trig = data->dready_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = iio_trigger_register(data->dready_trig);
 		if (ret)
 			goto err_poweroff;
 
+		indio_dev->trig = iio_trigger_get(data->dready_trig);
+
 		data->motion_trig->ops = &kxcjk1013_trigger_ops;
 		iio_trigger_set_drvdata(data->motion_trig, indio_dev);
 		ret = iio_trigger_register(data->motion_trig);
diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 21a99467f364..373b59557afe 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1493,10 +1493,14 @@ static int mma8452_reset(struct i2c_client *client)
 	int i;
 	int ret;
 
-	ret = i2c_smbus_write_byte_data(client,	MMA8452_CTRL_REG2,
+	/*
+	 * Find on fxls8471, after config reset bit, it reset immediately,
+	 * and will not give ACK, so here do not check the return value.
+	 * The following code will read the reset register, and check whether
+	 * this reset works.
+	 */
+	i2c_smbus_write_byte_data(client, MMA8452_CTRL_REG2,
 					MMA8452_CTRL_REG2_RST);
-	if (ret < 0)
-		return ret;
 
 	for (i = 0; i < 10; i++) {
 		usleep_range(100, 200);
@@ -1539,11 +1543,13 @@ static int mma8452_probe(struct i2c_client *client,
 	mutex_init(&data->lock);
 
 	data->chip_info = device_get_match_data(&client->dev);
-	if (!data->chip_info && id) {
-		data->chip_info = &mma_chip_info_table[id->driver_data];
-	} else {
-		dev_err(&client->dev, "unknown device model\n");
-		return -ENODEV;
+	if (!data->chip_info) {
+		if (id) {
+			data->chip_info = &mma_chip_info_table[id->driver_data];
+		} else {
+			dev_err(&client->dev, "unknown device model\n");
+			return -ENODEV;
+		}
 	}
 
 	data->vdd_reg = devm_regulator_get(&client->dev, "vdd");
diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index b3afbf064915..df600d2917c0 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -456,8 +456,6 @@ static int mxc4005_probe(struct i2c_client *client,
 
 		data->dready_trig->ops = &mxc4005_trigger_ops;
 		iio_trigger_set_drvdata(data->dready_trig, indio_dev);
-		indio_dev->trig = data->dready_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = devm_iio_trigger_register(&client->dev,
 						data->dready_trig);
 		if (ret) {
@@ -465,6 +463,8 @@ static int mxc4005_probe(struct i2c_client *client,
 				"failed to register trigger\n");
 			return ret;
 		}
+
+		indio_dev->trig = iio_trigger_get(data->dready_trig);
 	}
 
 	return devm_iio_device_register(&client->dev, indio_dev);
diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index a73e3c2d212f..a9e655e69eaa 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -322,16 +322,19 @@ static struct adi_axi_adc_client *adi_axi_adc_attach_client(struct device *dev)
 
 		if (!try_module_get(cl->dev->driver->owner)) {
 			mutex_unlock(&registered_clients_lock);
+			of_node_put(cln);
 			return ERR_PTR(-ENODEV);
 		}
 
 		get_device(cl->dev);
 		cl->info = info;
 		mutex_unlock(&registered_clients_lock);
+		of_node_put(cln);
 		return cl;
 	}
 
 	mutex_unlock(&registered_clients_lock);
+	of_node_put(cln);
 
 	return ERR_PTR(-EPROBE_DEFER);
 }
diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index 5f5e8b39e4d2..84dbe9e2f0ef 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -196,6 +196,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Nuvision Solo 10 Draw */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "TMAX"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "TM101W610L"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{}
 };
 
diff --git a/drivers/iio/adc/rzg2l_adc.c b/drivers/iio/adc/rzg2l_adc.c
index 32fbf57c362f..2fa41b90bcfa 100644
--- a/drivers/iio/adc/rzg2l_adc.c
+++ b/drivers/iio/adc/rzg2l_adc.c
@@ -334,11 +334,15 @@ static int rzg2l_adc_parse_properties(struct platform_device *pdev, struct rzg2l
 	i = 0;
 	device_for_each_child_node(&pdev->dev, fwnode) {
 		ret = fwnode_property_read_u32(fwnode, "reg", &channel);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 
-		if (channel >= RZG2L_ADC_MAX_CHANNELS)
+		if (channel >= RZG2L_ADC_MAX_CHANNELS) {
+			fwnode_handle_put(fwnode);
 			return -EINVAL;
+		}
 
 		chan_array[i].type = IIO_VOLTAGE;
 		chan_array[i].indexed = 1;
diff --git a/drivers/iio/adc/stm32-adc-core.c b/drivers/iio/adc/stm32-adc-core.c
index c088cb990193..42faca457ace 100644
--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -64,6 +64,7 @@ struct stm32_adc_priv;
  * @max_clk_rate_hz: maximum analog clock rate (Hz, from datasheet)
  * @has_syscfg: SYSCFG capability flags
  * @num_irqs:	number of interrupt lines
+ * @num_adcs:   maximum number of ADC instances in the common registers
  */
 struct stm32_adc_priv_cfg {
 	const struct stm32_adc_common_regs *regs;
@@ -71,6 +72,7 @@ struct stm32_adc_priv_cfg {
 	u32 max_clk_rate_hz;
 	unsigned int has_syscfg;
 	unsigned int num_irqs;
+	unsigned int num_adcs;
 };
 
 /**
@@ -352,7 +354,7 @@ static void stm32_adc_irq_handler(struct irq_desc *desc)
 	 * before invoking the interrupt handler (e.g. call ISR only for
 	 * IRQ-enabled ADCs).
 	 */
-	for (i = 0; i < priv->cfg->num_irqs; i++) {
+	for (i = 0; i < priv->cfg->num_adcs; i++) {
 		if ((status & priv->cfg->regs->eoc_msk[i] &&
 		     stm32_adc_eoc_enabled(priv, i)) ||
 		     (status & priv->cfg->regs->ovr_msk[i]))
@@ -796,6 +798,7 @@ static const struct stm32_adc_priv_cfg stm32f4_adc_priv_cfg = {
 	.clk_sel = stm32f4_adc_clk_sel,
 	.max_clk_rate_hz = 36000000,
 	.num_irqs = 1,
+	.num_adcs = 3,
 };
 
 static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
@@ -804,14 +807,16 @@ static const struct stm32_adc_priv_cfg stm32h7_adc_priv_cfg = {
 	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER,
 	.num_irqs = 1,
+	.num_adcs = 2,
 };
 
 static const struct stm32_adc_priv_cfg stm32mp1_adc_priv_cfg = {
 	.regs = &stm32h7_adc_common_regs,
 	.clk_sel = stm32h7_adc_clk_sel,
-	.max_clk_rate_hz = 40000000,
+	.max_clk_rate_hz = 36000000,
 	.has_syscfg = HAS_VBOOSTER | HAS_ANASWVDD,
 	.num_irqs = 2,
+	.num_adcs = 2,
 };
 
 static const struct of_device_id stm32_adc_of_match[] = {
diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index e3e75413b49e..ef5b54ed9661 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -1259,7 +1259,6 @@ static irqreturn_t stm32_adc_threaded_isr(int irq, void *data)
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
 
 	/* Check ovr status right now, as ovr mask should be already disabled */
 	if (status & regs->isr_ovr.mask) {
@@ -1274,11 +1273,6 @@ static irqreturn_t stm32_adc_threaded_isr(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
-	if (!(status & mask))
-		dev_err_ratelimited(&indio_dev->dev,
-				    "Unexpected IRQ: IER=0x%08x, ISR=0x%08x\n",
-				    mask, status);
-
 	return IRQ_NONE;
 }
 
@@ -1288,10 +1282,6 @@ static irqreturn_t stm32_adc_isr(int irq, void *data)
 	struct stm32_adc *adc = iio_priv(indio_dev);
 	const struct stm32_adc_regspec *regs = adc->cfg->regs;
 	u32 status = stm32_adc_readl(adc, regs->isr_eoc.reg);
-	u32 mask = stm32_adc_readl(adc, regs->ier_eoc.reg);
-
-	if (!(status & mask))
-		return IRQ_WAKE_THREAD;
 
 	if (status & regs->isr_ovr.mask) {
 		/*
diff --git a/drivers/iio/adc/ti-ads131e08.c b/drivers/iio/adc/ti-ads131e08.c
index 0c2025a22575..80a09817c119 100644
--- a/drivers/iio/adc/ti-ads131e08.c
+++ b/drivers/iio/adc/ti-ads131e08.c
@@ -739,7 +739,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 	device_for_each_child_node(dev, node) {
 		ret = fwnode_property_read_u32(node, "reg", &channel);
 		if (ret)
-			return ret;
+			goto err_child_out;
 
 		ret = fwnode_property_read_u32(node, "ti,gain", &tmp);
 		if (ret) {
@@ -747,7 +747,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 		} else {
 			ret = ads131e08_pga_gain_to_field_value(st, tmp);
 			if (ret < 0)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].pga_gain = tmp;
 		}
@@ -758,7 +758,7 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 		} else {
 			ret = ads131e08_validate_channel_mux(st, tmp);
 			if (ret)
-				return ret;
+				goto err_child_out;
 
 			channel_config[i].mux = tmp;
 		}
@@ -784,6 +784,10 @@ static int ads131e08_alloc_channels(struct iio_dev *indio_dev)
 	st->channel_config = channel_config;
 
 	return 0;
+
+err_child_out:
+	fwnode_handle_put(node);
+	return ret;
 }
 
 static void ads131e08_regulator_disable(void *data)
diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
index 271d73e420c4..cc28713b0dc8 100644
--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -148,7 +148,7 @@ static int rescale_configure_channel(struct device *dev,
 	chan->ext_info = rescale->ext_info;
 	chan->type = rescale->cfg->type;
 
-	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
+	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) &&
 	    iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE)) {
 		dev_info(dev, "using raw+scale source channel\n");
 	} else if (iio_channel_has_info(schan, IIO_CHAN_INFO_PROCESSED)) {
diff --git a/drivers/iio/chemical/ccs811.c b/drivers/iio/chemical/ccs811.c
index 847194fa1e46..80ef1aa9aae3 100644
--- a/drivers/iio/chemical/ccs811.c
+++ b/drivers/iio/chemical/ccs811.c
@@ -499,11 +499,11 @@ static int ccs811_probe(struct i2c_client *client,
 
 		data->drdy_trig->ops = &ccs811_trigger_ops;
 		iio_trigger_set_drvdata(data->drdy_trig, indio_dev);
-		indio_dev->trig = data->drdy_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = iio_trigger_register(data->drdy_trig);
 		if (ret)
 			goto err_poweroff;
+
+		indio_dev->trig = iio_trigger_get(data->drdy_trig);
 	}
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
diff --git a/drivers/iio/gyro/mpu3050-core.c b/drivers/iio/gyro/mpu3050-core.c
index 3225de1f023b..5311bee5475f 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -876,6 +876,7 @@ static int mpu3050_power_up(struct mpu3050 *mpu3050)
 	ret = regmap_update_bits(mpu3050->map, MPU3050_PWR_MGM,
 				 MPU3050_PWR_MGM_SLEEP, 0);
 	if (ret) {
+		regulator_bulk_disable(ARRAY_SIZE(mpu3050->regs), mpu3050->regs);
 		dev_err(mpu3050->dev, "error setting power mode\n");
 		return ret;
 	}
diff --git a/drivers/iio/humidity/hts221_buffer.c b/drivers/iio/humidity/hts221_buffer.c
index f29692b9d2db..66b32413cf5e 100644
--- a/drivers/iio/humidity/hts221_buffer.c
+++ b/drivers/iio/humidity/hts221_buffer.c
@@ -135,9 +135,12 @@ int hts221_allocate_trigger(struct iio_dev *iio_dev)
 
 	iio_trigger_set_drvdata(hw->trig, iio_dev);
 	hw->trig->ops = &hts221_trigger_ops;
+
+	err = devm_iio_trigger_register(hw->dev, hw->trig);
+
 	iio_dev->trig = iio_trigger_get(hw->trig);
 
-	return devm_iio_trigger_register(hw->dev, hw->trig);
+	return err;
 }
 
 static int hts221_buffer_preenable(struct iio_dev *iio_dev)
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600.h b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
index c0f5059b13b3..995a9dc06521 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -17,6 +17,7 @@
 #include "inv_icm42600_buffer.h"
 
 enum inv_icm42600_chip {
+	INV_CHIP_INVALID,
 	INV_CHIP_ICM42600,
 	INV_CHIP_ICM42602,
 	INV_CHIP_ICM42605,
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
index 86858da9cc38..ca85fccc9839 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -565,7 +565,7 @@ int inv_icm42600_core_probe(struct regmap *regmap, int chip, int irq,
 	bool open_drain;
 	int ret;
 
-	if (chip < 0 || chip >= INV_CHIP_NB) {
+	if (chip <= INV_CHIP_INVALID || chip >= INV_CHIP_NB) {
 		dev_err(dev, "invalid chip = %d\n", chip);
 		return -ENODEV;
 	}
diff --git a/drivers/iio/magnetometer/yamaha-yas530.c b/drivers/iio/magnetometer/yamaha-yas530.c
index 9ff7b0e56cf6..b2bc637150bf 100644
--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -639,7 +639,7 @@ static int yas532_get_calibration_data(struct yas5xx *yas5xx)
 	dev_dbg(yas5xx->dev, "calibration data: %*ph\n", 14, data);
 
 	/* Sanity check, is this all zeroes? */
-	if (memchr_inv(data, 0x00, 13)) {
+	if (memchr_inv(data, 0x00, 13) == NULL) {
 		if (!(data[13] & BIT(7)))
 			dev_warn(yas5xx->dev, "calibration is blank!\n");
 	}
diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index e9adfff45b39..bec9b94e088b 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -195,6 +195,7 @@ static int iio_sysfs_trigger_remove(int id)
 	}
 
 	iio_trigger_unregister(t->trig);
+	irq_work_sync(&t->work);
 	iio_trigger_free(t->trig);
 
 	list_del(&t->l);
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 2a78f6874143..a56df4536605 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1400,7 +1400,7 @@ static void start_worker(struct era *era)
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
-	flush_workqueue(era->wq);
+	drain_workqueue(era->wq);
 }
 
 /*----------------------------------------------------------------
@@ -1570,6 +1570,12 @@ static void era_postsuspend(struct dm_target *ti)
 	}
 
 	stop_worker(era);
+
+	r = metadata_commit(era->md);
+	if (r) {
+		DMERR("%s: metadata_commit failed", __func__);
+		/* FIXME: fail mode */
+	}
 }
 
 static int era_preresume(struct dm_target *ti)
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index ccdd65148498..b40741bedfd4 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -615,7 +615,7 @@ static int disk_resume(struct dm_dirty_log *log)
 			log_clear_bit(lc, lc->clean_bits, i);
 
 	/* clear any old bits -- device has shrunk */
-	for (i = lc->region_count; i % (sizeof(*lc->clean_bits) << BYTE_SHIFT); i++)
+	for (i = lc->region_count; i % BITS_PER_LONG; i++)
 		log_clear_bit(lc, lc->clean_bits, i);
 
 	/* copy clean across to sync */
diff --git a/drivers/memory/samsung/exynos5422-dmc.c b/drivers/memory/samsung/exynos5422-dmc.c
index 4733e7898ffe..c491cd549644 100644
--- a/drivers/memory/samsung/exynos5422-dmc.c
+++ b/drivers/memory/samsung/exynos5422-dmc.c
@@ -1187,33 +1187,39 @@ static int of_get_dram_timings(struct exynos5_dmc *dmc)
 
 	dmc->timing_row = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					     sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_row)
-		return -ENOMEM;
+	if (!dmc->timing_row) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timing_data = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					      sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_data)
-		return -ENOMEM;
+	if (!dmc->timing_data) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timing_power = devm_kmalloc_array(dmc->dev, TIMING_COUNT,
 					       sizeof(u32), GFP_KERNEL);
-	if (!dmc->timing_power)
-		return -ENOMEM;
+	if (!dmc->timing_power) {
+		ret = -ENOMEM;
+		goto put_node;
+	}
 
 	dmc->timings = of_lpddr3_get_ddr_timings(np_ddr, dmc->dev,
 						 DDR_TYPE_LPDDR3,
 						 &dmc->timings_arr_size);
 	if (!dmc->timings) {
-		of_node_put(np_ddr);
 		dev_warn(dmc->dev, "could not get timings from DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	dmc->min_tck = of_lpddr3_get_min_tck(np_ddr, dmc->dev);
 	if (!dmc->min_tck) {
-		of_node_put(np_ddr);
 		dev_warn(dmc->dev, "could not get tck from DT\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_node;
 	}
 
 	/* Sorted array of OPPs with frequency ascending */
@@ -1227,13 +1233,14 @@ static int of_get_dram_timings(struct exynos5_dmc *dmc)
 					     clk_period_ps);
 	}
 
-	of_node_put(np_ddr);
 
 	/* Take the highest frequency's timings as 'bypass' */
 	dmc->bypass_timing_row = dmc->timing_row[idx - 1];
 	dmc->bypass_timing_data = dmc->timing_data[idx - 1];
 	dmc->bypass_timing_power = dmc->timing_power[idx - 1];
 
+put_node:
+	of_node_put(np_ddr);
 	return ret;
 }
 
diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 1ac92015992e..f9b2897569bb 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -1355,7 +1355,7 @@ static void msdc_data_xfer_next(struct msdc_host *host, struct mmc_request *mrq)
 		msdc_request_done(host, mrq);
 }
 
-static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
+static void msdc_data_xfer_done(struct msdc_host *host, u32 events,
 				struct mmc_request *mrq, struct mmc_data *data)
 {
 	struct mmc_command *stop;
@@ -1375,7 +1375,7 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 	spin_unlock_irqrestore(&host->lock, flags);
 
 	if (done)
-		return true;
+		return;
 	stop = data->stop;
 
 	if (check_data || (stop && stop->error)) {
@@ -1384,12 +1384,15 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 		sdr_set_field(host->base + MSDC_DMA_CTRL, MSDC_DMA_CTRL_STOP,
 				1);
 
+		ret = readl_poll_timeout_atomic(host->base + MSDC_DMA_CTRL, val,
+						!(val & MSDC_DMA_CTRL_STOP), 1, 20000);
+		if (ret)
+			dev_dbg(host->dev, "DMA stop timed out\n");
+
 		ret = readl_poll_timeout_atomic(host->base + MSDC_DMA_CFG, val,
 						!(val & MSDC_DMA_CFG_STS), 1, 20000);
-		if (ret) {
-			dev_dbg(host->dev, "DMA stop timed out\n");
-			return false;
-		}
+		if (ret)
+			dev_dbg(host->dev, "DMA inactive timed out\n");
 
 		sdr_clr_bits(host->base + MSDC_INTEN, data_ints_mask);
 		dev_dbg(host->dev, "DMA stop\n");
@@ -1414,9 +1417,7 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 		}
 
 		msdc_data_xfer_next(host, mrq);
-		done = true;
 	}
-	return done;
 }
 
 static void msdc_set_buswidth(struct msdc_host *host, u32 width)
@@ -2347,6 +2348,9 @@ static void msdc_cqe_disable(struct mmc_host *mmc, bool recovery)
 	if (recovery) {
 		sdr_set_field(host->base + MSDC_DMA_CTRL,
 			      MSDC_DMA_CTRL_STOP, 1);
+		if (WARN_ON(readl_poll_timeout(host->base + MSDC_DMA_CTRL, val,
+			!(val & MSDC_DMA_CTRL_STOP), 1, 3000)))
+			return;
 		if (WARN_ON(readl_poll_timeout(host->base + MSDC_DMA_CFG, val,
 			!(val & MSDC_DMA_CFG_STS), 1, 3000)))
 			return;
diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
index 51d55a87aebe..059034e832c9 100644
--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -147,6 +147,8 @@ static int sdhci_o2_get_cd(struct mmc_host *mmc)
 
 	if (!(sdhci_readw(host, O2_PLL_DLL_WDT_CONTROL1) & O2_PLL_LOCK_STATUS))
 		sdhci_o2_enable_internal_clock(host);
+	else
+		sdhci_o2_wait_card_detect_stable(host);
 
 	return !!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT);
 }
diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index b72b387c08ef..6eb067777703 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -685,7 +685,7 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
 		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
-	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 4096);
+	hw->timing1 = BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeout_cycles, 4096));
 
 	/*
 	 * Derive NFC ideal delay from {3}:
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2e75b7e8f70b..cd0d7b24f014 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3474,9 +3474,11 @@ static void bond_activebackup_arp_mon(struct bonding *bond)
 		if (!rtnl_trylock())
 			return;
 
-		if (should_notify_peers)
+		if (should_notify_peers) {
+			bond->send_peer_notif--;
 			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
 						 bond->dev);
+		}
 		if (should_notify_rtnl) {
 			bond_slave_state_notify(bond);
 			bond_slave_link_notify(bond);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 19f115402969..982db894754f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2150,6 +2150,42 @@ ice_setup_autoneg(struct ice_port_info *p, struct ethtool_link_ksettings *ks,
 	return err;
 }
 
+/**
+ * ice_set_phy_type_from_speed - set phy_types based on speeds
+ * and advertised modes
+ * @ks: ethtool link ksettings struct
+ * @phy_type_low: pointer to the lower part of phy_type
+ * @phy_type_high: pointer to the higher part of phy_type
+ * @adv_link_speed: targeted link speeds bitmap
+ */
+static void
+ice_set_phy_type_from_speed(const struct ethtool_link_ksettings *ks,
+			    u64 *phy_type_low, u64 *phy_type_high,
+			    u16 adv_link_speed)
+{
+	/* Handle 1000M speed in a special way because ice_update_phy_type
+	 * enables all link modes, but having mixed copper and optical
+	 * standards is not supported.
+	 */
+	adv_link_speed &= ~ICE_AQ_LINK_SPEED_1000MB;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseT_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_T |
+				 ICE_PHY_TYPE_LOW_1G_SGMII;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseKX_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_KX;
+
+	if (ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  1000baseX_Full))
+		*phy_type_low |= ICE_PHY_TYPE_LOW_1000BASE_SX |
+				 ICE_PHY_TYPE_LOW_1000BASE_LX;
+
+	ice_update_phy_type(phy_type_low, phy_type_high, adv_link_speed);
+}
+
 /**
  * ice_set_link_ksettings - Set Speed and Duplex
  * @netdev: network interface device structure
@@ -2286,7 +2322,8 @@ ice_set_link_ksettings(struct net_device *netdev,
 		adv_link_speed = curr_link_speed;
 
 	/* Convert the advertise link speeds to their corresponded PHY_TYPE */
-	ice_update_phy_type(&phy_type_low, &phy_type_high, adv_link_speed);
+	ice_set_phy_type_from_speed(ks, &phy_type_low, &phy_type_high,
+				    adv_link_speed);
 
 	if (!autoneg_changed && adv_link_speed == curr_link_speed) {
 		netdev_info(netdev, "Nothing changed, exiting without setting anything.\n");
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b88303351484..db11a1c278f6 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4819,8 +4819,11 @@ static void igb_clean_tx_ring(struct igb_ring *tx_ring)
 	while (i != tx_ring->next_to_use) {
 		union e1000_adv_tx_desc *eop_desc, *tx_desc;
 
-		/* Free all the Tx ring sk_buffs */
-		dev_kfree_skb_any(tx_buffer->skb);
+		/* Free all the Tx ring sk_buffs or xdp frames */
+		if (tx_buffer->type == IGB_TYPE_SKB)
+			dev_kfree_skb_any(tx_buffer->skb);
+		else
+			xdp_return_frame(tx_buffer->xdpf);
 
 		/* unmap skb header data */
 		dma_unmap_single(tx_ring->dev,
@@ -9820,11 +9823,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 dmac_thr;
 	u16 hwm;
+	u32 reg;
 
 	if (hw->mac.type > e1000_82580) {
 		if (adapter->flags & IGB_FLAG_DMAC) {
-			u32 reg;
-
 			/* force threshold to 0. */
 			wr32(E1000_DMCTXTH, 0);
 
@@ -9857,7 +9859,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			/* Disable BMC-to-OS Watchdog Enable */
 			if (hw->mac.type != e1000_i354)
 				reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
-
 			wr32(E1000_DMACR, reg);
 
 			/* no lower threshold to disable
@@ -9874,12 +9875,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			 */
 			wr32(E1000_DMCTXTH, (IGB_MIN_TXPBSIZE -
 			     (IGB_TX_BUF_4096 + adapter->max_frame_size)) >> 6);
+		}
 
-			/* make low power state decision controlled
-			 * by DMA coal
-			 */
+		if (hw->mac.type >= e1000_i210 ||
+		    (adapter->flags & IGB_FLAG_DMAC)) {
 			reg = rd32(E1000_PCIEMISC);
-			reg &= ~E1000_PCIEMISC_LX_DECISION;
+			reg |= E1000_PCIEMISC_LX_DECISION;
 			wr32(E1000_PCIEMISC, reg);
 		} /* endif adapter->dmac is not disabled */
 	} else if (hw->mac.type == e1000_82580) {
diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 968dd43a2b1e..3221224525ac 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -34,6 +34,8 @@
 #define MDIO_AN_VEND_PROV			0xc400
 #define MDIO_AN_VEND_PROV_1000BASET_FULL	BIT(15)
 #define MDIO_AN_VEND_PROV_1000BASET_HALF	BIT(14)
+#define MDIO_AN_VEND_PROV_5000BASET_FULL	BIT(11)
+#define MDIO_AN_VEND_PROV_2500BASET_FULL	BIT(10)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_EN		BIT(4)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_MASK	GENMASK(3, 0)
 #define MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT	4
@@ -231,9 +233,20 @@ static int aqr_config_aneg(struct phy_device *phydev)
 			      phydev->advertising))
 		reg |= MDIO_AN_VEND_PROV_1000BASET_HALF;
 
+	/* Handle the case when the 2.5G and 5G speeds are not advertised */
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_2500BASET_FULL;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+			      phydev->advertising))
+		reg |= MDIO_AN_VEND_PROV_5000BASET_FULL;
+
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_VEND_PROV,
 				     MDIO_AN_VEND_PROV_1000BASET_HALF |
-				     MDIO_AN_VEND_PROV_1000BASET_FULL, reg);
+				     MDIO_AN_VEND_PROV_1000BASET_FULL |
+				     MDIO_AN_VEND_PROV_2500BASET_FULL |
+				     MDIO_AN_VEND_PROV_5000BASET_FULL, reg);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 73aba760e10c..468d0ffc266b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2431,7 +2431,6 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 static void virtnet_freeze_down(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int i;
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
@@ -2439,14 +2438,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	netif_tx_lock_bh(vi->dev);
 	netif_device_detach(vi->dev);
 	netif_tx_unlock_bh(vi->dev);
-	cancel_delayed_work_sync(&vi->refill);
-
-	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
-		}
-	}
+	if (netif_running(vi->dev))
+		virtnet_close(vi->dev);
 }
 
 static int init_vqs(struct virtnet_info *vi);
@@ -2454,7 +2447,7 @@ static int init_vqs(struct virtnet_info *vi);
 static int virtnet_restore_up(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int err, i;
+	int err;
 
 	err = init_vqs(vi);
 	if (err)
@@ -2463,15 +2456,9 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	virtio_device_ready(vdev);
 
 	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->curr_queue_pairs; i++)
-			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
-				schedule_delayed_work(&vi->refill, 0);
-
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
-			virtnet_napi_tx_enable(vi, vi->sq[i].vq,
-					       &vi->sq[i].napi);
-		}
+		err = virtnet_open(vi->dev);
+		if (err)
+			return err;
 	}
 
 	netif_tx_lock_bh(vi->dev);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9bc9f6d225bd..19054b791c67 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2475,6 +2475,34 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
 		.vid = 0x14a4,
 		.fr = "22301111",
 		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
+	},
+	{
+		/*
+		 * This Kioxia CD6-V Series / HPE PE8030 device times out and
+		 * aborts I/O during any load, but more easily reproducible
+		 * with discards (fstrim).
+		 *
+		 * The device is left in a state where it is also not possible
+		 * to use "nvme set-feature" to disable APST, but booting with
+		 * nvme_core.default_ps_max_latency=0 works.
+		 */
+		.vid = 0x1e0f,
+		.mn = "KCD6XVUL6T40",
+		.quirks = NVME_QUIRK_NO_APST,
+	},
+	{
+		/*
+		 * The external Samsung X5 SSD fails initialization without a
+		 * delay before checking if it is ready and has a whole set of
+		 * other problems.  To make this even more interesting, it
+		 * shares the PCI ID with internal Samsung 970 Evo Plus that
+		 * does not need or want these quirks.
+		 */
+		.vid = 0x144d,
+		.mn = "Samsung Portable SSD X5",
+		.quirks = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+			  NVME_QUIRK_NO_DEEPEST_PS |
+			  NVME_QUIRK_IGNORE_DEV_SUBNQN,
 	}
 };
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3ddd24a42043..58b8461b2b0f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3380,10 +3380,6 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS |
 				NVME_QUIRK_SKIP_CID_GEN },
-	{ PCI_DEVICE(0x144d, 0xa808),   /* Samsung X5 */
-		.driver_data =  NVME_QUIRK_DELAY_BEFORE_CHK_RDY|
-				NVME_QUIRK_NO_DEEPEST_PS |
-				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 01f79991bf4a..b3531065a438 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -160,8 +160,8 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *);
 static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
-static void ibmvfc_release_sub_crqs(struct ibmvfc_host *);
-static void ibmvfc_init_sub_crqs(struct ibmvfc_host *);
+static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *);
+static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *);
 
 static const char *unknown_error = "unknown error";
 
@@ -917,7 +917,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	unsigned long flags;
 
-	ibmvfc_release_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost);
 
 	/* Re-enable the CRQ */
 	do {
@@ -936,7 +936,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	ibmvfc_init_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost);
 
 	return rc;
 }
@@ -955,7 +955,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
-	ibmvfc_release_sub_crqs(vhost);
+	ibmvfc_dereg_sub_crqs(vhost);
 
 	/* Close the CRQ */
 	do {
@@ -988,7 +988,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	ibmvfc_init_sub_crqs(vhost);
+	ibmvfc_reg_sub_crqs(vhost);
 
 	return rc;
 }
@@ -5680,6 +5680,8 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	queue->cur = 0;
 	queue->fmt = fmt;
 	queue->size = PAGE_SIZE / fmt_size;
+
+	queue->vhost = vhost;
 	return 0;
 }
 
@@ -5755,9 +5757,6 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 
 	ENTER;
 
-	if (ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT))
-		return -ENOMEM;
-
 	rc = h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
 			   &scrq->cookie, &scrq->hw_irq);
 
@@ -5788,7 +5787,6 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 	}
 
 	scrq->hwq_id = index;
-	scrq->vhost = vhost;
 
 	LEAVE;
 	return 0;
@@ -5798,7 +5796,6 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
 	} while (rtas_busy_delay(rc));
 reg_failed:
-	ibmvfc_free_queue(vhost, scrq);
 	LEAVE;
 	return rc;
 }
@@ -5824,12 +5821,50 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 	if (rc)
 		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
 
-	ibmvfc_free_queue(vhost, scrq);
+	/* Clean out the queue */
+	memset(scrq->msgs.crq, 0, PAGE_SIZE);
+	scrq->cur = 0;
+
+	LEAVE;
+}
+
+static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost)
+{
+	int i, j;
+
+	ENTER;
+	if (!vhost->mq_enabled || !vhost->scsi_scrqs.scrqs)
+		return;
+
+	for (i = 0; i < nr_scsi_hw_queues; i++) {
+		if (ibmvfc_register_scsi_channel(vhost, i)) {
+			for (j = i; j > 0; j--)
+				ibmvfc_deregister_scsi_channel(vhost, j - 1);
+			vhost->do_enquiry = 0;
+			return;
+		}
+	}
+
+	LEAVE;
+}
+
+static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost)
+{
+	int i;
+
+	ENTER;
+	if (!vhost->mq_enabled || !vhost->scsi_scrqs.scrqs)
+		return;
+
+	for (i = 0; i < nr_scsi_hw_queues; i++)
+		ibmvfc_deregister_scsi_channel(vhost, i);
+
 	LEAVE;
 }
 
 static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
+	struct ibmvfc_queue *scrq;
 	int i, j;
 
 	ENTER;
@@ -5845,30 +5880,41 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 	}
 
 	for (i = 0; i < nr_scsi_hw_queues; i++) {
-		if (ibmvfc_register_scsi_channel(vhost, i)) {
-			for (j = i; j > 0; j--)
-				ibmvfc_deregister_scsi_channel(vhost, j - 1);
+		scrq = &vhost->scsi_scrqs.scrqs[i];
+		if (ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT)) {
+			for (j = i; j > 0; j--) {
+				scrq = &vhost->scsi_scrqs.scrqs[j - 1];
+				ibmvfc_free_queue(vhost, scrq);
+			}
 			kfree(vhost->scsi_scrqs.scrqs);
 			vhost->scsi_scrqs.scrqs = NULL;
 			vhost->scsi_scrqs.active_queues = 0;
 			vhost->do_enquiry = 0;
-			break;
+			vhost->mq_enabled = 0;
+			return;
 		}
 	}
 
+	ibmvfc_reg_sub_crqs(vhost);
+
 	LEAVE;
 }
 
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 {
+	struct ibmvfc_queue *scrq;
 	int i;
 
 	ENTER;
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
-	for (i = 0; i < nr_scsi_hw_queues; i++)
-		ibmvfc_deregister_scsi_channel(vhost, i);
+	ibmvfc_dereg_sub_crqs(vhost);
+
+	for (i = 0; i < nr_scsi_hw_queues; i++) {
+		scrq = &vhost->scsi_scrqs.scrqs[i];
+		ibmvfc_free_queue(vhost, scrq);
+	}
 
 	kfree(vhost->scsi_scrqs.scrqs);
 	vhost->scsi_scrqs.scrqs = NULL;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 3718406e0988..c39a245f43d0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -789,6 +789,7 @@ struct ibmvfc_queue {
 	spinlock_t _lock;
 	spinlock_t *q_lock;
 
+	struct ibmvfc_host *vhost;
 	struct ibmvfc_event_pool evt_pool;
 	struct list_head sent;
 	struct list_head free;
@@ -797,7 +798,6 @@ struct ibmvfc_queue {
 	union ibmvfc_iu cancel_rsp;
 
 	/* Sub-CRQ fields */
-	struct ibmvfc_host *vhost;
 	unsigned long cookie;
 	unsigned long vios_cookie;
 	unsigned long hw_irq;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cfeadd5f61f1..747e1cbb7ec9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2747,6 +2747,24 @@ static void zbc_open_zone(struct sdebug_dev_info *devip,
 	}
 }
 
+static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
+				     struct sdeb_zone_state *zsp)
+{
+	switch (zsp->z_cond) {
+	case ZC2_IMPLICIT_OPEN:
+		devip->nr_imp_open--;
+		break;
+	case ZC3_EXPLICIT_OPEN:
+		devip->nr_exp_open--;
+		break;
+	default:
+		WARN_ONCE(true, "Invalid zone %llu condition %x\n",
+			  zsp->z_start, zsp->z_cond);
+		break;
+	}
+	zsp->z_cond = ZC5_FULL;
+}
+
 static void zbc_inc_wp(struct sdebug_dev_info *devip,
 		       unsigned long long lba, unsigned int num)
 {
@@ -2759,7 +2777,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
 		zsp->z_wp += num;
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 		return;
 	}
 
@@ -2778,7 +2796,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 			n = num;
 		}
 		if (zsp->z_wp >= zend)
-			zsp->z_cond = ZC5_FULL;
+			zbc_set_zone_full(devip, zsp);
 
 		num -= n;
 		lba += n;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bcdfcb25349a..5947b9d5746e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -213,7 +213,12 @@ iscsi_create_endpoint(int dd_size)
 		return NULL;
 
 	mutex_lock(&iscsi_ep_idr_mutex);
-	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+
+	/*
+	 * First endpoint id should be 1 to comply with user space
+	 * applications (iscsid).
+	 */
+	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
 	if (id < 0) {
 		mutex_unlock(&iscsi_ep_idr_mutex);
 		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9eb1b88a29dd..71c7f7b435c4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1907,7 +1907,7 @@ static struct scsi_host_template scsi_driver = {
 	.cmd_per_lun =		2048,
 	.this_id =		-1,
 	/* Ensure there are no gaps in presented sgls */
-	.virt_boundary_mask =	PAGE_SIZE-1,
+	.virt_boundary_mask =	HV_HYP_PAGE_SIZE - 1,
 	.no_write_same =	1,
 	.track_queue_depth =	1,
 	.change_queue_depth =	storvsc_change_queue_depth,
@@ -1961,6 +1961,7 @@ static int storvsc_probe(struct hv_device *device,
 	int max_targets;
 	int max_channels;
 	int max_sub_channels = 0;
+	u32 max_xfer_bytes;
 
 	/*
 	 * Based on the windows host we are running on,
@@ -2049,12 +2050,28 @@ static int storvsc_probe(struct hv_device *device,
 	}
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
-
 	/*
-	 * set the table size based on the info we got
-	 * from the host.
+	 * Any reasonable Hyper-V configuration should provide
+	 * max_transfer_bytes value aligning to HV_HYP_PAGE_SIZE,
+	 * protecting it from any weird value.
+	 */
+	max_xfer_bytes = round_down(stor_device->max_transfer_bytes, HV_HYP_PAGE_SIZE);
+	/* max_hw_sectors_kb */
+	host->max_sectors = max_xfer_bytes >> 9;
+	/*
+	 * There are 2 requirements for Hyper-V storvsc sgl segments,
+	 * based on which the below calculation for max segments is
+	 * done:
+	 *
+	 * 1. Except for the first and last sgl segment, all sgl segments
+	 *    should be align to HV_HYP_PAGE_SIZE, that also means the
+	 *    maximum number of segments in a sgl can be calculated by
+	 *    dividing the total max transfer length by HV_HYP_PAGE_SIZE.
+	 *
+	 * 2. Except for the first and last, each entry in the SGL must
+	 *    have an offset that is a multiple of HV_HYP_PAGE_SIZE.
 	 */
-	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
+	host->sg_tablesize = (max_xfer_bytes >> HV_HYP_PAGE_SHIFT) + 1;
 	/*
 	 * For non-IDE disks, the host supports multiple channels.
 	 * Set the number of HW queues we are supporting.
diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index 3cbb165d6e30..70ad0f3dce28 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -783,6 +783,7 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	}
 
 	ret = brcmstb_init_sram(dn);
+	of_node_put(dn);
 	if (ret) {
 		pr_err("error setting up SRAM for PM\n");
 		return ret;
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 8834ca613721..aacc37736db6 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1040,6 +1040,9 @@ isr_setup_status_complete(struct usb_ep *ep, struct usb_request *req)
 	struct ci_hdrc *ci = req->context;
 	unsigned long flags;
 
+	if (req->status < 0)
+		return;
+
 	if (ci->setaddr) {
 		hw_usb_set_address(ci, ci->address);
 		ci->setaddr = false;
diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index 3427ce37a5c5..2869bda64229 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -11,6 +11,7 @@
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -36,6 +37,9 @@ MODULE_LICENSE("GPL");
 
 /*----------------------------------------------------------------------*/
 
+static DEFINE_IDA(driver_id_numbers);
+#define DRIVER_DRIVER_NAME_LENGTH_MAX	32
+
 #define RAW_EVENT_QUEUE_SIZE	16
 
 struct raw_event_queue {
@@ -161,6 +165,9 @@ struct raw_dev {
 	/* Reference to misc device: */
 	struct device			*dev;
 
+	/* Make driver names unique */
+	int				driver_id_number;
+
 	/* Protected by lock: */
 	enum dev_state			state;
 	bool				gadget_registered;
@@ -189,6 +196,7 @@ static struct raw_dev *dev_new(void)
 	spin_lock_init(&dev->lock);
 	init_completion(&dev->ep0_done);
 	raw_event_queue_init(&dev->queue);
+	dev->driver_id_number = -1;
 	return dev;
 }
 
@@ -199,6 +207,9 @@ static void dev_free(struct kref *kref)
 
 	kfree(dev->udc_name);
 	kfree(dev->driver.udc_name);
+	kfree(dev->driver.driver.name);
+	if (dev->driver_id_number >= 0)
+		ida_free(&driver_id_numbers, dev->driver_id_number);
 	if (dev->req) {
 		if (dev->ep0_urb_queued)
 			usb_ep_dequeue(dev->gadget->ep0, dev->req);
@@ -419,9 +430,11 @@ static int raw_release(struct inode *inode, struct file *fd)
 static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 {
 	int ret = 0;
+	int driver_id_number;
 	struct usb_raw_init arg;
 	char *udc_driver_name;
 	char *udc_device_name;
+	char *driver_driver_name;
 	unsigned long flags;
 
 	if (copy_from_user(&arg, (void __user *)value, sizeof(arg)))
@@ -440,36 +453,43 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 		return -EINVAL;
 	}
 
+	driver_id_number = ida_alloc(&driver_id_numbers, GFP_KERNEL);
+	if (driver_id_number < 0)
+		return driver_id_number;
+
+	driver_driver_name = kmalloc(DRIVER_DRIVER_NAME_LENGTH_MAX, GFP_KERNEL);
+	if (!driver_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_id_number;
+	}
+	snprintf(driver_driver_name, DRIVER_DRIVER_NAME_LENGTH_MAX,
+				DRIVER_NAME ".%d", driver_id_number);
+
 	udc_driver_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
-	if (!udc_driver_name)
-		return -ENOMEM;
+	if (!udc_driver_name) {
+		ret = -ENOMEM;
+		goto out_free_driver_driver_name;
+	}
 	ret = strscpy(udc_driver_name, &arg.driver_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_driver_name;
 	ret = 0;
 
 	udc_device_name = kmalloc(UDC_NAME_LENGTH_MAX, GFP_KERNEL);
 	if (!udc_device_name) {
-		kfree(udc_driver_name);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free_udc_driver_name;
 	}
 	ret = strscpy(udc_device_name, &arg.device_name[0],
 				UDC_NAME_LENGTH_MAX);
-	if (ret < 0) {
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_free_udc_device_name;
 	ret = 0;
 
 	spin_lock_irqsave(&dev->lock, flags);
 	if (dev->state != STATE_DEV_OPENED) {
 		dev_dbg(dev->dev, "fail, device is not opened\n");
-		kfree(udc_driver_name);
-		kfree(udc_device_name);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -484,14 +504,25 @@ static int raw_ioctl_init(struct raw_dev *dev, unsigned long value)
 	dev->driver.suspend = gadget_suspend;
 	dev->driver.resume = gadget_resume;
 	dev->driver.reset = gadget_reset;
-	dev->driver.driver.name = DRIVER_NAME;
+	dev->driver.driver.name = driver_driver_name;
 	dev->driver.udc_name = udc_device_name;
 	dev->driver.match_existing_only = 1;
+	dev->driver_id_number = driver_id_number;
 
 	dev->state = STATE_DEV_INITIALIZED;
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return ret;
 
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
+out_free_udc_device_name:
+	kfree(udc_device_name);
+out_free_udc_driver_name:
+	kfree(udc_driver_name);
+out_free_driver_driver_name:
+	kfree(driver_driver_name);
+out_free_driver_id_number:
+	ida_free(&driver_id_numbers, driver_id_number);
 	return ret;
 }
 
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index f65f1ba2b592..fc322a9526c8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -652,7 +652,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 	__must_hold(&xhci->lock)
 {
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 7d13ddff6b33..352626f9e451 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -61,6 +61,8 @@
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI		0x464e
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
+#define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI		0xa71e
+#define PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI		0x7ec0
 
 #define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
@@ -270,7 +272,9 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 90f5a3ce7c34..94fe7d64e762 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -774,6 +774,8 @@ static void xhci_stop(struct usb_hcd *hcd)
 void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	unsigned long flags;
+	int i;
 
 	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.sysdev));
@@ -789,12 +791,21 @@ void xhci_shutdown(struct usb_hcd *hcd)
 		del_timer_sync(&xhci->shared_hcd->rh_timer);
 	}
 
-	spin_lock_irq(&xhci->lock);
+	spin_lock_irqsave(&xhci->lock, flags);
 	xhci_halt(xhci);
+
+	/* Power off USB2 ports*/
+	for (i = 0; i < xhci->usb2_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->main_hcd, i, false, &flags);
+
+	/* Power off USB3 ports*/
+	for (i = 0; i < xhci->usb3_rhub.num_ports; i++)
+		xhci_set_port_power(xhci, xhci->shared_hcd, i, false, &flags);
+
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
-	spin_unlock_irq(&xhci->lock);
+	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	xhci_cleanup_msix(xhci);
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index bc0789229527..79fa34f1e31c 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2174,6 +2174,8 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
+			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ed1e50d83cca..de59fa919540 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -252,10 +252,12 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_EG95			0x0195
 #define QUECTEL_PRODUCT_BG96			0x0296
 #define QUECTEL_PRODUCT_EP06			0x0306
+#define QUECTEL_PRODUCT_EM05G			0x030a
 #define QUECTEL_PRODUCT_EM12			0x0512
 #define QUECTEL_PRODUCT_RM500Q			0x0800
 #define QUECTEL_PRODUCT_EC200S_CN		0x6002
 #define QUECTEL_PRODUCT_EC200T			0x6026
+#define QUECTEL_PRODUCT_RM500K			0x7001
 
 #define CMOTECH_VENDOR_ID			0x16d8
 #define CMOTECH_PRODUCT_6001			0x6001
@@ -1134,6 +1136,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0, 0) },
@@ -1147,6 +1151,7 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
 
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
@@ -1279,6 +1284,7 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1231, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x1250, 0xff, 0x00, 0x00) },	/* Telit LE910Cx (rmnet) */
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 3506c47e1eef..40b1ab3d284d 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -436,22 +436,27 @@ static int pl2303_detect_type(struct usb_serial *serial)
 		break;
 	case 0x200:
 		switch (bcdDevice) {
-		case 0x100:
+		case 0x100:	/* GC */
 		case 0x105:
+			return TYPE_HXN;
+		case 0x300:	/* GT / TA */
+			if (pl2303_supports_hx_status(serial))
+				return TYPE_TA;
+			fallthrough;
 		case 0x305:
+		case 0x400:	/* GL */
 		case 0x405:
+			return TYPE_HXN;
+		case 0x500:	/* GE / TB */
+			if (pl2303_supports_hx_status(serial))
+				return TYPE_TB;
+			fallthrough;
+		case 0x505:
+		case 0x600:	/* GS */
 		case 0x605:
-			/*
-			 * Assume it's an HXN-type if the device doesn't
-			 * support the old read request value.
-			 */
-			if (!pl2303_supports_hx_status(serial))
-				return TYPE_HXN;
-			break;
-		case 0x300:
-			return TYPE_TA;
-		case 0x500:
-			return TYPE_TB;
+		case 0x700:	/* GR */
+		case 0x705:
+			return TYPE_HXN;
 		}
 		break;
 	}
diff --git a/drivers/usb/typec/tcpm/Kconfig b/drivers/usb/typec/tcpm/Kconfig
index 557f392fe24d..073fd2ea5e0b 100644
--- a/drivers/usb/typec/tcpm/Kconfig
+++ b/drivers/usb/typec/tcpm/Kconfig
@@ -56,7 +56,6 @@ config TYPEC_WCOVE
 	tristate "Intel WhiskeyCove PMIC USB Type-C PHY driver"
 	depends on ACPI
 	depends on MFD_INTEL_PMC_BXT
-	depends on INTEL_SOC_PMIC
 	depends on BXT_WC_PMIC_OPREGION
 	help
 	  This driver adds support for USB Type-C on Intel Broxton platforms
diff --git a/drivers/video/console/sticore.c b/drivers/video/console/sticore.c
index 6a947ff96d6e..19fd3389946d 100644
--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -1127,6 +1127,7 @@ int sti_call(const struct sti_struct *sti, unsigned long func,
 	return ret;
 }
 
+#if defined(CONFIG_FB_STI)
 /* check if given fb_info is the primary device */
 int fb_is_primary_device(struct fb_info *info)
 {
@@ -1142,6 +1143,7 @@ int fb_is_primary_device(struct fb_info *info)
 	return (sti->info == info);
 }
 EXPORT_SYMBOL(fb_is_primary_device);
+#endif
 
 MODULE_AUTHOR("Philipp Rumpf, Helge Deller, Thomas Bogendoerfer");
 MODULE_DESCRIPTION("Core STI driver for HP's NGLE series graphics cards in HP PARISC machines");
diff --git a/drivers/xen/features.c b/drivers/xen/features.c
index 7b591443833c..87f1828d40d5 100644
--- a/drivers/xen/features.c
+++ b/drivers/xen/features.c
@@ -42,7 +42,7 @@ void xen_setup_features(void)
 		if (HYPERVISOR_xen_version(XENVER_get_features, &fi) < 0)
 			break;
 		for (j = 0; j < 32; j++)
-			xen_features[i * 32 + j] = !!(fi.submap & 1<<j);
+			xen_features[i * 32 + j] = !!(fi.submap & 1U << j);
 	}
 
 	if (xen_pv_domain()) {
diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 20d7d059dadb..40ef379c28ab 100644
--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -16,6 +16,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/types.h>
 #include <xen/interface/event_channel.h>
+#include <xen/grant_table.h>
 
 struct gntdev_dmabuf_priv;
 
@@ -56,6 +57,7 @@ struct gntdev_grant_map {
 	struct gnttab_unmap_grant_ref *unmap_ops;
 	struct gnttab_map_grant_ref   *kmap_ops;
 	struct gnttab_unmap_grant_ref *kunmap_ops;
+	bool *being_removed;
 	struct page **pages;
 	unsigned long pages_vm_start;
 
@@ -73,6 +75,11 @@ struct gntdev_grant_map {
 	/* Needed to avoid allocation in gnttab_dma_free_pages(). */
 	xen_pfn_t *frames;
 #endif
+
+	/* Number of live grants */
+	atomic_t live_grants;
+	/* Needed to avoid allocation in __unmap_grant_pages */
+	struct gntab_unmap_queue_data unmap_data;
 };
 
 struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 59ffea800079..4b56c39f766d 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -60,10 +61,11 @@ module_param(limit, uint, 0644);
 MODULE_PARM_DESC(limit,
 	"Maximum number of grants that may be mapped by one mapping request");
 
+/* True in PV mode, false otherwise */
 static int use_ptemod;
 
-static int unmap_grant_pages(struct gntdev_grant_map *map,
-			     int offset, int pages);
+static void unmap_grant_pages(struct gntdev_grant_map *map,
+			      int offset, int pages);
 
 static struct miscdevice gntdev_miscdev;
 
@@ -120,6 +122,7 @@ static void gntdev_free_map(struct gntdev_grant_map *map)
 	kvfree(map->unmap_ops);
 	kvfree(map->kmap_ops);
 	kvfree(map->kunmap_ops);
+	kvfree(map->being_removed);
 	kfree(map);
 }
 
@@ -140,10 +143,13 @@ struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
 	add->unmap_ops = kvmalloc_array(count, sizeof(add->unmap_ops[0]),
 					GFP_KERNEL);
 	add->pages     = kvcalloc(count, sizeof(add->pages[0]), GFP_KERNEL);
+	add->being_removed =
+		kvcalloc(count, sizeof(add->being_removed[0]), GFP_KERNEL);
 	if (NULL == add->grants    ||
 	    NULL == add->map_ops   ||
 	    NULL == add->unmap_ops ||
-	    NULL == add->pages)
+	    NULL == add->pages     ||
+	    NULL == add->being_removed)
 		goto err;
 	if (use_ptemod) {
 		add->kmap_ops   = kvmalloc_array(count, sizeof(add->kmap_ops[0]),
@@ -250,9 +256,36 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 	if (!refcount_dec_and_test(&map->users))
 		return;
 
-	if (map->pages && !use_ptemod)
+	if (map->pages && !use_ptemod) {
+		/*
+		 * Increment the reference count.  This ensures that the
+		 * subsequent call to unmap_grant_pages() will not wind up
+		 * re-entering itself.  It *can* wind up calling
+		 * gntdev_put_map() recursively, but such calls will be with a
+		 * reference count greater than 1, so they will return before
+		 * this code is reached.  The recursion depth is thus limited to
+		 * 1.  Do NOT use refcount_inc() here, as it will detect that
+		 * the reference count is zero and WARN().
+		 */
+		refcount_set(&map->users, 1);
+
+		/*
+		 * Unmap the grants.  This may or may not be asynchronous, so it
+		 * is possible that the reference count is 1 on return, but it
+		 * could also be greater than 1.
+		 */
 		unmap_grant_pages(map, 0, map->count);
 
+		/* Check if the memory now needs to be freed */
+		if (!refcount_dec_and_test(&map->users))
+			return;
+
+		/*
+		 * All pages have been returned to the hypervisor, so free the
+		 * map.
+		 */
+	}
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
@@ -283,6 +316,7 @@ static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 
 int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 {
+	size_t alloced = 0;
 	int i, err = 0;
 
 	if (!use_ptemod) {
@@ -331,97 +365,116 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 			map->count);
 
 	for (i = 0; i < map->count; i++) {
-		if (map->map_ops[i].status == GNTST_okay)
+		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-		else if (!err)
+			if (!use_ptemod)
+				alloced++;
+		} else if (!err)
 			err = -EINVAL;
 
 		if (map->flags & GNTMAP_device_map)
 			map->unmap_ops[i].dev_bus_addr = map->map_ops[i].dev_bus_addr;
 
 		if (use_ptemod) {
-			if (map->kmap_ops[i].status == GNTST_okay)
+			if (map->kmap_ops[i].status == GNTST_okay) {
+				if (map->map_ops[i].status == GNTST_okay)
+					alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
-			else if (!err)
+			} else if (!err)
 				err = -EINVAL;
 		}
 	}
+	atomic_add(alloced, &map->live_grants);
 	return err;
 }
 
-static int __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			       int pages)
+static void __unmap_grant_pages_done(int result,
+		struct gntab_unmap_queue_data *data)
 {
-	int i, err = 0;
-	struct gntab_unmap_queue_data unmap_data;
-
-	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
-		int pgno = (map->notify.addr >> PAGE_SHIFT);
-		if (pgno >= offset && pgno < offset + pages) {
-			/* No need for kmap, pages are in lowmem */
-			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
-			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
-			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
-		}
-	}
-
-	unmap_data.unmap_ops = map->unmap_ops + offset;
-	unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
-	unmap_data.pages = map->pages + offset;
-	unmap_data.count = pages;
-
-	err = gnttab_unmap_refs_sync(&unmap_data);
-	if (err)
-		return err;
+	unsigned int i;
+	struct gntdev_grant_map *map = data->data;
+	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
-	for (i = 0; i < pages; i++) {
-		if (map->unmap_ops[offset+i].status)
-			err = -EINVAL;
+	for (i = 0; i < data->count; i++) {
+		WARN_ON(map->unmap_ops[offset+i].status);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			if (map->kunmap_ops[offset+i].status)
-				err = -EINVAL;
+			WARN_ON(map->kunmap_ops[offset+i].status);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
 			map->kunmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		}
 	}
-	return err;
+	/*
+	 * Decrease the live-grant counter.  This must happen after the loop to
+	 * prevent premature reuse of the grants by gnttab_mmap().
+	 */
+	atomic_sub(data->count, &map->live_grants);
+
+	/* Release reference taken by __unmap_grant_pages */
+	gntdev_put_map(NULL, map);
+}
+
+static void __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			       int pages)
+{
+	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
+		int pgno = (map->notify.addr >> PAGE_SHIFT);
+
+		if (pgno >= offset && pgno < offset + pages) {
+			/* No need for kmap, pages are in lowmem */
+			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
+
+			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
+			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
+		}
+	}
+
+	map->unmap_data.unmap_ops = map->unmap_ops + offset;
+	map->unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
+	map->unmap_data.pages = map->pages + offset;
+	map->unmap_data.count = pages;
+	map->unmap_data.done = __unmap_grant_pages_done;
+	map->unmap_data.data = map;
+	refcount_inc(&map->users); /* to keep map alive during async call below */
+
+	gnttab_unmap_refs_async(&map->unmap_data);
 }
 
-static int unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			     int pages)
+static void unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			      int pages)
 {
-	int range, err = 0;
+	int range;
+
+	if (atomic_read(&map->live_grants) == 0)
+		return; /* Nothing to do */
 
 	pr_debug("unmap %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
 
 	/* It is possible the requested range will have a "hole" where we
 	 * already unmapped some of the grants. Only unmap valid ranges.
 	 */
-	while (pages && !err) {
-		while (pages &&
-		       map->unmap_ops[offset].handle == INVALID_GRANT_HANDLE) {
+	while (pages) {
+		while (pages && map->being_removed[offset]) {
 			offset++;
 			pages--;
 		}
 		range = 0;
 		while (range < pages) {
-			if (map->unmap_ops[offset + range].handle ==
-			    INVALID_GRANT_HANDLE)
+			if (map->being_removed[offset + range])
 				break;
+			map->being_removed[offset + range] = true;
 			range++;
 		}
-		err = __unmap_grant_pages(map, offset, range);
+		if (range)
+			__unmap_grant_pages(map, offset, range);
 		offset += range;
 		pages -= range;
 	}
-
-	return err;
 }
 
 /* ------------------------------------------------------------------ */
@@ -473,7 +526,6 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
-	int err;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -494,10 +546,9 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 			map->index, map->count,
 			map->vma->vm_start, map->vma->vm_end,
 			range->start, range->end, mstart, mend);
-	err = unmap_grant_pages(map,
+	unmap_grant_pages(map,
 				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
 				(mend - mstart) >> PAGE_SHIFT);
-	WARN_ON(err);
 
 	return true;
 }
@@ -985,6 +1036,10 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	if (use_ptemod && map->vma)
 		goto unlock_out;
+	if (atomic_read(&map->live_grants)) {
+		err = -EAGAIN;
+		goto unlock_out;
+	}
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index e8a3b891b036..c702a336837d 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -151,7 +151,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 	const unsigned char **wnames, *uname;
 	int i, n, l, clone, access;
 	struct v9fs_session_info *v9ses;
-	struct p9_fid *fid, *old_fid = NULL;
+	struct p9_fid *fid, *old_fid;
 
 	v9ses = v9fs_dentry2v9ses(dentry);
 	access = v9ses->flags & V9FS_ACCESS_MASK;
@@ -193,13 +193,12 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		if (IS_ERR(fid))
 			return fid;
 
+		refcount_inc(&fid->count);
 		v9fs_fid_add(dentry->d_sb->s_root, fid);
 	}
 	/* If we are root ourself just return that */
-	if (dentry->d_sb->s_root == dentry) {
-		refcount_inc(&fid->count);
+	if (dentry->d_sb->s_root == dentry)
 		return fid;
-	}
 	/*
 	 * Do a multipath walk with attached root.
 	 * When walking parent we need to make sure we
@@ -211,6 +210,7 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		fid = ERR_PTR(n);
 		goto err_out;
 	}
+	old_fid = fid;
 	clone = 1;
 	i = 0;
 	while (i < n) {
@@ -220,19 +220,15 @@ static struct p9_fid *v9fs_fid_lookup_with_uid(struct dentry *dentry,
 		 * walk to ensure none of the patch component change
 		 */
 		fid = p9_client_walk(fid, l, &wnames[i], clone);
+		/* non-cloning walk will return the same fid */
+		if (fid != old_fid) {
+			p9_client_clunk(old_fid);
+			old_fid = fid;
+		}
 		if (IS_ERR(fid)) {
-			if (old_fid) {
-				/*
-				 * If we fail, clunk fid which are mapping
-				 * to path component and not the last component
-				 * of the path.
-				 */
-				p9_client_clunk(old_fid);
-			}
 			kfree(wnames);
 			goto err_out;
 		}
-		old_fid = fid;
 		i += l;
 		clone = 0;
 	}
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 08f48b70a741..15d9492536cf 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1228,15 +1228,15 @@ static const char *v9fs_vfs_get_link(struct dentry *dentry,
 		return ERR_PTR(-ECHILD);
 
 	v9ses = v9fs_dentry2v9ses(dentry);
-	fid = v9fs_fid_lookup(dentry);
+	if (!v9fs_proto_dotu(v9ses))
+		return ERR_PTR(-EBADF);
+
 	p9_debug(P9_DEBUG_VFS, "%pd\n", dentry);
+	fid = v9fs_fid_lookup(dentry);
 
 	if (IS_ERR(fid))
 		return ERR_CAST(fid);
 
-	if (!v9fs_proto_dotu(v9ses))
-		return ERR_PTR(-EBADF);
-
 	st = p9_client_stat(fid);
 	p9_client_clunk(fid);
 	if (IS_ERR(st))
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a61df2e0ae52..833c638437a7 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -276,6 +276,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
+		p9_client_clunk(dfid);
 		goto out;
 	}
 
@@ -287,6 +288,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
@@ -294,6 +296,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	v9fs_invalidate_inode_attr(dir);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index a47666ba48f5..785bacb972da 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -733,7 +733,8 @@ int afs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
-	if (!(query_flags & AT_STATX_DONT_SYNC) &&
+	if (vnode->volume &&
+	    !(query_flags & AT_STATX_DONT_SYNC) &&
 	    !test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags)) {
 		key = afs_request_key(vnode->volume->cell);
 		if (IS_ERR(key))
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9ab279205527..233d894f6feb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4360,6 +4360,17 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	int ret;
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
+
+	/*
+	 * We may have the reclaim task running and relocating a data block group,
+	 * in which case it may create delayed iputs. So stop it before we park
+	 * the cleaner kthread otherwise we can get new delayed iputs after
+	 * parking the cleaner, and that can make the async reclaim task to hang
+	 * if it's waiting for delayed iputs to complete, since the cleaner is
+	 * parked and can not run delayed iputs - this will make us hang when
+	 * trying to stop the async reclaim task.
+	 */
+	cancel_work_sync(&fs_info->reclaim_bgs_work);
 	/*
 	 * We don't want the cleaner to start new transactions, add more delayed
 	 * iputs, etc. while we're closing. We can't use kthread_stop() yet
@@ -4400,8 +4411,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	cancel_work_sync(&fs_info->async_data_reclaim_work);
 	cancel_work_sync(&fs_info->preempt_reclaim_work);
 
-	cancel_work_sync(&fs_info->reclaim_bgs_work);
-
 	/* Cancel or finish ongoing discard work */
 	btrfs_discard_cleanup(fs_info);
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ff578c934bbc..a06c8366a8f4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2337,25 +2337,62 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_MMAP);
 
-	if (ret != BTRFS_NO_LOG_SYNC) {
+	if (ret == BTRFS_NO_LOG_SYNC) {
+		ret = btrfs_end_transaction(trans);
+		goto out;
+	}
+
+	/* We successfully logged the inode, attempt to sync the log. */
+	if (!ret) {
+		ret = btrfs_sync_log(trans, root, &ctx);
 		if (!ret) {
-			ret = btrfs_sync_log(trans, root, &ctx);
-			if (!ret) {
-				ret = btrfs_end_transaction(trans);
-				goto out;
-			}
-		}
-		if (!full_sync) {
-			ret = btrfs_wait_ordered_range(inode, start, len);
-			if (ret) {
-				btrfs_end_transaction(trans);
-				goto out;
-			}
+			ret = btrfs_end_transaction(trans);
+			goto out;
 		}
-		ret = btrfs_commit_transaction(trans);
-	} else {
+	}
+
+	/*
+	 * At this point we need to commit the transaction because we had
+	 * btrfs_need_log_full_commit() or some other error.
+	 *
+	 * If we didn't do a full sync we have to stop the trans handle, wait on
+	 * the ordered extents, start it again and commit the transaction.  If
+	 * we attempt to wait on the ordered extents here we could deadlock with
+	 * something like fallocate() that is holding the extent lock trying to
+	 * start a transaction while some other thread is trying to commit the
+	 * transaction while we (fsync) are currently holding the transaction
+	 * open.
+	 */
+	if (!full_sync) {
 		ret = btrfs_end_transaction(trans);
+		if (ret)
+			goto out;
+		ret = btrfs_wait_ordered_range(inode, start, len);
+		if (ret)
+			goto out;
+
+		/*
+		 * This is safe to use here because we're only interested in
+		 * making sure the transaction that had the ordered extents is
+		 * committed.  We aren't waiting on anything past this point,
+		 * we're purely getting the transaction and committing it.
+		 */
+		trans = btrfs_attach_transaction_barrier(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+
+			/*
+			 * We committed the transaction and there's no currently
+			 * running transaction, this means everything we care
+			 * about made it to disk and we are done.
+			 */
+			if (ret == -ENOENT)
+				ret = 0;
+			goto out;
+		}
 	}
+
+	ret = btrfs_commit_transaction(trans);
 out:
 	ASSERT(list_empty(&ctx.list));
 	err = file_check_and_advance_wb_err(file);
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 313d9d685adb..33461b4f9c8b 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -45,7 +45,6 @@ void __btrfs_tree_read_lock(struct extent_buffer *eb, enum btrfs_lock_nesting ne
 		start_ns = ktime_get_ns();
 
 	down_read_nested(&eb->lock, nest);
-	eb->lock_owner = current->pid;
 	trace_btrfs_tree_read_lock(eb, start_ns);
 }
 
@@ -62,7 +61,6 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 {
 	if (down_read_trylock(&eb->lock)) {
-		eb->lock_owner = current->pid;
 		trace_btrfs_try_tree_read_lock(eb);
 		return 1;
 	}
@@ -90,7 +88,6 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
 	trace_btrfs_tree_read_unlock(eb);
-	eb->lock_owner = 0;
 	up_read(&eb->lock);
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7f91d62c2225..969bf0724fdf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -712,6 +712,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				compress_force = false;
 				no_compress++;
 			} else {
+				btrfs_err(info, "unrecognized compression value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -770,8 +772,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_thread_pool:
 			ret = match_int(&args[0], &intarg);
 			if (ret) {
+				btrfs_err(info, "unrecognized thread_pool value %s",
+					  args[0].from);
 				goto out;
 			} else if (intarg == 0) {
+				btrfs_err(info, "invalid value 0 for thread_pool");
 				ret = -EINVAL;
 				goto out;
 			}
@@ -832,8 +837,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_ratio:
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info, "unrecognized metadata_ratio value %s",
+					  args[0].from);
 				goto out;
+			}
 			info->metadata_ratio = intarg;
 			btrfs_info(info, "metadata ratio %u",
 				   info->metadata_ratio);
@@ -850,6 +858,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, DISCARD_ASYNC,
 						   "turning on async discard");
 			} else {
+				btrfs_err(info, "unrecognized discard mode value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -874,6 +884,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, FREE_SPACE_TREE,
 						   "enabling free space tree");
 			} else {
+				btrfs_err(info, "unrecognized space_cache value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -943,8 +955,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_check_integrity_print_mask:
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info,
+				"unrecognized check_integrity_print_mask value %s",
+					args[0].from);
 				goto out;
+			}
 			info->check_integrity_print_mask = intarg;
 			btrfs_info(info, "check_integrity_print_mask 0x%x",
 				   info->check_integrity_print_mask);
@@ -959,13 +975,15 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			goto out;
 #endif
 		case Opt_fatal_errors:
-			if (strcmp(args[0].from, "panic") == 0)
+			if (strcmp(args[0].from, "panic") == 0) {
 				btrfs_set_opt(info->mount_opt,
 					      PANIC_ON_FATAL_ERROR);
-			else if (strcmp(args[0].from, "bug") == 0)
+			} else if (strcmp(args[0].from, "bug") == 0) {
 				btrfs_clear_opt(info->mount_opt,
 					      PANIC_ON_FATAL_ERROR);
-			else {
+			} else {
+				btrfs_err(info, "unrecognized fatal_errors value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -973,8 +991,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_commit_interval:
 			intarg = 0;
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info, "unrecognized commit_interval value %s",
+					  args[0].from);
+				ret = -EINVAL;
 				goto out;
+			}
 			if (intarg == 0) {
 				btrfs_info(info,
 					   "using default commit interval %us",
@@ -988,8 +1010,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_rescue:
 			ret = parse_rescue_options(info, args[0].from);
-			if (ret < 0)
+			if (ret < 0) {
+				btrfs_err(info, "unrecognized rescue value %s",
+					  args[0].from);
 				goto out;
+			}
 			break;
 #ifdef CONFIG_BTRFS_DEBUG
 		case Opt_fragment_all:
@@ -1917,6 +1942,14 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if (ret)
 		goto restore;
 
+	/* V1 cache is not supported for subpage mount. */
+	if (fs_info->sectorsize < PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+		btrfs_warn(fs_info,
+	"v1 space cache is not supported for page size %lu with sectorsize %u",
+			   PAGE_SIZE, fs_info->sectorsize);
+		ret = -EINVAL;
+		goto restore;
+	}
 	btrfs_remount_begin(fs_info, old_opts, *flags);
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index e4b25ef871b3..7a86a8dcf4f1 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -91,8 +91,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	if (test_opt(sbi, INLINE_XATTR))
 		set_inode_flag(inode, FI_INLINE_XATTR);
 
-	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
-		set_inode_flag(inode, FI_INLINE_DATA);
 	if (f2fs_may_inline_dentry(inode))
 		set_inode_flag(inode, FI_INLINE_DENTRY);
 
@@ -109,10 +107,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 
 	f2fs_init_extent_tree(inode, NULL);
 
-	stat_inc_inline_xattr(inode);
-	stat_inc_inline_inode(inode);
-	stat_inc_inline_dir(inode);
-
 	F2FS_I(inode)->i_flags =
 		f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
 
@@ -129,6 +123,14 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 			set_compress_context(inode);
 	}
 
+	/* Should enable inline_data after compression set */
+	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
+		set_inode_flag(inode, FI_INLINE_DATA);
+
+	stat_inc_inline_xattr(inode);
+	stat_inc_inline_inode(inode);
+	stat_inc_inline_dir(inode);
+
 	f2fs_set_inode_flags(inode);
 
 	trace_f2fs_new_inode(inode, 0);
@@ -327,6 +329,9 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
 		if (!is_extension_exist(name, ext[i], false))
 			continue;
 
+		/* Do not use inline_data with compression */
+		stat_dec_inline_inode(inode);
+		clear_inode_flag(inode, FI_INLINE_DATA);
 		set_compress_context(inode);
 		return;
 	}
diff --git a/include/linux/ratelimit_types.h b/include/linux/ratelimit_types.h
index b676aa419eef..f0e535f199be 100644
--- a/include/linux/ratelimit_types.h
+++ b/include/linux/ratelimit_types.h
@@ -23,12 +23,16 @@ struct ratelimit_state {
 	unsigned long	flags;
 };
 
-#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
-		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
-		.interval	= interval_init,			\
-		.burst		= burst_init,				\
+#define RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, flags_init) { \
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),		  \
+		.interval	= interval_init,				  \
+		.burst		= burst_init,					  \
+		.flags		= flags_init,					  \
 	}
 
+#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) \
+	RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, 0)
+
 #define RATELIMIT_STATE_INIT_DISABLED					\
 	RATELIMIT_STATE_INIT(ratelimit_state, 0, DEFAULT_RATELIMIT_BURST)
 
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 9e1111f5915b..d81b7f85819e 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -252,6 +252,11 @@ struct inet_sock {
 #define IP_CMSG_CHECKSUM	BIT(7)
 #define IP_CMSG_RECVFRAGSIZE	BIT(8)
 
+static inline bool sk_is_inet(struct sock *sk)
+{
+	return sk->sk_family == AF_INET || sk->sk_family == AF_INET6;
+}
+
 /**
  * sk_to_full_sk - Access to a full socket
  * @sk: pointer to a socket
diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
index ab69434e2329..72e785a903b6 100644
--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -249,6 +249,7 @@ DECLARE_EVENT_CLASS(ata_qc_complete_template,
 		__entry->hob_feature	= qc->result_tf.hob_feature;
 		__entry->nsect		= qc->result_tf.nsect;
 		__entry->hob_nsect	= qc->result_tf.hob_nsect;
+		__entry->flags		= qc->flags;
 	),
 
 	TP_printk("ata_port=%u ata_dev=%u tag=%d flags=%s status=%s " \
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 854d6df969de..ed5dd9e02324 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -323,7 +323,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	} else {
 		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_CLEAR_UNCACHED))
 			arch_dma_clear_uncached(cpu_addr, size);
-		if (dma_set_encrypted(dev, cpu_addr, 1 << page_order))
+		if (dma_set_encrypted(dev, cpu_addr, size))
 			return;
 	}
 
@@ -360,7 +360,6 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 		struct page *page, dma_addr_t dma_addr,
 		enum dma_data_direction dir)
 {
-	unsigned int page_order = get_order(size);
 	void *vaddr = page_address(page);
 
 	/* If cpu_addr is not from an atomic pool, dma_free_from_pool() fails */
@@ -368,7 +367,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	    dma_free_from_pool(dev, vaddr, size))
 		return;
 
-	if (dma_set_encrypted(dev, vaddr, 1 << page_order))
+	if (dma_set_encrypted(dev, vaddr, size))
 		return;
 	__dma_direct_free_pages(dev, page, size);
 }
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 39ee60725519..6a9c1ef15d5d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1733,8 +1733,17 @@ static int
 kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct kretprobe *rp = get_kretprobe(ri);
-	struct trace_kprobe *tk = container_of(rp, struct trace_kprobe, rp);
+	struct trace_kprobe *tk;
+
+	/*
+	 * There is a small chance that get_kretprobe(ri) returns NULL when
+	 * the kretprobe is unregister on another CPU between kretprobe's
+	 * trampoline_handler and this function.
+	 */
+	if (unlikely(!rp))
+		return 0;
 
+	tk = container_of(rp, struct trace_kprobe, rp);
 	raw_cpu_inc(*tk->nhit);
 
 	if (trace_probe_test_flag(&tk->tp, TP_FLAG_TRACE))
diff --git a/net/core/dev.c b/net/core/dev.c
index b9731b267d07..6111506a4105 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -365,12 +365,12 @@ static void list_netdevice(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	list_add_tail_rcu(&dev->dev_list, &net->dev_base_head);
 	netdev_name_node_add(net, dev->name_node);
 	hlist_add_head_rcu(&dev->index_hlist,
 			   dev_index_hash(net, dev->ifindex));
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(net);
 }
@@ -378,16 +378,18 @@ static void list_netdevice(struct net_device *dev)
 /* Device list removal
  * caller must respect a RCU grace period before freeing/reusing dev
  */
-static void unlist_netdevice(struct net_device *dev)
+static void unlist_netdevice(struct net_device *dev, bool lock)
 {
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
-	write_lock_bh(&dev_base_lock);
+	if (lock)
+		write_lock(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
-	write_unlock_bh(&dev_base_lock);
+	if (lock)
+		write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(dev_net(dev));
 }
@@ -1266,15 +1268,15 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	netdev_adjacent_rename_links(dev, oldname);
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	netdev_name_node_del(dev->name_node);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	synchronize_rcu();
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	netdev_name_node_add(net, dev->name_node);
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 
 	ret = call_netdevice_notifiers(NETDEV_CHANGENAME, dev);
 	ret = notifier_to_errno(ret);
@@ -10319,11 +10321,11 @@ int register_netdevice(struct net_device *dev)
 		goto err_uninit;
 
 	ret = netdev_register_kobject(dev);
-	if (ret) {
-		dev->reg_state = NETREG_UNREGISTERED;
+	write_lock(&dev_base_lock);
+	dev->reg_state = ret ? NETREG_UNREGISTERED : NETREG_REGISTERED;
+	write_unlock(&dev_base_lock);
+	if (ret)
 		goto err_uninit;
-	}
-	dev->reg_state = NETREG_REGISTERED;
 
 	__netdev_update_features(dev);
 
@@ -10483,8 +10485,6 @@ static void netdev_wait_allrefs(struct net_device *dev)
 	unsigned long rebroadcast_time, warning_time;
 	int wait = 0, refcnt;
 
-	linkwatch_forget_dev(dev);
-
 	rebroadcast_time = warning_time = jiffies;
 	refcnt = netdev_refcnt_read(dev);
 
@@ -10598,7 +10598,10 @@ void netdev_run_todo(void)
 			continue;
 		}
 
+		write_lock(&dev_base_lock);
 		dev->reg_state = NETREG_UNREGISTERED;
+		write_unlock(&dev_base_lock);
+		linkwatch_forget_dev(dev);
 
 		netdev_wait_allrefs(dev);
 
@@ -11043,9 +11046,10 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_for_each_entry(dev, head, unreg_list) {
 		/* And unlink it from device chain. */
-		unlist_netdevice(dev);
-
+		write_lock(&dev_base_lock);
+		unlist_netdevice(dev, false);
 		dev->reg_state = NETREG_UNREGISTERING;
+		write_unlock(&dev_base_lock);
 	}
 	flush_all_backlogs();
 
@@ -11190,7 +11194,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	dev_close(dev);
 
 	/* And unlink it from device chain */
-	unlist_netdevice(dev);
+	unlist_netdevice(dev, true);
 
 	synchronize_net();
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 0816468c545c..d1e2ef77ce4c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6209,10 +6209,21 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					   ifindex, proto, netns_id, flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
@@ -6246,10 +6257,21 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 					 flags);
 
 	if (sk) {
-		sk = sk_to_full_sk(sk);
-		if (!sk_fullsock(sk)) {
+		struct sock *sk2 = sk_to_full_sk(sk);
+
+		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk
+		 * sock refcnt is decremented to prevent a request_sock leak.
+		 */
+		if (!sk_fullsock(sk2))
+			sk2 = NULL;
+		if (sk2 != sk) {
 			sock_gen_put(sk);
-			return NULL;
+			/* Ensure there is no need to bump sk2 refcnt */
+			if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
+				WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
+				return NULL;
+			}
+			sk = sk2;
 		}
 	}
 
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 1a455847da54..9599afd0862d 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -55,7 +55,7 @@ static void rfc2863_policy(struct net_device *dev)
 	if (operstate == dev->operstate)
 		return;
 
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 
 	switch(dev->link_mode) {
 	case IF_LINK_MODE_TESTING:
@@ -74,7 +74,7 @@ static void rfc2863_policy(struct net_device *dev)
 
 	dev->operstate = operstate;
 
-	write_unlock_bh(&dev_base_lock);
+	write_unlock(&dev_base_lock);
 }
 
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9e5657f63245..e9ea0695efb4 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -32,6 +32,7 @@ static const char fmt_dec[] = "%d\n";
 static const char fmt_ulong[] = "%lu\n";
 static const char fmt_u64[] = "%llu\n";
 
+/* Caller holds RTNL or dev_base_lock */
 static inline int dev_isalive(const struct net_device *dev)
 {
 	return dev->reg_state <= NETREG_REGISTERED;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9c0e8ccf9bc5..8c85e93daa73 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -842,9 +842,9 @@ static void set_operstate(struct net_device *dev, unsigned char transition)
 	}
 
 	if (dev->operstate != operstate) {
-		write_lock_bh(&dev_base_lock);
+		write_lock(&dev_base_lock);
 		dev->operstate = operstate;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	}
 }
@@ -2781,11 +2781,11 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_LINKMODE]) {
 		unsigned char value = nla_get_u8(tb[IFLA_LINKMODE]);
 
-		write_lock_bh(&dev_base_lock);
+		write_lock(&dev_base_lock);
 		if (dev->link_mode ^ value)
 			status |= DO_SETLINK_NOTIFY;
 		dev->link_mode = value;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 	}
 
 	if (tb[IFLA_VFINFO_LIST]) {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc381165ea08..ede0af308f40 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -695,6 +695,11 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	write_lock_bh(&sk->sk_callback_lock);
 
+	if (sk_is_inet(sk) && inet_csk_has_ulp(sk)) {
+		psock = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	if (sk->sk_user_data) {
 		psock = ERR_PTR(-EBUSY);
 		goto out;
diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 7e6b37a54add..1c94bb8ea03f 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -36,7 +36,7 @@ static int fallback_set_params(struct eeprom_req_info *request,
 	if (request->page)
 		offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
 
-	if (modinfo->type == ETH_MODULE_SFF_8079 &&
+	if (modinfo->type == ETH_MODULE_SFF_8472 &&
 	    request->i2c_address == 0x51)
 		offset += ETH_MODULE_EEPROM_PAGE_LEN * 2;
 
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 26c32407f029..ea7b96e296ef 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -30,13 +30,13 @@ static bool is_slave_up(struct net_device *dev)
 
 static void __hsr_set_operstate(struct net_device *dev, int transition)
 {
-	write_lock_bh(&dev_base_lock);
+	write_lock(&dev_base_lock);
 	if (dev->operstate != transition) {
 		dev->operstate = transition;
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 		netdev_state_change(dev);
 	} else {
-		write_unlock_bh(&dev_base_lock);
+		write_unlock(&dev_base_lock);
 	}
 }
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f23528c77539..fc74a3e3b3e1 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -524,7 +524,6 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	int tunnel_hlen;
 	int version;
 	int nhoff;
-	int thoff;
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
@@ -558,10 +557,16 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
 
-	thoff = skb_transport_header(skb) - skb_mac_header(skb);
-	if (skb->protocol == htons(ETH_P_IPV6) &&
-	    (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff))
-		truncate = true;
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		int thoff;
+
+		if (skb_transport_header_was_set(skb))
+			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+		else
+			thoff = nhoff + sizeof(struct ipv6hdr);
+		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
+			truncate = true;
+	}
 
 	if (version == 1) {
 		erspan_build_header(skb, ntohl(tunnel_id_to_key32(key->tun_id)),
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1cdcb4df0eb7..2c597a4e429a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -612,9 +612,6 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 		return 0;
 	}
 
-	if (inet_csk_has_ulp(sk))
-		return -EINVAL;
-
 	if (sk->sk_family == AF_INET6) {
 		if (tcp_bpf_assert_proto_ops(psock->sk_proto))
 			return -EINVAL;
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a817ac6d9759..70ef4d4ebff4 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -944,7 +944,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	__be16 proto;
 	__u32 mtu;
 	int nhoff;
-	int thoff;
 
 	if (!pskb_inet_may_pull(skb))
 		goto tx_err;
@@ -965,10 +964,16 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
 
-	thoff = skb_transport_header(skb) - skb_mac_header(skb);
-	if (skb->protocol == htons(ETH_P_IPV6) &&
-	    (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff))
-		truncate = true;
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		int thoff;
+
+		if (skb_transport_header_was_set(skb))
+			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+		else
+			thoff = nhoff + sizeof(struct ipv6hdr);
+		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
+			truncate = true;
+	}
 
 	if (skb_cow_head(skb, dev->needed_headroom ?: t->hlen))
 		goto tx_err;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index a7e01e9952f1..44d9b38e5f90 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -14,6 +14,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/static_key.h>
 #include <net/dst.h>
@@ -32,8 +33,6 @@
 #define NFT_META_SECS_PER_DAY		86400
 #define NFT_META_DAYS_PER_WEEK		7
 
-static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
-
 static u8 nft_meta_weekday(void)
 {
 	time64_t secs = ktime_get_real_seconds();
@@ -267,13 +266,6 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 	return true;
 }
 
-static noinline u32 nft_prandom_u32(void)
-{
-	struct rnd_state *state = this_cpu_ptr(&nft_prandom_state);
-
-	return prandom_u32_state(state);
-}
-
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
@@ -385,7 +377,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 #endif
 	case NFT_META_PRANDOM:
-		*dest = nft_prandom_u32();
+		*dest = get_random_u32();
 		break;
 #ifdef CONFIG_XFRM
 	case NFT_META_SECPATH:
@@ -514,7 +506,6 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_PRANDOM:
-		prandom_init_once(&nft_prandom_state);
 		len = sizeof(u32);
 		break;
 #ifdef CONFIG_XFRM
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 722cac1e90e0..4e43214e88de 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -9,12 +9,11 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/random.h>
 #include <linux/static_key.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 
-static DEFINE_PER_CPU(struct rnd_state, nft_numgen_prandom_state);
-
 struct nft_ng_inc {
 	u8			dreg;
 	u32			modulus;
@@ -104,12 +103,9 @@ struct nft_ng_random {
 	u32			offset;
 };
 
-static u32 nft_ng_random_gen(struct nft_ng_random *priv)
+static u32 nft_ng_random_gen(const struct nft_ng_random *priv)
 {
-	struct rnd_state *state = this_cpu_ptr(&nft_numgen_prandom_state);
-
-	return reciprocal_scale(prandom_u32_state(state), priv->modulus) +
-	       priv->offset;
+	return reciprocal_scale(get_random_u32(), priv->modulus) + priv->offset;
 }
 
 static void nft_ng_random_eval(const struct nft_expr *expr,
@@ -137,8 +133,6 @@ static int nft_ng_random_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	prandom_init_once(&nft_numgen_prandom_state);
-
 	return nft_parse_register_store(ctx, tb[NFTA_NG_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, sizeof(u32));
 }
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 02096f2ec678..1b81d71bac3c 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -266,7 +266,7 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 	if (flags & IP6_FH_F_FRAG) {
 		if (frag_off) {
 			key->ip.frag = OVS_FRAG_TYPE_LATER;
-			key->ip.proto = nexthdr;
+			key->ip.proto = NEXTHDR_FRAGMENT;
 			return 0;
 		}
 		key->ip.frag = OVS_FRAG_TYPE_FIRST;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0c345e43a09a..adc5407fd5d5 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1146,9 +1146,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct tc_netem_rate rate;
 	struct tc_netem_slot slot;
 
-	qopt.latency = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->latency),
+	qopt.latency = min_t(psched_time_t, PSCHED_NS2TICKS(q->latency),
 			     UINT_MAX);
-	qopt.jitter = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->jitter),
+	qopt.jitter = min_t(psched_time_t, PSCHED_NS2TICKS(q->jitter),
 			    UINT_MAX);
 	qopt.limit = q->limit;
 	qopt.loss = q->loss;
diff --git a/net/tipc/core.c b/net/tipc/core.c
index 3f4542e0f065..434e70eabe08 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -109,10 +109,9 @@ static void __net_exit tipc_exit_net(struct net *net)
 	struct tipc_net *tn = tipc_net(net);
 
 	tipc_detach_loopback(net);
+	tipc_net_stop(net);
 	/* Make sure the tipc_net_finalize_work() finished */
 	cancel_work_sync(&tn->work);
-	tipc_net_stop(net);
-
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 9aac9c60d786..62b1c5e32bbd 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -790,6 +790,8 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
+	WARN_ON_ONCE(sk->sk_prot == p);
+
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 16cc38e51f14..9b55ca27cccf 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -553,12 +553,6 @@ static int xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
-		skb = xsk_build_skb(xs, &desc);
-		if (IS_ERR(skb)) {
-			err = PTR_ERR(skb);
-			goto out;
-		}
-
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
@@ -567,11 +561,19 @@ static int xsk_generic_xmit(struct sock *sk)
 		spin_lock_irqsave(&xs->pool->cq_lock, flags);
 		if (xskq_prod_reserve(xs->pool->cq)) {
 			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
-			kfree_skb(skb);
 			goto out;
 		}
 		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
+		skb = xsk_build_skb(xs, &desc);
+		if (IS_ERR(skb)) {
+			err = PTR_ERR(skb);
+			spin_lock_irqsave(&xs->pool->cq_lock, flags);
+			xskq_prod_cancel(xs->pool->cq);
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
+			goto out;
+		}
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 94041ee32798..b284ee01fdeb 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1108,7 +1108,7 @@ static const struct sectioncheck sectioncheck[] = {
 },
 /* Do not export init/exit functions or data */
 {
-	.fromsec = { "__ksymtab*", NULL },
+	.fromsec = { "___ksymtab*", NULL },
 	.bad_tosec = { INIT_SECTIONS, EXIT_SECTIONS, NULL },
 	.mismatch = EXPORT_TO_INIT_EXIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
diff --git a/sound/pci/hda/hda_auto_parser.c b/sound/pci/hda/hda_auto_parser.c
index 500d0d474d27..9cd0d61ab26d 100644
--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -823,7 +823,7 @@ static void set_pin_targets(struct hda_codec *codec,
 		snd_hda_set_pin_ctl_cache(codec, cfg->nid, cfg->val);
 }
 
-static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
+void __snd_hda_apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 {
 	const char *modelname = codec->fixup_name;
 
@@ -833,7 +833,7 @@ static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 		if (++depth > 10)
 			break;
 		if (fix->chained_before)
-			apply_fixup(codec, fix->chain_id, action, depth + 1);
+			__snd_hda_apply_fixup(codec, fix->chain_id, action, depth + 1);
 
 		switch (fix->type) {
 		case HDA_FIXUP_PINS:
@@ -874,6 +874,7 @@ static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 		id = fix->chain_id;
 	}
 }
+EXPORT_SYMBOL_GPL(__snd_hda_apply_fixup);
 
 /**
  * snd_hda_apply_fixup - Apply the fixup chain with the given action
@@ -883,7 +884,7 @@ static void apply_fixup(struct hda_codec *codec, int id, int action, int depth)
 void snd_hda_apply_fixup(struct hda_codec *codec, int action)
 {
 	if (codec->fixup_list)
-		apply_fixup(codec, codec->fixup_id, action, 0);
+		__snd_hda_apply_fixup(codec, codec->fixup_id, action, 0);
 }
 EXPORT_SYMBOL_GPL(snd_hda_apply_fixup);
 
diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index 8621f576446b..63c00363acad 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -350,6 +350,7 @@ void snd_hda_apply_verbs(struct hda_codec *codec);
 void snd_hda_apply_pincfgs(struct hda_codec *codec,
 			   const struct hda_pintbl *cfg);
 void snd_hda_apply_fixup(struct hda_codec *codec, int action);
+void __snd_hda_apply_fixup(struct hda_codec *codec, int id, int action, int depth);
 void snd_hda_pick_fixup(struct hda_codec *codec,
 			const struct hda_model_fixup *models,
 			const struct snd_pci_quirk *quirk,
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index bce2cef80000..0b7d500249f6 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1079,11 +1079,11 @@ static int patch_conexant_auto(struct hda_codec *codec)
 	if (err < 0)
 		goto error;
 
-	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
+	err = cx_auto_parse_beep(codec);
 	if (err < 0)
 		goto error;
 
-	err = cx_auto_parse_beep(codec);
+	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
 	if (err < 0)
 		goto error;
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4903a857f8f6..70664c9832d6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2629,6 +2629,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67f1, "Clevo PC70H[PRS]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x67f5, "Clevo PD70PN[NRT]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),
@@ -6883,6 +6884,7 @@ enum {
 	ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS,
 	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
+	ALC298_FIXUP_LENOVO_C940_DUET7,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -6892,6 +6894,23 @@ enum {
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
 };
 
+/* A special fixup for Lenovo C940 and Yoga Duet 7;
+ * both have the very same PCI SSID, and we need to apply different fixups
+ * depending on the codec ID
+ */
+static void alc298_fixup_lenovo_c940_duet7(struct hda_codec *codec,
+					   const struct hda_fixup *fix,
+					   int action)
+{
+	int id;
+
+	if (codec->core.vendor_id == 0x10ec0298)
+		id = ALC298_FIXUP_LENOVO_SPK_VOLUME; /* C940 */
+	else
+		id = ALC287_FIXUP_YOGA7_14ITL_SPEAKERS; /* Duet 7 */
+	__snd_hda_apply_fixup(codec, id, action, 0);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
@@ -8591,6 +8610,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE,
 	},
+	[ALC298_FIXUP_LENOVO_C940_DUET7] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc298_fixup_lenovo_c940_duet7,
+	},
 	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8830,6 +8853,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8783, "HP ZBook Fury 15 G7 Mobile Workstation",
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
@@ -8976,6 +9000,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x70f3, "Clevo NH77DPQ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f4, "Clevo NH77EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f6, "Clevo NH77DPQ-Y", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x7716, "Clevo NS50PU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8228, "Clevo NR40BU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8520, "Clevo NH50D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8521, "Clevo NH77D[CD]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -9059,7 +9084,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
-	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
+	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3820, "Yoga Duet 7 13ITL6", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
@@ -10521,6 +10546,7 @@ enum {
 	ALC668_FIXUP_MIC_DET_COEF,
 	ALC897_FIXUP_LENOVO_HEADSET_MIC,
 	ALC897_FIXUP_HEADSET_MIC_PIN,
+	ALC897_FIXUP_HP_HSMIC_VERB,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -10940,6 +10966,13 @@ static const struct hda_fixup alc662_fixups[] = {
 		.chained = true,
 		.chain_id = ALC897_FIXUP_LENOVO_HEADSET_MIC
 	},
+	[ALC897_FIXUP_HP_HSMIC_VERB] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -10965,6 +10998,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0698, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x885f, "HP 288 Pro G8", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 773a136161f1..a188901a83bb 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -520,11 +520,11 @@ static int via_parse_auto_config(struct hda_codec *codec)
 	if (err < 0)
 		return err;
 
-	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
+	err = auto_parse_beep(codec);
 	if (err < 0)
 		return err;
 
-	err = auto_parse_beep(codec);
+	err = snd_hda_gen_parse_auto_config(codec, &spec->gen.autocfg);
 	if (err < 0)
 		return err;
 
diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 235549bb28b9..569e1b8ad0ab 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -312,26 +312,16 @@ static int arm_spe__synth_branch_sample(struct arm_spe_queue *speq,
 	return arm_spe_deliver_synth_event(spe, speq, event, &sample);
 }
 
-#define SPE_MEM_TYPE	(ARM_SPE_L1D_ACCESS | ARM_SPE_L1D_MISS | \
-			 ARM_SPE_LLC_ACCESS | ARM_SPE_LLC_MISS | \
-			 ARM_SPE_REMOTE_ACCESS)
-
-static bool arm_spe__is_memory_event(enum arm_spe_sample_type type)
-{
-	if (type & SPE_MEM_TYPE)
-		return true;
-
-	return false;
-}
-
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record)
 {
 	union perf_mem_data_src	data_src = { 0 };
 
 	if (record->op == ARM_SPE_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
-	else
+	else if (record->op == ARM_SPE_ST)
 		data_src.mem_op = PERF_MEM_OP_STORE;
+	else
+		return 0;
 
 	if (record->type & (ARM_SPE_LLC_ACCESS | ARM_SPE_LLC_MISS)) {
 		data_src.mem_lvl = PERF_MEM_LVL_L3;
@@ -435,7 +425,11 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
 			return err;
 	}
 
-	if (spe->sample_memory && arm_spe__is_memory_event(record->type)) {
+	/*
+	 * When data_src is zero it means the record is not a memory operation,
+	 * skip to synthesize memory sample for this case.
+	 */
+	if (spe->sample_memory && data_src) {
 		err = arm_spe__synth_mem_sample(speq, spe->memory_id, data_src);
 		if (err)
 			return err;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index e32e8f2ff3bd..1d7c53873dd2 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -872,6 +872,30 @@ int build_id_cache__remove_s(const char *sbuild_id)
 	return err;
 }
 
+static int filename__read_build_id_ns(const char *filename,
+				      struct build_id *bid,
+				      struct nsinfo *nsi)
+{
+	struct nscookie nsc;
+	int ret;
+
+	nsinfo__mountns_enter(nsi, &nsc);
+	ret = filename__read_build_id(filename, bid);
+	nsinfo__mountns_exit(&nsc);
+
+	return ret;
+}
+
+static bool dso__build_id_mismatch(struct dso *dso, const char *name)
+{
+	struct build_id bid;
+
+	if (filename__read_build_id_ns(name, &bid, dso->nsinfo) < 0)
+		return false;
+
+	return !dso__build_id_equal(dso, &bid);
+}
+
 static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 			       void *priv __maybe_unused)
 {
@@ -886,6 +910,10 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 		is_kallsyms = true;
 		name = machine->mmap_name;
 	}
+
+	if (!is_kallsyms && dso__build_id_mismatch(dso, name))
+		return 0;
+
 	return build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
 				     is_kallsyms, is_vdso);
 }
diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index b5eef5ffb58e..af3461cb5c40 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -31,7 +31,7 @@ BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
-	../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+	../../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
 	pktgen/pktgen_bench_xmit_mode_netif_receive.sh"
 
 # Definition of set types:
