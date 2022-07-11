Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DD156FB59
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiGKJ3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiGKJ3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:29:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3E110EF;
        Mon, 11 Jul 2022 02:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C3061278;
        Mon, 11 Jul 2022 09:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E96C34115;
        Mon, 11 Jul 2022 09:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530977;
        bh=45YfZqTeBaddWVj5ELAXw0HVwdPptdajeRd/ErUVfHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqpQHRqHfUCDdwFZIaxZACgQjp+XkAl84aJP+Tt9HtwBrF0wq7KywZbDZZRfJ7Hdm
         ecz0pdRSkVAZ846FPGhTAGYkD8ERm2xzSoEWLAh4NuCb+OeViBPfmd+FoK4fA7wK35
         QmEbEUbjaiNvJkJPFTn+DYXl2Xr3FzQMiZ7X/qyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 052/112] ASoC: SOF: Intel: hda: Fix compressed stream position tracking
Date:   Mon, 11 Jul 2022 11:06:52 +0200
Message-Id: <20220711090551.048463206@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit ca7ab1dcf58dfce5bc851bf7e50fd94822c24665 ]

Commit 288fad2f71fa ("ASoC: SOF: Intel: hda: add quirks for HDAudio DMA position information")
modified the PCM path only, but left the compressed data patch using an
obsolete option.
Move the functionality in a helper that can be called for both PCM and
compressed data.

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Fixes: 288fad2f71fa ("ASoC: SOF: Intel: hda: add quirks for HDAudio DMA position information")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220616201953.130876-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-pcm.c    | 74 +------------------------
 sound/soc/sof/intel/hda-stream.c | 94 ++++++++++++++++++++++++++++++--
 sound/soc/sof/intel/hda.h        |  3 +
 3 files changed, 94 insertions(+), 77 deletions(-)

diff --git a/sound/soc/sof/intel/hda-pcm.c b/sound/soc/sof/intel/hda-pcm.c
index dc1f743730c0..6888e0a4665d 100644
--- a/sound/soc/sof/intel/hda-pcm.c
+++ b/sound/soc/sof/intel/hda-pcm.c
@@ -192,79 +192,7 @@ snd_pcm_uframes_t hda_dsp_pcm_pointer(struct snd_sof_dev *sdev,
 		goto found;
 	}
 
-	switch (sof_hda_position_quirk) {
-	case SOF_HDA_POSITION_QUIRK_USE_SKYLAKE_LEGACY:
-		/*
-		 * This legacy code, inherited from the Skylake driver,
-		 * mixes DPIB registers and DPIB DDR updates and
-		 * does not seem to follow any known hardware recommendations.
-		 * It's not clear e.g. why there is a different flow
-		 * for capture and playback, the only information that matters is
-		 * what traffic class is used, and on all SOF-enabled platforms
-		 * only VC0 is supported so the work-around was likely not necessary
-		 * and quite possibly wrong.
-		 */
-
-		/* DPIB/posbuf position mode:
-		 * For Playback, Use DPIB register from HDA space which
-		 * reflects the actual data transferred.
-		 * For Capture, Use the position buffer for pointer, as DPIB
-		 * is not accurate enough, its update may be completed
-		 * earlier than the data written to DDR.
-		 */
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-			pos = snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
-					       AZX_REG_VS_SDXDPIB_XBASE +
-					       (AZX_REG_VS_SDXDPIB_XINTERVAL *
-						hstream->index));
-		} else {
-			/*
-			 * For capture stream, we need more workaround to fix the
-			 * position incorrect issue:
-			 *
-			 * 1. Wait at least 20us before reading position buffer after
-			 * the interrupt generated(IOC), to make sure position update
-			 * happens on frame boundary i.e. 20.833uSec for 48KHz.
-			 * 2. Perform a dummy Read to DPIB register to flush DMA
-			 * position value.
-			 * 3. Read the DMA Position from posbuf. Now the readback
-			 * value should be >= period boundary.
-			 */
-			usleep_range(20, 21);
-			snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
-					 AZX_REG_VS_SDXDPIB_XBASE +
-					 (AZX_REG_VS_SDXDPIB_XINTERVAL *
-					  hstream->index));
-			pos = snd_hdac_stream_get_pos_posbuf(hstream);
-		}
-		break;
-	case SOF_HDA_POSITION_QUIRK_USE_DPIB_REGISTERS:
-		/*
-		 * In case VC1 traffic is disabled this is the recommended option
-		 */
-		pos = snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
-				       AZX_REG_VS_SDXDPIB_XBASE +
-				       (AZX_REG_VS_SDXDPIB_XINTERVAL *
-					hstream->index));
-		break;
-	case SOF_HDA_POSITION_QUIRK_USE_DPIB_DDR_UPDATE:
-		/*
-		 * This is the recommended option when VC1 is enabled.
-		 * While this isn't needed for SOF platforms it's added for
-		 * consistency and debug.
-		 */
-		pos = snd_hdac_stream_get_pos_posbuf(hstream);
-		break;
-	default:
-		dev_err_once(sdev->dev, "hda_position_quirk value %d not supported\n",
-			     sof_hda_position_quirk);
-		pos = 0;
-		break;
-	}
-
-	if (pos >= hstream->bufsize)
-		pos = 0;
-
+	pos = hda_dsp_stream_get_position(hstream, substream->stream, true);
 found:
 	pos = bytes_to_frames(substream->runtime, pos);
 
diff --git a/sound/soc/sof/intel/hda-stream.c b/sound/soc/sof/intel/hda-stream.c
index daeb64c495e4..d95ae17e81cc 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -707,12 +707,13 @@ bool hda_dsp_check_stream_irq(struct snd_sof_dev *sdev)
 }
 
 static void
