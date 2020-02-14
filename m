Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A8915ECCF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390730AbgBNQHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390727AbgBNQHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61021206D7;
        Fri, 14 Feb 2020 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696460;
        bh=B4hsJd84MGsALojLjJWgnNZLBKF6xB1oL1k8gRdTYlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8fELqIbOqfsWeLmyu6/ZDrlA+5x70TiaLSo2hWaSmuyu7QZymXQTjSGVMRJqJbCY
         kzIQuBpSi2pkRe0+kGELxp7DvV353TV/zQb4Fm5791KAsLRrXwmQrk+bW1HbC7TX+f
         tHQdMzfs6RaFed/jUwAaHkFlVIHH2eokOeSG0FkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 271/459] iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA
Date:   Fri, 14 Feb 2020 10:58:41 -0500
Message-Id: <20200214160149.11681-271-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index ed90361b84dc7..ee8d48d863e16 100644
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

