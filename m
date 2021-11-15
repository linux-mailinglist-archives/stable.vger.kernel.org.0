Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C2E4512FC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhKOTnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245245AbhKOTTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C5AA6351E;
        Mon, 15 Nov 2021 18:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001071;
        bh=Pa29cUfN9Qos/fMEE/K7sGbW0glSM32TIVsi3jcd7Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHH2hCqaMHPeZAXS8sITCOsiVhNoZgJbZWw0ZVbQUIxyaCZc2aMlZVlh4ibtOdt9m
         0RYpe26NpETRFbO2s6LVrXn4Q3JSeyaC7JyRDuxqozkLewE5Y0ww1n8IgBNO22GA3d
         pBkUcJBL7qFEjGt4z57knSeMBJQ5aJOjxJvqqf40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 048/917] ALSA: pci: rme: Fix unaligned buffer addresses
Date:   Mon, 15 Nov 2021 17:52:23 +0100
Message-Id: <20211115165430.398925776@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 43d35ccc36dad52377dd349b2e3ea803b72c3906 upstream.

The recent fix for setting up the DMA buffer type on RME drivers tried
to address the non-standard memory managements and changed the DMA
buffer information to the standard snd_dma_buffer object that is
allocated at the probe time.  However, I overlooked that the RME
drivers handle the buffer addresses based on 64k alignment, and the
previous conversion broke that silently.

This patch is an attempt to fix the regression.  The snd_dma_buffer
objects are copied to the original data with the correction to the
aligned accesses, and those are passed to snd_pcm_set_runtime_buffer()
helpers instead.  The original snd_dma_buffer objects are managed by
devres, hence they'll be released automagically.

Fixes: 0899a7a23047 ("ALSA: pci: rme: Set up buffer type properly")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211108145752.30572-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/rme9652/hdsp.c    |   41 +++++++++++++++++++++++------------------
 sound/pci/rme9652/rme9652.c |   41 +++++++++++++++++++++++------------------
 2 files changed, 46 insertions(+), 36 deletions(-)