-hda_dsp_set_bytes_transferred(struct hdac_stream *hstream, u64 buffer_size)
+hda_dsp_compr_bytes_transferred(struct hdac_stream *hstream, int direction)
 {
+	u64 buffer_size = hstream->bufsize;
 	u64 prev_pos, pos, num_bytes;
 
 	div64_u64_rem(hstream->curr_pos, buffer_size, &prev_pos);
-	pos = snd_hdac_stream_get_pos_posbuf(hstream);
+	pos = hda_dsp_stream_get_position(hstream, direction, false);
 
 	if (pos < prev_pos)
 		num_bytes = (buffer_size - prev_pos) +  pos;
@@ -748,8 +749,7 @@ static bool hda_dsp_stream_check(struct hdac_bus *bus, u32 status)
 			if (s->substream && sof_hda->no_ipc_position) {
 				snd_sof_pcm_period_elapsed(s->substream);
 			} else if (s->cstream) {
-				hda_dsp_set_bytes_transferred(s,
-					s->cstream->runtime->buffer_size);
+				hda_dsp_compr_bytes_transferred(s, s->cstream->direction);
 				snd_compr_fragment_elapsed(s->cstream);
 			}
 		}
@@ -1009,3 +1009,89 @@ void hda_dsp_stream_free(struct snd_sof_dev *sdev)
 		devm_kfree(sdev->dev, hda_stream);
 	}
 }
+
+snd_pcm_uframes_t hda_dsp_stream_get_position(struct hdac_stream *hstream,
+					      int direction, bool can_sleep)
+{
+	struct hdac_ext_stream *hext_stream = stream_to_hdac_ext_stream(hstream);
+	struct sof_intel_hda_stream *hda_stream = hstream_to_sof_hda_stream(hext_stream);
+	struct snd_sof_dev *sdev = hda_stream->sdev;
+	snd_pcm_uframes_t pos;
+
+	switch (sof_hda_position_quirk) {
+	case SOF_HDA_POSITION_QUIRK_USE_SKYLAKE_LEGACY:
+		/*
+		 * This legacy code, inherited from the Skylake driver,
+		 * mixes DPIB registers and DPIB DDR updates and
+		 * does not seem to follow any known hardware recommendations.
+		 * It's not clear e.g. why there is a different flow
+		 * for capture and playback, the only information that matters is
+		 * what traffic class is used, and on all SOF-enabled platforms
+		 * only VC0 is supported so the work-around was likely not necessary
+		 * and quite possibly wrong.
+		 */
+
+		/* DPIB/posbuf position mode:
+		 * For Playback, Use DPIB register from HDA space which
+		 * reflects the actual data transferred.
+		 * For Capture, Use the position buffer for pointer, as DPIB
+		 * is not accurate enough, its update may be completed
+		 * earlier than the data written to DDR.
+		 */
+		if (direction == SNDRV_PCM_STREAM_PLAYBACK) {
+			pos = snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
+					       AZX_REG_VS_SDXDPIB_XBASE +
+					       (AZX_REG_VS_SDXDPIB_XINTERVAL *
+						hstream->index));
+		} else {
+			/*
+			 * For capture stream, we need more workaround to fix the
+			 * position incorrect issue:
+			 *
+			 * 1. Wait at least 20us before reading position buffer after
+			 * the interrupt generated(IOC), to make sure position update
+			 * happens on frame boundary i.e. 20.833uSec for 48KHz.
+			 * 2. Perform a dummy Read to DPIB register to flush DMA
+			 * position value.
+			 * 3. Read the DMA Position from posbuf. Now the readback
+			 * value should be >= period boundary.
+			 */
+			if (can_sleep)
+				usleep_range(20, 21);
+
+			snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
+					 AZX_REG_VS_SDXDPIB_XBASE +
+					 (AZX_REG_VS_SDXDPIB_XINTERVAL *
+					  hstream->index));
+			pos = snd_hdac_stream_get_pos_posbuf(hstream);
+		}
+		break;
+	case SOF_HDA_POSITION_QUIRK_USE_DPIB_REGISTERS:
+		/*
+		 * In case VC1 traffic is disabled this is the recommended option
+		 */
+		pos = snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
+				       AZX_REG_VS_SDXDPIB_XBASE +
+				       (AZX_REG_VS_SDXDPIB_XINTERVAL *
+					hstream->index));
+		break;
+	case SOF_HDA_POSITION_QUIRK_USE_DPIB_DDR_UPDATE:
+		/*
+		 * This is the recommended option when VC1 is enabled.
+		 * While this isn't needed for SOF platforms it's added for
+		 * consistency and debug.
+		 */
+		pos = snd_hdac_stream_get_pos_posbuf(hstream);
+		break;
+	default:
+		dev_err_once(sdev->dev, "hda_position_quirk value %d not supported\n",
+			     sof_hda_position_quirk);
+		pos = 0;
+		break;
+	}
+
+	if (pos >= hstream->bufsize)
+		pos = 0;
+
+	return pos;
+}
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 05e5e158614a..196494ba1245 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -557,6 +557,9 @@ int hda_dsp_stream_setup_bdl(struct snd_sof_dev *sdev,
 bool hda_dsp_check_ipc_irq(struct snd_sof_dev *sdev);
 bool hda_dsp_check_stream_irq(struct snd_sof_dev *sdev);
 
+snd_pcm_uframes_t hda_dsp_stream_get_position(struct hdac_stream *hstream,
+					      int direction, bool can_sleep);
+
 struct hdac_ext_stream *
 	hda_dsp_stream_get(struct snd_sof_dev *sdev, int direction, u32 flags);
 int hda_dsp_stream_put(struct snd_sof_dev *sdev, int direction, int stream_tag);
-- 
2.35.1



