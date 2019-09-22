Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A8BBA657
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392502AbfIVStk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:49:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389691AbfIVStk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEC9F2196E;
        Sun, 22 Sep 2019 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178179;
        bh=FY/EUlQS4N2s2co7PlcvNhQsYjeZ7cSqWMW3E4pyJ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l699dCS6S4tzrYcQu3pXFTaeVxnMfitoRQ5SZ/wTCDHjQ3CzEw9TpHaa+qTzZitE/
         cwSJk2Pa1UTHeEZaVdf6Eonv4HlkDlFESc4JHshJMbrO8rwUchBJTa1PmIhzgSQ1Ou
         vX1WCAvBRd4Y35J81G5EAF0WfyO4VS0yDObXyIrU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <wahrenst@gmx.net>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 010/185] dmaengine: bcm2835: Print error in case setting DMA mask fails
Date:   Sun, 22 Sep 2019 14:46:28 -0400
Message-Id: <20190922184924.32534-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 72503b25ee363827aafffc3e8d872e6a92a7e422 ]

During enabling of the RPi 4, we found out that the driver doesn't provide
a helpful error message in case setting DMA mask fails. So add one.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/1563297318-4900-1-git-send-email-wahrenst@gmx.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/bcm2835-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 8101ff2f05c1c..970f654611bdd 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -871,8 +871,10 @@ static int bcm2835_dma_probe(struct platform_device *pdev)
 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
 
 	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-	if (rc)
+	if (rc) {
+		dev_err(&pdev->dev, "Unable to set DMA mask\n");
 		return rc;
+	}
 
 	od = devm_kzalloc(&pdev->dev, sizeof(*od), GFP_KERNEL);
 	if (!od)
-- 
2.20.1

