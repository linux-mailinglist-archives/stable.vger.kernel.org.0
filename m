Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44B3F88C1
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhHZN01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242573AbhHZN00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 790E0610C8;
        Thu, 26 Aug 2021 13:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629984339;
        bh=jj/e/ruEvGJSLm9S3T67Z2R3hMPssUOlcfAY/e3f1ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZgsQMrJfhPwALeOScM2MoYMbddSaffdF5tMfE1AwzpeWAFdxCwnc2SZC8Tj/V4lI
         TDef+XzbnoI801/pKHxP4jxlTIup4Fk13oCnYoJvJmtS2L9qEaUMyKUgUtnDVFNrzy
         7uqBnK3SshTBvvaY1iOm53uPitHVenE3x6m8qvCI4ZhzQ0ynXspElHGvwMj0jrOQn8
         Riv/Wgq1nCZxEyuxlTJbpuoJk4tVE5XUO2RKVrNTKreM4sW6PBksTrr497Q4QaIhn0
         3IwzUzw69oiByXv6YRvPo/07Q92szr77boY1KN/Ju4K2WcqXfMvu/NHuq+VcaxqFNB
         5dqIQG6tfePUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: Linux 5.13.13
Date:   Thu, 26 Aug 2021 09:25:36 -0400
Message-Id: <20210826132536.804538-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826132536.804538-1-sashal@kernel.org>
References: <20210826132536.804538-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 2458a4abcbcc..ed4031db3894 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 8b696107eef8..d2aebdbc7e0f 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -582,7 +582,7 @@
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
-	clock-frequency = <400000>;
+	clock-frequency = <100000>;
 
 	tps65218: tps65218@24 {
 		reg = <0x24>;
diff --git a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index c9b906432341..1815361fe73c 100644
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@ -755,14 +755,14 @@
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
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index b52481f0605d..02997b253dee 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -181,6 +181,8 @@ archprepare:
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
+	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso
+	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso32
 
 ifeq ($(KBUILD_EXTMOD),)
 # We need to generate vdso-offsets.h before compiling certain files in kernel/.
diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index 23cdcc9f7c72..1ccca83292ac 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
  */
 
 /dts-v1/;
@@ -9,6 +10,9 @@
 #include "pm8994.dtsi"
 #include "pmi8994.dtsi"
 
+/* cont_splash_mem has different memory mapping */
+/delete-node/ &cont_splash_mem;
+
 / {
 	model = "LG Nexus 5X";
 	compatible = "lg,bullhead", "qcom,msm8992";
@@ -17,6 +21,9 @@
 	qcom,board-id = <0xb64 0>;
 	qcom,pmic-id = <0x10009 0x1000A 0x0 0x0>;
 
+	/* Bullhead firmware doesn't support PSCI */
+	/delete-node/ psci;
+
 	aliases {
 		serial0 = &blsp1_uart2;
 	};
@@ -38,6 +45,11 @@
 			ftrace-size = <0x10000>;
 			pmsg-size = <0x20000>;
 		};
+
+		cont_splash_mem: memory@3400000 {
+			reg = <0 0x03400000 0 0x1200000>;
+			no-map;
+		};
 	};
 };
 
diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
index baa55643b40f..801995af3dfc 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, Huawei Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
  */
 
 /dts-v1/;
 
 #include "msm8994.dtsi"
 
+/* Angler's firmware does not report where the memory is allocated */
+/delete-node/ &cont_splash_mem;
+
 / {
 	model = "Huawei Nexus 6P";
 	compatible = "huawei,angler", "qcom,msm8994";
diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index f712771df0c7..846eebebd831 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -69,7 +69,7 @@
 		};
 		rmtfs_upper_guard: memory@f5d01000 {
 			no-map;
-			reg = <0 0xf5d01000 0 0x2000>;
+			reg = <0 0xf5d01000 0 0x1000>;
 		};
 
 		/*
@@ -78,7 +78,7 @@
 		 */
 		removed_region: memory@88f00000 {
 			no-map;
-			reg = <0 0x88f00000 0 0x200000>;
+			reg = <0 0x88f00000 0 0x1c00000>;
 		};
 
 		ramoops: ramoops@ac300000 {
diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index c2a709a384e9..d7591a4621a2 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -700,7 +700,7 @@
 		left_spkr: wsa8810-left{
 			compatible = "sdw10217211000";
 			reg = <0 3>;
-			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrLeft";
 			#sound-dai-cells = <0>;
@@ -708,7 +708,7 @@
 
 		right_spkr: wsa8810-right{
 			compatible = "sdw10217211000";
-			powerdown-gpios = <&wcdgpio 3 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
 			reg = <0 4>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrRight";
diff --git a/arch/powerpc/include/asm/book3s/32/kup.h b/arch/powerpc/include/asm/book3s/32/kup.h
index 1670dfe9d4f1..c6cfca9d2bd7 100644
--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -4,9 +4,50 @@
 
 #include <asm/bug.h>
 #include <asm/book3s/32/mmu-hash.h>
+#include <asm/mmu.h>
+#include <asm/synch.h>
 
 #ifndef __ASSEMBLY__
 
+static __always_inline bool kuep_is_disabled(void)
+{
+	return !IS_ENABLED(CONFIG_PPC_KUEP);
+}
+
+static inline void kuep_lock(void)
+{
+	if (kuep_is_disabled())
+		return;
+
+	update_user_segments(mfsr(0) | SR_NX);
+	/*
+	 * This isync() shouldn't be necessary as the kernel is not excepted to
+	 * run any instruction in userspace soon after the update of segments,
+	 * but hash based cores (at least G3) seem to exhibit a random
+	 * behaviour when the 'isync' is not there. 603 cores don't have this
+	 * behaviour so don't do the 'isync' as it saves several CPU cycles.
+	 */
+	if (mmu_has_feature(MMU_FTR_HPTE_TABLE))
+		isync();	/* Context sync required after mtsr() */
+}
+
+static inline void kuep_unlock(void)
+{
+	if (kuep_is_disabled())
+		return;
+
+	update_user_segments(mfsr(0) & ~SR_NX);
+	/*
+	 * This isync() shouldn't be necessary as a 'rfi' will soon be executed
+	 * to return to userspace, but hash based cores (at least G3) seem to
+	 * exhibit a random behaviour when the 'isync' is not there. 603 cores
+	 * don't have this behaviour so don't do the 'isync' as it saves several
+	 * CPU cycles.
+	 */
+	if (mmu_has_feature(MMU_FTR_HPTE_TABLE))
+		isync();	/* Context sync required after mtsr() */
+}
+
 #ifdef CONFIG_PPC_KUAP
 
 #include <linux/sched.h>
diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index b85f8e114a9c..cc0284bbac86 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -102,6 +102,33 @@ extern s32 patch__hash_page_B, patch__hash_page_C;
 extern s32 patch__flush_hash_A0, patch__flush_hash_A1, patch__flush_hash_A2;
 extern s32 patch__flush_hash_B;
 
+#include <asm/reg.h>
+#include <asm/task_size_32.h>
+
+#define UPDATE_TWO_USER_SEGMENTS(n) do {		\
+	if (TASK_SIZE > ((n) << 28))			\
+		mtsr(val1, (n) << 28);			\
+	if (TASK_SIZE > (((n) + 1) << 28))		\
+		mtsr(val2, ((n) + 1) << 28);		\
+	val1 = (val1 + 0x222) & 0xf0ffffff;		\
+	val2 = (val2 + 0x222) & 0xf0ffffff;		\
+} while (0)
+
+static __always_inline void update_user_segments(u32 val)
+{
+	int val1 = val;
+	int val2 = (val + 0x111) & 0xf0ffffff;
+
+	UPDATE_TWO_USER_SEGMENTS(0);
+	UPDATE_TWO_USER_SEGMENTS(2);
+	UPDATE_TWO_USER_SEGMENTS(4);
+	UPDATE_TWO_USER_SEGMENTS(6);
+	UPDATE_TWO_USER_SEGMENTS(8);
+	UPDATE_TWO_USER_SEGMENTS(10);
+	UPDATE_TWO_USER_SEGMENTS(12);
+	UPDATE_TWO_USER_SEGMENTS(14);
+}
+
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index ec96232529ac..4b94d4293777 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -46,10 +46,7 @@ void setup_kuep(bool disabled);
 static inline void setup_kuep(bool disabled) { }
 #endif /* CONFIG_PPC_KUEP */
 
-#if defined(CONFIG_PPC_KUEP) && defined(CONFIG_PPC_BOOK3S_32)
-void kuep_lock(void);
-void kuep_unlock(void);
-#else
+#ifndef CONFIG_PPC_BOOK3S_32
 static inline void kuep_lock(void) { }
 static inline void kuep_unlock(void) { }
 #endif
diff --git a/arch/powerpc/mm/book3s32/Makefile b/arch/powerpc/mm/book3s32/Makefile
index 7f0c8a78ba0c..15f4773643d2 100644
--- a/arch/powerpc/mm/book3s32/Makefile
+++ b/arch/powerpc/mm/book3s32/Makefile
@@ -10,3 +10,4 @@ obj-y += mmu.o mmu_context.o
 obj-$(CONFIG_PPC_BOOK3S_603) += nohash_low.o
 obj-$(CONFIG_PPC_BOOK3S_604) += hash_low.o tlb.o
 obj-$(CONFIG_PPC_KUEP) += kuep.o
+obj-$(CONFIG_PPC_KUAP) += kuap.o
diff --git a/arch/powerpc/mm/book3s32/kuap.c b/arch/powerpc/mm/book3s32/kuap.c
new file mode 100644
index 000000000000..1df55392878e
--- /dev/null
+++ b/arch/powerpc/mm/book3s32/kuap.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <asm/kup.h>
+
+void __init setup_kuap(bool disabled)
+{
+	pr_info("Activating Kernel Userspace Access Protection\n");
+
+	if (disabled)
+		pr_warn("KUAP cannot be disabled yet on 6xx when compiled in\n");
+}
diff --git a/arch/powerpc/mm/book3s32/kuep.c b/arch/powerpc/mm/book3s32/kuep.c
index 8ed1b8634839..919595f47e25 100644
--- a/arch/powerpc/mm/book3s32/kuep.c
+++ b/arch/powerpc/mm/book3s32/kuep.c
@@ -1,40 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 #include <asm/kup.h>
-#include <asm/reg.h>
-#include <asm/task_size_32.h>
-#include <asm/mmu.h>
 
-#define KUEP_UPDATE_TWO_USER_SEGMENTS(n) do {		\
-	if (TASK_SIZE > ((n) << 28))			\
-		mtsr(val1, (n) << 28);			\
-	if (TASK_SIZE > (((n) + 1) << 28))		\
-		mtsr(val2, ((n) + 1) << 28);		\
-	val1 = (val1 + 0x222) & 0xf0ffffff;		\
-	val2 = (val2 + 0x222) & 0xf0ffffff;		\
-} while (0)
-
-static __always_inline void kuep_update(u32 val)
+void __init setup_kuep(bool disabled)
 {
-	int val1 = val;
-	int val2 = (val + 0x111) & 0xf0ffffff;
-
-	KUEP_UPDATE_TWO_USER_SEGMENTS(0);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(2);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(4);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(6);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(8);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(10);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(12);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(14);
-}
+	pr_info("Activating Kernel Userspace Execution Prevention\n");
 
-void kuep_lock(void)
-{
-	kuep_update(mfsr(0) | SR_NX);
-}
-
-void kuep_unlock(void)
-{
-	kuep_update(mfsr(0) & ~SR_NX);
+	if (disabled)
+		pr_warn("KUEP cannot be disabled yet on 6xx when compiled in\n");
 }
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 159930351d9f..27061583a010 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -445,26 +445,6 @@ void __init print_system_hash_info(void)
 		pr_info("Hash_mask         = 0x%lx\n", Hash_mask);
 }
 
-#ifdef CONFIG_PPC_KUEP
-void __init setup_kuep(bool disabled)
-{
-	pr_info("Activating Kernel Userspace Execution Prevention\n");
-
-	if (disabled)
-		pr_warn("KUEP cannot be disabled yet on 6xx when compiled in\n");
-}
-#endif
-
-#ifdef CONFIG_PPC_KUAP
-void __init setup_kuap(bool disabled)
-{
-	pr_info("Activating Kernel Userspace Access Protection\n");
-
-	if (disabled)
-		pr_warn("KUAP cannot be disabled yet on 6xx when compiled in\n");
-}
-#endif
-
 void __init early_init_mmu(void)
 {
 }
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 9a1b7a0603b2..f2a9cd4284b0 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -230,8 +230,8 @@ static void __init init_resources(void)
 	}
 
 	/* Clean-up any unused pre-allocated resources */
-	mem_res_sz = (num_resources - res_idx + 1) * sizeof(*mem_res);
-	memblock_free(__pa(mem_res), mem_res_sz);
+	if (res_idx >= 0)
+		memblock_free(__pa(mem_res), (res_idx + 1) * sizeof(*mem_res));
 	return;
 
  error:
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index b0993e05affe..8fcb7ecb7225 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -560,9 +560,12 @@ static void zpci_cleanup_bus_resources(struct zpci_dev *zdev)
 
 int pcibios_add_device(struct pci_dev *pdev)
 {
+	struct zpci_dev *zdev = to_zpci(pdev);
 	struct resource *res;
 	int i;
 
+	/* The pdev has a reference to the zdev via its bus */
+	zpci_zdev_get(zdev);
 	if (pdev->is_physfn)
 		pdev->no_vf_scan = 1;
 
@@ -582,7 +585,10 @@ int pcibios_add_device(struct pci_dev *pdev)
 
 void pcibios_release_device(struct pci_dev *pdev)
 {
+	struct zpci_dev *zdev = to_zpci(pdev);
+
 	zpci_unmap_resources(pdev);
+	zpci_zdev_put(zdev);
 }
 
 int pcibios_enable_device(struct pci_dev *pdev, int mask)
diff --git a/arch/s390/pci/pci_bus.h b/arch/s390/pci/pci_bus.h
index b877a97e6745..e359d2686178 100644
--- a/arch/s390/pci/pci_bus.h
+++ b/arch/s390/pci/pci_bus.h
@@ -22,6 +22,11 @@ static inline void zpci_zdev_put(struct zpci_dev *zdev)
 	kref_put(&zdev->kref, zpci_release_device);
 }
 
+static inline void zpci_zdev_get(struct zpci_dev *zdev)
+{
+	kref_get(&zdev->kref);
+}
+
 int zpci_alloc_domain(int domain);
 void zpci_free_domain(int domain);
 int zpci_setup_bus_resources(struct zpci_dev *zdev,
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 1eb45139fcc6..3092fbf9dbe4 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2489,13 +2489,15 @@ void perf_clear_dirty_counters(void)
 		return;
 
 	for_each_set_bit(i, cpuc->dirty, X86_PMC_IDX_MAX) {
-		/* Metrics and fake events don't have corresponding HW counters. */
-		if (is_metric_idx(i) || (i == INTEL_PMC_IDX_FIXED_VLBR))
-			continue;
-		else if (i >= INTEL_PMC_IDX_FIXED)
+		if (i >= INTEL_PMC_IDX_FIXED) {
+			/* Metrics and fake events don't have corresponding HW counters. */
+			if ((i - INTEL_PMC_IDX_FIXED) >= hybrid(cpuc->pmu, num_counters_fixed))
+				continue;
+
 			wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + (i - INTEL_PMC_IDX_FIXED), 0);
-		else
+		} else {
 			wrmsrl(x86_pmu_event_addr(i), 0);
+		}
 	}
 
 	bitmap_zero(cpuc->dirty, X86_PMC_IDX_MAX);
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 81e3279ecd57..15a8be57203d 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -596,13 +596,13 @@ static void kyber_insert_requests(struct blk_mq_hw_ctx *hctx,
 		struct list_head *head = &kcq->rq_list[sched_domain];
 
 		spin_lock(&kcq->lock);
+		trace_block_rq_insert(rq);
 		if (at_head)
 			list_move(&rq->queuelist, head);
 		else
 			list_move_tail(&rq->queuelist, head);
 		sbitmap_set_bit(&khd->kcq_map[sched_domain],
 				rq->mq_ctx->index_hw[hctx->type]);
-		trace_block_rq_insert(rq);
 		spin_unlock(&kcq->lock);
 	}
 }
diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 0ef98e3ba341..148a4dd8cb9a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3097,8 +3097,10 @@ static int sysc_probe(struct platform_device *pdev)
 		return error;
 
 	error = sysc_check_active_timer(ddata);
-	if (error == -EBUSY)
+	if (error == -ENXIO)
 		ddata->reserved = true;
+	else if (error)
+		return error;
 
 	error = sysc_get_clocks(ddata);
 	if (error)
diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index 496900de0b0b..de36f58d551c 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -974,6 +974,6 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 			       hws[IMX6QDL_CLK_PLL3_USB_OTG]->clk);
 	}
 
-	imx_register_uart_clocks(1);
+	imx_register_uart_clocks(2);
 }
 CLK_OF_DECLARE(imx6q, "fsl,imx6q-ccm", imx6q_clocks_init);
diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 51ed640e527b..4ece326ea233 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -357,27 +357,43 @@ static int gdsc_init(struct gdsc *sc)
 	if (on < 0)
 		return on;
 
