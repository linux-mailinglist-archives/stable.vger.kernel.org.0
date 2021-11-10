Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5208D44C7DD
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhKJS4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232697AbhKJSya (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:54:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB636619E8;
        Wed, 10 Nov 2021 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570138;
        bh=5P+CV5TATPTtoir218qglaHIm3frLX7l/G/zKQctxZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzNfpPJqGvIO49xi4aCGUWKeDI/bcGSF7FarX43TimPef7Ffp92WLuHWt5BZiE8yT
         RhRDau1tu/blzP9wc24gydI/qhVq1EenFvr6qTbOKw71DuY4lbysp8ImxSp8QGlM8Y
         GsE9J2YMe8IVdEdwx2g7PaMx7KPoGUy/bqHLxCNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 01/24] ALSA: pcm: Check mmap capability of runtime dma buffer at first
Date:   Wed, 10 Nov 2021 19:43:53 +0100
Message-Id: <20211110182003.386664901@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit cbea6e5a7772b7a5b80baa8f98fd77853487fd2a upstream.

Currently we check only the substream->dma_buffer as the preset of the
buffer configuration for verifying the availability of mmap.  But a
few drivers rather set up the buffer in the own way without the
standard buffer preallocation using substream->dma_buffer, and they
miss the proper checks.  (Now it's working more or less fine as most
of them are running only on x86).

Actually, they may set up the runtime dma_buffer (referred via
snd_pcm_get_dma_buf()) at the open callback, though.  That is, this
could have been used as the primary source.

This patch changes the hw_support_mmap() function to check the runtime
dma buffer at first.  It's usually NULL with the standard buffer
preallocation, and in that case, we continue checking
substream->dma_buffer as fallback.

Link: https://lore.kernel.org/r/20210809071829.22238-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -243,13 +243,18 @@ int snd_pcm_info_user(struct snd_pcm_sub
 
 static bool hw_support_mmap(struct snd_pcm_substream *substream)
 {
+	struct snd_dma_buffer *dmabuf;
+
 	if (!(substream->runtime->hw.info & SNDRV_PCM_INFO_MMAP))
 		return false;
 
 	if (substream->ops->mmap || substream->ops->page)
 		return true;
 
-	switch (substream->dma_buffer.dev.type) {
+	dmabuf = snd_pcm_get_dma_buf(substream);
+	if (!dmabuf)
+		dmabuf = &substream->dma_buffer;
+	switch (dmabuf->dev.type) {
 	case SNDRV_DMA_TYPE_UNKNOWN:
 		/* we can't know the device, so just assume that the driver does
 		 * everything right
@@ -259,7 +264,7 @@ static bool hw_support_mmap(struct snd_p
 	case SNDRV_DMA_TYPE_VMALLOC:
 		return true;
 	default:
-		return dma_can_mmap(substream->dma_buffer.dev.dev);
+		return dma_can_mmap(dmabuf->dev.dev);
 	}
 }
 


