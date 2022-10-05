Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11B95F5191
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 11:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiJEJKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 05:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiJEJJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 05:09:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0924077562;
        Wed,  5 Oct 2022 02:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DD9AB81D48;
        Wed,  5 Oct 2022 09:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885B3C433B5;
        Wed,  5 Oct 2022 09:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664960915;
        bh=aYf7Wh7/VXHlwqw91kdfmUmijTY8Wqcb4/UogvAP3ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+v0T/BNlgp1i9KARp7h0SiM1jA3Xy/PVDq5eXl65WIkzoS0+/PnjtmwgUomH6LeW
         u47cKT6ENx9J4NSnWZqr5irN9hOF7xQHuq5BrQ84xtDHbuqut+he/iyQc7vtDpUBPm
         FS8iR6Pm9tiEpIUrhIMJXtoAuNqRLNM4QX2WSzeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.72
Date:   Wed,  5 Oct 2022 11:08:24 +0200
Message-Id: <166496090391124@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166496090322122@kroah.com>
References: <166496090322122@kroah.com>
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
index 4c06cbe89ece..19c18204d165 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 71
+SUBLEVEL = 72
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/am33xx-l4.dtsi b/arch/arm/boot/dts/am33xx-l4.dtsi
index c9629cb5ccd1..9a750883b987 100644
--- a/arch/arm/boot/dts/am33xx-l4.dtsi
+++ b/arch/arm/boot/dts/am33xx-l4.dtsi
@@ -1500,8 +1500,7 @@ SYSC_OMAP2_SOFTRESET |
 			mmc1: mmc@0 {
 				compatible = "ti,am335-sdhci";
 				ti,needs-special-reset;
-				dmas = <&edma_xbar 24 0 0
-					&edma_xbar 25 0 0>;
+				dmas = <&edma 24 0>, <&edma 25 0>;
 				dma-names = "tx", "rx";
 				interrupts = <64>;
 				reg = <0x0 0x1000>;
diff --git a/arch/arm/boot/dts/am5748.dtsi b/arch/arm/boot/dts/am5748.dtsi
index c260aa1a85bd..a1f029e9d1f3 100644
--- a/arch/arm/boot/dts/am5748.dtsi
+++ b/arch/arm/boot/dts/am5748.dtsi
@@ -25,6 +25,10 @@ &usb3_tm {
 	status = "disabled";
 };
 
+&usb4_tm {
+	status = "disabled";
+};
+
 &atl_tm {
 	status = "disabled";
 };
diff --git a/arch/arm/boot/dts/integratorap.dts b/arch/arm/boot/dts/integratorap.dts
index 67d1f9b24a52..8600c0548525 100644
--- a/arch/arm/boot/dts/integratorap.dts
+++ b/arch/arm/boot/dts/integratorap.dts
@@ -153,6 +153,7 @@ pic: pic@14000000 {
 
 	pci: pciv3@62000000 {
 		compatible = "arm,integrator-ap-pci", "v3,v360epc-pci";
+		device_type = "pci";
 		#interrupt-cells = <1>;
 		#size-cells = <2>;
 		#address-cells = <3>;
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 9ffb7355850c..c0a3ea47302f 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1109,7 +1109,7 @@ ufs_mem_hc: ufshc@1d84000 {
 
 		ufs_mem_phy: phy@1d87000 {
 			compatible = "qcom,sm8350-qmp-ufs-phy";
-			reg = <0 0x01d87000 0 0xe10>;
+			reg = <0 0x01d87000 0 0x1c4>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			#clock-cells = <1>;
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 98a8b59f87f3..43dd7f281a21 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1200,22 +1200,23 @@ struct bp_patching_desc {
 	atomic_t refs;
 };
 
-static struct bp_patching_desc *bp_desc;
+static struct bp_patching_desc bp_desc;
 
 static __always_inline
-struct bp_patching_desc *try_get_desc(struct bp_patching_desc **descp)
+struct bp_patching_desc *try_get_desc(void)
 {
-	/* rcu_dereference */
-	struct bp_patching_desc *desc = __READ_ONCE(*descp);
+	struct bp_patching_desc *desc = &bp_desc;
 
-	if (!desc || !arch_atomic_inc_not_zero(&desc->refs))
+	if (!arch_atomic_inc_not_zero(&desc->refs))
 		return NULL;
 
 	return desc;
 }
 
-static __always_inline void put_desc(struct bp_patching_desc *desc)
+static __always_inline void put_desc(void)
 {
+	struct bp_patching_desc *desc = &bp_desc;
+
 	smp_mb__before_atomic();
 	arch_atomic_dec(&desc->refs);
 }
@@ -1248,15 +1249,15 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 
 	/*
 	 * Having observed our INT3 instruction, we now must observe
-	 * bp_desc:
+	 * bp_desc with non-zero refcount:
 	 *
-	 *	bp_desc = desc			INT3
+	 *	bp_desc.refs = 1		INT3
 	 *	WMB				RMB
-	 *	write INT3			if (desc)
+	 *	write INT3			if (bp_desc.refs != 0)
 	 */
 	smp_rmb();
 
-	desc = try_get_desc(&bp_desc);
+	desc = try_get_desc();
 	if (!desc)
 		return 0;
 
@@ -1310,7 +1311,7 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 	ret = 1;
 
 out_put:
-	put_desc(desc);
+	put_desc();
 	return ret;
 }
 
@@ -1341,18 +1342,20 @@ static int tp_vec_nr;
  */
 static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries)
 {
-	struct bp_patching_desc desc = {
-		.vec = tp,
-		.nr_entries = nr_entries,
-		.refs = ATOMIC_INIT(1),
-	};
 	unsigned char int3 = INT3_INSN_OPCODE;
 	unsigned int i;
 	int do_sync;
 
 	lockdep_assert_held(&text_mutex);
 
-	smp_store_release(&bp_desc, &desc); /* rcu_assign_pointer */
+	bp_desc.vec = tp;
+	bp_desc.nr_entries = nr_entries;
+
+	/*
+	 * Corresponds to the implicit memory barrier in try_get_desc() to
+	 * ensure reading a non-zero refcount provides up to date bp_desc data.
+	 */
+	atomic_set_release(&bp_desc.refs, 1);
 
 	/*
 	 * Corresponding read barrier in int3 notifier for making sure the
@@ -1440,12 +1443,10 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 		text_poke_sync();
 
 	/*
-	 * Remove and synchronize_rcu(), except we have a very primitive
-	 * refcount based completion.
+	 * Remove and wait for refs to be zero.
 	 */
-	WRITE_ONCE(bp_desc, NULL); /* RCU_INIT_POINTER */
-	if (!atomic_dec_and_test(&desc.refs))
-		atomic_cond_read_acquire(&desc.refs, !VAL);
+	if (!atomic_dec_and_test(&bp_desc.refs))
+		atomic_cond_read_acquire(&bp_desc.refs, !VAL);
 }
 
 static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c93c9f9f8c7b..4ea48acf55fa 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -46,9 +46,13 @@ static LIST_HEAD(sgx_dirty_page_list);
  * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
  * from the input list, and made available for the page allocator. SECS pages
  * prepending their children in the input list are left intact.
+ *
+ * Return 0 when sanitization was successful or kthread was stopped, and the
+ * number of unsanitized pages otherwise.
  */
-static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
+static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
 {
+	unsigned long left_dirty = 0;
 	struct sgx_epc_page *page;
 	LIST_HEAD(dirty);
 	int ret;
@@ -56,7 +60,7 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 	/* dirty_page_list is thread-local, no need for a lock: */
 	while (!list_empty(dirty_page_list)) {
 		if (kthread_should_stop())
-			return;
+			return 0;
 
 		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
@@ -71,12 +75,14 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 		} else {
 			/* The page is not yet clean - move to the dirty list. */
 			list_move_tail(&page->list, &dirty);
+			left_dirty++;
 		}
 
 		cond_resched();
 	}
 
 	list_splice(&dirty, dirty_page_list);
+	return left_dirty;
 }
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
@@ -427,10 +433,7 @@ static int ksgxd(void *p)
 	 * required for SECS pages, whose child pages blocked EREMOVE.
 	 */
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
-	__sgx_sanitize_pages(&sgx_dirty_page_list);
-
-	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	WARN_ON(__sgx_sanitize_pages(&sgx_dirty_page_list));
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b17c9b00669e..d85a0808a446 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -718,8 +718,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
-	case 9:
-		break;
 	case 0xa: { /* Architectural Performance Monitoring */
 		struct x86_pmu_capability cap;
 		union cpuid10_eax eax;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 413faa9330b2..4d308e3163c3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3961,6 +3961,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
+	/* These specific Pioneer models have LPM issues */
+	{ "PIONEER BD-RW   BDR-207M",	NULL,	ATA_HORKAGE_NOLPM },
+	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
+
 	/* Crucial BX100 SSD 500GB has broken LPM support */
 	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
 
diff --git a/drivers/clk/bcm/clk-iproc-pll.c b/drivers/clk/bcm/clk-iproc-pll.c
index 33da30f99c79..d39c44b61c52 100644
--- a/drivers/clk/bcm/clk-iproc-pll.c
+++ b/drivers/clk/bcm/clk-iproc-pll.c
@@ -736,6 +736,7 @@ void iproc_pll_clk_setup(struct device_node *node,
 	const char *parent_name;
 	struct iproc_clk *iclk_array;
 	struct clk_hw_onecell_data *clk_data;
+	const char *clk_name;
 
 	if (WARN_ON(!pll_ctrl) || WARN_ON(!clk_ctrl))
 		return;
@@ -783,7 +784,12 @@ void iproc_pll_clk_setup(struct device_node *node,
 	iclk = &iclk_array[0];
 	iclk->pll = pll;
 
-	init.name = node->name;
+	ret = of_property_read_string_index(node, "clock-output-names",
+					    0, &clk_name);
+	if (WARN_ON(ret))
+		goto err_pll_register;
+
+	init.name = clk_name;
 	init.ops = &iproc_pll_ops;
 	init.flags = 0;
 	parent_name = of_clk_get_parent_name(node, 0);
@@ -803,13 +809,11 @@ void iproc_pll_clk_setup(struct device_node *node,
 		goto err_pll_register;
 
 	clk_data->hws[0] = &iclk->hw;
+	parent_name = clk_name;
 
 	/* now initialize and register all leaf clocks */
 	for (i = 1; i < num_clks; i++) {
-		const char *clk_name;
-
 		memset(&init, 0, sizeof(init));
-		parent_name = node->name;
 
 		ret = of_property_read_string_index(node, "clock-output-names",
 						    i, &clk_name);
diff --git a/drivers/clk/imx/clk-imx6sx.c b/drivers/clk/imx/clk-imx6sx.c
index fc1bd23d4583..598f3cf4eba4 100644
--- a/drivers/clk/imx/clk-imx6sx.c
+++ b/drivers/clk/imx/clk-imx6sx.c
@@ -280,13 +280,13 @@ static void __init imx6sx_clocks_init(struct device_node *ccm_node)
 	hws[IMX6SX_CLK_SSI3_SEL]           = imx_clk_hw_mux("ssi3_sel",         base + 0x1c,  14,     2,      ssi_sels,          ARRAY_SIZE(ssi_sels));
 	hws[IMX6SX_CLK_SSI2_SEL]           = imx_clk_hw_mux("ssi2_sel",         base + 0x1c,  12,     2,      ssi_sels,          ARRAY_SIZE(ssi_sels));
 	hws[IMX6SX_CLK_SSI1_SEL]           = imx_clk_hw_mux("ssi1_sel",         base + 0x1c,  10,     2,      ssi_sels,          ARRAY_SIZE(ssi_sels));
-	hws[IMX6SX_CLK_QSPI1_SEL]          = imx_clk_hw_mux_flags("qspi1_sel", base + 0x1c,  7, 3, qspi1_sels, ARRAY_SIZE(qspi1_sels), CLK_SET_RATE_PARENT);
+	hws[IMX6SX_CLK_QSPI1_SEL]          = imx_clk_hw_mux("qspi1_sel",        base + 0x1c,  7,      3,      qspi1_sels,        ARRAY_SIZE(qspi1_sels));
 	hws[IMX6SX_CLK_PERCLK_SEL]         = imx_clk_hw_mux("perclk_sel",       base + 0x1c,  6,      1,      perclk_sels,       ARRAY_SIZE(perclk_sels));
 	hws[IMX6SX_CLK_VID_SEL]            = imx_clk_hw_mux("vid_sel",          base + 0x20,  21,     3,      vid_sels,          ARRAY_SIZE(vid_sels));
 	hws[IMX6SX_CLK_ESAI_SEL]           = imx_clk_hw_mux("esai_sel",         base + 0x20,  19,     2,      audio_sels,        ARRAY_SIZE(audio_sels));
 	hws[IMX6SX_CLK_CAN_SEL]            = imx_clk_hw_mux("can_sel",          base + 0x20,  8,      2,      can_sels,          ARRAY_SIZE(can_sels));
 	hws[IMX6SX_CLK_UART_SEL]           = imx_clk_hw_mux("uart_sel",         base + 0x24,  6,      1,      uart_sels,         ARRAY_SIZE(uart_sels));
-	hws[IMX6SX_CLK_QSPI2_SEL]          = imx_clk_hw_mux_flags("qspi2_sel", base + 0x2c, 15, 3, qspi2_sels, ARRAY_SIZE(qspi2_sels), CLK_SET_RATE_PARENT);
+	hws[IMX6SX_CLK_QSPI2_SEL]          = imx_clk_hw_mux("qspi2_sel",        base + 0x2c,  15,     3,      qspi2_sels,        ARRAY_SIZE(qspi2_sels));
 	hws[IMX6SX_CLK_SPDIF_SEL]          = imx_clk_hw_mux("spdif_sel",        base + 0x30,  20,     2,      audio_sels,        ARRAY_SIZE(audio_sels));
 	hws[IMX6SX_CLK_AUDIO_SEL]          = imx_clk_hw_mux("audio_sel",        base + 0x30,  7,      2,      audio_sels,        ARRAY_SIZE(audio_sels));
 	hws[IMX6SX_CLK_ENET_PRE_SEL]       = imx_clk_hw_mux("enet_pre_sel",     base + 0x34,  15,     3,      enet_pre_sels,     ARRAY_SIZE(enet_pre_sels));
diff --git a/drivers/clk/ingenic/tcu.c b/drivers/clk/ingenic/tcu.c
index 77acfbeb4830..11fc39561836 100644
--- a/drivers/clk/ingenic/tcu.c
+++ b/drivers/clk/ingenic/tcu.c
@@ -100,15 +100,11 @@ static bool ingenic_tcu_enable_regs(struct clk_hw *hw)
 	bool enabled = false;
 
 	/*
-	 * If the SoC has no global TCU clock, we must ungate the channel's
-	 * clock to be able to access its registers.
-	 * If we have a TCU clock, it will be enabled automatically as it has
-	 * been attached to the regmap.
+	 * According to the programming manual, a timer channel's registers can
+	 * only be accessed when the channel's stop bit is clear.
 	 */
-	if (!tcu->clk) {
-		enabled = !!ingenic_tcu_is_enabled(hw);
-		regmap_write(tcu->map, TCU_REG_TSCR, BIT(info->gate_bit));
-	}
+	enabled = !!ingenic_tcu_is_enabled(hw);
+	regmap_write(tcu->map, TCU_REG_TSCR, BIT(info->gate_bit));
 
 	return enabled;
 }
@@ -119,8 +115,7 @@ static void ingenic_tcu_disable_regs(struct clk_hw *hw)
 	const struct ingenic_tcu_clk_info *info = tcu_clk->info;
 	struct ingenic_tcu *tcu = tcu_clk->tcu;
 
-	if (!tcu->clk)
-		regmap_write(tcu->map, TCU_REG_TSSR, BIT(info->gate_bit));
+	regmap_write(tcu->map, TCU_REG_TSSR, BIT(info->gate_bit));
 }
 
 static u8 ingenic_tcu_get_parent(struct clk_hw *hw)
diff --git a/drivers/firmware/arm_scmi/scmi_pm_domain.c b/drivers/firmware/arm_scmi/scmi_pm_domain.c
index 581d34c95769..d5dee625de78 100644
--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -8,7 +8,6 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
-#include <linux/pm_clock.h>
 #include <linux/pm_domain.h>
 #include <linux/scmi_protocol.h>
 
@@ -53,27 +52,6 @@ static int scmi_pd_power_off(struct generic_pm_domain *domain)
 	return scmi_pd_power(domain, false);
 }
 
-static int scmi_pd_attach_dev(struct generic_pm_domain *pd, struct device *dev)
-{
-	int ret;
-
-	ret = pm_clk_create(dev);
-	if (ret)
-		return ret;
-
-	ret = of_pm_clk_add_clks(dev);
-	if (ret >= 0)
-		return 0;
-
-	pm_clk_destroy(dev);
-	return ret;
-}
-
-static void scmi_pd_detach_dev(struct generic_pm_domain *pd, struct device *dev)
-{
-	pm_clk_destroy(dev);
-}
-
 static int scmi_pm_domain_probe(struct scmi_device *sdev)
 {
 	int num_domains, i;
@@ -124,10 +102,6 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
 		scmi_pd->genpd.name = scmi_pd->name;
 		scmi_pd->genpd.power_off = scmi_pd_power_off;
 		scmi_pd->genpd.power_on = scmi_pd_power_on;
-		scmi_pd->genpd.attach_dev = scmi_pd_attach_dev;
-		scmi_pd->genpd.detach_dev = scmi_pd_detach_dev;
-		scmi_pd->genpd.flags = GENPD_FLAG_PM_CLK |
-				       GENPD_FLAG_ACTIVE_WAKEUP;
 
 		pm_genpd_init(&scmi_pd->genpd, NULL,
 			      state == SCMI_POWER_STATE_GENERIC_OFF);
diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 1448dc874dfc..a245bfd5a617 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -793,8 +793,12 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 	u32 offset;
 	u32 set;
 
-	if (of_device_is_compatible(mvchip->chip.of_node,
-				    "marvell,armada-370-gpio")) {
+	if (mvchip->soc_variant == MVEBU_GPIO_SOC_VARIANT_A8K) {
+		int ret = of_property_read_u32(dev->of_node,
+					       "marvell,pwm-offset", &offset);
+		if (ret < 0)
+			return 0;
+	} else {
 		/*
 		 * There are only two sets of PWM configuration registers for
 		 * all the GPIO lines on those SoCs which this driver reserves
@@ -804,13 +808,6 @@ static int mvebu_pwm_probe(struct platform_device *pdev,
 		if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "pwm"))
 			return 0;
 		offset = 0;
-	} else if (mvchip->soc_variant == MVEBU_GPIO_SOC_VARIANT_A8K) {
-		int ret = of_property_read_u32(dev->of_node,
-					       "marvell,pwm-offset", &offset);
-		if (ret < 0)
-			return 0;
-	} else {
-		return 0;
 	}
 
 	if (IS_ERR(mvchip->clk))
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 98ac53ee6bb5..6cded09d5878 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1056,6 +1056,10 @@ bool amdgpu_acpi_should_gpu_reset(struct amdgpu_device *adev)
 {
 	if (adev->flags & AMD_IS_APU)
 		return false;
+
+	if (amdgpu_sriov_vf(adev))
+		return false;
+
 	return pm_suspend_target_state != PM_SUSPEND_TO_IDLE;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 0e3137fd5c35..ac4dabcde33f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3137,7 +3137,8 @@ static int amdgpu_device_ip_resume_phase1(struct amdgpu_device *adev)
 			continue;
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC ||
-		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_IH) {
+		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_IH ||
+		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP && amdgpu_sriov_vf(adev))) {
 
 			r = adev->ip_blocks[i].version->funcs->resume(adev);
 			if (r) {
@@ -4001,12 +4002,20 @@ static void amdgpu_device_evict_resources(struct amdgpu_device *adev)
 int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	int r = 0;
 
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
 	adev->in_suspend = true;
 
+	if (amdgpu_sriov_vf(adev)) {
+		amdgpu_virt_fini_data_exchange(adev);
+		r = amdgpu_virt_request_full_gpu(adev, false);
+		if (r)
+			return r;
+	}
+
 	if (amdgpu_acpi_smart_shift_update(dev, AMDGPU_SS_DEV_D3))
 		DRM_WARN("smart shift update failed\n");
 
@@ -4035,6 +4044,9 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 	 */
 	amdgpu_device_evict_resources(adev);
 
+	if (amdgpu_sriov_vf(adev))
+		amdgpu_virt_release_full_gpu(adev, false);
+
 	return 0;
 }
 
@@ -4053,6 +4065,12 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	int r = 0;
 
+	if (amdgpu_sriov_vf(adev)) {
+		r = amdgpu_virt_request_full_gpu(adev, true);
+		if (r)
+			return r;
+	}
+
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
@@ -4067,6 +4085,13 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 	}
 
 	r = amdgpu_device_ip_resume(adev);
+
+	/* no matter what r is, always need to properly release full GPU */
+	if (amdgpu_sriov_vf(adev)) {
+		amdgpu_virt_init_data_exchange(adev);
+		amdgpu_virt_release_full_gpu(adev, true);
+	}
+
 	if (r) {
 		dev_err(adev->dev, "amdgpu_device_ip_resume failed (%d).\n", r);
 		return r;
diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 873cf6882bd3..f0305f833b6c 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1860,12 +1860,6 @@ EXPORT_SYMBOL_GPL(analogix_dp_remove);
 int analogix_dp_suspend(struct analogix_dp_device *dp)
 {
 	clk_disable_unprepare(dp->clock);
-
-	if (dp->plat_data->panel) {
-		if (drm_panel_unprepare(dp->plat_data->panel))
-			DRM_ERROR("failed to turnoff the panel\n");
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_suspend);
@@ -1880,13 +1874,6 @@ int analogix_dp_resume(struct analogix_dp_device *dp)
 		return ret;
 	}
 
-	if (dp->plat_data->panel) {
-		if (drm_panel_prepare(dp->plat_data->panel)) {
-			DRM_ERROR("failed to setup the panel\n");
-			return -EBUSY;
-		}
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_resume);
diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 1b0c7eaf6c84..82169b6bfca1 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -186,7 +186,7 @@ static int lt8912_write_lvds_config(struct lt8912 *lt)
 		{0x03, 0xff},
 	};
 
-	return regmap_multi_reg_write(lt->regmap[I2C_CEC_DSI], seq, ARRAY_SIZE(seq));
+	return regmap_multi_reg_write(lt->regmap[I2C_MAIN], seq, ARRAY_SIZE(seq));
 };
 
 static inline struct lt8912 *bridge_to_lt8912(struct drm_bridge *b)
@@ -266,7 +266,7 @@ static int lt8912_video_setup(struct lt8912 *lt)
 	u32 hactive, h_total, hpw, hfp, hbp;
 	u32 vactive, v_total, vpw, vfp, vbp;
 	u8 settle = 0x08;
-	int ret;
+	int ret, hsync_activehigh, vsync_activehigh;
 
 	if (!lt)
 		return -EINVAL;
@@ -276,12 +276,14 @@ static int lt8912_video_setup(struct lt8912 *lt)
 	hpw = lt->mode.hsync_len;
 	hbp = lt->mode.hback_porch;
 	h_total = hactive + hfp + hpw + hbp;
+	hsync_activehigh = lt->mode.flags & DISPLAY_FLAGS_HSYNC_HIGH;
 
 	vactive = lt->mode.vactive;
 	vfp = lt->mode.vfront_porch;
 	vpw = lt->mode.vsync_len;
 	vbp = lt->mode.vback_porch;
 	v_total = vactive + vfp + vpw + vbp;
+	vsync_activehigh = lt->mode.flags & DISPLAY_FLAGS_VSYNC_HIGH;
 
 	if (vactive <= 600)
 		settle = 0x04;
@@ -315,6 +317,13 @@ static int lt8912_video_setup(struct lt8912 *lt)
 	ret |= regmap_write(lt->regmap[I2C_CEC_DSI], 0x3e, hfp & 0xff);
 	ret |= regmap_write(lt->regmap[I2C_CEC_DSI], 0x3f, hfp >> 8);
 
+	ret |= regmap_update_bits(lt->regmap[I2C_MAIN], 0xab, BIT(0),
+				  vsync_activehigh ? BIT(0) : 0);
+	ret |= regmap_update_bits(lt->regmap[I2C_MAIN], 0xab, BIT(1),
+				  hsync_activehigh ? BIT(1) : 0);
+	ret |= regmap_update_bits(lt->regmap[I2C_MAIN], 0xb2, BIT(0),
+				  lt->connector.display_info.is_hdmi ? BIT(0) : 0);
+
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index ba2e037a82e4..60f6a731f1bf 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -997,6 +997,10 @@ void i915_gem_context_release(struct kref *ref)
 	trace_i915_context_free(ctx);
 	GEM_BUG_ON(!i915_gem_context_is_closed(ctx));
 
+	spin_lock(&ctx->i915->gem.contexts.lock);
+	list_del(&ctx->link);
+	spin_unlock(&ctx->i915->gem.contexts.lock);
+
 	if (ctx->syncobj)
 		drm_syncobj_put(ctx->syncobj);
 
@@ -1228,10 +1232,6 @@ static void context_close(struct i915_gem_context *ctx)
 	 */
 	lut_close(ctx);
 
-	spin_lock(&ctx->i915->gem.contexts.lock);
-	list_del(&ctx->link);
-	spin_unlock(&ctx->i915->gem.contexts.lock);
-
 	mutex_unlock(&ctx->mutex);
 
 	/*
diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index adc44c9fac6d..bf5aeb97a458 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -143,6 +143,21 @@ struct intel_engine_execlists {
 	 */
 	struct timer_list preempt;
 
+	/**
+	 * @preempt_target: active request at the time of the preemption request
+	 *
+	 * We force a preemption to occur if the pending contexts have not
+	 * been promoted to active upon receipt of the CS ack event within
+	 * the timeout. This timeout maybe chosen based on the target,
+	 * using a very short timeout if the context is no longer schedulable.
+	 * That short timeout may not be applicable to other contexts, so
+	 * if a context switch should happen within before the preemption
+	 * timeout, we may shoot early at an innocent context. To prevent this,
+	 * we record which context was active at the time of the preemption
+	 * request and only reset that context upon the timeout.
+	 */
+	const struct i915_request *preempt_target;
+
 	/**
 	 * @ccid: identifier for contexts submitted to this engine
 	 */
diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 416f5e0657f0..773ff5121833 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -1225,6 +1225,9 @@ static unsigned long active_preempt_timeout(struct intel_engine_cs *engine,
 	if (!rq)
 		return 0;
 
+	/* Only allow ourselves to force reset the currently active context */
+	engine->execlists.preempt_target = rq;
+
 	/* Force a fast reset for terminated contexts (ignoring sysfs!) */
 	if (unlikely(intel_context_is_banned(rq->context) || bad_request(rq)))
 		return 1;
@@ -2401,8 +2404,24 @@ static void execlists_submission_tasklet(struct tasklet_struct *t)
 	GEM_BUG_ON(inactive - post > ARRAY_SIZE(post));
 
 	if (unlikely(preempt_timeout(engine))) {
+		const struct i915_request *rq = *engine->execlists.active;
+
+		/*
+		 * If after the preempt-timeout expired, we are still on the
+		 * same active request/context as before we initiated the
+		 * preemption, reset the engine.
+		 *
+		 * However, if we have processed a CS event to switch contexts,
+		 * but not yet processed the CS event for the pending
+		 * preemption, reset the timer allowing the new context to
+		 * gracefully exit.
+		 */
 		cancel_timer(&engine->execlists.preempt);
-		engine->execlists.error_interrupt |= ERROR_PREEMPT;
+		if (rq == engine->execlists.preempt_target)
+			engine->execlists.error_interrupt |= ERROR_PREEMPT;
+		else
+			set_timer_ms(&engine->execlists.preempt,
+				     active_preempt_timeout(engine, rq));
 	}
 
 	if (unlikely(READ_ONCE(engine->execlists.error_interrupt))) {
diff --git a/drivers/input/keyboard/snvs_pwrkey.c b/drivers/input/keyboard/snvs_pwrkey.c
index 65286762b02a..ad8660be0127 100644
--- a/drivers/input/keyboard/snvs_pwrkey.c
+++ b/drivers/input/keyboard/snvs_pwrkey.c
@@ -20,7 +20,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 
-#define SNVS_HPVIDR1_REG	0xF8
+#define SNVS_HPVIDR1_REG	0xBF8
 #define SNVS_LPSR_REG		0x4C	/* LP Status Register */
 #define SNVS_LPCR_REG		0x38	/* LP Control Register */
 #define SNVS_HPSR_REG		0x14
diff --git a/drivers/input/touchscreen/melfas_mip4.c b/drivers/input/touchscreen/melfas_mip4.c
index 2745bf1aee38..83f4be05e27b 100644
--- a/drivers/input/touchscreen/melfas_mip4.c
+++ b/drivers/input/touchscreen/melfas_mip4.c
@@ -1453,7 +1453,7 @@ static int mip4_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					      "ce", GPIOD_OUT_LOW);
 	if (IS_ERR(ts->gpio_ce)) {
 		error = PTR_ERR(ts->gpio_ce);
-		if (error != EPROBE_DEFER)
+		if (error != -EPROBE_DEFER)
 			dev_err(&client->dev,
 				"Failed to get gpio: %d\n", error);
 		return error;
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 6974f1731529..1331f2c2237e 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -358,6 +358,12 @@ int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req)
 
 int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
+	struct vb2_queue *q = &ctx->vb_q;
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "[%s] buffer index out of range\n", ctx->name);
+		return -EINVAL;
+	}
 	vb2_core_querybuf(&ctx->vb_q, b->index, b);
 	dprintk(3, "[%s] index=%d\n", ctx->name, b->index);
 	return 0;
@@ -382,8 +388,13 @@ int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp)
 
 int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
+	struct vb2_queue *q = &ctx->vb_q;
 	int ret;
 
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "[%s] buffer index out of range\n", ctx->name);
+		return -EINVAL;
+	}
 	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL);
 	if (ret) {
 		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 80aaf07b16f2..94037af1af2d 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1033,6 +1033,8 @@ int v4l2_compat_get_array_args(struct file *file, void *mbuf,
 {
 	int err = 0;
 
+	memset(mbuf, 0, array_size);
+
 	switch (cmd) {
 	case VIDIOC_G_FMT32:
 	case VIDIOC_S_FMT32:
diff --git a/drivers/mmc/host/mmc_hsq.c b/drivers/mmc/host/mmc_hsq.c
index a5e05ed0fda3..9d35453e7371 100644
--- a/drivers/mmc/host/mmc_hsq.c
+++ b/drivers/mmc/host/mmc_hsq.c
@@ -34,7 +34,7 @@ static void mmc_hsq_pump_requests(struct mmc_hsq *hsq)
 	spin_lock_irqsave(&hsq->lock, flags);
 
 	/* Make sure we are not already running a request now */
-	if (hsq->mrq) {
+	if (hsq->mrq || hsq->recovery_halt) {
 		spin_unlock_irqrestore(&hsq->lock, flags);
 		return;
 	}
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index b6eb75f4bbfc..dfc3ffd5b1f8 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -111,8 +111,8 @@
 #define CLK_DIV_MASK		0x7f
 
 /* REG_BUS_WIDTH */
-#define BUS_WIDTH_8		BIT(2)
-#define BUS_WIDTH_4		BIT(1)
+#define BUS_WIDTH_4_SUPPORT	BIT(3)
+#define BUS_WIDTH_4		BIT(2)
 #define BUS_WIDTH_1		BIT(0)
 
 #define MMC_VDD_360		23
@@ -524,9 +524,6 @@ static void moxart_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	case MMC_BUS_WIDTH_4:
 		writel(BUS_WIDTH_4, host->base + REG_BUS_WIDTH);
 		break;
-	case MMC_BUS_WIDTH_8:
-		writel(BUS_WIDTH_8, host->base + REG_BUS_WIDTH);
-		break;
 	default:
 		writel(BUS_WIDTH_1, host->base + REG_BUS_WIDTH);
 		break;
@@ -651,16 +648,8 @@ static int moxart_probe(struct platform_device *pdev)
 		dmaengine_slave_config(host->dma_chan_rx, &cfg);
 	}
 
-	switch ((readl(host->base + REG_BUS_WIDTH) >> 3) & 3) {
-	case 1:
+	if (readl(host->base + REG_BUS_WIDTH) & BUS_WIDTH_4_SUPPORT)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
-		break;
-	case 2:
-		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
-		break;
-	default:
-		break;
-	}
 
 	writel(0, host->base + REG_INTERRUPT_MASK);
 
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 08b6efa7a1a7..ae55eaca7b5e 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -236,9 +236,22 @@ static inline u8 c_can_get_tx_tail(const struct c_can_tx_ring *ring)
 	return ring->tail & (ring->obj_num - 1);
 }
 
-static inline u8 c_can_get_tx_free(const struct c_can_tx_ring *ring)
+static inline u8 c_can_get_tx_free(const struct c_can_priv *priv,
+				   const struct c_can_tx_ring *ring)
 {
-	return ring->obj_num - (ring->head - ring->tail);
+	u8 head = c_can_get_tx_head(ring);
+	u8 tail = c_can_get_tx_tail(ring);
+
+	if (priv->type == BOSCH_D_CAN)
+		return ring->obj_num - (ring->head - ring->tail);
+
+	/* This is not a FIFO. C/D_CAN sends out the buffers
+	 * prioritized. The lowest buffer number wins.
+	 */
+	if (head < tail)
+		return 0;
+
+	return ring->obj_num - head;
 }
 
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 52671d1ea17d..e04d4e7cc868 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -430,7 +430,7 @@ static void c_can_setup_receive_object(struct net_device *dev, int iface,
 static bool c_can_tx_busy(const struct c_can_priv *priv,
 			  const struct c_can_tx_ring *tx_ring)
 {
-	if (c_can_get_tx_free(tx_ring) > 0)
+	if (c_can_get_tx_free(priv, tx_ring) > 0)
 		return false;
 
 	netif_stop_queue(priv->dev);
@@ -438,7 +438,7 @@ static bool c_can_tx_busy(const struct c_can_priv *priv,
 	/* Memory barrier before checking tx_free (head and tail) */
 	smp_mb();
 
-	if (c_can_get_tx_free(tx_ring) == 0) {
+	if (c_can_get_tx_free(priv, tx_ring) == 0) {
 		netdev_dbg(priv->dev,
 			   "Stopping tx-queue (tx_head=0x%08x, tx_tail=0x%08x, len=%d).\n",
 			   tx_ring->head, tx_ring->tail,
@@ -466,7 +466,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 
 	idx = c_can_get_tx_head(tx_ring);
 	tx_ring->head++;
-	if (c_can_get_tx_free(tx_ring) == 0)
+	if (c_can_get_tx_free(priv, tx_ring) == 0)
 		netif_stop_queue(dev);
 
 	if (idx < c_can_get_tx_tail(tx_ring))
@@ -751,7 +751,7 @@ static void c_can_do_tx(struct net_device *dev)
 		return;
 
 	tx_ring->tail += pkts;
-	if (c_can_get_tx_free(tx_ring)) {
+	if (c_can_get_tx_free(priv, tx_ring)) {
 		/* Make sure that anybody stopping the queue after
 		 * this sees the new tx_ring->tail.
 		 */
@@ -764,8 +764,7 @@ static void c_can_do_tx(struct net_device *dev)
 	can_led_event(dev, CAN_LED_EVENT_TX);
 
 	tail = c_can_get_tx_tail(tx_ring);
-
-	if (tail == 0) {
+	if (priv->type == BOSCH_D_CAN && tail == 0) {
 		u8 head = c_can_get_tx_head(tx_ring);
 
 		/* Start transmission for all cached messages */
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index be5c9cca8084..704ba461a600 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -501,14 +501,19 @@ static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
 static int
 mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
-	struct mt7530_priv *priv = ds->priv;
+	return 0;
+}
+
+static void
+mt7531_pll_setup(struct mt7530_priv *priv)
+{
 	u32 top_sig;
 	u32 hwstrap;
 	u32 xtal;
 	u32 val;
 
 	if (mt7531_dual_sgmii_supported(priv))
-		return 0;
+		return;
 
 	val = mt7530_read(priv, MT7531_CREV);
 	top_sig = mt7530_read(priv, MT7531_TOP_SIG_SR);
@@ -587,8 +592,6 @@ mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 	val |= EN_COREPLL;
 	mt7530_write(priv, MT7531_PLLGP_EN, val);
 	usleep_range(25, 35);
-
-	return 0;
 }
 
 static void
@@ -2292,6 +2295,8 @@ mt7531_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7531_pll_setup(priv);
+
 	if (mt7531_dual_sgmii_supported(priv)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5_SGMII;
 
@@ -2867,8 +2872,6 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	case 6:
 		interface = PHY_INTERFACE_MODE_2500BASEX;
 
-		mt7531_pad_setup(ds, interface);
-
 		priv->p6_interface = interface;
 		break;
 	default:
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index a7f291c89702..557c591a6ce3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -14,6 +14,7 @@
 #include "cudbg_entity.h"
 #include "cudbg_lib.h"
 #include "cudbg_zlib.h"
+#include "cxgb4_tc_mqprio.h"
 
 static const u32 t6_tp_pio_array[][IREG_NUM_ELEM] = {
 	{0x7e40, 0x7e44, 0x020, 28}, /* t6_tp_pio_regs_20_to_3b */
@@ -3458,7 +3459,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < utxq->ntxq; i++)
 				QDESC_GET_TXQ(&utxq->uldtxq[i].q,
 					      cudbg_uld_txq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 	}
 
@@ -3475,7 +3476,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nrxq; i++)
 				QDESC_GET_RXQ(&urxq->uldrxq[i].rspq,
 					      cudbg_uld_rxq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 
 		/* ULD FLQ */
@@ -3487,7 +3488,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nrxq; i++)
 				QDESC_GET_FLQ(&urxq->uldrxq[i].fl,
 					      cudbg_uld_flq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 
 		/* ULD CIQ */
@@ -3500,29 +3501,34 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nciq; i++)
 				QDESC_GET_RXQ(&urxq->uldrxq[base + i].rspq,
 					      cudbg_uld_ciq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 	}
+	mutex_unlock(&uld_mutex);
+
+	if (!padap->tc_mqprio)
+		goto out;
 
+	mutex_lock(&padap->tc_mqprio->mqprio_mutex);
 	/* ETHOFLD TXQ */
 	if (s->eohw_txq)
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_TXQ(&s->eohw_txq[i].q,
-				      CUDBG_QTYPE_ETHOFLD_TXQ, out);
+				      CUDBG_QTYPE_ETHOFLD_TXQ, out_unlock_mqprio);
 
 	/* ETHOFLD RXQ and FLQ */
 	if (s->eohw_rxq) {
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_RXQ(&s->eohw_rxq[i].rspq,
-				      CUDBG_QTYPE_ETHOFLD_RXQ, out);
+				      CUDBG_QTYPE_ETHOFLD_RXQ, out_unlock_mqprio);
 
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_FLQ(&s->eohw_rxq[i].fl,
-				      CUDBG_QTYPE_ETHOFLD_FLQ, out);
+				      CUDBG_QTYPE_ETHOFLD_FLQ, out_unlock_mqprio);
 	}
 
-out_unlock:
-	mutex_unlock(&uld_mutex);
+out_unlock_mqprio:
+	mutex_unlock(&padap->tc_mqprio->mqprio_mutex);
 
 out:
 	qdesc_info->qdesc_entry_size = sizeof(*qdesc_entry);
@@ -3559,6 +3565,10 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 #undef QDESC_GET
 
 	return rc;
+
+out_unlock_uld:
+	mutex_unlock(&uld_mutex);
+	goto out;
 }
 
 int cudbg_collect_flash(struct cudbg_init *pdbg_init,
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index caa4380ada13..5819584345ab 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -244,8 +244,8 @@ int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 	}
 
 	priv->clk_io = devm_ioremap(dev, res->start, resource_size(res));
-	if (IS_ERR(priv->clk_io))
-		return PTR_ERR(priv->clk_io);
+	if (!priv->clk_io)
+		return -ENOMEM;
 
 	mlxbf_gige_mdio_cfg(priv);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2569673559df..6f579f498993 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3757,6 +3757,15 @@ static int stmmac_open(struct net_device *dev)
 		goto init_error;
 	}
 
+	if (priv->plat->serdes_powerup) {
+		ret = priv->plat->serdes_powerup(dev, priv->plat->bsp_priv);
+		if (ret < 0) {
+			netdev_err(priv->dev, "%s: Serdes powerup failed\n",
+				   __func__);
+			goto init_error;
+		}
+	}
+
 	ret = stmmac_hw_setup(dev, true);
 	if (ret < 0) {
 		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
@@ -3846,6 +3855,10 @@ static int stmmac_release(struct net_device *dev)
 	/* Disable the MAC Rx/Tx */
 	stmmac_mac_set(priv, priv->ioaddr, false);
 
+	/* Powerdown Serdes if there is */
+	if (priv->plat->serdes_powerdown)
+		priv->plat->serdes_powerdown(dev, priv->plat->bsp_priv);
+
 	netif_carrier_off(dev);
 
 	stmmac_release_ptp(priv);
@@ -7224,14 +7237,6 @@ int stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
-	if (priv->plat->serdes_powerup) {
-		ret = priv->plat->serdes_powerup(ndev,
-						 priv->plat->bsp_priv);
-
-		if (ret < 0)
-			goto error_serdes_powerup;
-	}
-
 #ifdef CONFIG_DEBUG_FS
 	stmmac_init_fs(ndev);
 #endif
@@ -7246,8 +7251,6 @@ int stmmac_dvr_probe(struct device *device,
 
 	return ret;
 
-error_serdes_powerup:
-	unregister_netdev(ndev);
 error_netdev_register:
 	phylink_destroy(priv->phylink);
 error_xpcs_setup:
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index b616f55ea222..c5b92ffaffb9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -315,11 +315,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
-	/* If we manged to get here with the PHY state machine in a state neither
-	 * PHY_HALTED nor PHY_READY this is an indication that something went wrong
-	 * and we should most likely be using MAC managed PM and we are not.
+	/* If we managed to get here with the PHY state machine in a state
+	 * neither PHY_HALTED, PHY_READY nor PHY_UP, this is an indication
+	 * that something went wrong and we should most likely be using
+	 * MAC managed PM, but we are not.
 	 */
-	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
+	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
+		phydev->state != PHY_UP);
 
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 15c90441285c..6bf5c75f519d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1393,6 +1393,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
+	{QMI_FIXED_INTF(0x413c, 0x81c2, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 5b7272fd25ee..e4fbb4d86606 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1599,6 +1599,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
 	struct net_device	*net;
+	struct urb		*urb;
 
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
@@ -1615,7 +1616,11 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
-	usb_scuttle_anchored_urbs(&dev->deferred);
+	while ((urb = usb_get_from_anchor(&dev->deferred))) {
+		dev_kfree_skb(urb->context);
+		kfree(urb->sg);
+		usb_free_urb(urb);
+	}
 
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind(dev, intf);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ed2740585c5d..76d8a72f52e2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2056,14 +2056,14 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 
 static int nvme_pr_clear(struct block_device *bdev, u64 key)
 {
-	u32 cdw10 = 1 | (key ? 1 << 3 : 0);
+	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 1 << 3 : 0);
+	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
 
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
diff --git a/drivers/reset/reset-imx7.c b/drivers/reset/reset-imx7.c
index 185a333df66c..d2408725eb2c 100644
--- a/drivers/reset/reset-imx7.c
+++ b/drivers/reset/reset-imx7.c
@@ -329,6 +329,7 @@ static int imx8mp_reset_set(struct reset_controller_dev *rcdev,
 		break;
 
 	case IMX8MP_RESET_PCIE_CTRL_APPS_EN:
+	case IMX8MP_RESET_PCIEPHY_PERST:
 		value = assert ? 0 : bit;
 		break;
 	}
diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 42833e33a96c..09754cd1d57d 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -78,8 +78,8 @@ static struct sunxi_sram_desc sun4i_a10_sram_d = {
 
 static struct sunxi_sram_desc sun50i_a64_sram_c = {
 	.data	= SUNXI_SRAM_DATA("C", 0x4, 24, 1,
-				  SUNXI_SRAM_MAP(0, 1, "cpu"),
-				  SUNXI_SRAM_MAP(1, 0, "de2")),
+				  SUNXI_SRAM_MAP(1, 0, "cpu"),
+				  SUNXI_SRAM_MAP(0, 1, "de2")),
 };
 
 static const struct of_device_id sunxi_sram_dt_ids[] = {
@@ -254,6 +254,7 @@ int sunxi_sram_claim(struct device *dev)
 	writel(val | ((device << sram_data->offset) & mask),
 	       base + sram_data->reg);
 
+	sram_desc->claimed = true;
 	spin_unlock(&sram_lock);
 
 	return 0;
@@ -329,12 +330,11 @@ static struct regmap_config sunxi_sram_emac_clock_regmap = {
 	.writeable_reg	= sunxi_sram_regmap_accessible_reg,
 };
 
-static int sunxi_sram_probe(struct platform_device *pdev)
+static int __init sunxi_sram_probe(struct platform_device *pdev)
 {
-	struct resource *res;
-	struct dentry *d;
 	struct regmap *emac_clock;
 	const struct sunxi_sramc_variant *variant;
+	struct device *dev = &pdev->dev;
 
 	sram_dev = &pdev->dev;
 
@@ -342,18 +342,10 @@ static int sunxi_sram_probe(struct platform_device *pdev)
 	if (!variant)
 		return -EINVAL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
-
-	d = debugfs_create_file("sram", S_IRUGO, NULL, NULL,
-				&sunxi_sram_fops);
-	if (!d)
-		return -ENOMEM;
-
 	if (variant->num_emac_clocks > 0) {
 		emac_clock = devm_regmap_init_mmio(&pdev->dev, base,
 						   &sunxi_sram_emac_clock_regmap);
@@ -362,6 +354,10 @@ static int sunxi_sram_probe(struct platform_device *pdev)
 			return PTR_ERR(emac_clock);
 	}
 
+	of_platform_populate(dev->of_node, NULL, NULL, dev);
+
+	debugfs_create_file("sram", 0444, NULL, NULL, &sunxi_sram_fops);
+
 	return 0;
 }
 
@@ -411,9 +407,8 @@ static struct platform_driver sunxi_sram_driver = {
 		.name		= "sunxi-sram",
 		.of_match_table	= sunxi_sram_dt_match,
 	},
-	.probe	= sunxi_sram_probe,
 };
-module_platform_driver(sunxi_sram_driver);
+builtin_platform_driver_probe(sunxi_sram_driver, sunxi_sram_probe);
 
 MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com>");
 MODULE_DESCRIPTION("Allwinner sunXi SRAM Controller Driver");
diff --git a/drivers/staging/media/rkvdec/rkvdec-h264.c b/drivers/staging/media/rkvdec/rkvdec-h264.c
index 22b4bf9e9ef4..438252fa1944 100644
--- a/drivers/staging/media/rkvdec/rkvdec-h264.c
+++ b/drivers/staging/media/rkvdec/rkvdec-h264.c
@@ -1124,8 +1124,8 @@ static int rkvdec_h264_run(struct rkvdec_ctx *ctx)
 
 	schedule_delayed_work(&rkvdec->watchdog_work, msecs_to_jiffies(2000));
 
-	writel(0xffffffff, rkvdec->regs + RKVDEC_REG_STRMD_ERR_EN);
-	writel(0xffffffff, rkvdec->regs + RKVDEC_REG_H264_ERR_E);
+	writel(0, rkvdec->regs + RKVDEC_REG_STRMD_ERR_EN);
+	writel(0, rkvdec->regs + RKVDEC_REG_H264_ERR_E);
 	writel(1, rkvdec->regs + RKVDEC_REG_PREF_LUMA_CACHE_COMMAND);
 	writel(1, rkvdec->regs + RKVDEC_REG_PREF_CHR_CACHE_COMMAND);
 
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 3014146081c1..50a5b160ccde 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2281,6 +2281,7 @@ int tb_switch_configure(struct tb_switch *sw)
 		 * additional capabilities.
 		 */
 		sw->config.cmuv = USB4_VERSION_1_0;
+		sw->config.plug_events_delay = 0xa;
 
 		/* Enumerate the switch */
 		ret = tb_sw_write(sw, (u32 *)&sw->config + 1, TB_CFG_SWITCH,
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 23ab3b048d9b..251778d14e2d 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -52,6 +52,13 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x090c, 0x2000, 0x0000, 0x9999,
+		"Hiksemi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
@@ -76,6 +83,13 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
+		"Hiksemi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",
@@ -118,6 +132,13 @@ UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x17ef, 0x3899, 0x0000, 0x9999,
+		"Thinkplus",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VIA",
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 1f23eb543d8f..7363958ca165 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -515,8 +515,6 @@ static int ucsi_get_pdos(struct ucsi_connector *con, int is_partner,
 				num_pdos * sizeof(u32));
 	if (ret < 0)
 		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
-	if (ret == 0 && offset == 0)
-		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
 
 	return ret;
 }
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 7d41dfe48ade..5091ff9d6c93 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -327,7 +327,7 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / hw->nr_vring;
+	q_pair_id = qid / 2;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	last_avail_idx = ifc_ioread16(avail_idx_addr);
 
@@ -341,7 +341,7 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	u32 q_pair_id;
 
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-	q_pair_id = qid / hw->nr_vring;
+	q_pair_id = qid / 2;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	hw->vring[qid].last_avail_idx = num;
 	ifc_iowrite16(num, avail_idx_addr);
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 73e67fa88972..e7d2d5b7e125 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -655,10 +655,15 @@ static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned int offset,
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
 
-	if (offset > dev->config_size ||
-	    len > dev->config_size - offset)
+	/* Initialize the buffer in case of partial copy. */
+	memset(buf, 0, len);
+
+	if (offset > dev->config_size)
 		return;
 
+	if (len > dev->config_size - offset)
+		len = dev->config_size - offset;
+
 	memcpy(buf, dev->config + offset, len);
 }
 
diff --git a/fs/internal.h b/fs/internal.h
index cdd83d4899bb..4f1fe6d08866 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -195,3 +195,27 @@ long splice_file_to_pipe(struct file *in,
 			 struct pipe_inode_info *opipe,
 			 loff_t *offset,
 			 size_t len, unsigned int flags);
+
+/*
+ * fs/xattr.c:
+ */
+struct xattr_name {
+	char name[XATTR_NAME_MAX + 1];
+};
+
+struct xattr_ctx {
+	/* Value of attribute */
+	union {
+		const void __user *cvalue;
+		void __user *value;
+	};
+	void *kvalue;
+	size_t size;
+	/* Attribute name */
+	struct xattr_name *kname;
+	unsigned int flags;
+};
+
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		struct xattr_ctx *ctx);
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 0d7e948cb29c..7f69422d5191 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2092,7 +2092,8 @@ static bool load_system_files(ntfs_volume *vol)
 	// TODO: Initialize security.
 	/* Get the extended system files' directory inode. */
 	vol->extend_ino = ntfs_iget(sb, FILE_Extend);
-	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino)) {
+	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino) ||
+	    !S_ISDIR(vol->extend_ino->i_mode)) {
 		if (!IS_ERR(vol->extend_ino))
 			iput(vol->extend_ino);
 		ntfs_error(sb, "Failed to load $Extend.");
diff --git a/fs/xattr.c b/fs/xattr.c
index 998045165916..7117cb253864 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -25,6 +25,8 @@
 
 #include <linux/uaccess.h>
 
+#include "internal.h"
+
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
 {
@@ -539,44 +541,76 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
 /*
  * Extended attribute SET operations
  */
-static long
-setxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	 const char __user *name, const void __user *value, size_t size,
-	 int flags)
+
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
 {
 	int error;
-	void *kvalue = NULL;
-	char kname[XATTR_NAME_MAX + 1];
 
-	if (flags & ~(XATTR_CREATE|XATTR_REPLACE))
+	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
 		return -EINVAL;
 
-	error = strncpy_from_user(kname, name, sizeof(kname));
-	if (error == 0 || error == sizeof(kname))
-		error = -ERANGE;
+	error = strncpy_from_user(ctx->kname->name, name,
+				sizeof(ctx->kname->name));
+	if (error == 0 || error == sizeof(ctx->kname->name))
+		return  -ERANGE;
 	if (error < 0)
 		return error;
 
-	if (size) {
-		if (size > XATTR_SIZE_MAX)
+	error = 0;
+	if (ctx->size) {
+		if (ctx->size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = kvmalloc(size, GFP_KERNEL);
-		if (!kvalue)
-			return -ENOMEM;
-		if (copy_from_user(kvalue, value, size)) {
-			error = -EFAULT;
-			goto out;
+
+		ctx->kvalue = vmemdup_user(ctx->cvalue, ctx->size);
+		if (IS_ERR(ctx->kvalue)) {
+			error = PTR_ERR(ctx->kvalue);
+			ctx->kvalue = NULL;
 		}
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
-						      kvalue, size);
 	}
 
-	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
-out:
-	kvfree(kvalue);
+	return error;
+}
+
+static void setxattr_convert(struct user_namespace *mnt_userns,
+			     struct dentry *d, struct xattr_ctx *ctx)
+{
+	if (ctx->size &&
+		((strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
+		(strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)))
+		posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
+						ctx->kvalue, ctx->size);
+}
+
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		struct xattr_ctx *ctx)
+{
+	setxattr_convert(mnt_userns, dentry, ctx);
+	return vfs_setxattr(mnt_userns, dentry, ctx->kname->name,
+			ctx->kvalue, ctx->size, ctx->flags);
+}
+
+static long
+setxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	const char __user *name, const void __user *value, size_t size,
+	int flags)
+{
+	struct xattr_name kname;
+	struct xattr_ctx ctx = {
+		.cvalue   = value,
+		.kvalue   = NULL,
+		.size     = size,
+		.kname    = &kname,
+		.flags    = flags,
+	};
+	int error;
+
+	error = setxattr_copy(name, &ctx);
+	if (error)
+		return error;
+
+	error = do_setxattr(mnt_userns, d, &ctx);
 
+	kvfree(ctx.kvalue);
 	return error;
 }
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 75c3881af078..4b19f7fc4deb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6021,17 +6021,23 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	struct kernfs_node *kn;
 	struct cgroup *cgrp = NULL;
 
-	mutex_lock(&cgroup_mutex);
 	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
 	if (!kn)
-		goto out_unlock;
+		goto out;
+
+	if (kernfs_type(kn) != KERNFS_DIR)
+		goto put;
 
-	cgrp = kn->priv;
-	if (cgroup_is_dead(cgrp) || !cgroup_tryget(cgrp))
+	rcu_read_lock();
+
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
+	if (cgrp && !cgroup_tryget(cgrp))
 		cgrp = NULL;
+
+	rcu_read_unlock();
+put:
 	kernfs_put(kn);
-out_unlock:
-	mutex_unlock(&cgroup_mutex);
+out:
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_id);
@@ -6585,30 +6591,34 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
  *
  * Find the cgroup at @path on the default hierarchy, increment its
  * reference count and return it.  Returns pointer to the found cgroup on
- * success, ERR_PTR(-ENOENT) if @path doesn't exist and ERR_PTR(-ENOTDIR)
- * if @path points to a non-directory.
+ * success, ERR_PTR(-ENOENT) if @path doesn't exist or if the cgroup has already
+ * been released and ERR_PTR(-ENOTDIR) if @path points to a non-directory.
  */
 struct cgroup *cgroup_get_from_path(const char *path)
 {
 	struct kernfs_node *kn;
-	struct cgroup *cgrp;
-
-	mutex_lock(&cgroup_mutex);
+	struct cgroup *cgrp = ERR_PTR(-ENOENT);
 
 	kn = kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
-	if (kn) {
-		if (kernfs_type(kn) == KERNFS_DIR) {
-			cgrp = kn->priv;
-			cgroup_get_live(cgrp);
-		} else {
-			cgrp = ERR_PTR(-ENOTDIR);
-		}
-		kernfs_put(kn);
-	} else {
-		cgrp = ERR_PTR(-ENOENT);
+	if (!kn)
+		goto out;
+
+	if (kernfs_type(kn) != KERNFS_DIR) {
+		cgrp = ERR_PTR(-ENOTDIR);
+		goto out_kernfs;
 	}
 
-	mutex_unlock(&cgroup_mutex);
+	rcu_read_lock();
+
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
+	if (!cgrp || !cgroup_tryget(cgrp))
+		cgrp = ERR_PTR(-ENOENT);
+
+	rcu_read_unlock();
+
+out_kernfs:
+	kernfs_put(kn);
+out:
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_path);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 018f140aaaf4..a9849670bdb5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -709,7 +709,18 @@ dma_addr_t swiotlb_map(struct device *dev, phys_addr_t paddr, size_t size,
 
 size_t swiotlb_max_mapping_size(struct device *dev)
 {
-	return ((size_t)IO_TLB_SIZE) * IO_TLB_SEGSIZE;
+	int min_align_mask = dma_get_min_align_mask(dev);
+	int min_align = 0;
+
+	/*
+	 * swiotlb_find_slots() skips slots according to
+	 * min align mask. This affects max mapping size.
+	 * Take it into acount here.
+	 */
+	if (min_align_mask)
+		min_align = roundup(min_align_mask, IO_TLB_SIZE);
+
+	return ((size_t)IO_TLB_SIZE) * IO_TLB_SEGSIZE - min_align;
 }
 
 bool is_swiotlb_active(struct device *dev)
diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
index 70a5cb977ed0..e670fb6b1126 100644
--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -443,6 +443,7 @@ static int dbgfs_rm_context(char *name)
 	struct dentry *root, *dir, **new_dirs;
 	struct damon_ctx **new_ctxs;
 	int i, j;
+	int ret = 0;
 
 	if (damon_nr_running_ctxs())
 		return -EBUSY;
@@ -457,14 +458,16 @@ static int dbgfs_rm_context(char *name)
 
 	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
 			GFP_KERNEL);
-	if (!new_dirs)
-		return -ENOMEM;
+	if (!new_dirs) {
+		ret = -ENOMEM;
+		goto out_dput;
+	}
 
 	new_ctxs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_ctxs),
 			GFP_KERNEL);
 	if (!new_ctxs) {
-		kfree(new_dirs);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_new_dirs;
 	}
 
 	for (i = 0, j = 0; i < dbgfs_nr_ctxs; i++) {
@@ -484,7 +487,13 @@ static int dbgfs_rm_context(char *name)
 	dbgfs_ctxs = new_ctxs;
 	dbgfs_nr_ctxs--;
 
-	return 0;
+	goto out_dput;
+
+out_new_dirs:
+	kfree(new_dirs);
+out_dput:
+	dput(dir);
+	return ret;
 }
 
 static ssize_t dbgfs_rm_context_write(struct file *file,
diff --git a/mm/madvise.c b/mm/madvise.c
index 882767d58c27..6c099f8bb8e6 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -436,8 +436,11 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 		}
 
-		/* Do not interfere with other mappings of this page */
-		if (page_mapcount(page) != 1)
+		/*
+		 * Do not interfere with other mappings of this page and
+		 * non-LRU page.
+		 */
+		if (!PageLRU(page) || page_mapcount(page) != 1)
 			continue;
 
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c71135edd0a1..31db222b6deb 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -700,6 +700,9 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 	};
 	priv.tk.tsk = p;
 
+	if (!p->mm)
+		return -EFAULT;
+
 	mmap_read_lock(p->mm);
 	ret = walk_page_range(p->mm, 0, TASK_SIZE, &hwp_walk_ops,
 			      (void *)&priv);
diff --git a/mm/migrate.c b/mm/migrate.c
index afb944b600fe..7da052c6cf1e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2422,13 +2422,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = mpfn;
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
 
 	/* Only flush the TLB if we actually modified any entries */
 	if (unmapped)
 		flush_tlb_range(walk->vma, start, end);
 
+	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(ptep - 1, ptl);
+
 	return 0;
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 61d7967897ce..a71722b4e464 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4581,6 +4581,30 @@ void fs_reclaim_release(gfp_t gfp_mask)
 EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
 
+/*
+ * Zonelists may change due to hotplug during allocation. Detect when zonelists
+ * have been rebuilt so allocation retries. Reader side does not lock and
+ * retries the allocation if zonelist changes. Writer side is protected by the
+ * embedded spin_lock.
+ */
+static DEFINE_SEQLOCK(zonelist_update_seq);
+
+static unsigned int zonelist_iter_begin(void)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+		return read_seqbegin(&zonelist_update_seq);
+
+	return 0;
+}
+
+static unsigned int check_retry_zonelist(unsigned int seq)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+		return read_seqretry(&zonelist_update_seq, seq);
+
+	return seq;
+}
+
 /* Perform direct synchronous page reclaim */
 static unsigned long
 __perform_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -4888,6 +4912,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int compaction_retries;
 	int no_progress_loops;
 	unsigned int cpuset_mems_cookie;
+	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
 	/*
@@ -4898,11 +4923,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
 		gfp_mask &= ~__GFP_ATOMIC;
 
-retry_cpuset:
+restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+	zonelist_iter_cookie = zonelist_iter_begin();
 
 	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
@@ -5061,9 +5087,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 
 
-	/* Deal with possible cpuset update races before we start OOM killing */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac))
-		goto retry_cpuset;
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * a unnecessary OOM kill.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
 
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
@@ -5083,9 +5113,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	}
 
 nopage:
