Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5538452489
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhKPBjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241958AbhKOSbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E51DD61AFF;
        Mon, 15 Nov 2021 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999144;
        bh=HWVHav7Wau7I7mtp/CXh2mCwJm6QZoTBdntmFjuLZbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gptt5tJBtmSp8tk889m0MmPsHr+kuZ5A06A1tJShNaLzHuESTeWtHDyeyIUYiFNUV
         ZyTa2sLOnOarJ+WjsjchIM4OJW6brntUvDnawm92QdOGVxsErzIOzOb3t+S99cg5z1
         SAEAXx88mJm+GVxL1teK3H2vMbSaI5i7ZnF4GsnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.14 175/849] PCI: aardvark: Fix configuring Reference clock
Date:   Mon, 15 Nov 2021 17:54:18 +0100
Message-Id: <20211115165426.094957280@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 46ef6090dbf590711cb12680b6eafde5fa21fe87 upstream.

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

Link: https://lore.kernel.org/r/20211005180952.6812-6-kabel@kernel.org
Fixes: 366697018c9a ("PCI: aardvark: Add PHY support")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

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
@@ -529,9 +530,15 @@ static void advk_pcie_setup_hw(struct ad
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


