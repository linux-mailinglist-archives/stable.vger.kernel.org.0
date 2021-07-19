Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AD43CE4CF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhGSPqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347944AbhGSPni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C08C6140A;
        Mon, 19 Jul 2021 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711750;
        bh=6MAIkxHaPo+Yqp2Ff/ElNQYLdszBr4YG2QdZKdHUdtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUbHeAmPJTI8foJ1OhHdenQyVPNXsjKPw9VmwBFHc8DnCdoBspI7LNXSHK7uZNDT/
         n+Wnvps5/74yYmO4pUxu1xENuyjIhd3E1IgXooAZHUPuHr5vpFMfUgei9hP1hD2zl6
         4pu3jM2SQnZWzOfR1lbtZzIXZDZDziceDhK8P6b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 085/292] iommu/arm-smmu-qcom: Skip the TTBR1 quirk for db820c.
Date:   Mon, 19 Jul 2021 16:52:27 +0200
Message-Id: <20210719144945.307816624@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



