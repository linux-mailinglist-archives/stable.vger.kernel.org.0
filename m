Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE651215FE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbfLPS0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731517AbfLPSRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:17:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEAC820717;
        Mon, 16 Dec 2019 18:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520252;
        bh=LIOwHcfllStzS2p0VL9Ya63jUZg+UW6CQNNda2dA7EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faidJgGsYdapLshYIptDBMExzYrFOPSSA5MB8qgMBxhzchQswPrgMcolKgPdO6NLb
         0quvs9wN4f5dCSCmCdmpKflnpA0ZWL0k7kKggohzQS9Wdv+5RQp5BMC0Fi2+lHXqOl
         1JfZK8V3d7VTX09QHonWYXD5jdVjlxwAWtukglao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 077/177] rtlwifi: rtl8192de: Fix missing enable interrupt flag
Date:   Mon, 16 Dec 2019 18:48:53 +0100
Message-Id: <20191216174836.212177398@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
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
@@ -1176,6 +1176,7 @@ void rtl92de_enable_interrupt(struct iee
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
+	rtlpci->irq_enabled = true;
 }
 
 void rtl92de_disable_interrupt(struct ieee80211_hw *hw)
@@ -1185,7 +1186,7 @@ void rtl92de_disable_interrupt(struct ie
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	synchronize_irq(rtlpci->pdev->irq);
+	rtlpci->irq_enabled = false;
 }
 
 static void _rtl92de_poweroff_adapter(struct ieee80211_hw *hw)
@@ -1351,7 +1352,7 @@ void rtl92de_set_beacon_related_register
 
 	bcn_interval = mac->beacon_interval;
 	atim_window = 2;
-	/*rtl92de_disable_interrupt(hw);  */
+	rtl92de_disable_interrupt(hw);
 	rtl_write_word(rtlpriv, REG_ATIMWND, atim_window);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
 	rtl_write_word(rtlpriv, REG_BCNTCFG, 0x660f);
@@ -1371,9 +1372,9 @@ void rtl92de_set_beacon_interval(struct
 
 	RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
 		 "beacon_interval:%d\n", bcn_interval);
-	/* rtl92de_disable_interrupt(hw); */
+	rtl92de_disable_interrupt(hw);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
-	/* rtl92de_enable_interrupt(hw); */
+	rtl92de_enable_interrupt(hw);
 }
 
 void rtl92de_update_interrupt_mask(struct ieee80211_hw *hw,