-	/* Deal with possible cpuset update races before we fail */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac))
-		goto retry_cpuset;
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * a unnecessary OOM kill.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
 
 	/*
 	 * Make sure that __GFP_NOFAIL request doesn't leak out and make sure
@@ -5566,6 +5600,18 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = size - fragsz;
+		if (unlikely(offset < 0)) {
+			/*
+			 * The caller is trying to allocate a fragment
+			 * with fragsz > PAGE_SIZE but the cache isn't big
+			 * enough to satisfy the request, this may
+			 * happen in low memory conditions.
+			 * We don't release the cache page because
+			 * it could make memory pressure worse
+			 * so we simply return NULL here.
+			 */
+			return NULL;
+		}
 	}
 
 	nc->pagecnt_bias--;
@@ -6367,9 +6413,8 @@ static void __build_all_zonelists(void *data)
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
-	static DEFINE_SPINLOCK(lock);
 
-	spin_lock(&lock);
+	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
 	memset(node_load, 0, sizeof(node_load));
@@ -6402,7 +6447,7 @@ static void __build_all_zonelists(void *data)
 #endif
 	}
 
-	spin_unlock(&lock);
+	write_sequnlock(&zonelist_update_seq);
 }
 
 static noinline void __init
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 14f49c0aa66e..d1986ce2e7c7 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -283,7 +283,7 @@ static int secretmem_init(void)
 
 	secretmem_mnt = kern_mount(&secretmem_fs);
 	if (IS_ERR(secretmem_mnt))
