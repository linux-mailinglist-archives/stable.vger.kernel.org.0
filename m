Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE94E306AC2
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 02:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhA1Bxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 20:53:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:14814 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhA1Bx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 20:53:28 -0500
IronPort-SDR: fFMBxtAptYDbJFoL3+ZlwH0WiIKX8ylb7DUG5qkhd7PnHLhxRFA3a22x16rotR/BOn5rNnkc0f
 PcvODrzgKSHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="198991706"
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="198991706"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 17:51:41 -0800
IronPort-SDR: rnpuTqtNP5HTpd56nN+iQtZfrfdhwWMnRLL81Xvssp8Mo7L9PCghuihYGjHq/9M98Z90fxl9z7
 Ag00aOHWkVmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="403302867"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jan 2021 17:51:39 -0800
Cc:     baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] iommu/vt-d: do not use flush-queue when caching-mode
 is on
To:     Nadav Amit <nadav.amit@gmail.com>, iommu@lists.linux-foundation.org
References: <20210127175317.1600473-1-namit@vmware.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <31808b1a-c5ce-b262-3022-ec6f31700728@linux.intel.com>
Date:   Thu, 28 Jan 2021 09:43:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210127175317.1600473-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/21 1:53 AM, Nadav Amit wrote:
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
> Getting batched TLB flushes to use page-specific invalidations again in
> such circumstances is not easy, since the TLB invalidation scheme
> assumes that "full" domain TLB flushes are performed for scalability.
> 
> Disable batched TLB flushes when caching-mode is on, as the performance
> benefit from using batched TLB invalidations is likely to be much
> smaller than the overhead of the virtual-to-physical IOMMU page-tables
> synchronization.
> 
> Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> 
> ---
> v2->v3:
> 
> * Fix the fixes tag in the commit-log (Lu).
> * Minor English rephrasing of the commit-log.
> 
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

Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
