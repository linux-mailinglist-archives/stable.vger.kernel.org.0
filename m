Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042303F67B2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241674AbhHXRgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242098AbhHXReg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B15361BA0;
        Tue, 24 Aug 2021 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824799;
        bh=GJQUHHC19H3AosXMyk0tjcmBoizngaJClrlOplJcQn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGDq62YFWikylmZjOH4hf0XPcRuxVMiXG9CD4O22Inyv1GUR76mdzyO8OsvpsCLHW
         CH8x8PazeFlkq1xOEZJZ6KWI97o01cm3MyMnL1+ENlGtsQMLh082RbuDQS+qDVq/Eh
         CkaIaxMJS21qnbrI02vI+EEmNpyOfTXeGVK0Zhr3C/9Hozk73vu7VPsNmFFnEL0XTw
         3a2YSF8L2Pb6PsLXEaGCKmLc+iFnH/4bid11nGkFX/8mNyuq75piaOP+u86i+/aPeq
         sxfeG7zAWUd8tK8Lhrea50duaVYhRLJ6E8Y9G8TXOPDXMJnyKnxuK8BR3zC2Ai672N
         Nx5regu0TpusQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/43] dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()
Date:   Tue, 24 Aug 2021 13:05:54 -0400
Message-Id: <20210824170614.710813-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 1da569fa7ec8cb0591c74aa3050d4ea1397778b4 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by moving the error_pm label above the pm_runtime_put() in
the error path.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20210706124521.1371901-1-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/usb-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sh/usb-dmac.c b/drivers/dma/sh/usb-dmac.c
index 6682b3eec2b6..ec15ded640f6 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -861,8 +861,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
 error:
 	of_dma_controller_free(pdev->dev.of_node);
-	pm_runtime_put(&pdev->dev);
 error_pm:
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
-- 
2.30.2

