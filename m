Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C125C3ED5ED
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbhHPNPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239969AbhHPNOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDBD632CC;
        Mon, 16 Aug 2021 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119514;
        bh=fE2XE13Gzy7eJJdVCFmq7ovZLqb8RtdPA54zFeVTKAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ4IC/HKkZddvyinYX0jRDchO5l45V8jSbBs40VVgGpghAfBLEaqjm54yAUG5c9JG
         NFebmAJOSMBJt/137yqgekKrIK87rhy/CBsLuYCPwn/o5kaTsoV8k4oysVydV+dBdA
         f+fGsma5xwAoXjlIG8yHW7Qe8uxbLshg32Auhxdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 054/151] ASoC: cs42l42: PLL must be running when changing MCLK_SRC_SEL
Date:   Mon, 16 Aug 2021 15:01:24 +0200
Message-Id: <20210816125445.849328391@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit f1040e86f83b0f7d5f45724500a6a441731ff4b7 ]

Both SCLK and PLL clocks must be running to drive the glitch-free mux
behind MCLK_SRC_SEL and complete the switchover.

This patch moves the writing of MCLK_SRC_SEL to when the PLL is started
and stopped, so that it only transitions while the PLL is running.
The unconditional write MCLK_SRC_SEL=0 in cs42l42_mute_stream() is safe
because if the PLL is not running MCLK_SRC_SEL is already 0.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 43fc357199f9 ("ASoC: cs42l42: Set clock source for both ways of stream")
Link: https://lore.kernel.org/r/20210805161111.10410-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 25 ++++++++++++++++++-------
 sound/soc/codecs/cs42l42.h |  1 +
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 22d8c8d03308..7b102a05a1b6 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -609,6 +609,8 @@ static int cs42l42_pll_config(struct snd_soc_component *component)
 
 	for (i = 0; i < ARRAY_SIZE(pll_ratio_table); i++) {
 		if (pll_ratio_table[i].sclk == clk) {
+			cs42l42->pll_config = i;
+
 			/* Configure the internal sample rate */
 			snd_soc_component_update_bits(component, CS42L42_MCLK_CTL,
 					CS42L42_INTERNAL_FS_MASK,
@@ -617,14 +619,9 @@ static int cs42l42_pll_config(struct snd_soc_component *component)
 					(pll_ratio_table[i].mclk_int !=
 					24000000)) <<
 					CS42L42_INTERNAL_FS_SHIFT);
-			/* Set the MCLK src (PLL or SCLK) and the divide
-			 * ratio
-			 */
+
 			snd_soc_component_update_bits(component, CS42L42_MCLK_SRC_SEL,
-					CS42L42_MCLK_SRC_SEL_MASK |
 					CS42L42_MCLKDIV_MASK,
-					(pll_ratio_table[i].mclk_src_sel
-					<< CS42L42_MCLK_SRC_SEL_SHIFT) |
 					(pll_ratio_table[i].mclk_div <<
 					CS42L42_MCLKDIV_SHIFT));
 			/* Set up the LRCLK */
@@ -882,13 +879,21 @@ static int cs42l42_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 			 */
 			regmap_multi_reg_write(cs42l42->regmap, cs42l42_to_osc_seq,
 					       ARRAY_SIZE(cs42l42_to_osc_seq));
+
+			/* Must disconnect PLL before stopping it */
+			snd_soc_component_update_bits(component,
+						      CS42L42_MCLK_SRC_SEL,
+						      CS42L42_MCLK_SRC_SEL_MASK,
+						      0);
+			usleep_range(100, 200);
+
 			snd_soc_component_update_bits(component, CS42L42_PLL_CTL1,
 						      CS42L42_PLL_START_MASK, 0);
 		}
 	} else {
 		if (!cs42l42->stream_use) {
 			/* SCLK must be running before codec unmute */
-			if ((cs42l42->bclk < 11289600) && (cs42l42->sclk < 11289600)) {
+			if (pll_ratio_table[cs42l42->pll_config].mclk_src_sel) {
 				snd_soc_component_update_bits(component, CS42L42_PLL_CTL1,
 							      CS42L42_PLL_START_MASK, 1);
 
@@ -909,6 +914,12 @@ static int cs42l42_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 							       CS42L42_PLL_LOCK_TIMEOUT_US);
 				if (ret < 0)
 					dev_warn(component->dev, "PLL failed to lock: %d\n", ret);
+
+				/* PLL must be running to drive glitchless switch logic */
+				snd_soc_component_update_bits(component,
+							      CS42L42_MCLK_SRC_SEL,
+							      CS42L42_MCLK_SRC_SEL_MASK,
+							      CS42L42_MCLK_SRC_SEL_MASK);
 			}
 
 			/* Mark SCLK as present, turn off internal oscillator */
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 5384105afe50..38fd91a168ae 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -775,6 +775,7 @@ struct  cs42l42_private {
 	struct gpio_desc *reset_gpio;
 	struct completion pdn_done;
 	struct snd_soc_jack jack;
+	int pll_config;
 	int bclk;
 	u32 sclk;
 	u32 srate;
-- 
2.30.2



