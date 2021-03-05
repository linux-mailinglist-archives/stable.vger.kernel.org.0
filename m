Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B8532EB15
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhCEMl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhCEMld (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD7176501F;
        Fri,  5 Mar 2021 12:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948093;
        bh=THECPWbjLSGXouHoFpAS+LioW/esMkbcAromSz3Gjvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWogRRtspOOEyVbhV0QvaZRVVvnUBqx1WHZY92sqYENo3s5ArFitruC5KG3ItPV0v
         vKrzvIemQ2lH+Q4jiQL/YmOiyb1KrpdXEKj70JmV4pMD/5D1Nuzw5GUH0VVdtn2i3E
         ZxP6AOg5ljMiH1ATmToymhjHqKFb/ZGuoaKmP9jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raz Bouganim <r-bouganim@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/41] wlcore: Fix command execute failure 19 for wl12xx
Date:   Fri,  5 Mar 2021 13:22:33 +0100
Message-Id: <20210305120852.573830300@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit cb88d01b67383a095e3f7caeb4cdade5a6cf0417 ]

We can currently get a "command execute failure 19" error on beacon loss
if the signal is weak:

wlcore: Beacon loss detected. roles:0xff
wlcore: Connection loss work (role_id: 0).
...
wlcore: ERROR command execute failure 19
...
WARNING: CPU: 0 PID: 1552 at drivers/net/wireless/ti/wlcore/main.c:803
...
(wl12xx_queue_recovery_work.part.0 [wlcore])
(wl12xx_cmd_role_start_sta [wlcore])
(wl1271_op_bss_info_changed [wlcore])
(ieee80211_prep_connection [mac80211])

Error 19 is defined as CMD_STATUS_WRONG_NESTING from the wlcore firmware,
and seems to mean that the firmware no longer wants to see the quirk
handling for WLCORE_QUIRK_START_STA_FAILS done.

This quirk got added with commit 18eab430700d ("wlcore: workaround
start_sta problem in wl12xx fw"), and it seems that this already got fixed
in the firmware long time ago back in 2012 as wl18xx never had this quirk
in place to start with.

As we no longer even support firmware that early, to me it seems that it's
safe to just drop WLCORE_QUIRK_START_STA_FAILS to fix the error. Looks
like earlier firmware got disabled back in 2013 with commit 0e284c074ef9
("wl12xx: increase minimum singlerole firmware version required").

If it turns out we still need WLCORE_QUIRK_START_STA_FAILS with any
firmware that the driver works with, we can simply revert this patch and
add extra checks for firmware version used.

With this fix wlcore reconnects properly after a beacon loss.

Cc: Raz Bouganim <r-bouganim@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210115065613.7731-1-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl12xx/main.c   |  3 ---
 drivers/net/wireless/ti/wlcore/main.c   | 15 +--------------
 drivers/net/wireless/ti/wlcore/wlcore.h |  3 ---
 3 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 22009e14a8fc..9bd635ec7827 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -648,7 +648,6 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
-			      WLCORE_QUIRK_START_STA_FAILS |
 			      WLCORE_QUIRK_AP_ZERO_SESSION_ID;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
@@ -672,7 +671,6 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
-			      WLCORE_QUIRK_START_STA_FAILS |
 			      WLCORE_QUIRK_AP_ZERO_SESSION_ID;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
@@ -701,7 +699,6 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
-			      WLCORE_QUIRK_START_STA_FAILS |
 			      WLCORE_QUIRK_AP_ZERO_SESSION_ID;
 
 		wlcore_set_min_fw_ver(wl, WL128X_CHIP_VER,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 17d32ce5d16b..a973dac456be 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2833,21 +2833,8 @@ static int wlcore_join(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	if (is_ibss)
 		ret = wl12xx_cmd_role_start_ibss(wl, wlvif);
-	else {
-		if (wl->quirks & WLCORE_QUIRK_START_STA_FAILS) {
-			/*
-			 * TODO: this is an ugly workaround for wl12xx fw
-			 * bug - we are not able to tx/rx after the first
-			 * start_sta, so make dummy start+stop calls,
-			 * and then call start_sta again.
-			 * this should be fixed in the fw.
-			 */
-			wl12xx_cmd_role_start_sta(wl, wlvif);
-			wl12xx_cmd_role_stop_sta(wl, wlvif);
-		}
-
+	else
 		ret = wl12xx_cmd_role_start_sta(wl, wlvif);
-	}
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 1827546ba807..34f0ba17fac9 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -557,9 +557,6 @@ wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 /* Each RX/TX transaction requires an end-of-transaction transfer */
 #define WLCORE_QUIRK_END_OF_TRANSACTION		BIT(0)
 
-/* the first start_role(sta) sometimes doesn't work on wl12xx */
-#define WLCORE_QUIRK_START_STA_FAILS		BIT(1)
-
 /* wl127x and SPI don't support SDIO block size alignment */
 #define WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN		BIT(2)
 
-- 
2.30.1



