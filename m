Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0998B6AA4DC
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjCCWyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjCCWyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:54:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D841214E87;
        Fri,  3 Mar 2023 14:53:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A063DB81A1F;
        Fri,  3 Mar 2023 21:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79A6C4339C;
        Fri,  3 Mar 2023 21:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879911;
        bh=rdHX1NYCXHcsgCzqeUQTYwR7JXbfTw3eMiKLl6bPnlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+fvJ/tobTsd2kjqawrH52TBUpL+FFJfHdSTt874Idiz/KYms2ds+Lgg9BW/M/p/Q
         G+mUmaNbaWSUdsArdWWWCHc2ya/zrtaXPvDEo1Qix9nmEY0ozdvPZQLWrjJh3qfkbN
         Z15Nnu5E+HfcUR+38LzMf0L4ucqVtmmWVc8AdTtzJCxZI4iwu2P7pvpkEYqJ6+mm7E
         tAmB+1bAQpvFrBLkNEtn+CWmxgylvec0yAWyCT6rnUlZ35asB1sPsdC/cIkPokmj9h
         iphzKh9hcB+BAvZgwRXPLvgaMX6e51OT3eMHAciFhuHHMNKw6Kmn/z5eORxCAHdBui
         2L/zF4E3enQNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 54/60] PCI: Add ACS quirk for Wangxun NICs
Date:   Fri,  3 Mar 2023 16:43:08 -0500
Message-Id: <20230303214315.1447666-54-sashal@kernel.org>
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

From: Mengyuan Lou <mengyuanlou@net-swift.com>

[ Upstream commit a2b9b123ccac913e9f9b80337d687a2fe786a634 ]

Wangxun has verified there is no peer-to-peer between functions for the
below selection of SFxxx, RP1000 and RP2000 NICS.  They may be
multi-function devices, but the hardware does not advertise ACS capability.

Add an ACS quirk for these devices so the functions can be in independent
IOMMU groups.

Link: https://lore.kernel.org/r/20230207102419.44326-1-mengyuanlou@net-swift.com
Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c    | 22 ++++++++++++++++++++++
 include/linux/pci_ids.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 285acc4aaccc1..13290048beda8 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4835,6 +4835,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+/*
+ * Wangxun 10G/1G NICs have no ACS capability, and on multi-function
+ * devices, peer-to-peer transactions are not be used between the functions.
+ * So add an ACS quirk for below devices to isolate functions.
+ * SFxxx 1G NICs(em).
+ * RP1000/RP2000 10G NICs(sp).
+ */
+static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	switch (dev->device) {
+	case 0x0100 ... 0x010F:
+	case 0x1001:
+	case 0x2001:
+		return pci_acs_ctrl_enabled(acs_flags,
+			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	}
+
+	return false;
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
@@ -4980,6 +5000,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
+	/* Wangxun nics */
+	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
 	{ 0 }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index b362d90eb9b0b..bc8f484cdcf3b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3012,6 +3012,8 @@
 #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
+#define PCI_VENDOR_ID_WANGXUN		0x8088
+
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
 
-- 
2.39.2

