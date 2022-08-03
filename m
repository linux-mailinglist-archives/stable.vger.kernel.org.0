Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA57B588A9D
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 12:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiHCKcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 06:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbiHCKbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 06:31:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99371624C;
        Wed,  3 Aug 2022 03:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B6EFB8211D;
        Wed,  3 Aug 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDB6C433D7;
        Wed,  3 Aug 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659522616;
        bh=sbOYzhUKHBiDz9XAt0rdb0VmSxjlipd5Sqoqm2pSnPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pab24vcsvamgJiay5WCtyKL2Q39vyxx8m+eBDCHjDJYPQ0KXb6PqxBHuljX/SQm4I
         HODpBRrdI2zQZc4Mo9JYQyiTwkn2m9zWSwcnO7cwD9TPE59/hOoYH/cTEzmZOTgWiH
         byShrvZSMmCNyiiSzafuVdqWR1SDXuJFe1lvowwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.18.16
Date:   Wed,  3 Aug 2022 12:30:09 +0200
Message-Id: <16595226091974@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165952260935153@kroah.com>
References: <165952260935153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index eb92195ca015..334544c893dd 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3106,6 +3106,7 @@
 					       no_entry_flush [PPC]
 					       no_uaccess_flush [PPC]
 					       mmio_stale_data=off [X86]
+					       retbleed=off [X86]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3128,6 +3129,7 @@
 					       mds=full,nosmt [X86]
 					       tsx_async_abort=full,nosmt [X86]
 					       mmio_stale_data=full,nosmt [X86]
+					       retbleed=auto,nosmt [X86]
 
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 8899b474edbf..e29017d4d7a2 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2848,7 +2848,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
 	Default: 4K
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	Currently this tunable has no effect.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimum size of send buffer that can be used by SCTP sockets.
+	It is guaranteed to each SCTP socket (but not association) even
+	under moderate memory pressure.
+
+	Default: 4K
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
diff --git a/Makefile b/Makefile
index 5957afa29692..18bcbcd037f0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 18
-SUBLEVEL = 15
+SUBLEVEL = 16
 EXTRAVERSION =
 NAME = Superb Owl
 
diff --git a/arch/arm/boot/dts/lan966x.dtsi b/arch/arm/boot/dts/lan966x.dtsi
index 5e9cbc8cdcbc..a99ffb4cfb8a 100644
--- a/arch/arm/boot/dts/lan966x.dtsi
+++ b/arch/arm/boot/dts/lan966x.dtsi
@@ -38,7 +38,7 @@ clocks {
 		sys_clk: sys_clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <162500000>;
+			clock-frequency = <165625000>;
 		};
 
 		cpu_clk: cpu_clk {
diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index a81dda65c576..45180a2cc47c 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -10,7 +10,7 @@
 #else
 #define MAX_DMA_ADDRESS	({ \
 	extern phys_addr_t arm_dma_zone_size; \
-	arm_dma_zone_size && arm_dma_zone_size < (0x10000000 - PAGE_OFFSET) ? \
+	arm_dma_zone_size && arm_dma_zone_size < (0x100000000ULL - PAGE_OFFSET) ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
 
diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index 44659fbc37ba..036f3aacd0e1 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -531,7 +531,7 @@ static struct pxa2xx_spi_controller corgi_spi_info = {
 };
 
 static struct gpiod_lookup_table corgi_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.1",
+	.dev_id = "spi1",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", CORGI_GPIO_ADS7846_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", CORGI_GPIO_LCDCON_CS, "cs", 1, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index e1870fbb19e7..188707316e6e 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -635,7 +635,7 @@ static struct pxa2xx_spi_controller pxa_ssp2_master_info = {
 };
 
 static struct gpiod_lookup_table pxa_ssp2_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO88_HX4700_TSC2046_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-pxa/icontrol.c b/arch/arm/mach-pxa/icontrol.c
index 753fe166ab68..624088257cfc 100644
--- a/arch/arm/mach-pxa/icontrol.c
+++ b/arch/arm/mach-pxa/icontrol.c
@@ -140,7 +140,7 @@ struct platform_device pxa_spi_ssp4 = {
 };
 
 static struct gpiod_lookup_table pxa_ssp3_gpio_table = {
-	.dev_id = "pxa2xx-spi.3",
+	.dev_id = "spi3",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS1, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS2, "cs", 1, GPIO_ACTIVE_LOW),
@@ -149,7 +149,7 @@ static struct gpiod_lookup_table pxa_ssp3_gpio_table = {
 };
 
 static struct gpiod_lookup_table pxa_ssp4_gpio_table = {
-	.dev_id = "pxa2xx-spi.4",
+	.dev_id = "spi4",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS3, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", ICONTROL_MCP251x_nCS4, "cs", 1, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/littleton.c b/arch/arm/mach-pxa/littleton.c
index 73f5953b3bb6..3d04912d44d4 100644
--- a/arch/arm/mach-pxa/littleton.c
+++ b/arch/arm/mach-pxa/littleton.c
@@ -208,7 +208,7 @@ static struct spi_board_info littleton_spi_devices[] __initdata = {
 };
 
 static struct gpiod_lookup_table littleton_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", LITTLETON_GPIO_LCD_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index fcced6499fae..828d6e1cd038 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -946,7 +946,7 @@ static struct pxa2xx_spi_controller magician_spi_info = {
 };
 
 static struct gpiod_lookup_table magician_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		/* NOTICE must be GPIO, incompatibility with hw PXA SPI framing */
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO14_MAGICIAN_TSC2046_CS, "cs", 0, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index a648e7094e84..36aee8de1872 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -578,7 +578,7 @@ static struct pxa2xx_spi_controller spitz_spi_info = {
 };
 
 static struct gpiod_lookup_table spitz_spi_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", SPITZ_GPIO_ADS7846_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP_IDX("gpio-pxa", SPITZ_GPIO_LCDCON_CS, "cs", 1, GPIO_ACTIVE_LOW),
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index 7eaeda269927..7b18d1f90309 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -623,7 +623,7 @@ static struct pxa2xx_spi_controller pxa_ssp2_master_info = {
 };
 
 static struct gpiod_lookup_table pxa_ssp1_gpio_table = {
-	.dev_id = "pxa2xx-spi.1",
+	.dev_id = "spi1",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO24_ZIPITZ2_WIFI_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
@@ -631,7 +631,7 @@ static struct gpiod_lookup_table pxa_ssp1_gpio_table = {
 };
 
 static struct gpiod_lookup_table pxa_ssp2_gpio_table = {
-	.dev_id = "pxa2xx-spi.2",
+	.dev_id = "spi2",
 	.table = {
 		GPIO_LOOKUP_IDX("gpio-pxa", GPIO88_ZIPITZ2_LCD_CS, "cs", 0, GPIO_ACTIVE_LOW),
 		{ },
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 2c6e1c6ecbe7..4120c428dc37 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017, 2020
+ * Copyright IBM Corp. 2017, 2022
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -14,6 +14,7 @@
 #ifdef CONFIG_ARCH_RANDOM
 
 #include <linux/static_key.h>
+#include <linux/preempt.h>
 #include <linux/atomic.h>
 #include <asm/cpacf.h>
 
@@ -32,7 +33,8 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
@@ -42,7 +44,8 @@ static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8179fa4d5004..fd986a8ba2bd 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1513,6 +1513,7 @@ static void __init spectre_v2_select_mitigation(void)
 	 * enable IBRS around firmware calls.
 	 */
 	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+	    boot_cpu_has(X86_FEATURE_IBPB) &&
 	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
 
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 6d1ddecbf0da..d0a9ccf640c4 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -101,9 +101,14 @@ static void dimm_setup_label(struct dimm_info *dimm, u16 handle)
 
 	dmi_memdev_name(handle, &bank, &device);
 
-	/* both strings must be non-zero */
-	if (bank && *bank && device && *device)
-		snprintf(dimm->label, sizeof(dimm->label), "%s %s", bank, device);
+	/*
+	 * Set to a NULL string when both bank and device are zero. In this case,
+	 * the label assigned by default will be preserved.
+	 */
+	snprintf(dimm->label, sizeof(dimm->label), "%s%s%s",
+		 (bank && *bank) ? bank : "",
+		 (bank && *bank && device && *device) ? " " : "",
+		 (device && *device) ? device : "");
 }
 
 static void assign_dmi_dimm_info(struct dimm_info *dimm, struct memdev_dmi_entry *entry)
diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 40b1abeca856..a14baeca6400 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -527,6 +527,28 @@ static void handle_error(struct mem_ctl_info *mci, struct synps_ecc_status *p)
 	memset(p, 0, sizeof(*p));
 }
 
+static void enable_intr(struct synps_edac_priv *priv)
+{
+	/* Enable UE/CE Interrupts */
+	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
+		writel(DDR_UE_MASK | DDR_CE_MASK,
+		       priv->baseaddr + ECC_CLR_OFST);
+	else
+		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
+		       priv->baseaddr + DDR_QOS_IRQ_EN_OFST);
+
+}
+
+static void disable_intr(struct synps_edac_priv *priv)
+{
+	/* Disable UE/CE Interrupts */
+	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
+		writel(0x0, priv->baseaddr + ECC_CLR_OFST);
+	else
+		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
+		       priv->baseaddr + DDR_QOS_IRQ_DB_OFST);
+}
+
 /**
  * intr_handler - Interrupt Handler for ECC interrupts.
  * @irq:        IRQ number.
@@ -568,6 +590,9 @@ static irqreturn_t intr_handler(int irq, void *dev_id)
 	/* v3.0 of the controller does not have this register */
 	if (!(priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR))
 		writel(regval, priv->baseaddr + DDR_QOS_IRQ_STAT_OFST);
+	else
+		enable_intr(priv);
+
 	return IRQ_HANDLED;
 }
 
@@ -850,25 +875,6 @@ static void mc_init(struct mem_ctl_info *mci, struct platform_device *pdev)
 	init_csrows(mci);
 }
 
