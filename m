Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B77D15C487
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgBMPsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbgBMP06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:58 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8EB620661;
        Thu, 13 Feb 2020 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607617;
        bh=nmvu67hqN0sZtyXAZ4ufGG9T4v6SmKu2ldauLxBO0As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2mmhjTXZTu4TNqYC1LgMQa/WQ1lz0LgPNQbjxnDUBnLUCUSZMVywmMDN0IcpVgjT
         az5tftS0j2eOggE8I8cQfDgx1441Z3Z1p/92Z5D1XXQMOLzgM+gjUifV96FCyRIELT
         KUPIyWxQ3UoplhNmCJwbcMKLo97k1ajaucmBdN7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/96] ASoC: pcm: update FE/BE trigger order based on the command
Date:   Thu, 13 Feb 2020 07:20:08 -0800
Message-Id: <20200213151839.476856295@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit acbf27746ecfa96b290b54cc7f05273482ea128a ]

Currently, the trigger orders SND_SOC_DPCM_TRIGGER_PRE/POST
determine the order in which FE DAI and BE DAI are triggered.
In the case of SND_SOC_DPCM_TRIGGER_PRE, the FE DAI is
triggered before the BE DAI and in the case of
SND_SOC_DPCM_TRIGGER_POST, the BE DAI is triggered before
the FE DAI. And this order remains the same irrespective of the
trigger command.

In the case of the SOF driver, during playback, the FW
expects the BE DAI to be triggered before the FE DAI during
the START trigger. The BE DAI trigger handles the starting of
Link DMA and so it must be started before the FE DAI is started
to prevent xruns during pause/release. This can be addressed
by setting the trigger order for the FE dai link to
SND_SOC_DPCM_TRIGGER_POST. But during the STOP trigger,
the FW expects the FE DAI to be triggered before the BE DAI.
Retaining the same order during the START and STOP commands,
results in FW error as the DAI component in the FW is still
active.

The issue can be fixed by mirroring the trigger order of
FE and BE DAI's during the START and STOP trigger. So, with the
trigger order set to SND_SOC_DPCM_TRIGGER_PRE, the FE DAI will be
trigger first during SNDRV_PCM_TRIGGER_START/STOP/RESUME
and the BE DAI will be triggered first during the
STOP/SUSPEND/PAUSE commands. Conversely, with the trigger order
set to SND_SOC_DPCM_TRIGGER_POST, the BE DAI will be triggered
first during the SNDRV_PCM_TRIGGER_START/STOP/RESUME commands
and the FE DAI will be triggered first during the
SNDRV_PCM_TRIGGER_STOP/SUSPEND/PAUSE commands.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191104224812.3393-2-ranjani.sridharan@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 95 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 68 insertions(+), 27 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index d07026a846b9c..8712a91e0e3ea 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2297,42 +2297,81 @@ int dpcm_be_dai_trigger(struct snd_soc_pcm_runtime *fe, int stream,
 }
 EXPORT_SYMBOL_GPL(dpcm_be_dai_trigger);
 
+static int dpcm_dai_trigger_fe_be(struct snd_pcm_substream *substream,
+				  int cmd, bool fe_first)
+{
+	struct snd_soc_pcm_runtime *fe = substream->private_data;
+	int ret;
+
+	/* call trigger on the frontend before the backend. */
+	if (fe_first) {
+		dev_dbg(fe->dev, "ASoC: pre trigger FE %s cmd %d\n",
+			fe->dai_link->name, cmd);
+
+		ret = soc_pcm_trigger(substream, cmd);
+		if (ret < 0)
+			return ret;
+
+		ret = dpcm_be_dai_trigger(fe, substream->stream, cmd);
+		return ret;
+	}
+
+	/* call trigger on the frontend after the backend. */
+	ret = dpcm_be_dai_trigger(fe, substream->stream, cmd);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(fe->dev, "ASoC: post trigger FE %s cmd %d\n",
+		fe->dai_link->name, cmd);
+
+	ret = soc_pcm_trigger(substream, cmd);
+
+	return ret;
+}
+
 static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct snd_soc_pcm_runtime *fe = substream->private_data;
-	int stream = substream->stream, ret;
+	int stream = substream->stream;
+	int ret = 0;
 	enum snd_soc_dpcm_trigger trigger = fe->dai_link->trigger[stream];
 
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
 
 	switch (trigger) {
 	case SND_SOC_DPCM_TRIGGER_PRE:
-		/* call trigger on the frontend before the backend. */
-
-		dev_dbg(fe->dev, "ASoC: pre trigger FE %s cmd %d\n",
-				fe->dai_link->name, cmd);
-
-		ret = soc_pcm_trigger(substream, cmd);
-		if (ret < 0) {
-			dev_err(fe->dev,"ASoC: trigger FE failed %d\n", ret);
-			goto out;
+		switch (cmd) {
+		case SNDRV_PCM_TRIGGER_START:
+		case SNDRV_PCM_TRIGGER_RESUME:
+		case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+			ret = dpcm_dai_trigger_fe_be(substream, cmd, true);
+			break;
+		case SNDRV_PCM_TRIGGER_STOP:
+		case SNDRV_PCM_TRIGGER_SUSPEND:
+		case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+			ret = dpcm_dai_trigger_fe_be(substream, cmd, false);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
 		}
-
-		ret = dpcm_be_dai_trigger(fe, substream->stream, cmd);
 		break;
 	case SND_SOC_DPCM_TRIGGER_POST:
-		/* call trigger on the frontend after the backend. */
-
-		ret = dpcm_be_dai_trigger(fe, substream->stream, cmd);
-		if (ret < 0) {
-			dev_err(fe->dev,"ASoC: trigger FE failed %d\n", ret);
-			goto out;
+		switch (cmd) {
+		case SNDRV_PCM_TRIGGER_START:
+		case SNDRV_PCM_TRIGGER_RESUME:
+		case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+			ret = dpcm_dai_trigger_fe_be(substream, cmd, false);
+			break;
+		case SNDRV_PCM_TRIGGER_STOP:
+		case SNDRV_PCM_TRIGGER_SUSPEND:
+		case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+			ret = dpcm_dai_trigger_fe_be(substream, cmd, true);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
 		}
-
-		dev_dbg(fe->dev, "ASoC: post trigger FE %s cmd %d\n",
-				fe->dai_link->name, cmd);
-
-		ret = soc_pcm_trigger(substream, cmd);
 		break;
 	case SND_SOC_DPCM_TRIGGER_BESPOKE:
 		/* bespoke trigger() - handles both FE and BEs */
@@ -2341,10 +2380,6 @@ static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 				fe->dai_link->name, cmd);
 
 		ret = soc_pcm_bespoke_trigger(substream, cmd);
-		if (ret < 0) {
-			dev_err(fe->dev,"ASoC: trigger FE failed %d\n", ret);
-			goto out;
-		}
 		break;
 	default:
 		dev_err(fe->dev, "ASoC: invalid trigger cmd %d for %s\n", cmd,
@@ -2353,6 +2388,12 @@ static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 		goto out;
 	}
 
+	if (ret < 0) {
+		dev_err(fe->dev, "ASoC: trigger FE cmd: %d failed: %d\n",
+			cmd, ret);
+		goto out;
+	}
+
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
-- 
2.20.1



