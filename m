Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8191C8F44
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgEGOaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728815AbgEGOaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:30:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB3F520936;
        Thu,  7 May 2020 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861822;
        bh=21RvU87suyQJ5Bno2TZaPg+6cnc/R8INOsdBybhJ+a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRM0RLH3vH3Y5pmm7WpKQt8PkiRTXJJ9X5OyTIeW6xT90bHnsXudMbGxOtT5iF44r
         a7k4XbnemjG0mL+cXfMKT/nvZh1/q19+vbH+vTVje9eYS8q1+OqhnvJo4zvtpe6GL2
         FIxD4IDi11jM/uP9zt9EFf7ZDZZZ5CIurYd2dD14=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/9] dmaengine: pch_dma.c: Avoid data race between probe and irq handler
Date:   Thu,  7 May 2020 10:30:12 -0400
Message-Id: <20200507143018.27195-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507143018.27195-1-sashal@kernel.org>
References: <20200507143018.27195-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 2e45676a4d33af47259fa186ea039122ce263ba9 ]

pd->dma.dev is read in irq handler pd_irq().
However, it is set to pdev->dev after request_irq().
Therefore, set pd->dma.dev to pdev->dev before request_irq() to
avoid data race between pch_dma_probe() and pd_irq().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200416062335.29223-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pch_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 113605f6fe208..32517003e118e 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -877,6 +877,7 @@ static int pch_dma_probe(struct pci_dev *pdev,
 	}
 
 	pci_set_master(pdev);
+	pd->dma.dev = &pdev->dev;
 
 	err = request_irq(pdev->irq, pd_irq, IRQF_SHARED, DRV_NAME, pd);
 	if (err) {
@@ -892,7 +893,6 @@ static int pch_dma_probe(struct pci_dev *pdev,
 		goto err_free_irq;
 	}
 
-	pd->dma.dev = &pdev->dev;
 
 	INIT_LIST_HEAD(&pd->dma.channels);
 
-- 
2.20.1

