Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E863D60B796
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiJXT0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiJXTYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:24:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E87AC4C25;
        Mon, 24 Oct 2022 10:58:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB1BCB8199E;
        Mon, 24 Oct 2022 12:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D8CC433D6;
        Mon, 24 Oct 2022 12:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615358;
        bh=yFICbyVM8BgNcPfifIhOQsq5a8XozO4z6144M/HeQM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGw0zXVKaJBBylPyzS3jCQifZCbKbMETk8WSN8D1wERjALMrqLsNpkje1zx04ZPhA
         sK2uzcQWl293HV8Yy7q2yNZiI3RWs+u8SMICYAdsvsB6epUWAxoQvP6IymMwG7xoF5
         EoqlShStV/rUkG+6UzmrnMxkbYKIyBl/llLLJpIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/530] ASoC: tas2764: Drop conflicting set_bias_level power setting
Date:   Mon, 24 Oct 2022 13:29:24 +0200
Message-Id: <20221024113055.049925924@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 09273f38832406db19a8907a934687cc10660a6b ]

The driver is setting the PWR_CTRL field in both the set_bias_level
callback and on DAPM events of the DAC widget (and also in the
mute_stream method). Drop the set_bias_level callback altogether as the
power setting it does is in conflict with the other code paths.

(This mirrors commit c8a6ae3fe1c8 ("ASoC: tas2770: Drop conflicting
set_bias_level power setting") which was a fix to the tas2770 driver.)

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220825140241.53963-3-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index d0b6c174186d..e76ce90c787f 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -50,38 +50,6 @@ static void tas2764_reset(struct tas2764_priv *tas2764)
 	usleep_range(1000, 2000);
 }
 
-static int tas2764_set_bias_level(struct snd_soc_component *component,
-				 enum snd_soc_bias_level level)
-{
-	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
-
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-		snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					      TAS2764_PWR_CTRL_MASK,
-					      TAS2764_PWR_CTRL_ACTIVE);
-		break;
-	case SND_SOC_BIAS_STANDBY:
-	case SND_SOC_BIAS_PREPARE:
-		snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					      TAS2764_PWR_CTRL_MASK,
-					      TAS2764_PWR_CTRL_MUTE);
-		break;
-	case SND_SOC_BIAS_OFF:
-		snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					      TAS2764_PWR_CTRL_MASK,
-					      TAS2764_PWR_CTRL_SHUTDOWN);
-		break;
-
-	default:
-		dev_err(tas2764->dev,
-				"wrong power level setting %d\n", level);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_PM
 static int tas2764_codec_suspend(struct snd_soc_component *component)
 {
@@ -549,7 +517,6 @@ static const struct snd_soc_component_driver soc_component_driver_tas2764 = {
 	.probe			= tas2764_codec_probe,
 	.suspend		= tas2764_codec_suspend,
 	.resume			= tas2764_codec_resume,
-	.set_bias_level		= tas2764_set_bias_level,
 	.controls		= tas2764_snd_controls,
 	.num_controls		= ARRAY_SIZE(tas2764_snd_controls),
 	.dapm_widgets		= tas2764_dapm_widgets,
-- 
2.35.1



