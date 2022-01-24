Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5535249A4A3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369567AbiAYACK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1587671AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AD9C06137C;
        Mon, 24 Jan 2022 13:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A16B61305;
        Mon, 24 Jan 2022 21:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B87FC340E4;
        Mon, 24 Jan 2022 21:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060003;
        bh=1JwUsDPGsn0+DgdjBcBpmV32LGvRqYu/Cx8GkXso3cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T84VTGmrSEwEAsFE+UjQQRLYdaOYlXrJmeuU54KrCf0Jzb7DBfeWyDAKNlIm8VBhO
         6yO+2jYzhrtUq3sUMRjtqixrhaCT+PGvJWccIs8gNEHUG1ruXD32o5QVDxJZJev26t
         hBb4uR7/QsSZISYNI1xuYtwoQQqs3OJGXjfQ9oy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0807/1039] PCI: mvebu: Fix support for DEVCAP2, DEVCTL2 and LNKCTL2 registers on emulated bridge
Date:   Mon, 24 Jan 2022 19:43:16 +0100
Message-Id: <20220124184152.438249854@linuxfoundation.org>
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

[ Upstream commit 4ab34548c55fbbb3898306a47dfaccd4860e1ccb ]

Armada XP and new hardware supports access to DEVCAP2, DEVCTL2 and LNKCTL2
configuration registers of PCIe core via PCIE_CAP_PCIEXP. So export them
via emulated software root bridge.

Pre-XP hardware does not support these registers and returns zeros.

Link: https://lore.kernel.org/r/20211125124605.25915-16-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 618c34e8879ec..ffcbb8d1d09d5 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -524,6 +524,18 @@ mvebu_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		*value = mvebu_readl(port, PCIE_RC_RTSTA);
 		break;
 
+	case PCI_EXP_DEVCAP2:
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCAP2);
+		break;
+
+	case PCI_EXP_DEVCTL2:
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL2);
+		break;
+
+	case PCI_EXP_LNKCTL2:
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_LNKCTL2);
+		break;
+
 	default:
 		return PCI_BRIDGE_EMUL_NOT_HANDLED;
 	}
@@ -615,6 +627,17 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 		if (new & PCI_EXP_RTSTA_PME)
 			mvebu_writel(port, ~PCIE_INT_PM_PME, PCIE_INT_CAUSE_OFF);
 		break;
+
+	case PCI_EXP_DEVCTL2:
+		mvebu_writel(port, new, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL2);
+		break;
+
+	case PCI_EXP_LNKCTL2:
+		mvebu_writel(port, new, PCIE_CAP_PCIEXP + PCI_EXP_LNKCTL2);
+		break;
+
+	default:
+		break;
 	}
 }
 
-- 
2.34.1



