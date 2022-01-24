Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456AA499A63
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345292AbiAXVnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52512 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454400AbiAXVcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B098614DC;
        Mon, 24 Jan 2022 21:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92F2C340E4;
        Mon, 24 Jan 2022 21:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059950;
        bh=7bcSEZLz3ee9hcPWYNTolYzG/C+UFjH9TlCAQp+r2gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucSnbFTwnjrIewUo2lXvrRW/xTPbkKpjno666YDfl525K6khJ+GLD4K9TJBdeKNyU
         IWkTUHRE2AdnXW5SZ3fojNdt/yx1BOvBKUEiQWL2PMZvQ9Er98XpJSnkKh33qYxk79
         Te1GoTxatiQRMbeUMCcFa/2G8/3kxmy/2mAn9kiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0762/1039] ASoC: SOF: Intel: hda: add quirks for HDAudio DMA position information
Date:   Mon, 24 Jan 2022 19:42:31 +0100
Message-Id: <20220124184150.932229356@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 288fad2f71fa0b989c075d4984879c26d47cfb06 ]

The code inherited from the Skylake driver does not seem to follow any
known hardware recommendations.

The only two recommended options are
a) use DPIB registers if VC1 traffic is not allowed
b) use DPIB DDR update if VC1 traffic is used

In all of SOF-based updated, VC1 is not supported so we can 'safely'
move to using DPIB registers only.

This patch keeps the legacy code, in case there was an undocumented
issue lost to history, and adds the DPIB DDR update for additional
debug.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20211207193947.71080-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-pcm.c | 86 +++++++++++++++++++++++++----------
 sound/soc/sof/intel/hda.c     |  9 +++-
 sound/soc/sof/intel/hda.h     |  6 +++
 3 files changed, 75 insertions(+), 26 deletions(-)

diff --git a/sound/soc/sof/intel/hda-pcm.c b/sound/soc/sof/intel/hda-pcm.c
index cc8ddef37f37b..41cb60955f5c1 100644
--- a/sound/soc/sof/intel/hda-pcm.c
+++ b/sound/soc/sof/intel/hda-pcm.c
@@ -172,38 +172,74 @@ snd_pcm_uframes_t hda_dsp_pcm_pointer(struct snd_sof_dev *sdev,
 		goto found;
 	}
 
-	/*
-	 * DPIB/posbuf position mode:
-	 * For Playback, Use DPIB register from HDA space which
-	 * reflects the actual data transferred.
-	 * For Capture, Use the position buffer for pointer, as DPIB
-	 * is not accurate enough, its update may be completed
-	 * earlier than the data written to DDR.
-	 */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
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
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
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
+			usleep_range(20, 21);
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
 		pos = snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
 				       AZX_REG_VS_SDXDPIB_XBASE +
 				       (AZX_REG_VS_SDXDPIB_XINTERVAL *
 					hstream->index));
-	} else {
+		break;
+	case SOF_HDA_POSITION_QUIRK_USE_DPIB_DDR_UPDATE:
 		/*
-		 * For capture stream, we need more workaround to fix the
-		 * position incorrect issue:
-		 *
-		 * 1. Wait at least 20us before reading position buffer after
-		 * the interrupt generated(IOC), to make sure position update
-		 * happens on frame boundary i.e. 20.833uSec for 48KHz.
-		 * 2. Perform a dummy Read to DPIB register to flush DMA
-		 * position value.
-		 * 3. Read the DMA Position from posbuf. Now the readback
-		 * value should be >= period boundary.
+		 * This is the recommended option when VC1 is enabled.
+		 * While this isn't needed for SOF platforms it's added for
+		 * consistency and debug.
 		 */
-		usleep_range(20, 21);
-		snd_sof_dsp_read(sdev, HDA_DSP_HDA_BAR,
-				 AZX_REG_VS_SDXDPIB_XBASE +
-				 (AZX_REG_VS_SDXDPIB_XINTERVAL *
-				  hstream->index));
 		pos = snd_hdac_stream_get_pos_posbuf(hstream);
+		break;
+	default:
+		dev_err_once(sdev->dev, "hda_position_quirk value %d not supported\n",
+			     sof_hda_position_quirk);
+		pos = 0;
+		break;
 	}
 
 	if (pos >= hstream->bufsize)
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 2c0d4d06ab364..25200a0e1dc9d 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -440,6 +440,10 @@ MODULE_PARM_DESC(use_msi, "SOF HDA use PCI MSI mode");
 #define hda_use_msi	(1)
 #endif
 
+int sof_hda_position_quirk = SOF_HDA_POSITION_QUIRK_USE_DPIB_REGISTERS;
+module_param_named(position_quirk, sof_hda_position_quirk, int, 0444);
+MODULE_PARM_DESC(position_quirk, "SOF HDaudio position quirk");
+
 static char *hda_model;
 module_param(hda_model, charp, 0444);
 MODULE_PARM_DESC(hda_model, "Use the given HDA board model.");
@@ -618,7 +622,10 @@ static int hda_init(struct snd_sof_dev *sdev)
 	/* HDA bus init */
 	sof_hda_bus_init(bus, &pci->dev);
 
-	bus->use_posbuf = 1;
+	if (sof_hda_position_quirk == SOF_HDA_POSITION_QUIRK_USE_DPIB_REGISTERS)
+		bus->use_posbuf = 0;
+	else
+		bus->use_posbuf = 1;
 	bus->bdl_pos_adj = 0;
 	bus->sync_write = 1;
 
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 1195018a1f4f5..dba4733ccf9ae 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -738,4 +738,10 @@ struct sof_ipc_dai_config;
 int hda_ctrl_dai_widget_setup(struct snd_soc_dapm_widget *w);
 int hda_ctrl_dai_widget_free(struct snd_soc_dapm_widget *w);
 
+#define SOF_HDA_POSITION_QUIRK_USE_SKYLAKE_LEGACY	(0) /* previous implementation */
+#define SOF_HDA_POSITION_QUIRK_USE_DPIB_REGISTERS	(1) /* recommended if VC0 only */
+#define SOF_HDA_POSITION_QUIRK_USE_DPIB_DDR_UPDATE	(2) /* recommended with VC0 or VC1 */
+
+extern int sof_hda_position_quirk;
+
 #endif
-- 
2.34.1



