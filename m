Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C72127A1
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 08:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfECGS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 02:18:58 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:53074 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfECGS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 02:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=ZQwUU+J/MQcrEGIy0MJ+HGRMeveOuqWSbA/IkAltfgs=; b=dBcYRvUe1aCP
        YZGZsViJliQgDvfMwTe4+d113vEp7lkGUS7j9+9b0hacgeOKj4nV6j9rfXymYydE48ER93PKLjne8
        5qNi67Fq6TvXnRW3RgKVYGbLeTHwwcLOrvQLTtKF6W3JccRjWJHGdmelTC9HnbavV/QJf5lKY4KJE
        icsyw=;
Received: from [42.29.24.106] (helo=finisterre.ee.mobilebroadband)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hMRWw-0000Wg-Oi; Fri, 03 May 2019 06:18:47 +0000
Received: by finisterre.ee.mobilebroadband (Postfix, from userid 1000)
        id 6D839441D58; Fri,  3 May 2019 07:18:42 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Jie Yang <yang.jie@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ross Zwisler <zwisler@google.com>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.com>
Subject: Applied "ASoC: Intel: avoid Oops if DMA setup fails" to the asoc tree
In-Reply-To: <20190429182517.210909-1-zwisler@google.com>
X-Patchwork-Hint: ignore
Message-Id: <20190503061842.6D839441D58@finisterre.ee.mobilebroadband>
Date:   Fri,  3 May 2019 07:18:42 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: Intel: avoid Oops if DMA setup fails

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.2

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 0efa3334d65b7f421ba12382dfa58f6ff5bf83c4 Mon Sep 17 00:00:00 2001
From: Ross Zwisler <zwisler@chromium.org>
Date: Mon, 29 Apr 2019 12:25:17 -0600
Subject: [PATCH] ASoC: Intel: avoid Oops if DMA setup fails

Currently in sst_dsp_new() if we get an error return from sst_dma_new()
we just print an error message and then still complete the function
successfully.  This means that we are trying to run without sst->dma
properly set up, which will result in NULL pointer dereference when
sst->dma is later used.  This was happening for me in
sst_dsp_dma_get_channel():

        struct sst_dma *dma = dsp->dma;
	...
        dma->ch = dma_request_channel(mask, dma_chan_filter, dsp);

This resulted in:

   BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
   IP: sst_dsp_dma_get_channel+0x4f/0x125 [snd_soc_sst_firmware]

Fix this by adding proper error handling for the case where we fail to
set up DMA.

This change only affects Haswell and Broadwell systems.  Baytrail
systems explicilty opt-out of DMA via sst->pdata->resindex_dma_base
being set to -1.

Signed-off-by: Ross Zwisler <zwisler@google.com>
Cc: stable@vger.kernel.org
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/intel/common/sst-firmware.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/common/sst-firmware.c b/sound/soc/intel/common/sst-firmware.c
index 1e067504b604..f830e59f93ea 100644
--- a/sound/soc/intel/common/sst-firmware.c
+++ b/sound/soc/intel/common/sst-firmware.c
@@ -1251,11 +1251,15 @@ struct sst_dsp *sst_dsp_new(struct device *dev,
 		goto irq_err;
 
 	err = sst_dma_new(sst);
-	if (err)
-		dev_warn(dev, "sst_dma_new failed %d\n", err);
+	if (err)  {
+		dev_err(dev, "sst_dma_new failed %d\n", err);
+		goto dma_err;
+	}
 
 	return sst;
 
+dma_err:
+	free_irq(sst->irq, sst);
 irq_err:
 	if (sst->ops->free)
 		sst->ops->free(sst);
-- 
2.20.1

