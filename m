Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA48499A80
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573156AbiAXVof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54158 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455200AbiAXVe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:34:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 962E461320;
        Mon, 24 Jan 2022 21:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA5FC340E4;
        Mon, 24 Jan 2022 21:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060095;
        bh=3i2XzHDZD3pXO+yiyPbt7hDEmvflOcH/cdCg0AQj2PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIOcCZrBv6EoXt/2KPu5op/U0qqdU7So9rHiNyZGOZOhhIum1o42MuzwU4gnc8UIp
         6E/uzacCPucefmpBPxIWs6Rp2S5cRV3Mbx0j9tmMuUHxppw4hAbxWPHYxZZvc7S8mt
         JV3WngkIHRMtZwkA8R3UC7UVd23LYXgQoxvdXTCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0804/1039] PCI: mvebu: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge
Date:   Mon, 24 Jan 2022 19:43:13 +0100
Message-Id: <20220124184152.336213477@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit d75404cc08832206f173668bd35391c581fea121 ]

Hardware supports PCIe Hot Reset via PCIE_CTRL_OFF register. Use it for
implementing PCI_BRIDGE_CTL_BUS_RESET bit of PCI_BRIDGE_CONTROL register on
emulated bridge.

With this change the function pci_reset_secondary_bus() starts working and
can reset connected PCIe card.

Link: https://lore.kernel.org/r/20211125124605.25915-13-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index f279471e340ee..aaf6a226f6dba 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -56,6 +56,7 @@
 #define PCIE_CTRL_OFF		0x1a00
 #define  PCIE_CTRL_X1_MODE		0x0001
 #define  PCIE_CTRL_RC_MODE		BIT(1)
+#define  PCIE_CTRL_MASTER_HOT_RESET	BIT(24)
 #define PCIE_STAT_OFF		0x1a04
 #define  PCIE_STAT_BUS                  0xff00
 #define  PCIE_STAT_DEV                  0x1f0000
@@ -462,6 +463,22 @@ mvebu_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
 		break;
 	}
 
+	case PCI_INTERRUPT_LINE: {
+		/*
+		 * From the whole 32bit register we support reading from HW only
+		 * one bit: PCI_BRIDGE_CTL_BUS_RESET.
+		 * Other bits are retrieved only from emulated config buffer.
+		 */
+		__le32 *cfgspace = (__le32 *)&bridge->conf;
+		u32 val = le32_to_cpu(cfgspace[PCI_INTERRUPT_LINE / 4]);
+		if (mvebu_readl(port, PCIE_CTRL_OFF) & PCIE_CTRL_MASTER_HOT_RESET)
+			val |= PCI_BRIDGE_CTL_BUS_RESET << 16;
+		else
+			val &= ~(PCI_BRIDGE_CTL_BUS_RESET << 16);
+		*value = val;
+		break;
+	}
+
 	default:
 		return PCI_BRIDGE_EMUL_NOT_HANDLED;
 	}
@@ -549,6 +566,17 @@ mvebu_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 			mvebu_pcie_set_local_bus_nr(port, conf->secondary_bus);
 		break;
 
+	case PCI_INTERRUPT_LINE:
+		if (mask & (PCI_BRIDGE_CTL_BUS_RESET << 16)) {
+			u32 ctrl = mvebu_readl(port, PCIE_CTRL_OFF);
+			if (new & (PCI_BRIDGE_CTL_BUS_RESET << 16))
+				ctrl |= PCIE_CTRL_MASTER_HOT_RESET;
+			else
+				ctrl &= ~PCIE_CTRL_MASTER_HOT_RESET;
+			mvebu_writel(port, ctrl, PCIE_CTRL_OFF);
+		}
+		break;
+
 	default:
 		break;
 	}
-- 
2.34.1



