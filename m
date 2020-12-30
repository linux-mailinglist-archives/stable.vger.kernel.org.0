Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C0F2E7934
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgL3NHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:07:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727449AbgL3NF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D71B1229EF;
        Wed, 30 Dec 2020 13:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333474;
        bh=lAXHsb70nJP+WYyBcH4Sr0dYyef1OZUZJDEgRu/5+Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MT/Mg4JGG1hPSHbCbsP1k5QWOjxRowd68evOaAKrTQilr8fPT2poXfw/v9j64wfiv
         Ki/uzT4tYW8B4OxTtGCdxhQZZ9qYIgTpU9LmTb7QobcdRkngiAoI+Z3n0ej3bQI9NQ
         w1bW00PqNoiixIuyTqTz6yUUfD7R4zR2zPRJQ9Qn0osfy4noIPTdNZ4Pjrmm2I6x0x
         fgWTvLMM+9WMrQl8rsu/xOw+Zkv+E99K6hRkLNDHHmOMtHY0SHuGVm0hm3PdqHULs8
         E7d8GshT7LpAwPUX5XiWIrEalh9HNttrzYSgsNGVwX5ZeR4phmbqaAnb53vDE7o4Rt
         YdfaUGf8KuRyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 09/10] ALSA: pcm: Clear the full allocated memory at hw_params
Date:   Wed, 30 Dec 2020 08:04:21 -0500
Message-Id: <20201230130422.3637448-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130422.3637448-1-sashal@kernel.org>
References: <20201230130422.3637448-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 618de0f4ef11acd8cf26902e65493d46cc20cc89 ]

The PCM hw_params core function tries to clear up the PCM buffer
before actually using for avoiding the information leak from the
previous usages or the usage before a new allocation.  It performs the
memset() with runtime->dma_bytes, but this might still leave some
remaining bytes untouched; namely, the PCM buffer size is aligned in
page size for mmap, hence runtime->dma_bytes doesn't necessarily cover
all PCM buffer pages, and the remaining bytes are exposed via mmap.

This patch changes the memory clearance to cover the all buffer pages
if the stream is supposed to be mmap-ready (that guarantees that the
buffer size is aligned in page size).

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20201218145625.2045-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 7c12b0deb4eb5..db62dbe7eaa8a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -753,8 +753,13 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 		runtime->boundary *= 2;
 
 	/* clear the buffer for avoiding possible kernel info leaks */
-	if (runtime->dma_area && !substream->ops->copy_user)
-		memset(runtime->dma_area, 0, runtime->dma_bytes);
+	if (runtime->dma_area && !substream->ops->copy_user) {
+		size_t size = runtime->dma_bytes;
+
+		if (runtime->info & SNDRV_PCM_INFO_MMAP)
+			size = PAGE_ALIGN(size);
+		memset(runtime->dma_area, 0, size);
+	}
 
 	snd_pcm_timer_resolution_change(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_SETUP);
-- 
2.27.0

