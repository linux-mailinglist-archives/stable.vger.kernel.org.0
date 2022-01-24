Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEF049A4AF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369577AbiAYACL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1587648AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB32C0A8877;
        Mon, 24 Jan 2022 13:33:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCD061305;
        Mon, 24 Jan 2022 21:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4B6C340E4;
        Mon, 24 Jan 2022 21:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059995;
        bh=yJKKoZqoeZsU/xnmPZ+NZhMnAgPh1Vr7l6l0WGRJ2cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrjYebrhZ/JIqN67oM6sWsi7TrcuQRgB/A1Zy54d2+CZkoW/kQZ8EzqAnjoYTfV5P
         74kz1De7m0rESCJzU6hzLZCSotz7Y7e9o7cmK1LopjjS1RiVQhRnVVoHB3ggJDRsi+
         hXdy3TpfDIVZEWSxc5DDAruCdi4+bC2MH5DPDWLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0805/1039] PCI: mvebu: Fix support for PCI_EXP_DEVCTL on emulated bridge
Date:   Mon, 24 Jan 2022 19:43:14 +0100
Message-Id: <20220124184152.374674254@linuxfoundation.org>
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

[ Upstream commit ecae073e393e65ee7be7ebf3fdd5258ab99f1636 ]

Comment in Armada 370 functional specification is misleading.
PCI_EXP_DEVCTL_*RE bits are supported and configures receiving of error
interrupts.

Link: https://lore.kernel.org/r/20211125124605.25915-14-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index aaf6a226f6dba..0052e83c95de9 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -498,9 +498,7 @@ mvebu_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_EXP_DEVCTL:
-		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL) &
-				 ~(PCI_EXP_DEVCTL_URRE | PCI_EXP_DEVCTL_FERE |
-				   PCI_EXP_DEVCTL_NFERE | PCI_EXP_DEVCTL_CERE);
+		*value = mvebu_readl(port, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL);
 		break;
 
 	case PCI_EXP_LNKCAP:
@@ -590,13 +588,6 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 
 	switch (reg) {
 	case PCI_EXP_DEVCTL:
-		/*
-		 * Armada370 data says these bits must always
-		 * be zero when in root complex mode.
-		 */
-		new &= ~(PCI_EXP_DEVCTL_URRE | PCI_EXP_DEVCTL_FERE |
-			 PCI_EXP_DEVCTL_NFERE | PCI_EXP_DEVCTL_CERE);
-
 		mvebu_writel(port, new, PCIE_CAP_PCIEXP + PCI_EXP_DEVCTL);
 		break;
 
-- 
2.34.1



