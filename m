Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8373E46237A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhK2Vno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhK2Vln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:41:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05B2C0E4987;
        Mon, 29 Nov 2021 10:24:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16EBDCE139A;
        Mon, 29 Nov 2021 18:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F40C53FAD;
        Mon, 29 Nov 2021 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210266;
        bh=2HRBXQIYfE6h3Mics8ijVXMc00ZREVIPUe9ZD+rn6yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q40JsA9G440Nq4QvmUASPz9En47tCeoqDXe7xEwcyYKAX/KVzEOh5Q2jgLOYypXg1
         LpaRNlKgmxeYBOPT6lCMCFA1in/bRk6lRvShZ+Ol7sIzWKnuniB57VUU7VOaRNlgd0
         F0S3Yaq6n0m2bHD3B8lUDWPtA7e1N3oIctz19y1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 27/92] PCI: aardvark: Improve link training
Date:   Mon, 29 Nov 2021 19:17:56 +0100
Message-Id: <20211129181708.322206614@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

commit 43fc679ced18006b12d918d7a8a4af392b7fbfe7 upstream.

Currently the aardvark driver trains link in PCIe gen2 mode. This may
cause some buggy gen1 cards (such as Compex WLE900VX) to be unstable or
even not detected. Moreover when ASPM code tries to retrain link second
time, these cards may stop responding and link goes down. If gen1 is
used this does not happen.

Unconditionally forcing gen1 is not a good solution since it may have
performance impact on gen2 cards.

To overcome this, read 'max-link-speed' property (as defined in PCI
device tree bindings) and use this as max gen mode. Then iteratively try
link training at this mode or lower until successful. After successful
link training choose final controller gen based on Negotiated Link Speed
from Link Status register, which should match card speed.

Link: https://lore.kernel.org/r/20200430080625.26070-5-pali@kernel.org
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |  114 ++++++++++++++++++++++++++--------
 1 file changed, 89 insertions(+), 25 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -39,6 +39,7 @@
 #define PCIE_CORE_LINK_CTRL_STAT_REG				0xd0
 #define     PCIE_CORE_LINK_L0S_ENTRY				BIT(0)
 #define     PCIE_CORE_LINK_TRAINING				BIT(5)
+#define     PCIE_CORE_LINK_SPEED_SHIFT				16
 #define     PCIE_CORE_LINK_WIDTH_SHIFT				20
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
@@ -249,6 +250,7 @@ struct advk_pcie {
 	struct mutex msi_used_lock;
 	u16 msi_msg;
 	int root_bus_nr;
+	int link_gen;
 	struct pci_bridge_emul bridge;
 };
 
@@ -309,20 +311,16 @@ static inline bool advk_pcie_link_traini
 
 static int advk_pcie_wait_for_link(struct advk_pcie *pcie)
 {
-	struct device *dev = &pcie->pdev->dev;
 	int retries;
 
 	/* check if the link is up or not */
 	for (retries = 0; retries < LINK_WAIT_MAX_RETRIES; retries++) {
-		if (advk_pcie_link_up(pcie)) {
-			dev_info(dev, "link up\n");
+		if (advk_pcie_link_up(pcie))
 			return 0;
-		}
 
 		usleep_range(LINK_WAIT_USLEEP_MIN, LINK_WAIT_USLEEP_MAX);
 	}
 
-	dev_err(dev, "link never came up\n");
 	return -ETIMEDOUT;
 }
 
@@ -337,6 +335,85 @@ static void advk_pcie_wait_for_retrain(s
 	}
 }
 
+static int advk_pcie_train_at_gen(struct advk_pcie *pcie, int gen)
+{
+	int ret, neg_gen;
+	u32 reg;
+
+	/* Setup link speed */
+	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
+	reg &= ~PCIE_GEN_SEL_MSK;
+	if (gen == 3)
+		reg |= SPEED_GEN_3;
+	else if (gen == 2)
+		reg |= SPEED_GEN_2;
+	else
+		reg |= SPEED_GEN_1;
+	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
+
+	/*
+	 * Enable link training. This is not needed in every call to this
+	 * function, just once suffices, but it does not break anything either.
+	 */
+	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
+	reg |= LINK_TRAINING_EN;
+	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
+
+	/*
+	 * Start link training immediately after enabling it.
+	 * This solves problems for some buggy cards.
+	 */
+	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
+	reg |= PCIE_CORE_LINK_TRAINING;
+	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
+
+	ret = advk_pcie_wait_for_link(pcie);
+	if (ret)
+		return ret;
+
+	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
+	neg_gen = (reg >> PCIE_CORE_LINK_SPEED_SHIFT) & 0xf;
+
+	return neg_gen;
+}
+
+static void advk_pcie_train_link(struct advk_pcie *pcie)
+{
+	struct device *dev = &pcie->pdev->dev;
+	int neg_gen = -1, gen;
+
+	/*
+	 * Try link training at link gen specified by device tree property
+	 * 'max-link-speed'. If this fails, iteratively train at lower gen.
+	 */
+	for (gen = pcie->link_gen; gen > 0; --gen) {
+		neg_gen = advk_pcie_train_at_gen(pcie, gen);
+		if (neg_gen > 0)
+			break;
+	}
+
+	if (neg_gen < 0)
+		goto err;
+
+	/*
+	 * After successful training if negotiated gen is lower than requested,
+	 * train again on negotiated gen. This solves some stability issues for
+	 * some buggy gen1 cards.
+	 */
+	if (neg_gen < gen) {
+		gen = neg_gen;
+		neg_gen = advk_pcie_train_at_gen(pcie, gen);
+	}
+
+	if (neg_gen == gen) {
+		dev_info(dev, "link up at gen %i\n", gen);
+		return;
+	}
+
+err:
+	dev_err(dev, "link never came up\n");
+}
+
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
 	u32 reg;
@@ -382,12 +459,6 @@ static void advk_pcie_setup_hw(struct ad
 		PCIE_CORE_CTRL2_TD_ENABLE;
 	advk_writel(pcie, reg, PCIE_CORE_CTRL2_REG);
 
-	/* Set GEN2 */
-	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
-	reg &= ~PCIE_GEN_SEL_MSK;
-	reg |= SPEED_GEN_2;
-	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
-
 	/* Set lane X1 */
 	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
 	reg &= ~LANE_CNT_MSK;
@@ -435,20 +506,7 @@ static void advk_pcie_setup_hw(struct ad
 	 */
 	msleep(PCI_PM_D3COLD_WAIT);
 
-	/* Enable link training */
-	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
-	reg |= LINK_TRAINING_EN;
-	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
-
-	/*
-	 * Start link training immediately after enabling it.
-	 * This solves problems for some buggy cards.
-	 */
-	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
-	reg |= PCIE_CORE_LINK_TRAINING;
-	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
-
-	advk_pcie_wait_for_link(pcie);
+	advk_pcie_train_link(pcie);
 
 	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 	reg |= PCIE_CORE_CMD_MEM_ACCESS_EN |
@@ -1278,6 +1336,12 @@ static int advk_pcie_probe(struct platfo
 		return ret;
 	}
 
+	ret = of_pci_get_max_link_speed(dev->of_node);
+	if (ret <= 0 || ret > 3)
+		pcie->link_gen = 3;
+	else
+		pcie->link_gen = ret;
+
 	advk_pcie_setup_hw(pcie);
 
 	ret = advk_sw_pci_bridge_init(pcie);


