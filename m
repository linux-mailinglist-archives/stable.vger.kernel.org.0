Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2DB15F1E5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgBNSEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:04:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387488AbgBNPzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:55:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E4324673;
        Fri, 14 Feb 2020 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695739;
        bh=hYe8mgurnnCNHbCZPCRsvBzYl8Frn3+rvW9UJrzHVNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFbGGzLp2/3R6LQo7nyKMACEzsGw/9bfEp4WytYKTlAWtfImFheNHFNgkL02WFILm
         WYp+/t28pDOMe6nTkYhzKyXK7FJgf9TQ4VgMjCG7Gygag2yX0C8YiBWv0/asaouIEL
         3Q2OPFqiFsIplX5FejZTqdgbBmi1TBrN/5aEVxVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.5 312/542] iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA
Date:   Fri, 14 Feb 2020 10:45:04 -0500
Message-Id: <20200214154854.6746-312-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

[ Upstream commit 935d43ba272e0001f8ef446a3eff15d8175cb11b ]

CMDQ_OP_TLBI_NH_VA requires VMID and this was missing since
commit 1c27df1c0a82 ("iommu/arm-smmu: Use correct address mask
for CMD_TLBI_S2_IPA"). Add it back.

Fixes: 1c27df1c0a82 ("iommu/arm-smmu: Use correct address mask for CMD_TLBI_S2_IPA")
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu-v3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index effe72eb89e7f..2f7680faba49e 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -856,6 +856,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
 		break;
 	case CMDQ_OP_TLBI_NH_VA:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
 		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
-- 
2.20.1

