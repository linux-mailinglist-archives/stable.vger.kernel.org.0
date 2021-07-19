Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A8C3CE058
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345991AbhGSPQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345303AbhGSPM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:12:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD9F61375;
        Mon, 19 Jul 2021 15:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709980;
        bh=79/HYkvwxCe55o5MFGHNpPyyxL7jdePrtaRs3K2/aC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLfTzoo7zrlh6Z1wiAf1Da7flLMjLZhaoxLYL7f56dUffHsNy4ocJADEOLFgfQgAl
         xIzHCWaVPE77G/INE6ppyBSa4kIxeft4W4LUvN7UF/ZY8wuFOl4DFBxHV1XSA5u1dd
         eH4opZ76vota0me6z6KfYnSSi1r2xr9+Zt7ko3GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/243] dmaengine: fsl-qdma: check dma_set_mask return value
Date:   Mon, 19 Jul 2021 16:50:54 +0200
Message-Id: <20210719144941.740694921@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

[ Upstream commit f0c07993af0acf5545d5c1445798846565f4f147 ]

For fix below warning reported by static code analysis tool like Coverity
from Synopsys:

Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Addresses-Coverity-ID: 12285639 ("Unchecked return value")
Link: https://lore.kernel.org/r/1619427549-20498-1-git-send-email-yibin.gong@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-qdma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index ed2ab46b15e7..045ead46ec8f 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -1235,7 +1235,11 @@ static int fsl_qdma_probe(struct platform_device *pdev)
 	fsl_qdma->dma_dev.device_synchronize = fsl_qdma_synchronize;
 	fsl_qdma->dma_dev.device_terminate_all = fsl_qdma_terminate_all;
 
-	dma_set_mask(&pdev->dev, DMA_BIT_MASK(40));
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(40));
+	if (ret) {
+		dev_err(&pdev->dev, "dma_set_mask failure.\n");
+		return ret;
+	}
 
 	platform_set_drvdata(pdev, fsl_qdma);
 
-- 
2.30.2



