Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B89F4F281D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiDEIKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiDEICg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823D25715A;
        Tue,  5 Apr 2022 01:00:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6B7661781;
        Tue,  5 Apr 2022 08:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EFAC340EE;
        Tue,  5 Apr 2022 08:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145637;
        bh=Oat9dFwqGRhj14OTXkdTkKFE+a4cA0jXTyXxE6bxho0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdRAmboTQyGjO6XuJsDNnEGI+/uz/nYwT/rCepPhhbnmzLip33aKGLOgcHXnT9WOa
         3PurUiRpLyKI+3SoDwPAM3F5XJdULV0MpD72RcBxLFO3D+f+W97FQB3BXOnmPgZ5OE
         AtUn09xwVbUOKYyAt3pbCFsTriFZTVGOYm/FaKhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0476/1126] rtw88: fix idle mode flow for hw scan
Date:   Tue,  5 Apr 2022 09:20:23 +0200
Message-Id: <20220405070421.598892500@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit c17f27167b4cb4988ae035fb8dce0c314e9de155 ]

Upon hw scan completion, idle mode is not re-entered. This might
increase power consumption under no link mode. Fix this by adding the
re-enter flow. We need another work for this since enter_ips waits
for c2h_work to finish, which might lead to deadlock if caller is in
the same work.

Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220121070813.9656-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c       |  2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c |  5 ++++-
 drivers/net/wireless/realtek/rtw88/main.c     | 16 +++++++++++++++-
 drivers/net/wireless/realtek/rtw88/main.h     |  4 +++-
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index b56dc43229d2..a631042753ea 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -2030,7 +2030,7 @@ void rtw_hw_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 	rtwdev->hal.rcr |= BIT_CBSSID_BCN;
 	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
 
-	rtw_core_scan_complete(rtwdev, vif);
+	rtw_core_scan_complete(rtwdev, vif, true);
 
 	ieee80211_wake_queues(rtwdev->hw);
 	ieee80211_scan_completed(rtwdev->hw, &info);
diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index ae7d97de5fdf..647d2662955b 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -72,6 +72,9 @@ static int rtw_ops_config(struct ieee80211_hw *hw, u32 changed)
 	struct rtw_dev *rtwdev = hw->priv;
 	int ret = 0;
 
+	/* let previous ips work finish to ensure we don't leave ips twice */
+	cancel_work_sync(&rtwdev->ips_work);
+
 	mutex_lock(&rtwdev->mutex);
 
 	rtw_leave_lps_deep(rtwdev);
@@ -614,7 +617,7 @@ static void rtw_ops_sw_scan_complete(struct ieee80211_hw *hw,
 	struct rtw_dev *rtwdev = hw->priv;
 
 	mutex_lock(&rtwdev->mutex);
-	rtw_core_scan_complete(rtwdev, vif);
+	rtw_core_scan_complete(rtwdev, vif, false);
 	mutex_unlock(&rtwdev->mutex);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 38252113c4a8..39c223a2e3e2 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -272,6 +272,15 @@ static void rtw_c2h_work(struct work_struct *work)
 	}
 }
 
+static void rtw_ips_work(struct work_struct *work)
+{
+	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev, ips_work);
+
+	mutex_lock(&rtwdev->mutex);
+	rtw_enter_ips(rtwdev);
+	mutex_unlock(&rtwdev->mutex);
+}
+
 static u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
 {
 	unsigned long mac_id;
@@ -1339,7 +1348,8 @@ void rtw_core_scan_start(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
 	set_bit(RTW_FLAG_SCANNING, rtwdev->flags);
 }
 
-void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+			    bool hw_scan)
 {
 	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
 	u32 config = 0;
@@ -1354,6 +1364,9 @@ void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
 	rtw_vif_port_config(rtwdev, rtwvif, config);
 
 	rtw_coex_scan_notify(rtwdev, COEX_SCAN_FINISH);
+
+	if (rtwvif->net_type == RTW_NET_NO_LINK && hw_scan)
+		ieee80211_queue_work(rtwdev->hw, &rtwdev->ips_work);
 }
 
 int rtw_core_start(struct rtw_dev *rtwdev)
@@ -1919,6 +1932,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	INIT_DELAYED_WORK(&coex->wl_ccklock_work, rtw_coex_wl_ccklock_work);
 	INIT_WORK(&rtwdev->tx_work, rtw_tx_work);
 	INIT_WORK(&rtwdev->c2h_work, rtw_c2h_work);
+	INIT_WORK(&rtwdev->ips_work, rtw_ips_work);
 	INIT_WORK(&rtwdev->fw_recovery_work, rtw_fw_recovery_work);
 	INIT_WORK(&rtwdev->ba_work, rtw_txq_ba_work);
 	skb_queue_head_init(&rtwdev->c2h_queue);
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index dc1cd9bd4b8a..36e1e408933d 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1960,6 +1960,7 @@ struct rtw_dev {
 	/* c2h cmd queue & handler work */
 	struct sk_buff_head c2h_queue;
 	struct work_struct c2h_work;
+	struct work_struct ips_work;
 	struct work_struct fw_recovery_work;
 
 	/* used to protect txqs list */
@@ -2101,7 +2102,8 @@ void rtw_tx_report_purge_timer(struct timer_list *t);
 void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
 void rtw_core_scan_start(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
 			 const u8 *mac_addr, bool hw_scan);
-void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif);
+void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
+			    bool hw_scan);
 int rtw_core_start(struct rtw_dev *rtwdev);
 void rtw_core_stop(struct rtw_dev *rtwdev);
 int rtw_chip_info_setup(struct rtw_dev *rtwdev);
-- 
2.34.1



