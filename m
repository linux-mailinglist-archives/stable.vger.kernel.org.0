Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994CC3B5FED
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhF1OV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232760AbhF1OVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B901F61C85;
        Mon, 28 Jun 2021 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889930;
        bh=ZCmDtZGyev1DPK9fMMl/6QEJ8lFloqU84FuLk3rUJ5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0qye0khah9oN9I4EZZwxDhW4wXyCdSZHtHqF83C0iR9OgL3C41SrCpSQxh/URMYk
         2s/JYd8dwKkeXE+bJGa8suc7xhPawcwk5H8RI+e+gUSOgUW6z0j/T3b7j942i3a/cO
         SZtPfWjjrKXhUOYZrIC8yH7EZlF17AYFQ80zaJa42suvhidA5JtDp4HT6k4ZB7A97G
         GSnpRYrP+XSK1qX1HZDiKoXv3WoCZHFUmJOL12QEEW71udNV9tR0yV90f0Obe2Fx/B
         lqQOqQeaoiTd6V+llaffmGYZ0FkCDwlpjEPxcd8enoCQp6PcfZ3ftDno7cW4Cyj6un
         70m2vazn6ZVdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 023/110] dmaengine: stm32-mdma: fix PM reference leak in stm32_mdma_alloc_chan_resourc()
Date:   Mon, 28 Jun 2021 10:17:01 -0400
Message-Id: <20210628141828.31757-24-sashal@kernel.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 83eb4868d325b86e18509d0874e911497667cb54 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20210517081826.1564698-2-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-mdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/stm32-mdma.c b/drivers/dma/stm32-mdma.c
index 36ba8b43e78d..18cbd1e43c2e 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1452,7 +1452,7 @@ static int stm32_mdma_alloc_chan_resources(struct dma_chan *c)
 		return -ENOMEM;
 	}
 
-	ret = pm_runtime_get_sync(dmadev->ddev.dev);
+	ret = pm_runtime_resume_and_get(dmadev->ddev.dev);
 	if (ret < 0)
 		return ret;
 
@@ -1718,7 +1718,7 @@ static int stm32_mdma_pm_suspend(struct device *dev)
 	u32 ccr, id;
 	int ret;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

