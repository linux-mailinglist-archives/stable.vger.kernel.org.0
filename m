Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D18531617
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240359AbiEWR3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242814AbiEWR2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524DC8CB20;
        Mon, 23 May 2022 10:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD594B811FB;
        Mon, 23 May 2022 17:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4B2C385A9;
        Mon, 23 May 2022 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326618;
        bh=bHHgkR7AsFXXXlmoxaxltJ3sm9C7QAmz3mFGsMxYIyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyjt++6R9a0hi73V5qVM/6iw/2JTknTEksjuoHfGChtQvuA3EH3zHfthXsfIXJUZJ
         /QP8pW3SAYA5iZwYS9XYflI0TMWq88F24NMaLlm1Qvm7A7DLlf4urnqcB4oHorR10i
         w6e+17RRdqctaGq1OfhX7cM7TLVhaLaDE1jqDDCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>
Subject: [PATCH 5.15 130/132] mt76: mt7921e: fix possible probe failure after reboot
Date:   Mon, 23 May 2022 19:05:39 +0200
Message-Id: <20220523165845.272447194@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c |  115 ----------------------
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c |   20 +--
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c |  121 ++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 125 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -118,109 +118,6 @@ static void mt7921_dma_prefetch(struct m
 	mt76_wr(dev, MT_WFDMA0_TX_RING17_EXT_CTRL, PREFETCH(0x380, 0x4));
 }
 
