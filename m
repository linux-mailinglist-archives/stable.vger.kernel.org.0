Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D015B603E73
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiJSJPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiJSJNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06B6BCBA2;
        Wed, 19 Oct 2022 02:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE05361879;
        Wed, 19 Oct 2022 08:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1741C433D6;
        Wed, 19 Oct 2022 08:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169522;
        bh=h2b9klU9HPAy6q0Q6MKdBI8G1gu0t6l4l0Iv3oCvsdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgaYDsgTIJL70M5YOyOzIIlVx991R3OGuH6XdlEgFrG77Q7T34/FSAT0b+f0avdAw
         CQ0i/t+2YGYPjuq8hedTpG2pcTA2OMDAP5eI4ckqMN6DNSC6vm/y+1FlptERVDYJD2
         xQhLi2FS46MQeUTzuplL5b7HBVWm2s5KdILqcrLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 275/862] wifi: mt76: mt7921e: fix race issue between reset and suspend/resume
Date:   Wed, 19 Oct 2022 10:26:02 +0200
Message-Id: <20221019083302.177387254@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 47f0aa81ab02..6bd9fc9228a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -780,6 +780,7 @@ void mt7921_mac_reset_work(struct work_struct *work)
 void mt7921_reset(struct mt76_dev *mdev)
 {
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+	struct mt76_connac_pm *pm = &dev->pm;
 
 	if (!dev->hw_init_done)
 		return;
@@ -787,8 +788,12 @@ void mt7921_reset(struct mt76_dev *mdev)
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
index ea3069d18c35..2b015dacbba2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -367,6 +367,7 @@ static int mt7921_pci_suspend(struct device *device)
 	int i, err;
 
 	pm->suspended = true;
+	flush_work(&dev->reset_work);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 
@@ -428,6 +429,9 @@ static int mt7921_pci_suspend(struct device *device)
 restore_suspend:
 	pm->suspended = false;
 
+	if (err < 0)
+		mt7921_reset(&dev->mt76);
+
 	return err;
 }
 
@@ -441,7 +445,7 @@ static int mt7921_pci_resume(struct device *device)
 
 	err = mt7921_mcu_drv_pmctrl(dev);
 	if (err < 0)
-		return err;
+		goto failed;
 
 	mt7921_wpdma_reinit_cond(dev);
 
@@ -471,11 +475,12 @@ static int mt7921_pci_resume(struct device *device)
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
 
-- 
2.35.1



