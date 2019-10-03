Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E3DCA626
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392494AbfJCQk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392490AbfJCQkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:40:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011A4215EA;
        Thu,  3 Oct 2019 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120824;
        bh=qyvPGPthlv7IWQeOy+355+CuuoZBoH+UE9kvtZXQ8ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpi/kJvkJxZcyoqFHw5Ps2/XJLJm5UipLjYR7ED3sNlR1yBAPPWl/vz7onLtemD41
         vR2NAtvLd87I13JLEhKcLVJ23fpCd72jloErhK6rj7ks/FYv+mmJcu7A2ocZ8+8PPW
         JdObueaxNlvAaPdvphHkClPlMk/T9orpjphgFTqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 051/344] ASoC: SOF: reset DMA state in prepare
Date:   Thu,  3 Oct 2019 17:50:16 +0200
Message-Id: <20191003154545.188981539@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 04c8027764bc82a325d3abc6f39a6a4642a937cb ]

When application goes through SUSPEND/STOP->PREPARE->START
cycle, we should always reprogram the SOF device to start
DMA from a known state so that hw_ptr/appl_ptrs remain valid.
This is expected by ALSA core as it resets the buffer
state as part of prepare (see snd_pcm_do_prepare()).

Fix the issue by forcing reconfiguration of the FW with
STREAM_PCM_PARAMS in prepare(). Use combined logic to handle
prepare and the existing flow to reprogram hw-params after
system suspend.

Without the fix, first call to pcm pointer() will return
an invalid hw_ptr and application may immediately observe XRUN
status, unless "start_threshold" SW parameter is set to maximum
value by the application.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190722141402.7194-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/pcm.c      | 27 +++++++++++++++------------
 sound/soc/sof/pm.c       |  2 +-
 sound/soc/sof/sof-priv.h |  2 +-
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index 334e9d59b1baf..3b8955e755b24 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -208,12 +208,11 @@ static int sof_pcm_hw_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		return ret;
 
+	spcm->prepared[substream->stream] = true;
+
 	/* save pcm hw_params */
 	memcpy(&spcm->params[substream->stream], params, sizeof(*params));
 
-	/* clear hw_params_upon_resume flag */
-	spcm->hw_params_upon_resume[substream->stream] = 0;
-
 	return ret;
 }
 
@@ -236,6 +235,9 @@ static int sof_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (!spcm)
 		return -EINVAL;
 
+	if (!spcm->prepared[substream->stream])
+		return 0;
+
 	dev_dbg(sdev->dev, "pcm: free stream %d dir %d\n", spcm->pcm.pcm_id,
 		substream->stream);
 
@@ -258,6 +260,8 @@ static int sof_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (ret < 0)
 		dev_err(sdev->dev, "error: platform hw free failed\n");
 
+	spcm->prepared[substream->stream] = false;
+
 	return ret;
 }
 
@@ -278,11 +282,7 @@ static int sof_pcm_prepare(struct snd_pcm_substream *substream)
 	if (!spcm)
 		return -EINVAL;
 
-	/*
-	 * check if hw_params needs to be set-up again.
-	 * This is only needed when resuming from system sleep.
-	 */
-	if (!spcm->hw_params_upon_resume[substream->stream])
+	if (spcm->prepared[substream->stream])
 		return 0;
 
 	dev_dbg(sdev->dev, "pcm: prepare stream %d dir %d\n", spcm->pcm.pcm_id,
@@ -311,6 +311,7 @@ static int sof_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	struct snd_sof_pcm *spcm;
 	struct sof_ipc_stream stream;
 	struct sof_ipc_reply reply;
+	bool reset_hw_params = false;
 	int ret;
 
 	/* nothing to do for BE */
@@ -351,6 +352,7 @@ static int sof_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
 		stream.hdr.cmd |= SOF_IPC_STREAM_TRIG_STOP;
+		reset_hw_params = true;
 		break;
 	default:
 		dev_err(sdev->dev, "error: unhandled trigger cmd %d\n", cmd);
@@ -363,17 +365,17 @@ static int sof_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	ret = sof_ipc_tx_message(sdev->ipc, stream.hdr.cmd, &stream,
 				 sizeof(stream), &reply, sizeof(reply));
 
-	if (ret < 0 || cmd != SNDRV_PCM_TRIGGER_SUSPEND)
+	if (ret < 0 || !reset_hw_params)
 		return ret;
 
 	/*
-	 * The hw_free op is usually called when the pcm stream is closed.
-	 * Since the stream is not closed during suspend, the DSP needs to be
-	 * notified explicitly to free pcm to prevent errors upon resume.
+	 * In case of stream is stopped, DSP must be reprogrammed upon
+	 * restart, so free PCM here.
 	 */
 	stream.hdr.size = sizeof(stream);
 	stream.hdr.cmd = SOF_IPC_GLB_STREAM_MSG | SOF_IPC_STREAM_PCM_FREE;
 	stream.comp_id = spcm->stream[substream->stream].comp_id;
+	spcm->prepared[substream->stream] = false;
 
 	/* send IPC to the DSP */
 	return sof_ipc_tx_message(sdev->ipc, stream.hdr.cmd, &stream,
@@ -481,6 +483,7 @@ static int sof_pcm_open(struct snd_pcm_substream *substream)
 	spcm->stream[substream->stream].posn.host_posn = 0;
 	spcm->stream[substream->stream].posn.dai_posn = 0;
 	spcm->stream[substream->stream].substream = substream;
+	spcm->prepared[substream->stream] = false;
 
 	ret = snd_sof_pcm_platform_open(sdev, substream);
 	if (ret < 0)
diff --git a/sound/soc/sof/pm.c b/sound/soc/sof/pm.c
index 278abfd10490d..48c6d78d72e2e 100644
--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -233,7 +233,7 @@ static int sof_set_hw_params_upon_resume(struct snd_sof_dev *sdev)
 
 			state = substream->runtime->status->state;
 			if (state == SNDRV_PCM_STATE_SUSPENDED)
-				spcm->hw_params_upon_resume[dir] = 1;
+				spcm->prepared[dir] = false;
 		}
 	}
 
diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index b8c0b2a226845..fa5cb7d2a6602 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -297,7 +297,7 @@ struct snd_sof_pcm {
 	struct snd_sof_pcm_stream stream[2];
 	struct list_head list;	/* list in sdev pcm list */
 	struct snd_pcm_hw_params params[2];
-	int hw_params_upon_resume[2]; /* set up hw_params upon resume */
+	bool prepared[2]; /* PCM_PARAMS set successfully */
 };
 
 /* ALSA SOF Kcontrol device */
-- 
2.20.1



