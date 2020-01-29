Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7080D14C839
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 10:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA2Jkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 04:40:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:50856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgA2Jkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 04:40:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B60A5ACF0;
        Wed, 29 Jan 2020 09:40:44 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andreas Schneider <asn@cryptomilk.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.4.y] ALSA: pcm: Add missing copy ops check before clearing buffer
Date:   Wed, 29 Jan 2020 10:40:41 +0100
Message-Id: <20200129094041.12272-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ this is a fix specific to 4.4.y and 4.9.y stable trees;
  4.14.y and older already contain the right fix ]

The stable 4.4.y and 4.9.y backports of the upstream commit
add9d56d7b37 ("ALSA: pcm: Avoid possible info leaks from PCM stream
buffers") dropped the check of substream->ops->copy_user as copy_user
is a new member that isn't present in the older kernels.
Although upstream drivers should work without this NULL check, it may
cause a regression with a downstream driver that sets some
inaccessible address to runtime->dma_area, leading to a crash at
worst.

Since such drivers must have ops->copy member on older kernels instead
of ops->copy_user, this patch adds the missing check of ops->copy for
fixing the regression.

Reported-and-tested-by: Andreas Schneider <asn@cryptomilk.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/core/pcm_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index b9bfbf394959..59423576b1cc 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -588,7 +588,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 		runtime->boundary *= 2;
 
 	/* clear the buffer for avoiding possible kernel info leaks */
-	if (runtime->dma_area)
+	if (runtime->dma_area && !substream->ops->copy)
 		memset(runtime->dma_area, 0, runtime->dma_bytes);
 
 	snd_pcm_timer_resolution_change(substream);
-- 
2.16.4

