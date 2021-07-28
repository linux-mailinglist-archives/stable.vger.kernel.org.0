Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C087B3D8CA7
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 13:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhG1LX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 07:23:57 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39770 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbhG1LX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 07:23:56 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 90B2322317;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627471434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zxZSXYV2Z8DNKyoSP3gHfHG8rbc/74gGdkpASn+huMw=;
        b=HZMUzbYX0ojh0n0PkiFWpOUE8F/jTuAu4NfftFiCmXeh9jLalVFbCR2T9/LyqIcdAuQy+9
        VvqXqHBXx+nVx/JBxcwAr57aLAW0nZt3iz3o/qUdPRoT9zPM57hPr3iyp38txtsJbaZcVJ
        Zn5o6zf6zHjmbbayqmb/NGLxuDhrlKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627471434;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zxZSXYV2Z8DNKyoSP3gHfHG8rbc/74gGdkpASn+huMw=;
        b=y37h0CWFkS8T2Wz0LLWXnZ5IQpme04sEKqk6jI4m2pX4c7jCVUUkMPvQ4CoaqdawGcXfa1
        XVAokszAJLQ1LmBA==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 816C9A3B8B;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     alsa-devel@alsa-project.org
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/5] ASoC: xilinx: Fix reference to PCM buffer address
Date:   Wed, 28 Jul 2021 13:23:51 +0200
Message-Id: <20210728112353.6675-4-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210728112353.6675-1-tiwai@suse.de>
References: <20210728112353.6675-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PCM buffers might be allocated dynamically when the buffer
preallocation failed or a larger buffer is requested, and it's not
guaranteed that substream->dma_buffer points to the actually used
buffer.  The driver needs to refer to substream->runtime->dma_addr
instead for the buffer address.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index 1d59fb668c77..91afea9d5de6 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -452,8 +452,8 @@ static int xlnx_formatter_pcm_hw_params(struct snd_soc_component *component,
 
 	stream_data->buffer_size = size;
 
-	low = lower_32_bits(substream->dma_buffer.addr);
-	high = upper_32_bits(substream->dma_buffer.addr);
+	low = lower_32_bits(runtime->dma_addr);
+	high = upper_32_bits(runtime->dma_addr);
 	writel(low, stream_data->mmio + XLNX_AUD_BUFF_ADDR_LSB);
 	writel(high, stream_data->mmio + XLNX_AUD_BUFF_ADDR_MSB);
 
-- 
2.26.2

