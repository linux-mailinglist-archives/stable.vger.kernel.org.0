Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DFF6AF9FE
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 00:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjCGXC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 18:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCGXCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 18:02:07 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BA75F6CF;
        Tue,  7 Mar 2023 14:59:58 -0800 (PST)
Received: from robin.home.jannau.net (p54accbe8.dip0.t-ipconnect.de [84.172.203.232])
        by soltyk.jannau.net (Postfix) with ESMTPSA id E283A26F88D;
        Tue,  7 Mar 2023 23:59:56 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Date:   Tue, 07 Mar 2023 23:59:50 +0100
Subject: [PATCH] PCI: apple: Set only available ports up
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230307-apple_pcie_disabled_ports-v1-1-b32ef91faf19@jannau.net>
X-B4-Tracking: v=1; b=H4sIAOXBB2QC/x2OUQrDIBAFrxL87hY1pYZepRRZdVMXghFXSiHk7
 k36OfDmMZsSakyiHsOmGn1YeC0HmMugYsbyJuB0sLLajnrUDrDWhXyNTD6xYFgo+bq2LqCjcXN
 weHPjpA4/oBCEhiXm8wEFM8P9asH4PhljIfVzVhvN/P0nPF/7/gPJGbNtkgAAAA==
To:     Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2-dev-4f8ba
X-Developer-Signature: v=1; a=openpgp-sha256; l=1425; i=j@jannau.net;
 h=from:subject:message-id; bh=l9OFnjvz5hSLpKVP1Knu7cPVnfzmd8YSULsFW4CMVGk=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhhT2g29ObHdp+FD/Z29UeARP3s0dVl+5j8pMdjrC7p9ju
 rFumkx7RykLgxgHg6yYIkuS9ssOhtU1ijG1D8Jg5rAygQxh4OIUgIlMOczIMHX9vjwmlYQGN0Mt
 lsUyBfvPvr+lsfac+qOEeEUG1+KAewz/K76lvmLOZbSdxifixcq4btqOC399Lyz1vHODk/XTiaJ
 J7AA=
X-Developer-Key: i=j@jannau.net; a=openpgp;
 fpr=8B336A6BE4E5695E89B8532B81E806F586338419
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes "interrupt-map" parsing in of_irq_parse_raw() which takes the
node's availability into account.

This became apparent after disabling unused PCIe ports in the Apple
silicon device trees instead of disabling them.

Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unused-v1-0-5ea0d3ddcde3@jannau.net/
Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08ce@linaro.org/
Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
Cc: stable@vger.kernel.org
Signed-off-by: Janne Grunau <j@jannau.net>
---
 drivers/pci/controller/pcie-apple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index 66f37e403a09..f8670a032f7a 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -783,7 +783,7 @@ static int apple_pcie_init(struct pci_config_window *cfg)
 	cfg->priv = pcie;
 	INIT_LIST_HEAD(&pcie->ports);
 
-	for_each_child_of_node(dev->of_node, of_port) {
+	for_each_available_child_of_node(dev->of_node, of_port) {
 		ret = apple_pcie_setup_port(pcie, of_port);
 		if (ret) {
 			dev_err(pcie->dev, "Port %pOF setup fail: %d\n", of_port, ret);

---
base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
change-id: 20230307-apple_pcie_disabled_ports-0c17fb7a4738

Best regards,
-- 
Janne Grunau <j@jannau.net>

