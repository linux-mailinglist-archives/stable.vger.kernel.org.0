Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15F15EF9B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388899AbgBNP7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388883AbgBNP7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F7802067D;
        Fri, 14 Feb 2020 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695960;
        bh=kfBZGCnGbpQro7ES8DP2ikbKpzDW9V8VqF0jmOeg57g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqzugSWrEOwMw74s0F0nIiSDq0MvX29WQ+/V7tnPD+Fw/3Lp9+4JfN7laN+tBSebC
         efDkIKJ7re1jt2lMBhWkntZF0PXJOf7k+uH6l4Xo40kwajw/P3roG0kXaKPhlhrWlE
         cm6wWf5URuXFoEcDgoyhXjndPxv35sYYe2v9TWyI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 489/542] ASoC: Intel: consistent HDMI codec probing code
Date:   Fri, 14 Feb 2020 10:48:01 -0500
Message-Id: <20200214154854.6746-489-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

[ Upstream commit 98ff5c262f27aafee077a4c096f71a8566e9e948 ]

Multiple Intel ASoC machine drivers repeat the same pattern in their
.late_probe() methods: they first check whether the common HDMI codec
driver is used, if not, they proceed by linking the legacy HDMI
driver to each HDMI port. While doing that they use some
inconsistent code:

1. after the loop they check, whether the list contained at least one
   element and if not, they return an error. However, the earlier
   code to use the common HDMI driver uses the first element of the
   same list without checking. To fix this we move the check to the
   top of the function.

2. some of those .late_probe() implementations execute code, only
   needed for the common HDMI driver, before checking, whether the
   driver is used. Move the code to after the check.

3. Some of those functions also perform a redundant initialisation of
   the "err" variable.

This patch fixes those issues.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200124213625.30186-8-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bxt_da7219_max98357a.c | 14 +++++++-------
 sound/soc/intel/boards/bxt_rt298.c            | 14 +++++++-------
 sound/soc/intel/boards/cml_rt1011_rt5682.c    | 13 +++++++------
 sound/soc/intel/boards/glk_rt5682_max98357a.c | 16 ++++++++--------
 sound/soc/intel/boards/sof_rt5682.c           | 15 ++++++++-------
 5 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/sound/soc/intel/boards/bxt_da7219_max98357a.c b/sound/soc/intel/boards/bxt_da7219_max98357a.c
index 5873abb46441c..749b1c4f1ceec 100644
--- a/sound/soc/intel/boards/bxt_da7219_max98357a.c
+++ b/sound/soc/intel/boards/bxt_da7219_max98357a.c
@@ -617,12 +617,15 @@ static int bxt_card_late_probe(struct snd_soc_card *card)
 		snd_soc_dapm_add_routes(&card->dapm, broxton_map,
 					ARRAY_SIZE(broxton_map));
 
-	pcm = list_first_entry(&ctx->hdmi_pcm_list, struct bxt_hdmi_pcm,
-			       head);
-	component = pcm->codec_dai->component;
+	if (list_empty(&ctx->hdmi_pcm_list))
+		return -EINVAL;
 
-	if (ctx->common_hdmi_codec_drv)
+	if (ctx->common_hdmi_codec_drv) {
+		pcm = list_first_entry(&ctx->hdmi_pcm_list, struct bxt_hdmi_pcm,
+				       head);
+		component = pcm->codec_dai->component;
 		return hda_dsp_hdmi_build_controls(card, component);
+	}
 
 	list_for_each_entry(pcm, &ctx->hdmi_pcm_list, head) {
 		component = pcm->codec_dai->component;
@@ -643,9 +646,6 @@ static int bxt_card_late_probe(struct snd_soc_card *card)
 		i++;
 	}
 
-	if (!component)
-		return -EINVAL;
-
 	return hdac_hdmi_jack_port_init(component, &card->dapm);
 }
 
diff --git a/sound/soc/intel/boards/bxt_rt298.c b/sound/soc/intel/boards/bxt_rt298.c
index eabf9d8468ae5..becfc4fc1aff3 100644
--- a/sound/soc/intel/boards/bxt_rt298.c
+++ b/sound/soc/intel/boards/bxt_rt298.c
@@ -529,12 +529,15 @@ static int bxt_card_late_probe(struct snd_soc_card *card)
 	int err, i = 0;
 	char jack_name[NAME_SIZE];
 
-	pcm = list_first_entry(&ctx->hdmi_pcm_list, struct bxt_hdmi_pcm,
-			       head);
-	component = pcm->codec_dai->component;
+	if (list_empty(&ctx->hdmi_pcm_list))
+		return -EINVAL;
 
-	if (ctx->common_hdmi_codec_drv)
+	if (ctx->common_hdmi_codec_drv) {
+		pcm = list_first_entry(&ctx->hdmi_pcm_list, struct bxt_hdmi_pcm,
+				       head);
+		component = pcm->codec_dai->component;
 		return hda_dsp_hdmi_build_controls(card, component);
+	}
 
 	list_for_each_entry(pcm, &ctx->hdmi_pcm_list, head) {
 		component = pcm->codec_dai->component;
@@ -555,9 +558,6 @@ static int bxt_card_late_probe(struct snd_soc_card *card)
 		i++;
 	}
 
