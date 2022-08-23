Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0B559D597
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346280AbiHWImc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243935AbiHWIkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6526B42AEA;
        Tue, 23 Aug 2022 01:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A45F611DD;
        Tue, 23 Aug 2022 08:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B8EC433C1;
        Tue, 23 Aug 2022 08:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242722;
        bh=mTvSXMU+FqVYUEjrCpZyNd5/4xWQ8kzPmC4oXbY4SGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpcYe5nKb/jDeJl4ECx/IejBEemH1z90kBvfAbdqUPFV8hBxlRWWyMZtyifQ86MZJ
         9aRdWapK066XwEK7ELPG1JY0GScLE5b39eadjQhLYDAWacG69BsvgLRnTNPIQo5mnh
         IatMGEB6ZqfzVk07rUGVStrnBxmNBIpdP/zsT3UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 180/365] ASoC: tas2770: Set correct FSYNC polarity
Date:   Tue, 23 Aug 2022 10:01:21 +0200
Message-Id: <20220823080125.757707186@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

commit e9ac31f0a5d0e246b046c20348954519f91a297f upstream.

Fix setting of FSYNC polarity for DAI formats other than I2S. Also
add support for polarity inversion.

Fixes: 1a476abc723e ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220808141246.5749-2-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2770.c |   20 +++++++++++++++++++-
 sound/soc/codecs/tas2770.h |    3 +++
 2 files changed, 22 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -337,7 +337,7 @@ static int tas2770_set_fmt(struct snd_so
 	struct snd_soc_component *component = dai->component;
 	struct tas2770_priv *tas2770 =
 			snd_soc_component_get_drvdata(component);
-	u8 tdm_rx_start_slot = 0, asi_cfg_1 = 0;
+	u8 tdm_rx_start_slot = 0, invert_fpol = 0, fpol_preinv = 0, asi_cfg_1 = 0;
 	int ret;
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -349,9 +349,15 @@ static int tas2770_set_fmt(struct snd_so
 	}
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_IF:
+		invert_fpol = 1;
+		fallthrough;
 	case SND_SOC_DAIFMT_NB_NF:
 		asi_cfg_1 |= TAS2770_TDM_CFG_REG1_RX_RSING;
 		break;
+	case SND_SOC_DAIFMT_IB_IF:
+		invert_fpol = 1;
+		fallthrough;
 	case SND_SOC_DAIFMT_IB_NF:
 		asi_cfg_1 |= TAS2770_TDM_CFG_REG1_RX_FALING;
 		break;
@@ -369,15 +375,19 @@ static int tas2770_set_fmt(struct snd_so
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
 		tdm_rx_start_slot = 1;
+		fpol_preinv = 0;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
 		tdm_rx_start_slot = 0;
+		fpol_preinv = 1;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
 		tdm_rx_start_slot = 1;
+		fpol_preinv = 1;
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
 		tdm_rx_start_slot = 0;
+		fpol_preinv = 1;
 		break;
 	default:
 		dev_err(tas2770->dev,
@@ -391,6 +401,14 @@ static int tas2770_set_fmt(struct snd_so
 	if (ret < 0)
 		return ret;
 
+	ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG0,
+					    TAS2770_TDM_CFG_REG0_FPOL_MASK,
+					    (fpol_preinv ^ invert_fpol)
+					     ? TAS2770_TDM_CFG_REG0_FPOL_RSING
+					     : TAS2770_TDM_CFG_REG0_FPOL_FALING);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
--- a/sound/soc/codecs/tas2770.h
+++ b/sound/soc/codecs/tas2770.h
@@ -41,6 +41,9 @@
 #define TAS2770_TDM_CFG_REG0_31_44_1_48KHZ  0x6
 #define TAS2770_TDM_CFG_REG0_31_88_2_96KHZ  0x8
 #define TAS2770_TDM_CFG_REG0_31_176_4_192KHZ  0xa
+#define TAS2770_TDM_CFG_REG0_FPOL_MASK  BIT(0)
+#define TAS2770_TDM_CFG_REG0_FPOL_RSING  0
+#define TAS2770_TDM_CFG_REG0_FPOL_FALING  1
     /* TDM Configuration Reg1 */
 #define TAS2770_TDM_CFG_REG1  TAS2770_REG(0X0, 0x0B)
 #define TAS2770_TDM_CFG_REG1_MASK	GENMASK(5, 1)


