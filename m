Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6357E404B93
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbhIILxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239669AbhIILux (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E658361355;
        Thu,  9 Sep 2021 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187837;
        bh=5dJO6w+5dh4dsYlnWN7LmnTtcZk0Tkos3wR4UE4Nr4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkXHEmRpD2RBh84Ld4yMo0KUcrQ0j/Br2dcbRR5n/l+1e3ESECBp8J1oWsUsY+M19
         ztZyVgATFOvraWkcUZu8LVAM0ufmWFIKZA/aFzMXtK+U5HqGJ6ge7+ief/+HVv5b5u
         IY3CLtjNHg/WNnhUfcEwYRwPnZPwfrkP0YEhbdPKSjTDAoImOKMnJnRcGLRGaZMCMt
         KThgdCCkDxj1CEkzkRbX2e+IC6ZjZWHYOy6Hzy3yw/sj3hv82Bv2Fhx+yfbjkkO3ER
         4cHgMAy7Bp2HCmopmafh4cat+hkcOYwV9IkqgQkPiRDRRsso98Cqx255qa+MDlm7Nh
         0UXfeKXqGsuCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 132/252] ALSA: pci: cs46xx: Fix set up buffer type properly
Date:   Thu,  9 Sep 2021 07:39:06 -0400
Message-Id: <20210909114106.141462-132-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4d9e9153f1c64d91a125c6967bc0bfb0bb653ea0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/cs46xx/cs46xx_lib.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 1e1eb17f8e07..d43927dcd61e 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -1121,9 +1121,7 @@ static int snd_cs46xx_playback_hw_params(struct snd_pcm_substream *substream,
 	if (params_periods(hw_params) == CS46XX_FRAGS) {
 		if (runtime->dma_area != cpcm->hw_buf.area)
 			snd_pcm_lib_free_pages(substream);
-		runtime->dma_area = cpcm->hw_buf.area;
-		runtime->dma_addr = cpcm->hw_buf.addr;
-		runtime->dma_bytes = cpcm->hw_buf.bytes;
+		snd_pcm_set_runtime_buffer(substream, &cpcm->hw_buf);
 
 
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
@@ -1143,11 +1141,8 @@ static int snd_cs46xx_playback_hw_params(struct snd_pcm_substream *substream,
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
@@ -1196,9 +1191,7 @@ static int snd_cs46xx_playback_hw_free(struct snd_pcm_substream *substream)
 	if (runtime->dma_area != cpcm->hw_buf.area)
 		snd_pcm_lib_free_pages(substream);
     
-	runtime->dma_area = NULL;
-	runtime->dma_addr = 0;
-	runtime->dma_bytes = 0;
+	snd_pcm_set_runtime_buffer(substream, NULL);
 
 	return 0;
 }
@@ -1287,16 +1280,11 @@ static int snd_cs46xx_capture_hw_params(struct snd_pcm_substream *substream,
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
@@ -1313,9 +1301,7 @@ static int snd_cs46xx_capture_hw_free(struct snd_pcm_substream *substream)
 
 	if (runtime->dma_area != chip->capt.hw_buf.area)
 		snd_pcm_lib_free_pages(substream);
-	runtime->dma_area = NULL;
-	runtime->dma_addr = 0;
-	runtime->dma_bytes = 0;
+	snd_pcm_set_runtime_buffer(substream, NULL);
 
 	return 0;
 }
-- 
2.30.2

