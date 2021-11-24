Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D2345D066
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352214AbhKXWxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352183AbhKXWxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51846610A6;
        Wed, 24 Nov 2021 22:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794195;
        bh=WKpDF8tX8dxNHZudHYX+I/82fwBd1AOUXA/qfxnqgeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2E2QA8nN37X4cYqT50t2yPAPHAWBx0k7umIEfHesBagb+smKlMpE6XQ2sXcEZlwf
         Cir/gisu+wpAlcvgpv+xNEje192GLbK+kdDIe6ZLQJ9gvYy0sy78KBTg02gua/lkcX
         gPjE0ecSYtsW5LEUNRgaXIf+h3mB5fJmYffEvAyOu+Z3S0uGv0UK1JSPgeB6Plui7l
         G51Pi3ZDi6BeuareZDaqxERwbepv1mo5PbEnPTWTGPJkv+OMuUFBiSVl0f2JNc/2ny
         BLHE+8gLRyt/WimYtIGLxO9aPSDuEeNHucLi3oVdBPVWCS5LUnBhqdMhK2oXfZ0oWw
         RJ1q6W6Dd5Ubg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 05/24] PCI: aardvark: Improve link training
Date:   Wed, 24 Nov 2021 23:49:14 +0100
Message-Id: <20211124224933.24275-6-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
---
 drivers/pci/host/pci-aardvark.c | 114 +++++++++++++++++++++++++-------
 1 file changed, 89 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 8373f8cc4c52..714d81462297 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -36,6 +36,7 @@
 #define PCIE_CORE_LINK_CTRL_STAT_REG				0xd0
 #define     PCIE_CORE_LINK_L0S_ENTRY				BIT(0)
 #define     PCIE_CORE_LINK_TRAINING				BIT(5)
+#define     PCIE_CORE_LINK_SPEED_SHIFT				16
 #define     PCIE_CORE_LINK_WIDTH_SHIFT				20
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
@@ -212,6 +213,7 @@ struct advk_pcie {
 	struct mutex msi_used_lock;
 	u16 msi_msg;
 	int root_bus_nr;
+	int link_gen;
 };
 
 static inline void advk_writel(struct advk_pcie *pcie, u32 val, u64 reg)
@@ -235,20 +237,16 @@ static int advk_pcie_link_up(struct advk_pcie *pcie)
 
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
 
@@ -272,6 +270,85 @@ static void advk_pcie_set_ob_win(struct advk_pcie *pcie,
 	advk_writel(pcie, match_ls | BIT(0), OB_WIN_MATCH_LS(win_num));
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
@@ -312,12 +389,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -365,20 +436,7 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -1017,6 +1075,12 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = of_pci_get_max_link_speed(dev->of_node);
+	if (ret <= 0 || ret > 3)
+		pcie->link_gen = 3;
+	else
+		pcie->link_gen = ret;
+
 	advk_pcie_setup_hw(pcie);
 
 	ret = advk_pcie_init_irq_domain(pcie);
-- 
2.32.0

