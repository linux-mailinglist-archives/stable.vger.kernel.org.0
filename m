Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870A859D9FB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348957AbiHWKEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352539AbiHWKCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13FF7C514;
        Tue, 23 Aug 2022 01:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79C46123D;
        Tue, 23 Aug 2022 08:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D29C433C1;
        Tue, 23 Aug 2022 08:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244600;
        bh=4jrCeDH5htUTAKRPY4r395KdKhET1ApCrWau5EWtYyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Db5ZcyM1bVvq93OkttBBS/qNOLT2ionqBGtOczhXxz2K4zLHovTG/FTNirOa5Hpbz
         S7cNKOEQU7OvZ4LPZGVpkYfrQYXclY0X7lEhA4khXgTISAxyHrzdToNb/T5S+jLvsI
         DarNnBvpLHgTw60CDnFGKfpvYnUxdYj5gah9u/lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 121/244] ASoC: tas2770: Fix handling of mute/unmute
Date:   Tue, 23 Aug 2022 10:24:40 +0200
Message-Id: <20220823080103.082949163@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

commit 1e5907bcb3a3b569be0a03ebe668bba2ed320a50 upstream.

Because the PWR_CTRL field is modeled as the power state of the DAC
widget, and at the same time it is used to implement mute/unmute, we
need some additional book-keeping to have the right end result no matter
the sequence of calls. Without this fix, one can mute an ongoing stream
by toggling a speaker pin control.

Fixes: 1a476abc723e ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220808141246.5749-5-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2770.c |   57 +++++++++++++++++++++++----------------------
 sound/soc/codecs/tas2770.h |    2 +
 2 files changed, 32 insertions(+), 27 deletions(-)

--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -46,6 +46,26 @@ static void tas2770_reset(struct tas2770
 	usleep_range(1000, 2000);
 }
 
+static int tas2770_update_pwr_ctrl(struct tas2770_priv *tas2770)
+{
+	struct snd_soc_component *component = tas2770->component;
+	unsigned int val;
+	int ret;
+
+	if (tas2770->dac_powered)
+		val = tas2770->unmuted ?
+			TAS2770_PWR_CTRL_ACTIVE : TAS2770_PWR_CTRL_MUTE;
+	else
+		val = TAS2770_PWR_CTRL_SHUTDOWN;
+
+	ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
+					    TAS2770_PWR_CTRL_MASK, val);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int tas2770_codec_suspend(struct snd_soc_component *component)
 {
@@ -82,9 +102,7 @@ static int tas2770_codec_resume(struct s
 		gpiod_set_value_cansleep(tas2770->sdz_gpio, 1);
 		usleep_range(1000, 2000);
 	} else {
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_ACTIVE);
+		ret = tas2770_update_pwr_ctrl(tas2770);
 		if (ret < 0)
 			return ret;
 	}
@@ -120,24 +138,19 @@ static int tas2770_dac_event(struct snd_
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_MUTE);
+		tas2770->dac_powered = 1;
+		ret = tas2770_update_pwr_ctrl(tas2770);
 		break;
 	case SND_SOC_DAPM_PRE_PMD:
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_SHUTDOWN);
+		tas2770->dac_powered = 0;
+		ret = tas2770_update_pwr_ctrl(tas2770);
 		break;
 	default:
 		dev_err(tas2770->dev, "Not supported evevt\n");
 		return -EINVAL;
 	}
 
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static const struct snd_kcontrol_new isense_switch =
@@ -171,21 +184,11 @@ static const struct snd_soc_dapm_route t
 static int tas2770_mute(struct snd_soc_dai *dai, int mute, int direction)
 {
 	struct snd_soc_component *component = dai->component;
-	int ret;
-
-	if (mute)
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_MUTE);
-	else
-		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-						    TAS2770_PWR_CTRL_MASK,
-						    TAS2770_PWR_CTRL_ACTIVE);
-
-	if (ret < 0)
-		return ret;
+	struct tas2770_priv *tas2770 =
+			snd_soc_component_get_drvdata(component);
 
-	return 0;
+	tas2770->unmuted = !mute;
+	return tas2770_update_pwr_ctrl(tas2770);
 }
 
 static int tas2770_set_bitwidth(struct tas2770_priv *tas2770, int bitwidth)
--- a/sound/soc/codecs/tas2770.h
+++ b/sound/soc/codecs/tas2770.h
@@ -138,6 +138,8 @@ struct tas2770_priv {
 	struct device *dev;
 	int v_sense_slot;
 	int i_sense_slot;
+	bool dac_powered;
+	bool unmuted;
 };
 
 #endif /* __TAS2770__ */


