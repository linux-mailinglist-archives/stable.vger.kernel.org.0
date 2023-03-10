Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1BF6B484C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbjCJPBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjCJPBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:01:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8D7123DC4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D4BAB8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C317FC4339B;
        Fri, 10 Mar 2023 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459687;
        bh=xP2tIvzs4HGffJYadT/MxHcizHb5/H9vzC+bvMWskqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drO2NV4mHAsJ3SnuxIsPd7O5Q0sWHEHvEYMf9QfbPhObBi2KNYULTy+F38igXgYrJ
         q4tA69X9q042qhafQ1ECwCVQjfI5fB4XsPGtfAsE1MfL9lZGTtO3fxq0gd/Y9Jhta4
         p+X6Wn/kj07KgFs30F6Ha3E6aO83DA6+gBDf/lUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/529] wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
Date:   Fri, 10 Mar 2023 14:33:20 +0100
Message-Id: <20230310133807.648303267@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 117dbeda22ec5ea0918254d03b540ef8b8a64d53 ]

There is a global-out-of-bounds reported by KASAN:

  BUG: KASAN: global-out-of-bounds in
  _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
  Read of size 1 at addr ffffffffa0773c43 by task NetworkManager/411

  CPU: 6 PID: 411 Comm: NetworkManager Tainted: G      D
  6.1.0-rc8+ #144 e15588508517267d37
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
  Call Trace:
   <TASK>
   ...
   kasan_report+0xbb/0x1c0
   _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
   rtl8821ae_phy_bb_config.cold+0x346/0x641 [rtl8821ae]
   rtl8821ae_hw_init+0x1f5e/0x79b0 [rtl8821ae]
   ...
   </TASK>

The root cause of the problem is that the comparison order of
"prate_section" in _rtl8812ae_phy_set_txpower_limit() is wrong. The
_rtl8812ae_eq_n_byte() is used to compare the first n bytes of the two
strings from tail to head, which causes the problem. In the
_rtl8812ae_phy_set_txpower_limit(), it was originally intended to meet
this requirement by carefully designing the comparison order.
For example, "pregulation" and "pbandwidth" are compared in order of
length from small to large, first is 3 and last is 4. However, the
comparison order of "prate_section" dose not obey such order requirement,
therefore when "prate_section" is "HT", when comparing from tail to head,
it will lead to access out of bounds in _rtl8812ae_eq_n_byte(). As
mentioned above, the _rtl8812ae_eq_n_byte() has the same function as
strcmp(), so just strcmp() is enough.

Fix it by removing _rtl8812ae_eq_n_byte() and use strcmp() barely.
Although it can be fixed by adjusting the comparison order of
"prate_section", this may cause the value of "rate_section" to not be
from 0 to 5. In addition, commit "21e4b0726dc6" not only moved driver
from staging to regular tree, but also added setting txpower limit
function during the driver config phase, so the problem was introduced
by this commit.

Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221212025812.1541311-1-lizetao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 52 +++++++------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 119e0f799826f..c0c06ab6d3e76 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1599,18 +1599,6 @@ static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 	return true;
 }
 
-static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
-{
-	if (num == 0)
-		return false;
-	while (num > 0) {
-		num--;
-		if (str1[num] != str2[num])
-			return false;
-	}
-	return true;
-}
-
 static s8 _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
 					      u8 band, u8 channel)
 {
@@ -1660,42 +1648,42 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 	power_limit = power_limit > MAX_POWER_INDEX ?
 		      MAX_POWER_INDEX : power_limit;
 
-	if (_rtl8812ae_eq_n_byte(pregulation, "FCC", 3))
+	if (strcmp(pregulation, "FCC") == 0)
 		regulation = 0;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "MKK", 3))
+	else if (strcmp(pregulation, "MKK") == 0)
 		regulation = 1;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "ETSI", 4))
+	else if (strcmp(pregulation, "ETSI") == 0)
 		regulation = 2;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "WW13", 4))
+	else if (strcmp(pregulation, "WW13") == 0)
 		regulation = 3;
 
-	if (_rtl8812ae_eq_n_byte(prate_section, "CCK", 3))
+	if (strcmp(prate_section, "CCK") == 0)
 		rate_section = 0;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "OFDM", 4))
+	else if (strcmp(prate_section, "OFDM") == 0)
 		rate_section = 1;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 2;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 3;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 4;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 5;
 
-	if (_rtl8812ae_eq_n_byte(pbandwidth, "20M", 3))
+	if (strcmp(pbandwidth, "20M") == 0)
 		bandwidth = 0;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "40M", 3))
+	else if (strcmp(pbandwidth, "40M") == 0)
 		bandwidth = 1;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "80M", 3))
+	else if (strcmp(pbandwidth, "80M") == 0)
 		bandwidth = 2;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "160M", 4))
+	else if (strcmp(pbandwidth, "160M") == 0)
 		bandwidth = 3;
 
-	if (_rtl8812ae_eq_n_byte(pband, "2.4G", 4)) {
+	if (strcmp(pband, "2.4G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_2_4G,
 							       channel);
@@ -1719,7 +1707,7 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 			regulation, bandwidth, rate_section, channel_index,
 			rtlphy->txpwr_limit_2_4g[regulation][bandwidth]
 				[rate_section][channel_index][RF90_PATH_A]);
-	} else if (_rtl8812ae_eq_n_byte(pband, "5G", 2)) {
+	} else if (strcmp(pband, "5G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_5G,
 							       channel);
-- 
2.39.2



