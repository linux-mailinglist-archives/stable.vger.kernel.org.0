Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8CB4FD44F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356586AbiDLIKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357087AbiDLHjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDE565DA;
        Tue, 12 Apr 2022 00:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EAB1B81895;
        Tue, 12 Apr 2022 07:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA477C385A5;
        Tue, 12 Apr 2022 07:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747488;
        bh=c0eHMg/vupodfFtJJT7UW8Yeq3VVqZoxDRGVYvTreuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0d5g2fKQUIO70v4tpxl7NwKlQHtAHavlolyO9b3aMkhD7s1+YIp1Ihdt/LNHeaRkY
         E2wRzjZZ6if2sCvJFtc2a7o9u+xHSJw3cCKum0ycw4QfKFKEi9XIyW8BffusmJaxEm
         vXIJ97cSitkWU74ikRiXxBbyqDbL4NGHYMw6FPBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 096/343] rtw88: change rtw_info() to proper message level
Date:   Tue, 12 Apr 2022 08:28:34 +0200
Message-Id: <20220412062953.872878897@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit a0061be4e54b52e5e4ff179c3f817107ddbb2830 ]

Larry reported funny log entries [1] when he used rtl8821ce. These
messages are not harmless, but not useful for users, so change them to
rtw_dbg() level. By the way, I review all rtw_info() and change others
to rtw_warn().

