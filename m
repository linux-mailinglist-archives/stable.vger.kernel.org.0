Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2767A49A43E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371290AbiAYAH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2366200AbiAXXwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BEEC07A95F;
        Mon, 24 Jan 2022 13:45:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91A53B81142;
        Mon, 24 Jan 2022 21:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8569C340E4;
        Mon, 24 Jan 2022 21:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060718;
        bh=iDFeLzaEtK0aETLPn/3Aj15BXnZkxD+Yg9u0RfYTh2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lmojvs4cXXpwKXACm9iWn9IUQdDV993HmRk4T6YDX3XLvA3KNrvlFMQZfXSro7o2
         iPB+PPx0KzJMYAEgyA4n30ZCPg2mqIzo+jguZkJebNbsmA04H7/EWWVhR+7thcgl/J
         16dAPA+IR7ToK5IFEDoK0QfneMC2815p3hY0cQdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Paul Olaru <paul.olaru@oss.nxp.com>,
        Bard Liao <bard.liao@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 1039/1039] ASoC: SOF: handle paused streams during system suspend
Date:   Mon, 24 Jan 2022 19:47:08 +0100
Message-Id: <20220124184200.208540069@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 96da174024b9c63bd5d3358668d0bc12677be877 upstream.

During system suspend, paused streams do not get suspended.
Therefore, we need to explicitly free these PCMs in the DSP
and free the associated DAPM widgets so that they can be set
up again during resume.

Fixes: 5fcdbb2d45df ("ASoC: SOF: Add support for dynamic pipelines")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Paul Olaru <paul.olaru@oss.nxp.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20211123171606.129350-3-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pcm.c       |    5 +--
 sound/soc/sof/sof-audio.c |   74 ++++++++++++++++++++++++++++++++++++++++++++--
 sound/soc/sof/sof-audio.h |    2 +
 3 files changed, 76 insertions(+), 5 deletions(-)

--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -100,9 +100,8 @@ void snd_sof_pcm_period_elapsed(struct s
 }
 EXPORT_SYMBOL(snd_sof_pcm_period_elapsed);
 
-static int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream,
-				struct snd_sof_dev *sdev,
-				struct snd_sof_pcm *spcm)
+int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream, struct snd_sof_dev *sdev,
+			 struct snd_sof_pcm *spcm)
 {
 	struct sof_ipc_stream stream;
 	struct sof_ipc_reply reply;
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -122,6 +122,14 @@ int sof_widget_free(struct snd_sof_dev *
 	case snd_soc_dapm_buffer:
 		ipc_free.hdr.cmd |= SOF_IPC_TPLG_BUFFER_FREE;
 		break;
+	case snd_soc_dapm_dai_in:
+	case snd_soc_dapm_dai_out:
+	{
+		struct snd_sof_dai *dai = swidget->private;
+
+		dai->configured = false;
+		fallthrough;
+	}
 	default:
 		ipc_free.hdr.cmd |= SOF_IPC_TPLG_COMP_FREE;
 		break;
@@ -680,6 +688,55 @@ int sof_set_up_pipelines(struct snd_sof_
 }
 
 /*
+ * Free the PCM, its associated widgets and set the prepared flag to false for all PCMs that
+ * did not get suspended(ex: paused streams) so the widgets can be set up again during resume.
+ */
+static int sof_tear_down_left_over_pipelines(struct snd_sof_dev *sdev)
+{
+	struct snd_sof_widget *swidget;
+	struct snd_sof_pcm *spcm;
+	int dir, ret;
+
+	/*
+	 * free all PCMs and their associated DAPM widgets if their connected DAPM widget
+	 * list is not NULL. This should only be true for paused streams at this point.
+	 * This is equivalent to the handling of FE DAI suspend trigger for running streams.
+	 */
+	list_for_each_entry(spcm, &sdev->pcm_list, list)
+		for_each_pcm_streams(dir) {
+			struct snd_pcm_substream *substream = spcm->stream[dir].substream;
+
+			if (!substream || !substream->runtime)
+				continue;
+
+			if (spcm->stream[dir].list) {
+				ret = sof_pcm_dsp_pcm_free(substream, sdev, spcm);
+				if (ret < 0)
+					return ret;
+
+				ret = sof_widget_list_free(sdev, spcm, dir);
+				if (ret < 0) {
+					dev_err(sdev->dev, "failed to free widgets during suspend\n");
+					return ret;
+				}
+			}
+		}
+
+	/*
+	 * free any left over DAI widgets. This is equivalent to the handling of suspend trigger
+	 * for the BE DAI for running streams.
+	 */
+	list_for_each_entry(swidget, &sdev->widget_list, list)
+		if (WIDGET_IS_DAI(swidget->id) && swidget->use_count == 1) {
+			ret = sof_widget_free(sdev, swidget);
+			if (ret < 0)
+				return ret;
+		}
+
+	return 0;
+}
+
+/*
  * For older firmware, this function doesn't free widgets for static pipelines during suspend.
  * It only resets use_count for all widgets.
  */
@@ -693,8 +750,8 @@ int sof_tear_down_pipelines(struct snd_s
 	/*
 	 * This function is called during suspend and for one-time topology verification during
 	 * first boot. In both cases, there is no need to protect swidget->use_count and
-	 * sroute->setup because during suspend all streams are suspended and during topology
-	 * loading the sound card unavailable to open PCMs.
+	 * sroute->setup because during suspend all running streams are suspended and during
+	 * topology loading the sound card unavailable to open PCMs.
 	 */
 	list_for_each_entry(swidget, &sdev->widget_list, list) {
 		if (swidget->dynamic_pipeline_widget)
@@ -713,6 +770,19 @@ int sof_tear_down_pipelines(struct snd_s
 			return ret;
 	}
 
+	/*
+	 * Tear down all pipelines associated with PCMs that did not get suspended
+	 * and unset the prepare flag so that they can be set up again during resume.
+	 * Skip this step for older firmware.
+	 */
+	if (!verify && v->abi_version >= SOF_ABI_VER(3, 19, 0)) {
+		ret = sof_tear_down_left_over_pipelines(sdev);
+		if (ret < 0) {
+			dev_err(sdev->dev, "failed to tear down paused pipelines\n");
+			return ret;
+		}
+	}
+
 	list_for_each_entry(sroute, &sdev->route_list, list)
 		sroute->setup = false;
 
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -267,4 +267,6 @@ int sof_widget_free(struct snd_sof_dev *
 /* PCM */
 int sof_widget_list_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm, int dir);
 int sof_widget_list_free(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm, int dir);
+int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream, struct snd_sof_dev *sdev,
+			 struct snd_sof_pcm *spcm);
 #endif


