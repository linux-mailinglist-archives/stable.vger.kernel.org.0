Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1123A13F617
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437240AbgAPTAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388832AbgAPRGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B57D12051A;
        Thu, 16 Jan 2020 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194376;
        bh=MHCXh7mx53nDHYWT2DU9sSjTnihaBUSrAy8mAcy3JuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PadDOdtK6DlcbCslVTxd5K2c1fDcWNCR4wqYPo4Z+QBl3thKhnOPY6idbvjgY7e06
         1KK+Y2l0o3SURfPG/yuKPfT87/rPWsb4RilW/1x/iUTKLh88sv4WXUi+HxceUbyJLQ
         VctuNWXH+nG7cqVqCqRk1ADnv6r1hXGlGJdFGdtc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 308/671] dmaengine: axi-dmac: Don't check the number of frames for alignment
Date:   Thu, 16 Jan 2020 11:59:06 -0500
Message-Id: <20200116170509.12787-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 15b2453d2647..b2c755b74bea 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -486,7 +486,7 @@ static struct dma_async_tx_descriptor *axi_dmac_prep_interleaved(
 
 	if (chan->hw_2d) {
 		if (!axi_dmac_check_len(chan, xt->sgl[0].size) ||
-		    !axi_dmac_check_len(chan, xt->numf))
+		    xt->numf == 0)
 			return NULL;
 		if (xt->sgl[0].size + dst_icg > chan->max_length ||
 		    xt->sgl[0].size + src_icg > chan->max_length)
-- 
2.20.1

