Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD3A119616
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfLJVYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728282AbfLJVKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C691324680;
        Tue, 10 Dec 2019 21:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012247;
        bh=rwRuxKl4wtv89HyUaQghbveRZ1eF/vZ80lSEysd1yrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyASVQNiWzYQc+Ng6KrcidsG7svF0H+iMDxF+pxT8UhWFzrkBjxZWYDGDXwjjKhbR
         h03NvsvUdVPfHDqcAxNWIA2pqmb24ZibGjWZfbymA/uYQC27yfWQ8CTcx6WjQjqbq6
         XasLOGciwaDyG14SjFtg23kCalV8DNtS7y8aslLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 195/350] ALSA: pcm: Fix missing check of the new non-cached buffer type
Date:   Tue, 10 Dec 2019 16:05:00 -0500
Message-Id: <20191210210735.9077-156-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6111fd2370eecae9f11bfdc08ba097e0b51fcfd3 ]

The check for the mmap support via hw_support_mmap() function misses
the case where the device is with SNDRV_DMA_TYPE_DEV_UC, which should
have been treated equally as SNDRV_DMA_TYPE_DEV.  Let's fix it.

Note that this bug doesn't hit any practical problem, because
SNDRV_DMA_TYPE_DEV_UC is used only for x86-specific drivers
(snd-hda-intel and snd-intel8x0) for the specific platforms that need
the non-cached buffers.  And, on such platforms, hw_support_mmap()
already returns true in anyway.  That's the reason I didn't put
Cc-to-stable mark here.  This is only for any theoretical future
extension.

Fixes: 425da159707b ("ALSA: pcm: use dma_can_mmap() to check if a device supports dma_mmap_*")
Fixes: 42e748a0b325 ("ALSA: memalloc: Add non-cached buffer type")
Link: https://lore.kernel.org/r/20191104101115.27311-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 91c6ad58729fe..c3a139436ac26 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -222,7 +222,8 @@ static bool hw_support_mmap(struct snd_pcm_substream *substream)
 		return false;
 
 	if (substream->ops->mmap ||
-	    substream->dma_buffer.dev.type != SNDRV_DMA_TYPE_DEV)
+	    (substream->dma_buffer.dev.type != SNDRV_DMA_TYPE_DEV &&
+	     substream->dma_buffer.dev.type != SNDRV_DMA_TYPE_DEV_UC))
 		return true;
 
 	return dma_can_mmap(substream->dma_buffer.dev.dev);
-- 
2.20.1

