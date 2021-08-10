Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07173E5D7D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbhHJOUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242670AbhHJOSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A04E60F02;
        Tue, 10 Aug 2021 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605003;
        bh=06702bpAaA2YITqoGY2oprCfqPNOskafyZbNdqoZNTE=;
        h=From:To:Cc:Subject:Date:From;
        b=hVzG6jM7/T/MGj3k8nQXAR+bIyTVNS6OSeWXEQyxnGeRddkKLdyf9D5roIyhFAU56
         HOBXGeny90bOgM3ATiFM99kXj+fQaLcleyyYgl2/HzvwaOmbAbCpmbwCDJxtgSp/PA
         RniyPS1h2PE7yL9H2dgfzDD1vBq7e1O1EzFxTw2+0sIk9oGb5wEjI+fblQWf9lt0JL
         AcO4DSlmzIFb8EoCDiuj5fsR2o+4iPsbxb9ApxP70YYWettoF2J4R9qTVGxoX3Kc9A
         KV5S0hO+cyQ79hsEg1ZRRasmX2T4zx6lih7q99od+Gyea5F6HYgGMobMCw+vdT758n
         Q4589N74p3jEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/10] dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()
Date:   Tue, 10 Aug 2021 10:16:32 -0400
Message-Id: <20210810141641.3118360-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
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
index 31a145154e9f..744fab9da918 100644
--- a/drivers/dma/sh/usb-dmac.c
+++ b/drivers/dma/sh/usb-dmac.c
@@ -858,8 +858,8 @@ static int usb_dmac_probe(struct platform_device *pdev)
 
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

