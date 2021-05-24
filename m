Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DB738EEAD
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhEXPx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhEXPvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDECE6162D;
        Mon, 24 May 2021 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870723;
        bh=dxBIgUZ1Idl+2yCCxvP+acIItyl3e/AKF/qtoTpLeMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbLcMc/13pAeMj7P4410VbxWz3T9CUs25xkCmjzLeUcy4Nt9GmW+fRBLaUhTCnvMF
         K/bXlj9KQIhJm0LRv3UDurD4rPNdY+s5qavwJsLp1fFyW1uNIhovUdQxb9BjXQCkvJ
         DUeOh0OMCSCvRWhUtg/KQgY35d4gdljFtre6wvYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Bryan Brattlof <hello@bryanbrattlof.com>
Subject: [PATCH 5.4 61/71] net: rtlwifi: properly check for alloc_workqueue() failure
Date:   Mon, 24 May 2021 17:26:07 +0200
Message-Id: <20210524152328.434681042@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
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
@@ -436,9 +436,14 @@ static void _rtl_init_mac80211(struct ie
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
 	timer_setup(&rtlpriv->works.watchdog_timer,
@@ -447,7 +452,8 @@ static void _rtl_init_deferred_work(stru
 		    rtl_easy_concurrent_retrytimer_callback, 0);
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	rtlpriv->works.rtl_wq = wq;
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
@@ -460,6 +466,7 @@ static void _rtl_init_deferred_work(stru
 			  (void *)rtl_fwevt_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq,
 			  (void *)rtl_c2hcmd_wq_callback);
+	return 0;
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw, bool ips_wq)
@@ -559,9 +566,7 @@ int rtl_init_core(struct ieee80211_hw *h
 	rtlmac->link_state = MAC80211_NOLINK;
 
 	/* <6> init deferred work */
-	_rtl_init_deferred_work(hw);
-
-	return 0;
+	return _rtl_init_deferred_work(hw);
 }
 EXPORT_SYMBOL_GPL(rtl_init_core);
 


