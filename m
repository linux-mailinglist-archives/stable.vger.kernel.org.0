Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA9F29C1E8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762164AbgJ0OlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761931AbgJ0OkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:40:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F753207BB;
        Tue, 27 Oct 2020 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809622;
        bh=Pkodcc0QYTb16u6wZo6rczQdApgVsy1vL1dCe8RTyis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3KGW1rXzKIOOvNjqG1T6++qLNzGck+dp8B/hJAtp3xoVu6iEe9HKajbSZoTtzNOv
         NVYaBryiBgwss+0+EEzed5mkKfWTE4/0gIJRfVxY+V7R+GRrawELl+InrgV3UbCyZx
         EgQm3ZfUuhKwQI31krrVamlzowc0Ftb67ZG3Krq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 262/408] PCI: aardvark: Check for errors from pci_bridge_emul_init() call
Date:   Tue, 27 Oct 2020 14:53:20 +0100
Message-Id: <20201027135507.201240352@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index f2481e80e2723..d0e60441dc8f2 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -503,7 +503,7 @@ static struct pci_bridge_emul_ops advk_pci_bridge_emul_ops = {
  * Initialize the configuration space of the PCI-to-PCI bridge
  * associated with the given PCIe interface.
  */
-static void advk_sw_pci_bridge_init(struct advk_pcie *pcie)
+static int advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 {
 	struct pci_bridge_emul *bridge = &pcie->bridge;
 
@@ -527,8 +527,7 @@ static void advk_sw_pci_bridge_init(struct advk_pcie *pcie)
 	bridge->data = pcie;
 	bridge->ops = &advk_pci_bridge_emul_ops;
 
-	pci_bridge_emul_init(bridge, 0);
-
+	return pci_bridge_emul_init(bridge, 0);
 }
 
 static bool advk_pcie_valid_device(struct advk_pcie *pcie, struct pci_bus *bus,
@@ -1027,7 +1026,11 @@ static int advk_pcie_probe(struct platform_device *pdev)
 
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



