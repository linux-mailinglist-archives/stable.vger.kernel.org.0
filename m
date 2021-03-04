Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA6132D063
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 11:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbhCDKGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 05:06:55 -0500
Received: from foss.arm.com ([217.140.110.172]:36200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhCDKGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 05:06:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 008D51FB;
        Thu,  4 Mar 2021 02:06:00 -0800 (PST)
Received: from [10.57.48.219] (unknown [10.57.48.219])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89A983F73B;
        Thu,  4 Mar 2021 02:05:58 -0800 (PST)
Subject: Re: [PATCH 5.10 337/663] iommu: Move iotlb_sync_map out from
 __iommu_map
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yong Wu <yong.wu@mediatek.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210301161141.760350206@linuxfoundation.org>
 <20210301161158.520692499@linuxfoundation.org> <20210304084329.GA25188@amd>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <849d5192-3eb6-99cf-62b1-20160a3a4232@arm.com>
Date:   Thu, 4 Mar 2021 10:05:53 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210304084329.GA25188@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-04 08:43, Pavel Machek wrote:
> Hi!
> 
>> [ Upstream commit d8c1df02ac7f2c802a9b2afc0f5c888c4217f1d5 ]
>>
>> In the end of __iommu_map, It alway call iotlb_sync_map.
>>
>> This patch moves iotlb_sync_map out from __iommu_map since it is
>> unnecessary to call this for each sg segment especially iotlb_sync_map
>> is flush tlb all currently. Add a little helper _iommu_map for this.
> 
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> AFAICT this is slight performance optimalization, not a bugfix. It
> actually introduces a bug, fixed by the next patch. I'd preffer not to
> have it in stable.

Right, the whole original series was a set of performance/efficiency 
improvements, so I'm not sure there's much justification for backporting 
individual patches out of context. Plus as you say this one has the 
unfortunate gfp bug.

Thanks for spotting this!

Robin.

> 
> Best regards,
> 								Pavel
> 
>> @@ -2421,18 +2418,31 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
>>   
>> +static int _iommu_map(struct iommu_domain *domain, unsigned long iova,
>> +		      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
>> +{
>> +	const struct iommu_ops *ops = domain->ops;
>> +	int ret;
>> +
>> +	ret = __iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
>> +	if (ret == 0 && ops->iotlb_sync_map)
>> +		ops->iotlb_sync_map(domain);
>> +
>> +	return ret;
>> +}
> 
