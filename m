Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F890FA633
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKMC1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbfKMBuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 622D3222CA;
        Wed, 13 Nov 2019 01:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609851;
        bh=iOCWkkQyNZ9HFAZK0cqFlOadkurC8YTumm+nF+4sP6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgCGl2tWDcxJ96EYTVJn/bPazGO/v2QBK27aEOibBrYvkTMcJw2Efj7TYMyof2JfL
         hdmi/1kSnd8dBzUZeanO7r2LIt3zs+Lp1sYwOgfwPRYY001yypZM6PDo8uCv51drT+
         9VyQRTOBk+GZfhaEbeEz447oZmYHyylU4J93Ti5Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 022/209] iommu/arm-smmu-v3: Fix unexpected CMD_SYNC timeout
Date:   Tue, 12 Nov 2019 20:47:18 -0500
Message-Id: <20191113015025.9685-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 0f02477d16980938a84aba8688a4e3a303306116 ]

The condition break condition of:

	(int)(VAL - sync_idx) >= 0

in the __arm_smmu_sync_poll_msi() polling loop requires that sync_idx
must be increased monotonically according to the sequence of the CMDs in
the cmdq.

However, since the msidata is populated using atomic_inc_return_relaxed()
before taking the command-queue spinlock, then the following scenario
can occur:

CPU0			CPU1
msidata=0
			msidata=1
			insert cmd1
insert cmd0
			smmu execute cmd1
smmu execute cmd0
			poll timeout, because msidata=1 is overridden by
			cmd0, that means VAL=0, sync_idx=1.

This is not a functional problem, since the caller will eventually either
timeout or exit due to another CMD_SYNC, however it's clearly not what
the code is supposed to be doing. Fix it, by incrementing the sequence
count with the command-queue lock held, allowing us to drop the atomic
operations altogether.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
[will: dropped the specialised cmd building routine for now]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu-v3.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 40fbf20d69e5a..2ab7100bcff12 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -567,7 +567,7 @@ struct arm_smmu_device {
 
 	int				gerr_irq;
 	int				combined_irq;
-	atomic_t			sync_nr;
+	u32				sync_nr;
 
 	unsigned long			ias; /* IPA */
 	unsigned long			oas; /* PA */
@@ -964,14 +964,13 @@ static int __arm_smmu_cmdq_issue_sync_msi(struct arm_smmu_device *smmu)
 	struct arm_smmu_cmdq_ent ent = {
 		.opcode = CMDQ_OP_CMD_SYNC,
 		.sync	= {
-			.msidata = atomic_inc_return_relaxed(&smmu->sync_nr),
 			.msiaddr = virt_to_phys(&smmu->sync_count),
 		},
 	};
 
-	arm_smmu_cmdq_build_cmd(cmd, &ent);
-
 	spin_lock_irqsave(&smmu->cmdq.lock, flags);
+	ent.sync.msidata = ++smmu->sync_nr;
+	arm_smmu_cmdq_build_cmd(cmd, &ent);
 	arm_smmu_cmdq_insert_cmd(smmu, cmd);
 	spin_unlock_irqrestore(&smmu->cmdq.lock, flags);
 
@@ -2196,7 +2195,6 @@ static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
 {
 	int ret;
 
-	atomic_set(&smmu->sync_nr, 0);
 	ret = arm_smmu_init_queues(smmu);
 	if (ret)
 		return ret;
-- 
2.20.1

