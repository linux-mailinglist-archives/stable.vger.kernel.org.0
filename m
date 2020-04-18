Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460561AF268
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgDRQn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 12:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgDRQn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 12:43:29 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D384DC061A0C;
        Sat, 18 Apr 2020 09:43:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so6636266wrs.9;
        Sat, 18 Apr 2020 09:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=iNg283N5W06QIOUQwrr2Mr28fG26BEGAnQLlw95W7Vk=;
        b=l4uwzmH+jB63wEowrpIUnU4NvYXXNyzkgm3JWMrire8H4Fyl7C7U+UXIK7Xt9fxuhY
         weY5EYdExkKjbUQ2bW/+ylqeBqJu5TLyetCQjiwLYxnOD31WMsm2Dx48jd4dgeUnHtgO
         /fukPtmyddwX/PrW5rH7o+3WevBP1qT7oPx4rfwKQy3sOUTYtvXop5cjTkuD1YDxjjlW
         H7ZRR6dE/PZeNL9/CfO90f+e7xK1E6YlV7cuvFSKNKf79d7mWexVWqkTa19igO7lUPbD
         yw/4GTxcQAffh4u0dPV9es/MCvJ59/+zAw98c71u8fsiZ9WrGwSTfw1xJAgYUwvurlWE
         8LvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=iNg283N5W06QIOUQwrr2Mr28fG26BEGAnQLlw95W7Vk=;
        b=bqGpIM7jCOYUHlkcdU0DGJ2DWfztoC4O+RALMJyvozdaJHh0lNCbw8JjY04hMXiJu0
         xGtCdbUqJS8qSFzyKmLA1ifAIz0VeDL+VWrU6OzESmmm8NU0YQEYfEdhFaWyLh+DVUW8
         EFSCIo8K1nTe2dr/3tRnecvy2dmYfdzDa8OQFU1OIxdnc1gKmE0qH9s047BFvCpsJ4Yj
         RzWBnh3wJmjPvJKYDHOG/v+Q/HvUQ2u/lb6LZSrDeOEYd37TUEb7RAcF98ptLyNcBhCw
         TwrTeFbe8AM5K0pU0JgjQ0ttmcpPk0owFb1plibFmf9cOhrMGZchyVqvGRF4SVxxwmyj
         ecKw==
X-Gm-Message-State: AGi0Publ51k/fGVdYWT6VIOJX8vQeXxfCGuloaCQo4w5ehvDFQpqFtwC
        q3DC/8+Ut/2L1yOlYnbuaIEQMTrp
X-Google-Smtp-Source: APiQypId+j/j49QIFvlMqBsMHGeD1CVJ88jDuC8ok/VU2cD12xD/KDvuO7yl6NvnrkAnOwTjg/uVTw==
X-Received: by 2002:adf:8b45:: with SMTP id v5mr10396563wra.175.1587228207209;
        Sat, 18 Apr 2020 09:43:27 -0700 (PDT)
Received: from [192.168.43.18] (188.29.165.57.threembb.co.uk. [188.29.165.57])
        by smtp.gmail.com with ESMTPSA id i97sm38784035wri.1.2020.04.18.09.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 09:43:26 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-wireless@vger.kernel.org,
        Oscar Carter <oscar.carter@gmx.com>, stable@vger.kernel.org
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6656: Fix drivers TBTT timing counter.
Message-ID: <375d0b25-e8bc-c8f7-9b10-6cc705d486ee@gmail.com>
Date:   Sat, 18 Apr 2020 17:43:24 +0100
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

The drivers TBTT counter is not synchronized with mac80211 timestamp.

Reorder the functions and use vnt_update_next_tbtt to do the final
synchronize.

Fixes: c15158797df6 ("staging: vt6656: implement TSF counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b2729d5eadfb..4213679345eb 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -762,12 +762,15 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			vnt_mac_reg_bits_on(priv, MAC_REG_TFTCTL,
 					    TFTCTL_TSFCNTREN);
 
-			vnt_adjust_tsf(priv, conf->beacon_rate->hw_value,
-				       conf->sync_tsf, priv->current_tsf);
-
 			vnt_mac_set_beacon_interval(priv, conf->beacon_int);
 
 			vnt_reset_next_tbtt(priv, conf->beacon_int);
+
+			vnt_adjust_tsf(priv, conf->beacon_rate->hw_value,
+				       conf->sync_tsf, priv->current_tsf);
+
+			vnt_update_next_tbtt(priv,
+					     conf->sync_tsf, conf->beacon_int);
 		} else {
 			vnt_clear_current_tsf(priv);
 
-- 
2.25.1
