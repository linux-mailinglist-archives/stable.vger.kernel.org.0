Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A81439C3A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 18:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhJYRCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234165AbhJYRCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A3D60F6F;
        Mon, 25 Oct 2021 16:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181185;
        bh=OrUiHOL1i3mXBRfwHV1zuqoY8KU2+QY55qJU/FNXOEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zqbhr+x94NhcMMT6woRH7V1cLfUCgXIr2QIy98iVovdHvM7lSPPmEJeeKrwko2BIK
         39HF8dqvfEFYBVjbuAMNsi784XvvaQrH6A7RKqrLsgyHj5UupTAQJuH7VLJU2xFp4a
         IEaAhr7+bu/vrlNzVy0bOHLN3PaZCfkLDclrnMIyjjYrUAnwvPXtTwEvlvj+lZ80LP
         FdIjr90d2mSEgVcRsT/CJ4bzaM1mH0bAoaAml0K5HeyB9/H4N0HsxreAD3cioCxu1L
         zgYj0emj071XUqBjJ/tjozHxkpNypeVQYMz8V1+/wd9F3S6jf2I+oPJQW3gVsD20hC
         z4Z7LtVkZn9rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Binding <sbinding@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, james.schulman@cirrus.com,
        david.rhodes@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.14 03/18] ASoC: cs42l42: Ensure 0dB full scale volume is used for headsets
Date:   Mon, 25 Oct 2021 12:59:16 -0400
Message-Id: <20211025165939.1393655-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025165939.1393655-1-sashal@kernel.org>
References: <20211025165939.1393655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit aa18457c4af7a9dad1f2b150b11beae1d8ab57aa ]

Ensure the default 0dB playback path is always used.

The code that set FULL_SCALE_VOL based on LOAD_DET_RCSTAT was
spurious, and resulted in a -6dB attenuation being accidentally
inserted into the playback path.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20211011144903.28915-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 99c022be94a6..8838b9a0de8e 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -901,7 +901,6 @@ static int cs42l42_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 	struct snd_soc_component *component = dai->component;
 	struct cs42l42_private *cs42l42 = snd_soc_component_get_drvdata(component);
 	unsigned int regval;
-	u8 fullScaleVol;
 	int ret;
 
 	if (mute) {
@@ -972,20 +971,11 @@ static int cs42l42_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 		cs42l42->stream_use |= 1 << stream;
 
 		if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
-			/* Read the headphone load */
-			regval = snd_soc_component_read(component, CS42L42_LOAD_DET_RCSTAT);
-			if (((regval & CS42L42_RLA_STAT_MASK) >> CS42L42_RLA_STAT_SHIFT) ==
-			    CS42L42_RLA_STAT_15_OHM) {
-				fullScaleVol = CS42L42_HP_FULL_SCALE_VOL_MASK;
-			} else {
-				fullScaleVol = 0;
-			}
-
-			/* Un-mute the headphone, set the full scale volume flag */
+			/* Un-mute the headphone */
 			snd_soc_component_update_bits(component, CS42L42_HP_CTL,
 						      CS42L42_HP_ANA_AMUTE_MASK |
-						      CS42L42_HP_ANA_BMUTE_MASK |
-						      CS42L42_HP_FULL_SCALE_VOL_MASK, fullScaleVol);
+						      CS42L42_HP_ANA_BMUTE_MASK,
+						      0);
 		}
 	}
 
-- 
2.33.0

