Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF71618063
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiKCPCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiKCPCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:02:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800A8193CD;
        Thu,  3 Nov 2022 08:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7EBBB828D1;
        Thu,  3 Nov 2022 15:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F587C433C1;
        Thu,  3 Nov 2022 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667487735;
        bh=7MMx7JgP6HSypzlVY5vTcGrAllNrhR6IgK2QktKm74E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ylJFYWX3PjvMaiyUhUm6EZUliBBqEnykdS0EojFAS17mnHxuINICMf5JmG6VEJfAS
         kLc4KGgt5UGE2XJIHOjWDQrC1H5v9tayrugRhcRHg6ilgz0zVzgtDq30V2QTsgHcbI
         mgxvvs6F/wTQxZNl8tAQ8n3iXmi1PkajMQgI1k2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.298
Date:   Fri,  4 Nov 2022 00:02:51 +0900
Message-Id: <166748777093203@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1667487770167141@kroah.com>
References: <1667487770167141@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 42f5672e8917..b03e9efa0e3b 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -53,7 +53,9 @@ stable kernels.
 | ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075        |
 | ARM            | Cortex-A57      | #852523         | N/A                         |
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220        |
+| ARM            | Cortex-A57      | #1742098        | ARM64_ERRATUM_1742098       |
 | ARM            | Cortex-A72      | #853709         | N/A                         |
+| ARM            | Cortex-A72      | #1655431        | ARM64_ERRATUM_1742098       |
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
 | ARM            | Cortex-A76      | #1188873        | ARM64_ERRATUM_1188873       |
diff --git a/Makefile b/Makefile
index a66c65fcb96f..c1912ead188e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 297
+SUBLEVEL = 298
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index 2f39d9b3886e..19d0cab60a39 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -35,7 +35,7 @@ static inline void ioport_unmap(void __iomem *addr)
 {
 }
 
-extern void iounmap(const void __iomem *addr);
+extern void iounmap(const volatile void __iomem *addr);
 
 #define ioremap_nocache(phy, sz)	ioremap(phy, sz)
 #define ioremap_wc(phy, sz)		ioremap(phy, sz)
diff --git a/arch/arc/mm/ioremap.c b/arch/arc/mm/ioremap.c
index 9881bd740ccc..0719b1280ef8 100644
--- a/arch/arc/mm/ioremap.c
+++ b/arch/arc/mm/ioremap.c
@@ -95,7 +95,7 @@ void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
 EXPORT_SYMBOL(ioremap_prot);
 
 
-void iounmap(const void __iomem *addr)
+void iounmap(const volatile void __iomem *addr)
 {
 	/* weird double cast to handle phys_addr_t > 32 bits */
 	if (arc_uncached_addr_space((phys_addr_t)(u32)addr))
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7605d2f00d55..9256c3456949 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -472,6 +472,22 @@ config ARM64_ERRATUM_1188873
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1742098
+	bool "Cortex-A57/A72: 1742098: ELR recorded incorrectly on interrupt taken between cryptographic instructions in a sequence"
+	depends on COMPAT
+	default y
+	help
+	  This option removes the AES hwcap for aarch32 user-space to
+	  workaround erratum 1742098 on Cortex-A57 and Cortex-A72.
+
+	  Affected parts may corrupt the AES state if an interrupt is
+	  taken between a pair of AES instructions. These instructions
+	  are only present if the cryptography extensions are present.
+	  All software should have a fallback implementation for CPUs
+	  that don't implement the cryptography extensions.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 20ca422eb094..d9f7a068a524 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -47,7 +47,8 @@
 #define ARM64_SSBS				27
 #define ARM64_WORKAROUND_1188873		28
 #define ARM64_SPECTRE_BHB			29
+#define ARM64_WORKAROUND_1742098		30
 
-#define ARM64_NCAPS				30
+#define ARM64_NCAPS				31
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ed627d44746a..40d05139398c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -576,6 +576,14 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	return (need_wa > 0);
 }
 
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+static struct midr_range broken_aarch32_aes[] = {
+	MIDR_RANGE(MIDR_CORTEX_A57, 0, 1, 0xf, 0xf),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -741,6 +749,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = is_spectre_bhb_affected,
 		.cpu_enable = spectre_bhb_enable_mitigation,
 	},
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	{
+		.desc = "ARM erratum 1742098",
+		.capability = ARM64_WORKAROUND_1742098,
+		CAP_MIDR_RANGE_LIST(broken_aarch32_aes),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b6922f33d306..ceac57bdf4ca 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -30,6 +30,7 @@
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
+#include <asm/hwcap.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
 #include <asm/sysreg.h>
@@ -1010,6 +1011,14 @@ static void cpu_enable_ssbs(const struct arm64_cpu_capabilities *__unused)
 }
 #endif /* CONFIG_ARM64_SSBD */
 
+static void elf_hwcap_fixup(void)
+{
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1742098))
+		compat_elf_hwcap2 &= ~COMPAT_HWCAP2_AES;
+#endif /* ARM64_ERRATUM_1742098 */
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -1588,8 +1597,10 @@ void __init setup_cpu_features(void)
 	mark_const_caps_ready();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	/* Advertise that we have computed the system capabilities */
 	set_sys_caps_initialised();
diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
index 9b5a3469fed9..87f794bde24b 100644
--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -16,7 +16,8 @@
 		"3: jl    1b\n"						\
 		"   lhi   %0,0\n"					\
 		"4: sacf  768\n"					\
