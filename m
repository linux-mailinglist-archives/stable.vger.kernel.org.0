Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3EE5C0400
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiIUQXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiIUQX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:23:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A84AFAEA;
        Wed, 21 Sep 2022 09:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60F9DB830B7;
        Wed, 21 Sep 2022 15:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80CAC433D7;
        Wed, 21 Sep 2022 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775497;
        bh=MvrFLzVPgqzDsrlIxsZUvsUYtPzd3vuBgQC+nZ43MeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1CrPub/9v6qFU1Bwg83TqPXKRJo3aBr5DLsJKQ4O3vBTwucsFmN0466os7qKa+7i
         tbgMp3TNfjkdCIjjPDhbJAKnI97Y6RlWDHN9YiNP2dj3Pjb/7OXU4XDvRL7u/pQHAC
         NMU460Ois6Eb1nSbubdxheaOwU/2c5NPPGlpux5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/39] ASoC: nau8824: Fix semaphore unbalance at error paths
Date:   Wed, 21 Sep 2022 17:46:31 +0200
Message-Id: <20220921153646.596226371@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5628560e90395d3812800a8e44a01c32ffa429ec ]

The semaphore of nau8824 wasn't properly unlocked at some error
handling code paths, hence this may result in the unbalance (and
potential lock-up).  Fix them to handle the semaphore up properly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220823081000.2965-3-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8824.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/nau8824.c b/sound/soc/codecs/nau8824.c
index c8ccfa2fff84..a95fe3fff1db 100644
--- a/sound/soc/codecs/nau8824.c
+++ b/sound/soc/codecs/nau8824.c
@@ -1072,6 +1072,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_component *component = dai->component;
 	struct nau8824 *nau8824 = snd_soc_component_get_drvdata(component);
 	unsigned int val_len = 0, osr, ctrl_val, bclk_fs, bclk_div;
+	int err = -EINVAL;
 
 	nau8824_sema_acquire(nau8824, HZ);
 
@@ -1088,7 +1089,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		osr &= NAU8824_DAC_OVERSAMPLE_MASK;
 		if (nau8824_clock_check(nau8824, substream->stream,
 			nau8824->fs, osr))
-			return -EINVAL;
+			goto error;
 		regmap_update_bits(nau8824->regmap, NAU8824_REG_CLK_DIVIDER,
 			NAU8824_CLK_DAC_SRC_MASK,
 			osr_dac_sel[osr].clk_src << NAU8824_CLK_DAC_SRC_SFT);
@@ -1098,7 +1099,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		osr &= NAU8824_ADC_SYNC_DOWN_MASK;
 		if (nau8824_clock_check(nau8824, substream->stream,
 			nau8824->fs, osr))
-			return -EINVAL;
+			goto error;
 		regmap_update_bits(nau8824->regmap, NAU8824_REG_CLK_DIVIDER,
 			NAU8824_CLK_ADC_SRC_MASK,
 			osr_adc_sel[osr].clk_src << NAU8824_CLK_ADC_SRC_SFT);
@@ -1119,7 +1120,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		else if (bclk_fs <= 256)
 			bclk_div = 0;
 		else
-			return -EINVAL;
+			goto error;
 		regmap_update_bits(nau8824->regmap,
 			NAU8824_REG_PORT0_I2S_PCM_CTRL_2,
 			NAU8824_I2S_LRC_DIV_MASK | NAU8824_I2S_BLK_DIV_MASK,
@@ -1140,15 +1141,17 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		val_len |= NAU8824_I2S_DL_32;
 		break;
 	default:
-		return -EINVAL;
+		goto error;
 	}
 
 	regmap_update_bits(nau8824->regmap, NAU8824_REG_PORT0_I2S_PCM_CTRL_1,
 		NAU8824_I2S_DL_MASK, val_len);
+	err = 0;
 
+ error:
 	nau8824_sema_release(nau8824);
 
-	return 0;
+	return err;
 }
 
 static int nau8824_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
@@ -1157,8 +1160,6 @@ static int nau8824_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	struct nau8824 *nau8824 = snd_soc_component_get_drvdata(component);
 	unsigned int ctrl1_val = 0, ctrl2_val = 0;
 
-	nau8824_sema_acquire(nau8824, HZ);
-
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBM_CFM:
 		ctrl2_val |= NAU8824_I2S_MS_MASTER;
@@ -1200,6 +1201,8 @@ static int nau8824_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
+	nau8824_sema_acquire(nau8824, HZ);
+
 	regmap_update_bits(nau8824->regmap, NAU8824_REG_PORT0_I2S_PCM_CTRL_1,
 		NAU8824_I2S_DF_MASK | NAU8824_I2S_BP_MASK |
 		NAU8824_I2S_PCMB_EN, ctrl1_val);
-- 
2.35.1



