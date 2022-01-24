Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A42E4996BA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348531AbiAXVGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54560 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443972AbiAXU7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:59:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74EA2B811A9;
        Mon, 24 Jan 2022 20:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12CEC340E5;
        Mon, 24 Jan 2022 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057978;
        bh=cdNwSonj5VNSzh2UcDs3FM0H8dMbYOowL2ixBHf52k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tag845MWwwZ54DRXIYiu6hiBBUhALNS14GlxUDT89jNPESHKQ06+/mFiKc6oeCNFv
         TP4BlL4lvv6DdQmnVjAf8MOk4nbDasFR/InzNXjWxil3/x/LbKjBQf7QOmN//To8Ay
         hZlHbz/RKy78Bd+uCF8vI+Xn3KRDxPxZRTRPQHDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0141/1039] ath11k: Fix ETSI regd with weather radar overlap
Date:   Mon, 24 Jan 2022 19:32:10 +0100
Message-Id: <20220124184129.915234920@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 086c921a354089f209318501038d43c98d3f409f ]

Some ETSI countries have a small overlap in the wireless-regdb with an ETSI
channel (5590-5650). A good example is Australia:

  country AU: DFS-ETSI
  	(2400 - 2483.5 @ 40), (36)
  	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
  	(5250 - 5350 @ 80), (20), NO-OUTDOOR, AUTO-BW, DFS
  	(5470 - 5600 @ 80), (27), DFS
  	(5650 - 5730 @ 80), (27), DFS
  	(5730 - 5850 @ 80), (36)
  	(57000 - 66000 @ 2160), (43), NO-OUTDOOR

If the firmware (or the BDF) is shipped with these rules then there is only
a 10 MHz overlap with the weather radar:

* below: 5470 - 5590
* weather radar: 5590 - 5600
* above: (none for the rule "5470 - 5600 @ 80")

There are several wrong assumption in the ath11k code:

* there is always a valid range below the weather radar
  (actually: there could be no range below the weather radar range OR range
   could be smaller than 20 MHz)
* intersected range in the weather radar range is valid
  (actually: the range could be smaller than 20 MHz)
* range above weather radar is either empty or valid
  (actually: the range could be smaller than 20 MHz)

These wrong assumption will lead in this example to a rule

  (5590 - 5600 @ 20), (N/A, 27), (600000 ms), DFS, AUTO-BW

which is invalid according to is_valid_reg_rule() because the freq_diff is
only 10 MHz but the max_bandwidth is set to 20 MHz. Which results in a
rejection like:

  WARNING: at backports-20210222_001-4.4.60-b157d2276/net/wireless/reg.c:3984
  [...]
  Call trace:
  [<ffffffbffc3d2e50>] reg_get_max_bandwidth+0x300/0x3a8 [cfg80211]
  [<ffffffbffc3d3d0c>] regulatory_set_wiphy_regd_sync+0x3c/0x98 [cfg80211]
  [<ffffffbffc651598>] ath11k_regd_update+0x1a8/0x210 [ath11k]
  [<ffffffbffc652108>] ath11k_regd_update_work+0x18/0x20 [ath11k]
  [<ffffffc0000a93e0>] process_one_work+0x1f8/0x340
  [<ffffffc0000a9784>] worker_thread+0x25c/0x448
  [<ffffffc0000aedc8>] kthread+0xd0/0xd8
  [<ffffffc000085550>] ret_from_fork+0x10/0x40
  ath11k c000000.wifi: failed to perform regd update : -22
  Invalid regulatory domain detected

To avoid this, the algorithm has to be changed slightly. Instead of
splitting a rule which overlaps with the weather radar range into 3 pieces
and accepting the first two parts blindly, it must actually be checked for
each piece whether it is a valid range. And only if it is valid, add it to
the output array.

