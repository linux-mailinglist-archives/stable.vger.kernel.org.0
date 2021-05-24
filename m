Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B088938EDBC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhEXPlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhEXPjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B8F461400;
        Mon, 24 May 2021 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870433;
        bh=/H2hHskoegI29xPt92L5/gju4VwR7DlzkGwpYpmSEE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ly7FhPsr8xD0+7KVaJGH//ilAOInvAhbEi+PA8RSVmZEnsem9Zr3j/7UVJYw3cJpx
         WjRfyDWJo2stuCqJ0K0zGqHcbZ0QBgnVHE2GC+lED4QQnXB7g+EzzPxCIb6wLpD7Vj
         xciDJpn4RsT96mnnWSV+l/wGLJKYnlf4+Gtw+K/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Bryan Brattlof <hello@bryanbrattlof.com>
Subject: [PATCH 4.14 31/37] net: rtlwifi: properly check for alloc_workqueue() failure
Date:   Mon, 24 May 2021 17:25:35 +0200
Message-Id: <20210524152325.223399428@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
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
@@ -456,9 +456,14 @@ static void _rtl_init_mac80211(struct ie
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
@@ -467,7 +472,8 @@ static void _rtl_init_deferred_work(stru
 		    rtl_easy_concurrent_retrytimer_callback, (unsigned long)hw);
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
+	rtlpriv->works.rtl_wq = wq;
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
@@ -480,7 +486,7 @@ static void _rtl_init_deferred_work(stru
 			  (void *)rtl_fwevt_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq,
 			  (void *)rtl_c2hcmd_wq_callback);
-
+	return 0;
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw, bool ips_wq)
@@ -580,9 +586,7 @@ int rtl_init_core(struct ieee80211_hw *h
 	rtlmac->link_state = MAC80211_NOLINK;
 
 	/* <6> init deferred work */
-	_rtl_init_deferred_work(hw);
-
-	return 0;
+	return _rtl_init_deferred_work(hw);
 }
 EXPORT_SYMBOL_GPL(rtl_init_core);
 


