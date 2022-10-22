Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC79A6086D7
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiJVHxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiJVHwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ACF2C6EB7;
        Sat, 22 Oct 2022 00:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C11E60BB5;
        Sat, 22 Oct 2022 07:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AED6C433D6;
        Sat, 22 Oct 2022 07:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424681;
        bh=Ezjo1GhHEo9V8xJkef95aeBkTOtIzA4CqJ/f1m1eZJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNLMWu419+CvpvQqVMNNw7kWJaVbNC9ePPdDJHD4Itgdp0crUUTMvo8W3VeSbvgmE
         F7+CcnMx9xNjQdQtbllsC5YNp9y2fYSxGICrM8nC+G9od7gn8ovZS5rrhWxYKxCjZz
         hejcNuvdfS4sAAb6ioCY0qiQybiWZrDkUbvjFMPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 237/717] wifi: mt76: mt7921e: fix race issue between reset and suspend/resume
Date:   Sat, 22 Oct 2022 09:21:56 +0200
Message-Id: <20221022072456.938168436@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit ff6c4a6449793e9718ef2e9ad46864b63022648e ]

It is unexpected that the reset work is running simultaneously with
the suspend or resume context and it is possible that reset work is still
running even after mt7921 is suspended if we don't fix the race issue.

Thus, the suspend procedure should be waiting until the reset is completed
at the beginning and ignore the subsequent the reset requests.

In case there is an error that happens during either suspend or resume
handler, we will schedule a reset task to recover the error before
returning the error code to ensure we can immediately fix the error there.

Fixes: 0c1ce9884607 ("mt76: mt7921: add wifi reset support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c |  5 +++++
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 13 +++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 2a2ea7b9977a..7e0cddc2aeab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1215,6 +1215,7 @@ void mt7921_mac_reset_work(struct work_struct *work)
 void mt7921_reset(struct mt76_dev *mdev)
 {
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	struct mt76_connac_pm *pm = &dev->pm;
 
 	if (!dev->hw_init_done)
 		return;
@@ -1222,8 +1223,12 @@ void mt7921_reset(struct mt76_dev *mdev)
 	if (dev->hw_full_reset)
 		return;
 
+	if (pm->suspended)
+		return;
+
 	queue_work(dev->mt76.wq, &dev->reset_work);
 }
+EXPORT_SYMBOL_GPL(mt7921_reset);
 
 void mt7921_mac_update_mib_stats(struct mt7921_phy *phy)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index b5fb22b8e086..295c21586273 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -368,6 +368,7 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	int i, err;
 
 	pm->suspended = true;
+	flush_work(&dev->reset_work);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 
@@ -433,6 +434,9 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 restore_suspend:
 	pm->suspended = false;
 
+	if (err < 0)
+		mt7921_reset(&dev->mt76);
+
 	return err;
 }
 
@@ -451,7 +455,7 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 
 	err = mt7921_mcu_drv_pmctrl(dev);
 	if (err < 0)
-		return err;
+		goto failed;
 
 	mt7921_wpdma_reinit_cond(dev);
 
@@ -481,11 +485,12 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
 
 	err = mt76_connac_mcu_set_hif_suspend(mdev, false);
-	if (err)
-		return err;
-
+failed:
 	pm->suspended = false;
 
+	if (err < 0)
+		mt7921_reset(&dev->mt76);
+
 	return err;
 }
 #endif /* CONFIG_PM */
-- 
2.35.1



