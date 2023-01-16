Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0A666C500
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjAPQAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjAPQA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE2323C5E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B71AB8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25FFC433F0;
        Mon, 16 Jan 2023 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884822;
        bh=y9xZbSk68/0vj//GZLoNIEb9xPGErQ1Js4FGjFoGyJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpJdv8q24IK79MtwfApgYzGLzvmq19ACOCCE7IdVcI7y6GynKY6oUb57UGl+p8Iv2
         ZYOopK+lpmHJiQ5gVE5gzgvRpI596fWIl0HmkTUvoPr0eOd2pPljELP/pfqk7ZCMUF
         dMNpgO6yCq8kmV4pjWNVKnUbJOOWFPZLvP7/K9tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/183] ASoC: qcom: Fix building APQ8016 machine driver without SOUNDWIRE
Date:   Mon, 16 Jan 2023 16:50:58 +0100
Message-Id: <20230116154809.070687461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 0cbf1ecd8c4801ec7566231491f7ad9cec31098b ]

Older Qualcomm platforms like APQ8016 do not have hardware support for
SoundWire, so kernel configurations made specifically for those platforms
will usually not have CONFIG_SOUNDWIRE enabled.

Unfortunately commit 8d89cf6ff229 ("ASoC: qcom: cleanup and fix
dependency of QCOM_COMMON") breaks those kernel configurations, because
SOUNDWIRE is now a required dependency for SND_SOC_QCOM_COMMON (and in
turn also SND_SOC_APQ8016_SBC). Trying to migrate such a kernel config
silently disables SND_SOC_APQ8016_SBC and breaks audio functionality.

The soundwire helpers in common.c are only used by two of the Qualcomm
audio machine drivers, so building and requiring CONFIG_SOUNDWIRE for
all platforms is unnecessary.

There is no need to stuff all common code into a single module. Fix the
issue by moving the soundwire helpers to a separate SND_SOC_QCOM_SDW
module/option that is selected only by the machine drivers that make
use of them. This also allows reverting the imply/depends changes from
the previous fix because both SM8250 and SC8280XP already depend on
SOUNDWIRE, so the soundwire helpers will be only built if SOUNDWIRE
is really enabled.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 8d89cf6ff229 ("ASoC: qcom: cleanup and fix dependency of QCOM_COMMON")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20221231115506.82991-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/Kconfig    |  21 ++++---
 sound/soc/qcom/Makefile   |   2 +
 sound/soc/qcom/common.c   | 114 -----------------------------------
 sound/soc/qcom/common.h   |  10 ----
 sound/soc/qcom/sc8280xp.c |   1 +
 sound/soc/qcom/sdw.c      | 123 ++++++++++++++++++++++++++++++++++++++
 sound/soc/qcom/sdw.h      |  18 ++++++
 sound/soc/qcom/sm8250.c   |   1 +
 8 files changed, 157 insertions(+), 133 deletions(-)
 create mode 100644 sound/soc/qcom/sdw.c
 create mode 100644 sound/soc/qcom/sdw.h

diff --git a/sound/soc/qcom/Kconfig b/sound/soc/qcom/Kconfig
index 96a6d4731e6f..e7b00d1d9e99 100644
--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -2,7 +2,6 @@
 menuconfig SND_SOC_QCOM
 	tristate "ASoC support for QCOM platforms"
 	depends on ARCH_QCOM || COMPILE_TEST
-	imply SND_SOC_QCOM_COMMON
 	help
 	  Say Y or M if you want to add support to use audio devices
 	  in Qualcomm Technologies SOC-based platforms.
@@ -60,14 +59,16 @@ config SND_SOC_STORM
 config SND_SOC_APQ8016_SBC
 	tristate "SoC Audio support for APQ8016 SBC platforms"
 	select SND_SOC_LPASS_APQ8016
-	depends on SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_COMMON
 	help
 	  Support for Qualcomm Technologies LPASS audio block in
 	  APQ8016 SOC-based systems.
 	  Say Y if you want to use audio devices on MI2S.
 
 config SND_SOC_QCOM_COMMON
-	depends on SOUNDWIRE
+	tristate
+
+config SND_SOC_QCOM_SDW
 	tristate
 
 config SND_SOC_QDSP6_COMMON
@@ -144,7 +145,7 @@ config SND_SOC_MSM8996
 	depends on QCOM_APR
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	depends on SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_COMMON
 	help
 	  Support for Qualcomm Technologies LPASS audio block in
 	  APQ8096 SoC-based systems.
@@ -155,7 +156,7 @@ config SND_SOC_SDM845
 	depends on QCOM_APR && I2C && SOUNDWIRE
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	depends on SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_COMMON
 	select SND_SOC_RT5663
 	select SND_SOC_MAX98927
 	imply SND_SOC_CROS_EC_CODEC
@@ -169,7 +170,8 @@ config SND_SOC_SM8250
 	depends on QCOM_APR && SOUNDWIRE
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	depends on SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_SDW
 	help
 	  To add support for audio on Qualcomm Technologies Inc.
 	  SM8250 SoC-based systems.
@@ -180,7 +182,8 @@ config SND_SOC_SC8280XP
 	depends on QCOM_APR && SOUNDWIRE
 	depends on COMMON_CLK
 	select SND_SOC_QDSP6
-	depends on SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_SDW
 	help
 	  To add support for audio on Qualcomm Technologies Inc.
 	  SC8280XP SoC-based systems.
@@ -190,7 +193,7 @@ config SND_SOC_SC7180
 	tristate "SoC Machine driver for SC7180 boards"
 	depends on I2C && GPIOLIB
 	depends on SOUNDWIRE || SOUNDWIRE=n
-	depends on SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_COMMON
 	select SND_SOC_LPASS_SC7180
 	select SND_SOC_MAX98357A
 	select SND_SOC_RT5682_I2C
@@ -204,7 +207,7 @@ config SND_SOC_SC7180
 config SND_SOC_SC7280
 	tristate "SoC Machine driver for SC7280 boards"
 	depends on I2C && SOUNDWIRE
-	depends on SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_COMMON
 	select SND_SOC_LPASS_SC7280
 	select SND_SOC_MAX98357A
 	select SND_SOC_WCD938X_SDW
diff --git a/sound/soc/qcom/Makefile b/sound/soc/qcom/Makefile
index 8b97172cf990..254350d9dc06 100644
--- a/sound/soc/qcom/Makefile
+++ b/sound/soc/qcom/Makefile
@@ -28,6 +28,7 @@ snd-soc-sdm845-objs := sdm845.o
 snd-soc-sm8250-objs := sm8250.o
 snd-soc-sc8280xp-objs := sc8280xp.o
 snd-soc-qcom-common-objs := common.o
+snd-soc-qcom-sdw-objs := sdw.o
 
 obj-$(CONFIG_SND_SOC_STORM) += snd-soc-storm.o
 obj-$(CONFIG_SND_SOC_APQ8016_SBC) += snd-soc-apq8016-sbc.o
@@ -38,6 +39,7 @@ obj-$(CONFIG_SND_SOC_SC8280XP) += snd-soc-sc8280xp.o
 obj-$(CONFIG_SND_SOC_SDM845) += snd-soc-sdm845.o
 obj-$(CONFIG_SND_SOC_SM8250) += snd-soc-sm8250.o
 obj-$(CONFIG_SND_SOC_QCOM_COMMON) += snd-soc-qcom-common.o
+obj-$(CONFIG_SND_SOC_QCOM_SDW) += snd-soc-qcom-sdw.o
 
 #DSP lib
 obj-$(CONFIG_SND_SOC_QDSP6) += qdsp6/
diff --git a/sound/soc/qcom/common.c b/sound/soc/qcom/common.c
index 49c74c1662a3..96fe80241fb4 100644
--- a/sound/soc/qcom/common.c
+++ b/sound/soc/qcom/common.c
@@ -180,120 +180,6 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 }
 EXPORT_SYMBOL_GPL(qcom_snd_parse_of);
 
