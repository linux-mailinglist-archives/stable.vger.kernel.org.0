Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8423F6388
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhHXQ5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233631AbhHXQ5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E68E96138B;
        Tue, 24 Aug 2021 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824175;
        bh=iWvU1n7Xu0JlgJ0bdwl8Mf+K9kye/OKxXwSbIDFd6S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmpjUb9A02zwJ2kHmmJPu/0YlEm6+jQj5dMKgkVQPt4vUGueY8tMbGCYh4nsM+R+r
         GlKLo3jAdfQSdvBUWB/uH+XZTOnX0H1bJnvf6ZAIgd0fMRMTUCA7a6JzGEsXuDwxXC
         mBT2gasClerwY2N6xMvUe9Jlxta9LZWh0RUhREARwVYSRTcIzvulk0V3cZq+ZaKS0L
         bTha0e8MTYeCKUWKvw0FwLXaQCgFy2Zu92nixJ63FeDFhKkSXwE7T1Tm7+fjYPU0yQ
         lIoEWeZ+jT3rkeBUGCYPFWXdl0DccNNbFmguhMTtdxxwc4INJ+JNxeG3ajGMFHPbPx
         tBorUr/Pton/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 006/127] dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()
Date:   Tue, 24 Aug 2021 12:54:06 -0400
Message-Id: <20210824165607.709387-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index 8f7ceb698226..1cc06900153e 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -855,8 +855,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
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

