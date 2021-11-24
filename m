Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5355945D0C8
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352482AbhKXXIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352455AbhKXXId (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 548A16109E;
        Wed, 24 Nov 2021 23:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795123;
        bh=xaW5JX1sEfjzF8x6OzQDnFpB4I4aX+Xuyk2Hkp/UWJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RB8k8jl9cEUjvFu7yBJNAAVSUKhjioidf1gRbIt89SJHBrQ/OYlHuWSZUiMJFHjK5
         mornvSsjeTAdDfbnAxvKL995jeA6R2Mpb2x4pAxVUEaQDa7uUUFLmqyQdY7gC9S+Vt
         EbFwK/+xeIWLydcimDK5xggxCgt/Js/fuO6EgCvBDN+r5BLaSxfFXbuOxv/yh1A+I/
         zrX40nkPhzXTe3uaTXo+4fOxi4wutDu0TlunUjHyozPIBFWHcx8iyAY0vvTpMn8JIU
         mO+BFMVLyEjqWSziS4wprEJb+96zRdxVtK2mgQj28S/ZcEhJ4ca7msUDho8k5PyTZv
         8i2SFi0IFi3Jw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 10/20] PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()
Date:   Thu, 25 Nov 2021 00:04:50 +0100
Message-Id: <20211124230500.27109-11-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit d0c6a3475b033960e85ae2bf176b14cab0a627d2 upstream.

Move code which belongs to link training (delays and resets) into
advk_pcie_train_link() function, so everything related to link training,
including timings is at one place.

After experiments it can be observed that link training in aardvark
hardware is very sensitive to timings and delays, so it is a good idea to
have this code at the same place as link training calls.

This patch does not change behavior of aardvark initialization.

Link: https://lore.kernel.org/r/20200907111038.5811-6-pali@kernel.org
Tested-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 64 ++++++++++++++-------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index e79c2fd86f4e..e26abbab506c 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -229,6 +229,25 @@ static int advk_pcie_wait_for_link(struct advk_pcie *pcie)
 	return -ETIMEDOUT;
 }
 
+static void advk_pcie_issue_perst(struct advk_pcie *pcie)
+{
+	u32 reg;
+
+	if (!pcie->reset_gpio)
+		return;
+
+	/* PERST does not work for some cards when link training is enabled */
+	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
+	reg &= ~LINK_TRAINING_EN;
+	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
+
+	/* 10ms delay is needed for some cards */
+	dev_info(&pcie->pdev->dev, "issuing PERST via reset GPIO for 10ms\n");
+	gpiod_set_value_cansleep(pcie->reset_gpio, 1);
+	usleep_range(10000, 11000);
+	gpiod_set_value_cansleep(pcie->reset_gpio, 0);
+}
+
 static int advk_pcie_train_at_gen(struct advk_pcie *pcie, int gen)
 {
 	int ret, neg_gen;
@@ -276,6 +295,21 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
 	struct device *dev = &pcie->pdev->dev;
 	int neg_gen = -1, gen;
 
+	/*
+	 * Reset PCIe card via PERST# signal. Some cards are not detected
+	 * during link training when they are in some non-initial state.
+	 */
+	advk_pcie_issue_perst(pcie);
+
+	/*
+	 * PERST# signal could have been asserted by pinctrl subsystem before
+	 * probe() callback has been called or issued explicitly by reset gpio
+	 * function advk_pcie_issue_perst(), making the endpoint going into
+	 * fundamental reset. As required by PCI Express spec a delay for at
+	 * least 100ms after such a reset before link training is needed.
+	 */
+	msleep(PCI_PM_D3COLD_WAIT);
+
 	/*
 	 * Try link training at link gen specified by device tree property
 	 * 'max-link-speed'. If this fails, iteratively train at lower gen.
@@ -308,31 +342,10 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
 	dev_err(dev, "link never came up\n");
 }
 
-static void advk_pcie_issue_perst(struct advk_pcie *pcie)
-{
-	u32 reg;
-
-	if (!pcie->reset_gpio)
-		return;
-
-	/* PERST does not work for some cards when link training is enabled */
-	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
-	reg &= ~LINK_TRAINING_EN;
-	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
-
-	/* 10ms delay is needed for some cards */
-	dev_info(&pcie->pdev->dev, "issuing PERST via reset GPIO for 10ms\n");
-	gpiod_set_value_cansleep(pcie->reset_gpio, 1);
-	usleep_range(10000, 11000);
-	gpiod_set_value_cansleep(pcie->reset_gpio, 0);
-}
-
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
 	u32 reg;
 
-	advk_pcie_issue_perst(pcie);
-
 	/* Set to Direct mode */
 	reg = advk_readl(pcie, CTRL_CONFIG_REG);
 	reg &= ~(CTRL_MODE_MASK << CTRL_MODE_SHIFT);
@@ -404,15 +417,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg |= PIO_CTRL_ADDR_WIN_DISABLE;
 	advk_writel(pcie, reg, PIO_CTRL);
 
-	/*
-	 * PERST# signal could have been asserted by pinctrl subsystem before
-	 * probe() callback has been called or issued explicitly by reset gpio
-	 * function advk_pcie_issue_perst(), making the endpoint going into
-	 * fundamental reset. As required by PCI Express spec a delay for at
-	 * least 100ms after such a reset before link training is needed.
-	 */
-	msleep(PCI_PM_D3COLD_WAIT);
-
 	advk_pcie_train_link(pcie);
 
 	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
-- 
2.32.0

