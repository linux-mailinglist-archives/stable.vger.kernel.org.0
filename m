Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911483CE1A2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349434AbhGSP05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348334AbhGSPYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C36160FE7;
        Mon, 19 Jul 2021 16:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710685;
        bh=b4HZ7ppO7r6L4zUYuuMfDXwZM1LLca5Cts5yxksp/nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVSqDuO/48rEtMrkyI/2z4ujIb16eiWTwZIVq7BUfy1tGaaGFXGIqm27ic+OiTpAV
         ULXmUz35xycWOJtua3tDfTh1wMuaghXVXjMQBXsbA1D7GgvTsApjjGoxoBk5iYjYq6
         SF3wAAkJOPQ7HTjJosikmQizf34bm6Mqj/m+ZpUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@sirena.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/351] ASoC: cs42l42: Fix 1536000 Bit Clock instability
Date:   Mon, 19 Jul 2021 16:50:17 +0200
Message-Id: <20210719144946.858641625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit 1c52825c38fc4e44c61ed75a8ae32f5fa580383b ]

The 16 Bits, 2 channels, 48K sample rate use case needs
to configure a safer pll_divout during the start of PLL
After 800us from the start of PLL the correct pll_divout
can be set

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Message-Id: <20210525090822.64577-1-tanureal@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 47 +++++++++++++++++++++++++-------------
 sound/soc/codecs/cs42l42.h |  2 ++
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 77473c226f9e..8434c48354f1 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -581,6 +581,7 @@ struct cs42l42_pll_params {
 	u8 pll_divout;
 	u32 mclk_int;
 	u8 pll_cal_ratio;
+	u8 n;
 };
 
 /*
@@ -588,21 +589,21 @@ struct cs42l42_pll_params {
  * Table 4-5 from the Datasheet
  */
 static const struct cs42l42_pll_params pll_ratio_table[] = {
-	{ 1536000, 0, 1, 0x00, 0x7D, 0x000000, 0x03, 0x10, 12000000, 125 },
-	{ 2822400, 0, 1, 0x00, 0x40, 0x000000, 0x03, 0x10, 11289600, 128 },
-	{ 3000000, 0, 1, 0x00, 0x40, 0x000000, 0x03, 0x10, 12000000, 128 },
-	{ 3072000, 0, 1, 0x00, 0x3E, 0x800000, 0x03, 0x10, 12000000, 125 },
-	{ 4000000, 0, 1, 0x00, 0x30, 0x800000, 0x03, 0x10, 12000000, 96 },
-	{ 4096000, 0, 1, 0x00, 0x2E, 0xE00000, 0x03, 0x10, 12000000, 94 },
-	{ 5644800, 0, 1, 0x01, 0x40, 0x000000, 0x03, 0x10, 11289600, 128 },
-	{ 6000000, 0, 1, 0x01, 0x40, 0x000000, 0x03, 0x10, 12000000, 128 },
-	{ 6144000, 0, 1, 0x01, 0x3E, 0x800000, 0x03, 0x10, 12000000, 125 },
-	{ 11289600, 0, 0, 0, 0, 0, 0, 0, 11289600, 0 },
-	{ 12000000, 0, 0, 0, 0, 0, 0, 0, 12000000, 0 },
-	{ 12288000, 0, 0, 0, 0, 0, 0, 0, 12288000, 0 },
-	{ 22579200, 1, 0, 0, 0, 0, 0, 0, 22579200, 0 },
-	{ 24000000, 1, 0, 0, 0, 0, 0, 0, 24000000, 0 },
-	{ 24576000, 1, 0, 0, 0, 0, 0, 0, 24576000, 0 }
+	{ 1536000, 0, 1, 0x00, 0x7D, 0x000000, 0x03, 0x10, 12000000, 125, 2},
+	{ 2822400, 0, 1, 0x00, 0x40, 0x000000, 0x03, 0x10, 11289600, 128, 1},
+	{ 3000000, 0, 1, 0x00, 0x40, 0x000000, 0x03, 0x10, 12000000, 128, 1},
+	{ 3072000, 0, 1, 0x00, 0x3E, 0x800000, 0x03, 0x10, 12000000, 125, 1},
+	{ 4000000, 0, 1, 0x00, 0x30, 0x800000, 0x03, 0x10, 12000000,  96, 1},
+	{ 4096000, 0, 1, 0x00, 0x2E, 0xE00000, 0x03, 0x10, 12000000,  94, 1},
+	{ 5644800, 0, 1, 0x01, 0x40, 0x000000, 0x03, 0x10, 11289600, 128, 1},
+	{ 6000000, 0, 1, 0x01, 0x40, 0x000000, 0x03, 0x10, 12000000, 128, 1},
+	{ 6144000, 0, 1, 0x01, 0x3E, 0x800000, 0x03, 0x10, 12000000, 125, 1},
+	{ 11289600, 0, 0, 0, 0, 0, 0, 0, 11289600, 0, 1},
+	{ 12000000, 0, 0, 0, 0, 0, 0, 0, 12000000, 0, 1},
+	{ 12288000, 0, 0, 0, 0, 0, 0, 0, 12288000, 0, 1},
+	{ 22579200, 1, 0, 0, 0, 0, 0, 0, 22579200, 0, 1},
+	{ 24000000, 1, 0, 0, 0, 0, 0, 0, 24000000, 0, 1},
+	{ 24576000, 1, 0, 0, 0, 0, 0, 0, 24576000, 0, 1}
 };
 
 static int cs42l42_pll_config(struct snd_soc_component *component)
