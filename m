Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D06B467D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjCJOns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjCJOna (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:43:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63F73B0D1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:43:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B1EB822E4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C781C433EF;
        Fri, 10 Mar 2023 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459399;
        bh=EW2bKacWBx2KLTNdcbe3a0wQMPbb0krAQ+X/DMJwonQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WigJqrc9m4DnPexNqTf/liRiD1uq6Olc0RKWikkAzFbDuHtcJEU1mYkt7VpR5moRp
         iV2l/BalhC8r3VV7V5rJ+7GzIgpSCOkH5Dx2pGj3fv42MIB8KzmTya3iW38J5KLVmH
         NWI3lbF8f8DgEjw6WdRCXaTrlnP0KcV/CoHksqw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mengyuan Lou <mengyuanlou@net-swift.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 347/357] PCI: Add ACS quirk for Wangxun NICs
Date:   Fri, 10 Mar 2023 14:40:36 +0100
Message-Id: <20230310133749.978482833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index b5a384f0a6844..449d4ed611a68 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4843,6 +4843,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
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
@@ -4988,6 +5008,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
+	/* Wangxun nics */
+	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
 	{ 0 }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 526d423740eb2..a31aa3ac4219f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3024,6 +3024,8 @@
 #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
+#define PCI_VENDOR_ID_WANGXUN		0x8088
+
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
 
-- 
2.39.2



