Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5899D4CF780
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbiCGJqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240842AbiCGJlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7D66B08C;
        Mon,  7 Mar 2022 01:38:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3F1C6128E;
        Mon,  7 Mar 2022 09:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50ECC340E9;
        Mon,  7 Mar 2022 09:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645903;
        bh=YU1Vn6+28zS0qXcWI5p6LeDttNBRhF0fSEo7j/aBBGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sW2a9lxbx8HSDhdjmGj/oOtV3dcZWvtQHwF7zQ8e2P4bKfRAg6l+rsJqs2niDQDx/
         W4bxK96EWbQsmPZG1TNJYLNXLIr+2oQfy/UeQjFonXYio9ZK8YDjl8Ke4oJUVSZLlC
         ygg507CgwPFb8x4tOQeTZptzsMBxA31Dsvfu/Yk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/262] PCI: mvebu: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge
Date:   Mon,  7 Mar 2022 10:16:55 +0100
Message-Id: <20220307091704.502609814@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index e2d4bd8442a80..3563301e772ae 100644
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



