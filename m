Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE343B5FF7
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhF1OVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhF1OVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA07761C7E;
        Mon, 28 Jun 2021 14:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889935;
        bh=7FejGutx7qigxlPOnRTPF0t+VREiWTptDfU4R0WFxNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrEzjtFmHMbIZBxwLw4h4s/jsbOEHDzUg9K8+zYRyRPnGIgCTTa1MTsgnNT1i7Akc
         LEUwEUWVDQs5TiroW8esp2u8KB5rJ+xcoYvDZivd49qNKx99Rca7F5XGzXHCXIF+0W
         sGuUHcalTar2UsDgugMIRpLRbjzQNKIHCNAc7/FmIRfbG0qBELiN8Jm42FvoOJUntc
         Lx34WVB3YRF4ZKFGYco4kqa6g6RrSU2YupymMEmUYttZ0E7Agy07L7s+uAH5V9DBzN
         2BUgCUnMthjhdKHjIikns1K5VCVcOI39TIpGTvDoizyO4jwcZJnuEh95mBjR26bg1k
         /86UfIWIF4qBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 029/110] dmaengine: idxd: Fix missing error code in idxd_cdev_open()
Date:   Mon, 28 Jun 2021 10:17:07 -0400
Message-Id: <20210628141828.31757-30-sashal@kernel.org>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 99b18e88a1cf737ae924123d63b46d9a3d17b1af ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc'.

Eliminate the follow smatch warning:

drivers/dma/idxd/cdev.c:113 idxd_cdev_open() warn: missing error code
'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/1622628446-87909-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 1d8a3876b745..5ba8e8bc609f 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -110,6 +110,7 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 		pasid = iommu_sva_get_pasid(sva);
 		if (pasid == IOMMU_PASID_INVALID) {
 			iommu_sva_unbind_device(sva);
+			rc = -EINVAL;
 			goto failed;
 		}
 
-- 
2.30.2

