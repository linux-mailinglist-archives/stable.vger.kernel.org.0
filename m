Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B754054C0
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349434AbhIINDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355571AbhIIM5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0657863251;
        Thu,  9 Sep 2021 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188717;
        bh=FRq+ITQ7cE3VDO3rLKqTjflgtQDvLrubnXxkMwr6glw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7Xt1EIdZ5UQ6sBfjjqGC8hOz7Paz7LLsUdSkzCSdT76z/RuMmPJULcxHzynTItnY
         5RhFhpIpijiO35YXctDG+Epk71o615PUl5cO1RfmSUMOgPHelAny2dVoHR8iyYIvcj
         fZPOx6E3ZEQ6sxb0OZGtMt+ND86mML1fKcpHeKQTmUW3G3PAPmJDD4/+FUKqmMBsan
         yhO9Qisj3RUmyINIKgrXNA/XkncoCll9M36g8sWeCF41wvDEABotPCoGx8asPHxmLa
         frTDbI883XBAxJqzMOGGVb/Vb4w/02jqhfalvG6/t5oGCy9ZuIp+aXpKwJJzMP6RIO
         L40sxeQFROxuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 57/74] ASoC: intel: atom: Revert PCM buffer address setup workaround again
Date:   Thu,  9 Sep 2021 07:57:09 -0400
Message-Id: <20210909115726.149004-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index 682ee41ec75c..501ac836777a 100644
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

