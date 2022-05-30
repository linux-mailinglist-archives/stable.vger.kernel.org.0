Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622C9537D9C
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbiE3NhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237444AbiE3NfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE1284A0A;
        Mon, 30 May 2022 06:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A903B60F16;
        Mon, 30 May 2022 13:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11681C3411F;
        Mon, 30 May 2022 13:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917298;
        bh=BMxjupewSyN1zYjMGF8CZPdW+jWCEaz6ImvUq00v+cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egvrEKMCY9rK3qCrtjGaySXFtf2JjpuPJiXqTLwcUhHA/YGo+AkN/bYFNVxXW8KGi
         nP9c2o+lKp8fgIsteLO2waMcloR6TSdhBLJKsYzF0D56HCJSHbgLs/JCwJhV/kWWGN
         ZH2ivo9d4cnS4y/PibvJCWr9pN05NNlqn8gtaEhx/820uXx2Necvk224J9XIyOecQI
         02mVr3rKTNOR4J/Z3Gl1cz9GnlYlM9NFwcpe7MQTaFptaVd5W5fr0cTA79LsIzv23q
         06NZXPfIu0j/Xs4tYQ2GHmbmSOpkzcQlGjEIm5uTpzZIKD9884hyXBSxyRlAj8jmvG
         6aad0Q+pSEqiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        steven.eckhoff.opensource@gmail.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 089/159] ASoC: tscs454: Add endianness flag in snd_soc_component_driver
Date:   Mon, 30 May 2022 09:23:14 -0400
Message-Id: <20220530132425.1929512-89-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ff69ec96b87dccb3a29edef8cec5d4fefbbc2055 ]

The endianness flag is used on the CODEC side to specify an
ambivalence to endian, typically because it is lost over the hardware
link. This device receives audio over an I2S DAI and as such should
have endianness applied.

A fixup is also required to use the width directly rather than relying
on the format in hw_params, now both little and big endian would be
supported. It is worth noting this changes the behaviour of S24_LE to
use a word length of 24 rather than 32. This would appear to be a
correction since the fact S24_LE is stored as 32 bits should not be
presented over the bus.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220504170905.332415-26-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tscs454.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/tscs454.c b/sound/soc/codecs/tscs454.c
index 7e1826d6f06f..32e6fa7b0a06 100644
--- a/sound/soc/codecs/tscs454.c
+++ b/sound/soc/codecs/tscs454.c
@@ -3120,18 +3120,17 @@ static int set_aif_sample_format(struct snd_soc_component *component,
 	unsigned int width;
 	int ret;
 
-	switch (format) {
-	case SNDRV_PCM_FORMAT_S16_LE:
+	switch (snd_pcm_format_width(format)) {
+	case 16:
 		width = FV_WL_16;
 		break;
-	case SNDRV_PCM_FORMAT_S20_3LE:
+	case 20:
 		width = FV_WL_20;
 		break;
-	case SNDRV_PCM_FORMAT_S24_3LE:
+	case 24:
 		width = FV_WL_24;
 		break;
-	case SNDRV_PCM_FORMAT_S24_LE:
-	case SNDRV_PCM_FORMAT_S32_LE:
+	case 32:
 		width = FV_WL_32;
 		break;
 	default:
@@ -3326,6 +3325,7 @@ static const struct snd_soc_component_driver soc_component_dev_tscs454 = {
 	.num_dapm_routes = ARRAY_SIZE(tscs454_intercon),
 	.controls =	tscs454_snd_controls,
 	.num_controls = ARRAY_SIZE(tscs454_snd_controls),
+	.endianness = 1,
 };
 
 #define TSCS454_RATES SNDRV_PCM_RATE_8000_96000
-- 
2.35.1

