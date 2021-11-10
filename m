Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5698544C7FA
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhKJS5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:57:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233678AbhKJSzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:55:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3195D61361;
        Wed, 10 Nov 2021 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570163;
        bh=KgYe8l5uXW+b7N5vXL+54Scwqn/I3CIuIgDVqFAHJsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6/ZBVhyFKW81eGD93ip959PWwOBsrcDYW0QE//4D0w77v0dag9A8+28GdsUaRmcD
         EH/I0NOS+RS1xjPzlhhPi6TAVu41aZxyQn0+xIJsbLl0BiL9387KCK0Ljz/2etrOXD
         NtkyceylYXFNyi6idqWdMtHiTwsS1g5GkutnkgpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 02/24] ALSA: pci: cs46xx: Fix set up buffer type properly
Date:   Wed, 10 Nov 2021 19:43:54 +0100
Message-Id: <20211110182003.416185064@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4d9e9153f1c64d91a125c6967bc0bfb0bb653ea0 upstream.

CS46xx driver switches the buffer depending on the number of periods,
and in some cases it switches to the own buffer without updating the
buffer type properly.  This may cause a problem with the mmap on
exotic architectures that require the own mmap call for the coherent
DMA buffer.

This patch addresses the potential breakage by replacing the buffer
setup with the proper macro.  It also simplifies the source code,
too.

Link: https://lore.kernel.org/r/20210809071829.22238-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cs46xx/cs46xx_lib.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -1121,9 +1121,7 @@ static int snd_cs46xx_playback_hw_params
 	if (params_periods(hw_params) == CS46XX_FRAGS) {
 		if (runtime->dma_area != cpcm->hw_buf.area)
 			snd_pcm_lib_free_pages(substream);
-		runtime->dma_area = cpcm->hw_buf.area;
-		runtime->dma_addr = cpcm->hw_buf.addr;
-		runtime->dma_bytes = cpcm->hw_buf.bytes;
+		snd_pcm_set_runtime_buffer(substream, &cpcm->hw_buf);
 
 
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
@@ -1143,11 +1141,8 @@ static int snd_cs46xx_playback_hw_params
 #endif
 
 	} else {
-		if (runtime->dma_area == cpcm->hw_buf.area) {
-			runtime->dma_area = NULL;
-			runtime->dma_addr = 0;
-			runtime->dma_bytes = 0;
-		}
+		if (runtime->dma_area == cpcm->hw_buf.area)
+			snd_pcm_set_runtime_buffer(substream, NULL);
 		err = snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(hw_params));
 		if (err < 0) {
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
@@ -1196,9 +1191,7 @@ static int snd_cs46xx_playback_hw_free(s
 	if (runtime->dma_area != cpcm->hw_buf.area)
 		snd_pcm_lib_free_pages(substream);
     
-	runtime->dma_area = NULL;
-	runtime->dma_addr = 0;
-	runtime->dma_bytes = 0;
+	snd_pcm_set_runtime_buffer(substream, NULL);
 
 	return 0;
 }
@@ -1287,16 +1280,11 @@ static int snd_cs46xx_capture_hw_params(
 	if (runtime->periods == CS46XX_FRAGS) {
 		if (runtime->dma_area != chip->capt.hw_buf.area)
 			snd_pcm_lib_free_pages(substream);
-		runtime->dma_area = chip->capt.hw_buf.area;
-		runtime->dma_addr = chip->capt.hw_buf.addr;
-		runtime->dma_bytes = chip->capt.hw_buf.bytes;
+		snd_pcm_set_runtime_buffer(substream, &chip->capt.hw_buf);
 		substream->ops = &snd_cs46xx_capture_ops;
 	} else {
-		if (runtime->dma_area == chip->capt.hw_buf.area) {
-			runtime->dma_area = NULL;
-			runtime->dma_addr = 0;
-			runtime->dma_bytes = 0;
-		}
+		if (runtime->dma_area == chip->capt.hw_buf.area)
+			snd_pcm_set_runtime_buffer(substream, NULL);
 		err = snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(hw_params));
 		if (err < 0)
 			return err;
@@ -1313,9 +1301,7 @@ static int snd_cs46xx_capture_hw_free(st
 
 	if (runtime->dma_area != chip->capt.hw_buf.area)
 		snd_pcm_lib_free_pages(substream);
-	runtime->dma_area = NULL;
-	runtime->dma_addr = 0;
-	runtime->dma_bytes = 0;
+	snd_pcm_set_runtime_buffer(substream, NULL);
 
 	return 0;
 }


