Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104D53F66EB
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbhHXR2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239838AbhHXR0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5776A613D2;
        Tue, 24 Aug 2021 17:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824702;
        bh=f/nvjyo225lMQLtXUC7kdnxxODRMtM+8czzkauiZav8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dALXuPhzW1EkRNL5x2uGSQivl6kpw7Bph/N8HFb3YtmDnHHrIRLsS21e+0kD8bnCc
         p8nHP1UvrTjlrfThZXQ6z0NqsSaYmz4PZ/kiVi7O2/et/+N03XBp9Sobse2i/mjrZW
         uxhqZoEUl9RQQoYCBLimh1/NF5A7iU27s+e06uZTjHxjA4W5rVI1S+y7sb/g4EpMcQ
         Ff837PV+S2VHMVdCieAKkpTX1lBRjKpLhQar9YeJ+vPwqOjEm/flFnb4UoasijcGom
         kOp0QqiJZLcrvzM0iXN8xwsiXis1jac+PiHd4yU2FcKOL9asyeBbNCbepavnyDL4sI
         N9qSTQGCgp4dA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 03/64] ASoC: intel: atom: Fix reference to PCM buffer address
Date:   Tue, 24 Aug 2021 13:03:56 -0400
Message-Id: <20210824170457.710623-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2e6b836312a477d647a7920b56810a5a25f6c856 upstream.

PCM buffers might be allocated dynamically when the buffer
preallocation failed or a larger buffer is requested, and it's not
guaranteed that substream->dma_buffer points to the actually used
buffer.  The address should be retrieved from runtime->dma_addr,
instead of substream->dma_buffer (and shouldn't use virt_to_phys).

Also, remove the line overriding runtime->dma_area superfluously,
which was already set up at the PCM buffer allocation.

Cc: Cezary Rojewski <cezary.rojewski@intel.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210728112353.6675-3-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index cdc0f22a57ee..c877326cb0a6 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -135,7 +135,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t period_size;
 	ssize_t periodbytes;
 	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
-	u32 buffer_addr = virt_to_phys(substream->dma_buffer.area);
+	u32 buffer_addr = substream->runtime->dma_addr;
 
 	channels = substream->runtime->channels;
 	period_size = substream->runtime->period_size;
@@ -241,7 +241,6 @@ static int sst_platform_alloc_stream(struct snd_pcm_substream *substream,
 	/* set codec params and inform SST driver the same */
 	sst_fill_pcm_params(substream, &param);
 	sst_fill_alloc_params(substream, &alloc_params);
-	substream->runtime->dma_area = substream->dma_buffer.area;
 	str_params.sparams = param;
 	str_params.aparams = alloc_params;
 	str_params.codec = SST_CODEC_TYPE_PCM;
-- 
2.30.2

