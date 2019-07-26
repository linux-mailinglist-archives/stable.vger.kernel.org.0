Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1CA76506
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 14:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfGZMBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 08:01:07 -0400
Received: from foss.arm.com ([217.140.110.172]:42078 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfGZMBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 08:01:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F185344;
        Fri, 26 Jul 2019 05:01:04 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2B983F694;
        Fri, 26 Jul 2019 05:01:03 -0700 (PDT)
Subject: Re: [PATCH] iommu: arm-smmu-v3: Mark expected switch fall-through
To:     Anders Roxell <anders.roxell@linaro.org>, will@kernel.org,
        joro@8bytes.org
Cc:     stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20190726112821.19775-1-anders.roxell@linaro.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <522507e5-96e6-2bf4-cf91-73963a77358d@arm.com>
Date:   Fri, 26 Jul 2019 13:01:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190726112821.19775-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/07/2019 12:28, Anders Roxell wrote:
> When fall-through warnings was enabled by default, commit d93512ef0f0e

That commit ID only exists in a handful of old linux-next tags.

> ("Makefile: Globally enable fall-through warning"), the following
> warning was starting to show up:
> 
> ../drivers/iommu/arm-smmu-v3.c: In function ‘arm_smmu_write_strtab_ent’:
> ../drivers/iommu/arm-smmu-v3.c:1189:7: warning: this statement may fall
>   through [-Wimplicit-fallthrough=]
>      if (disable_bypass)
>         ^
> ../drivers/iommu/arm-smmu-v3.c:1191:3: note: here
>     default:
>     ^~~~~~~
> 
> Rework so that the compiler doesn't warn about fall-through. Make it
> clearer by calling 'BUG()' when disable_bypass is set, and always
> 'break;'
> 
> Cc: stable@vger.kernel.org # v4.2+
> Fixes: 5bc0a11664e1 ("iommu/arm-smmu: Don't BUG() if we find aborting STEs with disable_bypass")

Why? There's no actual bug, and not even current kernels have that 
warning enabled.

> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>   drivers/iommu/arm-smmu-v3.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index a9a9fabd3968..8e5f0565996d 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -1186,8 +1186,9 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>   			ste_live = true;
>   			break;
>   		case STRTAB_STE_0_CFG_ABORT:
> -			if (disable_bypass)
> -				break;
> +			if (!disable_bypass)
> +				BUG();

You may as well just use BUG_ON().

Robin.

> +			break;
>   		default:
>   			BUG(); /* STE corruption */
>   		}
> 
