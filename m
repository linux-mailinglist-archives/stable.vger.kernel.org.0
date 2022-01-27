Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875C949E371
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 14:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241891AbiA0NcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 08:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241745AbiA0NcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 08:32:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D391AC06173B;
        Thu, 27 Jan 2022 05:32:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F150461BAD;
        Thu, 27 Jan 2022 13:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4D1C340E4;
        Thu, 27 Jan 2022 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643290332;
        bh=lS261Oz9gSnrnfnKxBj75NJHnI1HNAwY3Xz0o9ombjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXSedbWKQp6hsBahASpsQ2tpkNMnbOU3enLb+SluAirF2EBygpQuMM3X4HzCDx1NF
         GW47SKyqxPzJvWsLfo9xbWnBvpfIAWwqX/Hg93SZsul3uYZWj+gXwFIrdiPHgygMpB
         ffyusxUMl5cmwDDMqG16wB/0d/nS8Zbdei29eQYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.263
Date:   Thu, 27 Jan 2022 14:31:58 +0100
Message-Id: <164329031812413@kroah.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <1643290318232161@kroah.com>
References: <1643290318232161@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index e05e581af5cf..985181dba0ba 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -468,7 +468,7 @@ Spectre variant 2
    before invoking any firmware code to prevent Spectre variant 2 exploits
    using the firmware.
 
-   Using kernel address space randomization (CONFIG_RANDOMIZE_SLAB=y
+   Using kernel address space randomization (CONFIG_RANDOMIZE_BASE=y
    and CONFIG_SLAB_FREELIST_RANDOM=y in the kernel configuration) makes
    attacks on the kernel generally more difficult.
 
diff --git a/Makefile b/Makefile
index 33ffaa163c2b..0d754c4d8925 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 262
+SUBLEVEL = 263
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm64/boot/dts/nvidia/tegra186.dtsi b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
index a9c3eef6c4e0..3307d816050f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra186.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra186.dtsi
@@ -351,7 +351,7 @@
 
 	ccplex@e000000 {
 		compatible = "nvidia,tegra186-ccplex-cluster";
-		reg = <0x0 0x0e000000 0x0 0x3fffff>;
+		reg = <0x0 0x0e000000 0x0 0x400000>;
 
 		nvidia,bpmp = <&bpmp>;
 	};
diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 94697bab3805..a961b8106000 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -26,8 +26,8 @@
 	#size-cells = <2>;
 
 	aliases {
-		sdhc1 = &sdhc_1; /* SDC1 eMMC slot */
-		sdhc2 = &sdhc_2; /* SDC2 SD card slot */
+		mmc0 = &sdhc_1; /* SDC1 eMMC slot */
+		mmc1 = &sdhc_2; /* SDC2 SD card slot */
 	};
 
 	chosen { };
diff --git a/arch/mips/bcm63xx/clk.c b/arch/mips/bcm63xx/clk.c
index d2a5054b0492..73f2534b9676 100644
--- a/arch/mips/bcm63xx/clk.c
+++ b/arch/mips/bcm63xx/clk.c
@@ -343,6 +343,12 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_get_parent);
 
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
 unsigned long clk_get_rate(struct clk *clk)
 {
 	if (!clk)
diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index e1e24118c169..ed42fc27033c 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -328,6 +328,7 @@ static int __init octeon_ehci_device_init(void)
 
 	pd->dev.platform_data = &octeon_ehci_pdata;
 	octeon_ehci_hw_start(&pd->dev);
+	put_device(&pd->dev);
 
 	return ret;
 }
@@ -391,6 +392,7 @@ static int __init octeon_ohci_device_init(void)
 
 	pd->dev.platform_data = &octeon_ohci_pdata;
 	octeon_ohci_hw_start(&pd->dev);
+	put_device(&pd->dev);
 
 	return ret;
 }
diff --git a/arch/mips/cavium-octeon/octeon-usb.c b/arch/mips/cavium-octeon/octeon-usb.c
index 75189ff2f3c7..3465452e2819 100644
--- a/arch/mips/cavium-octeon/octeon-usb.c
+++ b/arch/mips/cavium-octeon/octeon-usb.c
@@ -543,6 +543,7 @@ static int __init dwc3_octeon_device_init(void)
 			devm_iounmap(&pdev->dev, base);
 			devm_release_mem_region(&pdev->dev, res->start,
 						resource_size(res));
+			put_device(&pdev->dev);
 		}
 	} while (node != NULL);
 
