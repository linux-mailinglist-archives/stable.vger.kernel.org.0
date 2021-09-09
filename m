Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CF5405650
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359502AbhIINTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358657AbhIINJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 001FA632C6;
        Thu,  9 Sep 2021 12:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188864;
        bh=Rnuu5MBNNKu7ao+bz2wwpD1xyDiLkKDC8HXBpCJK0Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbnHOQ5/1XxnJ2kCQaPPhSQCEEOsdrgcB++vi9V4UVq47dH8MNwHX4tqV4bXSOjK1
         ZGHzdAOjwlPHIOydD1BG818Kz3U9htStbsQ9+retmrCgHiEG1oc98r8UBYiWAKGcTW
         YcMLK18GEBzIy+w1mdZOzyJTvpjHqIFzCR7MjjRQK/YS0AhKWt4EioMQIG1Gj6JEjF
         Vi8vptTLEPPsHJgymNAOG/EsGRSMBKp49YkgAb3mnhuoMrLjb+eqdaEqN9DTByN4gm
         xnOI0lafklOhva8rVZt4p1OzGCH0BOKlSKBwNSgt5Ao0zvurgziyXiaK9VjPuPlcDn
         F7yeQ0GOxgjsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 39/48] ASoC: intel: atom: Revert PCM buffer address setup workaround again
Date:   Thu,  9 Sep 2021 08:00:06 -0400
Message-Id: <20210909120015.150411-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index 1b6dedfc33e3..6303b2d3982d 100644
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

