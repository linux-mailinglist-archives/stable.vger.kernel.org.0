Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436F13D8CA8
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 13:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhG1LX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 07:23:57 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39780 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbhG1LX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 07:23:56 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9E02122318;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627471434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLNE5iXLSb9YoiScs/jMmgMOKs5H0No9v7cRRFOmhOY=;
        b=MjK+r6LH4NfjfG7sjSH9mjPFrdW5Avs2gkI1pEExkgzZoB7oxkDmeIuQQLlEYoykjVy8/8
        E07qzOb9Rth6Cp6O2kDzH7QFFAo1e/vsCULQfw7mojBA28Rn5toAw9jXwmX0ETNhNzXEUD
        t9Ov/pLllVGATzsyAwWE7n8k2E/kRZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627471434;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLNE5iXLSb9YoiScs/jMmgMOKs5H0No9v7cRRFOmhOY=;
        b=cwmQsrL0nt80h7apeLfKPvCuMHwWADQrVjZFQLYMHpRIKcSbJiED3VrEJYNySM/NO5zK4T
        tG8bHiP/zLJxGBCA==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 8EE4DA3B81;
        Wed, 28 Jul 2021 11:23:54 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     alsa-devel@alsa-project.org
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 4/5] ASoC: uniphier: Fix reference to PCM buffer address
Date:   Wed, 28 Jul 2021 13:23:52 +0200
Message-Id: <20210728112353.6675-5-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210728112353.6675-1-tiwai@suse.de>
References: <20210728112353.6675-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Along with the transition to the managed PCM buffers, the driver now
accepts the dynamically allocated buffer, while it still kept the
reference to the old preallocated buffer address.  This patch corrects
to the right reference via runtime->dma_addr.

(Although this might have been already buggy before the cleanup with
the managed buffer, let's put Fixes tag to point that; it's a corner
case, after all.)

Fixes: d55894bc2763 ("ASoC: uniphier: Use managed buffer allocation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/soc/uniphier/aio-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/uniphier/aio-dma.c b/sound/soc/uniphier/aio-dma.c
index 3c1628a3a1ac..3d9736e7381f 100644
--- a/sound/soc/uniphier/aio-dma.c
+++ b/sound/soc/uniphier/aio-dma.c
@@ -198,7 +198,7 @@ static int uniphier_aiodma_mmap(struct snd_soc_component *component,
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
 	return remap_pfn_range(vma, vma->vm_start,
-			       substream->dma_buffer.addr >> PAGE_SHIFT,
+			       substream->runtime->dma_addr >> PAGE_SHIFT,
 			       vma->vm_end - vma->vm_start, vma->vm_page_prot);
 }
 
-- 
2.26.2