-		EX_TABLE(0b,4b) EX_TABLE(2b,4b) EX_TABLE(3b,4b)		\
+		EX_TABLE(0b,4b) EX_TABLE(1b,4b)				\
+		EX_TABLE(2b,4b) EX_TABLE(3b,4b)				\
 		: "=d" (ret), "=&d" (oldval), "=&d" (newval),		\
 		  "=m" (*uaddr)						\
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index d0a61d3e2fb9..69dd0c9de460 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -222,7 +222,13 @@ apply_microcode_early_amd(u32 cpuid_1_eax, void *ucode, size_t size, bool save_p
 		return ret;
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	if (rev >= mc->hdr.patch_id)
+
+	/*
+	 * Allow application of the same revision to pick up SMT-specific
+	 * changes even if the revision of the other SMT thread is already
+	 * up-to-date.
+	 */
+	if (rev > mc->hdr.patch_id)
 		return ret;
 
 	if (!__apply_microcode_amd(mc)) {
@@ -304,8 +310,12 @@ void load_ucode_amd_ap(unsigned int cpuid_1_eax)
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
-	/* Check whether we have saved a new patch already: */
-	if (*new_rev && rev < mc->hdr.patch_id) {
+	/*
+	 * Check whether a new patch has been saved already. Also, allow application of
+	 * the same revision in order to pick up SMT-thread-specific configuration even
+	 * if the sibling SMT thread already has an up-to-date revision.
+	 */
+	if (*new_rev && rev <= mc->hdr.patch_id) {
 		if (!__apply_microcode_amd(mc)) {
 			*new_rev = mc->hdr.patch_id;
 			return;
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index e64c5b78fbfd..350f40f9a0bf 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -579,7 +579,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	/* Otherwise, skip ahead to the user-specified starting frame: */
 	while (!unwind_done(state) &&
 	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
-			state->sp < (unsigned long)first_frame))
+			state->sp <= (unsigned long)first_frame))
 		unwind_next_frame(state);
 
 	return;
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 943b1dc2d0b3..e05309bc41cc 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -13,6 +13,7 @@
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
 #include <linux/ras.h>
+#include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
 
@@ -141,8 +142,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	int	cpu = mce->extcpu;
 	struct acpi_hest_generic_status *estatus, *tmp;
 	struct acpi_hest_generic_data *gdata;
-	const guid_t *fru_id = &guid_null;
-	char *fru_text = "";
+	const guid_t *fru_id;
+	char *fru_text;
 	guid_t *sec_type;
 	static u32 err_seq;
 
@@ -163,17 +164,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
 	/* log event via trace */
 	err_seq++;
-	gdata = (struct acpi_hest_generic_data *)(tmp + 1);
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
-		fru_id = (guid_t *)gdata->fru_id;
-	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
-		fru_text = gdata->fru_text;
-	sec_type = (guid_t *)gdata->section_type;
-	if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
-		struct cper_sec_mem_err *mem = (void *)(gdata + 1);
-		if (gdata->error_data_length >= sizeof(*mem))
-			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
-					       (u8)gdata->error_severity);
+	apei_estatus_for_each_section(tmp, gdata) {
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+			fru_id = (guid_t *)gdata->fru_id;
+		else
+			fru_id = &guid_null;
+		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+			fru_text = gdata->fru_text;
+		else
+			fru_text = "";
+		sec_type = (guid_t *)gdata->section_type;
+		if (guid_equal(sec_type, &CPER_SEC_PLATFORM_MEM)) {
+			struct cper_sec_mem_err *mem = (void *)(gdata + 1);
+
+			if (gdata->error_data_length >= sizeof(*mem))
+				trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
+						       (u8)gdata->error_severity);
+		}
 	}
 
 out:
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 490ae990bd3c..0ec74ab2a399 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -447,6 +447,70 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "PF5LUXG"),
 		},
 	},
