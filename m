Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E061F3ED592
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbhHPNMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236967AbhHPNHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:07:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88BE632A8;
        Mon, 16 Aug 2021 13:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119217;
        bh=BhIA9zJ/exLmau+ZqDDNyypST8RT8hSrTga1VebG2Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYXgp5EKrJTzZU5lm4z1MFLjykdEFTHt2wLsRuyTSEEpMZBoUbJaChEUkJx0Suo8g
         xwys0kl1f9MaiDxoDPP19yBv6c2zPyi81abrg/hVjkX2vVVEx64mze7YFQoN93eHXU
         nO4rl3q+VJ80ONoVw2t1Dhd17gDjlVDCjFsWV2IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 09/96] ASoC: intel: atom: Fix reference to PCM buffer address
Date:   Mon, 16 Aug 2021 15:01:19 +0200
Message-Id: <20210816125435.239774557@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2e6b836312a477d647a7920b56810a5a25f6c856 upstream.

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
Link: https://lore.kernel.org/r/20210728112353.6675-3-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -127,7 +127,7 @@ static void sst_fill_alloc_params(struct
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = virt_to_phys(substream->dma_buffer.area);
+	u32 buffer_addr = substream->runtime->dma_addr;
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
@@ -233,7 +233,6 @@ static int sst_platform_alloc_stream(str
 	/* set codec params and inform SST driver the same */
 	sst_fill_pcm_params(substream, &param);
 	sst_fill_alloc_params(substream, &alloc_params);
-	substream->runtime->dma_area = substream->dma_buffer.area;
 	str_params.sparams = param;
 	str_params.aparams = alloc_params;
 	str_params.codec = SST_CODEC_TYPE_PCM;


