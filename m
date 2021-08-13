Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958143EB8EE
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbhHMPSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242021AbhHMPQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:16:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6979960F51;
        Fri, 13 Aug 2021 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867712;
        bh=Wnr2UEfhoga8mlUyJF6OVI+WJR8GhYuImneCPcv6KkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Keto9Vs/VD73pfOMbHXsQ5vv+zRs3IoZHEyuUtH1cW/RCGKt1ysyMdEvu3+UYLapn
         pPiQo4zl1oB8YchmkmLUqjZifpZe0V41mIuWB7GZ5oVKEymjf/hhKfJrkyAGJSVij4
         92Ni5KiT8erewy278MiZxTUU9BfncI40pInrtQnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jeff Woods <jwoods@fnordco.com>
Subject: [PATCH 5.13 4/8] ALSA: pcm: Fix mmap breakage without explicit buffer setup
Date:   Fri, 13 Aug 2021 17:07:41 +0200
Message-Id: <20210813150520.224602422@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.090373732@linuxfoundation.org>
References: <20210813150520.090373732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit dc0dc8a73e8e4dc33fba93dfe23356cc5a500c57 upstream.

The recent fix c4824ae7db41 ("ALSA: pcm: Fix mmap capability check")
restricts the mmap capability only to the drivers that properly set up
the buffers, but it caused a regression for a few drivers that manage
the buffer on its own way.

For those with UNKNOWN buffer type (i.e. the uninitialized / unused
substream->dma_buffer), just assume that the driver handles the mmap
properly and blindly trust the hardware info bit.

Fixes: c4824ae7db41 ("ALSA: pcm: Fix mmap capability check")
Reported-and-tested-by: Jeff Woods <jwoods@fnordco.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/s5him0gpghv.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -251,7 +251,10 @@ static bool hw_support_mmap(struct snd_p
 
 	switch (substream->dma_buffer.dev.type) {
 	case SNDRV_DMA_TYPE_UNKNOWN:
-		return false;
+		/* we can't know the device, so just assume that the driver does
+		 * everything right
+		 */
+		return true;
 	case SNDRV_DMA_TYPE_CONTINUOUS:
 	case SNDRV_DMA_TYPE_VMALLOC:
 		return true;