-	/*
-	 * Votable GDSCs can be ON due to Vote from other masters.
-	 * If a Votable GDSC is ON, make sure we have a Vote.
-	 */
-	if ((sc->flags & VOTABLE) && on)
-		gdsc_enable(&sc->pd);
+	if (on) {
+		/* The regulator must be on, sync the kernel state */
+		if (sc->rsupply) {
+			ret = regulator_enable(sc->rsupply);
+			if (ret < 0)
+				return ret;
+		}
 
-	/*
-	 * Make sure the retain bit is set if the GDSC is already on, otherwise
-	 * we end up turning off the GDSC and destroying all the register
-	 * contents that we thought we were saving.
-	 */
-	if ((sc->flags & RETAIN_FF_ENABLE) && on)
-		gdsc_retain_ff_on(sc);
+		/*
+		 * Votable GDSCs can be ON due to Vote from other masters.
+		 * If a Votable GDSC is ON, make sure we have a Vote.
+		 */
+		if (sc->flags & VOTABLE) {
+			ret = regmap_update_bits(sc->regmap, sc->gdscr,
+						 SW_COLLAPSE_MASK, val);
+			if (ret)
+				return ret;
+		}
+
+		/* Turn on HW trigger mode if supported */
+		if (sc->flags & HW_CTRL) {
+			ret = gdsc_hwctrl(sc, true);
+			if (ret < 0)
+				return ret;
+		}
 
-	/* If ALWAYS_ON GDSCs are not ON, turn them ON */
-	if (sc->flags & ALWAYS_ON) {
-		if (!on)
-			gdsc_enable(&sc->pd);
+		/*
+		 * Make sure the retain bit is set if the GDSC is already on,
+		 * otherwise we end up turning off the GDSC and destroying all
+		 * the register contents that we thought we were saving.
+		 */
+		if (sc->flags & RETAIN_FF_ENABLE)
+			gdsc_retain_ff_on(sc);
+	} else if (sc->flags & ALWAYS_ON) {
+		/* If ALWAYS_ON GDSCs are not ON, turn them ON */
+		gdsc_enable(&sc->pd);
 		on = true;
-		sc->pd.flags |= GENPD_FLAG_ALWAYS_ON;
 	}
 
 	if (on || (sc->pwrsts & PWRSTS_RET))
@@ -385,6 +401,8 @@ static int gdsc_init(struct gdsc *sc)
 	else
 		gdsc_clear_mem_on(sc);
 
+	if (sc->flags & ALWAYS_ON)
+		sc->pd.flags |= GENPD_FLAG_ALWAYS_ON;
 	if (!sc->pd.power_off)
 		sc->pd.power_off = gdsc_disable;
 	if (!sc->pd.power_on)
diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index 3fc98a3ffd91..c10fc33b29b1 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -104,7 +104,11 @@ struct armada_37xx_dvfs {
 };
 
 static struct armada_37xx_dvfs armada_37xx_dvfs[] = {
-	{.cpu_freq_max = 1200*1000*1000, .divider = {1, 2, 4, 6} },
+	/*
+	 * The cpufreq scaling for 1.2 GHz variant of the SOC is currently
+	 * unstable because we do not know how to configure it properly.
+	 */
+	/* {.cpu_freq_max = 1200*1000*1000, .divider = {1, 2, 4, 6} }, */
 	{.cpu_freq_max = 1000*1000*1000, .divider = {1, 2, 4, 5} },
 	{.cpu_freq_max = 800*1000*1000,  .divider = {1, 2, 3, 4} },
 	{.cpu_freq_max = 600*1000*1000,  .divider = {2, 4, 5, 6} },
diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index ec9a87ca2dbb..75f818d04b48 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -134,7 +134,7 @@ static int scmi_cpufreq_init(struct cpufreq_policy *policy)
 	}
 
 	if (!zalloc_cpumask_var(&opp_shared_cpus, GFP_KERNEL))
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	/* Obtain CPUs that share SCMI performance controls */
 	ret = scmi_get_sharing_cpus(cpu_dev, policy->cpus);
diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index ec00b20ae8e4..ac61ecda2926 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -67,8 +67,12 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
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
@@ -89,6 +93,7 @@ static struct dma_chan *of_dma_router_xlate(struct of_phandle_args *dma_spec,
 		}
 	}
 
+err:
 	/*
 	 * Need to put the node back since the ofdma->of_dma_route_allocate
 	 * has taken it for generating the new, translated dma_spec
diff --git a/drivers/dma/sh/usb-dmac.c b/drivers/dma/sh/usb-dmac.c
index 8f7ceb698226..1cc06900153e 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -855,8 +855,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
 error:
 	of_dma_controller_free(pdev->dev.of_node);
-	pm_runtime_put(&pdev->dev);
 error_pm:
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 75c0b8e904e5..4b9530a7bf65 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -394,6 +394,7 @@ struct xilinx_dma_tx_descriptor {
  * @genlock: Support genlock mode
  * @err: Channel has errors
  * @idle: Check for channel idle
+ * @terminating: Check for channel being synchronized by user
  * @tasklet: Cleanup work after irq
  * @config: Device configuration info
  * @flush_on_fsync: Flush on Frame sync
@@ -431,6 +432,7 @@ struct xilinx_dma_chan {
 	bool genlock;
 	bool err;
 	bool idle;
+	bool terminating;
 	struct tasklet_struct tasklet;
 	struct xilinx_vdma_config config;
 	bool flush_on_fsync;
@@ -1049,6 +1051,13 @@ static void xilinx_dma_chan_desc_cleanup(struct xilinx_dma_chan *chan)
 		/* Run any dependencies, then free the descriptor */
 		dma_run_dependencies(&desc->async_tx);
 		xilinx_dma_free_tx_descriptor(chan, desc);
+
+		/*
+		 * While we ran a callback the user called a terminate function,
+		 * which takes care of cleaning up any remaining descriptors
+		 */
+		if (chan->terminating)
+			break;
 	}
 
 	spin_unlock_irqrestore(&chan->lock, flags);
@@ -1965,6 +1974,8 @@ static dma_cookie_t xilinx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (desc->cyclic)
 		chan->cyclic = true;
 
+	chan->terminating = false;
+
 	spin_unlock_irqrestore(&chan->lock, flags);
 
 	return cookie;
@@ -2436,6 +2447,7 @@ static int xilinx_dma_terminate_all(struct dma_chan *dchan)
 
 	xilinx_dma_chan_reset(chan);
 	/* Remove and free all of the descriptors in the lists */
+	chan->terminating = true;
 	xilinx_dma_free_descriptors(chan);
 	chan->idle = true;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 516467e962b7..3a476b86485e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1293,6 +1293,16 @@ static bool is_raven_kicker(struct amdgpu_device *adev)
 		return false;
 }
 
+static bool check_if_enlarge_doorbell_range(struct amdgpu_device *adev)
+{
+	if ((adev->asic_type == CHIP_RENOIR) &&
+	    (adev->gfx.me_fw_version >= 0x000000a5) &&
+	    (adev->gfx.me_feature_version >= 52))
+		return true;
+	else
+		return false;
+}
+
 static void gfx_v9_0_check_if_need_gfxoff(struct amdgpu_device *adev)
 {
 	if (gfx_v9_0_should_disable_gfxoff(adev->pdev))
@@ -3673,7 +3683,16 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
 	if (ring->use_doorbell) {
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
 					(adev->doorbell_index.kiq * 2) << 2);
-		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
+		/* If GC has entered CGPG, ringing doorbell > first page
+		 * doesn't wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to
+		 * workaround this issue. And this change has to align with firmware
+		 * update.
+		 */
+		if (check_if_enlarge_doorbell_range(adev))
+			WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
+					(adev->doorbell.size - 4));
+		else
+			WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
 					(adev->doorbell_index.userqueue_end * 2) << 2);
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 75ba86f951f8..7bbedb6b4a9e 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -66,9 +66,11 @@ int rn_get_active_display_cnt_wa(
 	for (i = 0; i < context->stream_count; i++) {
 		const struct dc_stream_state *stream = context->streams[i];
 
+		/* Extend the WA to DP for Linux*/
 		if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A ||
 				stream->signal == SIGNAL_TYPE_DVI_SINGLE_LINK ||
-				stream->signal == SIGNAL_TYPE_DVI_DUAL_LINK)
+				stream->signal == SIGNAL_TYPE_DVI_DUAL_LINK ||
+				stream->signal == SIGNAL_TYPE_DISPLAY_PORT)
 			tmds_present = true;
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
index 3139d90017ee..23f830986f78 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c
@@ -464,7 +464,7 @@ void optc2_lock_doublebuffer_enable(struct timing_generator *optc)
 
 	REG_UPDATE_2(OTG_GLOBAL_CONTROL1,
 			MASTER_UPDATE_LOCK_DB_X,
-			h_blank_start - 200 - 1,
+			(h_blank_start - 200 - 1) / optc1->opp_count,
 			MASTER_UPDATE_LOCK_DB_Y,
 			v_blank_start - 1);
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index 472696f949ac..63b09c1124c4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1622,106 +1622,12 @@ static void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *b
 	dml_init_instance(&dc->dml, &dcn3_01_soc, &dcn3_01_ip, DML_PROJECT_DCN30);
 }
 
-static void calculate_wm_set_for_vlevel(
-		int vlevel,
-		struct wm_range_table_entry *table_entry,
-		struct dcn_watermarks *wm_set,
-		struct display_mode_lib *dml,
-		display_e2e_pipe_params_st *pipes,
-		int pipe_cnt)
-{
-	double dram_clock_change_latency_cached = dml->soc.dram_clock_change_latency_us;
-
-	ASSERT(vlevel < dml->soc.num_states);
-	/* only pipe 0 is read for voltage and dcf/soc clocks */
-	pipes[0].clks_cfg.voltage = vlevel;
-	pipes[0].clks_cfg.dcfclk_mhz = dml->soc.clock_limits[vlevel].dcfclk_mhz;
-	pipes[0].clks_cfg.socclk_mhz = dml->soc.clock_limits[vlevel].socclk_mhz;
-
-	dml->soc.dram_clock_change_latency_us = table_entry->pstate_latency_us;
-	dml->soc.sr_exit_time_us = table_entry->sr_exit_time_us;
-	dml->soc.sr_enter_plus_exit_time_us = table_entry->sr_enter_plus_exit_time_us;
-
-	wm_set->urgent_ns = get_wm_urgent(dml, pipes, pipe_cnt) * 1000;
-	wm_set->cstate_pstate.cstate_enter_plus_exit_ns = get_wm_stutter_enter_exit(dml, pipes, pipe_cnt) * 1000;
-	wm_set->cstate_pstate.cstate_exit_ns = get_wm_stutter_exit(dml, pipes, pipe_cnt) * 1000;
-	wm_set->cstate_pstate.pstate_change_ns = get_wm_dram_clock_change(dml, pipes, pipe_cnt) * 1000;
-	wm_set->pte_meta_urgent_ns = get_wm_memory_trip(dml, pipes, pipe_cnt) * 1000;
-	wm_set->frac_urg_bw_nom = get_fraction_of_urgent_bandwidth(dml, pipes, pipe_cnt) * 1000;
-	wm_set->frac_urg_bw_flip = get_fraction_of_urgent_bandwidth_imm_flip(dml, pipes, pipe_cnt) * 1000;
-	wm_set->urgent_latency_ns = get_urgent_latency(dml, pipes, pipe_cnt) * 1000;
-	dml->soc.dram_clock_change_latency_us = dram_clock_change_latency_cached;
-
-}
-
-static void dcn301_calculate_wm_and_dlg(
-		struct dc *dc, struct dc_state *context,
-		display_e2e_pipe_params_st *pipes,
-		int pipe_cnt,
-		int vlevel_req)
-{
-	int i, pipe_idx;
-	int vlevel, vlevel_max;
-	struct wm_range_table_entry *table_entry;
-	struct clk_bw_params *bw_params = dc->clk_mgr->bw_params;
-
-	ASSERT(bw_params);
-
-	vlevel_max = bw_params->clk_table.num_entries - 1;
-
-	/* WM Set D */
-	table_entry = &bw_params->wm_table.entries[WM_D];
-	if (table_entry->wm_type == WM_TYPE_RETRAINING)
-		vlevel = 0;
-	else
-		vlevel = vlevel_max;
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.d,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-	/* WM Set C */
-	table_entry = &bw_params->wm_table.entries[WM_C];
-	vlevel = min(max(vlevel_req, 2), vlevel_max);
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.c,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-	/* WM Set B */
-	table_entry = &bw_params->wm_table.entries[WM_B];
-	vlevel = min(max(vlevel_req, 1), vlevel_max);
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.b,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-
-	/* WM Set A */
-	table_entry = &bw_params->wm_table.entries[WM_A];
-	vlevel = min(vlevel_req, vlevel_max);
-	calculate_wm_set_for_vlevel(vlevel, table_entry, &context->bw_ctx.bw.dcn.watermarks.a,
-						&context->bw_ctx.dml, pipes, pipe_cnt);
-
-	for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
-		if (!context->res_ctx.pipe_ctx[i].stream)
-			continue;
-
-		pipes[pipe_idx].clks_cfg.dispclk_mhz = get_dispclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt);
-		pipes[pipe_idx].clks_cfg.dppclk_mhz = get_dppclk_calculated(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx);
-
-		if (dc->config.forced_clocks) {
-			pipes[pipe_idx].clks_cfg.dispclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dispclk_mhz;
-			pipes[pipe_idx].clks_cfg.dppclk_mhz = context->bw_ctx.dml.soc.clock_limits[0].dppclk_mhz;
-		}
-		if (dc->debug.min_disp_clk_khz > pipes[pipe_idx].clks_cfg.dispclk_mhz * 1000)
-			pipes[pipe_idx].clks_cfg.dispclk_mhz = dc->debug.min_disp_clk_khz / 1000.0;
-		if (dc->debug.min_dpp_clk_khz > pipes[pipe_idx].clks_cfg.dppclk_mhz * 1000)
-			pipes[pipe_idx].clks_cfg.dppclk_mhz = dc->debug.min_dpp_clk_khz / 1000.0;
-
-		pipe_idx++;
-	}
-
-	dcn20_calculate_dlg_params(dc, context, pipes, pipe_cnt, vlevel);
-}
-
 static struct resource_funcs dcn301_res_pool_funcs = {
 	.destroy = dcn301_destroy_resource_pool,
 	.link_enc_create = dcn301_link_encoder_create,
 	.panel_cntl_create = dcn301_panel_cntl_create,
 	.validate_bandwidth = dcn30_validate_bandwidth,
-	.calculate_wm_and_dlg = dcn301_calculate_wm_and_dlg,
+	.calculate_wm_and_dlg = dcn30_calculate_wm_and_dlg,
 	.update_soc_for_wm_a = dcn30_update_soc_for_wm_a,
 	.populate_dml_pipes = dcn30_populate_dml_pipes_from_context,
 	.acquire_idle_pipe_for_layer = dcn20_acquire_idle_pipe_for_layer,
diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
index 99126caf5747..a8597444d515 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -5910,13 +5910,13 @@ void intel_display_power_suspend_late(struct drm_i915_private *i915)
 {
 	if (DISPLAY_VER(i915) >= 11 || IS_GEN9_LP(i915)) {
 		bxt_enable_dc9(i915);
-		/* Tweaked Wa_14010685332:icp,jsp,mcc */
-		if (INTEL_PCH_TYPE(i915) >= PCH_ICP && INTEL_PCH_TYPE(i915) <= PCH_MCC)
-			intel_de_rmw(i915, SOUTH_CHICKEN1,
-				     SBCLK_RUN_REFCLK_DIS, SBCLK_RUN_REFCLK_DIS);
 	} else if (IS_HASWELL(i915) || IS_BROADWELL(i915)) {
 		hsw_enable_pc8(i915);
 	}
+
+	/* Tweaked Wa_14010685332:cnp,icp,jsp,mcc,tgp,adp */
+	if (INTEL_PCH_TYPE(i915) >= PCH_CNP && INTEL_PCH_TYPE(i915) < PCH_DG1)
+		intel_de_rmw(i915, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, SBCLK_RUN_REFCLK_DIS);
 }
 
 void intel_display_power_resume_early(struct drm_i915_private *i915)
@@ -5924,13 +5924,13 @@ void intel_display_power_resume_early(struct drm_i915_private *i915)
 	if (DISPLAY_VER(i915) >= 11 || IS_GEN9_LP(i915)) {
 		gen9_sanitize_dc_state(i915);
 		bxt_disable_dc9(i915);
-		/* Tweaked Wa_14010685332:icp,jsp,mcc */
-		if (INTEL_PCH_TYPE(i915) >= PCH_ICP && INTEL_PCH_TYPE(i915) <= PCH_MCC)
-			intel_de_rmw(i915, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, 0);
-
 	} else if (IS_HASWELL(i915) || IS_BROADWELL(i915)) {
 		hsw_disable_pc8(i915);
 	}
+
+	/* Tweaked Wa_14010685332:cnp,icp,jsp,mcc,tgp,adp */
+	if (INTEL_PCH_TYPE(i915) >= PCH_CNP && INTEL_PCH_TYPE(i915) < PCH_DG1)
+		intel_de_rmw(i915, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, 0);
 }
 
 void intel_display_power_suspend(struct drm_i915_private *i915)
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 7eefbdec25a2..783f25920d00 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2421,6 +2421,8 @@ gen8_de_irq_handler(struct drm_i915_private *dev_priv, u32 master_ctl)
 	u32 iir;
 	enum pipe pipe;
 
+	drm_WARN_ON_ONCE(&dev_priv->drm, !HAS_DISPLAY(dev_priv));
+
 	if (master_ctl & GEN8_DE_MISC_IRQ) {
 		iir = intel_uncore_read(&dev_priv->uncore, GEN8_DE_MISC_IIR);
 		if (iir) {
@@ -3040,32 +3042,13 @@ static void valleyview_irq_reset(struct drm_i915_private *dev_priv)
 	spin_unlock_irq(&dev_priv->irq_lock);
 }
 
-static void cnp_display_clock_wa(struct drm_i915_private *dev_priv)
-{
-	struct intel_uncore *uncore = &dev_priv->uncore;
-
-	/*
-	 * Wa_14010685332:cnp/cmp,tgp,adp
-	 * TODO: Clarify which platforms this applies to
-	 * TODO: Figure out if this workaround can be applied in the s0ix suspend/resume handlers as
-	 * on earlier platforms and whether the workaround is also needed for runtime suspend/resume
-	 */
-	if (INTEL_PCH_TYPE(dev_priv) == PCH_CNP ||
-	    (INTEL_PCH_TYPE(dev_priv) >= PCH_TGP && INTEL_PCH_TYPE(dev_priv) < PCH_DG1)) {
-		intel_uncore_rmw(uncore, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS,
-				 SBCLK_RUN_REFCLK_DIS);
-		intel_uncore_rmw(uncore, SOUTH_CHICKEN1, SBCLK_RUN_REFCLK_DIS, 0);
-	}
-}
-
-static void gen8_irq_reset(struct drm_i915_private *dev_priv)
+static void gen8_display_irq_reset(struct drm_i915_private *dev_priv)
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
 	enum pipe pipe;
 
-	gen8_master_intr_disable(dev_priv->uncore.regs);
-
-	gen8_gt_irq_reset(&dev_priv->gt);
+	if (!HAS_DISPLAY(dev_priv))
+		return;
 
 	intel_uncore_write(uncore, EDP_PSR_IMR, 0xffffffff);
 	intel_uncore_write(uncore, EDP_PSR_IIR, 0xffffffff);
@@ -3077,12 +3060,21 @@ static void gen8_irq_reset(struct drm_i915_private *dev_priv)
 
 	GEN3_IRQ_RESET(uncore, GEN8_DE_PORT_);
 	GEN3_IRQ_RESET(uncore, GEN8_DE_MISC_);
+}
+
+static void gen8_irq_reset(struct drm_i915_private *dev_priv)
+{
+	struct intel_uncore *uncore = &dev_priv->uncore;
+
+	gen8_master_intr_disable(dev_priv->uncore.regs);
+
+	gen8_gt_irq_reset(&dev_priv->gt);
+	gen8_display_irq_reset(dev_priv);
 	GEN3_IRQ_RESET(uncore, GEN8_PCU_);
 
 	if (HAS_PCH_SPLIT(dev_priv))
 		ibx_irq_reset(dev_priv);
 
-	cnp_display_clock_wa(dev_priv);
 }
 
 static void gen11_display_irq_reset(struct drm_i915_private *dev_priv)