+	/*
+	 * More Tongfang devices with the same issue as the Clevo NL5xRU and
+	 * NL5xNU/TUXEDO Aura 15 Gen1 and Gen2. See the description above.
+	 */
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GKxNRxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1501A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A1650TI"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GKxNRxx",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+		DMI_MATCH(DMI_BOARD_NAME, "POLARIS1701A2060"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxNGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxNGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxZGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxZGxx"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "TongFang GMxRGxx",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
 	 * for this do not catch.
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 781b898e5785..f41f98626354 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -260,7 +260,7 @@ enum {
 	ICH_MAP				= 0x90, /* ICH MAP register */
 
 	/* em constants */
-	EM_MAX_SLOTS			= 8,
+	EM_MAX_SLOTS			= SATA_PMP_MAX_PORTS,
 	EM_MAX_RETRY			= 5,
 
 	/* em_ctl bits */
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index 787567e840bd..7ac3514657f4 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -887,4 +887,4 @@ module_platform_driver(imx_ahci_driver);
 MODULE_DESCRIPTION("Freescale i.MX AHCI SATA platform driver");
 MODULE_AUTHOR("Richard Zhu <Hong-Xing.Zhu@freescale.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ahci:imx");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index e811f2414889..a64b093a88cf 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2232,6 +2232,10 @@ static int genpd_iterate_idle_states(struct device_node *dn,
 		np = it.node;
 		if (!of_match_node(idle_state_match, np))
 			continue;
+
+		if (!of_device_is_available(np))
+			continue;
+
 		if (states) {
 			ret = genpd_parse_state(&states[i], np);
 			if (ret) {
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 0df62c9c2856..c55e1920bfde 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -291,6 +291,11 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 	struct platform_device *pdev = hdmi->pdev;
 	int ret;
 
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	hdmi->dev = dev;
 	hdmi->encoder = encoder;
 
diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c
index e3b1c86b7aae..5c932b3fb831 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c
@@ -71,8 +71,9 @@ static int mdp4_lvds_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
+static enum drm_mode_status
+mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
 {
 	struct mdp4_lvds_connector *mdp4_lvds_connector =
 			to_mdp4_lvds_connector(connector);
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 8c993f95e3ba..396a3c720b51 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -342,7 +342,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);
-		break;
+		return 0;
 	default:
 		return 0;
 	}
diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 87ed9adec7e1..e13917602704 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -867,7 +867,7 @@ static int tsl2583_probe(struct i2c_client *clientp,
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 74bfd7d29338..a04d4664edb4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2785,6 +2785,7 @@ static int __init si_domain_init(int hw)
 
 	if (md_domain_init(si_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		domain_exit(si_domain);
+		si_domain = NULL;
 		return -EFAULT;
 	}
 
@@ -3475,6 +3476,10 @@ static int __init init_dmars(void)
 		disable_dmar_iommu(iommu);
 		free_dmar_iommu(iommu);
 	}
+	if (si_domain) {
+		domain_exit(si_domain);
+		si_domain = NULL;
+	}
 
 	kfree(g_iommus);
 
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 6754e5fcc4c4..c4bbdd5196bf 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -309,6 +309,28 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a
 	return vivid_vid_out_g_fbuf(file, fh, a);
 }
 
+/*
+ * Only support the framebuffer of one of the vivid instances.
+ * Anything else is rejected.
+ */
+bool vivid_validate_fb(const struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev;
+	int i;
+
+	for (i = 0; i < n_devs; i++) {
+		dev = vivid_devs[i];
+		if (!dev || !dev->video_pbase)
+			continue;
+		if ((unsigned long)a->base == dev->video_pbase &&
+		    a->fmt.width <= dev->display_width &&
+		    a->fmt.height <= dev->display_height &&
+		    a->fmt.bytesperline <= dev->display_byte_stride)
+			return true;
+	}
+	return false;
+}
+
 static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a)
 {
 	struct video_device *vdev = video_devdata(file);
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 5cdf95bdc4d1..6de8eb8d2cef 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -562,4 +562,6 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
+bool vivid_validate_fb(const struct v4l2_framebuffer *a);
+
 #endif
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index c66568e8f388..459cff1626a6 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -458,6 +458,12 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 	tpg_reset_source(&dev->tpg, dev->src_rect.width, dev->src_rect.height, dev->field_cap);
 	dev->crop_cap = dev->src_rect;
 	dev->crop_bounds_cap = dev->src_rect;
+	if (dev->bitmap_cap &&
+	    (dev->compose_cap.width != dev->crop_cap.width ||
+	     dev->compose_cap.height != dev->crop_cap.height)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	dev->compose_cap = dev->crop_cap;
 	if (V4L2_FIELD_HAS_T_OR_B(dev->field_cap))
 		dev->compose_cap.height /= 2;
@@ -886,6 +892,8 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 	struct vivid_dev *dev = video_drvdata(file);
 	struct v4l2_rect *crop = &dev->crop_cap;
 	struct v4l2_rect *compose = &dev->compose_cap;
+	unsigned orig_compose_w = compose->width;
+	unsigned orig_compose_h = compose->height;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_cap) ? 2 : 1;
 	int ret;
 
@@ -1002,17 +1010,17 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 			s->r.height /= factor;
 		}
 		v4l2_rect_map_inside(&s->r, &dev->fmt_cap_rect);
-		if (dev->bitmap_cap && (compose->width != s->r.width ||
-					compose->height != s->r.height)) {
-			vfree(dev->bitmap_cap);
-			dev->bitmap_cap = NULL;
-		}
 		*compose = s->r;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (dev->bitmap_cap && (compose->width != orig_compose_w ||
+				compose->height != orig_compose_h)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	tpg_s_crop_compose(&dev->tpg, crop, compose);
 	return 0;
 }
@@ -1255,7 +1263,14 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	if (a->fmt.bytesperline < (a->fmt.width * fmt->bit_depth[0]) / 8)
 		return -EINVAL;
-	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+	if (a->fmt.bytesperline > a->fmt.sizeimage / a->fmt.height)
+		return -EINVAL;
+
+	/*
+	 * Only support the framebuffer of one of the vivid instances.
+	 * Anything else is rejected.
+	 */
+	if (!vivid_validate_fb(a))
 		return -EINVAL;
 
 	dev->fb_vbase_cap = phys_to_virt((unsigned long)a->base);
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index bed6b7db43f5..4353e624a585 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -172,6 +172,20 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
 	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
 		return false;
+
+	/* sanity checks for the blanking timings */
+	if (!bt->interlaced &&
+	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
+		return false;
+	if (bt->hfrontporch > 2 * bt->width ||
+	    bt->hsync > 1024 || bt->hbackporch > 1024)
+		return false;
+	if (bt->vfrontporch > 4096 ||
+	    bt->vsync > 128 || bt->vbackporch > 4096)
+		return false;
+	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
+	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }
 EXPORT_SYMBOL_GPL(v4l2_valid_dv_timings);
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index f62e68aa04c4..dcb869c588f2 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -358,19 +358,14 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
-int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
-		      struct v4l2_buffer *buf)
+static void v4l2_m2m_adjust_mem_offset(struct vb2_queue *vq,
+				       struct v4l2_buffer *buf)
 {
-	struct vb2_queue *vq;
-	int ret = 0;
-	unsigned int i;
-
-	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_querybuf(vq, buf);
-
 	/* Adjust MMAP memory offsets for the CAPTURE queue */
 	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
 		if (V4L2_TYPE_IS_MULTIPLANAR(vq->type)) {
+			unsigned int i;
+
 			for (i = 0; i < buf->length; ++i)
 				buf->m.planes[i].m.mem_offset
 					+= DST_QUEUE_OFF_BASE;
@@ -378,8 +373,23 @@ int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			buf->m.offset += DST_QUEUE_OFF_BASE;
 		}
 	}
+}
 
-	return ret;
+int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_querybuf(vq, buf);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 
@@ -391,10 +401,15 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_qbuf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
 
-	return ret;
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
@@ -402,9 +417,17 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf)
 {
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	ret = vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
@@ -416,10 +439,15 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_prepare_buf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
 
-	return ret;
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 2b32b88949ba..2441799605dd 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -264,7 +264,8 @@ static void sdio_release_func(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 
-	sdio_free_func_cis(func);
+	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
+		sdio_free_func_cis(func);
 
 	kfree(func->info);
 	kfree(func->tmpbuf);
diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 2949a381a94d..21993ba7ae2a 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -336,14 +336,14 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 					       &mscan_clksrc);
 	if (!priv->can.clock.freq) {
 		dev_err(&ofdev->dev, "couldn't get MSCAN clock properties\n");
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	err = register_mscandev(dev, mscan_clksrc);
 	if (err) {
 		dev_err(&ofdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	dev_info(&ofdev->dev, "MSCAN at 0x%p, irq %d, clock %d Hz\n",
@@ -351,7 +351,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 	return 0;
 
-exit_free_mscan:
+exit_put_clock:
+	if (data->put_clock)
+		data->put_clock(ofdev);
 	free_candev(dev);
 exit_dispose_irq:
 	irq_dispose_mapping(irq);
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index a1634834b640..cb1388267fe0 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1079,7 +1079,7 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	struct net_device *ndev;
 	struct rcar_canfd_channel *priv;
-	u32 sts, gerfl;
+	u32 sts, cc, gerfl;
 	u32 ch, ridx;
 
 	/* Global error interrupts still indicate a condition specific
@@ -1097,7 +1097,9 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 
 		/* Handle Rx interrupts */
 		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-		if (likely(sts & RCANFD_RFSTS_RFIF)) {
+		cc = rcar_canfd_read(priv->base, RCANFD_RFCC(ridx));
+		if (likely(sts & RCANFD_RFSTS_RFIF &&
+			   cc & RCANFD_RFCC_RFIE)) {
 			if (napi_schedule_prep(&priv->napi)) {
 				/* Disable Rx FIFO interrupts */
 				rcar_canfd_clear_bit(priv->base,
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 4a4370a470fd..3ccdac464cf5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -237,6 +237,7 @@ enum xgbe_sfp_speed {
 #define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
 #define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
+#define XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX	0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -273,6 +274,8 @@ struct xgbe_sfp_eeprom {
 #define XGBE_BEL_FUSE_VENDOR	"BEL-FUSE        "
 #define XGBE_BEL_FUSE_PARTNO	"1GBT-SFP06      "
 
+#define XGBE_MOLEX_VENDOR	"Molex Inc.      "
+
 struct xgbe_sfp_ascii {
 	union {
 		char vendor[XGBE_SFP_BASE_VENDOR_NAME_LEN + 1];
@@ -840,7 +843,11 @@ static bool xgbe_phy_sfp_bit_rate(struct xgbe_sfp_eeprom *sfp_eeprom,
 		break;
 	case XGBE_SFP_SPEED_10000:
 		min = XGBE_SFP_BASE_BR_10GBE_MIN;
-		max = XGBE_SFP_BASE_BR_10GBE_MAX;
+		if (memcmp(&sfp_eeprom->base[XGBE_SFP_BASE_VENDOR_NAME],
+			   XGBE_MOLEX_VENDOR, XGBE_SFP_BASE_VENDOR_NAME_LEN) == 0)
+			max = XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX;
+		else
+			max = XGBE_SFP_BASE_BR_10GBE_MAX;
 		break;
 	default:
 		return false;
@@ -1095,7 +1102,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	}
 
 	/* Determine the type of SFP */
-	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
+	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
+	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
@@ -1111,9 +1121,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
 	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
-	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
-		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
-		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 
 	switch (phy_data->sfp_base) {
 	case XGBE_SFP_BASE_1000_T:
diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index c7fa97a7e1f4..b591b05b956b 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -424,8 +424,10 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
 	hdev->cls_dev.release = hnae_release;
 	(void)dev_set_name(&hdev->cls_dev, "hnae%d", hdev->id);
 	ret = device_register(&hdev->cls_dev);
-	if (ret)
+	if (ret) {
+		put_device(&hdev->cls_dev);
 		return ret;
+	}
 
 	__module_get(THIS_MODULE);
 
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index a754e2ce7730..c3606e8b1192 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2928,6 +2928,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 	ret = of_device_register(&port->ofdev);
 	if (ret) {
 		pr_err("failed to register device. ret=%d\n", ret);
+		put_device(&port->ofdev.dev);
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 21648dab13e0..0691027e9ce1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2375,10 +2375,17 @@ static int i40e_get_rss_hash_opts(struct i40e_pf *pf, struct ethtool_rxnfc *cmd)
 
 		if (cmd->flow_type == TCP_V4_FLOW ||
 		    cmd->flow_type == UDP_V4_FLOW) {
-			if (i_set & I40E_L3_SRC_MASK)
-				cmd->data |= RXH_IP_SRC;
-			if (i_set & I40E_L3_DST_MASK)
-				cmd->data |= RXH_IP_DST;
+			if (hw->mac.type == I40E_MAC_X722) {
+				if (i_set & I40E_X722_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_X722_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			} else {
+				if (i_set & I40E_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			}
 		} else if (cmd->flow_type == TCP_V6_FLOW ||
 			  cmd->flow_type == UDP_V6_FLOW) {
 			if (i_set & I40E_L3_V6_SRC_MASK)
@@ -2683,12 +2690,15 @@ static int i40e_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 
 /**
  * i40e_get_rss_hash_bits - Read RSS Hash bits from register
+ * @hw: hw structure
  * @nfc: pointer to user request
  * @i_setc bits currently set
  *
  * Returns value of bits to be set per user request
  **/
-static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
+static u64 i40e_get_rss_hash_bits(struct i40e_hw *hw,
+				  struct ethtool_rxnfc *nfc,
+				  u64 i_setc)
 {
 	u64 i_set = i_setc;
 	u64 src_l3 = 0, dst_l3 = 0;
@@ -2707,8 +2717,13 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
 		dst_l3 = I40E_L3_V6_DST_MASK;
 	} else if (nfc->flow_type == TCP_V4_FLOW ||
 		  nfc->flow_type == UDP_V4_FLOW) {
-		src_l3 = I40E_L3_SRC_MASK;
-		dst_l3 = I40E_L3_DST_MASK;
+		if (hw->mac.type == I40E_MAC_X722) {
+			src_l3 = I40E_X722_L3_SRC_MASK;
+			dst_l3 = I40E_X722_L3_DST_MASK;
+		} else {
+			src_l3 = I40E_L3_SRC_MASK;
+			dst_l3 = I40E_L3_DST_MASK;
+		}
 	} else {
 		/* Any other flow type are not supported here */
 		return i_set;
@@ -2726,6 +2741,7 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
 	return i_set;
 }
 
+#define FLOW_PCTYPES_SIZE 64
 /**
  * i40e_set_rss_hash_opt - Enable/Disable flow types for RSS hash
  * @pf: pointer to the physical function struct
@@ -2738,9 +2754,11 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 	struct i40e_hw *hw = &pf->hw;
 	u64 hena = (u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(0)) |
 		   ((u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(1)) << 32);
-	u8 flow_pctype = 0;
+	DECLARE_BITMAP(flow_pctypes, FLOW_PCTYPES_SIZE);
 	u64 i_set, i_setc;
 
+	bitmap_zero(flow_pctypes, FLOW_PCTYPES_SIZE);
+
 	if (pf->flags & I40E_FLAG_MFP_ENABLED) {
 		dev_err(&pf->pdev->dev,
 			"Change of RSS hash input set is not supported when MFP mode is enabled\n");
@@ -2756,36 +2774,35 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 
 	switch (nfc->flow_type) {
 	case TCP_V4_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV4_TCP;
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_TCP, flow_pctypes);
 		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK);
+			set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK,
+				flow_pctypes);
 		break;
 	case TCP_V6_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV6_TCP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK);
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_TCP, flow_pctypes);
 		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV6_TCP_SYN_NO_ACK);
+			set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_TCP_SYN_NO_ACK,
+				flow_pctypes);
 		break;
 	case UDP_V4_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV4_UDP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV4_UDP) |
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV4_UDP);
-
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_UDP, flow_pctypes);
+		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE) {
+			set_bit(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV4_UDP,
+				flow_pctypes);
+			set_bit(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV4_UDP,
+				flow_pctypes);
+		}
 		hena |= BIT_ULL(I40E_FILTER_PCTYPE_FRAG_IPV4);
 		break;
 	case UDP_V6_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV6_UDP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV6_UDP) |
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV6_UDP);
-
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_UDP, flow_pctypes);
+		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE) {
+			set_bit(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV6_UDP,
+				flow_pctypes);
+			set_bit(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV6_UDP,
+				flow_pctypes);
+		}
 		hena |= BIT_ULL(I40E_FILTER_PCTYPE_FRAG_IPV6);
 		break;
 	case AH_ESP_V4_FLOW:
@@ -2818,17 +2835,20 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 		return -EINVAL;
 	}
 
-	if (flow_pctype) {
-		i_setc = (u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(0,
-					       flow_pctype)) |
-			((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1,
-					       flow_pctype)) << 32);
-		i_set = i40e_get_rss_hash_bits(nfc, i_setc);
-		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_pctype),
-				  (u32)i_set);
-		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_pctype),
-				  (u32)(i_set >> 32));
-		hena |= BIT_ULL(flow_pctype);
+	if (bitmap_weight(flow_pctypes, FLOW_PCTYPES_SIZE)) {
+		u8 flow_id;
+
+		for_each_set_bit(flow_id, flow_pctypes, FLOW_PCTYPES_SIZE) {
+			i_setc = (u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_id)) |
+				 ((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_id)) << 32);
+			i_set = i40e_get_rss_hash_bits(&pf->hw, nfc, i_setc);
+
+			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_id),
+					  (u32)i_set);
+			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_id),
+					  (u32)(i_set >> 32));
+			hena |= BIT_ULL(flow_id);
+		}
 	}
 
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), (u32)hena);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index fd4bbdd88b57..8338bd348d26 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1433,6 +1433,10 @@ struct i40e_lldp_variables {
 #define I40E_PFQF_CTL_0_HASHLUTSIZE_512	0x00010000
 
 /* INPUT SET MASK for RSS, flow director, and flexible payload */
+#define I40E_X722_L3_SRC_SHIFT		49
+#define I40E_X722_L3_SRC_MASK		(0x3ULL << I40E_X722_L3_SRC_SHIFT)
+#define I40E_X722_L3_DST_SHIFT		41
+#define I40E_X722_L3_DST_MASK		(0x3ULL << I40E_X722_L3_DST_SHIFT)
 #define I40E_L3_SRC_SHIFT		47
 #define I40E_L3_SRC_MASK		(0x3ULL << I40E_L3_SRC_SHIFT)
 #define I40E_L3_V6_SRC_SHIFT		43
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index afc810069440..2a14520e4798 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -479,7 +479,6 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	len = skb->len < ETH_ZLEN ? ETH_ZLEN : skb->len;
 
 	if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) || ch->skb[ch->dma.desc]) {
-		dev_kfree_skb_any(skb);
 		netdev_err(dev, "tx ring full\n");
 		netif_tx_stop_queue(txq);
 		return NETDEV_TX_BUSY;
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index b178e59baa2e..8212f24711bb 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6939,7 +6939,7 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 	char banner[sizeof(version)];
 	struct ksz_switch *sw = NULL;
 
-	result = pci_enable_device(pdev);
+	result = pcim_enable_device(pdev);
 	if (result)
 		return result;
 
diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 92a7247b6299..0eb417b8f709 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -777,6 +777,13 @@ static const struct usb_device_id	products[] = {
 },
 #endif
 
+/* Lenovo ThinkPad OneLink+ Dock (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3054, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* ThinkPad USB-C Dock (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 1ed358d0da84..d17d125a3454 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5312,6 +5312,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 1f26f0ab155f..3c33bd8d4679 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -227,6 +227,15 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Kingston DataTraveler 3.0 */
 	{ USB_DEVICE(0x0951, 0x1666), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* NVIDIA Jetson devices in Force Recovery mode */
+	{ USB_DEVICE(0x0955, 0x7018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7019), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7418), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7721), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7c18), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7e19), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7f21), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 2915ed402520..5d142d7f6272 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -965,8 +965,8 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:
diff --git a/drivers/usb/gadget/udc/bdc/bdc_udc.c b/drivers/usb/gadget/udc/bdc/bdc_udc.c
index c84346146456..bd40931c11bd 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_udc.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_udc.c
@@ -156,6 +156,7 @@ static void bdc_uspc_disconnected(struct bdc *bdc, bool reinit)
 	bdc->delayed_status = false;
 	bdc->reinit = reinit;
 	bdc->test_mode = false;
+	usb_gadget_set_state(&bdc->gadget, USB_STATE_NOTATTACHED);
 }
 
 /* TNotify wkaeup timer */
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index ae724460c8f2..0ba936c3a0e9 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -911,15 +911,19 @@ void xhci_free_virt_device(struct xhci_hcd *xhci, int slot_id)
 		if (dev->eps[i].stream_info)
 			xhci_free_stream_info(xhci,
 					dev->eps[i].stream_info);
-		/* Endpoints on the TT/root port lists should have been removed
-		 * when usb_disable_device() was called for the device.
-		 * We can't drop them anyway, because the udev might have gone
-		 * away by this point, and we can't tell what speed it was.
+		/*
+		 * Endpoints are normally deleted from the bandwidth list when
+		 * endpoints are dropped, before device is freed.
+		 * If host is dying or being removed then endpoints aren't
+		 * dropped cleanly, so delete the endpoint from list here.
+		 * Only applicable for hosts with software bandwidth checking.
 		 */
-		if (!list_empty(&dev->eps[i].bw_endpoint_list))
-			xhci_warn(xhci, "Slot %u endpoint %u "
-					"not removed from BW list!\n",
-					slot_id, i);
+
+		if (!list_empty(&dev->eps[i].bw_endpoint_list)) {
+			list_del_init(&dev->eps[i].bw_endpoint_list);
+			xhci_dbg(xhci, "Slot %u endpoint %u not removed from BW list!\n",
+				 slot_id, i);
+		}
 	}
 	/* If this is a hub, free the TT(s) from the TT list */
 	xhci_free_tt_info(xhci, dev, slot_id);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index bf649af49cbd..af420957767e 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -239,8 +239,14 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI) {
+		/*
+		 * try to tame the ASMedia 1042 controller which reports 0.96
+		 * but appears to behave more like 1.0
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 6f7820b236f4..1f4562e61669 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -100,7 +100,6 @@ struct ufx_data {
 	struct kref kref;
 	int fb_count;
 	bool virtualized; /* true when physical usb device not present */
-	struct delayed_work free_framebuffer_work;
 	atomic_t usb_active; /* 0 = update virtual buffer, but no usb traffic */
 	atomic_t lost_pixels; /* 1 = a render op failed. Need screen refresh */
 	u8 *edid; /* null until we read edid from hw or get from sysfs */
@@ -1120,15 +1119,24 @@ static void ufx_free(struct kref *kref)
 {
 	struct ufx_data *dev = container_of(kref, struct ufx_data, kref);
 
-	/* this function will wait for all in-flight urbs to complete */
-	if (dev->urbs.count > 0)
-		ufx_free_urb_list(dev);
+	kfree(dev);
+}
 
-	pr_debug("freeing ufx_data %p", dev);
+static void ufx_ops_destory(struct fb_info *info)
+{
+	struct ufx_data *dev = info->par;
+	int node = info->node;
 
-	kfree(dev);
+	/* Assume info structure is freed after this point */
+	framebuffer_release(info);
+
+	pr_debug("fb_info for /dev/fb%d has been freed", node);
+
+	/* release reference taken by kref_init in probe() */
+	kref_put(&dev->kref, ufx_free);
 }
 
+
 static void ufx_release_urb_work(struct work_struct *work)
 {
 	struct urb_node *unode = container_of(work, struct urb_node,
@@ -1137,14 +1145,9 @@ static void ufx_release_urb_work(struct work_struct *work)
 	up(&unode->dev->urbs.limit_sem);
 }
 
-static void ufx_free_framebuffer_work(struct work_struct *work)
+static void ufx_free_framebuffer(struct ufx_data *dev)
 {
-	struct ufx_data *dev = container_of(work, struct ufx_data,
-					    free_framebuffer_work.work);
 	struct fb_info *info = dev->info;
-	int node = info->node;
-
-	unregister_framebuffer(info);
 
 	if (info->cmap.len != 0)
 		fb_dealloc_cmap(&info->cmap);
@@ -1156,11 +1159,6 @@ static void ufx_free_framebuffer_work(struct work_struct *work)
 
 	dev->info = NULL;
 
-	/* Assume info structure is freed after this point */
-	framebuffer_release(info);
-
-	pr_debug("fb_info for /dev/fb%d has been freed", node);
-
 	/* ref taken in probe() as part of registering framebfufer */
 	kref_put(&dev->kref, ufx_free);
 }
@@ -1172,11 +1170,13 @@ static int ufx_ops_release(struct fb_info *info, int user)
 {
 	struct ufx_data *dev = info->par;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev->fb_count--;
 
 	/* We can't free fb_info here - fbmem will touch it when we return */
 	if (dev->virtualized && (dev->fb_count == 0))
-		schedule_delayed_work(&dev->free_framebuffer_work, HZ);
+		ufx_free_framebuffer(dev);
 
 	if ((dev->fb_count == 0) && (info->fbdefio)) {
 		fb_deferred_io_cleanup(info);
@@ -1190,6 +1190,8 @@ static int ufx_ops_release(struct fb_info *info, int user)
 
 	kref_put(&dev->kref, ufx_free);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1296,6 +1298,7 @@ static struct fb_ops ufx_ops = {
 	.fb_blank = ufx_ops_blank,
 	.fb_check_var = ufx_ops_check_var,
 	.fb_set_par = ufx_ops_set_par,
+	.fb_destroy = ufx_ops_destory,
 };
 
 /* Assumes &info->lock held by caller
@@ -1688,9 +1691,6 @@ static int ufx_usb_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	INIT_DELAYED_WORK(&dev->free_framebuffer_work,
-			  ufx_free_framebuffer_work);
-
 	retval = ufx_reg_read(dev, 0x3000, &id_rev);
 	check_warn_goto_error(retval, "error %d reading 0x3000 register from device", retval);
 	dev_dbg(dev->gdev, "ID_REV register value 0x%08x", id_rev);
@@ -1769,10 +1769,12 @@ static int ufx_usb_probe(struct usb_interface *interface,
 static void ufx_usb_disconnect(struct usb_interface *interface)
 {
 	struct ufx_data *dev;
+	struct fb_info *info;
 
 	mutex_lock(&disconnect_mutex);
 
 	dev = usb_get_intfdata(interface);
+	info = dev->info;
 
 	pr_debug("USB disconnect starting\n");
 
@@ -1786,12 +1788,15 @@ static void ufx_usb_disconnect(struct usb_interface *interface)
 
 	/* if clients still have us open, will be freed on last close */
 	if (dev->fb_count == 0)
-		schedule_delayed_work(&dev->free_framebuffer_work, 0);
+		ufx_free_framebuffer(dev);
 
-	/* release reference taken by kref_init in probe() */
-	kref_put(&dev->kref, ufx_free);
+	/* this function will wait for all in-flight urbs to complete */
+	if (dev->urbs.count > 0)
+		ufx_free_urb_list(dev);
 
-	/* consider ufx_data freed */
+	pr_debug("freeing ufx_data %p", dev);
+
+	unregister_framebuffer(info);
 
 	mutex_unlock(&disconnect_mutex);
 }
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 799173755b78..bcd1c3c993d3 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -364,8 +364,7 @@ static int map_grant_pages(struct grant_map *map)
 	for (i = 0; i < map->count; i++) {
 		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-			if (!use_ptemod)
-				alloced++;
+			alloced++;
 		} else if (!err)
 			err = -EINVAL;
 
@@ -374,8 +373,7 @@ static int map_grant_pages(struct grant_map *map)
 
 		if (use_ptemod) {
 			if (map->kmap_ops[i].status == GNTST_okay) {
-				if (map->map_ops[i].status == GNTST_okay)
-					alloced++;
+				alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
 			} else if (!err)
 				err = -EINVAL;
@@ -391,20 +389,42 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int i;
 	struct grant_map *map = data->data;
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
+	int successful_unmaps = 0;
+	int live_grants;
 
 	for (i = 0; i < data->count; i++) {
+		if (map->unmap_ops[offset + i].status == GNTST_okay &&
+		    map->unmap_ops[offset + i].handle != -1)
+			successful_unmaps++;
+
 		WARN_ON(map->unmap_ops[offset+i].status &&
 			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = -1;
+		if (use_ptemod) {
+			if (map->kunmap_ops[offset + i].status == GNTST_okay &&
+			    map->kunmap_ops[offset + i].handle != -1)
+				successful_unmaps++;
+
+			WARN_ON(map->kunmap_ops[offset+i].status &&
+				map->kunmap_ops[offset+i].handle != -1);
+			pr_debug("kunmap handle=%u st=%d\n",
+				 map->kunmap_ops[offset+i].handle,
+				 map->kunmap_ops[offset+i].status);
+			map->kunmap_ops[offset+i].handle = -1;
+		}
 	}
+
 	/*
 	 * Decrease the live-grant counter.  This must happen after the loop to
 	 * prevent premature reuse of the grants by gnttab_mmap().
 	 */
-	atomic_sub(data->count, &map->live_grants);
+	live_grants = atomic_sub_return(successful_unmaps, &map->live_grants);
+	if (WARN_ON(live_grants < 0))
+		pr_err("%s: live_grants became negative (%d) after unmapping %d pages!\n",
+		       __func__, live_grants, successful_unmaps);
 
 	/* Release reference taken by unmap_grant_pages */
 	gntdev_put_map(NULL, map);
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 58dc96d7ecaf..93cfbdada40f 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -146,6 +146,7 @@ struct share_check {
 	u64 root_objectid;
 	u64 inum;
 	int share_count;
+	bool have_delayed_delete_refs;
 };
 
 static inline int extent_is_shared(struct share_check *sc)
@@ -832,13 +833,22 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			key.offset = ref->offset;
 
 			/*
-			 * Found a inum that doesn't match our known inum, we
-			 * know it's shared.
+			 * If we have a share check context and a reference for
+			 * another inode, we can't exit immediately. This is
+			 * because even if this is a BTRFS_ADD_DELAYED_REF
+			 * reference we may find next a BTRFS_DROP_DELAYED_REF
+			 * which cancels out this ADD reference.
+			 *
+			 * If this is a DROP reference and there was no previous
+			 * ADD reference, then we need to signal that when we
+			 * process references from the extent tree (through
+			 * add_inline_refs() and add_keyed_refs()), we should
+			 * not exit early if we find a reference for another
+			 * inode, because one of the delayed DROP references
+			 * may cancel that reference in the extent tree.
 			 */
-			if (sc && sc->inum && ref->objectid != sc->inum) {
-				ret = BACKREF_FOUND_SHARED;
-				goto out;
-			}
+			if (sc && count < 0)
+				sc->have_delayed_delete_refs = true;
 
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
 					       &key, 0, node->bytenr, count, sc,
@@ -868,7 +878,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 	}
 	if (!ret)
 		ret = extent_is_shared(sc);
-out:
+
 	spin_unlock(&head->lock);
 	return ret;
 }
@@ -972,7 +982,8 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -982,6 +993,7 @@ static int add_inline_refs(const struct btrfs_fs_info *fs_info,
 			ret = add_indirect_ref(fs_info, preftrees, root,
 					       &key, 0, bytenr, count,
 					       sc, GFP_NOFS);
+
 			break;
 		}
 		default:
@@ -1071,7 +1083,8 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 
-			if (sc && sc->inum && key.objectid != sc->inum) {
+			if (sc && sc->inum && key.objectid != sc->inum &&
+			    !sc->have_delayed_delete_refs) {
 				ret = BACKREF_FOUND_SHARED;
 				break;
 			}
@@ -1490,6 +1503,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 		.root_objectid = root->objectid,
 		.inum = inum,
 		.share_count = 0,
+		.have_delayed_delete_refs = false,
 	};
 
 	tmp = ulist_alloc(GFP_NOFS);
@@ -1528,6 +1542,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 			break;
 		bytenr = node->val;
 		shared.share_count = 0;
+		shared.have_delayed_delete_refs = false;
 		cond_resched();
 	}
 
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index fa2dee322ee9..da25f36827eb 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1490,8 +1490,11 @@ int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 	mutex_lock(&kernfs_mutex);
 
 	kn = kernfs_find_ns(parent, name, ns);
-	if (kn)
+	if (kn) {
+		kernfs_get(kn);
 		__kernfs_remove(kn);
+		kernfs_put(kn);
+	}
 
 	mutex_unlock(&kernfs_mutex);
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3b0a10d9b36f..1dc9304eec89 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -244,6 +244,7 @@ static int ocfs2_mknod(struct inode *dir,
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
+	struct ocfs2_dinode *fe = NULL;
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
@@ -394,6 +395,7 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	}
 
+	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
 					    new_fe_bh, data_ac, meta_ac);
@@ -459,8 +461,11 @@ static int ocfs2_mknod(struct inode *dir,
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -638,18 +643,9 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		return status;
 	}
 
-	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
-		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
-		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
-				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
-		if (tmp)
-			mlog_errno(tmp);
-	}
-
-	return status;
 }
 
 static int ocfs2_mkdir(struct inode *dir,
@@ -2030,8 +2026,11 @@ static int ocfs2_symlink(struct inode *dir,
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index b773e96b4a28..b8fd2c303ed0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1392,7 +1392,8 @@ struct v4l2_bt_timings {
 	((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
 #define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
 	((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \
-	 (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
+	 ((bt)->interlaced ? \
+	  ((bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch) : 0))
 #define V4L2_DV_BT_FRAME_HEIGHT(bt) \
 	((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index f4ecb23c9194..e97f2395e15d 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -618,7 +618,7 @@ static void power_down(void)
 	int error;
 
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(mem_sleep_current);
 		if (error) {
 			hibernation_mode = hibernation_ops ?
 						HIBERNATION_PLATFORM :
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 04ad2bba01eb..f09f5dd9c731 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2089,11 +2089,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = __alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetPagePrivate(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock(&hugetlb_lock);
 		list_move(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 8a0c17e1c203..4d5f8690e914 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -220,11 +220,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (!page)
 		return -ENOMEM;
 
-	for (p = page, len = 0; len < nbytes; p++, len++) {
+	for (p = page, len = 0; len < nbytes; p++) {
 		if (get_user(*p, buff++)) {
 			free_page((unsigned long)page);
 			return -EFAULT;
 		}
+		len += 1;
 		if (*p == '\0' || *p == '\n')
 			break;
 	}
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a8929675b5ab..a13b10867b6f 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -515,8 +515,10 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 	if (err < 0)
 		goto out;
 
-	if (addr->family != AF_IEEE802154)
+	if (addr->family != AF_IEEE802154) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	ieee802154_addr_from_sa(&haddr, &addr->addr);
 	dev = ieee802154_get_dev(sock_net(sk), &haddr);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index eeed79ce8f9f..87095d5ecf95 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2058,7 +2058,8 @@ void tcp_enter_loss(struct sock *sk)
  */
 static bool tcp_check_sack_reneging(struct sock *sk, int flag)
 {
-	if (flag & FLAG_SACK_RENEGING) {
+	if (flag & FLAG_SACK_RENEGING &&
+	    flag & FLAG_SND_UNA_ADVANCED) {
 		struct tcp_sock *tp = tcp_sk(sk);
 		unsigned long delay = max(usecs_to_jiffies(tp->srtt_us >> 4),
 					  msecs_to_jiffies(10));
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index c364d849e7c3..629103c7337b 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -164,7 +164,8 @@ static void kcm_rcv_ready(struct kcm_sock *kcm)
 	/* Buffer limit is okay now, add to ready list */
 	list_add_tail(&kcm->wait_rx_list,
 		      &kcm->mux->kcm_rx_waiters);
-	kcm->rx_wait = true;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, true);
 }
 
 static void kcm_rfree(struct sk_buff *skb)
@@ -180,7 +181,7 @@ static void kcm_rfree(struct sk_buff *skb)
 	/* For reading rx_wait and rx_psock without holding lock */
 	smp_mb__after_atomic();
 
-	if (!kcm->rx_wait && !kcm->rx_psock &&
+	if (!READ_ONCE(kcm->rx_wait) && !READ_ONCE(kcm->rx_psock) &&
 	    sk_rmem_alloc_get(sk) < sk->sk_rcvlowat) {
 		spin_lock_bh(&mux->rx_lock);
 		kcm_rcv_ready(kcm);
@@ -239,7 +240,8 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 		if (kcm_queue_rcv_skb(&kcm->sk, skb)) {
 			/* Should mean socket buffer full */
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 
 			/* Commit rx_wait to read in kcm_free */
 			smp_wmb();
@@ -282,10 +284,12 @@ static struct kcm_sock *reserve_rx_kcm(struct kcm_psock *psock,
 	kcm = list_first_entry(&mux->kcm_rx_waiters,
 			       struct kcm_sock, wait_rx_list);
 	list_del(&kcm->wait_rx_list);
-	kcm->rx_wait = false;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, false);
 
 	psock->rx_kcm = kcm;
-	kcm->rx_psock = psock;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, psock);
 
 	spin_unlock_bh(&mux->rx_lock);
 
@@ -312,7 +316,8 @@ static void unreserve_rx_kcm(struct kcm_psock *psock,
 	spin_lock_bh(&mux->rx_lock);
 
 	psock->rx_kcm = NULL;
-	kcm->rx_psock = NULL;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, NULL);
 
 	/* Commit kcm->rx_psock before sk_rmem_alloc_get to sync with
 	 * kcm_rfree
@@ -1240,7 +1245,8 @@ static void kcm_recv_disable(struct kcm_sock *kcm)
 	if (!kcm->rx_psock) {
 		if (kcm->rx_wait) {
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 		}
 
 		requeue_rx_msgs(mux, &kcm->sk.sk_receive_queue);
@@ -1798,7 +1804,8 @@ static void kcm_done(struct kcm_sock *kcm)
 
 	if (kcm->rx_wait) {
 		list_del(&kcm->wait_rx_list);
-		kcm->rx_wait = false;
+		/* paired with lockless reads in kcm_rfree() */
+		WRITE_ONCE(kcm->rx_wait, false);
 	}
 	/* Move any pending receive messages to other kcm sockets */
 	requeue_rx_msgs(mux, &sk->sk_receive_queue);
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 060ccd0e14ce..dc1a384bc137 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -140,7 +140,7 @@ static int
 ieee802154_parse_frame_start(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 {
 	int hlen;
-	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
+	struct ieee802154_mac_cb *cb = mac_cb(skb);
 
 	skb_reset_mac_header(skb);
 
@@ -302,8 +302,9 @@ void
 ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
 
-	mac_cb(skb)->lqi = lqi;
+	cb->lqi = lqi;
 	skb->pkt_type = IEEE802154_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8319628ab428..a57a3755611d 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1578,7 +1578,8 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb, struct genl_info *in
 	if (IS_ERR(dp))
 		return;
 
-	WARN(dp->user_features, "Dropping previously announced user features\n");
+	pr_warn("%s: Dropping previously announced user features\n",
+		ovs_dp_name(dp));
 	dp->user_features = 0;
 }
 
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 000b58522106..2811e1f1e2fa 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -148,6 +148,7 @@ static int i2sbus_get_and_fixup_rsrc(struct device_node *np, int index,
 	return rc;
 }
 
+/* Returns 1 if added, 0 for otherwise; don't return a negative value! */
 /* FIXME: look at device node refcounting */
 static int i2sbus_add_dev(struct macio_dev *macio,
 			  struct i2sbus_control *control,
@@ -213,7 +214,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 	 * either as the second one in that case is just a modem. */
 	if (!ok) {
 		kfree(dev);
-		return -ENODEV;
+		return 0;
 	}
 
 	mutex_init(&dev->lock);
@@ -302,6 +303,10 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 
 	if (soundbus_add_one(&dev->sound)) {
 		printk(KERN_DEBUG "i2sbus: device registration error!\n");
+		if (dev->sound.ofdev.dev.kobj.state_initialized) {
+			soundbus_dev_put(&dev->sound);
+			return 0;
+		}
 		goto err;
 	}
 
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 1cb2a1ecf3cf..d5dfc7349e70 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1965,6 +1965,7 @@ static int snd_ac97_dev_register(struct snd_device *device)
 		     snd_ac97_get_short_name(ac97));
 	if ((err = device_register(&ac97->dev)) < 0) {
 		ac97_err(ac97, "Can't register ac97 bus\n");
+		put_device(&ac97->dev);
 		ac97->dev.bus = NULL;
 		return err;
 	}
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index bcc648bf6478..28a6598a391e 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -153,7 +153,7 @@ struct snd_vortex {
 #ifndef CHIP_AU8810
 	stream_t dma_wt[NR_WT];
 	wt_voice_t wt_voice[NR_WT];	/* WT register cache. */
-	char mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
+	s8 mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
 #endif
 
 	/* Global resources */
@@ -247,8 +247,8 @@ static int vortex_alsafmt_aspfmt(int alsafmt, vortex_t *v);
 static void vortex_connect_default(vortex_t * vortex, int en);
 static int vortex_adb_allocroute(vortex_t * vortex, int dma, int nr_ch,
 				 int dir, int type, int subdev);
-static char vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
-				  int restype);
+static int vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
+				 int restype);
 #ifndef CHIP_AU8810
 static int vortex_wt_allocroute(vortex_t * vortex, int dma, int nr_ch);
 static void vortex_wt_connect(vortex_t * vortex, int en);
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index c308a4f70550..7af6ada4b3c0 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -2004,7 +2004,7 @@ static int resnum[VORTEX_RESOURCE_LAST] =
  out: Mean checkout if != 0. Else mean Checkin resource.
  restype: Indicates type of resource to be checked in or out.
 */
-static char
+static int
 vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out, int restype)
 {
 	int i, qty = resnum[restype], resinuse = 0;
diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 82b587afa615..2f85103d42e4 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -138,15 +138,10 @@ EXPORT_SYMBOL(snd_emux_register);
  */
 int snd_emux_free(struct snd_emux *emu)
 {
-	unsigned long flags;
-
 	if (! emu)
 		return -EINVAL;
 
-	spin_lock_irqsave(&emu->voice_lock, flags);
-	if (emu->timer_active)
-		del_timer(&emu->tlist);
-	spin_unlock_irqrestore(&emu->voice_lock, flags);
+	del_timer_sync(&emu->tlist);
 
 	snd_emux_proc_free(emu);
 	snd_emux_delete_virmidi(emu);
diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index 55272fef3b50..d60a252577f0 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -546,6 +546,10 @@ static int calc_digits(int num)
 {
 	int count = 0;
 
+	/* It takes a digit to represent zero */
+	if (!num)
+		return 1;
+
 	while (num != 0) {
 		num /= 10;
 		count++;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8354ec4ef912..fd25c2161060 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1835,7 +1835,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 
 	memset(entry, 0, esz);
 
-	while (len > 0) {
+	while (true) {
 		int next_offset;
 		size_t byte_offset;
 
@@ -1848,6 +1848,9 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 			return next_offset;
 
 		byte_offset = next_offset * esz;
+		if (byte_offset >= len)
+			break;
+
 		id += next_offset;
 		gpa += byte_offset;
 		len -= byte_offset;
