Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B5A3ED540
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbhHPNKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238852AbhHPNIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11703632BD;
        Mon, 16 Aug 2021 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119250;
        bh=zWNH5pGT/pIHJCmvZRaSOkLXBiB8DCvb5EGjWZU9ZF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYAPXTCO6Agr+1T1xqHpAbA8cADWhehWUGu9UcJAnkljHCtMDtf+M5tv9LnUL0ROz
         Uq6I/KoqK2VgvS3YTKPCkHI0YFiJzkhVirAPo6FE5w2nSFXIg02G04VAyEQNjDPDoQ
         ao/yWTRRhxAl+OxtQ8HBXxVNZA7UbHbSGzOWjO7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/96] ASoC: cs42l42: Fix LRCLK frame start edge
Date:   Mon, 16 Aug 2021 15:01:43 +0200
Message-Id: <20210816125436.056638081@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 0c2f2ad4f16a58879463d0979a54293f8f296d6f ]

An I2S frame starts on the falling edge of LRCLK so ASP_STP must
be 0.

At the same time, move other format settings in the same register
from cs42l42_pll_config() to cs42l42_set_dai_fmt() where you'd
expect to find them, and merge into a single write.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20210805161111.10410-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index ab6f89032ea0..828dc78202e8 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -658,15 +658,6 @@ static int cs42l42_pll_config(struct snd_soc_component *component)
 					CS42L42_FSYNC_PULSE_WIDTH_MASK,
 					CS42L42_FRAC1_VAL(fsync - 1) <<
 					CS42L42_FSYNC_PULSE_WIDTH_SHIFT);
-			snd_soc_component_update_bits(component,
-					CS42L42_ASP_FRM_CFG,
-					CS42L42_ASP_5050_MASK,
-					CS42L42_ASP_5050_MASK);
-			/* Set the frame delay to 1.0 SCLK clocks */
-			snd_soc_component_update_bits(component, CS42L42_ASP_FRM_CFG,
-					CS42L42_ASP_FSD_MASK,
-					CS42L42_ASP_FSD_1_0 <<
-					CS42L42_ASP_FSD_SHIFT);
 			/* Set the sample rates (96k or lower) */
 			snd_soc_component_update_bits(component, CS42L42_FS_RATE_EN,
 					CS42L42_FS_EN_MASK,
@@ -762,6 +753,18 @@ static int cs42l42_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	/* interface format */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
+		/*
+		 * 5050 mode, frame starts on falling edge of LRCLK,
+		 * frame delayed by 1.0 SCLKs
+		 */
+		snd_soc_component_update_bits(component,
+					      CS42L42_ASP_FRM_CFG,
+					      CS42L42_ASP_STP_MASK |
+					      CS42L42_ASP_5050_MASK |
+					      CS42L42_ASP_FSD_MASK,
+					      CS42L42_ASP_5050_MASK |
+					      (CS42L42_ASP_FSD_1_0 <<
+						CS42L42_ASP_FSD_SHIFT));
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2



