Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C058499B98
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575010AbiAXVuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458144AbiAXVmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8B8C07A955;
        Mon, 24 Jan 2022 12:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29FB661383;
        Mon, 24 Jan 2022 20:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0839AC340E7;
        Mon, 24 Jan 2022 20:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056259;
        bh=e9ukgO2HtZrPpeNCuBBCRIWPjwNXuYeZrknKf0Rh6RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgRrmsTKzTTTv/EGe2/6mLZcTDNyzgT2ZkUe4NjXOrhz68EM2VKuJ2JR42Mrod+KR
         IjJJbCrVTEgw0RFCoJhjmB4aFEGucRNLDWdwZZYaxEHszfWLleRXbwg9HAIvwNLXqj
         hZfOj8Unhwkj4ZPUDAe3oP5m99tPICIj2FK4Izu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/846] ASoC: Intel: catpt: Test dmaengine_submit() result before moving on
Date:   Mon, 24 Jan 2022 19:39:01 +0100
Message-Id: <20220124184115.607866287@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 2a9a72e290d4a4741e673f86b9fba9bfb319786d ]

After calling dmaengine_submit(), the submitted transfer descriptor
belongs to the DMA engine. Pointer to that descriptor may no longer be
valid after the call and should be tested before awaiting transfer
completion.

Reported-by: Kevin Tian <kevin.tian@intel.com>
Suggested-by: Dave Jiang <dave.jiang@intel.com>
Fixes: 4fac9b31d0b9 ("ASoC: Intel: Add catpt base members")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20211216115743.2130622-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/catpt/dsp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/catpt/dsp.c b/sound/soc/intel/catpt/dsp.c
index 9c5fd18f2600f..346bec0003066 100644
--- a/sound/soc/intel/catpt/dsp.c
+++ b/sound/soc/intel/catpt/dsp.c
@@ -65,6 +65,7 @@ static int catpt_dma_memcpy(struct catpt_dev *cdev, struct dma_chan *chan,
 {
 	struct dma_async_tx_descriptor *desc;
 	enum dma_status status;
+	int ret;
 
 	desc = dmaengine_prep_dma_memcpy(chan, dst_addr, src_addr, size,
 					 DMA_CTRL_ACK);
@@ -77,13 +78,22 @@ static int catpt_dma_memcpy(struct catpt_dev *cdev, struct dma_chan *chan,
 	catpt_updatel_shim(cdev, HMDC,
 			   CATPT_HMDC_HDDA(CATPT_DMA_DEVID, chan->chan_id),
 			   CATPT_HMDC_HDDA(CATPT_DMA_DEVID, chan->chan_id));
-	dmaengine_submit(desc);
+
+	ret = dma_submit_error(dmaengine_submit(desc));
+	if (ret) {
+		dev_err(cdev->dev, "submit tx failed: %d\n", ret);
+		goto clear_hdda;
+	}
+
 	status = dma_wait_for_async_tx(desc);
+	ret = (status == DMA_COMPLETE) ? 0 : -EPROTO;
+
+clear_hdda:
 	/* regardless of status, disable access to HOST memory in demand mode */
 	catpt_updatel_shim(cdev, HMDC,
 			   CATPT_HMDC_HDDA(CATPT_DMA_DEVID, chan->chan_id), 0);
 
-	return (status == DMA_COMPLETE) ? 0 : -EPROTO;
+	return ret;
 }
 
 int catpt_dma_memcpy_todsp(struct catpt_dev *cdev, struct dma_chan *chan,
-- 
2.34.1



