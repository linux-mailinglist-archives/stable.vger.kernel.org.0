Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DEE4CF786
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbiCGJq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240881AbiCGJlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6E26AA5C;
        Mon,  7 Mar 2022 01:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 847576116E;
        Mon,  7 Mar 2022 09:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880D9C340E9;
        Mon,  7 Mar 2022 09:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645912;
        bh=wxtsX5+trDGKaAuQRjEP830qBdsbiq53aku4x6QZ0Qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZARjuEHJ2sR8kg95ZATUlZDyX16Mxvn8ejcYfti1a4Lb0ra4Uwn/Aa5yDDJdC9/hj
         dGYDu8g7pk2VQcm5TrfHoIUsAfZDG1wvHT9WsqPaWrjXJt61bCPygYupBP/dMqs/aW
         gm/wfd82sUNx8aJaste6y24X/W/eK0zfFoLm67Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/262] PCI: mvebu: Fix support for DEVCAP2, DEVCTL2 and LNKCTL2 registers on emulated bridge
Date:   Mon,  7 Mar 2022 10:16:58 +0100
Message-Id: <20220307091704.584066309@linuxfoundation.org>
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
index b690768d5a413..357e9a293edf7 100644
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



