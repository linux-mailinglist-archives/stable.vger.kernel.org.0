Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532865640C9
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiGBOiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiGBOii (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:38:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15F7FD03;
        Sat,  2 Jul 2022 07:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 758C6CE0B8A;
        Sat,  2 Jul 2022 14:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96B0C34114;
        Sat,  2 Jul 2022 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656772707;
        bh=IB6GfvuIk9/RC4vOtqxy84tOYKH78u1CXZ+hBs70MM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpyvB4hFQWYA+/uKJenkvT5vZbuS+EqwgT//+HqGtUWpKqOJw3pepyrUZSvSuefG9
         QqylzAcZ5QmFbywLo91p/ei2G7Lk89wRrDVEsYwzMr08sZuFW8x/t0Ez0r/ewTjLix
         BB7QFSb++dMkoPWiXs1Ph2cibEsXwSqsDkvCy6os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.250
Date:   Sat,  2 Jul 2022 16:38:19 +0200
Message-Id: <1656772698158131@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <1656772698234219@kroah.com>
References: <1656772698234219@kroah.com>
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
index 14ba089d5b01..f78a5a3604c3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 249
+SUBLEVEL = 250
 EXTRAVERSION =
 NAME = "People's Front"
 
@@ -1017,7 +1017,7 @@ PHONY += autoksyms_recursive
 autoksyms_recursive: $(vmlinux-deps)
 ifdef CONFIG_TRIM_UNUSED_KSYMS
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/adjust_autoksyms.sh \
-	  "$(MAKE) -f $(srctree)/Makefile vmlinux"
+	  "$(MAKE) -f $(srctree)/Makefile autoksyms_recursive"
 endif
 
 # For the kernel to actually contain only the needed exported symbols,
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 9f88b5691f05..d91cc532d0e2 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -753,7 +753,7 @@
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
index 865dcc4c3181..23adb1a54bcd 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -131,6 +131,7 @@ static void exynos_map_pmu(void)
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
index 56c33285b1df..9f89fac4ed08 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1731,7 +1731,7 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 		tm_reclaim_current(0);
 #endif
 
-	memset(regs->gpr, 0, sizeof(regs->gpr));
+	memset(&regs->gpr[1], 0, sizeof(regs->gpr) - sizeof(regs->gpr[0]));
 	regs->ctr = 0;
 	regs->link = 0;
 	regs->xer = 0;
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 362c20c8c22f..b492cb1c36fd 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1105,7 +1105,7 @@ static struct rtas_filter rtas_filters[] __ro_after_init = {
 	{ "get-time-of-day", -1, -1, -1, -1, -1 },
 	{ "ibm,get-vpd", -1, 0, -1, 1, 2 },
 	{ "ibm,lpar-perftools", -1, 2, 3, -1, -1 },
-	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },
+	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },		/* Special cased */
 	{ "ibm,read-slot-reset-state", -1, -1, -1, -1, -1 },
 	{ "ibm,scan-log-dump", -1, 0, 1, -1, -1 },
 	{ "ibm,set-dynamic-indicator", -1, 2, -1, -1, -1 },
@@ -1152,6 +1152,15 @@ static bool block_rtas_call(int token, int nargs,
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
index fd4a1c5a6369..cd9180cc0e13 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -30,4 +30,6 @@ extern void opal_event_shutdown(void);
 
 bool cpu_core_split_required(void);
 
+void pnv_rng_init(void);
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index e15dd09f71df..c5c1d5cd7b10 100644
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
@@ -102,9 +102,6 @@ static int initialise_darn(void)
 			return 0;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
 	return -EIO;
 }
 
@@ -167,32 +164,55 @@ static __init int rng_create(struct device_node *dn)
 
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
index 5068dd7f6e74..0ade08dd0ea2 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -171,6 +171,8 @@ static void __init pnv_setup_arch(void)
 	powersave_nap = 1;
 
 	/* XXX PMCS */
