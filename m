Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC5516D8C
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 11:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384285AbiEBJmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 05:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384278AbiEBJm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 05:42:28 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E9B1BE9E;
        Mon,  2 May 2022 02:38:59 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B4F7041E96;
        Mon,  2 May 2022 09:38:54 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Hector Martin <marcan@marcan.st>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/3] PCI: apple: Probe all GPIOs for availability first
Date:   Mon,  2 May 2022 18:38:31 +0900
Message-Id: <20220502093832.32778-3-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502093832.32778-1-marcan@marcan.st>
References: <20220502093832.32778-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we're probing the PCI controller and some GPIOs are not available and
cause a probe defer, we can end up leaving some ports initialized and
not others and making a mess.

Check for PERST# GPIOs for all ports first, and just return
-EPROBE_DEFER if any are not ready yet, without bringing anything up.

Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/pci/controller/pcie-apple.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index e0c06c0ee731..e3aa2d461739 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -507,6 +507,20 @@ static u32 apple_pcie_rid2sid_write(struct apple_pcie_port *port,
 	return readl_relaxed(port->base + PORT_RID2SID(idx));
 }
 
+static int apple_pcie_probe_port(struct device_node *np)
+{
+	struct gpio_desc *gd;
+
+	gd = gpiod_get_from_of_node(np, "reset-gpios", 0,
+				    GPIOD_OUT_LOW, "PERST#");
+	if (IS_ERR(gd)) {
+		return PTR_ERR(gd);
+	}
+
+	gpiod_put(gd);
+	return 0;
+}
+
 static int apple_pcie_setup_port(struct apple_pcie *pcie,
 				 struct device_node *np)
 {
@@ -797,8 +811,18 @@ static int apple_pcie_init(struct pci_config_window *cfg)
 
 static int apple_pcie_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
+	struct device_node *of_port;
 	int ret;
 
+	/* Check for probe dependencies for all ports first */
+	for_each_child_of_node(dev->of_node, of_port) {
+		ret = apple_pcie_probe_port(of_port);
+		of_node_put(of_port);
+		if (ret)
+			return dev_err_probe(dev, ret, "Port %pOF probe fail\n", of_port);
+	}
+
 	ret = bus_register_notifier(&pci_bus_type, &apple_pcie_nb);
 	if (ret)
 		return ret;
-- 
2.35.1

