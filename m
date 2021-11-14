Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5513944F842
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKNN5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhKNN5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:57:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7561D610A8;
        Sun, 14 Nov 2021 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636898048;
        bh=W6MtXm9ewIogsVKu714IlwLJmwhFnVGBhOa5F7nTZSo=;
        h=Subject:To:Cc:From:Date:From;
        b=AL4ay5Hzl1o1Xpuuyn0UOTp0uOuCs9Al9lQJfcuEMICG2SUe+AQxDMX8LOkfcYtxC
         Kuo/VUDeZa87wdR0hPM/LTZAE2IXReSuEVbeXeiYJT35mGg7k2VeKipewm0YAnyH4a
         ef2b3f99zlTHJej5loYMq9K6j0qAukrAkfCwHfiM=
Subject: FAILED: patch "[PATCH] PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated" failed to apply to 5.4-stable tree
To:     pali@kernel.org, kabel@kernel.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 14:54:05 +0100
Message-ID: <1636898045220251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 239edf686c14a9ff926dec2f350289ed7adfefe2 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Thu, 28 Oct 2021 20:56:59 +0200
Subject: [PATCH] PCI: aardvark: Fix support for PCI_ROM_ADDRESS1 on emulated
 bridge
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This register is exported at address offset 0x30.

Link: https://lore.kernel.org/r/20211028185659.20329-8-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index c3b725afa11f..c5300d49807a 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -32,6 +32,7 @@
 #define PCIE_CORE_DEV_ID_REG					0x0
 #define PCIE_CORE_CMD_STATUS_REG				0x4
 #define PCIE_CORE_DEV_REV_REG					0x8
+#define PCIE_CORE_EXP_ROM_BAR_REG				0x30
 #define PCIE_CORE_PCIEXP_CAP					0xc0
 #define PCIE_CORE_ERR_CAPCTL_REG				0x118
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX			BIT(5)
@@ -773,6 +774,10 @@ advk_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
 		*value = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 		return PCI_BRIDGE_EMUL_HANDLED;
 
+	case PCI_ROM_ADDRESS1:
+		*value = advk_readl(pcie, PCIE_CORE_EXP_ROM_BAR_REG);
+		return PCI_BRIDGE_EMUL_HANDLED;
+
 	case PCI_INTERRUPT_LINE: {
 		/*
 		 * From the whole 32bit register we support reading from HW only
@@ -805,6 +810,10 @@ advk_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 		advk_writel(pcie, new, PCIE_CORE_CMD_STATUS_REG);
 		break;
 
+	case PCI_ROM_ADDRESS1:
+		advk_writel(pcie, new, PCIE_CORE_EXP_ROM_BAR_REG);
+		break;
+
 	case PCI_INTERRUPT_LINE:
 		if (mask & (PCI_BRIDGE_CTL_BUS_RESET << 16)) {
 			u32 val = advk_readl(pcie, PCIE_CORE_CTRL1_REG);