-int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *sruntime,
-			 bool *stream_prepared)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
-	int ret;
-
-	if (!sruntime)
-		return 0;
-
-	switch (cpu_dai->id) {
-	case WSA_CODEC_DMA_RX_0:
-	case WSA_CODEC_DMA_RX_1:
-	case RX_CODEC_DMA_RX_0:
-	case RX_CODEC_DMA_RX_1:
-	case TX_CODEC_DMA_TX_0:
-	case TX_CODEC_DMA_TX_1:
-	case TX_CODEC_DMA_TX_2:
-	case TX_CODEC_DMA_TX_3:
-		break;
-	default:
-		return 0;
-	}
-
-	if (*stream_prepared) {
-		sdw_disable_stream(sruntime);
-		sdw_deprepare_stream(sruntime);
-		*stream_prepared = false;
-	}
-
-	ret = sdw_prepare_stream(sruntime);
-	if (ret)
-		return ret;
-
-	/**
-	 * NOTE: there is a strict hw requirement about the ordering of port
-	 * enables and actual WSA881x PA enable. PA enable should only happen
-	 * after soundwire ports are enabled if not DC on the line is
-	 * accumulated resulting in Click/Pop Noise
-	 * PA enable/mute are handled as part of codec DAPM and digital mute.
-	 */
-
-	ret = sdw_enable_stream(sruntime);
-	if (ret) {
-		sdw_deprepare_stream(sruntime);
-		return ret;
-	}
-	*stream_prepared  = true;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(qcom_snd_sdw_prepare);
-
-int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
-			   struct snd_pcm_hw_params *params,
-			   struct sdw_stream_runtime **psruntime)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai;
-	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
-	struct sdw_stream_runtime *sruntime;
-	int i;
-
-	switch (cpu_dai->id) {
-	case WSA_CODEC_DMA_RX_0:
-	case RX_CODEC_DMA_RX_0:
-	case RX_CODEC_DMA_RX_1:
-	case TX_CODEC_DMA_TX_0:
-	case TX_CODEC_DMA_TX_1:
-	case TX_CODEC_DMA_TX_2:
-	case TX_CODEC_DMA_TX_3:
-		for_each_rtd_codec_dais(rtd, i, codec_dai) {
-			sruntime = snd_soc_dai_get_stream(codec_dai, substream->stream);
-			if (sruntime != ERR_PTR(-ENOTSUPP))
-				*psruntime = sruntime;
-		}
-		break;
-	}
-
-	return 0;
-
-}
-EXPORT_SYMBOL_GPL(qcom_snd_sdw_hw_params);
-
-int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *sruntime, bool *stream_prepared)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
-
-	switch (cpu_dai->id) {
-	case WSA_CODEC_DMA_RX_0:
-	case WSA_CODEC_DMA_RX_1:
-	case RX_CODEC_DMA_RX_0:
-	case RX_CODEC_DMA_RX_1:
-	case TX_CODEC_DMA_TX_0:
-	case TX_CODEC_DMA_TX_1:
-	case TX_CODEC_DMA_TX_2:
-	case TX_CODEC_DMA_TX_3:
-		if (sruntime && *stream_prepared) {
-			sdw_disable_stream(sruntime);
-			sdw_deprepare_stream(sruntime);
-			*stream_prepared = false;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(qcom_snd_sdw_hw_free);
-
 int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 			    struct snd_soc_jack *jack, bool *jack_setup)
 {
diff --git a/sound/soc/qcom/common.h b/sound/soc/qcom/common.h
index 3ef5bb6d12df..d7f80ee5ae26 100644
--- a/sound/soc/qcom/common.h
+++ b/sound/soc/qcom/common.h
@@ -5,19 +5,9 @@
 #define __QCOM_SND_COMMON_H__
 
 #include <sound/soc.h>
-#include <linux/soundwire/sdw.h>
 
 int qcom_snd_parse_of(struct snd_soc_card *card);
 int qcom_snd_wcd_jack_setup(struct snd_soc_pcm_runtime *rtd,
 			    struct snd_soc_jack *jack, bool *jack_setup);
 
-int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *runtime,
-			 bool *stream_prepared);
-int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
-			   struct snd_pcm_hw_params *params,
-			   struct sdw_stream_runtime **psruntime);
-int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *sruntime,
-			 bool *stream_prepared);
 #endif
