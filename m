Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B891AF2E1
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 19:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgDRRhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 13:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgDRRhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 13:37:38 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB9DC061A0C;
        Sat, 18 Apr 2020 10:37:38 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so6418837wml.2;
        Sat, 18 Apr 2020 10:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kd5smkYSSB4FMGfeUinz8PyTLct8IRvqqCqI7WSgIBU=;
        b=NuegS+6RU6ia5geEkqb5kLREoT0jq0nUGis6p1b9XDHVbMAwKxa3ZGYieIlqBtIfzt
         cAYjqY8Vy0CpSgf/GWrNZp5teinkmGXZKGyswMKqt2r/tzMa/53Y0ar2yYsvdTh0LfXL
         rgsbj3CMiA3xS3IEISmciPQFV/NQ5qpwCLgOnQg683wwQ5WBaiEA9XzZ5t4kbOmnJSEF
         JGQAaE/wx1hvD0JZtbrUDYrJeGWeWIIAx1ruNcX27W89IEps9/Uil8Dfv16gFAsACMj4
         5i5MzOKPDECSE5BDBY7f9eBfLy15DaKLTh/BwzAS0MkSrXTBHXuYsELn0hMVMWC6lQL0
         uplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kd5smkYSSB4FMGfeUinz8PyTLct8IRvqqCqI7WSgIBU=;
        b=ruER2of7ppau4428jtdNzFoUfOOWyZmF/bBnrtFyfS/o/bmrZUpDK35nwJSQQ7r0KP
         zr6xYOLvda70EsIdL5Q0ylySA1JgrjtnDBAYgK7EL0JBXhtp1nrhvvpQmSLTIDtK4kOE
         CwCboBmpKcL8mLDr8Ql1PlUfS/92ttpTVlJvfDRgpruttzZ375D+WSC/ZCFoAgFgpTRU
         8PHNVuYeHNGaSdhNj+lQSvwl5IQc8Oey8DNkDHRc+3wGvZbe61Hq0+Xm7aYInPTfn/RB
         xyP4Zbj6UYoMsv6f3+w78tNzBsNU3DqCm3F8pPl9x6NbqpKY6lk/zYqMzFsCSpQ9Ecxz
         O1+A==
X-Gm-Message-State: AGi0PuZed3zytQ2/MK7yQCytTNcsh2yh5UHZn+JQD1r9bIsopW3CBVsK
        5wF0WIQzQczgZ7+wdLyVAPykobB3
X-Google-Smtp-Source: APiQypIY70su8W+ZNnjqvova5Wr4ao3gpM7K7eZKfG1Rg0ssq+ak32kSc0NvFKqyax3G/SUvXbiWxw==
X-Received: by 2002:a1c:b144:: with SMTP id a65mr9733624wmf.54.1587231456994;
        Sat, 18 Apr 2020 10:37:36 -0700 (PDT)
Received: from [192.168.43.18] (188.29.165.57.threembb.co.uk. [188.29.165.57])
        by smtp.gmail.com with ESMTPSA id s8sm6929138wru.38.2020.04.18.10.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:37:36 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-wireless@vger.kernel.org,
        Oscar Carter <oscar.carter@gmx.com>, stable@vger.kernel.org
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH ] staging: vt6656: Fix calling conditions of vnt_set_bss_mode
Message-ID: <c64e7134-c1a1-ecd1-1e0c-e0bfe002740b@gmail.com>
Date:   Sat, 18 Apr 2020 18:37:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

vnt_set_bss_mode needs to be called on all changes to BSS_CHANGED_BASIC_RATES,
BSS_CHANGED_ERP_PREAMBLE and BSS_CHANGED_ERP_SLOT

Remove all other calls and vnt_update_ifs which is called in vnt_set_bss_mode.

Fixes an issue that preamble mode is not being updated correctly.

Fixes: c12603576e06 ("staging: vt6656: Only call vnt_set_bss_mode on basic rates change.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fcd0fe5e6d72..85d4133315b1 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -625,8 +625,6 @@ static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	priv->op_mode = vif->type;
 
-	vnt_set_bss_mode(priv);
-
 	/* LED blink on TX */
 	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_INTER);
 
@@ -706,7 +704,6 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		priv->basic_rates = conf->basic_rates;
 
 		vnt_update_top_rates(priv);
-		vnt_set_bss_mode(priv);
 
 		dev_dbg(&priv->usb->dev, "basic rates %x\n", conf->basic_rates);
 	}
@@ -735,11 +732,14 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			priv->short_slot_time = false;
 
 		vnt_set_short_slot_time(priv);
-		vnt_update_ifs(priv);
 		vnt_set_vga_gain_offset(priv, priv->bb_vga[0]);
 		vnt_update_pre_ed_threshold(priv, false);
 	}
 
+	if (changed & (BSS_CHANGED_BASIC_RATES | BSS_CHANGED_ERP_PREAMBLE |
+		       BSS_CHANGED_ERP_SLOT))
+		vnt_set_bss_mode(priv);
+
 	if (changed & (BSS_CHANGED_TXPOWER | BSS_CHANGED_BANDWIDTH))
 		vnt_rf_setpower(priv, conf->chandef.chan);
 
-- 
2.25.1
