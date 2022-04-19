Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A566507BA4
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 23:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357493AbiDSVI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 17:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345084AbiDSVIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 17:08:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C90C124977;
        Tue, 19 Apr 2022 14:05:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 899BF13D5;
        Tue, 19 Apr 2022 14:05:41 -0700 (PDT)
Received: from [10.57.41.251] (unknown [10.57.41.251])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E939B3F766;
        Tue, 19 Apr 2022 14:05:38 -0700 (PDT)
Message-ID: <8a43fed2-5404-26bb-243c-991369451dd8@arm.com>
Date:   Tue, 19 Apr 2022 22:05:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] iommu/arm-smmu-v3: Fix size calculation in
 arm_smmu_mm_invalidate_range()
Content-Language: en-GB
To:     Nicolin Chen <nicolinc@nvidia.com>, jgg@ziepe.ca, will@kernel.org,
        joro@8bytes.org, jean-philippe@linaro.org
Cc:     jacob.jun.pan@linux.intel.com, baolu.lu@linux.intel.com,
        fenghua.yu@intel.com, rikard.falkeborn@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220419210158.21320-1-nicolinc@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220419210158.21320-1-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-04-19 22:01, Nicolin Chen wrote:
> The arm_smmu_mm_invalidate_range function is designed to be called
> by mm core for Shared Virtual Addressing purpose between IOMMU and
> CPU MMU. However, the ways of two subsystems defining their "end"
> addresses are slightly different. IOMMU defines its "end" address
> using the last address of an address range, while mm core defines
> that using the following address of an address range:
> 
> 	include/linux/mm_types.h:
> 		unsigned long vm_end;
> 		/* The first byte after our end address ...
> 
> This mismatch resulted in an incorrect calculation for size so it
> failed to be page-size aligned. Further, it caused a dead loop at
> "while (iova < end)" check in __arm_smmu_tlb_inv_range function.
> 
> This patch fixes the issue by doing the calculation correctly.

Reviewed-by: Robin Murphy <robin.murphy@arm.com>

> Fixes: 2f7e8c553e98d ("iommu/arm-smmu-v3: Hook up ATC invalidation to mm ops")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 22ddd05bbdcd..c623dae1e115 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -183,7 +183,14 @@ static void arm_smmu_mm_invalidate_range(struct mmu_notifier *mn,
>   {
>   	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
>   	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
> -	size_t size = end - start + 1;
> +	size_t size;
> +
> +	/*
> +	 * The mm_types defines vm_end as the first byte after the end address,
> +	 * different from IOMMU subsystem using the last address of an address
> +	 * range. So do a simple translation here by calculating size correctly.
> +	 */
> +	size = end - start;
>   
>   	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
>   		arm_smmu_tlb_inv_range_asid(start, size, smmu_mn->cd->asid,
