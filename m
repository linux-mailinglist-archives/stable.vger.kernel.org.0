Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B14206602
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390417AbgFWVgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388771AbgFWUJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5216F2082F;
        Tue, 23 Jun 2020 20:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942997;
        bh=5L4uTe5XJeR1TnS9+y0mdKLSkDnpZ4V3Xcs0dQ63MQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1zfv/U3LuMemS3brgEJXp7tC3psBhiKpR9XC6xKyrvu4AYiLZBXBGN8/zoFEKktE
         9lMQH3ddtpm71TqwbaRY1NdVyVMAoKuccbhFxqegJwcMGV7Qx4kTxnJwXohBJeIq6r
         uT8mDWCZNRA2yDTdoj1KvsHwfCJPvzrvoMvN4cQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 219/477] PCI: aardvark: Improve link training
Date:   Tue, 23 Jun 2020 21:53:36 +0200
Message-Id: <20200623195417.938543220@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

[ Upstream commit 43fc679ced18006b12d918d7a8a4af392b7fbfe7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 114 ++++++++++++++++++++------
 1 file changed, 89 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 74b90940a9d46..e202f954eb84e 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -40,6 +40,7 @@
 #define PCIE_CORE_LINK_CTRL_STAT_REG				0xd0
 #define     PCIE_CORE_LINK_L0S_ENTRY				BIT(0)
 #define     PCIE_CORE_LINK_TRAINING				BIT(5)
+#define     PCIE_CORE_LINK_SPEED_SHIFT				16
 #define     PCIE_CORE_LINK_WIDTH_SHIFT				20
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
@@ -201,6 +202,7 @@ struct advk_pcie {
 	struct mutex msi_used_lock;
 	u16 msi_msg;
 	int root_bus_nr;
+	int link_gen;
 	struct pci_bridge_emul bridge;
 };
 
@@ -225,20 +227,16 @@ static int advk_pcie_link_up(struct advk_pcie *pcie)
 
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
 
@@ -253,6 +251,85 @@ static void advk_pcie_wait_for_retrain(struct advk_pcie *pcie)
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
@@ -288,12 +365,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -341,20 +412,7 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -988,6 +1046,12 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	}
 	pcie->root_bus_nr = bus->start;
 
+	ret = of_pci_get_max_link_speed(dev->of_node);
+	if (ret <= 0 || ret > 3)
+		pcie->link_gen = 3;
+	else
+		pcie->link_gen = ret;
+
 	advk_pcie_setup_hw(pcie);
 
 	advk_sw_pci_bridge_init(pcie);
-- 
2.25.1



