Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4347241F605
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 21:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353931AbhJAUAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 16:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242085AbhJAUAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 16:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D1B61AE1;
        Fri,  1 Oct 2021 19:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633118348;
        bh=eRpW8lPqNlr7sPM6K6k5sNgLZQonKOlFpxu1O3BEbE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jS4ohRxwczJs54TkqXLw5X2NtYxmlwX2fj/zNGE/2wYMAuXGBJ08T+lr0Zv+xCG2g
         IjFP79N5fiActugo3IBCkKO++XS/x1HiHe9mDraEraNeXIbG/UVx4PbFN0u6X1WIo8
         cXAHZ8ov62w2aj20V071rKlwELlh5ohaf3KEeScz3E1jm0d0B8m9yCFm7zGmLXH98R
         tpOFe4Se2qn8QUYfk5e4Evx9RJfPCauSF71T+ffGLAUrrZOUQuuj/k6S3KJbd8SLS1
         IC49k2p6yAkuHdz9ICsV+4/oBM9QHTOOls2RK9vkFUJ6k1GwnJtozmnbfhqCM66ri7
         WSQoUbOSwE6Hw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 05/13] PCI: aardvark: Fix configuring Reference clock
Date:   Fri,  1 Oct 2021 21:58:48 +0200
Message-Id: <20211001195856.10081-6-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211001195856.10081-1-kabel@kernel.org>
References: <20211001195856.10081-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

Commit 366697018c9a ("PCI: aardvark: Add PHY support") introduced
configuration of PCIe Reference clock via PCIE_CORE_REF_CLK_REG register,
but did it incorrectly.

PCIe Reference clock differential pair is routed from system board to
endpoint card, so on CPU side it has output direction. Therefore it is
required to enable transmitting and disable receiving.

Default configuration according to Armada 3700 Functional Specifications is
enabled receiver part and disabled transmitter.

We need this change because otherwise PCIe Reference clock is configured to
some undefined state when differential pair is used for both transmitting
and receiving.

Fix this by disabling receiver part.

Fixes: 366697018c9a ("PCI: aardvark: Add PHY support")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/controller/pci-aardvark.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index bb57ca6aed35..d5d6f92e5143 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -99,6 +99,7 @@
 #define     PCIE_CORE_CTRL2_MSI_ENABLE		BIT(10)
 #define PCIE_CORE_REF_CLK_REG			(CONTROL_BASE_ADDR + 0x14)
 #define     PCIE_CORE_REF_CLK_TX_ENABLE		BIT(1)
+#define     PCIE_CORE_REF_CLK_RX_ENABLE		BIT(2)
 #define PCIE_MSG_LOG_REG			(CONTROL_BASE_ADDR + 0x30)
 #define PCIE_ISR0_REG				(CONTROL_BASE_ADDR + 0x40)
 #define PCIE_MSG_PM_PME_MASK			BIT(7)
@@ -451,9 +452,15 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	u32 reg;
 	int i;
 
-	/* Enable TX */
+	/*
+	 * Configure PCIe Reference clock. Direction is from the PCIe
+	 * controller to the endpoint card, so enable transmitting of
+	 * Reference clock differential signal off-chip and disable
+	 * receiving off-chip differential signal.
+	 */
 	reg = advk_readl(pcie, PCIE_CORE_REF_CLK_REG);
 	reg |= PCIE_CORE_REF_CLK_TX_ENABLE;
+	reg &= ~PCIE_CORE_REF_CLK_RX_ENABLE;
 	advk_writel(pcie, reg, PCIE_CORE_REF_CLK_REG);
 
 	/* Set to Direct mode */
-- 
2.32.0

