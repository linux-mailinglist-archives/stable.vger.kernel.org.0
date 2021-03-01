Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0E1328AF4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhCAS0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:26:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239717AbhCASUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A3D565130;
        Mon,  1 Mar 2021 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618232;
        bh=VpZyAlHJ0UQq/2F1yEnZCUDoku6qW+o29wPQKdf+8tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3Q4IFnPWD3nC/sPOSsf0zOO3T3RwNUR7VUqD86l9DXsa01cJBYbJ3RNGueZZvGA7
         QJ8C9zkuUCXgweXFjYMnpE6WRSZrL1xQ0TTX7MbxEBfQy7nM5OWcMERMfDAviz6dnV
         zk1UZQO68Ror7M4kjgkNMnEU7v2klCOh+TsQAJh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 013/663] ALSA: usb-audio: Fix PCM buffer allocation in non-vmalloc mode
Date:   Mon,  1 Mar 2021 17:04:21 +0100
Message-Id: <20210301161142.442178044@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
@@ -1861,7 +1861,7 @@ void snd_usb_preallocate_buffer(struct s
 {
 	struct snd_pcm *pcm = subs->stream->pcm;
 	struct snd_pcm_substream *s = pcm->streams[subs->direction].substream;
-	struct device *dev = subs->dev->bus->controller;
+	struct device *dev = subs->dev->bus->sysdev;
 
 	if (snd_usb_use_vmalloc)
 		snd_pcm_set_managed_buffer(s, SNDRV_DMA_TYPE_VMALLOC,