diff --git a/arch/mips/include/asm/octeon/cvmx-bootinfo.h b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
index 62787765575e..ce6e5fddce0b 100644
--- a/arch/mips/include/asm/octeon/cvmx-bootinfo.h
+++ b/arch/mips/include/asm/octeon/cvmx-bootinfo.h
@@ -315,7 +315,7 @@ enum cvmx_chip_types_enum {
 
 /* Functions to return string based on type */
 #define ENUM_BRD_TYPE_CASE(x) \
-	case x: return(#x + 16);	/* Skip CVMX_BOARD_TYPE_ */
+	case x: return (&#x[16]);	/* Skip CVMX_BOARD_TYPE_ */
 static inline const char *cvmx_board_type_to_string(enum
 						    cvmx_board_types_enum type)
 {
@@ -404,7 +404,7 @@ static inline const char *cvmx_board_type_to_string(enum
 }
 
 #define ENUM_CHIP_TYPE_CASE(x) \
-	case x: return(#x + 15);	/* Skip CVMX_CHIP_TYPE */
+	case x: return (&#x[15]);	/* Skip CVMX_CHIP_TYPE */
 static inline const char *cvmx_chip_type_to_string(enum
 						   cvmx_chip_types_enum type)
 {
diff --git a/arch/mips/lantiq/clk.c b/arch/mips/lantiq/clk.c
index a8e309dcd38d..f5fab99d1751 100644
--- a/arch/mips/lantiq/clk.c
+++ b/arch/mips/lantiq/clk.c
@@ -166,6 +166,12 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_get_parent);
 
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
 static inline u32 get_counter_resolution(void)
 {
 	u32 res;
diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index 1e4658eee13f..5a535220d7cd 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -272,7 +272,14 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_enable();
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 9a898d68f4a0..346456c43aa0 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -795,7 +795,7 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0 && !faulthandler_disabled())
+	    if (faulthandler_disabled() || fault_space == 0)
 	    {
 		/* Clean up and return if in exception table. */
 		if (fixup_exception(regs))
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
index 7f60b6060176..39b1c1fa0c81 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
@@ -78,6 +78,7 @@ fman0: fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfc000 0x1000>;
+		fsl,erratum-a009885;
 	};
 
 	xmdio0: mdio@fd000 {
@@ -85,6 +86,7 @@ fman0: fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfd000 0x1000>;
+		fsl,erratum-a009885;
 	};
 
 	ptp_timer0: ptp-timer@fe000 {
diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 6537cba1a758..d1a2fc7186ce 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -258,8 +258,10 @@ int __init btext_find_display(int allow_nonstdout)
 			rc = btext_initialize(np);
 			printk("result: %d\n", rc);
 		}
-		if (rc == 0)
+		if (rc == 0) {
+			of_node_put(np);
 			break;
+		}
 	}
 	return rc;
 }
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index f8782c7ef50f..7f049a60747e 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2774,7 +2774,7 @@ static void __init fixup_device_tree_efika_add_phy(void)
 
 	/* Check if the phy-handle property exists - bail if it does */
 	rv = prom_getprop(node, "phy-handle", prop, sizeof(prop));
-	if (!rv)
+	if (rv <= 0)
 		return;
 
 	/*
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 7c7aa7c98ba3..cf25b95ceee1 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1009,10 +1009,12 @@ void start_secondary(void *unused)
 	BUG();
 }
 
+#ifdef CONFIG_PROFILING
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_SCHED_SMT
 /* cpumask of CPUs with asymetric SMT dependancy */
diff --git a/arch/powerpc/kernel/watchdog.c b/arch/powerpc/kernel/watchdog.c
index ce848ff84edd..1617767ebc9a 100644
--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -106,6 +106,10 @@ static void set_cpumask_stuck(const struct cpumask *cpumask, u64 tb)
 {
 	cpumask_or(&wd_smp_cpus_stuck, &wd_smp_cpus_stuck, cpumask);
 	cpumask_andnot(&wd_smp_cpus_pending, &wd_smp_cpus_pending, cpumask);
+	/*
+	 * See wd_smp_clear_cpu_pending()
+	 */
+	smp_mb();
 	if (cpumask_empty(&wd_smp_cpus_pending)) {
 		wd_smp_last_reset_tb = tb;
 		cpumask_andnot(&wd_smp_cpus_pending,
@@ -177,13 +181,44 @@ static void wd_smp_clear_cpu_pending(int cpu, u64 tb)
 			wd_smp_lock(&flags);
 			cpumask_clear_cpu(cpu, &wd_smp_cpus_stuck);
 			wd_smp_unlock(&flags);
+		} else {
+			/*
+			 * The last CPU to clear pending should have reset the
+			 * watchdog so we generally should not find it empty
+			 * here if our CPU was clear. However it could happen
+			 * due to a rare race with another CPU taking the
+			 * last CPU out of the mask concurrently.
+			 *
+			 * We can't add a warning for it. But just in case
+			 * there is a problem with the watchdog that is causing
+			 * the mask to not be reset, try to kick it along here.
+			 */
+			if (unlikely(cpumask_empty(&wd_smp_cpus_pending)))
+				goto none_pending;
 		}
 		return;
 	}
+
 	cpumask_clear_cpu(cpu, &wd_smp_cpus_pending);
+
+	/*
+	 * Order the store to clear pending with the load(s) to check all
+	 * words in the pending mask to check they are all empty. This orders
+	 * with the same barrier on another CPU. This prevents two CPUs
+	 * clearing the last 2 pending bits, but neither seeing the other's
+	 * store when checking if the mask is empty, and missing an empty
+	 * mask, which ends with a false positive.
+	 */
+	smp_mb();
 	if (cpumask_empty(&wd_smp_cpus_pending)) {
 		unsigned long flags;
 
+none_pending:
+		/*
+		 * Double check under lock because more than one CPU could see
+		 * a clear mask with the lockless check after clearing their
+		 * pending bits.
+		 */
 		wd_smp_lock(&flags);
 		if (cpumask_empty(&wd_smp_cpus_pending)) {
 			wd_smp_last_reset_tb = tb;
@@ -276,8 +311,12 @@ void arch_touch_nmi_watchdog(void)
 {
 	unsigned long ticks = tb_ticks_per_usec * wd_timer_period_ms * 1000;
 	int cpu = smp_processor_id();
-	u64 tb = get_tb();
+	u64 tb;
+
+	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
+		return;
 
+	tb = get_tb();
 	if (tb - per_cpu(wd_timer_tb, cpu) >= ticks) {
 		per_cpu(wd_timer_tb, cpu) = tb;
 		wd_smp_clear_cpu_pending(cpu, tb);
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 4b91ad08eefd..c4f352387aec 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -1088,6 +1088,7 @@ static int __init cell_iommu_fixed_mapping_init(void)
 			if (hbase < dbase || (hend > (dbase + dsize))) {
 				pr_debug("iommu: hash window doesn't fit in"
 					 "real DMA window\n");
+				of_node_put(np);
 				return -1;
 			}
 		}
diff --git a/arch/powerpc/platforms/cell/pervasive.c b/arch/powerpc/platforms/cell/pervasive.c
index a88944db9fc3..97ac2622ee4e 100644
--- a/arch/powerpc/platforms/cell/pervasive.c
+++ b/arch/powerpc/platforms/cell/pervasive.c
@@ -90,6 +90,7 @@ static int cbe_system_reset_exception(struct pt_regs *regs)
 	switch (regs->msr & SRR1_WAKEMASK) {
 	case SRR1_WAKEDEC:
 		set_dec(1);
+		break;
 	case SRR1_WAKEEE:
 		/*
 		 * Handle these when interrupts get re-enabled and we take
diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
index bf4a125faec6..db2ea6b6889d 100644
--- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -220,6 +220,7 @@ void hlwd_pic_probe(void)
 			irq_set_chained_handler(cascade_virq,
 						hlwd_pic_irq_cascade);
 			hlwd_irq_host = host;
+			of_node_put(np);
 			break;
 		}
 	}
diff --git a/arch/powerpc/platforms/powernv/opal-lpc.c b/arch/powerpc/platforms/powernv/opal-lpc.c
index 6c7ad1d8b32e..21f0edcfb84a 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -400,6 +400,7 @@ void __init opal_lpc_init(void)
 		if (!of_get_property(np, "primary", NULL))
 			continue;
 		opal_lpc_chip_id = of_get_ibm_chip_id(np);
+		of_node_put(np);
 		break;
 	}
 	if (opal_lpc_chip_id < 0)
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 9bce54eac0b0..f26ca7fbd44e 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -285,7 +285,14 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	might_sleep();
 	start &= PAGE_MASK;
-	nr = __get_user_pages_fast(start, nr_pages, write, pages);
+	/*
+	 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+	 * because get_user_pages() may need to cause an early COW in
+	 * order to avoid confusing the normal COW routines. So only
+	 * targets that are already writable are safe to do by just
+	 * looking at the page tables.
+	 */
+	nr = __get_user_pages_fast(start, nr_pages, 1, pages);
 	if (nr == nr_pages)
 		return nr;
 
diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
index 8045b5bb7075..4abfc37dd7fe 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -240,7 +240,14 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_enable();
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index 5335ba3c850e..50593ca02144 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -262,7 +262,14 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 
diff --git a/arch/um/include/shared/registers.h b/arch/um/include/shared/registers.h
index a74449b5b0e3..12ad7c435e97 100644
--- a/arch/um/include/shared/registers.h
+++ b/arch/um/include/shared/registers.h
@@ -16,8 +16,8 @@ extern int restore_fp_registers(int pid, unsigned long *fp_regs);
 extern int save_fpx_registers(int pid, unsigned long *fp_regs);
 extern int restore_fpx_registers(int pid, unsigned long *fp_regs);
 extern int save_registers(int pid, struct uml_pt_regs *regs);
-extern int restore_registers(int pid, struct uml_pt_regs *regs);
-extern int init_registers(int pid);
+extern int restore_pid_registers(int pid, struct uml_pt_regs *regs);
+extern int init_pid_registers(int pid);
 extern void get_safe_registers(unsigned long *regs, unsigned long *fp_regs);
 extern unsigned long get_thread_reg(int reg, jmp_buf *buf);
 extern int get_fp_registers(int pid, unsigned long *regs);
diff --git a/arch/um/os-Linux/registers.c b/arch/um/os-Linux/registers.c
index 2ff8d4fe83c4..34a5963bd7ef 100644
--- a/arch/um/os-Linux/registers.c
+++ b/arch/um/os-Linux/registers.c
@@ -21,7 +21,7 @@ int save_registers(int pid, struct uml_pt_regs *regs)
 	return 0;
 }
 
-int restore_registers(int pid, struct uml_pt_regs *regs)
+int restore_pid_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
 
@@ -36,7 +36,7 @@ int restore_registers(int pid, struct uml_pt_regs *regs)
 static unsigned long exec_regs[MAX_REG_NR];
 static unsigned long exec_fp_regs[FP_SIZE];
 
-int init_registers(int pid)
+int init_pid_registers(int pid)
 {
 	int err;
 
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 82bf5f8442ba..2c75f2d63868 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -336,7 +336,7 @@ void __init os_early_checks(void)
 	check_tmpexec();
 
 	pid = start_ptraced_child();
-	if (init_registers(pid))
+	if (init_pid_registers(pid))
 		fatal("Failed to initialize default registers");
 	stop_ptraced_child(pid, 1, 1);
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 94aa91b09c28..2778b66aee8f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -354,7 +354,7 @@ static ssize_t flags_write(struct file *filp, const char __user *ubuf,
 	char buf[MAX_FLAG_OPT_SIZE], *__buf;
 	int err;
 
-	if (cnt > MAX_FLAG_OPT_SIZE)
+	if (!cnt || cnt > MAX_FLAG_OPT_SIZE)
 		return -EINVAL;
 
 	if (copy_from_user(&buf, ubuf, cnt))
diff --git a/arch/x86/um/syscalls_64.c b/arch/x86/um/syscalls_64.c
index 58f51667e2e4..8249685b4096 100644
--- a/arch/x86/um/syscalls_64.c
+++ b/arch/x86/um/syscalls_64.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <asm/prctl.h> /* XXX This should get the constants from libc */
 #include <os.h>
+#include <registers.h>
 
 long arch_prctl(struct task_struct *task, int option,
 		unsigned long __user *arg2)
@@ -35,7 +36,7 @@ long arch_prctl(struct task_struct *task, int option,
 	switch (option) {
 	case ARCH_SET_FS:
 	case ARCH_SET_GS:
-		ret = restore_registers(pid, &current->thread.regs.regs);
+		ret = restore_pid_registers(pid, &current->thread.regs.regs);
 		if (ret)
 			return ret;
 		break;
diff --git a/drivers/acpi/acpica/exoparg1.c b/drivers/acpi/acpica/exoparg1.c
index f787651348c1..9f4dbdb70111 100644
--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -1041,7 +1041,8 @@ acpi_status acpi_ex_opcode_1A_0T_1R(struct acpi_walk_state *walk_state)
 						    (walk_state, return_desc,
 						     &temp_desc);
 						if (ACPI_FAILURE(status)) {
-							goto cleanup;
+							return_ACPI_STATUS
+							    (status);
 						}
 
 						return_desc = temp_desc;
diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 7f8c57177819..45b392fa3665 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -138,7 +138,9 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	/* Flush caches, as per ACPI specification */
 
-	ACPI_FLUSH_CPU_CACHE();
+	if (sleep_state < ACPI_STATE_S4) {
+		ACPI_FLUSH_CPU_CACHE();
+	}
 
 	status = acpi_os_enter_sleep(sleep_state, sleep_control, 0);
 	if (status == AE_CTRL_TERMINATE) {
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 2c54d08b20ca..9e50529bb3cc 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -149,7 +149,9 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 
 	/* Flush caches, as per ACPI specification */
 
-	ACPI_FLUSH_CPU_CACHE();
+	if (sleep_state < ACPI_STATE_S4) {
+		ACPI_FLUSH_CPU_CACHE();
+	}
 
 	status = acpi_os_enter_sleep(sleep_state, pm1a_control, pm1b_control);
 	if (status == AE_CTRL_TERMINATE) {
diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 827c3242225d..b3c773661190 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -223,8 +223,6 @@ acpi_status acpi_enter_sleep_state_s4bios(void)
 		return_ACPI_STATUS(status);
 	}
 
-	ACPI_FLUSH_CPU_CACHE();
-
 	status = acpi_hw_write_port(acpi_gbl_FADT.smi_command,
 				    (u32)acpi_gbl_FADT.s4_bios_request, 8);
 
diff --git a/drivers/acpi/acpica/utdelete.c b/drivers/acpi/acpica/utdelete.c
index 61a979d0fbc5..64a90ba71f18 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -442,6 +442,7 @@ acpi_ut_update_ref_count(union acpi_operand_object *object, u32 action)
 			ACPI_WARNING((AE_INFO,
 				      "Obj %p, Reference Count is already zero, cannot decrement\n",
 				      object));
+			return;
 		}
 
 		ACPI_DEBUG_PRINT((ACPI_DB_ALLOCATIONS,
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cbf74731cfce..057bedeaacab 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -994,7 +994,7 @@ static DECLARE_DELAYED_WORK(fd_timer, fd_timer_workfn);
 static void cancel_activity(void)
 {
 	do_floppy = NULL;
-	cancel_delayed_work_sync(&fd_timer);
+	cancel_delayed_work(&fd_timer);
 	cancel_work_sync(&floppy_work);
 }
 
@@ -3118,6 +3118,8 @@ static void raw_cmd_free(struct floppy_raw_cmd **ptr)
 	}
 }
 
+#define MAX_LEN (1UL << MAX_ORDER << PAGE_SHIFT)
+
 static int raw_cmd_copyin(int cmd, void __user *param,
 				 struct floppy_raw_cmd **rcmd)
 {
@@ -3155,7 +3157,7 @@ static int raw_cmd_copyin(int cmd, void __user *param,
 	ptr->resultcode = 0;
 
 	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
-		if (ptr->length <= 0)
+		if (ptr->length <= 0 || ptr->length >= MAX_LEN)
 			return -EINVAL;
 		ptr->kernel_data = (char *)fd_dma_mem_alloc(ptr->length);
 		fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index ab090a313a5f..099d1ec34310 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -644,6 +644,9 @@ static int bfusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	data->bulk_out_ep   = bulk_out_ep->desc.bEndpointAddress;
 	data->bulk_pkt_size = le16_to_cpu(bulk_out_ep->desc.wMaxPacketSize);
 
+	if (!data->bulk_pkt_size)
+		goto done;
+
 	rwlock_init(&data->lock);
 
 	data->reassembly = NULL;
diff --git a/drivers/char/mwave/3780i.h b/drivers/char/mwave/3780i.h
index 9ccb6b270b07..95164246afd1 100644
--- a/drivers/char/mwave/3780i.h
+++ b/drivers/char/mwave/3780i.h
@@ -68,7 +68,7 @@ typedef struct {
 	unsigned char ClockControl:1;	/* RW: Clock control: 0=normal, 1=stop 3780i clocks */
 	unsigned char SoftReset:1;	/* RW: Soft reset 0=normal, 1=soft reset active */
 	unsigned char ConfigMode:1;	/* RW: Configuration mode, 0=normal, 1=config mode */
-	unsigned char Reserved:5;	/* 0: Reserved */
+	unsigned short Reserved:13;	/* 0: Reserved */
 } DSP_ISA_SLAVE_CONTROL;
 
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index a7ec07e499ba..1eb0cdbe8786 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -813,8 +813,8 @@ static void do_numa_crng_init(struct work_struct *work)
 		crng_initialize(crng);
 		pool[i] = crng;
 	}
-	mb();
-	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+	/* pairs with READ_ONCE() in select_crng() */
+	if (cmpxchg_release(&crng_node_pool, NULL, pool) != NULL) {
 		for_each_node(i)
 			kfree(pool[i]);
 		kfree(pool);
@@ -827,8 +827,26 @@ static void numa_crng_init(void)
 {
 	schedule_work(&numa_crng_init_work);
 }
+
+static struct crng_state *select_crng(void)
+{
+	struct crng_state **pool;
+	int nid = numa_node_id();
+
+	/* pairs with cmpxchg_release() in do_numa_crng_init() */
+	pool = READ_ONCE(crng_node_pool);
+	if (pool && pool[nid])
+		return pool[nid];
+
+	return &primary_crng;
+}
 #else
 static void numa_crng_init(void) {}
+
+static struct crng_state *select_crng(void)
+{
+	return &primary_crng;
+}
 #endif
 
 /*
@@ -933,7 +951,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		crng->state[i+4] ^= buf.key[i] ^ rv;
 	}
 	memzero_explicit(&buf, sizeof(buf));
-	crng->init_time = jiffies;
+	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
 	if (crng == &primary_crng && crng_init < 2) {
 		invalidate_batched_entropy();
@@ -960,12 +978,15 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA20_BLOCK_SIZE])
 {
-	unsigned long v, flags;
-
-	if (crng_ready() &&
-	    (time_after(crng_global_init_time, crng->init_time) ||
-	     time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL)))
-		crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
+	unsigned long v, flags, init_time;
+
+	if (crng_ready()) {
+		init_time = READ_ONCE(crng->init_time);
+		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
+		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
+			crng_reseed(crng, crng == &primary_crng ?
+				    &input_pool : NULL);
+	}
 	spin_lock_irqsave(&crng->lock, flags);
 	if (arch_get_random_long(&v))
 		crng->state[14] ^= v;
@@ -977,15 +998,7 @@ static void _extract_crng(struct crng_state *crng,
 
 static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_extract_crng(crng, out);
+	_extract_crng(select_crng(), out);
 }
 
 /*
@@ -1014,15 +1027,7 @@ static void _crng_backtrack_protect(struct crng_state *crng,
 
 static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
-	struct crng_state *crng = NULL;
-
-#ifdef CONFIG_NUMA
-	if (crng_node_pool)
-		crng = crng_node_pool[numa_node_id()];
-	if (crng == NULL)
-#endif
-		crng = &primary_crng;
-	_crng_backtrack_protect(crng, tmp, used);
+	_crng_backtrack_protect(select_crng(), tmp, used);
 }
 
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
@@ -1985,7 +1990,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		if (crng_init < 2)
 			return -ENODATA;
 		crng_reseed(&primary_crng, &input_pool);
-		crng_global_init_time = jiffies - 1;
+		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 1ac9abcdad52..9e42943f6a59 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -809,7 +809,15 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
+
+	rc = request_locality(chip, 0);
+	if (rc < 0) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
 	tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
+	release_locality(chip, 0);
 
 	rc = tpm2_probe(chip);
 	if (rc)
diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index 98295b970317..8ccd72cc66ba 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -949,8 +949,7 @@ static int bcm2835_clock_is_on(struct clk_hw *hw)
 
 static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
 				    unsigned long rate,
-				    unsigned long parent_rate,
-				    bool round_up)
+				    unsigned long parent_rate)
 {
 	struct bcm2835_clock *clock = bcm2835_clock_from_hw(hw);
 	const struct bcm2835_clock_data *data = clock->data;
@@ -962,10 +961,6 @@ static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
 
 	rem = do_div(temp, rate);
 	div = temp;
-
-	/* Round up and mask off the unused bits */
-	if (round_up && ((div & unused_frac_mask) != 0 || rem != 0))
-		div += unused_frac_mask + 1;
 	div &= ~unused_frac_mask;
 
 	/* different clamping limits apply for a mash clock */
@@ -1096,7 +1091,7 @@ static int bcm2835_clock_set_rate(struct clk_hw *hw,
 	struct bcm2835_clock *clock = bcm2835_clock_from_hw(hw);
 	struct bcm2835_cprman *cprman = clock->cprman;
 	const struct bcm2835_clock_data *data = clock->data;
-	u32 div = bcm2835_clock_choose_div(hw, rate, parent_rate, false);
+	u32 div = bcm2835_clock_choose_div(hw, rate, parent_rate);
 	u32 ctl;
 
 	spin_lock(&cprman->regs_lock);
@@ -1147,7 +1142,7 @@ static unsigned long bcm2835_clock_choose_div_and_prate(struct clk_hw *hw,
 
 	if (!(BIT(parent_idx) & data->set_rate_parent)) {
 		*prate = clk_hw_get_rate(parent);
-		*div = bcm2835_clock_choose_div(hw, rate, *prate, true);
+		*div = bcm2835_clock_choose_div(hw, rate, *prate);
 
 		*avgrate = bcm2835_clock_rate_from_divisor(clock, *prate, *div);
 
@@ -1233,7 +1228,7 @@ static int bcm2835_clock_determine_rate(struct clk_hw *hw,
 		rate = bcm2835_clock_choose_div_and_prate(hw, i, req->rate,
 							  &div, &prate,
 							  &avgrate);
-		if (rate > best_rate && rate <= req->rate) {
+		if (abs(req->rate - rate) < abs(req->rate - best_rate)) {
 			best_parent = parent;
 			best_prate = prate;
 			best_rate = rate;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 47e114ac09d0..ff1e788f9276 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -544,8 +544,8 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 
 	ret = crypto_register_ahash(alg);
 	if (ret) {
-		kfree(tmpl);
 		dev_err(qce->dev, "%s registration failed\n", base->cra_name);
+		kfree(tmpl);
 		return ret;
 	}
 
diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
index 8f09b8430893..d5a5b768ef44 100644
--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -206,7 +206,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
@@ -228,7 +228,7 @@ static struct shash_alg algs[] = {
 		.digestsize     = CHKSUM_DIGEST_SIZE,
 		.base           = {
 			.cra_name               = "crc32c",
-			.cra_driver_name        = DRIVER_NAME,
+			.cra_driver_name        = "stm32-crc32-crc32c",
 			.cra_priority           = 200,
 			.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
 			.cra_blocksize          = CHKSUM_BLOCK_SIZE,
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 8c2da523a8ff..5b182061da22 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -100,6 +100,7 @@
 #define		AT_XDMAC_CNDC_NDE		(0x1 << 0)		/* Channel x Next Descriptor Enable */
 #define		AT_XDMAC_CNDC_NDSUP		(0x1 << 1)		/* Channel x Next Descriptor Source Update */
 #define		AT_XDMAC_CNDC_NDDUP		(0x1 << 2)		/* Channel x Next Descriptor Destination Update */
+#define		AT_XDMAC_CNDC_NDVIEW_MASK	GENMASK(28, 27)
 #define		AT_XDMAC_CNDC_NDVIEW_NDV0	(0x0 << 3)		/* Channel x Next Descriptor View 0 */
 #define		AT_XDMAC_CNDC_NDVIEW_NDV1	(0x1 << 3)		/* Channel x Next Descriptor View 1 */
 #define		AT_XDMAC_CNDC_NDVIEW_NDV2	(0x2 << 3)		/* Channel x Next Descriptor View 2 */
@@ -231,15 +232,15 @@ struct at_xdmac {
 
 /* Linked List Descriptor */
 struct at_xdmac_lld {
-	dma_addr_t	mbr_nda;	/* Next Descriptor Member */
-	u32		mbr_ubc;	/* Microblock Control Member */
-	dma_addr_t	mbr_sa;		/* Source Address Member */
-	dma_addr_t	mbr_da;		/* Destination Address Member */
-	u32		mbr_cfg;	/* Configuration Register */
-	u32		mbr_bc;		/* Block Control Register */
-	u32		mbr_ds;		/* Data Stride Register */
-	u32		mbr_sus;	/* Source Microblock Stride Register */
-	u32		mbr_dus;	/* Destination Microblock Stride Register */
+	u32 mbr_nda;	/* Next Descriptor Member */
+	u32 mbr_ubc;	/* Microblock Control Member */
+	u32 mbr_sa;	/* Source Address Member */
+	u32 mbr_da;	/* Destination Address Member */
+	u32 mbr_cfg;	/* Configuration Register */
+	u32 mbr_bc;	/* Block Control Register */
+	u32 mbr_ds;	/* Data Stride Register */
+	u32 mbr_sus;	/* Source Microblock Stride Register */
+	u32 mbr_dus;	/* Destination Microblock Stride Register */
 };
 
 /* 64-bit alignment needed to update CNDA and CUBC registers in an atomic way. */
@@ -344,9 +345,6 @@ static void at_xdmac_start_xfer(struct at_xdmac_chan *atchan,
 
 	dev_vdbg(chan2dev(&atchan->chan), "%s: desc 0x%p\n", __func__, first);
 
-	if (at_xdmac_chan_is_enabled(atchan))
-		return;
-
 	/* Set transfer as active to not try to start it again. */
 	first->active_xfer = true;
 
@@ -362,7 +360,8 @@ static void at_xdmac_start_xfer(struct at_xdmac_chan *atchan,
 	 */
 	if (at_xdmac_chan_is_cyclic(atchan))
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV1;
-	else if (first->lld.mbr_ubc & AT_XDMAC_MBR_UBC_NDV3)
+	else if ((first->lld.mbr_ubc &
+		  AT_XDMAC_CNDC_NDVIEW_MASK) == AT_XDMAC_MBR_UBC_NDV3)
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV3;
 	else
 		reg = AT_XDMAC_CNDC_NDVIEW_NDV2;
@@ -427,13 +426,12 @@ static dma_cookie_t at_xdmac_tx_submit(struct dma_async_tx_descriptor *tx)
 	spin_lock_irqsave(&atchan->lock, irqflags);
 	cookie = dma_cookie_assign(tx);
 
+	list_add_tail(&desc->xfer_node, &atchan->xfers_list);
+	spin_unlock_irqrestore(&atchan->lock, irqflags);
+
 	dev_vdbg(chan2dev(tx->chan), "%s: atchan 0x%p, add desc 0x%p to xfers_list\n",
 		 __func__, atchan, desc);
-	list_add_tail(&desc->xfer_node, &atchan->xfers_list);
-	if (list_is_singular(&atchan->xfers_list))
-		at_xdmac_start_xfer(atchan, desc);
 
-	spin_unlock_irqrestore(&atchan->lock, irqflags);
 	return cookie;
 }
 
diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index eb3a1f42ab06..e8b2d3e31de8 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -722,12 +722,6 @@ static int mmp_pdma_config(struct dma_chan *dchan,
 
 	chan->dir = cfg->direction;
 	chan->dev_addr = addr;
-	/* FIXME: drivers should be ported over to use the filter
-	 * function. Once that's done, the following two lines can
-	 * be removed.
-	 */
-	if (cfg->slave_id)
-		chan->drcmr = cfg->slave_id;
 
 	return 0;
 }
diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index b53fb618bbf6..99a8ff130ad5 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -956,13 +956,6 @@ static void pxad_get_config(struct pxad_chan *chan,
 		*dcmd |= PXA_DCMD_BURST16;
 	else if (maxburst == 32)
 		*dcmd |= PXA_DCMD_BURST32;
-
-	/* FIXME: drivers should be ported over to use the filter
-	 * function. Once that's done, the following two lines can
-	 * be removed.
-	 */
-	if (chan->cfg.slave_id)
-		chan->drcmr = chan->cfg.slave_id;
 }
 
 static struct dma_async_tx_descriptor *
diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index f16b381a569c..ca049ecf5cfd 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -2,9 +2,9 @@ menuconfig GOOGLE_FIRMWARE
 	bool "Google Firmware Drivers"
 	default n
 	help
-	  These firmware drivers are used by Google's servers.  They are
-	  only useful if you are working directly on one of their
-	  proprietary servers.  If in doubt, say "N".
+	  These firmware drivers are used by Google servers,
+	  Chromebooks and other devices using coreboot firmware.
+	  If in doubt, say "N".
 
 if GOOGLE_FIRMWARE
 
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index c380ce957d8d..60e394da9709 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -943,10 +943,17 @@ int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
 			irq_flags = acpi_dev_get_irq_type(info.triggering,
 							  info.polarity);
 
-			/* Set type if specified and different than the current one */
-			if (irq_flags != IRQ_TYPE_NONE &&
-			    irq_flags != irq_get_trigger_type(irq))
-				irq_set_irq_type(irq, irq_flags);
+			/*
+			 * If the IRQ is not already in use then set type
+			 * if specified and different than the current one.
+			 */
+			if (can_request_irq(irq, irq_flags)) {
+				if (irq_flags != IRQ_TYPE_NONE &&
+				    irq_flags != irq_get_trigger_type(irq))
+					irq_set_irq_type(irq, irq_flags);
+			} else {
+				dev_dbg(&adev->dev, "IRQ %d already in use\n", irq);
+			}
 
 			return irq;
 		}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 54f414279037..0894bb98dc51 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -404,6 +404,9 @@ amdgpu_connector_lcd_native_mode(struct drm_encoder *encoder)
 	    native_mode->vdisplay != 0 &&
 	    native_mode->clock != 0) {
 		mode = drm_mode_duplicate(dev, native_mode);
+		if (!mode)
+			return NULL;
+
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		drm_mode_set_name(mode);
 
@@ -418,6 +421,9 @@ amdgpu_connector_lcd_native_mode(struct drm_encoder *encoder)
 		 * simpler.
 		 */
 		mode = drm_cvt_mode(dev, native_mode->hdisplay, native_mode->vdisplay, 60, true, false, false);
+		if (!mode)
+			return NULL;
+
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		DRM_DEBUG_KMS("Adding cvt approximation of native panel mode %s\n", mode->name);
 	}
diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 9f522372a488..4ab7b034bfec 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -302,19 +302,10 @@ static void ge_b850v3_lvds_remove(void)
 	mutex_unlock(&ge_b850v3_lvds_dev_mutex);
 }
 
-static int stdp4028_ge_b850v3_fw_probe(struct i2c_client *stdp4028_i2c,
-				       const struct i2c_device_id *id)
+static int ge_b850v3_register(void)
 {
+	struct i2c_client *stdp4028_i2c = ge_b850v3_lvds_ptr->stdp4028_i2c;
 	struct device *dev = &stdp4028_i2c->dev;
-	int ret;
-
-	ret = ge_b850v3_lvds_init(dev);
-
-	if (ret)
-		return ret;
-
-	ge_b850v3_lvds_ptr->stdp4028_i2c = stdp4028_i2c;
-	i2c_set_clientdata(stdp4028_i2c, ge_b850v3_lvds_ptr);
 
 	/* drm bridge initialization */
 	ge_b850v3_lvds_ptr->bridge.funcs = &ge_b850v3_lvds_funcs;
@@ -336,6 +327,27 @@ static int stdp4028_ge_b850v3_fw_probe(struct i2c_client *stdp4028_i2c,
 			"ge-b850v3-lvds-dp", ge_b850v3_lvds_ptr);
 }
 
+static int stdp4028_ge_b850v3_fw_probe(struct i2c_client *stdp4028_i2c,
+				       const struct i2c_device_id *id)
+{
+	struct device *dev = &stdp4028_i2c->dev;
+	int ret;
+
+	ret = ge_b850v3_lvds_init(dev);
+
+	if (ret)
+		return ret;
+
+	ge_b850v3_lvds_ptr->stdp4028_i2c = stdp4028_i2c;
+	i2c_set_clientdata(stdp4028_i2c, ge_b850v3_lvds_ptr);
+
+	/* Only register after both bridges are probed */
+	if (!ge_b850v3_lvds_ptr->stdp2690_i2c)
+		return 0;
+
+	return ge_b850v3_register();
+}
+
 static int stdp4028_ge_b850v3_fw_remove(struct i2c_client *stdp4028_i2c)
 {
 	ge_b850v3_lvds_remove();
@@ -379,7 +391,11 @@ static int stdp2690_ge_b850v3_fw_probe(struct i2c_client *stdp2690_i2c,
 	ge_b850v3_lvds_ptr->stdp2690_i2c = stdp2690_i2c;
 	i2c_set_clientdata(stdp2690_i2c, ge_b850v3_lvds_ptr);
 
-	return 0;
+	/* Only register after both bridges are probed */
+	if (!ge_b850v3_lvds_ptr->stdp4028_i2c)
+		return 0;
+
+	return ge_b850v3_register();
 }
 
 static int stdp2690_ge_b850v3_fw_remove(struct i2c_client *stdp2690_i2c)
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index fd6080437763..087634693346 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2985,9 +2985,9 @@ static void snb_wm_latency_quirk(struct drm_i915_private *dev_priv)
 	 * The BIOS provided WM memory latency values are often
 	 * inadequate for high resolution displays. Adjust them.
 	 */
-	changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12) |
-		ilk_increase_wm_latency(dev_priv, dev_priv->wm.spr_latency, 12) |
-		ilk_increase_wm_latency(dev_priv, dev_priv->wm.cur_latency, 12);
+	changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12);
+	changed |= ilk_increase_wm_latency(dev_priv, dev_priv->wm.spr_latency, 12);
+	changed |= ilk_increase_wm_latency(dev_priv, dev_priv->wm.cur_latency, 12);
 
 	if (!changed)
 		return;
diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index fde11ce466e4..495c4043467e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -106,12 +106,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_device *bdev,
 	else
 		nvbe->ttm.ttm.func = &nv50_sgdma_backend;
 
-	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))
-		/*
-		 * A failing ttm_dma_tt_init() will call ttm_tt_destroy()
-		 * and thus our nouveau_sgdma_destroy() hook, so we don't need
-		 * to free nvbe here.
-		 */
+	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page)) {
+		kfree(nvbe);
 		return NULL;
+	}
 	return &nvbe->ttm.ttm;
 }
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
index ce70a193caa7..8cf3d1b4662d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
@@ -70,20 +70,13 @@ nvkm_pmu_fini(struct nvkm_subdev *subdev, bool suspend)
 	return 0;
 }
 
-static int
+static void
 nvkm_pmu_reset(struct nvkm_pmu *pmu)
 {
 	struct nvkm_device *device = pmu->subdev.device;
 
 	if (!pmu->func->enabled(pmu))
-		return 0;
-
-	/* Inhibit interrupts, and wait for idle. */
-	nvkm_wr32(device, 0x10a014, 0x0000ffff);
-	nvkm_msec(device, 2000,
-		if (!nvkm_rd32(device, 0x10a04c))
-			break;
-	);
+		return;
 
 	/* Reset. */
 	if (pmu->func->reset)
@@ -94,25 +87,37 @@ nvkm_pmu_reset(struct nvkm_pmu *pmu)
 		if (!(nvkm_rd32(device, 0x10a10c) & 0x00000006))
 			break;
 	);
-
-	return 0;
 }
 
 static int
 nvkm_pmu_preinit(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	return nvkm_pmu_reset(pmu);
+	nvkm_pmu_reset(pmu);
+	return 0;
 }
 
 static int
 nvkm_pmu_init(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	int ret = nvkm_pmu_reset(pmu);
-	if (ret == 0 && pmu->func->init)
-		ret = pmu->func->init(pmu);
-	return ret;
+	struct nvkm_device *device = pmu->subdev.device;
+
+	if (!pmu->func->init)
+		return 0;
+
+	if (pmu->func->enabled(pmu)) {
+		/* Inhibit interrupts, and wait for idle. */
+		nvkm_wr32(device, 0x10a014, 0x0000ffff);
+		nvkm_msec(device, 2000,
+			if (!nvkm_rd32(device, 0x10a04c))
+				break;
+		);
+
+		nvkm_pmu_reset(pmu);
+	}
+
+	return pmu->func->init(pmu);
 }
 
 static int
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 4973bd241aec..b067ed26b9f5 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -655,6 +655,8 @@ void radeon_driver_lastclose_kms(struct drm_device *dev)
 int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 {
 	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_fpriv *fpriv;
+	struct radeon_vm *vm;
 	int r;
 
 	file_priv->driver_priv = NULL;
@@ -667,48 +669,52 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 
 	/* new gpu have virtual address space support */
 	if (rdev->family >= CHIP_CAYMAN) {
-		struct radeon_fpriv *fpriv;
-		struct radeon_vm *vm;
 
 		fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
 		if (unlikely(!fpriv)) {
 			r = -ENOMEM;
-			goto out_suspend;
+			goto err_suspend;
 		}
 
 		if (rdev->accel_working) {
 			vm = &fpriv->vm;
 			r = radeon_vm_init(rdev, vm);
-			if (r) {
-				kfree(fpriv);
-				goto out_suspend;
-			}
+			if (r)
+				goto err_fpriv;
 
 			r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
-			if (r) {
-				radeon_vm_fini(rdev, vm);
-				kfree(fpriv);
-				goto out_suspend;
-			}
+			if (r)
+				goto err_vm_fini;
 
 			/* map the ib pool buffer read only into
 			 * virtual address space */
 			vm->ib_bo_va = radeon_vm_bo_add(rdev, vm,
 							rdev->ring_tmp_bo.bo);
+			if (!vm->ib_bo_va) {
+				r = -ENOMEM;
+				goto err_vm_fini;
+			}
+
 			r = radeon_vm_bo_set_addr(rdev, vm->ib_bo_va,
 						  RADEON_VA_IB_OFFSET,
 						  RADEON_VM_PAGE_READABLE |
 						  RADEON_VM_PAGE_SNOOPED);
-			if (r) {
-				radeon_vm_fini(rdev, vm);
-				kfree(fpriv);
-				goto out_suspend;
-			}
+			if (r)
+				goto err_vm_fini;
 		}
 		file_priv->driver_priv = fpriv;
 	}
 
-out_suspend:
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
+	return 0;
+
+err_vm_fini:
+	radeon_vm_fini(rdev, vm);
+err_fpriv:
+	kfree(fpriv);
+
+err_suspend:
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 	return r;
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 8ebc8d3560c3..fc8bdcc1541b 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -199,7 +199,6 @@ int ttm_tt_init(struct ttm_tt *ttm, struct ttm_bo_device *bdev,
 
 	ttm_tt_alloc_page_directory(ttm);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}
@@ -232,7 +231,6 @@ int ttm_dma_tt_init(struct ttm_dma_tt *ttm_dma, struct ttm_bo_device *bdev,
 	INIT_LIST_HEAD(&ttm_dma->pages_list);
 	ttm_dma_tt_alloc_page_directory(ttm_dma);
 	if (!ttm->pages) {
-		ttm_tt_destroy(ttm);
 		pr_err("Failed allocating page table\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 4e3dd3f55a96..80ecbf14d3c8 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -392,7 +392,7 @@ static int apple_input_configured(struct hid_device *hdev,
 
 	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
 		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
-		asc->quirks = 0;
+		asc->quirks &= ~APPLE_HAS_FN;
 	}
 
 	return 0;
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index c749f449c7cb..333b6a769189 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -32,11 +32,22 @@
 
 struct uhid_device {
 	struct mutex devlock;
+
+	/* This flag tracks whether the HID device is usable for commands from
+	 * userspace. The flag is already set before hid_add_device(), which
+	 * runs in workqueue context, to allow hid_add_device() to communicate
+	 * with userspace.
+	 * However, if hid_add_device() fails, the flag is cleared without
+	 * holding devlock.
+	 * We guarantee that if @running changes from true to false while you're
+	 * holding @devlock, it's still fine to access @hid.
+	 */
 	bool running;
 
 	__u8 *rd_data;
 	uint rd_size;
 
+	/* When this is NULL, userspace may use UHID_CREATE/UHID_CREATE2. */
 	struct hid_device *hid;
 	struct uhid_event input_buf;
 
@@ -67,9 +78,18 @@ static void uhid_device_add_worker(struct work_struct *work)
 	if (ret) {
 		hid_err(uhid->hid, "Cannot register HID device: error %d\n", ret);
 
-		hid_destroy_device(uhid->hid);
-		uhid->hid = NULL;
+		/* We used to call hid_destroy_device() here, but that's really
+		 * messy to get right because we have to coordinate with
+		 * concurrent writes from userspace that might be in the middle
+		 * of using uhid->hid.
+		 * Just leave uhid->hid as-is for now, and clean it up when
+		 * userspace tries to close or reinitialize the uhid instance.
+		 *
+		 * However, we do have to clear the ->running flag and do a
+		 * wakeup to make sure userspace knows that the device is gone.
+		 */
 		uhid->running = false;
+		wake_up_interruptible(&uhid->report_wait);
 	}
 }
 
@@ -478,7 +498,7 @@ static int uhid_dev_create2(struct uhid_device *uhid,
 	void *rd_data;
 	int ret;
 
-	if (uhid->running)
+	if (uhid->hid)
 		return -EALREADY;
 
 	rd_size = ev->u.create2.rd_size;
@@ -559,7 +579,7 @@ static int uhid_dev_create(struct uhid_device *uhid,
 
 static int uhid_dev_destroy(struct uhid_device *uhid)
 {
-	if (!uhid->running)
+	if (!uhid->hid)
 		return -EINVAL;
 
 	uhid->running = false;
@@ -568,6 +588,7 @@ static int uhid_dev_destroy(struct uhid_device *uhid)
 	cancel_work_sync(&uhid->worker);
 
 	hid_destroy_device(uhid->hid);
+	uhid->hid = NULL;
 	kfree(uhid->rd_data);
 
 	return 0;
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 14373b06e63d..3511933429da 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2424,6 +2424,24 @@ static void wacom_wac_finger_slot(struct wacom_wac *wacom_wac,
 	}
 }
 
+static bool wacom_wac_slot_is_active(struct input_dev *dev, int key)
+{
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *s;
+
+	if (!mt)
+		return false;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
+		if (s->key == key &&
+			input_mt_get_value(s, ABS_MT_TRACKING_ID) >= 0) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void wacom_wac_finger_event(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage, __s32 value)
 {
@@ -2466,9 +2484,14 @@ static void wacom_wac_finger_event(struct hid_device *hdev,
 
 
 	if (usage->usage_index + 1 == field->report_count) {
-		if (equivalent_usage == wacom_wac->hid_data.last_slot_field &&
-		    wacom_wac->hid_data.confidence)
-			wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
+		if (equivalent_usage == wacom_wac->hid_data.last_slot_field) {
+			bool touch_removed = wacom_wac_slot_is_active(wacom_wac->touch_input,
+				wacom_wac->hid_data.id) && !wacom_wac->hid_data.tipswitch;
+
+			if (wacom_wac->hid_data.confidence || touch_removed) {
+				wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
+			}
+		}
 	}
 }
 
@@ -2482,6 +2505,10 @@ static void wacom_wac_finger_pre_report(struct hid_device *hdev,
 
 	hid_data->confidence = true;
 
+	hid_data->cc_report = 0;
+	hid_data->cc_index = -1;
+	hid_data->cc_value_index = -1;
+
 	for (i = 0; i < report->maxfield; i++) {
 		struct hid_field *field = report->field[i];
 		int j;
diff --git a/drivers/hsi/hsi_core.c b/drivers/hsi/hsi_core.c
index 71895da63810..daf2de837a30 100644
--- a/drivers/hsi/hsi_core.c
+++ b/drivers/hsi/hsi_core.c
@@ -115,6 +115,7 @@ struct hsi_client *hsi_new_client(struct hsi_port *port,
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", info->name);
 		put_device(&cl->device);
+		goto err;
 	}
 
 	return cl;
diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 86e1bd0b82e9..347d82dff67c 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -50,10 +50,10 @@ enum dw_pci_ctl_id_t {
 };
 
 struct dw_scl_sda_cfg {
-	u32 ss_hcnt;
-	u32 fs_hcnt;
-	u32 ss_lcnt;
-	u32 fs_lcnt;
+	u16 ss_hcnt;
+	u16 fs_hcnt;
+	u16 ss_lcnt;
+	u16 fs_lcnt;
 	u32 sda_hold;
 };
 
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 7b1654b0fb6d..c817e3d4b52b 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -769,6 +769,11 @@ static int i801_block_transaction(struct i801_priv *priv,
 	int result = 0;
 	unsigned char hostc;
 
+	if (read_write == I2C_SMBUS_READ && command == I2C_SMBUS_BLOCK_DATA)
+		data->block[0] = I2C_SMBUS_BLOCK_MAX;
+	else if (data->block[0] < 1 || data->block[0] > I2C_SMBUS_BLOCK_MAX)
+		return -EPROTO;
+
 	if (command == I2C_SMBUS_I2C_BLOCK_DATA) {
 		if (read_write == I2C_SMBUS_WRITE) {
 			/* set I2C_EN bit in configuration register */
@@ -782,16 +787,6 @@ static int i801_block_transaction(struct i801_priv *priv,
 		}
 	}
 
-	if (read_write == I2C_SMBUS_WRITE
-	 || command == I2C_SMBUS_I2C_BLOCK_DATA) {
-		if (data->block[0] < 1)
-			data->block[0] = 1;
-		if (data->block[0] > I2C_SMBUS_BLOCK_MAX)
-			data->block[0] = I2C_SMBUS_BLOCK_MAX;
-	} else {
-		data->block[0] = 32;	/* max for SMBus block reads */
-	}
-
 	/* Experience has shown that the block buffer can only be used for
 	   SMBus (not I2C) block transactions, even though the datasheet
 	   doesn't mention this limitation. */
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 7db5554d2b4e..194bf06ecb25 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -107,23 +107,30 @@ static irqreturn_t mpc_i2c_isr(int irq, void *dev_id)
 /* Sometimes 9th clock pulse isn't generated, and slave doesn't release
  * the bus, because it wants to send ACK.
  * Following sequence of enabling/disabling and sending start/stop generates
- * the 9 pulses, so it's all OK.
+ * the 9 pulses, each with a START then ending with STOP, so it's all OK.
  */
 static void mpc_i2c_fixup(struct mpc_i2c *i2c)
 {
 	int k;
-	u32 delay_val = 1000000 / i2c->real_clk + 1;
-
-	if (delay_val < 2)
-		delay_val = 2;
+	unsigned long flags;
 
 	for (k = 9; k; k--) {
 		writeccr(i2c, 0);
-		writeccr(i2c, CCR_MSTA | CCR_MTX | CCR_MEN);
+		writeb(0, i2c->base + MPC_I2C_SR); /* clear any status bits */
+		writeccr(i2c, CCR_MEN | CCR_MSTA); /* START */
+		readb(i2c->base + MPC_I2C_DR); /* init xfer */
+		udelay(15); /* let it hit the bus */
+		local_irq_save(flags); /* should not be delayed further */
+		writeccr(i2c, CCR_MEN | CCR_MSTA | CCR_RSTA); /* delay SDA */
 		readb(i2c->base + MPC_I2C_DR);
-		writeccr(i2c, CCR_MEN);
-		udelay(delay_val << 1);
+		if (k != 1)
+			udelay(5);
+		local_irq_restore(flags);
 	}
+	writeccr(i2c, CCR_MEN); /* Initiate STOP */
+	readb(i2c->base + MPC_I2C_DR);
+	udelay(15); /* Let STOP propagate */
+	writeccr(i2c, 0);
 }
 
 static int i2c_wait(struct mpc_i2c *i2c, unsigned timeout, int writing)
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 6b0d1d8609ca..b230f156a996 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1075,7 +1075,8 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
 			ret = ib_query_gid(device, port, i, &tmp_gid, NULL);
 			if (ret)
-				return ret;
+				continue;
+
 			if (!memcmp(&tmp_gid, gid, sizeof *gid)) {
 				*port_num = port;
 				if (index)
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 325561580729..225d4466fcb2 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -2115,6 +2115,7 @@ int c4iw_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	memset(attr, 0, sizeof *attr);
 	memset(init_attr, 0, sizeof *init_attr);
 	attr->qp_state = to_ib_qp_state(qhp->attr.state);
+	attr->cur_qp_state = to_ib_qp_state(qhp->attr.state);
 	init_attr->cap.max_send_wr = qhp->attr.sq_num_entries;
 	init_attr->cap.max_recv_wr = qhp->attr.rq_num_entries;
 	init_attr->cap.max_send_sge = qhp->attr.sq_max_sges;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index d9777b662eba..f4db0418a39f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -294,6 +294,9 @@ static int hns_roce_query_gid(struct ib_device *ib_dev, u8 port_num, int index,
 static int hns_roce_query_pkey(struct ib_device *ib_dev, u8 port, u16 index,
 			       u16 *pkey)
 {
+	if (index > 0)
+		return -EINVAL;
+
 	*pkey = PKEY_ID;
 
 	return 0;
@@ -374,7 +377,7 @@ static int hns_roce_mmap(struct ib_ucontext *context,
 		return -EINVAL;
 
 	if (vma->vm_pgoff == 0) {
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       to_hr_ucontext(context)->uar.pfn,
 				       PAGE_SIZE, vma->vm_page_prot))
diff --git a/drivers/infiniband/sw/rxe/rxe_opcode.c b/drivers/infiniband/sw/rxe/rxe_opcode.c
index 4cf11063e0b5..0f166d6d0ccb 100644
--- a/drivers/infiniband/sw/rxe/rxe_opcode.c
+++ b/drivers/infiniband/sw/rxe/rxe_opcode.c
@@ -137,7 +137,7 @@ struct rxe_opcode_info rxe_opcode[RXE_NUM_OPCODE] = {
 		}
 	},
 	[IB_OPCODE_RC_SEND_MIDDLE]		= {
-		.name	= "IB_OPCODE_RC_SEND_MIDDLE]",
+		.name	= "IB_OPCODE_RC_SEND_MIDDLE",
 		.mask	= RXE_PAYLOAD_MASK | RXE_REQ_MASK | RXE_SEND_MASK
 				| RXE_MIDDLE_MASK,
 		.length = RXE_BTH_BYTES,
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 2c97d2552c5b..ebee9e191b3e 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -68,8 +68,7 @@ static void free_iova_flush_queue(struct iova_domain *iovad)
 	if (!has_iova_flush_queue(iovad))
 		return;
 
-	if (timer_pending(&iovad->fq_timer))
-		del_timer(&iovad->fq_timer);
+	del_timer_sync(&iovad->fq_timer);
 
 	fq_destroy_all_entries(iovad);
 
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 8aae0624a297..6383afb88f31 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -83,14 +83,16 @@ void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
 }
 
 static int insert_at(size_t value_size, struct btree_node *node, unsigned index,
-		      uint64_t key, void *value)
-		      __dm_written_to_disk(value)
+		     uint64_t key, void *value)
+	__dm_written_to_disk(value)
 {
 	uint32_t nr_entries = le32_to_cpu(node->header.nr_entries);
+	uint32_t max_entries = le32_to_cpu(node->header.max_entries);
 	__le64 key_le = cpu_to_le64(key);
 
 	if (index > nr_entries ||
-	    index >= le32_to_cpu(node->header.max_entries)) {
+	    index >= max_entries ||
+	    nr_entries >= max_entries) {
 		DMERR("too many entries in btree node for insert");
 		__dm_unbless_for_disk(value);
 		return -ENOMEM;
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index a2eceb12f01d..1095b90307ae 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -279,6 +279,11 @@ int sm_ll_lookup_bitmap(struct ll_disk *ll, dm_block_t b, uint32_t *result)
 	struct disk_index_entry ie_disk;
 	struct dm_block *blk;
 
+	if (b >= ll->nr_blocks) {
+		DMERR_LIMIT("metadata block out of bounds");
+		return -EINVAL;
+	}
+
 	b = do_div(index, ll->entries_per_block);
 	r = ll->load_ie(ll, index, &ie_disk);
 	if (r < 0)
diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index 930d2c94d5d3..2c9365a39270 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -524,7 +524,7 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 		ERR("out of memory. aborting.\n");
 		kfree(vv);
 		v4l2_ctrl_handler_free(hdl);
-		return -1;
+		return -ENOMEM;
 	}
 
 	saa7146_video_uops.init(dev,vv);
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 51009b2718a3..ab9c4dba2a69 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1209,7 +1209,7 @@ static const struct dvb_device dvbdev_dvr = {
 };
 int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 {
-	int i;
+	int i, ret;
 
 	if (dmxdev->demux->open(dmxdev->demux) < 0)
 		return -EUSERS;
@@ -1227,14 +1227,26 @@ int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 					    DMXDEV_STATE_FREE);
 	}
 
-	dvb_register_device(dvb_adapter, &dmxdev->dvbdev, &dvbdev_demux, dmxdev,
+	ret = dvb_register_device(dvb_adapter, &dmxdev->dvbdev, &dvbdev_demux, dmxdev,
 			    DVB_DEVICE_DEMUX, dmxdev->filternum);
-	dvb_register_device(dvb_adapter, &dmxdev->dvr_dvbdev, &dvbdev_dvr,
+	if (ret < 0)
+		goto err_register_dvbdev;
+
+	ret = dvb_register_device(dvb_adapter, &dmxdev->dvr_dvbdev, &dvbdev_dvr,
 			    dmxdev, DVB_DEVICE_DVR, dmxdev->filternum);
+	if (ret < 0)
+		goto err_register_dvr_dvbdev;
 
 	dvb_ringbuffer_init(&dmxdev->dvr_buffer, NULL, 8192);
 
 	return 0;
+
+err_register_dvr_dvbdev:
+	dvb_unregister_device(dmxdev->dvbdev);
+err_register_dvbdev:
+	vfree(dmxdev->filter);
+	dmxdev->filter = NULL;
+	return ret;
 }
 
 EXPORT_SYMBOL(dvb_dmxdev_init);
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 59ab01dc62b1..c429392ebbe6 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4476,8 +4476,10 @@ static struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_ad
 
 	state->timf_default = cfg->pll->timf;
 
-	if (dib8000_identify(&state->i2c) == 0)
+	if (dib8000_identify(&state->i2c) == 0) {
+		kfree(fe);
 		goto error;
+	}
 
 	dibx000_init_i2c_master(&state->i2c_master, DIB8000, state->i2c.adap, state->i2c.addr);
 
diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index cc6527e35537..b7d8e34ffd5d 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -184,6 +184,8 @@ static irqreturn_t flexcop_pci_isr(int irq, void *dev_id)
 		dma_addr_t cur_addr =
 			fc->read_ibi_reg(fc,dma1_008).dma_0x8.dma_cur_addr << 2;
 		u32 cur_pos = cur_addr - fc_pci->dma[0].dma_addr0;
+		if (cur_pos > fc_pci->dma[0].size * 2)
+			goto error;
 
 		deb_irq("%u irq: %08x cur_addr: %llx: cur_pos: %08x, last_cur_pos: %08x ",
 				jiffies_to_usecs(jiffies - fc_pci->last_irq),
@@ -224,6 +226,7 @@ static irqreturn_t flexcop_pci_isr(int irq, void *dev_id)
 		ret = IRQ_NONE;
 	}
 
+error:
 	spin_unlock_irqrestore(&fc_pci->irq_lock, flags);
 	return ret;
 }
diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index a527d86b93a7..7f498aebb411 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -296,7 +296,12 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	hexium_set_input(hexium, 0);
 	hexium->cur_input = 0;
 
-	saa7146_vv_init(dev, &vv_data);
+	ret = saa7146_vv_init(dev, &vv_data);
+	if (ret) {
+		i2c_del_adapter(&hexium->i2c_adapter);
+		kfree(hexium);
+		return ret;
+	}
 
 	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index cb71653a6669..908de2f76844 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -366,10 +366,16 @@ static struct saa7146_ext_vv vv_data;
 static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
 {
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+	int ret;
 
 	DEB_EE("\n");
 
-	saa7146_vv_init(dev, &vv_data);
+	ret = saa7146_vv_init(dev, &vv_data);
+	if (ret) {
+		pr_err("Error in saa7146_vv_init()\n");
+		return ret;
+	}
+
 	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
 	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 2e7bd82282ca..b2260deab94c 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -694,10 +694,16 @@ static struct saa7146_ext_vv vv_data;
 static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
 {
 	struct mxb *mxb;
+	int ret;
 
 	DEB_EE("dev:%p\n", dev);
 
-	saa7146_vv_init(dev, &vv_data);
+	ret = saa7146_vv_init(dev, &vv_data);
+	if (ret) {
+		ERR("Error in saa7146_vv_init()");
+		return ret;
+	}
+
 	if (mxb_probe(dev)) {
 		saa7146_vv_release(dev);
 		return -1;
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index 83f859e8509c..b95006a864c2 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -217,11 +217,11 @@ static int fops_vcodec_release(struct file *file)
 	mtk_v4l2_debug(1, "[%d] encoder", ctx->id);
 	mutex_lock(&dev->dev_mutex);
 
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	mtk_vcodec_enc_release(ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 
 	list_del_init(&ctx->list);
 	kfree(ctx);
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index a5ea86be8f44..2a0325d1f9de 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -73,9 +73,11 @@ static void igorplugusb_irdata(struct igorplugusb *ir, unsigned len)
 	if (start >= len) {
 		dev_err(ir->dev, "receive overflow invalid: %u", overflow);
 	} else {
-		if (overflow > 0)
+		if (overflow > 0) {
 			dev_warn(ir->dev, "receive overflow, at least %u lost",
 								overflow);
+			ir_raw_event_reset(ir->rc);
+		}
 
 		do {
 			rawir.duration = ir->buf_in[i] * 85333;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 035b2455b26a..53e68d02763c 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1124,7 +1124,7 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	 */
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
-			      data, USB_CTRL_MSG_SZ, HZ * 3);
+			      data, USB_CTRL_MSG_SZ, 3000);
 	dev_dbg(dev, "set address - ret = %d", ret);
 	dev_dbg(dev, "set address - data[0] = %d, data[1] = %d",
 						data[0], data[1]);
@@ -1132,20 +1132,20 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	/* set feature: bit rate 38400 bps */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
-			      0xc04e, 0x0000, NULL, 0, HZ * 3);
+			      0xc04e, 0x0000, NULL, 0, 3000);
 
 	dev_dbg(dev, "set feature - ret = %d", ret);
 
 	/* bRequest 4: set char length to 8 bits */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      4, USB_TYPE_VENDOR,
-			      0x0808, 0x0000, NULL, 0, HZ * 3);
+			      0x0808, 0x0000, NULL, 0, 3000);
 	dev_dbg(dev, "set char length - retB = %d", ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      2, USB_TYPE_VENDOR,
-			      0x0000, 0x0100, NULL, 0, HZ * 3);
+			      0x0000, 0x0100, NULL, 0, 3000);
 	dev_dbg(dev, "set handshake  - retC = %d", ret);
 
 	/* device resume */
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 6784cb9fc4e7..d6fd924fea53 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -415,7 +415,7 @@ static int redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
 	udev = rr3->udev;
 	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), cmd,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0x0000, 0x0000, data, sizeof(u8), HZ * 10);
+			      0x0000, 0x0000, data, sizeof(u8), 10000);
 
 	if (res < 0) {
 		dev_err(rr3->dev, "%s: Error sending rr3 cmd res %d, data %d",
@@ -491,7 +491,7 @@ static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
 	ret = usb_control_msg(rr3->udev, pipe, RR3_GET_IR_PARAM,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      RR3_IR_IO_SIG_TIMEOUT, 0, tmp, len, HZ * 5);
+			      RR3_IR_IO_SIG_TIMEOUT, 0, tmp, len, 5000);
 	if (ret != len)
 		dev_warn(rr3->dev, "Failed to read timeout from hardware\n");
 	else {
@@ -521,7 +521,7 @@ static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), RR3_SET_IR_PARAM,
 		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 		     RR3_IR_IO_SIG_TIMEOUT, 0, timeout, sizeof(*timeout),
-		     HZ * 25);
+		     25000);
 	dev_dbg(dev, "set ir parm timeout %d ret 0x%02x\n",
 						be32_to_cpu(*timeout), ret);
 
@@ -553,32 +553,32 @@ static void redrat3_reset(struct redrat3_dev *rr3)
 	*val = 0x01;
 	rc = usb_control_msg(udev, rxpipe, RR3_RESET,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			     RR3_CPUCS_REG_ADDR, 0, val, len, HZ * 25);
+			     RR3_CPUCS_REG_ADDR, 0, val, len, 25000);
 	dev_dbg(dev, "reset returned 0x%02x\n", rc);
 
 	*val = length_fuzz;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_LENGTH_FUZZ, 0, val, len, HZ * 25);
+			     RR3_IR_IO_LENGTH_FUZZ, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm len fuzz %d rc 0x%02x\n", *val, rc);
 
 	*val = (65536 - (minimum_pause * 2000)) / 256;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_MIN_PAUSE, 0, val, len, HZ * 25);
+			     RR3_IR_IO_MIN_PAUSE, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm min pause %d rc 0x%02x\n", *val, rc);
 
 	*val = periods_measure_carrier;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_PERIODS_MF, 0, val, len, HZ * 25);
+			     RR3_IR_IO_PERIODS_MF, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm periods measure carrier %d rc 0x%02x", *val,
 									rc);
 
 	*val = RR3_DRIVER_MAXLENS;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_MAX_LENGTHS, 0, val, len, HZ * 25);
+			     RR3_IR_IO_MAX_LENGTHS, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm max lens %d rc 0x%02x\n", *val, rc);
 
 	kfree(val);
@@ -596,7 +596,7 @@ static void redrat3_get_firmware_rev(struct redrat3_dev *rr3)
 	rc = usb_control_msg(rr3->udev, usb_rcvctrlpipe(rr3->udev, 0),
 			     RR3_FW_VERSION,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			     0, 0, buffer, RR3_FW_VERSION_LEN, HZ * 5);
+			     0, 0, buffer, RR3_FW_VERSION_LEN, 5000);
 
 	if (rc >= 0)
 		dev_info(rr3->dev, "Firmware rev: %s", buffer);
@@ -836,14 +836,14 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 
 	pipe = usb_sndbulkpipe(rr3->udev, rr3->ep_out->bEndpointAddress);
 	ret = usb_bulk_msg(rr3->udev, pipe, irdata,
-			    sendbuf_len, &ret_len, 10 * HZ);
+			    sendbuf_len, &ret_len, 10000);
 	dev_dbg(dev, "sent %d bytes, (ret %d)\n", ret_len, ret);
 
 	/* now tell the hardware to transmit what we sent it */
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
 	ret = usb_control_msg(rr3->udev, pipe, RR3_TX_SEND_SIGNAL,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0, 0, irdata, 2, HZ * 10);
+			      0, 0, irdata, 2, 10000);
 
 	if (ret < 0)
 		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
index 3a12ef35682b..64d98517f470 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -464,6 +464,13 @@ static int msi001_probe(struct spi_device *spi)
 			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
 	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH, 200000, 8000000, 1, 200000);
+	if (dev->hdl.error) {
+		ret = dev->hdl.error;
+		dev_err(&spi->dev, "Could not initialize controls\n");
+		/* control init failed, free handler */
+		goto err_ctrl_handler_free;
+	}
+
 	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
 	dev->lna_gain = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 1, 1, 1);
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index c826997f5433..229fea019e99 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -89,7 +89,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	/* Try to get Xtal trim property, to verify tuner still running */
-	memcpy(cmd.args, "\x15\x00\x04\x02", 4);
+	memcpy(cmd.args, "\x15\x00\x02\x04", 4);
 	cmd.wlen = 4;
 	cmd.rlen = 4;
 	ret = si2157_cmd_execute(client, &cmd);
diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 5104678f29b7..9dd6e30749fd 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -86,7 +86,7 @@ static int flexcop_usb_readwrite_dw(struct flexcop_device *fc, u16 wRegOffsPCI,
 			0,
 			fc_usb->data,
 			sizeof(u32),
-			B2C2_WAIT_FOR_OPERATION_RDW * HZ);
+			B2C2_WAIT_FOR_OPERATION_RDW);
 
 	if (ret != sizeof(u32)) {
 		err("error while %s dword from %d (%d).", read ? "reading" :
@@ -154,7 +154,7 @@ static int flexcop_usb_v8_memory_req(struct flexcop_usb *fc_usb,
 			wIndex,
 			fc_usb->data,
 			buflen,
-			nWaitTime * HZ);
+			nWaitTime);
 	if (ret != buflen)
 		ret = -EIO;
 
@@ -248,13 +248,13 @@ static int flexcop_usb_i2c_req(struct flexcop_i2c_adapter *i2c,
 		/* DKT 020208 - add this to support special case of DiSEqC */
 	case USB_FUNC_I2C_CHECKWRITE:
 		pipe = B2C2_USB_CTRL_PIPE_OUT;
-		nWaitTime = 2;
+		nWaitTime = 2000;
 		request_type |= USB_DIR_OUT;
 		break;
 	case USB_FUNC_I2C_READ:
 	case USB_FUNC_I2C_REPEATREAD:
 		pipe = B2C2_USB_CTRL_PIPE_IN;
-		nWaitTime = 2;
+		nWaitTime = 2000;
 		request_type |= USB_DIR_IN;
 		break;
 	default:
@@ -281,7 +281,7 @@ static int flexcop_usb_i2c_req(struct flexcop_i2c_adapter *i2c,
 			wIndex,
 			fc_usb->data,
 			buflen,
-			nWaitTime * HZ);
+			nWaitTime);
 
 	if (ret != buflen)
 		ret = -EIO;
diff --git a/drivers/media/usb/b2c2/flexcop-usb.h b/drivers/media/usb/b2c2/flexcop-usb.h
index e86faa0e06ca..3dfd25fa4750 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.h
+++ b/drivers/media/usb/b2c2/flexcop-usb.h
@@ -91,13 +91,13 @@ typedef enum {
 	UTILITY_SRAM_TESTVERIFY     = 0x16,
 } flexcop_usb_utility_function_t;
 
-#define B2C2_WAIT_FOR_OPERATION_RW (1*HZ)
-#define B2C2_WAIT_FOR_OPERATION_RDW (3*HZ)
-#define B2C2_WAIT_FOR_OPERATION_WDW (1*HZ)
+#define B2C2_WAIT_FOR_OPERATION_RW 1000
+#define B2C2_WAIT_FOR_OPERATION_RDW 3000
+#define B2C2_WAIT_FOR_OPERATION_WDW 1000
 
-#define B2C2_WAIT_FOR_OPERATION_V8READ (3*HZ)
-#define B2C2_WAIT_FOR_OPERATION_V8WRITE (3*HZ)
-#define B2C2_WAIT_FOR_OPERATION_V8FLASH (3*HZ)
+#define B2C2_WAIT_FOR_OPERATION_V8READ 3000
+#define B2C2_WAIT_FOR_OPERATION_V8WRITE 3000
+#define B2C2_WAIT_FOR_OPERATION_V8FLASH 3000
 
 typedef enum {
 	V8_MEMORY_PAGE_DVB_CI = 0x20,
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 6475f992c2b2..6d96c329f4f7 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -559,7 +559,7 @@ static int write_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	kfree(buf);
 	return ret;
@@ -591,7 +591,7 @@ static int read_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	if (ret >= 0)
 		memcpy(registers, buf, size);
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 33dd54c8fa04..9cd4c03bbb42 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -619,8 +619,6 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		deb_info("the endpoint number (%i) is not correct, use the adapter id instead", adap->fe_adap[0].stream.props.endpoint);
 		if (onoff)
 			st->channel_state |=	1 << (adap->id);
-		else
-			st->channel_state |=	1 << ~(adap->id);
 	} else {
 		if (onoff)
 			st->channel_state |=	1 << (adap->fe_adap[0].stream.props.endpoint-2);
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 3d09e1c87921..98770a95721b 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -2103,46 +2103,153 @@ static struct dvb_usb_device_properties s6x0_properties = {
 	}
 };
 
-static const struct dvb_usb_device_description d1100 = {
-	"Prof 1100 USB ",
-	{&dw2102_table[PROF_1100], NULL},
-	{NULL},
-};
+static struct dvb_usb_device_properties p1100_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct dw2102_state),
+	.firmware = P1100_FIRMWARE,
+	.no_reconnect = 1,
 
-static const struct dvb_usb_device_description d660 = {
-	"TeVii S660 USB",
-	{&dw2102_table[TEVII_S660], NULL},
-	{NULL},
-};
+	.i2c_algo = &s6x0_i2c_algo,
+	.rc.core = {
+		.rc_interval = 150,
+		.rc_codes = RC_MAP_TBS_NEC,
+		.module_name = "dw2102",
+		.allowed_protos   = RC_PROTO_BIT_NEC,
+		.rc_query = prof_rc_query,
+	},
 
-static const struct dvb_usb_device_description d480_1 = {
-	"TeVii S480.1 USB",
-	{&dw2102_table[TEVII_S480_1], NULL},
-	{NULL},
+	.generic_bulk_ctrl_endpoint = 0x81,
+	.num_adapters = 1,
+	.download_firmware = dw2102_load_firmware,
+	.read_mac_address = s6x0_read_mac_address,
+	.adapter = {
+		{
+			.num_frontends = 1,
+			.fe = {{
+				.frontend_attach = stv0288_frontend_attach,
+				.stream = {
+					.type = USB_BULK,
+					.count = 8,
+					.endpoint = 0x82,
+					.u = {
+						.bulk = {
+							.buffersize = 4096,
+						}
+					}
+				},
+			} },
+		}
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{"Prof 1100 USB ",
+			{&dw2102_table[PROF_1100], NULL},
+			{NULL},
+		},
+	}
 };
 
-static const struct dvb_usb_device_description d480_2 = {
-	"TeVii S480.2 USB",
-	{&dw2102_table[TEVII_S480_2], NULL},
-	{NULL},
-};
+static struct dvb_usb_device_properties s660_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct dw2102_state),
+	.firmware = S660_FIRMWARE,
+	.no_reconnect = 1,
 
-static const struct dvb_usb_device_description d7500 = {
-	"Prof 7500 USB DVB-S2",
-	{&dw2102_table[PROF_7500], NULL},
-	{NULL},
-};
+	.i2c_algo = &s6x0_i2c_algo,
+	.rc.core = {
+		.rc_interval = 150,
+		.rc_codes = RC_MAP_TEVII_NEC,
+		.module_name = "dw2102",
+		.allowed_protos   = RC_PROTO_BIT_NEC,
+		.rc_query = dw2102_rc_query,
+	},
 
-static const struct dvb_usb_device_description d421 = {
-	"TeVii S421 PCI",
-	{&dw2102_table[TEVII_S421], NULL},
-	{NULL},
+	.generic_bulk_ctrl_endpoint = 0x81,
+	.num_adapters = 1,
+	.download_firmware = dw2102_load_firmware,
+	.read_mac_address = s6x0_read_mac_address,
+	.adapter = {
+		{
+			.num_frontends = 1,
+			.fe = {{
+				.frontend_attach = ds3000_frontend_attach,
+				.stream = {
+					.type = USB_BULK,
+					.count = 8,
+					.endpoint = 0x82,
+					.u = {
+						.bulk = {
+							.buffersize = 4096,
+						}
+					}
+				},
+			} },
+		}
+	},
+	.num_device_descs = 3,
+	.devices = {
+		{"TeVii S660 USB",
+			{&dw2102_table[TEVII_S660], NULL},
+			{NULL},
+		},
+		{"TeVii S480.1 USB",
+			{&dw2102_table[TEVII_S480_1], NULL},
+			{NULL},
+		},
+		{"TeVii S480.2 USB",
+			{&dw2102_table[TEVII_S480_2], NULL},
+			{NULL},
+		},
+	}
 };
 
-static const struct dvb_usb_device_description d632 = {
-	"TeVii S632 USB",
-	{&dw2102_table[TEVII_S632], NULL},
-	{NULL},
+static struct dvb_usb_device_properties p7500_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct dw2102_state),
+	.firmware = P7500_FIRMWARE,
+	.no_reconnect = 1,
+
+	.i2c_algo = &s6x0_i2c_algo,
+	.rc.core = {
+		.rc_interval = 150,
+		.rc_codes = RC_MAP_TBS_NEC,
+		.module_name = "dw2102",
+		.allowed_protos   = RC_PROTO_BIT_NEC,
+		.rc_query = prof_rc_query,
+	},
+
+	.generic_bulk_ctrl_endpoint = 0x81,
+	.num_adapters = 1,
+	.download_firmware = dw2102_load_firmware,
+	.read_mac_address = s6x0_read_mac_address,
+	.adapter = {
+		{
+			.num_frontends = 1,
+			.fe = {{
+				.frontend_attach = prof_7500_frontend_attach,
+				.stream = {
+					.type = USB_BULK,
+					.count = 8,
+					.endpoint = 0x82,
+					.u = {
+						.bulk = {
+							.buffersize = 4096,
+						}
+					}
+				},
+			} },
+		}
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{"Prof 7500 USB DVB-S2",
+			{&dw2102_table[PROF_7500], NULL},
+			{NULL},
+		},
+	}
 };
 
 static struct dvb_usb_device_properties su3000_properties = {
@@ -2214,6 +2321,59 @@ static struct dvb_usb_device_properties su3000_properties = {
 	}
 };
 
+static struct dvb_usb_device_properties s421_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.size_of_priv = sizeof(struct dw2102_state),
+	.power_ctrl = su3000_power_ctrl,
+	.num_adapters = 1,
+	.identify_state	= su3000_identify_state,
+	.i2c_algo = &su3000_i2c_algo,
+
+	.rc.core = {
+		.rc_interval = 150,
+		.rc_codes = RC_MAP_SU3000,
+		.module_name = "dw2102",
+		.allowed_protos   = RC_PROTO_BIT_RC5,
+		.rc_query = su3000_rc_query,
+	},
+
+	.read_mac_address = su3000_read_mac_address,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.adapter = {
+		{
+		.num_frontends = 1,
+		.fe = {{
+			.streaming_ctrl   = su3000_streaming_ctrl,
+			.frontend_attach  = m88rs2000_frontend_attach,
+			.stream = {
+				.type = USB_BULK,
+				.count = 8,
+				.endpoint = 0x82,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			}
+		} },
+		}
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{ "TeVii S421 PCI",
+			{ &dw2102_table[TEVII_S421], NULL },
+			{ NULL },
+		},
+		{ "TeVii S632 USB",
+			{ &dw2102_table[TEVII_S632], NULL },
+			{ NULL },
+		},
+	}
+};
+
 static struct dvb_usb_device_properties t220_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
@@ -2331,101 +2491,33 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 static int dw2102_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	int retval = -ENOMEM;
-	struct dvb_usb_device_properties *p1100;
-	struct dvb_usb_device_properties *s660;
-	struct dvb_usb_device_properties *p7500;
-	struct dvb_usb_device_properties *s421;
-
-	p1100 = kmemdup(&s6x0_properties,
-			sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
-	if (!p1100)
-		goto err0;
-
-	/* copy default structure */
-	/* fill only different fields */
-	p1100->firmware = P1100_FIRMWARE;
-	p1100->devices[0] = d1100;
-	p1100->rc.core.rc_query = prof_rc_query;
-	p1100->rc.core.rc_codes = RC_MAP_TBS_NEC;
-	p1100->adapter->fe[0].frontend_attach = stv0288_frontend_attach;
-
-	s660 = kmemdup(&s6x0_properties,
-		       sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
-	if (!s660)
-		goto err1;
-
-	s660->firmware = S660_FIRMWARE;
-	s660->num_device_descs = 3;
-	s660->devices[0] = d660;
-	s660->devices[1] = d480_1;
-	s660->devices[2] = d480_2;
-	s660->adapter->fe[0].frontend_attach = ds3000_frontend_attach;
-
-	p7500 = kmemdup(&s6x0_properties,
-			sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
-	if (!p7500)
-		goto err2;
-
-	p7500->firmware = P7500_FIRMWARE;
-	p7500->devices[0] = d7500;
-	p7500->rc.core.rc_query = prof_rc_query;
-	p7500->rc.core.rc_codes = RC_MAP_TBS_NEC;
-	p7500->adapter->fe[0].frontend_attach = prof_7500_frontend_attach;
-
-
-	s421 = kmemdup(&su3000_properties,
-		       sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
-	if (!s421)
-		goto err3;
-
-	s421->num_device_descs = 2;
-	s421->devices[0] = d421;
-	s421->devices[1] = d632;
-	s421->adapter->fe[0].frontend_attach = m88rs2000_frontend_attach;
-
-	if (0 == dvb_usb_device_init(intf, &dw2102_properties,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &dw2104_properties,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &dw3101_properties,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &s6x0_properties,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, p1100,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, s660,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, p7500,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, s421,
-			THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &su3000_properties,
-			 THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &t220_properties,
-			 THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &tt_s2_4600_properties,
-			 THIS_MODULE, NULL, adapter_nr)) {
-
-		/* clean up copied properties */
-		kfree(s421);
-		kfree(p7500);
-		kfree(s660);
-		kfree(p1100);
+	if (!(dvb_usb_device_init(intf, &dw2102_properties,
+			          THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &dw2104_properties,
+				  THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &dw3101_properties,
+			          THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &s6x0_properties,
+			          THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &p1100_properties,
+			          THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &s660_properties,
+				  THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &p7500_properties,
+				  THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &s421_properties,
+				  THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &su3000_properties,
+				  THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &t220_properties,
+				  THIS_MODULE, NULL, adapter_nr) &&
+	      dvb_usb_device_init(intf, &tt_s2_4600_properties,
+				  THIS_MODULE, NULL, adapter_nr))) {
 
 		return 0;
 	}
 
-	retval = -ENODEV;
-	kfree(s421);
-err3:
-	kfree(p7500);
-err2:
-	kfree(s660);
-err1:
-	kfree(p1100);
-err0:
-	return retval;
+	return -ENODEV;
 }
 
 static void dw2102_disconnect(struct usb_interface *intf)
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 32081c2ce0da..8a43e2415686 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -280,6 +280,13 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int nu
 			/* Should check for ack here, if we knew how. */
 		}
 		if (msg[i].flags & I2C_M_RD) {
+			char *read = kmalloc(1, GFP_KERNEL);
+			if (!read) {
+				ret = -ENOMEM;
+				kfree(read);
+				goto unlock;
+			}
+
 			for (j = 0; j < msg[i].len; j++) {
 				/* Last byte of transaction?
 				 * Send STOP, otherwise send ACK. */
@@ -287,9 +294,12 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int nu
 
 				if ((ret = m920x_read(d->udev, M9206_I2C, 0x0,
 						      0x20 | stop,
-						      &msg[i].buf[j], 1)) != 0)
+						      read, 1)) != 0)
 					goto unlock;
+				msg[i].buf[j] = read[0];
 			}
+
+			kfree(read);
 		} else {
 			for (j = 0; j < msg[i].len; j++) {
 				/* Last byte of transaction? Then send STOP. */
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 9747e23aad27..b736c027a0bd 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3386,8 +3386,10 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 
 	if (dev->is_audio_only) {
 		retval = em28xx_audio_setup(dev);
-		if (retval)
-			return -ENODEV;
+		if (retval) {
+			retval = -ENODEV;
+			goto err_deinit_media;
+		}
 		em28xx_init_extension(dev);
 
 		return 0;
@@ -3417,7 +3419,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		dev_err(&dev->intf->dev,
 			"%s: em28xx_i2c_register bus 0 - error [%d]!\n",
 		       __func__, retval);
-		return retval;
+		goto err_deinit_media;
 	}
 
 	/* register i2c bus 1 */
@@ -3433,9 +3435,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			       "%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 			       __func__, retval);
 
-			em28xx_i2c_unregister(dev, 0);
-
-			return retval;
+			goto err_unreg_i2c;
 		}
 	}
 
@@ -3443,6 +3443,12 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	em28xx_card_setup(dev);
 
 	return 0;
+
+err_unreg_i2c:
+	em28xx_i2c_unregister(dev, 0);
+err_deinit_media:
+	em28xx_unregister_media_device(dev);
+	return retval;
 }
 
 /* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 1d0d8cc06103..0fea2b5e9fcb 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -94,7 +94,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	mutex_lock(&dev->ctrl_urb_lock);
 	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	if (ret < 0) {
 		em28xx_regdbg("(pipe 0x%08x): IN:  %02x %02x %02x %02x %02x %02x %02x %02x  failed with error %i\n",
 			     pipe, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -162,7 +162,7 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 	memcpy(dev->urb_buf, buf, len);
 	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			      0x0000, reg, dev->urb_buf, len, HZ);
+			      0x0000, reg, dev->urb_buf, len, 1000);
 	mutex_unlock(&dev->ctrl_urb_lock);
 
 	if (ret < 0) {
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index fd1bd94cd78f..4ca7e1fad08b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -1476,7 +1476,7 @@ static int pvr2_upload_firmware1(struct pvr2_hdw *hdw)
 	for (address = 0; address < fwsize; address += 0x800) {
 		memcpy(fw_ptr, fw_entry->data + address, 0x800);
 		ret += usb_control_msg(hdw->usb_dev, pipe, 0xa0, 0x40, address,
-				       0, fw_ptr, 0x800, HZ);
+				       0, fw_ptr, 0x800, 1000);
 	}
 
 	trace_firmware("Upload done, releasing device's CPU");
@@ -1614,7 +1614,7 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 			((u32 *)fw_ptr)[icnt] = swab32(((u32 *)fw_ptr)[icnt]);
 
 		ret |= usb_bulk_msg(hdw->usb_dev, pipe, fw_ptr,bcnt,
-				    &actual_length, HZ);
+				    &actual_length, 1000);
 		ret |= (actual_length != bcnt);
 		if (ret) break;
 		fw_done += bcnt;
@@ -3433,7 +3433,7 @@ void pvr2_hdw_cpufw_set_enabled(struct pvr2_hdw *hdw,
 						      0xa0,0xc0,
 						      address,0,
 						      hdw->fw_buffer+address,
-						      0x800,HZ);
+						      0x800,1000);
 				if (ret < 0) break;
 			}
 
@@ -3961,7 +3961,7 @@ void pvr2_hdw_cpureset_assert(struct pvr2_hdw *hdw,int val)
 	/* Write the CPUCS register on the 8051.  The lsb of the register
 	   is the reset bit; a 1 asserts reset while a 0 clears it. */
 	pipe = usb_sndctrlpipe(hdw->usb_dev, 0);
-	ret = usb_control_msg(hdw->usb_dev,pipe,0xa0,0x40,0xe600,0,da,1,HZ);
+	ret = usb_control_msg(hdw->usb_dev,pipe,0xa0,0x40,0xe600,0,da,1,1000);
 	if (ret < 0) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "cpureset_assert(%d) error=%d",val,ret);
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index b2f239c4ba42..08106d3866b4 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1911,7 +1911,7 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
 				    USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				    USB_DIR_IN,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 
 		if (r >= 0)
 			memcpy(TransferBuffer, buf, TransferBufferLength);
@@ -1920,7 +1920,7 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
 		r = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 				    Request, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 	}
 	kfree(buf);
 	return r;
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index bea8bbbb84fb..8e434b31cb98 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -75,7 +75,7 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
 		return -ENOMEM;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, buf, sizeof(u8), HZ);
+			0x00, reg, buf, sizeof(u8), 1000);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
@@ -95,7 +95,7 @@ int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
 
 	ret =  usb_control_msg(dev->udev, pipe, 0x01,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, reg, NULL, 0, HZ);
