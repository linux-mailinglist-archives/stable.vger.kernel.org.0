Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262D349A3DE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369039AbiAYAAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384807AbiAXXR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:17:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8C6C08B4E9;
        Mon, 24 Jan 2022 11:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10015B81188;
        Mon, 24 Jan 2022 19:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C465C340E8;
        Mon, 24 Jan 2022 19:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053409;
        bh=2w476mOJU7MWM/BdfYpZC7AEg+AEjB5Orgrjn+jLcw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7t81xr7wTSmyktLnV/CnCMVKSVatHp+f6j9hnL5S7ReOe8TsKF6bo20OywWyvsgF
         oHrfGNC9zB+cXYjpSRQ3clXmnN1pyShXlbqIZYdwJ2muZrnqZYf9h3YgZ2DKR5DOVn
         f8quT+m3babc2vjhOWqg+KmOFxTzWJujsLIRKuCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/563] wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan
Date:   Mon, 24 Jan 2022 19:37:00 +0100
Message-Id: <20220124184026.315778418@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Li <benl@squareup.com>

[ Upstream commit 8f1ba8b0ee2679f0b3d22d2a5c1bc70c436fd872 ]

An SMD capture from the downstream prima driver on WCN3680B shows the
following command sequence for connected scans:

- init_scan_req
    - start_scan_req, channel 1
    - end_scan_req, channel 1
    - start_scan_req, channel 2
    - ...
    - end_scan_req, channel 3
- finish_scan_req
- init_scan_req
    - start_scan_req, channel 4
    - ...
    - end_scan_req, channel 6
- finish_scan_req
- ...
    - end_scan_req, channel 165
- finish_scan_req

Upstream currently never calls wcn36xx_smd_end_scan, and in some cases[1]
still sends finish_scan_req twice in a row or before init_scan_req. A
typical connected scan looks like this:

- init_scan_req
    - start_scan_req, channel 1
- finish_scan_req
- init_scan_req
    - start_scan_req, channel 2
- ...
    - start_scan_req, channel 165
- finish_scan_req
- finish_scan_req

This patch cleans up scanning so that init/finish and start/end are always
paired together and correctly nested.

- init_scan_req
    - start_scan_req, channel 1
    - end_scan_req, channel 1
- finish_scan_req
- init_scan_req
    - start_scan_req, channel 2
    - end_scan_req, channel 2
- ...
    - start_scan_req, channel 165
    - end_scan_req, channel 165
- finish_scan_req

Note that upstream will not do batching of 3 active-probe scans before
returning to the operating channel, and this patch does not change that.
To match downstream in this aspect, adjust IEEE80211_PROBE_DELAY and/or
the 125ms max off-channel time in ieee80211_scan_state_decision.

[1]: commit d195d7aac09b ("wcn36xx: Ensure finish scan is not requested
before start scan") addressed one case of finish_scan_req being sent
without a preceding init_scan_req (the case of the operating channel
coinciding with the first scan channel); two other cases are:
1) if SW scan is started and aborted immediately, without scanning any
   channels, we send a finish_scan_req without ever sending init_scan_req,
   and
2) as SW scan logic always returns us to the operating channel before
   calling wcn36xx_sw_scan_complete, finish_scan_req is always sent twice
   at the end of a SW scan

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Benjamin Li <benl@squareup.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211027170306.555535-4-benl@squareup.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    | 34 +++++++++++++++++-----
 drivers/net/wireless/ath/wcn36xx/smd.c     |  4 +++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 629ddfd74da1a..9aaf6f7473333 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -397,6 +397,7 @@ static void wcn36xx_change_opchannel(struct wcn36xx *wcn, int ch)
 static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wcn36xx *wcn = hw->priv;
+	int ret;
 
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac config changed 0x%08x\n", changed);
 
@@ -412,17 +413,31 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
 			 * want to receive/transmit regular data packets, then
 			 * simply stop the scan session and exit PS mode.
 			 */
