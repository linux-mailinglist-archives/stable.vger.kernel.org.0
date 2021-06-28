Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BD63B6111
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhF1Obr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234581AbhF1OaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5266961C9C;
        Mon, 28 Jun 2021 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890388;
        bh=32WYo5ihIgTpcTEKbKB73QoebLnYJZOaD0OgAOWFUOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qi4wL8YKqPkIeyAYtWDYpDztKsjyruXDh/NJpwBcZh4K2MmJvoYBv6Jo4/Uup+QE3
         5cILTKlRzfanu6Of3ZIWwKPENMSu4XS9wMqSmRyl20DlmO2TuwQTb0en7pYtksw0Vr
         jBc1fblXqkk54KtELGZtMILhRqFhdOZXW+hpDtPmeHB6dcgTiH2fee9FTa5gJsH/GB
         HzVO6V5VJEtkgmt3IrFGDU0euvCMXdKWkYwBlCRhNaaAMPDBysmNBf6BB2+akvlYcS
         96O7BmrXMQRixEK5UUmjN/Gh86JLaKUQ5SJkKB3g/dZEVw88Z7wQdslRZDgoNdfaXu
         EVPhZZhPx2UtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/101] dmaengine: zynqmp_dma: Fix PM reference leak in zynqmp_dma_alloc_chan_resourc()
Date:   Mon, 28 Jun 2021 10:24:48 -0400
Message-Id: <20210628142607.32218-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 8982d48af36d2562c0f904736b0fc80efc9f2532 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20210517081826.1564698-4-yukuai3@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index d8419565b92c..5fecf5aa6e85 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -468,7 +468,7 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 	struct zynqmp_dma_desc_sw *desc;
 	int i, ret;
 
-	ret = pm_runtime_get_sync(chan->dev);
+	ret = pm_runtime_resume_and_get(chan->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