+			value, reg, NULL, 0, 1000);
 	if (ret < 0) {
 		stk1160_err("write failed on reg 0x%x (%d)\n",
 			reg, ret);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index ce0a18019144..601782663871 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1711,6 +1711,10 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		if (ep == NULL)
 			return -EIO;
 
+		/* Reject broken descriptors. */
+		if (usb_endpoint_maxp(&ep->desc) == 0)
+			return -EIO;
+
 		ret = uvc_init_video_bulk(stream, ep, gfp_flags);
 	}
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 05398784d1c8..acb9f95127eb 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -167,7 +167,7 @@
 /* Maximum status buffer size in bytes of interrupt URB. */
 #define UVC_MAX_STATUS_SIZE	16
 
-#define UVC_CTRL_CONTROL_TIMEOUT	500
+#define UVC_CTRL_CONTROL_TIMEOUT	5000
 #define UVC_CTRL_STREAMING_TIMEOUT	5000
 
 /* Maximum allowed number of control mappings per device */
diff --git a/drivers/mfd/intel-lpss-acpi.c b/drivers/mfd/intel-lpss-acpi.c
index 7911b0a14a6d..fc44fb7c595b 100644
--- a/drivers/mfd/intel-lpss-acpi.c
+++ b/drivers/mfd/intel-lpss-acpi.c
@@ -80,6 +80,7 @@ static int intel_lpss_acpi_probe(struct platform_device *pdev)
 {
 	struct intel_lpss_platform_info *info;
 	const struct acpi_device_id *id;
+	int ret;
 
 	id = acpi_match_device(intel_lpss_acpi_ids, &pdev->dev);
 	if (!id)
@@ -93,10 +94,14 @@ static int intel_lpss_acpi_probe(struct platform_device *pdev)
 	info->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	info->irq = platform_get_irq(pdev, 0);
 
+	ret = intel_lpss_probe(&pdev->dev, info);
+	if (ret)
+		return ret;
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	return intel_lpss_probe(&pdev->dev, info);
+	return 0;
 }
 
 static int intel_lpss_acpi_remove(struct platform_device *pdev)
diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 626fdcaf2510..645d26536114 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -81,12 +81,12 @@ static void firmware_load(const struct firmware *fw, void *context)
 
 	if (fw == NULL) {
 		dev_err(&spi->dev, "Cannot load firmware, aborting\n");
-		return;
+		goto out;
 	}
 
 	if (fw->size == 0) {
 		dev_err(&spi->dev, "Error: Firmware size is 0!\n");
-		return;
+		goto out;
 	}
 
 	/* Fill dummy data (24 stuffing bits for commands) */
@@ -108,7 +108,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 		dev_err(&spi->dev,
 			"Error: No supported FPGA detected (JEDEC_ID=%08x)!\n",
 			jedec_id);
-		return;
+		goto out;
 	}
 
 	dev_info(&spi->dev, "FPGA %s detected\n", ecp3_dev[i].name);
@@ -121,7 +121,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 	buffer = kzalloc(fw->size + 8, GFP_KERNEL);
 	if (!buffer) {
 		dev_err(&spi->dev, "Error: Can't allocate memory!\n");
-		return;
+		goto out;
 	}
 
 	/*
@@ -160,7 +160,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 			"Error: Timeout waiting for FPGA to clear (status=%08x)!\n",
 			status);
 		kfree(buffer);
-		return;
+		goto out;
 	}
 
 	dev_info(&spi->dev, "Configuring the FPGA...\n");
@@ -186,7 +186,7 @@ static void firmware_load(const struct firmware *fw, void *context)
 	release_firmware(fw);
 
 	kfree(buffer);
-
+out:
 	complete(&data->fw_loaded);
 }
 
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 7568cea55922..bf0a0ef60d6b 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -631,6 +631,8 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	if (host->ops->init_card)
 		host->ops->init_card(host, card);
 
+	card->ocr = ocr_card;
+
 	/*
 	 * If the host and card support UHS-I mode request the card
 	 * to switch to 1.8V signaling level.  No 1.8v signalling if
@@ -737,7 +739,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 
 		card = oldcard;
 	}
-	card->ocr = ocr_card;
+
 	mmc_fixup_device(card, sdio_fixup_methods);
 
 	if (card->type == MMC_TYPE_SD_COMBO) {
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 340e7bf6463e..7096fcbf699c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -782,14 +782,14 @@ static bool bond_should_notify_peers(struct bonding *bond)
 	slave = rcu_dereference(bond->curr_active_slave);
 	rcu_read_unlock();
 
-	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
-		   slave ? slave->dev->name : "NULL");
-
 	if (!slave || !bond->send_peer_notif ||
 	    !netif_carrier_ok(bond->dev) ||
 	    test_bit(__LINK_STATE_LINKWATCH_PENDING, &slave->dev->state))
 		return false;
 
+	netdev_dbg(bond->dev, "bond_should_notify_peers: slave %s\n",
+		   slave ? slave->dev->name : "NULL");
+
 	return true;
 }
 
diff --git a/drivers/net/can/softing/softing_cs.c b/drivers/net/can/softing/softing_cs.c
index 4d4492884e0b..efe7d576afa5 100644
--- a/drivers/net/can/softing/softing_cs.c
+++ b/drivers/net/can/softing/softing_cs.c
@@ -304,7 +304,7 @@ static int softingcs_probe(struct pcmcia_device *pcmcia)
 	return 0;
 
 platform_failed:
-	kfree(dev);
+	platform_device_put(pdev);
 mem_failed:
 pcmcia_bad:
 pcmcia_failed:
diff --git a/drivers/net/can/softing/softing_fw.c b/drivers/net/can/softing/softing_fw.c
index aac58ce6e371..209eddeb822e 100644
--- a/drivers/net/can/softing/softing_fw.c
+++ b/drivers/net/can/softing/softing_fw.c
@@ -576,18 +576,19 @@ int softing_startstop(struct net_device *dev, int up)
 		if (ret < 0)
 			goto failed;
 	}
-	/* enable_error_frame */
-	/*
+
+	/* enable_error_frame
+	 *
 	 * Error reporting is switched off at the moment since
 	 * the receiving of them is not yet 100% verified
 	 * This should be enabled sooner or later
-	 *
-	if (error_reporting) {
+	 */
+	if (0 && error_reporting) {
 		ret = softing_fct_cmd(card, 51, "enable_error_frame");
 		if (ret < 0)
 			goto failed;
 	}
