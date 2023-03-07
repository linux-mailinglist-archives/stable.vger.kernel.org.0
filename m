Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53276AE958
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCGRXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjCGRWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB69E5DEE9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64EFAB819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECC0C433EF;
        Tue,  7 Mar 2023 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209491;
        bh=Ub4gL2SWRUQxDIbDVcCFnTHE8wFSikK5JXtvra/GilI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEVh4klC6waORVvrY15awRtNZYcQMnUOEPGBBNydo+rmgYmGxZELl91E7df8JQaZ8
         gNhn1wKHpz7lXVGMBTtUscslF2ipiTEtA8rUeV/67ZGA+7SKh2vC/VEumF7bwjhPYy
         BPoie9OSoMy/MDgwBoMkHaeXkFqhRrDosnW3vlxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0237/1001] wifi: mt76: mt7921: fix deadlock in mt7921_abort_roc
Date:   Tue,  7 Mar 2023 17:50:09 +0100
Message-Id: <20230307170032.125216943@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit de19b9c83654e323d83f839a550ca4af37fea15b ]

When mt7921_abort_roc is called with dev->mutex held, it can deadlock while
calling cancel_work_sync(&phy->roc_work), because the work function could
be waiting to acquire the mutex.

Fix this by flushing the work before taking the mutex

Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Fixes: 034ae28b56f1 ("wifi: mt76: mt7921: introduce remain_on_channel support")
Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 22 ++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 76ac5069638fe..722df8eea91f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -422,15 +422,15 @@ void mt7921_roc_timer(struct timer_list *timer)
 
 static int mt7921_abort_roc(struct mt7921_phy *phy, struct mt7921_vif *vif)
 {
-	int err;
-
-	if (!test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
-		return 0;
+	int err = 0;
 
 	del_timer_sync(&phy->roc_timer);
 	cancel_work_sync(&phy->roc_work);
-	err = mt7921_mcu_abort_roc(phy, vif, phy->roc_token_id);
-	clear_bit(MT76_STATE_ROC, &phy->mt76->state);
+
+	mt7921_mutex_acquire(phy->dev);
+	if (test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
+		err = mt7921_mcu_abort_roc(phy, vif, phy->roc_token_id);
+	mt7921_mutex_release(phy->dev);
 
 	return err;
 }
@@ -487,13 +487,8 @@ static int mt7921_cancel_remain_on_channel(struct ieee80211_hw *hw,
 {
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 	struct mt7921_phy *phy = mt7921_hw_phy(hw);
-	int err;
 
-	mt7921_mutex_acquire(phy->dev);
-	err = mt7921_abort_roc(phy, mvif);
-	mt7921_mutex_release(phy->dev);
-
-	return err;
+	return mt7921_abort_roc(phy, mvif);
 }
 
 static int mt7921_set_channel(struct mt7921_phy *phy)
@@ -1778,11 +1773,8 @@ static void mt7921_mgd_complete_tx(struct ieee80211_hw *hw,
 				   struct ieee80211_prep_tx_info *info)
 {
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
-	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 
-	mt7921_mutex_acquire(dev);
 	mt7921_abort_roc(mvif->phy, mvif);
-	mt7921_mutex_release(dev);
 }
 
 const struct ieee80211_ops mt7921_ops = {
-- 
2.39.2



