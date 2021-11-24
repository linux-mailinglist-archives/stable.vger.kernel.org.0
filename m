Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83C845BD0C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244694AbhKXMfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245150AbhKXMbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:31:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5250261361;
        Wed, 24 Nov 2021 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756369;
        bh=c8Zfvs25S92lKPy9RoOQGqfdnx+h92GTeWspcvixBFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxbGyoO3EFmlhyn/DQ7HHObUHPznKKx6jkq20jKLGROL20fxARsu8bBamnJ/K11Mj
         6RZ5y+UONloF8t/0QcNnWeAz5lC4rr4n3DQvDad2tHO6YjSJB1XBxC/zVt3LF7+AJ6
         4nS6CHubSQOwbyvY3GfETgi+sjXmb0RlWJ2mPtuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 061/251] PCI: aardvark: Read all 16-bits from PCIE_MSI_PAYLOAD_REG
Date:   Wed, 24 Nov 2021 12:55:03 +0100
Message-Id: <20211124115712.371114031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
@@ -112,6 +112,7 @@
 #define PCIE_MSI_STATUS_REG			(CONTROL_BASE_ADDR + 0x58)
 #define PCIE_MSI_MASK_REG			(CONTROL_BASE_ADDR + 0x5C)
 #define PCIE_MSI_PAYLOAD_REG			(CONTROL_BASE_ADDR + 0x9C)
+#define     PCIE_MSI_DATA_MASK			GENMASK(15, 0)
 
 /* PCIe window configuration */
 #define OB_WIN_BASE_ADDR			0x4c00
@@ -840,8 +841,12 @@ static void advk_pcie_handle_msi(struct
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
 