-	*/
+
 	/* initialize interface */
 	iowrite16(1, &card->dpram[DPRAM_FCT_PARAM + 2]);
 	iowrite16(1, &card->dpram[DPRAM_FCT_PARAM + 4]);
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 99c42f297afd..6b6fe0fba74f 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -328,7 +328,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
 	/* device reports out of range channel id */
 	if (hf->channel >= GS_MAX_INTF)
-		goto resubmit_urb;
+		goto device_detach;
 
 	dev = usbcan->canch[hf->channel];
 
@@ -413,6 +413,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
+ device_detach:
 		for (rc = 0; rc < GS_MAX_INTF; rc++) {
 			if (usbcan->canch[rc])
 				netif_device_detach(usbcan->canch[rc]->netdev);
@@ -514,6 +515,8 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 	hf->echo_id = idx;
 	hf->channel = dev->channel;
+	hf->flags = 0;
+	hf->reserved = 0;
 
 	cf = (struct can_frame *)skb->data;
 
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 5a24039733ef..caab0df7b368 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1302,7 +1302,12 @@ static int xcan_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->tx_lock);
 
 	/* Get IRQ for the device */
-	ndev->irq = platform_get_irq(pdev, 0);
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto err_free;
+
+	ndev->irq = ret;
+
 	ndev->flags |= IFF_ECHO;	/* We support local echo */
 
 	platform_set_drvdata(pdev, ndev);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 23ff3ec666cd..b819a9bde6cc 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3519,10 +3519,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
-	err = devm_request_irq(&pdev->dev, priv->wol_irq, bcmgenet_wol_isr, 0,
-			       dev->name, priv);
-	if (!err)
-		device_set_wakeup_capable(&pdev->dev, 1);
+	if (priv->wol_irq > 0) {
+		err = devm_request_irq(&pdev->dev, priv->wol_irq,
+				       bcmgenet_wol_isr, 0, dev->name, priv);
+		if (!err)
+			device_set_wakeup_capable(&pdev->dev, 1);
+	}
 
 	/* Set the needed headroom to account for any possible
 	 * features enabling/disabling at runtime
diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
index d04a6c163445..da8d10475a08 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
@@ -32,6 +32,7 @@
 
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
+#include <net/inet_ecn.h>
 #include <net/route.h>
 #include <net/ip6_route.h>
 
@@ -99,7 +100,7 @@ cxgb_find_route(struct cxgb4_lld_info *lldi,
 
 	rt = ip_route_output_ports(&init_net, &fl4, NULL, peer_ip, local_ip,
 				   peer_port, local_port, IPPROTO_TCP,
-				   tos, 0);
+				   tos & ~INET_ECN_MASK, 0);
 	if (IS_ERR(rt))
 		return NULL;
 	n = dst_neigh_lookup(&rt->dst, &peer_ip);
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 387eb4a88b72..3221a5420263 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -96,14 +96,17 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-static void set_fman_mac_params(struct mac_device *mac_dev,
-				struct fman_mac_params *params)
+static int set_fman_mac_params(struct mac_device *mac_dev,
+			       struct fman_mac_params *params)
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
 	params->base_addr = (typeof(params->base_addr))
 		devm_ioremap(priv->dev, mac_dev->res->start,
 			     resource_size(mac_dev->res));
+	if (!params->base_addr)
+		return -ENOMEM;
+
 	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
 	params->max_speed	= priv->max_speed;
 	params->phy_if		= priv->phy_if;
@@ -114,6 +117,8 @@ static void set_fman_mac_params(struct mac_device *mac_dev,
 	params->event_cb	= mac_exception;
 	params->dev_id		= mac_dev;
 	params->internal_phy_node = priv->internal_phy_node;
+
+	return 0;
 }
 
 static int tgec_initialization(struct mac_device *mac_dev)
@@ -125,7 +130,9 @@ static int tgec_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	mac_dev->fman_mac = tgec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -171,7 +178,9 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -220,7 +229,9 @@ static int memac_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	if (priv->max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index c89a5a80c9c8..4feab06b7ad7 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2936,29 +2936,21 @@ static bool gfar_add_rx_frag(struct gfar_rx_buff *rxb, u32 lstatus,
 {
 	int size = lstatus & BD_LENGTH_MASK;
 	struct page *page = rxb->page;
-	bool last = !!(lstatus & BD_LFLAG(RXBD_LAST));
-
-	/* Remove the FCS from the packet length */
-	if (last)
-		size -= ETH_FCS_LEN;
 
 	if (likely(first)) {
 		skb_put(skb, size);
 	} else {
 		/* the last fragments' length contains the full frame length */
-		if (last)
+		if (lstatus & BD_LFLAG(RXBD_LAST))
 			size -= skb->len;
 
-		/* Add the last fragment if it contains something other than
-		 * the FCS, otherwise drop it and trim off any part of the FCS
-		 * that was already received.
-		 */
-		if (size > 0)
-			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
-					rxb->page_offset + RXBUF_ALIGNMENT,
-					size, GFAR_RXB_TRUESIZE);
-		else if (size < 0)
-			pskb_trim(skb, skb->len + size);
+		WARN(size < 0, "gianfar: rx fragment size underflow");
+		if (size < 0)
+			return false;
+
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
+				rxb->page_offset + RXBUF_ALIGNMENT,
+				size, GFAR_RXB_TRUESIZE);
 	}
 
 	/* try reuse page */
@@ -3071,6 +3063,9 @@ static void gfar_process_frame(struct net_device *ndev, struct sk_buff *skb)
 	if (priv->padding)
 		skb_pull(skb, priv->padding);
 
+	/* Trim off the FCS */
+	pskb_trim(skb, skb->len - ETH_FCS_LEN);
+
 	if (ndev->features & NETIF_F_RXCSUM)
 		gfar_rx_checksum(skb, fcb);
 
@@ -3114,6 +3109,17 @@ int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit)
 		if (lstatus & BD_LFLAG(RXBD_EMPTY))
 			break;
 
+		/* lost RXBD_LAST descriptor due to overrun */
+		if (skb &&
+		    (lstatus & BD_LFLAG(RXBD_FIRST))) {
+			/* discard faulty buffer */
+			dev_kfree_skb(skb);
+			skb = NULL;
+			rx_queue->stats.rx_dropped++;
+
+			/* can continue normally */
+		}
+
 		/* order rx buffer descriptor reads */
 		rmb();
 
diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index c82c85ef5fb3..c37aea7ba850 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -301,9 +301,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 static int xgmac_mdio_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
+	struct mdio_fsl_priv *priv = bus->priv;
 
 	mdiobus_unregister(bus);
-	iounmap(bus->priv);
+	iounmap(priv->mdio_base);
 	mdiobus_free(bus);
 
 	return 0;
diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index 43c1fd18670b..a990e606ecaa 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -122,9 +122,10 @@ static int sni_82596_probe(struct platform_device *dev)
 	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
 	iounmap(eth_addr);
 
-	if (!netdevice->irq) {
+	if (netdevice->irq < 0) {
 		printk(KERN_ERR "%s: IRQ not found for i82596 at 0x%lx\n",
 			__FILE__, netdevice->base_addr);
+		retval = netdevice->irq;
 		goto probe_failed;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 6ef20e5cc77d..de93c7714868 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1772,6 +1772,7 @@ int mlxsw_pci_driver_register(struct pci_driver *pci_driver)
 {
 	pci_driver->probe = mlxsw_pci_probe;
 	pci_driver->remove = mlxsw_pci_remove;
+	pci_driver->shutdown = mlxsw_pci_remove;
 	return pci_register_driver(pci_driver);
 }
 EXPORT_SYMBOL(mlxsw_pci_driver_register);
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1152d74433f6..d2ba466613c0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -279,6 +279,16 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 
+	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
+	ret = read_poll_timeout(axienet_ior, value,
+				value & XAE_INT_PHYRSTCMPLT_MASK,
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAE_IS_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
+		return ret;
+	}
+
 	return 0;
 out:
 	axienet_dma_bd_release(ndev);
@@ -672,7 +682,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
-	if (axienet_check_tx_bd_space(lp, num_frag)) {
+	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		if (netif_queue_stopped(ndev))
 			return NETDEV_TX_BUSY;
 
@@ -682,7 +692,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag))
+		if (axienet_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 727b991312a4..3d8d76593293 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -938,6 +938,12 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	if (phy_interface_is_rgmii(phydev)) {
+		err = m88e1121_config_aneg_rgmii_delays(phydev);
+		if (err < 0)
+			return err;
+	}
+
 	/* Adjust LED Control */
 	if (phydev->dev_flags & MARVELL_PHY_M1118_DNS323_LEDS)
 		err = phy_write(phydev, 0x10, 0x1100);
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5ef9bbbab3db..7b9480ce21a2 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -392,7 +392,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index c6e067aae955..81a4fe9706be 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -72,6 +72,8 @@
 #define MPHDRLEN	6	/* multilink protocol header length */
 #define MPHDRLEN_SSN	4	/* ditto with short sequence numbers */
 
+#define PPP_PROTO_LEN	2
+
 /*
  * An instance of /dev/ppp can be associated with either a ppp
  * interface unit or a ppp channel.  In both cases, file->private_data
@@ -501,6 +503,9 @@ static ssize_t ppp_write(struct file *file, const char __user *buf,
 
 	if (!pf)
 		return -ENXIO;
+	/* All PPP packets should start with the 2-byte protocol */
+	if (count < PPP_PROTO_LEN)
+		return -EINVAL;
 	ret = -ENOMEM;
 	skb = alloc_skb(count + pf->hdrlen, GFP_KERNEL);
 	if (!skb)
@@ -1564,7 +1569,7 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	}
 
 	++ppp->stats64.tx_packets;
-	ppp->stats64.tx_bytes += skb->len - 2;
+	ppp->stats64.tx_bytes += skb->len - PPP_PROTO_LEN;
 
 	switch (proto) {
 	case PPP_IP:
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 5a47e5510ca8..c0f52a622964 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -121,8 +121,16 @@ static const char driver_name[] = "MOSCHIP usb-ethernet driver";
 
 static int mcs7830_get_reg(struct usbnet *dev, u16 index, u16 size, void *data)
 {
-	return usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
-				0x0000, index, data, size);
+	int ret;
+
+	ret = usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
+			      0x0000, index, data, size);
+	if (ret < 0)
+		return ret;
+	else if (ret < size)
+		return -ENODATA;
+
+	return ret;
 }
 
 static int mcs7830_set_reg(struct usbnet *dev, u16 index, u16 size, const void *data)
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index e1a1d27427cc..bf43244f051c 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -153,6 +153,10 @@ static void ar5523_cmd_rx_cb(struct urb *urb)
 			ar5523_err(ar, "Invalid reply to WDCMSG_TARGET_START");
 			return;
 		}
+		if (!cmd->odata) {
+			ar5523_err(ar, "Unexpected WDCMSG_TARGET_START reply");
+			return;
+		}
 		memcpy(cmd->odata, hdr + 1, sizeof(u32));
 		cmd->olen = sizeof(u32);
 		cmd->res = 0;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 685faac1368f..21f5fb68b204 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -158,6 +158,9 @@ void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 	htt->num_pending_tx--;
 	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
 		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
