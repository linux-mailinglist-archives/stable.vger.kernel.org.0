Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF56B44EA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjCJO3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjCJO3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE73EF9E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A144D618C9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DEBC433D2;
        Fri, 10 Mar 2023 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458457;
        bh=NXTGUYaRBdQKLnsY8q/m1kcVvxbyFCe5K5Yz3+oqAHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dorC0Wl6khn7aFknztcKcYuev4qUpBGP8v3O3cZ/Tx0dn5RO2mK3N6XWTO5SFgK3s
         Oj/zQ0SmjXOxkHDfeV/38e8Yc2fQCnFhNXqp0kZMwWQlR2UsJIEcjN8f3hrQlqQCDr
         zsOIIBULjpQSQNDHct6VGriMnH/l/2gSokljjhME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Markus Elfring <elfring@users.sourceforge.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/357] =?UTF-8?q?net/wireless:=20Delete=20unnecessary=20checks=20before?= =?UTF-8?q?=20the=20macro=20call=20=E2=80=9Cdev=5Fkfree=5Fskb=E2=80=9D?=
Date:   Fri, 10 Mar 2023 14:35:22 +0100
Message-Id: <20230310133735.473041028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 868ad21496020ef83d41fdeed3b0a63de2a3caa5 ]

The dev_kfree_skb() function performs also input parameter validation.
Thus the test around the shown calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Stable-dep-of: 0c1528675d7a ("wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c               | 4 +---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c      | 8 ++------
 drivers/net/wireless/intel/iwlegacy/common.c        | 8 ++------
 drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c | 5 +----
 drivers/net/wireless/st/cw1200/scan.c               | 3 +--
 5 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 796bd93c599b1..4adbe3ab9c870 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -9462,7 +9462,5 @@ void ath10k_wmi_detach(struct ath10k *ar)
 	}
 
 	cancel_work_sync(&ar->svc_rdy_work);
-
-	if (ar->svc_rdy_skb)
-		dev_kfree_skb(ar->svc_rdy_skb);
+	dev_kfree_skb(ar->svc_rdy_skb);
 }
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index e2e9c3e8fff51..206b43b9dff86 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -2302,9 +2302,7 @@ __il3945_down(struct il_priv *il)
 	il3945_hw_txq_ctx_free(il);
 exit:
 	memset(&il->card_alive, 0, sizeof(struct il_alive_resp));
-
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
+	dev_kfree_skb(il->beacon_skb);
 	il->beacon_skb = NULL;
 
 	/* clear out any free frames */
@@ -3847,9 +3845,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 	il_free_channel_map(il);
 	il_free_geos(il);
 	kfree(il->scan_cmd);
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
-
+	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);
 }
 
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 1107b96a8a880..525479f1bef7f 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5182,8 +5182,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
 
 	/* new association get rid of ibss beacon skb */
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
+	dev_kfree_skb(il->beacon_skb);
 	il->beacon_skb = NULL;
 	il->timestamp = 0;
 
@@ -5302,10 +5301,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_irqsave(&il->lock, flags);
-
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
-
+	dev_kfree_skb(il->beacon_skb);
 	il->beacon_skb = skb;
 
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
index 92305bd31aa1a..4209209ac940d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -77,10 +77,7 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 	for (i = 0; i < ARRAY_SIZE(dev->beacons); i++) {
 		if (vif_idx == i) {
 			force_update = !!dev->beacons[i] ^ !!skb;
-
-			if (dev->beacons[i])
-				dev_kfree_skb(dev->beacons[i]);
-
+			dev_kfree_skb(dev->beacons[i]);
 			dev->beacons[i] = skb;
 			__mt76x02_mac_set_beacon(dev, bcn_idx, skb);
 		} else if (force_update && dev->beacons[i]) {
diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index c46b044b7f7be..988581cc134b7 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -120,8 +120,7 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 		++priv->scan.n_ssids;
 	}
 
-	if (frame.skb)
-		dev_kfree_skb(frame.skb);
+	dev_kfree_skb(frame.skb);
 	mutex_unlock(&priv->conf_mutex);
 	queue_work(priv->workqueue, &priv->scan.work);
 	return 0;
-- 
2.39.2



