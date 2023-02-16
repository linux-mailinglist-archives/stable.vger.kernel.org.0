Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A5F698C2A
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBPFh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjBPFh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:37:26 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E4416AF1;
        Wed, 15 Feb 2023 21:37:24 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31G5bCcL5026853, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31G5bCcL5026853
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 16 Feb 2023 13:37:12 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 16 Feb 2023 13:37:09 +0800
Received: from localhost (172.21.69.188) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7; Thu, 16 Feb
 2023 13:37:09 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     <tony0620emma@gmail.com>, <kvalo@kernel.org>
CC:     <Stable@vger.kernel.org>, <pmw.gover@yahoo.co.uk>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH for-6.3] wifi: rtw88: use RTW_FLAG_POWERON flag to prevent to power on/off twice
Date:   Thu, 16 Feb 2023 13:36:33 +0800
Message-ID: <20230216053633.20366-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.69.188]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use power state to decide whether we can enter or leave IPS accurately,
and then prevent to power on/off twice.

The commit 6bf3a083407b ("wifi: rtw88: add flag check before enter or leave IPS")
would like to prevent this as well, but it still can't entirely handle all
cases. The exception is that WiFi gets connected and does suspend/resume,
it will power on twice and cause it failed to power on after resuming,
like:

  rtw_8723de 0000:03:00.0: failed to poll offset=0x6 mask=0x2 value=0x2
  rtw_8723de 0000:03:00.0: mac power on failed
  rtw_8723de 0000:03:00.0: failed to power on mac
  rtw_8723de 0000:03:00.0: leave idle state failed
  rtw_8723de 0000:03:00.0: failed to leave ips state
  rtw_8723de 0000:03:00.0: failed to leave idle state
  rtw_8723de 0000:03:00.0: failed to send h2c command

To fix this, introduce new flag RTW_FLAG_POWERON to reflect power state,
and call rtw_mac_pre_system_cfg() to configure registers properly between
power-off/-on.

Reported-by: Paul Gover <pmw.gover@yahoo.co.uk>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217016
Fixes: 6bf3a083407b ("wifi: rtw88: add flag check before enter or leave IPS")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
Hi Kalle,

This patch is to fix 8723DE failed to power on after system resume. Please
queue this to 6.3

Thank you
Ping-Ke

---
 drivers/net/wireless/realtek/rtw88/coex.c |  2 +-
 drivers/net/wireless/realtek/rtw88/mac.c  | 10 ++++++++++
 drivers/net/wireless/realtek/rtw88/main.h |  2 +-
 drivers/net/wireless/realtek/rtw88/ps.c   |  4 ++--
 drivers/net/wireless/realtek/rtw88/wow.c  |  2 +-
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 38697237ee5f0..86467d2f8888c 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -4056,7 +4056,7 @@ void rtw_coex_display_coex_info(struct rtw_dev *rtwdev, struct seq_file *m)
 		   rtwdev->stats.tx_throughput, rtwdev->stats.rx_throughput);
 	seq_printf(m, "%-40s = %u/ %u/ %u\n",
 		   "IPS/ Low Power/ PS mode",
-		   test_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags),
+		   !test_bit(RTW_FLAG_POWERON, rtwdev->flags),
 		   test_bit(RTW_FLAG_LEISURE_PS_DEEP, rtwdev->flags),
 		   rtwdev->lps_conf.mode);
 
diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 4e5c194aac299..dae64901bac5a 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -273,6 +273,11 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
 		return -EINVAL;
 
+	if (pwr_on)
+		set_bit(RTW_FLAG_POWERON, rtwdev->flags);
+	else
+		clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
+
 	return 0;
 }
 
@@ -335,6 +340,11 @@ int rtw_mac_power_on(struct rtw_dev *rtwdev)
 	ret = rtw_mac_power_switch(rtwdev, true);
 	if (ret == -EALREADY) {
 		rtw_mac_power_switch(rtwdev, false);
+
+		ret = rtw_mac_pre_system_cfg(rtwdev);
+		if (ret)
+			goto err;
+
 		ret = rtw_mac_power_switch(rtwdev, true);
 		if (ret)
 			goto err;
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 165f299e8e1f9..d4a53d5567451 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -356,7 +356,7 @@ enum rtw_flags {
 	RTW_FLAG_RUNNING,
 	RTW_FLAG_FW_RUNNING,
 	RTW_FLAG_SCANNING,
-	RTW_FLAG_INACTIVE_PS,
+	RTW_FLAG_POWERON,
 	RTW_FLAG_LEISURE_PS,
 	RTW_FLAG_LEISURE_PS_DEEP,
 	RTW_FLAG_DIG_DISABLE,
diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index 11594940d6b00..996365575f44f 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -25,7 +25,7 @@ static int rtw_ips_pwr_up(struct rtw_dev *rtwdev)
 
 int rtw_enter_ips(struct rtw_dev *rtwdev)
 {
-	if (test_and_set_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags))
+	if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags))
 		return 0;
 
 	rtw_coex_ips_notify(rtwdev, COEX_IPS_ENTER);
@@ -50,7 +50,7 @@ int rtw_leave_ips(struct rtw_dev *rtwdev)
 {
 	int ret;
 
-	if (!test_and_clear_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags))
+	if (test_bit(RTW_FLAG_POWERON, rtwdev->flags))
 		return 0;
 
 	rtw_hci_link_ps(rtwdev, false);
diff --git a/drivers/net/wireless/realtek/rtw88/wow.c b/drivers/net/wireless/realtek/rtw88/wow.c
index 89dc595094d5c..16ddee577efec 100644
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -592,7 +592,7 @@ static int rtw_wow_leave_no_link_ps(struct rtw_dev *rtwdev)
 		if (rtw_get_lps_deep_mode(rtwdev) != LPS_DEEP_MODE_NONE)
 			rtw_leave_lps_deep(rtwdev);
 	} else {
-		if (test_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags)) {
+		if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags)) {
 			rtw_wow->ips_enabled = true;
 			ret = rtw_leave_ips(rtwdev);
 			if (ret)
-- 
2.25.1

