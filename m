Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2923141737B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345173AbhIXM4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344103AbhIXMy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E292161267;
        Fri, 24 Sep 2021 12:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487849;
        bh=GDtNGAoovjQRcaxdNv2ul0SjCP2AWSi3Arrqxp7ED+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqJmTGfhrfR/9LA+4DWX3FFtFV+skgj9oHkyJWqKtn8Ue9omLMjj7tOyYJUDO7yoQ
         kXOC1z+JwpO6dMo0BsrWvY+//28Z/aWzVjN1h4woBVDX9oaFH0SfQE++Z4CX411wUK
         ut2LTEJK87O25CPeAq6QWKI7vzCAoJbU1gSaZwAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 04/50] PCI: aardvark: Fix reporting CRS value
Date:   Fri, 24 Sep 2021 14:43:53 +0200
Message-Id: <20210924124332.386165831@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 43f5c77bcbd27cce70bf33c2b86d6726ce95dd66 upstream.

Set CRSVIS flag in emulated root PCI bridge to indicate support for
Completion Retry Status.

Add check for CRSSVE flag from root PCI brige when issuing Configuration
Read Request via PIO to correctly returns fabricated CRS value as it is
required by PCIe spec.

Link: https://lore.kernel.org/r/20210722144041.12661-5-pali@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org # e0d9d30b7354 ("PCI: pci-bridge-emul: Fix big-endian support")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   67 +++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -188,6 +188,8 @@
 
 #define MSI_IRQ_NUM			32
 
+#define CFG_RD_CRS_VAL			0xffff0001
+
 struct advk_pcie {
 	struct platform_device *pdev;
 	void __iomem *base;
@@ -365,7 +367,7 @@ static void advk_pcie_setup_hw(struct ad
 	advk_writel(pcie, reg, PCIE_CORE_CMD_STATUS_REG);
 }
 
-static int advk_pcie_check_pio_status(struct advk_pcie *pcie, u32 *val)
+static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u32 *val)
 {
 	struct device *dev = &pcie->pdev->dev;
 	u32 reg;
@@ -407,9 +409,30 @@ static int advk_pcie_check_pio_status(st
 		strcomp_status = "UR";
 		break;
 	case PIO_COMPLETION_STATUS_CRS:
+		if (allow_crs && val) {
+			/* PCIe r4.0, sec 2.3.2, says:
+			 * If CRS Software Visibility is enabled:
+			 * For a Configuration Read Request that includes both
+			 * bytes of the Vendor ID field of a device Function's
+			 * Configuration Space Header, the Root Complex must
+			 * complete the Request to the host by returning a
+			 * read-data value of 0001h for the Vendor ID field and
+			 * all '1's for any additional bytes included in the
+			 * request.
+			 *
+			 * So CRS in this case is not an error status.
+			 */
+			*val = CFG_RD_CRS_VAL;
+			strcomp_status = NULL;
+			break;
+		}
 		/* PCIe r4.0, sec 2.3.2, says:
 		 * If CRS Software Visibility is not enabled, the Root Complex
 		 * must re-issue the Configuration Request as a new Request.
+		 * If CRS Software Visibility is enabled: For a Configuration
+		 * Write Request or for any other Configuration Read Request,
+		 * the Root Complex must re-issue the Configuration Request as
+		 * a new Request.
 		 * A Root Complex implementation may choose to limit the number
 		 * of Configuration Request/CRS Completion Status loops before
 		 * determining that something is wrong with the target of the
@@ -478,6 +501,7 @@ advk_pci_bridge_emul_pcie_conf_read(stru
 	case PCI_EXP_RTCTL: {
 		u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG);
 		*value = (val & PCIE_MSG_PM_PME_MASK) ? 0 : PCI_EXP_RTCTL_PMEIE;
+		*value |= PCI_EXP_RTCAP_CRSVIS << 16;
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
 
@@ -559,6 +583,7 @@ static struct pci_bridge_emul_ops advk_p
 static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 {
 	struct pci_bridge_emul *bridge = &pcie->bridge;
+	int ret;
 
 	bridge->conf.vendor = advk_readl(pcie, PCIE_CORE_DEV_ID_REG) & 0xffff;
 	bridge->conf.device = advk_readl(pcie, PCIE_CORE_DEV_ID_REG) >> 16;
@@ -580,7 +605,15 @@ static int advk_sw_pci_bridge_init(struc
 	bridge->data = pcie;
 	bridge->ops = &advk_pci_bridge_emul_ops;
 
-	return pci_bridge_emul_init(bridge, 0);
+	/* PCIe config space can be initialized after pci_bridge_emul_init() */
+	ret = pci_bridge_emul_init(bridge, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Indicates supports for Completion Retry Status */
+	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
+
+	return 0;
 }
 
 static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
@@ -625,6 +658,7 @@ static int advk_pcie_rd_conf(struct pci_
 			     int where, int size, u32 *val)
 {
 	struct advk_pcie *pcie = bus->sysdata;
+	bool allow_crs;
 	u32 reg;
 	int ret;
 
@@ -637,7 +671,24 @@ static int advk_pcie_rd_conf(struct pci_
 		return pci_bridge_emul_conf_read(&pcie->bridge, where,
 						 size, val);
 
+	/*
+	 * Completion Retry Status is possible to return only when reading all
+	 * 4 bytes from PCI_VENDOR_ID and PCI_DEVICE_ID registers at once and
+	 * CRSSVE flag on Root Bridge is enabled.
+	 */
+	allow_crs = (where == PCI_VENDOR_ID) && (size == 4) &&
+		    (le16_to_cpu(pcie->bridge.pcie_conf.rootctl) &
+		     PCI_EXP_RTCTL_CRSSVE);
+
 	if (advk_pcie_pio_is_running(pcie)) {
+		/*
+		 * If it is possible return Completion Retry Status so caller
+		 * tries to issue the request again instead of failing.
+		 */
+		if (allow_crs) {
+			*val = CFG_RD_CRS_VAL;
+			return PCIBIOS_SUCCESSFUL;
+		}
 		*val = 0xffffffff;
 		return PCIBIOS_SET_FAILED;
 	}
@@ -665,12 +716,20 @@ static int advk_pcie_rd_conf(struct pci_
 
 	ret = advk_pcie_wait_pio(pcie);
 	if (ret < 0) {
+		/*
+		 * If it is possible return Completion Retry Status so caller
+		 * tries to issue the request again instead of failing.
+		 */
+		if (allow_crs) {
+			*val = CFG_RD_CRS_VAL;
+			return PCIBIOS_SUCCESSFUL;
+		}
 		*val = 0xffffffff;
 		return PCIBIOS_SET_FAILED;
 	}
 
 	/* Check PIO status and get the read result */
-	ret = advk_pcie_check_pio_status(pcie, val);
+	ret = advk_pcie_check_pio_status(pcie, allow_crs, val);
 	if (ret < 0) {
 		*val = 0xffffffff;
 		return PCIBIOS_SET_FAILED;
@@ -739,7 +798,7 @@ static int advk_pcie_wr_conf(struct pci_
 	if (ret < 0)
 		return PCIBIOS_SET_FAILED;
 
-	ret = advk_pcie_check_pio_status(pcie, NULL);
+	ret = advk_pcie_check_pio_status(pcie, false, NULL);
 	if (ret < 0)
 		return PCIBIOS_SET_FAILED;
 


