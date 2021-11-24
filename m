Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0FF45BF76
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345686AbhKXM65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346030AbhKXM4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:56:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9671C611CA;
        Wed, 24 Nov 2021 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757159;
        bh=JT2Wj3L06UuAz3vS67qm6Rj1tZ96bJFkX6hToSKB84A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGHbF0vi2dFwVXlmM6W8D8h1Fevqj27IVAHavDLrstcLFB+FtPecYLghCW9JVYGau
         bc5XV/m2mqHGUI+EFly4/tOuxopFCSkzBSrm7GYtQ/ZWHnUTPkssvTxifSEp5jhRip
         yM0xa8mu4QLZq4tLfymI0ekHMEdOORSNemXAQ4vI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.19 075/323] PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG
Date:   Wed, 24 Nov 2021 12:54:25 +0100
Message-Id: <20211124115721.409237929@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 95997723b6402cd6c53e0f9e7ac640ec64eaaff8 upstream.

The PCIE_MSI_PAYLOAD_REG contains 16-bit MSI number, not only lower
8 bits. Fix reading content of this register and add a comment
describing the access to this register.

Link: https://lore.kernel.org/r/20211028185659.20329-4-kabel@kernel.org
Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -111,6 +111,7 @@
 #define PCIE_MSI_STATUS_REG			(CONTROL_BASE_ADDR + 0x58)
 #define PCIE_MSI_MASK_REG			(CONTROL_BASE_ADDR + 0x5C)
 #define PCIE_MSI_PAYLOAD_REG			(CONTROL_BASE_ADDR + 0x9C)
+#define     PCIE_MSI_DATA_MASK			GENMASK(15, 0)
 
 /* LMI registers base address and register offsets */
 #define LMI_BASE_ADDR				0x6000
@@ -805,8 +806,12 @@ static void advk_pcie_handle_msi(struct
 		if (!(BIT(msi_idx) & msi_status))
 			continue;
 
+		/*
+		 * msi_idx contains bits [4:0] of the msi_data and msi_data
+		 * contains 16bit MSI interrupt number
+		 */
 		advk_writel(pcie, BIT(msi_idx), PCIE_MSI_STATUS_REG);
-		msi_data = advk_readl(pcie, PCIE_MSI_PAYLOAD_REG) & 0xFF;
+		msi_data = advk_readl(pcie, PCIE_MSI_PAYLOAD_REG) & PCIE_MSI_DATA_MASK;
 		generic_handle_irq(msi_data);
 	}
 


