Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D30E45D0C1
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352453AbhKXXIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352370AbhKXXIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CCB6108F;
        Wed, 24 Nov 2021 23:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795110;
        bh=TfhzVc9r2W8hQaexOE+LCt5W4Wcm/3H/6Sunt0AVxvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tT8DFJAh0pIR4Zds/onNbY8UqOl3CRx5YzWT/NW5+r31GgxNuo95Ay1gaReYxLJ3D
         Jsgb8of36eeBso9Zb+QIVrhiJlUD+qp7AaNVSNA9fOE8CvCWQeAsuvlTAoOfMzcO4R
         xRoHRWsfLPQ/LriLdsZVukmJz0aCUyYaGVjMm6Aq7Qja8upEOt/y6xeiZSTBsjmHJs
         3eI94PtXsZ4nH/aQ9FkLBghz6RWpmlNihiBivwMfRCoUei2Hua0j7E+ow2eN9+H4qK
         zrrJIVLrHCvGF91STMVkdJfhMo2HfG2Joemz2zh0f4Ceve51+hVCjkV1Rywuzgfydc
         5FJpQuE5IV33Q==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Tomasz Maciej Nowak <tmn505@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 03/20] PCI: aardvark: Train link immediately after enabling training
Date:   Thu, 25 Nov 2021 00:04:43 +0100
Message-Id: <20211124230500.27109-4-kabel@kernel.org>
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

commit 6964494582f56a3882c2c53b0edbfe99eb32b2e1 upstream.

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
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 3449d1444805..4828d585d4b9 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -280,11 +280,6 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
@@ -326,7 +321,15 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
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
2.32.0

