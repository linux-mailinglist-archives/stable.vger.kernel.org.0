Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266E94524F6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357753AbhKPBqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238836AbhKOSVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:21:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B4B63410;
        Mon, 15 Nov 2021 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998778;
        bh=1e6b9FBICrzlKpl2mB1WYH8Lon7reBS5kHqhBVwnZ5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DruqKThuDqosikmDRbo+C0PBVRuLmfvtBn/HEy4s+PVu8OAXL+FocZP+CI0ubjxMq
         fGIWo0TByWumm78oWI+FVkJCpV66VjHyGuPTHc/jERBys3wB5JqTlbPNrL17YkkYrY
         nEpJ0vmfdOSlauHX1d1Dbhvv9WqkzV8ccCgJuxYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefan Binding <sbinding@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 058/849] ASoC: cs42l42: Ensure 0dB full scale volume is used for headsets
Date:   Mon, 15 Nov 2021 17:52:21 +0100
Message-Id: <20211115165421.989761603@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 99c022be94a68..8838b9a0de8e4 100644
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