@@ -3092,6 +3084,9 @@ static void gen11_display_irq_reset(struct drm_i915_private *dev_priv)
 	u32 trans_mask = BIT(TRANSCODER_A) | BIT(TRANSCODER_B) |
 		BIT(TRANSCODER_C) | BIT(TRANSCODER_D);
 
+	if (!HAS_DISPLAY(dev_priv))
+		return;
+
 	intel_uncore_write(uncore, GEN11_DISPLAY_INT_CTL, 0);
 
 	if (DISPLAY_VER(dev_priv) >= 12) {
@@ -3123,8 +3118,6 @@ static void gen11_display_irq_reset(struct drm_i915_private *dev_priv)
 
 	if (INTEL_PCH_TYPE(dev_priv) >= PCH_ICP)
 		GEN3_IRQ_RESET(uncore, SDE);
-
-	cnp_display_clock_wa(dev_priv);
 }
 
 static void gen11_irq_reset(struct drm_i915_private *dev_priv)
@@ -3714,6 +3707,9 @@ static void gen8_de_irq_postinstall(struct drm_i915_private *dev_priv)
 		BIT(TRANSCODER_C) | BIT(TRANSCODER_D);
 	enum pipe pipe;
 
+	if (!HAS_DISPLAY(dev_priv))
+		return;
+
 	if (DISPLAY_VER(dev_priv) <= 10)
 		de_misc_masked |= GEN8_DE_MISC_GSE;
 
@@ -3797,6 +3793,16 @@ static void gen8_irq_postinstall(struct drm_i915_private *dev_priv)
 	gen8_master_intr_enable(dev_priv->uncore.regs);
 }
 
+static void gen11_de_irq_postinstall(struct drm_i915_private *dev_priv)
+{
+	if (!HAS_DISPLAY(dev_priv))
+		return;
+
+	gen8_de_irq_postinstall(dev_priv);
+
+	intel_uncore_write(&dev_priv->uncore, GEN11_DISPLAY_INT_CTL,
+			   GEN11_DISPLAY_IRQ_ENABLE);
+}
 
 static void gen11_irq_postinstall(struct drm_i915_private *dev_priv)
 {
@@ -3807,12 +3813,10 @@ static void gen11_irq_postinstall(struct drm_i915_private *dev_priv)
 		icp_irq_postinstall(dev_priv);
 
 	gen11_gt_irq_postinstall(&dev_priv->gt);
-	gen8_de_irq_postinstall(dev_priv);
+	gen11_de_irq_postinstall(dev_priv);
 
 	GEN3_IRQ_INIT(uncore, GEN11_GU_MISC_, ~gu_misc_masked, gu_misc_masked);
 
-	intel_uncore_write(&dev_priv->uncore, GEN11_DISPLAY_INT_CTL, GEN11_DISPLAY_IRQ_ENABLE);
-
 	if (HAS_MASTER_UNIT_IRQ(dev_priv)) {
 		dg1_master_intr_enable(uncore->regs);
 		intel_uncore_posting_read(&dev_priv->uncore, DG1_MSTR_UNIT_INTR);
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_color.c b/drivers/gpu/drm/mediatek/mtk_disp_color.c
index 63f411ab393b..bcb470caf009 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_color.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_color.c
@@ -134,6 +134,8 @@ static int mtk_disp_color_probe(struct platform_device *pdev)
 
 static int mtk_disp_color_remove(struct platform_device *pdev)
 {
+	component_del(&pdev->dev, &mtk_disp_color_component_ops);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 961f87f8d4d1..32a2922bbe5f 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -424,6 +424,8 @@ static int mtk_disp_ovl_probe(struct platform_device *pdev)
 
 static int mtk_disp_ovl_remove(struct platform_device *pdev)
 {
+	component_del(&pdev->dev, &mtk_disp_ovl_component_ops);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index 75bc00e17fc4..50d20562e612 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -34,6 +34,7 @@
 
 #define DISP_AAL_EN				0x0000
 #define DISP_AAL_SIZE				0x0030
+#define DISP_AAL_OUTPUT_SIZE			0x04d8
 
 #define DISP_DITHER_EN				0x0000
 #define DITHER_EN				BIT(0)
@@ -197,6 +198,7 @@ static void mtk_aal_config(struct device *dev, unsigned int w,
 	struct mtk_ddp_comp_dev *priv = dev_get_drvdata(dev);
 
 	mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
+	mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_OUTPUT_SIZE);
 }
 
 static void mtk_aal_gamma_set(struct device *dev, struct drm_crtc_state *state)
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 5d96fcc45fec..698707699327 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -768,6 +768,7 @@ static void iommu_dma_free_noncontiguous(struct device *dev, size_t size,
 	__iommu_dma_unmap(dev, sgt->sgl->dma_address, size);
 	__iommu_dma_free_pages(sh->pages, PAGE_ALIGN(size) >> PAGE_SHIFT);
 	sg_free_table(&sh->sgt);
+	kfree(sh);
 }
 #endif /* CONFIG_DMA_REMAP */
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 72dc84821dad..581c694b7cf4 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -511,7 +511,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 				 u32 pasid, bool fault_ignore)
 {
 	struct pasid_entry *pte;
-	u16 did;
+	u16 did, pgtt;
 
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (WARN_ON(!pte))
@@ -521,13 +521,19 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		return;
 
 	did = pasid_get_domain_id(pte);
+	pgtt = pasid_pte_get_pgtt(pte);
+
 	intel_pasid_clear_entry(dev, pasid, fault_ignore);
 
 	if (!ecap_coherent(iommu->ecap))
 		clflush_cache_range(pte, sizeof(*pte));
 
 	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
-	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+
+	if (pgtt == PASID_ENTRY_PGTT_PT || pgtt == PASID_ENTRY_PGTT_FL_ONLY)
+		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+	else
+		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
 	/* Device IOTLB doesn't need to be flushed in caching mode. */
 	if (!cap_caching_mode(iommu->cap))
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 5ff61c3d401f..c11bc8b833b8 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -99,6 +99,12 @@ static inline bool pasid_pte_is_present(struct pasid_entry *pte)
 	return READ_ONCE(pte->val[0]) & PASID_PTE_PRESENT;
 }
 
+/* Get PGTT field of a PASID table entry */
+static inline u16 pasid_pte_get_pgtt(struct pasid_entry *pte)
+{
+	return (u16)((READ_ONCE(pte->val[0]) >> 6) & 0x7);
+}
+
 extern unsigned int intel_pasid_max_id;
 int intel_pasid_alloc_table(struct device *dev);
 void intel_pasid_free_table(struct device *dev);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 808ab70d5df5..db966a7841fe 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -924,6 +924,9 @@ void iommu_group_remove_device(struct device *dev)
 	struct iommu_group *group = dev->iommu_group;
 	struct group_device *tmp_device, *device = NULL;
 
+	if (!group)
+		return;
+
 	dev_info(dev, "Removing from iommu group %d\n", group->id);
 
 	/* Pre-notify listeners that a device is being removed. */
diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index e1822e87ec3d..c1098f40e03f 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -91,16 +91,13 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
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
@@ -259,7 +256,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_disable_pci;
+		goto err_disable_device;
 	}
 
 	/* Request IO ID INT space (Bar 3) */
@@ -271,7 +268,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ip_space;
+		goto err_ip_interface_bar;
 	}
 
 	/* Request MEM8 space (Bar 5) */
@@ -282,7 +279,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 5!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
+		goto err_io_id_int_spaces_bar;
 	}
 
 	/* Request MEM16 space (Bar 4) */
@@ -293,7 +290,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_mem8_space;
+		goto err_mem8_space_bar;
 	}
 
 	/* Map internal tpci200 driver user space */
@@ -307,7 +304,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
 		res = -ENOMEM;
-		goto out_release_mem8_space;
+		goto err_mem16_space_bar;
 	}
 
 	/* Initialize lock that protects interface_regs */
@@ -346,18 +343,22 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) unable to register IRQ !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
+		goto err_interface_regs;
 	}
 
 	return 0;
 
-out_release_mem8_space:
+err_interface_regs:
+	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
+err_mem16_space_bar:
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
+err_mem8_space_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
-out_release_ioid_int_space:
+err_io_id_int_spaces_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
-out_release_ip_space:
+err_ip_interface_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
-out_disable_pci:
+err_disable_device:
 	pci_disable_device(tpci200->info->pdev);
 	return res;
 }
@@ -529,7 +530,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	tpci200->info = kzalloc(sizeof(struct tpci200_infos), GFP_KERNEL);
 	if (!tpci200->info) {
 		ret = -ENOMEM;
-		goto out_err_info;
+		goto err_tpci200;
 	}
 
 	pci_dev_get(pdev);
@@ -540,7 +541,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to allocate PCI Configuration Memory");
 		ret = -EBUSY;
-		goto out_err_pci_request;
+		goto err_tpci200_info;
 	}
 	tpci200->info->cfg_regs = ioremap(
 			pci_resource_start(pdev, TPCI200_CFG_MEM_BAR),
@@ -548,7 +549,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (!tpci200->info->cfg_regs) {
 		dev_err(&pdev->dev, "Failed to map PCI Configuration Memory");
 		ret = -EFAULT;
-		goto out_err_ioremap;
+		goto err_request_region;
 	}
 
 	/* Disable byte swapping for 16 bit IP module access. This will ensure
@@ -571,7 +572,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	if (ret) {
 		dev_err(&pdev->dev, "error during tpci200 install\n");
 		ret = -ENODEV;
-		goto out_err_install;
+		goto err_cfg_regs;
 	}
 
 	/* Register the carrier in the industry pack bus driver */
@@ -583,7 +584,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev,
 			"error registering the carrier on ipack driver\n");
 		ret = -EFAULT;
-		goto out_err_bus_register;
+		goto err_tpci200_install;
 	}
 
 	/* save the bus number given by ipack to logging purpose */
@@ -594,19 +595,16 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
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
@@ -616,6 +614,12 @@ static void __tpci200_pci_remove(struct tpci200_board *tpci200)
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
index d333130d1531..c3229d8c7041 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2018,8 +2018,8 @@ static void dw_mci_tasklet_func(struct tasklet_struct *t)
 					continue;
 				}
 
-				dw_mci_stop_dma(host);
 				send_stop_abort(host, data);
+				dw_mci_stop_dma(host);
 				state = STATE_SENDING_STOP;
 				break;
 			}
@@ -2043,10 +2043,10 @@ static void dw_mci_tasklet_func(struct tasklet_struct *t)
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
@@ -2079,10 +2079,10 @@ static void dw_mci_tasklet_func(struct tasklet_struct *t)
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
diff --git a/drivers/mmc/host/mmci_stm32_sdmmc.c b/drivers/mmc/host/mmci_stm32_sdmmc.c
index 51db30acf4dc..fdaa11f92fe6 100644
--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -479,8 +479,9 @@ static int sdmmc_post_sig_volt_switch(struct mmci_host *host,
 	u32 status;
 	int ret = 0;
 
-	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_180) {
-		spin_lock_irqsave(&host->lock, flags);
+	spin_lock_irqsave(&host->lock, flags);
+	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_180 &&
+	    host->pwr_reg & MCI_STM32_VSWITCHEN) {
 		mmci_write_pwrreg(host, host->pwr_reg | MCI_STM32_VSWITCH);
 		spin_unlock_irqrestore(&host->lock, flags);
 
@@ -492,9 +493,11 @@ static int sdmmc_post_sig_volt_switch(struct mmci_host *host,
 
 		writel_relaxed(MCI_STM32_VSWENDC | MCI_STM32_CKSTOPC,
 			       host->base + MMCICLEAR);
+		spin_lock_irqsave(&host->lock, flags);
 		mmci_write_pwrreg(host, host->pwr_reg &
 				  ~(MCI_STM32_VSWITCHEN | MCI_STM32_VSWITCH));
 	}
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	return ret;
 }
diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index ddeaf8e1f72f..9f0eef97ebdd 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -173,6 +173,23 @@ static unsigned int sdhci_iproc_get_max_clock(struct sdhci_host *host)
 		return pltfm_host->clock;
 }
 
+/*
+ * There is a known bug on BCM2711's SDHCI core integration where the
+ * controller will hang when the difference between the core clock and the bus
+ * clock is too great. Specifically this can be reproduced under the following
+ * conditions:
+ *
+ *  - No SD card plugged in, polling thread is running, probing cards at
+ *    100 kHz.
+ *  - BCM2711's core clock configured at 500MHz or more
+ *
+ * So we set 200kHz as the minimum clock frequency available for that SoC.
+ */
+static unsigned int sdhci_iproc_bcm2711_get_min_clock(struct sdhci_host *host)
+{
+	return 200000;
+}
+
 static const struct sdhci_ops sdhci_iproc_ops = {
 	.set_clock = sdhci_set_clock,
 	.get_max_clock = sdhci_iproc_get_max_clock,
@@ -271,13 +288,15 @@ static const struct sdhci_ops sdhci_iproc_bcm2711_ops = {
 	.set_clock = sdhci_set_clock,
 	.set_power = sdhci_set_power_and_bus_voltage,
 	.get_max_clock = sdhci_iproc_get_max_clock,
+	.get_min_clock = sdhci_iproc_bcm2711_get_min_clock,
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
 };
 
 static const struct sdhci_pltfm_data sdhci_bcm2711_pltfm_data = {
-	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
+		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.ops = &sdhci_iproc_bcm2711_ops,
 };
 
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index e44b7a66b73c..290a14cdc1cf 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -2089,6 +2089,23 @@ static void sdhci_msm_cqe_disable(struct mmc_host *mmc, bool recovery)
 	sdhci_cqe_disable(mmc, recovery);
 }
 
+static void sdhci_msm_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
+{
+	u32 count, start = 15;
+
+	__sdhci_set_timeout(host, cmd);
+	count = sdhci_readb(host, SDHCI_TIMEOUT_CONTROL);
+	/*
+	 * Update software timeout value if its value is less than hardware data
+	 * timeout value. Qcom SoC hardware data timeout value was calculated
+	 * using 4 * MCLK * 2^(count + 13). where MCLK = 1 / host->clock.
+	 */
+	if (cmd && cmd->data && host->clock > 400000 &&
+	    host->clock <= 50000000 &&
+	    ((1 << (count + start)) > (10 * host->clock)))
+		host->data_timeout = 22LL * NSEC_PER_SEC;
+}
+
 static const struct cqhci_host_ops sdhci_msm_cqhci_ops = {
 	.enable		= sdhci_msm_cqe_enable,
 	.disable	= sdhci_msm_cqe_disable,
@@ -2438,6 +2455,7 @@ static const struct sdhci_ops sdhci_msm_ops = {
 	.irq	= sdhci_msm_cqe_irq,
 	.dump_vendor_regs = sdhci_msm_dump_vendor_regs,
 	.set_power = sdhci_set_power_noreg,
+	.set_timeout = sdhci_msm_set_timeout,
 };
 
 static const struct sdhci_pltfm_data sdhci_msm_pdata = {
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 3097e93787f7..a761134fd3be 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -119,7 +119,7 @@ static int cfi_use_status_reg(struct cfi_private *cfi)
 	struct cfi_pri_amdstd *extp = cfi->cmdset_priv;
 	u8 poll_mask = CFI_POLL_STATUS_REG | CFI_POLL_DQ;
 
-	return extp->MinorVersion >= '5' &&
+	return extp && extp->MinorVersion >= '5' &&
 		(extp->SoftwareFeatures & poll_mask) == CFI_POLL_STATUS_REG;
 }
 
diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index fb072c444495..4412fdc240a2 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -5056,12 +5056,18 @@ static bool of_get_nand_on_flash_bbt(struct device_node *np)
 static int of_get_nand_secure_regions(struct nand_chip *chip)
 {
 	struct device_node *dn = nand_get_flash_node(chip);
+	struct property *prop;
 	int nr_elem, i, j;
 
-	nr_elem = of_property_count_elems_of_size(dn, "secure-regions", sizeof(u64));
-	if (!nr_elem)
+	/* Only proceed if the "secure-regions" property is present in DT */
+	prop = of_find_property(dn, "secure-regions", NULL);
+	if (!prop)
 		return 0;
 
+	nr_elem = of_property_count_elems_of_size(dn, "secure-regions", sizeof(u64));
+	if (nr_elem <= 0)
+		return nr_elem;
+
 	chip->nr_secure_regions = nr_elem / 2;
 	chip->secure_regions = kcalloc(chip->nr_secure_regions, sizeof(*chip->secure_regions),
 				       GFP_KERNEL);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3c3aa9467310..b365768a2bda 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -69,7 +69,8 @@
 #include "bnxt_debugfs.h"
 
 #define BNXT_TX_TIMEOUT		(5 * HZ)
-#define BNXT_DEF_MSG_ENABLE	(NETIF_MSG_DRV | NETIF_MSG_HW)
+#define BNXT_DEF_MSG_ENABLE	(NETIF_MSG_DRV | NETIF_MSG_HW | \
+				 NETIF_MSG_TX_ERR)
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
@@ -362,6 +363,33 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
 	return md_dst->u.port_info.port_id;
 }
 
