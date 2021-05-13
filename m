Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEC737FABC
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhEMPcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEMPcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:32:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9CCB61168;
        Thu, 13 May 2021 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919882;
        bh=PKjE7Tz5Qn4JMbRkI2ReTwvM+ABkS56WbTiln93QayY=;
        h=Subject:To:From:Date:From;
        b=sMUZhoCU/AYZ/2y9YVg5Hoaao7OUL2WoKB6zfNpbYKEK/81Qhjo71PB+prpaj6a0L
         PeD8J3EeG9i07b0rH7PxL4UylRQKD70fKkEsx/bKOogR2KmLMcX3hbRIcG0xPidney
         NxRr0L/5gFHKllIgsqGeAyTHgYg7vrnN1o7ExZto=
Subject: patch "net: rtlwifi: properly check for alloc_workqueue() failure" added to char-misc-linus
To:     gregkh@linuxfoundation.org, hello@bryanbrattlof.com,
        kvalo@codeaurora.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:31:05 +0200
Message-ID: <162091986550190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    net: rtlwifi: properly check for alloc_workqueue() failure

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 30b0e0ee9d02b97b68705c46b41444786effc40c Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:40 +0200
Subject: net: rtlwifi: properly check for alloc_workqueue() failure

If alloc_workqueue() fails, properly catch this and propagate the error
to the calling functions, so that the devuce initialization will
properly error out.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Bryan Brattlof <hello@bryanbrattlof.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-14-gregkh@linuxfoundation.org
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


