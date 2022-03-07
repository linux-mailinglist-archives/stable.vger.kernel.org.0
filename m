Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4844CF769
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiCGJp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbiCGJl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7940550440;
        Mon,  7 Mar 2022 01:38:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EA4FB810D1;
        Mon,  7 Mar 2022 09:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B33C340F3;
        Mon,  7 Mar 2022 09:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645884;
        bh=gR9Qsy0DHrQHAX3LlOQEhO5NH64Tn0o3wJWUrAWaPhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8nRTp+xPNNDfo4R15CA9syWxUKEe26fbA1lF2db4S3EOcyPM4lN2KrxpUNMgQ+IN
         Cn+qaPqtqCPRWf0Zux6fnAbq2tmle8Fe5jAmlJaflU7KIAy8I8rOR5/0AtwgqGei2V
         HIiFi4IiJUbcyEPQT79NS6F7PM0a8/xQ2u4I2/M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/262] PCI: mvebu: Check for errors from pci_bridge_emul_init() call
Date:   Mon,  7 Mar 2022 10:16:50 +0100
Message-Id: <20220307091704.367272135@linuxfoundation.org>
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
index 2dc6890dbcaa2..f4971fc72a772 100644
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
 	u32 pcie_cap = mvebu_readl(port, PCIE_CAP_PCIEXP);
@@ -597,7 +597,7 @@ static void mvebu_pci_bridge_emul_init(struct mvebu_pcie_port *port)
 	bridge->data = port;
 	bridge->ops = &mvebu_pci_bridge_emul_ops;
 
-	pci_bridge_emul_init(bridge, PCI_BRIDGE_EMUL_NO_PREFETCHABLE_BAR);
+	return pci_bridge_emul_init(bridge, PCI_BRIDGE_EMUL_NO_PREFETCHABLE_BAR);
 }
 
 static inline struct mvebu_pcie *sys_to_pcie(struct pci_sys_data *sys)
@@ -1120,9 +1120,18 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
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



