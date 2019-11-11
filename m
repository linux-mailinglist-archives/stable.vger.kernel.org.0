Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA67DF8052
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKKTk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:40:56 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43287 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfKKTkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 14:40:55 -0500
Received: by mail-ot1-f65.google.com with SMTP id l14so12231732oti.10;
        Mon, 11 Nov 2019 11:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0k6JZD8kjz+vTgXniNU5bsoejW224xb6dmKkwGLsAc=;
        b=M2UHEeIsUHdrR3s1Eno1YdYvWEmkSw9XaVTSiMgai7ulz0GOl5sSmW329BiJsBO+ly
         9f3DYL2sk90op5hYGBLOa6Fq5KVhphajTOgPfJDV6XsozFkD+ntZyP/r04QB8gFhnwhQ
         uqLxfFdNH2gvPCmjlTrAbWnxaJk0/3Z2KhujIFqnJ8G/vGYXB3GGsg2ZGhJigojJMLGG
         +BH2uxd3VMYdhIQufnPwgrx5DRYn5ELhzjKoIMIIQIyoceGrTQdLfk9so1NTgKPVoPPa
         PUxWi07EPQxzXTaeVsxxNRraW5Z8z8o9mPyQZ8OOJYfCumYAKUV7Mnq6rSJDF5nVqttK
         V/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=W0k6JZD8kjz+vTgXniNU5bsoejW224xb6dmKkwGLsAc=;
        b=gqWdrvz/xmsgxOU4f9hoiWGQ+52Zm840t3n3Pd7XctIPe1N0vKzLTYwdDyxqozNkFp
         EJQ6zF7kWTY4kLmR9HAPMHlXDSMupBwwC1hEMVqxsz98ypgSNeTQ/GMqVzGlruU8Jgj2
         NwKahjDa6H/tyKmeRZTWBDbHblbf10gEiuigd6AdenwQqllT4jur+0iEm0o7eMPUlyqE
         yiZZ7J3ZeJ1SX9Jggi5aHWraZuKUaM0WlvIeZggs9C5BTyEm/dTdbCn2RPHzdd1MEfSI
         jkXekpknhaUa6JLqd8s0i805SJV3h1wOJWk3SiVr/RK6NiYpNjF/Lj/yKpIw1+XCzyYA
         JiPQ==
X-Gm-Message-State: APjAAAW1ySMTvDOH3r0MdRf//VUIu4z588LZz9hdihUjvSfGYdnSjybK
        2g9e/dddgk/Bb2XmKaq3YNw=
X-Google-Smtp-Source: APXvYqwKj0W9ruYZkc9/m5NUDyFOSx+XNv2LdyHC+Jrsa6RJee4AlcPtwKsluHeKyx8RUWXbTyZYNQ==
X-Received: by 2002:a9d:27c6:: with SMTP id c64mr22032900otb.307.1573501255043;
        Mon, 11 Nov 2019 11:40:55 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o22sm5031002otk.47.2019.11.11.11.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 11:40:54 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 3/3] rtlwifi: rtl8192de: Fix missing enable interrupt flag
Date:   Mon, 11 Nov 2019 13:40:46 -0600
Message-Id: <20191111194046.26908-4-Larry.Finger@lwfinger.net>
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
new drivers"), the flag that indicates that interrupts are enabled was
never set.

In addition, there are several places when enable/disable interrupts
were commented out are restored. A sychronize_interrupts() call is
removed.

Fixes: 38506ecefab9 ("rtlwifi: rtl_pci: Start modification for new drivers")
Cc: Stable <stable@vger.kernel.org>	# v3.18+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index c7f29a9be50d..146fe144f5f5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -1176,6 +1176,7 @@ void rtl92de_enable_interrupt(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
+	rtlpci->irq_enabled = true;
 }
 
 void rtl92de_disable_interrupt(struct ieee80211_hw *hw)
@@ -1185,7 +1186,7 @@ void rtl92de_disable_interrupt(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	synchronize_irq(rtlpci->pdev->irq);
+	rtlpci->irq_enabled = false;
 }
 
 static void _rtl92de_poweroff_adapter(struct ieee80211_hw *hw)
@@ -1351,7 +1352,7 @@ void rtl92de_set_beacon_related_registers(struct ieee80211_hw *hw)
 
 	bcn_interval = mac->beacon_interval;
 	atim_window = 2;
-	/*rtl92de_disable_interrupt(hw);  */
+	rtl92de_disable_interrupt(hw);
 	rtl_write_word(rtlpriv, REG_ATIMWND, atim_window);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
 	rtl_write_word(rtlpriv, REG_BCNTCFG, 0x660f);
@@ -1371,9 +1372,9 @@ void rtl92de_set_beacon_interval(struct ieee80211_hw *hw)
 
 	RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
 		 "beacon_interval:%d\n", bcn_interval);
-	/* rtl92de_disable_interrupt(hw); */
+	rtl92de_disable_interrupt(hw);
 	rtl_write_word(rtlpriv, REG_BCN_INTERVAL, bcn_interval);
-	/* rtl92de_enable_interrupt(hw); */
+	rtl92de_enable_interrupt(hw);
 }
 
 void rtl92de_update_interrupt_mask(struct ieee80211_hw *hw,
-- 
2.23.0

