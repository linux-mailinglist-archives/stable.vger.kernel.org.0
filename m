Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8F360217
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 07:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhDOF7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 01:59:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:43550 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhDOF7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 01:59:38 -0400
IronPort-SDR: PVz46bTUDm5iyLa2nCdlLkT5N6UYaT6qCJHuKsW9EWEm0QmDP1rf/0vWQcAIHgv7ryKpFxhA7X
 5Hf792p5OJ8Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="215294954"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="215294954"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 22:59:12 -0700
IronPort-SDR: rWcVVr+HoVZyGXzVMjF6DGfjHPVYXB9lyYmNeP89phqJcnEJnrpduOurB1cqgNB0zty9zG9yRb
 dabu/2Wdd6FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="444067941"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 14 Apr 2021 22:59:10 -0700
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Gonglei <arei.gonglei@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] iommu/vt-d: Force to flush iotlb before creating
 superpage
To:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210415004628.1779-1-longpeng2@huawei.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <91aaf321-92a2-9c61-93c3-00c4112977f7@linux.intel.com>
Date:   Thu, 15 Apr 2021 13:49:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415004628.1779-1-longpeng2@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Longpeng,

On 4/15/21 8:46 AM, Longpeng(Mike) wrote:
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
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Gonglei (Arei) <arei.gonglei@huawei.com>
> 
> Fixes: 6491d4d02893 ("intel-iommu: Free old page tables before creating superpage")
> Cc: <stable@vger.kernel.org> # v3.0+
> Link: https://lore.kernel.org/linux-iommu/670baaf8-4ff8-4e84-4be3-030b95ab5a5e@huawei.com/
> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> ---
> v1 -> v2:
>    - add Joerg
>    - reconstruct the solution base on the Baolu's suggestion
> ---
>   drivers/iommu/intel/iommu.c | 52 +++++++++++++++++++++++++++++++++------------
>   1 file changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ee09323..881c9f2 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -2289,6 +2289,41 @@ static inline int hardware_largepage_caps(struct dmar_domain *domain,
>   	return level;
>   }
>   
> +/*
> + * Ensure that old small page tables are removed to make room for superpage(s).
> + * We're going to add new large pages, so make sure we don't remove their parent
> + * tables. The IOTLB/devTLBs should be flushed if any PDE/PTEs are cleared.
> + */
> +static void switch_to_super_page(struct dmar_domain *domain,
> +				 unsigned long start_pfn,
> +				 unsigned long end_pfn, int level)
> +{
> +	unsigned long lvl_pages = lvl_to_nr_pages(level);
> +	struct dma_pte *pte = NULL;
> +	int i;
> +
> +	while (start_pfn <= end_pfn) {
> +		if (!pte)
> +			pte = pfn_to_dma_pte(domain, start_pfn, &level);
> +
> +		if (dma_pte_present(pte)) {
> +			dma_pte_free_pagetable(domain, start_pfn,
> +					       start_pfn + lvl_pages - 1,
> +					       level + 1);
> +
> +			for_each_domain_iommu(i, domain)
> +				iommu_flush_iotlb_psi(g_iommus[i], domain,
> +						      start_pfn, lvl_pages,
> +						      0, 0);
> +		}
> +
> +		pte++;
> +		start_pfn += lvl_pages;
> +		if (first_pte_in_page(pte))
> +			pte = NULL;
> +	}
> +}
> +
>   static int
>   __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
>   		 unsigned long phys_pfn, unsigned long nr_pages, int prot)
> @@ -2329,22 +2364,11 @@ static inline int hardware_largepage_caps(struct dmar_domain *domain,
>   				return -ENOMEM;
>   			/* It is large page*/
>   			if (largepage_lvl > 1) {
> -				unsigned long nr_superpages, end_pfn;
> +				unsigned long end_pfn;
>   
>   				pteval |= DMA_PTE_LARGE_PAGE;
> -				lvl_pages = lvl_to_nr_pages(largepage_lvl);
> -
> -				nr_superpages = nr_pages / lvl_pages;
> -				end_pfn = iov_pfn + nr_superpages * lvl_pages - 1;
> -
> -				/*
> -				 * Ensure that old small page tables are
> -				 * removed to make room for superpage(s).
> -				 * We're adding new large pages, so make sure
> -				 * we don't remove their parent tables.
> -				 */
> -				dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
> -						       largepage_lvl + 1);
> +				end_pfn = ((iov_pfn + nr_pages) & level_mask(largepage_lvl)) - 1;
> +				switch_to_super_page(domain, iov_pfn, end_pfn, largepage_lvl);
>   			} else {
>   				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
>   			}
> 

Thank you!

Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
