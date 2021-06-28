Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55CE3B618E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhF1OgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhF1Oep (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2114661C8B;
        Mon, 28 Jun 2021 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890618;
        bh=C3zD+YGqJM3yC94ihyfLYGL7l36I0vVTfiurb62Ssqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkeeKBJHg7VcfX8uilntbIajlDVR/zXTH1SquWncHAWTylYjSpIOUU9t/KbAvPXdu
         j6u82tRAgVbXXjfnx1BUY/WWtlTH/GVi6y5N3IL82E+UjRpJ3CREEaoIaPy0JCWtpZ
         UfLU2J6gQrM8io7/EkTvdUnWh4GcFvsAoxjylO6MjGkg23Tc/t9SDaHYCKiXuKzlMq
         S3v6i0bW7eiacAjs739A9BxGEKEe4KC7VMqdgSyl5X7TlWeFF3u6tSzY4mTYWLPK35
         8rWv8GbvAeqPzY2RWzpL/TnuTrJiH+QCPAnQOxj4yk84wDg68oRd2ARlaTMJtBlSjs
         Vu5H1mO4M7W3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/71] dmaengine: zynqmp_dma: Fix PM reference leak in zynqmp_dma_alloc_chan_resourc()
Date:   Mon, 28 Jun 2021 10:29:06 -0400
Message-Id: <20210628143004.32596-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index d47749a35863..84009c5e0f33 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -467,7 +467,7 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 	struct zynqmp_dma_desc_sw *desc;
 	int i, ret;
 
-	ret = pm_runtime_get_sync(chan->dev);
+	ret = pm_runtime_resume_and_get(chan->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2

