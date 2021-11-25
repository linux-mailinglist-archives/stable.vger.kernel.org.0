Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0721045D219
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345533AbhKYAfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353032AbhKYAdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 19:33:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB3CB610CF;
        Thu, 25 Nov 2021 00:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637800008;
        bh=8iYHA7g3jgETzn/iCCA7LuTb+gyyjh4M7ZeEOwPr1Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbBJ0JlnkcpPptVmIdFvBV1BY1Vb6/1y0LSVnoYKxDosBkTKomseo5RMM+iesqOB7
         pE87YrvqSlvP/ViR6Do3gCuL6NUqDtwoFIYRGbN2WjVGUuZAtyVXpVVdbtDyxO12pS
         e9/e6yT/vTT5849itXa6Sz+Kk3hu9gIUbG/Up3IGv2icaq3yPqK2WM30gEEthAsEq9
         F6xOm0BFD5KTk7wRCM+DitAEIytFTWk7NTJw0JDw1RqsjP091NBdfdMeRGEafWzhIH
         cX3dZhkipsuUwuPHIFDYAFPwrfWzJ+C8KqzcZ6dOUjIa29qUXSHAwVffyg3vH5LuPH
         9WBeaAa4OX/zA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 16/22] PCI: aardvark: Simplify initialization of rootcap on virtual bridge
Date:   Thu, 25 Nov 2021 01:26:10 +0100
Message-Id: <20211125002616.31363-17-kabel@kernel.org>
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

commit 454c53271fc11f3aa5e44e41fd99ca181bd32c62 upstream.

PCIe config space can be initialized also before pci_bridge_emul_init()
call, so move rootcap initialization after PCI config space initialization.

This simplifies the function a little since it removes one if (ret < 0)
check.

Link: https://lore.kernel.org/r/20211005180952.6812-11-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index bd5d309232a9..bb1d038346bd 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -898,7 +898,6 @@ static struct pci_bridge_emul_ops advk_pci_bridge_emul_ops = {
 static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 {
 	struct pci_bridge_emul *bridge = &pcie->bridge;
-	int ret;
 
 	bridge->conf.vendor =
 		cpu_to_le16(advk_readl(pcie, PCIE_CORE_DEV_ID_REG) & 0xffff);
@@ -918,19 +917,14 @@ static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 	/* Support interrupt A for MSI feature */
 	bridge->conf.intpin = PCIE_CORE_INT_A_ASSERT_ENABLE;
 
+	/* Indicates supports for Completion Retry Status */
+	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
+
 	bridge->has_pcie = true;
 	bridge->data = pcie;
 	bridge->ops = &advk_pci_bridge_emul_ops;
 
-	/* PCIe config space can be initialized after pci_bridge_emul_init() */
-	ret = pci_bridge_emul_init(bridge, 0);
-	if (ret < 0)
-		return ret;
-
-	/* Indicates supports for Completion Retry Status */
-	bridge->pcie_conf.rootcap = cpu_to_le16(PCI_EXP_RTCAP_CRSVIS);
-
-	return 0;
+	return pci_bridge_emul_init(bridge, 0);
 }
 
 static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
-- 
2.32.0

