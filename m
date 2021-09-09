Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBA4404FC1
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352326AbhIIMW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352834AbhIIMTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:19:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 029B161AAB;
        Thu,  9 Sep 2021 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188222;
        bh=sQYVfnoL0J/WnRQewf8hj4OQQlqQpZwChqsObkIN0ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB/o08I07TW2gdheqdleLenaVtr41WK3YpmOaapx0kD62AZt7fEqOfnIaoJkqFdcM
         w9xCYhgd7rCanjbSj11zSGiYmlaOjjh2DJOuWkuJf4G7+PQuQic5WSb+Cepb4pJW00
         R9ekJ8Ehd+akL61726Nx1K2ZoCibKIM3c32PI8GCrcIPuHL847PxorxIs2prvIPQ6q
         17+I5bUCg2zTjVJgDq4is5mYw0KF6uH7q3vFqnVYuaEMWaPYses61X6aEKb4Ntucgm
         pj1u4/S1AppQMCpunEOlln7/4WQIYloxQz1w2DoOjBoKL6b6gJk8OGY2bLoymdfYQR
         xOfUgQCTeCv6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 176/219] ASoC: intel: atom: Revert PCM buffer address setup workaround again
Date:   Thu,  9 Sep 2021 07:45:52 -0400
Message-Id: <20210909114635.143983-176-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e28ac04a705e946eddc5e7d2fc712dea3f20fe9e ]

We worked around the breakage of PCM buffer setup by the commit
65ca89c2b12c ("ASoC: intel: atom: Fix breakage for PCM buffer address
setup"), but this isn't necessary since the CONTINUOUS buffer type
also sets runtime->dma_addr since commit f84ba106a018 ("ALSA:
memalloc: Store snd_dma_buffer.addr for continuous pages, too").
Let's revert the change again.

Link: https://lore.kernel.org/r/20210822072127.9786-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 905c7965f653..5db2f4865bbb 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -127,7 +127,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = virt_to_phys(substream->runtime->dma_area);
+	u32 buffer_addr = substream->runtime->dma_addr;
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
-- 
2.30.2

