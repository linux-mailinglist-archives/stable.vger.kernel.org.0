Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B23121399
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfLPSDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729453AbfLPSDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:03:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39BB32072D;
        Mon, 16 Dec 2019 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519389;
        bh=hFureTdvfpp1CHTnbCGVi0B4qwsNsYx/cmvjy1S9FKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehSaD9VvpIrF1B7tQt6PZNH9Nf7KEi1YHT4JKmIz5KKd9Dc6Nhl7WE5HtfFcQxlMl
         pEROoNJQednaBoFPePDIZef+w4KjIAjNA48hqexZKri141Q1ACAowgktM36icTglqi
         KAnYyOVw/BYL6GwpNkU1e7QMTkAw7sbRBgYWACYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 045/140] rtlwifi: rtl8192de: Fix missing callback that tests for hw release of buffer
Date:   Mon, 16 Dec 2019 18:48:33 +0100
Message-Id: <20191216174801.125984474@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 3155db7613edea8fb943624062baf1e4f9cfbfd6 upstream.

In commit 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for
new drivers"), a callback needed to check if the hardware has released
a buffer indicating that a DMA operation is completed was not added.

Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
Cc: Stable <stable@vger.kernel.org>	# v3.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c  |    1 +
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c |   17 +++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h |    2 ++
 3 files changed, 20 insertions(+)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -238,6 +238,7 @@ static struct rtl_hal_ops rtl8192de_hal_
 	.led_control = rtl92de_led_control,
 	.set_desc = rtl92de_set_desc,
 	.get_desc = rtl92de_get_desc,
+	.is_tx_desc_closed = rtl92de_is_tx_desc_closed,
 	.tx_polling = rtl92de_tx_polling,
 	.enable_hw_sec = rtl92de_enable_hw_security_config,
 	.set_key = rtl92de_set_key,
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -859,6 +859,23 @@ u64 rtl92de_get_desc(struct ieee80211_hw
 	return ret;
 }
 
+bool rtl92de_is_tx_desc_closed(struct ieee80211_hw *hw,
+			       u8 hw_queue, u16 index)
+{
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
+	u8 *entry = (u8 *)(&ring->desc[ring->idx]);
+	u8 own = (u8)rtl92de_get_desc(hw, entry, true, HW_DESC_OWN);
+
+	/* a beacon packet will only use the first
+	 * descriptor by defaut, and the own bit may not
+	 * be cleared by the hardware
+	 */
+	if (own)
+		return false;
+	return true;
+}
+
 void rtl92de_tx_polling(struct ieee80211_hw *hw, u8 hw_queue)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
@@ -737,6 +737,8 @@ void rtl92de_set_desc(struct ieee80211_h
 		      u8 desc_name, u8 *val);
 u64 rtl92de_get_desc(struct ieee80211_hw *hw,
 		     u8 *p_desc, bool istx, u8 desc_name);
+bool rtl92de_is_tx_desc_closed(struct ieee80211_hw *hw,
+			       u8 hw_queue, u16 index);
 void rtl92de_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			     bool b_firstseg, bool b_lastseg,


