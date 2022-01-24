Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4066499681
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359481AbiAXVEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51218 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359437AbiAXU6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:58:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB3D860B28;
        Mon, 24 Jan 2022 20:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A512AC340E5;
        Mon, 24 Jan 2022 20:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057899;
        bh=KNx+81XLGMGGQOWm3ipy3nUWBHABpFfh8FamoSzrYhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Er3iSV1Nya/0t4UynVzACFwr5pbYaqS2SdC7H/QYlL22eQxnvKVDbCa8rhVeAlSMG
         8ft5BRas7I4XjlkcMkxUKV1FMxgRGdJq0b94OwFDkWxiZ6lcHH5RY4wxtRpTVYVTT+
         u01pyyMdRvwIRaS/PoIHJ955FCyu3WAOubq6pHNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0114/1039] wcn36xx: populate band before determining rate on RX
Date:   Mon, 24 Jan 2022 19:31:43 +0100
Message-Id: <20220124184128.961150656@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Li <benl@squareup.com>

[ Upstream commit c9c5608fafe4dae975c9644c7d14c51ad3b0ed73 ]

status.band is used in determination of status.rate -- for 5GHz on legacy
rates there is a linear shift between the BD descriptor's rate field and
the wcn36xx driver's rate table (wcn_5ghz_rates).

We have a special clause to populate status.band for hardware scan offload
frames. However, this block occurs after status.rate is already populated.
Correctly handle this dependency by moving the band block before the rate
block.

This patch addresses kernel warnings & missing scan results for 5GHz APs
that send their beacons/probe responses at the higher four legacy rates
(24-54 Mbps), when using hardware scan offload:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:4532 ieee80211_rx_napi+0x744/0x8d8
  Modules linked in: wcn36xx [...]
  CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         4.19.107-g73909fa #1
  Hardware name: Square, Inc. T2 (all variants) (DT)
  Call trace:
  dump_backtrace+0x0/0x148
  show_stack+0x14/0x1c
  dump_stack+0xb8/0xf0
  __warn+0x2ac/0x2d8
  warn_slowpath_null+0x44/0x54
  ieee80211_rx_napi+0x744/0x8d8
  ieee80211_tasklet_handler+0xa4/0xe0
  tasklet_action_common+0xe0/0x118
  tasklet_action+0x20/0x28
  __do_softirq+0x108/0x1ec
  irq_exit+0xd4/0xd8
  __handle_domain_irq+0x84/0xbc
  gic_handle_irq+0x4c/0xb8
  el1_irq+0xe8/0x190
  lpm_cpuidle_enter+0x220/0x260
  cpuidle_enter_state+0x114/0x1c0
  cpuidle_enter+0x34/0x48
  do_idle+0x150/0x268
  cpu_startup_entry+0x20/0x24
  rest_init+0xd4/0xe0
  start_kernel+0x398/0x430
  ---[ end trace ae28cb759352b403 ]---

Fixes: 8a27ca394782 ("wcn36xx: Correct band/freq reporting on RX")
Signed-off-by: Benjamin Li <benl@squareup.com>
Tested-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211104010548.1107405-2-benl@squareup.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 37 +++++++++++++------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 75951ccbc840e..f0a9f069a92a9 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -314,8 +314,6 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 	fc = __le16_to_cpu(hdr->frame_control);
 	sn = IEEE80211_SEQ_TO_SN(__le16_to_cpu(hdr->seq_ctrl));
 
-	status.freq = WCN36XX_CENTER_FREQ(wcn);
-	status.band = WCN36XX_BAND(wcn);
 	status.mactime = 10;
 	status.signal = -get_rssi0(bd);
 	status.antenna = 1;
@@ -327,6 +325,25 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 
 	wcn36xx_dbg(WCN36XX_DBG_RX, "status.flags=%x\n", status.flag);
 
+	if (bd->scan_learn) {
+		/* If packet originate from hardware scanning, extract the
+		 * band/channel from bd descriptor.
+		 */
+		u8 hwch = (bd->reserved0 << 4) + bd->rx_ch;
+
+		if (bd->rf_band != 1 && hwch <= sizeof(ab_rx_ch_map) && hwch >= 1) {
+			status.band = NL80211_BAND_5GHZ;
+			status.freq = ieee80211_channel_to_frequency(ab_rx_ch_map[hwch - 1],
+								     status.band);
+		} else {
+			status.band = NL80211_BAND_2GHZ;
+			status.freq = ieee80211_channel_to_frequency(hwch, status.band);
+		}
+	} else {
+		status.band = WCN36XX_BAND(wcn);
+		status.freq = WCN36XX_CENTER_FREQ(wcn);
+	}
+
 	if (bd->rate_id < ARRAY_SIZE(wcn36xx_rate_table)) {
 		rate = &wcn36xx_rate_table[bd->rate_id];
 		status.encoding = rate->encoding;
@@ -353,22 +370,6 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 	    ieee80211_is_probe_resp(hdr->frame_control))
 		status.boottime_ns = ktime_get_boottime_ns();
 
-	if (bd->scan_learn) {
-		/* If packet originates from hardware scanning, extract the
-		 * band/channel from bd descriptor.
-		 */
-		u8 hwch = (bd->reserved0 << 4) + bd->rx_ch;
-
-		if (bd->rf_band != 1 && hwch <= sizeof(ab_rx_ch_map) && hwch >= 1) {
-			status.band = NL80211_BAND_5GHZ;
-			status.freq = ieee80211_channel_to_frequency(ab_rx_ch_map[hwch - 1],
-								     status.band);
-		} else {
-			status.band = NL80211_BAND_2GHZ;
-			status.freq = ieee80211_channel_to_frequency(hwch, status.band);
-		}
-	}
-
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 
 	if (ieee80211_is_beacon(hdr->frame_control)) {
-- 
2.34.1



