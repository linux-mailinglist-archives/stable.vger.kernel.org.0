Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CEB3D60DF
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhGZPZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237835AbhGZPYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:24:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6873A60F38;
        Mon, 26 Jul 2021 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315482;
        bh=PotnVkL00huzlpfb7Bttwp0Mm9WjWG5f4iNsJZpXGoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHfPH8zXxE1CYmNM/w7kcVWM6mw6ohR0PPmtvNztVbR4QSBUc9msW65yQ0mrEgpf8
         wxRXx+AybUXbcGbjQZ8wltGt8Wi9Q9ERdQX5eJ6T/kaqPDTYUSpGp8Qpbl1DaHARRm
         akeacfxpoBZg7iRFOhpIvPsjqTJyJwYwv5UlHIKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 115/167] ALSA: pcm: Fix mmap capability check
Date:   Mon, 26 Jul 2021 17:39:08 +0200
Message-Id: <20210726153843.262460079@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c4824ae7db418aee6f50f308a20b832e58e997fd upstream.

The hw_support_mmap() doesn't cover all memory allocation types and
might use a wrong device pointer for checking the capability.
Check the all memory allocation types more completely.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210720092640.12338-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -246,12 +246,18 @@ static bool hw_support_mmap(struct snd_p
 	if (!(substream->runtime->hw.info & SNDRV_PCM_INFO_MMAP))
 		return false;
 
-	if (substream->ops->mmap ||
-	    (substream->dma_buffer.dev.type != SNDRV_DMA_TYPE_DEV &&
-	     substream->dma_buffer.dev.type != SNDRV_DMA_TYPE_DEV_UC))
+	if (substream->ops->mmap)
 		return true;
 
-	return dma_can_mmap(substream->dma_buffer.dev.dev);
+	switch (substream->dma_buffer.dev.type) {
+	case SNDRV_DMA_TYPE_UNKNOWN:
+		return false;
+	case SNDRV_DMA_TYPE_CONTINUOUS:
+	case SNDRV_DMA_TYPE_VMALLOC:
+		return true;
+	default:
+		return dma_can_mmap(substream->dma_buffer.dev.dev);
+	}
 }
 
 static int constrain_mask_params(struct snd_pcm_substream *substream,


