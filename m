Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55CF3B6440
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhF1PGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235733AbhF1PEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F43561CE6;
        Mon, 28 Jun 2021 14:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891390;
        bh=I1U75O5S3mjo5u3OwmNXu9uVwORj9PVFSWJjhAmQZuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5PsU8C+G9aOLeC0zxzsg9opz6c24x/gnfq+IdQOlXM4S9auDFoEvXw3CanHRX8YN
         njmGjncopmv5oft8OOH0Dsc2Q6UanP5xtk4mTFwnasjKDbPn6lPV1HSOzNJoUvjw2T
         1DQrk4pf5P0bPHtf0TmSvD3k3lzpO9XQp4JWfAT/BOxXFcRlWUFZOLXaGpa3+X5mgx
         PLJk2Mu57VtX0F55dR67yrSenh+BLX/pg4sSV6pQqj4DkYI/3GPy9zvwEHGseIM2BJ
         jkPKz+wgY3mmgh+6gFqNXMxT7f39CExbisZwPWOFCvoM8gefyYOCvcRUrfviPcwrw+
         QhL9rzHUFc0Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/57] dmaengine: stedma40: add missing iounmap() on error in d40_probe()
Date:   Mon, 28 Jun 2021 10:42:13 -0400
Message-Id: <20210628144256.34524-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fffdaba402cea79b8d219355487d342ec23f91c6 ]

Add the missing iounmap() before return from d40_probe()
in the error handling case.

Fixes: 8d318a50b3d7 ("DMAENGINE: Support for ST-Ericssons DMA40 block v3")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210518141108.1324127-1-yangyingliang@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0fede051f4e1..e6d3ed1de374 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3715,6 +3715,9 @@ failure:
 
 		kfree(base->lcla_pool.base_unaligned);
 
+		if (base->lcpa_base)
+			iounmap(base->lcpa_base);
+
 		if (base->phy_lcpa)
 			release_mem_region(base->phy_lcpa,
 					   base->lcpa_size);
-- 
2.30.2

