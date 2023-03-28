Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352266CC26A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjC1OpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjC1OpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF24BDDF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1457EB81D6F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73702C433D2;
        Tue, 28 Mar 2023 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014688;
        bh=DlFBxN07Mly2tY7satYdvNbvdLJqgvzYt73UN4R24Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIo4UJsEpHG32YkhCB6tk0AU+Raj5vFMsoVCfkRKWPPprjBtsE+haexhksr7Ske9S
         vAf7WV82RG9+1cJKu1je108Bs5lkmko7p1mJ+PihLPicidSL5USLJ/6wBZB8ZVIvUP
         +QEYZmRnSbtTwgvSxQlWCuqqqwm1SQwquL45XVck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
        Helmut Grohne <helmut@freexian.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 017/240] wifi: mt76: do not run mt76_unregister_device() on unregistered hw
Date:   Tue, 28 Mar 2023 16:39:40 +0200
Message-Id: <20230328142620.362151866@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 41130c32f3a18fcc930316da17f3a5f3bc326aa1 ]

Trying to probe a mt7921e pci card without firmware results in a
successful probe where ieee80211_register_hw hasn't been called. When
removing the driver, ieee802111_unregister_hw is called unconditionally
leading to a kernel NULL pointer dereference.
Fix the issue running mt76_unregister_device routine just for registered
hw.

Link: https://bugs.debian.org/1029116
Link: https://bugs.kali.org/view.php?id=8140
Reported-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Fixes: 1c71e03afe4b ("mt76: mt7921: move mt7921_init_hw in a dedicated work")
Tested-by: Helmut Grohne <helmut@freexian.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/be3457d82f4e44bb71a22b2b5db27b644a37b1e1.1677107277.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 8 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index fc608b369b3cc..d75e999a80e1f 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -526,6 +526,7 @@ int mt76_register_phy(struct mt76_phy *phy, bool vht,
 	if (ret)
 		return ret;
 
+	set_bit(MT76_STATE_REGISTERED, &phy->state);
 	phy->dev->phys[phy->band_idx] = phy;
 
 	return 0;
@@ -536,6 +537,9 @@ void mt76_unregister_phy(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev = phy->dev;
 
+	if (!test_bit(MT76_STATE_REGISTERED, &phy->state))
+		return;
+
 	mt76_tx_status_check(dev, true);
 	ieee80211_unregister_hw(phy->hw);
 	dev->phys[phy->band_idx] = NULL;
@@ -663,6 +667,7 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 		return ret;
 
 	WARN_ON(mt76_worker_setup(hw, &dev->tx_worker, NULL, "tx"));
+	set_bit(MT76_STATE_REGISTERED, &phy->state);
 	sched_set_fifo_low(dev->tx_worker.task);
 
 	return 0;
@@ -673,6 +678,9 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
+	if (!test_bit(MT76_STATE_REGISTERED, &dev->phy.state))
+		return;
+
 	if (IS_ENABLED(CONFIG_MT76_LEDS))
 		mt76_led_cleanup(dev);
 	mt76_tx_status_check(dev, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 32a77a0ae9da9..d8216243b0224 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -399,6 +399,7 @@ struct mt76_tx_cb {
 
 enum {
 	MT76_STATE_INITIALIZED,
+	MT76_STATE_REGISTERED,
 	MT76_STATE_RUNNING,
 	MT76_STATE_MCU_RUNNING,
 	MT76_SCANNING,
-- 
2.39.2



