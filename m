Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989283B5FF8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhF1OVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232889AbhF1OVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B02FF61C7F;
        Mon, 28 Jun 2021 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889936;
        bh=ky/LzMqmuKZBKITCQNeQdJdeaFLX/RLjJ8oc2YMNYzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXY1BiUumUDVxSfkrFtaBNA29mOaSdPxLYyZRDxzZeVaJxNM6eWHMLhtghrGl2BJt
         8vcuzrqQD18YS+xkgapI4sPrQGTe2lA2jjdYeeNUJZq17i0hpBDnEizKQU5FdEolx+
         8lfXfPBdhXZmkrVKNfszPQYcxCzAc5kdPB2mODdadLZas1lBRtKe96uLHlunHWE4qG
         TFtd2Qy3+j5DQSWKxgqYz1i7prRa27n+A3ixnMWRPH8SE9iiHsoBwK+xP6GvR5COqy
         qco5G7ijS/Taajyikw0DNhDVSXfCVFh/d9LoVL1d/71+Z9WGR117qR62GTCgbHHk1g
         wp30En0+zXp7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 030/110] dmaengine: rcar-dmac: Fix PM reference leak in rcar_dmac_probe()
Date:   Mon, 28 Jun 2021 10:17:08 -0400
Message-Id: <20210628141828.31757-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index d530c1bf11d9..6885b3dcd7a9 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1913,7 +1913,7 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 
 	/* Enable runtime PM and initialize the device. */
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "runtime PM get sync failed (%d)\n", ret);
 		return ret;
-- 
2.30.2

