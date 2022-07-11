Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26645640C5
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiGBOik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiGBOih (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:38:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFA3E0E5;
        Sat,  2 Jul 2022 07:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A73CCB827B9;
        Sat,  2 Jul 2022 14:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A83C341CD;
        Sat,  2 Jul 2022 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656772704;
        bh=Cb3n1r5ZDwr5DvnGrVwwvEcyv07rPTx3IBEVZR6rh0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvipBKKpnJSo+r0t0AH75wwYSlaUOSmFumdiyYOdO1XZM5nFgbu240bynmq6qJMii
         2g8Hz8ApJvzewS+qKY+9rrBMm2XqPgIQ/5batT02YikKCZQvrM25sbcXyb2ERqibwD
         IWUO7kQ/g0D8i/P3yCHw7atiqnZRwcD1FBCLoEF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.286
Date:   Sat,  2 Jul 2022 16:38:13 +0200
Message-Id: <1656772693197130@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <165677269252195@kroah.com>
References: <165677269252195@kroah.com>
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
diff --git a/Makefile b/Makefile
index abdee02ff673..4040699fbfdd 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 285
+SUBLEVEL = 286
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 0fedb0c24eca..4263f4e86b68 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -699,7 +699,7 @@
 					regulator-name = "vddpu";
 					regulator-min-microvolt = <725000>;
 					regulator-max-microvolt = <1450000>;
-					regulator-enable-ramp-delay = <150>;
+					regulator-enable-ramp-delay = <380>;
 					anatop-reg-offset = <0x140>;
 					anatop-vol-bit-shift = <9>;
 					anatop-vol-bit-width = <5>;
diff --git a/arch/arm/mach-axxia/platsmp.c b/arch/arm/mach-axxia/platsmp.c
index 502e3df69f69..c706a11c2193 100644
--- a/arch/arm/mach-axxia/platsmp.c
+++ b/arch/arm/mach-axxia/platsmp.c
@@ -42,6 +42,7 @@ static int axxia_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		return -ENOENT;
 
 	syscon = of_iomap(syscon_np, 0);
+	of_node_put(syscon_np);
 	if (!syscon)
 		return -ENOMEM;
 
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 7d5a44a06648..95716fc9e628 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -379,6 +379,7 @@ static void __init cns3xxx_init(void)
 		/* De-Asscer SATA Reset */
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SATA));
 	}
+	of_node_put(dn);
 
 	dn = of_find_compatible_node(NULL, NULL, "cavium,cns3420-sdhci");
 	if (of_device_is_available(dn)) {
@@ -392,6 +393,7 @@ static void __init cns3xxx_init(void)
 		cns3xxx_pwr_clk_en(CNS3XXX_PWR_CLK_EN(SDIO));
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SDIO));
 	}
+	of_node_put(dn);
 
 	pm_power_off = cns3xxx_power_off;
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index c404c15ad07f..1776efe108df 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -167,6 +167,7 @@ static void exynos_map_pmu(void)
 	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
 	if (np)
 		pmu_base_addr = of_iomap(np, 0);
+	of_node_put(np);
 }
 
 static void __init exynos_init_irq(void)
diff --git a/arch/mips/vr41xx/common/icu.c b/arch/mips/vr41xx/common/icu.c
index 745b7b436961..42f77b318974 100644
--- a/arch/mips/vr41xx/common/icu.c
+++ b/arch/mips/vr41xx/common/icu.c
@@ -653,8 +653,6 @@ static int icu_get_irq(unsigned int irq)
 
 	printk(KERN_ERR "spurious ICU interrupt: %04x,%04x\n", pend1, pend2);
 
-	atomic_inc(&irq_err_count);
-
 	return -1;
 }
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index ba0d4f9a99ba..a0be8ba25538 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1613,7 +1613,7 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 		tm_reclaim_current(0);
 #endif
 
-	memset(regs->gpr, 0, sizeof(regs->gpr));
+	memset(&regs->gpr[1], 0, sizeof(regs->gpr) - sizeof(regs->gpr[0]));
 	regs->ctr = 0;
 	regs->link = 0;
 	regs->xer = 0;
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 912e7f69266e..dd20e87f18f2 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1104,7 +1104,7 @@ static struct rtas_filter rtas_filters[] __ro_after_init = {
 	{ "get-time-of-day", -1, -1, -1, -1, -1 },
 	{ "ibm,get-vpd", -1, 0, -1, 1, 2 },
 	{ "ibm,lpar-perftools", -1, 2, 3, -1, -1 },
-	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },
+	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },		/* Special cased */
 	{ "ibm,read-slot-reset-state", -1, -1, -1, -1, -1 },
 	{ "ibm,scan-log-dump", -1, 0, 1, -1, -1 },
 	{ "ibm,set-dynamic-indicator", -1, 2, -1, -1, -1 },