-static void enable_intr(struct synps_edac_priv *priv)
-{
-	/* Enable UE/CE Interrupts */
-	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
-		writel(DDR_UE_MASK | DDR_CE_MASK,
-		       priv->baseaddr + ECC_CLR_OFST);
-	else
-		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
-		       priv->baseaddr + DDR_QOS_IRQ_EN_OFST);
-
-}
-
-static void disable_intr(struct synps_edac_priv *priv)
-{
-	/* Disable UE/CE Interrupts */
-	writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
-			priv->baseaddr + DDR_QOS_IRQ_DB_OFST);
-}
-
 static int setup_irq(struct mem_ctl_info *mci,
 		     struct platform_device *pdev)
 {
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 7ba66ad68a8a..16356611b5b9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -680,7 +680,11 @@ nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 		goto out_free_dma;
 
 	for (i = 0; i < npages; i += max) {
-		args.end = start + (max << PAGE_SHIFT);
+		if (args.start + (max << PAGE_SHIFT) > end)
+			args.end = end;
+		else
+			args.end = args.start + (max << PAGE_SHIFT);
+
 		ret = migrate_vma_setup(&args);
 		if (ret)
 			goto out_free_pfns;
diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index f5b8e864a5cd..b1a88675bd47 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -627,7 +627,7 @@ static const struct drm_connector_funcs simpledrm_connector_funcs = {
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-static int
+static enum drm_mode_status
 simpledrm_simple_display_pipe_mode_valid(struct drm_simple_display_pipe *pipe,
 				    const struct drm_display_mode *mode)
 {
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index b463d85bfb35..47b68c6071be 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -162,7 +162,13 @@ static __cpuidle int intel_idle_irq(struct cpuidle_device *dev,
 
 	raw_local_irq_enable();
 	ret = __intel_idle(dev, drv, index);
-	raw_local_irq_disable();
+
+	/*
+	 * The lockdep hardirqs state may be changed to 'on' with timer
+	 * tick interrupt followed by __do_softirq(). Use local_irq_disable()
+	 * to keep the hardirqs state correct.
+	 */
+	local_irq_disable();
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
index 0f6a549b9f67..29a6c2ede43a 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -142,6 +142,7 @@ static void *fun_run_xdp(struct funeth_rxq *q, skb_frag_t *frags, void *buf_va,
 			 int ref_ok, struct funeth_txq *xdp_q)
 {
 	struct bpf_prog *xdp_prog;
+	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 act;
 
@@ -163,7 +164,9 @@ static void *fun_run_xdp(struct funeth_rxq *q, skb_frag_t *frags, void *buf_va,
 	case XDP_TX:
 		if (unlikely(!ref_ok))
 			goto pass;
-		if (!fun_xdp_tx(xdp_q, xdp.data, xdp.data_end - xdp.data))
+
+		xdpf = xdp_convert_buff_to_frame(&xdp);
+		if (!xdpf || !fun_xdp_tx(xdp_q, xdpf))
 			goto xdp_error;
 		FUN_QSTAT_INC(q, xdp_tx);
 		q->xdp_flush |= FUN_XDP_FLUSH_TX;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index ff6e29237253..2f6698b98b03 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -466,7 +466,7 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 
 		do {
 			fun_xdp_unmap(q, reclaim_idx);
-			page_frag_free(q->info[reclaim_idx].vaddr);
+			xdp_return_frame(q->info[reclaim_idx].xdpf);
 
 			trace_funeth_tx_free(q, reclaim_idx, 1, head);
 
@@ -479,11 +479,11 @@ static unsigned int fun_xdpq_clean(struct funeth_txq *q, unsigned int budget)
 	return npkts;
 }
 
-bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
+bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf)
 {
 	struct fun_eth_tx_req *req;
 	struct fun_dataop_gl *gle;
-	unsigned int idx;
+	unsigned int idx, len;
 	dma_addr_t dma;
 
 	if (fun_txq_avail(q) < FUN_XDP_CLEAN_THRES)
@@ -494,7 +494,8 @@ bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
 		return false;
 	}
 
-	dma = dma_map_single(q->dma_dev, data, len, DMA_TO_DEVICE);
+	len = xdpf->len;
+	dma = dma_map_single(q->dma_dev, xdpf->data, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(q->dma_dev, dma))) {
 		FUN_QSTAT_INC(q, tx_map_err);
 		return false;
@@ -514,7 +515,7 @@ bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len)
 	gle = (struct fun_dataop_gl *)req->dataop.imm;
 	fun_dataop_gl_init(gle, 0, 0, len, dma);
 
-	q->info[idx].vaddr = data;
+	q->info[idx].xdpf = xdpf;
 
 	u64_stats_update_begin(&q->syncp);
 	q->stats.tx_bytes += len;
@@ -545,12 +546,9 @@ int fun_xdp_xmit_frames(struct net_device *dev, int n,
 	if (unlikely(q_idx >= fp->num_xdpqs))
 		return -ENXIO;
 
-	for (q = xdpqs[q_idx], i = 0; i < n; i++) {
-		const struct xdp_frame *xdpf = frames[i];
-
-		if (!fun_xdp_tx(q, xdpf->data, xdpf->len))
+	for (q = xdpqs[q_idx], i = 0; i < n; i++)
+		if (!fun_xdp_tx(q, frames[i]))
 			break;
-	}
 
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		fun_txq_wr_db(q);
@@ -577,7 +575,7 @@ static void fun_xdpq_purge(struct funeth_txq *q)
 		unsigned int idx = q->cons_cnt & q->mask;
 
 		fun_xdp_unmap(q, idx);
-		page_frag_free(q->info[idx].vaddr);
+		xdp_return_frame(q->info[idx].xdpf);
 		q->cons_cnt++;
 	}
 }
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
index 04c9f91b7489..8708e2895946 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -95,8 +95,8 @@ struct funeth_txq_stats {  /* per Tx queue SW counters */
 
 struct funeth_tx_info {      /* per Tx descriptor state */
 	union {
-		struct sk_buff *skb; /* associated packet */
-		void *vaddr;         /* start address for XDP */
+		struct sk_buff *skb;    /* associated packet (sk_buff path) */
+		struct xdp_frame *xdpf; /* associated XDP frame (XDP path) */
 	};
 };
 
@@ -245,7 +245,7 @@ static inline int fun_irq_node(const struct fun_irq *p)
 int fun_rxq_napi_poll(struct napi_struct *napi, int budget);
 int fun_txq_napi_poll(struct napi_struct *napi, int budget);
 netdev_tx_t fun_start_xmit(struct sk_buff *skb, struct net_device *netdev);
-bool fun_xdp_tx(struct funeth_txq *q, void *data, unsigned int len);
+bool fun_xdp_tx(struct funeth_txq *q, struct xdp_frame *xdpf);
 int fun_xdp_xmit_frames(struct net_device *dev, int n,
 			struct xdp_frame **frames, u32 flags);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6f01bffd7e5c..9471f47089b2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1920,11 +1920,15 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 		 * non-zero req_queue_pairs says that user requested a new
 		 * queue count via ethtool's set_channels, so use this
 		 * value for queues distribution across traffic classes
+		 * We need at least one queue pair for the interface
+		 * to be usable as we see in else statement.
 		 */
 		if (vsi->req_queue_pairs > 0)
 			vsi->num_queue_pairs = vsi->req_queue_pairs;
 		else if (pf->flags & I40E_FLAG_MSIX_ENABLED)
 			vsi->num_queue_pairs = pf->num_lan_msix;
+		else
+			vsi->num_queue_pairs = 1;
 	}
 
 	/* Number of queues per enabled TC */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 8aee4ae4cc8c..74350a95a6e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -660,7 +660,8 @@ static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
 		rx_desc = ICE_RX_DESC(rx_ring, i);
 
 		if (!(rx_desc->wb.status_error0 &
-		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
+		    (cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S)) |
+		     cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)))))
 			continue;
 
 		rx_buf = &rx_ring->rx_buf[i];
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index efb076f71e38..522462f41067 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4640,6 +4640,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		ice_set_safe_mode_caps(hw);
 	}
 
+	hw->ucast_shared = true;
+
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
@@ -5994,10 +5996,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 	if (vsi->netdev) {
 		ice_set_rx_mode(vsi->netdev);
 
-		err = ice_vsi_vlan_setup(vsi);
+		if (vsi->type != ICE_VSI_LB) {
+			err = ice_vsi_vlan_setup(vsi);
 
-		if (err)
-			return err;
+			if (err)
+				return err;
+		}
 	}
 	ice_vsi_cfg_dcb_rings(vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index bb1721f1321d..f4907a3c2d19 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1309,39 +1309,6 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 	return ret;
 }
 
-/**
- * ice_unicast_mac_exists - check if the unicast MAC exists on the PF's switch
- * @pf: PF used to reference the switch's rules
- * @umac: unicast MAC to compare against existing switch rules
- *
- * Return true on the first/any match, else return false
- */
-static bool ice_unicast_mac_exists(struct ice_pf *pf, u8 *umac)
-{
-	struct ice_sw_recipe *mac_recipe_list =
-		&pf->hw.switch_info->recp_list[ICE_SW_LKUP_MAC];
-	struct ice_fltr_mgmt_list_entry *list_itr;
-	struct list_head *rule_head;
-	struct mutex *rule_lock; /* protect MAC filter list access */
-
-	rule_head = &mac_recipe_list->filt_rules;
-	rule_lock = &mac_recipe_list->filt_rule_lock;
-
-	mutex_lock(rule_lock);
-	list_for_each_entry(list_itr, rule_head, list_entry) {
-		u8 *existing_mac = &list_itr->fltr_info.l_data.mac.mac_addr[0];
-
-		if (ether_addr_equal(existing_mac, umac)) {
-			mutex_unlock(rule_lock);
-			return true;
-		}
-	}
-
-	mutex_unlock(rule_lock);
-
-	return false;
-}
-
 /**
  * ice_set_vf_mac
  * @netdev: network interface device structure
@@ -1376,13 +1343,6 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	if (ret)
 		goto out_put_vf;
 
-	if (ice_unicast_mac_exists(pf, mac)) {
-		netdev_err(netdev, "Unicast MAC %pM already exists on this PF. Preventing setting VF %u unicast MAC address to %pM\n",
-			   mac, vf_id, mac);
-		ret = -EINVAL;
-		goto out_put_vf;
-	}
-
 	mutex_lock(&vf->cfg_lock);
 
 	/* VF is notified of its new MAC via the PF's response to the
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index da7c5ce15be0..3143c2abf775 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -2966,7 +2966,8 @@ ice_vc_validate_add_vlan_filter_list(struct ice_vsi *vsi,
 				     struct virtchnl_vlan_filtering_caps *vfc,
 				     struct virtchnl_vlan_filter_list_v2 *vfl)
 {
-	u16 num_requested_filters = vsi->num_vlan + vfl->num_elements;
+	u16 num_requested_filters = ice_vsi_num_non_zero_vlans(vsi) +
+		vfl->num_elements;
 
 	if (num_requested_filters > vfc->max_filters)
 		return false;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 28b19945d716..e64318c110fd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -28,6 +28,9 @@
 #define MAX_RATE_EXPONENT		0x0FULL
 #define MAX_RATE_MANTISSA		0xFFULL
 
+#define CN10K_MAX_BURST_MANTISSA	0x7FFFULL
+#define CN10K_MAX_BURST_SIZE		8453888ULL
+
 /* Bitfields in NIX_TLX_PIR register */
 #define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
 #define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
@@ -35,6 +38,9 @@
 #define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
 #define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
 
+#define CN10K_TLX_BURST_MANTISSA	GENMASK_ULL(43, 29)
+#define CN10K_TLX_BURST_EXPONENT	GENMASK_ULL(47, 44)
+
 struct otx2_tc_flow_stats {
 	u64 bytes;
 	u64 pkts;
@@ -77,33 +83,42 @@ int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
 }
 EXPORT_SYMBOL(otx2_tc_alloc_ent_bitmap);
 
