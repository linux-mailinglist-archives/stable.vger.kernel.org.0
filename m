Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0635B59E1DD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244473AbiHWMSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359550AbiHWMP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3D6EA147;
        Tue, 23 Aug 2022 02:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F70614C4;
        Tue, 23 Aug 2022 09:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECACC433C1;
        Tue, 23 Aug 2022 09:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247652;
        bh=HWPvRsRbImhp+mxkyDgXuQ+z0w/UFpkDqwsXmE51S2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0hCKbEoY/4YTbA7bfMzdeTFft8xIIZQ3vMByWb9I9R7t3iQDoT+x0UeyKhLv6/3f
         t5+6GIr12oULvvi8Rq5uGtDkvfJqIdTAdLE/+EW/AZYxza1bSN+V+rDu6R3MfG6MoO
         UKSSmUUJQqcMWHj5vktlgZu6+GN38TZfcsPzeC/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 073/158] ASoC: tas2770: Drop conflicting set_bias_level power setting
Date:   Tue, 23 Aug 2022 10:26:45 +0200
Message-Id: <20220823080049.005365066@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

commit 482c23fbc7e9bf5a7a74defd0735d5346215db58 upstream.

The driver is setting the PWR_CTRL field in both the set_bias_level
callback and on DAPM events of the DAC widget (and also in the
mute_stream method). Drop the set_bias_level callback altogether as the
power setting it does is in conflict with the other code paths.

Fixes: 1a476abc723e ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220808141246.5749-4-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2770.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -46,38 +46,6 @@ static void tas2770_reset(struct tas2770
 	usleep_range(1000, 2000);
 }
 
-static int tas2770_set_bias_level(struct snd_soc_component *component,
-				 enum snd_soc_bias_level level)
-{
-	struct tas2770_priv *tas2770 =
-			snd_soc_component_get_drvdata(component);
-
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-		snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-					      TAS2770_PWR_CTRL_MASK,
-					      TAS2770_PWR_CTRL_ACTIVE);
-		break;
-	case SND_SOC_BIAS_STANDBY:
-	case SND_SOC_BIAS_PREPARE:
-		snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-					      TAS2770_PWR_CTRL_MASK,
-					      TAS2770_PWR_CTRL_MUTE);
-		break;
-	case SND_SOC_BIAS_OFF:
-		snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
-					      TAS2770_PWR_CTRL_MASK,
-					      TAS2770_PWR_CTRL_SHUTDOWN);
-		break;
-
-	default:
-		dev_err(tas2770->dev, "wrong power level setting %d\n", level);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_PM
 static int tas2770_codec_suspend(struct snd_soc_component *component)
 {
@@ -555,7 +523,6 @@ static const struct snd_soc_component_dr
 	.probe			= tas2770_codec_probe,
 	.suspend		= tas2770_codec_suspend,
 	.resume			= tas2770_codec_resume,
-	.set_bias_level = tas2770_set_bias_level,
 	.controls		= tas2770_snd_controls,
 	.num_controls		= ARRAY_SIZE(tas2770_snd_controls),
 	.dapm_widgets		= tas2770_dapm_widgets,


