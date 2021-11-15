Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B7E4526CD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347814AbhKPCKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239371AbhKOSAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:00:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7897F63340;
        Mon, 15 Nov 2021 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997782;
        bh=z4PKjB7ebCJ+VGxdl51ILH41JYTL3Ocv8DnqqVmq9LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHzGMDw8+HNxWdPkZ2dM0hFc4Zx4zQBYuPWnanLgtafNKj0iYMvTv+gLJ64Vu+P3A
         XZ7IvtEXutQ1H3u3CzEQ/Gci83M5eAa96oERreEGKqdTK56LPlmz5QcIoo2MoT1D2o
         xxOTgZOQpGo0EZEpS5n5wzAi1ypmPTqwyCySpWZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Benjamin Li <benl@squareup.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/575] wcn36xx: Fix Antenna Diversity Switching
Date:   Mon, 15 Nov 2021 17:59:58 +0100
Message-Id: <20211115165353.213626242@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 701668d3bfa03dabc5095fc383d5315544ee5b31 ]

We have been tracking a strange bug with Antenna Diversity Switching (ADS)
on wcn3680b for a while.

ADS is configured like this:
   A. Via a firmware configuration table baked into the NV area.
       1. Defines if ADS is enabled.
       2. Defines which GPIOs are connected to which antenna enable pin.
       3. Defines which antenna/GPIO is primary and which is secondary.

   B. WCN36XX_CFG_VAL(ANTENNA_DIVERSITY, N)
      N is a bitmask of available antenna.

      Setting N to 3 indicates a bitmask of enabled antenna (1 | 2).

      Obviously then we can set N to 1 or N to 2 to fix to a particular
      antenna and disable antenna diversity.

   C. WCN36XX_CFG_VAL(ASD_PROBE_INTERVAL, XX)
      XX is the number of beacons between each antenna RSSI check.
      Setting this value to 50 means, every 50 received beacons, run the
      ADS algorithm.

   D. WCN36XX_CFG_VAL(ASD_TRIGGER_THRESHOLD, YY)
      YY is a two's complement integer which specifies the RSSI decibel
      threshold below which ADS will run.
      We default to -60db here, meaning a measured RSSI <= -60db will
      trigger an ADS probe.

   E. WCN36XX_CFG_VAL(ASD_RTT_RSSI_HYST_THRESHOLD, Z)
      Z is a hysteresis value, indicating a delta which the RSSI must
      exceed for the antenna switch to be valid.

      For example if HYST_THRESHOLD == 3 AntennaId1-RSSI == -60db and
      AntennaId-2-RSSI == -58db then firmware will not switch antenna.
      The threshold needs to be -57db or better to satisfy the criteria.

   F. A firmware feature bit also exists ANTENNA_DIVERSITY_SELECTION.
      This feature bit is used by the firmware to report if
      ANTENNA_DIVERSITY_SELECTION is supported. The host is not required to
      toggle this bit to enable or disable ADS.

ADS works like this:

    A. Every XX beacons the firmware switches to or remains on the primary
       antenna.

    B. The firmware then sends a Request-To-Send (RTS) packet to the AP.

    C. The firmware waits for a Clear-To-Send (CTS) response from the AP.

    D. The firmware then notes the received RSSI on the CTS packet.

    E. The firmware then repeats steps A-D on the secondary antenna.

    F. Subsequently if the RSSI on the measured antenna is better than
       ASD_TRIGGER_THRESHOLD + the active antenna's RSSI then the
       measured antenna becomes the active antenna.

    G. If RSSI rises past ASD_TRIGGER_THRESHOLD then ADS doesn't run at
       all even if there is a substantially better RSSI on the alternative
       antenna.

What we have been observing is that the RTS packet is being sent but the
MAC address is a byte-swapped version of the target MAC. The ADS/RTS MAC is
corrupted only when the link is encrypted, if the AP is open the RTS MAC is
correct. Similarly if we configure the firmware to an RTS/CTS sequence for
regular data - the transmitted RTS MAC is correctly formatted.

Internally the wcn36xx firmware uses the indexes in the SMD commands to
populate and extract data from specific entries in an STA lookup table. The
AP's MAC appears a number of times in different indexes within this lookup
table, so the MAC address extracted for the data-transmit RTS and the MAC
address extracted for the ADS/RTS packet are not the same STA table index.

Our analysis indicates the relevant firmware STA table index is
"bssSelfStaIdx".

There is an STA populate function responsible for formatting the MAC
address of the bssSelfStaIdx including byte-swapping the MAC address.

Its clear then that the required STA populate command did not run for
bssSelfStaIdx.

So taking a look at the sequence of SMD commands sent to the firmware we
see the following downstream when moving from an unencrypted to encrypted
BSS setup.

- WLAN_HAL_CONFIG_BSS_REQ
- WLAN_HAL_CONFIG_STA_REQ
- WLAN_HAL_SET_STAKEY_REQ

Upstream in wcn36xx we have

- WLAN_HAL_CONFIG_BSS_REQ
- WLAN_HAL_SET_STAKEY_REQ

The solution then is to add the missing WLAN_HAL_CONFIG_STA_REQ between
WLAN_HAL_CONFIG_BSS_REQ and WLAN_HAL_SET_STAKEY_REQ.

No surprise WLAN_HAL_CONFIG_STA_REQ is the routine responsible for
populating the STA lookup table in the firmware and once done the MAC sent
by the ADS routine is in the correct byte-order.

This bug is apparent with ADS but it is also the case that any other
firmware routine that depends on the "bssSelfStaIdx" would retrieve
malformed data on an encrypted link.

Fixes: 3e977c5c523d ("wcn36xx: Define wcn3680 specific firmware parameters")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Benjamin Li <benl@squareup.com>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210909144428.2564650-2-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 883534125df10..629ddfd74da1a 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -568,12 +568,14 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags) {
 			sta_priv->is_data_encrypted = true;
 			/* Reconfigure bss with encrypt_type */
-			if (NL80211_IFTYPE_STATION == vif->type)
+			if (NL80211_IFTYPE_STATION == vif->type) {
 				wcn36xx_smd_config_bss(wcn,
 						       vif,
 						       sta,
 						       sta->addr,
 						       true);
+				wcn36xx_smd_config_sta(wcn, vif, sta);
+			}
 
 			wcn36xx_smd_set_stakey(wcn,
 				vif_priv->encrypt_type,
-- 
2.33.0



