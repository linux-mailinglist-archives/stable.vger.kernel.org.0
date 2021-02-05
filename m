Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FCB310236
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 02:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhBEB1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 20:27:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:3516 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhBEB1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 20:27:12 -0500
IronPort-SDR: pLAHufxgXkX/emxOOSRI3OVfnaCRuO6gLpzPtudzu9RQj/6YXOFKrO5S20Ge+q8LIlKBedacYg
 a9k8+yl29EmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="169037899"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="169037899"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 17:25:25 -0800
IronPort-SDR: fPKO6/kMTAFM30VqHzdvaOtdYon9k99Kg7TaDduQokf6BJ3EtvBER6MxfBY5PCceTX9IjK6B5m
 bv6w3UMxe9nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="407457062"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 04 Feb 2021 17:25:22 -0800
Cc:     baolu.lu@linux.intel.com, David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        "jroedel@suse.de" <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when
 caching-mode is on" failed to apply to 5.10-stable tree
To:     Nadav Amit <namit@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1612104088214157@kroah.com>
 <52C9C14F-D496-4E11-9E63-CC9677DA4889@vmware.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <ef6ff830-6495-f3db-7a36-a77a4f62d265@linux.intel.com>
Date:   Fri, 5 Feb 2021 09:16:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <52C9C14F-D496-4E11-9E63-CC9677DA4889@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/5/21 2:04 AM, Nadav Amit wrote:
> Backporting requires to disable strict during initialization. Lu, can
> you ack this patch?
> 
> 
> -- >8 --
> 
>  From d5ce982ce6f6f869c53cc0ed496a6dd4c1309657 Mon Sep 17 00:00:00 2001
> From: Nadav Amit <namit@vmware.com>
> Date: Tue, 26 Jan 2021 12:03:11 -0800
> Subject: [PATCH] iommu/vt-d: do not use flush-queue when caching-mode is on
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
> ---
>   drivers/iommu/intel/iommu.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 151243fa01ba..7e3db4c0324d 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -3350,6 +3350,11 @@ static int __init init_dmars(void)
>   
>   		if (!ecap_pass_through(iommu->ecap))
>   			hw_pass_through = 0;
> +
> +		if (!intel_iommu_strict && cap_caching_mode(iommu->cap)) {
> +			pr_warn("Disable batched IOTLB flush due to virtualization");

It doesn't mean something is wrong. Just optimized for virtualization,
right? Is pr_info() sufficient?

Others look good to me.

Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

> +			intel_iommu_strict = 1;
> +		}
>   		intel_svm_check(iommu);
>   	}
>   
> 
