Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4AD405523
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355178AbhIINI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355703AbhIINDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27DBF6329E;
        Thu,  9 Sep 2021 11:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188795;
        bh=oYJiCx/R2zj8tB3GBLoUG1YKz8/b0mUWrrn503eqvUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMfofQ71zZcZNDSQoo0RN4tDLKEJ6+W5MoWTiPLVySBGne7dYXL4KwMaJC9e4Pbbt
         a8Keug8eMicTuxvyAyvoXNJzx5+0fJtTA8GRjt7JEAyoHc8LMYsrZURTh6KILN516F
         wzMyLkqNGwUiXbHH6jEG5uVOuRGKcMgUYqi4vAhL0vwuGeXvXvZvTvJYPdwrJoY+m3
         BYN+y0dMdc/V9Ceh1ARY7PaiAZBMPRVY1fYNGvYmCPDU1xXLgbw1B0cxipXMSO7wGw
         MwuvEZrGXEJICHXyOlFbnmYwUD+hi94sEExpA9cTE0rePiSggQ17wcKiVtdG5rW319
         lvL+pTR23J9sA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 44/59] ASoC: intel: atom: Revert PCM buffer address setup workaround again
Date:   Thu,  9 Sep 2021 07:58:45 -0400
Message-Id: <20210909115900.149795-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index 96f7facd0fa0..c877326cb0a6 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -135,7 +135,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = virt_to_phys(substream->runtime->dma_area);
+	u32 buffer_addr = substream->runtime->dma_addr;
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
-- 
2.30.2

