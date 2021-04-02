Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779E935259F
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 05:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhDBDPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 23:15:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:50529 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234314AbhDBDPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 23:15:35 -0400
IronPort-SDR: mRXSHQ7r785d38tCb0HOYfMlHPS+vxTVnUOQjnhXcFHPZrfy++FYI3WhtIa1OOaiJctxbr6e8X
 uUWffY9o83tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="192484245"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="192484245"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 20:15:35 -0700
IronPort-SDR: mWCofTGb+zOCsHT2FJk/D0jGvVvJ01//G9LsEk+Iog9W47QH4udM/T9l1qXmRpyjApFDXIInZO
 xUmh97glinFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="439449589"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 01 Apr 2021 20:15:32 -0700
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Gonglei <arei.gonglei@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: Force to flush iotlb before creating
 superpage
To:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210401071834.1639-1-longpeng2@huawei.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <af470760-04c1-0929-7304-0879ca7af542@linux.intel.com>
Date:   Fri, 2 Apr 2021 11:06:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210401071834.1639-1-longpeng2@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Longpeng,

On 4/1/21 3:18 PM, Longpeng(Mike) wrote:
> The translation caches may preserve obsolete data when the
> mapping size is changed, suppose the following sequence which
> can reveal the problem with high probability.
> 
> 1.mmap(4GB,MAP_HUGETLB)
> 2.
>    while (1) {
>     (a)    DMA MAP   0,0xa0000
>     (b)    DMA UNMAP 0,0xa0000
>     (c)    DMA MAP   0,0xc0000000
>               * DMA read IOVA 0 may failure here (Not present)
>               * if the problem occurs.
>     (d)    DMA UNMAP 0,0xc0000000
>    }
> 
> The page table(only focus on IOVA 0) after (a) is:
>   PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
>    PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
>     PDE: 0x1a30a72003  entry:0xffff89b39cacb000
>      PTE: 0x21d200803  entry:0xffff89b3b0a72000
> 
> The page table after (b) is:
>   PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
>    PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
>     PDE: 0x1a30a72003  entry:0xffff89b39cacb000
>      PTE: 0x0          entry:0xffff89b3b0a72000
> 
> The page table after (c) is:
>   PML4: 0x19db5c1003   entry:0xffff899bdcd2f000
>    PDPE: 0x1a1cacb003  entry:0xffff89b35b5c1000
>     PDE: 0x21d200883   entry:0xffff89b39cacb000 (*)
> 
> Because the PDE entry after (b) is present, it won't be
> flushed even if the iommu driver flush cache when unmap,
> so the obsolete data may be preserved in cache, which
> would cause the wrong translation at end.
> 
> However, we can see the PDE entry is finally switch to
> 2M-superpage mapping, but it does not transform
> to 0x21d200883 directly:
> 
> 1. PDE: 0x1a30a72003
> 2. __domain_mapping
>       dma_pte_free_pagetable
>         Set the PDE entry to ZERO
>       Set the PDE entry to 0x21d200883
> 
> So we must flush the cache after the entry switch to ZERO
> to avoid the obsolete info be preserved.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Gonglei (Arei) <arei.gonglei@huawei.com>
> 
> Fixes: 6491d4d02893 ("intel-iommu: Free old page tables before creating superpage")
> Cc: <stable@vger.kernel.org> # v3.0+
> Link: https://lore.kernel.org/linux-iommu/670baaf8-4ff8-4e84-4be3-030b95ab5a5e@huawei.com/
> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> ---
>   drivers/iommu/intel/iommu.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ee09323..cbcb434 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -2342,9 +2342,20 @@ static inline int hardware_largepage_caps(struct dmar_domain *domain,
>   				 * removed to make room for superpage(s).
>   				 * We're adding new large pages, so make sure
>   				 * we don't remove their parent tables.
> +				 *
> +				 * We also need to flush the iotlb before creating
> +				 * superpage to ensure it does not perserves any
> +				 * obsolete info.
>   				 */
> -				dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
> -						       largepage_lvl + 1);
> +				if (dma_pte_present(pte)) {
> +					int i;
> +
> +					dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
> +							       largepage_lvl + 1);
> +					for_each_domain_iommu(i, domain)
> +						iommu_flush_iotlb_psi(g_iommus[i], domain,
> +								      iov_pfn, nr_pages, 0, 0);

Thanks for patch!

How about making the flushed page size accurate? For example,

@@ -2365,8 +2365,8 @@ __domain_mapping(struct dmar_domain *domain, 
unsigned long iov_pfn,
                                         dma_pte_free_pagetable(domain, 
iov_pfn, end_pfn,
 
largepage_lvl + 1);
                                         for_each_domain_iommu(i, domain)
- 
iommu_flush_iotlb_psi(g_iommus[i], domain,
- 
iov_pfn, nr_pages, 0, 0);
+ 
iommu_flush_iotlb_psi(g_iommus[i], domain, iov_pfn,
+ 
ALIGN_DOWN(nr_pages, lvl_pages), 0, 0);


> +				}
>   			} else {
>   				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
>   			}
> 

Best regards,
baolu
