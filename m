Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC691328BB6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240305AbhCASij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239958AbhCASbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B676C6526A;
        Mon,  1 Mar 2021 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619783;
        bh=7jYcNy/gDiWlqXFLyGzQD2g11vvddoSFrlrfF1S8OvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+hGs0bBCoD23Mcsy0+73I4ms6rGKYLtJSCRMsK6kC6spAnRDrHb8wDO0a2A4CZ5p
         ZKGqVpTgZuCQ1mUoF7rts1KyWH2968YkWjChJv1G25ph2C7Z2/KcRVewOj2F/zeCoH
         MxzOTLAPKEd44J1zTrvx2Jbbh/Gh9ED6xvGXFOyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Isaac J. Manjarres" <isaacm@codeaurora.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 579/663] iommu/arm-smmu-qcom: Fix mask extraction for bootloader programmed SMRs
Date:   Mon,  1 Mar 2021 17:13:47 +0100
Message-Id: <20210301161210.508999094@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isaac J. Manjarres <isaacm@codeaurora.org>

commit dead723e6f049e9fb6b05e5b93456982798ea961 upstream.

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
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/1611611545-19055-1-git-send-email-isaacm@codeaurora.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -65,6 +65,8 @@ static int qcom_smmu_cfg_probe(struct ar
 		smr = arm_smmu_gr0_read(smmu, ARM_SMMU_GR0_SMR(i));
 
 		if (FIELD_GET(ARM_SMMU_SMR_VALID, smr)) {
+			/* Ignore valid bit for SMR mask extraction. */
+			smr &= ~ARM_SMMU_SMR_VALID;
 			smmu->smrs[i].id = FIELD_GET(ARM_SMMU_SMR_ID, smr);
 			smmu->smrs[i].mask = FIELD_GET(ARM_SMMU_SMR_MASK, smr);
 			smmu->smrs[i].valid = true;


