Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC06965A5
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 15:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjBNOBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 09:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjBNOBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 09:01:03 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA32C29E12
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ml19so40460939ejb.0
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 06:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjzsS5Cb3Aw1I5GcqBzV0WBKikDqzXmefD2Bm8OuvxM=;
        b=DXD07MYGL/qMhfo7M2UuGhPfJ1PcwuCtQMN3vyc0nt+nbJWuFnFPYWgXOR0kQ73nkA
         Pp+M/+dpvq6/5n/rFPPggX8WWD3sfGS2GInW/yiG2j4krnv+hCv9EHbKLTWUnQz8Ujj6
         kDBcAMBo8nGjHbNN0q8XWNGVF8CMwlOHFl+X6KgGy8fNtlzEoOZD2YN3matCRiRYdnAo
         1CjOK114DE/U7z8MnWsC3LrNP4SVxEK5l9oxd9sbgtsnytCKc7ivyZ/9ezmzrcsFvW2n
         AQwuHN9czHJw+tF/bmWsjn2pkUk25fnAbzNsKCKFOMlNVYJwsCQbXQW+ytdQigw4hi/Q
         Cuiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjzsS5Cb3Aw1I5GcqBzV0WBKikDqzXmefD2Bm8OuvxM=;
        b=PlGqLVmL5fsSiqKMmHCJS2yKExbiawxS1Gg+WNV3wkM4UCBgJcmzhrBcCXBtskkVq8
         PXBvG9EWyNxQk4u4i179yzgtdLh0MM4nqNWMvbHzCFCz/gfoh7T3DSRv0Q2e6ZlYceNu
         1g+2SZiwv265KSiMsfri+xnXo2oI9Q6G1H2z3Giit6i3YAfMQSjqW7CTU3Sm4xvsHoxN
         oyhPHe+4k6jJ6k5A/+JfSQuCclVLi1tEGdMG8uI+WT4Ugr6NDjCuqueVI7xxLqIztJKO
         vBcCl2G0w0vykmo1BqbJwpV4GzsjNoIKNmXOKVyK7TqdpfFlkxUGb86kUT8P9tk5jnSA
         PORA==
X-Gm-Message-State: AO0yUKW0ZK/Nj0vE5ft1ShL6Ehvi0UTIJVWM0KIPB6IHHf2v368FRTVS
        cxW1bzJHydJV/yCjSb0UzXE=
X-Google-Smtp-Source: AK7set+VvQ6qStzEZ+VuQpG3IrF/cKDSMUXhDij7P+Yp45pyAKvQ3Gm7KuP8sPf1vY1AXzK8anAVpw==
X-Received: by 2002:a17:907:9602:b0:87e:9441:4c6c with SMTP id gb2-20020a170907960200b0087e94414c6cmr3871672ejc.49.1676383230466;
        Tue, 14 Feb 2023 06:00:30 -0800 (PST)
Received: from A13PC04R.einet.ad.eivd.ch ([193.134.219.72])
        by smtp.googlemail.com with ESMTPSA id r1-20020a17090638c100b0088091cca1besm8273624ejd.134.2023.02.14.06.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:00:30 -0800 (PST)
From:   Rick Wertenbroek <rick.wertenbroek@gmail.com>
To:     rick.wertenbroek@heig-vd.ch
Cc:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 6/9] PCI: rockchip: Fix window mapping and address translation for endpoint
Date:   Tue, 14 Feb 2023 14:56:27 +0100
Message-Id: <20230214135630.1131245-7-rick.wertenbroek@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214135630.1131245-1-rick.wertenbroek@gmail.com>
References: <20230214135630.1131245-1-rick.wertenbroek@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The RK3399 PCI endpoint core has 33 windows for PCIe space, now in the
driver up to 32 fixed size (1M) windows are used and pages are allocated
and mapped accordingly. The driver first used a single window and allocated
space inside which caused translation issues (between CPU space and PCI
space) because a window can only have a single translation at a given
time, which if multiple pages are allocated inside will cause conflicts.
Now each window is a single region of 1M which will always guarantee that
the translation is not in conflict.

