Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4566AA294
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbjCCVsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbjCCVsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F1C69CD7;
        Fri,  3 Mar 2023 13:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF688B819F8;
        Fri,  3 Mar 2023 21:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D74C4339C;
        Fri,  3 Mar 2023 21:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879845;
        bh=opuHgZY3JMxoDZLJYqvPI5EIZPkEVCI1HwXnDKj40NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn3QVLFdFnzan+pIgO1eSuxGT6woT4pQYAP4RFybHWXoeCg0hBVtWnhbWQ+uL219o
         5Pc9PDHOw34+KKthlyCjj9M1TcixajnrmlkW9x/a3unCSX7b1s6HxtPFP08HttXFWi
         HObOQ7LOBNAWXTLgBSnWTIHdwI+sbSY+4digSxVhjxkTbQDtffalypCtauHi5gYZCD
         XidPppxr0jiIGSUmy2uju2C5hZ4hYOYtzvQSmcTq09zadBuTe6KK7q5SCqwbucZ8VV
         THJgpRHYRMhjXna0oaLm+T5mCUiTViDCStzISaTPpTXFrlmQECpvmKiNb9fcSY7zJ3
         o1St8w37yM/Cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, lpieralisi@kernel.org,
        kw@linux.com, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 24/60] PCI: loongson: Prevent LS7A MRRS increases
Date:   Fri,  3 Mar 2023 16:42:38 -0500
Message-Id: <20230303214315.1447666-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 8b3517f88ff2983f52698893519227c10aac90b2 ]

Except for isochronous-configured devices, software may set
Max_Read_Request_Size (MRRS) to any value up to 4096.  If a device issues a
read request with size greater than the completer's Max_Payload_Size (MPS),
the completer is required to break the response into multiple completions.

Instead of correctly responding with multiple completions to a large read
request, some LS7A Root Ports respond with a Completer Abort.  To prevent
this, the MRRS must be limited to an implementation-specific value.

The OS cannot detect that value, so rely on BIOS to configure MRRS before
booting, and quirk the Root Ports so we never set an MRRS larger than that
BIOS value for any downstream device.

N.B. Hot-added devices are not configured by BIOS, and they power up with
MRRS = 512 bytes, so these devices will be limited to 512 bytes.  If the
LS7A limit is smaller, those hot-added devices may not work correctly, but
per [1], hotplug is not supported with this chipset revision.

[1] https://lore.kernel.org/r/073638a7-ae68-2847-ac3d-29e5e760d6af@loongson.cn

[bhelgaas: commit log]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216884
Link: https://lore.kernel.org/r/20230201043018.778499-3-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-loongson.c | 44 +++++++++------------------
 drivers/pci/pci.c                     | 10 ++++++
 include/linux/pci.h                   |  1 +
 3 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/controller/pci-loongson.c b/drivers/pci/controller/pci-loongson.c
index 05c50408f13b7..759ec211c17bf 100644
--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -75,37 +75,23 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 			DEV_LS7A_LPC, system_bus_quirk);
 
-static void loongson_mrrs_quirk(struct pci_dev *dev)
+static void loongson_mrrs_quirk(struct pci_dev *pdev)
 {
-	struct pci_bus *bus = dev->bus;
-	struct pci_dev *bridge;
-	static const struct pci_device_id bridge_devids[] = {
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_0) },
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_1) },
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_2) },
-		{ 0, },
-	};
-
-	/* look for the matching bridge */
-	while (!pci_is_root_bus(bus)) {
-		bridge = bus->self;
-		bus = bus->parent;
-		/*
-		 * Some Loongson PCIe ports have a h/w limitation of
-		 * 256 bytes maximum read request size. They can't handle
-		 * anything larger than this. So force this limit on
-		 * any devices attached under these ports.
-		 */
-		if (pci_match_id(bridge_devids, bridge)) {
-			if (pcie_get_readrq(dev) > 256) {
-				pci_info(dev, "limiting MRRS to 256\n");
-				pcie_set_readrq(dev, 256);
-			}
-			break;
-		}
-	}
+	/*
+	 * Some Loongson PCIe ports have h/w limitations of maximum read
+	 * request size. They can't handle anything larger than this. So
+	 * force this limit on any devices attached under these ports.
+	 */
+	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
+
+	bridge->no_inc_mrrs = 1;
 }
-DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_PCIE_PORT_0, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_PCIE_PORT_1, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_PCIE_PORT_2, loongson_mrrs_quirk);
 
 static void loongson_pci_pin_quirk(struct pci_dev *pdev)
 {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d81df459b2f0..d0c973cf3d623 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6026,6 +6026,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 {
 	u16 v;
 	int ret;
+	struct pci_host_bridge *bridge = pci_find_host_bridge(dev->bus);
 
 	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
 		return -EINVAL;
@@ -6044,6 +6045,15 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 
 	v = (ffs(rq) - 8) << 12;
 
+	if (bridge->no_inc_mrrs) {
+		int max_mrrs = pcie_get_readrq(dev);
+
+		if (rq > max_mrrs) {
+			pci_info(dev, "can't set Max_Read_Request_Size to %d; max is %d\n", rq, max_mrrs);
+			return -EINVAL;
+		}
+	}
+
 	ret = pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
 						  PCI_EXP_DEVCTL_READRQ, v);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2bda4a4e47e81..cb538bc579710 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -570,6 +570,7 @@ struct pci_host_bridge {
 	void		*release_data;
 	unsigned int	ignore_reset_delay:1;	/* For entire hierarchy */
 	unsigned int	no_ext_tags:1;		/* No Extended Tags */
+	unsigned int	no_inc_mrrs:1;		/* No Increase MRRS */
 	unsigned int	native_aer:1;		/* OS may use PCIe AER */
 	unsigned int	native_pcie_hotplug:1;	/* OS may use PCIe hotplug */
 	unsigned int	native_shpc_hotplug:1;	/* OS may use SHPC hotplug */
-- 
2.39.2

