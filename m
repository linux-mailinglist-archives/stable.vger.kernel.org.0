Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244E610B8CB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfK0Uq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbfK0Uqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 517AA21844;
        Wed, 27 Nov 2019 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887614;
        bh=vS6NaVgZQJk4ZRO2M57wzdi0pOreZwpgBQncFbvkgIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkI0lpcCvrQcYUFLJCmzVgELHAVgSS3hxp7BAFBQB76puJXsM7+wBUfSu7uBRJvnI
         7L3bnznYjcXMZNDyN8GzxxoPmsbmQ10E2bORWPaNdy+AWoGbE2h0Q3D2HBs0MTsJWp
         8BcTp/i5H3PeVqLkoFFvkOxWnjUufYnLKhiWNgBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 027/211] brcmsmac: AP mode: update beacon when TIM changes
Date:   Wed, 27 Nov 2019 21:29:20 +0100
Message-Id: <20191127203053.813697712@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>

[ Upstream commit 2258ee58baa554609a3cc3996276e4276f537b6d ]

Beacons are not updated to reflect TIM changes. This is not compliant with
power-saving client stations as the beacons do not have valid TIM and can
cause the network to stall at random occasions and to have highly variable
latencies.
Fix it by updating beacon templates on mac80211 set_tim callback.

Addresses an issue described in:
https://marc.info/?i=20180911163534.21312d08%20()%20manjaro

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c | 26 +++++++++++++++++++
 .../broadcom/brcm80211/brcmsmac/main.h        |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ddfdfe177e245..257968fb3111f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -502,6 +502,7 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = vif;
 	wl->mute_tx = false;
 	brcms_c_mute(wl->wlc, false);
 	if (vif->type == NL80211_IFTYPE_STATION)
@@ -519,6 +520,11 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 static void
 brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
+	struct brcms_info *wl = hw->priv;
+
+	spin_lock_bh(&wl->lock);
+	wl->wlc->vif = NULL;
+	spin_unlock_bh(&wl->lock);
 }
 
 static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
@@ -937,6 +943,25 @@ static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
 	spin_unlock_bh(&wl->lock);
 }
 
+static int brcms_ops_beacon_set_tim(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta, bool set)
+{
+	struct brcms_info *wl = hw->priv;
+	struct sk_buff *beacon = NULL;
+	u16 tim_offset = 0;
+
+	spin_lock_bh(&wl->lock);
+	if (wl->wlc->vif)
+		beacon = ieee80211_beacon_get_tim(hw, wl->wlc->vif,
+						  &tim_offset, NULL);
+	if (beacon)
+		brcms_c_set_new_beacon(wl->wlc, beacon, tim_offset,
+				       wl->wlc->vif->bss_conf.dtim_period);
+	spin_unlock_bh(&wl->lock);
+
+	return 0;
+}
+
 static const struct ieee80211_ops brcms_ops = {
 	.tx = brcms_ops_tx,
 	.start = brcms_ops_start,
@@ -955,6 +980,7 @@ static const struct ieee80211_ops brcms_ops = {
 	.flush = brcms_ops_flush,
 	.get_tsf = brcms_ops_get_tsf,
 	.set_tsf = brcms_ops_set_tsf,
+	.set_tim = brcms_ops_beacon_set_tim,
 };
 
 void brcms_dpc(unsigned long data)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index c4d135cff04ad..9f76b880814e8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -563,6 +563,7 @@ struct brcms_c_info {
 
 	struct wiphy *wiphy;
 	struct scb pri_scb;
+	struct ieee80211_vif *vif;
 
 	struct sk_buff *beacon;
 	u16 beacon_tim_offset;
-- 
2.20.1



