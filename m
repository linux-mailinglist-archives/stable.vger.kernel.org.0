Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8BE38F040
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhEXQCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235537AbhEXQA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C20A61995;
        Mon, 24 May 2021 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871185;
        bh=w8AofuxdJMLE8NjVCLMel5ry4/86pey5fHiGwP8Fn14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXOhp9OGv1T/TZy226Hr2LOKYgEIQzM6lPs5/4brjYkTqq6TSdwkvQtJEH+i037xL
         thmXh/9/16hxW7iCh0gNU3he2gdgzIqw37svrKXCuNSSloWg62B9OOtV6y6Yfu5/5i
         UWOTxBiqbaQ5zGG4pcqPtgk38nPd1GDNRvr3AWNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Bryan Brattlof <hello@bryanbrattlof.com>
Subject: [PATCH 5.12 113/127] net: rtlwifi: properly check for alloc_workqueue() failure
Date:   Mon, 24 May 2021 17:27:10 +0200
Message-Id: <20210524152338.682934928@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 30b0e0ee9d02b97b68705c46b41444786effc40c upstream.

If alloc_workqueue() fails, properly catch this and propagate the error
to the calling functions, so that the devuce initialization will
properly error out.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Bryan Brattlof <hello@bryanbrattlof.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-14-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -440,9 +440,14 @@ static void rtl_watchdog_wq_callback(str
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
@@ -451,7 +456,8 @@ static void _rtl_init_deferred_work(stru
 		    rtl_easy_concurrent_retrytimer_callback, 0);
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	rtlpriv->works.rtl_wq = wq;
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
@@ -461,6 +467,7 @@ static void _rtl_init_deferred_work(stru
 			  rtl_swlps_rfon_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.fwevt_wq, rtl_fwevt_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq, rtl_c2hcmd_wq_callback);
+	return 0;
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw, bool ips_wq)
@@ -560,9 +567,7 @@ int rtl_init_core(struct ieee80211_hw *h
 	rtlmac->link_state = MAC80211_NOLINK;
 
 	/* <6> init deferred work */
-	_rtl_init_deferred_work(hw);
-
-	return 0;
+	return _rtl_init_deferred_work(hw);
 }
 EXPORT_SYMBOL_GPL(rtl_init_core);
 


