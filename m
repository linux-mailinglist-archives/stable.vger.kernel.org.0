Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728D245D067
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352196AbhKXWxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352215AbhKXWxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 708506108B;
        Wed, 24 Nov 2021 22:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794196;
        bh=wAztoczSmazOqT4JMKeXPg2ysOl76LQulKNIbsV40yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/u+NiHQZvZKdbmW97oRXDcR31MmMrqf1lcCHWOFy+gGUEo2xZp94sNXV61CQB8mQ
         021gvZCfmiTv9LaLLPCtoGQX0iUTYbxg+Cz0dpxTBtRg/Zl0bHopKh81PoXk50UFtB
         mtJ98VYAmaW05rHGLUt5fhywcI6v20w3VsZmwv2DC+8ev+q1qGq+yArW0ZwXhLf7ll
         /5CdQCdKmgATbiTfaNyB/KItY0U3MWRzH5pEO25VQsL1E7CKd8Lp9zRb5aU8wCB8/5
         tXbxq9hwity7DdTEIeAvial/WlaWBJh7mFiSKkGrEnIpm0IbTmvRL0m1RxXoKMLwGi
         9LxB0lsTyAtKA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 06/24] PCI: aardvark: Issue PERST via GPIO
Date:   Wed, 24 Nov 2021 23:49:15 +0100
Message-Id: <20211124224933.24275-7-kabel@kernel.org>
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

commit 5169a9851daaa2782a7bd2bb83d5b1bd224b2879 upstream.

Add support for issuing PERST via GPIO specified in 'reset-gpios'
property (as described in PCI device tree bindings).

Some buggy cards (e.g. Compex WLE900VX or WLE1216) are not detected
after reboot when PERST is not issued during driver initialization.

If bootloader already enabled link training then issuing PERST has no
effect for some buggy cards (e.g. Compex WLE900VX) and these cards are
not detected. We therefore clear the LINK_TRAINING_EN register before.

It was observed that Compex WLE900VX card needs to be in PERST reset
for at least 10ms if bootloader enabled link training.

Tested on Turris MOX.

Link: https://lore.kernel.org/r/20200430080625.26070-6-pali@kernel.org
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 44 ++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 714d81462297..0cfec5660c69 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
@@ -20,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/of_address.h>
+#include <linux/of_gpio.h>
 #include <linux/of_pci.h>
 
 /* PCIe core registers */
@@ -214,6 +216,7 @@ struct advk_pcie {
 	u16 msi_msg;
 	int root_bus_nr;
 	int link_gen;
+	struct gpio_desc *reset_gpio;
 };
 
 static inline void advk_writel(struct advk_pcie *pcie, u32 val, u64 reg)
@@ -349,6 +352,25 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
 	dev_err(dev, "link never came up\n");
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
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
 	u32 reg;
@@ -358,6 +380,8 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	for (i = 0; i < 8; i++)
 		advk_pcie_set_ob_win(pcie, i, 0, 0, 0, 0, 0, 0, 0);
 
+	advk_pcie_issue_perst(pcie);
+
 	/* Set to Direct mode */
 	reg = advk_readl(pcie, CTRL_CONFIG_REG);
 	reg &= ~(CTRL_MODE_MASK << CTRL_MODE_SHIFT);
@@ -430,7 +454,8 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 
 	/*
 	 * PERST# signal could have been asserted by pinctrl subsystem before
-	 * probe() callback has been called, making the endpoint going into
+	 * probe() callback has been called or issued explicitly by reset gpio
+	 * function advk_pcie_issue_perst(), making the endpoint going into
 	 * fundamental reset. As required by PCI Express spec a delay for at
 	 * least 100ms after such a reset before link training is needed.
 	 */
@@ -1075,6 +1100,23 @@ static int advk_pcie_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	pcie->reset_gpio = devm_fwnode_get_index_gpiod_from_child(dev, "reset",
+								  0,
+								  dev_fwnode(dev),
+								  GPIOD_OUT_LOW,
+								  "pcie1-reset");
+	ret = PTR_ERR_OR_ZERO(pcie->reset_gpio);
+	if (ret) {
+		if (ret == -ENOENT) {
+			pcie->reset_gpio = NULL;
+		} else {
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "Failed to get reset-gpio: %i\n",
+					ret);
+			return ret;
+		}
+	}
+
 	ret = of_pci_get_max_link_speed(dev->of_node);
 	if (ret <= 0 || ret > 3)
 		pcie->link_gen = 3;
-- 
2.32.0