@@ -738,8 +739,12 @@ static int cs42l42_pll_config(struct snd_soc_component *component)
 				snd_soc_component_update_bits(component,
 					CS42L42_PLL_CTL3,
 					CS42L42_PLL_DIVOUT_MASK,
-					pll_ratio_table[i].pll_divout
+					(pll_ratio_table[i].pll_divout * pll_ratio_table[i].n)
 					<< CS42L42_PLL_DIVOUT_SHIFT);
+				if (pll_ratio_table[i].n != 1)
+					cs42l42->pll_divout = pll_ratio_table[i].pll_divout;
+				else
+					cs42l42->pll_divout = 0;
 				snd_soc_component_update_bits(component,
 					CS42L42_PLL_CAL_RATIO,
 					CS42L42_PLL_CAL_RATIO_MASK,
@@ -894,6 +899,16 @@ static int cs42l42_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 			if ((cs42l42->bclk < 11289600) && (cs42l42->sclk < 11289600)) {
 				snd_soc_component_update_bits(component, CS42L42_PLL_CTL1,
 							      CS42L42_PLL_START_MASK, 1);
+
+				if (cs42l42->pll_divout) {
+					usleep_range(CS42L42_PLL_DIVOUT_TIME_US,
+						     CS42L42_PLL_DIVOUT_TIME_US * 2);
+					snd_soc_component_update_bits(component, CS42L42_PLL_CTL3,
+								      CS42L42_PLL_DIVOUT_MASK,
+								      cs42l42->pll_divout <<
+								      CS42L42_PLL_DIVOUT_SHIFT);
+				}
+
 				ret = regmap_read_poll_timeout(cs42l42->regmap,
 							       CS42L42_PLL_LOCK_STATUS,
 							       regval,
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 386c40f9ed31..5384105afe50 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -755,6 +755,7 @@
 
 #define CS42L42_NUM_SUPPLIES	5
 #define CS42L42_BOOT_TIME_US	3000
+#define CS42L42_PLL_DIVOUT_TIME_US	800
 #define CS42L42_CLOCK_SWITCH_DELAY_US 150
 #define CS42L42_PLL_LOCK_POLL_US	250
 #define CS42L42_PLL_LOCK_TIMEOUT_US	1250
@@ -777,6 +778,7 @@ struct  cs42l42_private {
 	int bclk;
 	u32 sclk;
 	u32 srate;
+	u8 pll_divout;
 	u8 plug_state;
 	u8 hs_type;
 	u8 ts_inv;
-- 
2.30.2



