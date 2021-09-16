Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41B140E5D2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbhIPRPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348494AbhIPRHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1438E619A6;
        Thu, 16 Sep 2021 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810169;
        bh=EAyf2jJkKpNyVQn8baH9LqdwLIuSwECqxzBzNdR5l/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMad0c+sC3+CAMJXHawhk+2VPaYkdhNrg8EXbJ6TPvy9qWY2vlsSJQcIegNmzBvqp
         UnUVGN23U6+z3O4+VEDjOz31djiPijo7g4NdInpJdsLP4nT+tPbCRO+uAPI8EXlJV5
         pjsh4BSrd1jZz0N/X6s7rb7txwcBUnr7nt+4parw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Gates <jgates@squareup.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.14 042/432] wcn36xx: Ensure finish scan is not requested before start scan
Date:   Thu, 16 Sep 2021 17:56:31 +0200
Message-Id: <20210916155812.241335485@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Gates <jgates@squareup.com>

commit d195d7aac09bddabc2c8326fb02fcec2b0a2de02 upstream.

If the operating channel is the first in the scan list, it was seen that
a finish scan request would be sent before a start scan request was
sent, causing the firmware to fail all future scans. Track the current
channel being scanned to avoid requesting the scan finish before it
starts.

Cc: <stable@vger.kernel.org>
Fixes: 5973a2947430 ("wcn36xx: Fix software-driven scan")
Signed-off-by: Joseph Gates <jgates@squareup.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1629286303-13179-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    |    5 ++++-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -408,13 +408,14 @@ static int wcn36xx_config(struct ieee802
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
@@ -422,6 +423,7 @@ static int wcn36xx_config(struct ieee802
 			wcn36xx_smd_init_scan(wcn, HAL_SYS_MODE_SCAN,
 					      wcn->sw_scan_vif);
 			wcn36xx_smd_start_scan(wcn, ch);
+			wcn->sw_scan_channel = ch;
 		} else {
 			wcn36xx_change_opchannel(wcn, ch);
 		}
@@ -702,6 +704,7 @@ static void wcn36xx_sw_scan_start(struct
 
 	wcn->sw_scan = true;
 	wcn->sw_scan_vif = vif;
+	wcn->sw_scan_channel = 0;
 	if (vif_priv->sta_assoc)
 		wcn->sw_scan_opchannel = WCN36XX_HW_CHANNEL(wcn);
 	else
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -246,6 +246,7 @@ struct wcn36xx {
 	struct cfg80211_scan_request *scan_req;
 	bool			sw_scan;
 	u8			sw_scan_opchannel;
+	u8			sw_scan_channel;
 	struct ieee80211_vif	*sw_scan_vif;
 	struct mutex		scan_lock;
 	bool			scan_aborted;


