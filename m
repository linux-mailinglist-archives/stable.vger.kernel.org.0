Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B9545BB16
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243478AbhKXMQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:16:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243628AbhKXMOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2946761165;
        Wed, 24 Nov 2021 12:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755772;
        bh=MGsW1YmiQKj69In0xFK3ds18Mj0PHgSqvUpTOPrsCiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCxgjtOG/OkYxiscGlmD3VejwFU3QBQ/bJpYdbCNZqMz4A7iWk4uur95PBxuWgM71
         4163QP4uWpEgc2ZiPr6399vVFyhAgKAmqT0O21kWdoICkw1iuUife09iE+1d2hKtOt
         ybCfkMVsDtz8JKMjfXFA55yA9pnmhDhSZj+g17Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.9 050/207] PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG
Date:   Wed, 24 Nov 2021 12:55:21 +0100
Message-Id: <20211124115705.550196466@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
 drivers/pci/host/pci-aardvark.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -110,6 +110,7 @@
 #define PCIE_MSI_STATUS_REG			(CONTROL_BASE_ADDR + 0x58)
 #define PCIE_MSI_MASK_REG			(CONTROL_BASE_ADDR + 0x5C)
 #define PCIE_MSI_PAYLOAD_REG			(CONTROL_BASE_ADDR + 0x9C)
+#define     PCIE_MSI_DATA_MASK			GENMASK(15, 0)
 
 /* PCIe window configuration */
 #define OB_WIN_BASE_ADDR			0x4c00
@@ -785,8 +786,12 @@ static void advk_pcie_handle_msi(struct
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
 


