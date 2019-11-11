Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0798BF8050
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKKTkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:40:55 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46608 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbfKKTkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 14:40:55 -0500
Received: by mail-ot1-f66.google.com with SMTP id n23so12215495otr.13;
        Mon, 11 Nov 2019 11:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ux6PcVKUkqIeV4gk2q6oB+RKeiUnJFZU2ksmKsu1Q3g=;
        b=cnKNYMpAr0P3zGnuuG3HMJz45DCgQL2Ne5tN4iIBk+SjDS981l2+YFiLnN9tOFLnrI
         /KBK2ILHWKccs6nftOsWeQ8+LJUMtyL8vpnfAfsxzCIOAmYhAuiPRD7w0YNgfK4V+2nT
         4OzPHdyE6SYwQQxBDbgV7FB00mXIGDj4YkxciEL1V0/5UGtKp1j5DvTZMhMlAAcx1UFS
         ++lgfv9oR0wOZAlqceB6UpGEydp8MLkBYCvIDB3YOO74/p9Gf+OvHNtLF/VU80ScLis6
         y9pLWbCTx9RHGRaaucXRl9+vQ9/waliSTf2cqJ6LyoATR0USdPe3ZzoyGgmJJ6dOvMav
         8Xxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Ux6PcVKUkqIeV4gk2q6oB+RKeiUnJFZU2ksmKsu1Q3g=;
        b=DeDF7Ozu76PzqxhJZoj9JRrL68AKyEbXt/7vD6/WP3W9bz1bZsA4yclIizKnRccSZD
         RaWOG/4Cc10heGu6xlYgs33UI4Z8f3OkPobynSEFlT+UE1YZ9f4hv5KSngUuOf5FvQD3
         +i8MWEVrNzJ6gLKsyB8Kgtw5UPwKJkhy7hNKQqzCeiETq6Z7dHrcQoX6rdvzq+Bd7eYO
         JFZ4qP5E8C1Y3iZvHQmCO4qCy4s694r8enNSiVzIgJnnlYBK/jrBP/q6SZgTZ5D/C782
         7O0RGAWus0HypkVhPlD7zWYM3Cu3lbs8OIvY+yxAG8/fpmOP2xa1Lt0Cqys6tP9uJlAY
         VoBQ==
X-Gm-Message-State: APjAAAX6eVEeFXEZR9grWUrYdv4J0BQ0GJICskiG0lVjD2jahIIQDjF3
        ufkEXq45w7M1vmTDTbvoWVU=
X-Google-Smtp-Source: APXvYqzNotmgNyy1oV8onhlUkI+FpJ5/y3DSW/RWST0qkGtXGMGiV37svWtl2glRY4le9qWQMEA9Sw==
X-Received: by 2002:a05:6830:1d71:: with SMTP id l17mr21879643oti.236.1573501254353;
        Mon, 11 Nov 2019 11:40:54 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o22sm5031002otk.47.2019.11.11.11.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 11:40:54 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] rtlwifi: rtl8192de: Fix missing callback that tests for hw release of buffer
Date:   Mon, 11 Nov 2019 13:40:45 -0600
Message-Id: <20191111194046.26908-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111194046.26908-1-Larry.Finger@lwfinger.net>
References: <20191111194046.26908-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for
new drivers"), a callback needed to check if the hardware has released
a buffer indicating that a DMA operation is completed was not added.

Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
Cc: Stable <stable@vger.kernel.org>	# v3.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c |  1 +
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c    | 17 +++++++++++++++++
 .../wireless/realtek/rtlwifi/rtl8192de/trx.h    |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 99e5cd9a5c86..1dbdddce0823 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -216,6 +216,7 @@ static struct rtl_hal_ops rtl8192de_hal_ops = {
 	.led_control = rtl92de_led_control,
 	.set_desc = rtl92de_set_desc,
 	.get_desc = rtl92de_get_desc,
+	.is_tx_desc_closed = rtl92de_is_tx_desc_closed,
 	.tx_polling = rtl92de_tx_polling,
 	.enable_hw_sec = rtl92de_enable_hw_security_config,
 	.set_key = rtl92de_set_key,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index b4561923a70a..92c9fb45f800 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -823,6 +823,23 @@ u64 rtl92de_get_desc(struct ieee80211_hw *hw,
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
index 36820070fd76..635989e15282 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
@@ -715,6 +715,8 @@ void rtl92de_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 		      u8 desc_name, u8 *val);
 u64 rtl92de_get_desc(struct ieee80211_hw *hw,
 		     u8 *p_desc, bool istx, u8 desc_name);
+bool rtl92de_is_tx_desc_closed(struct ieee80211_hw *hw,
+			       u8 hw_queue, u16 index);
 void rtl92de_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			     bool b_firstseg, bool b_lastseg,
-- 
2.23.0