--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -468,8 +468,11 @@ struct hdsp {
 	unsigned char         ss_out_channels;
 	u32                   io_loopback;          /* output loopback channel states*/
 
-	struct snd_dma_buffer *capture_dma_buf;
-	struct snd_dma_buffer *playback_dma_buf;
+	/* DMA buffers; those are copied instances from the original snd_dma_buf
+	 * objects (which are managed via devres) for the address alignments
+	 */
+	struct snd_dma_buffer capture_dma_buf;
+	struct snd_dma_buffer playback_dma_buf;
 	unsigned char        *capture_buffer;	    /* suitably aligned address */
 	unsigned char        *playback_buffer;	    /* suitably aligned address */
 
@@ -3764,30 +3767,32 @@ static void snd_hdsp_proc_init(struct hd
 
 static int snd_hdsp_initialize_memory(struct hdsp *hdsp)
 {
-	unsigned long pb_bus, cb_bus;
+	struct snd_dma_buffer *capture_dma, *playback_dma;
 
-	hdsp->capture_dma_buf =
-		snd_hammerfall_get_buffer(hdsp->pci, HDSP_DMA_AREA_BYTES);
-	hdsp->playback_dma_buf =
-		snd_hammerfall_get_buffer(hdsp->pci, HDSP_DMA_AREA_BYTES);
-	if (!hdsp->capture_dma_buf || !hdsp->playback_dma_buf) {
+	capture_dma = snd_hammerfall_get_buffer(hdsp->pci, HDSP_DMA_AREA_BYTES);
+	playback_dma = snd_hammerfall_get_buffer(hdsp->pci, HDSP_DMA_AREA_BYTES);
+	if (!capture_dma || !playback_dma) {
 		dev_err(hdsp->card->dev,
 			"%s: no buffers available\n", hdsp->card_name);
 		return -ENOMEM;
 	}
 
-	/* Align to bus-space 64K boundary */
+	/* copy to the own data for alignment */
+	hdsp->capture_dma_buf = *capture_dma;
+	hdsp->playback_dma_buf = *playback_dma;
 
-	cb_bus = ALIGN(hdsp->capture_dma_buf->addr, 0x10000ul);
-	pb_bus = ALIGN(hdsp->playback_dma_buf->addr, 0x10000ul);
+	/* Align to bus-space 64K boundary */
+	hdsp->capture_dma_buf.addr = ALIGN(capture_dma->addr, 0x10000ul);
+	hdsp->playback_dma_buf.addr = ALIGN(playback_dma->addr, 0x10000ul);
 
 	/* Tell the card where it is */
+	hdsp_write(hdsp, HDSP_inputBufferAddress, hdsp->capture_dma_buf.addr);
+	hdsp_write(hdsp, HDSP_outputBufferAddress, hdsp->playback_dma_buf.addr);
 
-	hdsp_write(hdsp, HDSP_inputBufferAddress, cb_bus);
-	hdsp_write(hdsp, HDSP_outputBufferAddress, pb_bus);
-
-	hdsp->capture_buffer = hdsp->capture_dma_buf->area + (cb_bus - hdsp->capture_dma_buf->addr);
-	hdsp->playback_buffer = hdsp->playback_dma_buf->area + (pb_bus - hdsp->playback_dma_buf->addr);
+	hdsp->capture_dma_buf.area += hdsp->capture_dma_buf.addr - capture_dma->addr;
+	hdsp->playback_dma_buf.area += hdsp->playback_dma_buf.addr - playback_dma->addr;
+	hdsp->capture_buffer = hdsp->capture_dma_buf.area;
+	hdsp->playback_buffer = hdsp->playback_dma_buf.area;
 
 	return 0;
 }
@@ -4507,7 +4512,7 @@ static int snd_hdsp_playback_open(struct
 	snd_pcm_set_sync(substream);
 
         runtime->hw = snd_hdsp_playback_subinfo;
-	snd_pcm_set_runtime_buffer(substream, hdsp->playback_dma_buf);
+	snd_pcm_set_runtime_buffer(substream, &hdsp->playback_dma_buf);
 
 	hdsp->playback_pid = current->pid;
 	hdsp->playback_substream = substream;
@@ -4583,7 +4588,7 @@ static int snd_hdsp_capture_open(struct
 	snd_pcm_set_sync(substream);
 
 	runtime->hw = snd_hdsp_capture_subinfo;
-	snd_pcm_set_runtime_buffer(substream, hdsp->capture_dma_buf);
+	snd_pcm_set_runtime_buffer(substream, &hdsp->capture_dma_buf);
 
 	hdsp->capture_pid = current->pid;
 	hdsp->capture_substream = substream;
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -208,8 +208,11 @@ struct snd_rme9652 {
 	unsigned char ds_channels;
 	unsigned char ss_channels;	/* different for hammerfall/hammerfall-light */
 
-	struct snd_dma_buffer *playback_dma_buf;
-	struct snd_dma_buffer *capture_dma_buf;
+	/* DMA buffers; those are copied instances from the original snd_dma_buf
+	 * objects (which are managed via devres) for the address alignments
+	 */
+	struct snd_dma_buffer playback_dma_buf;
+	struct snd_dma_buffer capture_dma_buf;
 
 	unsigned char *capture_buffer;	/* suitably aligned address */
 	unsigned char *playback_buffer;	/* suitably aligned address */
@@ -1719,30 +1722,32 @@ static void snd_rme9652_card_free(struct
 
 static int snd_rme9652_initialize_memory(struct snd_rme9652 *rme9652)
 {
-	unsigned long pb_bus, cb_bus;
+	struct snd_dma_buffer *capture_dma, *playback_dma;
 
-	rme9652->capture_dma_buf =
-		snd_hammerfall_get_buffer(rme9652->pci, RME9652_DMA_AREA_BYTES);
-	rme9652->playback_dma_buf =
-		snd_hammerfall_get_buffer(rme9652->pci, RME9652_DMA_AREA_BYTES);
-	if (!rme9652->capture_dma_buf || !rme9652->playback_dma_buf) {
+	capture_dma = snd_hammerfall_get_buffer(rme9652->pci, RME9652_DMA_AREA_BYTES);
+	playback_dma = snd_hammerfall_get_buffer(rme9652->pci, RME9652_DMA_AREA_BYTES);
+	if (!capture_dma || !playback_dma) {
 		dev_err(rme9652->card->dev,
 			"%s: no buffers available\n", rme9652->card_name);
 		return -ENOMEM;
 	}
 
-	/* Align to bus-space 64K boundary */
+	/* copy to the own data for alignment */
+	rme9652->capture_dma_buf = *capture_dma;
+	rme9652->playback_dma_buf = *playback_dma;
 
-	cb_bus = ALIGN(rme9652->capture_dma_buf->addr, 0x10000ul);
-	pb_bus = ALIGN(rme9652->playback_dma_buf->addr, 0x10000ul);
+	/* Align to bus-space 64K boundary */
+	rme9652->capture_dma_buf.addr = ALIGN(capture_dma->addr, 0x10000ul);
+	rme9652->playback_dma_buf.addr = ALIGN(playback_dma->addr, 0x10000ul);
 
 	/* Tell the card where it is */
+	rme9652_write(rme9652, RME9652_rec_buffer, rme9652->capture_dma_buf.addr);
+	rme9652_write(rme9652, RME9652_play_buffer, rme9652->playback_dma_buf.addr);
 
-	rme9652_write(rme9652, RME9652_rec_buffer, cb_bus);
-	rme9652_write(rme9652, RME9652_play_buffer, pb_bus);
-
-	rme9652->capture_buffer = rme9652->capture_dma_buf->area + (cb_bus - rme9652->capture_dma_buf->addr);
-	rme9652->playback_buffer = rme9652->playback_dma_buf->area + (pb_bus - rme9652->playback_dma_buf->addr);
+	rme9652->capture_dma_buf.area += rme9652->capture_dma_buf.addr - capture_dma->addr;
+	rme9652->playback_dma_buf.area += rme9652->playback_dma_buf.addr - playback_dma->addr;
+	rme9652->capture_buffer = rme9652->capture_dma_buf.area;
+	rme9652->playback_buffer = rme9652->playback_dma_buf.area;
 
 	return 0;
 }
@@ -2259,7 +2264,7 @@ static int snd_rme9652_playback_open(str
 	snd_pcm_set_sync(substream);
 
         runtime->hw = snd_rme9652_playback_subinfo;
-	snd_pcm_set_runtime_buffer(substream, rme9652->playback_dma_buf);
+	snd_pcm_set_runtime_buffer(substream, &rme9652->playback_dma_buf);
 
 	if (rme9652->capture_substream == NULL) {
 		rme9652_stop(rme9652);
@@ -2318,7 +2323,7 @@ static int snd_rme9652_capture_open(stru
 	snd_pcm_set_sync(substream);
 
 	runtime->hw = snd_rme9652_capture_subinfo;
-	snd_pcm_set_runtime_buffer(substream, rme9652->capture_dma_buf);
+	snd_pcm_set_runtime_buffer(substream, &rme9652->capture_dma_buf);
 
 	if (rme9652->playback_substream == NULL) {
 		rme9652_stop(rme9652);