-static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
-				      u32 *burst_mantissa)
+static void otx2_get_egress_burst_cfg(struct otx2_nic *nic, u32 burst,
+				      u32 *burst_exp, u32 *burst_mantissa)
 {
+	int max_burst, max_mantissa;
 	unsigned int tmp;
 
+	if (is_dev_otx2(nic->pdev)) {
+		max_burst = MAX_BURST_SIZE;
+		max_mantissa = MAX_BURST_MANTISSA;
+	} else {
+		max_burst = CN10K_MAX_BURST_SIZE;
+		max_mantissa = CN10K_MAX_BURST_MANTISSA;
+	}
+
 	/* Burst is calculated as
 	 * ((256 + BURST_MANTISSA) << (1 + BURST_EXPONENT)) / 256
 	 * Max supported burst size is 130,816 bytes.
 	 */
-	burst = min_t(u32, burst, MAX_BURST_SIZE);
+	burst = min_t(u32, burst, max_burst);
 	if (burst) {
 		*burst_exp = ilog2(burst) ? ilog2(burst) - 1 : 0;
 		tmp = burst - rounddown_pow_of_two(burst);
-		if (burst < MAX_BURST_MANTISSA)
+		if (burst < max_mantissa)
 			*burst_mantissa = tmp * 2;
 		else
 			*burst_mantissa = tmp / (1ULL << (*burst_exp - 7));
 	} else {
 		*burst_exp = MAX_BURST_EXPONENT;
-		*burst_mantissa = MAX_BURST_MANTISSA;
+		*burst_mantissa = max_mantissa;
 	}
 }
 
