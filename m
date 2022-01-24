Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCEB49A506
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370528AbiAYAFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850496AbiAXXaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:30:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA355C0A8930;
        Mon, 24 Jan 2022 13:34:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A87161469;
        Mon, 24 Jan 2022 21:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52050C340E4;
        Mon, 24 Jan 2022 21:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060079;
        bh=sLfxwkR7xnnWAPCDwvtlM2q9dCEaGfOBaWsBhM/oKzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/ZMPbkKVltW7skwetVaT8o69LuL85zcQGUZ16S77OMIwfzxDGsI09O0iG/jnwTea
         pxYS85YfdRDERp0d7yBRPkv0ggSop67vtJap0qcWGzOuYXX+ixJxtpPYW3bTFHHMv/
         JqAZkQlE4ar4OVEccRQLR4wUW4aqN0T6ULj5MsmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0799/1039] PCI: mvebu: Check for errors from pci_bridge_emul_init() call
Date:   Mon, 24 Jan 2022 19:43:08 +0100
Message-Id: <20220124184152.158416216@linuxfoundation.org>
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

[ Upstream commit 5d18d702e5c9309f4195653475c7a7fdde4ca71f ]

Function pci_bridge_emul_init() may fail so correctly check for errors.

Link: https://lore.kernel.org/r/20211125124605.25915-3-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index ed13e81cd691d..e6d63ad4d23b8 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -570,7 +570,7 @@ static struct pci_bridge_emul_ops mvebu_pci_bridge_emul_ops = {
  * Initialize the configuration space of the PCI-to-PCI bridge
  * associated with the given PCIe interface.
  */
-static void mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
+static int mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
 {
 	struct pci_bridge_emul *bridge = &port->bridge;
 
@@ -589,7 +589,7 @@ static void mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
 	bridge->data = port;
 	bridge->ops = &mvebu_pci_bridge_emul_ops;
 
-	pci_bridge_emul_init(bridge, PCI_BRIDGE_EMUL_NO_PREFETCHABLE_BAR);
+	return pci_bridge_emul_init(bridge, PCI_BRIDGE_EMUL_NO_PREFETCHABLE_BAR);
 }
 
 static inline struct mvebu_pcie *sys_to_pcie(struct pci_sys_data *sys)
@@ -1112,9 +1112,18 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 			continue;
 		}
 
+		ret = mvebu_pci_bridge_emul_init(port);
+		if (ret < 0) {
+			dev_err(dev, "%s: cannot init emulated bridge\n",
+				port->name);
+			devm_iounmap(dev, port->base);
+			port->base = NULL;
+			mvebu_pcie_powerdown(port);
+			continue;
+		}
+
 		mvebu_pcie_setup_hw(port);
 		mvebu_pcie_set_local_dev_nr(port, 1);
-		mvebu_pci_bridge_emul_init(port);
 	}
 
 	pcie->nports = i;
-- 
2.34.1