+
+	pnv_rng_init();
 }
 
 static void __init pnv_init(void)
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index 60db2ee511fb..2f7c5d1c1751 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -110,4 +110,6 @@ int dlpar_workqueue_init(void);
 
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
index 885d910bfd9d..77423d765001 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -792,6 +792,7 @@ static void __init pSeries_setup_arch(void)
 	}
 
 	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
+	pseries_rng_init();
 }
 
 static void pseries_panic(char *str)
diff --git a/arch/s390/include/asm/kexec.h b/arch/s390/include/asm/kexec.h
index 825dd0f7f221..ba9b0e76470c 100644
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -9,6 +9,8 @@
 #ifndef _S390_KEXEC_H
 #define _S390_KEXEC_H
 
+#include <linux/module.h>
+
 #include <asm/processor.h>
 #include <asm/page.h>
 /*
@@ -69,4 +71,12 @@ int *kexec_file_update_kernel(struct kimage *iamge,
 extern const struct kexec_file_ops s390_kexec_image_ops;
 extern const struct kexec_file_ops s390_kexec_elf_ops;
 
+#ifdef CONFIG_KEXEC_FILE
+struct purgatory_info;
+int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
+				     Elf_Shdr *section,
+				     const Elf_Shdr *relsec,
+				     const Elf_Shdr *symtab);
+#define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+#endif
 #endif /*_S390_KEXEC_H */
diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 5125fca472bb..0a41c62369f2 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -21,6 +21,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/string.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -217,6 +218,14 @@ extern int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages,
 extern void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages);
 #define arch_kexec_pre_free_pages arch_kexec_pre_free_pages
 
