Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8310C3D8CA9
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 13:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhG1LX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 07:23:57 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57830 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhG1LX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 07:23:56 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 83E691FF88;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627471434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uOLAxgFmuIdFVl8t9Q3JRIAsoz6GO4ZzUHxR55M5+qk=;
        b=jZjnFHSfstJWxgB0XrDp+UolP1Zm4spmkVhfrYreQk1Nim5It1dv0K5Qgpd3eHvZO1/+2e
        QdbFJcz4MjsOgOSqovgEMcjgavsBZNoDx3Mdibj141sARGvRGvRbtWqnDPuvk4RDoLNFWJ
        ub5jOIhiMZfFPsAhkNubYRheXlno5Ic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627471434;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uOLAxgFmuIdFVl8t9Q3JRIAsoz6GO4ZzUHxR55M5+qk=;
        b=lm+uiI0hpUG3lWwruUtGW3bJ/qKuuxB2gE/QMMuntYkAuOqbDGMChzula/mXoci1Yi/s+e
        UhGNr1bKPwxmq9Bw==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 6E388A3B81;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     alsa-devel@alsa-project.org
Cc:     Mark Brown <broonie@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/5] ASoC: intel: atom: Fix reference to PCM buffer address
Date:   Wed, 28 Jul 2021 13:23:50 +0200
Message-Id: <20210728112353.6675-3-tiwai@suse.de>
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
buffer.  The address should be retrieved from runtime->dma_addr,
instead of substream->dma_buffer (and shouldn't use virt_to_phys).

Also, remove the line overriding runtime->dma_area superfluously,
which was already set up at the PCM buffer allocation.

Cc: Cezary Rojewski <cezary.rojewski@intel.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 4124aa2fc247..5db2f4865bbb 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -127,7 +127,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = virt_to_phys(substream->dma_buffer.area);
+	u32 buffer_addr = substream->runtime->dma_addr;
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
@@ -233,7 +233,6 @@ static int sst_platform_alloc_stream(struct snd_pcm_substream *substream,
 	/* set codec params and inform SST driver the same */
 	sst_fill_pcm_params(substream, &param);
 	sst_fill_alloc_params(substream, &alloc_params);
-	substream->runtime->dma_area = substream->dma_buffer.area;
 	str_params.sparams = param;
 	str_params.aparams = alloc_params;
 	str_params.codec = SST_CODEC_TYPE_PCM;
-- 
2.26.2

