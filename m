Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69913C2E3A
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhGJC0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233057AbhGJCZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E51613EB;
        Sat, 10 Jul 2021 02:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883790;
        bh=6MAIkxHaPo+Yqp2Ff/ElNQYLdszBr4YG2QdZKdHUdtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzHshrDh8K/Q3OksNEHC3LOxtlRv6GGp6kSjGbD9sRR+0RhiTVzytrZ8mEQsAN7/N
         kf9ffs3SKjLnT9xexayZPVXwtRFl1vd5UE2OIkVwiHBxbEki+wPZrfTNXtHd75Of1j
         3mM9T8LoaFxAVv3Gad6rqoz+N0J+16iGswBgKJFD+ceOJmZnbqHkuMr2YPG/9IhZh/
         O9tlGGXY3G/21FqfE4L+384fMYSmr4SuqGXO4tLWy6/LJELoEIe62uTsnneABnc+oi
         V4kz/iGVGk874zH/yOu9LtLGDF4vHZfM3YkWS6FYWwWcmjAYHaL33YNj421np1bDV9
         iaQX0aU8Z5GJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Anholt <eric@anholt.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.12 056/104] iommu/arm-smmu-qcom: Skip the TTBR1 quirk for db820c.
Date:   Fri,  9 Jul 2021 22:21:08 -0400
Message-Id: <20210710022156.3168825-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Anholt <eric@anholt.net>

[ Upstream commit a242f4297cfe3f4589a7620dcd42cc503607fc6b ]

db820c wants to use the qcom smmu path to get HUPCF set (which keeps
the GPU from wedging and then sometimes wedging the kernel after a
page fault), but it doesn't have separate pagetables support yet in
drm/msm so we can't go all the way to the TTBR1 path.

Signed-off-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210326231303.3071950-1-eric@anholt.net
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 98b3a1c2a181..44a427833385 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -130,6 +130,16 @@ static int qcom_adreno_smmu_alloc_context_bank(struct arm_smmu_domain *smmu_doma
 	return __arm_smmu_alloc_bitmap(smmu->context_map, start, count);
 }
 
+static bool qcom_adreno_can_do_ttbr1(struct arm_smmu_device *smmu)
+{
+	const struct device_node *np = smmu->dev->of_node;
+
+	if (of_device_is_compatible(np, "qcom,msm8996-smmu-v2"))
+		return false;
+
+	return true;
+}
+
 static int qcom_adreno_smmu_init_context(struct arm_smmu_domain *smmu_domain,
 		struct io_pgtable_cfg *pgtbl_cfg, struct device *dev)
 {
@@ -144,7 +154,8 @@ static int qcom_adreno_smmu_init_context(struct arm_smmu_domain *smmu_domain,
 	 * be AARCH64 stage 1 but double check because the arm-smmu code assumes
 	 * that is the case when the TTBR1 quirk is enabled
 	 */
-	if ((smmu_domain->stage == ARM_SMMU_DOMAIN_S1) &&
+	if (qcom_adreno_can_do_ttbr1(smmu_domain->smmu) &&
+	    (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) &&
 	    (smmu_domain->cfg.fmt == ARM_SMMU_CTX_FMT_AARCH64))
 		pgtbl_cfg->quirks |= IO_PGTABLE_QUIRK_ARM_TTBR1;
 
-- 
2.30.2

