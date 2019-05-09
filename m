Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD011919C
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfEISxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbfEISxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:53:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3CD2177E;
        Thu,  9 May 2019 18:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428021;
        bh=K7/Z7ULPaiMrGML8CskPhXEpmnsruK7vDzfr3sp2vPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPFi0+UfKxLcQ+hEibCH2QwLQ26w9vLPT63JXJxphs47e7bMaSW/b+HTZ15uKrvBx
         COH6k9ozQG7sjN3iKKhk0NE+f4Hz3NF5mA5HMtis13iSl277Jdg/hpzp7DPMNpBkpi
         VBrmhlF3Zj25rVl9zHrWxmjRN8i+TDORkZUCo5F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.0 92/95] ASoC: Intel: avoid Oops if DMA setup fails
Date:   Thu,  9 May 2019 20:42:49 +0200
Message-Id: <20190509181315.648532906@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Zwisler <zwisler@chromium.org>

commit 0efa3334d65b7f421ba12382dfa58f6ff5bf83c4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/common/sst-firmware.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/soc/intel/common/sst-firmware.c
+++ b/sound/soc/intel/common/sst-firmware.c
@@ -1251,11 +1251,15 @@ struct sst_dsp *sst_dsp_new(struct devic
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


