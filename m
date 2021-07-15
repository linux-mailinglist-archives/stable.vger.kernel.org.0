Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03383CA68F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbhGOSsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239331AbhGOSsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:48:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B7E8613D0;
        Thu, 15 Jul 2021 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374707;
        bh=YLvMeZgML27z001Ivd15EcAZngsxhTD5qonkMYCvLFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qs4TTg0z32FjlsQbsvF5g1KkoqV/NBsbac3g3YQ7OME7OjjXhf1Y6f/iddE2d4AwS
         K+mNRi6LpMXIPIpej7Fe7PKaTVojMLI1z+PKurD06xc4yOBzOLMBcaeMMNfubPLMDt
         5KaQhNQ350TW4fvmEngzFrFXFzg9aDenHZxc00Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.4 112/122] PCI: aardvark: Implement workaround for the readback value of VEND_ID
Date:   Thu, 15 Jul 2021 20:39:19 +0200
Message-Id: <20210715182521.292790967@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 7f71a409fe3d9358da07c77f15bb5b7960f12253 upstream.

Marvell Armada 3700 Functional Errata, Guidelines, and Restrictions
document describes in erratum 4.1 PCIe value of vendor ID (Ref #: 243):

    The readback value of VEND_ID (RD0070000h [15:0]) is 1B4Bh, while it
    should read 11ABh.

    The firmware can write the correct value, 11ABh, through VEND_ID
    (RD0076044h [15:0]).

Implement this workaround in aardvark driver for both PCI vendor id and PCI
subsystem vendor id.

This change affects and fixes PCI vendor id of emulated PCIe root bridge.
After this change emulated PCIe root bridge has correct vendor id.

Link: https://lore.kernel.org/r/20210624222621.4776-5-pali@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -127,6 +127,7 @@
 #define     LTSSM_MASK				0x3f
 #define     LTSSM_L0				0x10
 #define     RC_BAR_CONFIG			0x300
+#define VENDOR_ID_REG				(LMI_BASE_ADDR + 0x44)
 
 /* PCIe core controller registers */
 #define CTRL_CORE_BASE_ADDR			0x18000
@@ -268,6 +269,16 @@ static void advk_pcie_setup_hw(struct ad
 	reg |= (IS_RC_MSK << IS_RC_SHIFT);
 	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
 
+	/*
+	 * Replace incorrect PCI vendor id value 0x1b4b by correct value 0x11ab.
+	 * VENDOR_ID_REG contains vendor id in low 16 bits and subsystem vendor
+	 * id in high 16 bits. Updating this register changes readback value of
+	 * read-only vendor id bits in PCIE_CORE_DEV_ID_REG register. Workaround
+	 * for erratum 4.1: "The value of device and vendor ID is incorrect".
+	 */
+	reg = (PCI_VENDOR_ID_MARVELL << 16) | PCI_VENDOR_ID_MARVELL;
+	advk_writel(pcie, reg, VENDOR_ID_REG);
+
 	/* Set Advanced Error Capabilities and Control PF0 register */
 	reg = PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX |
 		PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX_EN |


