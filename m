Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303CA3ED5D3
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhHPNP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237505AbhHPNNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 275BE6329F;
        Mon, 16 Aug 2021 13:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119436;
        bh=V0g9pCcgr6TQ1n/JR5Lpq1Ud0GpHqEe5x2dUg3Q1zBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRt3LP61xnrztemnGDlT6cVG79YWZPcZHTCII08bstLHhNTl+gU36Xd0Iwe1duvDj
         1lWxBM9u7+sKilmfpIqG7nf2J3fIv6IdF2i20OjTSzf+iFlqzxApa2Ci8CchUiSIXc
         tdw7S3M2x2ZXU7iRjlIw/OyFh3zIq785+RBVHp64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.13 007/151] ASoC: amd: Fix reference to PCM buffer address
Date:   Mon, 16 Aug 2021 15:00:37 +0200
Message-Id: <20210816125444.325488048@linuxfoundation.org>
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

commit 8b5d95313b6d30f642e4ed0125891984c446604e upstream.

PCM buffers might be allocated dynamically when the buffer
preallocation failed or a larger buffer is requested, and it's not
guaranteed that substream->dma_buffer points to the actually used
buffer.  The driver needs to refer to substream->runtime->dma_addr
instead for the buffer address.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210731084331.32225-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/acp-pcm-dma.c          |    2 +-
 sound/soc/amd/raven/acp3x-pcm-dma.c  |    2 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/amd/acp-pcm-dma.c
+++ b/sound/soc/amd/acp-pcm-dma.c
@@ -969,7 +969,7 @@ static int acp_dma_hw_params(struct snd_
 
 	acp_set_sram_bank_state(rtd->acp_mmio, 0, true);
 	/* Save for runtime private data */
-	rtd->dma_addr = substream->dma_buffer.addr;
+	rtd->dma_addr = runtime->dma_addr;
 	rtd->order = get_order(size);
 
 	/* Fill the page table entries in ACP SRAM */
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -286,7 +286,7 @@ static int acp3x_dma_hw_params(struct sn
 		pr_err("pinfo failed\n");
 	}
 	size = params_buffer_bytes(params);
-	rtd->dma_addr = substream->dma_buffer.addr;
+	rtd->dma_addr = substream->runtime->dma_addr;
 	rtd->num_pages = (PAGE_ALIGN(size) >> PAGE_SHIFT);
 	config_acp3x_dma(rtd, substream->stream);
 	return 0;
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -246,7 +246,7 @@ static int acp_pdm_dma_hw_params(struct
 		return -EINVAL;
 	size = params_buffer_bytes(params);
 	period_bytes = params_period_bytes(params);
-	rtd->dma_addr = substream->dma_buffer.addr;
+	rtd->dma_addr = substream->runtime->dma_addr;
 	rtd->num_pages = (PAGE_ALIGN(size) >> PAGE_SHIFT);
 	config_acp_dma(rtd, substream->stream);
 	init_pdm_ring_buffer(MEM_WINDOW_START, size, period_bytes,


