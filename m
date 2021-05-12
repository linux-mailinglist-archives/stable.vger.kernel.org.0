Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F15637CDC0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbhELQ6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244173AbhELQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB12161C7D;
        Wed, 12 May 2021 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835876;
        bh=TQ/AY50QtrSFMmbljmlljoZK0wNPuo/Aa8Uuz3GUWWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkGvbwaYIASqWORPtRrBflX7ANRSpkPCh5afILNOWo5le0McSo2JiqyVEZawE5/HG
         gBlXyo/5qTyC9UqgmYiJ0b4uZ42H6knkh2owFqpgPSv8WBLGwnk+EzMKKSiDJK3Wvg
         8zddUAKBx2UsNRwW5dVP7XjvzqQlb6j92DsdnwT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 519/677] mt76: mt7921: fix suspend/resume sequence
Date:   Wed, 12 May 2021 16:49:25 +0200
Message-Id: <20210512144854.626603408@linuxfoundation.org>
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

[ Upstream commit 5e30931494b4940ba74fa5796ca0b6d7e4c84e88 ]

Any pcie access should happen in pci D0 state and we should give ownership
back to the device at the end of the suspend procedure.

Fixes: 1d8efc741df80 ("mt76: mt7921: introduce Runtime PM support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 5570b4a50531..c747022f7642 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -209,12 +209,12 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* disable interrupt */
 	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA, 0);
 
-	pci_save_state(pdev);
-	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	err = mt7921_mcu_fw_pmctrl(dev);
 	if (err)
 		goto restore;
 
-	err = mt7921_mcu_drv_pmctrl(dev);
+	pci_save_state(pdev);
+	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	if (err)
 		goto restore;
 
@@ -237,16 +237,16 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
 	int i, err;
 
-	err = mt7921_mcu_fw_pmctrl(dev);
-	if (err < 0)
-		return err;
-
 	err = pci_set_power_state(pdev, PCI_D0);
 	if (err)
 		return err;
 
 	pci_restore_state(pdev);
 
+	err = mt7921_mcu_drv_pmctrl(dev);
+	if (err < 0)
+		return err;
+
 	/* enable interrupt */
 	mt7921_l1_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 	mt7921_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
-- 
2.30.2