-static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
+static void otx2_get_egress_rate_cfg(u64 maxrate, u32 *exp,
 				     u32 *mantissa, u32 *div_exp)
 {
-	unsigned int tmp;
+	u64 tmp;
 
 	/* Rate calculation by hardware
 	 *
@@ -132,21 +147,44 @@ static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
 	}
 }
 
-static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 maxrate)
+static u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
+				       u64 maxrate, u32 burst)
 {
-	struct otx2_hw *hw = &nic->hw;
-	struct nix_txschq_config *req;
 	u32 burst_exp, burst_mantissa;
 	u32 exp, mantissa, div_exp;
+	u64 regval = 0;
+
+	/* Get exponent and mantissa values from the desired rate */
+	otx2_get_egress_burst_cfg(nic, burst, &burst_exp, &burst_mantissa);
+	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
+
+	if (is_dev_otx2(nic->pdev)) {
+		regval = FIELD_PREP(TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	} else {
+		regval = FIELD_PREP(CN10K_TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(CN10K_TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	}
+
+	return regval;
+}
+
+static int otx2_set_matchall_egress_rate(struct otx2_nic *nic,
+					 u32 burst, u64 maxrate)
+{
+	struct otx2_hw *hw = &nic->hw;
+	struct nix_txschq_config *req;
 	int txschq, err;
 
 	/* All SQs share the same TL4, so pick the first scheduler */
 	txschq = hw->txschq_list[NIX_TXSCH_LVL_TL4][0];
 
-	/* Get exponent and mantissa values from the desired rate */
-	otx2_get_egress_burst_cfg(burst, &burst_exp, &burst_mantissa);
-	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
-
 	mutex_lock(&nic->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&nic->mbox);
 	if (!req) {
@@ -157,11 +195,7 @@ static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 ma
 	req->lvl = NIX_TXSCH_LVL_TL4;
 	req->num_regs = 1;
 	req->reg[0] = NIX_AF_TL4X_PIR(txschq);
-	req->regval[0] = FIELD_PREP(TLX_BURST_EXPONENT, burst_exp) |
-			 FIELD_PREP(TLX_BURST_MANTISSA, burst_mantissa) |
-			 FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
-			 FIELD_PREP(TLX_RATE_EXPONENT, exp) |
-			 FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	req->regval[0] = otx2_get_txschq_rate_regval(nic, maxrate, burst);
 
 	err = otx2_sync_mbox_msg(&nic->mbox);
 	mutex_unlock(&nic->mbox.lock);
@@ -230,7 +264,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct flow_action *actions = &cls->rule->action;
 	struct flow_action_entry *entry;
-	u32 rate;
+	u64 rate;
 	int err;
 
 	err = otx2_tc_validate_flow(nic, actions, extack);
@@ -256,7 +290,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 		}
 		/* Convert bytes per second to Mbps */
 		rate = entry->police.rate_bytes_ps * 8;
-		rate = max_t(u32, rate / 1000000, 1);
+		rate = max_t(u64, rate / 1000000, 1);
 		err = otx2_set_matchall_egress_rate(nic, entry->police.burst, rate);
 		if (err)
 			return err;
@@ -614,21 +648,27 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 
 		flow_spec->dport = match.key->dst;
 		flow_mask->dport = match.mask->dst;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_DPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_DPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_DPORT_SCTP);
+
+		if (flow_mask->dport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_DPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_DPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_DPORT_SCTP);
+		}
 
 		flow_spec->sport = match.key->src;
 		flow_mask->sport = match.mask->src;
-		if (ip_proto == IPPROTO_UDP)
-			req->features |= BIT_ULL(NPC_SPORT_UDP);
-		else if (ip_proto == IPPROTO_TCP)
-			req->features |= BIT_ULL(NPC_SPORT_TCP);
-		else if (ip_proto == IPPROTO_SCTP)
-			req->features |= BIT_ULL(NPC_SPORT_SCTP);
+
+		if (flow_mask->sport) {
+			if (ip_proto == IPPROTO_UDP)
+				req->features |= BIT_ULL(NPC_SPORT_UDP);
+			else if (ip_proto == IPPROTO_TCP)
+				req->features |= BIT_ULL(NPC_SPORT_TCP);
+			else if (ip_proto == IPPROTO_SCTP)
+				req->features |= BIT_ULL(NPC_SPORT_SCTP);
+		}
 	}
 
 	return otx2_tc_parse_actions(nic, &rule->action, req, f, node);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index c00d6c4ed37c..245d36696486 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7022,7 +7022,7 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
 		if (IS_ERR(mlxsw_sp_rt6)) {
 			err = PTR_ERR(mlxsw_sp_rt6);
-			goto err_rt6_create;
+			goto err_rt6_unwind;
 		}
 
 		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
@@ -7031,14 +7031,12 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 
 	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
 	if (err)
-		goto err_nexthop6_group_update;
+		goto err_rt6_unwind;
 
 	return 0;
 
-err_nexthop6_group_update:
-	i = nrt6;
-err_rt6_create:
-	for (i--; i >= 0; i--) {
+err_rt6_unwind:
+	for (; i > 0; i--) {
 		fib6_entry->nrt6--;
 		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
 					       struct mlxsw_sp_rt6, list);
@@ -7166,7 +7164,7 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
 		if (IS_ERR(mlxsw_sp_rt6)) {
 			err = PTR_ERR(mlxsw_sp_rt6);
-			goto err_rt6_create;
+			goto err_rt6_unwind;
 		}
 		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
 		fib6_entry->nrt6++;
@@ -7174,7 +7172,7 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 
 	err = mlxsw_sp_nexthop6_group_get(mlxsw_sp, fib6_entry);
 	if (err)
-		goto err_nexthop6_group_get;
+		goto err_rt6_unwind;
 
 	err = mlxsw_sp_nexthop_group_vr_link(fib_entry->nh_group,
 					     fib_node->fib);
@@ -7193,10 +7191,8 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_group_vr_unlink(fib_entry->nh_group, fib_node->fib);
 err_nexthop_group_vr_link:
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, fib_entry);
-err_nexthop6_group_get:
-	i = nrt6;
-err_rt6_create:
-	for (i--; i >= 0; i--) {
+err_rt6_unwind:
+	for (; i > 0; i--) {
 		fib6_entry->nrt6--;
 		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
 					       struct mlxsw_sp_rt6, list);
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 4625f85acab2..10ad0b93d283 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1100,7 +1100,29 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
+		/* This code invokes normal driver TX code which is always
+		 * protected from softirqs when called from generic TX code,
+		 * which in turn disables preemption. Look at __dev_queue_xmit
+		 * which uses rcu_read_lock_bh disabling preemption for RCU
+		 * plus disabling softirqs. We do not need RCU reader
+		 * protection here.
+		 *
+		 * Although it is theoretically safe for current PTP TX/RX code
+		 * running without disabling softirqs, there are three good
+		 * reasond for doing so:
+		 *
+		 *      1) The code invoked is mainly implemented for non-PTP
+		 *         packets and it is always executed with softirqs
+		 *         disabled.
+		 *      2) This being a single PTP packet, better to not
+		 *         interrupt its processing by softirqs which can lead
+		 *         to high latencies.
+		 *      3) netdev_xmit_more checks preemption is disabled and
+		 *         triggers a BUG_ON if not.
+		 */
+		local_bh_disable();
 		efx_enqueue_skb(tx_queue, skb);
+		local_bh_enable();
 	} else {
 		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index ca8ab290013c..d42e1afb6521 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -688,18 +688,19 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 
 	ret = mediatek_dwmac_clks_config(priv_plat, true);
 	if (ret)
-		return ret;
+		goto err_remove_config_dt;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
-	if (ret) {
-		stmmac_remove_config_dt(pdev, plat_dat);
+	if (ret)
 		goto err_drv_probe;
-	}
 
 	return 0;
 
 err_drv_probe:
 	mediatek_dwmac_clks_config(priv_plat, false);
+err_remove_config_dt:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
 	return ret;
 }
 
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 817577e713d7..f354fad05714 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -243,6 +243,7 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define DEFAULT_SEND_SCI true
 #define DEFAULT_ENCRYPT false
 #define DEFAULT_ENCODING_SA 0
+#define MACSEC_XPN_MAX_REPLAY_WINDOW (((1 << 30) - 1))
 
 static bool send_sci(const struct macsec_secy *secy)
 {
@@ -1697,7 +1698,7 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_PN] &&
-	    *(u64 *)nla_data(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1753,7 +1754,8 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+	if (tb_sa[MACSEC_SA_ATTR_PN] &&
+	    nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
 		pr_notice("macsec: nl: add_rxsa: bad pn length: %d != %d\n",
 			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
 		rtnl_unlock();
@@ -1769,7 +1771,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_rxsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -1842,7 +1844,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	kfree(rx_sa);
+	macsec_rxsa_put(rx_sa);
 	rtnl_unlock();
 	return err;
 }
@@ -1939,7 +1941,7 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -2011,7 +2013,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_txsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -2085,7 +2087,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 
 cleanup:
 	secy->operational = was_operational;
-	kfree(tx_sa);
+	macsec_txsa_put(tx_sa);
 	rtnl_unlock();
 	return err;
 }
@@ -2293,7 +2295,7 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -3745,9 +3747,6 @@ static int macsec_changelink_common(struct net_device *dev,
 		secy->operational = tx_sa && tx_sa->active;
 	}
 
-	if (data[IFLA_MACSEC_WINDOW])
-		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
-
 	if (data[IFLA_MACSEC_ENCRYPT])
 		tx_sc->encrypt = !!nla_get_u8(data[IFLA_MACSEC_ENCRYPT]);
 
@@ -3793,6 +3792,16 @@ static int macsec_changelink_common(struct net_device *dev,
 		}
 	}
 
+	if (data[IFLA_MACSEC_WINDOW]) {
+		secy->replay_window = nla_get_u32(data[IFLA_MACSEC_WINDOW]);
+
+		/* IEEE 802.1AEbw-2013 10.7.8 - maximum replay window
+		 * for XPN cipher suites */
+		if (secy->xpn &&
+		    secy->replay_window > MACSEC_XPN_MAX_REPLAY_WINDOW)
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -3822,7 +3831,7 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	ret = macsec_changelink_common(dev, data);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 61418d4dc0cd..8768f6e34846 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -898,7 +898,7 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	 */
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS);
 	if (ret < 0)
-		return false;
+		return ret;
 
 	if (ret & DW_VR_MII_C37_ANSGM_SP_LNKSTS) {
 		int speed_value;
diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 4daac5fda073..0d40d265b688 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -454,6 +454,7 @@ static int bcm5421_init(struct mii_phy* phy)
 		int can_low_power = 1;
 		if (np == NULL || of_get_property(np, "no-autolowpower", NULL))
 			can_low_power = 0;
+		of_node_put(np);
 		if (can_low_power) {
 			/* Enable automatic low-power */
 			sungem_phy_write(phy, 0x1c, 0x9002);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c7804fce204c..206904e60784 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -242,9 +242,15 @@ struct virtnet_info {
 	/* Packet virtio header size */
 	u8 hdr_len;
 
-	/* Work struct for refilling if we run low on memory. */
+	/* Work struct for delayed refilling if we run low on memory. */
 	struct delayed_work refill;
 
+	/* Is delayed refill enabled? */
+	bool refill_enabled;
+
+	/* The lock to synchronize the access to refill_enabled */
+	spinlock_t refill_lock;
+
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
@@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
 	return p;
 }
 
+static void enable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = true;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
+static void disable_delayed_refill(struct virtnet_info *vi)
+{
+	spin_lock_bh(&vi->refill_lock);
+	vi->refill_enabled = false;
+	spin_unlock_bh(&vi->refill_lock);
+}
+
 static void virtqueue_napi_schedule(struct napi_struct *napi,
 				    struct virtqueue *vq)
 {
@@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
 	}
 
 	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
-		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
-			schedule_delayed_work(&vi->refill, 0);
+		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
+			spin_lock(&vi->refill_lock);
+			if (vi->refill_enabled)
+				schedule_delayed_work(&vi->refill, 0);
+			spin_unlock(&vi->refill_lock);
+		}
 	}
 
 	u64_stats_update_begin(&rq->stats.syncp);
@@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, err;
 
+	enable_delayed_refill(vi);
+
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		if (i < vi->curr_queue_pairs)
 			/* Make sure we have some buffers: if oom use wq. */
@@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i;
 
+	/* Make sure NAPI doesn't schedule refill work */
+	disable_delayed_refill(vi);
 	/* Make sure refill_work doesn't re-enable napi! */
 	cancel_delayed_work_sync(&vi->refill);
 
@@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	enable_delayed_refill(vi);
+
 	if (netif_running(vi->dev)) {
 		err = virtnet_open(vi->dev);
 		if (err)
@@ -3534,6 +3564,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	vdev->priv = vi;
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
+	spin_lock_init(&vi->refill_lock);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7e476f50935b..f9e4b01cd0f5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11386,6 +11386,7 @@ scsih_shutdown(struct pci_dev *pdev)
 	_scsih_ir_shutdown(ioc);
 	_scsih_nvme_shutdown(ioc);
 	mpt3sas_base_mask_interrupts(ioc);
+	mpt3sas_base_stop_watchdog(ioc);
 	ioc->shost_recovery = 1;
 	mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 	ioc->shost_recovery = 0;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index a480c4d589f5..729e309e6034 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -450,7 +450,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 		goto out_put_request;
 
 	ret = 0;
-	if (hdr->iovec_count) {
+	if (hdr->iovec_count && hdr->dxfer_len) {
 		struct iov_iter i;
 		struct iovec *iov = NULL;
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 87975d1a21c8..adc302b1a57a 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -107,9 +107,20 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	return ret;
 }
 
+static bool phandle_exists(const struct device_node *np,
+			   const char *phandle_name, int index)
+{
+	struct device_node *parse_np = of_parse_phandle(np, phandle_name, index);
+
+	if (parse_np)
+		of_node_put(parse_np);
+
+	return parse_np != NULL;
+}
+
 #define MAX_PROP_SIZE 32
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
-		struct ufs_vreg **out_vreg)
+				struct ufs_vreg **out_vreg)
 {
 	char prop_name[MAX_PROP_SIZE];
 	struct ufs_vreg *vreg = NULL;
@@ -121,7 +132,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	}
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
-	if (!of_parse_phandle(np, prop_name, 0)) {
+	if (!phandle_exists(np, prop_name, 0)) {
 		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
 				__func__, prop_name);
 		goto out;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 452ad0612067..874490f7f5e7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -734,17 +734,28 @@ static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_utrl_clear - Clear a bit in UTRLCLR register
+ * ufshcd_utrl_clear() - Clear requests from the controller request list.
  * @hba: per adapter instance
- * @pos: position of the bit to be cleared
+ * @mask: mask with one bit set for each request to be cleared
  */
-static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
+static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 mask)
 {
 	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
-		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
-	else
-		ufshcd_writel(hba, ~(1 << pos),
-				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+		mask = ~mask;
+	/*
+	 * From the UFSHCI specification: "UTP Transfer Request List CLear
+	 * Register (UTRLCLR): This field is bit significant. Each bit
+	 * corresponds to a slot in the UTP Transfer Request List, where bit 0
+	 * corresponds to request slot 0. A bit in this field is set to ‘0’
+	 * by host software to indicate to the host controller that a transfer
+	 * request slot is cleared. The host controller
+	 * shall free up any resources associated to the request slot
+	 * immediately, and shall set the associated bit in UTRLDBR to ‘0’. The
+	 * host software indicates no change to request slots by setting the
+	 * associated bits in this field to ‘1’. Bits in this field shall only
+	 * be set ‘1’ or ‘0’ by host software when UTRLRSR is set to ‘1’."
+	 */
+	ufshcd_writel(hba, ~mask, REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -2853,16 +2864,19 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	return ufshcd_compose_devman_upiu(hba, lrbp);
 }
 
-static int
-ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
+/*
+ * Clear all the requests from the controller for which a bit has been set in
+ * @mask and wait until the controller confirms that these requests have been
+ * cleared.
+ */
+static int ufshcd_clear_cmds(struct ufs_hba *hba, u32 mask)
 {
 	int err = 0;
 	unsigned long flags;
-	u32 mask = 1 << tag;
 
 	/* clear outstanding transaction before retry */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_utrl_clear(hba, tag);
+	ufshcd_utrl_clear(hba, mask);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/*
@@ -2933,37 +2947,59 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
 {
-	int err = 0;
-	unsigned long time_left;
+	unsigned long time_left = msecs_to_jiffies(max_timeout);
 	unsigned long flags;
+	bool pending;
+	int err;
 
+retry:
 	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
-			msecs_to_jiffies(max_timeout));
+						time_left);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->dev_cmd.complete = NULL;
 	if (likely(time_left)) {
+		/*
+		 * The completion handler called complete() and the caller of
+		 * this function still owns the @lrbp tag so the code below does
+		 * not trigger any race conditions.
+		 */
+		hba->dev_cmd.complete = NULL;
 		err = ufshcd_get_tr_ocs(lrbp);
 		if (!err)
 			err = ufshcd_dev_cmd_completion(hba, lrbp);
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (!time_left) {
+	} else {
 		err = -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
 			__func__, lrbp->task_tag);
-		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
+		if (ufshcd_clear_cmds(hba, 1U << lrbp->task_tag) == 0) {
 			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
-		/*
-		 * in case of an error, after clearing the doorbell,
-		 * we also need to clear the outstanding_request
-		 * field in hba
-		 */
-		spin_lock_irqsave(&hba->outstanding_lock, flags);
-		__clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
-		spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+			/*
+			 * Since clearing the command succeeded we also need to
+			 * clear the task tag bit from the outstanding_reqs
+			 * variable.
+			 */
+			spin_lock_irqsave(&hba->outstanding_lock, flags);
+			pending = test_bit(lrbp->task_tag,
+					   &hba->outstanding_reqs);
+			if (pending) {
+				hba->dev_cmd.complete = NULL;
+				__clear_bit(lrbp->task_tag,
+					    &hba->outstanding_reqs);
+			}
+			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+			if (!pending) {
+				/*
+				 * The completion handler ran while we tried to
+				 * clear the command.
+				 */
+				time_left = 1;
+				goto retry;
+			}
+		} else {
+			dev_err(hba->dev, "%s: failed to clear tag %d\n",
+				__func__, lrbp->task_tag);
+		}
 	}
 
 	return err;
@@ -6988,7 +7024,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
 		if (hba->lrb[pos].lun == lun) {
-			err = ufshcd_clear_cmd(hba, pos);
+			err = ufshcd_clear_cmds(hba, 1U << pos);
 			if (err)
 				break;
 			__ufshcd_transfer_req_compl(hba, 1U << pos);
@@ -7090,7 +7126,7 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
 		goto out;
 	}
 
-	err = ufshcd_clear_cmd(hba, tag);
+	err = ufshcd_clear_cmds(hba, 1U << tag);
 	if (err)
 		dev_err(hba->dev, "%s: Failed clearing cmd at tag %d, err %d\n",
 			__func__, tag, err);
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 2911c04a33e0..080333bda45e 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -592,8 +592,12 @@ static int ntfs_attr_find(const ATTR_TYPE type, const ntfschar *name,
 		a = (ATTR_RECORD*)((u8*)ctx->attr +
 				le32_to_cpu(ctx->attr->length));
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > (u8*)ctx->mrec +
-				le32_to_cpu(ctx->mrec->bytes_allocated))
+		u8 *mrec_end = (u8 *)ctx->mrec +
+		               le32_to_cpu(ctx->mrec->bytes_allocated);
+		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			       a->name_length * sizeof(ntfschar);
+		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
+		    name_end > mrec_end)
 			break;
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 337527571461..740b64238312 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -277,7 +277,6 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
 	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
-	OCFS2_MOUNT_NOCLUSTER = 1 << 18, /* No cluster aware filesystem mount */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
@@ -673,8 +672,7 @@ static inline int ocfs2_cluster_o2cb_global_heartbeat(struct ocfs2_super *osb)
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 {
-	return ((osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT)
-		|| (osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER));
+	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
 }
 
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 0b0ae3ebb0cf..da7718cef735 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -252,16 +252,14 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid ||
-		    !si->si_slots[preferred].sl_node_num) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid ||
-		    !si->si_slots[i].sl_node_num) {
+		if (!si->si_slots[i].sl_valid) {
 			ret = i;
 			break;
 		}
@@ -456,30 +454,24 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	if (ocfs2_mount_local(osb))
-		/* use slot 0 directly in local mode */
-		slot = 0;
-	else {
-		/* search for ourselves first and take the slot if it already
-		 * exists. Perhaps we need to mark this in a variable for our
-		 * own journal recovery? Possibly not, though we certainly
-		 * need to warn to the user */
-		slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	/* search for ourselves first and take the slot if it already
+	 * exists. Perhaps we need to mark this in a variable for our
+	 * own journal recovery? Possibly not, though we certainly
+	 * need to warn to the user */
+	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	if (slot < 0) {
+		/* if no slot yet, then just take 1st available
+		 * one. */
+		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
 		if (slot < 0) {
-			/* if no slot yet, then just take 1st available
-			 * one. */
-			slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
-			if (slot < 0) {
-				spin_unlock(&osb->osb_lock);
-				mlog(ML_ERROR, "no free slots available!\n");
-				status = -EINVAL;
-				goto bail;
-			}
-		} else
-			printk(KERN_INFO "ocfs2: Slot %d on device (%s) was "
-			       "already allocated to this node!\n",
-			       slot, osb->dev_str);
-	}
+			spin_unlock(&osb->osb_lock);
+			mlog(ML_ERROR, "no free slots available!\n");
+			status = -EINVAL;
+			goto bail;
+		}
+	} else
+		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
+		       "allocated to this node!\n", slot, osb->dev_str);
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 311433c69a3f..0535acd2389a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -172,7 +172,6 @@ enum {
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
 	Opt_err_cont,
-	Opt_nocluster,
 	Opt_err,
 };
 