+static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			     u16 prod)
+{
+	bnxt_db_write(bp, &txr->tx_db, prod);
+	txr->kick_pending = 0;
+}
+
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
@@ -381,6 +409,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
 		dev_kfree_skb_any(skb);
+		atomic_long_inc(&dev->tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -390,8 +419,12 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
-		netif_tx_stop_queue(txq);
-		return NETDEV_TX_BUSY;
+		/* We must have raced with NAPI cleanup */
+		if (net_ratelimit() && txr->kick_pending)
+			netif_warn(bp, tx_err, dev,
+				   "bnxt: ring busy w/ flush pending!\n");
+		if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
+			return NETDEV_TX_BUSY;
 	}
 
 	length = skb->len;
@@ -498,21 +531,16 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 normal_tx:
 	if (length < BNXT_MIN_PKT_SIZE) {
 		pad = BNXT_MIN_PKT_SIZE - length;
-		if (skb_pad(skb, pad)) {
+		if (skb_pad(skb, pad))
 			/* SKB already freed. */
-			tx_buf->skb = NULL;
-			return NETDEV_TX_OK;
-		}
+			goto tx_kick_pending;
 		length = BNXT_MIN_PKT_SIZE;
 	}
 
 	mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
 
-	if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
-		dev_kfree_skb_any(skb);
-		tx_buf->skb = NULL;
-		return NETDEV_TX_OK;
-	}
+	if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
+		goto tx_free;
 
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
 	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
@@ -597,24 +625,17 @@ normal_tx:
 	txr->tx_prod = prod;
 
 	if (!netdev_xmit_more() || netif_xmit_stopped(txq))
-		bnxt_db_write(bp, &txr->tx_db, prod);
+		bnxt_txr_db_kick(bp, txr, prod);
+	else
+		txr->kick_pending = 1;
 
 tx_done:
 
 	if (unlikely(bnxt_tx_avail(bp, txr) <= MAX_SKB_FRAGS + 1)) {
 		if (netdev_xmit_more() && !tx_buf->is_push)
-			bnxt_db_write(bp, &txr->tx_db, prod);
-
-		netif_tx_stop_queue(txq);
+			bnxt_txr_db_kick(bp, txr, prod);
 
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
 
@@ -624,7 +645,6 @@ tx_dma_error:
 	/* start back at beginning and unmap skb */
 	prod = txr->tx_prod;
 	tx_buf = &txr->tx_buf_ring[prod];
-	tx_buf->skb = NULL;
 	dma_unmap_single(&pdev->dev, dma_unmap_addr(tx_buf, mapping),
 			 skb_headlen(skb), PCI_DMA_TODEVICE);
 	prod = NEXT_TX(prod);
@@ -638,7 +658,13 @@ tx_dma_error:
 			       PCI_DMA_TODEVICE);
 	}
 
+tx_free:
 	dev_kfree_skb_any(skb);
+tx_kick_pending:
+	if (txr->kick_pending)
+		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
+	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
+	atomic_long_inc(&dev->tx_dropped);
 	return NETDEV_TX_OK;
 }
 
@@ -698,14 +724,9 @@ next_tx_int:
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
@@ -1733,6 +1754,10 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	if (!RX_CMP_VALID(rxcmp1, tmp_raw_cons))
 		return -EBUSY;
 
+	/* The valid test of the entry must be done first before
+	 * reading any further.
+	 */
+	dma_rmb();
 	prod = rxr->rx_prod;
 
 	if (cmp_type == CMP_TYPE_RX_L2_TPA_START_CMP) {
@@ -1936,6 +1961,10 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	if (!RX_CMP_VALID(rxcmp1, tmp_raw_cons))
 		return -EBUSY;
 
+	/* The valid test of the entry must be done first before
+	 * reading any further.
+	 */
+	dma_rmb();
 	cmp_type = RX_CMP_TYPE(rxcmp);
 	if (cmp_type == CMP_TYPE_RX_L2_CMP) {
 		rxcmp1->rx_cmp_cfa_code_errors_v2 |=
@@ -2400,6 +2429,10 @@ static int bnxt_poll_nitroa0(struct napi_struct *napi, int budget)
 		if (!TX_CMP_VALID(txcmp, raw_cons))
 			break;
 
+		/* The valid test of the entry must be done first before
+		 * reading any further.
+		 */
+		dma_rmb();
 		if ((TX_CMP_TYPE(txcmp) & 0x30) == 0x10) {
 			tmp_raw_cons = NEXT_RAW_CMP(raw_cons);
 			cp_cons = RING_CMP(tmp_raw_cons);
@@ -9018,10 +9051,9 @@ static void bnxt_disable_napi(struct bnxt *bp)
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_cp_ring_info *cpr = &bp->bnapi[i]->cp_ring;
 
+		napi_disable(&bp->bnapi[i]->napi);
 		if (bp->bnapi[i]->rx_ring)
 			cancel_work_sync(&cpr->dim.work);
-
-		napi_disable(&bp->bnapi[i]->napi);
 	}
 }
 
@@ -9055,9 +9087,11 @@ void bnxt_tx_disable(struct bnxt *bp)
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
@@ -9071,8 +9105,10 @@ void bnxt_tx_enable(struct bnxt *bp)
 
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
@@ -10644,6 +10680,9 @@ static bool bnxt_rfs_supported(struct bnxt *bp)
 			return true;
 		return false;
 	}
+	/* 212 firmware is broken for aRFS */
+	if (BNXT_FW_MAJ(bp) == 212)
+		return false;
 	if (BNXT_PF(bp) && !BNXT_CHIP_TYPE_NITRO_A0(bp))
 		return true;
 	if (bp->flags & BNXT_FLAG_NEW_RSS_CAP)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 30e47ea343f9..e2f38aaa474b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -783,6 +783,7 @@ struct bnxt_tx_ring_info {
 	u16			tx_prod;
 	u16			tx_cons;
 	u16			txq_index;
+	u8			kick_pending;
 	struct bnxt_db_info	tx_db;
 
 	struct tx_bd		*tx_desc_ring[MAX_TX_PAGES];
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 87321b7239cf..58964d22cb17 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3038,26 +3038,30 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	return err;
 }
 
-static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
+static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
+{
+	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
+	dpaa2_switch_free_dpio(ethsw);
+	dpaa2_switch_destroy_rings(ethsw);
+	dpaa2_switch_drain_bp(ethsw);
+	dpaa2_switch_free_dpbp(ethsw);
+}
+
+static void dpaa2_switch_teardown(struct fsl_mc_device *sw_dev)
 {
 	struct device *dev = &sw_dev->dev;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
 	int err;
 
+	dpaa2_switch_ctrl_if_teardown(ethsw);
+
+	destroy_workqueue(ethsw->workqueue);
+
 	err = dpsw_close(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err)
 		dev_warn(dev, "dpsw_close err %d\n", err);
 }
 
-static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
-{
-	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-	dpaa2_switch_free_dpio(ethsw);
-	dpaa2_switch_destroy_rings(ethsw);
-	dpaa2_switch_drain_bp(ethsw);
-	dpaa2_switch_free_dpbp(ethsw);
-}
-
 static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
 	struct ethsw_port_priv *port_priv;
@@ -3068,8 +3072,6 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	dev = &sw_dev->dev;
 	ethsw = dev_get_drvdata(dev);
 
-	dpaa2_switch_ctrl_if_teardown(ethsw);
-
 	dpaa2_switch_teardown_irqs(sw_dev);
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
@@ -3084,9 +3086,7 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	kfree(ethsw->acls);
 	kfree(ethsw->ports);
 
-	dpaa2_switch_takedown(sw_dev);
-
-	destroy_workqueue(ethsw->workqueue);
+	dpaa2_switch_teardown(sw_dev);
 
 	fsl_mc_portal_free(ethsw->mc_io);
 
@@ -3199,7 +3199,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			       GFP_KERNEL);
 	if (!(ethsw->ports)) {
 		err = -ENOMEM;
-		goto err_takedown;
+		goto err_teardown;
 	}
 
 	ethsw->fdbs = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->fdbs),
@@ -3270,8 +3270,8 @@ err_free_fdbs:
 err_free_ports:
 	kfree(ethsw->ports);
 
-err_takedown:
-	dpaa2_switch_takedown(sw_dev);
+err_teardown:
+	dpaa2_switch_teardown(sw_dev);
 
 err_free_cmdport:
 	fsl_mc_portal_free(ethsw->mc_io);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 107fb472319e..b18ff0ed8527 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3665,8 +3665,7 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 
 	/* is DCB enabled at all? */
 	if (vsi->tc_config.numtc == 1)
-		return i40e_swdcb_skb_tx_hash(netdev, skb,
-					      netdev->real_num_tx_queues);
+		return netdev_pick_tx(netdev, skb, sb_dev);
 
 	prio = skb->priority;
 	hw = &vsi->back->hw;
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index e8bd04100ecd..90793b36126e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -136,6 +136,7 @@ struct iavf_q_vector {
 struct iavf_mac_filter {
 	struct list_head list;
 	u8 macaddr[ETH_ALEN];
+	bool is_new_mac;	/* filter is new, wait for PF decision */
 	bool remove;		/* filter needs to be removed */
 	bool add;		/* filter needs to be added */
 };
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 244ec74ceca7..606a01ce4073 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -751,6 +751,7 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
+		f->is_new_mac = true;
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
 	} else {
 		f->remove = false;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 0eab3c43bdc5..3c735968e1b8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -540,6 +540,47 @@ void iavf_del_ether_addrs(struct iavf_adapter *adapter)
 	kfree(veal);
 }
 
+/**
+ * iavf_mac_add_ok
+ * @adapter: adapter structure
+ *
+ * Submit list of filters based on PF response.
+ **/
+static void iavf_mac_add_ok(struct iavf_adapter *adapter)
+{
+	struct iavf_mac_filter *f, *ftmp;
+
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
+	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
+		f->is_new_mac = false;
+	}
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+}
+
+/**
+ * iavf_mac_add_reject
+ * @adapter: adapter structure
+ *
+ * Remove filters from list based on PF response.
+ **/
+static void iavf_mac_add_reject(struct iavf_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct iavf_mac_filter *f, *ftmp;
+
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
+	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
+		if (f->remove && ether_addr_equal(f->macaddr, netdev->dev_addr))
+			f->remove = false;
+
+		if (f->is_new_mac) {
+			list_del(&f->list);
+			kfree(f);
+		}
+	}
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+}
+
 /**
  * iavf_add_vlans
  * @adapter: adapter structure
@@ -1492,6 +1533,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		case VIRTCHNL_OP_ADD_ETH_ADDR:
 			dev_err(&adapter->pdev->dev, "Failed to add MAC filter, error %s\n",
 				iavf_stat_str(&adapter->hw, v_retval));
+			iavf_mac_add_reject(adapter);
 			/* restore administratively set MAC address */
 			ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
 			break;
