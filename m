Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C4F37CE4D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbhELREy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237786AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B8FF61C6A;
        Wed, 12 May 2021 16:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835995;
        bh=3/xdwj08t05KJdosI3aohZK+htRhLJFwjq2coPJx6/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6M3o73cqyo8Xvm20m7FDB611nVoykaybH39cH5ZtxukPF7ZO2JXlFwMqn7WVw8qe
         qdwJvzIiweXJspX1VS9lnQR1AEDBeXaPEJZxcfgkkKAM1IckqwX9txRhA433F3Qe58
         G08Z5h9Jqe7XxK6YDP8nbaXKPlAthtx6t85vflOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 532/677] mt76: mt7921: fix the base of PCIe interrupt
Date:   Wed, 12 May 2021 16:49:38 +0200
Message-Id: <20210512144855.053035075@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 23c1d2dc9ed5be1d0df7987335f5646e3826a461 ]

Should use 0x10000 as the base to operate PCIe interrupt according
to the vendor reference driver.

Fixes: ffa1bf97425b ("mt76: mt7921: introduce PM support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Tested-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c  | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index c747022f7642..0262bd8b1626 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -137,7 +137,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 
 	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA, 0);
 
-	mt7921_l1_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
+	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 
 	ret = devm_request_irq(mdev->dev, pdev->irq, mt7921_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, dev);
@@ -248,7 +248,7 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 		return err;
 
 	/* enable interrupt */
-	mt7921_l1_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
+	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 	mt7921_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
 			  MT_INT_MCU_CMD);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index 2dd2e628b776..e7bb918446ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -389,7 +389,7 @@
 #define MT_HW_CHIPID			0x70010200
 #define MT_HW_REV			0x70010204
 
-#define MT_PCIE_MAC_BASE		0x74030000
+#define MT_PCIE_MAC_BASE		0x10000
 #define MT_PCIE_MAC(ofs)		(MT_PCIE_MAC_BASE + (ofs))
 #define MT_PCIE_MAC_INT_ENABLE		MT_PCIE_MAC(0x188)
 
-- 
2.30.2