+#ifdef CONFIG_KEXEC_FILE
+struct purgatory_info;
+int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
+				     Elf_Shdr *section,
+				     const Elf_Shdr *relsec,
+				     const Elf_Shdr *symtab);
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
index 55b23104fe33..bac4dc501dc4 100644
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
index 027699cec911..217b077838af 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -230,8 +230,6 @@ static int giu_get_irq(unsigned int irq)
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
index da9a381d6b57..fbe9156c9e7c 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -3270,24 +3270,3 @@ int drm_fbdev_generic_setup(struct drm_device *dev, unsigned int preferred_bpp)
 	return 0;
 }
 EXPORT_SYMBOL(drm_fbdev_generic_setup);
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
index 93e2b30fe1a5..681b29727235 100644
--- a/drivers/gpu/drm/drm_kms_helper_common.c
+++ b/drivers/gpu/drm/drm_kms_helper_common.c
@@ -63,19 +63,18 @@ MODULE_PARM_DESC(edid_firmware,
 
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
index 52275dddab3e..7980bd95e382 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -780,11 +780,12 @@ static int bma180_probe(struct i2c_client *client,
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
index 1ef75c94987b..b03c6d9553ae 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1486,10 +1486,14 @@ static int mma8452_reset(struct i2c_client *client)
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
index e6ce25bcc01c..8192d20d260a 100644
--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -205,6 +205,14 @@ static const struct dmi_system_id axp288_adc_ts_bias_override[] = {
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
 
diff --git a/drivers/iio/chemical/ccs811.c b/drivers/iio/chemical/ccs811.c
index 46d5d48b58b6..70f1bec3bba8 100644
--- a/drivers/iio/chemical/ccs811.c
+++ b/drivers/iio/chemical/ccs811.c
@@ -421,11 +421,11 @@ static int ccs811_probe(struct i2c_client *client,
 		data->drdy_trig->dev.parent = &client->dev;
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
index e6fdd0f4b4bc..0d7581a6f5ba 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -873,6 +873,7 @@ static int mpu3050_power_up(struct mpu3050 *mpu3050)
 	ret = regmap_update_bits(mpu3050->map, MPU3050_PWR_MGM,
 				 MPU3050_PWR_MGM_SLEEP, 0);
 	if (ret) {
+		regulator_bulk_disable(ARRAY_SIZE(mpu3050->regs), mpu3050->regs);
 		dev_err(mpu3050->dev, "error setting power mode\n");
 		return ret;
 	}
diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index 3f0dc9a1a514..cccc07e637a4 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -198,6 +198,7 @@ static int iio_sysfs_trigger_remove(int id)
 	}
 
 	iio_trigger_unregister(t->trig);
+	irq_work_sync(&t->work);
 	iio_trigger_free(t->trig);
 
 	list_del(&t->l);
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index c596fc564a58..da88237f1fe4 100644
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
@@ -1580,6 +1580,12 @@ static void era_postsuspend(struct dm_target *ti)
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
index 2d70cdd26f89..cab5c1cc9fe9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3069,9 +3069,11 @@ static void bond_activebackup_arp_mon(struct bonding *bond)
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
index a93edd31011f..9f45ecd9e8e5 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9444,11 +9444,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
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
 
@@ -9481,7 +9480,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			/* Disable BMC-to-OS Watchdog Enable */
 			if (hw->mac.type != e1000_i354)
 				reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
-
 			wr32(E1000_DMACR, reg);
 
 			/* no lower threshold to disable
@@ -9498,12 +9496,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
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
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ea30da1c53f0..a4e20a62bf8d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1733,8 +1733,12 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot,
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_MC);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV6);
 
 	/* CPU port Injection/Extraction configuration */
 	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 1a8fe5bacb19..415b26c80fe7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2315,7 +2315,6 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 static void virtnet_freeze_down(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int i;
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
@@ -2323,14 +2322,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
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
@@ -2338,7 +2331,7 @@ static int init_vqs(struct virtnet_info *vi);
 static int virtnet_restore_up(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int err, i;
+	int err;
 
 	err = init_vqs(vi);
 	if (err)
@@ -2347,15 +2340,9 @@ static int virtnet_restore_up(struct virtio_device *vdev)
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
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 2e9ea7f1e719..9fecac72c358 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1119,6 +1119,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 
 		/* try to clear seed so it won't be found. */
 		fdt_nop_property(initial_boot_params, node, "rng-seed");
+
+		/* update CRC check value */
+		of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	}
 
 	/* break now */
@@ -1223,6 +1227,8 @@ bool __init early_init_dt_verify(void *params)
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1248,8 +1254,6 @@ bool __init early_init_dt_scan(void *params)
 		return false;
 
 	early_init_dt_scan_nodes();
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index 8ee06347447c..f4ad45a1efab 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -788,6 +788,7 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	}
 
 	ret = brcmstb_init_sram(dn);
+	of_node_put(dn);
 	if (ret) {
 		pr_err("error setting up SRAM for PM\n");
 		return ret;
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 72e3989dffa6..dca627ccece5 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4472,16 +4472,8 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
 
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
 
@@ -4509,7 +4501,7 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
 		return -EINVAL;
 	if (op->charcount > 512)
 		return -EINVAL;
-	if (op->width <= 0 || op->width > 32 || op->height > 32)
+	if (op->width <= 0 || op->width > 32 || !op->height || op->height > 32)
 		return -EINVAL;
 	size = (op->width+7)/8 * 32 * op->charcount;
 	if (size > max_font_size)
@@ -4519,31 +4511,6 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
 	if (IS_ERR(font.data))
 		return PTR_ERR(font.data);
 
-	if (!op->height) {		/* Need to guess font height [compat] */
-		int h, i;
-		u8 *charmap = font.data;
-
-		/*
-		 * If from KDFONTOP ioctl, don't allow things which can be done
-		 * in userland,so that we can get rid of this soon
-		 */
-		if (!(op->flags & KD_FONT_FLAG_OLD)) {
-			kfree(font.data);
-			return -EINVAL;
-		}
-
-		for (h = 32; h > 0; h--)
-			for (i = 0; i < op->charcount; i++)
-				if (charmap[32*i+h-1])
-					goto nonzero;
-
-		kfree(font.data);
-		return -EINVAL;
-
-	nonzero:
-		op->height = h;
-	}
-
 	font.charcount = op->charcount;
 	font.width = op->width;
 	font.height = op->height;
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 78ae1f0908fd..86efb5493543 100644
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
index 169ccfacfc75..3bda856ff2ca 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -920,6 +920,9 @@ isr_setup_status_complete(struct usb_ep *ep, struct usb_request *req)
 	struct ci_hdrc *ci = req->context;
 	unsigned long flags;
 
+	if (req->status < 0)
+		return;
+
 	if (ci->setaddr) {
 		hw_usb_set_address(ci, ci->address);
 		ci->setaddr = false;
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1bb48e53449e..e40370ed7d8a 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -565,7 +565,7 @@ struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd)
  * It will release and re-aquire the lock while calling ACPI
  * method.
  */
-static void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd,
 				u16 index, bool on, unsigned long *flags)
 {
 	struct xhci_hub *rhub;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a9e72fee87a7..677587479d26 100644
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
index 3e6cb257fde5..3b29dfc6f79e 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2145,6 +2145,8 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex,
 int xhci_hub_status_data(struct usb_hcd *hcd, char *buf);
 int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1);
 struct xhci_hub *xhci_get_rhub(struct usb_hcd *hcd);
+void xhci_set_port_power(struct xhci_hcd *xhci, struct usb_hcd *hcd, u16 index,
+			 bool on, unsigned long *flags);
 
 void xhci_hc_died(struct xhci_hcd *xhci);
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 4f99818ca70e..d7ea64e8b024 100644
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
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index a12ae3ef8fb4..0983d7e859c8 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -473,7 +473,8 @@ int afs_getattr(const struct path *path, struct kstat *stat,
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
-	if (!(query_flags & AT_STATX_DONT_SYNC) &&
+	if (vnode->volume &&
+	    !(query_flags & AT_STATX_DONT_SYNC) &&
 	    !test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags)) {
 		key = afs_request_key(vnode->volume->cell);
 		if (IS_ERR(key))
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
index fe9f6f2dd811..29bffbc6d73a 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -174,14 +174,6 @@ int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
 				   bool get_value);
 void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name);
 
-int __weak arch_kexec_apply_relocations_add(struct purgatory_info *pi,
-					    Elf_Shdr *section,
-					    const Elf_Shdr *relsec,
-					    const Elf_Shdr *symtab);
-int __weak arch_kexec_apply_relocations(struct purgatory_info *pi,
-					Elf_Shdr *section,
-					const Elf_Shdr *relsec,
-					const Elf_Shdr *symtab);
 
 int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
 			       int (*func)(struct resource *, void *));
@@ -206,6 +198,44 @@ extern int crash_exclude_mem_range(struct crash_mem *mem,
 				   unsigned long long mend);
 extern int crash_prepare_elf64_headers(struct crash_mem *mem, int kernel_map,
 				       void **addr, unsigned long *sz);
+
+#ifndef arch_kexec_apply_relocations_add
+/*
+ * arch_kexec_apply_relocations_add - apply relocations of type RELA
+ * @pi:		Purgatory to be relocated.
+ * @section:	Section relocations applying to.
+ * @relsec:	Section containing RELAs.
+ * @symtab:	Corresponding symtab.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int
+arch_kexec_apply_relocations_add(struct purgatory_info *pi, Elf_Shdr *section,
+				 const Elf_Shdr *relsec, const Elf_Shdr *symtab)
+{
+	pr_err("RELA relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
+
+#ifndef arch_kexec_apply_relocations
+/*
+ * arch_kexec_apply_relocations - apply relocations of type REL
+ * @pi:		Purgatory to be relocated.
+ * @section:	Section relocations applying to.
+ * @relsec:	Section containing RELs.
+ * @symtab:	Corresponding symtab.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int
+arch_kexec_apply_relocations(struct purgatory_info *pi, Elf_Shdr *section,
+			     const Elf_Shdr *relsec, const Elf_Shdr *symtab)
+{
+	pr_err("REL relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
 #endif /* CONFIG_KEXEC_FILE */
 
 struct kimage {
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
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8b1360772fc5..b1e2ce2f9c2d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -594,7 +594,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	 * unconditional bounce may prevent leaking swiotlb content (i.e.
 	 * kernel memory) to user-space.
 	 */
-	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
+	if (orig_addr)
+		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 89d41c0a10f1..ab1934a2b2e6 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -110,40 +110,6 @@ int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 }
 #endif
 
-/*
- * arch_kexec_apply_relocations_add - apply relocations of type RELA
- * @pi:		Purgatory to be relocated.
- * @section:	Section relocations applying to.
- * @relsec:	Section containing RELAs.
- * @symtab:	Corresponding symtab.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak
-arch_kexec_apply_relocations_add(struct purgatory_info *pi, Elf_Shdr *section,
-				 const Elf_Shdr *relsec, const Elf_Shdr *symtab)
-{
-	pr_err("RELA relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
-/*
- * arch_kexec_apply_relocations - apply relocations of type REL
- * @pi:		Purgatory to be relocated.
- * @section:	Section relocations applying to.
- * @relsec:	Section containing RELs.
- * @symtab:	Corresponding symtab.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak
-arch_kexec_apply_relocations(struct purgatory_info *pi, Elf_Shdr *section,
-			     const Elf_Shdr *relsec, const Elf_Shdr *symtab)
-{
-	pr_err("REL relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
 /*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index cf60d0e07965..c72432ce9bf5 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -574,7 +574,6 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 	int tunnel_hlen;
 	int version;
 	int nhoff;
-	int thoff;
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
@@ -609,10 +608,16 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
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
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 4fd6c0929b14..e617a98f4df6 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -946,7 +946,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	__be16 proto;
 	__u32 mtu;
 	int nhoff;
-	int thoff;
 
 	if (!pskb_inet_may_pull(skb))
 		goto tx_err;
@@ -967,10 +966,16 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
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
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 7c1b1eff84f4..cad2586c3473 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -970,8 +970,6 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 	const struct Qdisc_ops *ops;
 	struct sk_buff *skb, *tmp;
 
-	if (!qdisc)
-		return;
 	ops = qdisc->ops;
 
 #ifdef CONFIG_NET_SCHED
@@ -1003,6 +1001,9 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 
 void qdisc_put(struct Qdisc *qdisc)
 {
+	if (!qdisc)
+		return;
+
 	if (qdisc->flags & TCQ_F_BUILTIN ||
 	    !refcount_dec_and_test(&qdisc->refcnt))
 		return;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index ad400f4f9a2d..31793af1a77b 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1120,9 +1120,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_buff *skb)
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
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index e294b6cff9fd..8c2847ef4e42 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1066,7 +1066,7 @@ static const struct sectioncheck sectioncheck[] = {
 },
 /* Do not export init/exit functions or data */
 {
-	.fromsec = { "__ksymtab*", NULL },
+	.fromsec = { "___ksymtab*", NULL },
 	.bad_tosec = { INIT_SECTIONS, EXIT_SECTIONS, NULL },
 	.mismatch = EXPORT_TO_INIT_EXIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 629857f5539c..9b7f474ee6ca 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1061,11 +1061,11 @@ static int patch_conexant_auto(struct hda_codec *codec)
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
index ed0b8ec50d71..2915bf0857df 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2567,6 +2567,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x67e1, "Clevo PB71[DE][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67e5, "Clevo PC70D[PRS](?:-D|-G)?", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67f1, "Clevo PC70H[PRS]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x67f5, "Clevo PD70PN[NRT]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 0046ea78abd2..937155b1fae0 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -533,11 +533,11 @@ static int via_parse_auto_config(struct hda_codec *codec)
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
 
