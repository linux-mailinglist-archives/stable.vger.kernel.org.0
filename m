Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2411AF2DE
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 19:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgDRRhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 13:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgDRRhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 13:37:22 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AC6C061A0C;
        Sat, 18 Apr 2020 10:37:22 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y24so6413968wma.4;
        Sat, 18 Apr 2020 10:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kd5smkYSSB4FMGfeUinz8PyTLct8IRvqqCqI7WSgIBU=;
        b=m0YBAMO+WbOSfBzFNh/zTyWpfKuquX6JVZcYc1RO47R4U8ERmZkkp77mvErsv2TMNx
         AHnJWPahXlZRTaR3gKiIXUg5S0UU6XY0yM8HrzQOBA0ebNTbTzk1CKyuXm6nH+7Kwc+n
         yHoH6IffyFpAPWwPKG6R4Rd6lCiC7MWXDlWLJdRw3Un+Gf2DQsmMCL4TqLgZgCf0W7pj
         uwGWhJKD67nwdaciNeAxwx8afn8aG0s4dbCE4C7Mt2Plmx2f9YCi+BoPGNbMtJqeqiTs
         fAqyjV+X3NQXPQUji5TFPnQ+j0MSt/c4AJNtWbI0rt8SnZKQcxRdGmRJs9RaWhiy6Oe0
         tAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kd5smkYSSB4FMGfeUinz8PyTLct8IRvqqCqI7WSgIBU=;
        b=V31Q6/Pq73ojDWjPQFvH+3HPZydM52UPixImusLPvdN3ISEJ+tBdVZB2vXMTrsTqXd
         oFYqhESDjjB+FxjLxJqkMoOz+abQ9L3H0nfL9E4+Nel1b3ZpkuFuD8rmqRUIDKeTQRwI
         Xksqj5eM01adP69NJYqNvHx6Z0C99sQpVHl3LGXW4SNUS90qkgseHRHiLLxEA6xywaDB
         DV9/WUGRf8FtpyfMLQIPvald2HnJ3mvbFnWymzF7Ld8dde68KqlZDMFMsbNqQdt9Cz3V
         mg8hAoTU1IthM6lqEby+XIHl6bQ5g1LR6l0OeoUOOoDybriwZHylSmHFufSGWxiawrP2
         56KQ==
X-Gm-Message-State: AGi0PuZQPCgMsOhjtaTcWlcePHu9xZd18vz8CYH/9dZTDezp8c6CNlPP
        cSug5cZKo9l/Xp8lWjM+coQkPHV9
X-Google-Smtp-Source: APiQypLmOvCvSP1tOFtJN3HPdd0wH3K3oZRVBMMLldEYYyymUSSE1PdrjmMe/joQM3JgTjuqqDCilw==
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr9224669wmj.34.1587231441017;
        Sat, 18 Apr 2020 10:37:21 -0700 (PDT)
Received: from [192.168.43.18] (188.29.165.57.threembb.co.uk. [188.29.165.57])
        by smtp.gmail.com with ESMTPSA id q187sm12501075wma.41.2020.04.18.10.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:37:20 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-wireless@vger.kernel.org,
        Oscar Carter <oscar.carter@gmx.com>, stable@vger.kernel.org
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH ] staging: vt6656: Fix calling conditions of vnt_set_bss_mode
Message-ID: <44110801-6234-50d8-c583-9388f04b486c@gmail.com>
Date:   Sat, 18 Apr 2020 18:37:18 +0100
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
