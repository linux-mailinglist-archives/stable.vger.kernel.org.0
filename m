Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0488B15C301
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgBMPjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387623AbgBMP3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:07 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A04172168B;
        Thu, 13 Feb 2020 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607746;
        bh=h01NWZOOigUYj3y7BGnmqb1uz3HLgPVnrUQFyR0V3Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joRpHBQepGwgQd5BTj3bYtfZAxoHh4tWRcM51QV/SNIUjuMdJQ+y5tXvvIHaqAFiF
         wN6xQG3fFj6PigBt8UwPQ5OKfMGuJKAjR29bbYidtV3QE21TZCyRVycTryWtXMfuAT
         Yr7/qc/5dk8flaRdjtU38BgScn5u3fYLECssQjDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 104/120] ASoC: soc-generic-dmaengine-pcm: Fix error handling
Date:   Thu, 13 Feb 2020 07:21:40 -0800
Message-Id: <20200213151935.722992932@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 130128098a4e5ce9a0dfbdf9a7e27a43579901fd upstream.

Remove the return value checking, that is to align with the code
before adding snd_dmaengine_pcm_refine_runtime_hwparams function.

Otherwise it causes a regression on the HiKey board:

[   17.721424] hi6210_i2s f7118000.i2s: ASoC: can't open component f7118000.i2s: -6

Fixes: e957204e732b ("ASoC: pcm_dmaengine: Extract snd_dmaengine_pcm_refine_runtime_hwparams")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Link: https://lore.kernel.org/r/1579505286-32085-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-generic-dmaengine-pcm.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -117,7 +117,6 @@ dmaengine_pcm_set_runtime_hwparams(struc
 	struct dma_chan *chan = pcm->chan[substream->stream];
 	struct snd_dmaengine_dai_dma_data *dma_data;
 	struct snd_pcm_hardware hw;
-	int ret;
 
 	if (pcm->config && pcm->config->pcm_hardware)
 		return snd_soc_set_runtime_hwparams(substream,
@@ -138,12 +137,15 @@ dmaengine_pcm_set_runtime_hwparams(struc
 	if (pcm->flags & SND_DMAENGINE_PCM_FLAG_NO_RESIDUE)
 		hw.info |= SNDRV_PCM_INFO_BATCH;
 
-	ret = snd_dmaengine_pcm_refine_runtime_hwparams(substream,
-							dma_data,
-							&hw,
-							chan);
-	if (ret)
-		return ret;
+	/**
+	 * FIXME: Remove the return value check to align with the code
+	 * before adding snd_dmaengine_pcm_refine_runtime_hwparams
+	 * function.
+	 */
+	snd_dmaengine_pcm_refine_runtime_hwparams(substream,
+						  dma_data,
+						  &hw,
+						  chan);
 
 	return snd_soc_set_runtime_hwparams(substream, &hw);
 }


