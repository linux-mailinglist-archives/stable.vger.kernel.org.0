Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942F7352652
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 06:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhDBEx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 00:53:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:50358 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhDBEx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Apr 2021 00:53:27 -0400
IronPort-SDR: sBNyMtZEIrSFXv1l4R0jg55WB3X45Awh/TdbGQzycMAjKq/K7Mg77UMtuJa5ZuZQSVLPKoI3xK
 51MFS44QE07g==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="191869860"
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="191869860"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 21:53:26 -0700
IronPort-SDR: wrvsYJM85qho+rwKDNnxzVYqmYVmd532nChyBcTpoLpAENCHNdIRC5iMpxu6hAlLcPjZYmiSvU
 D1OFOT0HBDGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,298,1610438400"; 
   d="scan'208";a="439476626"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 01 Apr 2021 21:53:24 -0700
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
Message-ID: <9c368419-6e45-6b27-0f34-26b581589fa7@linux.intel.com>
Date:   Fri, 2 Apr 2021 12:44:02 +0800
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

The dma_pte_free_pagetable() clears a batch of PTEs. So checking current
PTE is insufficient. How about removing this check and always performing
cache invalidation?

> +					int i;
> +
> +					dma_pte_free_pagetable(domain, iov_pfn, end_pfn,
> +							       largepage_lvl + 1);
> +					for_each_domain_iommu(i, domain)
> +						iommu_flush_iotlb_psi(g_iommus[i], domain,
> +								      iov_pfn, nr_pages, 0, 0);
> +				

Best regards,
baolu
