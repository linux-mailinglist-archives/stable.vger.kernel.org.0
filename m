Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E4522F114
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732049AbgG0OXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732038AbgG0OXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:23:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25F452083E;
        Mon, 27 Jul 2020 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859795;
        bh=eejwkf5aLP13LBU3eN1eFu50Bc9f75o89K27gI+G6Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQzl56gWRLvt8bpkJoh6DxlIup6FWbdfCDrAi8YyRmE6aCJkIZB+EtgtaQlCNGcuR
         XYKVkXd0oKy+pPcUPasZXBsKIfnd6d30QiYpyiIRfDnQ2UMVDLL/+07hF7t47l7XQG
         RIz+RjBjEoMCoWMjVgQow2Bj8yZkc/RgtvlBNFU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 108/179] dmaengine: tegra210-adma: Fix runtime PM imbalance on error
Date:   Mon, 27 Jul 2020 16:04:43 +0200
Message-Id: <20200727134937.912112497@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index db58d7e4f9fec..c5fa2ef74abc7 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -658,6 +658,7 @@ static int tegra_adma_alloc_chan_resources(struct dma_chan *dc)
 
 	ret = pm_runtime_get_sync(tdc2dev(tdc));
 	if (ret < 0) {
+		pm_runtime_put_noidle(tdc2dev(tdc));
 		free_irq(tdc->irq, tdc);
 		return ret;
 	}
@@ -869,8 +870,10 @@ static int tegra_adma_probe(struct platform_device *pdev)
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