@@ -1151,6 +1151,15 @@ static bool block_rtas_call(int token, int nargs,
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
diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index 94f17ab1374b..1aa9bc43bdaa 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -29,4 +29,6 @@ extern void opal_event_shutdown(void);
 
 bool cpu_core_split_required(void);
 
+void pnv_rng_init(void);
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 718f50ed22f1..60ed30306da5 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -21,6 +21,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/smp.h>
+#include "powernv.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -32,7 +33,6 @@ struct powernv_rng {
 
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
index 0693fd16e2c9..9653917df9ef 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -170,6 +170,8 @@ static void __init pnv_setup_arch(void)
 	powersave_nap = 1;
 
 	/* XXX PMCS */
+
+	pnv_rng_init();
 }
 
 static void __init pnv_init(void)
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index 27cdcb69fd18..534e0951f890 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -102,4 +102,6 @@ int dlpar_workqueue_init(void);
 
 void pseries_setup_rfi_flush(void);
 
+void pseries_rng_init(void);
+
 #endif /* _PSERIES_PSERIES_H */
diff --git a/arch/powerpc/platforms/pseries/rng.c b/arch/powerpc/platforms/pseries/rng.c
index 262b8c5e1b9d..2262630543e9 100644
--- a/arch/powerpc/platforms/pseries/rng.c
+++ b/arch/powerpc/platforms/pseries/rng.c
@@ -14,6 +14,7 @@
 #include <asm/archrandom.h>
 #include <asm/machdep.h>
 #include <asm/plpar_wrappers.h>
+#include "pseries.h"
 
 
 static int pseries_get_random_long(unsigned long *v)
@@ -28,19 +29,13 @@ static int pseries_get_random_long(unsigned long *v)
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
index ab85fac02c04..c73eafc1d212 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -594,6 +594,7 @@ static void __init pSeries_setup_arch(void)
 	}
 
 	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
+	pseries_rng_init();
 }
 
 static int __init pSeries_init_panel(void)
diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 5125fca472bb..e699819bf7b3 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -21,6 +21,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/string.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -217,6 +218,11 @@ extern int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages,
 extern void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages);
 #define arch_kexec_pre_free_pages arch_kexec_pre_free_pages
 
+#ifdef CONFIG_KEXEC_FILE
+int arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
+				     Elf_Shdr *sechdrs, unsigned int relsec);
+#define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+#endif
 #endif
 
 typedef void crash_vmclear_fn(void);
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 378186b5eb40..071c5f59d620 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -146,6 +146,7 @@ static void __init calibrate_ccount(void)
 	cpu = of_find_compatible_node(NULL, NULL, "cdns,xtensa-cpu");
 	if (cpu) {
 		clk = of_clk_get(cpu, 0);
+		of_node_put(cpu);
 		if (!IS_ERR(clk)) {
 			ccount_freq = clk_get_rate(clk);
 			return;
diff --git a/arch/xtensa/platforms/xtfpga/setup.c b/arch/xtensa/platforms/xtfpga/setup.c
index db5122765f16..ce00dc2b3a1e 100644
--- a/arch/xtensa/platforms/xtfpga/setup.c
+++ b/arch/xtensa/platforms/xtfpga/setup.c
@@ -152,6 +152,7 @@ static int __init machine_setup(void)
 
 	if ((eth = of_find_compatible_node(eth, NULL, "opencores,ethoc")))
 		update_local_mac(eth);
+	of_node_put(eth);
 	return 0;
 }
 arch_initcall(machine_setup);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1331571e2b12..9efa197364a6 100644
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
@@ -996,7 +996,7 @@ void add_interrupt_randomness(int irq)
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
+	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index ac8deb01f6f6..ee3163dd794b 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -224,8 +224,6 @@ static int giu_get_irq(unsigned int irq)
 	printk(KERN_ERR "spurious GIU interrupt: %04x(%04x),%04x(%04x)\n",
 	       maskl, pendl, maskh, pendh);
 
-	atomic_inc(&irq_err_count);
-
 	return -EINVAL;
 }
 
