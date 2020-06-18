Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB931FE746
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgFRCjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbgFRBMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F0221974;
        Thu, 18 Jun 2020 01:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442774;
        bh=s5tlMG5xYQEvcF25X+nwy3A9jSU1v8iqz8pZFmMrPIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdjCOut2ZjdBTpoS5bkod65IoM+ujhhLeI5X6KlQiR5Wcu7s6AvIKRTBIjpwRazgJ
         0p3NoTcUDigD6MZqTTgg1B3jPwi5XmJ2lM8IFry60EKg1YR8qVEx6w8pxdGRaES1yH
         nQq6Ln8VP1Uv/RjQ4y02AnXV3EOZpU+w6XQwsMoQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 221/388] PCI: aardvark: Train link immediately after enabling training
Date:   Wed, 17 Jun 2020 21:05:18 -0400
Message-Id: <20200618010805.600873-221-sashal@kernel.org>
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

[ Upstream commit 6964494582f56a3882c2c53b0edbfe99eb32b2e1 ]

Adding even 100ms (PCI_PM_D3COLD_WAIT) delay between enabling link
training and starting link training causes detection issues with some
buggy cards (such as Compex WLE900VX).

Move the code which enables link training immediately before the one
which starts link traning.

This fixes detection issues of Compex WLE900VX card on Turris MOX after
cold boot.

Link: https://lore.kernel.org/r/20200430080625.26070-2-pali@kernel.org
Fixes: f4c7d053d7f7 ("PCI: aardvark: Wait for endpoint to be ready...")
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 3a6d07dc0a38..74b90940a9d4 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -300,11 +300,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg |= LANE_COUNT_1;
 	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
 
-	/* Enable link training */
-	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
-	reg |= LINK_TRAINING_EN;
-	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
-
 	/* Enable MSI */
 	reg = advk_readl(pcie, PCIE_CORE_CTRL2_REG);
 	reg |= PCIE_CORE_CTRL2_MSI_ENABLE;
@@ -346,7 +341,15 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	 */
 	msleep(PCI_PM_D3COLD_WAIT);
 
-	/* Start link training */
+	/* Enable link training */
+	reg = advk_readl(pcie, PCIE_CORE_CTRL0_REG);
+	reg |= LINK_TRAINING_EN;
+	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
+
+	/*
+	 * Start link training immediately after enabling it.
+	 * This solves problems for some buggy cards.
+	 */
 	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
 	reg |= PCIE_CORE_LINK_TRAINING;
 	advk_writel(pcie, reg, PCIE_CORE_LINK_CTRL_STAT_REG);
-- 
2.25.1

