Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCCE227148
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgGTVm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbgGTVi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C70B822D00;
        Mon, 20 Jul 2020 21:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281137;
        bh=iEtFf7QMN19S5dmrOUJonugb+EIs3TYktwEmUKejVvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtHsqAs2U6ZJViVGhfZlos2Y967Mm0++q5seUJHJELvPkLDsaSo6WKMl57jBmzJc1
         IB2fXqz0rwgRPcCnwtrdcFsaDSjuJEIEjob62K9ogN+6G2jPPX+eXV+l/uBFPtxenq
         iV4WiBBAKZr7s72r9/7cQNMSQaoG2TQIjqruRv+4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/19] dmaengine: tegra210-adma: Fix runtime PM imbalance on error
Date:   Mon, 20 Jul 2020 17:38:36 -0400
Message-Id: <20200720213851.407715-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213851.407715-1-sashal@kernel.org>
References: <20200720213851.407715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 5b78fac4b1ba731cf4177fdbc1e3a4661521bcd0 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20200624064626.19855-1-dinghao.liu@zju.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra210-adma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index 045351f3549c1..86b45198fb962 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -583,6 +583,7 @@ static int tegra_adma_alloc_chan_resources(struct dma_chan *dc)
 
 	ret = pm_runtime_get_sync(tdc2dev(tdc));
 	if (ret < 0) {
+		pm_runtime_put_noidle(tdc2dev(tdc));
 		free_irq(tdc->irq, tdc);
 		return ret;
 	}
@@ -764,8 +765,10 @@ static int tegra_adma_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(&pdev->dev);
 		goto rpm_disable;
+	}
 
 	ret = tegra_adma_init(tdma);
 	if (ret)
-- 
2.25.1

