Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13A7302E65
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 22:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732854AbhAYVxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 16:53:41 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:56275 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732651AbhAYVxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 16:53:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611611590; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=wjOwZ7hnkSut6Udf2hJQbonOlbKoFsbqZco5e9Oswzk=; b=fR2qsfRVUa1S9421tOeLI3rJqmaFSqDDRk06xBrDqbp4tQYjJCohacD7BfhiirWt8GNmaLFI
 iSw5ZF5hCLwoqXrzyiOcbLKosC/ogI+V1/NetCaIkj5BDV4KJZNUSNt4MuMBhMf4N7aZxcjn
 2qQkmUUsvnPTnlzgjGvtalXVAZg=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 600f3da02c36b2106dd15037 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Jan 2021 21:52:32
 GMT
Sender: isaacm=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D2380C433C6; Mon, 25 Jan 2021 21:52:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from isaacm-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: isaacm)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB1D3C433CA;
        Mon, 25 Jan 2021 21:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EB1D3C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=isaacm@codeaurora.org
From:   "Isaac J. Manjarres" <isaacm@codeaurora.org>
To:     will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        bjorn.andersson@linaro.org
Cc:     "Isaac J. Manjarres" <isaacm@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] iommu/arm-smmu-qcom: Fix mask extraction for bootloader programmed SMRs
Date:   Mon, 25 Jan 2021 13:52:25 -0800
Message-Id: <1611611545-19055-1-git-send-email-isaacm@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When extracting the mask for a SMR that was programmed by the
bootloader, the SMR's valid bit is also extracted and is treated
as part of the mask, which is not correct. Consider the scenario
where an SMMU master whose context is determined by a bootloader
programmed SMR is removed (omitting parts of device/driver core):

->iommu_release_device()
 -> arm_smmu_release_device()
  -> arm_smmu_master_free_smes()
   -> arm_smmu_free_sme() /* Assume that the SME is now free */
   -> arm_smmu_write_sme()
    -> arm_smmu_write_smr() /* Construct SMR value using mask and SID */

Since the valid bit was considered as part of the mask, the SMR will
be programmed as valid.

Fix the SMR mask extraction step for bootloader programmed SMRs
by masking out the valid bit when we know that we're already
working with a valid SMR.

Fixes: 07a7f2caaa5a ("iommu/arm-smmu-qcom: Read back stream mappings")
Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
Cc: stable@vger.kernel.org
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index bcda170..abb1d2f 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -206,6 +206,8 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 		smr = arm_smmu_gr0_read(smmu, ARM_SMMU_GR0_SMR(i));
 
 		if (FIELD_GET(ARM_SMMU_SMR_VALID, smr)) {
+			/* Ignore valid bit for SMR mask extraction. */
+			smr &= ~ARM_SMMU_SMR_VALID;
 			smmu->smrs[i].id = FIELD_GET(ARM_SMMU_SMR_ID, smr);
 			smmu->smrs[i].mask = FIELD_GET(ARM_SMMU_SMR_MASK, smr);
 			smmu->smrs[i].valid = true;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

