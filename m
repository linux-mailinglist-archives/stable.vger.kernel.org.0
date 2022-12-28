Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92EA657E16
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiL1PuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbiL1Ptx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:49:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD0183A9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:49:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD68B81733
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CDDC433D2;
        Wed, 28 Dec 2022 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242589;
        bh=AeuYrHL1UAeS44Ad7IVUw50JUV7TwgCyFkcgzbm1FV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfJWF5LkVloyrn/UGOkwix5WODBQ1DEwGRAaxcfursQh9WyVP4ISx9BQ+ILFeA1al
         qh9aSCY0MN+GRIhdvyOYTTYdXH+J5MI8/10e5P/mud4839W4Bhv2dxHrgUjYwBBSEA
         SzhWplTM1Mw78SsokBFgtJkR1um59QqNhuhCd/Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0391/1146] ASoC: qcom: cleanup and fix dependency of QCOM_COMMON
Date:   Wed, 28 Dec 2022 15:32:10 +0100
Message-Id: <20221228144340.786381545@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 8d89cf6ff229ff31cd4f73f5b3928564b81fc41e ]

SND_SOC_QCOM_COMMON depends on SOUNDWIRE for some symbols but this
is not explicitly specified using Kconfig depends. On the other hand
SND_SOC_QCOM_COMMON is also directly selected by the sound card
Kconfigs, this could result in various combinations and some symbols
ending up in modules and soundcard that uses those symbols as in-build
driver.

Fix these issues by explicitly specifying the dependencies of
SND_SOC_QCOM_COMMON and also use imply a to select SND_SOC_QCOM_COMMON
so that the symbol is selected based on its dependencies.

Also remove dummy stubs in common.c around CONFIG_SOUNDWIRE

Fixes: 3bd975f3ae0a ("ASoC: qcom: sm8250: move some code to common")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221124140351.407506-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/Kconfig  | 16 +++++++++-------
 sound/soc/qcom/common.c |  2 --
 sound/soc/qcom/common.h | 23 -----------------------
 3 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/sound/soc/qcom/Kconfig b/sound/soc/qcom/Kconfig
index 8c7398bc1ca8..96a6d4731e6f 100644
--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -2,6 +2,7 @@
 menuconfig SND_SOC_QCOM
 	tristate "ASoC support for QCOM platforms"
 	depends on ARCH_QCOM || COMPILE_TEST
+	imply SND_SOC_QCOM_COMMON
 	help
 	  Say Y or M if you want to add support to use audio devices
 	  in Qualcomm Technologies SOC-based platforms.
@@ -59,13 +60,14 @@ config SND_SOC_STORM
 config SND_SOC_APQ8016_SBC
 	tristate "SoC Audio support for APQ8016 SBC platforms"
 	select SND_SOC_LPASS_APQ8016
-	select SND_SOC_QCOM_COMMON
+	depends on SND_SOC_QCOM_COMMON
 	help
 	  Support for Qualcomm Technologies LPASS audio block in
 	  APQ8016 SOC-based systems.
 	  Say Y if you want to use audio devices on MI2S.
 
 config SND_SOC_QCOM_COMMON
+	depends on SOUNDWIRE
 	tristate
 
 config SND_SOC_QDSP6_COMMON
@@ -142,7 +144,7 @@ config SND_SOC_MSM8996
 	depends on QCOM_APR
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	select SND_SOC_QCOM_COMMON
+	depends on SND_SOC_QCOM_COMMON
 	help
 	  Support for Qualcomm Technologies LPASS audio block in
 	  APQ8096 SoC-based systems.
@@ -153,7 +155,7 @@ config SND_SOC_SDM845
 	depends on QCOM_APR && I2C && SOUNDWIRE
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	select SND_SOC_QCOM_COMMON
+	depends on SND_SOC_QCOM_COMMON
 	select SND_SOC_RT5663
 	select SND_SOC_MAX98927
 	imply SND_SOC_CROS_EC_CODEC
@@ -167,7 +169,7 @@ config SND_SOC_SM8250
 	depends on QCOM_APR && SOUNDWIRE
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	select SND_SOC_QCOM_COMMON
+	depends on SND_SOC_QCOM_COMMON
 	help
 	  To add support for audio on Qualcomm Technologies Inc.
 	  SM8250 SoC-based systems.
@@ -178,7 +180,7 @@ config SND_SOC_SC8280XP
 	depends on QCOM_APR && SOUNDWIRE
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	select SND_SOC_QCOM_COMMON
+	depends on SND_SOC_QCOM_COMMON
 	help
 	  To add support for audio on Qualcomm Technologies Inc.
 	  SC8280XP SoC-based systems.
@@ -188,7 +190,7 @@ config SND_SOC_SC7180
 	tristate "SoC Machine driver for SC7180 boards"
 	depends on I2C && GPIOLIB
 	depends on SOUNDWIRE || SOUNDWIRE=n
-	select SND_SOC_QCOM_COMMON
+	depends on SND_SOC_QCOM_COMMON
 	select SND_SOC_LPASS_SC7180
 	select SND_SOC_MAX98357A
 	select SND_SOC_RT5682_I2C
@@ -202,7 +204,7 @@ config SND_SOC_SC7180
 config SND_SOC_SC7280
 	tristate "SoC Machine driver for SC7280 boards"
 	depends on I2C && SOUNDWIRE
-	select SND_SOC_QCOM_COMMON
+	depends on SND_SOC_QCOM_COMMON
 	select SND_SOC_LPASS_SC7280
 	select SND_SOC_MAX98357A
 	select SND_SOC_WCD938X_SDW
diff --git a/sound/soc/qcom/common.c b/sound/soc/qcom/common.c
index 69dd3b504e20..49c74c1662a3 100644
--- a/sound/soc/qcom/common.c
+++ b/sound/soc/qcom/common.c
@@ -180,7 +180,6 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 }
 EXPORT_SYMBOL_GPL(qcom_snd_parse_of);
 
-#if IS_ENABLED(CONFIG_SOUNDWIRE)
 int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
 			 struct sdw_stream_runtime *sruntime,
 			 bool *stream_prepared)
@@ -294,7 +293,6 @@ int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_snd_sdw_hw_free);
-#endif
 
 int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 			    struct snd_soc_jack *jack, bool *jack_setup)
diff --git a/sound/soc/qcom/common.h b/sound/soc/qcom/common.h
index c5472a642de0..3ef5bb6d12df 100644
--- a/sound/soc/qcom/common.h
+++ b/sound/soc/qcom/common.h
@@ -11,7 +11,6 @@ int qcom_snd_parse_of(struct snd_soc_card *card);
 int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 			    struct snd_soc_jack *jack, bool *jack_setup);
 
-#if IS_ENABLED(CONFIG_SOUNDWIRE)
 int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
 			 struct sdw_stream_runtime *runtime,
 			 bool *stream_prepared);
@@ -21,26 +20,4 @@ int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
 int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
 			 struct sdw_stream_runtime *sruntime,
 			 bool *stream_prepared);
-#else
-static inline int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
-				       struct sdw_stream_runtime *runtime,
-				       bool *stream_prepared)
-{
-	return -ENOTSUPP;
-}
-
-static inline int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
-					 struct snd_pcm_hw_params *params,
-					 struct sdw_stream_runtime **psruntime)
-{
-	return -ENOTSUPP;
-}
-
-static inline int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
-				       struct sdw_stream_runtime *sruntime,
-				       bool *stream_prepared)
-{
-	return -ENOTSUPP;
-}
-#endif
 #endif
-- 
2.35.1



