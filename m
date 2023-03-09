Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785C66B258F
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 14:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCINgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 08:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCINgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 08:36:35 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECCFD3311;
        Thu,  9 Mar 2023 05:36:31 -0800 (PST)
Received: from robin.home.jannau.net (p54accbe8.dip0.t-ipconnect.de [84.172.203.232])
        by soltyk.jannau.net (Postfix) with ESMTPSA id 59BAA26F8B0;
        Thu,  9 Mar 2023 14:36:29 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Date:   Thu, 09 Mar 2023 14:36:24 +0100
Subject: [PATCH v2] PCI: apple: Set only available ports up
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230307-apple_pcie_disabled_ports-v2-1-c3bd1fd278a4@jannau.net>
X-B4-Tracking: v=1; b=H4sIANfgCWQC/42OTQ6CMBCFr0K6dghTjIAr72EImcJUxpjStJVoC
 HcXOIHL7+X9LSpyEI7qmi0q8CxRJreBPmWqH8k9GGTYWOlCl0VZVEDev7jzvXA3SCTz4qHzU0g
 Rih4rayo6V2WttryhyGACuX7cGyjSKHDJNWCXakQNQ9ptPrCVz3Hh3m48SkxT+B6PZtzVf8ZnB
 ARTarYNWrLY3J7kHL1zx0m167r+AOzk3WLqAAAA
To:     Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.2-dev-4f8ba
X-Developer-Signature: v=1; a=openpgp-sha256; l=2589; i=j@jannau.net;
 h=from:subject:message-id; bh=QcxEtQIueASZ7Kn8Sieol5sNB26pvJfkFJzVau6FKHs=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhhTOB3dCEt8/j7NmD8mOOqH08tpn19yD0g8qtv7l4r7KK
 7WQLXN3RykLgxgHg6yYIkuS9ssOhtU1ijG1D8Jg5rAygQxh4OIUgInY/GFk+F1QKbri/LfszVOY
 XDzKksw/7M7+savd+fa2t1Mv8ZqqBzD8r55sVrjtfE5u7ue3f89tO7WNb+e5eoaFJ0+vcnAtT7z
 AzQMA
X-Developer-Key: i=j@jannau.net; a=openpgp;
 fpr=8B336A6BE4E5695E89B8532B81E806F586338419
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes following warning inside of_irq_parse_raw() called from the common
PCI device probe path.

  /soc/pcie@690000000/pci@1,0 interrupt-map failed, using interrupt-controller
  WARNING: CPU: 4 PID: 252 at drivers/of/irq.c:279 of_irq_parse_raw+0x5fc/0x724
  ...
  Call trace:
   of_irq_parse_raw+0x5fc/0x724
   of_irq_parse_and_map_pci+0x128/0x1d8
   pci_assign_irq+0xc8/0x140
   pci_device_probe+0x70/0x188
   really_probe+0x178/0x418
   __driver_probe_device+0x120/0x188
   driver_probe_device+0x48/0x22c
   __device_attach_driver+0x134/0x1d8
   bus_for_each_drv+0x8c/0xd8
   __device_attach+0xdc/0x1d0
   device_attach+0x20/0x2c
   pci_bus_add_device+0x5c/0xc0
   pci_bus_add_devices+0x58/0x88
   pci_host_probe+0x124/0x178
   pci_host_common_probe+0x124/0x198 [pci_host_common]
   apple_pcie_probe+0x108/0x16c [pcie_apple]
   platform_probe+0xb4/0xdc

This became apparent after disabling unused PCIe ports in the Apple
silicon device trees instead of deleting them.

Use for_each_available_child_of_node instead of for_each_child_of_node
which takes the "status" property into account.

Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unused-v1-0-5ea0d3ddcde3@jannau.net/
Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08ce@linaro.org/
Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Janne Grunau <j@jannau.net>
---
Changes in v2:
- rewritten commit message with more details and corrections
- collected Marc's "Reviewed-by:"
- Link to v1: https://lore.kernel.org/r/20230307-apple_pcie_disabled_ports-v1-1-b32ef91faf19@jannau.net
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

