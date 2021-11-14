Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D2344F840
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 14:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKNN4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 08:56:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhKNN4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 08:56:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AC8D6112E;
        Sun, 14 Nov 2021 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636898010;
        bh=4103TB1dFVpin/SFICawvble8M5OPlCG8+2EpURDqgo=;
        h=Subject:To:Cc:From:Date:From;
        b=sSeqtG3/MvBscnhLgL2NT8slawbEj6dGiYINlZYcdL+l8HF5GaWXIWtyxheStRBBn
         otV58qshHDUgViDElSMqckk17+6Ec1Fc+y4slmUeYXfpeeIA/Ko9m01xfnEBh5wAjV
         7wMmHOvqKPNWdJbDUbGfklRp3mGPfqs9tmwcLgPg=
Subject: FAILED: patch "[PATCH] PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on" failed to apply to 5.4-stable tree
To:     pali@kernel.org, kabel@kernel.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 14:53:28 +0100
Message-ID: <1636898008226162@kroah.com>
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

From bc4fac42e5f8460af09c0a7f2f1915be09e20c71 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Thu, 28 Oct 2021 20:56:58 +0200
Subject: [PATCH] PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on
 emulated bridge
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Aardvark supports PCIe Hot Reset via PCIE_CORE_CTRL1_REG.

Use it for implementing PCI_BRIDGE_CTL_BUS_RESET bit of PCI_BRIDGE_CONTROL
register on emulated bridge.

With this, the function pci_reset_secondary_bus() starts working and can
reset connected PCIe card. Custom userspace script [1] which uses setpci
can trigger PCIe Hot Reset and reset the card manually.

[1] https://alexforencich.com/wiki/en/pcie/hot-reset-linux

Link: https://lore.kernel.org/r/20211028185659.20329-7-kabel@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index ddca45415c65..c3b725afa11f 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -773,6 +773,22 @@ advk_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
 		*value = advk_readl(pcie, PCIE_CORE_CMD_STATUS_REG);
 		return PCI_BRIDGE_EMUL_HANDLED;
 
+	case PCI_INTERRUPT_LINE: {
+		/*
+		 * From the whole 32bit register we support reading from HW only
+		 * one bit: PCI_BRIDGE_CTL_BUS_RESET.
+		 * Other bits are retrieved only from emulated config buffer.
+		 */
+		__le32 *cfgspace = (__le32 *)&bridge->conf;
+		u32 val = le32_to_cpu(cfgspace[PCI_INTERRUPT_LINE / 4]);
+		if (advk_readl(pcie, PCIE_CORE_CTRL1_REG) & HOT_RESET_GEN)
+			val |= PCI_BRIDGE_CTL_BUS_RESET << 16;
+		else
+			val &= ~(PCI_BRIDGE_CTL_BUS_RESET << 16);
+		*value = val;
+		return PCI_BRIDGE_EMUL_HANDLED;
+	}
+
 	default:
 		return PCI_BRIDGE_EMUL_NOT_HANDLED;
 	}
@@ -789,6 +805,17 @@ advk_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 		advk_writel(pcie, new, PCIE_CORE_CMD_STATUS_REG);
 		break;
 
+	case PCI_INTERRUPT_LINE:
+		if (mask & (PCI_BRIDGE_CTL_BUS_RESET << 16)) {
+			u32 val = advk_readl(pcie, PCIE_CORE_CTRL1_REG);
+			if (new & (PCI_BRIDGE_CTL_BUS_RESET << 16))
+				val |= HOT_RESET_GEN;
+			else
+				val &= ~HOT_RESET_GEN;
+			advk_writel(pcie, val, PCIE_CORE_CTRL1_REG);
+		}
+		break;
+
 	default:
 		break;
 	}

