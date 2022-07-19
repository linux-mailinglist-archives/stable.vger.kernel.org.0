Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57CB579D9F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242059AbiGSMxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242002AbiGSMw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:52:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96809904CF;
        Tue, 19 Jul 2022 05:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93653618D1;
        Tue, 19 Jul 2022 12:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83DC341CA;
        Tue, 19 Jul 2022 12:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233242;
        bh=ZG3776QSZuja70voJ1g0ymRaEyAfYER6qQIvzhPcQ40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSzyhA2/h4nhmqOKArABMeuis4nv/yQaqlX3BbfpeqwP6ERmDiRzUxiVS6hr8FxF0
         hdpPARw1qc18wsD/HmFtDOPxCEhGp3WEpNZ8nwrQqxuVQrE4oa4S6cXyuuhM1jS4iD
         e5zyGN+i7WQcjICdbmoHOLHSythi7Ms6IymskUXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 055/231] ASoC: tas2764: Fix and extend FSYNC polarity handling
Date:   Tue, 19 Jul 2022 13:52:20 +0200
Message-Id: <20220719114718.833333062@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit d1a10f1b48202e2d183cce144c218a211e98d906 ]

Fix setting of FSYNC polarity in case of LEFT_J and DSP_A/B formats.
Do NOT set the SCFG field as was previously done, because that is not
correct and is also in conflict with the "ASI1 Source" control which
sets the same SCFG field!

Also add support for explicit polarity inversion.

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220630075135.2221-2-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 30 +++++++++++++++++-------------
 sound/soc/codecs/tas2764.h |  6 ++----
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index edc66ff6dc49..46c815650b2c 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -135,7 +135,8 @@ static const char * const tas2764_ASI1_src[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(
-	tas2764_ASI1_src_enum, TAS2764_TDM_CFG2, 4, tas2764_ASI1_src);
+	tas2764_ASI1_src_enum, TAS2764_TDM_CFG2, TAS2764_TDM_CFG2_SCFG_SHIFT,
+	tas2764_ASI1_src);
 
 static const struct snd_kcontrol_new tas2764_asi1_mux =
 	SOC_DAPM_ENUM("ASI1 Source", tas2764_ASI1_src_enum);
@@ -333,20 +334,22 @@ static int tas2764_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 {
 	struct snd_soc_component *component = dai->component;
 	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
-	u8 tdm_rx_start_slot = 0, asi_cfg_1 = 0;
-	int iface;
+	u8 tdm_rx_start_slot = 0, asi_cfg_0 = 0, asi_cfg_1 = 0;
 	int ret;
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_IF:
+		asi_cfg_0 ^= TAS2764_TDM_CFG0_FRAME_START;
+		fallthrough;
 	case SND_SOC_DAIFMT_NB_NF:
 		asi_cfg_1 = TAS2764_TDM_CFG1_RX_RISING;
 		break;
+	case SND_SOC_DAIFMT_IB_IF:
+		asi_cfg_0 ^= TAS2764_TDM_CFG0_FRAME_START;
+		fallthrough;
 	case SND_SOC_DAIFMT_IB_NF:
 		asi_cfg_1 = TAS2764_TDM_CFG1_RX_FALLING;
 		break;
-	default:
-		dev_err(tas2764->dev, "ASI format Inverse is not found\n");
-		return -EINVAL;
 	}
 
 	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG1,
@@ -357,13 +360,13 @@ static int tas2764_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
+		asi_cfg_0 ^= TAS2764_TDM_CFG0_FRAME_START;
+		fallthrough;
 	case SND_SOC_DAIFMT_DSP_A:
-		iface = TAS2764_TDM_CFG2_SCFG_I2S;
 		tdm_rx_start_slot = 1;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
 	case SND_SOC_DAIFMT_LEFT_J:
-		iface = TAS2764_TDM_CFG2_SCFG_LEFT_J;
 		tdm_rx_start_slot = 0;
 		break;
 	default:
@@ -372,14 +375,15 @@ static int tas2764_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
-	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG1,
-					    TAS2764_TDM_CFG1_MASK,
-					    (tdm_rx_start_slot << TAS2764_TDM_CFG1_51_SHIFT));
+	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG0,
+					    TAS2764_TDM_CFG0_FRAME_START,
+					    asi_cfg_0);
 	if (ret < 0)
 		return ret;
 
-	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG2,
-					    TAS2764_TDM_CFG2_SCFG_MASK, iface);
+	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG1,
+					    TAS2764_TDM_CFG1_MASK,
+					    (tdm_rx_start_slot << TAS2764_TDM_CFG1_51_SHIFT));
 	if (ret < 0)
 		return ret;
 
diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index 67d6fd903c42..f015f22a083b 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -47,6 +47,7 @@
 #define TAS2764_TDM_CFG0_MASK		GENMASK(3, 1)
 #define TAS2764_TDM_CFG0_44_1_48KHZ	BIT(3)
 #define TAS2764_TDM_CFG0_88_2_96KHZ	(BIT(3) | BIT(1))
+#define TAS2764_TDM_CFG0_FRAME_START	BIT(0)
 
 /* TDM Configuration Reg1 */
 #define TAS2764_TDM_CFG1		TAS2764_REG(0X0, 0x09)
@@ -66,10 +67,7 @@
 #define TAS2764_TDM_CFG2_RXS_16BITS	0x0
 #define TAS2764_TDM_CFG2_RXS_24BITS	BIT(0)
 #define TAS2764_TDM_CFG2_RXS_32BITS	BIT(1)
-#define TAS2764_TDM_CFG2_SCFG_MASK	GENMASK(5, 4)
-#define TAS2764_TDM_CFG2_SCFG_I2S	0x0
-#define TAS2764_TDM_CFG2_SCFG_LEFT_J	BIT(4)
-#define TAS2764_TDM_CFG2_SCFG_RIGHT_J	BIT(5)
+#define TAS2764_TDM_CFG2_SCFG_SHIFT	4
 
 /* TDM Configuration Reg3 */
 #define TAS2764_TDM_CFG3		TAS2764_REG(0X0, 0x0c)
-- 
2.35.1