When these checks are in place, the processed rules for AU would end up as

  country AU: DFS-ETSI
          (2400 - 2483 @ 40), (N/A, 36), (N/A)
          (5150 - 5250 @ 80), (6, 23), (N/A), NO-OUTDOOR, AUTO-BW
          (5250 - 5350 @ 80), (6, 20), (0 ms), NO-OUTDOOR, DFS, AUTO-BW
          (5470 - 5590 @ 80), (6, 27), (0 ms), DFS, AUTO-BW
          (5650 - 5730 @ 80), (6, 27), (0 ms), DFS, AUTO-BW
          (5730 - 5850 @ 80), (6, 36), (N/A), AUTO-BW

and will be accepted by the wireless regulatory code.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211112153116.1214421-1-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/reg.c | 103 ++++++++++++++------------
 1 file changed, 56 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index a66b5bdd21679..8606170ba80d5 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -456,6 +456,9 @@ ath11k_reg_adjust_bw(u16 start_freq, u16 end_freq, u16 max_bw)
 {
 	u16 bw;
 
+	if (end_freq <= start_freq)
+		return 0;
+
 	bw = end_freq - start_freq;
 	bw = min_t(u16, bw, max_bw);
 
@@ -463,8 +466,10 @@ ath11k_reg_adjust_bw(u16 start_freq, u16 end_freq, u16 max_bw)
 		bw = 80;
 	else if (bw >= 40 && bw < 80)
 		bw = 40;
-	else if (bw < 40)
+	else if (bw >= 20 && bw < 40)
 		bw = 20;
+	else
+		bw = 0;
 
 	return bw;
 }