diff --git a/sound/soc/qcom/sc8280xp.c b/sound/soc/qcom/sc8280xp.c
index ade44ad7c585..14d9fea33d16 100644
--- a/sound/soc/qcom/sc8280xp.c
+++ b/sound/soc/qcom/sc8280xp.c
@@ -12,6 +12,7 @@
 #include <linux/input-event-codes.h>
 #include "qdsp6/q6afe.h"
 #include "common.h"
+#include "sdw.h"
 
 #define DRIVER_NAME		"sc8280xp"
 
diff --git a/sound/soc/qcom/sdw.c b/sound/soc/qcom/sdw.c
new file mode 100644
index 000000000000..10249519a39e
--- /dev/null
+++ b/sound/soc/qcom/sdw.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018, Linaro Limited.
+// Copyright (c) 2018, The Linux Foundation. All rights reserved.
+
+#include <linux/module.h>
+#include <sound/soc.h>
+#include "qdsp6/q6afe.h"
+#include "sdw.h"
+
+int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
+			 struct sdw_stream_runtime *sruntime,
+			 bool *stream_prepared)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+	int ret;
+
+	if (!sruntime)
+		return 0;
+
+	switch (cpu_dai->id) {
+	case WSA_CODEC_DMA_RX_0:
+	case WSA_CODEC_DMA_RX_1:
+	case RX_CODEC_DMA_RX_0:
+	case RX_CODEC_DMA_RX_1:
+	case TX_CODEC_DMA_TX_0:
+	case TX_CODEC_DMA_TX_1:
+	case TX_CODEC_DMA_TX_2:
+	case TX_CODEC_DMA_TX_3:
+		break;
+	default:
+		return 0;
+	}
+
+	if (*stream_prepared) {
+		sdw_disable_stream(sruntime);
+		sdw_deprepare_stream(sruntime);
+		*stream_prepared = false;
+	}
+
+	ret = sdw_prepare_stream(sruntime);
+	if (ret)
+		return ret;
+
+	/**
+	 * NOTE: there is a strict hw requirement about the ordering of port
+	 * enables and actual WSA881x PA enable. PA enable should only happen
+	 * after soundwire ports are enabled if not DC on the line is
+	 * accumulated resulting in Click/Pop Noise
+	 * PA enable/mute are handled as part of codec DAPM and digital mute.
+	 */
+
+	ret = sdw_enable_stream(sruntime);
+	if (ret) {
+		sdw_deprepare_stream(sruntime);
+		return ret;
+	}
+	*stream_prepared  = true;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_snd_sdw_prepare);
+
+int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
+			   struct snd_pcm_hw_params *params,
+			   struct sdw_stream_runtime **psruntime)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai;
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+	struct sdw_stream_runtime *sruntime;
+	int i;
+
+	switch (cpu_dai->id) {
+	case WSA_CODEC_DMA_RX_0:
+	case RX_CODEC_DMA_RX_0:
+	case RX_CODEC_DMA_RX_1:
+	case TX_CODEC_DMA_TX_0:
+	case TX_CODEC_DMA_TX_1:
+	case TX_CODEC_DMA_TX_2:
+	case TX_CODEC_DMA_TX_3:
+		for_each_rtd_codec_dais(rtd, i, codec_dai) {
+			sruntime = snd_soc_dai_get_stream(codec_dai, substream->stream);
+			if (sruntime != ERR_PTR(-ENOTSUPP))
+				*psruntime = sruntime;
+		}
+		break;
+	}
+
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(qcom_snd_sdw_hw_params);
+
+int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
+			 struct sdw_stream_runtime *sruntime, bool *stream_prepared)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+
+	switch (cpu_dai->id) {
+	case WSA_CODEC_DMA_RX_0:
+	case WSA_CODEC_DMA_RX_1:
+	case RX_CODEC_DMA_RX_0:
+	case RX_CODEC_DMA_RX_1:
+	case TX_CODEC_DMA_TX_0:
+	case TX_CODEC_DMA_TX_1:
+	case TX_CODEC_DMA_TX_2:
+	case TX_CODEC_DMA_TX_3:
+		if (sruntime && *stream_prepared) {
+			sdw_disable_stream(sruntime);
+			sdw_deprepare_stream(sruntime);
+			*stream_prepared = false;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_snd_sdw_hw_free);
+MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/qcom/sdw.h b/sound/soc/qcom/sdw.h
new file mode 100644
index 000000000000..d74cbb84da13
--- /dev/null
+++ b/sound/soc/qcom/sdw.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+// Copyright (c) 2018, The Linux Foundation. All rights reserved.
+
+#ifndef __QCOM_SND_SDW_H__
+#define __QCOM_SND_SDW_H__
+
+#include <linux/soundwire/sdw.h>
+
+int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
+			 struct sdw_stream_runtime *runtime,
+			 bool *stream_prepared);
+int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
+			   struct snd_pcm_hw_params *params,
+			   struct sdw_stream_runtime **psruntime);
+int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
+			 struct sdw_stream_runtime *sruntime,
+			 bool *stream_prepared);
+#endif
diff --git a/sound/soc/qcom/sm8250.c b/sound/soc/qcom/sm8250.c
index 8dbe9ef41b1c..9626a9ef78c2 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -12,6 +12,7 @@
 #include <linux/input-event-codes.h>
 #include "qdsp6/q6afe.h"
 #include "common.h"
+#include "sdw.h"
 
 #define DRIVER_NAME		"sm8250"
 #define MI2S_BCLK_RATE		1536000
-- 
2.35.1



