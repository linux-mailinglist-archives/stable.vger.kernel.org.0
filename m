Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C3B6B44F1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjCJOaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjCJO3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010801A4AE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C26B616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB15C433EF;
        Fri, 10 Mar 2023 14:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458472;
        bh=krsIpeMRSmv9ah5kdimJhCdEvpttPzJtLC5Rd0/vUmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXVvO6JttuI9kwR/6MKugHsLA4SiSQ/QYLlAVGvl+16dD/3725+mVdZJW29v72otV
         d4tFxe3IZq+nBlhYoMsjIYtjgFSvv3RdL1f5KHxKvleIf+0e/06TCl12pMe/Dw+2RW
         fdfTBe+w25baIaWuI3Jr2qJrZaRRHuivhHC4ZF48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/357] rtlwifi: fix -Wpointer-sign warning
Date:   Fri, 10 Mar 2023 14:35:26 +0100
Message-Id: <20230310133735.642187958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ef41937631bfee855e2b406e1d536efdaa9ce512 ]

There are thousands of warnings in a W=2 build from just one file:

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c:3788:15: warning: pointer targets in initialization of 'u8 *' {aka 'unsigned char *'} from 'char *' differ in signedness [-Wpointer-sign]

Change the types to consistently use 'const char *' for the
strings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201026213040.3889546-6-arnd@kernel.org
Stable-dep-of: 117dbeda22ec ("wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 81 ++++++++++---------
 .../realtek/rtlwifi/rtl8821ae/table.c         |  4 +-
 .../realtek/rtlwifi/rtl8821ae/table.h         |  4 +-
 3 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 979e434a4e739..b9c560829a6f8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1587,7 +1587,7 @@ static void _rtl8821ae_phy_txpower_by_rate_configuration(struct ieee80211_hw *hw
 }
 
 /* string is in decimal */
-static bool _rtl8812ae_get_integer_from_string(char *str, u8 *pint)
+static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 {
 	u16 i = 0;
 	*pint = 0;
@@ -1605,7 +1605,7 @@ static bool _rtl8812ae_get_integer_from_string(char *str, u8 *pint)
 	return true;
 }
 
-static bool _rtl8812ae_eq_n_byte(u8 *str1, u8 *str2, u32 num)
+static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
 {
 	if (num == 0)
 		return false;
@@ -1643,10 +1643,11 @@ static s8 _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
 	return channel_index;
 }
 
-static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregulation,
-				      u8 *pband, u8 *pbandwidth,
-				      u8 *prate_section, u8 *prf_path,
-				      u8 *pchannel, u8 *ppower_limit)
+static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
+				      const char *pregulation,
+				      const char *pband, const char *pbandwidth,
+				      const char *prate_section, const char *prf_path,
+				      const char *pchannel, const char *ppower_limit)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
@@ -1654,8 +1655,8 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 	u8 channel_index;
 	s8 power_limit = 0, prev_power_limit, ret;
 
-	if (!_rtl8812ae_get_integer_from_string((char *)pchannel, &channel) ||
-	    !_rtl8812ae_get_integer_from_string((char *)ppower_limit,
+	if (!_rtl8812ae_get_integer_from_string(pchannel, &channel) ||
+	    !_rtl8812ae_get_integer_from_string(ppower_limit,
 						&power_limit)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Illegal index of pwr_lmt table [chnl %d][val %d]\n",
@@ -1665,42 +1666,42 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 	power_limit = power_limit > MAX_POWER_INDEX ?
 		      MAX_POWER_INDEX : power_limit;
 
-	if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("FCC"), 3))
+	if (_rtl8812ae_eq_n_byte(pregulation, "FCC", 3))
 		regulation = 0;
-	else if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("MKK"), 3))
+	else if (_rtl8812ae_eq_n_byte(pregulation, "MKK", 3))
 		regulation = 1;
-	else if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("ETSI"), 4))
+	else if (_rtl8812ae_eq_n_byte(pregulation, "ETSI", 4))
 		regulation = 2;
-	else if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("WW13"), 4))
+	else if (_rtl8812ae_eq_n_byte(pregulation, "WW13", 4))
 		regulation = 3;
 
-	if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("CCK"), 3))
+	if (_rtl8812ae_eq_n_byte(prate_section, "CCK", 3))
 		rate_section = 0;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("OFDM"), 4))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "OFDM", 4))
 		rate_section = 1;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("HT"), 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("1T"), 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
+		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
 		rate_section = 2;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("HT"), 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("2T"), 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
+		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
 		rate_section = 3;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("VHT"), 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("1T"), 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
+		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
 		rate_section = 4;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("VHT"), 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("2T"), 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
+		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
 		rate_section = 5;
 
-	if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("20M"), 3))
+	if (_rtl8812ae_eq_n_byte(pbandwidth, "20M", 3))
 		bandwidth = 0;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("40M"), 3))
+	else if (_rtl8812ae_eq_n_byte(pbandwidth, "40M", 3))
 		bandwidth = 1;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("80M"), 3))