@@ -206,7 +205,6 @@ static const match_table_t tokens = {
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err_cont, "errors=continue"},
-	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL}
 };
 
@@ -618,13 +616,6 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		goto out;
 	}
 
-	tmp = OCFS2_MOUNT_NOCLUSTER;
-	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
-		ret = -EINVAL;
-		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
-		goto out;
-	}
-
 	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
 		OCFS2_MOUNT_HB_NONE;
 	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
@@ -865,7 +856,6 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
-	    !(osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
 	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
@@ -1144,11 +1134,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	       osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK ? "writeback" :
 	       "ordered");
 
-	if ((osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
-	   !(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT))
-		printk(KERN_NOTICE "ocfs2: The shared device (%s) is mounted "
-		       "without cluster aware mode.\n", osb->dev_str);
-
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
@@ -1455,9 +1440,6 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_journal_async_commit:
 			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
 			break;
-		case Opt_nocluster:
-			mopt->mount_opt |= OCFS2_MOUNT_NOCLUSTER;
-			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1569,9 +1551,6 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
 		seq_printf(s, ",journal_async_commit");
 
-	if (opts & OCFS2_MOUNT_NOCLUSTER)
-		seq_printf(s, ",nocluster");
-
 	return 0;
 }
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 671f47d5984c..aca85a5bbb0f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1247,6 +1247,9 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 					  count, fl);
 		file_end_write(out.file);
 	} else {
+		if (out.file->f_flags & O_NONBLOCK)
+			fl |= SPLICE_F_NONBLOCK;
+
 		retval = splice_file_to_pipe(in.file, opipe, &pos, count, fl);
 	}
 
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index aa0c47cb0d16..694096653ea7 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -191,17 +191,19 @@ static inline void msg_init(struct uffd_msg *msg)
 }
 
 static inline struct uffd_msg userfault_msg(unsigned long address,
+					    unsigned long real_address,
 					    unsigned int flags,
 					    unsigned long reason,
 					    unsigned int features)
 {
 	struct uffd_msg msg;
+
 	msg_init(&msg);
 	msg.event = UFFD_EVENT_PAGEFAULT;
 
-	if (!(features & UFFD_FEATURE_EXACT_ADDRESS))
-		address &= PAGE_MASK;
-	msg.arg.pagefault.address = address;
+	msg.arg.pagefault.address = (features & UFFD_FEATURE_EXACT_ADDRESS) ?
+				    real_address : address;
+
 	/*
 	 * These flags indicate why the userfault occurred:
 	 * - UFFD_PAGEFAULT_FLAG_WP indicates a write protect fault.
@@ -485,8 +487,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
-			ctx->features);
+	uwq.msg = userfault_msg(vmf->address, vmf->real_address, vmf->flags,
+				reason, ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 7ce93aaf69f8..98954dda5734 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -1125,9 +1125,7 @@ static inline void memcpy_toio(volatile void __iomem *addr, const void *buffer,
 }
 #endif
 
-#ifndef CONFIG_GENERIC_DEVMEM_IS_ALLOWED
 extern int devmem_is_allowed(unsigned long pfn);
-#endif
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index da08cce2a9fa..b5a115e9bcd5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1130,23 +1130,27 @@ static inline bool is_zone_movable_page(const struct page *page)
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-bool __put_devmap_managed_page(struct page *page);
-static inline bool put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page_refs(struct page *page, int refs);
+static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	return __put_devmap_managed_page(page);
+	return __put_devmap_managed_page_refs(page, refs);
 }
-
 #else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-static inline bool put_devmap_managed_page(struct page *page)
+static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	return false;
 }
 #endif /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
 
+static inline bool put_devmap_managed_page(struct page *page)
+{
+	return put_devmap_managed_page_refs(page, 1);
+}
+
 /* 127: arbitrary random number, small enough to assemble well */
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index f7506f08e505..c04f359655b8 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -405,6 +405,9 @@ static inline bool ip6_ignore_linkdown(const struct net_device *dev)
 {
 	const struct inet6_dev *idev = __in6_dev_get(dev);
 
+	if (unlikely(!idev))
+		return true;
+
 	return !!idev->cnf.ignore_routes_with_linkdown;
 }
 
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 3c4f550e5a8b..2f766e3437ce 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -847,6 +847,7 @@ enum {
 };
 
 void l2cap_chan_hold(struct l2cap_chan *c);
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c);
 void l2cap_chan_put(struct l2cap_chan *c);
 
 static inline void l2cap_chan_lock(struct l2cap_chan *chan)
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 3908296d103f..d24719972900 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -323,7 +323,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
-#define TCP_PINGPONG_THRESH	3
+#define TCP_PINGPONG_THRESH	1
 
 static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
 {
@@ -340,14 +340,6 @@ static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
 	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
 }
 
-static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_ack.pingpong < U8_MAX)
-		icsk->icsk_ack.pingpong++;
-}
-
 static inline bool inet_csk_has_ulp(struct sock *sk)
 {
 	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
diff --git a/include/net/sock.h b/include/net/sock.h
index 6bef0ffb1e7b..9563a093fdfc 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2834,18 +2834,18 @@ static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_wmem ? */
 	if (proto->sysctl_wmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset));
 
-	return *proto->sysctl_wmem;
+	return READ_ONCE(*proto->sysctl_wmem);
 }
 
 static inline int sk_get_rmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_rmem ? */
 	if (proto->sysctl_rmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset));
 
-	return *proto->sysctl_rmem;
+	return READ_ONCE(*proto->sysctl_rmem);
 }
 
 /* Default TCP Small queue budget is ~1 ms of data (1sec >> 10)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4f5de382e192..f618d6a52324 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1437,7 +1437,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space,
 
 static inline int tcp_win_from_space(const struct sock *sk, int space)
 {
-	int tcp_adv_win_scale = sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale;
+	int tcp_adv_win_scale = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale);
 
 	return tcp_adv_win_scale <= 0 ?
 		(space>>(-tcp_adv_win_scale)) :
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index acde5d6f1254..13a78b2b7b32 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -334,8 +334,6 @@ struct rwsem_waiter {
 	struct task_struct *task;
 	enum rwsem_waiter_type type;
 	unsigned long timeout;
-
-	/* Writer only, not initialized in reader */
 	bool handoff_set;
 };
 #define rwsem_first_waiter(sem) \
@@ -455,10 +453,12 @@ static void rwsem_mark_wake(struct rw_semaphore *sem,
 			 * to give up the lock), request a HANDOFF to
 			 * force the issue.
 			 */
