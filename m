Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A928C3F028A
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 13:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhHRLWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 07:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbhHRLWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 07:22:17 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A012AC061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 04:21:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z9so2905378wrh.10
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 04:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Um/2sZ3CB494B6HeG+9P8o7byJNXyi5wGDTtlcjbk+s=;
        b=hcrnhKgaO1CHkap09gVEmCMFB9lXUXpNfHvCPihvFm+vJF/IZuGVQ6KA4qHI0rL4VH
         iasHqMhp1iabAu6WVi6Hgi1a5Ug/P3O2ZoDXN3D/bq60ILjYpTR+aD0vr9AAnilWvGQK
         KRcxvnESm/jgjZmTjVgIvBudMZwcCoeUjq0tS4i/+cqd9yNQ3nEjMeYsY3J7mBCaZf3T
         vjREA1hqXObyhTrbTjehllRbF7GN17WhVnl2KjNEJHgKulS8hR3LZaThGWAYIqmhxaZU
         bADSHIE+4D+RGdFhtLQN+vdEsH4BrlRheh+Fr+0wzPoOgCcRFZRyfg5VtKNCkvJ/GRzy
         LRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Um/2sZ3CB494B6HeG+9P8o7byJNXyi5wGDTtlcjbk+s=;
        b=rWNm8l4lH76XDR0WAur/BXMkSm8g6vcbX1D4LVRo0yqBpKF2kga+gZFGvQ9ywDcbZu
         bXa/H4nnTdhUIYyXtUAqRi4Uuf0adQQdI7rIRCRLgE+Hk9k37m65zXEk6VTpog0RxPv9
         mGcK5btMGDhBpxeg3oICEL6Djy55LocU+n0bKuYzAqNUVmlJIXw1KGWy8c3VWEc2OJYE
         QXjk7OaaLtfD5chH54tnW354HdWULUVWSkZaW0V0PvSWEMLktdwrZZngqOMwS6T9Xt4+
         GuyBr1u/rc/VcHUPIYHzHkMWrRG+zc6BQ7iX8yFL22LXDm66UWN9kbUT7ovQbxa8b0cP
         hKgA==
X-Gm-Message-State: AOAM531U44GK/S3BYMrjlV11KhjQlARAnTVzDEeiAyihilM1JpmHUT/R
        XkgspPeg590rZnnxJs1Ulx3NdQ==
X-Google-Smtp-Source: ABdhPJzQ/jynJGWIh+7IAo8D7U1jUkqkL3mh2SBtAj15V9XxmKfBdFtfXVBJm/9JSE112jnbYGcZ4g==
X-Received: by 2002:a5d:4d03:: with SMTP id z3mr10058223wrt.229.1629285701121;
        Wed, 18 Aug 2021 04:21:41 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id e4sm5744270wrw.74.2021.08.18.04.21.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Aug 2021 04:21:40 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     bryan.odonoghue@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Joseph Gates <jgates@squareup.com>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: Ensure finish scan is not requested before start scan
Date:   Wed, 18 Aug 2021 13:31:43 +0200
Message-Id: <1629286303-13179-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Gates <jgates@squareup.com>

If the operating channel is the first in the scan list, it was seen that
a finish scan request would be sent before a start scan request was
sent, causing the firmware to fail all future scans. Track the current
channel being scanned to avoid requesting the scan finish before it
starts.

Cc: <stable@vger.kernel.org>
Fixes: 5973a2947430 ("wcn36xx: Fix software-driven scan")
Signed-off-by: Joseph Gates <jgates@squareup.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    | 5 ++++-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index dabed4e..e8c772a 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -405,13 +405,14 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
 		wcn36xx_dbg(WCN36XX_DBG_MAC, "wcn36xx_config channel switch=%d\n",
 			    ch);
 
-		if (wcn->sw_scan_opchannel == ch) {
+		if (wcn->sw_scan_opchannel == ch && wcn->sw_scan_channel) {
 			/* If channel is the initial operating channel, we may
 			 * want to receive/transmit regular data packets, then
 			 * simply stop the scan session and exit PS mode.
 			 */
 			wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
 						wcn->sw_scan_vif);
+			wcn->sw_scan_channel = 0;
 		} else if (wcn->sw_scan) {
 			/* A scan is ongoing, do not change the operating
 			 * channel, but start a scan session on the channel.
@@ -419,6 +420,7 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
 			wcn36xx_smd_init_scan(wcn, HAL_SYS_MODE_SCAN,
 					      wcn->sw_scan_vif);
 			wcn36xx_smd_start_scan(wcn, ch);
+			wcn->sw_scan_channel = ch;
 		} else {
 			wcn36xx_change_opchannel(wcn, ch);
 		}
@@ -699,6 +701,7 @@ static void wcn36xx_sw_scan_start(struct ieee80211_hw *hw,
 
 	wcn->sw_scan = true;
 	wcn->sw_scan_vif = vif;
+	wcn->sw_scan_channel = 0;
 	if (vif_priv->sta_assoc)
 		wcn->sw_scan_opchannel = WCN36XX_HW_CHANNEL(wcn);
 	else
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 71fa999..d0fcce8 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -232,6 +232,7 @@ struct wcn36xx {
 	struct cfg80211_scan_request *scan_req;
 	bool			sw_scan;
 	u8			sw_scan_opchannel;
+	u8			sw_scan_channel;
 	struct ieee80211_vif	*sw_scan_vif;
 	struct mutex		scan_lock;
 	bool			scan_aborted;
-- 
2.7.4