+	else if (_rtl8812ae_eq_n_byte(pbandwidth, "80M", 3))
 		bandwidth = 2;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("160M"), 4))
+	else if (_rtl8812ae_eq_n_byte(pbandwidth, "160M", 4))
 		bandwidth = 3;
 
-	if (_rtl8812ae_eq_n_byte(pband, (u8 *)("2.4G"), 4)) {
+	if (_rtl8812ae_eq_n_byte(pband, "2.4G", 4)) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_2_4G,
 							       channel);
@@ -1724,7 +1725,7 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 			  regulation, bandwidth, rate_section, channel_index,
 			  rtlphy->txpwr_limit_2_4g[regulation][bandwidth]
 				[rate_section][channel_index][RF90_PATH_A]);
-	} else if (_rtl8812ae_eq_n_byte(pband, (u8 *)("5G"), 2)) {
+	} else if (_rtl8812ae_eq_n_byte(pband, "5G", 2)) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_5G,
 							       channel);
@@ -1755,10 +1756,10 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 }
 
 static void _rtl8812ae_phy_config_bb_txpwr_lmt(struct ieee80211_hw *hw,
-					  u8 *regulation, u8 *band,
-					  u8 *bandwidth, u8 *rate_section,
-					  u8 *rf_path, u8 *channel,
-					  u8 *power_limit)
+					  const char *regulation, const char *band,
+					  const char *bandwidth, const char *rate_section,
+					  const char *rf_path, const char *channel,
+					  const char *power_limit)
 {
 	_rtl8812ae_phy_set_txpower_limit(hw, regulation, band, bandwidth,
 					 rate_section, rf_path, channel,
@@ -1771,7 +1772,7 @@ static void _rtl8821ae_phy_read_and_config_txpwr_lmt(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u32 i = 0;
 	u32 array_len;
-	u8 **array;
+	const char **array;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
 		array_len = RTL8812AE_TXPWR_LMT_ARRAY_LEN;
@@ -1785,13 +1786,13 @@ static void _rtl8821ae_phy_read_and_config_txpwr_lmt(struct ieee80211_hw *hw)
 		 "\n");
 
 	for (i = 0; i < array_len; i += 7) {
-		u8 *regulation = array[i];
-		u8 *band = array[i+1];
-		u8 *bandwidth = array[i+2];
-		u8 *rate = array[i+3];
-		u8 *rf_path = array[i+4];
-		u8 *chnl = array[i+5];
-		u8 *val = array[i+6];
+		const char *regulation = array[i];
+		const char *band = array[i+1];
+		const char *bandwidth = array[i+2];
+		const char *rate = array[i+3];
+		const char *rf_path = array[i+4];
+		const char *chnl = array[i+5];
+		const char *val = array[i+6];
 
 		_rtl8812ae_phy_config_bb_txpwr_lmt(hw, regulation, band,
 						   bandwidth, rate, rf_path,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
index ed72a2aeb6c8e..fcaaf664cbec5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
@@ -2894,7 +2894,7 @@ u32 RTL8821AE_AGC_TAB_1TARRAYLEN = ARRAY_SIZE(RTL8821AE_AGC_TAB_ARRAY);
 *                           TXPWR_LMT.TXT
 ******************************************************************************/
 
-u8 *RTL8812AE_TXPWR_LMT[] = {
+const char *RTL8812AE_TXPWR_LMT[] = {
 	"FCC", "2.4G", "20M", "CCK", "1T", "01", "36",
 	"ETSI", "2.4G", "20M", "CCK", "1T", "01", "32",
 	"MKK", "2.4G", "20M", "CCK", "1T", "01", "32",
@@ -3463,7 +3463,7 @@ u8 *RTL8812AE_TXPWR_LMT[] = {
 
 u32 RTL8812AE_TXPWR_LMT_ARRAY_LEN = ARRAY_SIZE(RTL8812AE_TXPWR_LMT);
 
-u8 *RTL8821AE_TXPWR_LMT[] = {
+const char *RTL8821AE_TXPWR_LMT[] = {
 	"FCC", "2.4G", "20M", "CCK", "1T", "01", "32",
 	"ETSI", "2.4G", "20M", "CCK", "1T", "01", "32",
 	"MKK", "2.4G", "20M", "CCK", "1T", "01", "32",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
index 540159c25078a..76c62b7c0fb24 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
@@ -28,7 +28,7 @@ extern u32 RTL8821AE_AGC_TAB_ARRAY[];
 extern u32 RTL8812AE_AGC_TAB_1TARRAYLEN;
 extern u32 RTL8812AE_AGC_TAB_ARRAY[];
 extern u32 RTL8812AE_TXPWR_LMT_ARRAY_LEN;
-extern u8 *RTL8812AE_TXPWR_LMT[];
+extern const char *RTL8812AE_TXPWR_LMT[];
 extern u32 RTL8821AE_TXPWR_LMT_ARRAY_LEN;
-extern u8 *RTL8821AE_TXPWR_LMT[];
+extern const char *RTL8821AE_TXPWR_LMT[];
 #endif
-- 
2.39.2



