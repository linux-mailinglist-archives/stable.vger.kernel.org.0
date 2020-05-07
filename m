Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D051C8EFF
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgEGO2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgEGO2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4EE20857;
        Thu,  7 May 2020 14:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861725;
        bh=1nnHsVdBrNbkfWBXxTVXXxkC6uk3Re/8JIIgBHmsfGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+zX5wk7RnmVI4g5Xzw0gIdEut6bI+kBz8V2XfBMXKoOFpRaGX2WfbdenEZA3FAGr
         m9TtDqE2seADSaEiNCpJlpwG3scMfAMIItqdYhom9liogymQHw98bLPlyB70v2Q4Kv
         pmwK+E7UuGCPHhM5zghVAALx/Lsqs+4nGrVcIVOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/35] dmaengine: pch_dma.c: Avoid data race between probe and irq handler
Date:   Thu,  7 May 2020 10:28:05 -0400
Message-Id: <20200507142830.26239-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
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
index 581e7a290d98e..a3b0b4c56a190 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -865,6 +865,7 @@ static int pch_dma_probe(struct pci_dev *pdev,
 	}
 
 	pci_set_master(pdev);
+	pd->dma.dev = &pdev->dev;
 
 	err = request_irq(pdev->irq, pd_irq, IRQF_SHARED, DRV_NAME, pd);
 	if (err) {
@@ -880,7 +881,6 @@ static int pch_dma_probe(struct pci_dev *pdev,
 		goto err_free_irq;
 	}
 
-	pd->dma.dev = &pdev->dev;
 
 	INIT_LIST_HEAD(&pd->dma.channels);
 
-- 
2.20.1