[1] https://lore.kernel.org/linux-wireless/c356d5ae-a7b3-3065-1121-64c446e70333@lwfinger.net/

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220218035527.9835-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/debug.c    | 2 +-
 drivers/net/wireless/realtek/rtw88/debug.h    | 1 +
 drivers/net/wireless/realtek/rtw88/fw.c       | 2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c | 8 ++++----
 drivers/net/wireless/realtek/rtw88/main.c     | 8 ++++----
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/sar.c      | 8 ++++----
 9 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index e429428232c1..e7e9f17df96a 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -390,7 +390,7 @@ static ssize_t rtw_debugfs_set_h2c(struct file *filp,
 		     &param[0], &param[1], &param[2], &param[3],
 		     &param[4], &param[5], &param[6], &param[7]);
 	if (num != 8) {
-		rtw_info(rtwdev, "invalid H2C command format for debug\n");
+		rtw_warn(rtwdev, "invalid H2C command format for debug\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtw88/debug.h b/drivers/net/wireless/realtek/rtw88/debug.h
index 61f8369fe2d6..066792dd96af 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.h
+++ b/drivers/net/wireless/realtek/rtw88/debug.h
@@ -23,6 +23,7 @@ enum rtw_debug_mask {
 	RTW_DBG_PATH_DIV	= 0x00004000,
 	RTW_DBG_ADAPTIVITY	= 0x00008000,
 	RTW_DBG_HW_SCAN		= 0x00010000,
+	RTW_DBG_STATE		= 0x00020000,
 
 	RTW_DBG_ALL		= 0xffffffff
 };
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 4c8e5ea5d069..db90d75a8633 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -2131,7 +2131,7 @@ void rtw_hw_scan_status_report(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	rtw_hw_scan_complete(rtwdev, vif, aborted);
 
 	if (aborted)
-		rtw_info(rtwdev, "HW scan aborted with code: %d\n", rc);
+		rtw_dbg(rtwdev, RTW_DBG_HW_SCAN, "HW scan aborted with code: %d\n", rc);
 }
 
 void rtw_store_op_chan(struct rtw_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 647d2662955b..5cdc54c9a9aa 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -208,7 +208,7 @@ static int rtw_ops_add_interface(struct ieee80211_hw *hw,
 
 	mutex_unlock(&rtwdev->mutex);
 
-	rtw_info(rtwdev, "start vif %pM on port %d\n", vif->addr, rtwvif->port);
+	rtw_dbg(rtwdev, RTW_DBG_STATE, "start vif %pM on port %d\n", vif->addr, rtwvif->port);
 	return 0;
 }
 
@@ -219,7 +219,7 @@ static void rtw_ops_remove_interface(struct ieee80211_hw *hw,
 	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
 	u32 config = 0;
 
-	rtw_info(rtwdev, "stop vif %pM on port %d\n", vif->addr, rtwvif->port);
+	rtw_dbg(rtwdev, RTW_DBG_STATE, "stop vif %pM on port %d\n", vif->addr, rtwvif->port);
 
 	mutex_lock(&rtwdev->mutex);
 
@@ -245,8 +245,8 @@ static int rtw_ops_change_interface(struct ieee80211_hw *hw,
 {
 	struct rtw_dev *rtwdev = hw->priv;
 
-	rtw_info(rtwdev, "change vif %pM (%d)->(%d), p2p (%d)->(%d)\n",
-		 vif->addr, vif->type, type, vif->p2p, p2p);
+	rtw_dbg(rtwdev, RTW_DBG_STATE, "change vif %pM (%d)->(%d), p2p (%d)->(%d)\n",
+		vif->addr, vif->type, type, vif->p2p, p2p);
 
 	rtw_ops_remove_interface(hw, vif);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 39c223a2e3e2..b00200f81db7 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -314,8 +314,8 @@ int rtw_sta_add(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 
 	rtwdev->sta_cnt++;
 	rtwdev->beacon_loss = false;
-	rtw_info(rtwdev, "sta %pM joined with macid %d\n",
-		 sta->addr, si->mac_id);
+	rtw_dbg(rtwdev, RTW_DBG_STATE, "sta %pM joined with macid %d\n",
+		sta->addr, si->mac_id);
 
 	return 0;
 }
@@ -336,8 +336,8 @@ void rtw_sta_remove(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
 	kfree(si->mask);
 
 	rtwdev->sta_cnt--;
-	rtw_info(rtwdev, "sta %pM with macid %d left\n",
-		 sta->addr, si->mac_id);
+	rtw_dbg(rtwdev, RTW_DBG_STATE, "sta %pM with macid %d left\n",
+		sta->addr, si->mac_id);
 }
 
 struct rtw_fwcd_hdr {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index db078df63f85..80d4761796b1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -499,7 +499,7 @@ static s8 get_cck_rx_pwr(struct rtw_dev *rtwdev, u8 lna_idx, u8 vga_idx)
 	}
 
 	if (lna_idx >= lna_gain_table_size) {
-		rtw_info(rtwdev, "incorrect lna index (%d)\n", lna_idx);
+		rtw_warn(rtwdev, "incorrect lna index (%d)\n", lna_idx);
 		return -120;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index dd4fbb82750d..a23806b69b0f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -1012,12 +1012,12 @@ static int rtw8822b_set_antenna(struct rtw_dev *rtwdev,
 		antenna_tx, antenna_rx);
 
 	if (!rtw8822b_check_rf_path(antenna_tx)) {
-		rtw_info(rtwdev, "unsupported tx path 0x%x\n", antenna_tx);
+		rtw_warn(rtwdev, "unsupported tx path 0x%x\n", antenna_tx);
 		return -EINVAL;
 	}
 
 	if (!rtw8822b_check_rf_path(antenna_rx)) {
-		rtw_info(rtwdev, "unsupported rx path 0x%x\n", antenna_rx);
+		rtw_warn(rtwdev, "unsupported rx path 0x%x\n", antenna_rx);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 35c46e5209de..ddf4d1a23e60 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -2798,7 +2798,7 @@ static int rtw8822c_set_antenna(struct rtw_dev *rtwdev,
 	case BB_PATH_AB:
 		break;
 	default:
-		rtw_info(rtwdev, "unsupported tx path 0x%x\n", antenna_tx);
+		rtw_warn(rtwdev, "unsupported tx path 0x%x\n", antenna_tx);
 		return -EINVAL;
 	}
 
@@ -2808,7 +2808,7 @@ static int rtw8822c_set_antenna(struct rtw_dev *rtwdev,
 	case BB_PATH_AB:
 		break;
 	default:
-		rtw_info(rtwdev, "unsupported rx path 0x%x\n", antenna_rx);
+		rtw_warn(rtwdev, "unsupported rx path 0x%x\n", antenna_rx);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtw88/sar.c b/drivers/net/wireless/realtek/rtw88/sar.c
index 3383726c4d90..c472f1502b82 100644
--- a/drivers/net/wireless/realtek/rtw88/sar.c
+++ b/drivers/net/wireless/realtek/rtw88/sar.c
@@ -91,10 +91,10 @@ int rtw_set_sar_specs(struct rtw_dev *rtwdev,
 			return -EINVAL;
 
 		power = sar->sub_specs[i].power;
-		rtw_info(rtwdev, "On freq %u to %u, set SAR %d in 1/%lu dBm\n",
-			 rtw_common_sar_freq_ranges[idx].start_freq,
-			 rtw_common_sar_freq_ranges[idx].end_freq,
-			 power, BIT(RTW_COMMON_SAR_FCT));
+		rtw_dbg(rtwdev, RTW_DBG_REGD, "On freq %u to %u, set SAR %d in 1/%lu dBm\n",
+			rtw_common_sar_freq_ranges[idx].start_freq,
+			rtw_common_sar_freq_ranges[idx].end_freq,
+			power, BIT(RTW_COMMON_SAR_FCT));
 
 		for (j = 0; j < RTW_RF_PATH_MAX; j++) {
 			for (k = 0; k < RTW_RATE_SECTION_MAX; k++) {
-- 
2.35.1



