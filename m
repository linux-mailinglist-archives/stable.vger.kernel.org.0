Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5011C310
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 03:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfLLCNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 21:13:41 -0500
Received: from mga04.intel.com ([192.55.52.120]:35819 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbfLLCNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 21:13:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 18:13:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,303,1571727600"; 
   d="scan'208";a="225748499"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 11 Dec 2019 18:13:38 -0800
Cc:     baolu.lu@linux.intel.com
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix dmar pte read access not set error
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191211014015.7898-1-baolu.lu@linux.intel.com>
 <20191212014952.vlrmxrk2cebwxjnp@cantor>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <6f3bcad9-b9b3-b349-fdad-ce53a79a665b@linux.intel.com>
Date:   Thu, 12 Dec 2019 10:12:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191212014952.vlrmxrk2cebwxjnp@cantor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/12/19 9:49 AM, Jerry Snitselaar wrote:
> On Wed Dec 11 19, Lu Baolu wrote:
>> If the default DMA domain of a group doesn't fit a device, it
>> will still sit in the group but use a private identity domain.
>> When map/unmap/iova_to_phys come through iommu API, the driver
>> should still serve them, otherwise, other devices in the same
>> group will be impacted. Since identity domain has been mapped
>> with the whole available memory space and RMRRs, we don't need
>> to worry about the impact on it.
>>
>> Link: https://www.spinics.net/lists/iommu/msg40416.html
>> Cc: Jerry Snitselaar <jsnitsel@redhat.com>
>> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
>> Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains replaced 
>> with private")
>> Cc: stable@vger.kernel.org # v5.3+
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

Can you please try this fix and check whether it can fix your problem?
If it helps, do you mind adding a Tested-by?

Best regards,
baolu

> 
>> ---
>> drivers/iommu/intel-iommu.c | 8 --------
>> 1 file changed, 8 deletions(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 0c8d81f56a30..b73bebea9148 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -5478,9 +5478,6 @@ static int intel_iommu_map(struct iommu_domain 
>> *domain,
>>     int prot = 0;
>>     int ret;
>>
>> -    if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>> -        return -EINVAL;
>> -
>>     if (iommu_prot & IOMMU_READ)
>>         prot |= DMA_PTE_READ;
>>     if (iommu_prot & IOMMU_WRITE)
>> @@ -5523,8 +5520,6 @@ static size_t intel_iommu_unmap(struct 
>> iommu_domain *domain,
>>     /* Cope with horrid API which requires us to unmap more than the
>>        size argument if it happens to be a large-page mapping. */
>>     BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level));
>> -    if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>> -        return 0;
>>
>>     if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
>>         size = VTD_PAGE_SIZE << level_to_offset_bits(level);
>> @@ -5556,9 +5551,6 @@ static phys_addr_t 
>> intel_iommu_iova_to_phys(struct iommu_domain *domain,
>>     int level = 0;
>>     u64 phys = 0;
>>
>> -    if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>> -        return 0;
>> -
>>     pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
>>     if (pte)
>>         phys = dma_pte_addr(pte);
>> -- 
>> 2.17.1
>>
> 