+
+	if (htt->num_pending_tx == 0)
+		wake_up(&htt->empty_tx_wq);
 }
 
 int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 9999c8c40269..e6705a30f379 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -90,8 +90,6 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt);
-	if (htt->num_pending_tx == 0)
-		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index ce3a78521274..8125f1752651 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -588,6 +588,13 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			return;
 		}
 
+		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
+			dev_err(&hif_dev->udev->dev,
+				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
+			RX_STAT_INC(skb_dropped);
+			return;
+		}
+
 		pad_len = 4 - (pkt_len & 0x3);
 		if (pad_len == 4)
 			pad_len = 0;
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index c5b5fbcd2066..3073c5af7dae 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2053,7 +2053,7 @@ static int wcn36xx_smd_missed_beacon_ind(struct wcn36xx *wcn,
 			wcn36xx_dbg(WCN36XX_DBG_HAL, "beacon missed bss_index %d\n",
 				    tmp->bss_index);
 			vif = wcn36xx_priv_to_vif(tmp);
-			ieee80211_connection_loss(vif);
+			ieee80211_beacon_loss(vif);
 		}
 		return 0;
 	}
@@ -2068,7 +2068,7 @@ static int wcn36xx_smd_missed_beacon_ind(struct wcn36xx *wcn,
 			wcn36xx_dbg(WCN36XX_DBG_HAL, "beacon missed bss_index %d\n",
 				    rsp->bss_index);
 			vif = wcn36xx_priv_to_vif(tmp);
-			ieee80211_connection_loss(vif);
+			ieee80211_beacon_loss(vif);
 			return 0;
 		}
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 6c10b8c4ddbe..ade3c2705047 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -182,6 +182,9 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
+
+	/* clear the data for the aborted load case */
+	memset(&drv->fw, 0, sizeof(drv->fw));
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
@@ -1271,6 +1274,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	int i;
 	bool load_module = false;
 	bool usniffer_images = false;
+	bool failure = true;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1490,15 +1494,9 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	 * else from proceeding if the module fails to load
 	 * or hangs loading.
 	 */
-	if (load_module) {
+	if (load_module)
 		request_module("%s", op->name);
-#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
-		if (err)
-			IWL_ERR(drv,
-				"failed to load module %s (error %d), is dynamic loading enabled?\n",
-				op->name, err);
-#endif
-	}
+	failure = false;
 	goto free;
 
  try_again:
@@ -1514,6 +1512,9 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
  free:
+	if (failure)
+		iwl_dealloc_ucode(drv);
+
 	if (pieces) {
 		for (i = 0; i < ARRAY_SIZE(pieces->img); i++)
 			kfree(pieces->img[i].sec);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d82d8cfe2e41..f896758a3fa3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1608,6 +1608,7 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	struct iwl_mvm_mc_iter_data iter_data = {
 		.mvm = mvm,
 	};
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1617,6 +1618,22 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_mc_iface_iterator, &iter_data);
+
+	/*
+	 * Send a (synchronous) ech command so that we wait for the
+	 * multiple asynchronous MCAST_FILTER_CMD commands sent by
+	 * the interface iterator. Otherwise, we might get here over
+	 * and over again (by userspace just sending a lot of these)
+	 * and the CPU can send them faster than the firmware can
+	 * process them.
+	 * Note that the CPU is still faster - but with this we'll
+	 * actually send fewer commands overall because the CPU will
+	 * not schedule the work in mac80211 as frequently if it's
+	 * still running when rescheduled (possibly multiple times).
+	 */
+	ret = iwl_mvm_send_cmd_pdu(mvm, ECHO_CMD, 0, 0, NULL);
+	if (ret)
+		IWL_ERR(mvm, "Failed to synchronize multicast groups update\n");
 }
 
 static u64 iwl_mvm_prepare_multicast(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index e4fd476e9ccb..713f3c13fa52 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1364,7 +1364,7 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 	return -EIO;
 }
 
-#define SCAN_TIMEOUT 20000
+#define SCAN_TIMEOUT 30000
 
 void iwl_mvm_scan_timeout_wk(struct work_struct *work)
 {
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 202ce83cb794..f279cd4e78ff 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -130,7 +130,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		default:
 			mwifiex_dbg(adapter, ERROR,
 				    "unknown recv_type %#x\n", recv_type);
-			return -1;
+			ret = -1;
+			goto exit_restore_skb;
 		}
 		break;
 	case MWIFIEX_USB_EP_DATA:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 1ee7f796113b..d2f1a6ef32de 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1020,6 +1020,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	_InitPABias(hw);
 	rtl92c_dm_init(hw);
 exit:
+	local_irq_disable();
 	local_irq_restore(flags);
 	return err;
 }
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index b1ff46fe4547..bbc59d329e9d 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -992,8 +992,10 @@ pdcs_register_pathentries(void)
 		entry->kobj.kset = paths_kset;
 		err = kobject_init_and_add(&entry->kobj, &ktype_pdcspath, NULL,
 					   "%s", entry->name);
-		if (err)
+		if (err) {
+			kobject_put(&entry->kobj);
 			return err;
+		}
 
 		/* kobject is now registered */
 		write_lock(&entry->rw_lock);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1bfc24654b58..98327966e5b4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4004,6 +4004,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9120,
 			 quirk_dma_func1_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9123,
 			 quirk_dma_func1_alias);
+/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c136 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9125,
+			 quirk_dma_func1_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9128,
 			 quirk_dma_func1_alias);
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c14 */
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 8c8caec3a72c..182e5ef4ab83 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -669,18 +669,16 @@ static int pccardd(void *__skt)
 		if (events || sysfs_events)
 			continue;
 
+		set_current_state(TASK_INTERRUPTIBLE);
 		if (kthread_should_stop())
 			break;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		schedule();
 
-		/* make sure we are running */
-		__set_current_state(TASK_RUNNING);
-
 		try_to_freeze();
 	}
+	/* make sure we are running before we exit */
+	__set_current_state(TASK_RUNNING);
 
 	/* shut down socket, if a device is still present */
 	if (skt->state & SOCKET_PRESENT) {
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 5ef7b46a2578..2e96d9273b78 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -693,6 +693,9 @@ static struct resource *__nonstatic_find_io_region(struct pcmcia_socket *s,
 	unsigned long min = base;
 	int ret;
 
+	if (!res)
+		return NULL;
+
 	data.mask = align - 1;
 	data.offset = base & data.mask;
 	data.map = &s_data->io_db;
@@ -812,6 +815,9 @@ static struct resource *nonstatic_find_mem_region(u_long base, u_long num,
 	unsigned long min, max;
 	int ret, i, j;
 
+	if (!res)
+		return NULL;
+
 	low = low || !(s->features & SS_CAP_PAGE_REGS);
 
 	data.mask = align - 1;
diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index 8e2c41ded171..e90253b3f656 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -521,12 +521,12 @@ static void bq25890_handle_state_change(struct bq25890_device *bq,
 
 	if (!new_state->online) {			     /* power removed */
 		/* disable ADC */
-		ret = bq25890_field_write(bq, F_CONV_START, 0);
+		ret = bq25890_field_write(bq, F_CONV_RATE, 0);
 		if (ret < 0)
 			goto error;
 	} else if (!old_state.online) {			    /* power inserted */
 		/* enable ADC, to have control of charge current/voltage */
-		ret = bq25890_field_write(bq, F_CONV_START, 1);
+		ret = bq25890_field_write(bq, F_CONV_RATE, 1);
 		if (ret < 0)
 			goto error;
 	}
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5b7c16b85dc0..5e2ee430b3f8 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -421,7 +421,10 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	min = t->time.tm_min;
 	sec = t->time.tm_sec;
 
+	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
+	spin_unlock_irq(&rtc_lock);
+
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
 		/* Writing 0xff means "don't care" or "match all".  */
 		mon = (mon <= 12) ? bin2bcd(mon) : 0xff;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index be2daf5536ff..180087d1c6cd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -885,7 +885,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
 		return;
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index e3b0ce25162b..2887be4316be 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -119,7 +119,7 @@ int sr_set_blocklength(Scsi_CD *cd, int blocklength)
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 #endif
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -167,7 +167,7 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 325d5e14fc0d..a8b50fc1960d 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -138,7 +138,6 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8992354d4e2c..6f076ff35dd3 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -348,8 +348,6 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
-	platform_set_drvdata(pdev, hba);
-
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f46fa8a2f658..694c0fc31fbf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7904,6 +7904,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	struct Scsi_Host *host = hba->host;
 	struct device *dev = hba->dev;
 
+	/*
+	 * dev_set_drvdata() must be called before any callbacks are registered
+	 * that use dev_get_drvdata() (frequency scaling, clock scaling, hwmon,
+	 * sysfs).
+	 */
+	dev_set_drvdata(dev, hba);
+
 	if (!mmio_base) {
 		dev_err(hba->dev,
 		"Invalid memory reference for mmio_base is NULL\n");
diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
index 616566e793c6..28975b6f054f 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -357,6 +357,7 @@ static int meson_spifc_probe(struct platform_device *pdev)
 	return 0;
 out_clk:
 	clk_disable_unprepare(spifc->clk);
+	pm_runtime_disable(spifc->dev);
 out_err:
 	spi_master_put(master);
 	return ret;
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 292ebbce50dc..3cc180a90cd2 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3904,18 +3904,18 @@ static void hfa384x_usb_throttlefn(unsigned long data)
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
 
-	/*
-	 * We need to check BOTH the RX and the TX throttle controls,
-	 * so we use the bitwise OR instead of the logical OR.
-	 */
 	pr_debug("flags=0x%lx\n", hw->usb_flags);
-	if (!hw->wlandev->hwremoved &&
-	    ((test_and_clear_bit(THROTTLE_RX, &hw->usb_flags) &&
-	      !test_and_set_bit(WORK_RX_RESUME, &hw->usb_flags)) |
-	     (test_and_clear_bit(THROTTLE_TX, &hw->usb_flags) &&
-	      !test_and_set_bit(WORK_TX_RESUME, &hw->usb_flags))
-	    )) {
-		schedule_work(&hw->usb_work);
+	if (!hw->wlandev->hwremoved) {
+		bool rx_throttle = test_and_clear_bit(THROTTLE_RX, &hw->usb_flags) &&
+				   !test_and_set_bit(WORK_RX_RESUME, &hw->usb_flags);
+		bool tx_throttle = test_and_clear_bit(THROTTLE_TX, &hw->usb_flags) &&
+				   !test_and_set_bit(WORK_TX_RESUME, &hw->usb_flags);
+		/*
+		 * We need to check BOTH the RX and the TX throttle controls,
+		 * so we use the bitwise OR instead of the logical OR.
+		 */
+		if (rx_throttle | tx_throttle)
+			schedule_work(&hw->usb_work);
 	}
 
 	spin_unlock_irqrestore(&hw->ctlxq.lock, flags);
diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 9ec4b8d2879f..0698fbf3b6d6 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -465,14 +465,11 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 	if ((termios->c_cflag & CREAD) == 0)
 		uap->port.ignore_status_mask |= UART_DUMMY_RSR_RX;
 
-	/* first, disable everything */
 	old_cr = readb(uap->port.membase + UART010_CR) & ~UART010_CR_MSIE;
 
 	if (UART_ENABLE_MS(port, termios->c_cflag))
 		old_cr |= UART010_CR_MSIE;
 
-	writel(0, uap->port.membase + UART010_CR);
-
 	/* Set baud rate */
 	quot -= 1;
 	writel((quot & 0xf00) >> 8, uap->port.membase + UART010_LCRM);
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index dcf84d5020c6..a9aa8cd7f29c 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2111,32 +2111,13 @@ static const char *pl011_type(struct uart_port *port)
 	return uap->port.type == PORT_AMBA ? uap->type : NULL;
 }
 
-/*
- * Release the memory region(s) being used by 'port'
- */
-static void pl011_release_port(struct uart_port *port)
-{
-	release_mem_region(port->mapbase, SZ_4K);
-}
-
-/*
- * Request the memory region(s) being used by 'port'
- */
-static int pl011_request_port(struct uart_port *port)
-{
-	return request_mem_region(port->mapbase, SZ_4K, "uart-pl011")
-			!= NULL ? 0 : -EBUSY;
-}
-
 /*
  * Configure/autoconfigure the port.
  */
 static void pl011_config_port(struct uart_port *port, int flags)
 {
-	if (flags & UART_CONFIG_TYPE) {
+	if (flags & UART_CONFIG_TYPE)
 		port->type = PORT_AMBA;
-		pl011_request_port(port);
-	}
 }
 
 /*
@@ -2151,6 +2132,8 @@ static int pl011_verify_port(struct uart_port *port, struct serial_struct *ser)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
+	if (port->mapbase != (unsigned long) ser->iomem_base)
+		ret = -EINVAL;
 	return ret;
 }
 
@@ -2168,8 +2151,6 @@ static const struct uart_ops amba_pl011_pops = {
 	.flush_buffer	= pl011_dma_flush_buffer,
 	.set_termios	= pl011_set_termios,
 	.type		= pl011_type,
-	.release_port	= pl011_release_port,
-	.request_port	= pl011_request_port,
 	.config_port	= pl011_config_port,
 	.verify_port	= pl011_verify_port,
 #ifdef CONFIG_CONSOLE_POLL
@@ -2199,8 +2180,6 @@ static const struct uart_ops sbsa_uart_pops = {
 	.shutdown	= sbsa_uart_shutdown,
 	.set_termios	= sbsa_uart_set_termios,
 	.type		= pl011_type,
-	.release_port	= pl011_release_port,
-	.request_port	= pl011_request_port,
 	.config_port	= pl011_config_port,
 	.verify_port	= pl011_verify_port,
 #ifdef CONFIG_CONSOLE_POLL
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a00227d312d3..4da5604d7385 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -925,6 +925,13 @@ static void atmel_tx_dma(struct uart_port *port)
 		desc->callback = atmel_complete_tx_dma;
 		desc->callback_param = atmel_port;
 		atmel_port->cookie_tx = dmaengine_submit(desc);
+		if (dma_submit_error(atmel_port->cookie_tx)) {
+			dev_err(port->dev, "dma_submit_error %d\n",
+				atmel_port->cookie_tx);
+			return;
+		}
+
+		dma_async_issue_pending(chan);
 	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -1183,6 +1190,13 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 	desc->callback_param = port;
 	atmel_port->desc_rx = desc;
 	atmel_port->cookie_rx = dmaengine_submit(desc);
+	if (dma_submit_error(atmel_port->cookie_rx)) {
+		dev_err(port->dev, "dma_submit_error %d\n",
+			atmel_port->cookie_rx);
+		goto chan_err;
+	}
+
+	dma_async_issue_pending(atmel_port->chan_rx);
 
 	return 0;
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 16ce187390d8..230e515b83c8 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -172,7 +172,7 @@ static void uart_port_dtr_rts(struct uart_port *uport, int raise)
 	int RTS_after_send = !!(uport->rs485.flags & SER_RS485_RTS_AFTER_SEND);
 
 	if (raise) {
-		if (rs485_on && !RTS_after_send) {
+		if (rs485_on && RTS_after_send) {
 			uart_set_mctrl(uport, TIOCM_DTR);
 			uart_clear_mctrl(uport, TIOCM_RTS);
 		} else {
@@ -181,7 +181,7 @@ static void uart_port_dtr_rts(struct uart_port *uport, int raise)
 	} else {
 		unsigned int clear = TIOCM_DTR;
 
-		clear |= (!rs485_on || !RTS_after_send) ? TIOCM_RTS : 0;
+		clear |= (!rs485_on || RTS_after_send) ? TIOCM_RTS : 0;
 		uart_clear_mctrl(uport, clear);
 	}
 }
@@ -2361,7 +2361,8 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 * We probably don't need a spinlock around this, but
 		 */
 		spin_lock_irqsave(&port->lock, flags);
-		port->ops->set_mctrl(port, port->mctrl & TIOCM_DTR);
+		port->mctrl &= TIOCM_DTR;
+		port->ops->set_mctrl(port, port->mctrl);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 5fcea1114e2f..d634db802fbd 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -761,6 +761,7 @@ void usb_hcd_poll_rh_status(struct usb_hcd *hcd)
 {
 	struct urb	*urb;
 	int		length;
+	int		status;
 	unsigned long	flags;
 	char		buffer[6];	/* Any root hubs with > 31 ports? */
 
@@ -778,11 +779,17 @@ void usb_hcd_poll_rh_status(struct usb_hcd *hcd)
 		if (urb) {
 			clear_bit(HCD_FLAG_POLL_PENDING, &hcd->flags);
 			hcd->status_urb = NULL;
+			if (urb->transfer_buffer_length >= length) {
+				status = 0;
+			} else {
+				status = -EOVERFLOW;
+				length = urb->transfer_buffer_length;
+			}
 			urb->actual_length = length;
 			memcpy(urb->transfer_buffer, buffer, length);
 
 			usb_hcd_unlink_urb_from_ep(hcd, urb);
-			usb_hcd_giveback_urb(hcd, urb, 0);
+			usb_hcd_giveback_urb(hcd, urb, status);
 		} else {
 			length = 0;
 			set_bit(HCD_FLAG_POLL_PENDING, &hcd->flags);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 56a0bd05aa2c..132828b56cf8 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1077,7 +1077,10 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 		} else {
 			hub_power_on(hub, true);
 		}
-	}
+	/* Give some time on remote wakeup to let links to transit to U0 */
+	} else if (hub_is_superspeed(hub->hdev))
+		msleep(20);
+
  init2:
 
 	/*
@@ -1192,7 +1195,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			 */
 			if (portchange || (hub_is_superspeed(hub->hdev) &&
 						port_resumed))
-				set_bit(port1, hub->change_bits);
+				set_bit(port1, hub->event_bits);
 
 		} else if (udev->persist_enabled) {
 #ifdef CONFIG_PM
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 6029f9b00b4a..61795025f11b 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -608,7 +608,7 @@ static int ffs_ep0_open(struct inode *inode, struct file *file)
 	file->private_data = ffs;
 	ffs_data_opened(ffs);
 
-	return 0;
+	return stream_open(inode, file);
 }
 
 static int ffs_ep0_release(struct inode *inode, struct file *file)
@@ -1072,7 +1072,7 @@ ffs_epfile_open(struct inode *inode, struct file *file)
 	file->private_data = epfile;
 	ffs_data_opened(epfile->ffs);
 
-	return 0;
+	return stream_open(inode, file);
 }
 
 static int ffs_aio_cancel(struct kiocb *kiocb)
diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index 6cb16d4b2257..4e91f7b21a79 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -113,7 +113,8 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 				num_ports);
 		}
 		if (of_device_is_compatible(np, "aspeed,ast2400-uhci") ||
-		    of_device_is_compatible(np, "aspeed,ast2500-uhci")) {
+		    of_device_is_compatible(np, "aspeed,ast2500-uhci") ||
+		    of_device_is_compatible(np, "aspeed,ast2600-uhci")) {
 			uhci->is_aspeed = 1;
 			dev_info(&pdev->dev,
 				 "Enabled Aspeed implementation workarounds\n");
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 424ff12f3b51..0231c0cc6481 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -206,6 +206,7 @@ static void ftdi_elan_delete(struct kref *kref)
 	mutex_unlock(&ftdi_module_lock);
 	kfree(ftdi->bulk_in_buffer);
 	ftdi->bulk_in_buffer = NULL;
+	kfree(ftdi);
 }
 
 static void ftdi_elan_put_kref(struct usb_ftdi *ftdi)
diff --git a/drivers/w1/slaves/w1_ds28e04.c b/drivers/w1/slaves/w1_ds28e04.c
index ec234b846eb3..e5eb19a34ee2 100644
--- a/drivers/w1/slaves/w1_ds28e04.c
+++ b/drivers/w1/slaves/w1_ds28e04.c
@@ -34,7 +34,7 @@ static int w1_strong_pullup = 1;
 module_param_named(strong_pullup, w1_strong_pullup, int, 0);
 
 /* enable/disable CRC checking on DS28E04-100 memory accesses */
-static char w1_enable_crccheck = 1;
+static bool w1_enable_crccheck = true;
 
 #define W1_EEPROM_SIZE		512
 #define W1_PAGE_COUNT		16
@@ -341,32 +341,18 @@ static BIN_ATTR_RW(pio, 1);
 static ssize_t crccheck_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	if (put_user(w1_enable_crccheck + 0x30, buf))
