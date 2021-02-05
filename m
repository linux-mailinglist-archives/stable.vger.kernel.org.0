Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF38A31072D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhBEIy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229734AbhBEIyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 03:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6279864FB7;
        Fri,  5 Feb 2021 08:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612515251;
        bh=to0LvE6fDEjFogi7LOD27cNgjqWq+5rVRKP8rq7kIag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uLryk1Dl4Y0/DTX4Sn3Zf7PxO5aHTUByEbyxi+KjOgijTL1aCsGGGk8asB+X8/T9r
         DmX2i7GoOv2uQ2ZhY7R/U9nBizHRmvDWTjlBsp3O4bBIy52GD5ad72eCIwDQA8RXj0
         wumrH/twSION4KH/cWY68fHjxFlk24c6cqGh+Hwg=
Date:   Fri, 5 Feb 2021 09:54:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        "jroedel@suse.de" <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when
 caching-mode is on" failed to apply to 5.10-stable tree
Message-ID: <YB0HrznvibyfVBpu@kroah.com>
References: <1612104088214157@kroah.com>
 <52C9C14F-D496-4E11-9E63-CC9677DA4889@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C9C14F-D496-4E11-9E63-CC9677DA4889@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 06:04:13PM +0000, Nadav Amit wrote:
> Backporting requires to disable strict during initialization. Lu, can
> you ack this patch?
> 
> 
> -- >8 --
> 
> >From d5ce982ce6f6f869c53cc0ed496a6dd4c1309657 Mon Sep 17 00:00:00 2001
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
>  drivers/iommu/intel/iommu.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 151243fa01ba..7e3db4c0324d 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -3350,6 +3350,11 @@ static int __init init_dmars(void)
>  
>  		if (!ecap_pass_through(iommu->ecap))
>  			hw_pass_through = 0;
> +
> +		if (!intel_iommu_strict && cap_caching_mode(iommu->cap)) {
> +			pr_warn("Disable batched IOTLB flush due to virtualization");
> +			intel_iommu_strict = 1;
> +		}
>  		intel_svm_check(iommu);
>  	}
>  

This works for 5.10, thanks!  But what about 4.9, 4.14, 4.19, and 5.4?
Those also need this change, right?

thanks,

greg k-h