-			if (!(oldcount & RWSEM_FLAG_HANDOFF) &&
-			    time_after(jiffies, waiter->timeout)) {
-				adjustment -= RWSEM_FLAG_HANDOFF;
-				lockevent_inc(rwsem_rlock_handoff);
+			if (time_after(jiffies, waiter->timeout)) {
+				if (!(oldcount & RWSEM_FLAG_HANDOFF)) {
+					adjustment -= RWSEM_FLAG_HANDOFF;
+					lockevent_inc(rwsem_rlock_handoff);
+				}
+				waiter->handoff_set = true;
 			}
 
 			atomic_long_add(-adjustment, &sem->count);
@@ -568,7 +568,7 @@ static void rwsem_mark_wake(struct rw_semaphore *sem,
 static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 					struct rwsem_waiter *waiter)
 {
-	bool first = rwsem_first_waiter(sem) == waiter;
+	struct rwsem_waiter *first = rwsem_first_waiter(sem);
 	long count, new;
 
 	lockdep_assert_held(&sem->wait_lock);
@@ -578,11 +578,20 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 		bool has_handoff = !!(count & RWSEM_FLAG_HANDOFF);
 
 		if (has_handoff) {
-			if (!first)
+			/*
+			 * Honor handoff bit and yield only when the first
+			 * waiter is the one that set it. Otherwisee, we
+			 * still try to acquire the rwsem.
+			 */
+			if (first->handoff_set && (waiter != first))
 				return false;
 
-			/* First waiter inherits a previously set handoff bit */
-			waiter->handoff_set = true;
+			/*
+			 * First waiter can inherit a previously set handoff
+			 * bit and spin on rwsem if lock acquisition fails.
+			 */
+			if (waiter == first)
+				waiter->handoff_set = true;
 		}
 
 		new = count;
@@ -972,6 +981,7 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int stat
 	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_READ;
 	waiter.timeout = jiffies + RWSEM_WAIT_TIMEOUT;
+	waiter.handoff_set = false;
 
 	raw_spin_lock_irq(&sem->wait_lock);
 	if (list_empty(&sem->wait_list)) {
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index bb9962b33f95..59ddb00d6944 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -454,6 +454,33 @@ void init_watch(struct watch *watch, struct watch_queue *wqueue)
 	rcu_assign_pointer(watch->queue, wqueue);
 }
 
+static int add_one_watch(struct watch *watch, struct watch_list *wlist, struct watch_queue *wqueue)
+{
+	const struct cred *cred;
+	struct watch *w;
+
+	hlist_for_each_entry(w, &wlist->watchers, list_node) {
+		struct watch_queue *wq = rcu_access_pointer(w->queue);
+		if (wqueue == wq && watch->id == w->id)
+			return -EBUSY;
+	}
+
+	cred = current_cred();
+	if (atomic_inc_return(&cred->user->nr_watches) > task_rlimit(current, RLIMIT_NOFILE)) {
+		atomic_dec(&cred->user->nr_watches);
+		return -EAGAIN;
+	}
+
+	watch->cred = get_cred(cred);
+	rcu_assign_pointer(watch->watch_list, wlist);
+
+	kref_get(&wqueue->usage);
+	kref_get(&watch->usage);
+	hlist_add_head(&watch->queue_node, &wqueue->watches);
+	hlist_add_head_rcu(&watch->list_node, &wlist->watchers);
+	return 0;
+}
+
 /**
  * add_watch_to_object - Add a watch on an object to a watch list
  * @watch: The watch to add
@@ -468,34 +495,21 @@ void init_watch(struct watch *watch, struct watch_queue *wqueue)
  */
 int add_watch_to_object(struct watch *watch, struct watch_list *wlist)
 {
-	struct watch_queue *wqueue = rcu_access_pointer(watch->queue);
-	struct watch *w;
-
-	hlist_for_each_entry(w, &wlist->watchers, list_node) {
-		struct watch_queue *wq = rcu_access_pointer(w->queue);
-		if (wqueue == wq && watch->id == w->id)
-			return -EBUSY;
-	}
-
-	watch->cred = get_current_cred();
-	rcu_assign_pointer(watch->watch_list, wlist);
+	struct watch_queue *wqueue;
+	int ret = -ENOENT;
 
-	if (atomic_inc_return(&watch->cred->user->nr_watches) >
-	    task_rlimit(current, RLIMIT_NOFILE)) {
-		atomic_dec(&watch->cred->user->nr_watches);
-		put_cred(watch->cred);
-		return -EAGAIN;
-	}
+	rcu_read_lock();
 
+	wqueue = rcu_access_pointer(watch->queue);
 	if (lock_wqueue(wqueue)) {
-		kref_get(&wqueue->usage);
-		kref_get(&watch->usage);
-		hlist_add_head(&watch->queue_node, &wqueue->watches);
+		spin_lock(&wlist->lock);
+		ret = add_one_watch(watch, wlist, wqueue);
+		spin_unlock(&wlist->lock);
 		unlock_wqueue(wqueue);
 	}
 
-	hlist_add_head(&watch->list_node, &wlist->watchers);
-	return 0;
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL(add_watch_to_object);
 
diff --git a/mm/gup.c b/mm/gup.c
index f598a037eb04..c5d076d43d9b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -54,7 +54,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	 * belongs to this folio.
 	 */
 	if (unlikely(page_folio(page) != folio)) {
-		folio_put_refs(folio, refs);
+		if (!put_devmap_managed_page_refs(&folio->page, refs))
+			folio_put_refs(folio, refs);
 		goto retry;
 	}
 
@@ -143,7 +144,8 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	folio_put_refs(folio, refs);
+	if (!put_devmap_managed_page_refs(&folio->page, refs))
+		folio_put_refs(folio, refs);
 }
 
 /**
diff --git a/mm/hmm.c b/mm/hmm.c
index af71aac3140e..6ec5ea76f31b 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -212,14 +212,6 @@ int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		unsigned long end, unsigned long hmm_pfns[], pmd_t pmd);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline bool hmm_is_device_private_entry(struct hmm_range *range,
-		swp_entry_t entry)
-{
-	return is_device_private_entry(entry) &&
-		pfn_swap_entry_to_page(entry)->pgmap->owner ==
-		range->dev_private_owner;
-}
-
 static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
 						 pte_t pte)
 {
@@ -252,10 +244,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		/*
-		 * Never fault in device private pages, but just report
-		 * the PFN even if not present.
+		 * Don't fault in device private pages owned by the caller,
+		 * just report the PFN.
 		 */
-		if (hmm_is_device_private_entry(range, entry)) {
+		if (is_device_private_entry(entry) &&
+		    pfn_swap_entry_to_page(entry)->pgmap->owner ==
+		    range->dev_private_owner) {
 			cpu_flags = HMM_PFN_VALID;
 			if (is_writable_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
@@ -273,6 +267,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (!non_swap_entry(entry))
 			goto fault;
 
+		if (is_device_private_entry(entry))
+			goto fault;
+
 		if (is_device_exclusive_entry(entry))
 			goto fault;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 410bbb0aee32..859cfcaecddb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5822,6 +5822,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
 		if (IS_ERR(page)) {
+			put_page(*pagep);
 			ret = -ENOMEM;
 			*pagep = NULL;
 			goto out;
diff --git a/mm/memory.c b/mm/memory.c
index e176ee386238..4ef55c26e114 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4108,9 +4108,12 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return VM_FAULT_OOM;
 	}
 
-	/* See comment in handle_pte_fault() */
+	/*
+	 * See comment in handle_pte_fault() for how this scenario happens, we
+	 * need to return NOPAGE so that we drop this page.
+	 */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
-		return 0;
+		return VM_FAULT_NOPAGE;
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
diff --git a/mm/memremap.c b/mm/memremap.c
index 2554a6b07007..e11653fd348c 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -489,7 +489,7 @@ void free_zone_device_page(struct page *page)
 }
 
 #ifdef CONFIG_FS_DAX
-bool __put_devmap_managed_page(struct page *page)
+bool __put_devmap_managed_page_refs(struct page *page, int refs)
 {
 	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
@@ -499,9 +499,9 @@ bool __put_devmap_managed_page(struct page *page)
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (page_ref_dec_return(page) == 1)
+	if (page_ref_sub_return(page, refs) == 1)
 		wake_up_var(&page->_refcount);
 	return true;
 }
-EXPORT_SYMBOL(__put_devmap_managed_page);
+EXPORT_SYMBOL(__put_devmap_managed_page_refs);
 #endif /* CONFIG_FS_DAX */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5ced6cb260ed..135a081edb82 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3953,11 +3953,15 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 	 * need to be calculated.
 	 */
 	if (!order) {
-		long fast_free;
+		long usable_free;
+		long reserved;
 
-		fast_free = free_pages;
-		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
-		if (fast_free > mark + z->lowmem_reserve[highest_zoneidx])
+		usable_free = free_pages;
+		reserved = __zone_watermark_unusable_free(z, 0, alloc_flags);
+
+		/* reserved may over estimate high-atomic reserves. */
+		usable_free -= min(usable_free, reserved);
+		if (usable_free > mark + z->lowmem_reserve[highest_zoneidx])
 			return true;
 	}
 
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 3b3cf2892b6a..81ff3037bd55 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -55,22 +55,28 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
 	struct page *page;
+	vm_fault_t ret;
 	int err;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return vmf_error(-EINVAL);
 
+	filemap_invalidate_lock_shared(mapping);
+
 retry:
 	page = find_lock_page(mapping, offset);
 	if (!page) {
 		page = alloc_page(gfp | __GFP_ZERO);
-		if (!page)
-			return VM_FAULT_OOM;
+		if (!page) {
+			ret = VM_FAULT_OOM;
+			goto out;
+		}
 
 		err = set_direct_map_invalid_noflush(page);
 		if (err) {
 			put_page(page);
-			return vmf_error(err);
+			ret = vmf_error(err);
+			goto out;
 		}
 
 		__SetPageUptodate(page);
@@ -86,7 +92,8 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			if (err == -EEXIST)
 				goto retry;
 
-			return vmf_error(err);
+			ret = vmf_error(err);
+			goto out;
 		}
 
 		addr = (unsigned long)page_address(page);
@@ -94,7 +101,11 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 	}
 
 	vmf->page = page;
-	return VM_FAULT_LOCKED;
+	ret = VM_FAULT_LOCKED;
+
+out:
+	filemap_invalidate_unlock_shared(mapping);
+	return ret;
 }
 
 static const struct vm_operations_struct secretmem_vm_ops = {
@@ -162,12 +173,20 @@ static int secretmem_setattr(struct user_namespace *mnt_userns,
 			     struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = d_inode(dentry);
+	struct address_space *mapping = inode->i_mapping;
 	unsigned int ia_valid = iattr->ia_valid;
+	int ret;
+
+	filemap_invalidate_lock(mapping);
 
 	if ((ia_valid & ATTR_SIZE) && inode->i_size)
-		return -EINVAL;
+		ret = -EINVAL;
+	else
+		ret = simple_setattr(mnt_userns, dentry, iattr);
 
-	return simple_setattr(mnt_userns, dentry, iattr);
+	filemap_invalidate_unlock(mapping);
+
+	return ret;
 }
 
 static const struct inode_operations secretmem_iops = {
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 351c2390164d..9e2a42299fc0 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4942,6 +4942,9 @@ int hci_suspend_sync(struct hci_dev *hdev)
 		return err;
 	}
 
+	/* Update event mask so only the allowed event can wakeup the host */
+	hci_set_event_mask_sync(hdev);
+
 	/* Only configure accept list if disconnect succeeded and wake
 	 * isn't being prevented.
 	 */
@@ -4953,9 +4956,6 @@ int hci_suspend_sync(struct hci_dev *hdev)
 	/* Unpause to take care of updating scanning params */
 	hdev->scanning_paused = false;
 
-	/* Update event mask so only the allowed event can wakeup the host */
-	hci_set_event_mask_sync(hdev);
-
 	/* Enable event filter for paired devices */
 	hci_update_event_filter_sync(hdev);
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ae78490ecd3d..52668662ae8d 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -111,7 +111,8 @@ static struct l2cap_chan *__l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 }
 
 /* Find channel with given SCID.
- * Returns locked channel. */
+ * Returns a reference locked channel.
+ */
 static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 						 u16 cid)
 {
@@ -119,15 +120,19 @@ static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_scid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
 }
 
 /* Find channel with given DCID.
- * Returns locked channel.
+ * Returns a reference locked channel.
  */
 static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
 						 u16 cid)
@@ -136,8 +141,12 @@ static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_dcid(conn, cid);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -162,8 +171,12 @@ static struct l2cap_chan *l2cap_get_chan_by_ident(struct l2cap_conn *conn,
 
 	mutex_lock(&conn->chan_lock);
 	c = __l2cap_get_chan_by_ident(conn, ident);
-	if (c)
-		l2cap_chan_lock(c);
+	if (c) {
+		/* Only lock if chan reference is not 0 */
+		c = l2cap_chan_hold_unless_zero(c);
+		if (c)
+			l2cap_chan_lock(c);
+	}
 	mutex_unlock(&conn->chan_lock);
 
 	return c;
@@ -497,6 +510,16 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 	kref_get(&c->kref);
 }
 
+struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
+{
+	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
+
+	if (!kref_get_unless_zero(&c->kref))
+		return NULL;
+
+	return c;
+}
+
 void l2cap_chan_put(struct l2cap_chan *c)
 {
 	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
@@ -1968,7 +1991,10 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			src_match = !bacmp(&c->src, src);
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
-				l2cap_chan_hold(c);
+				c = l2cap_chan_hold_unless_zero(c);
+				if (!c)
+					continue;
+
 				read_unlock(&chan_list_lock);
 				return c;
 			}
@@ -1983,7 +2009,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 	}
 
 	if (c1)
-		l2cap_chan_hold(c1);
+		c1 = l2cap_chan_hold_unless_zero(c1);
 
 	read_unlock(&chan_list_lock);
 
@@ -4463,6 +4489,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -4577,6 +4604,7 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 	return err;
 }
 
