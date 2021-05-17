Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D8C382E96
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238072AbhEQOJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237896AbhEQOHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:07:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD0561350;
        Mon, 17 May 2021 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260359;
        bh=tm8jSpP60pbo5RlHvOGMwjbKX7BlomLq7rcI8Zd1ArA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWmnd9LnM5VOmxkiF+ocGiJaXU9L9SFLr5y24S7t253USfdXjZvSUZeEFMO3H4Wqj
         O+mTc9jrhHZd0N3ThkcPVKQ3vR06Iac0RNzVL7d2cMEXYjEXbJ5KaCT+/un4UJjr26
         YTBJ4KuMLuWZ75aR151M1NVcycX5UH+s/Vu64NLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 045/363] iommu/arm-smmu-v3: Add a check to avoid invalid iotlb sync
Date:   Mon, 17 May 2021 15:58:31 +0200
Message-Id: <20210517140304.132008919@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



