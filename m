Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F3B44F841
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhKNN4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhKNN4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:56:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46E63610A8;
        Sun, 14 Nov 2021 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636898029;
        bh=TYdcjS5GKXc9ES7QSNJX+B1SIBTPcQUb0RMYo8yabJY=;
        h=Subject:To:Cc:From:Date:From;
        b=D/m18isb35zKIuffK1WhZYY8WsoxPo+b1zKrYL8hZ1tbgdvRKJzAqqK772iVBeeNd
         4FtPA3kzq+jHQ8lgMZibr5EgFm3RstQnS3Pn0hnRnDcFXGGx3sL+GEMSa3wwOgCvnJ
         0cxm7aXZE7tZEYpHsM0H1gQYcWafgFse9FxK6Dq4=
Subject: FAILED: patch "[PATCH] PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge" failed to apply to 5.4-stable tree
To:     pali@kernel.org, kabel@kernel.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 14:53:47 +0100
Message-ID: <16368980275639@kroah.com>
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

From 84e1b4045dc887b78bdc87d92927093dc3a465aa Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Thu, 28 Oct 2021 20:56:57 +0200
Subject: [PATCH] PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Aardvark controller has something like config space of a Root Port
available at offset 0x0 of internal registers - these registers are used
for implementation of the emulated bridge.

The default value of Class Code of this bridge corresponds to a RAID Mass
storage controller, though. (This is probably intended for when the
controller is used as Endpoint.)

Change the Class Code to correspond to a PCI Bridge.

Add comment explaining this change.

Link: https://lore.kernel.org/r/20211028185659.20329-6-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index d7db03da4d1c..ddca45415c65 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -511,6 +511,26 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	reg = (PCI_VENDOR_ID_MARVELL << 16) | PCI_VENDOR_ID_MARVELL;
 	advk_writel(pcie, reg, VENDOR_ID_REG);
 
+	/*
+	 * Change Class Code of PCI Bridge device to PCI Bridge (0x600400),
+	 * because the default value is Mass storage controller (0x010400).
+	 *
+	 * Note that this Aardvark PCI Bridge does not have compliant Type 1
+	 * Configuration Space and it even cannot be accessed via Aardvark's
+	 * PCI config space access method. Something like config space is
+	 * available in internal Aardvark registers starting at offset 0x0
+	 * and is reported as Type 0. In range 0x10 - 0x34 it has totally
+	 * different registers.
+	 *
+	 * Therefore driver uses emulation of PCI Bridge which emulates
+	 * access to configuration space via internal Aardvark registers or
+	 * emulated configuration buffer.
+	 */
+	reg = advk_readl(pcie, PCIE_CORE_DEV_REV_REG);
+	reg &= ~0xffffff00;
+	reg |= (PCI_CLASS_BRIDGE_PCI << 8) << 8;
+	advk_writel(pcie, reg, PCIE_CORE_DEV_REV_REG);
+
 	/* Disable Root Bridge I/O space, memory space and bus mastering */
 	reg = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 	reg &= ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);

