Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD623F66D7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbhHXR2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240578AbhHXR0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DCBB61B3E;
        Tue, 24 Aug 2021 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824649;
        bh=Bx3EvdD7+8ct4roylUOvmjuDmf/uDDzHr4EslT2ykPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdwrrj/RNgdi5uylqzEEPcaZsAFXqmcVGgiyLZOLAlJHaj3G107P4NBnOgBFpAIFm
         GqnpGgEe5mCnU3nDjPJ7oib6nA3d64rG2xPwS7jSa4c1CdHNw5u4S+J7JL90BUWne9
         MDsMhD43vJheZhzF2iU/5Tj07fkLCTp5cpCizB9JjXzle5rKY0Q0GSz8ceNIaK1tb+
         CaDexfDJiWsjP4pYzjrudW3YR+sbmUskBFhF4gJtbzPKiGeRlKc/xfdpUWefGJetAj
         bjSf3y3ZTos2zgX/qO3U72yOLagOT+yRtanNLmae+yh0t7mqTdqaww5KemTmr1BoPC
         F+vYMHldAPTYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 80/84] ASoC: intel: atom: Fix breakage for PCM buffer address setup
Date:   Tue, 24 Aug 2021 13:02:46 -0400
Message-Id: <20210824170250.710392-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 65ca89c2b12cca0d473f3dd54267568ad3af55cc ]

The commit 2e6b836312a4 ("ASoC: intel: atom: Fix reference to PCM
buffer address") changed the reference of PCM buffer address to
substream->runtime->dma_addr as the buffer address may change
dynamically.  However, I forgot that the dma_addr field is still not
set up for the CONTINUOUS buffer type (that this driver uses) yet in
5.14 and earlier kernels, and it resulted in garbage I/O.  The problem
will be fixed in 5.15, but we need to address it quickly for now.

The fix is to deduce the address again from the DMA pointer with
virt_to_phys(), but from the right one, substream->runtime->dma_area.

Fixes: 2e6b836312a4 ("ASoC: intel: atom: Fix reference to PCM buffer address")
Reported-and-tested-by: Hans de Goede <hdegoede@redhat.com>
Cc: <stable@vger.kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/2048c6aa-2187-46bd-6772-36a4fb3c5aeb@redhat.com
Link: https://lore.kernel.org/r/20210819152945.8510-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 501ac836777a..682ee41ec75c 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -135,7 +135,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = substream->runtime->dma_addr;
+	u32 buffer_addr = virt_to_phys(substream->runtime->dma_area);
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
-- 
2.30.2

