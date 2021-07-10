Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C28E3C2F86
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhGJCbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233220AbhGJC3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FDD9613AF;
        Sat, 10 Jul 2021 02:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884031;
        bh=kWGsgISN7lcqmtjugESr6/bNe397iyJKqWDj4dYdleo=;
        h=From:To:Cc:Subject:Date:From;
        b=DYYaE+JKxKXkKQUqa1We+8NxiyK5YJXR3/itVAxV4I1s1WxeBDiOqaase8M6lcz9C
         r9dji0YCuzcck+UWF65VfwA0aFN9Zato34lcEjeoydOvTmB8PPUt0XHJ79s0xvhYia
         hGR1Gp0V/QEEIjCWGczHJaxvytLHCM45OlABsRRJ/XUjIGNNsZYvXyxCrmKVfV4dqv
         sEdEJLjmxbgNEdsLa2AAxijxD3o88J1AZNQ/xf4Ti51R1OTcs4jl6t+pyQyMqRqEwQ
         NdphRfuTzB74xun5N0H04QDkyXt8BFkOl2Kc61bEbW42gfBJ6BlCv0GYVXoHFq1r4t
         3/tR0llo7DadQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/63] dmaengine: fsl-qdma: check dma_set_mask return value
Date:   Fri,  9 Jul 2021 22:26:07 -0400
Message-Id: <20210710022709.3170675-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 95cc0256b387..f5a1ae164193 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -1184,7 +1184,11 @@ static int fsl_qdma_probe(struct platform_device *pdev)
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