@@ -488,73 +493,77 @@ ath11k_reg_update_weather_radar_band(struct ath11k_base *ab,
 				     struct cur_reg_rule *reg_rule,
 				     u8 *rule_idx, u32 flags, u16 max_bw)
 {
+	u32 start_freq;
 	u32 end_freq;
 	u16 bw;
 	u8 i;
 
 	i = *rule_idx;
 
+	/* there might be situations when even the input rule must be dropped */
+	i--;
+
+	/* frequencies below weather radar */
 	bw = ath11k_reg_adjust_bw(reg_rule->start_freq,
 				  ETSI_WEATHER_RADAR_BAND_LOW, max_bw);
+	if (bw > 0) {
+		i++;
 
-	ath11k_reg_update_rule(regd->reg_rules + i, reg_rule->start_freq,
-			       ETSI_WEATHER_RADAR_BAND_LOW, bw,
-			       reg_rule->ant_gain, reg_rule->reg_power,
-			       flags);
+		ath11k_reg_update_rule(regd->reg_rules + i,
+				       reg_rule->start_freq,
+				       ETSI_WEATHER_RADAR_BAND_LOW, bw,
+				       reg_rule->ant_gain, reg_rule->reg_power,
+				       flags);
 
-	ath11k_dbg(ab, ATH11K_DBG_REG,
-		   "\t%d. (%d - %d @ %d) (%d, %d) (%d ms) (FLAGS %d)\n",
-		   i + 1, reg_rule->start_freq, ETSI_WEATHER_RADAR_BAND_LOW,
-		   bw, reg_rule->ant_gain, reg_rule->reg_power,
-		   regd->reg_rules[i].dfs_cac_ms,
-		   flags);
-
-	if (reg_rule->end_freq > ETSI_WEATHER_RADAR_BAND_HIGH)
-		end_freq = ETSI_WEATHER_RADAR_BAND_HIGH;
-	else
-		end_freq = reg_rule->end_freq;
+		ath11k_dbg(ab, ATH11K_DBG_REG,
+			   "\t%d. (%d - %d @ %d) (%d, %d) (%d ms) (FLAGS %d)\n",
+			   i + 1, reg_rule->start_freq,
+			   ETSI_WEATHER_RADAR_BAND_LOW, bw, reg_rule->ant_gain,
+			   reg_rule->reg_power, regd->reg_rules[i].dfs_cac_ms,
+			   flags);
+	}
 
-	bw = ath11k_reg_adjust_bw(ETSI_WEATHER_RADAR_BAND_LOW, end_freq,
-				  max_bw);
+	/* weather radar frequencies */
+	start_freq = max_t(u32, reg_rule->start_freq,
+			   ETSI_WEATHER_RADAR_BAND_LOW);
+	end_freq = min_t(u32, reg_rule->end_freq, ETSI_WEATHER_RADAR_BAND_HIGH);
 
-	i++;
+	bw = ath11k_reg_adjust_bw(start_freq, end_freq, max_bw);
+	if (bw > 0) {
+		i++;
 
-	ath11k_reg_update_rule(regd->reg_rules + i,
-			       ETSI_WEATHER_RADAR_BAND_LOW, end_freq, bw,
-			       reg_rule->ant_gain, reg_rule->reg_power,
-			       flags);
+		ath11k_reg_update_rule(regd->reg_rules + i, start_freq,
+				       end_freq, bw, reg_rule->ant_gain,
+				       reg_rule->reg_power, flags);
 
-	regd->reg_rules[i].dfs_cac_ms = ETSI_WEATHER_RADAR_BAND_CAC_TIMEOUT;
+		regd->reg_rules[i].dfs_cac_ms = ETSI_WEATHER_RADAR_BAND_CAC_TIMEOUT;
 
-	ath11k_dbg(ab, ATH11K_DBG_REG,
-		   "\t%d. (%d - %d @ %d) (%d, %d) (%d ms) (FLAGS %d)\n",
-		   i + 1, ETSI_WEATHER_RADAR_BAND_LOW, end_freq,
-		   bw, reg_rule->ant_gain, reg_rule->reg_power,
-		   regd->reg_rules[i].dfs_cac_ms,
-		   flags);
-
-	if (end_freq == reg_rule->end_freq) {
-		regd->n_reg_rules--;
-		*rule_idx = i;
-		return;
+		ath11k_dbg(ab, ATH11K_DBG_REG,
+			   "\t%d. (%d - %d @ %d) (%d, %d) (%d ms) (FLAGS %d)\n",
+			   i + 1, start_freq, end_freq, bw,
+			   reg_rule->ant_gain, reg_rule->reg_power,
+			   regd->reg_rules[i].dfs_cac_ms, flags);
 	}
 
+	/* frequencies above weather radar */
 	bw = ath11k_reg_adjust_bw(ETSI_WEATHER_RADAR_BAND_HIGH,
 				  reg_rule->end_freq, max_bw);
+	if (bw > 0) {
+		i++;
 
-	i++;
-
-	ath11k_reg_update_rule(regd->reg_rules + i, ETSI_WEATHER_RADAR_BAND_HIGH,
-			       reg_rule->end_freq, bw,
-			       reg_rule->ant_gain, reg_rule->reg_power,
-			       flags);
+		ath11k_reg_update_rule(regd->reg_rules + i,
+				       ETSI_WEATHER_RADAR_BAND_HIGH,
+				       reg_rule->end_freq, bw,
+				       reg_rule->ant_gain, reg_rule->reg_power,
+				       flags);
 
-	ath11k_dbg(ab, ATH11K_DBG_REG,
-		   "\t%d. (%d - %d @ %d) (%d, %d) (%d ms) (FLAGS %d)\n",
-		   i + 1, ETSI_WEATHER_RADAR_BAND_HIGH, reg_rule->end_freq,
-		   bw, reg_rule->ant_gain, reg_rule->reg_power,
-		   regd->reg_rules[i].dfs_cac_ms,
-		   flags);
+		ath11k_dbg(ab, ATH11K_DBG_REG,
+			   "\t%d. (%d - %d @ %d) (%d, %d) (%d ms) (FLAGS %d)\n",
+			   i + 1, ETSI_WEATHER_RADAR_BAND_HIGH,
+			   reg_rule->end_freq, bw, reg_rule->ant_gain,
+			   reg_rule->reg_power, regd->reg_rules[i].dfs_cac_ms,
+			   flags);
+	}
 
 	*rule_idx = i;
 }
-- 
2.34.1



