Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF99F29B51D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793778AbgJ0PIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793664AbgJ0PHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A123C20720;
        Tue, 27 Oct 2020 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811263;
        bh=zTrIGX5j6lGm9KtvsQcpAoF40FD1TkjkOgesb4rR1FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBDza88DIjujJahjSJ8e5B5xoZ2eWhbob1vTCKsXlh+/Knxdl5y7wsSrxXNb6cDcw
         JZBwD2m5NdaYE4w5K1YVjGRi1BdEvf5ZZ+wQBvGXL7Aa9PPa0U97KzvCiSg06RrkRx
         u9iUjpDepNSenxP18gw8N681mBQL5oh68iaovCHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 431/633] PCI: aardvark: Check for errors from pci_bridge_emul_init() call
Date:   Tue, 27 Oct 2020 14:52:54 +0100
Message-Id: <20201027135542.939260118@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 7862a6134456c8b4f8c39e8c94aa97e5c2f7f2b7 ]

Function pci_bridge_emul_init() may fail so correctly check for errors.

Link: https://lore.kernel.org/r/20200907111038.5811-3-pali@kernel.org
Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 8caa80b19cf86..d5f58684d962c 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -608,7 +608,7 @@ static struct pci_bridge_emul_ops advk_pci_bridge_emul_ops = {
  * Initialize the configuration space of the PCI-to-PCI bridge
  * associated with the given PCIe interface.
  */
-static void advk_sw_pci_bridge_init(struct advk_pcie *pcie)
+static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 {
 	struct pci_bridge_emul *bridge = &pcie->bridge;
 
@@ -634,8 +634,7 @@ static void advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 	bridge->data = pcie;
 	bridge->ops = &advk_pci_bridge_emul_ops;
 
-	pci_bridge_emul_init(bridge, 0);
-
+	return pci_bridge_emul_init(bridge, 0);
 }
 
 static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
@@ -1169,7 +1168,11 @@ static int advk_pcie_probe(struct platform_device *pdev)
 
 	advk_pcie_setup_hw(pcie);
 
-	advk_sw_pci_bridge_init(pcie);
+	ret = advk_sw_pci_bridge_init(pcie);
+	if (ret) {
+		dev_err(dev, "Failed to register emulated root PCI bridge\n");
+		return ret;
+	}
 
 	ret = advk_pcie_init_irq_domain(pcie);
 	if (ret) {
-- 
2.25.1



