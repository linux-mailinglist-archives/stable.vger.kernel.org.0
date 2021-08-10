Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4BC3E8121
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbhHJRzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236998AbhHJRyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746B961371;
        Tue, 10 Aug 2021 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617448;
        bh=76zOx8RR5kNg3eS8gh3KAjbFpnzDu9itDLeMLvoYuqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ysgc7HRKPXBe1uzOVJ0fdIldjMUXJjc98ReahtVaU7f7+8u/CNb8tPPhF1/q/ONm3
         cVKSx6RQjmOVBdgGViVD6Z6pnOfxLF2gkHbLvjiYyq+BO2UEpZP80MYaJkxL0sbfhH
         Hgj79gnzn438JfMwK+jrDtqnmLZ1R8jbDf2WM2tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 030/175] dmaengine: stm32-dmamux: Fix PM usage counter unbalance in stm32 dmamux ops
Date:   Tue, 10 Aug 2021 19:28:58 +0200
Message-Id: <20210810173001.948045507@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit baa16371c9525f24d508508e4d296c031e1de29c ]

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: 4f3ceca254e0f ("dmaengine: stm32-dmamux: Add PM Runtime support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20210607064640.121394-3-zhangqilong3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-dmamux.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/stm32-dmamux.c b/drivers/dma/stm32-dmamux.c
index ef0d0555103d..a42164389ebc 100644
--- a/drivers/dma/stm32-dmamux.c
+++ b/drivers/dma/stm32-dmamux.c
@@ -137,7 +137,7 @@ static void *stm32_dmamux_route_allocate(struct of_phandle_args *dma_spec,
 
 	/* Set dma request */
 	spin_lock_irqsave(&dmamux->lock, flags);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&dmamux->lock, flags);
 		goto error;
@@ -336,7 +336,7 @@ static int stm32_dmamux_suspend(struct device *dev)
 	struct stm32_dmamux_data *stm32_dmamux = platform_get_drvdata(pdev);
 	int i, ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
@@ -361,7 +361,7 @@ static int stm32_dmamux_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



