Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E0B6B4AEC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbjCJP2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbjCJP13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:27:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CA112C0ED
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 835DC61A47
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96202C4339E;
        Fri, 10 Mar 2023 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461382;
        bh=eaqxMiW+hFInlOzEsD+yg/ipaGPuNxTLH2jXqymyuGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8+4oBo/xLMGfXiYzVNgUX0jg6rVutpRnCUrOEERiN1FGRnx/tc+lmhvoQxz+CS1X
         KmkfYTjhBroiQFFX5DK0o7mGPRopZQ0ufN5KexuD1wUk1JYPIVb9Xitn86pnPR+3Jv
         /wMsKW+es880OVmzoMdKmaN8Y8ClLrf/QnFsZgb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huacai Chen <chenhuacai@loongson.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/136] PCI: loongson: Add more devices that need MRRS quirk
Date:   Fri, 10 Mar 2023 14:44:01 +0100
Message-Id: <20230310133710.811638169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit c768f8c5f40fcdc6f058cc2f02592163d6c6716c ]

Loongson-2K SOC and LS7A2000 chipset add new PCI IDs that need MRRS
quirk.  Add them.

Link: https://lore.kernel.org/r/20230211023321.3530080-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-loongson.c | 33 +++++++++++++++++++--------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-loongson.c b/drivers/pci/controller/pci-loongson.c
index dc7b4e4293ced..e73e18a73833b 100644
--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -13,9 +13,14 @@
 #include "../pci.h"
 
 /* Device IDs */
-#define DEV_PCIE_PORT_0	0x7a09
-#define DEV_PCIE_PORT_1	0x7a19
-#define DEV_PCIE_PORT_2	0x7a29
+#define DEV_LS2K_PCIE_PORT0	0x1a05
+#define DEV_LS7A_PCIE_PORT0	0x7a09
+#define DEV_LS7A_PCIE_PORT1	0x7a19
+#define DEV_LS7A_PCIE_PORT2	0x7a29
+#define DEV_LS7A_PCIE_PORT3	0x7a39
+#define DEV_LS7A_PCIE_PORT4	0x7a49
+#define DEV_LS7A_PCIE_PORT5	0x7a59
+#define DEV_LS7A_PCIE_PORT6	0x7a69
 
 #define DEV_LS2K_APB	0x7a02
 #define DEV_LS7A_CONF	0x7a10
@@ -38,11 +43,11 @@ static void bridge_class_quirk(struct pci_dev *dev)
 	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_0, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT0, bridge_class_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_1, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT1, bridge_class_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_2, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT2, bridge_class_quirk);
 
 static void system_bus_quirk(struct pci_dev *pdev)
 {
@@ -72,11 +77,21 @@ static void loongson_mrrs_quirk(struct pci_dev *pdev)
 	bridge->no_inc_mrrs = 1;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_0, loongson_mrrs_quirk);
+			DEV_LS2K_PCIE_PORT0, loongson_mrrs_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_1, loongson_mrrs_quirk);
+			DEV_LS7A_PCIE_PORT0, loongson_mrrs_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_2, loongson_mrrs_quirk);
+			DEV_LS7A_PCIE_PORT1, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT2, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT3, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT4, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT5, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT6, loongson_mrrs_quirk);
 
 static void __iomem *cfg1_map(struct loongson_pci *priv, int bus,
 				unsigned int devfn, int where)
-- 
2.39.2



