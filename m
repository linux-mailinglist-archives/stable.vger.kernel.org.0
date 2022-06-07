Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9211E541411
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357796AbiFGUMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359208AbiFGUJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871E01C4F0F;
        Tue,  7 Jun 2022 11:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2291361252;
        Tue,  7 Jun 2022 18:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E32C385A2;
        Tue,  7 Jun 2022 18:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626426;
        bh=r4Cxs6mC/j3Ia4H5h56qzcI8TWV9ryZCS5RxCwnAKOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gON4QeA1WcKS7igaQ4w3hV1G4O2ABIk/Q/xXA1KSWV5TRmaie3a1/qwo8Jj4R0X+S
         puu/2a0QVYKCrpDd0RWJAZaTnCrXGJ+fnW40/qkvohv/bx/w0zzJvvQ2DfQoUbkfs0
         m1+l4m2r2NguI632K2LEyUp2Iqf7darbgYssxzRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 373/772] mt76: fix tx status related use-after-free race on station removal
Date:   Tue,  7 Jun 2022 18:59:25 +0200
Message-Id: <20220607165000.006614205@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit fcfe1b5e162bf473c1d47760962cec8523c00466 ]

There is a small race window where ongoing tx activity can lead to a skb
getting added to the status tracking idr after that idr has already been
cleaned up, which will keep the wcid linked in the status poll list.
Fix this by only adding status skbs if the wcid pointer is still assigned
in dev->wcid, which gets cleared early by mt76_sta_pre_rcu_remove

Fixes: bd1e3e7b693c ("mt76: introduce packet_id idr")
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 ++
 drivers/net/wireless/mediatek/mt76/tx.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 6023ff6dc059..cbda0f57ff9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1344,7 +1344,9 @@ void mt76_sta_pre_rcu_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 
 	mutex_lock(&dev->mutex);
+	spin_lock_bh(&dev->status_lock);
 	rcu_assign_pointer(dev->wcid[wcid->idx], NULL);
+	spin_unlock_bh(&dev->status_lock);
 	mutex_unlock(&dev->mutex);
 }
 EXPORT_SYMBOL_GPL(mt76_sta_pre_rcu_remove);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 6b8c9dc80542..ccaf9a31fbc4 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -120,7 +120,7 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	memset(cb, 0, sizeof(*cb));
 
-	if (!wcid)
+	if (!wcid || !rcu_access_pointer(dev->wcid[wcid->idx]))
 		return MT_PACKET_ID_NO_ACK;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
-- 
2.35.1



