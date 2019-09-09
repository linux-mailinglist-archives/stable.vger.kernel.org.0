Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFADAE0C6
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392275AbfIIWRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392262AbfIIWRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:17:20 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5F1222C4;
        Mon,  9 Sep 2019 22:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067439;
        bh=8Ay5QZRIfx6Enn7YintV43y+fPovqavXMA0bfouCU1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJGAS4PMi4E2Yjng1XGqxZH/WaIKdk+ONsId/WHQs8vfYwut6iCN72TqHMBphboDN
         wo9ytmIBv35rMOblvB2h9kHRfOpO7YsrswlxON0WxLUw/y3BQYNXBsbhprJ+nzumL2
         obPz8m7HgIFJRlAIPKvQX1Fb/yGVaEdWOrocxmu8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/6] dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()
Date:   Mon,  9 Sep 2019 11:42:01 -0400
Message-Id: <20190909154205.31376-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154205.31376-1-sashal@kernel.org>
References: <20190909154205.31376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 962411b05a6d3342aa649e39cda1704c1fc042c6 ]

If devm_request_irq() fails to disable all interrupts, no cleanup is
performed before retuning the error. To fix this issue, invoke
omap_dma_free() to do the cleanup.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/1565938570-7528-1-git-send-email-wenwen@cs.uga.edu
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/omap-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 6b16ce390dce1..9f901f16bddcd 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1429,8 +1429,10 @@ static int omap_dma_probe(struct platform_device *pdev)
 
 		rc = devm_request_irq(&pdev->dev, irq, omap_dma_irq,
 				      IRQF_SHARED, "omap-dma-engine", od);
-		if (rc)
+		if (rc) {
+			omap_dma_free(od);
 			return rc;
+		}
 	}
 
 	if (omap_dma_glbl_read(od, CAPS_0) & CAPS_0_SUPPORT_LL123)
-- 
2.20.1

