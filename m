Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350F314E24A
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgA3SpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730952AbgA3SpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2059A2082E;
        Thu, 30 Jan 2020 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409905;
        bh=nhjcnkcEO8jN1x3NpWuxFwmmX5e5juZ3g2iPE9HWB9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vA7p8doGSYIt6zQfGqj4+xagteR6tRJDnNUiJmyR03fKzv9eCsQNXF6T7gv6M+1S0
         Ma9fYU3SqINUNit8vCvkckoKyRM/sdtIl6eZfE6+zqjJq3Rdm62rg9dyCNBtN4tYTR
         /+Ov2KACzD6nmF6jaZG6Sd0kTKnFPJGZzM5ExQP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/110] staging: mt7621-pci: add quirks for E2 revision using soc_device_attribute
Date:   Thu, 30 Jan 2020 19:38:55 +0100
Message-Id: <20200130183623.602645531@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit b483b4e4d3f6bfd5089b9e6dc9ba259879c6ce6f ]

Depending on revision of the chip, reset lines are inverted. Make code
more readable making use of 'soc_device_match' in driver probe function.

Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20191006181032.19112-1-sergio.paracuellos@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index 6b98827da57fd..3633c924848ec 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -29,15 +29,14 @@
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
+#include <linux/sys_soc.h>
 #include <mt7621.h>
 #include <ralink_regs.h>
 
 #include "../../pci/pci.h"
 
 /* sysctl */
-#define MT7621_CHIP_REV_ID		0x0c
 #define MT7621_GPIO_MODE		0x60
-#define CHIP_REV_MT7621_E2		0x0101
 
 /* MediaTek specific configuration registers */
 #define PCIE_FTS_NUM			0x70c
@@ -126,6 +125,8 @@ struct mt7621_pcie_port {
  * @ports: pointer to PCIe port information
  * @perst: gpio reset
  * @rst: pointer to pcie reset
+ * @resets_inverted: depends on chip revision
+ * reset lines are inverted.
  */
 struct mt7621_pcie {
 	void __iomem *base;
@@ -140,6 +141,7 @@ struct mt7621_pcie {
 	struct list_head ports;
 	struct gpio_desc *perst;
 	struct reset_control *rst;
+	bool resets_inverted;
 };
 
 static inline u32 pcie_read(struct mt7621_pcie *pcie, u32 reg)
@@ -229,9 +231,9 @@ static inline void mt7621_pcie_port_clk_disable(struct mt7621_pcie_port *port)
 
 static inline void mt7621_control_assert(struct mt7621_pcie_port *port)
 {
-	u32 chip_rev_id = rt_sysc_r32(MT7621_CHIP_REV_ID);
+	struct mt7621_pcie *pcie = port->pcie;
 
-	if ((chip_rev_id & 0xFFFF) == CHIP_REV_MT7621_E2)
+	if (pcie->resets_inverted)
 		reset_control_assert(port->pcie_rst);
 	else
 		reset_control_deassert(port->pcie_rst);
@@ -239,9 +241,9 @@ static inline void mt7621_control_assert(struct mt7621_pcie_port *port)
 
 static inline void mt7621_control_deassert(struct mt7621_pcie_port *port)
 {
-	u32 chip_rev_id = rt_sysc_r32(MT7621_CHIP_REV_ID);
+	struct mt7621_pcie *pcie = port->pcie;
 
-	if ((chip_rev_id & 0xFFFF) == CHIP_REV_MT7621_E2)
+	if (pcie->resets_inverted)
 		reset_control_deassert(port->pcie_rst);
 	else
 		reset_control_assert(port->pcie_rst);
@@ -641,9 +643,14 @@ static int mt7621_pcie_register_host(struct pci_host_bridge *host,
 	return pci_host_probe(host);
 }
 
+static const struct soc_device_attribute mt7621_pci_quirks_match[] = {
+	{ .soc_id = "mt7621", .revision = "E2" }
+};
+
 static int mt7621_pci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	const struct soc_device_attribute *attr;
 	struct mt7621_pcie *pcie;
 	struct pci_host_bridge *bridge;
 	int err;
@@ -661,6 +668,10 @@ static int mt7621_pci_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pcie);
 	INIT_LIST_HEAD(&pcie->ports);
 
+	attr = soc_device_match(mt7621_pci_quirks_match);
+	if (attr)
+		pcie->resets_inverted = true;
+
 	err = mt7621_pcie_parse_dt(pcie);
 	if (err) {
 		dev_err(dev, "Parsing DT failed\n");
-- 
2.20.1



