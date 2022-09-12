Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407585B5582
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 09:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiILHqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 03:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiILHqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 03:46:43 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A791A3B9;
        Mon, 12 Sep 2022 00:46:35 -0700 (PDT)
X-UUID: 974102ee514c46779d604914c54fb22d-20220912
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=8nqBvEoYhhM10pqeIUysrjTuBKAUboHsqeHxK1jGstA=;
        b=O6uT2cFoKC41d0EaVV522525+9lckgOck4c3Lt1VN2TQTqYA1cHorzfZpXEWa44CMguIlQ4oEu2XmMgB9e5MGOwqpsDUxuwl0hy5YrTEJH+fBDgBtN6fTNS0YQIODeYd19TVa2rz8oXgy++M41Cs506qekQPNG8chPw0gBz565c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.10,REQID:fc17f0b4-2541-4899-9761-8f5c472f4cd7,OB:0,L
        OB:0,IP:0,URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Releas
        e_Ham,ACTION:release,TS:-25
X-CID-META: VersionHash:84eae18,CLOUDID:1b0b1bec-2856-4fce-b125-09d4c7ebe045,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 974102ee514c46779d604914c54fb22d-20220912
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <deren.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1867544988; Mon, 12 Sep 2022 15:46:30 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 12 Sep 2022 15:46:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Mon, 12 Sep 2022 15:46:28 +0800
From:   Deren Wu <Deren.Wu@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>
CC:     Sean Wang <sean.wang@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Leon Yen <Leon.Yen@mediatek.com>,
        "Eric-SY Chang" <Eric-SY.Chang@mediatek.com>,
        Deren Wu <Deren.Wu@mediatek.com>, KM Lin <km.lin@mediatek.com>,
        Robin Chiu <robin.chiu@mediatek.com>,
        CH Yeh <ch.yeh@mediatek.com>, Posh Sun <posh.sun@mediatek.com>,
        Stella Chang <Stella.Chang@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        "Ryder Lee" <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        Deren Wu <deren.wu@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH] wifi: mt76: mt7921e: fix random fw download fail
Date:   Mon, 12 Sep 2022 15:45:48 +0800
Message-ID: <c513094e569a21f23c9b5dfe17cd299b76b514d2.1662968113.git.deren.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

In case of PCIe interoperability problem shows up, the firmware
payload my be corrupted in download stage. Turn off L0s to keep
fw download process accurately.

[ 1093.528363] mt7921e 0000:3b:00.0: Message 00000007 (seq 7) timeout
[ 1093.528414] mt7921e 0000:3b:00.0: Failed to start patch
[ 1096.600156] mt7921e 0000:3b:00.0: Message 00000010 (seq 8) timeout
[ 1096.600207] mt7921e 0000:3b:00.0: Failed to release patch semaphore
[ 1097.699031] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1098.758427] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1099.834408] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1100.915264] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1101.990625] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1103.077587] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1104.173258] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1105.248466] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1106.336969] mt7921e 0000:3b:00.0: Timeout for driver own
[ 1106.397542] mt7921e 0000:3b:00.0: hardware init failed

Cc: stable@vger.kernel.org
Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c     | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h    | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 9d1ba838e54f..43a8deeb17df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -148,6 +148,7 @@ static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
 		{ 0x820c8000, 0x0c000, 0x02000 }, /* WF_UMAC_TOP (PSE) */
 		{ 0x820cc000, 0x0e000, 0x01000 }, /* WF_UMAC_TOP (PP) */
 		{ 0x820cd000, 0x0f000, 0x01000 }, /* WF_MDP_TOP */
+		{ 0x74030000, 0x10000, 0x10000 }, /* PCIE_MAC_IREG */
 		{ 0x820ce000, 0x21c00, 0x00200 }, /* WF_LMAC_TOP (WF_SEC) */
 		{ 0x820cf000, 0x22000, 0x01000 }, /* WF_LMAC_TOP (WF_PF) */
 		{ 0x820e0000, 0x20000, 0x00400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
index 5efda694fb9d..19facf31e4e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
@@ -59,6 +59,8 @@ int mt7921e_mcu_init(struct mt7921_dev *dev)
 	if (err)
 		return err;
 
+	mt76_rmw_field(dev, MT_PCIE_MAC_PM, MT_PCIE_MAC_PM_L0S_DIS, 1);
+
 	err = mt7921_run_firmware(dev);
 
 	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_FWDL], false);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index ea643260ceb6..c65582acfa55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -440,6 +440,8 @@
 #define MT_PCIE_MAC_BASE		0x10000
 #define MT_PCIE_MAC(ofs)		(MT_PCIE_MAC_BASE + (ofs))
 #define MT_PCIE_MAC_INT_ENABLE		MT_PCIE_MAC(0x188)
+#define MT_PCIE_MAC_PM			MT_PCIE_MAC(0x194)
+#define MT_PCIE_MAC_PM_L0S_DIS		BIT(8)
 
 #define MT_DMA_SHDL(ofs)		(0x7c026000 + (ofs))
 #define MT_DMASHDL_SW_CONTROL		MT_DMA_SHDL(0x004)
-- 
2.18.0

