Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9187B54179F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378601AbiFGVEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378488AbiFGVDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:03:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03403149166;
        Tue,  7 Jun 2022 11:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E605B8237F;
        Tue,  7 Jun 2022 18:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10508C385A5;
        Tue,  7 Jun 2022 18:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627710;
        bh=+WgOzsWRKetzAfOsz+S4/Q/45z6GGe4m0xrIXOZM+yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRdJP3w4L+GKVXLeV3shBa9B/bDihArXHwflUfAcSQPuP6wM8MdwwSIUOh3u6GKhs
         1T723OL2vcvaBOlnv4Ofxs/ekliD94PaFfO2Y/a7B9Hm7bg4c0mITUERCV7HLAwqaL
         wcDCq2S2OsmACv+if2k1eLqZlKrg6Y6kJHnNncZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 063/879] rtw89: ser: fix CAM leaks occurring in L2 reset
Date:   Tue,  7 Jun 2022 18:53:01 +0200
Message-Id: <20220607165004.521491217@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit b169f877f001a474fb89939842c390518160bcc5 ]

The CAM, meaning address CAM and bssid CAM here, will get leaks during
SER (system error recover) L2 reset process and ieee80211_restart_hw()
which is called by L2 reset process eventually.

The normal flow would be like
-> add interface (acquire 1)
-> enter ips (release 1)
-> leave ips (acquire 1)
-> connection (occupy 1) <(A) 1 leak after L2 reset if non-sec connection>

The ieee80211_restart_hw() flow (under connection)
-> ieee80211 reconfig
-> add interface (acquire 1)
-> leave ips (acquire 1)
-> connection (occupy (A) + 2) <(B) 1 more leak>

Originally, CAM is released before HW restart only if connection is under
security. Now, release CAM whatever connection it is to fix leak in (A).
OTOH, check if CAM is already valid to avoid acquiring multiple times to
fix (B).

Besides, if AP mode, release address CAM of all stations before HW restart.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220314071250.40292-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/cam.c | 14 ++++++++++++--
 drivers/net/wireless/realtek/rtw89/ser.c | 21 +++++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wireless/realtek/rtw89/cam.c
index 305dbbebff6b..26bef9fdd205 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -421,10 +421,8 @@ static void rtw89_cam_reset_key_iter(struct ieee80211_hw *hw,
 				     void *data)
 {
 	struct rtw89_dev *rtwdev = (struct rtw89_dev *)data;
-	struct rtw89_vif *rtwvif = (struct rtw89_vif *)vif->drv_priv;
 
 	rtw89_cam_sec_key_del(rtwdev, vif, sta, key, false);
-	rtw89_cam_deinit(rtwdev, rtwvif);
 }
 
 void rtw89_cam_deinit_addr_cam(struct rtw89_dev *rtwdev,
@@ -480,6 +478,12 @@ int rtw89_cam_init_addr_cam(struct rtw89_dev *rtwdev,
 	int i;
 	int ret;
 
+	if (unlikely(addr_cam->valid)) {
+		rtw89_debug(rtwdev, RTW89_DBG_FW,
+			    "addr cam is already valid; skip init\n");
+		return 0;
+	}
+
 	ret = rtw89_cam_get_avail_addr_cam(rtwdev, &addr_cam_idx);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to get available addr cam\n");
@@ -531,6 +535,12 @@ static int rtw89_cam_init_bssid_cam(struct rtw89_dev *rtwdev,
 	u8 bssid_cam_idx;
 	int ret;
 
+	if (unlikely(bssid_cam->valid)) {
+		rtw89_debug(rtwdev, RTW89_DBG_FW,
+			    "bssid cam is already valid; skip init\n");
+		return 0;
+	}
+
 	ret = rtw89_cam_get_avail_bssid_cam(rtwdev, &bssid_cam_idx);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to get available bssid cam\n");
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 837cdc366a61..e86f3d89ef1b 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -220,11 +220,32 @@ static void ser_reset_vif(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 	rtwvif->trigger = false;
 }
 
+static void ser_sta_deinit_addr_cam_iter(void *data, struct ieee80211_sta *sta)
+{
+	struct rtw89_dev *rtwdev = (struct rtw89_dev *)data;
+	struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
+
+	rtw89_cam_deinit_addr_cam(rtwdev, &rtwsta->addr_cam);
+}
+
+static void ser_deinit_cam(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
+{
+	if (rtwvif->net_type == RTW89_NET_TYPE_AP_MODE)
+		ieee80211_iterate_stations_atomic(rtwdev->hw,
+						  ser_sta_deinit_addr_cam_iter,
+						  rtwdev);
+
+	rtw89_cam_deinit(rtwdev, rtwvif);
+}
+
 static void ser_reset_mac_binding(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_vif *rtwvif;
 
 	rtw89_cam_reset_keys(rtwdev);
+	rtw89_for_each_rtwvif(rtwdev, rtwvif)
+		ser_deinit_cam(rtwdev, rtwvif);
+
 	rtw89_core_release_all_bits_map(rtwdev->mac_id_map, RTW89_MAX_MAC_ID_NUM);
 	rtw89_for_each_rtwvif(rtwdev, rtwvif)
 		ser_reset_vif(rtwdev, rtwvif);
-- 
2.35.1



