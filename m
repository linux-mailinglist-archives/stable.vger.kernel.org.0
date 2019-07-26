Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9518767C4
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfGZNj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727336AbfGZNjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928C222BF5;
        Fri, 26 Jul 2019 13:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148395;
        bh=WlgqJ2mMnBB9/OWIiyXcImKmI4a4+nQG6JXuqaoxSRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=en8bKg71fCL2otUnbd17Ix7fcy1TCPgu521VMGICCvHCfAFjbggz1TvbqN8jfS8Dg
         MjkDSpE31lYivcDa6mXuuGgALy1w0uuJUsdK4ouGbvBRRbil/mPFJzwh2Fo9FUkMed
         SgyhmChoMXZRFr01AsrKs0jNxvWziLzimHBbLH7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 11/85] dmaengine: tegra-apb: Error out if DMA_PREP_INTERRUPT flag is unset
Date:   Fri, 26 Jul 2019 09:38:21 -0400
Message-Id: <20190726133936.11177-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit dc161064beb83c668e0f85766b92b1e7ed186e58 ]

Apparently driver was never tested with DMA_PREP_INTERRUPT flag being
unset since it completely disables interrupt handling instead of skipping
the callbacks invocations, hence putting channel into unusable state.

The flag is always set by all of kernel drivers that use APB DMA, so let's
error out in otherwise case for consistency. It won't be difficult to
support that case properly if ever will be needed.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra20-apb-dma.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index ef317c90fbe1..79e9593815f1 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -977,8 +977,12 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
 		csr |= tdc->slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
 	}
 
-	if (flags & DMA_PREP_INTERRUPT)
+	if (flags & DMA_PREP_INTERRUPT) {
 		csr |= TEGRA_APBDMA_CSR_IE_EOC;
+	} else {
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
 
 	apb_seq |= TEGRA_APBDMA_APBSEQ_WRAP_WORD_1;
 
@@ -1120,8 +1124,12 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 		csr |= tdc->slave_id << TEGRA_APBDMA_CSR_REQ_SEL_SHIFT;
 	}
 
-	if (flags & DMA_PREP_INTERRUPT)
+	if (flags & DMA_PREP_INTERRUPT) {
 		csr |= TEGRA_APBDMA_CSR_IE_EOC;
+	} else {
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
 
 	apb_seq |= TEGRA_APBDMA_APBSEQ_WRAP_WORD_1;
 
-- 
2.20.1