@@ -5304,6 +5332,7 @@ static inline int l2cap_move_channel_req(struct l2cap_conn *conn,
 	l2cap_send_move_chan_rsp(chan, result);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5396,6 +5425,7 @@ static void l2cap_move_continue(struct l2cap_conn *conn, u16 icid, u16 result)
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
@@ -5425,6 +5455,7 @@ static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
 	l2cap_send_move_chan_cfm(chan, L2CAP_MC_UNCONFIRMED);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static int l2cap_move_channel_rsp(struct l2cap_conn *conn,
@@ -5488,6 +5519,7 @@ static int l2cap_move_channel_confirm(struct l2cap_conn *conn,
 	l2cap_send_move_chan_cfm_rsp(conn, cmd->ident, icid);
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5523,6 +5555,7 @@ static inline int l2cap_move_channel_confirm_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -5895,12 +5928,11 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
 	if (credits > max_credits) {
 		BT_ERR("LE credits overflow");
 		l2cap_send_disconn_req(chan, ECONNRESET);
-		l2cap_chan_unlock(chan);
 
 		/* Return 0 so that we don't trigger an unnecessary
 		 * command reject packet.
 		 */
-		return 0;
+		goto unlock;
 	}
 
 	chan->tx_credits += credits;
@@ -5911,7 +5943,9 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
 	if (chan->tx_credits)
 		chan->ops->resume(chan);
 
+unlock:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
@@ -7597,6 +7631,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 
 done:
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 }
 
 static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
@@ -8085,7 +8120,7 @@ static struct l2cap_chan *l2cap_global_fixed_chan(struct l2cap_chan *c,
 		if (src_type != c->src_type)
 			continue;
 
-		l2cap_chan_hold(c);
+		c = l2cap_chan_hold_unless_zero(c);
 		read_unlock(&chan_list_lock);
 		return c;
 	}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 200ad05b296f..52abc46e8841 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -589,9 +589,13 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	}
 
 done:
+	if (af) {
+		if (nlmsg_get_pos(skb) - (void *)af > nla_attr_size(0))
+			nla_nest_end(skb, af);
+		else
+			nla_nest_cancel(skb, af);
+	}
 
-	if (af)
-		nla_nest_end(skb, af);
 	nlmsg_end(skb, nlh);
 	return 0;
 
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index dc92a67baea3..7d542eb46172 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -480,8 +480,8 @@ static struct sock *dn_alloc_sock(struct net *net, struct socket *sock, gfp_t gf
 	sk->sk_family      = PF_DECnet;
 	sk->sk_protocol    = 0;
 	sk->sk_allocation  = gfp;
-	sk->sk_sndbuf	   = sysctl_decnet_wmem[1];
-	sk->sk_rcvbuf	   = sysctl_decnet_rmem[1];
+	sk->sk_sndbuf	   = READ_ONCE(sysctl_decnet_wmem[1]);
+	sk->sk_rcvbuf	   = READ_ONCE(sysctl_decnet_rmem[1]);
 
 	/* Initialization of DECnet Session Control Port		*/
 	scp = DN_SK(sk);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d8a80cf9742c..52f84ea349d2 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -363,6 +363,7 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
 
 	ether_addr_copy(a->addr, addr);
 	a->vid = vid;
+	a->db = db;
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &lag->fdbs);
 
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 43a496272227..c1b53854047b 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1042,6 +1042,7 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 
 void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 {
+	u8 fib_notify_on_flag_change;
 	struct fib_alias *fa_match;
 	struct sk_buff *skb;
 	int err;
@@ -1063,14 +1064,16 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	WRITE_ONCE(fa_match->offload, fri->offload);
 	WRITE_ONCE(fa_match->trap, fri->trap);
 
+	fib_notify_on_flag_change = READ_ONCE(net->ipv4.sysctl_fib_notify_on_flag_change);
+
 	/* 2 means send notifications only if offload_failed was changed. */
-	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
+	if (fib_notify_on_flag_change == 2 &&
 	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
 	WRITE_ONCE(fa_match->offload_failed, fri->offload_failed);
 
-	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
+	if (!fib_notify_on_flag_change)
 		goto out;
 
 	skb = nlmsg_new(fib_nlmsg_size(fa_match->fa_info), GFP_ATOMIC);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 28db838e604a..91735d631a28 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -452,8 +452,8 @@ void tcp_init_sock(struct sock *sk)
 
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
-	WRITE_ONCE(sk->sk_sndbuf, sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
-	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
 	sk_sockets_allocated_inc(sk);
 }
@@ -686,7 +686,7 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 				int size_goal)
 {
 	return skb->len < size_goal &&
-	       sock_net(sk)->ipv4.sysctl_tcp_autocorking &&
+	       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_autocorking) &&
 	       !tcp_rtx_queue_empty(sk) &&
 	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize &&
 	       tcp_skb_can_collapse_to(skb);
@@ -1743,7 +1743,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		cap = sk->sk_rcvbuf >> 1;
 	else
-		cap = sock_net(sk)->ipv4.sysctl_tcp_rmem[2] >> 1;
+		cap = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
 	val = min(val, cap);
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 
@@ -4481,9 +4481,18 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
 
-	/* check the signature */
-	genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
-						 NULL, skb);
+	/* Check the signature.
+	 * To support dual stack listeners, we need to handle
+	 * IPv4-mapped case.
+	 */
+	if (family == AF_INET)
+		genhash = tcp_v4_md5_hash_skb(newhash,
+					      hash_expected,
+					      NULL, skb);
+	else
+		genhash = tp->af_specific->calc_md5_hash(newhash,
+							 hash_expected,
+							 NULL, skb);
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 19b186a4a8e8..9221c8c7b9a9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -426,7 +426,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 
 	if (sk->sk_sndbuf < sndmem)
 		WRITE_ONCE(sk->sk_sndbuf,
-			   min(sndmem, sock_net(sk)->ipv4.sysctl_tcp_wmem[2]));
+			   min(sndmem, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[2])));
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
@@ -461,7 +461,7 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
 	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
-	int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
+	int window = tcp_win_from_space(sk, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2])) >> 1;
 
 	while (tp->rcv_ssthresh <= window) {
 		if (truesize <= skb->len)
@@ -534,7 +534,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
  */
 static void tcp_init_buffer_space(struct sock *sk)
 {
-	int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
+	int tcp_app_win = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_app_win);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 
@@ -574,16 +574,17 @@ static void tcp_clamp_window(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
+	int rmem2;
 
 	icsk->icsk_ack.quick = 0;
+	rmem2 = READ_ONCE(net->ipv4.sysctl_tcp_rmem[2]);
 
-	if (sk->sk_rcvbuf < net->ipv4.sysctl_tcp_rmem[2] &&
+	if (sk->sk_rcvbuf < rmem2 &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK) &&
 	    !tcp_under_memory_pressure(sk) &&
 	    sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)) {
 		WRITE_ONCE(sk->sk_rcvbuf,
-			   min(atomic_read(&sk->sk_rmem_alloc),
-			       net->ipv4.sysctl_tcp_rmem[2]));
+			   min(atomic_read(&sk->sk_rmem_alloc), rmem2));
 	}
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		tp->rcv_ssthresh = min(tp->window_clamp, 2U * tp->advmss);
@@ -724,7 +725,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 	 * <prev RTT . ><current RTT .. ><next RTT .... >
 	 */
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;
@@ -745,7 +746,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 		do_div(rcvwin, tp->advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		if (rcvbuf > sk->sk_rcvbuf) {
 			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
@@ -910,9 +911,9 @@ static void tcp_update_pacing_rate(struct sock *sk)
 	 *	 end of slow start and should slow down.
 	 */
 	if (tcp_snd_cwnd(tp) < tp->snd_ssthresh / 2)
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio);
 	else
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio);
 
 	rate *= max(tcp_snd_cwnd(tp), tp->packets_out);
 
@@ -2175,7 +2176,7 @@ void tcp_enter_loss(struct sock *sk)
 	 * loss recovery is underway except recurring timeout(s) on
 	 * the same SND.UNA (sec 3.2). Disable F-RTO on path MTU probing
 	 */
-	tp->frto = net->ipv4.sysctl_tcp_frto &&
+	tp->frto = READ_ONCE(net->ipv4.sysctl_tcp_frto) &&
 		   (new_recovery || icsk->icsk_retransmits) &&
 		   !inet_csk(sk)->icsk_mtup.probe_size;
 }
@@ -3058,7 +3059,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 
 static void tcp_update_rtt_min(struct sock *sk, u32 rtt_us, const int flag)
 {
-	u32 wlen = sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen * HZ;
+	u32 wlen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen) * HZ;
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if ((flag & FLAG_ACK_MAYBE_DELAYED) && rtt_us > tcp_min_rtt(tp)) {
@@ -3581,7 +3582,8 @@ static bool __tcp_oow_rate_limited(struct net *net, int mib_idx,
 	if (*last_oow_ack_time) {
 		s32 elapsed = (s32)(tcp_jiffies32 - *last_oow_ack_time);
 
-		if (0 <= elapsed && elapsed < net->ipv4.sysctl_tcp_invalid_ratelimit) {
+		if (0 <= elapsed &&
+		    elapsed < READ_ONCE(net->ipv4.sysctl_tcp_invalid_ratelimit)) {
 			NET_INC_STATS(net, mib_idx);
 			return true;	/* rate-limited: don't send yet! */
 		}
@@ -3629,7 +3631,7 @@ static void tcp_send_challenge_ack(struct sock *sk)
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
 	if (now != challenge_timestamp) {
-		u32 ack_limit = net->ipv4.sysctl_tcp_challenge_ack_limit;
+		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
 		challenge_timestamp = now;
@@ -4426,7 +4428,7 @@ static void tcp_dsack_set(struct sock *sk, u32 seq, u32 end_seq)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+	if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 		int mib_idx;
 
 		if (before(seq, tp->rcv_nxt))
@@ -4473,7 +4475,7 @@ static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 
-		if (tcp_is_sack(tp) && sock_net(sk)->ipv4.sysctl_tcp_dsack) {
+		if (tcp_is_sack(tp) && READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_dsack)) {
 			u32 end_seq = TCP_SKB_CB(skb)->end_seq;
 
 			tcp_rcv_spurious_retrans(sk, skb);
@@ -5523,7 +5525,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	}
 
 	if (!tcp_is_sack(tp) ||
-	    tp->compressed_ack >= sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr)
+	    tp->compressed_ack >= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr))
 		goto send_now;
 
 	if (tp->compressed_ack_rcv_nxt != tp->rcv_nxt) {
@@ -5544,11 +5546,12 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	if (tp->srtt_us && tp->srtt_us < rtt)
 		rtt = tp->srtt_us;
 
-	delay = min_t(unsigned long, sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns,
+	delay = min_t(unsigned long,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns),
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
 	hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(delay),
-			       sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns,
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns),
 			       HRTIMER_MODE_REL_PINNED_SOFT);
 }
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a57f96b86874..1db9938163c4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1007,7 +1007,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
 
-		tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+		tos = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
 				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
 				(inet_sk(sk)->tos & INET_ECN_MASK) :
 				inet_sk(sk)->tos;
@@ -1527,7 +1527,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	/* Set ToS of the new socket based upon the value of incoming SYN.
 	 * ECT bits are set later in tcp_init_transfer().
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
 		newinet->tos = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
 	if (!dst) {
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index a501150deaa3..d58e672be31c 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -329,7 +329,7 @@ void tcp_update_metrics(struct sock *sk)
 	int m;
 
 	sk_dst_confirm(sk);
-	if (net->ipv4.sysctl_tcp_nometrics_save || !dst)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_nometrics_save) || !dst)
 		return;
 
 	rcu_read_lock();
@@ -385,7 +385,7 @@ void tcp_update_metrics(struct sock *sk)
 
 	if (tcp_in_initial_slowstart(tp)) {
 		/* Slow start still did not finish. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && (tcp_snd_cwnd(tp) >> 1) > val)
@@ -401,7 +401,7 @@ void tcp_update_metrics(struct sock *sk)
 	} else if (!tcp_in_slow_start(tp) &&
 		   icsk->icsk_ca_state == TCP_CA_Open) {
 		/* Cong. avoidance phase, cwnd is reliable. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
 			tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
 				       max(tcp_snd_cwnd(tp) >> 1, tp->snd_ssthresh));
@@ -418,7 +418,7 @@ void tcp_update_metrics(struct sock *sk)
 			tcp_metric_set(tm, TCP_METRIC_CWND,
 				       (val + tp->snd_ssthresh) >> 1);
 		}
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && tp->snd_ssthresh > val)
@@ -463,7 +463,7 @@ void tcp_init_metrics(struct sock *sk)
 	if (tcp_metric_locked(tm, TCP_METRIC_CWND))
 		tp->snd_cwnd_clamp = tcp_metric_get(tm, TCP_METRIC_CWND);
 
-	val = net->ipv4.sysctl_tcp_no_ssthresh_metrics_save ?
+	val = READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) ?
 	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 	if (val) {
 		tp->snd_ssthresh = val;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3554a4c1e1b8..a7f0a1f0c2a3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -167,16 +167,13 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
 
-	/* If this is the first data packet sent in response to the
-	 * previous received data,
-	 * and it is a reply for ato after last received packet,
-	 * increase pingpong count.
-	 */
-	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
-	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
-		inet_csk_inc_pingpong_cnt(sk);
-
 	tp->lsndtime = now;
+
+	/* If it is a reply for ato after last received
+	 * packet, enter pingpong mode.
+	 */
+	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+		inet_csk_enter_pingpong_mode(sk);
 }
 
 /* Account for an ACK we sent. */
@@ -230,7 +227,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	 * which we interpret as a sign the remote TCP is not
 	 * misinterpreting the window field as a signed quantity.
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows))
 		(*rcv_wnd) = min(space, MAX_TCP_WINDOW);
 	else
 		(*rcv_wnd) = min_t(u32, space, U16_MAX);
