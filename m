Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF00E5C18
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfJZN2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbfJZNVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD972070B;
        Sat, 26 Oct 2019 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096071;
        bh=af3p0/s1/mz9NwY6vrVnhrPQVib0bzNLSeGM8cpc73Y=;
        h=From:To:Cc:Subject:Date:From;
        b=UsU+1yB3+UjOg2VZlNl0rrjRIhBBZTK9GxEkjHnRbvX118tP2rVNrTFLY1tSHw8OM
         mSKNSG9p/K8BHzHIuQmgtXoOz40G5yDGzS7CXna8nLZrMt8hq6NTMw2Mdt4Mi9lst/
         IrbZfQigHU8yDe67sV6CIIZ7xFPbOKX24MeIODhw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Xiang <liuxiang_1999@126.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.14 01/33] iommu/arm-smmu: Free context bitmap in the err path of arm_smmu_init_domain_context
Date:   Sat, 26 Oct 2019 09:20:38 -0400
Message-Id: <20191026132110.4026-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Xiang <liuxiang_1999@126.com>

[ Upstream commit 6db7bfb431220d78e34d2d0afdb7c12683323588 ]

When alloc_io_pgtable_ops is failed, context bitmap which is just allocated
by __arm_smmu_alloc_bitmap should be freed to release the resource.

Signed-off-by: Liu Xiang <liuxiang_1999@126.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index c38cf03c099ed..f97c26c90c41f 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -922,6 +922,7 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
 	return 0;
 
 out_clear_smmu:
+	__arm_smmu_free_bitmap(smmu->context_map, cfg->cbndx);
 	smmu_domain->smmu = NULL;
 out_unlock:
 	mutex_unlock(&smmu_domain->init_mutex);
-- 
2.20.1