-static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
-{
-	static const struct {
-		u32 phys;
-		u32 mapped;
-		u32 size;
-	} fixed_map[] = {
-		{ 0x00400000, 0x80000, 0x10000}, /* WF_MCU_SYSRAM */
-		{ 0x00410000, 0x90000, 0x10000}, /* WF_MCU_SYSRAM (configure register) */
-		{ 0x40000000, 0x70000, 0x10000}, /* WF_UMAC_SYSRAM */
-		{ 0x54000000, 0x02000, 0x1000 }, /* WFDMA PCIE0 MCU DMA0 */
-		{ 0x55000000, 0x03000, 0x1000 }, /* WFDMA PCIE0 MCU DMA1 */
-		{ 0x58000000, 0x06000, 0x1000 }, /* WFDMA PCIE1 MCU DMA0 (MEM_DMA) */
-		{ 0x59000000, 0x07000, 0x1000 }, /* WFDMA PCIE1 MCU DMA1 */
-		{ 0x7c000000, 0xf0000, 0x10000 }, /* CONN_INFRA */
-		{ 0x7c020000, 0xd0000, 0x10000 }, /* CONN_INFRA, WFDMA */
-		{ 0x7c060000, 0xe0000, 0x10000}, /* CONN_INFRA, conn_host_csr_top */
-		{ 0x80020000, 0xb0000, 0x10000 }, /* WF_TOP_MISC_OFF */
-		{ 0x81020000, 0xc0000, 0x10000 }, /* WF_TOP_MISC_ON */
-		{ 0x820c0000, 0x08000, 0x4000 }, /* WF_UMAC_TOP (PLE) */
-		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
-		{ 0x820cc000, 0x0e000, 0x2000 }, /* WF_UMAC_TOP (PP) */
-		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
-		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
-		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
-		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
-		{ 0x820e1000, 0x20400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_TRB) */
-		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
-		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
-		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
-		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
-		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
-		{ 0x820e9000, 0x23400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_WTBLOFF) */
-		{ 0x820ea000, 0x24000, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_ETBF) */
-		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
-		{ 0x820ec000, 0x24600, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_INT) */
-		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
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
@@ -380,20 +277,8 @@ int mt7921_wpdma_reinit_cond(struct mt79
 
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
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1306,8 +1306,6 @@ int mt7921_mcu_sta_update(struct mt7921_
 
 int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 {
-	struct mt76_phy *mphy = &dev->mt76.phy;
-	struct mt76_connac_pm *pm = &dev->pm;
 	int i, err = 0;
 
 	for (i = 0; i < MT7921_DRV_OWN_RETRY_COUNT; i++) {
@@ -1320,16 +1318,8 @@ int __mt7921_mcu_drv_pmctrl(struct mt792
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
 		dev_err(dev->mt76.dev, "driver own failed\n");
 		err = -EIO;
-		goto out;
 	}
 
-	mt7921_wpdma_reinit_cond(dev);
-	clear_bit(MT76_STATE_PM, &mphy->state);
-
-	pm->stats.last_wake_event = jiffies;
-	pm->stats.doze_time += pm->stats.last_wake_event -
-			       pm->stats.last_doze_event;
-out:
 	return err;
 }
 
@@ -1345,6 +1335,16 @@ int mt7921_mcu_drv_pmctrl(struct mt7921_
 		goto out;
 
 	err = __mt7921_mcu_drv_pmctrl(dev);
+        if (err < 0)
+            goto out;
+
+	mt7921_wpdma_reinit_cond(dev);
+	clear_bit(MT76_STATE_PM, &mphy->state);
+
+	pm->stats.last_wake_event = jiffies;
+	pm->stats.doze_time += pm->stats.last_wake_event -
+			       pm->stats.last_doze_event;
+
 out:
 	mutex_unlock(&pm->mutex);
 
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -88,6 +88,110 @@ static void mt7921_irq_tasklet(unsigned
 		napi_schedule(&dev->mt76.napi[MT_RXQ_MAIN]);
 }
 
+static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
+{
+	static const struct {
+		u32 phys;
+		u32 mapped;
+		u32 size;
+	} fixed_map[] = {
+		{ 0x00400000, 0x80000, 0x10000}, /* WF_MCU_SYSRAM */
+		{ 0x00410000, 0x90000, 0x10000}, /* WF_MCU_SYSRAM (configure register) */
+		{ 0x40000000, 0x70000, 0x10000}, /* WF_UMAC_SYSRAM */
+		{ 0x54000000, 0x02000, 0x1000 }, /* WFDMA PCIE0 MCU DMA0 */
+		{ 0x55000000, 0x03000, 0x1000 }, /* WFDMA PCIE0 MCU DMA1 */
+		{ 0x58000000, 0x06000, 0x1000 }, /* WFDMA PCIE1 MCU DMA0 (MEM_DMA) */
+		{ 0x59000000, 0x07000, 0x1000 }, /* WFDMA PCIE1 MCU DMA1 */
+		{ 0x7c000000, 0xf0000, 0x10000 }, /* CONN_INFRA */
+		{ 0x7c020000, 0xd0000, 0x10000 }, /* CONN_INFRA, WFDMA */
+		{ 0x7c060000, 0xe0000, 0x10000}, /* CONN_INFRA, conn_host_csr_top */
+		{ 0x80020000, 0xb0000, 0x10000 }, /* WF_TOP_MISC_OFF */
+		{ 0x81020000, 0xc0000, 0x10000 }, /* WF_TOP_MISC_ON */
+		{ 0x820c0000, 0x08000, 0x4000 }, /* WF_UMAC_TOP (PLE) */
+		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
+		{ 0x820cc000, 0x0e000, 0x2000 }, /* WF_UMAC_TOP (PP) */
+		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
+		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
+		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
+		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
+		{ 0x820e1000, 0x20400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_TRB) */
+		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
+		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
+		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
+		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
+		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
+		{ 0x820e9000, 0x23400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_WTBLOFF) */
+		{ 0x820ea000, 0x24000, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_ETBF) */
+		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
+		{ 0x820ec000, 0x24600, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_INT) */
+		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
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
+
 static int mt7921_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -110,6 +214,7 @@ static int mt7921_pci_probe(struct pci_d
 		.sta_remove = mt7921_mac_sta_remove,
 		.update_survey = mt7921_update_channel,
 	};
+	struct mt76_bus_ops *bus_ops;
 	struct mt7921_dev *dev;
 	struct mt76_dev *mdev;
 	int ret;
@@ -145,6 +250,22 @@ static int mt7921_pci_probe(struct pci_d
 
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
+	ret = __mt7921_mcu_drv_pmctrl(dev);
+	if (ret)
+		return ret;
+
 	mdev->rev = (mt7921_l1_rr(dev, MT_HW_CHIPID) << 16) |
 		    (mt7921_l1_rr(dev, MT_HW_REV) & 0xff);
 	dev_err(mdev->dev, "ASIC revision: %04x\n", mdev->rev);


