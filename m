Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64D024BC7B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgHTMrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbgHTJp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F79022D6D;
        Thu, 20 Aug 2020 09:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916696;
        bh=4Pu5l+a7R0giKXEjk93F4XnVBL48zhHRz7T5g0HZRQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0R89/UlMfCk1dw0PXngaU+kvwFjI8T7lm3yTcsj++RqxW+18v3lKVZnxyu41wx6gk
         PP6gh1QcxrX6kyWBlgqJu1z/TcM1Wu9JREIxb3CTYNtSq6iFurBLwXyKvX6f4HjVoL
         Ufo1sz0QI9YdyNK/ffeaWd4j74M9Q2eOpkyotqdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 5.4 007/152] PCI: qcom: Define some PARF params needed for ipq8064 SoC
Date:   Thu, 20 Aug 2020 11:19:34 +0200
Message-Id: <20200820091554.011441096@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

commit 5149901e9e6deca487c01cc434a3ac4125c7b00b upstream.

Set some specific value for Tx De-Emphasis, Tx Swing and Rx equalization
needed on some ipq8064 based device (Netgear R7800 for example). Without
this the system locks on kernel load.

Link: https://lore.kernel.org/r/20200615210608.21469-8-ansuelsmth@gmail.com
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/dwc/pcie-qcom.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -76,6 +76,18 @@
 #define DBI_RO_WR_EN				1
 
 #define PERST_DELAY_US				1000
+/* PARF registers */
+#define PCIE20_PARF_PCS_DEEMPH			0x34
+#define PCS_DEEMPH_TX_DEEMPH_GEN1(x)		((x) << 16)
+#define PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(x)	((x) << 8)
+#define PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(x)	((x) << 0)
+
+#define PCIE20_PARF_PCS_SWING			0x38
+#define PCS_SWING_TX_SWING_FULL(x)		((x) << 8)
+#define PCS_SWING_TX_SWING_LOW(x)		((x) << 0)
+
+#define PCIE20_PARF_CONFIG_BITS		0x50
+#define PHY_RX0_EQ(x)				((x) << 24)
 
 #define PCIE20_v3_PARF_SLV_ADDR_SPACE_SIZE	0x358
 #define SLV_ADDR_SPACE_SZ			0x10000000
@@ -275,6 +287,7 @@ static int qcom_pcie_init_2_1_0(struct q
 	struct qcom_pcie_resources_2_1_0 *res = &pcie->res.v2_1_0;
 	struct dw_pcie *pci = pcie->pci;
 	struct device *dev = pci->dev;
+	struct device_node *node = dev->of_node;
 	u32 val;
 	int ret;
 
@@ -319,6 +332,17 @@ static int qcom_pcie_init_2_1_0(struct q
 	val &= ~BIT(0);
 	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
 
+	if (of_device_is_compatible(node, "qcom,pcie-ipq8064")) {
+		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
+			       PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(24) |
+			       PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(34),
+		       pcie->parf + PCIE20_PARF_PCS_DEEMPH);
+		writel(PCS_SWING_TX_SWING_FULL(120) |
+			       PCS_SWING_TX_SWING_LOW(120),
+		       pcie->parf + PCIE20_PARF_PCS_SWING);
+		writel(PHY_RX0_EQ(4), pcie->parf + PCIE20_PARF_CONFIG_BITS);
+	}
+
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
 	val |= BIT(16);


