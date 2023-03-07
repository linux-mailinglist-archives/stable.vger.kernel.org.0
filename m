Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB9F6AECDD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCGR6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjCGR6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:58:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A386A5906
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:52:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB8BC6150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1554C433EF;
        Tue,  7 Mar 2023 17:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211561;
        bh=L0wTZ31N6P3KERkNZ5z/0tXuCJP3/Nf+rc0d6EopIw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWCk/VpmjR9oApo8nLGiTtaEeKRlh6kJciJB/r5t1DkeUDO29Yoi3U0MMaXLSMqOm
         Ocfn2BxNWKAZlMxYHoaP5ST/A2eVv3JxMsKVNtpAvWCymMm1LLoBrrxvk+G49nAcPM
         ZCGjhinU3V7vDST0eyhvCcw7dY6LIg/vrCfYYGkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Gover <pmw.gover@yahoo.co.uk>,
        Stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 0903/1001] wifi: rtw88: use RTW_FLAG_POWERON flag to prevent to power on/off twice
Date:   Tue,  7 Mar 2023 18:01:15 +0100
Message-Id: <20230307170101.201165332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

commit 4a267bc5ea8f159b614d0549030216d0434eccca upstream.

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
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230216053633.20366-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/coex.c |    2 +-
 drivers/net/wireless/realtek/rtw88/mac.c  |   10 ++++++++++
 drivers/net/wireless/realtek/rtw88/main.h |    2 +-
 drivers/net/wireless/realtek/rtw88/ps.c   |    4 ++--
 drivers/net/wireless/realtek/rtw88/wow.c  |    2 +-
 5 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -4056,7 +4056,7 @@ void rtw_coex_display_coex_info(struct r
 		   rtwdev->stats.tx_throughput, rtwdev->stats.rx_throughput);
 	seq_printf(m, "%-40s = %u/ %u/ %u\n",
 		   "IPS/ Low Power/ PS mode",
-		   test_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags),
+		   !test_bit(RTW_FLAG_POWERON, rtwdev->flags),
 		   test_bit(RTW_FLAG_LEISURE_PS_DEEP, rtwdev->flags),
 		   rtwdev->lps_conf.mode);
 
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -273,6 +273,11 @@ static int rtw_mac_power_switch(struct r
 	if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
 		return -EINVAL;
 
+	if (pwr_on)
+		set_bit(RTW_FLAG_POWERON, rtwdev->flags);
+	else
+		clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
+
 	return 0;
 }
 
@@ -335,6 +340,11 @@ int rtw_mac_power_on(struct rtw_dev *rtw
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
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -25,7 +25,7 @@ static int rtw_ips_pwr_up(struct rtw_dev
 
 int rtw_enter_ips(struct rtw_dev *rtwdev)
 {
-	if (test_and_set_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags))
+	if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags))
 		return 0;
 
 	rtw_coex_ips_notify(rtwdev, COEX_IPS_ENTER);
@@ -50,7 +50,7 @@ int rtw_leave_ips(struct rtw_dev *rtwdev
 {
 	int ret;
 
-	if (!test_and_clear_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags))
+	if (test_bit(RTW_FLAG_POWERON, rtwdev->flags))
 		return 0;
 
 	rtw_hci_link_ps(rtwdev, false);
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -592,7 +592,7 @@ static int rtw_wow_leave_no_link_ps(stru
 		if (rtw_get_lps_deep_mode(rtwdev) != LPS_DEEP_MODE_NONE)
 			rtw_leave_lps_deep(rtwdev);
 	} else {
-		if (test_bit(RTW_FLAG_INACTIVE_PS, rtwdev->flags)) {
+		if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags)) {
 			rtw_wow->ips_enabled = true;
 			ret = rtw_leave_ips(rtwdev);
 			if (ret)


