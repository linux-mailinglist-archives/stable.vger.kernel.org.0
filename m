Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233C53F67DE
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhHXRiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241543AbhHXRgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:36:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE79C61B46;
        Tue, 24 Aug 2021 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824815;
        bh=tmErq8VbvJyU+Snc2XP+PGWPU8/hIDNQCHPjJxeKaI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfKa94lV/zKYGDX4xGgLipe/PYUrzWE0GC9mzhANxzvtbgxl40GhmBvq+lt0IhK/j
         VaLT7T/aNAnCwPlKS9vuiVvA4CBfs/6rx3ns80EBU4Fc4SyPojMIEXmF4h/G+IWDLP
         7aCVaoMlFW38lll690SVln50VBQ0RexKwMBfuFRR+j3no7XynNDUX8N7biJHeU0F8y
         5k6PQ1mCE/sL3G4UPF69aK5AGouu8Y6C1VXGFsElkSZ9oKNZA5Evg7uEYxPTd0TJzN
         GgEVABIMSedE6HpLRIr5hCr6pAH7I2Reh2gY1892HWvm6H+pLVo1zs+3E1OVGqwAZx
         Sd5lV7gPDkMlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/43] ASoC: intel: atom: Fix breakage for PCM buffer address setup
Date:   Tue, 24 Aug 2021 13:06:11 -0400
Message-Id: <20210824170614.710813-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
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
index 6303b2d3982d..1b6dedfc33e3 100644
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

