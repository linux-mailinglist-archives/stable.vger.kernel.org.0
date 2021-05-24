Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FC238ED8A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhEXPiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhEXPgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:36:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96B361411;
        Mon, 24 May 2021 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870377;
        bh=S1CN5MyHtZ9OSrpusCrkNbNf9yJ1kB5dvIQ0K/iCqlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRw0wwKYsPgh2M/iVQ+SYHn3eX39zA5ebd7fJ/9lPo7YTmTi3bFfdmCSUBmQtyc7q
         nmMi8rGfdNXt67b2TM5w8UZGjx7ncqHexMv50p08SZtehrchHirGWsfQx5KZL34L0H
         gM97PjxKhbipYfuLcy1HJKL5Q2a1B8sSYRF4AZHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Bryan Brattlof <hello@bryanbrattlof.com>
Subject: [PATCH 4.9 29/36] net: rtlwifi: properly check for alloc_workqueue() failure
Date:   Mon, 24 May 2021 17:25:14 +0200
Message-Id: <20210524152325.101577356@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
References: <20210524152324.158146731@linuxfoundation.org>
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
 drivers/net/wireless/realtek/rtlwifi/base.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -454,9 +454,14 @@ static void _rtl_init_mac80211(struct ie
 	}
 }
 
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
 	setup_timer(&rtlpriv->works.watchdog_timer,
@@ -465,7 +470,8 @@ static void _rtl_init_deferred_work(stru
 		    rtl_easy_concurrent_retrytimer_callback, (unsigned long)hw);
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	rtlpriv->works.rtl_wq = wq;
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
@@ -476,7 +482,7 @@ static void _rtl_init_deferred_work(stru
 			  (void *)rtl_swlps_rfon_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.fwevt_wq,
 			  (void *)rtl_fwevt_wq_callback);
-
+	return 0;
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw)
@@ -568,9 +574,7 @@ int rtl_init_core(struct ieee80211_hw *h
 	rtlmac->link_state = MAC80211_NOLINK;
 
 	/* <6> init deferred work */
-	_rtl_init_deferred_work(hw);
-
-	return 0;
+	return _rtl_init_deferred_work(hw);
 }
 EXPORT_SYMBOL_GPL(rtl_init_core);
 


