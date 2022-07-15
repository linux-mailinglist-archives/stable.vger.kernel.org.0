Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A545767E7
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 22:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiGOT7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 15:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiGOT7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 15:59:44 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F64753B1;
        Fri, 15 Jul 2022 12:59:42 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso7109675pjk.3;
        Fri, 15 Jul 2022 12:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UzYAPla/80/LN8bVyX6WSfuF3YFvUrZUewuLhzxStWk=;
        b=lNbIopt7Zv+Q6a0qIixU/2YjSiYW/uYJy+LDufsZHZQMEcxWiOk/7t6wh2gWb8emXk
         AT9ldHTU/kUKYJzPuYQssYLF6d0BeGXWj2bW2EFW1LPakFi7Mwc0YRWMezwwSdItteOS
         n7WUq9o8GSri2LllJnVn0UMcpC4d97FEL2Etn2KKu69eLLKDwuzwYRyY0SzkfXErr0lY
         RVcqURLLOLqDrldbt0Vpxq3yYOPxPVWxZazvLsxHsT7mwkWnXKLdAaBehuB8Fk6/MlV/
         +XjHcdjeHYGb0rFWUGH8bMFbKO5fP/K8ZfXVYhzI5F93h0HUtKneF1qU+xj/PmMEaFK1
         mZ5Q==
X-Gm-Message-State: AJIora+sHfeCAH/3Q1dBCgvblDIJPYldCEgsKgc/qsRE0G9clW2eyRNo
        1TmaeCbk/Gn2Wr6LH7EXvjBonb0W3U8=
X-Google-Smtp-Source: AGRyM1t+dbuYv+h2sJFJ2Hq4HDFhhVN3RG/O2kvQKYp8liZ9IiNlpfqzVFAlgAs39SXePVSDZqsMow==
X-Received: by 2002:a17:902:d651:b0:16b:f55e:c626 with SMTP id y17-20020a170902d65100b0016bf55ec626mr15558213plh.78.1657915181400;
        Fri, 15 Jul 2022 12:59:41 -0700 (PDT)
Received: from sean-ThinkPad-T450s.lan (c-73-71-21-1.hsd1.ca.comcast.net. [73.71.21.1])
        by smtp.gmail.com with ESMTPSA id y1-20020a62ce01000000b00528bc6d8939sm4224629pfg.157.2022.07.15.12.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 12:59:40 -0700 (PDT)
From:   sean.wang@kernel.org
To:     stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 5.15 4/5] mt76: mt7921e: fix possible probe failure after reboot
Date:   Fri, 15 Jul 2022 12:59:25 -0700
Message-Id: <25c3ff7c55f0b916d73778be156f9f784722a0f9.1657915079.git.sean.wang@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <27b8ccd411f2c51e2b8193a4eb1fa7e6f416a2f0.1657915079.git.sean.wang@kernel.org>
References: <27b8ccd411f2c51e2b8193a4eb1fa7e6f416a2f0.1657915079.git.sean.wang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

commit 602cc0c9618a819ab00ea3c9400742a0ca318380 upstream.

It doesn't guarantee the mt7921e gets started with ASPM L0 after each
machine reboot on every platform.

If mt7921e gets started with not ASPM L0, it would be possible that the
driver encounters time to time failure in mt7921_pci_probe, like a
weird chip identifier is read

[  215.514503] mt7921e 0000:05:00.0: ASIC revision: feed0000
[  216.604741] mt7921e: probe of 0000:05:00.0 failed with error -110

or failing to init hardware because the driver is not allowed to access the
register until the device is in ASPM L0 state. So, we call
__mt7921e_mcu_drv_pmctrl in early mt7921_pci_probe to force the device
to bring back to the L0 state for we can safely access registers in any
case.

In the patch, we move all functions from dma.c to pci.c and register mt76
bus operation earilier, that is the __mt7921e_mcu_drv_pmctrl depends on.

Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
Reported-by: Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>
Co-developed-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
There was mistake in
'649178c0493e ("mt76: mt7921e: fix possible probe failure after reboot")'
that caused WiFi reset cannot work well as the reported issue
"PROBLEM: [Stable v5.15.42+] [mt7921] Wake after suspend locks up system
when mt7921-driver is used on a Lenovo ThinkPad E15 G3"
in http://lists.infradead.org/pipermail/linux-mediatek/2022-June/042668.html
So, we need to fix and land it again on the stable tree from upstream.

