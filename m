Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E3846230D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhK2VPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbhK2VNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:13:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1690C0E49A6;
        Mon, 29 Nov 2021 10:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88CACB815D2;
        Mon, 29 Nov 2021 18:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7195C53FCD;
        Mon, 29 Nov 2021 18:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210283;
        bh=LCP2APcv0Gj4c/rMJooGGbQ8+UhgLqC+gxUVNuVe2Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3KRiglSdl5HZs2hndY+4HfJT0pAGMok5efb/zYZlJipi77ngv4gcraGUfh0WmzMf
         QxJSmVAcmbmxwexJvBpFf6ZNJqZd4An+hl8Ooj4FZbPm9jXWWulY4vykE96d++XZBM
         jlfcR/d0R5ByS0NW9m1ElaOOWNkj1vD8H0LK47Ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 32/92] PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()
Date:   Mon, 29 Nov 2021 19:18:01 +0100
Message-Id: <20211129181708.480337770@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   64 ++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 30 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -332,6 +332,25 @@ static void advk_pcie_wait_for_retrain(s
 	}
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
@@ -380,6 +399,21 @@ static void advk_pcie_train_link(struct
 	int neg_gen = -1, gen;
 
 	/*
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
+	/*
 	 * Try link training at link gen specified by device tree property
 	 * 'max-link-speed'. If this fails, iteratively train at lower gen.
 	 */
@@ -411,31 +445,10 @@ err:
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
@@ -517,15 +530,6 @@ static void advk_pcie_setup_hw(struct ad
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


