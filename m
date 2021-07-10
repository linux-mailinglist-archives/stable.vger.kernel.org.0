Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCB73C2CBD
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhGJCUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhGJCUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46430613C7;
        Sat, 10 Jul 2021 02:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883474;
        bh=79/HYkvwxCe55o5MFGHNpPyyxL7jdePrtaRs3K2/aC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOAUGs+A/2a+qPEmsK9O6wIi7XjLF5Q7bnG6nqG+AgSErxmcq7IOjBjaGUJJrW1lj
         tVop+r1s/avchqEfTRCx9fKKkmv+rHP9iv6Gza84nXoPVqXnyVecql+YjQc0ZHCGI3
         7PbPL+GQF83NLqrsJ7pe+zSZ6D0R/B6Am7EKO1ZEZmBbQul0ZF8hRCq5W19nFlmly1
         vxY0InIKi+oUDjDCfzcAHPice6utMffdVh4Ap3LQAaddaSnLgjk612zUhFxKNebMnv
         ZJfxihgGajtlwSsw4Tjsy9FdEvFEjzOF6vIIpWv53g1IapBlYc7ZWk1qydBgX0PTmR
         f5jDe/AhKv/+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 004/114] dmaengine: fsl-qdma: check dma_set_mask return value
Date:   Fri,  9 Jul 2021 22:15:58 -0400
Message-Id: <20210710021748.3167666-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

