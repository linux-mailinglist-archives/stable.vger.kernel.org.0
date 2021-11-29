Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AB946237C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhK2Vnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhK2Vlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:41:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80DCC0E4989;
        Mon, 29 Nov 2021 10:24:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 704C0B815CC;
        Mon, 29 Nov 2021 18:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B4C53FAD;
        Mon, 29 Nov 2021 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210269;
        bh=HYoqmRsE9YHqAm6buAdzBlIoKhWNPK+eOQUpbZvakGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAUxYEHV/XrYc/LDiQyi4mKm4Cd71qKqVHBPzve5AEU1kKtm/9g/35aUyYRB+GoKe
         AjTkQlvihzZMDGqxESZSdHljGo4wtINyLlrPvGo7DYHLFKOFw55xqk5e0xAP7HLD5T
         zKVQcdyixPMPLJdRQ8OgH0TCoN9t3axoa4oHEHAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 28/92] PCI: aardvark: Issue PERST via GPIO
Date:   Mon, 29 Nov 2021 19:17:57 +0100
Message-Id: <20211129181708.354432645@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   43 +++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
@@ -17,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/of_address.h>
+#include <linux/of_gpio.h>
 #include <linux/of_pci.h>
 
 #include "../pci.h"
@@ -252,6 +254,7 @@ struct advk_pcie {
 	int root_bus_nr;
 	int link_gen;
 	struct pci_bridge_emul bridge;
+	struct gpio_desc *reset_gpio;
 };
 
 static inline void advk_writel(struct advk_pcie *pcie, u32 val, u64 reg)
@@ -414,10 +417,31 @@ err:
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
@@ -500,7 +524,8 @@ static void advk_pcie_setup_hw(struct ad
 
 	/*
 	 * PERST# signal could have been asserted by pinctrl subsystem before
-	 * probe() callback has been called, making the endpoint going into
+	 * probe() callback has been called or issued explicitly by reset gpio
+	 * function advk_pcie_issue_perst(), making the endpoint going into
 	 * fundamental reset. As required by PCI Express spec a delay for at
 	 * least 100ms after such a reset before link training is needed.
 	 */
@@ -1336,6 +1361,22 @@ static int advk_pcie_probe(struct platfo
 		return ret;
 	}
 
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