v2: no changed
---
 .../net/wireless/mediatek/mt76/mt7921/dma.c   | 116 -----------------
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  18 ++-
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |   1 +
 .../net/wireless/mediatek/mt76/mt7921/pci.c   | 121 ++++++++++++++++++
 4 files changed, 136 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index f74c385ec80f..93d0cc1827d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -118,110 +118,6 @@ static void mt7921_dma_prefetch(struct mt7921_dev *dev)
 	mt76_wr(dev, MT_WFDMA0_TX_RING17_EXT_CTRL, PREFETCH(0x380, 0x4));
 }
 
-static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
-{
-	static const struct {
-		u32 phys;
-		u32 mapped;
-		u32 size;
-	} fixed_map[] = {
-		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
-		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
-		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
-		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
-		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
-		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
-		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
-		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
-		{ 0x00400000, 0x80000, 0x10000 }, /* WF_MCU_SYSRAM */
-		{ 0x00410000, 0x90000, 0x10000 }, /* WF_MCU_SYSRAM (configure register) */
-		{ 0x40000000, 0x70000, 0x10000 }, /* WF_UMAC_SYSRAM */
-		{ 0x54000000, 0x02000, 0x1000 }, /* WFDMA PCIE0 MCU DMA0 */
-		{ 0x55000000, 0x03000, 0x1000 }, /* WFDMA PCIE0 MCU DMA1 */
-		{ 0x58000000, 0x06000, 0x1000 }, /* WFDMA PCIE1 MCU DMA0 (MEM_DMA) */
-		{ 0x59000000, 0x07000, 0x1000 }, /* WFDMA PCIE1 MCU DMA1 */
-		{ 0x7c000000, 0xf0000, 0x10000 }, /* CONN_INFRA */
-		{ 0x7c020000, 0xd0000, 0x10000 }, /* CONN_INFRA, WFDMA */
-		{ 0x7c060000, 0xe0000, 0x10000 }, /* CONN_INFRA, conn_host_csr_top */
-		{ 0x80020000, 0xb0000, 0x10000 }, /* WF_TOP_MISC_OFF */
-		{ 0x81020000, 0xc0000, 0x10000 }, /* WF_TOP_MISC_ON */
-		{ 0x820c0000, 0x08000, 0x4000 }, /* WF_UMAC_TOP (PLE) */
-		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
-		{ 0x820cc000, 0x0e000, 0x1000 }, /* WF_UMAC_TOP (PP) */
-		{ 0x820cd000, 0x0f000, 0x1000 }, /* WF_MDP_TOP */
-		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
-		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
-		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
-		{ 0x820e1000, 0x20400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_TRB) */
-		{ 0x820e9000, 0x23400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_WTBLOFF) */
-		{ 0x820ea000, 0x24000, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_ETBF) */
-		{ 0x820ec000, 0x24600, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_INT) */
-		{ 0x820f0000, 0xa0000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_CFG) */
-		{ 0x820f1000, 0xa0600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_TRB) */
-		{ 0x820f2000, 0xa0800, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_AGG) */
-		{ 0x820f3000, 0xa0c00, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_ARB) */
-		{ 0x820f4000, 0xa1000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_TMAC) */
-		{ 0x820f5000, 0xa1400, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_RMAC) */
-		{ 0x820f7000, 0xa1e00, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_DMA) */
-		{ 0x820f9000, 0xa3400, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_WTBLOFF) */
-		{ 0x820fa000, 0xa4000, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_ETBF) */
-		{ 0x820fb000, 0xa4200, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_LPON) */
-		{ 0x820fc000, 0xa4600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_INT) */
-		{ 0x820fd000, 0xa4800, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_MIB) */
-	};
-	int i;
-
-	if (addr < 0x100000)
-		return addr;
-
-	for (i = 0; i < ARRAY_SIZE(fixed_map); i++) {
-		u32 ofs;
-
-		if (addr < fixed_map[i].phys)
-			continue;
-
-		ofs = addr - fixed_map[i].phys;
-		if (ofs > fixed_map[i].size)
-			continue;
-
-		return fixed_map[i].mapped + ofs;
-	}
-
-	if ((addr >= 0x18000000 && addr < 0x18c00000) ||
-	    (addr >= 0x70000000 && addr < 0x78000000) ||
-	    (addr >= 0x7c000000 && addr < 0x7c400000))
-		return mt7921_reg_map_l1(dev, addr);
-
-	dev_err(dev->mt76.dev, "Access currently unsupported address %08x\n",
-		addr);
-
-	return 0;
-}
-
-static u32 mt7921_rr(struct mt76_dev *mdev, u32 offset)
-{
-	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
-	u32 addr = __mt7921_reg_addr(dev, offset);
-
-	return dev->bus_ops->rr(mdev, addr);
-}
-
-static void mt7921_wr(struct mt76_dev *mdev, u32 offset, u32 val)
-{
-	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
-	u32 addr = __mt7921_reg_addr(dev, offset);
-
-	dev->bus_ops->wr(mdev, addr, val);
-}
-
-static u32 mt7921_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
-{
-	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
-	u32 addr = __mt7921_reg_addr(dev, offset);
-
-	return dev->bus_ops->rmw(mdev, addr, mask, val);
-}
-
 static int mt7921_dma_disable(struct mt7921_dev *dev, bool force)
 {
 	if (force) {
@@ -381,20 +277,8 @@ int mt7921_wpdma_reinit_cond(struct mt7921_dev *dev)
 
 int mt7921_dma_init(struct mt7921_dev *dev)
 {
-	struct mt76_bus_ops *bus_ops;
 	int ret;
 
-	dev->bus_ops = dev->mt76.bus;
-	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
-			       GFP_KERNEL);
-	if (!bus_ops)
-		return -ENOMEM;
-
-	bus_ops->rr = mt7921_rr;
-	bus_ops->wr = mt7921_wr;
-	bus_ops->rmw = mt7921_rmw;
-	dev->mt76.bus = bus_ops;
-
 	mt76_dma_attach(&dev->mt76);
 
 	ret = mt7921_dma_disable(dev, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 391bbb114750..9b490ff36bd6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1306,10 +1306,8 @@ int mt7921_mcu_sta_update(struct mt7921_dev *dev, struct ieee80211_sta *sta,
 	return mt76_connac_mcu_sta_cmd(&dev->mphy, &info);
 }
 
-int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
+int __mt7921e_mcu_drv_pmctrl(struct mt7921_dev *dev)
 {
-	struct mt76_phy *mphy = &dev->mt76.phy;
-	struct mt76_connac_pm *pm = &dev->pm;
 	int i, err = 0;
 
 	for (i = 0; i < MT7921_DRV_OWN_RETRY_COUNT; i++) {
@@ -1322,9 +1320,21 @@ int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
 		dev_err(dev->mt76.dev, "driver own failed\n");
 		err = -EIO;
-		goto out;
 	}
 
+	return err;
+}
+
+int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mt76.phy;
+	struct mt76_connac_pm *pm = &dev->pm;
+	int err;
+
+	err = __mt7921e_mcu_drv_pmctrl(dev);
+	if (err < 0)
+		goto out;
+
 	mt7921_wpdma_reinit_cond(dev);
 	clear_bit(MT76_STATE_PM, &mphy->state);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 32d4f2cab94e..6eb03d6705a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -374,6 +374,7 @@ int mt7921_mcu_uni_rx_ba(struct mt7921_dev *dev,
 			 bool enable);
 void mt7921_scan_work(struct work_struct *work);
 int mt7921_mcu_uni_bss_ps(struct mt7921_dev *dev, struct ieee80211_vif *vif);
+int __mt7921e_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index c3905bcab360..815b926e52e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -88,6 +88,110 @@ static void mt7921_irq_tasklet(unsigned long data)
 		napi_schedule(&dev->mt76.napi[MT_RXQ_MAIN]);
 }
 
+static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
+{
+	static const struct {
+		u32 phys;
+		u32 mapped;
+		u32 size;
+	} fixed_map[] = {
+		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
+		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
+		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
+		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
+		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
+		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
+		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
+		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
+		{ 0x00400000, 0x80000, 0x10000 }, /* WF_MCU_SYSRAM */
+		{ 0x00410000, 0x90000, 0x10000 }, /* WF_MCU_SYSRAM (configure register) */
+		{ 0x40000000, 0x70000, 0x10000 }, /* WF_UMAC_SYSRAM */
+		{ 0x54000000, 0x02000, 0x1000 }, /* WFDMA PCIE0 MCU DMA0 */
+		{ 0x55000000, 0x03000, 0x1000 }, /* WFDMA PCIE0 MCU DMA1 */
+		{ 0x58000000, 0x06000, 0x1000 }, /* WFDMA PCIE1 MCU DMA0 (MEM_DMA) */
+		{ 0x59000000, 0x07000, 0x1000 }, /* WFDMA PCIE1 MCU DMA1 */
+		{ 0x7c000000, 0xf0000, 0x10000 }, /* CONN_INFRA */
+		{ 0x7c020000, 0xd0000, 0x10000 }, /* CONN_INFRA, WFDMA */
+		{ 0x7c060000, 0xe0000, 0x10000 }, /* CONN_INFRA, conn_host_csr_top */
+		{ 0x80020000, 0xb0000, 0x10000 }, /* WF_TOP_MISC_OFF */
+		{ 0x81020000, 0xc0000, 0x10000 }, /* WF_TOP_MISC_ON */
+		{ 0x820c0000, 0x08000, 0x4000 }, /* WF_UMAC_TOP (PLE) */
+		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
+		{ 0x820cc000, 0x0e000, 0x1000 }, /* WF_UMAC_TOP (PP) */
+		{ 0x820cd000, 0x0f000, 0x1000 }, /* WF_MDP_TOP */
+		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
+		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
+		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
+		{ 0x820e1000, 0x20400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_TRB) */
+		{ 0x820e9000, 0x23400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_WTBLOFF) */
+		{ 0x820ea000, 0x24000, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_ETBF) */
+		{ 0x820ec000, 0x24600, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_INT) */
+		{ 0x820f0000, 0xa0000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_CFG) */
+		{ 0x820f1000, 0xa0600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_TRB) */
+		{ 0x820f2000, 0xa0800, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_AGG) */
+		{ 0x820f3000, 0xa0c00, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_ARB) */
+		{ 0x820f4000, 0xa1000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_TMAC) */
+		{ 0x820f5000, 0xa1400, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_RMAC) */
+		{ 0x820f7000, 0xa1e00, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_DMA) */
+		{ 0x820f9000, 0xa3400, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_WTBLOFF) */
+		{ 0x820fa000, 0xa4000, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_ETBF) */
+		{ 0x820fb000, 0xa4200, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_LPON) */
+		{ 0x820fc000, 0xa4600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_INT) */
+		{ 0x820fd000, 0xa4800, 0x0800 }, /* WF_LMAC_TOP BN1 (WF_MIB) */
+	};
+	int i;
+
+	if (addr < 0x100000)
+		return addr;
+
+	for (i = 0; i < ARRAY_SIZE(fixed_map); i++) {
+		u32 ofs;
+
+		if (addr < fixed_map[i].phys)
+			continue;
+
+		ofs = addr - fixed_map[i].phys;
+		if (ofs > fixed_map[i].size)
+			continue;
+
+		return fixed_map[i].mapped + ofs;
+	}
+
+	if ((addr >= 0x18000000 && addr < 0x18c00000) ||
+	    (addr >= 0x70000000 && addr < 0x78000000) ||
+	    (addr >= 0x7c000000 && addr < 0x7c400000))
+		return mt7921_reg_map_l1(dev, addr);
+
+	dev_err(dev->mt76.dev, "Access currently unsupported address %08x\n",
+		addr);
+
+	return 0;
+}
+
+static u32 mt7921_rr(struct mt76_dev *mdev, u32 offset)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	u32 addr = __mt7921_reg_addr(dev, offset);
+
+	return dev->bus_ops->rr(mdev, addr);
+}
+
+static void mt7921_wr(struct mt76_dev *mdev, u32 offset, u32 val)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	u32 addr = __mt7921_reg_addr(dev, offset);
+
+	dev->bus_ops->wr(mdev, addr, val);
+}
+
+static u32 mt7921_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	u32 addr = __mt7921_reg_addr(dev, offset);
+
+	return dev->bus_ops->rmw(mdev, addr, mask, val);
+}
+
 static int mt7921_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -110,6 +214,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		.sta_remove = mt7921_mac_sta_remove,
 		.update_survey = mt7921_update_channel,
 	};
+	struct mt76_bus_ops *bus_ops;
 	struct mt7921_dev *dev;
 	struct mt76_dev *mdev;
 	int ret;
@@ -145,6 +250,22 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
 	tasklet_init(&dev->irq_tasklet, mt7921_irq_tasklet, (unsigned long)dev);
+
+	dev->bus_ops = dev->mt76.bus;
+	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
+			       GFP_KERNEL);
+	if (!bus_ops)
+		return -ENOMEM;
+
+	bus_ops->rr = mt7921_rr;
+	bus_ops->wr = mt7921_wr;
+	bus_ops->rmw = mt7921_rmw;
+	dev->mt76.bus = bus_ops;
+
+	ret = __mt7921e_mcu_drv_pmctrl(dev);
+	if (ret)
+		return ret;
+
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);
 	dev_err(mdev->dev, "ASIC revision: %04x\n", mdev->rev);
-- 
2.25.1

