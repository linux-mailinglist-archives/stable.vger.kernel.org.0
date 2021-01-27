Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DA33059B0
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhA0L24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:28:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:37675 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236650AbhA0L12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 06:27:28 -0500
IronPort-SDR: hoBikP5/y05dcUIh6hv9g/5kmqrT1/5YA8F5t1zio/bTLegbrCH/IClmXWNorkxiv4YeDBGM65
 zVRqnh1RKdXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="180198480"
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="180198480"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 03:25:41 -0800
IronPort-SDR: hvjRdxd5h34oq8sWBSRRbZVDmfRlupl/AXYAo0HarVvgNWk5+D2LexuQBJxuY5h0D5mpElmMdm
 a1P93lIRoGfA==
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="388270712"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.255.31.249]) ([10.255.31.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 03:25:39 -0800
Cc:     baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
To:     Nadav Amit <nadav.amit@gmail.com>, iommu@lists.linux-foundation.org
References: <20210127061729.1596640-1-namit@vmware.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH v2] iommu/vt-d: do not use flush-queue when caching-mode
 is on
Message-ID: <15c974b1-b50d-9061-9d97-fef6f3804b22@linux.intel.com>
Date:   Wed, 27 Jan 2021 19:25:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127061729.1596640-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/1/27 14:17, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> When an Intel IOMMU is virtualized, and a physical device is
> passed-through to the VM, changes of the virtual IOMMU need to be
> propagated to the physical IOMMU. The hypervisor therefore needs to
> monitor PTE mappings in the IOMMU page-tables. Intel specifications
> provide "caching-mode" capability that a virtual IOMMU uses to report
> that the IOMMU is virtualized and a TLB flush is needed after mapping to
> allow the hypervisor to propagate virtual IOMMU mappings to the physical
> IOMMU. To the best of my knowledge no real physical IOMMU reports
> "caching-mode" as turned on.
> 
> Synchronizing the virtual and the physical IOMMU tables is expensive if
> the hypervisor is unaware which PTEs have changed, as the hypervisor is
> required to walk all the virtualized tables and look for changes.
> Consequently, domain flushes are much more expensive than page-specific
> flushes on virtualized IOMMUs with passthrough devices. The kernel
> therefore exploited the "caching-mode" indication to avoid domain
> flushing and use page-specific flushing in virtualized environments. See
> commit 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching
> mode.")
> 
> This behavior changed after commit 13cf01744608 ("iommu/vt-d: Make use
> of iova deferred flushing"). Now, when batched TLB flushing is used (the
> default), full TLB domain flushes are performed frequently, requiring
> the hypervisor to perform expensive synchronization between the virtual
> TLB and the physical one.
> 
> Getting batched TLB flushes to use in such circumstances page-specific
> invalidations again is not easy, since the TLB invalidation scheme
> assumes that "full" domain TLB flushes are performed for scalability.
> 
> Disable batched TLB flushes when caching-mode is on, as the performance
> benefit from using batched TLB invalidations is likely to be much
> smaller than the overhead of the virtual-to-physical IOMMU page-tables
> synchronization.
> 
> Fixes: 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching mode.")

Isn't it

Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")

?

Best regards,
baolu

> Signed-off-by: Nadav Amit <namit@vmware.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org >
> ---
> v1->v2:
> 
> * disable flush queue for all domains if caching-mode is on for any
>    IOMMU (Lu).
> ---
>   drivers/iommu/intel/iommu.c | 32 +++++++++++++++++++++++++++++++-
>   1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 788119c5b021..de3dd617cf60 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5373,6 +5373,36 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
>   	return ret;
>   }
>   
> +static bool domain_use_flush_queue(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	bool r = true;
> +
> +	if (intel_iommu_strict)
> +		return false;
> +
> +	/*
> +	 * The flush queue implementation does not perform page-selective
> +	 * invalidations that are required for efficient TLB flushes in virtual
> +	 * environments. The benefit of batching is likely to be much lower than
> +	 * the overhead of synchronizing the virtual and physical IOMMU
> +	 * page-tables.
> +	 */
> +	rcu_read_lock();
> +	for_each_active_iommu(iommu, drhd) {
> +		if (!cap_caching_mode(iommu->cap))
> +			continue;
> +
> +		pr_warn_once("IOMMU batching is disabled due to virtualization");
> +		r = false;
> +		break;
> +	}
> +	rcu_read_unlock();
> +
> +	return r;
> +}
> +
>   static int
>   intel_iommu_domain_get_attr(struct iommu_domain *domain,
>   			    enum iommu_attr attr, void *data)
> @@ -5383,7 +5413,7 @@ intel_iommu_domain_get_attr(struct iommu_domain *domain,
>   	case IOMMU_DOMAIN_DMA:
>   		switch (attr) {
>   		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
> -			*(int *)data = !intel_iommu_strict;
> +			*(int *)data = domain_use_flush_queue();
>   			return 0;
>   		default:
>   			return -ENODEV;
> 
