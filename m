Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BB53AF2CE
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhFUR4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232427AbhFURzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40598611BD;
        Mon, 21 Jun 2021 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297983;
        bh=32WYo5ihIgTpcTEKbKB73QoebLnYJZOaD0OgAOWFUOY=;
        h=From:To:Cc:Subject:Date:From;
        b=gimRHTttXlt/aK43WHDtHRkd80MENElLjQcEH3Ad0yH0aYBhmHHr3jIhgptqBUj/o
         jHeCMjjdrT/Lz5gE0o7OCRo7l0/e8U2J6BL0UJtirJxz+pROEbEu6KsOrBp0WkAbno
         dAiJf9Zd2ayJjQIFdeAjlJ6DHyloY6zhyNPRLKrrK67hwTzY+/buykIVAr8wjZgPtP
         /2x9BdUQSI/qlvl//UaeekZde4LH7NXNoipoq04mqa6NDb7UjKMdyt8vTpjd21X9mp
         qlrqxnoeE1pDFokpCnEXkoNbQD9j24Wp4UeSzwIGT+tFhl8uFmuGr6qY/O5cwgvHhl
         UjFJdiSlZupsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 01/35] dmaengine: zynqmp_dma: Fix PM reference leak in zynqmp_dma_alloc_chan_resourc()
Date:   Mon, 21 Jun 2021 13:52:26 -0400
Message-Id: <20210621175300.735437-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
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

