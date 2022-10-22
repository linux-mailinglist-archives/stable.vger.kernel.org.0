Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFF660870D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiJVHz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiJVHy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6534951D8;
        Sat, 22 Oct 2022 00:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FEB6B82E17;
        Sat, 22 Oct 2022 07:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95FFC433D6;
        Sat, 22 Oct 2022 07:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424785;
        bh=kUpBrIVqSlkp2SOCGgG54sjDPu8ZawxljH/7Mfewagg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/EJbPL9p4PN61+z3JkI4qwD6Vs888Kh6WjbO1Al7YnTCBg1imq2NegOV0jz7FQKH
         EIiwoVgSTVuTPlcORinvekoetKhCiCu3Tze8Sm5G2Anxled4v50lBuHfau/5aQJweg
         YZeRNjYWp4UMeIUUwqc7jHC7UJyQOElwsqohRDHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 276/717] wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM
Date:   Sat, 22 Oct 2022 09:22:35 +0200
Message-Id: <20221022072503.020943027@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 5574d3290449916397f3092dcd2bac92415498e1 ]

ieee80211_tx_queue_params.aifs is not supposed to be written directly
to the REG_EDCA_*_PARAM registers. Instead process it like the vendor
drivers do. It's kinda hacky but it works.

This change boosts the download speed and makes it more stable.

Tested with RTL8188FU but all the other supported chips should also
benefit.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Jes Sorensen <jes@trained-monkey.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/038cc03f-3567-77ba-a7bd-c4930e3b2fad@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5f9d6cce1114..57b5370a256b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4560,6 +4560,53 @@ rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
 	return network_type;
 }
 
+static void rtl8xxxu_set_aifs(struct rtl8xxxu_priv *priv, u8 slot_time)
+{
+	u32 reg_edca_param[IEEE80211_NUM_ACS] = {
+		[IEEE80211_AC_VO] = REG_EDCA_VO_PARAM,
+		[IEEE80211_AC_VI] = REG_EDCA_VI_PARAM,
+		[IEEE80211_AC_BE] = REG_EDCA_BE_PARAM,
+		[IEEE80211_AC_BK] = REG_EDCA_BK_PARAM,
+	};
+	u32 val32;
+	u16 wireless_mode = 0;
+	u8 aifs, aifsn, sifs;
+	int i;
+
+	if (priv->vif) {
+		struct ieee80211_sta *sta;
+
+		rcu_read_lock();
+		sta = ieee80211_find_sta(priv->vif, priv->vif->bss_conf.bssid);
+		if (sta)
+			wireless_mode = rtl8xxxu_wireless_mode(priv->hw, sta);
+		rcu_read_unlock();
+	}
+
+	if (priv->hw->conf.chandef.chan->band == NL80211_BAND_5GHZ ||
+	    (wireless_mode & WIRELESS_MODE_N_24G))
+		sifs = 16;
+	else
+		sifs = 10;
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		val32 = rtl8xxxu_read32(priv, reg_edca_param[i]);
+
+		/* It was set in conf_tx. */
+		aifsn = val32 & 0xff;
+
+		/* aifsn not set yet or already fixed */
+		if (aifsn < 2 || aifsn > 15)
+			continue;
+
+		aifs = aifsn * slot_time + sifs;
+
+		val32 &= ~0xff;
+		val32 |= aifs;
+		rtl8xxxu_write32(priv, reg_edca_param[i], val32);
+	}
+}
+
 static void
 rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf, u32 changed)
@@ -4679,6 +4726,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		else
 			val8 = 20;
 		rtl8xxxu_write8(priv, REG_SLOT, val8);
+
+		rtl8xxxu_set_aifs(priv, val8);
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
-- 
2.35.1