diff --git a/drivers/gpu/drm/drm_crtc_helper_internal.h b/drivers/gpu/drm/drm_crtc_helper_internal.h
index b5ac1581e623..d595697d3d7e 100644
--- a/drivers/gpu/drm/drm_crtc_helper_internal.h
+++ b/drivers/gpu/drm/drm_crtc_helper_internal.h
@@ -32,16 +32,6 @@
 #include <drm/drm_encoder.h>
 #include <drm/drm_modes.h>
 
-/* drm_fb_helper.c */
-#ifdef CONFIG_DRM_FBDEV_EMULATION
-int drm_fb_helper_modinit(void);
-#else
-static inline int drm_fb_helper_modinit(void)
-{
-	return 0;
-}
-#endif
-
 /* drm_dp_aux_dev.c */
 #ifdef CONFIG_DRM_DP_AUX_CHARDEV
 int drm_dp_aux_dev_init(void);
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index eb6bf881c465..fbf7f28d9df9 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2612,24 +2612,3 @@ int drm_fb_helper_hotplug_event(struct drm_fb_helper *fb_helper)
 	return 0;
 }
 EXPORT_SYMBOL(drm_fb_helper_hotplug_event);
-
-/* The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
- * but the module doesn't depend on any fb console symbols.  At least
- * attempt to load fbcon to avoid leaving the system without a usable console.
- */
-int __init drm_fb_helper_modinit(void)
-{
-#if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
-	const char name[] = "fbcon";
-	struct module *fbcon;
-
-	mutex_lock(&module_mutex);
-	fbcon = find_module(name);
-	mutex_unlock(&module_mutex);
-
-	if (!fbcon)
-		request_module_nowait(name);
-#endif
-	return 0;
-}
-EXPORT_SYMBOL(drm_fb_helper_modinit);
diff --git a/drivers/gpu/drm/drm_kms_helper_common.c b/drivers/gpu/drm/drm_kms_helper_common.c
index 6e35a56a6102..7fddc4a7a8e0 100644
--- a/drivers/gpu/drm/drm_kms_helper_common.c
+++ b/drivers/gpu/drm/drm_kms_helper_common.c
@@ -35,19 +35,18 @@ MODULE_LICENSE("GPL and additional rights");
 
 static int __init drm_kms_helper_init(void)
 {
-	int ret;
-
-	/* Call init functions from specific kms helpers here */
-	ret = drm_fb_helper_modinit();
-	if (ret < 0)
-		goto out;
-
-	ret = drm_dp_aux_dev_init();
-	if (ret < 0)
-		goto out;
-
-out:
-	return ret;
+	/*
+	 * The Kconfig DRM_KMS_HELPER selects FRAMEBUFFER_CONSOLE (if !EXPERT)
+	 * but the module doesn't depend on any fb console symbols.  At least
+	 * attempt to load fbcon to avoid leaving the system without a usable
+	 * console.
+	 */
+	if (IS_ENABLED(CONFIG_DRM_FBDEV_EMULATION) &&
+	    IS_MODULE(CONFIG_FRAMEBUFFER_CONSOLE) &&
+	    !IS_ENABLED(CONFIG_EXPERT))
+		request_module_nowait("fbcon");
+
+	return drm_dp_aux_dev_init();
 }
 
 static void __exit drm_kms_helper_exit(void)
diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index d266e5614473..2455446af883 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -782,11 +782,12 @@ static int bma180_probe(struct i2c_client *client,
 		data->trig->dev.parent = &client->dev;
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
diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 5dbbba365ce8..5a945889f82c 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1412,10 +1412,14 @@ static int mma8452_reset(struct i2c_client *client)
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
diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
index 546bbe59c241..79ab8db450a4 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -213,6 +213,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
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
 
diff --git a/drivers/iio/gyro/mpu3050-core.c b/drivers/iio/gyro/mpu3050-core.c
index 1096226a0612..44b57808b70c 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -874,6 +874,7 @@ static int mpu3050_power_up(struct mpu3050 *mpu3050)
 	ret = regmap_update_bits(mpu3050->map, MPU3050_PWR_MGM,
 				 MPU3050_PWR_MGM_SLEEP, 0);
 	if (ret) {
+		regulator_bulk_disable(ARRAY_SIZE(mpu3050->regs), mpu3050->regs);
 		dev_err(mpu3050->dev, "error setting power mode\n");
 		return ret;
 	}
diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index 202e8b89caf2..0e9590e071d1 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -199,6 +199,7 @@ static int iio_sysfs_trigger_remove(int id)
 	}
 
 	iio_trigger_unregister(t->trig);