-		ret = PTR_ERR(secretmem_mnt);
+		return PTR_ERR(secretmem_mnt);
 
 	/* prevent secretmem mappings from ever getting PROT_EXEC */
 	secretmem_mnt->mnt_flags |= MNT_NOEXEC;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a499b07fee33..8f8dc2625d53 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5719,6 +5719,9 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_network_header(skb);
 	skb_reset_mac_header(skb);
 
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		goto start_xmit;
+
 	/* update QoS header to prioritize control port frames if possible,
 	 * priorization also happens for control port frames send over
 	 * AF_PACKET
@@ -5734,6 +5737,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 
 	rcu_read_unlock();
 
+start_xmit:
 	/* mutex lock is only needed for incrementing the cookie counter */
 	mutex_lock(&local->mtx);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f4fd584fba08..d85fdefe5730 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1306,7 +1306,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_ct_flow_table_get(params);
 	if (err)
-		goto cleanup;
+		goto cleanup_params;
 
 	spin_lock_bh(&c->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -1321,6 +1321,9 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	return res;
 
+cleanup_params:
+	if (params->tmpl)
+		nf_ct_put(params->tmpl);
 cleanup:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 7153bd53e189..7af251573595 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -14,6 +14,7 @@
 #include <sound/core.h>
 #include <sound/hda_codec.h>
 #include "hda_local.h"
+#include "hda_jack.h"
 
 /*
  * find a matching codec id
@@ -156,9 +157,10 @@ static int hda_codec_driver_remove(struct device *dev)
 		return codec->bus->core.ext_ops->hdev_detach(&codec->core);
 	}
 
-	refcount_dec(&codec->pcm_ref);
 	snd_hda_codec_disconnect_pcms(codec);
-	wait_event(codec->remove_sleep, !refcount_read(&codec->pcm_ref));
+	snd_hda_jack_tbl_disconnect(codec);
+	if (!refcount_dec_and_test(&codec->pcm_ref))
+		wait_event(codec->remove_sleep, !refcount_read(&codec->pcm_ref));
 	snd_power_sync_ref(codec->bus->card);
 
 	if (codec->patch_ops.free)
diff --git a/sound/pci/hda/hda_jack.c b/sound/pci/hda/hda_jack.c
index f29975e3e98d..7d7786df60ea 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -158,6 +158,17 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 	return jack;
 }
 
+void snd_hda_jack_tbl_disconnect(struct hda_codec *codec)
+{
+	struct hda_jack_tbl *jack = codec->jacktbl.list;
+	int i;
+
+	for (i = 0; i < codec->jacktbl.used; i++, jack++) {
+		if (!codec->bus->shutdown && jack->jack)
+			snd_device_disconnect(codec->card, jack->jack);
+	}
+}
+
 void snd_hda_jack_tbl_clear(struct hda_codec *codec)
 {
 	struct hda_jack_tbl *jack = codec->jacktbl.list;
diff --git a/sound/pci/hda/hda_jack.h b/sound/pci/hda/hda_jack.h
index 2abf7aac243a..ff7d289c034b 100644
--- a/sound/pci/hda/hda_jack.h
+++ b/sound/pci/hda/hda_jack.h
@@ -69,6 +69,7 @@ struct hda_jack_tbl *
 snd_hda_jack_tbl_get_from_tag(struct hda_codec *codec,
 			      unsigned char tag, int dev_id);
 
+void snd_hda_jack_tbl_disconnect(struct hda_codec *codec);
 void snd_hda_jack_tbl_clear(struct hda_codec *codec);
 
 void snd_hda_jack_set_dirty_all(struct hda_codec *codec);
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index d19bc2b9f778..d3da42e0e7b3 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -162,6 +162,8 @@ struct hdmi_spec {
 	bool dyn_pin_out;
 	bool dyn_pcm_assign;
 	bool dyn_pcm_no_legacy;
+	bool nv_dp_workaround; /* workaround DP audio infoframe for Nvidia */
+
 	bool intel_hsw_fixup;	/* apply Intel platform-specific fixups */
 	/*
 	 * Non-generic VIA/NVIDIA specific
@@ -671,15 +673,24 @@ static void hdmi_pin_setup_infoframe(struct hda_codec *codec,
 				     int ca, int active_channels,
 				     int conn_type)
 {
+	struct hdmi_spec *spec = codec->spec;
 	union audio_infoframe ai;
 
 	memset(&ai, 0, sizeof(ai));
-	if (conn_type == 0) { /* HDMI */
+	if ((conn_type == 0) || /* HDMI */
+		/* Nvidia DisplayPort: Nvidia HW expects same layout as HDMI */
+		(conn_type == 1 && spec->nv_dp_workaround)) {
 		struct hdmi_audio_infoframe *hdmi_ai = &ai.hdmi;
 
-		hdmi_ai->type		= 0x84;
-		hdmi_ai->ver		= 0x01;
-		hdmi_ai->len		= 0x0a;
+		if (conn_type == 0) { /* HDMI */
+			hdmi_ai->type		= 0x84;
+			hdmi_ai->ver		= 0x01;
+			hdmi_ai->len		= 0x0a;
+		} else {/* Nvidia DP */
+			hdmi_ai->type		= 0x84;
+			hdmi_ai->ver		= 0x1b;
+			hdmi_ai->len		= 0x11 << 2;
+		}
 		hdmi_ai->CC02_CT47	= active_channels - 1;
 		hdmi_ai->CA		= ca;
 		hdmi_checksum_audio_infoframe(hdmi_ai);
@@ -3539,6 +3550,7 @@ static int patch_nvhdmi_2ch(struct hda_codec *codec)
 	spec->pcm_playback.rates = SUPPORTED_RATES;
 	spec->pcm_playback.maxbps = SUPPORTED_MAXBPS;
 	spec->pcm_playback.formats = SUPPORTED_FORMATS;
+	spec->nv_dp_workaround = true;
 	return 0;
 }
 
@@ -3678,6 +3690,7 @@ static int patch_nvhdmi(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3701,6 +3714,7 @@ static int patch_nvhdmi_legacy(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	codec->link_down_at_suspend = 1;
 
@@ -3874,6 +3888,7 @@ static int patch_tegra_hdmi(struct hda_codec *codec)
 	spec->chmap.ops.chmap_cea_alloc_validate_get_type =
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
+	spec->nv_dp_workaround = true;
 
 	return 0;
 }
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c4b3f2d3c7e3..f7b6a516439d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6939,6 +6939,7 @@ enum {
 	ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME,
 	ALC285_FIXUP_LEGION_Y9000X_SPEAKERS,
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
+	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -8753,6 +8754,16 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x19 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x8e11 },
+			 { }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8976,6 +8987,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index b8cda6b14b49..a13b086a072b 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -495,6 +495,8 @@ static struct snd_soc_dai_driver tas2770_dai_driver[] = {
 	},
 };
 
+static const struct regmap_config tas2770_i2c_regmap;
+
 static int tas2770_codec_probe(struct snd_soc_component *component)
 {
 	struct tas2770_priv *tas2770 =
@@ -508,6 +510,7 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 	}
 
 	tas2770_reset(tas2770);
+	regmap_reinit_cache(tas2770->regmap, &tas2770_i2c_regmap);
 
 	return 0;
 }
diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 593d69b96523..d59f5efbf7ed 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -698,6 +698,10 @@ static int imx_card_parse_of(struct imx_card_data *data)
 		of_node_put(cpu);
 		of_node_put(codec);
 		of_node_put(platform);
+
+		cpu = NULL;
+		codec = NULL;
+		platform = NULL;
 	}
 
 	return 0;
diff --git a/tools/testing/selftests/net/reuseport_bpf.c b/tools/testing/selftests/net/reuseport_bpf.c
index b5277106df1f..b0cc082fbb84 100644
--- a/tools/testing/selftests/net/reuseport_bpf.c
+++ b/tools/testing/selftests/net/reuseport_bpf.c
@@ -330,7 +330,7 @@ static void test_extra_filter(const struct test_params p)
 	if (bind(fd1, addr, sockaddr_size()))
 		error(1, errno, "failed to bind recv socket 1");
 
-	if (!bind(fd2, addr, sockaddr_size()) && errno != EADDRINUSE)
+	if (!bind(fd2, addr, sockaddr_size()) || errno != EADDRINUSE)
 		error(1, errno, "bind socket 2 should fail with EADDRINUSE");
 
 	free(addr);
