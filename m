Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF5481C41
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbfHENVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbfHENVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237F32067D;
        Mon,  5 Aug 2019 13:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011308;
        bh=RXq82yXBtpwWT7EC+LA8Ru3p7SQOpZ4Adeaw98q+AbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGnI2N964EhzcUj/8TCZx5ot0NnHMzHU1nh7eoatTscRAfe3/h0uOeIz+n1VdCoXL
         7UPc0XRDpSbNU8ceV4ktv1HY0QaMhsDPpZ48UGzHho6iIw8nqDS0sIqKgBgpQy4BlT
         AXsuI7wqUCOHEU2UQihPslzv4zGLjAxV9Z5u4RjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 011/131] dmaengine: tegra-apb: Error out if DMA_PREP_INTERRUPT flag is unset
Date:   Mon,  5 Aug 2019 15:01:38 +0200
Message-Id: <20190805124952.183362810@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ef317c90fbe1e..79e9593815f12 100644
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



