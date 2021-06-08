Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208F63A028D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbhFHTGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236810AbhFHTDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9B8B6144B;
        Tue,  8 Jun 2021 18:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177920;
        bh=Fw9RNyDj5A6BRIdFN41J096U8mq9I9cyHyEfJB6ky4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zylFssSVh/gkptU4yc4Fg0/EULrX4Kab4RcJDRAUS+NJ58xcwpYHcV6bDoRCJy4d0
         aCUdgHKFhYAx2D2RveW9QOgI2Yw5iNox0PSUfiNjQg0dbGpIwieO+1EK8t6v6xYEdK
         tvi5C0RD/5wctjf5gq8jK6E/pIGyxRtGrxjxo0xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Trombin <luca.trombin@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 003/161] mt76: mt76x0e: fix device hang during suspend/resume
Date:   Tue,  8 Jun 2021 20:25:33 +0200
Message-Id: <20210608175945.587547202@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 509559c35bcd23d5a046624b225cb3e99a9f1481 ]

Similar to usb device, re-initialize mt76x0e device after resume in order
to fix mt7630e hang during suspend/resume

Reported-by: Luca Trombin <luca.trombin@gmail.com>
Fixes: c2a4d9fbabfb9 ("mt76x0: inital split between pci and usb")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/4812f9611624b34053c1592fd9c175b67d4ffcb4.1620406022.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 81 ++++++++++++++++++-
 1 file changed, 77 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 02d0aa0b815e..d2489dc9dc13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -87,7 +87,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.reconfig_complete = mt76x02_reconfig_complete,
 };
 
-static int mt76x0e_register_device(struct mt76x02_dev *dev)
+static int mt76x0e_init_hardware(struct mt76x02_dev *dev, bool resume)
 {
 	int err;
 
@@ -100,9 +100,11 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
-	err = mt76x02_dma_init(dev);
-	if (err < 0)
-		return err;
+	if (!resume) {
+		err = mt76x02_dma_init(dev);
+		if (err < 0)
+			return err;
+	}
 
 	err = mt76x0_init_hardware(dev);
 	if (err < 0)
@@ -123,6 +125,17 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 	mt76_clear(dev, 0x110, BIT(9));
 	mt76_set(dev, MT_MAX_LEN_CFG, BIT(13));
 
+	return 0;
+}
+
+static int mt76x0e_register_device(struct mt76x02_dev *dev)
+{
+	int err;
+
+	err = mt76x0e_init_hardware(dev, false);
+	if (err < 0)
+		return err;
+
 	err = mt76x0_register_device(dev);
 	if (err < 0)
 		return err;
@@ -167,6 +180,8 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
+	mt76_pci_disable_aspm(pdev);
+
 	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt76x0e_ops,
 				 &drv_ops);
 	if (!mdev)
@@ -220,6 +235,60 @@ mt76x0e_remove(struct pci_dev *pdev)
 	mt76_free_device(mdev);
 }
 
+#ifdef CONFIG_PM
+static int mt76x0e_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	int i;
+
+	mt76_worker_disable(&mdev->tx_worker);
+	for (i = 0; i < ARRAY_SIZE(mdev->phy.q_tx); i++)
+		mt76_queue_tx_cleanup(dev, mdev->phy.q_tx[i], true);
+	for (i = 0; i < ARRAY_SIZE(mdev->q_mcu); i++)
+		mt76_queue_tx_cleanup(dev, mdev->q_mcu[i], true);
+	napi_disable(&mdev->tx_napi);
+
+	mt76_for_each_q_rx(mdev, i)
+		napi_disable(&mdev->napi[i]);
+
+	mt76x02_dma_disable(dev);
+	mt76x02_mcu_cleanup(dev);
+	mt76x0_chip_onoff(dev, false, false);
+
+	pci_enable_wake(pdev, pci_choose_state(pdev, state), true);
+	pci_save_state(pdev);
+
+	return pci_set_power_state(pdev, pci_choose_state(pdev, state));
+}
+
+static int mt76x0e_resume(struct pci_dev *pdev)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	int err, i;
+
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err)
+		return err;
+
+	pci_restore_state(pdev);
+
+	mt76_worker_enable(&mdev->tx_worker);
+
+	mt76_for_each_q_rx(mdev, i) {
+		mt76_queue_rx_reset(dev, i);
+		napi_enable(&mdev->napi[i]);
+		napi_schedule(&mdev->napi[i]);
+	}
+
+	napi_enable(&mdev->tx_napi);
+	napi_schedule(&mdev->tx_napi);
+
+	return mt76x0e_init_hardware(dev, true);
+}
+#endif /* CONFIG_PM */
+
 static const struct pci_device_id mt76x0e_device_table[] = {
 	{ PCI_DEVICE(0x14c3, 0x7610) },
 	{ PCI_DEVICE(0x14c3, 0x7630) },
@@ -237,6 +306,10 @@ static struct pci_driver mt76x0e_driver = {
 	.id_table	= mt76x0e_device_table,
 	.probe		= mt76x0e_probe,
 	.remove		= mt76x0e_remove,
+#ifdef CONFIG_PM
+	.suspend	= mt76x0e_suspend,
+	.resume		= mt76x0e_resume,
+#endif /* CONFIG_PM */
 };
 
 module_pci_driver(mt76x0e_driver);
-- 
2.30.2