-			wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
-						wcn->sw_scan_vif);
-			wcn->sw_scan_channel = 0;
+			if (wcn->sw_scan_channel)
+				wcn36xx_smd_end_scan(wcn, wcn->sw_scan_channel);
+			if (wcn->sw_scan_init) {
+				wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
+							wcn->sw_scan_vif);
+			}
 		} else if (wcn->sw_scan) {
 			/* A scan is ongoing, do not change the operating
 			 * channel, but start a scan session on the channel.
 			 */
-			wcn36xx_smd_init_scan(wcn, HAL_SYS_MODE_SCAN,
-					      wcn->sw_scan_vif);
+			if (wcn->sw_scan_channel)
+				wcn36xx_smd_end_scan(wcn, wcn->sw_scan_channel);
+			if (!wcn->sw_scan_init) {
+				/* This can fail if we are unable to notify the
+				 * operating channel.
+				 */
+				ret = wcn36xx_smd_init_scan(wcn,
+							    HAL_SYS_MODE_SCAN,
+							    wcn->sw_scan_vif);
+				if (ret) {
+					mutex_unlock(&wcn->conf_mutex);
+					return -EIO;
+				}
+			}
 			wcn36xx_smd_start_scan(wcn, ch);
-			wcn->sw_scan_channel = ch;
 		} else {
 			wcn36xx_change_opchannel(wcn, ch);
 		}
@@ -709,7 +724,12 @@ static void wcn36xx_sw_scan_complete(struct ieee80211_hw *hw,
 	struct wcn36xx *wcn = hw->priv;
 
 	/* ensure that any scan session is finished */
-	wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN, wcn->sw_scan_vif);
+	if (wcn->sw_scan_channel)
+		wcn36xx_smd_end_scan(wcn, wcn->sw_scan_channel);
+	if (wcn->sw_scan_init) {
+		wcn36xx_smd_finish_scan(wcn, HAL_SYS_MODE_SCAN,
+					wcn->sw_scan_vif);
+	}
 	wcn->sw_scan = false;
 	wcn->sw_scan_opchannel = 0;
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 3793907ace92e..ad312e17f7a3c 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -730,6 +730,7 @@ int wcn36xx_smd_init_scan(struct wcn36xx *wcn, enum wcn36xx_hal_sys_mode mode,
 		wcn36xx_err("hal_init_scan response failed err=%d\n", ret);
 		goto out;
 	}
+	wcn->sw_scan_init = true;
 out:
 	mutex_unlock(&wcn->hal_mutex);
 	return ret;
@@ -760,6 +761,7 @@ int wcn36xx_smd_start_scan(struct wcn36xx *wcn, u8 scan_channel)
 		wcn36xx_err("hal_start_scan response failed err=%d\n", ret);
 		goto out;
 	}
+	wcn->sw_scan_channel = scan_channel;
 out:
 	mutex_unlock(&wcn->hal_mutex);
 	return ret;
@@ -790,6 +792,7 @@ int wcn36xx_smd_end_scan(struct wcn36xx *wcn, u8 scan_channel)
 		wcn36xx_err("hal_end_scan response failed err=%d\n", ret);
 		goto out;
 	}
+	wcn->sw_scan_channel = 0;
 out:
 	mutex_unlock(&wcn->hal_mutex);
 	return ret;
@@ -831,6 +834,7 @@ int wcn36xx_smd_finish_scan(struct wcn36xx *wcn,
 		wcn36xx_err("hal_finish_scan response failed err=%d\n", ret);
 		goto out;
 	}
+	wcn->sw_scan_init = false;
 out:
 	mutex_unlock(&wcn->hal_mutex);
 	return ret;
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 9b4dee2fc6483..5c40d0bdee245 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -231,6 +231,7 @@ struct wcn36xx {
 	struct cfg80211_scan_request *scan_req;
 	bool			sw_scan;
 	u8			sw_scan_opchannel;
+	bool			sw_scan_init;
 	u8			sw_scan_channel;
 	struct ieee80211_vif	*sw_scan_vif;
 	struct mutex		scan_lock;
-- 
2.34.1