+	irq_work_sync(&t->work);
 	iio_trigger_free(t->trig);
 
 	list_del(&t->l);
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index adf22692566d..046291d41ec1 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1396,7 +1396,7 @@ static void start_worker(struct era *era)
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
-	flush_workqueue(era->wq);
+	drain_workqueue(era->wq);
 }
 
 /*----------------------------------------------------------------
@@ -1581,6 +1581,12 @@ static void era_postsuspend(struct dm_target *ti)
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
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7096fcbf699c..98e64f63d9ba 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3048,9 +3048,11 @@ static void bond_activebackup_arp_mon(struct bonding *bond)
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
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 618063d21f96..7b70e95ee352 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8618,11 +8618,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
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
 
@@ -8655,7 +8654,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			/* Disable BMC-to-OS Watchdog Enable */
 			if (hw->mac.type != e1000_i354)
 				reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
-
 			wr32(E1000_DMACR, reg);
 
 			/* no lower threshold to disable
@@ -8672,12 +8670,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
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
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 1d4090d2b91e..512d3a8439c9 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1159,6 +1159,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 
 		/* try to clear seed so it won't be found. */
 		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	}
 
 	/* break now */
@@ -1272,6 +1276,8 @@ bool __init early_init_dt_verify(void *params)
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1297,8 +1303,6 @@ bool __init early_init_dt_scan(void *params)
 		return false;
 
 	early_init_dt_scan_nodes();
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f4ac5ec5dc02..cd4947a72a6c 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4132,16 +4132,8 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
 
 	if (op->data && font.charcount > op->charcount)
 		rc = -ENOSPC;
-	if (!(op->flags & KD_FONT_FLAG_OLD)) {
-		if (font.width > op->width || font.height > op->height) 
-			rc = -ENOSPC;
-	} else {
-		if (font.width != 8)
-			rc = -EIO;
-		else if ((op->height && font.height > op->height) ||
-			 font.height > 32)
-			rc = -ENOSPC;
-	}
+	if (font.width > op->width || font.height > op->height)
+		rc = -ENOSPC;
 	if (rc)
 		goto out;
 
@@ -4169,27 +4161,7 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
 		return -EINVAL;
 	if (op->charcount > 512)
 		return -EINVAL;
-	if (!op->height) {		/* Need to guess font height [compat] */
-		int h, i;
-		u8 __user *charmap = op->data;
-		u8 tmp;
-		
-		/* If from KDFONTOP ioctl, don't allow things which can be done in userland,
-		   so that we can get rid of this soon */
-		if (!(op->flags & KD_FONT_FLAG_OLD))
-			return -EINVAL;
-		for (h = 32; h > 0; h--)
-			for (i = 0; i < op->charcount; i++) {
-				if (get_user(tmp, &charmap[32*i+h-1]))
-					return -EFAULT;
-				if (tmp)
-					goto nonzero;
-			}
-		return -EINVAL;
-	nonzero:
-		op->height = h;
-	}
-	if (op->width <= 0 || op->width > 32 || op->height > 32)
+	if (op->width <= 0 || op->width > 32 || !op->height || op->height > 32)
 		return -EINVAL;
 	size = (op->width+7)/8 * 32 * op->charcount;
 	if (size > max_font_size)
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 6bc9af583d6d..285fc3ef0b53 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -241,48 +241,6 @@ int vt_waitactive(int n)
 #define GPLAST 0x3df
 #define GPNUM (GPLAST - GPFIRST + 1)
 
