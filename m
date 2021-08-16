Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74463ED594
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhHPNMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237580AbhHPNKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F81760E78;
        Mon, 16 Aug 2021 13:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119398;
        bh=Syyxvf7D+RvcJyfS+6XzQCELASBKS4J068rcCopCPJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNL/ThDuStcvaugpzY12Ds5PgAL5Jx/SjqZRoZ3IyUZ3vBR2WuLdtvVk1KnIaeWeL
         8Sh+YHnKGrJp35WO/WhtYd36do6+OkoBarTAmIZqruEAJQ4k602fepo5cuKku80Tvj
         8q5FXyzvm04oB+aOIY9FbBdBJWZtd+W3lcFEHDZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.13 011/151] ASoC: kirkwood: Fix reference to PCM buffer address
Date:   Mon, 16 Aug 2021 15:00:41 +0200
Message-Id: <20210816125444.449051054@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit bb6a40fc5a830cae45ddd5cd6cfa151b008522ed upstream.

The transition to the managed PCM buffers allowed the dynamically
buffer allocation, while the driver code still assumes the fixed
preallocation buffer and sets up the DMA stuff at the open call.
This needs to be moved to hw_params after the buffer allocation and
setup.  Also, the reference to the buffer address has to be corrected
to runtime->dma_addr.

Fixes: b3c0ae75f5d3 ("ASoC: kirkwood: Use managed DMA buffer allocation")
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210728112353.6675-6-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/kirkwood/kirkwood-dma.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -104,8 +104,6 @@ static int kirkwood_dma_open(struct snd_
 	int err;
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct kirkwood_dma_data *priv = kirkwood_priv(substream);
-	const struct mbus_dram_target_info *dram;
-	unsigned long addr;
 
 	snd_soc_set_runtime_hwparams(substream, &kirkwood_dma_snd_hw);
 
@@ -142,20 +140,14 @@ static int kirkwood_dma_open(struct snd_
 		writel((unsigned int)-1, priv->io + KIRKWOOD_ERR_MASK);
 	}
 
-	dram = mv_mbus_dram_info();
-	addr = substream->dma_buffer.addr;
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		if (priv->substream_play)
 			return -EBUSY;
 		priv->substream_play = substream;
-		kirkwood_dma_conf_mbus_windows(priv->io,
-			KIRKWOOD_PLAYBACK_WIN, addr, dram);
 	} else {
 		if (priv->substream_rec)
 			return -EBUSY;
 		priv->substream_rec = substream;
-		kirkwood_dma_conf_mbus_windows(priv->io,
-			KIRKWOOD_RECORD_WIN, addr, dram);
 	}
 
 	return 0;
@@ -182,6 +174,23 @@ static int kirkwood_dma_close(struct snd
 	return 0;
 }
 
+static int kirkwood_dma_hw_params(struct snd_soc_component *component,
+				  struct snd_pcm_substream *substream,
+				  struct snd_pcm_hw_params *params)
+{
+	struct kirkwood_dma_data *priv = kirkwood_priv(substream);
+	const struct mbus_dram_target_info *dram = mv_mbus_dram_info();
+	unsigned long addr = substream->runtime->dma_addr;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		kirkwood_dma_conf_mbus_windows(priv->io,
+			KIRKWOOD_PLAYBACK_WIN, addr, dram);
+	else
+		kirkwood_dma_conf_mbus_windows(priv->io,
+			KIRKWOOD_RECORD_WIN, addr, dram);
+	return 0;
+}
+
 static int kirkwood_dma_prepare(struct snd_soc_component *component,
 				struct snd_pcm_substream *substream)
 {
@@ -246,6 +255,7 @@ const struct snd_soc_component_driver ki
 	.name		= DRV_NAME,
 	.open		= kirkwood_dma_open,
 	.close		= kirkwood_dma_close,
+	.hw_params	= kirkwood_dma_hw_params,
 	.prepare	= kirkwood_dma_prepare,
 	.pointer	= kirkwood_dma_pointer,
 	.pcm_construct	= kirkwood_dma_new,


