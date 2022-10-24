Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C213060B035
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiJXQCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiJXQBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:01:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D68CA3AA4;
        Mon, 24 Oct 2022 07:55:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78CD4B8125F;
        Mon, 24 Oct 2022 12:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78E5C433C1;
        Mon, 24 Oct 2022 12:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614237;
        bh=vcw+YLlXa2iZArTHHxfDK4FeCWbErJRMzc+eA4PfH9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJBLJQYh9vGyXkSYVb/c/u8H1edTnNL6Ekr9LZYqqJXTTrYkR5AEqi94CMO3k9mTj
         BjZjNdPuSLel7beXqLug05MHchbLbMxl2yAGzJIhzcvHp82BHkNjaJUB+2diLlg6bK
         pJm3LJ4y5iQuQBp9LwVP9WzEfm3vbHcBuasa7Qz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/390] ASoC: tas2764: Fix mute/unmute
Date:   Mon, 24 Oct 2022 13:29:08 +0200
Message-Id: <20221024113029.114894525@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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

[ Upstream commit f5ad67f13623548e5aff847f89700c178aaf2a98 ]

Because the PWR_CTRL field is modeled as the power state of the DAC
widget, and at the same time it is used to implement mute/unmute, we
need some additional book-keeping to have the right end result no matter
the sequence of calls. Without this fix, one permanently mutes an
ongoing stream by toggling the associated speaker pin control.

(This mirrors commit 1e5907bcb3a3 ("ASoC: tas2770: Fix handling of
mute/unmute") which was a fix to the tas2770 driver.)

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220825140241.53963-4-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 57 +++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 6b6e30b072f2..8b262e7f5275 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -34,6 +34,9 @@ struct tas2764_priv {
 	
 	int v_sense_slot;
 	int i_sense_slot;
+
+	bool dac_powered;
+	bool unmuted;
 };
 
 static void tas2764_reset(struct tas2764_priv *tas2764)
@@ -50,6 +53,26 @@ static void tas2764_reset(struct tas2764_priv *tas2764)
 	usleep_range(1000, 2000);
 }
 
+static int tas2764_update_pwr_ctrl(struct tas2764_priv *tas2764)
+{
+	struct snd_soc_component *component = tas2764->component;
+	unsigned int val;
+	int ret;
+
+	if (tas2764->dac_powered)
+		val = tas2764->unmuted ?
+			TAS2764_PWR_CTRL_ACTIVE : TAS2764_PWR_CTRL_MUTE;
+	else
+		val = TAS2764_PWR_CTRL_SHUTDOWN;
+
+	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
+					    TAS2764_PWR_CTRL_MASK, val);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int tas2764_codec_suspend(struct snd_soc_component *component)
 {
@@ -82,9 +105,7 @@ static int tas2764_codec_resume(struct snd_soc_component *component)
 		usleep_range(1000, 2000);
 	}
 
-	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					    TAS2764_PWR_CTRL_MASK,
-					    TAS2764_PWR_CTRL_ACTIVE);
+	ret = tas2764_update_pwr_ctrl(tas2764);
 
 	if (ret < 0)
 		return ret;
@@ -118,14 +139,12 @@ static int tas2764_dac_event(struct snd_soc_dapm_widget *w,
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
-		ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-						    TAS2764_PWR_CTRL_MASK,
-						    TAS2764_PWR_CTRL_MUTE);
+		tas2764->dac_powered = true;
+		ret = tas2764_update_pwr_ctrl(tas2764);
 		break;
 	case SND_SOC_DAPM_PRE_PMD:
-		ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-						    TAS2764_PWR_CTRL_MASK,
-						    TAS2764_PWR_CTRL_SHUTDOWN);
+		tas2764->dac_powered = false;
+		ret = tas2764_update_pwr_ctrl(tas2764);
 		break;
 	default:
 		dev_err(tas2764->dev, "Unsupported event\n");
@@ -170,17 +189,11 @@ static const struct snd_soc_dapm_route tas2764_audio_map[] = {
 
 static int tas2764_mute(struct snd_soc_dai *dai, int mute, int direction)
 {
-	struct snd_soc_component *component = dai->component;
-	int ret;
-
-	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					    TAS2764_PWR_CTRL_MASK,
-					    mute ? TAS2764_PWR_CTRL_MUTE : 0);
+	struct tas2764_priv *tas2764 =
+			snd_soc_component_get_drvdata(dai->component);
 
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	tas2764->unmuted = !mute;
+	return tas2764_update_pwr_ctrl(tas2764);
 }
 
 static int tas2764_set_bitwidth(struct tas2764_priv *tas2764, int bitwidth)
@@ -494,12 +507,6 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	if (ret < 0)
 		return ret;
 
-	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
-					    TAS2764_PWR_CTRL_MASK,
-					    TAS2764_PWR_CTRL_MUTE);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
-- 
2.35.1



