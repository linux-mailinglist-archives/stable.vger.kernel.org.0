Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D7497EE5
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 17:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbfHUPgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 11:36:36 -0400
Received: from foss.arm.com ([217.140.110.172]:60300 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbfHUPgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 11:36:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FCBC337;
        Wed, 21 Aug 2019 08:36:35 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 502633F718;
        Wed, 21 Aug 2019 08:36:34 -0700 (PDT)
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Disable detection of ATS and
 PRI
To:     Will Deacon <will@kernel.org>, iommu@lists.linux-foundation.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        John Garry <john.garry@huawei.com>, stable@vger.kernel.org
References: <20190821151749.23743-1-will@kernel.org>
 <20190821151749.23743-3-will@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <af491ac1-f08b-f253-2133-2e45b7b99800@arm.com>
Date:   Wed, 21 Aug 2019 16:36:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190821151749.23743-3-will@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/08/2019 16:17, Will Deacon wrote:
> Detecting the ATS capability of the SMMU at probe time introduces a
> spinlock into the ->unmap() fast path, even when ATS is not actually
> in use. Furthermore, the ATC invalidation that exists is broken, as it
> occurs before invalidation of the main SMMU TLB which leaves a window
> where the ATC can be repopulated with stale entries.
> 
> Given that ATS is both a new feature and a specialist sport, disable it
> for now whilst we fix it properly in subsequent patches. Since PRI
> requires ATS, disable that too.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 9ce27afc0830 ("iommu/arm-smmu-v3: Add support for PCI ATS")

Acked-by: Robin Murphy <robin.murphy@arm.com>

> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   drivers/iommu/arm-smmu-v3.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index 3402b1bc8e94..7a368059cd7d 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -3295,11 +3295,13 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>   	}
>   
>   	/* Boolean feature flags */
> +#if 0	/* ATS invalidation is slow and broken */
>   	if (IS_ENABLED(CONFIG_PCI_PRI) && reg & IDR0_PRI)
>   		smmu->features |= ARM_SMMU_FEAT_PRI;
>   
>   	if (IS_ENABLED(CONFIG_PCI_ATS) && reg & IDR0_ATS)
>   		smmu->features |= ARM_SMMU_FEAT_ATS;
> +#endif
>   
>   	if (reg & IDR0_SEV)
>   		smmu->features |= ARM_SMMU_FEAT_SEV;
> 
