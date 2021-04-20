Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7A2365701
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 13:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhDTLCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 07:02:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:7594 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhDTLCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 07:02:43 -0400
IronPort-SDR: 5gZ32iMOfFGv/YMtnfc4oUHjvCtClv2YQBBKHedqL7NI80/OX6Dl6hxglVzIiGhcvtxngAw8f2
 oBJe/qR8Hpow==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="256799128"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="256799128"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 04:02:10 -0700
IronPort-SDR: SfbMSfrbmDeoAoFxkyFsFFfzKzEx81WFjQoAVZJKo6/3QealsjUg7D5+x26/+2Dk91uspeeOXH
 meq+32GNYf4Q==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="534453026"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 04:02:06 -0700
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id 791ED228CE;
        Tue, 20 Apr 2021 12:13:09 +0300 (EEST)
Date:   Tue, 20 Apr 2021 12:13:09 +0300
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Bingbu Cao <bingbu.cao@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
        will@kernel.org, bhelgaas@google.com, rajatja@google.com,
        grundler@chromium.org, tfiga@chromium.org,
        senozhatsky@chromium.org, andriy.shevchenko@linux.intel.com,
        bingbu.cao@linux.intel.com
Subject: Re: [RESEND v2] iommu/vt-d: Use passthrough mode for the Intel IPUs
Message-ID: <20210420091309.GH3@paasikivi.fi.intel.com>
References: <1618886913-6594-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618886913-6594-1-git-send-email-bingbu.cao@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bingbu,

Thanks for the patch.

On Tue, Apr 20, 2021 at 10:48:33AM +0800, Bingbu Cao wrote:
> Intel IPU(Image Processing Unit) has its own (IO)MMU hardware,
> The IPU driver allocates its own page table that is not mapped
> via the DMA, and thus the Intel IOMMU driver blocks access giving
> this error:

The page table should be mapped to the possible IOMMU using the DMA API.

> 
> DMAR: DRHD: handling fault status reg 3
> DMAR: [DMA Read] Request device [00:05.0] PASID ffffffff
>       fault addr 76406000 [fault reason 06] PTE Read access is not set
> 
> As IPU is not an external facing device which is not risky, so use
> IOMMU passthrough mode for Intel IPUs.

I think a factor here is that the page tables aren't accessible by the IPU
firmware.

> 
> Fixes: 26f5689592e2 ("media: staging/intel-ipu3: mmu: Implement driver")
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> ---
>  drivers/iommu/intel/iommu.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ee0932307d64..7e2fbdae467e 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -55,6 +55,12 @@
>  #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
>  #define IS_USB_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_SERIAL_USB)
>  #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
> +#define IS_INTEL_IPU(pdev) ((pdev)->vendor == PCI_VENDOR_ID_INTEL &&	\
> +			    ((pdev)->device == 0x9a19 ||		\
> +			     (pdev)->device == 0x9a39 ||		\
> +			     (pdev)->device == 0x4e19 ||		\
> +			     (pdev)->device == 0x465d ||		\
> +			     (pdev)->device == 0x1919))
>  #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
>  
>  #define IOAPIC_RANGE_START	(0xfee00000)
> @@ -360,6 +366,7 @@ int intel_iommu_enabled = 0;
>  EXPORT_SYMBOL_GPL(intel_iommu_enabled);
>  
>  static int dmar_map_gfx = 1;
> +static int dmar_map_ipu = 1;

This works as long as there's only one IPU. Same for graphics. But I guess
this can be reworked in the future if the presumption changes.

>  static int dmar_forcedac;
>  static int intel_iommu_strict;
>  static int intel_iommu_superpage = 1;
> @@ -368,6 +375,7 @@ static int iommu_skip_te_disable;
>  
>  #define IDENTMAP_GFX		2
>  #define IDENTMAP_AZALIA		4
> +#define IDENTMAP_IPU		8
>  
>  int intel_iommu_gfx_mapped;
>  EXPORT_SYMBOL_GPL(intel_iommu_gfx_mapped);
> @@ -2839,6 +2847,9 @@ static int device_def_domain_type(struct device *dev)
>  
>  		if ((iommu_identity_mapping & IDENTMAP_GFX) && IS_GFX_DEVICE(pdev))
>  			return IOMMU_DOMAIN_IDENTITY;
> +
> +		if ((iommu_identity_mapping & IDENTMAP_IPU) && IS_INTEL_IPU(pdev))
> +			return IOMMU_DOMAIN_IDENTITY;
>  	}
>  
>  	return 0;
> @@ -3278,6 +3289,9 @@ static int __init init_dmars(void)
>  	if (!dmar_map_gfx)
>  		iommu_identity_mapping |= IDENTMAP_GFX;
>  
> +	if (!dmar_map_ipu)
> +		iommu_identity_mapping |= IDENTMAP_IPU;
> +
>  	check_tylersburg_isoch();
>  
>  	ret = si_domain_init(hw_pass_through);
> @@ -5622,6 +5636,18 @@ static void quirk_iommu_igfx(struct pci_dev *dev)
>  	dmar_map_gfx = 0;
>  }
>  
> +static void quirk_iommu_ipu(struct pci_dev *dev)
> +{
> +	if (!IS_INTEL_IPU(dev))
> +		return;
> +
> +	if (risky_device(dev))
> +		return;
> +
> +	pci_info(dev, "Passthrough IOMMU for integrated Intel IPU\n");
> +	dmar_map_ipu = 0;
> +}
> +
>  /* G4x/GM45 integrated gfx dmar support is totally busted. */
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_igfx);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_igfx);
> @@ -5657,6 +5683,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1632, quirk_iommu_igfx);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x163A, quirk_iommu_igfx);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x163D, quirk_iommu_igfx);
>  
> +/* disable IPU dmar support */
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_iommu_ipu);
> +
>  static void quirk_iommu_rwbf(struct pci_dev *dev)
>  {
>  	if (risky_device(dev))

-- 
Kind regards,

Sakari Ailus
