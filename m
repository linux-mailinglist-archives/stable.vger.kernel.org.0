Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B8B14BA3C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgA1Ohs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730923AbgA1OTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6DEC2468F;
        Tue, 28 Jan 2020 14:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221181;
        bh=HY+wfotgluU10jnyLR4+EduJuquGEvYO7BcvVCfbxrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GL5Ckk4G0VzlgHy6mnSMGAOSkSdD234RY9Ux13xY7Pq4cOtEo5g1PcT92SOPj4Z7C
         gg0Pv/ck4BwPsJpWyogdD5VQ0/KZqeWl8m6wWa3aP8ylo6SgxI+DYTVPERUWhjllml
         bj7BlzdtugwXNizTuSOyWLkXSo3ReVA3g+fn+OEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 122/271] dmaengine: axi-dmac: Dont check the number of frames for alignment
Date:   Tue, 28 Jan 2020 15:04:31 +0100
Message-Id: <20200128135901.671922895@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 648865a79d8ee3d1aa64aab5eb2a9d12eeed14f9 ]

In 2D transfers (for the AXI DMAC), the number of frames (numf) represents
Y_LENGTH, and the length of a frame is X_LENGTH. 2D transfers are useful
for video transfers where screen resolutions ( X * Y ) are typically
aligned for X, but not for Y.

There is no requirement for Y_LENGTH to be aligned to the bus-width (or
anything), and this is also true for AXI DMAC.

Checking the Y_LENGTH for alignment causes false errors when initiating DMA
transfers. This change fixes this by checking only that the Y_LENGTH is
non-zero.

Fixes: 0e3b67b348b8 ("dmaengine: Add support for the Analog Devices AXI-DMAC DMA controller")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index 7f0b9aa158679..9887f2a14aa98 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -451,7 +451,7 @@ static struct dma_async_tx_descriptor *axi_dmac_prep_interleaved(
 
 	if (chan->hw_2d) {
 		if (!axi_dmac_check_len(chan, xt->sgl[0].size) ||
-		    !axi_dmac_check_len(chan, xt->numf))
+		    xt->numf == 0)
 			return NULL;
 		if (xt->sgl[0].size + dst_icg > chan->max_length ||
 		    xt->sgl[0].size + src_icg > chan->max_length)
-- 
2.20.1



