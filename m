Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A4237D2BB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhELSNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352978AbhELSGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:06:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 991306143E;
        Wed, 12 May 2021 18:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842654;
        bh=7Ch6g9m0pDQtJfE1thoMDqdVhwlP7VdPts0zlyKQIf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pE2xPnpSUTRymcHd0CTbIUo/+gnW0NlbuDoKmiCPezsHbKo3QuIr4JUqH5oV2YnAA
         W3goKZwLmzVQENFO8DT7TxrudSwYlhI1lDYY/Ixxzme6rMIJTmlsA8mQDA5KozLfxU
         9dqmGlt4qp7bUy7Ez+7rsbZbENyh93Yr7TKZhp0gbqpRYz1UQUV07u34xf4/x4f/Sp
         Oc2/CZjaR5fk9Y6J3j3RyIQFxta212UsqUCIQ5hnZbv7ko4ukQZL/F6U+WhMiwR4Uq
         RUc3Bn6pssWmkiCsoN96H9hAMxEdMnY0ea7mVNMkV3sjmzTFyyJlKS+VmIg5c7V4Wt
         WcdG3LjemkN7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/23] dmaengine: dw-edma: Fix crash on loading/unloading driver
Date:   Wed, 12 May 2021 14:03:47 -0400
Message-Id: <20210512180408.665338-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180408.665338-1-sashal@kernel.org>
References: <20210512180408.665338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>

[ Upstream commit e970dcc4bd8e0a1376e794fc81d41d0fc98262dd ]

When the driver is compiled as a module and loaded if we try to unload
it, the Kernel shows a crash log. This Kernel crash is due to the
dma_async_device_unregister() call done after deleting the channels,
this patch fixes this issue.

Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
Link: https://lore.kernel.org/r/4aa850c035cf7ee488f1d3fb6dee0e37be0dce0a.1613674948.git.gustavo.pimentel@synopsys.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 31577316f80b..afbd1a459019 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -910,22 +910,21 @@ int dw_edma_remove(struct dw_edma_chip *chip)
 	/* Power management */
 	pm_runtime_disable(dev);
 
+	/* Deregister eDMA device */
+	dma_async_device_unregister(&dw->wr_edma);
 	list_for_each_entry_safe(chan, _chan, &dw->wr_edma.channels,
 				 vc.chan.device_node) {
-		list_del(&chan->vc.chan.device_node);
 		tasklet_kill(&chan->vc.task);
+		list_del(&chan->vc.chan.device_node);
 	}
 
+	dma_async_device_unregister(&dw->rd_edma);
 	list_for_each_entry_safe(chan, _chan, &dw->rd_edma.channels,
 				 vc.chan.device_node) {
-		list_del(&chan->vc.chan.device_node);
 		tasklet_kill(&chan->vc.task);
+		list_del(&chan->vc.chan.device_node);
 	}
 
-	/* Deregister eDMA device */
-	dma_async_device_unregister(&dw->wr_edma);
-	dma_async_device_unregister(&dw->rd_edma);
-
 	/* Turn debugfs off */
 	dw_edma_v0_core_debugfs_off();
 
-- 
2.30.2

