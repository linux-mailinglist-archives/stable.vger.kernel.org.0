Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B49B3B6191
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhF1Ogb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235195AbhF1OfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F883619BE;
        Mon, 28 Jun 2021 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890622;
        bh=EnmzwoTGJS54IOhfktyp5oe1qbC3Ies/VbAzdAFFc0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uM4PDIBE1CmaQu0Wh3RFS5dYjW3hGzkE+8y975LdHbajGyLko4O4fL8hyYAlsHsr8
         S0uSM483/Dq+MIc6Nzd1DbWseNjZTpnBY4A4lF8AoxEArQe5faI50Fka00AWiYOCz5
         dCwW5xhG5bcvW1UmL5ENW1yxEh83TWnvNt0nUkMpo0q59N/vJuhT3fCmq1KbkcrAc8
         sq2W7E8lGt4hINwTqocOOaslHPUmBH5G3QpqM7c7gx7wtPvSGYY3qV/p/1RgQvB1je
         cppsdyUj4zgmXewP2DIiX9orLO/iN0UU/rktRW/kv68C6gyw58xrSdDWjuf7TmZ6xY
         JmchpBUkzX5Nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/71] dmaengine: rcar-dmac: Fix PM reference leak in rcar_dmac_probe()
Date:   Mon, 28 Jun 2021 10:29:10 -0400
Message-Id: <20210628143004.32596-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit dea8464ddf553803382efb753b6727dbf3931d06 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/1622442963-54095-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/rcar-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 3993ab65c62c..89eb9ea25814 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1855,7 +1855,7 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 
 	/* Enable runtime PM and initialize the device. */
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "runtime PM get sync failed (%d)\n", ret);
 		return ret;
-- 
2.30.2

