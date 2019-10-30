Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2D1E9F9F
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfJ3PuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbfJ3PuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:50:18 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8984F20856;
        Wed, 30 Oct 2019 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450617;
        bh=Q20vSiNZNOz4YiE2NlHcH9OoJldhsBbNcjgKqyF9u1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UjUpnvUMiQsx9VxcYuR5TwI5l3Vh4jVAG025sm0WL485grOZR/Bpl6Pu22K89G6r
         UlvywolvAUaHA9DIIudHdKwVI4+kBhOjHfIWBI8BodGfdg+AmIMHz4JYFSmrTJjkao
         rUhCt+QEPYSSUF5OH/eBEazz7pFQDTKZrT9kFbAo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 14/81] ASoC: SOF: Intel: hda: fix warnings during FW load
Date:   Wed, 30 Oct 2019 11:48:20 -0400
Message-Id: <20191030154928.9432-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 4ff5f6439fe69624e8f7d559915e9b54a6477684 ]

The "snd_pcm_substream" handle was not initialized properly
in hda-loader.c for firmware load.

When the HDA DMAs were used to load the firmware,
the interrupts related to firmware load also triggered
calls to snd_sof_pcm_period_elapsed() on a non-existent ALSA
PCM stream.

This caused runtime kernel warnings from
pcm_lib.c:snd_pcm_period_elapsed().

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927200538.660-11-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-loader.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 6427f0b3a2f11..65c2af3fcaab7 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -44,6 +44,7 @@ static int cl_stream_prepare(struct snd_sof_dev *sdev, unsigned int format,
 		return -ENODEV;
 	}
 	hstream = &dsp_stream->hstream;
+	hstream->substream = NULL;
 
 	/* allocate DMA buffer */
 	ret = snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV_SG, &pci->dev, size, dmab);
-- 
2.20.1

