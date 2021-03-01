Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E57632897E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhCAR5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238968AbhCARvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:51:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B90650A2;
        Mon,  1 Mar 2021 17:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620054;
        bh=gsSBsaN2vV5sf5GBB8ILF0HW3IXBAhVe7GPY5Ie63t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZxNxsdL1n3JI4+QInKafNe3zBHfkBvSQhVg3w/CHKjVoxIN1+kDGkX/9p2yRFLXo
         acyUsT1rjGxzKnoPPOasGJoZpvemdOy8Xtuq+PcUso7P2YEo2t0DPNN8NmT0YJm0Yt
         L+VZqD68lvE5Vj7rRw3CTrp+1IIH4S1rVgtPbrvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 014/775] ALSA: usb-audio: Fix PCM buffer allocation in non-vmalloc mode
Date:   Mon,  1 Mar 2021 17:03:02 +0100
Message-Id: <20210301161202.415686082@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit fb3c293b82c31a9a68fbcf4e7a45fadd8a47ea2b upstream.

The commit f274baa49be6 ("ALSA: usb-audio: Allow non-vmalloc buffer
for PCM buffers") introduced the mode to allocate coherent pages for
PCM buffers, and it used bus->controller device as its DMA device.
It turned out, however, that bus->sysdev is a more appropriate device
to be used for DMA mapping in HCD code.

This patch corrects the device reference accordingly.

Note that, on most platforms, both point to the very same device,
hence this patch doesn't change anything practically.  But on
platforms like xhcd-plat hcd, the change becomes effective.

Fixes: f274baa49be6 ("ALSA: usb-audio: Allow non-vmalloc buffer for PCM buffers")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210205144559.29555-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1558,7 +1558,7 @@ void snd_usb_preallocate_buffer(struct s
 {
 	struct snd_pcm *pcm = subs->stream->pcm;
 	struct snd_pcm_substream *s = pcm->streams[subs->direction].substream;
-	struct device *dev = subs->dev->bus->controller;
+	struct device *dev = subs->dev->bus->sysdev;
 
 	if (snd_usb_use_vmalloc)
 		snd_pcm_set_managed_buffer(s, SNDRV_DMA_TYPE_VMALLOC,


