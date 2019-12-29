Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2BA12C6C4
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbfL2RuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731818AbfL2RuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9817820718;
        Sun, 29 Dec 2019 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641814;
        bh=qjpoMGgXjcNmi4j8T+3Fy+8TjF0hWqMvbn2ZLk8QUQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Umy12WIB1vqpMXXtyzoiTFytY0Fbc5fbIhrLIQo4wxQyODleaIYGVfjeGjmY4iZDe
         UxdswukpDFwBJ/pLMGGD7oztYo6TQoH6vB8NBgQ2b+qiwWu0fepvl1wS1oKC4AJWfy
         obb0lZ0EJX8dSoQx/OnHfkGvIj+4tY8vCrgSs6E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/434] ALSA: pcm: Fix missing check of the new non-cached buffer type
Date:   Sun, 29 Dec 2019 18:24:34 +0100
Message-Id: <20191229172716.523417491@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 91c6ad58729f..c3a139436ac2 100644
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