Set the translation register addresses for physical function. As documented
in the technical reference manual (TRM) section 17.5.5 "PCIe Address
Translation" and section 17.6.8 "Address Translation Registers Description"

Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Cc: stable@vger.kernel.org
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 67 ++++++++++++-----------
 drivers/pci/controller/pcie-rockchip.h    | 25 +++++----
 2 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 4c84e403e..cbc281a6a 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -76,11 +76,17 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
 	if (num_pass_bits < 8)
 		num_pass_bits = 8;
 
-	cpu_addr -= rockchip->mem_res->start;
-	addr0 = ((is_nor_msg ? 0x10 : (num_pass_bits - 1)) &
-		PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
-		(lower_32_bits(cpu_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
-	addr1 = upper_32_bits(is_nor_msg ? cpu_addr : pci_addr);
+	if (is_nor_msg) {
+		dev_warn(rockchip->dev, "NOR MSG\n");
+		cpu_addr -= rockchip->mem_res->start;
+		addr0 = (0x10 & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
+			(lower_32_bits(cpu_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
+		addr1 = upper_32_bits(cpu_addr);
+	} else {
+		addr0 = (num_pass_bits & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
+			(lower_32_bits(pci_addr) & PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
+		addr1 = upper_32_bits(pci_addr);
+	}
 	desc0 = ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(fn) | type;
 	desc1 = 0;
 
@@ -103,12 +109,6 @@ static void rockchip_pcie_prog_ep_ob_atu(struct rockchip_pcie *rockchip, u8 fn,
 				    ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r));
 		rockchip_pcie_write(rockchip, desc1,
 				    ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r));
-
-		addr0 =
-		    ((num_pass_bits - 1) & PCIE_CORE_OB_REGION_ADDR0_NUM_BITS) |
-		    (lower_32_bits(cpu_addr) &
-		     PCIE_CORE_OB_REGION_ADDR0_LO_ADDR);
-		addr1 = upper_32_bits(cpu_addr);
 	}
 }
 
@@ -256,15 +256,7 @@ static int rockchip_pcie_ep_map_addr(struct pci_epc *epc, u8 fn, u8 vfn,
 	struct rockchip_pcie *pcie = &ep->rockchip;
 	u32 r;
 
-	r = find_first_zero_bit(&ep->ob_region_map, BITS_PER_LONG);
-	/*
-	 * Region 0 is reserved for configuration space and shouldn't
-	 * be used elsewhere per TRM, so leave it out.
-	 */
-	if (r >= ep->max_regions - 1) {
-		dev_err(&epc->dev, "no free outbound region\n");
-		return -EINVAL;
-	}
+	r = (addr >> ilog2(SZ_1M)) & 0x1f;
 
 	rockchip_pcie_prog_ep_ob_atu(pcie, fn, r, AXI_WRAPPER_MEM_WRITE, addr,
 				     pci_addr, size);
@@ -282,15 +274,11 @@ static void rockchip_pcie_ep_unmap_addr(struct pci_epc *epc, u8 fn, u8 vfn,
 	struct rockchip_pcie *rockchip = &ep->rockchip;
 	u32 r;
 
-	for (r = 0; r < ep->max_regions - 1; r++)
+	for (r = 0; r < ep->max_regions; r++)
 		if (ep->ob_addr[r] == addr)
 			break;
 
-	/*
-	 * Region 0 is reserved for configuration space and shouldn't
-	 * be used elsewhere per TRM, so leave it out.
-	 */
-	if (r == ep->max_regions - 1)
+	if (r == ep->max_regions)
 		return;
 
 	rockchip_pcie_clear_ep_ob_atu(rockchip, r);
@@ -411,6 +399,7 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
 	u16 flags, mme, data, data_mask;
 	u8 msi_count;
 	u64 pci_addr, pci_addr_mask = 0xff;
+	u32 r;
 
 	/* Check MSI enable bit */
 	flags = rockchip_pcie_read(&ep->rockchip,
@@ -444,12 +433,12 @@ static int rockchip_pcie_ep_send_msi_irq(struct rockchip_pcie_ep *ep, u8 fn,
 				       ROCKCHIP_PCIE_EP_FUNC_BASE(fn) +
 				       ROCKCHIP_PCIE_EP_MSI_CTRL_REG +
 				       PCI_MSI_ADDRESS_LO);
-	pci_addr &= GENMASK_ULL(63, 2);
 
 	/* Set the outbound region if needed. */
 	if (unlikely(ep->irq_pci_addr != (pci_addr & ~pci_addr_mask) ||
 		     ep->irq_pci_fn != fn)) {
-		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, ep->max_regions - 1,
+		r = (ep->irq_phys_addr >> ilog2(SZ_1M)) & 0x1f;
+		rockchip_pcie_prog_ep_ob_atu(rockchip, fn, r,
 					     AXI_WRAPPER_MEM_WRITE,
 					     ep->irq_phys_addr,
 					     pci_addr & ~pci_addr_mask,
@@ -539,6 +528,8 @@ static int rockchip_pcie_parse_ep_dt(struct rockchip_pcie *rockchip,
 	if (err < 0 || ep->max_regions > MAX_REGION_LIMIT)
 		ep->max_regions = MAX_REGION_LIMIT;
 
+	ep->ob_region_map = 0;
+
 	err = of_property_read_u8(dev->of_node, "max-functions",
 				  &ep->epc->max_functions);
 	if (err < 0)
@@ -559,7 +550,10 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 	struct rockchip_pcie *rockchip;
 	struct pci_epc *epc;
 	size_t max_regions;
+	struct pci_epc_mem_window *windows = NULL;
 	int err;
+	u32 cfg;
+	int i;
 
 	ep = devm_kzalloc(dev, sizeof(*ep), GFP_KERNEL);
 	if (!ep)
@@ -606,15 +600,26 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
 	/* Only enable function 0 by default */
 	rockchip_pcie_write(rockchip, BIT(0), PCIE_CORE_PHY_FUNC_CFG);
 
-	err = pci_epc_mem_init(epc, rockchip->mem_res->start,
-			       resource_size(rockchip->mem_res), PAGE_SIZE);
+	windows = devm_kcalloc(dev, ep->max_regions, sizeof(struct pci_epc_mem_window), GFP_KERNEL);
+	if (!windows) {
+		err = -ENOMEM;
+		goto err_uninit_port;
+	}
+	for (i = 0; i < ep->max_regions; i++) {
+		windows[i].phys_base = rockchip->mem_res->start + (SZ_1M * i);
+		windows[i].size = SZ_1M;
+		windows[i].page_size = SZ_1M;
+	}
+	err = pci_epc_multi_mem_init(epc, windows, ep->max_regions);
+	devm_kfree(dev, windows);
+
 	if (err < 0) {
 		dev_err(dev, "failed to initialize the memory space\n");
 		goto err_uninit_port;
 	}
 
 	ep->irq_cpu_addr = pci_epc_mem_alloc_addr(epc, &ep->irq_phys_addr,
-						  SZ_128K);
+						  SZ_1M);
 	if (!ep->irq_cpu_addr) {
 		dev_err(dev, "failed to reserve memory space for MSI\n");
 		err = -ENOMEM;
diff --git a/drivers/pci/controller/pcie-rockchip.h b/drivers/pci/controller/pcie-rockchip.h
index f3a5ff1cf..72e427a0f 100644
--- a/drivers/pci/controller/pcie-rockchip.h
+++ b/drivers/pci/controller/pcie-rockchip.h
@@ -134,6 +134,7 @@
 
 #define PCIE_RC_RP_ATS_BASE		0x400000
 #define PCIE_RC_CONFIG_NORMAL_BASE	0x800000
+#define PCIE_EP_PF_CONFIG_REGS_BASE	0x800000
 #define PCIE_RC_CONFIG_BASE		0xa00000
 #define PCIE_EP_CONFIG_BASE		0xa00000
 #define PCIE_EP_CONFIG_DID_VID		(PCIE_EP_CONFIG_BASE + 0x00)
@@ -228,13 +229,14 @@
 #define   ROCKCHIP_PCIE_EP_MSI_CTRL_MASK_MSI_CAP	BIT(24)
 #define ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR				0x1
 #define ROCKCHIP_PCIE_EP_PCI_LEGACY_IRQ_ADDR		0x3
-#define ROCKCHIP_PCIE_EP_FUNC_BASE(fn)	(((fn) << 12) & GENMASK(19, 12))
+#define ROCKCHIP_PCIE_EP_FUNC_BASE(fn) \
+	(PCIE_EP_PF_CONFIG_REGS_BASE + (((fn) << 12) & GENMASK(19, 12)))
+#define ROCKCHIP_PCIE_EP_VIRT_FUNC_BASE(fn) \
+	(PCIE_EP_PF_CONFIG_REGS_BASE + 0x10000 + (((fn) << 12) & GENMASK(19, 12)))
 #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR0(fn, bar) \
-	(PCIE_RC_RP_ATS_BASE + 0x0840 + (fn) * 0x0040 + (bar) * 0x0008)
+	(PCIE_CORE_AXI_CONF_BASE + 0x0828 + (fn) * 0x0040 + (bar) * 0x0008)
 #define ROCKCHIP_PCIE_AT_IB_EP_FUNC_BAR_ADDR1(fn, bar) \
-	(PCIE_RC_RP_ATS_BASE + 0x0844 + (fn) * 0x0040 + (bar) * 0x0008)
-#define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r) \
-	(PCIE_RC_RP_ATS_BASE + 0x0000 + ((r) & 0x1f) * 0x0020)
+	(PCIE_CORE_AXI_CONF_BASE + 0x082c + (fn) * 0x0040 + (bar) * 0x0008)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_DEVFN_MASK	GENMASK(19, 12)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_DEVFN(devfn) \
 	(((devfn) << 12) & \
@@ -242,20 +244,19 @@
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS_MASK	GENMASK(27, 20)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS(bus) \
 		(((bus) << 20) & ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0_BUS_MASK)
+#define PCIE_RC_EP_ATR_OB_REGIONS_1_32 (PCIE_CORE_AXI_CONF_BASE + 0x0020)
+#define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR0(r) \
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0000 + ((r) & 0x1f) * 0x0020)
 #define ROCKCHIP_PCIE_AT_OB_REGION_PCI_ADDR1(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x0004 + ((r) & 0x1f) * 0x0020)
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0004 + ((r) & 0x1f) * 0x0020)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_HARDCODED_RID	BIT(23)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN_MASK	GENMASK(31, 24)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN(devfn) \
 		(((devfn) << 24) & ROCKCHIP_PCIE_AT_OB_REGION_DESC0_DEVFN_MASK)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC0(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x0008 + ((r) & 0x1f) * 0x0020)
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x0008 + ((r) & 0x1f) * 0x0020)
 #define ROCKCHIP_PCIE_AT_OB_REGION_DESC1(r)	\
-		(PCIE_RC_RP_ATS_BASE + 0x000c + ((r) & 0x1f) * 0x0020)
-#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR0(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x0018 + ((r) & 0x1f) * 0x0020)
-#define ROCKCHIP_PCIE_AT_OB_REGION_CPU_ADDR1(r) \
-		(PCIE_RC_RP_ATS_BASE + 0x001c + ((r) & 0x1f) * 0x0020)
+		(PCIE_RC_EP_ATR_OB_REGIONS_1_32 + 0x000c + ((r) & 0x1f) * 0x0020)
 
 #define ROCKCHIP_PCIE_CORE_EP_FUNC_BAR_CFG0(fn) \
 		(PCIE_CORE_CTRL_MGMT_BASE + 0x0240 + (fn) * 0x0008)
-- 
2.25.1

