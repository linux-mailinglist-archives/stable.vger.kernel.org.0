Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A152D303A73
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 11:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404062AbhAZKgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 05:36:10 -0500
Received: from foss.arm.com ([217.140.110.172]:60670 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404175AbhAZKfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 05:35:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 862E2D6E;
        Tue, 26 Jan 2021 02:34:34 -0800 (PST)
Received: from [10.57.43.46] (unknown [10.57.43.46])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FCA73F66B;
        Tue, 26 Jan 2021 02:34:33 -0800 (PST)
Subject: Re: [PATCH] iommu/arm-smmu-qcom: Fix mask extraction for bootloader
 programmed SMRs
To:     "Isaac J. Manjarres" <isaacm@codeaurora.org>, will@kernel.org,
        joro@8bytes.org, bjorn.andersson@linaro.org
Cc:     stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1611611545-19055-1-git-send-email-isaacm@codeaurora.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <21495c0d-d029-48c8-bbe7-fc45ff7d9326@arm.com>
Date:   Tue, 26 Jan 2021 10:34:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611611545-19055-1-git-send-email-isaacm@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-01-25 21:52, Isaac J. Manjarres wrote:
> When extracting the mask for a SMR that was programmed by the
> bootloader, the SMR's valid bit is also extracted and is treated
> as part of the mask, which is not correct. Consider the scenario
> where an SMMU master whose context is determined by a bootloader
> programmed SMR is removed (omitting parts of device/driver core):
> 
> ->iommu_release_device()
>   -> arm_smmu_release_device()
>    -> arm_smmu_master_free_smes()
>     -> arm_smmu_free_sme() /* Assume that the SME is now free */
>     -> arm_smmu_write_sme()
>      -> arm_smmu_write_smr() /* Construct SMR value using mask and SID */
> 
> Since the valid bit was considered as part of the mask, the SMR will
> be programmed as valid.

Ah, right, because ARM_SMMU_SMR_{ID,MASK} are 16-bit fields to 
accommodate EXIDS, which doesn't matter normally when the IDs are 
strictly validated in arm_smmu_probe_device()...

> Fix the SMR mask extraction step for bootloader programmed SMRs
> by masking out the valid bit when we know that we're already
> working with a valid SMR.

This seems like the neatest approach to me.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Fixes: 07a7f2caaa5a ("iommu/arm-smmu-qcom: Read back stream mappings")
> Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
> Cc: stable@vger.kernel.org
> ---
>   drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> index bcda170..abb1d2f 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> @@ -206,6 +206,8 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
>   		smr = arm_smmu_gr0_read(smmu, ARM_SMMU_GR0_SMR(i));
>   
>   		if (FIELD_GET(ARM_SMMU_SMR_VALID, smr)) {
> +			/* Ignore valid bit for SMR mask extraction. */
> +			smr &= ~ARM_SMMU_SMR_VALID;
>   			smmu->smrs[i].id = FIELD_GET(ARM_SMMU_SMR_ID, smr);
>   			smmu->smrs[i].mask = FIELD_GET(ARM_SMMU_SMR_MASK, smr);
>   			smmu->smrs[i].valid = true;
> 
