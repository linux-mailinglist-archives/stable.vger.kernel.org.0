Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CCE3D8CA6
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 13:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhG1LX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 07:23:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57818 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhG1LX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 07:23:56 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 70E841FF79;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627471434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NaLs8BsZk6odCGRALkXaO/U8Ju0yashC2G+aBewOPs=;
        b=X76o6Zbp+wWwX7xXGLvMSWzqZSGP9Yg/93iJgtVbawcotr5Cb7GY6v959U1ReOY2rahwzF
        fI95dmfn09QRtJhZuQt5nSErUqNvlGdtCJEhNlrNwK9RUVzltt81wBz/yXFgIE3XVzboh+
        wTJwxf/um86Mxq599MZRephCy6y80vU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627471434;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8NaLs8BsZk6odCGRALkXaO/U8Ju0yashC2G+aBewOPs=;
        b=Gtyenl5QjqADEvqXdAHA8GcH8UkI7qMEiWteLiGo7OVxIL8+k6PntD+RYVwBday38kpXEU
        7PiCtvHQKUY7aGBA==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 5FC71A3B8B;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     alsa-devel@alsa-project.org
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/5] ASoC: amd: Fix reference to PCM buffer address
Date:   Wed, 28 Jul 2021 13:23:49 +0200
Message-Id: <20210728112353.6675-2-tiwai@suse.de>
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
 sound/soc/amd/acp-pcm-dma.c          | 2 +-
 sound/soc/amd/raven/acp3x-pcm-dma.c  | 2 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/amd/acp-pcm-dma.c b/sound/soc/amd/acp-pcm-dma.c
index 143155a840ac..cc1ce6f22caa 100644
--- a/sound/soc/amd/acp-pcm-dma.c
+++ b/sound/soc/amd/acp-pcm-dma.c
@@ -969,7 +969,7 @@ static int acp_dma_hw_params(struct snd_soc_component *component,
 
 	acp_set_sram_bank_state(rtd->acp_mmio, 0, true);
 	/* Save for runtime private data */
-	rtd->dma_addr = substream->dma_buffer.addr;
+	rtd->dma_addr = runtime->dma_addr;
 	rtd->order = get_order(size);
 
 	/* Fill the page table entries in ACP SRAM */
diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 8148b0d22e88..597d7c4b2a6b 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -286,7 +286,7 @@ static int acp3x_dma_hw_params(struct snd_soc_component *component,
 		pr_err("pinfo failed\n");
 	}
 	size = params_buffer_bytes(params);
-	rtd->dma_addr = substream->dma_buffer.addr;
+	rtd->dma_addr = substream->runtime->dma_addr;
 	rtd->num_pages = (PAGE_ALIGN(size) >> PAGE_SHIFT);
 	config_acp3x_dma(rtd, substream->stream);
 	return 0;
diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index bd20622b0933..11bd22f4fef5 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -242,7 +242,7 @@ static int acp_pdm_dma_hw_params(struct snd_soc_component *component,
 		return -EINVAL;
 	size = params_buffer_bytes(params);
 	period_bytes = params_period_bytes(params);
-	rtd->dma_addr = substream->dma_buffer.addr;
+	rtd->dma_addr = runtime->dma_addr;
 	rtd->num_pages = (PAGE_ALIGN(size) >> PAGE_SHIFT);
 	config_acp_dma(rtd, substream->stream);
 	init_pdm_ring_buffer(MEM_WINDOW_START, size, period_bytes,
-- 
2.26.2