@@ -241,7 +238,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	*rcv_wscale = 0;
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
-		space = max_t(u32, space, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+		space = max_t(u32, space, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		space = max_t(u32, space, sysctl_rmem_max);
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
@@ -285,7 +282,7 @@ static u16 tcp_select_window(struct sock *sk)
 	 * scaled window.
 	 */
 	if (!tp->rx_opt.rcv_wscale &&
-	    sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows))
 		new_win = min(new_win, MAX_TCP_WINDOW);
 	else
 		new_win = min(new_win, (65535U << tp->rx_opt.rcv_wscale));
@@ -1974,7 +1971,7 @@ static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
 
 	bytes = sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift);
 
-	r = tcp_min_rtt(tcp_sk(sk)) >> sock_net(sk)->ipv4.sysctl_tcp_tso_rtt_log;
+	r = tcp_min_rtt(tcp_sk(sk)) >> READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tso_rtt_log);
 	if (r < BITS_PER_TYPE(sk->sk_gso_max_size))
 		bytes += sk->sk_gso_max_size >> r;
 
@@ -1993,7 +1990,7 @@ static u32 tcp_tso_segs(struct sock *sk, unsigned int mss_now)
 
 	min_tso = ca_ops->min_tso_segs ?
 			ca_ops->min_tso_segs(sk) :
-			sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs;
+			READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_tso_segs);
 
 	tso_segs = tcp_tso_autosize(sk, mss_now, min_tso);
 	return min_t(u32, tso_segs, sk->sk_gso_max_segs);
@@ -2505,7 +2502,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift));
 	if (sk->sk_pacing_status == SK_PACING_NONE)
 		limit = min_t(unsigned long, limit,
-			      sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
+			      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes));
 	limit <<= factor;
 
 	if (static_branch_unlikely(&tcp_tx_delay_enabled) &&
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7f695c39d9a8..87c699d57b36 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1522,7 +1522,6 @@ static void mld_query_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_query_work, 0);
 			break;
 		}
 	}
@@ -1533,8 +1532,10 @@ static void mld_query_work(struct work_struct *work)
 		__mld_query_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_query_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 /* called with rcu_read_lock() */
@@ -1624,7 +1625,6 @@ static void mld_report_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_report_work, 0);
 			break;
 		}
 	}
@@ -1635,8 +1635,10 @@ static void mld_report_work(struct work_struct *work)
 		__mld_report_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_report_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ecf3a553a0dc..8c6c2d82c1cd 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -22,6 +22,11 @@
 #include <linux/proc_fs.h>
 #include <net/ping.h>
 
+static void ping_v6_destroy(struct sock *sk)
+{
+	inet6_destroy_sock(sk);
+}
+
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
 				 int *addr_len)
@@ -181,6 +186,7 @@ struct proto pingv6_prot = {
 	.owner =	THIS_MODULE,
 	.init =		ping_init_sock,
 	.close =	ping_close,
+	.destroy =	ping_v6_destroy,
 	.connect =	ip6_datagram_connect_v6_only,
 	.disconnect =	__udp_disconnect,
 	.setsockopt =	ipv6_setsockopt,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5185c11dc444..979e0d7b2119 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -546,7 +546,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		if (np->repflow && ireq->pktopts)
 			fl6->flowlabel = ip6_flowlabel(ipv6_hdr(ireq->pktopts));
 
-		tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+		tclass = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
 				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
 				(np->tclass & INET_ECN_MASK) :
 				np->tclass;
@@ -1314,7 +1314,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	/* Set ToS of the new socket based upon the value of incoming SYN.
 	 * ECT bits are set later in tcp_init_transfer().
 	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos))
 		newnp->tclass = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
 
 	/* Clone native IPv6 options from listening socket (if any)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b52fd250cb3a..07b5a2044cab 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1882,7 +1882,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 	if (msk->rcvq_space.copied <= msk->rcvq_space.space)
 		goto new_measure;
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf) &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
 		int rcvmem, rcvbuf;
 		u64 rcvwin, grow;
@@ -1900,7 +1900,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 
 		do_div(rcvwin, advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 
 		if (rcvbuf > sk->sk_rcvbuf) {
 			u32 window_clamp;
@@ -2597,8 +2597,8 @@ static int mptcp_init_sock(struct sock *sk)
 	mptcp_ca_reset(sk);
 
 	sk_sockets_allocated_inc(sk);
-	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
-	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	sk->sk_sndbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
 
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a364f8e5e698..87a9009d5234 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -843,11 +843,16 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 }
 
 static int
-nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e, int diff)
+nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
 	struct sk_buff *nskb;
 
 	if (diff < 0) {
+		unsigned int min_len = skb_transport_offset(e->skb);
+
+		if (data_len < min_len)
+			return -EINVAL;
+
 		if (pskb_trim(e->skb, data_len))
 			return -ENOMEM;
 	} else if (diff > 0) {
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index be29da09cc7a..3460abceba44 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -229,9 +229,8 @@ static struct sctp_association *sctp_association_init(
 	if (!sctp_ulpq_init(&asoc->ulpq, asoc))
 		goto fail_init;
 
-	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams,
-			     0, gfp))
-		goto fail_init;
+	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams, 0, gfp))
+		goto stream_free;
 
 	/* Initialize default path MTU. */
 	asoc->pathmtu = sp->pathmtu;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 6dc95dcc0ff4..ef9fceadef8d 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -137,7 +137,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	for (i = 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
@@ -145,22 +145,9 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
-		goto out;
-
-	ret = sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret)
-		goto in_err;
-
-	goto out;
+		return 0;
 
-in_err:
-	sched->free(stream);
-	genradix_free(&stream->in);
-out_err:
-	genradix_free(&stream->out);
-	stream->outcnt = 0;
-out:
-	return ret;
+	return sctp_stream_alloc_in(stream, incnt, gfp);
 }
 
 int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 99e5f69fbb74..a2e1d34f52c5 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -163,7 +163,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 		if (!SCTP_SO(&asoc->stream, i)->ext)
 			continue;
 
-		ret = n->init_sid(&asoc->stream, i, GFP_KERNEL);
+		ret = n->init_sid(&asoc->stream, i, GFP_ATOMIC);
 		if (ret)
 			goto err;
 	}
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 43509c7e90fc..f1c3b8eb4b3d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -517,7 +517,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	timer_setup(&sk->sk_timer, tipc_sk_timeout, 0);
 	sk->sk_shutdown = 0;
 	sk->sk_backlog_rcv = tipc_sk_backlog_rcv;
-	sk->sk_rcvbuf = sysctl_tipc_rmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sysctl_tipc_rmem[1]);
 	sk->sk_data_ready = tipc_data_ready;
 	sk->sk_write_space = tipc_write_space;
 	sk->sk_destruct = tipc_sock_destruct;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 9c3933781ad4..b1f3d336cdae 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1351,8 +1351,13 @@ static int tls_device_down(struct net_device *netdev)
 		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
 		 * Now release the ref taken above.
 		 */
-		if (refcount_dec_and_test(&ctx->refcount))
+		if (refcount_dec_and_test(&ctx->refcount)) {
+			/* sk_destruct ran after tls_device_down took a ref, and
+			 * it returned early. Complete the destruction here.
+			 */
+			list_del(&ctx->list);
 			tls_device_free_ctx(ctx);
+		}
 	}
 
 	up_write(&device_offload_lock);
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index ecd377938eea..ef6ced5c5746 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -233,6 +233,33 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	return NULL;
 }
 
+static int elf_read_program_header(Elf *elf, u64 vaddr, GElf_Phdr *phdr)
+{
+	size_t i, phdrnum;
+	u64 sz;
+
+	if (elf_getphdrnum(elf, &phdrnum))
+		return -1;
+
+	for (i = 0; i < phdrnum; i++) {
+		if (gelf_getphdr(elf, i, phdr) == NULL)
+			return -1;
+
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		sz = max(phdr->p_memsz, phdr->p_filesz);
+		if (!sz)
+			continue;
+
+		if (vaddr >= phdr->p_vaddr && (vaddr < phdr->p_vaddr + sz))
+			return 0;
+	}
+
+	/* Not found any valid program header */
+	return -1;
+}
+
 static bool want_demangle(bool is_kernel_sym)
 {
 	return is_kernel_sym ? symbol_conf.demangle_kernel : symbol_conf.demangle;
@@ -1209,6 +1236,7 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 					sym.st_value);
 			used_opd = true;
 		}
+
 		/*
 		 * When loading symbols in a data mapping, ABS symbols (which
 		 * has a value of SHN_ABS in its st_shndx) failed at
@@ -1262,11 +1290,20 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 				goto out_elf_end;
 		} else if ((used_opd && runtime_ss->adjust_symbols) ||
 			   (!used_opd && syms_ss->adjust_symbols)) {
+			GElf_Phdr phdr;
+
+			if (elf_read_program_header(syms_ss->elf,
+						    (u64)sym.st_value, &phdr)) {
+				pr_warning("%s: failed to find program header for "
+					   "symbol: %s st_value: %#" PRIx64 "\n",
+					   __func__, elf_name, (u64)sym.st_value);
+				continue;
+			}
 			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
-				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
-				  (u64)sym.st_value, (u64)shdr.sh_addr,
-				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+				  "p_vaddr: %#" PRIx64 " p_offset: %#" PRIx64 "\n",
+				  __func__, (u64)sym.st_value, (u64)phdr.p_vaddr,
+				  (u64)phdr.p_offset);
+			sym.st_value -= phdr.p_vaddr - phdr.p_offset;
 		}
 
 		demangled = demangle_sym(dso, kmodule, elf_name);
