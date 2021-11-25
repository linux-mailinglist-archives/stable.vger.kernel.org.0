Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F37A45D21F
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345802AbhKYAfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353120AbhKYAdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:33:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CA961107;
        Thu, 25 Nov 2021 00:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637800014;
        bh=nQqax1dpM5nANFLx3hVy6Ub0CA7PpqALhTHW2gldnPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjLESGH/W4WtuOMiGgl6krSi71kFBClRed9ABeuEQemtMJJ6uET6RnuyU7JqItQ+G
         /YYgMepzaa5l2Gr/idYY0vrMKMd071aPiaBNjbdorvuCwT+LLLf3VBIHhqx/52ajzr
         uCK2wdLCjhfUwHlYG2LQvlr/Df1oV7YqzkDbSNzfGJSALsQ83Bd7yStZ7KfiHpvlns
         p/IouMO1vJfiWHn1fiNYBM+WuvSdaaBRaCbqQqkewb7sk/7g2V3mf16glo/z1EwW3H
         cU/N0OVl5JuQZyk2yUwtGNMLzNrUj48IRYA4WezmPi7xBOFYCCktAmsVSMwEta0M7j
         roayttT3QfJSg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 20/22] PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge
Date:   Thu, 25 Nov 2021 01:26:14 +0100
Message-Id: <20211125002616.31363-21-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
References: <20211125002616.31363-1-kabel@kernel.org>
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
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 3265709bfba9..9e208294946c 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -764,6 +764,22 @@ advk_pci_bridge_emul_base_conf_read(struct pci_bridge_emul *bridge,
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
@@ -780,6 +796,17 @@ advk_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
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
-- 
2.32.0

