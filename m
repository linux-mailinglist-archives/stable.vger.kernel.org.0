Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41DE3AF2EB
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhFUR6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231736AbhFUR4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69DD361353;
        Mon, 21 Jun 2021 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297993;
        bh=CtLT/lzwUI8ebT8vGhX4RAeNFaQvGQpIJCVCOAIQ0WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6iO8rv0W1UFeuWNWeYr+7K7mNEiT4eh9gHZZsy3ZNlIICZGDjWIAdYbtjCD/I7Lr
         rR354lq1uQtkPbIAPd1Ypho/lf3xEf3CEMS4dErVjoFQrtdEtCSeP5c/nC4ZQdrAju
         6zSrDHZg0lvP7yZChGdpc9YgyHL+S8TZJl1hf5HFoniEK4Cg/adN7HQqiqXTNZJavh
         CLQVKOZNBePXHKtC0ROTVsp22iJ0aIOQxyNftatxOFu0FqLi7kKH2OgttKUeIKia08
         fqoIoFxjvN/fRD2vurnUA8xevDx8LGyP91tKDKli98DL+3GNIsWj4tcSkCF7n94xLZ
         DvAQCXf5BYVAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/35] dmaengine: rcar-dmac: Fix PM reference leak in rcar_dmac_probe()
Date:   Mon, 21 Jun 2021 13:52:33 -0400
Message-Id: <20210621175300.735437-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
MIME-Version: 1.0
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
index a57705356e8b..991a7b5da29f 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1874,7 +1874,7 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 
 	/* Enable runtime PM and initialize the device. */
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "runtime PM get sync failed (%d)\n", ret);
 		return ret;
-- 
2.30.2

