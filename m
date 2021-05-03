Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385443714AA
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbhECL7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 07:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233353AbhECL7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 07:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CDF56127A;
        Mon,  3 May 2021 11:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043139;
        bh=ai49qo2xncmZvSTVWexxt3oB6tZvJINjoI9g6I/u8B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buna9D0GC8+9CvIMqY5xmiwUWg3tutDI3zfHQ0XY7FWSwJvpON6Doq47xQddo+2eq
         HJ0IG+XfZIHU/ebyJ/dQrtlmagOjJDEtkfhCeYgqTdsraSCjyPo2Zdn7M5LTFKtc7E
         KrXVzidGG/f8FV2HUoXBc6A08p1vab+Wul++0Py0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Bryan Brattlof <hello@bryanbrattlof.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 13/69] net: rtlwifi: properly check for alloc_workqueue() failure
Date:   Mon,  3 May 2021 13:56:40 +0200
Message-Id: <20210503115736.2104747-14-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If alloc_workqueue() fails, properly catch this and propagate the error
to the calling functions, so that the devuce initialization will
properly error out.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Bryan Brattlof <hello@bryanbrattlof.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 4136d7c63254..ffd150ec181f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -440,9 +440,14 @@ static void rtl_watchdog_wq_callback(struct work_struct *work);
 static void rtl_fwevt_wq_callback(struct work_struct *work);
 static void rtl_c2hcmd_wq_callback(struct work_struct *work);
 
-static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
+static int _rtl_init_deferred_work(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct workqueue_struct *wq;
+
+	wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	if (!wq)
+		return -ENOMEM;
 
 	/* <1> timer */
 	timer_setup(&rtlpriv->works.watchdog_timer,
@@ -451,7 +456,8 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 		    rtl_easy_concurrent_retrytimer_callback, 0);
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	rtlpriv->works.rtl_wq = wq;
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
@@ -461,6 +467,7 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 			  rtl_swlps_rfon_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.fwevt_wq, rtl_fwevt_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq, rtl_c2hcmd_wq_callback);
+	return 0;
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw, bool ips_wq)
@@ -559,9 +566,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	rtlmac->link_state = MAC80211_NOLINK;
 
 	/* <6> init deferred work */
-	_rtl_init_deferred_work(hw);
-
-	return 0;
+	return _rtl_init_deferred_work(hw);
 }
 EXPORT_SYMBOL_GPL(rtl_init_core);
 
-- 
2.31.1

