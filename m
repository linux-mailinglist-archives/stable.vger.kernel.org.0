Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8723F681E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbhHXRkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241938AbhHXRiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AE2F61BB1;
        Tue, 24 Aug 2021 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824880;
        bh=bXXPPSl3UEzk1Aov3GYXRmLxrCKsx+1rwjgrEp9BZgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KweS5wP7cfDC2pzDw0O4dHf1Q22LZz7XKWGnFCjf/872+VuV05WUNP+o7L/m7h+iG
         K9Rn6XTV+kZAwBFraq3wrb/GVK/Szbr/cYCIr8AoEnCxNL75Lp9umr+zx120WSpilG
         nJilme8Q3aY5kZY3YbavfkT1HrdNjEjsLYMWuzbT87pDesxc6LjsDFll7iKphCGg+U
         Ajw84sQGxNo48r/DcNBS/pskyOoMYzjiZp0Ly4AIYyMKwl7hbe7p7fllVywzXsjAgz
         rJwogV+qkgfcoQdLpTfdoa48KdToHlxAgjNMYMtr407CbeWkZEL/J8UfsN+CoxlpFi
         7HBorG2lk874Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 16/31] dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()
Date:   Tue, 24 Aug 2021 13:07:28 -0400
Message-Id: <20210824170743.710957-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index cc8fc601ed47..416057d9f0b6 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -863,8 +863,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
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

