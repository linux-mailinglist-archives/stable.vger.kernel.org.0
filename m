Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEB41FDB90
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgFRBM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729018AbgFRBM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4590C221ED;
        Thu, 18 Jun 2020 01:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442777;
        bh=Ofauh1tBppSKUpqFNfZSf4nuYCyIJ5cLtkEC6ulDfek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5itvmspFirUGLJ7e4a4hbJeCNnbdXNJ81Lek596J2A8OXmbCLtcg2roRUb8aowDn
         /gW1dwnCKHocalOTC6uxHXstGX56M9VCj9tWfJiiVpKUuLIHtQmHCVkbcygGUMJFYJ
         v3SaIX/1KpgXnOoJUOGyCS11unp6HeMOVHg7gGm8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 223/388] PCI: aardvark: Issue PERST via GPIO
Date:   Wed, 17 Jun 2020 21:05:20 -0400
Message-Id: <20200618010805.600873-223-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 5169a9851daaa2782a7bd2bb83d5b1bd224b2879 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 43 ++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index e202f954eb84..2ecc79c03ade 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
@@ -18,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/msi.h>
 #include <linux/of_address.h>
+#include <linux/of_gpio.h>
 #include <linux/of_pci.h>
 
 #include "../pci.h"
@@ -204,6 +206,7 @@ struct advk_pcie {
 	int root_bus_nr;
 	int link_gen;
 	struct pci_bridge_emul bridge;
+	struct gpio_desc *reset_gpio;
 };
 
 static inline void advk_writel(struct advk_pcie *pcie, u32 val, u64 reg)
@@ -330,10 +333,31 @@ static void advk_pcie_train_link(struct advk_pcie *pcie)
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
 
+	advk_pcie_issue_perst(pcie);
+
 	/* Set to Direct mode */
 	reg = advk_readl(pcie, CTRL_CONFIG_REG);
 	reg &= ~(CTRL_MODE_MASK << CTRL_MODE_SHIFT);
@@ -406,7 +430,8 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 
 	/*
 	 * PERST# signal could have been asserted by pinctrl subsystem before
-	 * probe() callback has been called, making the endpoint going into
+	 * probe() callback has been called or issued explicitly by reset gpio
+	 * function advk_pcie_issue_perst(), making the endpoint going into
 	 * fundamental reset. As required by PCI Express spec a delay for at
 	 * least 100ms after such a reset before link training is needed.
 	 */
@@ -1046,6 +1071,22 @@ static int advk_pcie_probe(struct platform_device *pdev)
 	}
 	pcie->root_bus_nr = bus->start;
 
+	pcie->reset_gpio = devm_gpiod_get_from_of_node(dev, dev->of_node,
+						       "reset-gpios", 0,
+						       GPIOD_OUT_LOW,
+						       "pcie1-reset");
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
2.25.1