-	if (!component)
-		return -EINVAL;
-
 	return hdac_hdmi_jack_port_init(component, &card->dapm);
 }
 
diff --git a/sound/soc/intel/boards/cml_rt1011_rt5682.c b/sound/soc/intel/boards/cml_rt1011_rt5682.c
index 5f1bf6d3800c6..a54636f77c8e6 100644
--- a/sound/soc/intel/boards/cml_rt1011_rt5682.c
+++ b/sound/soc/intel/boards/cml_rt1011_rt5682.c
@@ -241,12 +241,15 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 	struct hdmi_pcm *pcm;
 	int ret, i = 0;
 
-	pcm = list_first_entry(&ctx->hdmi_pcm_list, struct hdmi_pcm,
-			       head);
-	component = pcm->codec_dai->component;
+	if (list_empty(&ctx->hdmi_pcm_list))
+		return -EINVAL;
 
-	if (ctx->common_hdmi_codec_drv)
+	if (ctx->common_hdmi_codec_drv) {
+		pcm = list_first_entry(&ctx->hdmi_pcm_list, struct hdmi_pcm,
+				       head);
+		component = pcm->codec_dai->component;
 		return hda_dsp_hdmi_build_controls(card, component);
+	}
 
 	list_for_each_entry(pcm, &ctx->hdmi_pcm_list, head) {
 		component = pcm->codec_dai->component;
@@ -265,8 +268,6 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 
 		i++;
 	}
-	if (!component)
-		return -EINVAL;
 
 	return hdac_hdmi_jack_port_init(component, &card->dapm);
 }
diff --git a/sound/soc/intel/boards/glk_rt5682_max98357a.c b/sound/soc/intel/boards/glk_rt5682_max98357a.c
index b36264d1d1cd3..94c6bdfab63bb 100644
--- a/sound/soc/intel/boards/glk_rt5682_max98357a.c
+++ b/sound/soc/intel/boards/glk_rt5682_max98357a.c
@@ -544,15 +544,18 @@ static int glk_card_late_probe(struct snd_soc_card *card)
 	struct snd_soc_component *component = NULL;
 	char jack_name[NAME_SIZE];
 	struct glk_hdmi_pcm *pcm;
-	int err = 0;
+	int err;
 	int i = 0;
 
-	pcm = list_first_entry(&ctx->hdmi_pcm_list, struct glk_hdmi_pcm,
-			       head);
-	component = pcm->codec_dai->component;
+	if (list_empty(&ctx->hdmi_pcm_list))
+		return -EINVAL;
 
-	if (ctx->common_hdmi_codec_drv)
+	if (ctx->common_hdmi_codec_drv) {
+		pcm = list_first_entry(&ctx->hdmi_pcm_list, struct glk_hdmi_pcm,
+				       head);
+		component = pcm->codec_dai->component;
 		return hda_dsp_hdmi_build_controls(card, component);
+	}
 
 	list_for_each_entry(pcm, &ctx->hdmi_pcm_list, head) {
 		component = pcm->codec_dai->component;
@@ -573,9 +576,6 @@ static int glk_card_late_probe(struct snd_soc_card *card)
 		i++;
 	}
 
-	if (!component)
-		return -EINVAL;
-
 	return hdac_hdmi_jack_port_init(component, &card->dapm);
 }
 
diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 8a13231dee15d..5d878873a8e08 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -273,19 +273,22 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 	struct snd_soc_component *component = NULL;
 	char jack_name[NAME_SIZE];
 	struct sof_hdmi_pcm *pcm;
-	int err = 0;
+	int err;
 	int i = 0;
 
 	/* HDMI is not supported by SOF on Baytrail/CherryTrail */
 	if (is_legacy_cpu)
 		return 0;
 
-	pcm = list_first_entry(&ctx->hdmi_pcm_list, struct sof_hdmi_pcm,
-			       head);
-	component = pcm->codec_dai->component;
+	if (list_empty(&ctx->hdmi_pcm_list))
+		return -EINVAL;
 
-	if (ctx->common_hdmi_codec_drv)
+	if (ctx->common_hdmi_codec_drv) {
+		pcm = list_first_entry(&ctx->hdmi_pcm_list, struct sof_hdmi_pcm,
+				       head);
+		component = pcm->codec_dai->component;
 		return hda_dsp_hdmi_build_controls(card, component);
+	}
 
 	list_for_each_entry(pcm, &ctx->hdmi_pcm_list, head) {
 		component = pcm->codec_dai->component;
@@ -305,8 +308,6 @@ static int sof_card_late_probe(struct snd_soc_card *card)
 
 		i++;
 	}
-	if (!component)
-		return -EINVAL;
 
 	return hdac_hdmi_jack_port_init(component, &card->dapm);
 }
-- 
2.20.1

