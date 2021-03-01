Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28A2328C86
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbhCASx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240431AbhCASq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B777665019;
        Mon,  1 Mar 2021 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618663;
        bh=TLWxD7EFUh2V3do57RgboHDrwvdJab/sEilyXSsC2d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpacG4Wc6Le4C3inUqeMI+1EILgzMrrYsxO3W8plPJrcHBX4wr79EERueArakXevN
         f87lfJAayPKwiwDeIdss4Qwbb5fEoX4xbgRPu8P8IuBiqXfG9bO1EmT/G0bo9cqRnm
         9KFBqmthf1qLhtDAnOdnh02t4C2doemHq5wROpUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/663] ASoC: qcom: qdsp6: Move frontend AIFs to q6asm-dai
Date:   Mon,  1 Mar 2021 17:06:59 +0100
Message-Id: <20210301161150.248703273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 6fd8d2d275f74baa7ac17b2656da1235f56dab99 ]

At the moment it is necessary to set up the DAPM routes between
front-end AIF<->DAI explicitly in the device tree, e.g. using

	audio-routing =
		"MM_DL1", "MultiMedia1 Playback",
		"MM_DL3", "MultiMedia3 Playback",
		"MM_DL4", "MultiMedia4 Playback",
		"MultiMedia2 Capture", "MM_UL2";

This is prone to mistakes and (sadly) there is no clear error if one
of these routes is missing. :(

Actually, this should not be necessary because the ASoC core normally
automatically links AIF<->DAI within snd_soc_dapm_link_dai_widgets().
This is done using the "stname" parameter of SND_SOC_DAPM_AIF_IN/OUT.

For SND_SOC_DAPM_AIF_IN("MM_DL1", "MultiMedia1 Playback", 0, 0, 0, 0),
it should create the route from above: MM_DL1 <-> MultiMedia1 Playback.

This does not work at the moment because the AIF widget (MM_DL1)
and the DAI widget (MultiMedia1 Playback) belong to different
DAPM contexts (q6routing / q6asm-dai).

Fix this by declaring the AIF widgets in the same driver as the DAIs
(q6asm-dai). Now the routes above are created automatically
and no longer need to be specified in the device tree.

This is also more consistent with the back-end AIFs which are already
declared in q6afe-dais instead of q6routing. q6routing should only link
the components together using mixers.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 2a9e92d371db ("ASoC: qdsp6: q6asm: Add q6asm dai driver")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20201211203255.148246-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm-dai.c | 21 +++++++++++++++++++++
 sound/soc/qcom/qdsp6/q6routing.c | 18 ------------------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm-dai.c b/sound/soc/qcom/qdsp6/q6asm-dai.c
index c9ac9c1d26c47..9766725c29166 100644
--- a/sound/soc/qcom/qdsp6/q6asm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6asm-dai.c
@@ -1233,6 +1233,25 @@ static void q6asm_dai_pcm_free(struct snd_soc_component *component,
 	}
 }
 
+static const struct snd_soc_dapm_widget q6asm_dapm_widgets[] = {
+	SND_SOC_DAPM_AIF_IN("MM_DL1", "MultiMedia1 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("MM_DL2", "MultiMedia2 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("MM_DL3", "MultiMedia3 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("MM_DL4", "MultiMedia4 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("MM_DL5", "MultiMedia5 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("MM_DL6", "MultiMedia6 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("MM_DL7", "MultiMedia7 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_IN("MM_DL8", "MultiMedia8 Playback", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL1", "MultiMedia1 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL2", "MultiMedia2 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL3", "MultiMedia3 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL4", "MultiMedia4 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL5", "MultiMedia5 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL6", "MultiMedia6 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL7", "MultiMedia7 Capture", 0, SND_SOC_NOPM, 0, 0),
+	SND_SOC_DAPM_AIF_OUT("MM_UL8", "MultiMedia8 Capture", 0, SND_SOC_NOPM, 0, 0),
+};
+
 static const struct snd_soc_component_driver q6asm_fe_dai_component = {
 	.name		= DRV_NAME,
 	.open		= q6asm_dai_open,
@@ -1245,6 +1264,8 @@ static const struct snd_soc_component_driver q6asm_fe_dai_component = {
 	.pcm_construct	= q6asm_dai_pcm_new,
 	.pcm_destruct	= q6asm_dai_pcm_free,
 	.compress_ops	= &q6asm_dai_compress_ops,
+	.dapm_widgets	= q6asm_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(q6asm_dapm_widgets),
 };
 
 static struct snd_soc_dai_driver q6asm_fe_dais_template[] = {
diff --git a/sound/soc/qcom/qdsp6/q6routing.c b/sound/soc/qcom/qdsp6/q6routing.c
index 53185e26fea17..0a6b9433f6acf 100644
--- a/sound/soc/qcom/qdsp6/q6routing.c
+++ b/sound/soc/qcom/qdsp6/q6routing.c
@@ -713,24 +713,6 @@ static const struct snd_kcontrol_new mmul8_mixer_controls[] = {
 	Q6ROUTING_TX_MIXERS(MSM_FRONTEND_DAI_MULTIMEDIA8) };
 
 static const struct snd_soc_dapm_widget msm_qdsp6_widgets[] = {
-	/* Frontend AIF */
-	SND_SOC_DAPM_AIF_IN("MM_DL1", "MultiMedia1 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_IN("MM_DL2", "MultiMedia2 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_IN("MM_DL3", "MultiMedia3 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_IN("MM_DL4", "MultiMedia4 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_IN("MM_DL5", "MultiMedia5 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_IN("MM_DL6", "MultiMedia6 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_IN("MM_DL7", "MultiMedia7 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_IN("MM_DL8", "MultiMedia8 Playback", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL1", "MultiMedia1 Capture", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL2", "MultiMedia2 Capture", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL3", "MultiMedia3 Capture", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL4", "MultiMedia4 Capture", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL5", "MultiMedia5 Capture", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL6", "MultiMedia6 Capture", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL7", "MultiMedia7 Capture", 0, 0, 0, 0),
-	SND_SOC_DAPM_AIF_OUT("MM_UL8", "MultiMedia8 Capture", 0, 0, 0, 0),
-
 	/* Mixer definitions */
 	SND_SOC_DAPM_MIXER("HDMI Mixer", SND_SOC_NOPM, 0, 0,
 			   hdmi_mixer_controls,
-- 
2.27.0



