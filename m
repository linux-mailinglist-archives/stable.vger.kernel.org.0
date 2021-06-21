Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A83AF017
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhFUQqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhFUQnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D788C613B0;
        Mon, 21 Jun 2021 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293119;
        bh=p+7NsAlql8/K0DWE4g/lK3f5Roe0GJ3MYo0VhnV77eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGUlA1nBDasW9Ge9p2PiRlYZyj+LBw8mPijCswElva+mqr0pN7ZRkFTVaeqCzMFlz
         Qe+kP19roAFBSROK1T3mG5xnbXHJNAVoqM+mJUOdN9T+b2L83Tp9mWRpNQqDgg3DNU
         svH+A2JemJaM5RFx5JznjyTmu44Tn2Ie12nyEJJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Judy Hsiao <judyhsiao@chromium.org>,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 106/178] ASoC: qcom: lpass-cpu: Fix pop noise during audio capture begin
Date:   Mon, 21 Jun 2021 18:15:20 +0200
Message-Id: <20210621154926.378677329@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

[ Upstream commit c8a4556d98510ca05bad8d02265a4918b03a8c0b ]

This patch fixes PoP noise of around 15ms observed during audio
capture begin.
Enables BCLK and LRCLK in snd_soc_dai_ops prepare call for
introducing some delay before capture start.

(am from https://patchwork.kernel.org/patch/12276369/)
(also found at https://lore.kernel.org/r/20210524142114.18676-1-srivasam@codeaurora.org)

Co-developed-by: Judy Hsiao <judyhsiao@chromium.org>
Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210604154545.1198337-1-judyhsiao@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 79 ++++++++++++++++++++++++++++++++++++++
 sound/soc/qcom/lpass.h     |  4 ++
 2 files changed, 83 insertions(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 936384a94f25..74d3d8c58608 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -93,8 +93,30 @@ static void lpass_cpu_daiops_shutdown(struct snd_pcm_substream *substream,
 		struct snd_soc_dai *dai)
 {
 	struct lpass_data *drvdata = snd_soc_dai_get_drvdata(dai);
+	struct lpaif_i2sctl *i2sctl = drvdata->i2sctl;
+	unsigned int id = dai->driver->id;
 
 	clk_disable_unprepare(drvdata->mi2s_osr_clk[dai->driver->id]);
+	/*
+	 * Ensure LRCLK is disabled even in device node validation.
+	 * Will not impact if disabled in lpass_cpu_daiops_trigger()
+	 * suspend.
+	 */
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		regmap_fields_write(i2sctl->spken, id, LPAIF_I2SCTL_SPKEN_DISABLE);
+	else
+		regmap_fields_write(i2sctl->micen, id, LPAIF_I2SCTL_MICEN_DISABLE);
+
+	/*
+	 * BCLK may not be enabled if lpass_cpu_daiops_prepare is called before
+	 * lpass_cpu_daiops_shutdown. It's paired with the clk_enable in
+	 * lpass_cpu_daiops_prepare.
+	 */
+	if (drvdata->mi2s_was_prepared[dai->driver->id]) {
+		drvdata->mi2s_was_prepared[dai->driver->id] = false;
+		clk_disable(drvdata->mi2s_bit_clk[dai->driver->id]);
+	}
+
 	clk_unprepare(drvdata->mi2s_bit_clk[dai->driver->id]);
 }
 
@@ -275,6 +297,18 @@ static int lpass_cpu_daiops_trigger(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		/*
+		 * Ensure lpass BCLK/LRCLK is enabled during
+		 * device resume as lpass_cpu_daiops_prepare() is not called
+		 * after the device resumes. We don't check mi2s_was_prepared before
+		 * enable/disable BCLK in trigger events because:
+		 *  1. These trigger events are paired, so the BCLK
+		 *     enable_count is balanced.
+		 *  2. the BCLK can be shared (ex: headset and headset mic),
+		 *     we need to increase the enable_count so that we don't
+		 *     turn off the shared BCLK while other devices are using
+		 *     it.
+		 */
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			ret = regmap_fields_write(i2sctl->spken, id,
 						 LPAIF_I2SCTL_SPKEN_ENABLE);
@@ -296,6 +330,10 @@ static int lpass_cpu_daiops_trigger(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		/*
+		 * To ensure lpass BCLK/LRCLK is disabled during
+		 * device suspend.
+		 */
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			ret = regmap_fields_write(i2sctl->spken, id,
 						 LPAIF_I2SCTL_SPKEN_DISABLE);
@@ -315,12 +353,53 @@ static int lpass_cpu_daiops_trigger(struct snd_pcm_substream *substream,
 	return ret;
 }
 
+static int lpass_cpu_daiops_prepare(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *dai)
+{
+	struct lpass_data *drvdata = snd_soc_dai_get_drvdata(dai);
+	struct lpaif_i2sctl *i2sctl = drvdata->i2sctl;
+	unsigned int id = dai->driver->id;
+	int ret;
+
+	/*
+	 * Ensure lpass BCLK/LRCLK is enabled bit before playback/capture
+	 * data flow starts. This allows other codec to have some delay before
+	 * the data flow.
+	 * (ex: to drop start up pop noise before capture starts).
+	 */
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		ret = regmap_fields_write(i2sctl->spken, id, LPAIF_I2SCTL_SPKEN_ENABLE);
+	else
+		ret = regmap_fields_write(i2sctl->micen, id, LPAIF_I2SCTL_MICEN_ENABLE);
+
+	if (ret) {
+		dev_err(dai->dev, "error writing to i2sctl reg: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * Check mi2s_was_prepared before enabling BCLK as lpass_cpu_daiops_prepare can
+	 * be called multiple times. It's paired with the clk_disable in
+	 * lpass_cpu_daiops_shutdown.
+	 */
+	if (!drvdata->mi2s_was_prepared[dai->driver->id]) {
+		ret = clk_enable(drvdata->mi2s_bit_clk[id]);
+		if (ret) {
+			dev_err(dai->dev, "error in enabling mi2s bit clk: %d\n", ret);
+			return ret;
+		}
+		drvdata->mi2s_was_prepared[dai->driver->id] = true;
+	}
+	return 0;
+}
+
 const struct snd_soc_dai_ops asoc_qcom_lpass_cpu_dai_ops = {
 	.set_sysclk	= lpass_cpu_daiops_set_sysclk,
 	.startup	= lpass_cpu_daiops_startup,
 	.shutdown	= lpass_cpu_daiops_shutdown,
 	.hw_params	= lpass_cpu_daiops_hw_params,
 	.trigger	= lpass_cpu_daiops_trigger,
+	.prepare	= lpass_cpu_daiops_prepare,
 };
 EXPORT_SYMBOL_GPL(asoc_qcom_lpass_cpu_dai_ops);
 
diff --git a/sound/soc/qcom/lpass.h b/sound/soc/qcom/lpass.h
index 83b2e08ade06..7f72214404ba 100644
--- a/sound/soc/qcom/lpass.h
+++ b/sound/soc/qcom/lpass.h
@@ -67,6 +67,10 @@ struct lpass_data {
 	/* MI2S SD lines to use for playback/capture */
 	unsigned int mi2s_playback_sd_mode[LPASS_MAX_MI2S_PORTS];
 	unsigned int mi2s_capture_sd_mode[LPASS_MAX_MI2S_PORTS];
+
+	/* The state of MI2S prepare dai_ops was called */
+	bool mi2s_was_prepared[LPASS_MAX_MI2S_PORTS];
+
 	int hdmi_port_enable;
 
 	/* low-power audio interface (LPAIF) registers */
-- 
2.30.2



