Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5563AF251
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhFURyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhFURyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96057611C1;
        Mon, 21 Jun 2021 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297921;
        bh=ZCmDtZGyev1DPK9fMMl/6QEJ8lFloqU84FuLk3rUJ5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPGsyvT80vfesRfDNXfj1QDP7omkjYQMZoWxiRzIFYZKFqmDIPaNefRdG3DrQFGlH
         yCIa+eJc6UBVTbUNll7VLduZd6lvMEs0mzIBxrHHBCY6wOJYf3EC4er2wNUpETmOO5
         9TRflyfv9Aj4du9pOYnJiOOXU85uOCKZ3kmytW3QDKocgtF/P692kg2JeCQgESxy+G
         wIcEMHsGmFBo2zwwAnlsHTMY8ykpwaGiMIdgAWpn398duhhpEdFeBuM9rlR60iEYoR
         b3DFKybKHTCAdfDjfGB1JrO8kTzzO/PbOwIYvUz/QKbol59QP3vNfOT80KdmktFqf4
         Aj1wTK97y789g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 02/39] dmaengine: stm32-mdma: fix PM reference leak in stm32_mdma_alloc_chan_resourc()
Date:   Mon, 21 Jun 2021 13:51:18 -0400
Message-Id: <20210621175156.735062-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
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