-		return -EFAULT;
-
-	return sizeof(w1_enable_crccheck);
+	return sysfs_emit(buf, "%d\n", w1_enable_crccheck);
 }
 
 static ssize_t crccheck_store(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	char val;
-
-	if (count != 1 || !buf)
-		return -EINVAL;
+	int err = kstrtobool(buf, &w1_enable_crccheck);
 
-	if (get_user(val, buf))
-		return -EFAULT;
+	if (err)
+		return err;
 
-	/* convert to decimal */
-	val = val - 0x30;
-	if (val != 0 && val != 1)
-		return -EINVAL;
-
-	/* set the new value */
-	w1_enable_crccheck = val;
-
-	return sizeof(w1_enable_crccheck);
+	return count;
 }
 
 static DEVICE_ATTR_RW(crccheck);
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1cf75d1032e1..58dc96d7ecaf 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1163,7 +1163,12 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret == 0);
+	if (ret == 0) {
+		/* This shouldn't happen, indicates a bug or fs corruption. */
+		ASSERT(ret != 0);
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	if (trans && likely(trans->type != __TRANS_DUMMY) &&
@@ -1310,10 +1315,18 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				goto out;
 			if (!ret && extent_item_pos) {
 				/*
-				 * we've recorded that parent, so we must extend
-				 * its inode list here
+				 * We've recorded that parent, so we must extend
+				 * its inode list here.
+				 *
+				 * However if there was corruption we may not
+				 * have found an eie, return an error in this
+				 * case.
 				 */
-				BUG_ON(!eie);
+				ASSERT(eie);
+				if (!eie) {
+					ret = -EUCLEAN;
+					goto out;
+				}
 				while (eie->next)
 					eie = eie->next;
 				eie->next = ref->inode_list;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 21643d2b3fee..8364f170fbb8 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3974,6 +3974,14 @@ static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
 	int from = ms->m_header.h_nodeid;
 	int error = 0;
 
+	/* currently mixing of user/kernel locks are not supported */
+	if (ms->m_flags & DLM_IFL_USER && ~lkb->lkb_flags & DLM_IFL_USER) {
+		log_error(lkb->lkb_resource->res_ls,
+			  "got user dlm message for a kernel lock");
+		error = -EINVAL;
+		goto out;
+	}
+
 	switch (ms->m_type) {
 	case DLM_MSG_CONVERT:
 	case DLM_MSG_UNLOCK:
@@ -4002,6 +4010,7 @@ static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
 		error = -EINVAL;
 	}
 
+out:
 	if (error)
 		log_error(lkb->lkb_resource->res_ls,
 			  "ignore invalid message %d from %d %x %x %x %d",
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 6718c7ccd631..3bd79fc4e948 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -992,8 +992,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		    sizeof(range)))
 			return -EFAULT;
 
-		range.minlen = max((unsigned int)range.minlen,
-				   q->limits.discard_granularity);
 		ret = ext4_trim_fs(sb, &range);
 		if (ret < 0)
 			return ret;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c40d3c44a1d6..28bee66c5fbf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5284,6 +5284,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
  */
 int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
+	struct request_queue *q = bdev_get_queue(sb->s_bdev);
 	struct ext4_group_info *grp;
 	ext4_group_t group, first_group, last_group;
 	ext4_grpblk_t cnt = 0, first_cluster, last_cluster;
@@ -5302,6 +5303,13 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	    start >= max_blks ||
 	    range->len < sb->s_blocksize)
 		return -EINVAL;
+	/* No point to try to trim less than discard granularity */
+	if (range->minlen < q->limits.discard_granularity) {
+		minlen = EXT4_NUM_B2C(EXT4_SB(sb),
+			q->limits.discard_granularity >> sb->s_blocksize_bits);
+		if (minlen > EXT4_CLUSTERS_PER_GROUP(sb))
+			goto out;
+	}
 	if (end >= max_blks)
 		end = max_blks - 1;
 	if (end <= first_data_blk)
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 0d785868cc50..b6e9d56696ef 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -462,12 +462,12 @@ int ext4_ext_migrate(struct inode *inode)
 	percpu_down_write(&sbi->s_writepages_rwsem);
 
 	/*
-	 * Worst case we can touch the allocation bitmaps, a bgd
-	 * block, and a block to link in the orphan list.  We do need
-	 * need to worry about credits for modifying the quota inode.
+	 * Worst case we can touch the allocation bitmaps and a block
+	 * group descriptor block.  We do need need to worry about
+	 * credits for modifying the quota inode.
 	 */
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE,
-		4 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb));
+		3 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb));
 
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
@@ -484,6 +484,13 @@ int ext4_ext_migrate(struct inode *inode)
 		ext4_journal_stop(handle);
 		goto out_unlock;
 	}
+	/*
+	 * Use the correct seed for checksum (i.e. the seed from 'inode').  This
+	 * is so that the metadata blocks will have the correct checksum after
+	 * the migration.
+	 */
+	ei = EXT4_I(inode);
+	EXT4_I(tmp_inode)->i_csum_seed = ei->i_csum_seed;
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
 	 * Set the i_nlink to zero so it will be deleted later
@@ -492,7 +499,6 @@ int ext4_ext_migrate(struct inode *inode)
 	clear_nlink(tmp_inode);
 
 	ext4_ext_tree_init(handle, tmp_inode);
-	ext4_orphan_add(handle, tmp_inode);
 	ext4_journal_stop(handle);
 
 	/*
@@ -517,17 +523,10 @@ int ext4_ext_migrate(struct inode *inode)
 
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
 	if (IS_ERR(handle)) {
-		/*
-		 * It is impossible to update on-disk structures without
-		 * a handle, so just rollback in-core changes and live other
-		 * work to orphan_list_cleanup()
-		 */
-		ext4_orphan_del(NULL, tmp_inode);
 		retval = PTR_ERR(handle);
 		goto out_tmp_inode;
 	}
 
-	ei = EXT4_I(inode);
 	i_data = ei->i_data;
 	memset(&lb, 0, sizeof(lb));
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 105334ebc102..dd424958be60 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5678,10 +5678,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 
 	lockdep_set_quota_inode(path->dentry->d_inode, I_DATA_SEM_QUOTA);
 	err = dquot_quota_on(sb, type, format_id, path);
-	if (err) {
-		lockdep_set_quota_inode(path->dentry->d_inode,
-					     I_DATA_SEM_NORMAL);
-	} else {
+	if (!err) {
 		struct inode *inode = d_inode(path->dentry);
 		handle_t *handle;
 
@@ -5701,7 +5698,12 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 		ext4_journal_stop(handle);
 	unlock_inode:
 		inode_unlock(inode);
+		if (err)
+			dquot_quota_off(sb, type);
 	}
+	if (err)
+		lockdep_set_quota_inode(path->dentry->d_inode,
+					     I_DATA_SEM_NORMAL);
 	return err;
 }
 
@@ -5867,7 +5869,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
-	if (EXT4_SB(sb)->s_journal && !handle) {
+	if (!handle) {
 		ext4_msg(sb, KERN_WARNING, "Quota write (off=%llu, len=%llu)"
 			" cancelled because transaction is not started",
 			(unsigned long long)off, (unsigned long long)len);
diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index ec85765502f1..990529da5354 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -19,6 +19,9 @@ struct posix_acl *fuse_get_acl(struct inode *inode, int type)
 	void *value = NULL;
 	struct posix_acl *acl;
 
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!fc->posix_acl || fc->no_getxattr)
 		return NULL;
 
@@ -53,6 +56,9 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	const char *name;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fc->posix_acl || fc->no_setxattr)
 		return -EOPNOTSUPP;
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b8d13b69583c..94ecc67292c7 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -187,7 +187,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	int ret;
 
 	inode = d_inode_rcu(entry);
-	if (inode && is_bad_inode(inode))
+	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
 		 (flags & LOOKUP_REVAL)) {
@@ -364,6 +364,9 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	bool outarg_valid = true;
 	bool locked;
 
+	if (fuse_is_bad(dir))
+		return ERR_PTR(-EIO);
+
 	locked = fuse_lock_inode(dir);
 	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
 			       &outarg, &inode);
@@ -504,6 +507,9 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct dentry *res = NULL;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	if (d_in_lookup(entry)) {
 		res = fuse_lookup(dir, entry, 0);
 		if (IS_ERR(res))
@@ -551,6 +557,9 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 	int err;
 	struct fuse_forget_link *forget;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	forget = fuse_alloc_forget();
 	if (!forget)
 		return -ENOMEM;
@@ -672,6 +681,9 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode = FUSE_UNLINK;
 	args.in.h.nodeid = get_node_id(dir);
 	args.in.numargs = 1;
@@ -708,6 +720,9 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.in.h.opcode = FUSE_RMDIR;
 	args.in.h.nodeid = get_node_id(dir);
 	args.in.numargs = 1;
@@ -786,6 +801,9 @@ static int fuse_rename2(struct inode *olddir, struct dentry *oldent,
 	struct fuse_conn *fc = get_fuse_conn(olddir);
 	int err;
 
+	if (fuse_is_bad(olddir))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
@@ -921,7 +939,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
+			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
 			fuse_change_attributes(inode, &outarg.attr,
@@ -1110,6 +1128,9 @@ static int fuse_permission(struct inode *inode, int mask)
 	bool refreshed = false;
 	int err = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -1247,7 +1268,7 @@ static int fuse_direntplus_link(struct file *file,
 			dput(dentry);
 			goto retry;
 		}
-		if (is_bad_inode(inode)) {
+		if (fuse_is_bad(inode)) {
 			dput(dentry);
 			return -EIO;
 		}
@@ -1345,7 +1366,7 @@ static int fuse_readdir(struct file *file, struct dir_context *ctx)
 	u64 attr_version = 0;
 	bool locked;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	req = fuse_get_req(fc, 1);
@@ -1405,6 +1426,9 @@ static const char *fuse_get_link(struct dentry *dentry,
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	link = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!link)
 		return ERR_PTR(-ENOMEM);
@@ -1703,7 +1727,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 
 	if (fuse_invalid_attr(&outarg.attr) ||
 	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
 	}
@@ -1759,6 +1783,9 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 	struct file *file = (attr->ia_valid & ATTR_FILE) ? attr->ia_file : NULL;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
 
@@ -1817,6 +1844,9 @@ static int fuse_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4238939af2fe..5f5da2911cea 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -206,6 +206,9 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 			  fc->atomic_o_trunc &&
 			  fc->writeback_cache;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
@@ -407,7 +410,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	struct fuse_flush_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (fc->no_flush)
@@ -455,7 +458,7 @@ int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
 	struct fuse_fsync_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	inode_lock(inode);
@@ -770,7 +773,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	err = fuse_do_readpage(file, page);
@@ -897,7 +900,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 	int nr_alloc = min_t(unsigned, nr_pages, FUSE_MAX_PAGES_PER_REQ);
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.file = file;
@@ -927,6 +930,9 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	/*
 	 * In auto invalidate mode, always update attributes on read.
 	 * Otherwise, only update if we attempt to read past EOF (to ensure
@@ -1127,7 +1133,7 @@ static ssize_t fuse_perform_write(struct kiocb *iocb,
 	int err = 0;
 	ssize_t res = 0;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (inode->i_size < pos + iov_iter_count(ii))
@@ -1184,6 +1190,9 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t err;
 	loff_t endbyte = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (get_fuse_conn(inode)->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
 		err = fuse_update_attributes(mapping->host, file);
@@ -1420,7 +1429,7 @@ static ssize_t __fuse_direct_read(struct fuse_io_priv *io,
 	ssize_t res;
 	struct inode *inode = file_inode(io->iocb->ki_filp);
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	res = fuse_direct_io(io, iter, ppos, 0);
@@ -1442,7 +1451,7 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct fuse_io_priv io = FUSE_IO_PRIV_SYNC(iocb);
 	ssize_t res;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	/* Don't allow parallel writes to the same file */
@@ -1916,7 +1925,7 @@ static int fuse_writepages(struct address_space *mapping,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.inode = inode;
@@ -2701,7 +2710,7 @@ long fuse_ioctl_common(struct file *file, unsigned int cmd,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	return fuse_do_ioctl(file, cmd, arg, flags);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 338aa5e266d6..fac1f08dd32e 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -117,6 +117,8 @@ enum {
 	FUSE_I_INIT_RDPLUS,
 	/** An operation changing file size is in progress  */
 	FUSE_I_SIZE_UNSTABLE,
+	/* Bad inode */
+	FUSE_I_BAD,
 };
 
 struct fuse_conn;
@@ -687,6 +689,17 @@ static inline u64 get_node_id(struct inode *inode)
 	return get_fuse_inode(inode)->nodeid;
 }
 
+static inline void fuse_make_bad(struct inode *inode)
+{
+	remove_inode_hash(inode);
+	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
+}
+
+static inline bool fuse_is_bad(struct inode *inode)
+{
+	return unlikely(test_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state));
+}
+
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ffb61787d77a..747f7a710fb9 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -317,7 +317,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
 		/* Inode has changed type, any I/O on the old should fail */
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
 	}
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 3caac46b08b0..134bbc432ae6 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -113,6 +113,9 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -178,6 +181,9 @@ static int fuse_xattr_get(const struct xattr_handler *handler,
 			 struct dentry *dentry, struct inode *inode,
 			 const char *name, void *value, size_t size)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	return fuse_getxattr(inode, name, value, size);
 }
 
@@ -186,6 +192,9 @@ static int fuse_xattr_set(const struct xattr_handler *handler,
 			  const char *name, const void *value, size_t size,
 			  int flags)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!value)
 		return fuse_removexattr(inode, name);
 
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index bd0428bebe9b..221eb2bd205e 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -135,20 +135,15 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	struct page *pg;
 	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	pgoff_t index = pos >> PAGE_SHIFT;
 	uint32_t pageofs = index << PAGE_SHIFT;
 	int ret = 0;
 
-	pg = grab_cache_page_write_begin(mapping, index, flags);
-	if (!pg)
-		return -ENOMEM;
-	*pagep = pg;
-
 	jffs2_dbg(1, "%s()\n", __func__);
 
 	if (pageofs > inode->i_size) {
 		/* Make new hole frag from old EOF to new page */
-		struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
 		uint32_t alloc_len;
@@ -159,7 +154,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
 		if (ret)
-			goto out_page;
+			goto out_err;
 
 		mutex_lock(&f->sem);
 		memset(&ri, 0, sizeof(ri));
@@ -189,7 +184,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			ret = PTR_ERR(fn);
 			jffs2_complete_reservation(c);
 			mutex_unlock(&f->sem);
-			goto out_page;
+			goto out_err;
 		}
 		ret = jffs2_add_full_dnode_to_inode(c, f, fn);
 		if (f->metadata) {
@@ -204,13 +199,26 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			jffs2_free_full_dnode(fn);
 			jffs2_complete_reservation(c);
 			mutex_unlock(&f->sem);
-			goto out_page;
+			goto out_err;
 		}
 		jffs2_complete_reservation(c);
 		inode->i_size = pageofs;
 		mutex_unlock(&f->sem);
 	}
 
+	/*
+	 * While getting a page and reading data in, lock c->alloc_sem until
+	 * the page is Uptodate. Otherwise GC task may attempt to read the same
+	 * page in read_cache_page(), which causes a deadlock.
+	 */
+	mutex_lock(&c->alloc_sem);
+	pg = grab_cache_page_write_begin(mapping, index, flags);
+	if (!pg) {
+		ret = -ENOMEM;
+		goto release_sem;
+	}
+	*pagep = pg;
+
 	/*
 	 * Read in the page if it wasn't already present. Cannot optimize away
 	 * the whole page write case until jffs2_write_end can handle the
@@ -220,15 +228,17 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		mutex_lock(&f->sem);
 		ret = jffs2_do_readpage_nolock(inode, pg);
 		mutex_unlock(&f->sem);
-		if (ret)
-			goto out_page;
+		if (ret) {
+			unlock_page(pg);
+			put_page(pg);
+			goto release_sem;
+		}
 	}
 	jffs2_dbg(1, "end write_begin(). pg->flags %lx\n", pg->flags);
-	return ret;
 
-out_page:
-	unlock_page(pg);
-	put_page(pg);
+release_sem:
+	mutex_unlock(&c->alloc_sem);
+out_err:
 	return ret;
 }
 
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 3c8dfab8e958..02b01b4025f6 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -177,8 +177,11 @@ void nfs40_shutdown_client(struct nfs_client *clp)
 
 struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 {
-	int err;
+	char buf[INET6_ADDRSTRLEN + 1];
+	const char *ip_addr = cl_init->ip_addr;
 	struct nfs_client *clp = nfs_alloc_client(cl_init);
+	int err;
+
 	if (IS_ERR(clp))
 		return clp;
 
@@ -202,6 +205,44 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 #if IS_ENABLED(CONFIG_NFS_V4_1)
 	init_waitqueue_head(&clp->cl_lock_waitq);
 #endif
+
+	if (cl_init->minorversion != 0)
+		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
+	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
+	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
+
+	/*
+	 * Set up the connection to the server before we add add to the
+	 * global list.
+	 */
+	err = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
+	if (err == -EINVAL)
+		err = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_UNIX);
+	if (err < 0)
+		goto error;
+
+	/* If no clientaddr= option was specified, find a usable cb address */
+	if (ip_addr == NULL) {
+		struct sockaddr_storage cb_addr;
+		struct sockaddr *sap = (struct sockaddr *)&cb_addr;
+
+		err = rpc_localaddr(clp->cl_rpcclient, sap, sizeof(cb_addr));
+		if (err < 0)
+			goto error;
+		err = rpc_ntop(sap, buf, sizeof(buf));
+		if (err < 0)
+			goto error;
+		ip_addr = (const char *)buf;
+	}
+	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
+
+	err = nfs_idmap_new(clp);
+	if (err < 0) {
+		dprintk("%s: failed to create idmapper. Error = %d\n",
+			__func__, err);
+		goto error;
+	}
+	__set_bit(NFS_CS_IDMAP, &clp->cl_res_state);
 	return clp;
 
 error:
@@ -354,8 +395,6 @@ static int nfs4_init_client_minor_version(struct nfs_client *clp)
 struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 				    const struct nfs_client_initdata *cl_init)
 {
-	char buf[INET6_ADDRSTRLEN + 1];
-	const char *ip_addr = cl_init->ip_addr;
 	struct nfs_client *old;
 	int error;
 
@@ -363,43 +402,6 @@ struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 		/* the client is initialised already */
 		return clp;
 
-	/* Check NFS protocol revision and initialize RPC op vector */
-	clp->rpc_ops = &nfs_v4_clientops;
-
-	if (clp->cl_minorversion != 0)
-		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
-	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
-	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
-
-	error = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
-	if (error == -EINVAL)
-		error = nfs_create_rpc_client(clp, cl_init, RPC_AUTH_UNIX);
-	if (error < 0)
-		goto error;
-
-	/* If no clientaddr= option was specified, find a usable cb address */
-	if (ip_addr == NULL) {
-		struct sockaddr_storage cb_addr;
-		struct sockaddr *sap = (struct sockaddr *)&cb_addr;
-
-		error = rpc_localaddr(clp->cl_rpcclient, sap, sizeof(cb_addr));
-		if (error < 0)
-			goto error;
-		error = rpc_ntop(sap, buf, sizeof(buf));
-		if (error < 0)
-			goto error;
-		ip_addr = (const char *)buf;
-	}
-	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
-
-	error = nfs_idmap_new(clp);
-	if (error < 0) {
-		dprintk("%s: failed to create idmapper. Error = %d\n",
-			__func__, error);
-		goto error;
-	}
-	__set_bit(NFS_CS_IDMAP, &clp->cl_res_state);
-
 	error = nfs4_init_client_minor_version(clp);
 	if (error < 0)
 		goto error;
diff --git a/fs/orangefs/orangefs-bufmap.c b/fs/orangefs/orangefs-bufmap.c
index 59f444dced9b..b46f315183f1 100644
--- a/fs/orangefs/orangefs-bufmap.c
+++ b/fs/orangefs/orangefs-bufmap.c
@@ -179,7 +179,7 @@ orangefs_bufmap_free(struct orangefs_bufmap *bufmap)
 {
 	kfree(bufmap->page_array);
 	kfree(bufmap->desc_array);
-	kfree(bufmap->buffer_index_array);
+	bitmap_free(bufmap->buffer_index_array);
 	kfree(bufmap);
 }
 
@@ -243,8 +243,7 @@ orangefs_bufmap_alloc(struct ORANGEFS_dev_map_desc *user_desc)
 	bufmap->desc_size = user_desc->size;
 	bufmap->desc_shift = ilog2(bufmap->desc_size);
 
-	bufmap->buffer_index_array =
-		kzalloc(DIV_ROUND_UP(bufmap->desc_count, BITS_PER_LONG), GFP_KERNEL);
+	bufmap->buffer_index_array = bitmap_zalloc(bufmap->desc_count, GFP_KERNEL);
 	if (!bufmap->buffer_index_array)
 		goto out_free_bufmap;
 
@@ -267,7 +266,7 @@ orangefs_bufmap_alloc(struct ORANGEFS_dev_map_desc *user_desc)
 out_free_desc_array:
 	kfree(bufmap->desc_array);
 out_free_index_array:
-	kfree(bufmap->buffer_index_array);
+	bitmap_free(bufmap->buffer_index_array);
 out_free_bufmap:
 	kfree(bufmap);
 out:
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ad827cf642fe..c27f5318d36c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1706,7 +1706,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 		kthread_stop(c->bgt);
 		c->bgt = NULL;
 	}
-	free_wbufs(c);
 	kfree(c->write_reserve_buf);
 	c->write_reserve_buf = NULL;
 	vfree(c->ileb_buf);
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 71fadbe77e21..2c5df69e6781 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -560,8 +560,14 @@ typedef u64 acpi_integer;
  * Can be used with access_width of struct acpi_generic_address and access_size of
  * struct acpi_resource_generic_register.
  */
