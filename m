Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D8537D23D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbhELSHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352018AbhELSCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F39FF61421;
        Wed, 12 May 2021 18:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842469;
        bh=gRKsVhSCPTfSxlwv8gu5v/+2IY0c3SXd+j+s4H623ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DixhcXwEJSy3eh/WTmJuCSTE25X2ZMIgNc1BlLwcVVzA61WkrXUnthPZVPCPl86XP
         kJ7r2JlI6a2ighy0C8vsgY2yHygSm7rQvLHgtauYWSaT+gUe76d1eVEYv3CbEjZImQ
         Qi0DOKsNBCrMeObmuzE3WfrlWKyhgDGuTurMkJBcLfVn/S6JcllNIAeaa7bXba3QG2
         wY42+wtQGVNHCt7/qXdfl7Z9619r9GvIZ1KniI7F1em6I24jOb74FjKuBregbgVm+n
         84z827kIkfr0gscPTnBYS/p3V8JvaUXxKsX9O520Wd/yZUukIKCnBcjtKjrVl0ea0a
         UyiDIojwBNMQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 03/37] dmaengine: dw-edma: Fix crash on loading/unloading driver
Date:   Wed, 12 May 2021 14:00:30 -0400
Message-Id: <20210512180104.664121-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
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
index 08d71dafa001..58c8cc8fe0e1 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -937,22 +937,21 @@ int dw_edma_remove(struct dw_edma_chip *chip)
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

