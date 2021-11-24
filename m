Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0988B45D06D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352215AbhKXWxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352193AbhKXWxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F12D06108E;
        Wed, 24 Nov 2021 22:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794207;
        bh=QavBavWcf2Y/8CI2xTxWOvtSJcNtflbf9If8O00n/Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqFbL/J6Uge3Kx6NYxSjMSw/FtQfa8O9tyumzoT8N7nyG6ffHMJrnAPXjjHcM7SK6
         exikaTEO4AetyPMrzHUkzR9HzlftYRfaHzh1glnE1oW6xaLMctup+8yNuFe00UVGMW
         8crVwutNnFOjRkfDCwKVW0ZE92EdKPIRqNdrvEG1B7a+hgtsea7jBxDBbFG9dQ+1dC
         /4IU+N1X/BeMZLJQe8Z1kcO410/J6Pq3CReIZTl9eT2aNam4q4ulD21BGow+yrcmyT
         ZhUuoyz58seW4rlxieXeUfjhYPwR0QKnHAN2pN7fK/3bo1AwdcAkA/mYdymvb5iKpK
         nnV/GcFqTGGOA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 12/24] PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()
Date:   Wed, 24 Nov 2021 23:49:21 +0100
Message-Id: <20211124224933.24275-13-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
 drivers/pci/host/pci-aardvark.c | 64 +++++++++++++++++----------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index b3bce506d995..68ab3aef0e12 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -268,6 +268,25 @@ static void advk_pcie_set_ob_win(struct advk_pcie *pcie,
 	advk_writel(pcie, match_ls | BIT(0), OB_WIN_MATCH_LS(win_num));
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
@@ -315,6 +334,21 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
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
@@ -347,25 +381,6 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
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
@@ -375,8 +390,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	for (i = 0; i < 8; i++)
 		advk_pcie_set_ob_win(pcie, i, 0, 0, 0, 0, 0, 0, 0);
 
-	advk_pcie_issue_perst(pcie);
-
 	/* Set to Direct mode */
 	reg = advk_readl(pcie, CTRL_CONFIG_REG);
 	reg &= ~(CTRL_MODE_MASK << CTRL_MODE_SHIFT);
@@ -448,15 +461,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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