@@ -1639,10 +1681,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		}
 	}
 	switch (v_opcode) {
-	case VIRTCHNL_OP_ADD_ETH_ADDR: {
+	case VIRTCHNL_OP_ADD_ETH_ADDR:
+		if (!v_retval)
+			iavf_mac_add_ok(adapter);
 		if (!ether_addr_equal(netdev->dev_addr, adapter->hw.mac.addr))
 			ether_addr_copy(netdev->dev_addr, adapter->hw.mac.addr);
-		}
 		break;
 	case VIRTCHNL_OP_GET_STATS: {
 		struct iavf_eth_stats *stats =
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index f72d2978263b..d60da7a89092 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -52,8 +52,11 @@ static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
 
 		/* Kick start the NAPI context so that receiving will start */
 		err = ixgbe_xsk_wakeup(adapter->netdev, qid, XDP_WAKEUP_RX);
-		if (err)
+		if (err) {
+			clear_bit(qid, adapter->af_xdp_zc_qps);
+			xsk_pool_dma_unmap(pool, IXGBE_RX_DMA_ATTR);
 			return err;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index adfb9781799e..2948d731a1c1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1334,6 +1334,7 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot_get_bridge_fwd_mask(ocelot, bridge);
+			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
 			if (bond) {
 				mask &= ~ocelot_get_bond_mask(ocelot, bond,
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 2e62a2c4eb63..5630008f38b7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -501,6 +501,7 @@ struct qede_fastpath {
 #define QEDE_SP_HW_ERR                  4
 #define QEDE_SP_ARFS_CONFIG             5
 #define QEDE_SP_AER			7
+#define QEDE_SP_DISABLE			8
 
 #ifdef CONFIG_RFS_ACCEL
 int qede_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 01ac1e93d27a..7c6064baeba2 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1009,6 +1009,13 @@ static void qede_sp_task(struct work_struct *work)
 	struct qede_dev *edev = container_of(work, struct qede_dev,
 					     sp_task.work);
 
+	/* Disable execution of this deferred work once
+	 * qede removal is in progress, this stop any future
+	 * scheduling of sp_task.
+	 */
+	if (test_bit(QEDE_SP_DISABLE, &edev->sp_flags))
+		return;
+
 	/* The locking scheme depends on the specific flag:
 	 * In case of QEDE_SP_RECOVERY, acquiring the RTNL lock is required to
 	 * ensure that ongoing flows are ended and new ones are not started.
@@ -1300,6 +1307,7 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 	qede_rdma_dev_remove(edev, (mode == QEDE_REMOVE_RECOVERY));
 
 	if (mode != QEDE_REMOVE_RECOVERY) {
+		set_bit(QEDE_SP_DISABLE, &edev->sp_flags);
 		unregister_netdev(ndev);
 
 		cancel_delayed_work_sync(&edev->sp_task);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index d8882d0b6b49..d51bac7ba5af 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3156,8 +3156,10 @@ int qlcnic_83xx_flash_read32(struct qlcnic_adapter *adapter, u32 flash_addr,
 
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
index 80f41945709f..da6a2a4b6cc7 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -833,6 +833,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
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
diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index 110e4ee85785..3dde0c2b3e09 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -82,6 +82,17 @@ out:
 
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
@@ -144,7 +155,7 @@ int mdio_mux_init(struct device *dev,
 		cb = devm_kzalloc(dev, sizeof(*cb), GFP_KERNEL);
 		if (!cb) {
 			ret_val = -ENOMEM;
-			continue;
+			goto err_loop;
 		}
 		cb->bus_number = v;
 		cb->parent = pb;
@@ -152,8 +163,7 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus = mdiobus_alloc();
 		if (!cb->mii_bus) {
 			ret_val = -ENOMEM;
-			devm_kfree(dev, cb);
-			continue;
+			goto err_loop;
 		}
 		cb->mii_bus->priv = cb;
 
@@ -165,11 +175,15 @@ int mdio_mux_init(struct device *dev,
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
@@ -182,6 +196,10 @@ int mdio_mux_init(struct device *dev,
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
 	devm_kfree(dev, pb);
+
+err_loop:
+	mdio_mux_uninit_children(pb);
+	of_node_put(child_bus_node);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
@@ -193,14 +211,8 @@ EXPORT_SYMBOL_GPL(mdio_mux_init);
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
diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 3b53685301de..edb94efd265e 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -205,8 +205,7 @@ struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 int asix_set_sw_mii(struct usbnet *dev, int in_pm);
 int asix_set_hw_mii(struct usbnet *dev, int in_pm);
 
-int asix_read_phy_addr(struct usbnet *dev, int internal);
-int asix_get_phy_addr(struct usbnet *dev);
+int asix_read_phy_addr(struct usbnet *dev, bool internal);
 
 int asix_sw_reset(struct usbnet *dev, u8 flags, int in_pm);
 
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 7bc6e8f856fe..e1109f1a8dd5 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -288,32 +288,33 @@ int asix_set_hw_mii(struct usbnet *dev, int in_pm)
 	return ret;
 }
 
-int asix_read_phy_addr(struct usbnet *dev, int internal)
+int asix_read_phy_addr(struct usbnet *dev, bool internal)
 {
-	int offset = (internal ? 1 : 0);
+	int ret, offset;
 	u8 buf[2];
-	int ret = asix_read_cmd(dev, AX_CMD_READ_PHY_ID, 0, 0, 2, buf, 0);
 
-	netdev_dbg(dev->net, "asix_get_phy_addr()\n");
+	ret = asix_read_cmd(dev, AX_CMD_READ_PHY_ID, 0, 0, 2, buf, 0);
+	if (ret < 0)
+		goto error;
 
 	if (ret < 2) {
-		netdev_err(dev->net, "Error reading PHYID register: %02x\n", ret);
-		goto out;
+		ret = -EIO;
+		goto error;
 	}
-	netdev_dbg(dev->net, "asix_get_phy_addr() returning 0x%04x\n",
-		   *((__le16 *)buf));
+
+	offset = (internal ? 1 : 0);
 	ret = buf[offset];
 
-out:
+	netdev_dbg(dev->net, "%s PHY address 0x%x\n",
+		   internal ? "internal" : "external", ret);
+
 	return ret;
-}
 
-int asix_get_phy_addr(struct usbnet *dev)
-{
-	/* return the address of the internal phy */
-	return asix_read_phy_addr(dev, 1);
-}
+error:
+	netdev_err(dev->net, "Error reading PHY_ID register: %02x\n", ret);
 
+	return ret;
+}
 
 int asix_sw_reset(struct usbnet *dev, u8 flags, int in_pm)
 {
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 19a8fafb8f04..fb523734bf31 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -262,7 +262,10 @@ static int ax88172_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.mdio_write = asix_mdio_write;
 	dev->mii.phy_id_mask = 0x3f;
 	dev->mii.reg_num_mask = 0x1f;
-	dev->mii.phy_id = asix_get_phy_addr(dev);
+
+	dev->mii.phy_id = asix_read_phy_addr(dev, true);
+	if (dev->mii.phy_id < 0)
+		return dev->mii.phy_id;
 
 	dev->net->netdev_ops = &ax88172_netdev_ops;
 	dev->net->ethtool_ops = &ax88172_ethtool_ops;
@@ -717,7 +720,10 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.mdio_write = asix_mdio_write;
 	dev->mii.phy_id_mask = 0x1f;
 	dev->mii.reg_num_mask = 0x1f;
-	dev->mii.phy_id = asix_get_phy_addr(dev);
+
+	dev->mii.phy_id = asix_read_phy_addr(dev, true);
+	if (dev->mii.phy_id < 0)
+		return dev->mii.phy_id;
 
 	dev->net->netdev_ops = &ax88772_netdev_ops;
 	dev->net->ethtool_ops = &ax88772_ethtool_ops;
@@ -1081,7 +1087,10 @@ static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id_mask = 0x1f;
 	dev->mii.reg_num_mask = 0xff;
 	dev->mii.supports_gmii = 1;
-	dev->mii.phy_id = asix_get_phy_addr(dev);
+
+	dev->mii.phy_id = asix_read_phy_addr(dev, true);
+	if (dev->mii.phy_id < 0)
+		return dev->mii.phy_id;
 
 	dev->net->netdev_ops = &ax88178_netdev_ops;
 	dev->net->ethtool_ops = &ax88178_ethtool_ops;
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index b404c9462dce..c8ca5187eece 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -220,6 +220,11 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
+	if (priv->phy_addr < 0) {
+		ret = priv->phy_addr;
+		goto free;
+	}
+
 	ax88172a_reset_phy(dev, priv->use_embdphy);
 
 	/* Asix framing packs multiple eth frames into a 2K usb bulk transfer */
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 02bce40a67e5..c46a66ea32eb 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1154,7 +1154,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
 	struct ethtool_link_ksettings ecmd;
-	int ladv, radv, ret;
+	int ladv, radv, ret, link;
 	u32 buf;
 
 	/* clear LAN78xx interrupt status */
@@ -1162,9 +1162,12 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
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
@@ -1177,7 +1180,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 			return -EIO;
 
 		del_timer(&dev->stat_monitor);
-	} else if (phydev->link && !dev->link_on) {
+	} else if (link && !dev->link_on) {
 		dev->link_on = true;
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
@@ -1466,9 +1469,14 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
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
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index bc2dbf86496b..a08a46fef0d2 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -132,9 +132,15 @@ static int get_registers(pegasus_t *pegasus, __u16 indx, __u16 size, void *data)
 static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
 			 const void *data)
 {
-	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
+	int ret;
+
+	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
 				    PEGASUS_REQT_WRITE, 0, indx, data, size,
 				    1000, GFP_NOIO);
+	if (ret < 0)
+		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
+
+	return ret;
 }
 
 /*
@@ -145,10 +151,15 @@ static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
 static int set_register(pegasus_t *pegasus, __u16 indx, __u8 data)
 {
 	void *buf = &data;
+	int ret;
 
-	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
+	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
 				    PEGASUS_REQT_WRITE, data, indx, buf, 1,
 				    1000, GFP_NOIO);
+	if (ret < 0)
+		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
+
+	return ret;
 }
 
 static int update_eth_regs_async(pegasus_t *pegasus)
@@ -188,10 +199,9 @@ static int update_eth_regs_async(pegasus_t *pegasus)
 
 static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
 {
-	int i;
-	__u8 data[4] = { phy, 0, 0, indx };
+	int i, ret;
 	__le16 regdi;
-	int ret = -ETIMEDOUT;
+	__u8 data[4] = { phy, 0, 0, indx };
 
 	if (cmd & PHY_WRITE) {
 		__le16 *t = (__le16 *) & data[1];
@@ -207,12 +217,15 @@ static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
 		if (data[0] & PHY_DONE)
 			break;
 	}
-	if (i >= REG_TIMEOUT)
+	if (i >= REG_TIMEOUT) {
+		ret = -ETIMEDOUT;
 		goto fail;
+	}
 	if (cmd & PHY_READ) {
 		ret = get_registers(p, PhyData, 2, &regdi);
+		if (ret < 0)
+			goto fail;
 		*regd = le16_to_cpu(regdi);
-		return ret;
 	}
 	return 0;
 fail:
@@ -235,9 +248,13 @@ static int write_mii_word(pegasus_t *pegasus, __u8 phy, __u8 indx, __u16 *regd)
 static int mdio_read(struct net_device *dev, int phy_id, int loc)
 {
 	pegasus_t *pegasus = netdev_priv(dev);
+	int ret;
 	u16 res;
 
-	read_mii_word(pegasus, phy_id, loc, &res);
+	ret = read_mii_word(pegasus, phy_id, loc, &res);
+	if (ret < 0)
+		return ret;
+
 	return (int)res;
 }
 
@@ -251,10 +268,9 @@ static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
 
 static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
 {
-	int i;
-	__u8 tmp = 0;
+	int ret, i;
 	__le16 retdatai;
-	int ret;
+	__u8 tmp = 0;
 
 	set_register(pegasus, EpromCtrl, 0);
 	set_register(pegasus, EpromOffset, index);
@@ -262,21 +278,25 @@ static int read_eprom_word(pegasus_t *pegasus, __u8 index, __u16 *retdata)
 
 	for (i = 0; i < REG_TIMEOUT; i++) {
 		ret = get_registers(pegasus, EpromCtrl, 1, &tmp);
+		if (ret < 0)
+			goto fail;
 		if (tmp & EPROM_DONE)
 			break;
-		if (ret == -ESHUTDOWN)
-			goto fail;
 	}
-	if (i >= REG_TIMEOUT)
+	if (i >= REG_TIMEOUT) {
+		ret = -ETIMEDOUT;
 		goto fail;
+	}
 
 	ret = get_registers(pegasus, EpromData, 2, &retdatai);
+	if (ret < 0)
+		goto fail;
 	*retdata = le16_to_cpu(retdatai);
 	return ret;
 
 fail:
-	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
-	return -ETIMEDOUT;
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
+	return ret;
 }
 
 #ifdef	PEGASUS_WRITE_EEPROM
@@ -324,10 +344,10 @@ static int write_eprom_word(pegasus_t *pegasus, __u8 index, __u16 data)
 	return ret;
 
 fail:
-	netif_warn(pegasus, drv, pegasus->net, "%s failed\n", __func__);
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return -ETIMEDOUT;
 }
-#endif				/* PEGASUS_WRITE_EEPROM */
+#endif	/* PEGASUS_WRITE_EEPROM */
 
 static inline int get_node_id(pegasus_t *pegasus, u8 *id)
 {
@@ -367,19 +387,21 @@ static void set_ethernet_addr(pegasus_t *pegasus)
 	return;
 err:
 	eth_hw_addr_random(pegasus->net);
-	dev_info(&pegasus->intf->dev, "software assigned MAC address.\n");
+	netif_dbg(pegasus, drv, pegasus->net, "software assigned MAC address.\n");
 
 	return;
 }
 
 static inline int reset_mac(pegasus_t *pegasus)
 {
+	int ret, i;
 	__u8 data = 0x8;
-	int i;
 
 	set_register(pegasus, EthCtrl1, data);
 	for (i = 0; i < REG_TIMEOUT; i++) {
-		get_registers(pegasus, EthCtrl1, 1, &data);
+		ret = get_registers(pegasus, EthCtrl1, 1, &data);
+		if (ret < 0)
+			goto fail;
 		if (~data & 0x08) {
 			if (loopback)
 				break;
@@ -402,22 +424,29 @@ static inline int reset_mac(pegasus_t *pegasus)
 	}
 	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_ELCON) {
 		__u16 auxmode;
-		read_mii_word(pegasus, 3, 0x1b, &auxmode);
+		ret = read_mii_word(pegasus, 3, 0x1b, &auxmode);
+		if (ret < 0)
+			goto fail;
 		auxmode |= 4;
 		write_mii_word(pegasus, 3, 0x1b, &auxmode);
 	}
 
 	return 0;
+fail:
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
+	return ret;
 }
 
 static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 {
-	__u16 linkpart;
-	__u8 data[4];
 	pegasus_t *pegasus = netdev_priv(dev);
 	int ret;
+	__u16 linkpart;
+	__u8 data[4];
 
-	read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
+	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
+	if (ret < 0)
+		goto fail;
 	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
 	data[1] = 0;
 	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
@@ -435,11 +464,16 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
 	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
 		u16 auxmode;
-		read_mii_word(pegasus, 0, 0x1b, &auxmode);
+		ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
+		if (ret < 0)
+			goto fail;
 		auxmode |= 4;
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
+	return 0;
+fail:
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
 }
 
@@ -447,9 +481,9 @@ static void read_bulk_callback(struct urb *urb)
 {
 	pegasus_t *pegasus = urb->context;
 	struct net_device *net;
+	u8 *buf = urb->transfer_buffer;
 	int rx_status, count = urb->actual_length;
 	int status = urb->status;
-	u8 *buf = urb->transfer_buffer;
 	__u16 pkt_len;
 
 	if (!pegasus)
@@ -1004,8 +1038,7 @@ static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
 		data[0] = pegasus->phy;
 		fallthrough;
 	case SIOCDEVPRIVATE + 1:
-		read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
-		res = 0;
+		res = read_mii_word(pegasus, data[0], data[1] & 0x1f, &data[3]);
 		break;
 	case SIOCDEVPRIVATE + 2:
 		if (!capable(CAP_NET_ADMIN))
@@ -1039,22 +1072,25 @@ static void pegasus_set_multicast(struct net_device *net)
 
 static __u8 mii_phy_probe(pegasus_t *pegasus)
 {
-	int i;
+	int i, ret;
 	__u16 tmp;
 
 	for (i = 0; i < 32; i++) {
-		read_mii_word(pegasus, i, MII_BMSR, &tmp);
+		ret = read_mii_word(pegasus, i, MII_BMSR, &tmp);
+		if (ret < 0)
+			goto fail;
 		if (tmp == 0 || tmp == 0xffff || (tmp & BMSR_MEDIA) == 0)
 			continue;
 		else
 			return i;
 	}
-
+fail:
 	return 0xff;
 }
 
 static inline void setup_pegasus_II(pegasus_t *pegasus)
 {
+	int ret;
 	__u8 data = 0xa5;
 
 	set_register(pegasus, Reg1d, 0);
@@ -1066,7 +1102,9 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg7b, 2);
 
 	set_register(pegasus, 0x83, data);
-	get_registers(pegasus, 0x83, 1, &data);
+	ret = get_registers(pegasus, 0x83, 1, &data);
+	if (ret < 0)
+		goto fail;
 
 	if (data == 0xa5)
 		pegasus->chip = 0x8513;
@@ -1081,6 +1119,10 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg81, 6);
 	else
 		set_register(pegasus, Reg81, 2);
+
+	return;
+fail:
+	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 }
 
 static void check_carrier(struct work_struct *work)
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2cf763b4ea84..a044f37e87ae 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3953,17 +3953,28 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	case RTL_VER_06:
 		ocp_write_byte(tp, type, PLA_BP_EN, 0);
 		break;
+	case RTL_VER_14:
+		ocp_write_word(tp, type, USB_BP2_EN, 0);
+
+		ocp_write_word(tp, type, USB_BP_8, 0);
+		ocp_write_word(tp, type, USB_BP_9, 0);
+		ocp_write_word(tp, type, USB_BP_10, 0);
+		ocp_write_word(tp, type, USB_BP_11, 0);
+		ocp_write_word(tp, type, USB_BP_12, 0);
+		ocp_write_word(tp, type, USB_BP_13, 0);
+		ocp_write_word(tp, type, USB_BP_14, 0);
+		ocp_write_word(tp, type, USB_BP_15, 0);
+		break;
 	case RTL_VER_08:
 	case RTL_VER_09:
 	case RTL_VER_10:
 	case RTL_VER_11:
 	case RTL_VER_12:
 	case RTL_VER_13:
-	case RTL_VER_14:
 	case RTL_VER_15:
 	default:
 		if (type == MCU_TYPE_USB) {
-			ocp_write_byte(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
 
 			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0);
 			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0);
@@ -4329,7 +4340,6 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 		case RTL_VER_11:
 		case RTL_VER_12:
 		case RTL_VER_13:
-		case RTL_VER_14:
 		case RTL_VER_15:
 			fw_reg = 0xf800;
 			bp_ba_addr = PLA_BP_BA;
@@ -4337,6 +4347,13 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 			bp_start = PLA_BP_0;
 			max_bp = 8;
 			break;
+		case RTL_VER_14:
+			fw_reg = 0xf800;
+			bp_ba_addr = PLA_BP_BA;
+			bp_en_addr = USB_BP2_EN;
+			bp_start = PLA_BP_0;
+			max_bp = 16;
+			break;
 		default:
 			goto out;
 		}
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6af227964413..d397dc6b0ebf 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -63,7 +63,7 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_CSUM
 };
 
-#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
+#define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
 				(1ULL << VIRTIO_NET_F_GUEST_UFO))
@@ -2490,7 +2490,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
-		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
+		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
 		return -EOPNOTSUPP;
 	}
 
@@ -2621,15 +2621,15 @@ static int virtnet_set_features(struct net_device *dev,
 	u64 offloads;
 	int err;
 
-	if ((dev->features ^ features) & NETIF_F_LRO) {
+	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
-		if (features & NETIF_F_LRO)
+		if (features & NETIF_F_GRO_HW)
 			offloads = vi->guest_offloads_capable;
 		else
 			offloads = vi->guest_offloads_capable &
-				   ~GUEST_OFFLOAD_LRO_MASK;
+				   ~GUEST_OFFLOAD_GRO_HW_MASK;
 
 		err = virtnet_set_guest_offloads(vi, offloads);
 		if (err)
@@ -3109,9 +3109,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 		dev->features |= NETIF_F_RXCSUM;
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		dev->features |= NETIF_F_LRO;
+		dev->features |= NETIF_F_GRO_HW;
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
-		dev->hw_features |= NETIF_F_LRO;
+		dev->hw_features |= NETIF_F_GRO_HW;
 
 	dev->vlan_features = dev->features;
 
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 414afcb0a23f..b1c451d10a5d 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1367,6 +1367,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
 
+	nf_reset_ct(skb);
+
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
 	 * For strict packets with a source LLA, determine the dst using the
@@ -1429,6 +1431,8 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
 
+	nf_reset_ct(skb);
+
 	if (ipv4_is_multicast(ip_hdr(skb)->daddr))
 		goto out;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 607980321d27..106177072d18 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -111,7 +111,7 @@ mt7915_mcu_get_cipher(int cipher)
 	case WLAN_CIPHER_SUITE_SMS4:
 		return MCU_CIPHER_WAPI;
 	default:
-		return MT_CIPHER_NONE;
+		return MCU_CIPHER_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index 517621044d9e..c0255c3ac7d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -1035,7 +1035,8 @@ enum {
 };
 
 enum mcu_cipher_type {
-	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_NONE = 0,
+	MCU_CIPHER_WEP40,
 	MCU_CIPHER_WEP104,
 	MCU_CIPHER_WEP128,
 	MCU_CIPHER_TKIP,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 47843b055959..fc0d7dc3a5f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -111,7 +111,7 @@ mt7921_mcu_get_cipher(int cipher)
 	case WLAN_CIPHER_SUITE_SMS4:
 		return MCU_CIPHER_WAPI;
 	default:
-		return MT_CIPHER_NONE;
+		return MCU_CIPHER_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
index 07abe86f07a9..adad20819341 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
@@ -198,7 +198,8 @@ struct sta_rec_sec {
 } __packed;
 
 enum mcu_cipher_type {
-	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_NONE = 0,
+	MCU_CIPHER_WEP40,
 	MCU_CIPHER_WEP104,
 	MCU_CIPHER_WEP128,
 	MCU_CIPHER_TKIP,
diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index e366218d6736..4c23b5736c77 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1846,9 +1846,6 @@ void dev_pm_opp_put_supported_hw(struct opp_table *opp_table)
 	if (unlikely(!opp_table))
 		return;
 
-	/* Make sure there are no concurrent readers while updating opp_table */
-	WARN_ON(!list_empty(&opp_table->opp_list));
-
 	kfree(opp_table->supported_hw);
 	opp_table->supported_hw = NULL;
 	opp_table->supported_hw_count = 0;
@@ -1934,9 +1931,6 @@ void dev_pm_opp_put_prop_name(struct opp_table *opp_table)
 	if (unlikely(!opp_table))
 		return;
 
-	/* Make sure there are no concurrent readers while updating opp_table */
-	WARN_ON(!list_empty(&opp_table->opp_list));
-
 	kfree(opp_table->prop_name);
 	opp_table->prop_name = NULL;
 
@@ -2046,9 +2040,6 @@ void dev_pm_opp_put_regulators(struct opp_table *opp_table)
 	if (!opp_table->regulators)
 		goto put_opp_table;
 
-	/* Make sure there are no concurrent readers while updating opp_table */
-	WARN_ON(!list_empty(&opp_table->opp_list));
-
 	if (opp_table->enabled) {
 		for (i = opp_table->regulator_count - 1; i >= 0; i--)
 			regulator_disable(opp_table->regulators[i]);
@@ -2168,9 +2159,6 @@ void dev_pm_opp_put_clkname(struct opp_table *opp_table)
 	if (unlikely(!opp_table))
 		return;
 
-	/* Make sure there are no concurrent readers while updating opp_table */
-	WARN_ON(!list_empty(&opp_table->opp_list));
-
 	clk_put(opp_table->clk);
 	opp_table->clk = ERR_PTR(-EINVAL);
 
@@ -2269,9 +2257,6 @@ void dev_pm_opp_unregister_set_opp_helper(struct opp_table *opp_table)
 	if (unlikely(!opp_table))
 		return;
 
-	/* Make sure there are no concurrent readers while updating opp_table */
-	WARN_ON(!list_empty(&opp_table->opp_list));
-
 	opp_table->set_opp = NULL;
 
 	mutex_lock(&opp_table->lock);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index beb8d1f4fafe..fb667d78e7b3 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -978,7 +978,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 	b->legacy_mem->size = 1024*1024;
 	b->legacy_mem->attr.mode = 0600;
 	b->legacy_mem->mmap = pci_mmap_legacy_mem;
-	b->legacy_io->mapping = iomem_get_mapping();
+	b->legacy_mem->mapping = iomem_get_mapping();
 	pci_adjust_legacy_attr(b, pci_mmap_mem);
 	error = device_create_bin_file(&b->dev, b->legacy_mem);
 	if (error)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6d74386eadc2..ab3de1551b50 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1900,6 +1900,7 @@ static void quirk_ryzen_xhci_d3hot(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e0, quirk_ryzen_xhci_d3hot);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15e1, quirk_ryzen_xhci_d3hot);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1639, quirk_ryzen_xhci_d3hot);
 
 #ifdef CONFIG_X86_IO_APIC
 static int dmi_disable_ioapicreroute(const struct dmi_system_id *d)
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 8c20e524e9ad..e085c255da0c 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -90,7 +90,8 @@ config PTP_1588_CLOCK_INES
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
index 25f6e1ac9e7b..66652ab409cc 100644
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
@@ -778,11 +778,11 @@ static void rdac_bus_detach( struct scsi_device *sdev )
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
index abf7b401f5b9..c509440bd161 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -238,7 +238,7 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 	mimd_t		mimd;
 	uint32_t	adapno;
 	int		iterator;
-
+	bool		is_found;
 
 	if (copy_from_user(&mimd, umimd, sizeof(mimd_t))) {
 		*rval = -EFAULT;
@@ -254,12 +254,16 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 
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
@@ -725,6 +729,7 @@ ioctl_done(uioc_t *kioc)
 	uint32_t	adapno;
 	int		iterator;
 	mraid_mmadp_t*	adapter;
+	bool		is_found;
 
 	/*
 	 * When the kioc returns from driver, make sure it still doesn't
@@ -747,19 +752,23 @@ ioctl_done(uioc_t *kioc)
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
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 335cf37e6cb9..2e429e31f1f0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -684,8 +684,7 @@ int pm8001_dev_found(struct domain_device *dev)
 
 void pm8001_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->slow_task->timer))
-		return;
+	del_timer(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 
@@ -693,9 +692,14 @@ static void pm8001_tmf_timedout(struct timer_list *t)
 {
 	struct sas_task_slow *slow = from_timer(slow, t, timer);
 	struct sas_task *task = slow->task;
+	unsigned long flags;
 
-	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
-	complete(&task->slow_task->completion);
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		complete(&task->slow_task->completion);
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 }
 
 #define PM8001_TASK_TIMEOUT 20
@@ -748,13 +752,10 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		}
 		res = -TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task[%x]timeout.\n",
-					   tmf->tmf);
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
+				   tmf->tmf);
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
@@ -834,12 +835,9 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		wait_for_completion(&task->slow_task->completion);
 		res = TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task timeout.\n");
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 12f54571b83e..f0367115632b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -471,7 +471,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			if (error != -ENXIO)
+				dev_err(dev, "target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 32489d25158f..ae9bfc658203 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -807,11 +807,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_device_set_state(sdev, state);
 	/*
-	 * If the device state changes to SDEV_RUNNING, we need to run
-	 * the queue to avoid I/O hang.
+	 * If the device state changes to SDEV_RUNNING, we need to
+	 * rescan the device to revalidate it, and run the queue to
+	 * avoid I/O hang.
 	 */
-	if (ret == 0 && state == SDEV_RUNNING)
+	if (ret == 0 && state == SDEV_RUNNING) {
+		scsi_rescan_device(dev);
 		blk_mq_run_hw_queues(sdev->request_queue, true);
+	}
 	mutex_unlock(&sdev->state_mutex);
 
 	return ret == 0 ? count : -EINVAL;
diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index f2b5d347d227..e5ae26227bdb 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -66,7 +66,7 @@ int slim_alloc_txn_tid(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	int ret = 0;
 
 	spin_lock_irqsave(&ctrl->txn_lock, flags);
-	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 0,
+	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 1,
 				SLIM_MAX_TIDS, GFP_ATOMIC);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&ctrl->txn_lock, flags);
@@ -131,7 +131,8 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 			goto slim_xfer_err;
 		}
 	}
-
+	/* Initialize tid to invalid value */
+	txn->tid = 0;
 	need_tid = slim_tid_txn(txn->mt, txn->mc);
 
 	if (need_tid) {
@@ -163,7 +164,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 			txn->mt, txn->mc, txn->la, ret);
 
 slim_xfer_err:
-	if (!clk_pause_msg && (!need_tid  || ret == -ETIMEDOUT)) {
+	if (!clk_pause_msg && (txn->tid == 0  || ret == -ETIMEDOUT)) {
 		/*
 		 * remove runtime-pm vote if this was TX only, or
 		 * if there was error during this transaction
diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index c054e83ab636..7040293c2ee8 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -618,7 +618,7 @@ static void qcom_slim_ngd_rx(struct qcom_slim_ngd_ctrl *ctrl, u8 *buf)
 		(mc == SLIM_USR_MC_GENERIC_ACK &&
 		 mt == SLIM_MSG_MT_SRC_REFERRED_USER)) {
 		slim_msg_response(&ctrl->ctrl, &buf[4], buf[3], len - 4);
-		pm_runtime_mark_last_busy(ctrl->dev);
+		pm_runtime_mark_last_busy(ctrl->ctrl.dev);
 	}
 }
 
@@ -1080,7 +1080,8 @@ static void qcom_slim_ngd_setup(struct qcom_slim_ngd_ctrl *ctrl)
 {
 	u32 cfg = readl_relaxed(ctrl->ngd->base);
 
-	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN)
+	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN ||
+		ctrl->state == QCOM_SLIM_NGD_CTRL_ASLEEP)
 		qcom_slim_ngd_init_dma(ctrl);
 
 	/* By default enable message queues */
@@ -1131,6 +1132,7 @@ static int qcom_slim_ngd_power_up(struct qcom_slim_ngd_ctrl *ctrl)
 			dev_info(ctrl->dev, "Subsys restart: ADSP active framer\n");
 			return 0;
 		}
+		qcom_slim_ngd_setup(ctrl);
 		return 0;
 	}
 
@@ -1257,13 +1259,14 @@ static int qcom_slim_ngd_enable(struct qcom_slim_ngd_ctrl *ctrl, bool enable)
 		}
 		/* controller state should be in sync with framework state */
 		complete(&ctrl->qmi.qmi_comp);