-
-
-static inline int 
-do_fontx_ioctl(struct vc_data *vc, int cmd, struct consolefontdesc __user *user_cfd, int perm, struct console_font_op *op)
-{
-	struct consolefontdesc cfdarg;
-	int i;
-
-	if (copy_from_user(&cfdarg, user_cfd, sizeof(struct consolefontdesc))) 
-		return -EFAULT;
- 	
-	switch (cmd) {
-	case PIO_FONTX:
-		if (!perm)
-			return -EPERM;
-		op->op = KD_FONT_OP_SET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = cfdarg.chardata;
-		return con_font_op(vc, op);
-
-	case GIO_FONTX:
-		op->op = KD_FONT_OP_GET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = cfdarg.chardata;
-		i = con_font_op(vc, op);
-		if (i)
-			return i;
-		cfdarg.charheight = op->height;
-		cfdarg.charcount = op->charcount;
-		if (copy_to_user(user_cfd, &cfdarg, sizeof(struct consolefontdesc)))
-			return -EFAULT;
-		return 0;
-	}
-	return -EINVAL;
-}
-
 static inline int 
 do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud, int perm, struct vc_data *vc)
 {
@@ -919,30 +877,6 @@ int vt_ioctl(struct tty_struct *tty,
 		break;
 	}
 
-	case PIO_FONT: {
-		if (!perm)
-			return -EPERM;
-		op.op = KD_FONT_OP_SET;
-		op.flags = KD_FONT_FLAG_OLD | KD_FONT_FLAG_DONT_RECALC;	/* Compatibility */
-		op.width = 8;
-		op.height = 0;
-		op.charcount = 256;
-		op.data = up;
-		ret = con_font_op(vc, &op);
-		break;
-	}
-
-	case GIO_FONT: {
-		op.op = KD_FONT_OP_GET;
-		op.flags = KD_FONT_FLAG_OLD;
-		op.width = 8;
-		op.height = 32;
-		op.charcount = 256;
-		op.data = up;
-		ret = con_font_op(vc, &op);
-		break;
-	}
-
 	case PIO_CMAP:
                 if (!perm)
 			ret = -EPERM;
@@ -954,36 +888,6 @@ int vt_ioctl(struct tty_struct *tty,
                 ret = con_get_cmap(up);
 		break;
 
-	case PIO_FONTX:
-	case GIO_FONTX:
-		ret = do_fontx_ioctl(vc, cmd, up, perm, &op);
-		break;
-
-	case PIO_FONTRESET:
-	{
-		if (!perm)
-			return -EPERM;
-
-#ifdef BROKEN_GRAPHICS_PROGRAMS
-		/* With BROKEN_GRAPHICS_PROGRAMS defined, the default
-		   font is not saved. */
-		ret = -ENOSYS;
-		break;
-#else
-		{
-		op.op = KD_FONT_OP_SET_DEFAULT;
-		op.data = NULL;
-		ret = con_font_op(vc, &op);
-		if (ret)
-			break;
-		console_lock();
-		con_set_default_unimap(vc);
-		console_unlock();
-		break;
-		}
-#endif
-	}
-
 	case KDFONTOP: {
 		if (copy_from_user(&op, up, sizeof(op))) {
 			ret = -EFAULT;
@@ -1097,54 +1001,6 @@ void vc_SAK(struct work_struct *work)
 
 #ifdef CONFIG_COMPAT
 
-struct compat_consolefontdesc {
-	unsigned short charcount;       /* characters in font (256 or 512) */
-	unsigned short charheight;      /* scan lines per character (1-32) */
-	compat_caddr_t chardata;	/* font data in expanded form */
-};
-
-static inline int
-compat_fontx_ioctl(struct vc_data *vc, int cmd,
-		   struct compat_consolefontdesc __user *user_cfd,
-		   int perm, struct console_font_op *op)
-{
-	struct compat_consolefontdesc cfdarg;
-	int i;
-
-	if (copy_from_user(&cfdarg, user_cfd, sizeof(struct compat_consolefontdesc)))
-		return -EFAULT;
-
-	switch (cmd) {
-	case PIO_FONTX:
-		if (!perm)
-			return -EPERM;
-		op->op = KD_FONT_OP_SET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = compat_ptr(cfdarg.chardata);
-		return con_font_op(vc, op);
-
-	case GIO_FONTX:
-		op->op = KD_FONT_OP_GET;
-		op->flags = KD_FONT_FLAG_OLD;
-		op->width = 8;
-		op->height = cfdarg.charheight;
-		op->charcount = cfdarg.charcount;
-		op->data = compat_ptr(cfdarg.chardata);
-		i = con_font_op(vc, op);
-		if (i)
-			return i;
-		cfdarg.charheight = op->height;
-		cfdarg.charcount = op->charcount;
-		if (copy_to_user(user_cfd, &cfdarg, sizeof(struct compat_consolefontdesc)))
-			return -EFAULT;
-		return 0;
-	}
-	return -EINVAL;
-}
-
 struct compat_console_font_op {
 	compat_uint_t op;        /* operation code KD_FONT_OP_* */
 	compat_uint_t flags;     /* KD_FONT_FLAG_* */
@@ -1222,11 +1078,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	/*
 	 * these need special handlers for incompatible data structures
 	 */
-	case PIO_FONTX:
-	case GIO_FONTX:
-		ret = compat_fontx_ioctl(vc, cmd, up, perm, &op);
-		break;
-
 	case KDFONTOP:
 		ret = compat_kdfontop_ioctl(up, perm, &op, vc);
 		break;
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index e3a44bea7bb7..535d3816fda1 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -923,6 +923,9 @@ isr_setup_status_complete(struct usb_ep *ep, struct usb_request *req)
 	struct ci_hdrc *ci = req->context;
 	unsigned long flags;
 
+	if (req->status < 0)
+		return;
+
 	if (ci->setaddr) {
 		hw_usb_set_address(ci, ci->address);
 		ci->setaddr = false;
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index bbd20defaae6..f613086aa635 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -255,10 +255,12 @@ static void option_instat_callback(struct urb *urb);
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
@@ -1137,6 +1139,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM05G, 0xff),
+	  .driver_info = RSVD(6) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0, 0) },
@@ -1150,6 +1154,7 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
 
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
@@ -1282,6 +1287,7 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1231, 0xff),	/* Telit LE910Cx (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x1250, 0xff, 0x00, 0x00) },	/* Telit LE910Cx (rmnet) */
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),
diff --git a/drivers/xen/features.c b/drivers/xen/features.c
index d7d34fdfc993..f466f776604f 100644
--- a/drivers/xen/features.c
+++ b/drivers/xen/features.c
@@ -28,6 +28,6 @@ void xen_setup_features(void)
 		if (HYPERVISOR_xen_version(XENVER_get_features, &fi) < 0)
 			break;
 		for (j = 0; j < 32; j++)
-			xen_features[i * 32 + j] = !!(fi.submap & 1<<j);
+			xen_features[i * 32 + j] = !!(fi.submap & 1U << j);
 	}
 }
diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index e7df65d32c91..136345b45b29 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -262,4 +262,3 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xen_xlate_map_ballooned_pages);
diff --git a/include/linux/kd.h b/include/linux/kd.h
deleted file mode 100644
index b130a18f860f..000000000000
--- a/include/linux/kd.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_KD_H
-#define _LINUX_KD_H
-
-#include <uapi/linux/kd.h>
-
-#define KD_FONT_FLAG_OLD		0x80000000	/* Invoked via old interface [compat] */
-#endif /* _LINUX_KD_H */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 1ce6ba5f0407..07578da0e2f5 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -163,6 +163,28 @@ int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
 			       int (*func)(u64, u64, void *));
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
+
+#ifndef arch_kexec_apply_relocations_add
+/* Apply relocations of type RELA */
+static inline int
+arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
+				 Elf_Shdr *sechdrs, unsigned int relsec)
+{
+	pr_err("RELA relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
+
+#ifndef arch_kexec_apply_relocations
+/* Apply relocations of type REL */
+static inline int
+arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+			     unsigned int relsec)
+{
+	pr_err("REL relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
 #endif /* CONFIG_KEXEC_FILE */
 
 struct kimage {
@@ -288,10 +310,6 @@ void * __weak arch_kexec_kernel_image_load(struct kimage *image);
 int __weak arch_kimage_file_post_load_cleanup(struct kimage *image);
 int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 					unsigned long buf_len);
-int __weak arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
-					Elf_Shdr *sechdrs, unsigned int relsec);
-int __weak arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-					unsigned int relsec);
 void arch_kexec_protect_crashkres(void);
 void arch_kexec_unprotect_crashkres(void);
 
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 8ddf79e9207a..1df12e8dde6f 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
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
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 9d979b2954ef..4e95641e8dd6 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -53,24 +53,6 @@ int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 }
 #endif
 
-/* Apply relocations of type RELA */
-int __weak
-arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-				 unsigned int relsec)
-{
-	pr_err("RELA relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
-/* Apply relocations of type REL */
-int __weak
-arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
-			     unsigned int relsec)
-{
-	pr_err("REL relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
 /*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bdc2b89870e3..e162cb464ee4 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -607,7 +607,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	 * unconditional bounce may prevent leaking swiotlb content (i.e.
 	 * kernel memory) to user-space.
 	 */
-	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
+	if (orig_addr)
+		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f35fb7fcd98c..ed2b7a16554e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1077,7 +1077,7 @@ static const struct sectioncheck sectioncheck[] = {
 },
 /* Do not export init/exit functions or data */
 {
-	.fromsec = { "__ksymtab*", NULL },
+	.fromsec = { "___ksymtab*", NULL },
 	.bad_tosec = { INIT_SECTIONS, EXIT_SECTIONS, NULL },
 	.mismatch = EXPORT_TO_INIT_EXIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
