Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B3405205
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345370AbhIIMkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349239AbhIIMhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C6861BA7;
        Thu,  9 Sep 2021 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188461;
        bh=vbdf67mGKnbL5mlvXwU/akyou7+baScr6JPATev4oJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7raYbtujL8lh58SeOq5uNOax0GxF4ez4Lt3h4FaTGn24/+0F/Jx2905lz4InIZYU
         HdJ6+ptRgpb7GHqx06Dzad6a1Z92wQdl7O/tVobPlSE4Au19MKul7S4tnrROps7w8j
         IOaTjuqUps9Zi1Zgl2IAq5YVhruhRLJOFJIt0ouhByb6p5XsOXRbKGWQk3/AGTw9Bo
         MMU9NCrvliP0FQmzz1RnvI3lDxYxakE2CEAXdHlHU4k2YWXp+huzQw+1PWo23qYGg9
         qsz1nyXudeJl6lUxxQYdeyvfgflka66oDHCoXJBAzBZGyxBa3m3f5XlzzI2nnuX26H
         ARrxT5MKy4MfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 141/176] ASoC: intel: atom: Revert PCM buffer address setup workaround again
Date:   Thu,  9 Sep 2021 07:50:43 -0400
Message-Id: <20210909115118.146181-141-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e28ac04a705e946eddc5e7d2fc712dea3f20fe9e ]

We worked around the breakage of PCM buffer setup by the commit
65ca89c2b12c ("ASoC: intel: atom: Fix breakage for PCM buffer address
setup"), but this isn't necessary since the CONTINUOUS buffer type
also sets runtime->dma_addr since commit f84ba106a018 ("ALSA:
memalloc: Store snd_dma_buffer.addr for continuous pages, too").
Let's revert the change again.

Link: https://lore.kernel.org/r/20210822072127.9786-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 255b4d528a66..2784611196f0 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -127,7 +127,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = virt_to_phys(substream->runtime->dma_area);
+	u32 buffer_addr = substream->runtime->dma_addr;
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
-- 
2.30.2

