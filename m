Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C723450FA9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbhKOSfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:35:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242041AbhKOSdN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:33:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F041A6345B;
        Mon, 15 Nov 2021 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999197;
        bh=ivERZluPG4683IGei38/S2cmxwj+794NDxDNI6OomYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPsIrLGHl3FLXUVeSDTgYNcyAKB96Qu33pu2ZhBw/fxCHQ6YI+c7Wp0bsQFuL9MAb
         s0hRl3nDhEIx2/TObR+kXdV/zHIhq75I4nck+dr5jfkedHF6baNCzVgun1lfXWsCWE
         MSlnYVMW0WSlegeJdIMtTbBDci5BfOmnXunUBPUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.14 179/849] PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge
Date:   Mon, 15 Nov 2021 17:54:22 +0100
Message-Id: <20211115165426.230664521@linuxfoundation.org>
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

commit bc4fac42e5f8460af09c0a7f2f1915be09e20c71 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -793,6 +793,22 @@ advk_pci_bridge_emul_base_conf_read(stru
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
@@ -809,6 +825,17 @@ advk_pci_bridge_emul_base_conf_write(str
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