-#define ACPI_ACCESS_BIT_WIDTH(size)     (1 << ((size) + 2))
-#define ACPI_ACCESS_BYTE_WIDTH(size)    (1 << ((size) - 1))
+#define ACPI_ACCESS_BIT_SHIFT		2
+#define ACPI_ACCESS_BYTE_SHIFT		-1
+#define ACPI_ACCESS_BIT_MAX		(31 - ACPI_ACCESS_BIT_SHIFT)
+#define ACPI_ACCESS_BYTE_MAX		(31 - ACPI_ACCESS_BYTE_SHIFT)
+#define ACPI_ACCESS_BIT_DEFAULT		(8 - ACPI_ACCESS_BIT_SHIFT)
+#define ACPI_ACCESS_BYTE_DEFAULT	(8 - ACPI_ACCESS_BYTE_SHIFT)
+#define ACPI_ACCESS_BIT_WIDTH(size)	(1 << ((size) + ACPI_ACCESS_BIT_SHIFT))
+#define ACPI_ACCESS_BYTE_WIDTH(size)	(1 << ((size) + ACPI_ACCESS_BYTE_SHIFT))
 
 /*******************************************************************************
  *
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 37876d842f2e..c4ab9934b41d 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -885,6 +885,7 @@ struct psched_ratecfg {
 	u64	rate_bytes_ps; /* bytes per second */
 	u32	mult;
 	u16	overhead;
+	u16	mpu;
 	u8	linklayer;
 	u8	shift;
 };
@@ -894,6 +895,9 @@ static inline u64 psched_l2t_ns(const struct psched_ratecfg *r,
 {
 	len += r->overhead;
 
+	if (len < r->mpu)
+		len = r->mpu;
+
 	if (unlikely(r->linklayer == TC_LINKLAYER_ATM))
 		return ((u64)(DIV_ROUND_UP(len,48)*53) * r->mult) >> r->shift;
 
@@ -916,6 +920,7 @@ static inline void psched_ratecfg_getrate(struct tc_ratespec *res,
 	res->rate = min_t(u64, r->rate_bytes_ps, ~0U);
 
 	res->overhead = r->overhead;
+	res->mpu = r->mpu;
 	res->linklayer = (r->linklayer & TC_LINKLAYER_MASK);
 }
 
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 45c2cd37fe6b..60d4cd6d9c59 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -150,10 +150,10 @@ void account_guest_time(struct task_struct *p, u64 cputime)
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += cputime;
+		task_group_account_field(p, CPUTIME_NICE, cputime);
 		cpustat[CPUTIME_GUEST_NICE] += cputime;
 	} else {
-		cpustat[CPUTIME_USER] += cputime;
+		task_group_account_field(p, CPUTIME_USER, cputime);
 		cpustat[CPUTIME_GUEST] += cputime;
 	}
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index cc7dd1aaf08e..c093bb0f52eb 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -52,11 +52,8 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	rt_b->rt_period_timer.function = sched_rt_period_timer;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static inline void do_start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return;
-
 	raw_spin_lock(&rt_b->rt_runtime_lock);
 	if (!rt_b->rt_period_active) {
 		rt_b->rt_period_active = 1;
@@ -74,6 +71,14 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+		return;
+
+	do_start_rt_bandwidth(rt_b);
+}
+
 void init_rt_rq(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array;
@@ -982,13 +987,17 @@ static void update_curr_rt(struct rq *rq)
 
 	for_each_sched_rt_entity(rt_se) {
 		struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+		int exceeded;
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
-			if (sched_rt_runtime_exceeded(rt_rq))
+			exceeded = sched_rt_runtime_exceeded(rt_rq);
+			if (exceeded)
 				resched_curr(rq);
 			raw_spin_unlock(&rt_rq->rt_runtime_lock);
+			if (exceeded)
+				do_start_rt_bandwidth(sched_rt_bandwidth(rt_rq));
 		}
 	}
 }
@@ -2629,8 +2638,12 @@ static int sched_rt_global_validate(void)
 
 static void sched_rt_do_global(void)
 {
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	def_rt_bandwidth.rt_runtime = global_rt_runtime();
 	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
+	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 }
 
 int sched_rt_handler(struct ctl_table *table, int write,
diff --git a/mm/shmem.c b/mm/shmem.c
index cb1003d1159e..5a7b182f7845 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -450,7 +450,7 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 	struct shmem_inode_info *info;
 	struct page *page;
 	unsigned long batch = sc ? sc->nr_to_scan : 128;
-	int removed = 0, split = 0;
+	int split = 0;
 
 	if (list_empty(&sbinfo->shrinklist))
 		return SHRINK_STOP;
@@ -465,7 +465,6 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		/* inode is about to be evicted */
 		if (!inode) {
 			list_del_init(&info->shrinklist);
-			removed++;
 			goto next;
 		}
 
@@ -473,12 +472,12 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		if (round_up(inode->i_size, PAGE_SIZE) ==
 				round_up(inode->i_size, HPAGE_PMD_SIZE)) {
 			list_move(&info->shrinklist, &to_remove);
-			removed++;
 			goto next;
 		}
 
 		list_move(&info->shrinklist, &list);
 next:
+		sbinfo->shrinklist_len--;
 		if (!--batch)
 			break;
 	}
@@ -498,7 +497,7 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		inode = &info->vfs_inode;
 
 		if (nr_to_split && split >= nr_to_split)
-			goto leave;
+			goto move_back;
 
 		page = find_get_page(inode->i_mapping,
 				(inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
@@ -512,38 +511,44 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		}
 
 		/*
-		 * Leave the inode on the list if we failed to lock
-		 * the page at this time.
+		 * Move the inode on the list back to shrinklist if we failed
+		 * to lock the page at this time.
 		 *
 		 * Waiting for the lock may lead to deadlock in the
 		 * reclaim path.
 		 */
 		if (!trylock_page(page)) {
 			put_page(page);
-			goto leave;
+			goto move_back;
 		}
 
 		ret = split_huge_page(page);
 		unlock_page(page);
 		put_page(page);
 
-		/* If split failed leave the inode on the list */
+		/* If split failed move the inode on the list back to shrinklist */
 		if (ret)
-			goto leave;
+			goto move_back;
 
 		split++;
 drop:
 		list_del_init(&info->shrinklist);
-		removed++;
-leave:
+		goto put;
+move_back:
+		/*
+		 * Make sure the inode is either on the global list or deleted
+		 * from any local list before iput() since it could be deleted
+		 * in another thread once we put the inode (then the local list
+		 * is corrupted).
+		 */
+		spin_lock(&sbinfo->shrinklist_lock);
+		list_move(&info->shrinklist, &sbinfo->shrinklist);
+		sbinfo->shrinklist_len++;
+		spin_unlock(&sbinfo->shrinklist_lock);
+put:
 		iput(inode);
 	}
 
-	spin_lock(&sbinfo->shrinklist_lock);
-	list_splice_tail(&list, &sbinfo->shrinklist);
-	sbinfo->shrinklist_len -= removed;
-	spin_unlock(&sbinfo->shrinklist_lock);
-
 	return split;
 }
 
diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 9873684a9d8f..4764ed73f33b 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -499,9 +499,7 @@ static int __init cmtp_init(void)
 {
 	BT_INFO("CMTP (CAPI Emulation) ver %s", VERSION);
 
-	cmtp_init_sockets();
-
-	return 0;
+	return cmtp_init_sockets();
 }
 
 static void __exit cmtp_exit(void)
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1906adfd553a..687b4d0e4c67 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3183,6 +3183,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 5186f199d892..eca596a56f46 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4967,7 +4967,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
-		if (ev->length <= HCI_MAX_AD_LENGTH) {
+		if (ev->length <= HCI_MAX_AD_LENGTH &&
+		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
 			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
 					   ev->bdaddr_type, NULL, 0, rssi,
@@ -4977,6 +4978,11 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
+
+		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
+			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
+			break;
+		}
 	}
 
 	hci_dev_unlock(hdev);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index a5cc8942fc3f..5c411118b30d 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -48,6 +48,8 @@ struct sco_conn {
 	spinlock_t	lock;
 	struct sock	*sk;
 
+	struct delayed_work	timeout_work;
+
 	unsigned int    mtu;
 };
 
@@ -73,9 +75,20 @@ struct sco_pinfo {
 #define SCO_CONN_TIMEOUT	(HZ * 40)
 #define SCO_DISCONN_TIMEOUT	(HZ * 2)
 
-static void sco_sock_timeout(unsigned long arg)
+static void sco_sock_timeout(struct work_struct *work)
 {
-	struct sock *sk = (struct sock *)arg;
+	struct sco_conn *conn = container_of(work, struct sco_conn,
+					     timeout_work.work);
+	struct sock *sk;
+
+	sco_conn_lock(conn);
+	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
+	sco_conn_unlock(conn);
+
+	if (!sk)
+		return;
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
 
@@ -89,14 +102,21 @@ static void sco_sock_timeout(unsigned long arg)
 
 static void sco_sock_set_timer(struct sock *sk, long timeout)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
+	schedule_delayed_work(&sco_pi(sk)->conn->timeout_work, timeout);
 }
 
 static void sco_sock_clear_timer(struct sock *sk)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
-	sk_stop_timer(sk, &sk->sk_timer);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
 }
 
 /* ---- SCO connections ---- */
@@ -113,6 +133,7 @@ static struct sco_conn *sco_conn_add(struct hci_conn *hcon)
 		return NULL;
 
 	spin_lock_init(&conn->lock);
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
 
 	hcon->sco_data = conn;
 	conn->hcon = hcon;
@@ -178,6 +199,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sock_put(sk);
 	}
 
+	/* Ensure no more work items will run before freeing conn. */
+	cancel_delayed_work_sync(&conn->timeout_work);
+
 	hcon->sco_data = NULL;
 	kfree(conn);
 }
@@ -466,8 +490,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
 
 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
 
-	setup_timer(&sk->sk_timer, sco_sock_timeout, (unsigned long)sk);
-
 	bt_sock_link(&sco_sk_list, sk);
 	return sk;
 }
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 8155c3d811a1..7e50bd9f3611 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -724,6 +724,9 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 	if (nf_bridge->frag_max_size && nf_bridge->frag_max_size < mtu)
 		mtu = nf_bridge->frag_max_size;
 
+	nf_bridge_update_protocol(skb);
+	nf_bridge_push_encap_header(skb);
+
 	if (skb_is_gso(skb) || skb->len + mtu_reserved <= mtu) {
 		nf_bridge_info_free(skb);
 		return br_dev_queue_push_xmit(net, sk, skb);
@@ -741,8 +744,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 
 		data->vlan_tci = skb->vlan_tci;
@@ -765,8 +766,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IP6CB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 		data->encap_size = nf_bridge_encap_header_len(skb);
 		data->size = ETH_HLEN + data->encap_size;
diff --git a/net/core/filter.c b/net/core/filter.c
index 40b378bed603..729e302bba6e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3644,9 +3644,9 @@ void bpf_warn_invalid_xdp_action(u32 act)
 {
 	const u32 act_max = XDP_REDIRECT;
 
-	WARN_ONCE(1, "%s XDP return value %u, expect packet loss!\n",
-		  act > act_max ? "Illegal" : "Driver unsupported",
-		  act);
+	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
+		     act > act_max ? "Illegal" : "Driver unsupported",
+		     act);
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 37f4313e82d2..34fd852fe3ca 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -138,8 +138,10 @@ static void ops_exit_list(const struct pernet_operations *ops,
 {
 	struct net *net;
 	if (ops->exit) {
-		list_for_each_entry(net, net_exit_list, exit_list)
+		list_for_each_entry(net, net_exit_list, exit_list) {
 			ops->exit(net);
+			cond_resched();
+		}
 	}
 	if (ops->exit_batch)
 		ops->exit_batch(net_exit_list);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cbe1177d95f9..13cae95a3466 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4434,7 +4434,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 				goto drop;
 			break;
 		case RX_ENC_VHT:
-			if (WARN_ONCE(status->rate_idx > 9 ||
+			if (WARN_ONCE(status->rate_idx > 11 ||
 				      !status->nss ||
 				      status->nss > 8,
 				      "Rate marked as a VHT rate but data is invalid: MCS: %d, NSS: %d\n",
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 02aebc318763..5bd649457394 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -797,6 +797,11 @@ static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
+	if (!llcp_sock->local) {
+		release_sock(sk);
+		return -ENODEV;
+	}
+
 	if (sk->sk_type == SOCK_DGRAM) {
 		DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, addr,
 				 msg->msg_name);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 091a9746627f..82752dcbf2a2 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1010,6 +1010,7 @@ void psched_ratecfg_precompute(struct psched_ratecfg *r,
 {
 	memset(r, 0, sizeof(*r));
 	r->overhead = conf->overhead;
+	r->mpu = conf->mpu;
 	r->rate_bytes_ps = max_t(u64, conf->rate, rate64);
 	r->linklayer = (conf->linklayer & TC_LINKLAYER_MASK);
 	r->mult = 1;
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 8bbe1b8e4ff7..4d283e26d816 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -197,8 +197,11 @@ void wait_for_unix_gc(void)
 {
 	/* If number of inflight sockets is insane,
 	 * force a garbage collect right now.
+	 * Paired with the WRITE_ONCE() in unix_inflight(),
+	 * unix_notinflight() and gc_in_progress().
 	 */
-	if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
+	if (READ_ONCE(unix_tot_inflight) > UNIX_INFLIGHT_TRIGGER_GC &&
+	    !READ_ONCE(gc_in_progress))
 		unix_gc();
 	wait_event(unix_gc_wait, gc_in_progress == false);
 }
@@ -218,7 +221,9 @@ void unix_gc(void)
 	if (gc_in_progress)
 		goto out;
 
-	gc_in_progress = true;
+	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
+	WRITE_ONCE(gc_in_progress, true);
+
 	/* First, select candidates for garbage collection.  Only
 	 * in-flight sockets are considered, and from those only ones
 	 * which don't have any external reference.
@@ -304,7 +309,10 @@ void unix_gc(void)
 
 	/* All candidates should have been detached by now. */
 	BUG_ON(!list_empty(&gc_candidates));
-	gc_in_progress = false;
+
+	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
+	WRITE_ONCE(gc_in_progress, false);
+
 	wake_up(&unix_gc_wait);
 
  out:
diff --git a/net/unix/scm.c b/net/unix/scm.c
index e13d320c41c7..6c10af6037e3 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -57,7 +57,8 @@ void unix_inflight(struct user_struct *user, struct file *fp)
 		} else {
 			BUG_ON(list_empty(&u->link));
 		}
-		unix_tot_inflight++;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight + 1);
 	}
 	user->unix_inflight++;
 	spin_unlock(&unix_gc_lock);
@@ -77,7 +78,8 @@ void unix_notinflight(struct user_struct *user, struct file *fp)
 
 		if (atomic_long_dec_and_test(&u->inflight))
 			list_del_init(&u->link);
-		unix_tot_inflight--;
+		/* Paired with READ_ONCE() in wait_for_unix_gc() */
+		WRITE_ONCE(unix_tot_inflight, unix_tot_inflight - 1);
 	}
 	user->unix_inflight--;
 	spin_unlock(&unix_gc_lock);
diff --git a/scripts/dtc/dtx_diff b/scripts/dtc/dtx_diff
index 8c4fbad2055e..1046bdc0719d 100755
--- a/scripts/dtc/dtx_diff
+++ b/scripts/dtc/dtx_diff
@@ -56,12 +56,8 @@ Otherwise DTx is treated as a dts source file (aka .dts).
    or '/include/' to be processed.
 
    If DTx_1 and DTx_2 are in different architectures, then this script
-   may not work since \${ARCH} is part of the include path.  Two possible
-   workarounds:
-
-      `basename $0` \\
-          <(ARCH=arch_of_dtx_1 `basename $0` DTx_1) \\
-          <(ARCH=arch_of_dtx_2 `basename $0` DTx_2)
+   may not work since \${ARCH} is part of the include path.  The following
+   workaround can be used:
 
       `basename $0` ARCH=arch_of_dtx_1 DTx_1 >tmp_dtx_1.dts
       `basename $0` ARCH=arch_of_dtx_2 DTx_2 >tmp_dtx_2.dts
diff --git a/sound/core/jack.c b/sound/core/jack.c
index 5ddf81f091fa..36cfe1c54109 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -68,10 +68,13 @@ static int snd_jack_dev_free(struct snd_device *device)
 	struct snd_card *card = device->card;
 	struct snd_jack_kctl *jack_kctl, *tmp_jack_kctl;
 
+	down_write(&card->controls_rwsem);
 	list_for_each_entry_safe(jack_kctl, tmp_jack_kctl, &jack->kctl_list, list) {
 		list_del_init(&jack_kctl->list);
 		snd_ctl_remove(card, jack_kctl->kctl);
 	}
+	up_write(&card->controls_rwsem);
+
 	if (jack->private_free)
 		jack->private_free(jack);
 
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index b092f257c1c6..87806dab321a 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2070,7 +2070,7 @@ static int snd_pcm_oss_set_trigger(struct snd_pcm_oss_file *pcm_oss_file, int tr
 	int err, cmd;
 
 #ifdef OSS_DEBUG
-	pcm_dbg(substream->pcm, "pcm_oss: trigger = 0x%x\n", trigger);
+	pr_debug("pcm_oss: trigger = 0x%x\n", trigger);
 #endif
 	
 	psubstream = pcm_oss_file->streams[SNDRV_PCM_STREAM_PLAYBACK];
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 2b5caa8dea2e..a228bf933110 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -875,7 +875,11 @@ EXPORT_SYMBOL(snd_pcm_new_internal);
 static void free_chmap(struct snd_pcm_str *pstr)
 {
 	if (pstr->chmap_kctl) {
-		snd_ctl_remove(pstr->pcm->card, pstr->chmap_kctl);
+		struct snd_card *card = pstr->pcm->card;
+
+		down_write(&card->controls_rwsem);
+		snd_ctl_remove(card, pstr->chmap_kctl);
+		up_write(&card->controls_rwsem);
 		pstr->chmap_kctl = NULL;
 	}
 }
diff --git a/sound/core/seq/seq_queue.c b/sound/core/seq/seq_queue.c
index ea1aa0796276..b923059a2227 100644
--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -257,12 +257,15 @@ struct snd_seq_queue *snd_seq_queue_find_name(char *name)
 
 /* -------------------------------------------------------- */
 
+#define MAX_CELL_PROCESSES_IN_QUEUE	1000
+
 void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
 {
 	unsigned long flags;
 	struct snd_seq_event_cell *cell;
 	snd_seq_tick_time_t cur_tick;
 	snd_seq_real_time_t cur_time;
+	int processed = 0;
 
 	if (q == NULL)
 		return;
@@ -285,6 +288,8 @@ void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
 		if (!cell)
 			break;
 		snd_seq_dispatch_event(cell, atomic, hop);
+		if (++processed >= MAX_CELL_PROCESSES_IN_QUEUE)
+			goto out; /* the rest processed at the next batch */
 	}
 
 	/* Process time queue... */
@@ -294,14 +299,19 @@ void snd_seq_check_queue(struct snd_seq_queue *q, int atomic, int hop)
 		if (!cell)
 			break;
 		snd_seq_dispatch_event(cell, atomic, hop);
+		if (++processed >= MAX_CELL_PROCESSES_IN_QUEUE)
+			goto out; /* the rest processed at the next batch */
 	}
 
+ out:
 	/* free lock */
 	spin_lock_irqsave(&q->check_lock, flags);
 	if (q->check_again) {
 		q->check_again = 0;
-		spin_unlock_irqrestore(&q->check_lock, flags);
-		goto __again;
+		if (processed < MAX_CELL_PROCESSES_IN_QUEUE) {
+			spin_unlock_irqrestore(&q->check_lock, flags);
+			goto __again;
+		}
 	}
 	q->check_blocked = 0;
 	spin_unlock_irqrestore(&q->check_lock, flags);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index a56f018d586f..8ec73955170b 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1680,8 +1680,11 @@ void snd_hda_ctls_clear(struct hda_codec *codec)
 {
 	int i;
 	struct hda_nid_item *items = codec->mixers.list;
+
+	down_write(&codec->card->controls_rwsem);
 	for (i = 0; i < codec->mixers.used; i++)
 		snd_ctl_remove(codec->card, items[i].kctl);
+	up_write(&codec->card->controls_rwsem);
 	snd_array_free(&codec->mixers);
 	snd_array_free(&codec->nids);
 }
diff --git a/sound/soc/mediatek/mt8173/mt8173-max98090.c b/sound/soc/mediatek/mt8173/mt8173-max98090.c
index e0c2b23ec711..0adb7ded61e9 100644
--- a/sound/soc/mediatek/mt8173/mt8173-max98090.c
+++ b/sound/soc/mediatek/mt8173/mt8173-max98090.c
@@ -177,6 +177,9 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(codec_node);
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
index 99c15219dbc8..aa52e2f81760 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
@@ -227,6 +227,8 @@ static int mt8173_rt5650_rt5514_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
index 42de84ca8c84..61b0d8f8678e 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c
@@ -284,6 +284,8 @@ static int mt8173_rt5650_rt5676_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650.c b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
index e69c141d8ed4..3492c02f72c1 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
@@ -316,6 +316,8 @@ static int mt8173_rt5650_dev_probe(struct platform_device *pdev)
 	if (ret)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
+
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
index a635df61f928..2a6ffb2abb33 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -369,6 +369,8 @@ static int preallocate_idma_buffer(struct snd_pcm *pcm, int stream)
 	buf->addr = idma.lp_tx_addr;
 	buf->bytes = idma_hardware.buffer_bytes_max;
 	buf->area = (unsigned char * __force)ioremap(buf->addr, buf->bytes);
+	if (!buf->area)
+		return -ENOMEM;
 
 	return 0;
 }