-		if (!pm_runtime_enabled(ctrl->dev) ||
-				!pm_runtime_suspended(ctrl->dev))
-			qcom_slim_ngd_runtime_resume(ctrl->dev);
+		if (!pm_runtime_enabled(ctrl->ctrl.dev) ||
+			 !pm_runtime_suspended(ctrl->ctrl.dev))
+			qcom_slim_ngd_runtime_resume(ctrl->ctrl.dev);
 		else
-			pm_runtime_resume(ctrl->dev);
-		pm_runtime_mark_last_busy(ctrl->dev);
-		pm_runtime_put(ctrl->dev);
+			pm_runtime_resume(ctrl->ctrl.dev);
+
+		pm_runtime_mark_last_busy(ctrl->ctrl.dev);
+		pm_runtime_put(ctrl->ctrl.dev);
 
 		ret = slim_register_controller(&ctrl->ctrl);
 		if (ret) {
@@ -1389,7 +1392,7 @@ static int qcom_slim_ngd_ssr_pdr_notify(struct qcom_slim_ngd_ctrl *ctrl,
 		/* Make sure the last dma xfer is finished */
 		mutex_lock(&ctrl->tx_lock);
 		if (ctrl->state != QCOM_SLIM_NGD_CTRL_DOWN) {
-			pm_runtime_get_noresume(ctrl->dev);
+			pm_runtime_get_noresume(ctrl->ctrl.dev);
 			ctrl->state = QCOM_SLIM_NGD_CTRL_DOWN;
 			qcom_slim_ngd_down(ctrl);
 			qcom_slim_ngd_exit_dma(ctrl);
@@ -1617,6 +1620,7 @@ static int __maybe_unused qcom_slim_ngd_runtime_suspend(struct device *dev)
 	struct qcom_slim_ngd_ctrl *ctrl = dev_get_drvdata(dev);
 	int ret = 0;
 
+	qcom_slim_ngd_exit_dma(ctrl);
 	if (!ctrl->qmi.handle)
 		return 0;
 
diff --git a/drivers/soc/fsl/qe/qe_ic.c b/drivers/soc/fsl/qe/qe_ic.c
index 3f711c1a0996..bbae3d39c7be 100644
--- a/drivers/soc/fsl/qe/qe_ic.c
+++ b/drivers/soc/fsl/qe/qe_ic.c
@@ -23,6 +23,7 @@
 #include <linux/signal.h>
 #include <linux/device.h>
 #include <linux/spinlock.h>
+#include <linux/platform_device.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <soc/fsl/qe/qe.h>
@@ -53,8 +54,8 @@ struct qe_ic {
 	struct irq_chip hc_irq;
 
 	/* VIRQ numbers of QE high/low irqs */
-	unsigned int virq_high;
-	unsigned int virq_low;
+	int virq_high;
+	int virq_low;
 };
 
 /*
@@ -404,42 +405,40 @@ static void qe_ic_cascade_muxed_mpic(struct irq_desc *desc)
 	chip->irq_eoi(&desc->irq_data);
 }
 
-static void __init qe_ic_init(struct device_node *node)
+static int qe_ic_init(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	void (*low_handler)(struct irq_desc *desc);
 	void (*high_handler)(struct irq_desc *desc);
 	struct qe_ic *qe_ic;
-	struct resource res;
-	u32 ret;
+	struct resource *res;
+	struct device_node *node = pdev->dev.of_node;
 
-	ret = of_address_to_resource(node, 0, &res);
-	if (ret)
-		return;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "no memory resource defined\n");
+		return -ENODEV;
+	}
 
-	qe_ic = kzalloc(sizeof(*qe_ic), GFP_KERNEL);
+	qe_ic = devm_kzalloc(dev, sizeof(*qe_ic), GFP_KERNEL);
 	if (qe_ic == NULL)
-		return;
+		return -ENOMEM;
 
-	qe_ic->irqhost = irq_domain_add_linear(node, NR_QE_IC_INTS,
-					       &qe_ic_host_ops, qe_ic);
-	if (qe_ic->irqhost == NULL) {
-		kfree(qe_ic);
-		return;
+	qe_ic->regs = devm_ioremap(dev, res->start, resource_size(res));
+	if (qe_ic->regs == NULL) {
+		dev_err(dev, "failed to ioremap() registers\n");
+		return -ENODEV;
 	}
 
-	qe_ic->regs = ioremap(res.start, resource_size(&res));
-
 	qe_ic->hc_irq = qe_ic_irq_chip;
 
-	qe_ic->virq_high = irq_of_parse_and_map(node, 0);
-	qe_ic->virq_low = irq_of_parse_and_map(node, 1);
+	qe_ic->virq_high = platform_get_irq(pdev, 0);
+	qe_ic->virq_low = platform_get_irq(pdev, 1);
 
-	if (!qe_ic->virq_low) {
-		printk(KERN_ERR "Failed to map QE_IC low IRQ\n");
-		kfree(qe_ic);
-		return;
-	}
-	if (qe_ic->virq_high != qe_ic->virq_low) {
+	if (qe_ic->virq_low <= 0)
+		return -ENODEV;
+
+	if (qe_ic->virq_high > 0 && qe_ic->virq_high != qe_ic->virq_low) {
 		low_handler = qe_ic_cascade_low;
 		high_handler = qe_ic_cascade_high;
 	} else {
@@ -447,29 +446,42 @@ static void __init qe_ic_init(struct device_node *node)
 		high_handler = NULL;
 	}
 
+	qe_ic->irqhost = irq_domain_add_linear(node, NR_QE_IC_INTS,
+					       &qe_ic_host_ops, qe_ic);
+	if (qe_ic->irqhost == NULL) {
+		dev_err(dev, "failed to add irq domain\n");
+		return -ENODEV;
+	}
+
 	qe_ic_write(qe_ic->regs, QEIC_CICR, 0);
 
 	irq_set_handler_data(qe_ic->virq_low, qe_ic);
 	irq_set_chained_handler(qe_ic->virq_low, low_handler);
 
-	if (qe_ic->virq_high && qe_ic->virq_high != qe_ic->virq_low) {
+	if (high_handler) {
 		irq_set_handler_data(qe_ic->virq_high, qe_ic);
 		irq_set_chained_handler(qe_ic->virq_high, high_handler);
 	}
+	return 0;
 }
+static const struct of_device_id qe_ic_ids[] = {
+	{ .compatible = "fsl,qe-ic"},
+	{ .type = "qeic"},
+	{},
+};
 
-static int __init qe_ic_of_init(void)
+static struct platform_driver qe_ic_driver =
 {
-	struct device_node *np;
+	.driver	= {
+		.name		= "qe-ic",
+		.of_match_table	= qe_ic_ids,
+	},
+	.probe	= qe_ic_init,
+};
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,qe-ic");
-	if (!np) {
-		np = of_find_node_by_type(NULL, "qeic");
-		if (!np)
-			return -ENODEV;
-	}
-	qe_ic_init(np);
-	of_node_put(np);
+static int __init qe_ic_of_init(void)
+{
+	platform_driver_register(&qe_ic_driver);
 	return 0;
 }
 subsys_initcall(qe_ic_of_init);
diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index d62d69dd72b9..73d4f0a1558d 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -325,7 +325,15 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 	f_pdata->inst_width = CQSPI_INST_TYPE_SINGLE;
 	f_pdata->addr_width = CQSPI_INST_TYPE_SINGLE;
 	f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
-	f_pdata->dtr = op->data.dtr && op->cmd.dtr && op->addr.dtr;
+
+	/*
+	 * For an op to be DTR, cmd phase along with every other non-empty
+	 * phase should have dtr field set to 1. If an op phase has zero
+	 * nbytes, ignore its dtr field; otherwise, check its dtr field.
+	 */
+	f_pdata->dtr = op->cmd.dtr &&
+		       (!op->addr.nbytes || op->addr.dtr) &&
+		       (!op->data.nbytes || op->data.dtr);
 
 	switch (op->data.buswidth) {
 	case 0:
@@ -1227,8 +1235,15 @@ static bool cqspi_supports_mem_op(struct spi_mem *mem,
 {
 	bool all_true, all_false;
 
-	all_true = op->cmd.dtr && op->addr.dtr && op->dummy.dtr &&
-		   op->data.dtr;
+	/*
+	 * op->dummy.dtr is required for converting nbytes into ncycles.
+	 * Also, don't check the dtr field of the op phase having zero nbytes.
+	 */
+	all_true = op->cmd.dtr &&
+		   (!op->addr.nbytes || op->addr.dtr) &&
+		   (!op->dummy.nbytes || op->dummy.dtr) &&
+		   (!op->data.nbytes || op->data.dtr);
+
 	all_false = !op->cmd.dtr && !op->addr.dtr && !op->dummy.dtr &&
 		    !op->data.dtr;
 
diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index 37dfc6e82804..9708b7827ff7 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -167,10 +167,17 @@ err_put_ctlr:
 	return ret;
 }
 
+static const struct spi_device_id spi_mux_id[] = {
+	{ "spi-mux" },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, spi_mux_id);
+
 static const struct of_device_id spi_mux_of_match[] = {
 	{ .compatible = "spi-mux" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, spi_mux_of_match);
 
 static struct spi_driver spi_mux_driver = {
 	.probe  = spi_mux_probe,
@@ -178,6 +185,7 @@ static struct spi_driver spi_mux_driver = {
 		.name   = "spi-mux",
 		.of_match_table = spi_mux_of_match,
 	},
+	.id_table = spi_mux_id,
 };
 
 module_spi_driver(spi_mux_driver);
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 2218941d35a3..73b60f013b20 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1133,7 +1133,7 @@ static int do_proc_control(struct usb_dev_state *ps,
 		"wIndex=%04x wLength=%04x\n",
 		ctrl->bRequestType, ctrl->bRequest, ctrl->wValue,
 		ctrl->wIndex, ctrl->wLength);
-	if (ctrl->bRequestType & 0x80) {
+	if ((ctrl->bRequestType & USB_DIR_IN) && ctrl->wLength) {
 		pipe = usb_rcvctrlpipe(dev, 0);
 		snoop_urb(dev, NULL, pipe, ctrl->wLength, tmo, SUBMIT, NULL, 0);
 
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 30e9e680c74c..4d59d927ae3e 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -783,6 +783,9 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	memset(buf, 0, size);	/* Make sure we parse really received data */
 
 	for (i = 0; i < 3; ++i) {
@@ -832,6 +835,9 @@ static int usb_get_string(struct usb_device *dev, unsigned short langid,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	for (i = 0; i < 3; ++i) {
 		/* retry on length 0 or stall; some devices are flakey */
 		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 426e37a1e78c..1b886d80ba1c 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1709,6 +1709,10 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 	return rlen;
 }
 
+static void tcpm_pd_handle_msg(struct tcpm_port *port,
+			       enum pd_msg_request message,
+			       enum tcpm_ams ams);
+
 static void tcpm_handle_vdm_request(struct tcpm_port *port,
 				    const __le32 *payload, int cnt)
 {
@@ -1736,11 +1740,11 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 		port->vdm_state = VDM_STATE_DONE;
 	}
 
-	if (PD_VDO_SVDM(p[0])) {
+	if (PD_VDO_SVDM(p[0]) && (adev || tcpm_vdm_ams(port) || port->nr_snk_vdo)) {
 		rlen = tcpm_pd_svdm(port, adev, p, cnt, response, &adev_action);
 	} else {
 		if (port->negotiated_rev >= PD_REV30)
-			tcpm_queue_message(port, PD_MSG_CTRL_NOT_SUPP);
+			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 	}
 
 	/*
@@ -2443,10 +2447,7 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 					   NONE_AMS);
 		break;
 	case PD_DATA_VENDOR_DEF:
-		if (tcpm_vdm_ams(port) || port->nr_snk_vdo)
-			tcpm_handle_vdm_request(port, msg->payload, cnt);
-		else if (port->negotiated_rev > PD_REV20)
-			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
+		tcpm_handle_vdm_request(port, msg->payload, cnt);
 		break;
 	case PD_DATA_BIST:
 		port->bist_request = le32_to_cpu(msg->payload[0]);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ab0ab5cf0f6e..1c6cd5276a50 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -477,9 +477,9 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
 				    dev, &ifc_vdpa_ops, NULL);
-	if (adapter == NULL) {
+	if (IS_ERR(adapter)) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
-		return -ENOMEM;
+		return PTR_ERR(adapter);
 	}
 
 	pci_set_master(pdev);
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index cfa56a58b271..0ca39ef20c6d 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -454,11 +454,6 @@ out:
 	mutex_unlock(&mr->mkey_mtx);
 }
 
-static bool map_empty(struct vhost_iotlb *iotlb)
-{
-	return !vhost_iotlb_itree_first(iotlb, 0, U64_MAX);
-}
-
 int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			     bool *change_map)
 {
@@ -466,10 +461,6 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 	int err = 0;
 
 	*change_map = false;
-	if (map_empty(iotlb)) {
-		mlx5_vdpa_destroy_mr(mvdev);
-		return 0;
-	}
 	mutex_lock(&mr->mkey_mtx);
 	if (mr->initialized) {
 		mlx5_vdpa_info(mvdev, "memory map update\n");
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f3495386698a..103d8f70df8e 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -752,12 +752,12 @@ static int get_queue_type(struct mlx5_vdpa_net *ndev)
 	type_mask = MLX5_CAP_DEV_VDPA_EMULATION(ndev->mvdev.mdev, virtio_queue_type);
 
 	/* prefer split queue */
-	if (type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED)
-		return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED;
+	if (type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT)
+		return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT;
 
-	WARN_ON(!(type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT));
+	WARN_ON(!(type_mask & MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED));
 
-	return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT;
+	return MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED;
 }
 
 static bool vq_is_tx(u16 idx)
@@ -2010,6 +2010,12 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 		return -ENOSPC;
 
 	mdev = mgtdev->madev->mdev;
+	if (!(MLX5_CAP_DEV_VDPA_EMULATION(mdev, virtio_queue_type) &
+	    MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT)) {
+		dev_warn(mdev->device, "missing support for split virtqueues\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* we save one virtqueue for control virtqueue should we require it */
 	max_vqs = MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
 	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 98f793bc9376..26337ba42445 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -251,8 +251,10 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
 				    dev_attr->name);
-	if (!vdpasim)
+	if (IS_ERR(vdpasim)) {
+		ret = PTR_ERR(vdpasim);
 		goto err_alloc;
+	}
 
 	vdpasim->dev_attr = *dev_attr;
 	INIT_WORK(&vdpasim->work, dev_attr->work_fn);
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 9145e0624565..54b313e4e63f 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -400,9 +400,9 @@ static int vp_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vp_vdpa = vdpa_alloc_device(struct vp_vdpa, vdpa,
 				    dev, &vp_vdpa_ops, NULL);
-	if (vp_vdpa == NULL) {
+	if (IS_ERR(vp_vdpa)) {
 		dev_err(dev, "vp_vdpa: Failed to allocate vDPA structure\n");
-		return -ENOMEM;
+		return PTR_ERR(vp_vdpa);
 	}
 
 	mdev = &vp_vdpa->mdev;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index fb41db3da611..b5201bedf93f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -614,7 +614,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	long pinned;
 	int ret = 0;
 
-	if (msg->iova < v->range.first ||
+	if (msg->iova < v->range.first || !msg->size ||
+	    msg->iova > U64_MAX - msg->size + 1 ||
 	    msg->iova + msg->size - 1 > v->range.last)
 		return -EINVAL;
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5ccb0705beae..f41463ab4031 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -735,10 +735,16 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
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
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4b15c00c0a0a..49984d2cba24 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -355,6 +355,7 @@ int register_virtio_device(struct virtio_device *dev)
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
 
 	INIT_LIST_HEAD(&dev->vqs);
+	spin_lock_init(&dev->vqs_list_lock);
 
 	/*
 	 * device_add() causes the bus infrastructure to look for a matching
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..6b7aa26c5384 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1668,7 +1668,9 @@ static struct virtqueue *vring_create_virtqueue_packed(
 			cpu_to_le16(vq->packed.event_flags_shadow);
 	}
 
+	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
+	spin_unlock(&vdev->vqs_list_lock);
 	return &vq->vq;
 
 err_desc_extra:
@@ -2126,7 +2128,9 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	memset(vq->split.desc_state, 0, vring.num *
 			sizeof(struct vring_desc_state_split));
 
+	spin_lock(&vdev->vqs_list_lock);
 	list_add_tail(&vq->vq.list, &vdev->vqs);
+	spin_unlock(&vdev->vqs_list_lock);
 	return &vq->vq;
 }
 EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
@@ -2210,7 +2214,9 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 	}
 	if (!vq->packed_ring)
 		kfree(vq->split.desc_state);
+	spin_lock(&vq->vq.vdev->vqs_list_lock);
 	list_del(&_vq->list);
+	spin_unlock(&vq->vq.vdev->vqs_list_lock);
 	kfree(vq);
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
@@ -2274,10 +2280,12 @@ void virtio_break_device(struct virtio_device *dev)
 {
 	struct virtqueue *_vq;
 
+	spin_lock(&dev->vqs_list_lock);
 	list_for_each_entry(_vq, &dev->vqs, list) {
 		struct vring_virtqueue *vq = to_vvq(_vq);
 		vq->broken = true;
 	}
+	spin_unlock(&dev->vqs_list_lock);
 }
 EXPORT_SYMBOL_GPL(virtio_break_device);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272eff4441bc..5d188d5af6fa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9191,8 +9191,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	bool dest_log_pinned = false;
 	bool need_abort = false;
 
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
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f23ff39f7697..9df82eee440a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -165,7 +165,7 @@ struct io_rings {
 	 * Written by the application, shouldn't be modified by the
 	 * kernel.
 	 */
-	u32                     cq_flags;
+	u32			cq_flags;
 	/*
 	 * Number of completion events lost because the queue was full;
 	 * this should be avoided by the application by making sure
@@ -850,7 +850,7 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
-	const struct cred 		*creds;
+	const struct cred		*creds;
 
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
@@ -1482,7 +1482,8 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	if (all_flushed) {
 		clear_bit(0, &ctx->sq_check_overflow);
 		clear_bit(0, &ctx->cq_check_overflow);
-		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
 	}
 
 	if (posted)
@@ -1562,7 +1563,9 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(0, &ctx->sq_check_overflow);
 		set_bit(0, &ctx->cq_check_overflow);
-		ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
+
 	}
 	ocqe->cqe.user_data = user_data;
 	ocqe->cqe.res = res;
@@ -1718,7 +1721,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
+	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
 
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
@@ -2775,7 +2778,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	else
 		io_rw_done(kiocb, ret);
 
-	if (check_reissue && req->flags & REQ_F_REISSUE) {
+	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
 			req_ref_get(req);
@@ -3605,7 +3608,7 @@ static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 static int __io_splice_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
-	struct io_splice* sp = &req->splice;
+	struct io_splice *sp = &req->splice;
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -3659,7 +3662,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_splice* sp = &req->splice;
+	struct io_splice *sp = &req->splice;
 
 	sp->off_in = READ_ONCE(sqe->splice_off_in);
 	sp->off_out = READ_ONCE(sqe->off);
@@ -6790,14 +6793,16 @@ static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	/* Tell userspace we may need a wakeup call */
 	spin_lock_irq(&ctx->completion_lock);
-	ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
 static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	spin_lock_irq(&ctx->completion_lock);
-	ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
@@ -8558,6 +8563,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
 	if (IS_ERR(ctx->cq_ev_fd)) {
 		int ret = PTR_ERR(ctx->cq_ev_fd);
+
 		ctx->cq_ev_fd = NULL;
 		return ret;
 	}
@@ -9356,8 +9362,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		io_cqring_overflow_flush(ctx, false);
 
-		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sq_data->thread == NULL)) {
+			ret = -EOWNERDEAD;
 			goto out;
 		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
@@ -9829,10 +9835,11 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
 			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (!ret)
-		return id;
-	put_cred(creds);
-	return ret;
+	if (ret < 0) {
+		put_cred(creds);
+		return ret;
+	}
+	return id;
 }
 
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
diff --git a/fs/namespace.c b/fs/namespace.c
index caad091fb204..03770bae9dd5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1716,8 +1716,12 @@ static inline bool may_mount(void)
 }
 
 #ifdef	CONFIG_MANDATORY_FILE_LOCKING
-static inline bool may_mandlock(void)
+static bool may_mandlock(void)
 {
+	pr_warn_once("======================================================\n"
+		     "WARNING: the mand mount option is being deprecated and\n"
+		     "         will be removed in v5.15!\n"
+		     "======================================================\n");
 	return capable(CAP_SYS_ADMIN);
 }
 #else
diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index a70d1ea03532..3fe6dd8a18c1 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -51,10 +51,11 @@ extern atomic_t kfence_allocation_gate;
 static __always_inline bool is_kfence_address(const void *addr)
 {
 	/*
-	 * The non-NULL check is required in case the __kfence_pool pointer was
-	 * never initialized; keep it in the slow-path after the range-check.
+	 * The __kfence_pool != NULL check is required to deal with the case
+	 * where __kfence_pool == NULL && addr < KFENCE_POOL_SIZE. Keep it in
+	 * the slow-path after the range-check!
 	 */
-	return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && addr);
+	return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && __kfence_pool);
 }
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c193be760709..63f751faa5c1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -613,12 +613,15 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
-						  struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
+static inline void mem_cgroup_protection(struct mem_cgroup *root,
+					 struct mem_cgroup *memcg,
+					 unsigned long *min,
+					 unsigned long *low)
 {
+	*min = *low = 0;
+
 	if (mem_cgroup_disabled())
-		return 0;
+		return;
 
 	/*
 	 * There is no reclaim protection applied to a targeted reclaim.
@@ -654,13 +657,10 @@ static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
 	 *
 	 */
 	if (root == memcg)
-		return 0;
-
-	if (in_low_reclaim)
-		return READ_ONCE(memcg->memory.emin);
+		return;
 
-	return max(READ_ONCE(memcg->memory.emin),
-		   READ_ONCE(memcg->memory.elow));
+	*min = READ_ONCE(memcg->memory.emin);
+	*low = READ_ONCE(memcg->memory.elow);
 }
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
@@ -1165,11 +1165,12 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
-						  struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
+static inline void mem_cgroup_protection(struct mem_cgroup *root,
+					 struct mem_cgroup *memcg,
+					 unsigned long *min,
+					 unsigned long *low)
 {
-	return 0;
+	*min = *low = 0;
 }
 
 static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
index 98b56b75c625..1a9c9d94cb59 100644
--- a/include/linux/mlx5/mlx5_ifc_vdpa.h
+++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
@@ -11,13 +11,15 @@ enum {
 };
 
 enum {
-	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT   = 0x1, // do I check this caps?
-	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED  = 0x2,
+	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT   = 0,
+	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED  = 1,
 };
 
 enum {
-	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT   = 0,
-	MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED  = 1,
+	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_SPLIT =
+		BIT(MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_SPLIT),
+	MLX5_VIRTIO_EMULATION_CAP_VIRTIO_QUEUE_TYPE_PACKED =
+		BIT(MLX5_VIRTIO_EMULATION_VIRTIO_QUEUE_TYPE_PACKED),
 };
 
 struct mlx5_ifc_virtio_q_bits {
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b1894e0323fa..41edbc01ffa4 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -110,6 +110,7 @@ struct virtio_device {
 	bool config_enabled;
 	bool config_change_pending;
 	spinlock_t config_lock;
+	spinlock_t vqs_list_lock; /* Protects VQs list access */
 	struct device dev;
 	struct virtio_device_id id;
 	const struct virtio_config_ops *config;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 69c9eabf8325..dc5c1e69cd9f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -319,14 +319,12 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	if (action) {
-		flow_action_for_each(i, action_entry, action) {
-			if (i && action_entry->hw_stats != last_hw_stats) {
-				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
-				return false;
-			}
-			last_hw_stats = action_entry->hw_stats;
+	flow_action_for_each(i, action_entry, action) {
+		if (i && action_entry->hw_stats != last_hw_stats) {
+			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
+			return false;
 		}
+		last_hw_stats = action_entry->hw_stats;
 	}
 	return true;
 }
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index eab48745231f..0fbe7ef6b155 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11632,6 +11632,7 @@ static void sanitize_dead_code(struct bpf_verifier_env *env)
 		if (aux_data[i].seen)
 			continue;
 		memcpy(insn + i, &trap, sizeof(trap));
+		aux_data[i].zext_dst = false;
 	}
 }
 
diff --git a/kernel/cfi.c b/kernel/cfi.c
index e17a56639766..9594cfd1cf2c 100644
--- a/kernel/cfi.c
+++ b/kernel/cfi.c
@@ -248,9 +248,9 @@ static inline cfi_check_fn find_shadow_check_fn(unsigned long ptr)
 {
 	cfi_check_fn fn;
 
-	rcu_read_lock_sched();
+	rcu_read_lock_sched_notrace();
 	fn = ptr_to_check_fn(rcu_dereference_sched(cfi_shadow), ptr);
-	rcu_read_unlock_sched();
+	rcu_read_unlock_sched_notrace();
 
 	return fn;
 }
@@ -269,11 +269,11 @@ static inline cfi_check_fn find_module_check_fn(unsigned long ptr)
 	cfi_check_fn fn = NULL;
 	struct module *mod;
 
-	rcu_read_lock_sched();
+	rcu_read_lock_sched_notrace();
 	mod = __module_address(ptr);
 	if (mod)
 		fn = mod->cfi_check;
-	rcu_read_unlock_sched();
+	rcu_read_unlock_sched_notrace();
 
 	return fn;
 }
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 7fa82778c3e6..682334e018dd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -219,6 +219,11 @@ config DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	depends on DYNAMIC_FTRACE_WITH_REGS
 	depends on HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 
+config DYNAMIC_FTRACE_WITH_ARGS
+	def_bool y
+	depends on DYNAMIC_FTRACE
+	depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
+
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 018067e379f2..fa617a0a9eed 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2853,14 +2853,26 @@ int tracepoint_printk_sysctl(struct ctl_table *table, int write,
 
 void trace_event_buffer_commit(struct trace_event_buffer *fbuffer)
 {
+	enum event_trigger_type tt = ETT_NONE;
+	struct trace_event_file *file = fbuffer->trace_file;
+
+	if (__event_trigger_test_discard(file, fbuffer->buffer, fbuffer->event,
+			fbuffer->entry, &tt))
+		goto discard;
+
 	if (static_key_false(&tracepoint_printk_key.key))
 		output_printk(fbuffer);
 
 	if (static_branch_unlikely(&trace_event_exports_enabled))
 		ftrace_exports(fbuffer->event, TRACE_EXPORT_EVENT);
-	event_trigger_unlock_commit_regs(fbuffer->trace_file, fbuffer->buffer,
-				    fbuffer->event, fbuffer->entry,
-				    fbuffer->trace_ctx, fbuffer->regs);
+
+	trace_buffer_unlock_commit_regs(file->tr, fbuffer->buffer,
+			fbuffer->event, fbuffer->trace_ctx, fbuffer->regs);
+
+discard:
+	if (tt)
+		event_triggers_post_call(file, tt);
+
 }
 EXPORT_SYMBOL_GPL(trace_event_buffer_commit);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cd80d046c7a5..1b60ecf85391 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1391,38 +1391,6 @@ event_trigger_unlock_commit(struct trace_event_file *file,
 		event_triggers_post_call(file, tt);
 }
 
-/**
- * event_trigger_unlock_commit_regs - handle triggers and finish event commit
- * @file: The file pointer associated with the event
- * @buffer: The ring buffer that the event is being written to
- * @event: The event meta data in the ring buffer
- * @entry: The event itself
- * @trace_ctx: The tracing context flags.
- *
- * This is a helper function to handle triggers that require data
- * from the event itself. It also tests the event against filters and
- * if the event is soft disabled and should be discarded.
- *
- * Same as event_trigger_unlock_commit() but calls
- * trace_buffer_unlock_commit_regs() instead of trace_buffer_unlock_commit().
- */
-static inline void
-event_trigger_unlock_commit_regs(struct trace_event_file *file,
-				 struct trace_buffer *buffer,
-				 struct ring_buffer_event *event,
-				 void *entry, unsigned int trace_ctx,
-				 struct pt_regs *regs)
-{
-	enum event_trigger_type tt = ETT_NONE;
-
-	if (!__event_trigger_test_discard(file, buffer, event, entry, &tt))
-		trace_buffer_unlock_commit_regs(file->tr, buffer, event,
-						trace_ctx, regs);
-
-	if (tt)
-		event_triggers_post_call(file, tt);
-}
-
 #define FILTER_PRED_INVALID	((unsigned short)-1)
 #define FILTER_PRED_IS_RIGHT	(1 << 15)
 #define FILTER_PRED_FOLD	(1 << 15)
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index c59793ffd59c..4a2e1d360437 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3430,6 +3430,8 @@ trace_action_create_field_var(struct hist_trigger_data *hist_data,
 			event = data->match_data.event;
 		}
 
+		if (!event)
+			goto free;
 		/*
 		 * At this point, we're looking at a field on another
 		 * event.  Because we can't modify a hist trigger on
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8363f737d5ad..6ad419e7e0a4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2286,7 +2286,7 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 		if (!rc) {
 			/*
 			 * This indicates there is an entry in the reserve map
-			 * added by alloc_huge_page.  We know it was added
+			 * not added by alloc_huge_page.  We know it was added
 			 * before the alloc_huge_page call, otherwise
 			 * HPageRestoreReserve would be set on the page.
 			 * Remove the entry so that a subsequent allocation
@@ -4465,7 +4465,9 @@ retry_avoidcopy:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 out_release_all:
-	restore_reserve_on_error(h, vma, haddr, new_page);
+	/* No restore in case of successful pagetable update (Break COW) */
+	if (new_page != old_page)
+		restore_reserve_on_error(h, vma, haddr, new_page);
 	put_page(new_page);
 out_release_old:
 	put_page(old_page);
@@ -4581,7 +4583,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	pte_t new_pte;
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
-	bool new_page = false;
+	bool new_page, new_pagecache_page = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4604,6 +4606,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 		goto out;
 
 retry:
+	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
 		/* Check for page in userfault range */
@@ -4647,6 +4650,7 @@ retry:
 					goto retry;
 				goto out;
 			}
+			new_pagecache_page = true;
 		} else {
 			lock_page(page);
 			if (unlikely(anon_vma_prepare(vma))) {
@@ -4731,7 +4735,9 @@ backout:
 	spin_unlock(ptl);
 backout_unlocked:
 	unlock_page(page);
-	restore_reserve_on_error(h, vma, haddr, page);
+	/* restore reserve for newly allocated pages not in page cache */
+	if (new_page && !new_pagecache_page)
+		restore_reserve_on_error(h, vma, haddr, page);
 	put_page(page);
 	goto out;
 }
@@ -4940,6 +4946,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	int ret;
 	struct page *page;
 	int writable;
+	bool new_pagecache_page = false;
 
 	mapping = dst_vma->vm_file->f_mapping;
 	idx = vma_hugecache_offset(h, dst_vma, dst_addr);
@@ -5004,6 +5011,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
+		new_pagecache_page = true;
 	}
 
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
@@ -5067,7 +5075,8 @@ out_release_unlock:
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
-	restore_reserve_on_error(h, dst_vma, dst_addr, page);
+	if (!new_pagecache_page)
+		restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;
 }
@@ -5930,6 +5939,8 @@ int get_hwpoison_huge_page(struct page *page, bool *hugetlb)
 		*hugetlb = true;
 		if (HPageFreed(page) || HPageMigratable(page))
 			ret = get_page_unless_zero(page);
+		else
+			ret = -EBUSY;
 	}
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6f5f78885ab4..624763fdecc5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -974,13 +974,6 @@ static inline bool HWPoisonHandlable(struct page *page)
 	return PageLRU(page) || __PageMovable(page);
 }
 
-/**
- * __get_hwpoison_page() - Get refcount for memory error handling:
- * @page:	raw error page (hit by memory error)
- *
- * Return: return 0 if failed to grab the refcount, otherwise true (some
- * non-zero value.)
- */
 static int __get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
@@ -997,7 +990,7 @@ static int __get_hwpoison_page(struct page *page)
 	 * unexpected races caused by taking a page refcount.
 	 */
 	if (!HWPoisonHandlable(head))
-		return 0;
+		return -EBUSY;
 
 	if (PageTransHuge(head)) {
 		/*
@@ -1025,15 +1018,6 @@ static int __get_hwpoison_page(struct page *page)
 	return 0;
 }
 
-/*
- * Safely get reference count of an arbitrary page.
- *
- * Returns 0 for a free page, 1 for an in-use page,
- * -EIO for a page-type we cannot handle and -EBUSY if we raced with an
- * allocation.
- * We only incremented refcount in case the page was already in-use and it
- * is a known type we can handle.
- */
 static int get_any_page(struct page *p, unsigned long flags)
 {
 	int ret = 0, pass = 0;
@@ -1043,50 +1027,83 @@ static int get_any_page(struct page *p, unsigned long flags)
 		count_increased = true;
 
 try_again:
-	if (!count_increased && !__get_hwpoison_page(p)) {
-		if (page_count(p)) {
-			/* We raced with an allocation, retry. */
-			if (pass++ < 3)
-				goto try_again;
-			ret = -EBUSY;
-		} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
-			/* We raced with put_page, retry. */
-			if (pass++ < 3)
-				goto try_again;
-			ret = -EIO;
-		}
-	} else {
-		if (PageHuge(p) || HWPoisonHandlable(p)) {
-			ret = 1;
-		} else {
+	if (!count_increased) {
+		ret = __get_hwpoison_page(p);
+		if (!ret) {
+			if (page_count(p)) {
+				/* We raced with an allocation, retry. */
+				if (pass++ < 3)
+					goto try_again;
+				ret = -EBUSY;
+			} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
+				/* We raced with put_page, retry. */
+				if (pass++ < 3)
+					goto try_again;
+				ret = -EIO;
+			}
+			goto out;
+		} else if (ret == -EBUSY) {
 			/*
-			 * A page we cannot handle. Check whether we can turn
-			 * it into something we can handle.
+			 * We raced with (possibly temporary) unhandlable
+			 * page, retry.
 			 */
 			if (pass++ < 3) {
-				put_page(p);
 				shake_page(p, 1);
-				count_increased = false;
 				goto try_again;
 			}
-			put_page(p);
 			ret = -EIO;
+			goto out;
 		}
 	}
 
+	if (PageHuge(p) || HWPoisonHandlable(p)) {
+		ret = 1;
+	} else {
+		/*
+		 * A page we cannot handle. Check whether we can turn
+		 * it into something we can handle.
+		 */
+		if (pass++ < 3) {
+			put_page(p);
+			shake_page(p, 1);
+			count_increased = false;
+			goto try_again;
+		}
+		put_page(p);
+		ret = -EIO;
+	}
+out:
 	return ret;
 }
 
-static int get_hwpoison_page(struct page *p, unsigned long flags,
-			     enum mf_flags ctxt)
+/**
+ * get_hwpoison_page() - Get refcount for memory error handling
+ * @p:		Raw error page (hit by memory error)
+ * @flags:	Flags controlling behavior of error handling
+ *
+ * get_hwpoison_page() takes a page refcount of an error page to handle memory
+ * error on it, after checking that the error page is in a well-defined state
+ * (defined as a page-type we can successfully handle the memor error on it,
+ * such as LRU page and hugetlb page).
+ *
+ * Memory error handling could be triggered at any time on any type of page,
+ * so it's prone to race with typical memory management lifecycle (like
+ * allocation and free).  So to avoid such races, get_hwpoison_page() takes
+ * extra care for the error page's state (as done in __get_hwpoison_page()),
+ * and has some retry logic in get_any_page().
+ *
+ * Return: 0 on failure,
+ *         1 on success for in-use pages in a well-defined state,
+ *         -EIO for pages on which we can not handle memory errors,
+ *         -EBUSY when get_hwpoison_page() has raced with page lifecycle
+ *         operations like allocation and free.
+ */
+static int get_hwpoison_page(struct page *p, unsigned long flags)
 {
 	int ret;
 
 	zone_pcp_disable(page_zone(p));
-	if (ctxt == MF_SOFT_OFFLINE)
-		ret = get_any_page(p, flags);
-	else
-		ret = __get_hwpoison_page(p);
+	ret = get_any_page(p, flags);
 	zone_pcp_enable(page_zone(p));
 
 	return ret;
@@ -1272,27 +1289,33 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 
 	num_poisoned_pages_inc();
 
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p, flags, 0)) {
-		/*
-		 * Check "filter hit" and "race with other subpage."
-		 */
-		lock_page(head);
-		if (PageHWPoison(head)) {
-			if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
-			    || (p != head && TestSetPageHWPoison(head))) {
-				num_poisoned_pages_dec();
-				unlock_page(head);
-				return 0;
+	if (!(flags & MF_COUNT_INCREASED)) {
+		res = get_hwpoison_page(p, flags);
+		if (!res) {
+			/*
+			 * Check "filter hit" and "race with other subpage."
+			 */
+			lock_page(head);
+			if (PageHWPoison(head)) {
+				if ((hwpoison_filter(p) && TestClearPageHWPoison(p))
+				    || (p != head && TestSetPageHWPoison(head))) {
+					num_poisoned_pages_dec();
+					unlock_page(head);
+					return 0;
+				}
 			}
+			unlock_page(head);
+			res = MF_FAILED;
+			if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+				page_ref_inc(p);
+				res = MF_RECOVERED;
+			}
+			action_result(pfn, MF_MSG_FREE_HUGE, res);
+			return res == MF_RECOVERED ? 0 : -EBUSY;
+		} else if (res < 0) {
+			action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
+			return -EBUSY;
 		}
-		unlock_page(head);
-		res = MF_FAILED;
-		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
-			page_ref_inc(p);
-			res = MF_RECOVERED;
-		}
-		action_result(pfn, MF_MSG_FREE_HUGE, res);
-		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
 	lock_page(head);
@@ -1493,28 +1516,35 @@ try_again:
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p, flags, 0)) {
-		if (is_free_buddy_page(p)) {
-			if (take_page_off_buddy(p)) {
-				page_ref_inc(p);
-				res = MF_RECOVERED;
-			} else {
-				/* We lost the race, try again */
-				if (retry) {
-					ClearPageHWPoison(p);
-					num_poisoned_pages_dec();
-					retry = false;
-					goto try_again;
+	if (!(flags & MF_COUNT_INCREASED)) {
+		res = get_hwpoison_page(p, flags);
+		if (!res) {
+			if (is_free_buddy_page(p)) {
+				if (take_page_off_buddy(p)) {
+					page_ref_inc(p);
+					res = MF_RECOVERED;
+				} else {
+					/* We lost the race, try again */
+					if (retry) {
+						ClearPageHWPoison(p);
+						num_poisoned_pages_dec();
+						retry = false;
+						goto try_again;
+					}
+					res = MF_FAILED;
 				}
-				res = MF_FAILED;
+				action_result(pfn, MF_MSG_BUDDY, res);
+				res = res == MF_RECOVERED ? 0 : -EBUSY;
+			} else {
+				action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+				res = -EBUSY;
 			}
-			action_result(pfn, MF_MSG_BUDDY, res);
-			res = res == MF_RECOVERED ? 0 : -EBUSY;
-		} else {
-			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+			goto unlock_mutex;
+		} else if (res < 0) {
+			action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 			res = -EBUSY;
+			goto unlock_mutex;
 		}
-		goto unlock_mutex;
 	}
 
 	if (PageTransHuge(hpage)) {
@@ -1792,7 +1822,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	if (!get_hwpoison_page(p, flags, 0)) {
+	if (!get_hwpoison_page(p, flags)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
@@ -2008,7 +2038,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 
 retry:
 	get_online_mems();
-	ret = get_hwpoison_page(page, flags, MF_SOFT_OFFLINE);
+	ret = get_hwpoison_page(page, flags);
 	put_online_mems();
 
 	if (ret > 0) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5199b9696bab..f62d81f61b56 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -100,9 +100,12 @@ struct scan_control {
 	unsigned int may_swap:1;
 
 	/*
-	 * Cgroups are not reclaimed below their configured memory.low,
-	 * unless we threaten to OOM. If any cgroups are skipped due to
-	 * memory.low and nothing was reclaimed, go back for memory.low.
+	 * Cgroup memory below memory.low is protected as long as we
+	 * don't threaten to OOM. If any cgroup is reclaimed at
+	 * reduced force or passed over entirely due to its memory.low
+	 * setting (memcg_low_skipped), and nothing is reclaimed as a
+	 * result, then go back for one more cycle that reclaims the protected
+	 * memory (memcg_low_reclaim) to avert OOM.
 	 */
 	unsigned int memcg_low_reclaim:1;
 	unsigned int memcg_low_skipped:1;
@@ -2521,15 +2524,14 @@ out:
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
 		unsigned long lruvec_size;
+		unsigned long low, min;
 		unsigned long scan;
-		unsigned long protection;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		protection = mem_cgroup_protection(sc->target_mem_cgroup,
-						   memcg,
-						   sc->memcg_low_reclaim);
+		mem_cgroup_protection(sc->target_mem_cgroup, memcg,
+				      &min, &low);
 
-		if (protection) {
+		if (min || low) {
 			/*
 			 * Scale a cgroup's reclaim pressure by proportioning
 			 * its current usage to its memory.low or memory.min
@@ -2560,6 +2562,15 @@ out:
 			 * hard protection.
 			 */
 			unsigned long cgroup_size = mem_cgroup_size(memcg);
+			unsigned long protection;
+
+			/* memory.low scaling, make sure we retry before OOM */
+			if (!sc->memcg_low_reclaim && low > min) {
+				protection = low;
+				sc->memcg_low_skipped = 1;
+			} else {
+				protection = min;
+			}
 
 			/* Avoid TOCTOU with earlier protection check */
 			cgroup_size = max(cgroup_size, protection);
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 9cc9d1ee6cdb..c5c1d2b8045e 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -41,9 +41,9 @@ extern bool dccp_debug;
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
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2481bfdfafd0..efe5c3295455 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -260,6 +260,8 @@ static void ieee80211_restart_work(struct work_struct *work)
 	flush_work(&local->radar_detected_work);
 
 	rtnl_lock();
+	/* we might do interface manipulations, so need both */
+	wiphy_lock(local->hw.wiphy);
 
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 	     "%s called with hardware scan in progress\n", __func__);
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 4f08e04e1ab7..f3ec85779733 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -843,20 +843,16 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		return subflow->mp_capable;
 	}
 
-	if (mp_opt->dss && mp_opt->use_ack) {
+	if ((mp_opt->dss && mp_opt->use_ack) ||
+	    (mp_opt->add_addr && !mp_opt->echo)) {
 		/* subflows are fully established as soon as we get any
-		 * additional ack.
+		 * additional ack, including ADD_ADDR.
 		 */
 		subflow->fully_established = 1;
 		WRITE_ONCE(msk->fully_established, true);
 		goto fully_established;
 	}
 
-	if (mp_opt->add_addr) {
-		WRITE_ONCE(msk->fully_established, true);
-		return true;
-	}
-
 	/* If the first established packet does not contain MP_CAPABLE + data
 	 * then fallback to TCP. Fallback scenarios requires a reset for
 	 * MP_JOIN subflows.
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index fce1d057d19e..45b414efc001 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1135,36 +1135,12 @@ next:
 	return 0;
 }
 
-struct addr_entry_release_work {
-	struct rcu_work	rwork;
-	struct mptcp_pm_addr_entry *entry;
-};
-
-static void mptcp_pm_release_addr_entry(struct work_struct *work)
+/* caller must ensure the RCU grace period is already elapsed */
+static void __mptcp_pm_release_addr_entry(struct mptcp_pm_addr_entry *entry)
 {
-	struct addr_entry_release_work *w;
-	struct mptcp_pm_addr_entry *entry;
-
-	w = container_of(to_rcu_work(work), struct addr_entry_release_work, rwork);
-	entry = w->entry;
-	if (entry) {
-		if (entry->lsk)
-			sock_release(entry->lsk);
-		kfree(entry);
-	}
-	kfree(w);
-}
-
-static void mptcp_pm_free_addr_entry(struct mptcp_pm_addr_entry *entry)
-{
-	struct addr_entry_release_work *w;
-
-	w = kmalloc(sizeof(*w), GFP_ATOMIC);
-	if (w) {
-		INIT_RCU_WORK(&w->rwork, mptcp_pm_release_addr_entry);
-		w->entry = entry;
-		queue_rcu_work(system_wq, &w->rwork);
-	}
+	if (entry->lsk)
+		sock_release(entry->lsk);
+	kfree(entry);
 }
 
 static int mptcp_nl_remove_id_zero_address(struct net *net,
@@ -1244,7 +1220,8 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	spin_unlock_bh(&pernet->lock);
 
 	mptcp_nl_remove_subflow_and_signal_addr(sock_net(skb->sk), &entry->addr);
-	mptcp_pm_free_addr_entry(entry);
+	synchronize_rcu();
+	__mptcp_pm_release_addr_entry(entry);
 
 	return ret;
 }
@@ -1297,6 +1274,7 @@ static void mptcp_nl_remove_addrs_list(struct net *net,
 	}
 }
 
+/* caller must ensure the RCU grace period is already elapsed */
 static void __flush_addrs(struct list_head *list)
 {
 	while (!list_empty(list)) {
@@ -1305,7 +1283,7 @@ static void __flush_addrs(struct list_head *list)
 		cur = list_entry(list->next,
 				 struct mptcp_pm_addr_entry, list);
 		list_del_rcu(&cur->list);
-		mptcp_pm_free_addr_entry(cur);
+		__mptcp_pm_release_addr_entry(cur);
 	}
 }
 
@@ -1329,6 +1307,7 @@ static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
 	spin_unlock_bh(&pernet->lock);
 	mptcp_nl_remove_addrs_list(sock_net(skb->sk), &free_list);
+	synchronize_rcu();
 	__flush_addrs(&free_list);
 	return 0;
 }
@@ -1936,7 +1915,8 @@ static void __net_exit pm_nl_exit_net(struct list_head *net_list)
 		struct pm_nl_pernet *pernet = net_generic(net, pm_nl_pernet_id);
 
 		/* net is removed from namespace list, can't race with
-		 * other modifiers
+		 * other modifiers, also netns core already waited for a
+		 * RCU grace period.
 		 */
 		__flush_addrs(&pernet->local_addr_list);
 	}
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 88deb5b41429..cf2ce5812489 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
 	}
 
 	skb->dev = vport->dev;
+	skb->tstamp = 0;
 	vport->ops->send(skb);
 	return;
 
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 951542843cab..28af8b1e1bb1 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -720,7 +720,7 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 skip_hash:
 	if (flow_override)
 		flow_hash = flow_override - 1;
-	else if (use_skbhash)
+	else if (use_skbhash && (flow_mode & CAKE_FLOW_FLOWS))
 		flow_hash = skb->hash;
 	if (host_override) {
 		dsthost_hash = host_override - 1;
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 2e8afe078d61..cb40ff0ff28d 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -241,7 +241,7 @@ static void ipcomp_free_tfms(struct crypto_comp * __percpu *tfms)
 			break;
 	}
 
-	WARN_ON(!pos);
+	WARN_ON(list_entry_is_head(pos, &ipcomp_tfms_list, list));
 
 	if (--pos->users)
 		return;
diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 1f8018f9ce57..534c0df75172 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -3460,7 +3460,7 @@ static int cap_put_caller(struct snd_kcontrol *kcontrol,
 	struct hda_gen_spec *spec = codec->spec;
 	const struct hda_input_mux *imux;
 	struct nid_path *path;
-	int i, adc_idx, err = 0;
+	int i, adc_idx, ret, err = 0;
 
 	imux = &spec->input_mux;
 	adc_idx = kcontrol->id.index;
@@ -3470,9 +3470,13 @@ static int cap_put_caller(struct snd_kcontrol *kcontrol,
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
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6d8c4dedfe0f..0c6be8509855 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6598,6 +6598,7 @@ enum {
 	ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP,
 	ALC623_FIXUP_LENOVO_THINKSTATION_P340,
 	ALC255_FIXUP_ACER_HEADPHONE_AND_MIC,
+	ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8182,6 +8183,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC255_FIXUP_XIAOMI_HEADSET_MIC
 	},
+	[ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8272,6 +8279,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1028, 0x0a61, "Dell XPS 15 9510", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
@@ -8377,8 +8385,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884c, "HP EliteBook 840 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
-	SND_PCI_QUIRK(0x103c, 0x8862, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
-	SND_PCI_QUIRK(0x103c, 0x8863, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8862, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x103c, 0x8863, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x886d, "HP ZBook Fury 17.3 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index a5c1a2c4eae4..773a136161f1 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1041,6 +1041,7 @@ static const struct hda_fixup via_fixups[] = {
 };
 
 static const struct snd_pci_quirk vt2002p_fixups[] = {
+	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 5db2f4865bbb..905c7965f653 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -127,7 +127,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = substream->runtime->dma_addr;
+	u32 buffer_addr = virt_to_phys(substream->runtime->dma_area);
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
