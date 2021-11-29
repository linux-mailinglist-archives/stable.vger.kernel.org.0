Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE82461DD5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378275AbhK2S3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48764 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378615AbhK2S1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BF3CCE13E6;
        Mon, 29 Nov 2021 18:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA09EC53FAD;
        Mon, 29 Nov 2021 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210263;
        bh=rQhYkcav+ZpTGHy/dZz+gZ2BeaE9OME0op6o1I0+mHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZYWRkHFL7SkmW3AcIC+ujZuYxJLINUu6h2YHBF/QOl0avq8iW5y0SQXMEekJRkmg
         wsNEmsEIe+eDSBK4dASRqBp1YTIYl6xkM2BR5VxhTrbenRub03dpYtmJM2PusL1dF2
         CEASFDKefV0QN/g2oMW52ScLvKLMqg0KdYSuQ1jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 26/92] PCI: aardvark: Train link immediately after enabling training
Date:   Mon, 29 Nov 2021 19:17:55 +0100
Message-Id: <20211129181708.289743163@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -394,11 +394,6 @@ static void advk_pcie_setup_hw(struct ad
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
@@ -440,7 +435,15 @@ static void advk_pcie_setup_hw(struct ad
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


