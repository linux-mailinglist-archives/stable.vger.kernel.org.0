Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFB737406B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbhEEQer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234395AbhEEQdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 967D4613FE;
        Wed,  5 May 2021 16:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232334;
        bh=tm8jSpP60pbo5RlHvOGMwjbKX7BlomLq7rcI8Zd1ArA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICDvFJ1ObZSCg2xwedzl9XYK9MXsnVMgU3oeKTp87nnbh27OjBABSUFA8D4zYuNJ9
         xWfPMDmK6qCbgOSvZ1/xeaqvYVgpVzT8jPyvn59Z9DNhJuHvbB2h8JVF2N52z8AfEI
         NOEdBDz4JDsifdAKDyDQIBVFmlHoe2xPoqSxgt3mNQLBRWlK2l2PBWCrjIqZkzrv35
         f3agdzwUTdtd+LZqIYhaFlC9yRkS3Irt82xW6w3XTvlyDetDbBGOhpcyJM43jl4uja
         jmru5tD+1VszFSmwgBja5j/KUmv8ZoVjNXwqH4aamypPs7q87RQBB7sEHNR8L+L08J
         JO9MjUq3xiOng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.12 036/116] iommu/arm-smmu-v3: Add a check to avoid invalid iotlb sync
Date:   Wed,  5 May 2021 12:30:04 -0400
Message-Id: <20210505163125.3460440-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 6cc7e5a9c6b02507b9be5a99b51e970afa91c85f ]

It may send a invalid tlb sync for smmuv3 if iotlb_gather is not valid
(iotlb_gather->pgsize = 0). So add a check to avoid invalid iotlb sync
for it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1617109106-121844-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8594b4a83043..941ba5484731 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2305,6 +2305,9 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
+	if (!gather->pgsize)
+		return;
+
 	arm_smmu_tlb_inv_range_domain(gather->start,
 				      gather->end - gather->start + 1,
 				      gather->pgsize, true, smmu_domain);
-- 
2.30.2

