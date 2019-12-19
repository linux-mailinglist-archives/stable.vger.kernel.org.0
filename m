Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC8C126C81
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfLSSrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfLSSrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:47:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE874206D7;
        Thu, 19 Dec 2019 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781238;
        bh=6RpLG1w9cbjENnUVpGsfAHqGQ7HZEHT8ezMsQ7pwDXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqlmXqFLxBRhli5hGz5L+y+Nxsw8CqWawNINYx3Sjce8PFDmpZan/y4o8cv3OfaGs
         ocUSCgOm6u87rjkCCDSfnHB8MpmVitGW+XE+2yID8pb9JVf2H2JiRRpG9G7tjn4Vth
         ZIjfwM5fLqMskagzawkNMuSWvBrLE2ndJi5hUCqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 122/199] rtlwifi: rtl8192de: Fix missing enable interrupt flag
Date:   Thu, 19 Dec 2019 19:33:24 +0100
Message-Id: <20191219183221.695212263@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 330bb7117101099c687e9c7f13d48068670b9c62 upstream.

In commit 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for
new drivers"), the flag that indicates that interrupts are enabled was
never set.

In addition, there are several places when enable/disable interrupts
were commented out are restored. A sychronize_interrupts() call is
removed.

Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
Cc: Stable <stable@vger.kernel.org>	# v3.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -1209,6 +1209,7 @@ void rtl92de_enable_interrupt(struct iee
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
+	rtlpci->irq_enabled = true;
 }
 
 void rtl92de_disable_interrupt(struct ieee80211_hw *hw)
@@ -1218,7 +1219,7 @@ void rtl92de_disable_interrupt(struct ie
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	synchronize_irq(rtlpci->pdev->irq);
+	rtlpci->irq_enabled = false;
 }
 
 static void _rtl92de_poweroff_adapter(struct ieee80211_hw *hw)
@@ -1389,7 +1390,7 @@ void rtl92de_set_beacon_related_register
 
 	bcn_interval = mac->beacon_interval;
 	atim_window = 2;
-	/*rtl92de_disable_interrupt(hw);  */
+	rtl92de_disable_interrupt(hw);
 	rtl_write_word(rtlpriv, REG_ATIMWND, atim_window);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
 	rtl_write_word(rtlpriv, REG_BCNTCFG, 0x660f);
@@ -1409,9 +1410,9 @@ void rtl92de_set_beacon_interval(struct
 
 	RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
 		 "beacon_interval:%d\n", bcn_interval);
-	/* rtl92de_disable_interrupt(hw); */
+	rtl92de_disable_interrupt(hw);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
-	/* rtl92de_enable_interrupt(hw); */
+	rtl92de_enable_interrupt(hw);
 }
 
 void rtl92de_update_interrupt_mask(struct ieee80211_hw *hw,


