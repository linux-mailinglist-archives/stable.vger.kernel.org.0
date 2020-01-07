Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5DF1331A1
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgAGVCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbgAGVCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98DE32187F;
        Tue,  7 Jan 2020 21:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430950;
        bh=Rbq9ff1kEAgmg60+E1Ba2H3rPuwflhxi/vZb09xzZRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHj1NdRzUfpXbyvZpYwPRfXZWy2rkmOTyziarYJkQ/z4dFuA4JdepEWXN7o9nmo4X
         I167MxH5DmOwJ/2ox3YCAfyVc/IhU6R1zz8qBVzLGG7NieDJmUefKvFjH/qNtce2hl
         sl5A/nkMuYNv+S/TOMnLT+LmyhWJr7LkYmlqUMFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 126/191] ALSA: pcm: Yet another missing check of non-cached buffer type
Date:   Tue,  7 Jan 2020 21:54:06 +0100
Message-Id: <20200107205339.720940752@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2406ff9b86aa1b77fe1a6d15f37195ac1fdb2a14 upstream.

For non-x86 architectures, SNDRV_DMA_TYPE_DEV_UC should be treated
equivalent with SNDRV_DMA_TYPE_DEV, where the default mmap handler
still checks only about SNDRV_DMA_TYPE_DEV.  Make the check more
proper.

Note that all existing users of *_UC buffer types are x86-only, so
this doesn't fix any bug, but just for consistency.

Fixes: 42e748a0b325 ("ALSA: memalloc: Add non-cached buffer type")
Link: https://lore.kernel.org/r/20191108165626.5947-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_native.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3408,7 +3408,8 @@ int snd_pcm_lib_default_mmap(struct snd_
 #endif /* CONFIG_GENERIC_ALLOCATOR */
 #ifndef CONFIG_X86 /* for avoiding warnings arch/x86/mm/pat.c */
 	if (IS_ENABLED(CONFIG_HAS_DMA) && !substream->ops->page &&
-	    substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV)
+	    (substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV ||
+	     substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV_UC))
 		return dma_mmap_coherent(substream->dma_buffer.dev.dev,
 					 area,
 					 substream->runtime->dma_area,


