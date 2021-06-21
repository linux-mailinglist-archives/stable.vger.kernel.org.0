Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC43AF35D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhFUSAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhFUR6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B396E61289;
        Mon, 21 Jun 2021 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298042;
        bh=C3zD+YGqJM3yC94ihyfLYGL7l36I0vVTfiurb62Ssqg=;
        h=From:To:Cc:Subject:Date:From;
        b=CHLCiODYBeDHfwVzJl4b+yccK19tei2kxIpUSEZ8LxpoDQUgDeyqHqItvVhIe4gQp
         7C0czEwWuT8ZD06WBl779r+raI4u7R7Px5bPwcx/dz6xNW82v6DghIoF82ii+EdpEC
         FAqd92oLtL1Md4lwon8hjvv9dS2wlngDfh2TfZNoT8gobcq3RSKHs1rJc6li79OB0O
         ERDKQmI3+Mcc9ye3Tu+1PbLAJ498fMFyEd4vFZtXlqBklAoHuponj4LWIT9UWovInn
         c1H2tPl0I65CI6+l4rNuZgg+XTePnwCFfiOFHR2ocTCfrpnRrdOtl1mBJuwhPMLsXu
         24m108hmBoSqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 01/26] dmaengine: zynqmp_dma: Fix PM reference leak in zynqmp_dma_alloc_chan_resourc()
Date:   Mon, 21 Jun 2021 13:53:34 -0400
Message-Id: <20210621175400.735800-1-sashal@kernel.org>
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

